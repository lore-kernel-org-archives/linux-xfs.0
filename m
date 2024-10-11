Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EC7391
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609766; cv=none; b=b1hYiCk4GjdQmAAINWiYy6uWnvXC2hCKPV9WOyX6CZLqloOtgPwSSEKBWbkvIGWSAv9tIevxCn60A5yGCo677RxkUS2mBC97clRCQJuvNUKP+7diSw7iAafo0TIiL6aP3irVRqjpZL08Cx8fjxJYzd+JuQcom4iuG9gc8/gCSgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609766; c=relaxed/simple;
	bh=T7STk+zYqBQCAmLoKQe5YbPFAspQ8IQSQLd3SeOiqw4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c48uC/ZwZsIwoGUOWOJ4pY2ubrv4TsTPmBI+cspkjHz1Ezsbkpq6mcdvxsWZ/QfX50hjr4bslEHQalAOyxUSisTL7UgekdDmfFv/4t54SX4nG3DeKBOBhoAUjuizvuK8MXBNc2dTjuTa0fDT6f41gWdzXyx45QTEk3BPYPqldYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JFtyG/m8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JFtyG/m8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D31C4CEC5;
	Fri, 11 Oct 2024 01:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609765;
	bh=T7STk+zYqBQCAmLoKQe5YbPFAspQ8IQSQLd3SeOiqw4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JFtyG/m8YYp842Nc5ZZuTFVJwSzGJHs2u8Xl4SnniwIqO6O4l5WHqeHVB/C9ctwo8
	 iv3x8fZo9V/YVdCo6RXGytBgS4W1S+kz0+vlolCRSK78ch3OAuCCAFp7eIKV3AsqIY
	 LphbDyJe0Hy+Ynj5NgYhbSObU5OAsn13Zg/TbQlbzY/llWG9uYmGj4vWj9UCXmgt7j
	 eZy3k7zNuHlJGCaV7HTCTdrieMvmbAy/nYJ15HDCLUn+V2xroJWi5KC/kClvlYoryC
	 xPKeHuQAuOUfV7TWRmvEm3BwKIKJHJ4C0ZTa0NAx8foiiGOwXUrBp5s8F33iAKszm+
	 M66QMd6iWUQpg==
Date: Thu, 10 Oct 2024 18:22:45 -0700
Subject: [PATCH 33/38] xfs_repair: truncate and unmark orphaned metadata
 inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654484.4183231.1561167273815408420.stgit@frogsfrogsfrogs>
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

If an inode claims to be a metadata inode but wasn't linked in either
directory tree, remove the attr fork and reset the data fork if the
contents weren't regular extent mappings before moving the inode to the
lost+found.

We don't ifree the inode, because it's possible that the inode was not
actually a metadata inode but simply got corrupted due to bitflips or
something, and we'd rather let the sysadmin examine what's left of the
file instead of photorec'ing it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)


diff --git a/repair/phase6.c b/repair/phase6.c
index dd17e8a60d05a3..cc81f5c8b013f4 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -855,6 +855,53 @@ mk_orphanage(
 	return(ino);
 }
 
+/* Don't let metadata inode contents leak to lost+found. */
+static void
+trunc_metadata_inode(
+	struct xfs_inode	*ip)
+{
+	struct xfs_trans	*tp;
+	struct xfs_mount	*mp = ip->i_mount;
+	int			err;
+
+	err = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
+	if (err)
+		do_error(
+	_("space reservation failed (%d), filesystem may be out of space\n"),
+					err);
+
+	libxfs_trans_ijoin(tp, ip, 0);
+	ip->i_diflags2 &= ~XFS_DIFLAG2_METADATA;
+
+	switch (VFS_I(ip)->i_mode & S_IFMT) {
+	case S_IFIFO:
+	case S_IFCHR:
+	case S_IFBLK:
+	case S_IFSOCK:
+		ip->i_df.if_format = XFS_DINODE_FMT_DEV;
+		break;
+	case S_IFREG:
+		switch (ip->i_df.if_format) {
+		case XFS_DINODE_FMT_EXTENTS:
+		case XFS_DINODE_FMT_BTREE:
+			break;
+		default:
+			ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
+			ip->i_df.if_nextents = 0;
+			break;
+		}
+		break;
+	}
+
+	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	err = -libxfs_trans_commit(tp);
+	if (err)
+		do_error(
+	_("truncation of metadata inode 0x%llx failed, err=%d\n"),
+				(unsigned long long)ip->i_ino, err);
+}
+
 /*
  * Add a parent pointer back to the orphanage for any file we're moving into
  * the orphanage, being careful not to trip over any existing parent pointer.
@@ -945,6 +992,9 @@ mv_orphanage(
 	if (err)
 		do_error(_("%d - couldn't iget disconnected inode\n"), err);
 
+	if (xfs_is_metadir_inode(ino_p))
+		trunc_metadata_inode(ino_p);
+
 	xname.type = libxfs_mode_to_ftype(VFS_I(ino_p)->i_mode);
 
 	if (isa_dir)  {

