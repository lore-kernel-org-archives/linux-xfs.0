Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716D29441
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719883111; cv=none; b=UbvyHhDuvbT57bKdE3bqdoqhbgnP7Moo+JGuHHErQOy5llCg2/7fHBDRDIRN6/vmJtCANtkEnZsAW0SrwppHfpLArKu2KfdffS5i4QY9Smyy+XPWoewG7nlQ9t7u0wKNlg8N42UZj2vJ39KxUAqaGCIFb9io99yT8ejK8FJ4f60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719883111; c=relaxed/simple;
	bh=e2qt/IoH35gJdraxnMyAzvVBxCKaalV4Z+JOGoo9ifI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t+9+1F93mvpIFfjjj9hTE88BLHBSbxA9k83TO1U+U1yjVTwDkJgQ87KTSkzI5CtuftWdI6AqWK64kNNvD02ESXWDmwLIrGj7b9z3Alm2lZzGRUaF3AuCn5BDRTkiOvJ0lmmSs3PUYH9k2Wpj7hHVCKPRIWiDaEGFLovQNkbaxvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cAcO8JPn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cAcO8JPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C46FC116B1;
	Tue,  2 Jul 2024 01:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719883111;
	bh=e2qt/IoH35gJdraxnMyAzvVBxCKaalV4Z+JOGoo9ifI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cAcO8JPn8Sg/iUZp+5Dx/79kNAPztk10IB3gR5q5fR14Ak86NNeAmzM0Iqo4/TgjT
	 GNmY2/cdJAnXteHdtwtObFa+IrSxB0nLKN8m9LNmSSifU9W2iY6BpuV1nffPC2Qsa6
	 fRcg8i2wzgCY+qS7xfgrE4H0L/yjOoGHwuuu/UqEPHyoRG11zGCOwbz5Cd1xEX8y/D
	 OipTOunbpoOef1GiLffdehCVbK6eeqoPY1aL+MlQQ31JS4mibOJkDOh4PhjNf2uYuk
	 ZHmicQwjsG/VMtKmM4NrxIgEdoKbARPAkKdJfGS6omppMhjSREXiWDL6RcLnY157Up
	 QJ3MjQjEio3lw==
Date: Mon, 01 Jul 2024 18:18:30 -0700
Subject: [PATCH 04/12] xfs_repair: add parent pointers when messing with
 /lost+found
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988122227.2010218.6936061653638637272.stgit@frogsfrogsfrogs>
In-Reply-To: <171988122147.2010218.8997075209577453030.stgit@frogsfrogsfrogs>
References: <171988122147.2010218.8997075209577453030.stgit@frogsfrogsfrogs>
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
---
 libxfs/libxfs_api_defs.h |    2 +
 repair/phase6.c          |   76 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index bf1d3c9d37f6..d3611e05bade 100644
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
index 47dd9de2741c..791f7d36fa8a 100644
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

