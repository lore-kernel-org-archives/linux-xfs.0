Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E5621353
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425381; cv=none; b=MwtLkIBjtChzbSa8OYateyJekjBZDnd/Z7uA8PSySoInvhMBCt1udkUSkPCaSkP2Dt4PMZAXlMrk/0Lemal2qyqGwSQYalsKBTP4fIFh7tBas29fT1czSxiXGMB6pU+hO0qKrinB++NNFOjQeMOaBXGGtWfka6FN9t0/Q7wgy6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425381; c=relaxed/simple;
	bh=i5qyQEr5pjVgEH6RDTlD0uIzJhTgJEwvyQiZPc1hdwg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AbJXLiMTWWlDbH4MxgV8y8qdwcU9XEv+gFcWpJtKFwY0iybFnYP9r6AzvCISzxOSWRyJLILMakVwZCsD3eQsCEgVUur3IC7Q6HkTk2sleEdfzPHurACCzd+P4ctk6m+L3+Zf/uiDmOzFg3C0GAg4sFvWKqBpiManlrWdbyXJ0Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KCc/k3DK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KCc/k3DK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88908C433C7;
	Tue, 26 Mar 2024 03:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425381;
	bh=i5qyQEr5pjVgEH6RDTlD0uIzJhTgJEwvyQiZPc1hdwg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KCc/k3DKjenXuAJ3iFreCql6Q2Lq1W3Bxg+RqA2Se9vUNJdaorlL7OcNwN9spv9HW
	 7Q4FkQxOCIasKV7g+qhpvID1oeff82IP3Fcy0NwP12TtYJUwQbRgrCyzSgud/nR6Qd
	 UFCLNiY/yyYjC3YiwDb1mKnncinlwZF4+JHLyR2FCSDAfIXL+f2SaavCfn2U5q33Na
	 w04dt1Xf2mk+btTBrP0kvHVSthHsajZNrPAsrpbo9XyjPy8cRPxslBwvORZ615ajXR
	 0CYEJ15DbdfKr+7jdCYc4daMnxqYRHCJZtRjb9H5W6IYiVsx/mDupEmoPTK+GvgM9s
	 o27TgO55Jrhng==
Date: Mon, 25 Mar 2024 20:56:21 -0700
Subject: [PATCH 107/110] xfs: move remote symlink target read function to
 libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132919.2215168.13609056082540129702.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: 376b4f0522484f43660dab8e4e92b471863b49f9

Move xfs_readlink_bmap_ilocked to xfs_symlink_remote.c so that the
swapext code can use it to convert a remote format symlink back to
shortform format after a metadata repair.  While we're at it, fix a
broken printf prefix.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_symlink_remote.c |   77 +++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_symlink_remote.h |    1 +
 2 files changed, 78 insertions(+)


diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index 33689ba2eac3..f2e591ea9c9c 100644
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
@@ -225,3 +228,77 @@ xfs_symlink_shortform_verify(
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
+	xfs_assert_ilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL);
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
index c6f621a0ec05..bb83a8b8dfa6 100644
--- a/libxfs/xfs_symlink_remote.h
+++ b/libxfs/xfs_symlink_remote.h
@@ -18,5 +18,6 @@ bool xfs_symlink_hdr_ok(xfs_ino_t ino, uint32_t offset,
 void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
 				 struct xfs_inode *ip, struct xfs_ifork *ifp);
 xfs_failaddr_t xfs_symlink_shortform_verify(void *sfp, int64_t size);
+int xfs_symlink_remote_read(struct xfs_inode *ip, char *link);
 
 #endif /* __XFS_SYMLINK_REMOTE_H */

