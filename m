Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9900A22C6C6
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528739; cv=none; b=Xt272NHF5TRNwK+BsZ2r4Cp0sClPvzdnuz6uF0HCD6pb+YISt5jtSP5/N4vHH8GB60pzU5xawphpz7hs6Ka/IZrVwzowHilmAEVZq0QqqzGCyT9Jr+lqzSvN5eFPmhATTzGmjpiHXu+jiBKE1HJV5ysBVu2AFIBGdkVsXg++/rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528739; c=relaxed/simple;
	bh=XVXmTtypjh9+lH0bwdSxwc5dUWMqfDe8Ts+WUlsM778=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TAX22T310ZcgxU6rE+Ovrmi8nM3K7jsNnkoVGmhBC7E6xT/IONBEKydrbVaDbI2evpbIZPzcm+4skgae5ZpHBTKXaAmPsHieLrDb9vNOli3hzKkwVMni1HTtNExnckn7BW21uQWYtU4AipzTxzKUoWLfrOqT6SdOCD4+i+uxmsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LFxSQ48U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LFxSQ48U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B26C4CED1;
	Fri,  6 Dec 2024 23:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528739;
	bh=XVXmTtypjh9+lH0bwdSxwc5dUWMqfDe8Ts+WUlsM778=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LFxSQ48UrnL3lgr11HQGLtflMsZHkOZp8mbObasPMwyEuksIlmzSBMvV0tnBIiBJg
	 dAZrXO031MKDk+z0SX/5l/6qv01pDi/MECCMFm69iHR3IJ8nilsWNMJXqDYNzR1Dnd
	 cGFJOtEyp5mqlmc4GhSlyDKj6/NQwvN0ztGnSKyVP1eIf6g/TwHC1RlBIuxlEhJ8R6
	 eQ1zC3ObPppCo6wUieUhVXDfeIJtIiDrRo8a5IwcCYKTixLqK16sulJbdprZRnO4i/
	 R87AY21Z5z56lFxvlrwwIny1Uas2bYFnCZmdhBJyV41H2AQRomQn5oq+Z72uBWde4R
	 T3dmAXE5CDH0A==
Date: Fri, 06 Dec 2024 15:45:38 -0800
Subject: [PATCH 23/41] xfs_repair: refactor fixing dotdot
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748588.122992.770780373114325109.stgit@frogsfrogsfrogs>
In-Reply-To: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Pull the code that fixes a directory's dot-dot entry into a separate
helper function so that we can call it on the rootdir and (later) the
metadir.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/phase6.c |   96 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 57 insertions(+), 39 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index 630617ef8ab8fe..0f13d996fe726a 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2649,6 +2649,62 @@ dir_hash_add_parent_ptrs(
 	}
 }
 
+/*
+ * If we have to create a .. for /, do it now *before* we delete the bogus
+ * entries, otherwise the directory could transform into a shortform dir which
+ * would probably cause the simulation to choke.  Even if the illegal entries
+ * get shifted around, it's ok because the entries are structurally intact and
+ * in in hash-value order so the simulation won't get confused if it has to
+ * move them around.
+ */
+static void
+fix_dotdot(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	struct xfs_inode	*ip,
+	xfs_ino_t		rootino,
+	const char		*tag,
+	int			*need_dotdot)
+{
+	struct xfs_trans	*tp;
+	int			nres;
+	int			error;
+
+	if (ino != rootino || !*need_dotdot)
+		return;
+
+	if (no_modify) {
+		do_warn(_("would recreate %s directory .. entry\n"), tag);
+		return;
+	}
+
+	ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_LOCAL);
+
+	do_warn(_("recreating %s directory .. entry\n"), tag);
+
+	nres = libxfs_mkdir_space_res(mp, 2);
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_mkdir, nres, 0, 0, &tp);
+	if (error)
+		res_failed(error);
+
+	libxfs_trans_ijoin(tp, ip, 0);
+
+	error = -libxfs_dir_createname(tp, ip, &xfs_name_dotdot, ip->i_ino,
+			nres);
+	if (error)
+		do_error(
+_("can't make \"..\" entry in %s inode %" PRIu64 ", createname error %d\n"),
+			tag ,ino, error);
+
+	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		do_error(
+_("%s inode \"..\" entry recreation failed (%d)\n"), tag, error);
+
+	*need_dotdot = 0;
+}
+
 /*
  * processes all reachable inodes in directories
  */
@@ -2778,45 +2834,7 @@ _("error %d fixing shortform directory %llu\n"),
 	dir_hash_add_parent_ptrs(ip, hashtab);
 	dir_hash_done(hashtab);
 
-	/*
-	 * if we have to create a .. for /, do it now *before*
-	 * we delete the bogus entries, otherwise the directory
-	 * could transform into a shortform dir which would
-	 * probably cause the simulation to choke.  Even
-	 * if the illegal entries get shifted around, it's ok
-	 * because the entries are structurally intact and in
-	 * in hash-value order so the simulation won't get confused
-	 * if it has to move them around.
-	 */
-	if (!no_modify && need_root_dotdot && ino == mp->m_sb.sb_rootino)  {
-		ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_LOCAL);
-
-		do_warn(_("recreating root directory .. entry\n"));
-
-		nres = libxfs_mkdir_space_res(mp, 2);
-		error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_mkdir,
-					    nres, 0, 0, &tp);
-		if (error)
-			res_failed(error);
-
-		libxfs_trans_ijoin(tp, ip, 0);
-
-		error = -libxfs_dir_createname(tp, ip, &xfs_name_dotdot,
-					ip->i_ino, nres);
-		if (error)
-			do_error(
-	_("can't make \"..\" entry in root inode %" PRIu64 ", createname error %d\n"), ino, error);
-
-		libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-		error = -libxfs_trans_commit(tp);
-		if (error)
-			do_error(
-	_("root inode \"..\" entry recreation failed (%d)\n"), error);
-
-		need_root_dotdot = 0;
-	} else if (need_root_dotdot && ino == mp->m_sb.sb_rootino)  {
-		do_warn(_("would recreate root directory .. entry\n"));
-	}
+	fix_dotdot(mp, ino, ip, mp->m_sb.sb_rootino, "root", &need_root_dotdot);
 
 	/*
 	 * if we need to create the '.' entry, do so only if

