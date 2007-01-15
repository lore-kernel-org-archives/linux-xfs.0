Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Jan 2007 14:32:22 -0800 (PST)
Received: from bycast.com (bycast.com [209.139.229.1] (may be forged))
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0FMWHqw017458
	for <xfs@oss.sgi.com>; Mon, 15 Jan 2007 14:32:17 -0800
Received: from [192.168.110.200] (account kjamieson HELO [192.168.110.200])
  by bycast.com (CommuniGate Pro SMTP 4.3.9)
  with ESMTPA id 1472555 for xfs@oss.sgi.com; Mon, 15 Jan 2007 13:31:22 -0800
Message-ID: <45ABF2AA.2010209@bycast.com>
Date: Mon, 15 Jan 2007 13:31:22 -0800
From: Kevin Jamieson <kjamieson@bycast.com>
Reply-To: kjamieson@bycast.com
MIME-Version: 1.0
Subject: Re: Review: fix block reservation to work with per-cpu counters
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

This fails to build on non-SMP systems:

  CC [M]  fs/xfs/xfs_fsops.o
fs/xfs/xfs_fsops.c: In function 'xfs_fs_counts':
fs/xfs/xfs_fsops.c:463: warning: implicit declaration of function 'xfs_icsb_sync_counters_flags'
fs/xfs/xfs_fsops.c:463: error: 'XFS_ICSB_LAZY_COUNT' undeclared (first use in this function)
fs/xfs/xfs_fsops.c:463: error: (Each undeclared identifier is reported only once
fs/xfs/xfs_fsops.c:463: error: for each function it appears in.)
fs/xfs/xfs_fsops.c: In function 'xfs_reserve_blocks':
fs/xfs/xfs_fsops.c:525: error: 'XFS_ICSB_SB_LOCKED' undeclared (first use in this function)
make[1]: *** [fs/xfs/xfs_fsops.o] Error 1
make: *** [fs/xfs/xfs.ko] Error 2


The define for not HAVE_PERCPU_SB needs to be changed:


Index: fs/xfs/xfs_mount.h
===================================================================
RCS file: /cvs/linux-2.6-xfs/fs/xfs/xfs_mount.h,v
retrieving revision 1.232
diff -u -r1.232 xfs_mount.h
--- fs/xfs/xfs_mount.h	10 Jan 2007 14:42:52 -0000	1.232
+++ fs/xfs/xfs_mount.h	15 Jan 2007 21:13:09 -0000
@@ -311,7 +311,7 @@
 
 #else
 #define xfs_icsb_init_counters(mp)	(0)
-#define xfs_icsb_sync_counters_lazy(mp)	do { } while (0)
+#define xfs_icsb_sync_counters_flags(mp, flags)	do { } while (0)
 #endif
 
 typedef struct xfs_mount {
