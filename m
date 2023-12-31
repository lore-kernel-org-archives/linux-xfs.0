Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76A9C2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jVvSlolq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B768FC433C7;
	Sun, 31 Dec 2023 23:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064344;
	bh=mXYcodJ52vnINEs0pgcJWnY9HUGUuMQeBih6NSdzMh0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jVvSlolqK5VdVbxZYfwh0N9iyHQlRGRCSKZAML1X+MCN+C1vaMvZAHxxejueDBupD
	 h0OJUhnhsbhe+IHpHLRTq7QSU1nCwmpNuLy/mw/NoaJdKX6Ia3mccsuJCUx/H8/LzM
	 tkDmWeBfO2jLFV7MJBdqQL+HjmY15v9ioS649x+vjmXCZSAGrwv/gkDtuJ3MoakHZW
	 MKD3WzhV+f0zGz29nms8jPZDkoXR945i1Lgx3SOxtRqgPlTJuqWoOl9ji2FT0jaJIq
	 J+H+XJriW2i9U5fB9Tg+j7AdVVVhwoKxvc/0+nKzUGxZ6SEu44nht9HS7H67NGYldt
	 8jj9eLYcaRwEA==
Date: Sun, 31 Dec 2023 15:12:24 -0800
Subject: [PATCH 28/32] xfs_db: add a parents command to list the parents of a
 file
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405006474.1804688.8496939238290408650.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
References: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
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

Create a command to dump the parents of a file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/namei.c               |  335 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/libxfs_api_defs.h |    1 
 man/man8/xfs_db.8        |    9 +
 3 files changed, 345 insertions(+)


diff --git a/db/namei.c b/db/namei.c
index a8577b97222..fb7f63fda07 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -598,6 +598,338 @@ static struct cmdinfo ls_cmd = {
 	.help		= ls_help,
 };
 
+static void
+pptr_emit(
+	struct xfs_mount	*mp,
+	const struct xfs_parent_name_irec *irec)
+{
+	struct xfs_name		xname = {
+		.name		= irec->p_name,
+		.len		= irec->p_namelen,
+	};
+	xfs_dahash_t		hash;
+	bool			good;
+
+	hash = libxfs_dir2_hashname(mp, &xname);
+	good = libxfs_parent_verify_irec(mp, irec);
+
+	dbprintf("%18llu:0x%08x 0x%08x:0x%08x %3d %.*s %s\n",
+			irec->p_ino, irec->p_gen, irec->p_namehash, hash,
+			xname.len, xname.len, xname.name,
+			good ? _("(good)") : _("(corrupt)"));
+}
+
+static int
+list_sf_pptrs(
+	struct xfs_inode		*ip)
+{
+	struct xfs_parent_name_irec	irec;
+	struct xfs_attr_shortform	*sf;
+	struct xfs_attr_sf_entry	*sfe;
+	unsigned int			i;
+
+	sf = (struct xfs_attr_shortform *)ip->i_af.if_u1.if_data;
+	for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
+		void			*name = sfe->nameval;
+		void			*value = &sfe->nameval[sfe->namelen];
+
+		if ((sfe->flags & XFS_ATTR_PARENT) &&
+		    libxfs_parent_namecheck(mp, name, sfe->namelen, sfe->flags) &&
+		    libxfs_parent_valuecheck(mp, value, sfe->valuelen)) {
+			libxfs_parent_irec_from_disk(&irec, name, value,
+					sfe->valuelen);
+			pptr_emit(mp, &irec);
+		}
+
+		sfe = xfs_attr_sf_nextentry(sfe);
+	}
+
+	return 0;
+}
+
+static void
+list_leaf_pptr_entries(
+	struct xfs_inode		*ip,
+	struct xfs_buf			*bp)
+{
+	struct xfs_parent_name_irec	irec;
+	struct xfs_attr3_icleaf_hdr	ichdr;
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_attr_leafblock	*leaf = bp->b_addr;
+	struct xfs_attr_leaf_entry	*entry;
+	unsigned int			i;
+
+	libxfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
+	entry = xfs_attr3_leaf_entryp(leaf);
+
+	for (i = 0; i < ichdr.count; entry++, i++) {
+		struct xfs_attr_leaf_name_local	*name_loc;
+		void			*value;
+		void			*name;
+		unsigned int		namelen, valuelen;
+
+		if (!(entry->flags & XFS_ATTR_LOCAL) ||
+		    !(entry->flags & XFS_ATTR_PARENT))
+			continue;
+
+		name_loc = xfs_attr3_leaf_name_local(leaf, i);
+		name = name_loc->nameval;
+		namelen = name_loc->namelen;
+		value = &name_loc->nameval[name_loc->namelen];
+		valuelen = be16_to_cpu(name_loc->valuelen);
+
+		if (libxfs_parent_namecheck(mp, name, namelen, entry->flags) &&
+		    libxfs_parent_valuecheck(mp, value, valuelen)) {
+			libxfs_parent_irec_from_disk(&irec, name, value,
+					valuelen);
+			pptr_emit(mp, &irec);
+		}
+	}
+}
+
+static int
+list_leaf_pptrs(
+	struct xfs_inode		*ip)
+{
+	struct xfs_buf			*leaf_bp;
+	int				error;
+
+	error = -libxfs_attr3_leaf_read(NULL, ip, ip->i_ino, 0, &leaf_bp);
+	if (error)
+		return error;
+
+	list_leaf_pptr_entries(ip, leaf_bp);
+	libxfs_trans_brelse(NULL, leaf_bp);
+	return 0;
+}
+
+static int
+find_leftmost_attr_leaf(
+	struct xfs_inode		*ip,
+	struct xfs_buf			**leaf_bpp)
+{
+	struct xfs_da3_icnode_hdr	nodehdr;
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_da_intnode		*node;
+	struct xfs_da_node_entry	*btree;
+	struct xfs_buf			*bp;
+	xfs_dablk_t			blkno = 0;
+	unsigned int			expected_level = 0;
+	int				error;
+
+	for (;;) {
+		uint16_t		magic;
+
+		error = -libxfs_da3_node_read(NULL, ip, blkno, &bp,
+				XFS_ATTR_FORK);
+		if (error)
+			return error;
+
+		node = bp->b_addr;
+		magic = be16_to_cpu(node->hdr.info.magic);
+		if (magic == XFS_ATTR_LEAF_MAGIC ||
+		    magic == XFS_ATTR3_LEAF_MAGIC)
+			break;
+
+		error = EFSCORRUPTED;
+		if (magic != XFS_DA_NODE_MAGIC &&
+		    magic != XFS_DA3_NODE_MAGIC)
+			goto out_buf;
+
+		libxfs_da3_node_hdr_from_disk(mp, &nodehdr, node);
+
+		if (nodehdr.count == 0 || nodehdr.level >= XFS_DA_NODE_MAXDEPTH)
+			goto out_buf;
+
+		/* Check the level from the root node. */
+		if (blkno == 0)
+			expected_level = nodehdr.level - 1;
+		else if (expected_level != nodehdr.level)
+			goto out_buf;
+		else
+			expected_level--;
+
+		/* Find the next level towards the leaves of the dabtree. */
+		btree = nodehdr.btree;
+		blkno = be32_to_cpu(btree->before);
+		libxfs_trans_brelse(NULL, bp);
+	}
+
+	error = EFSCORRUPTED;
+	if (expected_level != 0)
+		goto out_buf;
+
+	*leaf_bpp = bp;
+	return 0;
+
+out_buf:
+	libxfs_trans_brelse(NULL, bp);
+	return error;
+}
+
+static int
+list_node_pptrs(
+	struct xfs_inode		*ip)
+{
+	struct xfs_attr3_icleaf_hdr	leafhdr;
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_attr_leafblock	*leaf;
+	struct xfs_buf			*leaf_bp;
+	int				error;
+
+	error = find_leftmost_attr_leaf(ip, &leaf_bp);
+	if (error)
+		return error;
+
+	for (;;) {
+		list_leaf_pptr_entries(ip, leaf_bp);
+
+		/* Find the right sibling of this leaf block. */
+		leaf = leaf_bp->b_addr;
+		libxfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
+		if (leafhdr.forw == 0)
+			goto out_leaf;
+
+		libxfs_trans_brelse(NULL, leaf_bp);
+
+		error = -libxfs_attr3_leaf_read(NULL, ip, ip->i_ino,
+				leafhdr.forw, &leaf_bp);
+		if (error)
+			return error;
+	}
+
+out_leaf:
+	libxfs_trans_brelse(NULL, leaf_bp);
+	return error;
+}
+
+static int
+list_pptrs(
+	struct xfs_inode	*ip)
+{
+	int			error;
+
+	if (!libxfs_inode_hasattr(ip))
+		return 0;
+
+	if (ip->i_af.if_format == XFS_DINODE_FMT_LOCAL)
+		return list_sf_pptrs(ip);
+
+	/* attr functions require that the attr fork is loaded */
+	error = -libxfs_iread_extents(NULL, ip, XFS_ATTR_FORK);
+	if (error)
+		return error;
+
+	if (libxfs_attr_is_leaf(ip))
+		return list_leaf_pptrs(ip);
+
+	return list_node_pptrs(ip);
+}
+
+/* If the io cursor points to a file, list its parents. */
+static int
+parent_cur(
+	char			*tag)
+{
+	struct xfs_inode	*ip;
+	int			error = 0;
+
+	if (!xfs_has_parent(mp))
+		return 0;
+
+	if (iocur_top->typ != &typtab[TYP_INODE])
+		return ENOTDIR;
+
+	error = -libxfs_iget(mp, NULL, iocur_top->ino, 0, &ip);
+	if (error)
+		return error;
+
+	/* List the parents of a file. */
+	if (tag)
+		dbprintf(_("%s:\n"), tag);
+
+	error = list_pptrs(ip);
+	if (error)
+		goto rele;
+
+rele:
+	libxfs_irele(ip);
+	return error;
+}
+
+static void
+parent_help(void)
+{
+	dbprintf(_(
+"\n"
+" List the parents of the currently selected file.\n"
+"\n"
+" Parent pointers will be listed in the format:\n"
+" inode_number:inode_gen	ondisk_namehash:namehash	name_length	name\n"
+	));
+}
+
+static int
+parent_f(
+	int			argc,
+	char			**argv)
+{
+	int			c;
+	int			error = 0;
+
+	while ((c = getopt(argc, argv, "")) != -1) {
+		switch (c) {
+		default:
+			ls_help();
+			return 0;
+		}
+	}
+
+	if (optind == argc) {
+		error = parent_cur(NULL);
+		if (error) {
+			dbprintf("%s\n", strerror(error));
+			exitcode = 1;
+		}
+
+		return 0;
+	}
+
+	for (c = optind; c < argc; c++) {
+		push_cur();
+
+		error = path_walk(argv[c]);
+		if (error)
+			goto err_cur;
+
+		error = parent_cur(argv[c]);
+		if (error)
+			goto err_cur;
+
+		pop_cur();
+	}
+
+	return 0;
+err_cur:
+	pop_cur();
+	if (error) {
+		dbprintf("%s: %s\n", argv[c], strerror(error));
+		exitcode = 1;
+	}
+	return 0;
+}
+
+static struct cmdinfo parent_cmd = {
+	.name		= "parent",
+	.altname	= "pptr",
+	.cfunc		= parent_f,
+	.argmin		= 0,
+	.argmax		= -1,
+	.canpush	= 0,
+	.args		= "[paths...]",
+	.help		= parent_help,
+};
+
 void
 namei_init(void)
 {
@@ -606,4 +938,7 @@ namei_init(void)
 
 	ls_cmd.oneline = _("list directory contents");
 	add_command(&ls_cmd);
+
+	parent_cmd.oneline = _("list parent pointers");
+	add_command(&parent_cmd);
 }
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 22e4c569170..7ea7eebfbca 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -189,6 +189,7 @@
 #define xfs_parent_hashcheck		libxfs_parent_hashcheck
 #define xfs_parent_namecheck		libxfs_parent_namecheck
 #define xfs_parent_valuecheck		libxfs_parent_valuecheck
+#define xfs_parent_verify_irec		libxfs_parent_verify_irec
 #define xfs_perag_get			libxfs_perag_get
 #define xfs_perag_hold			libxfs_perag_hold
 #define xfs_perag_put			libxfs_perag_put
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index a7f6d55ed8b..937b17e79a3 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -943,6 +943,15 @@ See the
 .B print
 command.
 .TP
+.BI "parent [" paths "]..."
+List the parents of a file.
+If a path resolves to a file, the parents of that file will be listed.
+If no paths are supplied and the IO cursor points at an inode, the parents of
+that file will be listed.
+
+The output format is:
+inode number, inode generation, ondisk namehash, namehash, name length, name.
+.TP
 .BI "path " dir_path
 Walk the directory tree to an inode using the supplied path.
 Absolute and relative paths are supported.

