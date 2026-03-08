Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA4739283D;
	Sun,  8 Mar 2026 18:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.42.203.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772994506; cv=none; b=CkGh93cGIR5dZdG4ZIkPghoGCEmLZ/PybFMPT1DodKPTotD8rEQsqMQrp3g3mbUoqiB5++cygPqeTRqInXiuauJ1yj6CFoskw4XAZs5mUGFnll5NOIGHCUCRtrlwPRKANyaJxLCVpBv1MqDzhUPSnoVzqeNNMi+18fe9BCGrrng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772994506; c=relaxed/simple;
	bh=zLMN9+R3TcKfIQICVwuSHYqAKVdUpKlnJmncphhvbK8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WyE9rvaaak+kgm6GjWFOm4okKXRkvf1F+9h96W/P8IBZtPys0WhcaRk7Fa9AvxgXEofC5wuJIoA0t2Y7kEoGLhx5VLXnLldq1Ae8QVtXj9lL4X/nuJjrgLDdG7pj+kxO1Mktyr3C3YuhuNHqM5tSIVhu079HgPnD8MqN6sqNelU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=mfdNifbw; arc=none smtp.client-ip=52.42.203.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="mfdNifbw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772994505; x=1804530505;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xxNWM3yg6rCQ2GaizLCYP3y/nhylL6KTTtZ38mtodWg=;
  b=mfdNifbw6O2HG7GnoxXjACbr/WxWHBuGfZ3VdLYuha26vP5cMlYv614T
   8TccNm/h+pIKhtHkysa/nqo16bDfF3yFblh4zFUT8xq7Eohs5fJOwWoIX
   GioPFGrxgMjYrOuIY7KECO9QbqSmb9xgmLfQ21N/ZofN3CWeFcJunwM5F
   IPZ8XACyoNE9pBuGAVy0EH3dYQgZMokTR05QomixGgNBsmm323LhSML9D
   8M2m9wR6L/8u6C0FG6pbVK8YukIc5RmVUarpnhQrgsb3n67gXdxPEVTqS
   +kGEMcMoyqCgsDDr7i8JXl5LH0Ew+8y+7sZ7AYoD+3Rczok/d1j0a8y4O
   g==;
X-CSE-ConnectionGUID: HKNvzKu0TM224L6+ThPT6w==
X-CSE-MsgGUID: 7zQ07h3uQpK41nMlRux01g==
X-IronPort-AV: E=Sophos;i="6.23,109,1770595200"; 
   d="scan'208";a="14575498"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2026 18:28:24 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:16326]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.6.153:2525] with esmtp (Farcaster)
 id 1203a453-8489-4ab9-a65c-e19db4ef0a33; Sun, 8 Mar 2026 18:28:23 +0000 (UTC)
X-Farcaster-Flow-ID: 1203a453-8489-4ab9-a65c-e19db4ef0a33
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sun, 8 Mar 2026 18:28:23 +0000
Received: from c889f3b07a0a.amazon.com (10.106.82.18) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sun, 8 Mar 2026 18:28:21 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>
CC: "Darrick J . Wong" <darrick.wong@oracle.com>, Brian Foster
	<bfoster@redhat.com>, <linux-xfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yuto Ohnuki <ytohnuki@amazon.com>,
	<stable@vger.kernel.org>
Subject: [PATCH v3 2/4] xfs: refactor xfsaild_push loop into helper
Date: Sun, 8 Mar 2026 18:28:07 +0000
Message-ID: <20260308182804.33127-8-ytohnuki@amazon.com>
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

Factor the loop body of xfsaild_push() into a separate
xfsaild_process_logitem() helper to improve readability.

This is a pure code movement with no functional change. The
subsequent patch to fix a use-after-free in the AIL push path
depends on this refactoring.

Cc: <stable@vger.kernel.org> # v5.9
Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
---
 fs/xfs/xfs_trans_ail.c | 116 +++++++++++++++++++++++------------------
 1 file changed, 64 insertions(+), 52 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 923729af4206..ac747804e1d6 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -458,6 +458,69 @@ xfs_ail_calc_push_target(
 	return target_lsn;
 }
 
+static void
+xfsaild_process_logitem(
+	struct xfs_ail		*ailp,
+	struct xfs_log_item	*lip,
+	xfs_lsn_t		lsn,
+	int			*stuck,
+	int			*flushing)
+{
+	struct xfs_mount	*mp = ailp->ail_log->l_mp;
+	int			lock_result;
+
+	/*
+	 * Note that iop_push may unlock and reacquire the AIL lock. We
+	 * rely on the AIL cursor implementation to be able to deal with
+	 * the dropped lock.
+	 */
+	lock_result = xfsaild_push_item(ailp, lip);
+	switch (lock_result) {
+	case XFS_ITEM_SUCCESS:
+		XFS_STATS_INC(mp, xs_push_ail_success);
+		trace_xfs_ail_push(lip);
+
+		ailp->ail_last_pushed_lsn = lsn;
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
+		trace_xfs_ail_flushing(lip);
+
+		(*flushing)++;
+		ailp->ail_last_pushed_lsn = lsn;
+		break;
+
+	case XFS_ITEM_PINNED:
+		XFS_STATS_INC(mp, xs_push_ail_pinned);
+		trace_xfs_ail_pinned(lip);
+
+		(*stuck)++;
+		ailp->ail_log_flush++;
+		break;
+	case XFS_ITEM_LOCKED:
+		XFS_STATS_INC(mp, xs_push_ail_locked);
+		trace_xfs_ail_locked(lip);
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
@@ -505,62 +568,11 @@ xfsaild_push(
 
 	lsn = lip->li_lsn;
 	while ((XFS_LSN_CMP(lip->li_lsn, ailp->ail_target) <= 0)) {
-		int	lock_result;
 
 		if (test_bit(XFS_LI_FLUSHING, &lip->li_flags))
 			goto next_item;
 
-		/*
-		 * Note that iop_push may unlock and reacquire the AIL lock.  We
-		 * rely on the AIL cursor implementation to be able to deal with
-		 * the dropped lock.
-		 */
-		lock_result = xfsaild_push_item(ailp, lip);
-		switch (lock_result) {
-		case XFS_ITEM_SUCCESS:
-			XFS_STATS_INC(mp, xs_push_ail_success);
-			trace_xfs_ail_push(lip);
-
-			ailp->ail_last_pushed_lsn = lsn;
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
-			trace_xfs_ail_flushing(lip);
-
-			flushing++;
-			ailp->ail_last_pushed_lsn = lsn;
-			break;
-
-		case XFS_ITEM_PINNED:
-			XFS_STATS_INC(mp, xs_push_ail_pinned);
-			trace_xfs_ail_pinned(lip);
-
-			stuck++;
-			ailp->ail_log_flush++;
-			break;
-		case XFS_ITEM_LOCKED:
-			XFS_STATS_INC(mp, xs_push_ail_locked);
-			trace_xfs_ail_locked(lip);
-
-			stuck++;
-			break;
-		default:
-			ASSERT(0);
-			break;
-		}
-
+		xfsaild_process_logitem(ailp, lip, lsn, &stuck, &flushing);
 		count++;
 
 		/*
-- 
2.50.1




Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



