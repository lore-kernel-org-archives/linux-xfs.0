Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75B4218AB5;
	Tue,  4 Feb 2025 18:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738695144; cv=none; b=Zk8LYXzc2SFVn1LV1MaAo9/911MOdJpdADY6tdLEmrQwEKgmxN52jUy8MJBuDH3uCcnf0pJHqKgUt7bWj/DXfQzItS9kPfX3FT41Yygdn5vFRQaRYuSdvxRNoPyIOArFO81WBQwe7CqD5NZw5vXmEzsF8YIJ+FdR3p0rn3o5eKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738695144; c=relaxed/simple;
	bh=pDiCFKmVT8F/FtxMm6fLl3R1XtRDH1QMV/dkDJdKu9A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XHcDT537LmQ5RwntCyNfHsU2seMjJigu//wFa67BtbZWdBegB8kfSCJuuRqi0RUtHU9XnoLFP/UBmmKGkB0mYizRuZAs375TsDdZBTSAtAl3ssho93KmK4Tgx3ccr79nTJMOKKzmVaZYPHKnNTZUzihLyFqkicff81fAScPB4Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rkhL8EfG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rkhL8EfG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C98C4CEDF;
	Tue,  4 Feb 2025 18:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738695144;
	bh=pDiCFKmVT8F/FtxMm6fLl3R1XtRDH1QMV/dkDJdKu9A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rkhL8EfGe3ysFxzv9u9ZckkexsqNPjF9hSeLb32R+OZnsFzas9Ddsjo4I71UrDV0N
	 xcJX3OUUAxxsecq0mviBQ/vShH0N9HmFHw4qB5K+fWHsIa0rTz3xUe0sXVoiCi0TiB
	 bkQb4I4TnP4l+l4ibuJjtjOLvKhrVGSz1FkBfxOq1HIcZaYBlKxNWPAjY3djz6J3ud
	 X5zJIz34A8Br8siQrAoImt240r2NaiuX+l9pdRqYe/WzRbdOKHJ5MqVsOT5fSa1fkA
	 T6bF2EZDccolSTyqVyDNZoWv1Blzfc3LnVWMTHTXtpwuhkeaJ/0AZdTfbZp9i1svPW
	 u9hHfiV5SuL8Q==
Date: Tue, 04 Feb 2025 10:52:24 -0800
Subject: [PATCH 05/10] xfs: clean up log item accesses in
 xfs_qm_dqflush{,_done}
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, xfs-stable@lists.linux.dev, linux-xfs@vger.kernel.org
Cc: hch@lst.de, stable@vger.kernel.org
Message-ID: <173869499422.410229.9863498724888167626.stgit@frogsfrogsfrogs>
In-Reply-To: <173869499323.410229.9898612619797978336.stgit@frogsfrogsfrogs>
References: <173869499323.410229.9898612619797978336.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

commit ec88b41b932d5731291dcc0d0d63ea13ab8e07d5 upstream

Clean up these functions a little bit before we move on to the real
modifications, and make the variable naming consistent for dquot log items.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 5c4ede3e0fc70d..4f8fd1fa94dae2 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1136,8 +1136,9 @@ static void
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
 
@@ -1150,12 +1151,12 @@ xfs_qm_dqflush_done(
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
@@ -1313,7 +1314,7 @@ xfs_qm_dqflush(
 	dqp->q_flags &= ~XFS_DQFLAG_DIRTY;
 
 	xfs_trans_ail_copy_lsn(mp->m_ail, &dqp->q_logitem.qli_flush_lsn,
-					&dqp->q_logitem.qli_item.li_lsn);
+			&lip->li_lsn);
 
 	/*
 	 * copy the lsn into the on-disk dquot now while we have the in memory
@@ -1325,7 +1326,7 @@ xfs_qm_dqflush(
 	 * of a dquot without an up-to-date CRC getting to disk.
 	 */
 	if (xfs_has_crc(mp)) {
-		dqblk->dd_lsn = cpu_to_be64(dqp->q_logitem.qli_item.li_lsn);
+		dqblk->dd_lsn = cpu_to_be64(lip->li_lsn);
 		xfs_update_cksum((char *)dqblk, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF);
 	}
@@ -1335,7 +1336,7 @@ xfs_qm_dqflush(
 	 * the AIL and release the flush lock once the dquot is synced to disk.
 	 */
 	bp->b_flags |= _XBF_DQUOTS;
-	list_add_tail(&dqp->q_logitem.qli_item.li_bio_list, &bp->b_li_list);
+	list_add_tail(&lip->li_bio_list, &bp->b_li_list);
 
 	/*
 	 * If the buffer is pinned then push on the log so we won't

