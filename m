Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A02E1AC8BE;
	Tue, 24 Sep 2024 18:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727203159; cv=none; b=R2IKRX/x6+AGPO5M3ruoYvlihRxFXWJzFTYke7aJnGAf9lO3115LEpc1DO4rfk4xFvMFrDx+YlDbGE6wLLSHmd3KY+vtSB2JfX+bogZAL/rkBZ938HuvRYsUEcVrB0K/NHfHI0tHteIOKa05UMJTAAvQqiFKscQ0gWaVFlP6IHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727203159; c=relaxed/simple;
	bh=0jmFHBw/vCU3VtCuvFmFU4TH0eWnRgMg4rr48Qvr4VE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ka8zv2/ffO0fU8pwuixNplyK7r174Ijor563zxlX8AJzx/V3hdyPw+5gVNxK5PJeaNlskzU+0+8SksZ7SXLfj03edIxoncbve+qCUKXcVguvlrSJccRO6pvJ2gfSZY7Fwk9Uf80v1JJm0SB+b/SE8oEi4ubK/wFC4X7ipKlyOpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BTqnBlhs; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BTqnBlhs"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2dee71e47c5so2403215a91.0;
        Tue, 24 Sep 2024 11:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727203157; x=1727807957; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BmQQX1Xon3zuomztZ3fANi6Gg8W/RuxklKOScXmdVwU=;
        b=BTqnBlhsxbrCkV05j2ZIV3W93NaKx+UFTzKTT2Z4R39Racw3i9XNiR3mJWZZh/NGFe
         lez9qNUVSYtUFUbtOU/X+l5VPmFteeHcQfiDS+eh7n/d99DnwmRk8ITJ7PqsR8zi/TqO
         lpNtkHo6Lc4GTicJ2LS05aRsqJYwfZmfwZBvyu4Uh3jPBiKRf1q0DdwypgyjzVjh1Cxl
         qkRIxC/M5ragT3BMnEbFn77e4UVii3129IwvBepxkDwo/VH5WzD5Ll+zH8lF7qbMWx9H
         kaCPTGTV1TkGyE77Bm992ke9DFdDCgWD4i7iM4SklXcddzra36RPAC4qz33w6OVR7vOE
         579w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727203157; x=1727807957;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BmQQX1Xon3zuomztZ3fANi6Gg8W/RuxklKOScXmdVwU=;
        b=Ayvq+VIAh6ih55Bb0EantkEiZ9VmieiZhaNM6Iqcul1IXWtpZ5/hSgsb3W8m0txvUf
         gzMm8EIAUpkWMIl4YNBkP6UZhzvicOAWaYqWel7+y8pZmtPrDggdtW2pa3PBGBOl52U0
         I8R4H9gqM1ORLZBC18OpLHeqMtVE+HWFz39UwmZfmu7O8LNfTk6vOzJk7Yh9HDzP4Hb/
         CkFr0C3hZLKqzFe0hCs+4sDTEU97pvoF5jd+ttiUYYoCgmBWGNq8umsTCguTZbXci7Yv
         t0WCzAgpNEREP1l3RRAKNXdy8zW5wPk8/9i+dbvrRHBVp6zA4McMRINFMiWyEb7lVTew
         A16A==
X-Gm-Message-State: AOJu0YyN9vhDpRD71D9rD6oQpidE9WWgDEATpkI77xw3C1aUMByZeLJI
	Pa2Ym+SXnTyDBPOqUxe1HXCBxd4eHqsHHikTtnMnpbJl+OcWOjhbg4VWy/wG
X-Google-Smtp-Source: AGHT+IH0pAVn4Ru65vibzMaz6N0eNgwDTVRREwsGKHF2wjCa7PyaH2YWh5koLW43SkJCCZRNoe9q9A==
X-Received: by 2002:a17:90b:48c5:b0:2dd:6969:208e with SMTP id 98e67ed59e1d1-2e06ae25d43mr128093a91.3.1727203156510;
        Tue, 24 Sep 2024 11:39:16 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:3987:6b77:4621:58ca])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ef93b2fsm11644349a91.49.2024.09.24.11.39.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 11:39:16 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	cem@kernel.org,
	catherine.hoang@oracle.com,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 14/26] xfs: collect errors from inodegc for unlinked inode recovery
Date: Tue, 24 Sep 2024 11:38:39 -0700
Message-ID: <20240924183851.1901667-15-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
In-Reply-To: <20240924183851.1901667-1-leah.rumancik@gmail.com>
References: <20240924183851.1901667-1-leah.rumancik@gmail.com>
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
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
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
2.46.0.792.g87dc391469-goog

