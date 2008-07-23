Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 00:23:18 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6N7NDxW009272
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 00:23:15 -0700
Subject: TAKE 981498 - Use KM_NOFS for incore inode extent tree allocation V2
Message-Id: <20080723072419.0F55858C4C3F@chook.melbourne.sgi.com>
Date: Wed, 23 Jul 2008 17:24:18 +1000 (EST)
From: xaiki@sgi.com (Niv Sardi-Altivanik)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Use KM_NOFS for incore inode extent tree allocation V2

If we allow incore extent tree allocations to recurse into the
filesystem under memory pressure, new delayed allocations through
xfs_iomap_write_delay() can deadlock on themselves if memory reclaim
tries to write back dirty pages from that inode.

It will deadlock in xfs_iomap_write_allocate() trying to take the
ilock we already hold. This can also show up as complex ABBA
deadlocks when multiple threads are triggering memory reclaim when
trying to allocate extents.

The main cause of this is the fact that delayed allocation is
not done in a transaction, so KM_NOFS is not automatically
added to the allocations to prevent this recursion.

Mark all allocations done for the incore inode extent tree as
KM_NOFS to ensure they never recurse back into the filesystem.

Version 2:
o KM_NOFS implies KM_SLEEP, so just use KM_NOFS

Signed-off-by: Dave Chinner <david@fromorbit.com>


Date:  Wed Jul 23 17:22:16 AEST 2008
Workarea:  itchy.melbourne.sgi.com:/i386/home/xaiki/Wrk/ptools/xfs-2.6
Inspected by:  dgc,hch,lachlan,xaiki

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31726a
fs/xfs/xfs_inode.c - 1.509 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.509&r2=text&tr2=1.508&f=h
