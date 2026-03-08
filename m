Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32519394495;
	Sun,  8 Mar 2026 18:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.68.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772994520; cv=none; b=Wo3DTOTpGrM9SIX0atkWS4JkA6kjQHXaQFXDDXtGiq76JsRC+tWPzIRPXHgZL7bJffeIdxV/OStsfMiMeeLdexZWulV2deK4IgTVRhjoOm782BP3giCHcwBqE4cv9tDXuBPsyShE1UokE2KKrbiLHl02CEv/+W07a0hRIWQZC8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772994520; c=relaxed/simple;
	bh=1UIppoZyir+61CDau2LCokh4PD34UW78nSJShCzVnyE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ky27WPkjprFAiaWVsn5lLdLSbhjMycWwT7q6UcwNfjg5T0wUeptXFPrWVlDODXHOPXAN7DNDWCJ1Ennpbo0KuwSrnyeizJWGpZ0woK8YeJZnOb/byLUb4Tcw9unQMA0/v6JitmJP5bc1u1WBBA+XehcwqvNWce3eEoAgMhd3P3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=rPKNi0jT; arc=none smtp.client-ip=44.246.68.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="rPKNi0jT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772994509; x=1804530509;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AueivNNeE//yBNWDqGURJYyIQboJLeELbylOy5lnfSU=;
  b=rPKNi0jTkL0SSjZA1jTkdrndsjfcrieCXwxNH3P/VguDwun9Wa3ADFFh
   /RfLPUKfypB4CLiocqbWjZfMyIvCXBoDtbgQDJct7dspFNzXY5yxU+aoE
   NpBJW84ZlIfalPmug5dpz1qBB62xXc6MipA+kM8XxC29SAQOyYpM+Jab7
   z+YdC8PDCXN5xVk6Vf4NRcbj9eVJZcHn4vEDs7ImNxa3z/9Ve8ZXLuUeo
   wk97MYxGFcGBQYxBQcmpeaXn4xRBE16FLRGjSenndBjoEVC67A+Ro98QR
   5UlTFkFm4fNijdq5orq7JoSFoGKohnc5yRP2r1W8dMUslgxj1wKAIC+W7
   g==;
X-CSE-ConnectionGUID: ZcFVHh2zTS+iuBTxwHb1+g==
X-CSE-MsgGUID: JiOmpOdnR9+V3bgTU02qEg==
X-IronPort-AV: E=Sophos;i="6.23,109,1770595200"; 
   d="scan'208";a="14587972"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2026 18:28:26 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:6408]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.52.102:2525] with esmtp (Farcaster)
 id 5ee920d1-6f3e-4586-bebb-47a18ba0f82b; Sun, 8 Mar 2026 18:28:26 +0000 (UTC)
X-Farcaster-Flow-ID: 5ee920d1-6f3e-4586-bebb-47a18ba0f82b
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sun, 8 Mar 2026 18:28:26 +0000
Received: from c889f3b07a0a.amazon.com (10.106.82.18) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sun, 8 Mar 2026 18:28:24 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>
CC: "Darrick J . Wong" <darrick.wong@oracle.com>, Brian Foster
	<bfoster@redhat.com>, <linux-xfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yuto Ohnuki <ytohnuki@amazon.com>,
	<syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH v3 3/4] xfs: avoid dereferencing log items after push callbacks
Date: Sun, 8 Mar 2026 18:28:08 +0000
Message-ID: <20260308182804.33127-9-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260308182804.33127-6-ytohnuki@amazon.com>
References: <20260308182804.33127-6-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D036UWB004.ant.amazon.com (10.13.139.170) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

After xfsaild_push_item() calls iop_push(), the log item may have been
freed if the AIL lock was dropped during the push. The tracepoints in
the switch statement dereference the log item after iop_push() returns,
which can result in a use-after-free.

Fix this by capturing the log item type, flags, and LSN before calling
xfsaild_push_item(), and introducing a new xfs_ail_push_class trace
event class that takes these pre-captured values and the ailp pointer
instead of the log item pointer.

Reported-by: syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=652af2b3c5569c4ab63c
Fixes: 90c60e164012 ("xfs: xfs_iflush() is no longer necessary")
Cc: <stable@vger.kernel.org> # v5.9
Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
---
 fs/xfs/xfs_trace.h     | 36 ++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_trans_ail.c | 24 ++++++++++++++++--------
 2 files changed, 48 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 813e5a9f57eb..0e994b3f768f 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -56,6 +56,7 @@
 #include <linux/tracepoint.h>
 
 struct xfs_agf;
+struct xfs_ail;
 struct xfs_alloc_arg;
 struct xfs_attr_list_context;
 struct xfs_buf_log_item;
@@ -1650,16 +1651,43 @@ TRACE_EVENT(xfs_log_force,
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
 DEFINE_LOG_ITEM_EVENT(xlog_ail_insert_abort);
 DEFINE_LOG_ITEM_EVENT(xfs_trans_free_abort);
 
+DECLARE_EVENT_CLASS(xfs_ail_push_class,
+	TP_PROTO(struct xfs_ail *ailp, uint type, unsigned long flags, xfs_lsn_t lsn),
+	TP_ARGS(ailp, type, flags, lsn),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(uint, type)
+		__field(unsigned long, flags)
+		__field(xfs_lsn_t, lsn)
+	),
+	TP_fast_assign(
+		__entry->dev = ailp->ail_log->l_mp->m_super->s_dev;
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
+	TP_PROTO(struct xfs_ail *ailp, uint type, unsigned long flags, xfs_lsn_t lsn), \
+	TP_ARGS(ailp, type, flags, lsn))
+DEFINE_AIL_PUSH_EVENT(xfs_ail_push);
+DEFINE_AIL_PUSH_EVENT(xfs_ail_pinned);
+DEFINE_AIL_PUSH_EVENT(xfs_ail_locked);
+DEFINE_AIL_PUSH_EVENT(xfs_ail_flushing);
+
 DECLARE_EVENT_CLASS(xfs_ail_class,
 	TP_PROTO(struct xfs_log_item *lip, xfs_lsn_t old_lsn, xfs_lsn_t new_lsn),
 	TP_ARGS(lip, old_lsn, new_lsn),
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index ac747804e1d6..14ffb77b12ea 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -365,6 +365,12 @@ xfsaild_resubmit_item(
 	return XFS_ITEM_SUCCESS;
 }
 
+/*
+ * Push a single log item from the AIL.
+ *
+ * @lip may have been released and freed by the time this function returns,
+ * so callers must not dereference the log item afterwards.
+ */
 static inline uint
 xfsaild_push_item(
 	struct xfs_ail		*ailp,
@@ -462,11 +468,13 @@ static void
 xfsaild_process_logitem(
 	struct xfs_ail		*ailp,
 	struct xfs_log_item	*lip,
-	xfs_lsn_t		lsn,
 	int			*stuck,
 	int			*flushing)
 {
 	struct xfs_mount	*mp = ailp->ail_log->l_mp;
+	uint			type = lip->li_type;
+	unsigned long		flags = lip->li_flags;
+	xfs_lsn_t		item_lsn = lip->li_lsn;
 	int			lock_result;
 
 	/*
@@ -478,9 +486,9 @@ xfsaild_process_logitem(
 	switch (lock_result) {
 	case XFS_ITEM_SUCCESS:
 		XFS_STATS_INC(mp, xs_push_ail_success);
-		trace_xfs_ail_push(lip);
+		trace_xfs_ail_push(ailp, type, flags, item_lsn);
 
-		ailp->ail_last_pushed_lsn = lsn;
+		ailp->ail_last_pushed_lsn = item_lsn;
 		break;
 
 	case XFS_ITEM_FLUSHING:
@@ -496,22 +504,22 @@ xfsaild_process_logitem(
 		 * AIL is being flushed.
 		 */
 		XFS_STATS_INC(mp, xs_push_ail_flushing);
-		trace_xfs_ail_flushing(lip);
+		trace_xfs_ail_flushing(ailp, type, flags, item_lsn);
 
 		(*flushing)++;
-		ailp->ail_last_pushed_lsn = lsn;
+		ailp->ail_last_pushed_lsn = item_lsn;
 		break;
 
 	case XFS_ITEM_PINNED:
 		XFS_STATS_INC(mp, xs_push_ail_pinned);
-		trace_xfs_ail_pinned(lip);
+		trace_xfs_ail_pinned(ailp, type, flags, item_lsn);
 
 		(*stuck)++;
 		ailp->ail_log_flush++;
 		break;
 	case XFS_ITEM_LOCKED:
 		XFS_STATS_INC(mp, xs_push_ail_locked);
-		trace_xfs_ail_locked(lip);
+		trace_xfs_ail_locked(ailp, type, flags, item_lsn);
 
 		(*stuck)++;
 		break;
@@ -572,7 +580,7 @@ xfsaild_push(
 		if (test_bit(XFS_LI_FLUSHING, &lip->li_flags))
 			goto next_item;
 
-		xfsaild_process_logitem(ailp, lip, lsn, &stuck, &flushing);
+		xfsaild_process_logitem(ailp, lip, &stuck, &flushing);
 		count++;
 
 		/*
-- 
2.50.1




Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



