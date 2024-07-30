Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D5F881E
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302801; cv=none; b=tEfRS4+reHNm+5sclqmI/ADOw8kLdMt8Yvfqz9JBzdLJWwEBoeB2IM4g7wPInAaajy8lKmmd9U/vq2Nl+N3Dux4OT1/qRfs71NDIHGOXlq9AYL9y7oJNbkOaUzWcpyZJpGsl89mhvWkC/tQd5c2Jg8M6elT1FZl6k3QBXgcBf0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302801; c=relaxed/simple;
	bh=L2YObl43EOWfu+VDFYE2h0qknryRWmfhwCmck0q2LDU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gQLYJY/0vOtN0+HTmIISGX4/5RWTDH0F2UYUpIwey7DwSPcaLrjXojbsBoF/N5HMoGWeVMcCsT08KmIHsSDbzf/emCts8dc1dB+ubB3LapXeLr9Wsc5z2AUqC5U342GLsSm5tLkChJ9eWy92xMr4uKmTLyA/9rUur7YOBk6uRh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oIBXyB/W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oIBXyB/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207FDC32786;
	Tue, 30 Jul 2024 01:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302801;
	bh=L2YObl43EOWfu+VDFYE2h0qknryRWmfhwCmck0q2LDU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oIBXyB/WexyzLFr2QBX/QjNTMKr6FhdwEH6v2Df+Zdaa2WFBt84Uoamtm8rNYuSMh
	 557duXfm2pgAgzDMOK5QXb5OslT8JGuW6xBhaY77eqGTxOMED5VpuqUfHKjhGvmv+X
	 en/vVNEE6VuOCswFbAwyBwtpqb0Xsp4pbv0LbnFOEJR8tk58sDSpB1JdkYzHwJTSDj
	 hU6rWy1yzLca4lakMhl2x8+tQtLzdylB6TG9FbUkHS/USht7HvPlWCG7dC/65xs4aZ
	 mGgrHLzHaexXGg2+gMSgfqkr+es/CdcBqADh33x9jo2MAtvyTh/GHnnn5DU+dxOVKO
	 VSIL3pNE3fvng==
Date: Mon, 29 Jul 2024 18:26:40 -0700
Subject: [PATCH 04/12] xfs_repair: add parent pointers when messing with
 /lost+found
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
 catherine.hoang@oracle.com, allison.henderson@oracle.com
Message-ID: <172229851540.1352527.8664055953754357445.stgit@frogsfrogsfrogs>
In-Reply-To: <172229851481.1352527.11812121319440135994.stgit@frogsfrogsfrogs>
References: <172229851481.1352527.11812121319440135994.stgit@frogsfrogsfrogs>
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

Make sure that the /lost+found gets created with parent pointers, and
that lost children being put in there get new parent pointers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_api_defs.h |    2 +
 repair/phase6.c          |   76 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index bf1d3c9d3..d3611e05b 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -52,6 +52,7 @@
 #define xfs_attr_shortform_verify	libxfs_attr_shortform_verify
 
 #define __xfs_bmap_add_free		__libxfs_bmap_add_free
+#define xfs_bmap_add_attrfork		libxfs_bmap_add_attrfork
 #define xfs_bmap_validate_extent	libxfs_bmap_validate_extent
 #define xfs_bmapi_read			libxfs_bmapi_read
 #define xfs_bmapi_remap			libxfs_bmapi_remap
@@ -205,6 +206,7 @@
 #define xfs_parent_addname		libxfs_parent_addname
 #define xfs_parent_finish		libxfs_parent_finish
 #define xfs_parent_hashval		libxfs_parent_hashval
+#define xfs_parent_lookup		libxfs_parent_lookup
 #define xfs_parent_removename		libxfs_parent_removename
 #define xfs_parent_start		libxfs_parent_start
 #define xfs_parent_from_attr		libxfs_parent_from_attr
diff --git a/repair/phase6.c b/repair/phase6.c
index 47dd9de27..791f7d36f 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -903,6 +903,12 @@ mk_orphanage(xfs_mount_t *mp)
 	const int	mode = 0755;
 	int		nres;
 	struct xfs_name	xname;
+	struct xfs_parent_args *ppargs = NULL;
+
+	i = -libxfs_parent_start(mp, &ppargs);
+	if (i)
+		do_error(_("%d - couldn't allocate parent pointer for %s\n"),
+			i, ORPHANAGE);
 
 	/*
 	 * check for an existing lost+found first, if it exists, return
@@ -994,6 +1000,14 @@ mk_orphanage(xfs_mount_t *mp)
 		_("can't make %s, createname error %d\n"),
 			ORPHANAGE, error);
 
+	if (ppargs) {
+		error = -libxfs_parent_addname(tp, ppargs, pip, &xname, ip);
+		if (error)
+			do_error(
+ _("can't make %s, parent addname error %d\n"),
+					ORPHANAGE, error);
+	}
+
 	/*
 	 * bump up the link count in the root directory to account
 	 * for .. in the new directory, and update the irec copy of the
@@ -1016,10 +1030,52 @@ mk_orphanage(xfs_mount_t *mp)
 	libxfs_irele(ip);
 out_pip:
 	libxfs_irele(pip);
+	libxfs_parent_finish(mp, ppargs);
 
 	return(ino);
 }
 
+/*
+ * Add a parent pointer back to the orphanage for any file we're moving into
+ * the orphanage, being careful not to trip over any existing parent pointer.
+ * You never know when the orphanage might get corrupted.
+ */
+static void
+add_orphan_pptr(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*orphanage_ip,
+	const struct xfs_name	*xname,
+	struct xfs_inode	*ip,
+	struct xfs_parent_args	*ppargs)
+{
+	struct xfs_parent_rec	pptr = { };
+	struct xfs_da_args	scratch;
+	int			error;
+
+	xfs_inode_to_parent_rec(&pptr, orphanage_ip);
+	error = -libxfs_parent_lookup(tp, ip, xname, &pptr, &scratch);
+	if (!error)
+		return;
+	if (error != ENOATTR)
+		do_log(
+ _("cannot look up parent pointer for '%.*s', err %d\n"),
+				xname->len, xname->name, error);
+
+	if (!xfs_inode_has_attr_fork(ip)) {
+		error = -libxfs_bmap_add_attrfork(tp, ip,
+				sizeof(struct xfs_attr_sf_hdr), true);
+		if (error)
+			do_error(_("can't add attr fork to inode 0x%llx\n"),
+					(unsigned long long)ip->i_ino);
+	}
+
+	error = -libxfs_parent_addname(tp, ppargs, orphanage_ip, xname, ip);
+	if (error)
+		do_error(
+ _("can't add parent pointer for '%.*s', error %d\n"),
+				xname->len, xname->name, error);
+}
+
 /*
  * move a file to the orphange.
  */
@@ -1040,6 +1096,13 @@ mv_orphanage(
 	ino_tree_node_t		*irec;
 	int			ino_offset = 0;
 	struct xfs_name		xname;
+	struct xfs_parent_args	*ppargs;
+
+	err = -libxfs_parent_start(mp, &ppargs);
+	if (err)
+		do_error(
+ _("%d - couldn't allocate parent pointer for lost inode\n"),
+			err);
 
 	xname.name = fname;
 	xname.len = snprintf((char *)fname, sizeof(fname), "%llu",
@@ -1091,6 +1154,10 @@ mv_orphanage(
 				do_error(
 	_("name create failed in %s (%d)\n"), ORPHANAGE, err);
 
+			if (ppargs)
+				add_orphan_pptr(tp, orphanage_ip, &xname,
+						ino_p, ppargs);
+
 			if (irec)
 				add_inode_ref(irec, ino_offset);
 			else
@@ -1125,6 +1192,10 @@ mv_orphanage(
 				do_error(
 	_("name create failed in %s (%d)\n"), ORPHANAGE, err);
 
+			if (ppargs)
+				add_orphan_pptr(tp, orphanage_ip, &xname,
+						ino_p, ppargs);
+
 			if (irec)
 				add_inode_ref(irec, ino_offset);
 			else
@@ -1173,6 +1244,10 @@ mv_orphanage(
 	_("name create failed in %s (%d)\n"), ORPHANAGE, err);
 		ASSERT(err == 0);
 
+		if (ppargs)
+			add_orphan_pptr(tp, orphanage_ip, &xname, ino_p,
+					ppargs);
+
 		set_nlink(VFS_I(ino_p), 1);
 		libxfs_trans_log_inode(tp, ino_p, XFS_ILOG_CORE);
 		err = -libxfs_trans_commit(tp);
@@ -1182,6 +1257,7 @@ mv_orphanage(
 	}
 	libxfs_irele(ino_p);
 	libxfs_irele(orphanage_ip);
+	libxfs_parent_finish(mp, ppargs);
 }
 
 static int

