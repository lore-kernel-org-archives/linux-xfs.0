Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63B72BD030;
	Tue, 17 Feb 2026 23:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771370501; cv=none; b=as9XOzT66CtrpqwbklmdxeangJ/DSzofj3WA4KwBlmuLwNWSNhp4h2Yk0Se4JvBVjAcfgA9uuTPGzrtNKv9Nu9cQprz9EegZwgybcHAmIgum8eRDF36lp3HAVIIic7Yp6ayyxWx86ZBLOtRKb/5xAathen+oHZ457MbeJLo05xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771370501; c=relaxed/simple;
	bh=quSnexTs0Pk30pZQBh1iV0RJFkPu+VOBJWh27yUCdVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tR4Rltqv7xUgEfKlBTxNb3/AW5MZyAcXdCGvyydAhPNSdZwGTjaPcU8Hcf/VqSlZmGFFO1aKZPeGeskiSIYTGRpc9gRo4ViUq/OvT2uvzNRkwVAkNic6OdBTgvVJxChz8P38DBHPRkk7D2Lx9OoYRWypGW/B58DOugdId6zWAeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dxJ+paS5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dxJ+paS5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5874C4CEF7;
	Tue, 17 Feb 2026 23:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771370501;
	bh=quSnexTs0Pk30pZQBh1iV0RJFkPu+VOBJWh27yUCdVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dxJ+paS5WxRXXslZBQ/FQt4GZLys8BYdRYK0XUl1zjNtcqN4ohHZdCOJlOaSQKedq
	 B2zm3V1ZNejL+s92GxFztJz464AZ2UmuUPuR31rESUFMktNQWAIVmElaUDzhl4Fdiu
	 NMjda78b7K0plYI/AoW5GyqMEdcn8MQDF5/alV5McMWha5xtIqaLqiEI4hpyDqbHJv
	 njJhAIn0T1vabkGAZ4PxcCbGSqdYba3HznS/HweUZU5EcWmAXQi1BtvFD7/OsBJW0F
	 PRYJi4FWCyiaK7gu9ZSno2hElxYJswBSUBbAjpa/BujIWUXrDOu+8gZ3tnK3mwkv+0
	 Y9K2ncmYcdMuA==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH v3 32/35] xfs: report verity failures through the health system
Date: Wed, 18 Feb 2026 00:19:32 +0100
Message-ID: <20260217231937.1183679-33-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260217231937.1183679-1-aalbersh@kernel.org>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Record verity failures and report them through the health system.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h     |  1 +
 fs/xfs/libxfs/xfs_health.h |  4 +++-
 fs/xfs/xfs_fsverity.c      | 10 ++++++++++
 fs/xfs/xfs_health.c        |  1 +
 4 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index abe5d8e3eed7..36a87276f0b7 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -422,6 +422,7 @@ struct xfs_bulkstat {
 #define XFS_BS_SICK_SYMLINK	(1 << 6)  /* symbolic link remote target */
 #define XFS_BS_SICK_PARENT	(1 << 7)  /* parent pointers */
 #define XFS_BS_SICK_DIRTREE	(1 << 8)  /* directory tree structure */
+#define XFS_BS_SICK_DATA	(1 << 9)  /* file data */
 
 /*
  * Project quota id helpers (previously projid was 16bit only
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index b31000f7190c..fa91916ad072 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -104,6 +104,7 @@ struct xfs_rtgroup;
 /* Don't propagate sick status to ag health summary during inactivation */
 #define XFS_SICK_INO_FORGET	(1 << 12)
 #define XFS_SICK_INO_DIRTREE	(1 << 13)  /* directory tree structure */
+#define XFS_SICK_INO_DATA	(1 << 14)  /* file data */
 
 /* Primary evidence of health problems in a given group. */
 #define XFS_SICK_FS_PRIMARY	(XFS_SICK_FS_COUNTERS | \
@@ -140,7 +141,8 @@ struct xfs_rtgroup;
 				 XFS_SICK_INO_XATTR | \
 				 XFS_SICK_INO_SYMLINK | \
 				 XFS_SICK_INO_PARENT | \
-				 XFS_SICK_INO_DIRTREE)
+				 XFS_SICK_INO_DIRTREE | \
+				 XFS_SICK_INO_DATA)
 
 #define XFS_SICK_INO_ZAPPED	(XFS_SICK_INO_BMBTD_ZAPPED | \
 				 XFS_SICK_INO_BMBTA_ZAPPED | \
diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
index cdbe26ab88b7..5a2874236c3c 100644
--- a/fs/xfs/xfs_fsverity.c
+++ b/fs/xfs/xfs_fsverity.c
@@ -474,6 +474,15 @@ xfs_fsverity_write_merkle(
 	return xfs_fsverity_write(file, position, size, buf);
 }
 
+static void
+xfs_fsverity_file_corrupt(
+	struct inode		*inode,
+	loff_t			pos,
+	size_t			len)
+{
+	xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_DATA);
+}
+
 const struct fsverity_operations xfs_fsverity_ops = {
 	.begin_enable_verity		= xfs_fsverity_begin_enable,
 	.end_enable_verity		= xfs_fsverity_end_enable,
@@ -481,4 +490,5 @@ const struct fsverity_operations xfs_fsverity_ops = {
 	.read_merkle_tree_page		= xfs_fsverity_read_merkle,
 	.readahead_merkle_tree		= xfs_fsverity_readahead_merkle_tree,
 	.write_merkle_tree_block	= xfs_fsverity_write_merkle,
+	.file_corrupt			= xfs_fsverity_file_corrupt,
 };
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 3c1557fb1cf0..b851651c02b2 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -487,6 +487,7 @@ static const struct ioctl_sick_map ino_map[] = {
 	{ XFS_SICK_INO_DIR_ZAPPED,	XFS_BS_SICK_DIR },
 	{ XFS_SICK_INO_SYMLINK_ZAPPED,	XFS_BS_SICK_SYMLINK },
 	{ XFS_SICK_INO_DIRTREE,	XFS_BS_SICK_DIRTREE },
+	{ XFS_SICK_INO_DATA,	XFS_BS_SICK_DATA },
 };
 
 /* Fill out bulkstat health info. */
-- 
2.51.2

