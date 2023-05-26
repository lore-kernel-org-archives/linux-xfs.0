Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD4BC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233494AbjEZCTy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234550AbjEZCTu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:19:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D84194
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:19:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66E4D64C49
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:19:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0F4C433D2;
        Fri, 26 May 2023 02:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067586;
        bh=Js9rj0qpM0iRtAb0FuzEhtakxsev7vLoAMhyak/U8wI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=sg2g0gDMADIVsa9wZ5BXyjbNtcgQ04EESKNjZ8rcU37O1Jka6W3Rrq6Meir6W0jds
         RXsthnJh197eUiJZlv8MQp5SPoGXiAa2JPhe3mCNl0vsgLfr/4V22LCgPhuhaGDqDn
         haYwJ+47WtLYRDl/yByiaho7+Hw2m0bDox2H1htKk020o6IWZeGGyNsL7TTayCu84s
         wUk+5nm7w93elWzbdYYIYn1M4TxBdhWebVsrhxwUgbZRSQMrMdLYoIgWBvu6ghQ4E+
         DLfNIUFr4YQzUx6Yr4vuGJfDEWIsHqTvqG6bLQSGqrthC1E85QT20B48e//MHMODMD
         AE5cRLAdtmX0w==
Date:   Thu, 25 May 2023 19:19:46 -0700
Subject: [PATCH 02/10] xfs: allow xattr matching on name and value for
 local/sf attrs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506077461.3749126.982144107925942089.stgit@frogsfrogsfrogs>
In-Reply-To: <168506077431.3749126.3177791326683307311.stgit@frogsfrogsfrogs>
References: <168506077431.3749126.3177791326683307311.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_attr_leaf.c |   45 +++++++++++++++++++++++++++++++++++++--------
 libxfs/xfs_da_btree.h  |    4 +++-
 2 files changed, 40 insertions(+), 9 deletions(-)


diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 1a2371c33e4..d737d4163dd 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -505,10 +505,12 @@ xfs_attr3_leaf_read(
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
@@ -516,6 +518,23 @@ xfs_attr_match(
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
@@ -534,6 +553,10 @@ xfs_attr_copy_value(
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
@@ -758,6 +781,7 @@ xfs_attr_sf_findname(
 			     base += size, i++) {
 		size = xfs_attr_sf_entsize(sfe);
 		if (!xfs_attr_match(args, sfe->namelen, sfe->nameval,
+				    sfe->valuelen, &sfe->nameval[sfe->namelen],
 				    sfe->flags))
 			continue;
 		break;
@@ -926,6 +950,7 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
 	for (i = 0; i < sf->hdr.count;
 				sfe = xfs_attr_sf_nextentry(sfe), i++) {
 		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
+				sfe->valuelen, &sfe->nameval[sfe->namelen],
 				sfe->flags))
 			return -EEXIST;
 	}
@@ -953,6 +978,7 @@ xfs_attr_shortform_getvalue(
 	for (i = 0; i < sf->hdr.count;
 				sfe = xfs_attr_sf_nextentry(sfe), i++) {
 		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
+				sfe->valuelen, &sfe->nameval[sfe->namelen],
 				sfe->flags))
 			return xfs_attr_copy_value(args,
 				&sfe->nameval[args->namelen], sfe->valuelen);
@@ -1005,7 +1031,7 @@ xfs_attr_shortform_to_leaf(
 	nargs.total = args->total;
 	nargs.whichfork = XFS_ATTR_FORK;
 	nargs.trans = args->trans;
-	nargs.op_flags = XFS_DA_OP_OKNOENT;
+	nargs.op_flags = XFS_DA_OP_OKNOENT | XFS_DA_OP_NVLOOKUP;
 	nargs.owner = args->owner;
 
 	sfe = &sf->list[0];
@@ -1226,7 +1252,7 @@ xfs_attr3_leaf_to_shortform(
 	nargs.total = args->total;
 	nargs.whichfork = XFS_ATTR_FORK;
 	nargs.trans = args->trans;
-	nargs.op_flags = XFS_DA_OP_OKNOENT;
+	nargs.op_flags = XFS_DA_OP_OKNOENT | XFS_DA_OP_NVLOOKUP;
 	nargs.owner = args->owner;
 
 	for (i = 0; i < ichdr.count; entry++, i++) {
@@ -2529,14 +2555,17 @@ xfs_attr3_leaf_lookup_int(
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
diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index 1f5b3c3f0de..091750b2d42 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -94,6 +94,7 @@ typedef struct xfs_da_args {
 #define XFS_DA_OP_REMOVE	(1u << 6) /* this is a remove operation */
 #define XFS_DA_OP_RECOVERY	(1u << 7) /* Log recovery operation */
 #define XFS_DA_OP_LOGGED	(1u << 8) /* Use intent items to track op */
+#define XFS_DA_OP_NVLOOKUP	(1u << 9) /* Match local attr on name+value */
 
 #define XFS_DA_OP_FLAGS \
 	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
@@ -104,7 +105,8 @@ typedef struct xfs_da_args {
 	{ XFS_DA_OP_NOTIME,	"NOTIME" }, \
 	{ XFS_DA_OP_REMOVE,	"REMOVE" }, \
 	{ XFS_DA_OP_RECOVERY,	"RECOVERY" }, \
-	{ XFS_DA_OP_LOGGED,	"LOGGED" }
+	{ XFS_DA_OP_LOGGED,	"LOGGED" }, \
+	{ XFS_DA_OP_NVLOOKUP,	"NVLOOKUP" }
 
 /*
  * Storage for holding state during Btree searches and split/join ops.

