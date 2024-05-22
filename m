Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E524933F9
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347802; cv=none; b=IRgFomy2C4Q+c2ZOkLEaPHnd6SM9NXAVP2AFgFlEkCdQeZpkq7AniG6o4sUPn8+DQgtVJk/Tn41Ge6GgO2zX68ABo5b0wHDFk9x46thi8soQlTDTJC4Jc6Sf1/BWZ+LJHWLQ5vQIlq86v0qleoTNwmz0FBkl/3ZKSPWAaajK05Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347802; c=relaxed/simple;
	bh=ubriXKeTXvLeB7wCypDQxl4etsGmguF65l8ZAY4rfqc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kGNPX0HVxJYzQROyUtnqjyQnaQX6iuIkOP/IfS/CYxscSlBcwWlUacaQRkQNZ28uXvFTNc7DFZKksZDL74maBtA+dl8UBTNBmsd+lUFnlGcAwwlRQqzdQbwa+UJOjYVr/2u4wsAxXQfQM8XJVefeXxpMe/Ut+jsblqjhAWOs1zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QVaurkxf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QVaurkxf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F61EC2BD11;
	Wed, 22 May 2024 03:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347801;
	bh=ubriXKeTXvLeB7wCypDQxl4etsGmguF65l8ZAY4rfqc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QVaurkxfK80Ut4HyLGPg+P+inVZyhIl9wFxNuX4lmsA4ZrYJFXN/I/FGuhCI3yjqG
	 rd5SEgX04SwgDTizrwtMyclmz1WVSUdykHj8byRJqRCRYNwoBFBrky+x7swnyc3A6L
	 Tm8zHBzYkFfeDc1NFPtiNzFyVYqqLbLJWC1ZcUvtAmpua6XOG7WeS+TLvjG4wSxOFj
	 S9M3eFy39lqPSr/310PyWNWP+v+hG4+Zo5GvMUtv0BfIOmabCa9u6VG4RHI2MXi3YB
	 7LMnaYITz0F2BS3Wc34dFORiHPEewb2eJMVK9j1s15b3qgpYdb7A9KZsgVWrKpwSqj
	 YGkRshcuQpZ7A==
Date: Tue, 21 May 2024 20:16:40 -0700
Subject: [PATCH 107/111] xfs: move remote symlink target read function to
 libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634533309.2478931.3323956381923402919.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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
index 33689ba2e..f2e591ea9 100644
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
index c6f621a0e..bb83a8b8d 100644
--- a/libxfs/xfs_symlink_remote.h
+++ b/libxfs/xfs_symlink_remote.h
@@ -18,5 +18,6 @@ bool xfs_symlink_hdr_ok(xfs_ino_t ino, uint32_t offset,
 void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
 				 struct xfs_inode *ip, struct xfs_ifork *ifp);
 xfs_failaddr_t xfs_symlink_shortform_verify(void *sfp, int64_t size);
+int xfs_symlink_remote_read(struct xfs_inode *ip, char *link);
 
 #endif /* __XFS_SYMLINK_REMOTE_H */

