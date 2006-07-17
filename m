Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Jul 2006 03:41:48 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6HAfHDW021644
	for <linux-xfs@oss.sgi.com>; Mon, 17 Jul 2006 03:41:29 -0700
Received: from chook.melbourne.sgi.com (chook.melbourne.sgi.com [134.14.54.237]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id UAA05087 for <linux-xfs@oss.sgi.com>; Mon, 17 Jul 2006 20:40:45 +1000
Subject: TAKE 954580 - cleanups
Message-Id: <20060717104044.E87C958C4C01@chook.melbourne.sgi.com>
Date: Mon, 17 Jul 2006 20:40:44 +1000 (EST)
From: nathans@sgi.com (Nathan Scott)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

use NULL for pointer initialisation instead of zero-cast-to-ptr


Date:  Mon Jul 17 20:31:23 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  sjv

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26562a
xfs_ialloc.c - 1.191 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc.c.diff?r1=text&tr1=1.191&r2=text&tr2=1.190&f=h
xfs_ialloc_btree.c - 1.86 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.c.diff?r1=text&tr1=1.86&r2=text&tr2=1.85&f=h
xfs_bmap_btree.c - 1.157 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.157&r2=text&tr2=1.156&f=h
xfs_alloc_btree.c - 1.89 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.c.diff?r1=text&tr1=1.89&r2=text&tr2=1.88&f=h


remove bhv_lookup, _range version works aswell and has more useful semantics.

Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Mon Jul 17 20:34:49 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  hch

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26563a
xfs_mount.h - 1.226 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.226&r2=text&tr2=1.225&f=h
xfs_behavior.c - 1.26 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_behavior.c.diff?r1=text&tr1=1.26&r2=text&tr2=1.25&f=h
xfs_behavior.h - 1.23 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_behavior.h.diff?r1=text&tr1=1.23&r2=text&tr2=1.22&f=h
linux-2.6/xfs_vnode.h - 1.125 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.125&r2=text&tr2=1.124&f=h
linux-2.4/xfs_vnode.h - 1.113 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_vnode.h.diff?r1=text&tr1=1.113&r2=text&tr2=1.112&f=h
linux-2.6/xfs_ksyms.c - 1.50 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.50&r2=text&tr2=1.49&f=h
linux-2.4/xfs_ksyms.c - 1.45 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_ksyms.c.diff?r1=text&tr1=1.45&r2=text&tr2=1.44&f=h
dmapi/xfs_dm.c - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
	- remove bhv_lookup, _range version works aswell and has more useful semantics.


remove accidentally reintroduced vfs unmount flag, unneeded in current kernels


Date:  Mon Jul 17 20:40:14 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  hch

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26564a
linux-2.6/xfs_vfs.h - 1.65 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vfs.h.diff?r1=text&tr1=1.65&r2=text&tr2=1.64&f=h
