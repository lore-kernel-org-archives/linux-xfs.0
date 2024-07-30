Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262731373
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300639; cv=none; b=ogg8DW2fQmdHD4kropd9icN8ZOK8i+338LfQUpYWYkv5SWrIMgKCnu28ii8bsugqLX9DXxB8K+LpH0wk0WZivuwkrFMnnMivci8Wxo8NS2elv2G0wd2iVnwpYK8TVOE0MsLOowenIQKqDx2UfbZggsneQMPUL6veS3WLBqWeQuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300639; c=relaxed/simple;
	bh=yTrH3zsi6DnqeDzCE7JlQfJ2Ryqi3kvrNEyUiZH6MJk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bb5L/TGCpFpti9/L2vpnu8FFWkrCxj9M9DbIAW+LdCaMQ6XLb5ec/LJaq6MsqTcxWnKsTAP/tMMZmiOuvUsf9US209m4ebdoXu+83s8vStaBWgbVo6nHMcNCgX9Axh7j+EN8dRFJ9jrLD/PwWiAPEzP3FCFWMo/8tcsBHbgCVTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YJXbSgaj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YJXbSgaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19E6C32786;
	Tue, 30 Jul 2024 00:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300639;
	bh=yTrH3zsi6DnqeDzCE7JlQfJ2Ryqi3kvrNEyUiZH6MJk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YJXbSgajuARvsHSko/xhHGWhWL8tdPdT4ckUPQlmIL62yCH2FXGS9Sil3vfQ0Xi3Q
	 pHPhl/FWyzdVa0qguB6aBfusF5K8RBT6WDSkwnYPPcfbWEoTlup4u6q0cMKyvANUDg
	 u/5x9tt4kOoY4f3BrP2Xauosa5pICVJuELvb8nhPgF7ZD/By1GQ0w0Ma1UwCWW1NdF
	 lVUqPsRwikR443HcZmeB3tikOTo+BHb6L9UQQoKLoZLIGoFFIhuaWs5i1F8G3WkLak
	 JfXozOWOHHMsMB+2Z9ywHCPymIM7P1lO5Efc8HsEpyFWF5T8eukj9TI6WW9xjLTTIK
	 YevaG+zY8hBCQ==
Date: Mon, 29 Jul 2024 17:50:38 -0700
Subject: [PATCH 103/115] xfs: turn XFS_ATTR3_RMT_BUF_SPACE into a function
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <172229843903.1338752.16739798694181425064.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: a5714b67cad586f44777ad834e577037ce6b64fd

Turn this into a properly typechecked function, and actually use the
correct blocksize for extended attributes.  The function cannot be
static inline because xfsprogs userspace uses it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/attr.c                |    2 +-
 db/metadump.c            |    8 ++++----
 libxfs/xfs_attr_remote.c |   19 ++++++++++++++++---
 libxfs/xfs_da_format.h   |    4 +---
 4 files changed, 22 insertions(+), 11 deletions(-)


diff --git a/db/attr.c b/db/attr.c
index ba722e146..de68d6276 100644
--- a/db/attr.c
+++ b/db/attr.c
@@ -214,7 +214,7 @@ attr3_remote_data_count(
 
 	if (hdr->rm_magic != cpu_to_be32(XFS_ATTR3_RMT_MAGIC))
 		return 0;
-	buf_space = XFS_ATTR3_RMT_BUF_SPACE(mp, mp->m_sb.sb_blocksize);
+	buf_space = xfs_attr3_rmt_buf_space(mp);
 	if (be32_to_cpu(hdr->rm_bytes) > buf_space)
 		return buf_space;
 	return be32_to_cpu(hdr->rm_bytes);
diff --git a/db/metadump.c b/db/metadump.c
index a656ef574..9457e02e8 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1369,7 +1369,7 @@ add_remote_vals(
 		attr_data.remote_vals[attr_data.remote_val_count] = blockidx;
 		attr_data.remote_val_count++;
 		blockidx++;
-		length -= XFS_ATTR3_RMT_BUF_SPACE(mp, mp->m_sb.sb_blocksize);
+		length -= xfs_attr3_rmt_buf_space(mp);
 	}
 
 	if (attr_data.remote_val_count >= MAX_REMOTE_VALS) {
@@ -1405,8 +1405,8 @@ process_attr_block(
 			    attr_data.remote_vals[i] == offset)
 				/* Macros to handle both attr and attr3 */
 				memset(block +
-					(bs - XFS_ATTR3_RMT_BUF_SPACE(mp, bs)),
-				      'v', XFS_ATTR3_RMT_BUF_SPACE(mp, bs));
+					(bs - xfs_attr3_rmt_buf_space(mp)),
+				      'v', xfs_attr3_rmt_buf_space(mp));
 		}
 		return;
 	}
@@ -1418,7 +1418,7 @@ process_attr_block(
 	if (nentries == 0 ||
 	    nentries * sizeof(xfs_attr_leaf_entry_t) +
 			xfs_attr3_leaf_hdr_size(leaf) >
-				XFS_ATTR3_RMT_BUF_SPACE(mp, bs)) {
+				xfs_attr3_rmt_buf_space(mp)) {
 		if (metadump.show_warnings)
 			print_warning("invalid attr count in inode %llu",
 					(long long)metadump.cur_ino);
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 34e74fd57..58078465b 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -42,6 +42,19 @@
  * the logging system and therefore never have a log item.
  */
 
+/* How many bytes can be stored in a remote value buffer? */
+inline unsigned int
+xfs_attr3_rmt_buf_space(
+	struct xfs_mount	*mp)
+{
+	unsigned int		blocksize = mp->m_attr_geo->blksize;
+
+	if (xfs_has_crc(mp))
+		return blocksize - sizeof(struct xfs_attr3_rmt_hdr);
+
+	return blocksize;
+}
+
 /*
  * Each contiguous block has a header, so it is not just a simple attribute
  * length to FSB conversion.
@@ -52,7 +65,7 @@ xfs_attr3_rmt_blocks(
 	unsigned int		attrlen)
 {
 	if (xfs_has_crc(mp)) {
-		unsigned int buflen = XFS_ATTR3_RMT_BUF_SPACE(mp, mp->m_sb.sb_blocksize);
+		unsigned int buflen = xfs_attr3_rmt_buf_space(mp);
 		return (attrlen + buflen - 1) / buflen;
 	}
 	return XFS_B_TO_FSB(mp, attrlen);
@@ -292,7 +305,7 @@ xfs_attr_rmtval_copyout(
 
 	while (len > 0 && *valuelen > 0) {
 		unsigned int hdr_size = 0;
-		unsigned int byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, blksize);
+		unsigned int byte_cnt = xfs_attr3_rmt_buf_space(mp);
 
 		byte_cnt = min(*valuelen, byte_cnt);
 
@@ -341,7 +354,7 @@ xfs_attr_rmtval_copyin(
 
 	while (len > 0 && *valuelen > 0) {
 		unsigned int hdr_size;
-		unsigned int byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, blksize);
+		unsigned int byte_cnt = xfs_attr3_rmt_buf_space(mp);
 
 		byte_cnt = min(*valuelen, byte_cnt);
 		hdr_size = xfs_attr3_rmt_hdr_set(mp, dst, ino, *offset,
diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index ebde6eb1d..86de99e2f 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -880,9 +880,7 @@ struct xfs_attr3_rmt_hdr {
 
 #define XFS_ATTR3_RMT_CRC_OFF	offsetof(struct xfs_attr3_rmt_hdr, rm_crc)
 
-#define XFS_ATTR3_RMT_BUF_SPACE(mp, bufsize)	\
-	((bufsize) - (xfs_has_crc((mp)) ? \
-			sizeof(struct xfs_attr3_rmt_hdr) : 0))
+unsigned int xfs_attr3_rmt_buf_space(struct xfs_mount *mp);
 
 /* Number of bytes in a directory block. */
 static inline unsigned int xfs_dir2_dirblock_bytes(struct xfs_sb *sbp)

