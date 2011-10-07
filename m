Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p97NEHmb004243 for <xfs@oss.sgi.com>; Fri, 7 Oct 2011 18:14:18 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 107211B80A7
	for <xfs@oss.sgi.com>; Fri,  7 Oct 2011 16:14:14 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	hQWEndkjZyDeckvB for <xfs@oss.sgi.com>;
	Fri, 07 Oct 2011 16:14:14 -0700 (PDT)
Date: Sat, 8 Oct 2011 10:14:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Premature "No Space left on device" on XFS
Message-ID: <20111007231410.GG3159@dastard>
References: <4E8E079B.4040103@birkenwald.de> <20111007013711.GW3159@dastard>
	<4E8F0385.7060906@birkenwald.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E8F0385.7060906@birkenwald.de>
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
To: Bernhard Schmidt <berni@birkenwald.de>
Cc: xfs@oss.sgi.com

On Fri, Oct 07, 2011 at 03:49:57PM +0200, Bernhard Schmidt wrote:
> Am 07.10.2011 03:37, schrieb Dave Chinner:
> 
> Hi,
> 
> >> this is an XFS-related summary of a problem report I sent to the
> >> postfix mailinglist a few minutes ago after a bulkmail test system
> >> blew up during a stress test.
> >>
> >> We have a few MTAs running SLES11.1 amd64 (2.6.32.45-0.3-default),
> >> 10 GB XFS Spooldirectory with default blocksize (4k). It was
> >> bombarded with mails faster than it could send them on, which
> >> eventually led to almost 2 million files of ~1.5kB in one directory.
> >> Suddenly, this started to happen
> >>
> >> lxmhs45:/var/spool/postfix-bulk/postfix-bulkinhss # touch a
> >> touch: cannot touch `a': No space left on device
> >> lxmhs45:/var/spool/postfix-bulk/postfix-bulkinhss # df .
> >> Filesystem           1K-blocks      Used Available Use% Mounted on
> >> /dev/sdb              10475520   7471160   3004360  72%
> > 
> > So you have a 10GB filesystem, with about 3GB of free space.
> > 
> >> /var/spool/postfix-bulk
> >> lxmhs45:/var/spool/postfix-bulk/postfix-bulkinhss # df -i .
> >> Filesystem            Inodes   IUsed   IFree IUse% Mounted on
> >> /dev/sdb             10485760 1742528 8743232   17% /var/spool/postfix-bulk
> > 
> > And with 1.7 million inodes in it. That's a lot for a tiny
> > filesystem, and not really a use case that XFS is well suited to.
> > XFS will work, but it won't age gracefully under these conditions...
> > 
> > As it is, your problem is most likely fragmented free space (an
> > aging problem). Inodes are allocated in chunks of 64, so require an
> > -aligned- contiguous 16k extent for the default 256 byte inode size.
> > If you have no aligned contiguous 16k extents free then inode
> > allocation will fail.
> > 
> > Running 'xfs_db -r "-c freesp -s" /dev/sdb' will give you a
> > histogram of free space extents in the filesystem, which will tell
> > us if you are hitting this problem.
> 
> I managed to create the situation again. This time the total usage is a
> bit higher, but it still failed.

No surprise. The way you are using the filesystem is pre-disposed to
this sort of problem.

> lxmhs45:~ # df /var/spool/postfix-bulk
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/sdb              10475520   8071008   2404512  78%
> /var/spool/postfix-bulk
> lxmhs45:~ # df -i /var/spool/postfix-bulk
> Filesystem            Inodes   IUsed   IFree IUse% Mounted on
> /dev/sdb             11500544 1882496 9618048   17% /var/spool/postfix-bulk
> 
> This is the output requested.
> 
> lxmhs45:~ # xfs_db -r "-c freesp -s" /dev/sdb
>    from      to extents  blocks    pct
>       1       1   32230   32230   5.36
>       2       3    6874   16476   2.74
>       4       7  138151  552604  91.90
> total free extents 177255
> total free blocks 601310
> average free extent size 3.39234

And that shows your freespace is indeed badly fragmentedi and the
cause of your problem. The majority of the free space is in 4-7
block extents which, if inode allocation is failing, are all
unaligned even though they are large enough for an inode chunk.

> lxmhs45:~ # xfs_info /dev/sdb
> meta-data=/dev/sdb               isize=256    agcount=4, agsize=655360 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=2621440, imaxpct=50
                                                                ^^^^^^^^^^

And there lies the reason you are getting the filesystem into this
situation - you're allowing a very large number of inodes to be created
in the filesystem.

I'd suggest that for your workload, you need to allow at least 10GB
of disk space per million inodes. Because of the number of small
files, XFS is going to need a much larger amount of free space
available to prevent aging related freespace fragmentation problems.
The above ratio results in a maximum space usage of about 50%, which
will avoid such issues. If you need to hold 2 million files, use a
20GB filesystem...

>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=2560, version=2
                                               ^^^^^^^^^^^^^

And you'll probably get better performance if you use a larger log
as well.

FWIW, if you have anyone with developer time available, finishing
off this work:

http://xfs.org/index.php/Unfinished_work#Inline_data_in_inodes

and using 2kB inodes (which would fit ~1900 bytes of data in line)
would solve you problem entirely and perform much, much better.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
