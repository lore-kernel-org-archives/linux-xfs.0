Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 586FAC76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240542AbjDFTRY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240460AbjDFTRW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:17:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A101FDA
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:17:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B62DF6449B
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:17:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24BE2C433D2;
        Thu,  6 Apr 2023 19:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680808638;
        bh=Mt+ijNdXi/3qEmt24E/wMuSxEESGPlALWI0XE9MoeoA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=MHLJIF84foGbP4WDjqQftzA554qYHHqtwzvsc3jTAebFmRKZtl7+tnpfX1wg+izhZ
         q1z/Zd1EGhd9SCyYAHm4dejgxxG1z+4OXwBPImPOBi56bMd+3lPwE1DhpuRGomO5wr
         v21ki12qbn8pIwlXn7IM6KlG80T6csx1Wk+YqIn+HfVkOrDFjjA9iGtU0pQnW2vz2B
         eJzSXnHBhYRgW0VYVMDTacjYwTn9MNpQ4mxcCW70CpRN/hy0PSzxZxwd/0X/CCgycX
         B2pQ3MgmdsKRlA8+Er8mKOybG/dTNws7TWeMKHB/mMVii8WOKC+EayOglLshnQrUco
         bdW+YaI/J7W/g==
Date:   Thu, 06 Apr 2023 12:17:17 -0700
Subject: [PATCH 03/12] xfs: allow xattr matching on name and value for
 local/sf attrs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080823848.613065.7140979158870437420.stgit@frogsfrogsfrogs>
In-Reply-To: <168080823794.613065.2971656278555515103.stgit@frogsfrogsfrogs>
References: <168080823794.613065.2971656278555515103.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a new NVLOOKUP flag to signal that the caller wants to look up an
extended attribute by name and value.  This only works with shortform
and local attributes.  Only parent pointers need this functionality
and parent pointers cannot be remote xattrs, so this limitation is ok
for now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |   45 ++++++++++++++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_da_btree.h  |    4 +++-
 2 files changed, 40 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index beee51ad75ce..c38caa8cba3a 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -473,10 +473,12 @@ xfs_attr3_leaf_read(
  */
 static bool
 xfs_attr_match(
-	struct xfs_da_args	*args,
-	uint8_t			namelen,
-	unsigned char		*name,
-	int			flags)
+	const struct xfs_da_args	*args,
+	uint8_t				namelen,
+	const unsigned char		*name,
+	unsigned int			valuelen,
+	const void			*value,
+	int				flags)
 {
 
 	if (args->namelen != namelen)
@@ -484,6 +486,23 @@ xfs_attr_match(
 	if (memcmp(args->name, name, namelen) != 0)
 		return false;
 
+	if (args->op_flags & XFS_DA_OP_NVLOOKUP) {
+		if (args->valuelen != valuelen)
+			return false;
+		if (args->valuelen && !value) {
+			/* not implemented for remote values */
+			ASSERT(0);
+			return false;
+		}
+		if (valuelen && !args->value) {
+			/* caller gave us valuelen > 0 but no value?? */
+			ASSERT(0);
+			return false;
+		}
+		if (valuelen > 0 && memcmp(args->value, value, valuelen) != 0)
+			return false;
+	}
+
 	/* Recovery ignores the INCOMPLETE flag. */
 	if ((args->op_flags & XFS_DA_OP_RECOVERY) &&
 	    args->attr_filter == (flags & XFS_ATTR_NSP_ONDISK_MASK))
@@ -502,6 +521,10 @@ xfs_attr_copy_value(
 	unsigned char		*value,
 	int			valuelen)
 {
+	/* vlookups already supplied the attr value; don't copy anything */
+	if (args->op_flags & XFS_DA_OP_NVLOOKUP)
+		return 0;
+
 	/*
 	 * No copy if all we have to do is get the length
 	 */
@@ -726,6 +749,7 @@ xfs_attr_sf_findname(
 			     base += size, i++) {
 		size = xfs_attr_sf_entsize(sfe);
 		if (!xfs_attr_match(args, sfe->namelen, sfe->nameval,
+				    sfe->valuelen, &sfe->nameval[sfe->namelen],
 				    sfe->flags))
 			continue;
 		break;
@@ -894,6 +918,7 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
 	for (i = 0; i < sf->hdr.count;
 				sfe = xfs_attr_sf_nextentry(sfe), i++) {
 		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
+				sfe->valuelen, &sfe->nameval[sfe->namelen],
 				sfe->flags))
 			return -EEXIST;
 	}
@@ -921,6 +946,7 @@ xfs_attr_shortform_getvalue(
 	for (i = 0; i < sf->hdr.count;
 				sfe = xfs_attr_sf_nextentry(sfe), i++) {
 		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
+				sfe->valuelen, &sfe->nameval[sfe->namelen],
 				sfe->flags))
 			return xfs_attr_copy_value(args,
 				&sfe->nameval[args->namelen], sfe->valuelen);
@@ -973,7 +999,7 @@ xfs_attr_shortform_to_leaf(
 	nargs.total = args->total;
 	nargs.whichfork = XFS_ATTR_FORK;
 	nargs.trans = args->trans;
-	nargs.op_flags = XFS_DA_OP_OKNOENT;
+	nargs.op_flags = XFS_DA_OP_OKNOENT | XFS_DA_OP_NVLOOKUP;
 
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count; i++) {
@@ -1183,7 +1209,7 @@ xfs_attr3_leaf_to_shortform(
 	nargs.total = args->total;
 	nargs.whichfork = XFS_ATTR_FORK;
 	nargs.trans = args->trans;
-	nargs.op_flags = XFS_DA_OP_OKNOENT;
+	nargs.op_flags = XFS_DA_OP_OKNOENT | XFS_DA_OP_NVLOOKUP;
 
 	for (i = 0; i < ichdr.count; entry++, i++) {
 		if (entry->flags & XFS_ATTR_INCOMPLETE)
@@ -2482,14 +2508,17 @@ xfs_attr3_leaf_lookup_int(
 		if (entry->flags & XFS_ATTR_LOCAL) {
 			name_loc = xfs_attr3_leaf_name_local(leaf, probe);
 			if (!xfs_attr_match(args, name_loc->namelen,
-					name_loc->nameval, entry->flags))
+					name_loc->nameval,
+					be16_to_cpu(name_loc->valuelen),
+					&name_loc->nameval[name_loc->namelen],
+					entry->flags))
 				continue;
 			args->index = probe;
 			return -EEXIST;
 		} else {
 			name_rmt = xfs_attr3_leaf_name_remote(leaf, probe);
 			if (!xfs_attr_match(args, name_rmt->namelen,
-					name_rmt->name, entry->flags))
+					name_rmt->name, 0, NULL, entry->flags))
 				continue;
 			args->index = probe;
 			args->rmtvaluelen = be32_to_cpu(name_rmt->valuelen);
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index ffa3df5b2893..94a544fc8a9c 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -93,6 +93,7 @@ typedef struct xfs_da_args {
 #define XFS_DA_OP_REMOVE	(1u << 6) /* this is a remove operation */
 #define XFS_DA_OP_RECOVERY	(1u << 7) /* Log recovery operation */
 #define XFS_DA_OP_LOGGED	(1u << 8) /* Use intent items to track op */
+#define XFS_DA_OP_NVLOOKUP	(1u << 9) /* Match local attr on name+value */
 
 #define XFS_DA_OP_FLAGS \
 	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
@@ -103,7 +104,8 @@ typedef struct xfs_da_args {
 	{ XFS_DA_OP_NOTIME,	"NOTIME" }, \
 	{ XFS_DA_OP_REMOVE,	"REMOVE" }, \
 	{ XFS_DA_OP_RECOVERY,	"RECOVERY" }, \
-	{ XFS_DA_OP_LOGGED,	"LOGGED" }
+	{ XFS_DA_OP_LOGGED,	"LOGGED" }, \
+	{ XFS_DA_OP_NVLOOKUP,	"NVLOOKUP" }
 
 /*
  * Storage for holding state during Btree searches and split/join ops.

