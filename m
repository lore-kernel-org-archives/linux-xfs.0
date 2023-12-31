Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75719C2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LzLjOlun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43CE7C433C8;
	Sun, 31 Dec 2023 23:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065110;
	bh=Q8IBQ5cFJ9Qzf+orw3ibhMIbjAnnh7t431XLrWkRX5M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LzLjOlunDsd8uR1Q3s2NBbAUB6E2Qr9v6JkfzdPH/T8Am68jL5+mGrULzqKREI9LX
	 FjksatKgVRA9AWCYWExX97hQlciH6phQfYA5kEZTM94rXByu+xWidYH49cDh+/jiEv
	 0Fltb2bzl11fNjk/YNN6TzBK4IfGLFD09Lh6PfcXiYwymiiMZiMc0WaaNskBwB+AsP
	 wsH5h0u9AR/pvMTj51I7wrEcXKNJy4FPLj8vrZ0VKy3xjTpdUW31SGpLXagptjkvRe
	 Q7b4S911SUtSbTErCt/la0O3qj0fzc0g8zhhKV7o3cVlC5E2FuseGDuxDNFEqh4Ww0
	 MLKmLg4YpzsKg==
Date: Sun, 31 Dec 2023 15:25:09 -0800
Subject: [PATCH 11/28] libxfs: pass flags2 from parent to child when creating
 files
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009323.1808635.14260753186484818050.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
References: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
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

When mkfs creates a new file as a child of an existing directory, we
should propagate the flags2 field from parent to child like the kernel
does.  This ensures that mkfs propagates cowextsize hints properly when
protofiles are in use.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/inode.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)


diff --git a/libxfs/inode.c b/libxfs/inode.c
index e34b8e4b194..518c8b45371 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -59,6 +59,20 @@ xfs_inode_propagate_flags(
 	ip->i_diflags |= di_flags;
 }
 
+/* Propagate di_flags2 from a parent inode to a child inode. */
+static void
+xfs_inode_inherit_flags2(
+	struct xfs_inode	*ip,
+	const struct xfs_inode	*pip)
+{
+	if (pip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) {
+		ip->i_diflags2 |= XFS_DIFLAG2_COWEXTSIZE;
+		ip->i_cowextsize = pip->i_cowextsize;
+	}
+	if (pip->i_diflags2 & XFS_DIFLAG2_DAX)
+		ip->i_diflags2 |= XFS_DIFLAG2_DAX;
+}
+
 /*
  * Increment the link count on an inode & log the change.
  */
@@ -141,6 +155,8 @@ libxfs_icreate(
 	case S_IFDIR:
 		if (pip && (pip->i_diflags & XFS_DIFLAG_ANY))
 			xfs_inode_propagate_flags(ip, pip);
+		if (pip && (pip->i_diflags2 & XFS_DIFLAG2_ANY))
+			xfs_inode_inherit_flags2(ip, pip);
 		/* FALLTHROUGH */
 	case S_IFLNK:
 		ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;

