Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF52A8F7D;
	Tue, 26 Nov 2024 01:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584611; cv=none; b=g6UglF/y6sGcfi4NKwj+VfKhi2E2CgiHOrJ75lFRVtf0GMjQ0HR9m3atL0UDGyGCNIRDnV/ulQEQIto3sQqg51uR751263M+jqC6cIE8iOKxtwjY+B4kiSZbAwvNFYQiASFtPZmIpNNoJ8quwPM4XpXCLeZqxKcmZGPV1k//fpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584611; c=relaxed/simple;
	bh=HK5b8pvSZdRSIviaWqNiHWzdphi33f6n7p6eh1jC4o8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hcfiCFZJvJ+umLdel+cgPGP2k9adS3Ej4osp/a9BYo7Szhgn3G3AmYyh7kSGF6+tJKUZuy/3+Fp9HtwYfzJb+Zjqpi25/+w5pq946wmYkTWD7ljAI/QU7m7v9uFGvngLOXXe5OPltfZT6bnoxirWTaUlP4yGCFeeFRZgnRM/Qd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gEqDbxkB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gEqDbxkB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89923C4CECE;
	Tue, 26 Nov 2024 01:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584611;
	bh=HK5b8pvSZdRSIviaWqNiHWzdphi33f6n7p6eh1jC4o8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gEqDbxkBaR/ldjuFZ0/6thiUPyST/s2+hzLoRO1pVJFEQw+1guaTZ5Oz81SC4YNHo
	 9ZXk41onAqlZ1b10v0Omfisqib0Z1WpHnWBN23rzERmnO2akv9LYWjlLbCoo5OiC2M
	 LsdGKqdOh1WS8E2Y6N27Ll0P8Aog6Pix+gTus2x/gePLcatqTGXBQXqbCdwpZUuHz5
	 YXVn0/38I+ECXbLqjCdsGUTWx/aoMz52Ysjg3So5cMCQoZIQ96YFYgIc7mUGoblJ4j
	 77WE5qPKTW7wamr9N4oBxo0Lltk25MVd589WagBEa95cTSjRXTj30NgTvr/Eospytk
	 si4b8xCtwusiQ==
Date: Mon, 25 Nov 2024 17:30:11 -0800
Subject: [PATCH 21/21] xfs: convert quotacheck to attach dquot buffers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173258398160.4032920.3728172117282478382.stgit@frogsfrogsfrogs>
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

Now that we've converted the dquot logging machinery to attach the dquot
buffer to the li_buf pointer so that the AIL dqflush doesn't have to
allocate or read buffers in a reclaim path, do the same for the
quotacheck code so that the reclaim shrinker dqflush call doesn't have
to do that either.

Cc: <stable@vger.kernel.org> # v6.12
Fixes: 903edea6c53f09 ("mm: warn about illegal __GFP_NOFAIL usage in a more appropriate location and manner")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_dquot.c |    9 +++------
 fs/xfs/xfs_dquot.h |    2 --
 fs/xfs/xfs_qm.c    |   18 +++++++++++++-----
 3 files changed, 16 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index c495f7ad80018f..c47f95c96fe0cf 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1275,11 +1275,10 @@ xfs_qm_dqflush_check(
  * Requires dquot flush lock, will clear the dirty flag, delete the quota log
  * item from the AIL, and shut down the system if something goes wrong.
  */
-int
+static int
 xfs_dquot_read_buf(
 	struct xfs_trans	*tp,
 	struct xfs_dquot	*dqp,
-	xfs_buf_flags_t		xbf_flags,
 	struct xfs_buf		**bpp)
 {
 	struct xfs_mount	*mp = dqp->q_mount;
@@ -1287,10 +1286,8 @@ xfs_dquot_read_buf(
 	int			error;
 
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, dqp->q_blkno,
-				   mp->m_quotainfo->qi_dqchunklen, xbf_flags,
+				   mp->m_quotainfo->qi_dqchunklen, 0,
 				   &bp, &xfs_dquot_buf_ops);
-	if (error == -EAGAIN)
-		return error;
 	if (xfs_metadata_is_sick(error))
 		xfs_dquot_mark_sick(dqp);
 	if (error)
@@ -1324,7 +1321,7 @@ xfs_dquot_attach_buf(
 		struct xfs_buf	*bp = NULL;
 
 		spin_unlock(&qlip->qli_lock);
-		error = xfs_dquot_read_buf(tp, dqp, 0, &bp);
+		error = xfs_dquot_read_buf(tp, dqp, &bp);
 		if (error)
 			return error;
 
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 362ca34f7c248b..1c5c911615bf7f 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -214,8 +214,6 @@ void xfs_dquot_to_disk(struct xfs_disk_dquot *ddqp, struct xfs_dquot *dqp);
 #define XFS_DQ_IS_DIRTY(dqp)	((dqp)->q_flags & XFS_DQFLAG_DIRTY)
 
 void		xfs_qm_dqdestroy(struct xfs_dquot *dqp);
-int		xfs_dquot_read_buf(struct xfs_trans *tp, struct xfs_dquot *dqp,
-				xfs_buf_flags_t flags, struct xfs_buf **bpp);
 int		xfs_qm_dqflush(struct xfs_dquot *dqp, struct xfs_buf *bp);
 void		xfs_qm_dqunpin_wait(struct xfs_dquot *dqp);
 void		xfs_qm_adjust_dqtimers(struct xfs_dquot *d);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index a79c4a1bf27fab..e073ad51af1a3d 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -148,13 +148,13 @@ xfs_qm_dqpurge(
 		 * We don't care about getting disk errors here. We need
 		 * to purge this dquot anyway, so we go ahead regardless.
 		 */
-		error = xfs_dquot_read_buf(NULL, dqp, XBF_TRYLOCK, &bp);
+		error = xfs_dquot_use_attached_buf(dqp, &bp);
 		if (error == -EAGAIN) {
 			xfs_dqfunlock(dqp);
 			dqp->q_flags &= ~XFS_DQFLAG_FREEING;
 			goto out_unlock;
 		}
-		if (error)
+		if (!bp)
 			goto out_funlock;
 
 		/*
@@ -506,8 +506,8 @@ xfs_qm_dquot_isolate(
 		/* we have to drop the LRU lock to flush the dquot */
 		spin_unlock(lru_lock);
 
-		error = xfs_dquot_read_buf(NULL, dqp, XBF_TRYLOCK, &bp);
-		if (error) {
+		error = xfs_dquot_use_attached_buf(dqp, &bp);
+		if (!bp || error == -EAGAIN) {
 			xfs_dqfunlock(dqp);
 			goto out_unlock_dirty;
 		}
@@ -1330,6 +1330,10 @@ xfs_qm_quotacheck_dqadjust(
 		return error;
 	}
 
+	error = xfs_dquot_attach_buf(NULL, dqp);
+	if (error)
+		return error;
+
 	trace_xfs_dqadjust(dqp);
 
 	/*
@@ -1512,9 +1516,13 @@ xfs_qm_flush_one(
 		goto out_unlock;
 	}
 
-	error = xfs_dquot_read_buf(NULL, dqp, XBF_TRYLOCK, &bp);
+	error = xfs_dquot_use_attached_buf(dqp, &bp);
 	if (error)
 		goto out_unlock;
+	if (!bp) {
+		error = -EFSCORRUPTED;
+		goto out_unlock;
+	}
 
 	error = xfs_qm_dqflush(dqp, bp);
 	if (!error)

