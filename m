Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9913D1509BD;
	Tue,  4 Feb 2025 18:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738695207; cv=none; b=NnMCCLHnmDfDNaNCd8JlKeD40B9hkO/CjrUNonL4+Rso/z6KHXX+yrphial0IePDY6cIUJYU0Z4EuS4OoMoPvb8tZs0KAcFFaAePENQWjcs1JEi99eJxvPT6xhn2FXe8odw6E5gHglOwl/WUc+LR826sKe7TE9h9OKTnrX2y41g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738695207; c=relaxed/simple;
	bh=0dpsnUeiBRsogmiTDRaqBMn1+//11clSOwauom1k8+U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U9tZYBHYsgleqF7ay3VDOUW8vFnwsfC9ttAfw+8BAR+pf9ypzQMOae6w5hYDCVNvDC8XUWCw76qQ/165sG435MH3qgvEm5TSGzQSDE6YaiKP7Ybm2Q6juUXyBxRUQKuLhdHzCAcTrY047aoHOmnpw8oU63+RS4fhwgmD+bkTlrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M2/CUvLc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M2/CUvLc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0922FC4CEDF;
	Tue,  4 Feb 2025 18:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738695207;
	bh=0dpsnUeiBRsogmiTDRaqBMn1+//11clSOwauom1k8+U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=M2/CUvLcef0yMXmrYdf1ym3QbHYX9SNkMNNL8XGG6mUJ4B41/H46amSgzDvRIvM8/
	 IvDXNWLANfaitV7fLyAb02rxTIZTF9uTsADJjQU0FvAcoeDl0y1CZfT5RavYm70mrf
	 3VVtYTfqjJ3e7u0W2KxkvAu40MXXHpKGGxqqTDkT9K/ucf6diPI80Cm7RgiyFtMFxZ
	 LTOpWq4Xl0/fML0CnA7JCsBziXotKeiKuNsyj/cUxk6/pzUQqEc2ULd7q37Rn+HFim
	 FqmJXrmt+m47ceRwXTfKa+OmLTUPCtDi6r6PJyw/4d+e0HdA5ucUZtmWdZp0dguqn8
	 aRCG6UvAgaT/A==
Date: Tue, 04 Feb 2025 10:53:26 -0800
Subject: [PATCH 09/10] xfs: release the dquot buf outside of qli_lock
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, xfs-stable@lists.linux.dev, linux-xfs@vger.kernel.org
Cc: syzbot+3126ab3db03db42e7a31@syzkaller.appspotmail.com, hch@lst.de,
 stable@vger.kernel.org
Message-ID: <173869499488.410229.13232898846294467954.stgit@frogsfrogsfrogs>
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

commit 1aacd3fac248902ea1f7607f2d12b93929a4833b upstream

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
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index d2b06ca2ec7a9c..d64d454cbe8bca 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1308,7 +1308,8 @@ xfs_dquot_read_buf(
 
 /*
  * Attach a dquot buffer to this dquot to avoid allocating a buffer during a
- * dqflush, since dqflush can be called from reclaim context.
+ * dqflush, since dqflush can be called from reclaim context.  Caller must hold
+ * the dqlock.
  */
 int
 xfs_dquot_attach_buf(
@@ -1329,13 +1330,16 @@ xfs_dquot_attach_buf(
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

