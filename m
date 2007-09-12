Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Sep 2007 19:07:30 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8C27O4p002953
	for <xfs@oss.sgi.com>; Tue, 11 Sep 2007 19:07:25 -0700
Message-ID: <46E749DD.8010200@sandeen.net>
Date: Tue, 11 Sep 2007 21:07:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH SERIES] untangle spinlock macros
References: <46E6221E.803@sandeen.net> <46E7460D.3000502@sgi.com>
In-Reply-To: <46E7460D.3000502@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Donald Douwsma <donaldd@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Donald Douwsma wrote:

>   
> So the only things left in spin.h are the spinlock headers and
>
>   #define spinlock_init(lock, name)      spin_lock_init(lock)
>   #define        spinlock_destroy(lock)
>
> I cant se why we need these abstractions. Should we nuke the whole file and
> add the spinlock headers elsewhere?
>
> Don
>
>   
Ok, if you want it :)

-------------------------

remove abstraction macros in spin.h, remove the callers, and 
remove the file.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/spin.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/spin.h
+++ /dev/null
@@ -1,27 +0,0 @@
-/*
- * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_SUPPORT_SPIN_H__
-#define __XFS_SUPPORT_SPIN_H__
-
-#include <linux/sched.h>	/* preempt needs this */
-#include <linux/spinlock.h>
-
-#define spinlock_init(lock, name)	spin_lock_init(lock)
-#define	spinlock_destroy(lock)
-
-#endif /* __XFS_SUPPORT_SPIN_H__ */
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_buf.c
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.c
@@ -1568,7 +1568,7 @@ xfs_alloc_delwrite_queue(
 
 	INIT_LIST_HEAD(&btp->bt_list);
 	INIT_LIST_HEAD(&btp->bt_delwrite_queue);
-	spinlock_init(&btp->bt_delwrite_lock, "delwri_lock");
+	spin_lock_init(&btp->bt_delwrite_lock);
 	btp->bt_flags = 0;
 	btp->bt_task = kthread_run(xfsbufd, btp, "xfsbufd");
 	if (IS_ERR(btp->bt_task)) {
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_linux.h
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_linux.h
@@ -43,7 +43,6 @@
 
 #include <kmem.h>
 #include <mrlock.h>
-#include <spin.h>
 #include <sv.h>
 #include <mutex.h>
 #include <sema.h>
@@ -75,6 +74,7 @@
 #include <linux/notifier.h>
 #include <linux/delay.h>
 #include <linux/log2.h>
+#include <linux/spinlock.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>
Index: linux-2.6-xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_qm.c
+++ linux-2.6-xfs/fs/xfs/quota/xfs_qm.c
@@ -1131,7 +1131,7 @@ xfs_qm_init_quotainfo(
 		return error;
 	}
 
-	spinlock_init(&qinf->qi_pinlock, "xfs_qinf_pin");
+	spin_lock_init(&qinf->qi_pinlock);
 	xfs_qm_list_init(&qinf->qi_dqlist, "mpdqlist", 0);
 	qinf->qi_dqreclaims = 0;
 
@@ -1228,7 +1228,6 @@ xfs_qm_destroy_quotainfo(
 	 */
 	xfs_qm_rele_quotafs_ref(mp);
 
-	spinlock_destroy(&qi->qi_pinlock);
 	xfs_qm_list_destroy(&qi->qi_dqlist);
 
 	if (qi->qi_uquotaip) {
Index: linux-2.6-xfs/fs/xfs/support/debug.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/support/debug.c
+++ linux-2.6-xfs/fs/xfs/support/debug.c
@@ -17,7 +17,6 @@
  */
 #include <xfs.h>
 #include "debug.h"
-#include "spin.h"
 
 static char		message[1024];	/* keep it off the stack */
 static DEFINE_SPINLOCK(xfs_err_lock);
Index: linux-2.6-xfs/fs/xfs/support/ktrace.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/support/ktrace.h
+++ linux-2.6-xfs/fs/xfs/support/ktrace.h
@@ -18,8 +18,6 @@
 #ifndef __XFS_SUPPORT_KTRACE_H__
 #define __XFS_SUPPORT_KTRACE_H__
 
-#include <spin.h>
-
 /*
  * Trace buffer entry structure.
  */
Index: linux-2.6-xfs/fs/xfs/xfs_alloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc.c
+++ linux-2.6-xfs/fs/xfs/xfs_alloc.c
@@ -2206,7 +2206,7 @@ xfs_alloc_read_agf(
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]);
 		pag->pagf_levels[XFS_BTNUM_CNTi] =
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
-		spinlock_init(&pag->pagb_lock, "xfspagb");
+		spin_lock_init(&pag->pagb_lock);
 		pag->pagb_list = kmem_zalloc(XFS_PAGB_NUM_SLOTS *
 					sizeof(xfs_perag_busy_t), KM_SLEEP);
 		pag->pagf_init = 1;
Index: linux-2.6-xfs/fs/xfs/xfs_log.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log.c
+++ linux-2.6-xfs/fs/xfs/xfs_log.c
@@ -1189,8 +1189,8 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
 	log->l_xbuf = bp;
 
-	spinlock_init(&log->l_icloglock, "iclog");
-	spinlock_init(&log->l_grant_lock, "grhead_iclog");
+	spin_lock_init(&log->l_icloglock);
+	spin_lock_init(&log->l_grant_lock);
 	initnsema(&log->l_flushsema, 0, "ic-flush");
 	xlog_state_ticket_alloc(log);  /* wait until after icloglock inited */
 
@@ -1543,8 +1543,6 @@ xlog_dealloc_log(xlog_t *log)
 		iclog = next_iclog;
 	}
 	freesema(&log->l_flushsema);
-	spinlock_destroy(&log->l_icloglock);
-	spinlock_destroy(&log->l_grant_lock);
 
 	/* XXXsup take a look at this again. */
 	if ((log->l_ticket_cnt != log->l_ticket_tcnt)  &&
Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c
+++ linux-2.6-xfs/fs/xfs/xfs_mount.c
@@ -136,8 +136,8 @@ xfs_mount_init(void)
 		mp->m_flags |= XFS_MOUNT_NO_PERCPU_SB;
 	}
 
-	spinlock_init(&mp->m_ail_lock, "xfs_ail");
-	spinlock_init(&mp->m_sb_lock, "xfs_sb");
+	spin_lock_init(&mp->m_ail_lock);
+	spin_lock_init(&mp->m_sb_lock);
 	mutex_init(&mp->m_ilock);
 	mutex_init(&mp->m_growlock);
 	/*
@@ -171,8 +171,6 @@ xfs_mount_free(
 			  sizeof(xfs_perag_t) * mp->m_sb.sb_agcount);
 	}
 
-	spinlock_destroy(&mp->m_ail_lock);
-	spinlock_destroy(&mp->m_sb_lock);
 	mutex_destroy(&mp->m_ilock);
 	mutex_destroy(&mp->m_growlock);
 	if (mp->m_quotainfo)
@@ -616,7 +614,7 @@ xfs_mount_common(xfs_mount_t *mp, xfs_sb
 	int	i;
 
 	mp->m_agfrotor = mp->m_agirotor = 0;
-	spinlock_init(&mp->m_agirotor_lock, "m_agirotor_lock");
+	spin_lock_init(&mp->m_agirotor_lock);
 	mp->m_maxagi = mp->m_sb.sb_agcount;
 	mp->m_blkbit_log = sbp->sb_blocklog + XFS_NBBYLOG;
 	mp->m_blkbb_log = sbp->sb_blocklog - BBSHIFT;
Index: linux-2.6-xfs/fs/xfs/xfs_mru_cache.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mru_cache.c
+++ linux-2.6-xfs/fs/xfs/xfs_mru_cache.c
@@ -368,7 +368,7 @@ xfs_mru_cache_create(
 	 */
 	INIT_RADIX_TREE(&mru->store, GFP_ATOMIC);
 	INIT_LIST_HEAD(&mru->reap_list);
-	spinlock_init(&mru->lock, "xfs_mru_cache");
+	spin_lock_init(&mru->lock);
 	INIT_DELAYED_WORK(&mru->work, _xfs_mru_cache_reap);
 
 	mru->grp_time  = grp_time;
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.c
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.c
@@ -68,7 +68,7 @@ xfs_init(void)
 	extern kmem_zone_t	*xfs_dabuf_zone;
 #ifdef XFS_DABUF_DEBUG
 	extern spinlock_t        xfs_dabuf_global_lock;
-	spinlock_init(&xfs_dabuf_global_lock, "xfsda");
+	spin_lock_init(&xfs_dabuf_global_lock);
 #endif
 
 	/*
