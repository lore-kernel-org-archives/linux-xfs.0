Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666321A9B53;
	Thu, 19 Dec 2024 19:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636048; cv=none; b=adFaQVRVV/7zX9Huq+vJFmq/MEuSxnmlgqMKK+bF0CNK0lEm8C1ZLQ7hGSUKwFbqZDSsKJhdxSShH8hpyzI9lDL6aCZsDJmi+6kHlm3L5j6Bsb8jO2ZgdVMTRMGIgg0iTa6OnfYi/sXPcI+DBPESnJL+BiFFpsPYoXZPBw8NqJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636048; c=relaxed/simple;
	bh=EXnrut/7cp8GX1BFNcfEjeRFFG/TWYFDDVd0rm5b0Uo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VRX7fPh9DM/IfIAGJ2FfxGnhbsNUHIIVSLZatYZ2L+H2o62z7kKKpxGOKElVs5Qvh82wXnPg8/2ucl0WcZfZg2Q5I8ScR0pCR2j+MgFIQo3y7DLMc2OsLKALDBd6xiA4bNuoKV870Waa1SVa1t5O4YGWcp0obH11E3oF5ajks5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fsp4U8EW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fsp4U8EW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0982C4CECE;
	Thu, 19 Dec 2024 19:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636048;
	bh=EXnrut/7cp8GX1BFNcfEjeRFFG/TWYFDDVd0rm5b0Uo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Fsp4U8EW33mjVCVvN40yiFTfX17deOVpKkcjUMD67p3iyXMT2ZTwD3lFaXqYNSBym
	 k2gOIh7F3ppQokWfT9xb+c7x2cKQ97X2+hyO2bmZTluQD1s9HKImfiK75lkl4H5jop
	 Ed3OZ8RcaE5NLDmad/OX1rIBrCsdsrw+y4t5jOf/jpfIU9ekLUmmqfcZpmyxRz+jm3
	 a6JB6MoPZI/lz0JZSey8a8bciGjztRmmjv7JJGMzHZWMk1cxpGibIOIGEksgeeNtPw
	 yEA0nbWETycllrVzhwwTOcfTgNJbP9Hmqk5ATtJOnIyeI5VkBmPaooXmK/4U/4Fjyx
	 vJJwQmHsj8ttQ==
Date: Thu, 19 Dec 2024 11:20:47 -0800
Subject: [PATCH 2/2] xfs: release the dquot buf outside of qli_lock
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: syzbot+3126ab3db03db42e7a31@syzkaller.appspotmail.com,
 stable@vger.kernel.org,
 syzbot+3126ab3db03db42e7a31@syzkaller.appspotmail.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463578249.1570935.14851151691186464527.stgit@frogsfrogsfrogs>
In-Reply-To: <173463578212.1570935.4004660775026906039.stgit@frogsfrogsfrogs>
References: <173463578212.1570935.4004660775026906039.stgit@frogsfrogsfrogs>
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

