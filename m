Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Sep 2006 23:20:00 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k856JYDW018426
	for <linux-xfs@oss.sgi.com>; Mon, 4 Sep 2006 23:19:47 -0700
Received: from chook.melbourne.sgi.com (chook.melbourne.sgi.com [134.14.54.237]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id QAA24939 for <linux-xfs@oss.sgi.com>; Tue, 5 Sep 2006 16:18:49 +1000
Subject: TAKE 955302 - cleanup
Message-Id: <20060905061849.23D5C58CF851@chook.melbourne.sgi.com>
Date: Tue,  5 Sep 2006 16:18:49 +1000 (EST)
From: nathans@sgi.com (Nathan Scott)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Reduce endian flipping in alloc_btree, same as was done for ialloc_btree.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>


Date:  Mon Sep  4 12:07:50 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  sandeen

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26910a
xfs_alloc_btree.c - 1.90 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.c.diff?r1=text&tr1=1.90&r2=text&tr2=1.89&f=h
	- Reduce endian flipping in alloc_btree, same as was done for ialloc_btree.


standardize on one sema init macro

One sema to rule them all, one sema to find them...

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>


Date:  Mon Sep  4 14:54:30 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  sandeen

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26911a
xfs_iget.c - 1.220 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.220&r2=text&tr2=1.219&f=h
linux-2.6/sema.h - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/sema.h.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
linux-2.4/sema.h - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/sema.h.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
	- standardize on one sema init macro


Collapse sv_init and init_sv into just the one interface.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>


Date:  Tue Sep  5 16:18:33 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  sandeen

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26925a
linux-2.4/xfs_vnode.c - 1.139 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_vnode.c.diff?r1=text&tr1=1.139&r2=text&tr2=1.138&f=h
linux-2.6/sv.h - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/sv.h.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
linux-2.4/sv.h - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/sv.h.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
	- Collapse sv_init and init_sv into just the one interface.
