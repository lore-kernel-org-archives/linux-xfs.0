Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B97C12BF17
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998977; cv=none; b=JEOyTt4ffr4Z/thpIpweLZelzRx7Sd3JyG/gBX8nHHQraFk+SZ+jD+ePjvRoWcZrXtfm5x84wX3ux3N6LZEdAJOP9eUNutv5ULI8T7+wT38CbvjRNxJMkrrlaQh4z1MVHzHgPjy4PeeA15HL2wIh902Gye/O1SIBbbVN4GsYO4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998977; c=relaxed/simple;
	bh=/2TRymqznSIRb1u4AXkxfrlF50drOHbBMDHG4ERiNXg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ePEsSJAFR1nOlJ4Gss1iYE54dh2uJxZZ7lEdvOG7txLfvIqlhOIRcxnYPO7Cl0rhx6vEKtqXT8xjIGIlBhrIZ9sQanL0L2AWcrTe0AiI8Dx/uh7U6lsUd7s3ZVIMFUMPYdZpRBR1Nr7TluZVWKK+aW8Z/pVpIbIvhfrWzoL/mqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=beUVwdbk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="beUVwdbk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B625DC433F1
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998977;
	bh=/2TRymqznSIRb1u4AXkxfrlF50drOHbBMDHG4ERiNXg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=beUVwdbkVDiUMB7ozP2BB9pBwEdY5v6XG9yMy64WuNndQTlQG9EsEug/EG0EtaU7s
	 lKyrAsscFRs3efHKVX1xSUJQLGFCD3cgHcSGs5sxnvowIepvoZIRlP/A2WmN2r/kPK
	 /h46V/OLip+Bfg0+QFRXHLej+W9KfefOjNGSZe1Zo6l+b8wIOJypYSNt0JPvUL3PDy
	 M6OUeqj8+7SAp02lemGADokNWVhDpXcxPK+10x4pS3Nz4tSIY2UpcXGk1YHoyLG5VZ
	 D2DwbcgzMFyzd/mflDzTiOJGJ0KLeqkxx0Q60z/rJ/c27ohxznBZzu/AhaekZS2PQ1
	 aP1UC+gUE1RbQ==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 21/35] xfs: convert to new timestamp accessors
Date: Thu, 15 Feb 2024 13:08:33 +0100
Message-ID: <20240215120907.1542854-22-cem@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240215120907.1542854-1-cem@kernel.org>
References: <20240215120907.1542854-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jeff Layton <jlayton@kernel.org>

Source kernel commit: 75d1e312bbbd175fa27ffdd4c4fe9e8cc7d047ec

Convert to using the new inode timestamp accessor functions.

[Carlos: Also partially port 077c212f0344ae and 12cd4402365166]
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://lore.kernel.org/r/20231004185347.80880-75-jlayton@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 include/xfs_inode.h      | 74 ++++++++++++++++++++++++++++++++++++++--
 libxfs/util.c            |  2 +-
 libxfs/xfs_inode_buf.c   | 10 +++---
 libxfs/xfs_rtbitmap.c    |  6 +++-
 libxfs/xfs_trans_inode.c |  2 +-
 mkfs/proto.c             |  2 +-
 6 files changed, 86 insertions(+), 10 deletions(-)

diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 986815e5c..a351bb0d9 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -41,8 +41,8 @@ struct inode {
 	unsigned long		i_state; /* Not actually used in userspace */
 	uint32_t		i_generation;
 	uint64_t		i_version;
-	struct timespec64	i_atime;
-	struct timespec64	i_mtime;
+	struct timespec64	__i_atime;
+	struct timespec64	__i_mtime;
 	struct timespec64	__i_ctime; /* use inode_*_ctime accessors! */
 	spinlock_t		i_lock;
 };
@@ -69,6 +69,76 @@ static inline void ihold(struct inode *inode)
 	inode->i_count++;
 }
 
+static inline time64_t inode_get_atime_sec(const struct inode *inode)
+{
+	return inode->__i_atime.tv_sec;
+}
+
+static inline long inode_get_atime_nsec(const struct inode *inode)
+{
+	return inode->__i_atime.tv_nsec;
+}
+
+static inline struct timespec64 inode_get_atime(const struct inode *inode)
+{
+	return inode->__i_atime;
+}
+
+static inline struct timespec64 inode_set_atime_to_ts(struct inode *inode,
+						      struct timespec64 ts)
+{
+	inode->__i_atime = ts;
+	return ts;
+}
+
+static inline struct timespec64 inode_set_atime(struct inode *inode,
+						time64_t sec, long nsec)
+{
+	struct timespec64 ts = { .tv_sec = sec,
+				 .tv_nsec = nsec };
+	return inode_set_atime_to_ts(inode, ts);
+}
+
+static inline time64_t inode_get_mtime_sec(const struct inode *inode)
+{
+	return inode->__i_mtime.tv_sec;
+}
+
+static inline long inode_get_mtime_nsec(const struct inode *inode)
+{
+	return inode->__i_mtime.tv_nsec;
+}
+
+static inline struct timespec64 inode_get_mtime(const struct inode *inode)
+{
+	return inode->__i_mtime;
+}
+
+static inline struct timespec64 inode_set_mtime_to_ts(struct inode *inode,
+						      struct timespec64 ts)
+{
+	inode->__i_mtime = ts;
+	return ts;
+}
+
+static inline struct timespec64 inode_set_mtime(struct inode *inode,
+						time64_t sec, long nsec)
+{
+	struct timespec64 ts = { .tv_sec = sec,
+				 .tv_nsec = nsec };
+	return inode_set_mtime_to_ts(inode, ts);
+}
+
+static inline time64_t inode_get_ctime_sec(const struct inode *inode)
+{
+	return inode->__i_ctime.tv_sec;
+}
+
+static inline long inode_get_ctime_nsec(const struct inode *inode)
+{
+	return inode->__i_ctime.tv_nsec;
+}
+
 static inline struct timespec64 inode_get_ctime(const struct inode *inode)
 {
 	return inode->__i_ctime;
diff --git a/libxfs/util.c b/libxfs/util.c
index 8f79b0cd1..8517bfb64 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -291,7 +291,7 @@ libxfs_init_new_inode(
 		if (!pip)
 			ip->i_diflags2 = xfs_flags2diflags2(ip,
 							fsx->fsx_xflags);
-		ip->i_crtime = VFS_I(ip)->i_mtime; /* struct copy */
+		ip->i_crtime = inode_get_mtime(VFS_I(ip)); /* struct copy */
 		ip->i_cowextsize = pip ? 0 : fsx->fsx_cowextsize;
 	}
 
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index fccab4193..74a1bd227 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -217,8 +217,10 @@ xfs_inode_from_disk(
 	 * a time before epoch is converted to a time long after epoch
 	 * on 64 bit systems.
 	 */
-	inode->i_atime = xfs_inode_from_disk_ts(from, from->di_atime);
-	inode->i_mtime = xfs_inode_from_disk_ts(from, from->di_mtime);
+	inode_set_atime_to_ts(inode,
+			      xfs_inode_from_disk_ts(from, from->di_atime));
+	inode_set_mtime_to_ts(inode,
+			      xfs_inode_from_disk_ts(from, from->di_mtime));
 	inode_set_ctime_to_ts(inode,
 			      xfs_inode_from_disk_ts(from, from->di_ctime));
 
@@ -312,8 +314,8 @@ xfs_inode_to_disk(
 	to->di_projid_lo = cpu_to_be16(ip->i_projid & 0xffff);
 	to->di_projid_hi = cpu_to_be16(ip->i_projid >> 16);
 
-	to->di_atime = xfs_inode_to_disk_ts(ip, inode->i_atime);
-	to->di_mtime = xfs_inode_to_disk_ts(ip, inode->i_mtime);
+	to->di_atime = xfs_inode_to_disk_ts(ip, inode_get_atime(inode));
+	to->di_mtime = xfs_inode_to_disk_ts(ip, inode_get_mtime(inode));
 	to->di_ctime = xfs_inode_to_disk_ts(ip, inode_get_ctime(inode));
 	to->di_nlink = cpu_to_be32(inode->i_nlink);
 	to->di_gen = cpu_to_be32(inode->i_generation);
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index c635e8c2e..9a8bd93b7 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -974,6 +974,7 @@ xfs_rtfree_extent(
 	xfs_mount_t	*mp;		/* file system mount structure */
 	xfs_fsblock_t	sb;		/* summary file block number */
 	struct xfs_buf	*sumbp = NULL;	/* summary file block buffer */
+	struct timespec64 atime;
 
 	mp = tp->t_mountp;
 
@@ -1003,7 +1004,10 @@ xfs_rtfree_extent(
 	    mp->m_sb.sb_rextents) {
 		if (!(mp->m_rbmip->i_diflags & XFS_DIFLAG_NEWRTBM))
 			mp->m_rbmip->i_diflags |= XFS_DIFLAG_NEWRTBM;
-		*(uint64_t *)&VFS_I(mp->m_rbmip)->i_atime = 0;
+
+		atime = inode_get_atime(VFS_I(mp->m_rbmip));
+		atime.tv_sec = 0;
+		inode_set_atime_to_ts(VFS_I(mp->m_rbmip), atime);
 		xfs_trans_log_inode(tp, mp->m_rbmip, XFS_ILOG_CORE);
 	}
 	return 0;
diff --git a/libxfs/xfs_trans_inode.c b/libxfs/xfs_trans_inode.c
index ca8e82376..c171a525c 100644
--- a/libxfs/xfs_trans_inode.c
+++ b/libxfs/xfs_trans_inode.c
@@ -62,7 +62,7 @@ xfs_trans_ichgtime(
 	tv = current_time(inode);
 
 	if (flags & XFS_ICHGTIME_MOD)
-		inode->i_mtime = tv;
+		inode_set_mtime_to_ts(inode, tv);
 	if (flags & XFS_ICHGTIME_CHG)
 		inode_set_ctime_to_ts(inode, tv);
 	if (flags & XFS_ICHGTIME_CREATE)
diff --git a/mkfs/proto.c b/mkfs/proto.c
index ea31cfe5c..e9c633ed3 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -688,7 +688,7 @@ rtinit(
 	mp->m_sb.sb_rbmino = rbmip->i_ino;
 	rbmip->i_disk_size = mp->m_sb.sb_rbmblocks * mp->m_sb.sb_blocksize;
 	rbmip->i_diflags = XFS_DIFLAG_NEWRTBM;
-	*(uint64_t *)&VFS_I(rbmip)->i_atime = 0;
+	inode_set_atime(VFS_I(rbmip), 0, 0);
 	libxfs_trans_log_inode(tp, rbmip, XFS_ILOG_CORE);
 	libxfs_log_sb(tp);
 	mp->m_rbmip = rbmip;
-- 
2.43.0

