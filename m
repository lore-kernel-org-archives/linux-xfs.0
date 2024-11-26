Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D533D531
	for <linux-xfs@vger.kernel.org>; Tue, 26 Nov 2024 01:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584580; cv=none; b=T2wrdGRGiYcXarbsg6EQEMpGg08sclfBScCpokuSJsgAZ+3P+0AgxNIh12i4K2o9S7sUdHOAt9zhpQqIy59DeDj9VdITTHhAuwdnRskwFC2wr/Mvaqc1Wx1f6bK36Q8kOkALFEd4f0nGUWZH0r34q1UGoyYg/W1b6RLRZOqgU9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584580; c=relaxed/simple;
	bh=9XEqeucVOzgibdufI0pmJr9ghGoD5zeYFVoGtKEkOuc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a0NaqoASF2sPT27219PdoVnfkVWSKPoECSPAv/DWFeuhh55fJr3Sag9CCH1G3Ai6bPR8XhbHpTMIokmHzMK9sFdXMjZamHXoeBdSu1kxtN6it595AKcjs93GXRIdQSgvyMpslcpP8b5sZDKTl1ZzYD4jz1DxDo5X5i7bfyCSiPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P+mIVVkO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P+mIVVkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574FBC4CECE;
	Tue, 26 Nov 2024 01:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584580;
	bh=9XEqeucVOzgibdufI0pmJr9ghGoD5zeYFVoGtKEkOuc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=P+mIVVkOmERnvj2U+o8SxL/5wnpap/W0SRIaknGuz12P963P3667VF00/B5XbLXmU
	 dTE+JIWVgm7g0a4IkqRsAjmZCrACfrZIGSPSDX9sZ2sVkpmzWPuvegkXH4Z6y2ig9x
	 S4mUraLePirT7dG9chLIbm/P9bkVCoT/XIyhvhSBPIMXhOZ4oy7be58FLzRK7cYUOE
	 THsLQsQJu1tZeoVWzsf7pc8InswHXm+L1PdHfC2Cm/l4+9L5/qJzPCfNSWSYXiBzTh
	 t2JWXWUocgSds9nbpXhd70lNCiToVGXiu90V1LKDwlOQLF/Jr3zUGhmaC4grsuszD2
	 HdLwYvdaGJ7/g==
Date: Mon, 25 Nov 2024 17:29:39 -0800
Subject: [PATCH 19/21] xfs: clean up log item accesses in
 xfs_qm_dqflush{,_done}
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173258398125.4032920.10688788085648644743.stgit@frogsfrogsfrogs>
In-Reply-To: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Clean up these functions a little bit before we move on to the real
modifications, and make the variable naming consistent for dquot log
items.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_dquot.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 6ec4087e38dfc8..4ba042786cfb7b 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1142,8 +1142,9 @@ static void
 xfs_qm_dqflush_done(
 	struct xfs_log_item	*lip)
 {
-	struct xfs_dq_logitem	*qip = (struct xfs_dq_logitem *)lip;
-	struct xfs_dquot	*dqp = qip->qli_dquot;
+	struct xfs_dq_logitem	*qlip =
+			container_of(lip, struct xfs_dq_logitem, qli_item);
+	struct xfs_dquot	*dqp = qlip->qli_dquot;
 	struct xfs_ail		*ailp = lip->li_ailp;
 	xfs_lsn_t		tail_lsn;
 
@@ -1156,12 +1157,12 @@ xfs_qm_dqflush_done(
 	 * holding the lock before removing the dquot from the AIL.
 	 */
 	if (test_bit(XFS_LI_IN_AIL, &lip->li_flags) &&
-	    ((lip->li_lsn == qip->qli_flush_lsn) ||
+	    ((lip->li_lsn == qlip->qli_flush_lsn) ||
 	     test_bit(XFS_LI_FAILED, &lip->li_flags))) {
 
 		spin_lock(&ailp->ail_lock);
 		xfs_clear_li_failed(lip);
-		if (lip->li_lsn == qip->qli_flush_lsn) {
+		if (lip->li_lsn == qlip->qli_flush_lsn) {
 			/* xfs_ail_update_finish() drops the AIL lock */
 			tail_lsn = xfs_ail_delete_one(ailp, lip);
 			xfs_ail_update_finish(ailp, tail_lsn);
@@ -1319,7 +1320,7 @@ xfs_qm_dqflush(
 	dqp->q_flags &= ~XFS_DQFLAG_DIRTY;
 
 	xfs_trans_ail_copy_lsn(mp->m_ail, &dqp->q_logitem.qli_flush_lsn,
-					&dqp->q_logitem.qli_item.li_lsn);
+			&lip->li_lsn);
 
 	/*
 	 * copy the lsn into the on-disk dquot now while we have the in memory
@@ -1331,7 +1332,7 @@ xfs_qm_dqflush(
 	 * of a dquot without an up-to-date CRC getting to disk.
 	 */
 	if (xfs_has_crc(mp)) {
-		dqblk->dd_lsn = cpu_to_be64(dqp->q_logitem.qli_item.li_lsn);
+		dqblk->dd_lsn = cpu_to_be64(lip->li_lsn);
 		xfs_update_cksum((char *)dqblk, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF);
 	}
@@ -1341,7 +1342,7 @@ xfs_qm_dqflush(
 	 * the AIL and release the flush lock once the dquot is synced to disk.
 	 */
 	bp->b_flags |= _XBF_DQUOTS;
-	list_add_tail(&dqp->q_logitem.qli_item.li_bio_list, &bp->b_li_list);
+	list_add_tail(&lip->li_bio_list, &bp->b_li_list);
 
 	/*
 	 * If the buffer is pinned then push on the log so we won't

