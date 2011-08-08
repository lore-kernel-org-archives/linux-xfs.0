Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p780Tr2a000954 for <xfs@oss.sgi.com>; Sun, 7 Aug 2011 19:29:54 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E845A1EF7C70
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2011 17:29:49 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	rQykhSf1kp580kez for <xfs@oss.sgi.com>;
	Sun, 07 Aug 2011 17:29:49 -0700 (PDT)
Date: Mon, 8 Aug 2011 10:29:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair 3.1.4/3.1.5: fatal error -- couldn't malloc dir2
	buffer data
Message-ID: <20110808002946.GK3162@dastard>
References: <20110806121728.GA20341@schmorp.de> <20110806141241.GF3162@dastard>
	<20110806175428.GA1900@schmorp.de> <20110806233913.GH3162@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110806233913.GH3162@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Marc Lehmann <schmorp@schmorp.de>
Cc: xfs@oss.sgi.com

On Sun, Aug 07, 2011 at 09:39:13AM +1000, Dave Chinner wrote:
> On Sat, Aug 06, 2011 at 07:54:28PM +0200, Marc Lehmann wrote:
> > On Sun, Aug 07, 2011 at 12:12:41AM +1000, Dave Chinner <david@fromorbit.com> wrote:
> > > > this is 3.1.5 - 3.1.4 simply segfaults. using ltrace shows this as
> > > > last call to malloc:
> > > > 
> > > >    malloc(18446744073708732928)                                  = NULL
> > > > 
> > > > I think thats a bit unreasonable of xfs_repair :)
> > > 
> > > Can you share a metadump of the image in question?
> > 
> > I can, but unfortunately, it's fixed itself in the meantime:
> > 
> > I wanted to make a copy of the image, and mounted it read-write. I stat'ed
> > all files inside (which worked) and then rsynced all files out.
> > 
> > Then I unmounmted it and re-ran xfs_repair
> > (http://ue.tst.eu/3cbc07150eb6b69c63361937c6c3044f.txt) which got much
> > farther, but failed with the same error.
> 
> Looks lke corrupt directory blocks are causing it.
> 
> > Then I re-ran xfs_repair one last time, which ran through without any "error"
> > messages.
> > 
> > An xfs_metadata -o is here (gzipped):
> > http://data.plan9.de/smoker-chroot.bin.gz
> 
> I'll have a look at it.

$ sudo xfs_repair -V  -f /vm-images/busted.img 
xfs_repair version 3.1.5
$ sudo xfs_repair  -f /vm-images/busted.img 
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 11
        - agno = 1
        - agno = 3
        - agno = 2
        - agno = 4
        - agno = 10
        - agno = 7
        - agno = 5
        - agno = 6
        - agno = 8
        - agno = 9
        - agno = 12
        - agno = 13
        - agno = 15
        - agno = 14
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done
$

Yup, there's nothing wrong with the filesystem in the image you
posted.

I need an image of the broken filesystem to be able to find the bug
in xfs_repair. Next time it breaks, can you post the image of the
broken fs? i.e. run xfs_repair -n first to see if it will fail
without trying to repair the corruption it encounters, then take a
metadump before really trying to repair the problem...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
