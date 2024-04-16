Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032D15227
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713231514; cv=none; b=RPKK4X7WpkOVzz78etAIDwdQpL5UM3yItvpjM6mKpNyqWlAMcuiu9/vU1cy8aLnDV4Rdb2Ejf3qTeibTQgPFwRBMCFmUc1r95dTIOZ65YhzHgeWF81QAlKbIpPqmAH6F5/R5xQVDN8tcO4nYSqS+yeMDbFsOVPw2Lv3mRa+SEV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713231514; c=relaxed/simple;
	bh=lf641bR2nGki5UOLidLnZb7sJyyLHGQNxwKgf8hiOYg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QTyk8Bqln8vE7XZyvmdOWi3O/jPJwYoS9Fr+BNi4+7drgYSWmk2t3QVJ2fWFP+kmBremmPRCfbymqoxon9fXqyxQe0E43E7XzCw0z7qq4ode9nUKSd8sETRH2j48uUBM1CH+R4gy5jn+3MQIAw1gwztIyHhxCtC7Br/Fpjofdc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FIYPZb8O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FIYPZb8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6B7C113CC;
	Tue, 16 Apr 2024 01:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713231513;
	bh=lf641bR2nGki5UOLidLnZb7sJyyLHGQNxwKgf8hiOYg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FIYPZb8Oay3A5WIZtYIck3Wyk2fuVHcpowlM2Bv3pTFROXvQa9qMtcyPoIFsfkyP2
	 uTmCm8RdJL1E3Wx3uiHe9Rf/Kbec1YFAvcHo8Gx3BxvzwAcWSM5l4RK2G1d7cd+mAH
	 CXL99VaILxUvlI0rN/jl5DBmQGZ+UAU71iToXOHhpujk3rSOc0fka9Aa6o7iQYS6tu
	 CFm1U4Z+XKl0PyV3Zkmi9VePsJaEmlkM6sbPaVHNXElEyLyfHXtNRIHsM+Vvp8On7U
	 vQ327iHoC0qOkV5UIYS0P8xCs/a6lPc0Syjug9OYsNCE+zO20yIvQZsKYqNul2TmeF
	 f5ijG6JotXU8w==
Date: Mon, 15 Apr 2024 18:38:33 -0700
Subject: [PATCH 10/17] xfs: implement live updates for parent pointer repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, allison.henderson@oracle.com,
 hch@infradead.org, linux-xfs@vger.kernel.org, catherine.hoang@oracle.com,
 hch@lst.de
Message-ID: <171323029346.253068.16910470222703212133.stgit@frogsfrogsfrogs>
In-Reply-To: <171323029141.253068.12138115574003345390.stgit@frogsfrogsfrogs>
References: <171323029141.253068.12138115574003345390.stgit@frogsfrogsfrogs>
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

While we're scanning the filesystem for dirents that we can turn into
parent pointers, we cannot hold the IOLOCK or ILOCK of the file being
repaired.  Therefore, we need to set up a dirent hook so that we can
keep the temporary file's parent pionters up to date with the rest of
the filesystem.  Hence we add the ability to *remove* pptrs from the
temporary file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/parent_repair.c |  103 ++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/trace.h         |    2 +
 2 files changed, 100 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index b4084a9f0e9c8..311bc7990d7c7 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -70,6 +70,12 @@
  * disrupt attrmulti cursors.
  */
 
+/* Create a parent pointer in the tempfile. */
+#define XREP_PPTR_ADD		(1)
+
+/* Remove a parent pointer from the tempfile. */
+#define XREP_PPTR_REMOVE	(2)
+
 /* A stashed parent pointer update. */
 struct xrep_pptr {
 	/* Cookie for retrieval of the pptr name. */
@@ -80,6 +86,9 @@ struct xrep_pptr {
 
 	/* Length of the pptr name. */
 	uint8_t			namelen;
+
+	/* XREP_PPTR_{ADD,REMOVE} */
+	uint8_t			action;
 };
 
 /*
@@ -225,11 +234,25 @@ xrep_parent_replay_update(
 {
 	struct xfs_scrub	*sc = rp->sc;
 
-	/* Create parent pointer. */
-	trace_xrep_parent_replay_parentadd(sc->tempip, xname, &pptr->pptr_rec);
+	switch (pptr->action) {
+	case XREP_PPTR_ADD:
+		/* Create parent pointer. */
+		trace_xrep_parent_replay_parentadd(sc->tempip, xname,
+				&pptr->pptr_rec);
 
-	return xfs_parent_set(sc->tempip, sc->ip->i_ino, xname,
-			&pptr->pptr_rec, &rp->pptr_args);
+		return xfs_parent_set(sc->tempip, sc->ip->i_ino, xname,
+				&pptr->pptr_rec, &rp->pptr_args);
+	case XREP_PPTR_REMOVE:
+		/* Remove parent pointer. */
+		trace_xrep_parent_replay_parentremove(sc->tempip, xname,
+				&pptr->pptr_rec);
+
+		return xfs_parent_unset(sc->tempip, sc->ip->i_ino, xname,
+				&pptr->pptr_rec, &rp->pptr_args);
+	}
+
+	ASSERT(0);
+	return -EIO;
 }
 
 /*
@@ -290,6 +313,7 @@ xrep_parent_stash_parentadd(
 	const struct xfs_inode	*dp)
 {
 	struct xrep_pptr	pptr = {
+		.action		= XREP_PPTR_ADD,
 		.namelen	= name->len,
 	};
 	int			error;
@@ -304,6 +328,32 @@ xrep_parent_stash_parentadd(
 	return xfarray_append(rp->pptr_recs, &pptr);
 }
 
+/*
+ * Remember that we want to remove a parent pointer from the tempfile.  These
+ * stashed actions will be replayed later.
+ */
+STATIC int
+xrep_parent_stash_parentremove(
+	struct xrep_parent	*rp,
+	const struct xfs_name	*name,
+	const struct xfs_inode	*dp)
+{
+	struct xrep_pptr	pptr = {
+		.action		= XREP_PPTR_REMOVE,
+		.namelen	= name->len,
+	};
+	int			error;
+
+	trace_xrep_parent_stash_parentremove(rp->sc->tempip, dp, name);
+
+	xfs_inode_to_parent_rec(&pptr.pptr_rec, dp);
+	error = xfblob_storename(rp->pptr_names, &pptr.name_cookie, name);
+	if (error)
+		return error;
+
+	return xfarray_append(rp->pptr_recs, &pptr);
+}
+
 /*
  * Examine an entry of a directory.  If this dirent leads us back to the file
  * whose parent pointers we're rebuilding, add a pptr to the temporary
@@ -513,6 +563,48 @@ xrep_parent_scan_dirtree(
 	return 0;
 }
 
+/*
+ * Capture dirent updates being made by other threads which are relevant to the
+ * file being repaired.
+ */
+STATIC int
+xrep_parent_live_update(
+	struct notifier_block		*nb,
+	unsigned long			action,
+	void				*data)
+{
+	struct xfs_dir_update_params	*p = data;
+	struct xrep_parent		*rp;
+	struct xfs_scrub		*sc;
+	int				error;
+
+	rp = container_of(nb, struct xrep_parent, pscan.dhook.dirent_hook.nb);
+	sc = rp->sc;
+
+	/*
+	 * This thread updated a dirent that points to the file that we're
+	 * repairing, so stash the update for replay against the temporary
+	 * file.
+	 */
+	if (p->ip->i_ino == sc->ip->i_ino &&
+	    xchk_iscan_want_live_update(&rp->pscan.iscan, p->dp->i_ino)) {
+		mutex_lock(&rp->pscan.lock);
+		if (p->delta > 0)
+			error = xrep_parent_stash_parentadd(rp, p->name, p->dp);
+		else
+			error = xrep_parent_stash_parentremove(rp, p->name,
+					p->dp);
+		mutex_unlock(&rp->pscan.lock);
+		if (error)
+			goto out_abort;
+	}
+
+	return NOTIFY_DONE;
+out_abort:
+	xchk_iscan_abort(&rp->pscan.iscan);
+	return NOTIFY_DONE;
+}
+
 /* Reset a directory's dotdot entry, if needed. */
 STATIC int
 xrep_parent_reset_dotdot(
@@ -684,7 +776,8 @@ xrep_parent_setup_scan(
 	if (error)
 		goto out_recs;
 
-	error = xrep_findparent_scan_start(sc, &rp->pscan);
+	error = __xrep_findparent_scan_start(sc, &rp->pscan,
+			xrep_parent_live_update);
 	if (error)
 		goto out_names;
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 10c2a8d10058b..3e0cd482379c6 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2821,6 +2821,7 @@ DEFINE_EVENT(xrep_pptr_class, name, \
 DEFINE_XREP_PPTR_EVENT(xrep_xattr_replay_parentadd);
 DEFINE_XREP_PPTR_EVENT(xrep_xattr_replay_parentremove);
 DEFINE_XREP_PPTR_EVENT(xrep_parent_replay_parentadd);
+DEFINE_XREP_PPTR_EVENT(xrep_parent_replay_parentremove);
 
 DECLARE_EVENT_CLASS(xrep_pptr_scan_class,
 	TP_PROTO(struct xfs_inode *ip, const struct xfs_inode *dp,
@@ -2856,6 +2857,7 @@ DEFINE_EVENT(xrep_pptr_scan_class, name, \
 		 const struct xfs_name *name), \
 	TP_ARGS(ip, dp, name))
 DEFINE_XREP_PPTR_SCAN_EVENT(xrep_parent_stash_parentadd);
+DEFINE_XREP_PPTR_SCAN_EVENT(xrep_parent_stash_parentremove);
 
 TRACE_EVENT(xrep_nlinks_set_record,
 	TP_PROTO(struct xfs_mount *mp, xfs_ino_t ino,

