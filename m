Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F02157A61
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224292; cv=none; b=TOadUkctV2XhEEXin3cUJ0+zLzd2GQ2YEEVZpVJWzFvtEa1t4NeRGNdjHpiilswN0aznwRU5qQgzulvjbwJgizwbycdkRKkV56W6qPKbEgwRAqHChVWtln6df98p/f/f86+9dASi0cX9SPC3TjDlA7wgZFMxt8hjsLL1+G0vYCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224292; c=relaxed/simple;
	bh=LrxIOPHRXV5JyZmaYFoor3+NPTVnOKvMLfZZ8bPSTJg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NcaQmr2avwkkf3LLZuC9OjLsLqGgomIOXmrW3MVV7p5DXl7ZnOG60bN3lINCjRpbGd0yvb/Xvr8iqO0twN9sfYD2TQaPCarLdxv+ya9tYJOfrgwo68fIAwp8QWYWD75lONkn0LNEMe3wtfbmWTs5NCg0chD7C52NDNGooO8xzNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OGrNtd3B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OGrNtd3B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EACAC113CC;
	Mon, 15 Apr 2024 23:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713224292;
	bh=LrxIOPHRXV5JyZmaYFoor3+NPTVnOKvMLfZZ8bPSTJg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OGrNtd3Bech7CzC0p66c5fGMWQwv3Ip3FnuGjtN/vpD+hBDCealz9LvLOZMbN9+TM
	 m38bSkemMhFm1X5/bGlDpoL9uxlRZD7kMe1h7459uDBIz78q1D6YMr5iOd+WXg6ROs
	 bls2rtxhFt5yjtudVRlava2HCjcQCpLyXVbFU3D7SkX9IRd20q7Sr8dr+vVnCTi7X9
	 Yj2btCuLqYQ1xSbPNk9G5thJrLYrZ/Wy576CLLrjtDDb4knde4kSSuXVCF4LWf6CfE
	 l3sWAq9m/ee/ezCjqvooBOoHssqDZqLhOFdkFU4pSjmJQ9stSe2Q7wJEGeNI2zIOdb
	 zH3DndCBXpolg==
Date: Mon, 15 Apr 2024 16:38:11 -0700
Subject: [PATCH 2/5] xfs: fix an AGI lock acquisition ordering problem in
 xrep_dinode_findmode
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322380337.86847.1946985581059465446.stgit@frogsfrogsfrogs>
In-Reply-To: <171322380288.86847.5430338887776337667.stgit@frogsfrogsfrogs>
References: <171322380288.86847.5430338887776337667.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/inode_repair.c |    1 +
 fs/xfs/scrub/iscan.c        |   36 +++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/iscan.h        |   15 +++++++++++++++
 fs/xfs/scrub/trace.h        |   10 ++++++++--
 4 files changed, 59 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index eab380e95ef4..35da0193c919 100644
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
index 66ba0fbd059e..c643b7d79b60 100644
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
+	if (!xchk_iscan_agi_needs_trylock(iscan))
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
index 71f657552dfa..5e0e4ed9dea6 100644
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
+xchk_iscan_agi_needs_trylock(const struct xchk_iscan *iscan)
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
index 5b294be52c55..b1c7c79760d4 100644
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

