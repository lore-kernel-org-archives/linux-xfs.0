Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CECA947E
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929076; cv=none; b=n1AxQpTuPxDhwa+UQpYA2310kHu7RTz0OUEBOFgxum8zW4i3GyMqYmBXcP50vZ2P0P+vP++n7z3pw8Nt7GhN/2bZ/2GM/FSzQmelh8qLWmnYFwx404swGl14IVegkoENwI1N5jXF1lt+WzMkMjPP8wkqKwA4sZomiTs8jNA2jPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929076; c=relaxed/simple;
	bh=LHpHGlxFlLi5rlnEvg51gmYdDtKVSUHRY7I+z619TWg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RQ8Dyo/+Z+geYDB1cTnCCQcDUFyR/QPedk+F+QJSrGuN0LZKYmAuqmt7blMEAQfAa1w0w5fSUDNaNjQMoaf0d59YY96uOFWYIV95KtDUlMKlba/vm0vEz0jV+kwwDJ7nk3BuwLoQRgMEY9AWsXedQzZKBmDKtFzCWFCaBDWovCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C/QYIA7N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C/QYIA7N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A1CC2BD11;
	Wed, 24 Apr 2024 03:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713929076;
	bh=LHpHGlxFlLi5rlnEvg51gmYdDtKVSUHRY7I+z619TWg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=C/QYIA7Nv1UJAJYu+7yBPmj7Aac38wuhi5EYXmjl6pNJO9rOXXYDEQXQ/tZjKR7ev
	 sGbmNvxUw+SkpxSRdpuSnzcZd8yvmowNLg4DDK0hH2DLjYJ39QkrNPh2PGc+wn49tq
	 jfZcctlKyo30HuNqA0RO7GBy+uRmdBzh+8EIdzTkCwPusb6Z1sw/7Hjnq+qJdCZ+GQ
	 6m2vfGfTZrqeDBXsVIHtaxvuUAB5kK/nk0MEGwcCseE4kYDdP6ZLYQHOMQuNBUtREn
	 FBEbdwuQiqtEhPw7hoeT12rAyflJg/9e5CCb4+DXT1tDvYL6JISaRtH9ccpAF88rNm
	 AIpJvsELTmjug==
Date: Tue, 23 Apr 2024 20:24:35 -0700
Subject: [PATCH 09/16] xfs: implement live updates for parent pointer repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392784804.1906420.13310169909410878153.stgit@frogsfrogsfrogs>
In-Reply-To: <171392784611.1906420.2159865382920841289.stgit@frogsfrogsfrogs>
References: <171392784611.1906420.2159865382920841289.stgit@frogsfrogsfrogs>
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
index b4084a9f0e9c..311bc7990d7c 100644
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
index 10c2a8d10058..3e0cd482379c 100644
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

