Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 Feb 2007 00:09:22 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l1689F3c002603
	for <xfs@oss.sgi.com>; Tue, 6 Feb 2007 00:09:17 -0800
Subject: TAKE 960196 - remove unused "firstblock" arg from xfs_bmap_finish()
Message-Id: <20070206080910.678B058FF657@chook.melbourne.sgi.com>
Date: Tue,  6 Feb 2007 19:09:10 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Remove unused argument to xfs_bmap_finish

The firstblock argument to xfs_bmap_finish is not used by
that function. Remove it and cleanup the code a bit.

Patch provided by Eric Sandeen.
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Date:  Tue Feb  6 18:59:03 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  dgc,sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28034a
fs/xfs/xfs_vnodeops.c - 1.688 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.688&r2=text&tr2=1.687&f=h
	- Remove unused firstblock argument from xfs_bmap_finish.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/xfs_rtalloc.c - 1.104 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rtalloc.c.diff?r1=text&tr1=1.104&r2=text&tr2=1.103&f=h
	- Remove unused firstblock argument from xfs_bmap_finish.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/xfs_inode.c - 1.459 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.459&r2=text&tr2=1.458&f=h
	- Remove unused firstblock argument from xfs_bmap_finish.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/xfs_bmap.h - 1.98 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.h.diff?r1=text&tr1=1.98&r2=text&tr2=1.97&f=h
	- Remove unused firstblock argument from xfs_bmap_finish.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/xfs_bmap.c - 1.362 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.362&r2=text&tr2=1.361&f=h
	- Remove unused firstblock argument from xfs_bmap_finish.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/xfs_rename.c - 1.69 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rename.c.diff?r1=text&tr1=1.69&r2=text&tr2=1.68&f=h
	- Remove unused firstblock argument from xfs_bmap_finish.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/xfs_attr.c - 1.142 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr.c.diff?r1=text&tr1=1.142&r2=text&tr2=1.141&f=h
	- Remove unused firstblock argument from xfs_bmap_finish.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/quota/xfs_dquot.c - 1.27 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot.c.diff?r1=text&tr1=1.27&r2=text&tr2=1.26&f=h
	- Remove unused firstblock argument from xfs_bmap_finish.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/xfs_iomap.c - 1.49 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iomap.c.diff?r1=text&tr1=1.49&r2=text&tr2=1.48&f=h
	- Remove unused firstblock argument from xfs_bmap_finish.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
