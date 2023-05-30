Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF0B7C77B7E
	for <linux-xfs@archiver.kernel.org>; Tue, 30 May 2023 00:19:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbjE3ATg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 May 2023 20:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjE3ATf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 May 2023 20:19:35 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66312D9
        for <linux-xfs@vger.kernel.org>; Mon, 29 May 2023 17:19:33 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1b01dac1a82so19671525ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 29 May 2023 17:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1685405973; x=1687997973;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=tLE3cQknJeg+DS3kMSkZbZ75g9d3SqekIB4K/EOaGgM=;
        b=MN2cFp47hjbp3wkMzsMqPbrP7Wx7UQOnGcigCJP3S/+2F1SkP0vuxFhHDJAOUHSR55
         tm7wXkGqARPuYEqXZwEIRpYy+Rr+puiM2gTfqm6uBiE9t3QWGh/4XJnd7IYVz/muwEHe
         7l3ObPb31YqdZIN6FGVu+ikaV/zmeExPYcusdIVhM66sx21FDodwDKvRyk3/r8HeXfdb
         wiH1ETLIhr6+GAoBw90hsDaj+A+E9+nOrEXkycDiSotF7RKnm57r2W1JaxSyy3oE/VYa
         MyhbHV9UN8rP5Oc+SR64k97hkT73AeF37vSy5vygqtRFjPG0HH5x9avMNN9rZ4mTArJc
         Lv2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685405973; x=1687997973;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tLE3cQknJeg+DS3kMSkZbZ75g9d3SqekIB4K/EOaGgM=;
        b=jFvM84pP4AQsn/ePpBnt8MhCi5EEZSAMYWjU74zXElSraJaYPMsb5shyNoi8mam7DU
         yxN0ekZuwLvzZS5ATnpIiig0Wde/kfm9vU03KuZGi19lWGatKGfr8Jbrf6GsAt0chDLU
         7euyDrbtXioRowDi8Gy8Iy/WVi2KxUU0lldsV86eFwMI07XPHKC6My0HRthsIwiFugAa
         wkuZexWCbNGSUb8l733QC7vIGELegxiLRjevDsfxdgKAzWDVmt2rHaAewEMeiakKvcoY
         4P9rV6xz10POvB/p9qr6lWCZSZ+TmsUNUS2ZrXVQykuOc3OEBmngONW9joXgm/ltuWDb
         5NMg==
X-Gm-Message-State: AC+VfDx3F5NDMoM4CNkH1jIss/X2lsbhPC7SE6f51/OSo0dJqSmYKcgO
        XL0U9ir1RApwr/xoQpRq5AHru0nJRf8EavKLzcc=
X-Google-Smtp-Source: ACHHUZ45/7yetATjx0PByiVG5k+myaCdOVEFG7uJJ28qp4zR+HvJzY3ygvVJ3F3K4qqkzn7QUCHrGg==
X-Received: by 2002:a17:902:e945:b0:1af:a2a4:8386 with SMTP id b5-20020a170902e94500b001afa2a48386mr704258pll.38.1685405972732;
        Mon, 29 May 2023 17:19:32 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id e4-20020a170902d38400b001b017d0fecfsm6507784pld.293.2023.05.29.17.19.31
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 17:19:32 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1q3n5E-005Vfk-2G
        for linux-xfs@vger.kernel.org;
        Tue, 30 May 2023 10:19:28 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1q3n5E-00CRuZ-13
        for linux-xfs@vger.kernel.org;
        Tue, 30 May 2023 10:19:28 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: collect errors from inodegc for unlinked inode recovery
Date:   Tue, 30 May 2023 10:19:28 +1000
Message-Id: <20230530001928.2967218-1-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Unlinked list recovery requires errors removing the inode the from
the unlinked list get fed back to the main recovery loop. Now that
we offload the unlinking to the inodegc work, we don't get errors
being fed back when we trip over a corruption that prevents the
inode from being removed from the unlinked list.

This means we never clear the corrupt unlinked list bucket,
resulting in runtime operations eventually tripping over it and
shutting down.

Fix this by collecting inodegc worker errors and feed them
back to the flush caller. This is largely best effort - the only
context that really cares is log recovery, and it only flushes a
single inode at a time so we don't need complex synchronised
handling. Essentially the inodegc workers will capture the first
error that occurs and the next flush will gather them and clear
them. The flush itself will only report the first gathered error.

In the cases where callers can return errors, propagate the
collected inodegc flush error up the error handling chain.

In the case of inode unlinked list recovery, there are several
superfluous calls to flush queued unlinked inodes -
xlog_recover_iunlink_bucket() guarantees that it has flushed the
inodegc and collected errors before it returns. Hence nothing in the
calling path needs to run a flush, even when an error is returned.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c      | 46 ++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_icache.h      |  4 ++--
 fs/xfs/xfs_inode.c       | 18 +++++-----------
 fs/xfs/xfs_inode.h       |  2 +-
 fs/xfs/xfs_log_recover.c | 19 ++++++++---------
 fs/xfs/xfs_mount.h       |  1 +
 fs/xfs/xfs_super.c       |  1 +
 fs/xfs/xfs_trans.c       |  4 +++-
 8 files changed, 59 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 0f60e301eb1f..453890942d9f 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -454,6 +454,27 @@ xfs_inodegc_queue_all(
 	return ret;
 }
 
+/* Wait for all queued work and collect errors */
+static int
+xfs_inodegc_wait_all(
+	struct xfs_mount	*mp)
+{
+	int			cpu;
+	int			error = 0;
+
+	flush_workqueue(mp->m_inodegc_wq);
+	for_each_online_cpu(cpu) {
+		struct xfs_inodegc	*gc;
+
+		gc = per_cpu_ptr(mp->m_inodegc, cpu);
+		if (gc->error && !error)
+			error = gc->error;
+		gc->error = 0;
+	}
+
+	return error;
+}
+
 /*
  * Check the validity of the inode we just found it the cache
  */
@@ -1491,15 +1512,14 @@ xfs_blockgc_free_space(
 	if (error)
 		return error;
 
-	xfs_inodegc_flush(mp);
-	return 0;
+	return xfs_inodegc_flush(mp);
 }
 
 /*
  * Reclaim all the free space that we can by scheduling the background blockgc
  * and inodegc workers immediately and waiting for them all to clear.
  */
-void
+int
 xfs_blockgc_flush_all(
 	struct xfs_mount	*mp)
 {
@@ -1520,7 +1540,7 @@ xfs_blockgc_flush_all(
 	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCKGC_TAG)
 		flush_delayed_work(&pag->pag_blockgc_work);
 
-	xfs_inodegc_flush(mp);
+	return xfs_inodegc_flush(mp);
 }
 
 /*
@@ -1842,13 +1862,17 @@ xfs_inodegc_set_reclaimable(
  * This is the last chance to make changes to an otherwise unreferenced file
  * before incore reclamation happens.
  */
-static void
+static int
 xfs_inodegc_inactivate(
 	struct xfs_inode	*ip)
 {
+	int			error;
+
 	trace_xfs_inode_inactivating(ip);
-	xfs_inactive(ip);
+	error = xfs_inactive(ip);
 	xfs_inodegc_set_reclaimable(ip);
+	return error;
+
 }
 
 void
@@ -1880,8 +1904,12 @@ xfs_inodegc_worker(
 
 	WRITE_ONCE(gc->shrinker_hits, 0);
 	llist_for_each_entry_safe(ip, n, node, i_gclist) {
+		int	error;
+
 		xfs_iflags_set(ip, XFS_INACTIVATING);
-		xfs_inodegc_inactivate(ip);
+		error = xfs_inodegc_inactivate(ip);
+		if (error && !gc->error)
+			gc->error = error;
 	}
 
 	memalloc_nofs_restore(nofs_flag);
@@ -1905,13 +1933,13 @@ xfs_inodegc_push(
  * Force all currently queued inode inactivation work to run immediately and
  * wait for the work to finish.
  */
-void
+int
 xfs_inodegc_flush(
 	struct xfs_mount	*mp)
 {
 	xfs_inodegc_push(mp);
 	trace_xfs_inodegc_flush(mp, __return_address);
-	flush_workqueue(mp->m_inodegc_wq);
+	return xfs_inodegc_wait_all(mp);
 }
 
 /*
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 87910191a9dd..1dcdcb23796e 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -62,7 +62,7 @@ int xfs_blockgc_free_dquots(struct xfs_mount *mp, struct xfs_dquot *udqp,
 		unsigned int iwalk_flags);
 int xfs_blockgc_free_quota(struct xfs_inode *ip, unsigned int iwalk_flags);
 int xfs_blockgc_free_space(struct xfs_mount *mp, struct xfs_icwalk *icm);
-void xfs_blockgc_flush_all(struct xfs_mount *mp);
+int xfs_blockgc_flush_all(struct xfs_mount *mp);
 
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
@@ -80,7 +80,7 @@ void xfs_blockgc_start(struct xfs_mount *mp);
 
 void xfs_inodegc_worker(struct work_struct *work);
 void xfs_inodegc_push(struct xfs_mount *mp);
-void xfs_inodegc_flush(struct xfs_mount *mp);
+int xfs_inodegc_flush(struct xfs_mount *mp);
 void xfs_inodegc_stop(struct xfs_mount *mp);
 void xfs_inodegc_start(struct xfs_mount *mp);
 void xfs_inodegc_cpu_dead(struct xfs_mount *mp, unsigned int cpu);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5808abab786c..c0d0466f3270 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1620,16 +1620,7 @@ xfs_inactive_ifree(
 	 */
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_ICOUNT, -1);
 
-	/*
-	 * Just ignore errors at this point.  There is nothing we can do except
-	 * to try to keep going. Make sure it's not a silent error.
-	 */
-	error = xfs_trans_commit(tp);
-	if (error)
-		xfs_notice(mp, "%s: xfs_trans_commit returned error %d",
-			__func__, error);
-
-	return 0;
+	return xfs_trans_commit(tp);
 }
 
 /*
@@ -1693,7 +1684,7 @@ xfs_inode_needs_inactive(
  * now be truncated.  Also, we clear all of the read-ahead state
  * kept for the inode here since the file is now closed.
  */
-void
+int
 xfs_inactive(
 	xfs_inode_t	*ip)
 {
@@ -1736,7 +1727,7 @@ xfs_inactive(
 		 * reference to the inode at this point anyways.
 		 */
 		if (xfs_can_free_eofblocks(ip, true))
-			xfs_free_eofblocks(ip);
+			error = xfs_free_eofblocks(ip);
 
 		goto out;
 	}
@@ -1773,7 +1764,7 @@ xfs_inactive(
 	/*
 	 * Free the inode.
 	 */
-	xfs_inactive_ifree(ip);
+	error = xfs_inactive_ifree(ip);
 
 out:
 	/*
@@ -1781,6 +1772,7 @@ xfs_inactive(
 	 * the attached dquots.
 	 */
 	xfs_qm_dqdetach(ip);
+	return error;
 }
 
 /*
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 69d21e42c10a..7547caf2f2ab 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -470,7 +470,7 @@ enum layout_break_reason {
 	(xfs_has_grpid((pip)->i_mount) || (VFS_I(pip)->i_mode & S_ISGID))
 
 int		xfs_release(struct xfs_inode *ip);
-void		xfs_inactive(struct xfs_inode *ip);
+int		xfs_inactive(struct xfs_inode *ip);
 int		xfs_lookup(struct xfs_inode *dp, const struct xfs_name *name,
 			   struct xfs_inode **ipp, struct xfs_name *ci_name);
 int		xfs_create(struct mnt_idmap *idmap,
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 322eb2ee6c55..82c81d20459d 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2711,7 +2711,9 @@ xlog_recover_iunlink_bucket(
 			 * just to flush the inodegc queue and wait for it to
 			 * complete.
 			 */
-			xfs_inodegc_flush(mp);
+			error = xfs_inodegc_flush(mp);
+			if (error)
+				break;
 		}
 
 		prev_agino = agino;
@@ -2719,10 +2721,15 @@ xlog_recover_iunlink_bucket(
 	}
 
 	if (prev_ip) {
+		int	error2;
+
 		ip->i_prev_unlinked = prev_agino;
 		xfs_irele(prev_ip);
+
+		error2 = xfs_inodegc_flush(mp);
+		if (error2 && !error)
+			return error2;
 	}
-	xfs_inodegc_flush(mp);
 	return error;
 }
 
@@ -2789,7 +2796,6 @@ xlog_recover_iunlink_ag(
 			 * bucket and remaining inodes on it unreferenced and
 			 * unfreeable.
 			 */
-			xfs_inodegc_flush(pag->pag_mount);
 			xlog_recover_clear_agi_bucket(pag, bucket);
 		}
 	}
@@ -2806,13 +2812,6 @@ xlog_recover_process_iunlinks(
 
 	for_each_perag(log->l_mp, agno, pag)
 		xlog_recover_iunlink_ag(pag);
-
-	/*
-	 * Flush the pending unlinked inodes to ensure that the inactivations
-	 * are fully completed on disk and the incore inodes can be reclaimed
-	 * before we signal that recovery is complete.
-	 */
-	xfs_inodegc_flush(log->l_mp);
 }
 
 STATIC void
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index aaaf5ec13492..6c09f89534d3 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -62,6 +62,7 @@ struct xfs_error_cfg {
 struct xfs_inodegc {
 	struct llist_head	list;
 	struct delayed_work	work;
+	int			error;
 
 	/* approximate count of inodes in the list */
 	unsigned int		items;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 7e706255f165..4120bd1cba90 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1100,6 +1100,7 @@ xfs_inodegc_init_percpu(
 #endif
 		init_llist_head(&gc->list);
 		gc->items = 0;
+		gc->error = 0;
 		INIT_DELAYED_WORK(&gc->work, xfs_inodegc_worker);
 	}
 	return 0;
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index f81fbf081b01..8c0bfc9a33b1 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -290,7 +290,9 @@ xfs_trans_alloc(
 		 * Do not perform a synchronous scan because callers can hold
 		 * other locks.
 		 */
-		xfs_blockgc_flush_all(mp);
+		error = xfs_blockgc_flush_all(mp);
+		if (error)
+			return error;
 		want_retry = false;
 		goto retry;
 	}
-- 
2.40.1

