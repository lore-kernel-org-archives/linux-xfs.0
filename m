Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1792BC77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:18:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbjEZCSd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjEZCSb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:18:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BF7B2
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:18:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E8D26122B
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECAAC433D2;
        Fri, 26 May 2023 02:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067508;
        bh=oVcWySd0NkNaU28Yq9j8ViIgoQOKktbJMu72S0pECXs=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=kQPsB8zp4bSeDdBiAu+jpydvqtMkerHw1m+yVNbsw1uMdSJWvJVITG49PjtiFEdKo
         5vs4timAVj+vPpxYdGdDv3leUDeSDza15iJPtYnWZ2JbqxrAH7o4T0UmoxWZoAgqZK
         XnOUL6fBB2bLK2Md2bQBrsKUBS58ymwLFgwYdjMOIKylLujyNUX+bv1Jx24KFHrn4u
         D0eIO1MHq7wDcbhAD0vII4t27C3PiWtT6dP51+IhsEF2iF0JG+NFBWWx9S8EkMooXf
         Q5MU1erC7D3hnPCBx3DycqwY3F/Fz6XfDtqXf/PoriXnMKbitpEalbbD98NBZIY6ch
         3k8jAJDaOcqnw==
Date:   Thu, 25 May 2023 19:18:28 -0700
Subject: [PATCH 15/17] xfs: implement live updates for parent pointer repairs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506073510.3745075.3794570658317339096.stgit@frogsfrogsfrogs>
In-Reply-To: <168506073275.3745075.7865645835865818396.stgit@frogsfrogsfrogs>
References: <168506073275.3745075.7865645835865818396.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
index adf23180c822..b87eb389e45e 100644
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
@@ -518,6 +572,48 @@ xrep_parent_scan_dirtree(
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
+	rp = container_of(nb, struct xrep_parent, pscan.hooks.dirent_hook.nb);
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
@@ -666,7 +762,8 @@ xrep_parent_setup_scan(
 	if (error)
 		goto out_recs;
 
-	error = xrep_findparent_scan_start(sc, &rp->pscan);
+	error = __xrep_findparent_scan_start(sc, &rp->pscan,
+			xrep_parent_live_update);
 	if (error)
 		goto out_names;
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index e355f8f7a444..cc164c34d853 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2759,6 +2759,7 @@ DEFINE_EVENT(xrep_pptr_class, name, \
 DEFINE_XREP_PPTR_CLASS(xrep_xattr_replay_parentadd);
 DEFINE_XREP_PPTR_CLASS(xrep_xattr_replay_parentremove);
 DEFINE_XREP_PPTR_CLASS(xrep_parent_replay_parentadd);
+DEFINE_XREP_PPTR_CLASS(xrep_parent_replay_parentremove);
 
 DECLARE_EVENT_CLASS(xrep_pptr_scan_class,
 	TP_PROTO(struct xfs_inode *ip, const struct xfs_inode *dp,
@@ -2794,6 +2795,7 @@ DEFINE_EVENT(xrep_pptr_scan_class, name, \
 		 const struct xfs_name *name), \
 	TP_ARGS(ip, dp, name))
 DEFINE_XREP_PPTR_SCAN_CLASS(xrep_parent_stash_parentadd);
+DEFINE_XREP_PPTR_SCAN_CLASS(xrep_parent_stash_parentremove);
 
 TRACE_EVENT(xrep_nlinks_set_record,
 	TP_PROTO(struct xfs_mount *mp, xfs_ino_t ino,

