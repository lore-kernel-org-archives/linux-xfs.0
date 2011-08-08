Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p78HnIB4046154 for <xfs@oss.sgi.com>; Mon, 8 Aug 2011 12:49:19 -0500
Received: from mail.nethype.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BE65BC6242
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2011 10:49:15 -0700 (PDT)
Received: from mail.nethype.de (mail.nethype.de [78.47.73.129]) by
	cuda.sgi.com with ESMTP id 1rsTrIe8s9APhPYS for
	<xfs@oss.sgi.com>; Mon, 08 Aug 2011 10:49:15 -0700 (PDT)
Date: Mon, 8 Aug 2011 19:49:11 +0200
From: Marc Lehmann <schmorp@schmorp.de>
Subject: Re: xfs_repair 3.1.4/3.1.5: fatal error -- couldn't malloc dir2
	buffer data
Message-ID: <20110808174911.GA7087@schmorp.de>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sun, Aug 07, 2011 at 09:39:13AM +1000, Dave Chinner <david@fromorbit.com> wrote:
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

I had another lockup, no xfs_fsr involved this time.

After rebooting, xfs_repair on the filesystem I mkfs'ed yesterday had the
same problem, here is the metadump:

   http://data.plan9.de/metadump-smoker-new.gz
   
(if it's not accessible right now then this is because thats the server
that locked up, it should be up and running in an hour again).

And here is the output of xfs_repair:

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

   fatal error -- couldn't malloc dir2 buffer data

-- 
                The choice of a       Deliantra, the free code+content MORPG
      -----==-     _GNU_              http://www.deliantra.net
      ----==-- _       generation
      ---==---(_)__  __ ____  __      Marc Lehmann
      --==---/ / _ \/ // /\ \/ /      schmorp@schmorp.de
      -=====/_/_//_/\_,_/ /_/\_\

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
