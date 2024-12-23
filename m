Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F7F1B395B
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990984; cv=none; b=YSn/YDF33G+4kZSFEakwjmQl3ZMAmfVZ5B1JZ3LLQcb94bGAp1SSlD6MlfZA7QtboZG24yx96B60BAHi7b58OQKzorIbd2AK8a2Cx60nZfEoHt2Dd8DYzwa4nTLAqJ9z/gRQQyBUxzHIm3VVwXNo3crfdiSGQvjiM6JkFO5TrDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990984; c=relaxed/simple;
	bh=92UckHqm+r3FqG5u99FtFM3L6D0VmzLJZt/xcmLkSzA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=haLVi+na8EvLgEFQ3pk5XBb5ZhAxJQO34fvsnj1O4jf0bm32ZULVzctQrktxlfuqA+2rdiZ+kdrKMbYyDZ/HAei7lfgdH27ZOBgc5ng5rEWmMUubh/lzuK9+7XBWjXnq3CbNize8YFeU2lAqHVCu0LSv2vQGhZm89TnmILM6jpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eSsdHjWi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eSsdHjWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B14C4CED3;
	Mon, 23 Dec 2024 21:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990984;
	bh=92UckHqm+r3FqG5u99FtFM3L6D0VmzLJZt/xcmLkSzA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eSsdHjWic0nLVTFHamR6a/HN/5nxNTfMnKi2GRLU5OPI6ITD/ePZatqOVLyugg40o
	 2xU06B1ZobBLgiIUXinHtGjvQ4DzTefbDirKb+DSd1BzXi639zmuLzJ+IsnywpAgHt
	 6UhvbkOOySSBUaQGus70g7aM9uuMhjZLRUhV0/9bFgRcnk3mV1TUJaNMCFmrm3BnVm
	 RNsLrXNvVKtnK+qcpBB6d/Mec4Hxgvo++SoyPKQ+GpzAxK9XOZ9OpUVwrb5seWp4AR
	 u0eXBsNapJ0E/WyP//sjnbfepdmqdABLYkbz4RelOjDQGn9menqJTm8DsGu9Nqnrml
	 lrCMA0IAFnchw==
Date: Mon, 23 Dec 2024 13:56:23 -0800
Subject: [PATCH 38/41] xfs_repair: truncate and unmark orphaned metadata
 inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941551.2294268.13361852125408207098.stgit@frogsfrogsfrogs>
In-Reply-To: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
References: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/phase6.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)


diff --git a/repair/phase6.c b/repair/phase6.c
index 8fa2c3c8bf0419..3dd67f7e0ec051 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -853,6 +853,53 @@ mk_orphanage(
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
@@ -943,6 +990,9 @@ mv_orphanage(
 	if (err)
 		do_error(_("%d - couldn't iget disconnected inode\n"), err);
 
+	if (xfs_is_metadir_inode(ino_p))
+		trunc_metadata_inode(ino_p);
+
 	xname.type = libxfs_mode_to_ftype(VFS_I(ino_p)->i_mode);
 
 	if (isa_dir)  {

