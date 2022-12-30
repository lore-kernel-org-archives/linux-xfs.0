Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50554C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:49:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235398AbiL3Xt4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:49:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiL3Xtz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:49:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A289064FA
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:49:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27FBE61C39
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882A0C433D2;
        Fri, 30 Dec 2022 23:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672444193;
        bh=Ph6ucvWKe3RU8ouAKR0Y2/T2X47N3FMcHXbTlidONzk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=k7myGQCynSqVmEwbBpZ9Q4r0cn+qkQ/KG4oT8DJvaygoYRwL0kurNPz33DzIhz54s
         sOqvujQeQ8NJyUCKAdWMgiRGnwOidQyjVx92tP1+BzeOkO+kZVavDxOUhTjW4O1h7I
         6rc3TCaqzXy7vmnDi3XAhrrVePvFLStLdTWDOHJWNCTgM8Egm0nMQjCxntB2u9O6sL
         jwud5DuaxtXZBgzn3owT5gj2qgzhuZOjnDT4cTPA/sF2peuloVmhGj319UdBoGEd2v
         MkjB9FlQ0eTN8rIj8WvxalSuveIo4yzpJAZ0ZcoZqKSufVF+bcHEzAH1H5l59AulBs
         mQbHau967LoYw==
Subject: [PATCH 2/3] xfs: move remote symlink target read function to libxfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:51 -0800
Message-ID: <167243843166.699346.3184723834314773941.stgit@magnolia>
In-Reply-To: <167243843134.699346.594115796077510288.stgit@magnolia>
References: <167243843134.699346.594115796077510288.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
index 3ea30adc8220..7b4f2b306bc4 100644
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
@@ -238,3 +241,77 @@ xfs_symlink_shortform_verify(
 
 	return xfs_symlink_sf_verify_struct(ifp->if_u1.if_data, ifp->if_bytes);
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
index a58d536c8b83..7d3acaee0af0 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.h
+++ b/fs/xfs/libxfs/xfs_symlink_remote.h
@@ -19,5 +19,6 @@ void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
 				 struct xfs_inode *ip, struct xfs_ifork *ifp);
 xfs_failaddr_t xfs_symlink_sf_verify_struct(void *sfp, int64_t size);
 xfs_failaddr_t xfs_symlink_shortform_verify(struct xfs_inode *ip);
+int xfs_symlink_remote_read(struct xfs_inode *ip, char *link);
 
 #endif /* __XFS_SYMLINK_REMOTE_H */
diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
index 3c9900b242e4..c134f738bc43 100644
--- a/fs/xfs/scrub/symlink.c
+++ b/fs/xfs/scrub/symlink.c
@@ -60,7 +60,7 @@ xchk_symlink(
 	}
 
 	/* Remote symlink; must read the contents. */
-	error = xfs_readlink_bmap_ilocked(sc->ip, sc->buf);
+	error = xfs_symlink_remote_read(sc->ip, sc->buf);
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
 		goto out;
 	if (strnlen(sc->buf, XFS_SYMLINK_MAXLEN) < len)
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 76f80f958381..710da8dfb7d3 100644
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
@@ -142,7 +69,7 @@ xfs_readlink(
 		memcpy(link, ip->i_df.if_u1.if_data, pathlen + 1);
 		error = 0;
 	} else {
-		error = xfs_readlink_bmap_ilocked(ip, link);
+		error = xfs_symlink_remote_read(ip, link);
 	}
 
  out:
diff --git a/fs/xfs/xfs_symlink.h b/fs/xfs/xfs_symlink.h
index 2586b7e393f3..526ea98315b5 100644
--- a/fs/xfs/xfs_symlink.h
+++ b/fs/xfs/xfs_symlink.h
@@ -10,7 +10,6 @@
 int xfs_symlink(struct user_namespace *mnt_userns, struct xfs_inode *dp,
 		struct xfs_name *link_name, const char *target_path,
 		umode_t mode, struct xfs_inode **ipp);
-int xfs_readlink_bmap_ilocked(struct xfs_inode *ip, char *link);
 int xfs_readlink(struct xfs_inode *ip, char *link);
 int xfs_inactive_symlink(struct xfs_inode *ip);
 

