Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFD1C2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sIdZJyRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97BE3C433C8;
	Sun, 31 Dec 2023 22:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060951;
	bh=D0k2xenrOs52PF19sxLcFcTGUQtXdtgUufJwNL/qfJY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sIdZJyRESZMO4GR0eoZXNC+au42BTtokvjG5J74OC+8u632cU2iOGd15b9CdE1Y9x
	 EQlIeRhVYNCQwmTFQ7D6ceL+g24U8gCm9Rj8J+q+Rb4A+0YejFjyS6oOz9ubHLK7p1
	 0L5lq52K8JyHbluXyhiYU2Lp2xk7/PMJY9CiPXkqxnmaulSLJWYI4yY1sEov4OsN5O
	 UmO1xYMsKbVpfi7JIqBUWzPJInFfx5NH1K/DYZ6+DEas/6ujwSQjetoDq5wGy9+iro
	 ecdnL7rGm1bvC++K0iAk+ME+MP8sJN64RdRcI4RQ61OEnKzgahTTIkfLJrDqrCvrFV
	 lQVRll8caP70A==
Date: Sun, 31 Dec 2023 14:15:51 -0800
Subject: [PATCH 05/10] libxfs: support in-memory buffer cache targets
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404992849.1794490.842205740134023696.stgit@frogsfrogsfrogs>
In-Reply-To: <170404992774.1794490.2226231791872978170.stgit@frogsfrogsfrogs>
References: <170404992774.1794490.2226231791872978170.stgit@frogsfrogsfrogs>
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

Allow the buffer cache to target in-memory files by connecting it to
xfiles.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_io.h |    3 +++
 libxfs/rdwr.c      |   40 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 41 insertions(+), 2 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 7877e17685b..a20e78338dd 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -27,6 +27,7 @@ struct xfs_buftarg {
 	unsigned long		writes_left;
 	dev_t			bt_bdev;
 	int			bt_bdev_fd;
+	struct xfile		*bt_xfile;
 	unsigned int		flags;
 	struct cache		*bcache;	/* buffer cache */
 };
@@ -39,6 +40,8 @@ struct xfs_buftarg {
 #define XFS_BUFTARG_INJECT_WRITE_FAIL	(1 << 2)
 /* purge buffers when lookups find a size mismatch */
 #define XFS_BUFTARG_MISCOMPARE_PURGE	(1 << 3)
+/* use bt_xfile instead of bt_bdev/bt_bdev_fd */
+#define XFS_BUFTARG_XFILE		(1 << 4)
 
 /* Simulate the system crashing after a certain number of writes. */
 static inline void
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index f791136c982..645c4b7838d 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -18,7 +18,7 @@
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "libfrog/platform.h"
-
+#include "libxfs/xfile.h"
 #include "libxfs.h"
 
 static void libxfs_brelse(struct cache_node *node);
@@ -69,6 +69,9 @@ libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
 	char		*z;
 	int		error;
 
+	if (btp->flags & XFS_BUFTARG_XFILE)
+		return -EOPNOTSUPP;
+
 	start_offset = LIBXFS_BBTOOFF64(start);
 
 	/* try to use special zeroing methods, fall back to writes if needed */
@@ -578,6 +581,31 @@ libxfs_balloc(
 	return &bp->b_node;
 }
 
+static inline int
+libxfs_buf_ioapply_in_memory(
+	struct xfs_buf		*bp,
+	bool			is_write)
+{
+	struct xfile		*xfile = bp->b_target->bt_xfile;
+	loff_t			pos = BBTOB(xfs_buf_daddr(bp));
+	size_t			size = BBTOB(bp->b_length);
+	int			error;
+
+	if (bp->b_nmaps > 1) {
+		/* We don't need or support multi-map buffers. */
+		ASSERT(0);
+		error = -EIO;
+	} else if (is_write) {
+		error = xfile_obj_store(xfile, bp->b_addr, size, pos);
+	} else {
+		error = xfile_obj_load(xfile, bp->b_addr, size, pos);
+	}
+	if (error)
+		bp->b_error = error;
+	else if (!is_write)
+		bp->b_flags |= LIBXFS_B_UPTODATE;
+	return error;
+}
 
 static int
 __read_buf(int fd, void *buf, int len, off64_t offset, int flags)
@@ -608,6 +636,9 @@ libxfs_readbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, struct xfs_buf *bp,
 
 	ASSERT(len <= bp->b_length);
 
+	if (bp->b_target->flags & XFS_BUFTARG_XFILE)
+		return libxfs_buf_ioapply_in_memory(bp, false);
+
 	error = __read_buf(fd, bp->b_addr, bytes, LIBXFS_BBTOOFF64(blkno), flags);
 	if (!error &&
 	    bp->b_target->bt_bdev == btp->bt_bdev &&
@@ -640,6 +671,9 @@ libxfs_readbufr_map(struct xfs_buftarg *btp, struct xfs_buf *bp, int flags)
 	void	*buf;
 	int	i;
 
+	if (bp->b_target->flags & XFS_BUFTARG_XFILE)
+		return libxfs_buf_ioapply_in_memory(bp, false);
+
 	buf = bp->b_addr;
 	for (i = 0; i < bp->b_nmaps; i++) {
 		off64_t	offset = LIBXFS_BBTOOFF64(bp->b_maps[i].bm_bn);
@@ -858,7 +892,9 @@ libxfs_bwrite(
 		}
 	}
 
-	if (!(bp->b_flags & LIBXFS_B_DISCONTIG)) {
+	if (bp->b_target->flags & XFS_BUFTARG_XFILE) {
+		libxfs_buf_ioapply_in_memory(bp, true);
+	} else if (!(bp->b_flags & LIBXFS_B_DISCONTIG)) {
 		bp->b_error = __write_buf(fd, bp->b_addr, BBTOB(bp->b_length),
 				    LIBXFS_BBTOOFF64(xfs_buf_daddr(bp)),
 				    bp->b_flags);

