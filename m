Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Feb 2008 22:33:23 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m146XFoD030023
	for <xfs@oss.sgi.com>; Sun, 3 Feb 2008 22:33:17 -0800
Received: from mta5.srv.hcvlny.cv.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 71D22D7F381
	for <xfs@oss.sgi.com>; Sun,  3 Feb 2008 22:31:10 -0800 (PST)
Received: from mta5.srv.hcvlny.cv.net (mta5.srv.hcvlny.cv.net [167.206.4.200]) by cuda.sgi.com with ESMTP id FHIFYBDRX231KuEi for <xfs@oss.sgi.com>; Sun, 03 Feb 2008 22:31:10 -0800 (PST)
Received: from freyr.home (ool-44c218a8.dyn.optonline.net [68.194.24.168])
 by mta5.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0JVP005HQBFVJFW0@mta5.srv.hcvlny.cv.net> for xfs@oss.sgi.com;
 Mon, 04 Feb 2008 01:31:07 -0500 (EST)
Date: Mon, 04 Feb 2008 01:30:52 -0500 (EST)
From: jeffpc@home.josefsipek.net (Jeff)
Subject: XFS compile error
Message-id: <20080204063052.3F4E5800BA3@freyr.home>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 8BIT
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: jeffpc@josefsipek.net

Enabling CONFIG_XFS_DEBUG as well as XFS_TRANS_DEBUG (by editing the
makefile) results in a compile error:

$ make
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  CC [M]  fs/xfs/xfs_rtalloc.o
  CC [M]  fs/xfs/xfs_acl.o
  CC [M]  fs/xfs/linux-2.6/xfs_stats.o
  CC [M]  fs/xfs/linux-2.6/xfs_sysctl.o
  CC [M]  fs/xfs/xfs_alloc.o
  CC [M]  fs/xfs/xfs_alloc_btree.o
  CC [M]  fs/xfs/xfs_attr.o
  CC [M]  fs/xfs/xfs_attr_leaf.o
  CC [M]  fs/xfs/xfs_bit.o
  CC [M]  fs/xfs/xfs_bmap.o
  CC [M]  fs/xfs/xfs_bmap_btree.o
  CC [M]  fs/xfs/xfs_btree.o
  CC [M]  fs/xfs/xfs_buf_item.o
fs/xfs/xfs_buf_item.c: In function ‘xfs_buf_item_log_debug’:
fs/xfs/xfs_buf_item.c:64: error: implicit declaration of function ‘bfset’
fs/xfs/xfs_buf_item.c: In function ‘xfs_buf_item_log_check’:
fs/xfs/xfs_buf_item.c:127: error: implicit declaration of function ‘btst’
fs/xfs/xfs_buf_item.c:130: warning: format ‘%x’ expects type ‘unsigned int’, but argument 3 has type ‘struct xfs_buf_log_item_t *’
fs/xfs/xfs_buf_item.c:130: warning: format ‘%x’ expects type ‘unsigned int’, but argument 4 has type ‘struct xfs_buf_t *’
fs/xfs/xfs_buf_item.c:130: warning: format ‘%x’ expects type ‘unsigned int’, but argument 5 has type ‘char *’
make[2]: *** [fs/xfs/xfs_buf_item.o] Error 1
make[1]: *** [fs/xfs] Error 2
make: *** [fs] Error 2
