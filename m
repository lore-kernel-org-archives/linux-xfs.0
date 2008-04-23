Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Apr 2008 20:52:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3N3qCK9015343
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2008 20:52:14 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 567DFA9B974
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2008 20:52:50 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 1L0R1Fp8qO4TkKHy for <xfs@oss.sgi.com>; Tue, 22 Apr 2008 20:52:50 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id C164A18004B68
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2008 22:52:49 -0500 (CDT)
Message-ID: <480EB291.5030205@sandeen.net>
Date: Tue, 22 Apr 2008 22:52:49 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] fix non-smp xfs build
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

xfs_reserve_blocks() calls xfs_icsb_sync_counters_locked(),
which is not defined if !CONFIG_SMP/!HAVE_PERCPU_SB

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h
+++ linux-2.6-xfs/fs/xfs/xfs_mount.h
@@ -217,6 +217,7 @@ extern void	xfs_icsb_sync_counters_locke
 #define xfs_icsb_init_counters(mp)	(0)
 #define xfs_icsb_reinit_counters(mp)	do { } while (0)
 #define xfs_icsb_sync_counters(mp, flags)	do { } while (0)
+#define xfs_icsb_sync_counters_locked(mp, flags) do { } while (0)
 #endif
 
 typedef struct xfs_ail {
