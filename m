Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688D65A0FA
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798746; cv=none; b=rZlJSofjZb5RUETMR/57ftussZa30UWiOGIYkmurkgLPvs+U6CHCnk6P1laEA3Y0Z3iVtoS2guLBwu4itpLZKVq/s6SS82s1LY9K9xUw/n0fbUBvgXrY4bTtXDf94yjPJDFpxcxeKEVz/FkHV5/U3TlgiaHLStu9pqY5Hj15m4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798746; c=relaxed/simple;
	bh=RTqEv2Iri8LTk682ZDfWK1nzb96/5W2FHtmsE9Eh9jw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XkXCSiOxs1NHuIAn3cKzOljM7uAuTfeA2LgMf4jwtTgO3Xu5ex5k0ZYH1L1EthPX8jVG+AEIXg/QXJ0vISZ3K8X/kwc+zCIy3YkfTdBnxEnEwPSLhbnAqtCFvXo5TBx9IvO2YYVNBEZK+QjGDwb+ZxmyLb04G1UzssVt2/obpJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TKkpdHLu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TKkpdHLu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3620AC433F1;
	Mon, 18 Mar 2024 21:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798746;
	bh=RTqEv2Iri8LTk682ZDfWK1nzb96/5W2FHtmsE9Eh9jw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TKkpdHLuwZGmDrKYbi81IPaubbGQSPZQ+Qn2yvCskC5HCh0CDb8qKE6WtxMadBqk5
	 20c0EkqBJ5nGqw2fgL1hJ2LUBB5OYW/3EMd6SIdpWROcHyQ5/k69pvJaGLxBVmLabu
	 5iwiBAoYpZAaM1ABZDw4NQm0jNIyDq6iMYOFTpwGmkNiyU2BH5jQ9I0Uwng6nX8wEL
	 KxhcFq+Oa/Htr6UMiOO+ZtmWhIHCw9ExtiSHXI0qeKQoGB5LH66C2zWgCNxiW+N2RJ
	 9LF2jixOWuWfj/Tvl96MbbfkZp52OCa0jHtb0DqAClZtizKJm5XXzHFUAXZwBXSbWI
	 Vx4In4O9imToQ==
Date: Mon, 18 Mar 2024 14:52:25 -0700
Subject: [PATCH 17/23] xfs: implement live updates for parent pointer repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079802971.3808642.1559057883117209158.stgit@frogsfrogsfrogs>
In-Reply-To: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
References: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/scrub/parent_repair.c |  111 +++++++++++++++++++++++++++++++++++++++---
 fs/xfs/scrub/trace.h         |    2 +
 2 files changed, 106 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index daf34808b3bbc..7ade65cd61b7f 100644
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
@@ -81,6 +87,9 @@ struct xrep_pptr {
 
 	/* Length of the pptr name. */
 	uint8_t				namelen;
+
+	/* XREP_PPTR_{ADD,REMOVE} */
+	uint8_t				action;
 };
 
 /*
@@ -233,13 +242,29 @@ xrep_parent_replay_update(
 	rp->pptr.p_namelen = pptr->namelen;
 	xfs_parent_irec_hashname(sc->mp, &rp->pptr);
 
-	/* Create parent pointer. */
-	trace_xrep_parent_replay_parentadd(sc->tempip, &rp->pptr);
+	switch (pptr->action) {
+	case XREP_PPTR_ADD:
+		/* Create parent pointer. */
+		trace_xrep_parent_replay_parentadd(sc->tempip, &rp->pptr);
 
-	error = xfs_parent_set(sc->tempip, sc->ip->i_ino, &rp->pptr,
-			&rp->pptr_scratch);
-	if (error)
-		return error;
+		error = xfs_parent_set(sc->tempip, sc->ip->i_ino, &rp->pptr,
+				&rp->pptr_scratch);
+		if (error)
+			return error;
+		break;
+	case XREP_PPTR_REMOVE:
+		/* Remove parent pointer. */
+		trace_xrep_parent_replay_parentremove(sc->tempip, &rp->pptr);
+
+		error = xfs_parent_unset(sc->tempip, sc->ip->i_ino, &rp->pptr,
+				&rp->pptr_scratch);
+		if (error)
+			return error;
+		break;
+	default:
+		ASSERT(0);
+		return -EIO;
+	}
 
 	return 0;
 }
@@ -302,6 +327,7 @@ xrep_parent_stash_parentadd(
 	const struct xfs_inode	*dp)
 {
 	struct xrep_pptr	pptr = {
+		.action		= XREP_PPTR_ADD,
 		.namelen	= name->len,
 		.p_ino		= dp->i_ino,
 		.p_gen		= VFS_IC(dp)->i_generation,
@@ -318,6 +344,34 @@ xrep_parent_stash_parentadd(
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
+		.p_ino		= dp->i_ino,
+		.p_gen		= VFS_IC(dp)->i_generation,
+	};
+	int			error;
+
+	trace_xrep_parent_stash_parentremove(rp->sc->tempip, dp, name);
+
+	error = xfblob_store(rp->pptr_names, &pptr.name_cookie, name->name,
+			name->len);
+	if (error)
+		return error;
+
+	return xfarray_append(rp->pptr_recs, &pptr);
+}
+
 /*
  * Examine an entry of a directory.  If this dirent leads us back to the file
  * whose parent pointers we're rebuilding, add a pptr to the temporary
@@ -527,6 +581,48 @@ xrep_parent_scan_dirtree(
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
@@ -698,7 +794,8 @@ xrep_parent_setup_scan(
 	if (error)
 		goto out_recs;
 
-	error = xrep_findparent_scan_start(sc, &rp->pscan);
+	error = __xrep_findparent_scan_start(sc, &rp->pscan,
+			xrep_parent_live_update);
 	if (error)
 		goto out_names;
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index dc5190f4aa89b..9ff1c897add2b 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2814,6 +2814,7 @@ DEFINE_EVENT(xrep_pptr_class, name, \
 DEFINE_XREP_PPTR_EVENT(xrep_xattr_replay_parentadd);
 DEFINE_XREP_PPTR_EVENT(xrep_xattr_replay_parentremove);
 DEFINE_XREP_PPTR_EVENT(xrep_parent_replay_parentadd);
+DEFINE_XREP_PPTR_EVENT(xrep_parent_replay_parentremove);
 
 DECLARE_EVENT_CLASS(xrep_pptr_scan_class,
 	TP_PROTO(struct xfs_inode *ip, const struct xfs_inode *dp,
@@ -2849,6 +2850,7 @@ DEFINE_EVENT(xrep_pptr_scan_class, name, \
 		 const struct xfs_name *name), \
 	TP_ARGS(ip, dp, name))
 DEFINE_XREP_PPTR_SCAN_EVENT(xrep_parent_stash_parentadd);
+DEFINE_XREP_PPTR_SCAN_EVENT(xrep_parent_stash_parentremove);
 
 TRACE_EVENT(xrep_nlinks_set_record,
 	TP_PROTO(struct xfs_mount *mp, xfs_ino_t ino,

