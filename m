Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Oct 2008 22:01:49 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9A51kQo000706
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2008 22:01:47 -0700
Subject: PARTIAL TAKE 988146 - Cleanup maxrecs calculation.
Message-Id: <20081010050319.56FBB1F08E9@chapter11.melbourne.sgi.com>
Date: Fri, 10 Oct 2008 16:03:19 +1100 (EST)
From: donaldd@sgi.com (Donald Douwsma)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Cleanup maxrecs calculation.

Clean up the way the maximum and minimum records for the btree blocks are
calculated.  For the alloc and inobt btrees all the values are pre-calculated
in xfs_mount_common, and we switch the current loop around the ugly generic
macros that use cpp token pasting to generate type names to two small helpers
in normal C code.  For the bmbt and bmdr trees these helpers also exist,
but can be called during runtime, too.  Here we also kill various macros
dealing with them and inline the logic into the get_minrecs / get_maxrecs /
get_dmaxrecs methods in xfs_bmap_btree.c.

Note that all these new helpers take an xfs_mount * argument which will
be needed to determine the size of a btree block once we add support for
extended btree blocks with CRCs and other RAS information.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Fri Oct 10 16:02:17 EST 2008
Workarea:  chapter11.melbourne.sgi.com:/scratch/donaldd/isms/2.6.x-xfs
Inspected by:  hch

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32292a
fs/xfs/xfs_ialloc_btree.h - 1.42 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.h.diff?r1=text&tr1=1.42&r2=text&tr2=1.41&f=h
	- Cleanup maxrecs calculation.

fs/xfs/xfs_ialloc_btree.c - 1.107 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.c.diff?r1=text&tr1=1.107&r2=text&tr2=1.106&f=h
	- Cleanup maxrecs calculation.

fs/xfs/xfs_log_recover.c - 1.348 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.348&r2=text&tr2=1.347&f=h
	- Cleanup maxrecs calculation.

fs/xfs/xfs_bmap_btree.h - 1.92 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.h.diff?r1=text&tr1=1.92&r2=text&tr2=1.91&f=h
	- Cleanup maxrecs calculation.

fs/xfs/xfs_bmap_btree.c - 1.196 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.196&r2=text&tr2=1.195&f=h
	- Cleanup maxrecs calculation.

fs/xfs/xfs_mount.h - 1.278 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.278&r2=text&tr2=1.277&f=h
	- Cleanup maxrecs calculation.

fs/xfs/xfs_mount.c - 1.448 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.448&r2=text&tr2=1.447&f=h
	- Cleanup maxrecs calculation.

fs/xfs/xfs_btree.h - 1.98 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.98&r2=text&tr2=1.97&f=h
	- Cleanup maxrecs calculation.

fs/xfs/xfs_inode.c - 1.527 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.527&r2=text&tr2=1.526&f=h
	- Cleanup maxrecs calculation.

fs/xfs/xfs_bmap.c - 1.412 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.412&r2=text&tr2=1.411&f=h
	- Cleanup maxrecs calculation.

fs/xfs/xfs_alloc_btree.h - 1.39 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.h.diff?r1=text&tr1=1.39&r2=text&tr2=1.38&f=h
	- Cleanup maxrecs calculation.

fs/xfs/xfs_alloc_btree.c - 1.111 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.c.diff?r1=text&tr1=1.111&r2=text&tr2=1.110&f=h
	- Cleanup maxrecs calculation.

fs/xfs/xfs_dinode.h - 1.87 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dinode.h.diff?r1=text&tr1=1.87&r2=text&tr2=1.86&f=h
	- Cleanup maxrecs calculation.
