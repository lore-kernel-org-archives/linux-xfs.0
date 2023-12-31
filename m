Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A43FC127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eij0gyec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A12FC433C7;
	Sun, 31 Dec 2023 22:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061592;
	bh=NiXPCmVco1aWO6DMQibfNuuGzdpqWcSGtG9Bjvw3zms=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eij0gyecc8Lvs4zvM+Tay7kLg6KGl5KrZ/ESw8syJdg45ccOMCYJpChnO6CBbLkXY
	 5v9GMmNvpoXyEhtZ8PvF+/Lui7BgcbfvYTk7GCZgU1zH0GFbh/43fXfpKP/PqTg8VD
	 WzVrdGp+YtLhKeclI/PiiKa99BJ1zGFpjQfpkILnstPXi+hzm5M/o/r+TzEoIUlS4B
	 aEBTUWPFJjf+Y5v/WTb8cxD6M9qGmEoCQavmpHfJc8IjzHHSp06j/9U/mBDlExUP04
	 3booVXJOb4hQ2Hy79QEChvfiBCal9E/eaYhmZBD5LnCrBwZo2ilpai0WRL2aZDk0vL
	 BKYE0prM9J/0g==
Date: Sun, 31 Dec 2023 14:26:31 -0800
Subject: [PATCH 2/4] xfs: move remote symlink target read function to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404995907.1795978.7021937513451333513.stgit@frogsfrogsfrogs>
In-Reply-To: <170404995879.1795978.16481180835947373560.stgit@frogsfrogsfrogs>
References: <170404995879.1795978.16481180835947373560.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_symlink_remote.c |   77 +++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_symlink_remote.h |    1 +
 2 files changed, 78 insertions(+)


diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index a989ce2f3f2..8f251ae6799 100644
--- a/libxfs/xfs_symlink_remote.c
+++ b/libxfs/xfs_symlink_remote.c
@@ -14,6 +14,9 @@
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_symlink_remote.h"
+#include "xfs_bit.h"
+#include "xfs_bmap.h"
+#include "xfs_health.h"
 
 /*
  * Each contiguous block has a header, so it is not just a simple pathlen
@@ -224,3 +227,77 @@ xfs_symlink_shortform_verify(
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
diff --git a/libxfs/xfs_symlink_remote.h b/libxfs/xfs_symlink_remote.h
index c6f621a0ec0..bb83a8b8dfa 100644
--- a/libxfs/xfs_symlink_remote.h
+++ b/libxfs/xfs_symlink_remote.h
@@ -18,5 +18,6 @@ bool xfs_symlink_hdr_ok(xfs_ino_t ino, uint32_t offset,
 void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
 				 struct xfs_inode *ip, struct xfs_ifork *ifp);
 xfs_failaddr_t xfs_symlink_shortform_verify(void *sfp, int64_t size);
+int xfs_symlink_remote_read(struct xfs_inode *ip, char *link);
 
 #endif /* __XFS_SYMLINK_REMOTE_H */

