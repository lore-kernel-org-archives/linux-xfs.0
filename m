Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5918F5E
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609547; cv=none; b=XNjIiz1YNbCF5196anAZANmN25HUN4RvN3z8kPFdYvY7Z6dVkVsotZgjG7X71cHUWKHJMu2tYeP1FRabM5VpTn9IGpiSbllLS7gb52Gzn/3trpKlFApWIJunILwcYjR4yBAKpMerc/xuUggo4DmvHiriY6oJJ+yNz4wqQg4SEN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609547; c=relaxed/simple;
	bh=vAp61FzaEeWT1l2JwsW7N6EevQgOWtbm6Lvx5j3zfcY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YFz4VZZTfeRX9LcxKnYyWqjggEEGc9EIhvvPNcZqscZiBQuqZyOd7RoBQ8SI2js7ZlUFSRC43kP6H8P2Uf2NCRon+eBDD2CgSGWiI2JTExLlXJ3w9p8BkLOK3vwlGpKuq8smtOPA/hO2+/o32Di+m0E9VQKESsiunQXq7dGxaFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q4RhARDw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q4RhARDw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6DCC4CEC5;
	Fri, 11 Oct 2024 01:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609547;
	bh=vAp61FzaEeWT1l2JwsW7N6EevQgOWtbm6Lvx5j3zfcY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=q4RhARDw84jsa3xt9VGJtC7ObcmFWJ2QtzSmzXzl5+k6HEC8ouZ+Efu3sD8G8cP/l
	 JaaEGLCv+kA1gTAUBH1Ae0c2Z4G4/s3sJjnus9A8dfsBqpWoNoRS8ssVK9XjbHjsgY
	 +3HTVWkEMMxtv+PaaXtb5ab0CUoThBUjD94W9fg5bh0LmudAks3n+OG/zYqj5KTw0+
	 TtlGNISrCWH2c8wxyW/l5Svrf6h2SwqmjLVE3KOYxBegkMYQ4DNmzGx28/BrfiIbjd
	 nQ4IzG7o6C4On1nlTNcY1Tk3lxCl4j8xfzm1cEq5zWseSYvHJcn+wwngzc/sO2JWqU
	 eQqBYZiwHaP8g==
Date: Thu, 10 Oct 2024 18:19:06 -0700
Subject: [PATCH 19/38] xfs_repair: refactor fixing dotdot
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654267.4183231.12434205260500740198.stgit@frogsfrogsfrogs>
In-Reply-To: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
References: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
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

Pull the code that fixes a directory's dot-dot entry into a separate
helper function so that we can call it on the rootdir and (later) the
metadir.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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

