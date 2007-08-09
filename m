Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Aug 2007 04:39:47 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l79Bdcbm005510
	for <xfs@oss.sgi.com>; Thu, 9 Aug 2007 04:39:41 -0700
Date: Thu, 9 Aug 2007 21:39:37 +1000
From: David Chinner <dgc@sgi.com>
Subject: [PATCH 2 of 4] Factor per-ag radix tree intialisation
Message-ID: <20070809113937.GE12413810@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Factor out common intialisation code.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/xfs_mount.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.c	2007-08-09 13:03:53.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.c	2007-08-09 13:07:53.410065825 +1000
@@ -337,6 +337,17 @@ xfs_mount_validate_sb(
 	return 0;
 }
 
+STATIC void
+xfs_initialize_perag_icache(
+	xfs_perag_t	*pag)
+{
+	if (!pag->pag_ici_init) {
+		rwlock_init(&pag->pag_ici_lock);
+		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
+		pag->pag_ici_init = 1;
+	}
+}
+
 xfs_agnumber_t
 xfs_initialize_perag(
 	bhv_vfs_t	*vfs,
@@ -391,22 +402,14 @@ xfs_initialize_perag(
 			pag->pagi_inodeok = 1;
 			if (index < max_metadata)
 				pag->pagf_metadata = 1;
-			if (!pag->pag_ici_init) {
-				rwlock_init(&pag->pag_ici_lock);
-				INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
-				pag->pag_ici_init = 1;
-			}
+			xfs_initialize_perag_icache(pag);
 		}
 	} else {
 		/* Setup default behavior for smaller filesystems */
 		for (index = 0; index < agcount; index++) {
 			pag = &mp->m_perag[index];
 			pag->pagi_inodeok = 1;
-			if (!pag->pag_ici_init) {
-				rwlock_init(&pag->pag_ici_lock);
-				INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
-				pag->pag_ici_init = 1;
-			}
+			xfs_initialize_perag_icache(pag);
 		}
 	}
 	return index;
