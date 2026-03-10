Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BE0319860;
	Tue, 10 Mar 2026 18:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.162.73.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773167951; cv=none; b=EjuRR0QGnQfnr9/VsXDaofVpYk/VrB1gkUm8erUpIlMdlmMG/4tVuzmsOlkB0DRN+BGBGr5Owv5OSf1r9kxjrhCP17ouMEb8O2VjWqyVDEAIx4tOXnZ0c5BFEFPoJqNLSsH7oRDYzIco6H8O/tTmyvcmJjRBUW3YEp840osY248=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773167951; c=relaxed/simple;
	bh=ugCxwAnkKxNq3cd/FvFAywTt11Al2okO0P4Ue3iUiAM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s0JnnJDDqDMClWbAkl/fP3X+RRdDHwyTX+7LgYCOdBVm7Udzfid75BGVsDXFs3IgBVwQZ7q2mly7tim/jQNIZVHzGEAB6rmBVmFMTN5L6BSejteF5RsAmlrhcbcYEd5bBcceKhYmJ36zIncq0hIzylH3f8POejqBhrBbUg0PTeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=mdPtN5+5; arc=none smtp.client-ip=35.162.73.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="mdPtN5+5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1773167950; x=1804703950;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4NnVIiiPnNfD22/cOrpxQtuLL3TRTQnIr3yN1LcrQTw=;
  b=mdPtN5+514Sl3jJ72hvj6zAZ8Pe9FIGF+Tyr4wldtEcRC+6ckpWEklKq
   rk8pdXezpUOsgtf7UxbO/eTI7mCYrGknYgmHxTC8lvACOgglORrJKXgNc
   JE3fxGxX0R2fHzg678BKv589LQTgb5nooRNgafFm2waNiUO+i8+1JZECu
   xikI00xWuW01G3QyTWaryxMUdENhETDcvil6n0QsxLn2Ib4Dfmnl4t9+u
   CYcDGH65Z1MUwcRZhJqztwnu6v58LJhqiKUSip+FA+CMtASbyACF2V4KL
   379JJnSGJEZ1hyTXFcM38FTxGraWKWf9SbDxFAaO63+DCpv52rGTNtyni
   Q==;
X-CSE-ConnectionGUID: UukqTGmsSsuzgaDY9ujWPA==
X-CSE-MsgGUID: 9/r7+1+8So+BI8O9gofq0w==
X-IronPort-AV: E=Sophos;i="6.23,112,1770595200"; 
   d="scan'208";a="14537315"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2026 18:39:06 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:1842]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.26.67:2525] with esmtp (Farcaster)
 id 015c37b5-5e0c-4ec1-a167-c5bc2692f652; Tue, 10 Mar 2026 18:39:06 +0000 (UTC)
X-Farcaster-Flow-ID: 015c37b5-5e0c-4ec1-a167-c5bc2692f652
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 10 Mar 2026 18:39:00 +0000
Received: from c889f3b07a0a.amazon.com (10.106.82.15) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 10 Mar 2026 18:38:58 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>
CC: "Darrick J . Wong" <darrick.wong@oracle.com>, Brian Foster
	<bfoster@redhat.com>, <linux-xfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yuto Ohnuki <ytohnuki@amazon.com>
Subject: [PATCH v4 4/4] xfs: refactor xfsaild_push loop into helper
Date: Tue, 10 Mar 2026 18:38:40 +0000
Message-ID: <20260310183835.89827-10-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260310183835.89827-6-ytohnuki@amazon.com>
References: <20260310183835.89827-6-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D036UWC002.ant.amazon.com (10.13.139.242) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Factor the loop body of xfsaild_push() into a separate
xfsaild_process_logitem() helper to improve readability.

This is a pure code movement with no functional change.

Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
---
 fs/xfs/xfs_trans_ail.c | 127 ++++++++++++++++++++++-------------------
 1 file changed, 69 insertions(+), 58 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 63266d31b514..99a9bf3762b7 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -464,6 +464,74 @@ xfs_ail_calc_push_target(
 	return target_lsn;
 }
 
+static void
+xfsaild_process_logitem(
+	struct xfs_ail		*ailp,
+	struct xfs_log_item	*lip,
+	int			*stuck,
+	int			*flushing)
+{
+	struct xfs_mount	*mp = ailp->ail_log->l_mp;
+	uint			type = lip->li_type;
+	unsigned long		flags = lip->li_flags;
+	xfs_lsn_t		item_lsn = lip->li_lsn;
+	int			lock_result;
+
+	/*
+	 * Note that iop_push may unlock and reacquire the AIL lock. We
+	 * rely on the AIL cursor implementation to be able to deal with
+	 * the dropped lock.
+	 *
+	 * The log item may have been freed by the push, so it must not
+	 * be accessed or dereferenced below this line.
+	 */
+	lock_result = xfsaild_push_item(ailp, lip);
+	switch (lock_result) {
+	case XFS_ITEM_SUCCESS:
+		XFS_STATS_INC(mp, xs_push_ail_success);
+		trace_xfs_ail_push(ailp, type, flags, item_lsn);
+
+		ailp->ail_last_pushed_lsn = item_lsn;
+		break;
+
+	case XFS_ITEM_FLUSHING:
+		/*
+		 * The item or its backing buffer is already being
+		 * flushed.  The typical reason for that is that an
+		 * inode buffer is locked because we already pushed the
+		 * updates to it as part of inode clustering.
+		 *
+		 * We do not want to stop flushing just because lots
+		 * of items are already being flushed, but we need to
+		 * re-try the flushing relatively soon if most of the
+		 * AIL is being flushed.
+		 */
+		XFS_STATS_INC(mp, xs_push_ail_flushing);
+		trace_xfs_ail_flushing(ailp, type, flags, item_lsn);
+
+		(*flushing)++;
+		ailp->ail_last_pushed_lsn = item_lsn;
+		break;
+
+	case XFS_ITEM_PINNED:
+		XFS_STATS_INC(mp, xs_push_ail_pinned);
+		trace_xfs_ail_pinned(ailp, type, flags, item_lsn);
+
+		(*stuck)++;
+		ailp->ail_log_flush++;
+		break;
+	case XFS_ITEM_LOCKED:
+		XFS_STATS_INC(mp, xs_push_ail_locked);
+		trace_xfs_ail_locked(ailp, type, flags, item_lsn);
+
+		(*stuck)++;
+		break;
+	default:
+		ASSERT(0);
+		break;
+	}
+}
+
 static long
 xfsaild_push(
 	struct xfs_ail		*ailp)
@@ -511,68 +579,11 @@ xfsaild_push(
 
 	lsn = lip->li_lsn;
 	while ((XFS_LSN_CMP(lip->li_lsn, ailp->ail_target) <= 0)) {
-		int		lock_result;
-		uint		type = lip->li_type;
-		unsigned long	flags = lip->li_flags;
-		xfs_lsn_t	item_lsn = lip->li_lsn;
 
 		if (test_bit(XFS_LI_FLUSHING, &lip->li_flags))
 			goto next_item;
 
-		/*
-		 * Note that iop_push may unlock and reacquire the AIL lock.  We
-		 * rely on the AIL cursor implementation to be able to deal with
-		 * the dropped lock.
-		 *
-		 * The log item may have been freed by the push, so it must not
-		 * be accessed or dereferenced below this line.
-		 */
-		lock_result = xfsaild_push_item(ailp, lip);
-		switch (lock_result) {
-		case XFS_ITEM_SUCCESS:
-			XFS_STATS_INC(mp, xs_push_ail_success);
-			trace_xfs_ail_push(ailp, type, flags, item_lsn);
-
-			ailp->ail_last_pushed_lsn = item_lsn;
-			break;
-
-		case XFS_ITEM_FLUSHING:
-			/*
-			 * The item or its backing buffer is already being
-			 * flushed.  The typical reason for that is that an
-			 * inode buffer is locked because we already pushed the
-			 * updates to it as part of inode clustering.
-			 *
-			 * We do not want to stop flushing just because lots
-			 * of items are already being flushed, but we need to
-			 * re-try the flushing relatively soon if most of the
-			 * AIL is being flushed.
-			 */
-			XFS_STATS_INC(mp, xs_push_ail_flushing);
-			trace_xfs_ail_flushing(ailp, type, flags, item_lsn);
-
-			flushing++;
-			ailp->ail_last_pushed_lsn = item_lsn;
-			break;
-
-		case XFS_ITEM_PINNED:
-			XFS_STATS_INC(mp, xs_push_ail_pinned);
-			trace_xfs_ail_pinned(ailp, type, flags, item_lsn);
-
-			stuck++;
-			ailp->ail_log_flush++;
-			break;
-		case XFS_ITEM_LOCKED:
-			XFS_STATS_INC(mp, xs_push_ail_locked);
-			trace_xfs_ail_locked(ailp, type, flags, item_lsn);
-
-			stuck++;
-			break;
-		default:
-			ASSERT(0);
-			break;
-		}
-
+		xfsaild_process_logitem(ailp, lip, &stuck, &flushing);
 		count++;
 
 		/*
-- 
2.50.1




Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



