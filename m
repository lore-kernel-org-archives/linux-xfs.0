Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D635C7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:38:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236697AbjDFTiC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237423AbjDFThx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:37:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A861A5277
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:37:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFBF964731
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:37:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC35C433EF;
        Thu,  6 Apr 2023 19:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809869;
        bh=6C7eM8RHMvJb/SUrJpdl6or4ng+YNCIEWYQQr97AJGw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=SJQcFexpjoekRNOvNG6lrE4ebEJeDMrEUu76a6YqgdqpHtPrFxijdO6G815u3TsXC
         NoTRZEhfshiBEnEzmnxp858VnMYCs4EBRFGrjgc6VrmDBrdHuDovn9a8W6zyfSUWam
         tKj0h771ZoFH0RLT4fFC8VLdZJZ0IXNr788sKTLd2S8nGfbzSfhi3EjtglvEi1lYQb
         9cH1vNZG962IGXgNWHEHnXAyvxyA44N6yYnikW9mNWLfvfc+oKylNd8sHI23DK8HpW
         mSOIBYXDlR+KOkZs2X2rAlEsiCvxZmMXyWdmhJ3E3sAJ/hX0gc39Kze3sCTRtBLz59
         p88q+qqX0Cyww==
Date:   Thu, 06 Apr 2023 12:37:48 -0700
Subject: [PATCH 24/32] xfs_db: report parent pointers embedded in xattrs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080827873.616793.12205479848532394957.stgit@frogsfrogsfrogs>
In-Reply-To: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
References: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Decode the parent pointer inode, generation, namehash, and name fields
if the parent pointer passes basic validation checks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/attr.c      |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 db/attrshort.c |   48 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 110 insertions(+)


diff --git a/db/attr.c b/db/attr.c
index f29e4a544..9e7bbd164 100644
--- a/db/attr.c
+++ b/db/attr.c
@@ -19,6 +19,8 @@ static int	attr_leaf_entries_count(void *obj, int startoff);
 static int	attr_leaf_hdr_count(void *obj, int startoff);
 static int	attr_leaf_name_local_count(void *obj, int startoff);
 static int	attr_leaf_name_local_name_count(void *obj, int startoff);
+static int	attr_leaf_name_pptr_count(void *obj, int startoff);
+static int	attr_leaf_name_pptr_namelen(void *obj, int startoff);
 static int	attr_leaf_name_local_value_count(void *obj, int startoff);
 static int	attr_leaf_name_local_value_offset(void *obj, int startoff,
 						  int idx);
@@ -111,6 +113,8 @@ const field_t	attr_leaf_map_flds[] = {
 
 #define	LNOFF(f)	bitize(offsetof(xfs_attr_leaf_name_local_t, f))
 #define	LVOFF(f)	bitize(offsetof(xfs_attr_leaf_name_remote_t, f))
+#define	PPOFF(f)	bitize(offsetof(xfs_attr_leaf_name_local_t, nameval) + \
+			       offsetof(struct xfs_parent_name_rec, f))
 const field_t	attr_leaf_name_flds[] = {
 	{ "valuelen", FLDT_UINT16D, OI(LNOFF(valuelen)),
 	  attr_leaf_name_local_count, FLD_COUNT, TYP_NONE },
@@ -118,6 +122,14 @@ const field_t	attr_leaf_name_flds[] = {
 	  attr_leaf_name_local_count, FLD_COUNT, TYP_NONE },
 	{ "name", FLDT_CHARNS, OI(LNOFF(nameval)),
 	  attr_leaf_name_local_name_count, FLD_COUNT, TYP_NONE },
+	{ "parent_ino", FLDT_INO, OI(PPOFF(p_ino)),
+	  attr_leaf_name_pptr_count, FLD_COUNT, TYP_INODE },
+	{ "parent_gen", FLDT_UINT32D, OI(PPOFF(p_gen)),
+	  attr_leaf_name_pptr_count, FLD_COUNT, TYP_NONE },
+	{ "parent_namehash", FLDT_UINT32X, OI(PPOFF(p_namehash)),
+	  attr_leaf_name_pptr_count, FLD_COUNT, TYP_NONE },
+	{ "parent_name", FLDT_CHARNS, attr_leaf_name_local_value_offset,
+	  attr_leaf_name_pptr_namelen, FLD_COUNT|FLD_OFFSET, TYP_NONE },
 	{ "value", FLDT_CHARNS, attr_leaf_name_local_value_offset,
 	  attr_leaf_name_local_value_count, FLD_COUNT|FLD_OFFSET, TYP_NONE },
 	{ "valueblk", FLDT_UINT32X, OI(LVOFF(valueblk)),
@@ -273,6 +285,26 @@ attr_leaf_name_local_count(
 				    __attr_leaf_name_local_count);
 }
 
+static int
+__attr_leaf_name_pptr_count(
+	struct xfs_attr_leafblock	*leaf,
+	struct xfs_attr_leaf_entry      *e,
+	int				i)
+{
+	if ((e->flags & XFS_ATTR_NSP_ONDISK_MASK) == XFS_ATTR_PARENT)
+		return 1;
+	return 0;
+}
+
+static int
+attr_leaf_name_pptr_count(
+	void				*obj,
+	int				startoff)
+{
+	return attr_leaf_entry_walk(obj, startoff,
+			__attr_leaf_name_pptr_count);
+}
+
 static int
 __attr_leaf_name_local_name_count(
 	struct xfs_attr_leafblock	*leaf,
@@ -283,6 +315,8 @@ __attr_leaf_name_local_name_count(
 
 	if (!(e->flags & XFS_ATTR_LOCAL))
 		return 0;
+	if ((e->flags & XFS_ATTR_NSP_ONDISK_MASK) == XFS_ATTR_PARENT)
+		return 0;
 
 	l = xfs_attr3_leaf_name_local(leaf, i);
 	return l->namelen;
@@ -297,6 +331,32 @@ attr_leaf_name_local_name_count(
 				    __attr_leaf_name_local_name_count);
 }
 
+static int
+__attr_leaf_name_pptr_namelen(
+	struct xfs_attr_leafblock	*leaf,
+	struct xfs_attr_leaf_entry      *e,
+	int				i)
+{
+	struct xfs_attr_leaf_name_local	*l;
+
+	if (!(e->flags & XFS_ATTR_LOCAL))
+		return 0;
+	if ((e->flags & XFS_ATTR_NSP_ONDISK_MASK) != XFS_ATTR_PARENT)
+		return 0;
+
+	l = xfs_attr3_leaf_name_local(leaf, i);
+	return be16_to_cpu(l->valuelen);
+}
+
+static int
+attr_leaf_name_pptr_namelen(
+	void				*obj,
+	int				startoff)
+{
+	return attr_leaf_entry_walk(obj, startoff,
+				    __attr_leaf_name_pptr_namelen);
+}
+
 static int
 __attr_leaf_name_local_value_count(
 	struct xfs_attr_leafblock	*leaf,
@@ -307,6 +367,8 @@ __attr_leaf_name_local_value_count(
 
 	if (!(e->flags & XFS_ATTR_LOCAL))
 		return 0;
+	if ((e->flags & XFS_ATTR_NSP_ONDISK_MASK) == XFS_ATTR_PARENT)
+		return 0;
 
 	l = xfs_attr3_leaf_name_local(leaf, i);
 	return be16_to_cpu(l->valuelen);
diff --git a/db/attrshort.c b/db/attrshort.c
index 872d771d5..9cd3411be 100644
--- a/db/attrshort.c
+++ b/db/attrshort.c
@@ -13,6 +13,8 @@
 #include "attrshort.h"
 
 static int	attr_sf_entry_name_count(void *obj, int startoff);
+static int	attr_sf_entry_pptr_count(void *obj, int startoff);
+static int	attr_sf_entry_pptr_namelen(void *obj, int startoff);
 static int	attr_sf_entry_value_count(void *obj, int startoff);
 static int	attr_sf_entry_value_offset(void *obj, int startoff, int idx);
 static int	attr_shortform_list_count(void *obj, int startoff);
@@ -34,6 +36,8 @@ const field_t	attr_sf_hdr_flds[] = {
 };
 
 #define	EOFF(f)	bitize(offsetof(struct xfs_attr_sf_entry, f))
+#define	PPOFF(f) bitize(offsetof(struct xfs_attr_sf_entry, nameval) + \
+			offsetof(struct xfs_parent_name_rec, f))
 const field_t	attr_sf_entry_flds[] = {
 	{ "namelen", FLDT_UINT8D, OI(EOFF(namelen)), C1, 0, TYP_NONE },
 	{ "valuelen", FLDT_UINT8D, OI(EOFF(valuelen)), C1, 0, TYP_NONE },
@@ -49,11 +53,33 @@ const field_t	attr_sf_entry_flds[] = {
 	  TYP_NONE },
 	{ "name", FLDT_CHARNS, OI(EOFF(nameval)), attr_sf_entry_name_count,
 	  FLD_COUNT, TYP_NONE },
+	{ "parent_ino", FLDT_INO, OI(PPOFF(p_ino)), attr_sf_entry_pptr_count,
+	  FLD_COUNT, TYP_INODE },
+	{ "parent_gen", FLDT_UINT32D, OI(PPOFF(p_gen)), attr_sf_entry_pptr_count,
+	  FLD_COUNT, TYP_NONE },
+	{ "parent_namehash", FLDT_UINT32X, OI(PPOFF(p_namehash)),
+	  attr_sf_entry_pptr_count, FLD_COUNT, TYP_NONE },
+	{ "parent_name", FLDT_CHARNS, attr_sf_entry_value_offset,
+	  attr_sf_entry_pptr_namelen, FLD_COUNT|FLD_OFFSET, TYP_NONE },
 	{ "value", FLDT_CHARNS, attr_sf_entry_value_offset,
 	  attr_sf_entry_value_count, FLD_COUNT|FLD_OFFSET, TYP_NONE },
 	{ NULL }
 };
 
+static int
+attr_sf_entry_pptr_count(
+	void				*obj,
+	int				startoff)
+{
+	struct xfs_attr_sf_entry	*e;
+
+	ASSERT(bitoffs(startoff) == 0);
+	e = (struct xfs_attr_sf_entry *)((char *)obj + byteize(startoff));
+	if ((e->flags & XFS_ATTR_NSP_ONDISK_MASK) == XFS_ATTR_PARENT)
+		return 1;
+	return 0;
+}
+
 static int
 attr_sf_entry_name_count(
 	void				*obj,
@@ -63,6 +89,8 @@ attr_sf_entry_name_count(
 
 	ASSERT(bitoffs(startoff) == 0);
 	e = (struct xfs_attr_sf_entry *)((char *)obj + byteize(startoff));
+	if ((e->flags & XFS_ATTR_NSP_ONDISK_MASK) == XFS_ATTR_PARENT)
+		return 0;
 	return e->namelen;
 }
 
@@ -84,6 +112,22 @@ attr_sf_entry_size(
 	return bitize((int)xfs_attr_sf_entsize(e));
 }
 
+static int
+attr_sf_entry_pptr_namelen(
+	void				*obj,
+	int				startoff)
+{
+	struct xfs_attr_sf_entry	*e;
+
+	ASSERT(bitoffs(startoff) == 0);
+	e = (struct xfs_attr_sf_entry *)((char *)obj + byteize(startoff));
+
+	if ((e->flags & XFS_ATTR_NSP_ONDISK_MASK) != XFS_ATTR_PARENT)
+		return 0;
+
+	return e->valuelen;
+}
+
 static int
 attr_sf_entry_value_count(
 	void				*obj,
@@ -93,6 +137,10 @@ attr_sf_entry_value_count(
 
 	ASSERT(bitoffs(startoff) == 0);
 	e = (struct xfs_attr_sf_entry *)((char *)obj + byteize(startoff));
+
+	if ((e->flags & XFS_ATTR_NSP_ONDISK_MASK) == XFS_ATTR_PARENT)
+		return 0;
+
 	return e->valuelen;
 }
 

