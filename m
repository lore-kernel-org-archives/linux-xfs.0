Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7603DC8CA
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tTyZ3SW2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC540C433C8;
	Sun, 31 Dec 2023 23:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063781;
	bh=wzSLwOQyQoSh0654sitxLjcQFQlNiMW9aW8rlQbKD7Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tTyZ3SW2t+sSWXsZy5piHaIpbsxWizqWYCjP53/awyaTX+5IzYC+KWJWe/3M0ykH7
	 n/o+xMjLGihT3pMVtn7eLwTJkIhVhSlUsZvN2aANSixo2tBW+RuWyNkpfpMnEg76Zi
	 PFG/aZuq9QPZgkUTNejNXJoIYfmwjrD6un0k0yFc3G3sNbaD61EiHEfuLLcdXCbaTr
	 YKdhi9mWHfqfDB8kBbTq+ODysuWyej6KbndHHvB9+OXyvSoJX1BVBiR9qNOXt1XkVq
	 ZYvrPLICF2eiOZ69KIhQjtlpZy308q7AEMAGHqc9W1Cd7OMU6mF7kDYgi7FcuLXWF0
	 seaFLUvo5m8bA==
Date: Sun, 31 Dec 2023 15:03:01 -0800
Subject: [PATCH 03/11] xfs: allow xattr matching on name and value for
 local/sf attrs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405005637.1804370.10798804609296237199.stgit@frogsfrogsfrogs>
In-Reply-To: <170405005590.1804370.14232373294131770998.stgit@frogsfrogsfrogs>
References: <170405005590.1804370.14232373294131770998.stgit@frogsfrogsfrogs>
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
index 3d798828833..c0fc3c10dc4 100644
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
@@ -1209,7 +1235,7 @@ xfs_attr3_leaf_to_shortform(
 	nargs.total = args->total;
 	nargs.whichfork = XFS_ATTR_FORK;
 	nargs.trans = args->trans;
-	nargs.op_flags = XFS_DA_OP_OKNOENT;
+	nargs.op_flags = XFS_DA_OP_OKNOENT | XFS_DA_OP_NVLOOKUP;
 	nargs.owner = args->owner;
 
 	for (i = 0; i < ichdr.count; entry++, i++) {
@@ -2506,14 +2532,17 @@ xfs_attr3_leaf_lookup_int(
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
index 7a004786ee0..1bcb291150e 100644
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

