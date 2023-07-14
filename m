Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3FA7C0015E
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Jul 2023 14:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236158AbjGNOpY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Jul 2023 10:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236173AbjGNOpV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2023 10:45:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78985213B
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 07:45:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1FCB61D3E
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 14:45:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B56EC433C8;
        Fri, 14 Jul 2023 14:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689345917;
        bh=4Ww3w8Cliljwncan3qmjZ6bom6mlUV8YHs5dWUImNDQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kHg3BJX+YVHWvMsUUKST6S9YOf7DC3wmeDvSGTVySJt5bbVhF25unBkz3Y65of533
         Cw0GvkK6tSdIEIw8kqoB9Z2I0qXCfNDNr2WE2rDqeqbfP1d/x1qFde/sm/0tU3fgxq
         DJpooRnxbAvbkylDq5N5JtZ1itl1GF7nSO+5eE/lGE9ZlARuDKT+KVljAZTofuueU1
         yNun/F4ZWy0PRcz2MENjrZoXCb/AsrnqKkJmhC/UzyzGXexDYbV9uNh0QClBFOq7sV
         dOfrwtPsphAzSHshxnk5oNsifFjU7HzDRObe8yyGKbRZA3xFhSFsHKqibzmtErVTHW
         SzK3HdtivqNzw==
Subject: [PATCH 2/3] xfs: convert flex-array declarations in xfs attr leaf
 blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, keescook@chromium.org,
        david@fromorbit.com
Date:   Fri, 14 Jul 2023 07:45:16 -0700
Message-ID: <168934591669.3368057.4588378580238137738.stgit@frogsfrogsfrogs>
In-Reply-To: <168934590524.3368057.8686152348214871657.stgit@frogsfrogsfrogs>
References: <168934590524.3368057.8686152348214871657.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 3d282679ac2249f0d239a4ae2403d884fccd3ea1

As of 6.5-rc1, UBSAN trips over the ondisk extended attribute leaf block
definitions using an array length of 1 to pretend to be a flex array.
Kernel compilers have to support unbounded array declarations, so let's
correct this.

================================================================================
UBSAN: array-index-out-of-bounds in fs/xfs/libxfs/xfs_attr_leaf.c:2535:24
index 2 is out of range for type '__u8 [1]'
Call Trace:
<TASK>
dump_stack_lvl+0x33/0x50
__ubsan_handle_out_of_bounds+0x9c/0xd0
xfs_attr3_leaf_getvalue+0x2ce/0x2e0 [xfs 4a986a89a77bb77402ab8a87a37da369ef6a3f09]
xfs_attr_leaf_get+0x148/0x1c0 [xfs 4a986a89a77bb77402ab8a87a37da369ef6a3f09]
xfs_attr_get_ilocked+0xae/0x110 [xfs 4a986a89a77bb77402ab8a87a37da369ef6a3f09]
xfs_attr_get+0xee/0x150 [xfs 4a986a89a77bb77402ab8a87a37da369ef6a3f09]
xfs_xattr_get+0x7d/0xc0 [xfs 4a986a89a77bb77402ab8a87a37da369ef6a3f09]
__vfs_getxattr+0xa3/0x100
vfs_getxattr+0x87/0x1d0
do_getxattr+0x17a/0x220
getxattr+0x89/0xf0

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/metadump.c          |    4 +--
 libxfs/xfs_da_format.h |   73 +++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 67 insertions(+), 10 deletions(-)


diff --git a/db/metadump.c b/db/metadump.c
index d9a616a9..3545124f 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1475,7 +1475,7 @@ process_attr_block(
 			nlen = local->namelen;
 			vlen = be16_to_cpu(local->valuelen);
 			zlen = xfs_attr_leaf_entsize_local(nlen, vlen) -
-				(sizeof(xfs_attr_leaf_name_local_t) - 1 +
+				(offsetof(struct xfs_attr_leaf_name_local, nameval) +
 				 nlen + vlen);
 			if (zero_stale_data)
 				memset(&local->nameval[nlen + vlen], 0, zlen);
@@ -1497,7 +1497,7 @@ process_attr_block(
 			/* zero from end of name[] to next name start */
 			nlen = remote->namelen;
 			zlen = xfs_attr_leaf_entsize_remote(nlen) -
-				(sizeof(xfs_attr_leaf_name_remote_t) - 1 +
+				(offsetof(struct xfs_attr_leaf_name_remote, name) +
 				 nlen);
 			if (zero_stale_data)
 				memset(&remote->name[nlen], 0, zlen);
diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index 25e28410..b2362717 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -620,19 +620,29 @@ typedef struct xfs_attr_leaf_entry {	/* sorted on key, not name */
 typedef struct xfs_attr_leaf_name_local {
 	__be16	valuelen;		/* number of bytes in value */
 	__u8	namelen;		/* length of name bytes */
-	__u8	nameval[1];		/* name/value bytes */
+	/*
+	 * In Linux 6.5 this flex array was converted from nameval[1] to
+	 * nameval[].  Be very careful here about extra padding at the end;
+	 * see xfs_attr_leaf_entsize_local() for details.
+	 */
+	__u8	nameval[];		/* name/value bytes */
 } xfs_attr_leaf_name_local_t;
 
 typedef struct xfs_attr_leaf_name_remote {
 	__be32	valueblk;		/* block number of value bytes */
 	__be32	valuelen;		/* number of bytes in value */
 	__u8	namelen;		/* length of name bytes */
-	__u8	name[1];		/* name bytes */
+	/*
+	 * In Linux 6.5 this flex array was converted from name[1] to name[].
+	 * Be very careful here about extra padding at the end; see
+	 * xfs_attr_leaf_entsize_remote() for details.
+	 */
+	__u8	name[];			/* name bytes */
 } xfs_attr_leaf_name_remote_t;
 
 typedef struct xfs_attr_leafblock {
 	xfs_attr_leaf_hdr_t	hdr;	/* constant-structure header block */
-	xfs_attr_leaf_entry_t	entries[1];	/* sorted on key, not name */
+	xfs_attr_leaf_entry_t	entries[];	/* sorted on key, not name */
 	/*
 	 * The rest of the block contains the following structures after the
 	 * leaf entries, growing from the bottom up. The variables are never
@@ -664,7 +674,7 @@ struct xfs_attr3_leaf_hdr {
 
 struct xfs_attr3_leafblock {
 	struct xfs_attr3_leaf_hdr	hdr;
-	struct xfs_attr_leaf_entry	entries[1];
+	struct xfs_attr_leaf_entry	entries[];
 
 	/*
 	 * The rest of the block contains the following structures after the
@@ -747,14 +757,61 @@ xfs_attr3_leaf_name_local(xfs_attr_leafblock_t *leafp, int idx)
  */
 static inline int xfs_attr_leaf_entsize_remote(int nlen)
 {
-	return round_up(sizeof(struct xfs_attr_leaf_name_remote) - 1 +
-			nlen, XFS_ATTR_LEAF_NAME_ALIGN);
+	/*
+	 * Prior to Linux 6.5, struct xfs_attr_leaf_name_remote ended with
+	 * name[1], which was used as a flexarray.  The layout of this struct
+	 * is 9 bytes of fixed-length fields followed by a __u8 flex array at
+	 * offset 9.
+	 *
+	 * On most architectures, struct xfs_attr_leaf_name_remote had two
+	 * bytes of implicit padding at the end of the struct to make the
+	 * struct length 12.  After converting name[1] to name[], there are
+	 * three implicit padding bytes and the struct size remains 12.
+	 * However, there are compiler configurations that do not add implicit
+	 * padding at all (m68k) and have been broken for years.
+	 *
+	 * This entsize computation historically added (the xattr name length)
+	 * to (the padded struct length - 1) and rounded that sum up to the
+	 * nearest multiple of 4 (NAME_ALIGN).  IOWs, round_up(11 + nlen, 4).
+	 * This is encoded in the ondisk format, so we cannot change this.
+	 *
+	 * Compute the entsize from offsetof of the flexarray and manually
+	 * adding bytes for the implicit padding.
+	 */
+	const size_t remotesize =
+			offsetof(struct xfs_attr_leaf_name_remote, name) + 2;
+
+	return round_up(remotesize + nlen, XFS_ATTR_LEAF_NAME_ALIGN);
 }
 
 static inline int xfs_attr_leaf_entsize_local(int nlen, int vlen)
 {
-	return round_up(sizeof(struct xfs_attr_leaf_name_local) - 1 +
-			nlen + vlen, XFS_ATTR_LEAF_NAME_ALIGN);
+	/*
+	 * Prior to Linux 6.5, struct xfs_attr_leaf_name_local ended with
+	 * nameval[1], which was used as a flexarray.  The layout of this
+	 * struct is 3 bytes of fixed-length fields followed by a __u8 flex
+	 * array at offset 3.
+	 *
+	 * struct xfs_attr_leaf_name_local had zero bytes of implicit padding
+	 * at the end of the struct to make the struct length 4.  On most
+	 * architectures, after converting nameval[1] to nameval[], there is
+	 * one implicit padding byte and the struct size remains 4.  However,
+	 * there are compiler configurations that do not add implicit padding
+	 * at all (m68k) and would break.
+	 *
+	 * This entsize computation historically added (the xattr name and
+	 * value length) to (the padded struct length - 1) and rounded that sum
+	 * up to the nearest multiple of 4 (NAME_ALIGN).  IOWs, the formula is
+	 * round_up(3 + nlen + vlen, 4).  This is encoded in the ondisk format,
+	 * so we cannot change this.
+	 *
+	 * Compute the entsize from offsetof of the flexarray and manually
+	 * adding bytes for the implicit padding.
+	 */
+	const size_t localsize =
+			offsetof(struct xfs_attr_leaf_name_local, nameval);
+
+	return round_up(localsize + nlen + vlen, XFS_ATTR_LEAF_NAME_ALIGN);
 }
 
 static inline int xfs_attr_leaf_entsize_local_max(int bsize)

