Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F686AD7
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 05:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712121513; cv=none; b=aT7ASZZoiphuEQoJ6hswSgc6OqLNztCMHHD1NNfynTjUBjAtyhUaB1Q8NH0S6zhBMOYygn8/C0Jv+pXREIRUzmPDqjcemdq+cWVAiqmBF74T+dW1bBKprvvVhcOjVRTcKzLK2I0qWi71bu7PfjFmddxsNVZyq4OzZNfvD4+JAs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712121513; c=relaxed/simple;
	bh=Se2nXJCcT4sawSe+jwQtnM+VYLCUul4VhyRIPFuWVOc=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hQ3yFEKJoA7diQEJw7pUTZYOWGiIU9aSUD6qIJrDj8/mZuJ2NHqGTIRqmi+nfcWT9rk0H2+zdJ4xgr3nIKGkyoEizR6MGS/clKx64dr1G+57g7b9lvZnaPzz8RbTTIp+TVT6cH4Mems1OUtzZCpQ3UPUhgjOqHaE9GlQB9XQnpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WYauV48I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WYauV48I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7EEC433F1;
	Wed,  3 Apr 2024 05:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712121512;
	bh=Se2nXJCcT4sawSe+jwQtnM+VYLCUul4VhyRIPFuWVOc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=WYauV48IUUriUGNF+3FvTND6lx9Iu/J8v6xhTW4s2yU0Rt3j9wDW7eTJX84zP1Mpp
	 LIf/seP+VYgcN7K2+gWUBlgt4dgmDhYPe4btRYBl/9E3o0rqUxXxjkgKRlUc7nQYXn
	 EcUqsU1Pz+zDmiY9ERSg196/vJfzcSDFO3L8/Qk0Iu67oBhEP5Yu2fuyNLTBeOrP21
	 /BTBdg4llYK7Bl/ZTB6HLVnFwU4GTtj4ZfL2yr+0dVVH8L2cY9oCwOlW+IjIS3SEpa
	 o/NTr7Pzax9Cj9Xwohuua86hkQvCWx1SJQSk++fPGFWbuNYsLy0xb9LULUn8erTBtl
	 I2m2KkskT8Alw==
Subject: [PATCH 2/3] xfs: fix an AGI lock acquisition ordering problem in
 xrep_dinode_findmode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Date: Tue, 02 Apr 2024 22:18:31 -0700
Message-ID: <171212151192.1535150.13198476701217286884.stgit@frogsfrogsfrogs>
In-Reply-To: <171212150033.1535150.8307366470561747407.stgit@frogsfrogsfrogs>
References: <171212150033.1535150.8307366470561747407.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

While reviewing the next patch which fixes an ABBA deadlock between the
AGI and a directory ILOCK, someone asked a question about why we're
holding the AGI in the first place.  The reason for that is to quiesce
the inode structures for that AG while we do a repair.

I then realized that the xrep_dinode_findmode invokes xchk_iscan_iter,
which walks the inobts (and hence the AGIs) to find all the inodes.
This itself is also an ABBA vector, since the damaged inode could be in
AG 5, which we hold while we scan AG 0 for directories.  5 -> 0 is not
allowed.

To address this, modify the iscan to allow trylock of the AGI buffer
using the flags argument to xfs_ialloc_read_agi that the previous patch
added.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/inode_repair.c |    1 +
 fs/xfs/scrub/iscan.c        |   36 +++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/iscan.h        |   15 +++++++++++++++
 fs/xfs/scrub/trace.h        |   10 ++++++++--
 4 files changed, 59 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index eab380e95ef40..35da0193c919e 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -356,6 +356,7 @@ xrep_dinode_find_mode(
 	 * so there's a real possibility that _iscan_iter can return EBUSY.
 	 */
 	xchk_iscan_start(sc, 5000, 100, &ri->ftype_iscan);
+	xchk_iscan_set_agi_trylock(&ri->ftype_iscan);
 	ri->ftype_iscan.skip_ino = sc->sm->sm_ino;
 	ri->alleged_ftype = XFS_DIR3_FT_UNKNOWN;
 	while ((error = xchk_iscan_iter(&ri->ftype_iscan, &dp)) == 1) {
diff --git a/fs/xfs/scrub/iscan.c b/fs/xfs/scrub/iscan.c
index 66ba0fbd059e0..736ce7c9de6a8 100644
--- a/fs/xfs/scrub/iscan.c
+++ b/fs/xfs/scrub/iscan.c
@@ -243,6 +243,40 @@ xchk_iscan_finish(
 	mutex_unlock(&iscan->lock);
 }
 
+/*
+ * Grab the AGI to advance the inode scan.  Returns 0 if *agi_bpp is now set,
+ * -ECANCELED if the live scan aborted, -EBUSY if the AGI could not be grabbed,
+ * or the usual negative errno.
+ */
+STATIC int
+xchk_iscan_read_agi(
+	struct xchk_iscan	*iscan,
+	struct xfs_perag	*pag,
+	struct xfs_buf		**agi_bpp)
+{
+	struct xfs_scrub	*sc = iscan->sc;
+	unsigned long		relax;
+	int			ret;
+
+	if (!xchk_iscan_agi_trylock(iscan))
+		return xfs_ialloc_read_agi(pag, sc->tp, 0, agi_bpp);
+
+	relax = msecs_to_jiffies(iscan->iget_retry_delay);
+	do {
+		ret = xfs_ialloc_read_agi(pag, sc->tp, XFS_IALLOC_FLAG_TRYLOCK,
+				agi_bpp);
+		if (ret != -EAGAIN)
+			return ret;
+		if (!iscan->iget_timeout ||
+		    time_is_before_jiffies(iscan->__iget_deadline))
+			return -EBUSY;
+
+		trace_xchk_iscan_agi_retry_wait(iscan);
+	} while (!schedule_timeout_killable(relax) &&
+		 !xchk_iscan_aborted(iscan));
+	return -ECANCELED;
+}
+
 /*
  * Advance ino to the next inode that the inobt thinks is allocated, being
  * careful to jump to the next AG if we've reached the right end of this AG's
@@ -281,7 +315,7 @@ xchk_iscan_advance(
 		if (!pag)
 			return -ECANCELED;
 
-		ret = xfs_ialloc_read_agi(pag, sc->tp, 0, &agi_bp);
+		ret = xchk_iscan_read_agi(iscan, pag, &agi_bp);
 		if (ret)
 			goto out_pag;
 
diff --git a/fs/xfs/scrub/iscan.h b/fs/xfs/scrub/iscan.h
index 71f657552dfac..c9da8f7721f66 100644
--- a/fs/xfs/scrub/iscan.h
+++ b/fs/xfs/scrub/iscan.h
@@ -59,6 +59,9 @@ struct xchk_iscan {
 /* Set if the scan has been aborted due to some event in the fs. */
 #define XCHK_ISCAN_OPSTATE_ABORTED	(1)
 
+/* Use trylock to acquire the AGI */
+#define XCHK_ISCAN_OPSTATE_TRYLOCK_AGI	(2)
+
 static inline bool
 xchk_iscan_aborted(const struct xchk_iscan *iscan)
 {
@@ -71,6 +74,18 @@ xchk_iscan_abort(struct xchk_iscan *iscan)
 	set_bit(XCHK_ISCAN_OPSTATE_ABORTED, &iscan->__opstate);
 }
 
+static inline bool
+xchk_iscan_agi_trylock(const struct xchk_iscan *iscan)
+{
+	return test_bit(XCHK_ISCAN_OPSTATE_TRYLOCK_AGI, &iscan->__opstate);
+}
+
+static inline void
+xchk_iscan_set_agi_trylock(struct xchk_iscan *iscan)
+{
+	set_bit(XCHK_ISCAN_OPSTATE_TRYLOCK_AGI, &iscan->__opstate);
+}
+
 void xchk_iscan_start(struct xfs_scrub *sc, unsigned int iget_timeout,
 		unsigned int iget_retry_delay, struct xchk_iscan *iscan);
 void xchk_iscan_teardown(struct xchk_iscan *iscan);
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 5b294be52c558..b1c7c79760d44 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1300,7 +1300,7 @@ TRACE_EVENT(xchk_iscan_iget_batch,
 		  __entry->unavail)
 );
 
-TRACE_EVENT(xchk_iscan_iget_retry_wait,
+DECLARE_EVENT_CLASS(xchk_iscan_retry_wait_class,
 	TP_PROTO(struct xchk_iscan *iscan),
 	TP_ARGS(iscan),
 	TP_STRUCT__entry(
@@ -1326,7 +1326,13 @@ TRACE_EVENT(xchk_iscan_iget_retry_wait,
 		  __entry->remaining,
 		  __entry->iget_timeout,
 		  __entry->retry_delay)
-);
+)
+#define DEFINE_ISCAN_RETRY_WAIT_EVENT(name) \
+DEFINE_EVENT(xchk_iscan_retry_wait_class, name, \
+	TP_PROTO(struct xchk_iscan *iscan), \
+	TP_ARGS(iscan))
+DEFINE_ISCAN_RETRY_WAIT_EVENT(xchk_iscan_iget_retry_wait);
+DEFINE_ISCAN_RETRY_WAIT_EVENT(xchk_iscan_agi_retry_wait);
 
 TRACE_EVENT(xchk_nlinks_collect_dirent,
 	TP_PROTO(struct xfs_mount *mp, struct xfs_inode *dp,

