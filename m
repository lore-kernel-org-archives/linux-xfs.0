Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32062DC359;
	Thu,  5 Mar 2026 18:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.245.243.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772737133; cv=none; b=A1iVQpLxTd8GB7E7la1Z15s44hzlklf44JWZzlGszRxYwFHVzrE8ni31S3cP7GutNSQi3H2GMRJX+IiVI60zQ8nzHhrFcPQYAWY+DNScEIKew/xvv17w6dl7aQwwzqLc2KT4L9bUNwbgnQYJCa8/Rm0juNr6fzC6oX7kgHNpV44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772737133; c=relaxed/simple;
	bh=GMugpAfqnoCQAmp6a6YlFiYZ7sf+oEd/g95pDfg+RZ8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BmYrbMWfEy3SkepHfqiEi+JGD9pB4aP5j2cUTDmT8JwucaO3S4Jxs5cAfSNMuow4Svp1t0iaHkRDSmBh9vdo6rrt/9zSdOy3gT519qJB0VdoK8P/YVL7/O5DIP9/48C/NWFc1VuzOCRAXV1KBNgKba8QAhMoRCHHcsFV8dGQ9mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=W26/dGVC; arc=none smtp.client-ip=44.245.243.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="W26/dGVC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772737131; x=1804273131;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4StIWF/SCjxNpIHsoNZ6n82y3enD+uz4y2VDFyzET7s=;
  b=W26/dGVCEGmz72Cf37a3SLnZLI3rfBhq8fl+PSYTv8wasENs2ig3isUx
   1FNnHT6OiBEl+lJKKhLeg3yHCucAqKofNeuPIfLUQfqvSXYZkVBGKsMiY
   kLG4dAl7z9arhnjUHMSdvht8rsNXBMUVmrWDxXurLlsr7++KSUiI1xzoC
   d6vbz4ZrAxZxqalOGJRKvyaSyHcdajbHv78KCQdYaWvZHUIP0mLBhb+Df
   sjeVrYh5T85con9SwELbTk2MncfKZryeA7q5MVMZfRzmRRIhhxTqSzTZK
   hUfN60XExCwQcpkIjeFrHakJjRS1NFf7BdiyzFImYBPIWXDPXic66lTwb
   Q==;
X-CSE-ConnectionGUID: ike/aCFsSP207dXpNGDppQ==
X-CSE-MsgGUID: ksD7cZ6FT/mlhC4Vv0cqlA==
X-IronPort-AV: E=Sophos;i="6.23,103,1770595200"; 
   d="scan'208";a="13942444"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 18:58:49 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:24734]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.34.39:2525] with esmtp (Farcaster)
 id 5b5058c2-77b4-40be-82f7-669c5a659971; Thu, 5 Mar 2026 18:58:48 +0000 (UTC)
X-Farcaster-Flow-ID: 5b5058c2-77b4-40be-82f7-669c5a659971
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 5 Mar 2026 18:58:46 +0000
Received: from c889f3b07a0a.amazon.com (10.106.82.26) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 5 Mar 2026 18:58:44 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>
CC: "Darrick J . Wong" <darrick.wong@oracle.com>, Brian Foster
	<bfoster@redhat.com>, <linux-xfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yuto Ohnuki <ytohnuki@amazon.com>,
	<syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH v2] xfs: fix use-after-free of log items during AIL pushing
Date: Thu, 5 Mar 2026 18:58:37 +0000
Message-ID: <20260305185836.56478-2-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D037UWC003.ant.amazon.com (10.13.139.231) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When a filesystem is shut down, background inode reclaim and the xfsaild
can race to abort and free dirty inodes. During xfs_iflush_cluster(), if
the filesystem is shut down, individual inodes are aborted, marked clean
and removed from the AIL. When the buffer is subsequently failed via
xfs_buf_ioend_fail(), the buffer is unlocked and pending inode reclaim
can make progress.

If the xfsaild is then preempted long enough for reclaim to complete its
work and the RCU grace period to expire, the inode and its log item are
freed before the xfsaild reacquires the AIL lock. This results in a
use-after-free when dereferencing the log item's li_ailp pointer at
offset 48.

Since commit 90c60e164012 ("xfs: xfs_iflush() is no longer necessary"),
xfs_inode_item_push() no longer holds ILOCK_SHARED while flushing,
removing the protection that prevented the inode from being reclaimed
during the flush.

xfs_dquot_item_push() has the same issue, as dquots can be reclaimed
asynchronously via a memory pressure driven shrinker while the AIL lock
is temporarily dropped.

The unmount sequence in xfs_unmount_flush_inodes() also contributes to
the race by pushing the AIL while background reclaim and inodegc are
still running.

Additionally, all tracepoints in the xfsaild_push() switch statement
dereference the log item after xfsaild_push_item() returns, when the
item may already be freed. The UAF is most likely when
xfs_iflush_cluster() returns -EIO and XFS_ITEM_LOCKED is returned.

Fix this by:
- Reordering xfs_unmount_flush_inodes() to stop background reclaim and
  inodegc before pushing the AIL.
- Saving the ailp pointer in local variables in xfs_inode_item_push()
  and xfs_dquot_item_push() when the AIL lock is held and the log item
  is guaranteed to be valid.
- Capturing log item fields before calling xfsaild_push_item() so that
  tracepoints do not dereference potentially freed log items.
  A new xfs_ail_push_class trace event class is introduced for this
  purpose, while the existing xfs_log_item_class remains unchanged to
  preserve compatibility.
- Adding comments documenting that log items must not be referenced
  after iop_push() returns.

Reported-by: syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=652af2b3c5569c4ab63c
Fixes: 90c60e164012 ("xfs: xfs_iflush() is no longer necessary")
Cc: <stable@vger.kernel.org> # v5.9
Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
---
Changes in v2:
- Reordered xfs_unmount_flush_inodes() to stop reclaim before pushing
  AIL suggested by Dave Chinner
- Introduced xfs_ail_push_class trace event to avoid dereferencing
  freed log items in tracepoints
- Added comments documenting that log items must not be referenced
  after iop_push() returns
- Saved ailp pointer in local variables in push functions
- Link to v1: https://lore.kernel.org/all/20260304162405.58017-2-ytohnuki@amazon.com/
---
 fs/xfs/xfs_dquot_item.c | 10 ++++++++--
 fs/xfs/xfs_inode_item.c |  9 +++++++--
 fs/xfs/xfs_mount.c      |  4 ++--
 fs/xfs/xfs_trace.h      | 35 +++++++++++++++++++++++++++++++----
 fs/xfs/xfs_trans_ail.c  | 28 ++++++++++++++++++++++++----
 5 files changed, 72 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 491e2a7053a3..223e7162db02 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -125,6 +125,7 @@ xfs_qm_dquot_logitem_push(
 	struct xfs_dq_logitem	*qlip = DQUOT_ITEM(lip);
 	struct xfs_dquot	*dqp = qlip->qli_dquot;
 	struct xfs_buf		*bp;
+	struct xfs_ail		*ailp = lip->li_ailp;
 	uint			rval = XFS_ITEM_SUCCESS;
 	int			error;
 
@@ -153,7 +154,12 @@ xfs_qm_dquot_logitem_push(
 		goto out_unlock;
 	}
 
-	spin_unlock(&lip->li_ailp->ail_lock);
+	/*
+	 * After dropping the AIL lock, the log item may be freed via
+	 * memory pressure driven shrinker. Do not reference lip after
+	 * this point.
+	 */
+	spin_unlock(&ailp->ail_lock);
 
 	error = xfs_dquot_use_attached_buf(dqp, &bp);
 	if (error == -EAGAIN) {
@@ -174,7 +180,7 @@ xfs_qm_dquot_logitem_push(
 	xfs_buf_relse(bp);
 
 out_relock_ail:
-	spin_lock(&lip->li_ailp->ail_lock);
+	spin_lock(&ailp->ail_lock);
 out_unlock:
 	mutex_unlock(&dqp->q_qlock);
 	return rval;
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 8913036b8024..f584e0a2f174 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -746,6 +746,7 @@ xfs_inode_item_push(
 	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
 	struct xfs_inode	*ip = iip->ili_inode;
 	struct xfs_buf		*bp = lip->li_buf;
+	struct xfs_ail		*ailp = lip->li_ailp;
 	uint			rval = XFS_ITEM_SUCCESS;
 	int			error;
 
@@ -771,7 +772,11 @@ xfs_inode_item_push(
 	if (!xfs_buf_trylock(bp))
 		return XFS_ITEM_LOCKED;
 
-	spin_unlock(&lip->li_ailp->ail_lock);
+	/*
+	 * After dropping the AIL lock, the log item may be freed via
+	 * RCU callback. Do not reference lip after this point.
+	 */
+	spin_unlock(&ailp->ail_lock);
 
 	/*
 	 * We need to hold a reference for flushing the cluster buffer as it may
@@ -795,7 +800,7 @@ xfs_inode_item_push(
 		rval = XFS_ITEM_LOCKED;
 	}
 
-	spin_lock(&lip->li_ailp->ail_lock);
+	spin_lock(&ailp->ail_lock);
 	return rval;
 }
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 9c295abd0a0a..786e1fc720e5 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -621,9 +621,9 @@ xfs_unmount_flush_inodes(
 
 	xfs_set_unmounting(mp);
 
-	xfs_ail_push_all_sync(mp->m_ail);
-	xfs_inodegc_stop(mp);
 	cancel_delayed_work_sync(&mp->m_reclaim_work);
+	xfs_inodegc_stop(mp);
+	xfs_ail_push_all_sync(mp->m_ail);
 	xfs_reclaim_inodes(mp);
 	xfs_health_unmount(mp);
 	xfs_healthmon_unmount(mp);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 813e5a9f57eb..ee4b72878f7b 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1646,14 +1646,41 @@ TRACE_EVENT(xfs_log_force,
 		  __entry->lsn, (void *)__entry->caller_ip)
 )
 
+DECLARE_EVENT_CLASS(xfs_ail_push_class,
+	TP_PROTO(dev_t dev, uint type, unsigned long flags, xfs_lsn_t lsn),
+	TP_ARGS(dev, type, flags, lsn),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(uint, type)
+		__field(unsigned long, flags)
+		__field(xfs_lsn_t, lsn)
+	),
+	TP_fast_assign(
+		__entry->dev = dev;
+		__entry->type = type;
+		__entry->flags = flags;
+		__entry->lsn = lsn;
+	),
+	TP_printk("dev %d:%d lsn %d/%d type %s flags %s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  CYCLE_LSN(__entry->lsn), BLOCK_LSN(__entry->lsn),
+		  __print_symbolic(__entry->type, XFS_LI_TYPE_DESC),
+		  __print_flags(__entry->flags, "|", XFS_LI_FLAGS))
+)
+
+#define DEFINE_AIL_PUSH_EVENT(name) \
+DEFINE_EVENT(xfs_ail_push_class, name, \
+	TP_PROTO(dev_t dev, uint type, unsigned long flags, xfs_lsn_t lsn), \
+	TP_ARGS(dev, type, flags, lsn))
+DEFINE_AIL_PUSH_EVENT(xfs_ail_push);
+DEFINE_AIL_PUSH_EVENT(xfs_ail_pinned);
+DEFINE_AIL_PUSH_EVENT(xfs_ail_locked);
+DEFINE_AIL_PUSH_EVENT(xfs_ail_flushing);
+
 #define DEFINE_LOG_ITEM_EVENT(name) \
 DEFINE_EVENT(xfs_log_item_class, name, \
 	TP_PROTO(struct xfs_log_item *lip), \
 	TP_ARGS(lip))
-DEFINE_LOG_ITEM_EVENT(xfs_ail_push);
-DEFINE_LOG_ITEM_EVENT(xfs_ail_pinned);
-DEFINE_LOG_ITEM_EVENT(xfs_ail_locked);
-DEFINE_LOG_ITEM_EVENT(xfs_ail_flushing);
 DEFINE_LOG_ITEM_EVENT(xfs_cil_whiteout_mark);
 DEFINE_LOG_ITEM_EVENT(xfs_cil_whiteout_skip);
 DEFINE_LOG_ITEM_EVENT(xfs_cil_whiteout_unpin);
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 923729af4206..48b14146826b 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -387,6 +387,11 @@ xfsaild_push_item(
 		return XFS_ITEM_PINNED;
 	if (test_bit(XFS_LI_FAILED, &lip->li_flags))
 		return xfsaild_resubmit_item(lip, &ailp->ail_buf_list);
+
+	/*
+	 * Once iop_push() returns, the log item may have been freed
+	 * and must not be dereferenced.
+	 */
 	return lip->li_ops->iop_push(lip, &ailp->ail_buf_list);
 }
 
@@ -506,20 +511,35 @@ xfsaild_push(
 	lsn = lip->li_lsn;
 	while ((XFS_LSN_CMP(lip->li_lsn, ailp->ail_target) <= 0)) {
 		int	lock_result;
+		dev_t dev;
+		uint type;
+		unsigned long flags;
+		xfs_lsn_t item_lsn;
 
 		if (test_bit(XFS_LI_FLUSHING, &lip->li_flags))
 			goto next_item;
 
+		/*
+		 * Store log item information before pushing, as the item
+		 * may be freed after dropping the AIL lock.
+		 */
+		dev = lip->li_log->l_mp->m_super->s_dev;
+		type = lip->li_type;
+		flags = lip->li_flags;
+		item_lsn = lip->li_lsn;
+
 		/*
 		 * Note that iop_push may unlock and reacquire the AIL lock.  We
 		 * rely on the AIL cursor implementation to be able to deal with
 		 * the dropped lock.
+		 * After this call returns, the log item may have been freed and
+		 * must not be referenced.
 		 */
 		lock_result = xfsaild_push_item(ailp, lip);
 		switch (lock_result) {
 		case XFS_ITEM_SUCCESS:
 			XFS_STATS_INC(mp, xs_push_ail_success);
-			trace_xfs_ail_push(lip);
+			trace_xfs_ail_push(dev, type, flags, item_lsn);
 
 			ailp->ail_last_pushed_lsn = lsn;
 			break;
@@ -537,7 +557,7 @@ xfsaild_push(
 			 * AIL is being flushed.
 			 */
 			XFS_STATS_INC(mp, xs_push_ail_flushing);
-			trace_xfs_ail_flushing(lip);
+			trace_xfs_ail_flushing(dev, type, flags, item_lsn);
 
 			flushing++;
 			ailp->ail_last_pushed_lsn = lsn;
@@ -545,14 +565,14 @@ xfsaild_push(
 
 		case XFS_ITEM_PINNED:
 			XFS_STATS_INC(mp, xs_push_ail_pinned);
-			trace_xfs_ail_pinned(lip);
+			trace_xfs_ail_pinned(dev, type, flags, item_lsn);
 
 			stuck++;
 			ailp->ail_log_flush++;
 			break;
 		case XFS_ITEM_LOCKED:
 			XFS_STATS_INC(mp, xs_push_ail_locked);
-			trace_xfs_ail_locked(lip);
+			trace_xfs_ail_locked(dev, type, flags, item_lsn);
 
 			stuck++;
 			break;
-- 
2.50.1




Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



