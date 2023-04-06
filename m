Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E643C7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:38:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237261AbjDFTiz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbjDFTiy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:38:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EEBC94
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:38:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DBB360DED
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBF1C4339B;
        Thu,  6 Apr 2023 19:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809931;
        bh=Vp9r3b3okPwN/zXVxvuEOGE0BDFNYKzsFMknEdN/8JY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=s3HiuF9DMRMmIrJ86VYU5iqHkO8N2fixssbo2BGg72pVMGphXgLkRkcBe2c7P4e0J
         3zaO2NR3jAyCy7Bp6SiVsQpe3HzNepaTVaHGft5TiETiSmKqF56lvo5EN81rlQb9oP
         aJ8sRbR8q09Zan9YVxt9y9mn7g3eKxsIqbuWUUbJHvI+p83VAJl80r7ivbvv9kFTTs
         2TF1XN6IJD+3/E3HOiwpRHjECYIZKt9KpnDv/6yo+Z1+luS0jXEsuwr9UnDysI8Tjj
         Gq+wC8SrmCKjJRq+2+LOeu8jl+qmg32Bdy6pSZ7jXM21w12r8uNUDcWh5nHwzD1NpO
         ZSX3j46QbQE+w==
Date:   Thu, 06 Apr 2023 12:38:51 -0700
Subject: [PATCH 28/32] xfs_db: add a parents command to list the parents of a
 file
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080827925.616793.8896509199935689523.stgit@frogsfrogsfrogs>
In-Reply-To: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
References: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a command to dump the parents of a file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/namei.c        |  335 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_db.8 |    9 +
 2 files changed, 344 insertions(+)


diff --git a/db/namei.c b/db/namei.c
index 063721ca9..98a019d8f 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -596,6 +596,338 @@ static struct cmdinfo ls_cmd = {
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
+	good = hash == irec->p_namehash &&
+	       libxfs_dir2_namecheck(irec->p_name, irec->p_namelen);
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
+	error = -libxfs_attr3_leaf_read(NULL, ip, 0, &leaf_bp);
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
+		error = -libxfs_attr3_leaf_read(NULL, ip, leafhdr.forw,
+				&leaf_bp);
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
 void
 namei_init(void)
 {
@@ -604,4 +936,7 @@ namei_init(void)
 
 	ls_cmd.oneline = _("list directory contents");
 	add_command(&ls_cmd);
+
+	parent_cmd.oneline = _("list parent pointers");
+	add_command(&parent_cmd);
 }
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index fde1c5c6c..02351d1ec 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -884,6 +884,15 @@ See the
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

