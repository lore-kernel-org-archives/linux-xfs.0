Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6FMsLn6228497 for <xfs@oss.sgi.com>; Thu, 15 Jul 2010 17:54:21 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AC65A15D6563
	for <xfs@oss.sgi.com>; Thu, 15 Jul 2010 15:57:16 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	afJGrtZ4e0vcZVOb for <xfs@oss.sgi.com>;
	Thu, 15 Jul 2010 15:57:16 -0700 (PDT)
Date: Fri, 16 Jul 2010 08:57:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: rsync and corrupt inodes (was xfs_dump problem)
Message-ID: <20100715225713.GK30737@dastard>
References: <201007152258.15631@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201007152258.15631@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Thu, Jul 15, 2010 at 10:58:15PM +0200, Michael Monnerie wrote:
> Ping?
> 
> On Montag, 5. Juli 2010 Dave Chinner wrote:
> > > So far, so good. I'm on 2.6.34 now. Is there any chance for a fixed
> > > version of xfs_repair, so that I can either get rid of the 4 broken
> > > files (i.e. delete them), or repair the filesystem? ATM, xfs_repair
> > > asserts on this filesystem.
> > 
> > What version of xfs_repair? v3.1.2 does not assert fail here on the
> > metadump image you posted, but it does take 3 runs to fix up all the
> > problems with the busted inodes....
> 
> Do you mean this one?
> http://zmi.at/saturn_bigdata.metadump.only_broken.bz2 (197 MB)

Yes, that's the one.

> I have xfs_repair 3.1.2, and made a shell script which 10x does 
> xfs_repair that image, I attached the output here. Doesn't seem to 
> repair anything, just crashing.
> 
> Maybe I did something wrong? I configured xfsprogs 3.1.2 with
> CFLAGS=-march=athlon64-sse3 ./configure --prefix=/usr
> and then 
> make;make install

Drop the CFLAGS and see what happens when you just use a generic
arch target.

> I recompiled the whole thing now with
> # gcc --version
> gcc (SUSE Linux) 4.4.1 [gcc-4_4-branch revision 150839]

$ gcc --version
gcc (Debian 4.4.4-6) 4.4.4

> and it's the same output as ever. Either you meant another metadump, or 
> there is a problem somewhere I don't see.

It's the same metadump. The repair output is identical up to phase
4. Then I note that your first run processes AGs out of order and so
detects problems in a different order to when I run locally.

> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 2
>         - agno = 1
>         - agno = 3
>         - agno = 4
>         - agno = 5
>         - agno = 6
>         - agno = 7
> data fork in inode 2195133988 claims metadata block 537122652
> xfs_repair: dinode.c:2101: process_inode_data_fork: Assertion `err == 0' failed.

This is where things go out of order. In comparison:

Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
data fork in inode 649642 claims metadata block 537266460
correcting nblocks for inode 649642, was 8928025 - counted 8388604
data fork in inode 649790 claims metadata block 537274140
bad attribute format 1 in inode 649790, resetting value
correcting nblocks for inode 649790, was 8928025 - counted 8388604
        - agno = 1
data fork in inode 2195133988 claims metadata block 537122652
bad attribute format 1 in inode 2195133988, resetting value
correcting nblocks for inode 2195133988, was 8928025 - counted 8388604
data fork in inode 2902971474 claims metadata block 537036572
correcting nblocks for inode 2902971474, was 8928025 - counted 8388604
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
....

This is not consistent, though, so it seems there is some problem where
bad attribute format is not being detected and corrected properly
for inode 2195133988. I don't see why AG processing order would
affect this.

Regardless, can you run xfs_repair -P and see if that prevents the assert
failure?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
