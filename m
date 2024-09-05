Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C766814F125
	for <linux-xfs@vger.kernel.org>; Thu,  5 Sep 2024 18:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725560528; cv=none; b=E3yM/YY2p5UvmCYALBWbZPlTPJ7wtAAfkvHrjxnU7LmNnWZTKKPCzktg7Pc22Y83z5bZs2V+SMEFyRSrSUOPiaEdizAGPkS5T13XwNatujOWoDzMr1Zrgxyk0SA5aJE6FKp2IjbptSW9ss3butoj7mM7hyRLjNwcuQ30wMyau2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725560528; c=relaxed/simple;
	bh=BbFnDJSkUm3Sdb4VroXXYAhanjg3vkqsQhVamSt+P7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oaVUX4nMSDivC+9i5xJukKz9AWLk1fmSNnU/qf3MoAiA51a64E66Qd2DtOqQW2HmktkJGsoU88UJ4inAVVWnmvKPN1JuFrKnKOlbnD4SC7JcfxVSVvhyca27QMzs1QRmhQBZLBDMr2DqWnCaiIrWUWz8IR+yu2NMdEUGgWh5OBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hsQ/EMVp; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hsQ/EMVp"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2068a7c9286so10968655ad.1
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2024 11:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725560526; x=1726165326; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pl22X2afz+QBVCMFxTlTVdU7L2XLQCrOsSnRWzmnJn8=;
        b=hsQ/EMVpA590g0LH90PCC1zAysZUioLrUBHCGcEHXVQFGM6pACEZogHPO6wOtqi5UP
         C2RD2JqnRuwFzga4MJ/fyicd7UCA7qVp6FhLN0LwuGOoYHGhZIunyVl1kGO8gUpS6pca
         K9p5IdjFV4riTo7ksthdhsingRWpzamH1b1iZj6F7l0iexmScmg/d++jQggbG9N0U/BU
         6Z5q0nzpFOcdP34lWoUmMlng0EnBZKztiIFpOI1/tdsq0i945jknGtzckMML/33H61YF
         YEA3zhX45LlPnJM49j4dBYGXft6+rDTIrmOpE2DEnHK9Ss1InbBtc0sdWLw6uSBH23aP
         SEIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725560526; x=1726165326;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pl22X2afz+QBVCMFxTlTVdU7L2XLQCrOsSnRWzmnJn8=;
        b=CBJAakQZf91n/nMSUwTjQ3m5FJz1TJvLTFBt+t1mwQyk7mwM6tRY9Rt2/ZHZaSGkpv
         GCUIXTdW2zxGFCrpvZElEa1BmpVKtdVDmZtOU4KFxE2QC4baq7JLPAkrsY+FmgzCrkKd
         rx7MaHsyxBUdZamH0k0whwcSfs1w3ThRib1It/P/c6xsERYS8PK8Rt8JK7tZcGYlLRVp
         t82pA2EnezXWZWRj5xRV396F1Gsy19AzPn24zh8RisYGWBtCzNdUL4lmFyHzOQlxHtT8
         YSfW5Xd3V4Va2UNcIoCnAO7QDWuKwSONTaKUBqnydSTrqNNGhYSd9MsvRSui5qIyRR35
         hSug==
X-Gm-Message-State: AOJu0Yx6tLPcgfr6o86cMdIQmvs+8V2TgYeKxmC4tAXi3pMwc1AXDQj+
	N489UQBym+iXimivm9vN2M9ao2YElAoC+IWrZXe1PqJS1O9DxugQoVDud6Gv
X-Google-Smtp-Source: AGHT+IFyZsgZA52vmjhRYX23VY5eQdGjFmYgDoxDrWg9v/CcbArTzDLRsudXe5cuECkkq614xfv6Tg==
X-Received: by 2002:a17:902:d48a:b0:205:73ac:98d9 with SMTP id d9443c01a7336-205841b9fa7mr135970595ad.31.1725560525960;
        Thu, 05 Sep 2024 11:22:05 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2da2:d734:ef56:7ccf])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea684f0sm31374395ad.271.2024.09.05.11.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 11:22:05 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 14/26] xfs: collect errors from inodegc for unlinked inode recovery
Date: Thu,  5 Sep 2024 11:21:31 -0700
Message-ID: <20240905182144.2691920-15-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240905182144.2691920-1-leah.rumancik@gmail.com>
References: <20240905182144.2691920-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit d4d12c02bf5f768f1b423c7ae2909c5afdfe0d5f ]

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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_icache.c      | 46 ++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_icache.h      |  4 ++--
 fs/xfs/xfs_inode.c       | 20 ++++++-----------
 fs/xfs/xfs_inode.h       |  2 +-
 fs/xfs/xfs_log_recover.c | 19 ++++++++---------
 fs/xfs/xfs_mount.h       |  1 +
 fs/xfs/xfs_super.c       |  1 +
 fs/xfs/xfs_trans.c       |  4 +++-
 8 files changed, 60 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index f5568fa54039..4b040740678c 100644
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
@@ -1490,15 +1511,14 @@ xfs_blockgc_free_space(
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
@@ -1519,7 +1539,7 @@ xfs_blockgc_flush_all(
 	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCKGC_TAG)
 		flush_delayed_work(&pag->pag_blockgc_work);
 
-	xfs_inodegc_flush(mp);
+	return xfs_inodegc_flush(mp);
 }
 
 /*
@@ -1841,13 +1861,17 @@ xfs_inodegc_set_reclaimable(
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
@@ -1879,8 +1903,12 @@ xfs_inodegc_worker(
 
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
@@ -1904,13 +1932,13 @@ xfs_inodegc_push(
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
index 6cd180721659..da58984b80d2 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -59,7 +59,7 @@ int xfs_blockgc_free_dquots(struct xfs_mount *mp, struct xfs_dquot *udqp,
 		unsigned int iwalk_flags);
 int xfs_blockgc_free_quota(struct xfs_inode *ip, unsigned int iwalk_flags);
 int xfs_blockgc_free_space(struct xfs_mount *mp, struct xfs_icwalk *icm);
-void xfs_blockgc_flush_all(struct xfs_mount *mp);
+int xfs_blockgc_flush_all(struct xfs_mount *mp);
 
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
@@ -77,7 +77,7 @@ void xfs_blockgc_start(struct xfs_mount *mp);
 
 void xfs_inodegc_worker(struct work_struct *work);
 void xfs_inodegc_push(struct xfs_mount *mp);
-void xfs_inodegc_flush(struct xfs_mount *mp);
+int xfs_inodegc_flush(struct xfs_mount *mp);
 void xfs_inodegc_stop(struct xfs_mount *mp);
 void xfs_inodegc_start(struct xfs_mount *mp);
 void xfs_inodegc_cpu_dead(struct xfs_mount *mp, unsigned int cpu);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 54b707787f90..b0b4f6ac2397 100644
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
@@ -1696,12 +1687,12 @@ xfs_inode_needs_inactive(
  * now be truncated.  Also, we clear all of the read-ahead state
  * kept for the inode here since the file is now closed.
  */
-void
+int
 xfs_inactive(
 	xfs_inode_t	*ip)
 {
 	struct xfs_mount	*mp;
-	int			error;
+	int			error = 0;
 	int			truncate = 0;
 
 	/*
@@ -1742,7 +1733,7 @@ xfs_inactive(
 		 * reference to the inode at this point anyways.
 		 */
 		if (xfs_can_free_eofblocks(ip, true))
-			xfs_free_eofblocks(ip);
+			error = xfs_free_eofblocks(ip);
 
 		goto out;
 	}
@@ -1779,7 +1770,7 @@ xfs_inactive(
 	/*
 	 * Free the inode.
 	 */
-	xfs_inactive_ifree(ip);
+	error = xfs_inactive_ifree(ip);
 
 out:
 	/*
@@ -1787,6 +1778,7 @@ xfs_inactive(
 	 * the attached dquots.
 	 */
 	xfs_qm_dqdetach(ip);
+	return error;
 }
 
 /*
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index fa780f08dc89..225f6f93c2fa 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -470,7 +470,7 @@ enum layout_break_reason {
 	(xfs_has_grpid((pip)->i_mount) || (VFS_I(pip)->i_mode & S_ISGID))
 
 int		xfs_release(struct xfs_inode *ip);
-void		xfs_inactive(struct xfs_inode *ip);
+int		xfs_inactive(struct xfs_inode *ip);
 int		xfs_lookup(struct xfs_inode *dp, const struct xfs_name *name,
 			   struct xfs_inode **ipp, struct xfs_name *ci_name);
 int		xfs_create(struct user_namespace *mnt_userns,
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 05e48523ea40..affe94356ed1 100644
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
index 69ddd5319634..c8e72f0d3965 100644
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
index 12662b169b71..1c143c69da6e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1089,6 +1089,7 @@ xfs_inodegc_init_percpu(
 #endif
 		init_llist_head(&gc->list);
 		gc->items = 0;
+		gc->error = 0;
 		INIT_DELAYED_WORK(&gc->work, xfs_inodegc_worker);
 	}
 	return 0;
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index a772f60de4a2..b45879868f90 100644
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
2.46.0.598.g6f2099f65c-goog

