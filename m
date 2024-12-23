Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2CF7462;
	Mon, 23 Dec 2024 22:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734994443; cv=none; b=hw7nMKUIKhP9PfVbB0Ak6pBDqJLyVe0FjiPcF1jCaxQ/VZ8N2MmyDpsyxPWLCJNBZJP4lif8YgSoZRwr0I9q9Azf1+ebWG57AmO3VmI5mNVE2QUpBe/QIYauUlCqopent1mR5uOa6iuhO5Jq1uO05zCYSQu899dup9Vyg78EU5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734994443; c=relaxed/simple;
	bh=6UupUeon87UjQLmMzWBbAwsippmxgliIqnlXIEXICi8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kzpwy/kT8395MTyQTh4Jh+J62bO3/ZkZ6IhD/D8/XwsoVy77DLsvz5UWjgfUz5NhMY45LAG0uZnI9JoSHCvVvBneKn99ECBRvp+gAViSbDfcCFjQetbRJfET1eJy8k81ykuiv2LQE8L8mFsVuEmvpRUof7zw1IrjZspsLTauFuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hcU+l2CS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hcU+l2CS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F629C4CED3;
	Mon, 23 Dec 2024 22:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734994443;
	bh=6UupUeon87UjQLmMzWBbAwsippmxgliIqnlXIEXICi8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hcU+l2CSbRHttSsyupw5r7iQ7qOu16C182+dQWB9wQP5tXEvdFxZXdYnSzHN0gqev
	 Aw1cLZdVOLuWoNI6VW1iBlSuTQ24Iqr+0lJLa3oov37CfRXTfc4Uy74F6yOnuWI3Qb
	 87AFMneQ321BGJ1QR34OUFJ9uQiFGdgBn/Zqo5QeVXd2b0sqBWOxtg+4bVitJSdTof
	 ZE7J3ujHykpvlB1AXEn62jJ5bHsrdT3ZQwTenrr2oEbAUYvQfw84/TSwhct3AswwBs
	 jOGcNPAeBx7LPTlHfqxNd54stZNOaA+kqIkXxGbPmfEQUL24Zcka0qCLwat4HTEhjM
	 hqGymNAkRykKA==
Date: Mon, 23 Dec 2024 14:54:03 -0800
Subject: [PATCH 2/2] xfs: release the dquot buf outside of qli_lock
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: syzbot+3126ab3db03db42e7a31@syzkaller.appspotmail.com,
 stable@vger.kernel.org,
 syzbot+3126ab3db03db42e7a31@syzkaller.appspotmail.com, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <173499417167.2379546.16719980703926745114.stgit@frogsfrogsfrogs>
In-Reply-To: <173499417129.2379546.10223550496728939171.stgit@frogsfrogsfrogs>
References: <173499417129.2379546.10223550496728939171.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Lai Yi reported a lockdep complaint about circular locking:

 Chain exists of:
   &lp->qli_lock --> &bch->bc_lock --> &l->lock

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&l->lock);
                                lock(&bch->bc_lock);
                                lock(&l->lock);
   lock(&lp->qli_lock);

I /think/ the problem here is that xfs_dquot_attach_buf during
quotacheck will release the buffer while it's holding the qli_lock.
Because this is a cached buffer, xfs_buf_rele_cached takes b_lock before
decrementing b_hold.  Other threads have taught lockdep that a locking
dependency chain is bp->b_lock -> bch->bc_lock -> l(ru)->lock; and that
another chain is l(ru)->lock -> lp->qli_lock.  Hence we do not want to
take b_lock while holding qli_lock.

Reported-by: syzbot+3126ab3db03db42e7a31@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org> # v6.13-rc3
Fixes: ca378189fdfa89 ("xfs: convert quotacheck to attach dquot buffers")
Tested-by: syzbot+3126ab3db03db42e7a31@syzkaller.appspotmail.com
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index f11d475898f280..576b7755b1f1fc 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1315,7 +1315,8 @@ xfs_dquot_read_buf(
 
 /*
  * Attach a dquot buffer to this dquot to avoid allocating a buffer during a
- * dqflush, since dqflush can be called from reclaim context.
+ * dqflush, since dqflush can be called from reclaim context.  Caller must hold
+ * the dqlock.
  */
 int
 xfs_dquot_attach_buf(
@@ -1336,13 +1337,16 @@ xfs_dquot_attach_buf(
 			return error;
 
 		/*
-		 * Attach the dquot to the buffer so that the AIL does not have
-		 * to read the dquot buffer to push this item.
+		 * Hold the dquot buffer so that we retain our ref to it after
+		 * detaching it from the transaction, then give that ref to the
+		 * dquot log item so that the AIL does not have to read the
+		 * dquot buffer to push this item.
 		 */
 		xfs_buf_hold(bp);
+		xfs_trans_brelse(tp, bp);
+
 		spin_lock(&qlip->qli_lock);
 		lip->li_buf = bp;
-		xfs_trans_brelse(tp, bp);
 	}
 	qlip->qli_dirty = true;
 	spin_unlock(&qlip->qli_lock);

