Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Jun 2007 01:44:48 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l588ihWt020811
	for <xfs@oss.sgi.com>; Fri, 8 Jun 2007 01:44:44 -0700
Subject: TAKE 964468 - XFS can ENOSPC in bad places
Message-Id: <20070608084439.1558C58C38F3@chook.melbourne.sgi.com>
Date: Fri,  8 Jun 2007 18:44:38 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Prevent ENOSPC from aborting transactions that need to succeed

During delayed allocation extent conversion or unwritten extent
conversion, we need to reserve some blocks for transactions
reservations. We need to reserve these blocks in case a btree
split occurs and we need to allocate some blocks.

Unfortunately, we've only ever reserved the number of data blocks we
are allocating, so in both the unwritten and delalloc case we can
get ENOSPC to the transaction reservation. This is bad because in
both cases we cannot report the failure to the writing application.

The fix is two-fold:

        1 - leverage the reserved block infrastructure XFS already
        has to reserve a small pool of blocks by default to allow
        specially marked transactions to dip into when we are at
        ENOSPC.

            Default setting is min(5%, 1024 blocks).

        2 - convert critical transaction reservations to be allowed
        to dip into this pool. Spots changed are delalloc
        conversion, unwritten extent conversion and growing a
        filesystem at ENOSPC.

This also allows growing the filesytsem to succeed at ENOSPC.

Date:  Fri Jun  8 18:44:10 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  tes@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28865a
fs/xfs/xfs_mount.c - 1.397 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.397&r2=text&tr2=1.396&f=h
	- reserve a small amount of disk blocks by default to use in
	  emergency ENOSPC situations.

fs/xfs/xfs_fsops.c - 1.126 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_fsops.c.diff?r1=text&tr1=1.126&r2=text&tr2=1.125&f=h
	- Allow growfs transaction to use reserved space.

fs/xfs/xfs_iomap.c - 1.53 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iomap.c.diff?r1=text&tr1=1.53&r2=text&tr2=1.52&f=h
	- Allow unwritten extent conversion and delayed allocation tranactions
	  to use reserved space instead of silently failing at ENOSPC.
