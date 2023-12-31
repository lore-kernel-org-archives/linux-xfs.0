Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD0CC2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QeDCsquW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59656C433C7;
	Sun, 31 Dec 2023 23:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066220;
	bh=X6tgdC5ODeXmt3P3R1uhRCi8QKXDbbLcJaELMaj1G/Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QeDCsquWDch6/FS+KMVlGSZH3i2wHryzsboo2pP6BZj80EMwAmj7AybTpqL/F/qnl
	 lYRbHxH/niahwbC6rLo8nup5FOoa2t2NeTln7mpyQXr30ZPEcfDMwmIEiuHLia2nvO
	 KwOmVYr/WTNEsNxWqbkvbiv3+skiB7oApWH52MJyb3hjp9+VdR5AN5R7QlvHmB9bmO
	 Z8DQTV9mTmQpiKAt5CJ9tRZT0udrniI0s9+iqWg+5oNbVX3NKjO/YkTEk95ExxqZrV
	 fkB+L3JxnLghTKtgZR6OmdcF9fb/CPyU4ArrtiJzUR4pe+ZUFQzI8SQRg7TcLrWr4N
	 WzRLMMD4voMNw==
Date: Sun, 31 Dec 2023 15:43:39 -0800
Subject: [PATCH 54/58] xfs_repair: truncate and unmark orphaned metadata
 inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010667.1809361.3276857935166080301.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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
index c7cfc371ac2..a99793b4d90 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1273,6 +1273,53 @@ mk_orphanage(
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
+	ip->i_diflags2 &= ~XFS_DIFLAG2_METADIR;
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
@@ -1362,6 +1409,9 @@ mv_orphanage(
 	if (err)
 		do_error(_("%d - couldn't iget disconnected inode\n"), err);
 
+	if (xfs_is_metadir_inode(ino_p))
+		trunc_metadata_inode(ino_p);
+
 	xname.type = libxfs_mode_to_ftype(VFS_I(ino_p)->i_mode);
 
 	if (isa_dir)  {

