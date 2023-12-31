Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818D0C127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GI5J8BQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF15DC433C8;
	Sun, 31 Dec 2023 23:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064547;
	bh=FrokU9IwDsz3QU4j+XYwMcz4v+fBBfcu3dQHNwNohV4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GI5J8BQahmKoCtHZGAzUQIlH+buVwFpuf09SvazMSlV+/gT1jS4tKksFhLuRelmJ2
	 eI95lcP7TxB90kwT1F0UcgJbak1RwW8ncmAacOrf7l8n3mzUCMqYJWHztlk9iLmA5s
	 5F/EbQOV6YvVvWuVdBBtHn2wSZ0oWqbPkT0hUCJ9hMXsjj1qTRh/fnfVoh5QdXcEY3
	 rNeyxl3kwJG1w8aXjtqR9/Ky/WdST74TvxSlRR+14oPPM8jOCfViMFgaM7P9pdugey
	 kloIReVNU06DP+coJhvanna4WoRgJ+n4EWqiFZ5t8fzNGr3aHutvLxqxfBZyTLgyLF
	 W9LP64UD0pFEw==
Date: Sun, 31 Dec 2023 15:15:47 -0800
Subject: [PATCH 09/18] xfs_repair: add parent pointers when messing with
 /lost+found
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405006982.1805510.17053068517547637734.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006850.1805510.11145262768706358018.stgit@frogsfrogsfrogs>
References: <170405006850.1805510.11145262768706358018.stgit@frogsfrogsfrogs>
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
 repair/phase6.c          |   73 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 7ea7eebfbca..1aa2d9f0679 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -185,6 +185,8 @@
 #define xfs_parent_add			libxfs_parent_add
 #define xfs_parent_finish		libxfs_parent_finish
 #define xfs_parent_irec_from_disk	libxfs_parent_irec_from_disk
+#define xfs_parent_irec_hashname	libxfs_parent_irec_hashname
+#define xfs_parent_lookup		libxfs_parent_lookup
 #define xfs_parent_start		libxfs_parent_start
 #define xfs_parent_hashcheck		libxfs_parent_hashcheck
 #define xfs_parent_namecheck		libxfs_parent_namecheck
diff --git a/repair/phase6.c b/repair/phase6.c
index 9b43e58b3d3..2bdddafe213 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -902,6 +902,12 @@ mk_orphanage(xfs_mount_t *mp)
 	const int	mode = 0755;
 	int		nres;
 	struct xfs_name	xname;
+	struct xfs_parent_args *ppargs;
+
+	i = -libxfs_parent_start(mp, &ppargs);
+	if (i)
+		do_error(_("%d - couldn't allocate parent pointer for %s\n"),
+			i, ORPHANAGE);
 
 	/*
 	 * check for an existing lost+found first, if it exists, return
@@ -991,6 +997,12 @@ mk_orphanage(xfs_mount_t *mp)
 		_("can't make %s, createname error %d\n"),
 			ORPHANAGE, error);
 
+	error = -libxfs_parent_add(tp, ppargs, pip, &xname, ip);
+	if (error)
+		do_error(
+ _("committing %s parent pointer failed, error %d.\n"),
+				ORPHANAGE, error);
+
 	/*
 	 * bump up the link count in the root directory to account
 	 * for .. in the new directory, and update the irec copy of the
@@ -1012,10 +1024,51 @@ mk_orphanage(xfs_mount_t *mp)
 	}
 	libxfs_irele(ip);
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
+	struct xfs_parent_name_irec	pptr = {
+		.p_ino		= orphanage_ip->i_ino,
+		.p_gen		= VFS_I(orphanage_ip)->i_generation,
+		.p_namelen	= xname->len,
+	};
+	struct xfs_parent_scratch	scr = { };
+	struct xfs_mount	*mp = tp->t_mountp;
+	int			error;
+
+	memcpy(pptr.p_name, xname->name, xname->len);
+	libxfs_parent_irec_hashname(mp, &pptr);
+
+	error = -libxfs_parent_lookup(tp, ip, &pptr, &scr);
+	if (!error)
+		return;
+	if (error != ENOATTR)
+		do_log(
+ _("cannot look up parent pointer for '%.*s', err %d\n"),
+				xname->len, xname->name, error);
+
+	error = -libxfs_parent_add(tp, ppargs, orphanage_ip, xname, ip);
+	if (error)
+		do_error(
+ _("adding '%.*s' parent pointer failed, error %d.\n"),
+				xname->len, xname->name, error);
+}
+
 /*
  * move a file to the orphange.
  */
@@ -1036,6 +1089,13 @@ mv_orphanage(
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
@@ -1087,6 +1147,10 @@ mv_orphanage(
 				do_error(
 	_("name create failed in %s (%d)\n"), ORPHANAGE, err);
 
+			if (ppargs)
+				add_orphan_pptr(tp, orphanage_ip, &xname,
+						ino_p, ppargs);
+
 			if (irec)
 				add_inode_ref(irec, ino_offset);
 			else
@@ -1121,6 +1185,10 @@ mv_orphanage(
 				do_error(
 	_("name create failed in %s (%d)\n"), ORPHANAGE, err);
 
+			if (ppargs)
+				add_orphan_pptr(tp, orphanage_ip, &xname,
+						ino_p, ppargs);
+
 			if (irec)
 				add_inode_ref(irec, ino_offset);
 			else
@@ -1169,6 +1237,10 @@ mv_orphanage(
 	_("name create failed in %s (%d)\n"), ORPHANAGE, err);
 		ASSERT(err == 0);
 
+		if (ppargs)
+			add_orphan_pptr(tp, orphanage_ip, &xname, ino_p,
+					ppargs);
+
 		set_nlink(VFS_I(ino_p), 1);
 		libxfs_trans_log_inode(tp, ino_p, XFS_ILOG_CORE);
 		err = -libxfs_trans_commit(tp);
@@ -1178,6 +1250,7 @@ mv_orphanage(
 	}
 	libxfs_irele(ino_p);
 	libxfs_irele(orphanage_ip);
+	libxfs_parent_finish(mp, ppargs);
 }
 
 static int

