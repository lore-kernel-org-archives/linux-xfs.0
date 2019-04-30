Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:41780 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfD3RlA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Apr 2019 13:41:00 -0400
Date: Tue, 30 Apr 2019 10:40:42 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfs: Assertion failed in xfs_ag_resv_init()
Message-ID: <20190430174042.GH5207@magnolia>
References: <20190430121420.GW2780@tuebingen.mpg.de>
 <20190430151151.GF5207@magnolia>
 <20190430162506.GZ2780@tuebingen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190430162506.GZ2780@tuebingen.mpg.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andre Noll <maan@tuebingen.mpg.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Apr 30, 2019 at 06:25:06PM +0200, Andre Noll wrote:
> On Tue, Apr 30, 08:11, Darrick J. Wong wrote
> > > To see why the assertion triggers, I added
> > > 
> > >         xfs_warn(NULL, "a: %u", xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved);
> > >         xfs_warn(NULL, "b: %u", xfs_perag_resv(pag, XFS_AG_RESV_AGFL)->ar_reserved);
> > >         xfs_warn(NULL, "c: %u", pag->pagf_freeblks);
> > >         xfs_warn(NULL, "d: %u", pag->pagf_flcount);
> > > 
> > > right before the ASSERT() in xfs_ag_resv.c. Looks like
> > > pag->pagf_freeblks is way too small:
> > > 
> > > [  149.777035] XFS: a: 267367
> > > [  149.777036] XFS: b: 0
> > > [  149.777036] XFS: c: 6388
> > > [  149.777037] XFS: d: 4
> > > 
> > > Fortunately, this is new hardware which is not yet in production use,
> > > and the filesystem in question only contains a few dummy files. So
> > > I can test patches.
> > 
> > The assert (and your very helpful debugging xfs_warns) indicate that for
> > the kernel was trying to reserve 267,367 blocks to guarantee space for
> > metadata btrees in an allocation group (AG) that has only 6,392 blocks
> > remaining.
> > 
> > This per-AG block reservation exists to avoid running out of space for
> > metadata in worst case situations (needing space midway through a
> > transaction on a nearly full fs).  The assert your machine hit is a
> > debugging warning to alert developers to the per-AG block reservation
> > system deciding that it won't be able to handle all cases.
> 
> So, consider yourself alerted :)
> 
> > Hmmm, what features does this filesystem have enabled?
> 
> With CONFIG_XFS_DEBUG=n the mount succeeded, and xfs_info says
> 
> 	meta-data=/dev/mapper/zeal-tst   isize=512    agcount=101, agsize=268435392 blks
> 		 =                       sectsz=4096  attr=2, projid32bit=1
> 		 =                       crc=1        finobt=1 spinodes=0 rmapbt=0
> 		 =                       reflink=0
> 	data     =                       bsize=4096   blocks=26843545600, imaxpct=1

Oh, wait, you have a 100T filesystem with a runt AG at the end due to
the raid striping...

26843545600 % 268435392 == 6400 blocks (in AG 100)

And that's why there's 6,392 free blocks in an AG and an attempted
reservation of 267,367 blocks.

Sorry, I misunderstood and thought this was a new-ish but nearly full
filesystem, not a completely new filesystem.

In that case, the patch you want is c08768977b9 ("xfs: finobt AG
reserves don't consider last AG can be a runt") which has not been
backported to 4.9.  That patch relies on a function introduced in
21ec54168b36 ("xfs: create block pointer check functions") and moved to
a different file in 86210fbebae6e ("xfs: move various type verifiers to
common file").

The c087 patch which will generate appropriately sized reservations for
the last AG if it is significantly smaller than the the other and should
fix the assertion failure.

--D

> 		 =                       sunit=64     swidth=1024 blks
> 	naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> 	log      =internal               bsize=4096   blocks=521728, version=2
> 		 =                       sectsz=4096  sunit=1 blks, lazy-count=1
> 	realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> > Given that XFS_AG_RESV_METADATA > 0 and there's no warning about the
> > experimental reflink feature, that implies that the free inode btree
> > (finobt) feature is enabled?
> 
> yep: no reflink, but finobt.
> 
> > The awkward thing about the finobt reservation is that it was added long
> > after the finobt feature was enabled, to fix a corner case in that code.
> > If you're coming from an older kernel, there might not be enough free
> > space in the AG to guarantee space for the finobt.
> 
> No, this machine and its storage is new, and never ran a kernel other
> than 4.9.x. The filesystem was created with mkfs.xfs of xfsprogs
> version 4.9.0+nmu1ubuntu2, which ships with Ubuntu-18.04.
> 
> Isn't it surprising to run into ENOSPC on an almost empty 100T
> large filesystem? If so, do you think the issue could be related to
> dm-thin? Another explanation would be that the assert condition is
> broken, for example because pag->pagf_freeblks is not uptodate.
> 
> > In any case, if you're /not/ trying to debug the XFS code itself, you
> > could set CONFIG_XFS_DEBUG=n to turn off all the programmer debugging
> > pieces (which will improve fs performance substantially).
> > 
> > If you want all the verbose debugging checks without the kernel hang
> > behavior you could set CONFIG_XFS_DEBUG=n and CONFIG_XFS_WARN=y.
> 
> Sure, debugging will be turned off when the machine goes into production
> mode. For stress testing new hardware I prefer to leave it on, though.
> 
> Anyways, do you believe that the assert is just an overzealous check
> to inform developers about a corner case that never triggers under
> normal circumstances, or is this an issue that will come back to hurt
> plenty when the assert is ignored due to CONFIG_XFS_DEBUG=n?
> 
> One more data point: After booting into a CONFIG_XFS_DEBUG=n kernel,
> mounting and unmounting the filesystem, and booting back into the
> CONFIG_XFS_DEBUG=y kernel, the assert still triggers.
> 
> Thanks for your help
> Andre
> -- 
> Max Planck Institute for Developmental Biology
> Max-Planck-Ring 5, 72076 Tübingen, Germany. Phone: (+49) 7071 601 829
> http://people.tuebingen.mpg.de/maan/
