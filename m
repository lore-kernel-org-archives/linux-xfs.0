Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8268BA30
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NSltnxQC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73966C433C7;
	Sun, 31 Dec 2023 20:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054239;
	bh=4vYDHkxsfoBljpadNfXYuVeAgyjU7euq9BxLwRDKSiI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NSltnxQCvecw15TY0PsqnE4Cjy79wK62SNZu2dhLKySzUWGkpmjbTesAPPtC327Ya
	 aD8HlrLBslPrBV4rExY1dhdbcOVtAMcUcBvVeSzyLkOXaX2tGxW1mOpcWVjHSuYXsF
	 ebarA6ybgzFomg8f5YbznoPqEIA5BEWSzhhwQpVnh6g5brPxr/4uhtpHzKJZ74p0Ql
	 7PbKfkYrgWl+oCXm3d0rIVG0kTO6zbBWkOGkKegXimTCxk+jruOhkKVUujL99k7Bww
	 oL6WCh3Jer9aYoqMHiFoKNgJcFPIOTyoumDl9k3Spgqv55fS0mEqUcnluGlkd044Fs
	 SmR+K0j7K8T+w==
Date: Sun, 31 Dec 2023 12:23:59 -0800
Subject: [PATCH 2/3] xfs: move remote symlink target read function to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404832680.1750161.6114741655557405167.stgit@frogsfrogsfrogs>
In-Reply-To: <170404832640.1750161.7474736298870522543.stgit@frogsfrogsfrogs>
References: <170404832640.1750161.7474736298870522543.stgit@frogsfrogsfrogs>
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

Move xfs_readlink_bmap_ilocked to xfs_symlink_remote.c so that the
swapext code can use it to convert a remote format symlink back to
shortform format after a metadata repair.  While we're at it, fix a
broken printf prefix.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_symlink_remote.c |   77 ++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_symlink_remote.h |    1 
 fs/xfs/scrub/symlink.c             |    2 -
 fs/xfs/xfs_symlink.c               |   75 -----------------------------------
 fs/xfs/xfs_symlink.h               |    1 
 5 files changed, 80 insertions(+), 76 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index a809a784d1741..b1ab6bdc3834e 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -17,6 +17,9 @@
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
 #include "xfs_symlink_remote.h"
+#include "xfs_bit.h"
+#include "xfs_bmap.h"
+#include "xfs_health.h"
 
 /*
  * Each contiguous block has a header, so it is not just a simple pathlen
@@ -227,3 +230,77 @@ xfs_symlink_shortform_verify(
 		return __this_address;
 	return NULL;
 }
+
+/* Read a remote symlink target into the buffer. */
+int
+xfs_symlink_remote_read(
+	struct xfs_inode	*ip,
+	char			*link)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_bmbt_irec	mval[XFS_SYMLINK_MAPS];
+	struct xfs_buf		*bp;
+	xfs_daddr_t		d;
+	char			*cur_chunk;
+	int			pathlen = ip->i_disk_size;
+	int			nmaps = XFS_SYMLINK_MAPS;
+	int			byte_cnt;
+	int			n;
+	int			error = 0;
+	int			fsblocks = 0;
+	int			offset;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
+
+	fsblocks = xfs_symlink_blocks(mp, pathlen);
+	error = xfs_bmapi_read(ip, 0, fsblocks, mval, &nmaps, 0);
+	if (error)
+		goto out;
+
+	offset = 0;
+	for (n = 0; n < nmaps; n++) {
+		d = XFS_FSB_TO_DADDR(mp, mval[n].br_startblock);
+		byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
+
+		error = xfs_buf_read(mp->m_ddev_targp, d, BTOBB(byte_cnt), 0,
+				&bp, &xfs_symlink_buf_ops);
+		if (xfs_metadata_is_sick(error))
+			xfs_inode_mark_sick(ip, XFS_SICK_INO_SYMLINK);
+		if (error)
+			return error;
+		byte_cnt = XFS_SYMLINK_BUF_SPACE(mp, byte_cnt);
+		if (pathlen < byte_cnt)
+			byte_cnt = pathlen;
+
+		cur_chunk = bp->b_addr;
+		if (xfs_has_crc(mp)) {
+			if (!xfs_symlink_hdr_ok(ip->i_ino, offset,
+							byte_cnt, bp)) {
+				xfs_inode_mark_sick(ip, XFS_SICK_INO_SYMLINK);
+				error = -EFSCORRUPTED;
+				xfs_alert(mp,
+"symlink header does not match required off/len/owner (0x%x/0x%x,0x%llx)",
+					offset, byte_cnt, ip->i_ino);
+				xfs_buf_relse(bp);
+				goto out;
+
+			}
+
+			cur_chunk += sizeof(struct xfs_dsymlink_hdr);
+		}
+
+		memcpy(link + offset, cur_chunk, byte_cnt);
+
+		pathlen -= byte_cnt;
+		offset += byte_cnt;
+
+		xfs_buf_relse(bp);
+	}
+	ASSERT(pathlen == 0);
+
+	link[ip->i_disk_size] = '\0';
+	error = 0;
+
+ out:
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.h b/fs/xfs/libxfs/xfs_symlink_remote.h
index c6f621a0ec053..bb83a8b8dfa66 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.h
+++ b/fs/xfs/libxfs/xfs_symlink_remote.h
@@ -18,5 +18,6 @@ bool xfs_symlink_hdr_ok(xfs_ino_t ino, uint32_t offset,
 void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
 				 struct xfs_inode *ip, struct xfs_ifork *ifp);
 xfs_failaddr_t xfs_symlink_shortform_verify(void *sfp, int64_t size);
+int xfs_symlink_remote_read(struct xfs_inode *ip, char *link);
 
 #endif /* __XFS_SYMLINK_REMOTE_H */
diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
index 06f8fe117cb4c..7239590c9dd29 100644
--- a/fs/xfs/scrub/symlink.c
+++ b/fs/xfs/scrub/symlink.c
@@ -68,7 +68,7 @@ xchk_symlink(
 	}
 
 	/* Remote symlink; must read the contents. */
-	error = xfs_readlink_bmap_ilocked(sc->ip, sc->buf);
+	error = xfs_symlink_remote_read(sc->ip, sc->buf);
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
 		return error;
 	if (strnlen(sc->buf, XFS_SYMLINK_MAXLEN) < len)
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index ca1daf8245fa6..0a9a1ad733336 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -27,79 +27,6 @@
 #include "xfs_symlink_remote.h"
 
 /* ----- Kernel only functions below ----- */
-int
-xfs_readlink_bmap_ilocked(
-	struct xfs_inode	*ip,
-	char			*link)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_bmbt_irec	mval[XFS_SYMLINK_MAPS];
-	struct xfs_buf		*bp;
-	xfs_daddr_t		d;
-	char			*cur_chunk;
-	int			pathlen = ip->i_disk_size;
-	int			nmaps = XFS_SYMLINK_MAPS;
-	int			byte_cnt;
-	int			n;
-	int			error = 0;
-	int			fsblocks = 0;
-	int			offset;
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
-
-	fsblocks = xfs_symlink_blocks(mp, pathlen);
-	error = xfs_bmapi_read(ip, 0, fsblocks, mval, &nmaps, 0);
-	if (error)
-		goto out;
-
-	offset = 0;
-	for (n = 0; n < nmaps; n++) {
-		d = XFS_FSB_TO_DADDR(mp, mval[n].br_startblock);
-		byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
-
-		error = xfs_buf_read(mp->m_ddev_targp, d, BTOBB(byte_cnt), 0,
-				&bp, &xfs_symlink_buf_ops);
-		if (xfs_metadata_is_sick(error))
-			xfs_inode_mark_sick(ip, XFS_SICK_INO_SYMLINK);
-		if (error)
-			return error;
-		byte_cnt = XFS_SYMLINK_BUF_SPACE(mp, byte_cnt);
-		if (pathlen < byte_cnt)
-			byte_cnt = pathlen;
-
-		cur_chunk = bp->b_addr;
-		if (xfs_has_crc(mp)) {
-			if (!xfs_symlink_hdr_ok(ip->i_ino, offset,
-							byte_cnt, bp)) {
-				xfs_inode_mark_sick(ip, XFS_SICK_INO_SYMLINK);
-				error = -EFSCORRUPTED;
-				xfs_alert(mp,
-"symlink header does not match required off/len/owner (0x%x/Ox%x,0x%llx)",
-					offset, byte_cnt, ip->i_ino);
-				xfs_buf_relse(bp);
-				goto out;
-
-			}
-
-			cur_chunk += sizeof(struct xfs_dsymlink_hdr);
-		}
-
-		memcpy(link + offset, cur_chunk, byte_cnt);
-
-		pathlen -= byte_cnt;
-		offset += byte_cnt;
-
-		xfs_buf_relse(bp);
-	}
-	ASSERT(pathlen == 0);
-
-	link[ip->i_disk_size] = '\0';
-	error = 0;
-
- out:
-	return error;
-}
-
 int
 xfs_readlink(
 	struct xfs_inode	*ip,
@@ -141,7 +68,7 @@ xfs_readlink(
 		memcpy(link, ip->i_df.if_u1.if_data, pathlen + 1);
 		error = 0;
 	} else {
-		error = xfs_readlink_bmap_ilocked(ip, link);
+		error = xfs_symlink_remote_read(ip, link);
 	}
 
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
diff --git a/fs/xfs/xfs_symlink.h b/fs/xfs/xfs_symlink.h
index d1ca1ce62a93b..0d29a50e66fdc 100644
--- a/fs/xfs/xfs_symlink.h
+++ b/fs/xfs/xfs_symlink.h
@@ -10,7 +10,6 @@
 int xfs_symlink(struct mnt_idmap *idmap, struct xfs_inode *dp,
 		struct xfs_name *link_name, const char *target_path,
 		umode_t mode, struct xfs_inode **ipp);
-int xfs_readlink_bmap_ilocked(struct xfs_inode *ip, char *link);
 int xfs_readlink(struct xfs_inode *ip, char *link);
 int xfs_inactive_symlink(struct xfs_inode *ip);
 

