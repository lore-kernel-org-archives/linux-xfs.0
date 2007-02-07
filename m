Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 Feb 2007 17:19:35 -0800 (PST)
Received: from omx1.sgi.com (omx1.americas.sgi.com [198.149.16.13])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l171JR3c023704
	for <xfs@oss.sgi.com>; Tue, 6 Feb 2007 17:19:29 -0800
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by omx1.sgi.com (8.12.10/8.12.9/linux-outbound_gateway-1.1) with SMTP id l170RSDW021405
	for <xfs@oss.sgi.com>; Tue, 6 Feb 2007 18:27:29 -0600
Subject: TAKE 960197 - remove unused arguments from the XFS_BTREE_*_ADDR functions
Message-Id: <20070207002721.D9D8F58C4C27@chook.melbourne.sgi.com>
Date: Wed,  7 Feb 2007 11:27:21 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Remove unused arguments from the XFS_BTREE_*_ADDR macros.

It makes it incrementally clearer to read the code when the top of a macro
spaghetti-pile only receives the 3 arguments it uses, rather than 2 extra
ones which are not used.  Also when you start pulling this thread out of the
sweater (i.e. remove unused args from XFS_BTREE_*_ADDR), a couple other
third arms etc fall off too.  If they're not used in the macro, then they
sometimes don't need to be passed to the function calling the macro either,
etc....

Patch provided by Eric Sandeen (sandeen@sandeen.net).
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Date:  Wed Feb  7 11:26:40 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  dgc,sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28037a
fs/xfs/xfsidbg.c - 1.311 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.311&r2=text&tr2=1.310&f=h
	- Remove unused arguments from XFS_BTREE_*_ADDR macros.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/xfs_ialloc_btree.h - 1.32 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.h.diff?r1=text&tr1=1.32&r2=text&tr2=1.31&f=h
	- Remove unused arguments from XFS_BTREE_*_ADDR macros.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/xfs_bmap_btree.h - 1.75 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.h.diff?r1=text&tr1=1.75&r2=text&tr2=1.74&f=h
	- Remove unused arguments from XFS_BTREE_*_ADDR macros.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/xfs_bmap_btree.c - 1.159 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.159&r2=text&tr2=1.158&f=h
	- Remove unused arguments from XFS_BTREE_*_ADDR macros.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/xfs_btree.h - 1.65 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.65&r2=text&tr2=1.64&f=h
	- Remove unused arguments from XFS_BTREE_*_ADDR macros.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/xfs_fsops.c - 1.121 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_fsops.c.diff?r1=text&tr1=1.121&r2=text&tr2=1.120&f=h
	- Remove unused arguments from XFS_BTREE_*_ADDR macros.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/xfs_bmap.c - 1.363 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.363&r2=text&tr2=1.362&f=h
	- Remove unused arguments from XFS_BTREE_*_ADDR macros.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/xfs_alloc_btree.h - 1.30 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.h.diff?r1=text&tr1=1.30&r2=text&tr2=1.29&f=h
	- Remove unused arguments from XFS_BTREE_*_ADDR macros.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
