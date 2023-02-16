Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E47BAC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbjBPVC6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:02:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjBPVC6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:02:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285CF16324
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:02:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 906DCB8217A
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:02:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC81C433D2;
        Thu, 16 Feb 2023 21:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581373;
        bh=UMhw1UjO0TQN3LZ5FNiHOIU/igE8TkRZQ7MTgvgFSh0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=pjNRjn4ALZaDCSJZd8hCBCrpjKpei27Cderz/IT96sIqUJ++v03vtxjAgLMz8lNHK
         TiXNc6RScplUnZGEy+5ZJEqB0poV5T+GgKE8JIAmbqYbWbUP8ZS9b1WphXb78ZiBK/
         cyFJqSC4bVMVU/T+SdYdEbg139Pei+s8i94jXvqwGOLow236xdurx+vgJ+Sv7OTDoP
         yxJP7FfjkQzkOFboGUxQ5EqaTLN80n+pGNYwotuSA9CpjbnB1FIR45Snpwu5U8WjVX
         2dQ0QnVMHgcOu3ajPvYlmBA9/BDFlBEry9gI5/bkLN4OIcdrn1JBSdoqWTyy8SC3Cw
         RXgwif0muVfug==
Date:   Thu, 16 Feb 2023 13:02:52 -0800
Subject: [PATCH 5/6] xfs_db: report parent pointer keys
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657879962.3476911.9549384051252763800.stgit@magnolia>
In-Reply-To: <167657879895.3476911.2211427543938389071.stgit@magnolia>
References: <167657879895.3476911.2211427543938389071.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Decode the parent pointer inode, generation, and diroffset fields.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/attr.c      |   31 +++++++++++++++++++++++++++++++
 db/attrshort.c |   25 +++++++++++++++++++++++++
 2 files changed, 56 insertions(+)


diff --git a/db/attr.c b/db/attr.c
index f29e4a54..db7cf54b 100644
--- a/db/attr.c
+++ b/db/attr.c
@@ -19,6 +19,7 @@ static int	attr_leaf_entries_count(void *obj, int startoff);
 static int	attr_leaf_hdr_count(void *obj, int startoff);
 static int	attr_leaf_name_local_count(void *obj, int startoff);
 static int	attr_leaf_name_local_name_count(void *obj, int startoff);
+static int	attr_leaf_name_pptr_count(void *obj, int startoff);
 static int	attr_leaf_name_local_value_count(void *obj, int startoff);
 static int	attr_leaf_name_local_value_offset(void *obj, int startoff,
 						  int idx);
@@ -111,6 +112,8 @@ const field_t	attr_leaf_map_flds[] = {
 
 #define	LNOFF(f)	bitize(offsetof(xfs_attr_leaf_name_local_t, f))
 #define	LVOFF(f)	bitize(offsetof(xfs_attr_leaf_name_remote_t, f))
+#define	PPOFF(f)	bitize(offsetof(xfs_attr_leaf_name_local_t, nameval) + \
+			       offsetof(struct xfs_parent_name_rec, f))
 const field_t	attr_leaf_name_flds[] = {
 	{ "valuelen", FLDT_UINT16D, OI(LNOFF(valuelen)),
 	  attr_leaf_name_local_count, FLD_COUNT, TYP_NONE },
@@ -118,6 +121,12 @@ const field_t	attr_leaf_name_flds[] = {
 	  attr_leaf_name_local_count, FLD_COUNT, TYP_NONE },
 	{ "name", FLDT_CHARNS, OI(LNOFF(nameval)),
 	  attr_leaf_name_local_name_count, FLD_COUNT, TYP_NONE },
+	{ "parent_ino", FLDT_INO, OI(PPOFF(p_ino)),
+	  attr_leaf_name_pptr_count, FLD_COUNT, TYP_INODE },
+	{ "parent_gen", FLDT_UINT32D, OI(PPOFF(p_gen)),
+	  attr_leaf_name_pptr_count, FLD_COUNT, TYP_NONE },
+	{ "parent_diroffset", FLDT_UINT32D, OI(PPOFF(p_diroffset)),
+	  attr_leaf_name_pptr_count, FLD_COUNT, TYP_NONE },
 	{ "value", FLDT_CHARNS, attr_leaf_name_local_value_offset,
 	  attr_leaf_name_local_value_count, FLD_COUNT|FLD_OFFSET, TYP_NONE },
 	{ "valueblk", FLDT_UINT32X, OI(LVOFF(valueblk)),
@@ -273,6 +282,26 @@ attr_leaf_name_local_count(
 				    __attr_leaf_name_local_count);
 }
 
+static int
+__attr_leaf_name_pptr_count(
+	struct xfs_attr_leafblock	*leaf,
+	struct xfs_attr_leaf_entry      *e,
+	int				i)
+{
+	if (e->flags & XFS_ATTR_PARENT)
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
@@ -283,6 +312,8 @@ __attr_leaf_name_local_name_count(
 
 	if (!(e->flags & XFS_ATTR_LOCAL))
 		return 0;
+	if (e->flags & XFS_ATTR_PARENT)
+		return 0;
 
 	l = xfs_attr3_leaf_name_local(leaf, i);
 	return l->namelen;
diff --git a/db/attrshort.c b/db/attrshort.c
index 872d771d..7c8ac485 100644
--- a/db/attrshort.c
+++ b/db/attrshort.c
@@ -13,6 +13,7 @@
 #include "attrshort.h"
 
 static int	attr_sf_entry_name_count(void *obj, int startoff);
+static int	attr_sf_entry_pptr_count(void *obj, int startoff);
 static int	attr_sf_entry_value_count(void *obj, int startoff);
 static int	attr_sf_entry_value_offset(void *obj, int startoff, int idx);
 static int	attr_shortform_list_count(void *obj, int startoff);
@@ -34,6 +35,8 @@ const field_t	attr_sf_hdr_flds[] = {
 };
 
 #define	EOFF(f)	bitize(offsetof(struct xfs_attr_sf_entry, f))
+#define	PPOFF(f) bitize(offsetof(struct xfs_attr_sf_entry, nameval) + \
+			offsetof(struct xfs_parent_name_rec, f))
 const field_t	attr_sf_entry_flds[] = {
 	{ "namelen", FLDT_UINT8D, OI(EOFF(namelen)), C1, 0, TYP_NONE },
 	{ "valuelen", FLDT_UINT8D, OI(EOFF(valuelen)), C1, 0, TYP_NONE },
@@ -49,11 +52,31 @@ const field_t	attr_sf_entry_flds[] = {
 	  TYP_NONE },
 	{ "name", FLDT_CHARNS, OI(EOFF(nameval)), attr_sf_entry_name_count,
 	  FLD_COUNT, TYP_NONE },
+	{ "parent_ino", FLDT_INO, OI(PPOFF(p_ino)), attr_sf_entry_pptr_count,
+	  FLD_COUNT, TYP_INODE },
+	{ "parent_gen", FLDT_UINT32D, OI(PPOFF(p_gen)), attr_sf_entry_pptr_count,
+	  FLD_COUNT, TYP_NONE },
+	{ "parent_diroffset", FLDT_UINT32D, OI(PPOFF(p_diroffset)),
+	   attr_sf_entry_pptr_count, FLD_COUNT, TYP_NONE },
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
+	if (e->flags & XFS_ATTR_PARENT)
+		return 1;
+	return 0;
+}
+
 static int
 attr_sf_entry_name_count(
 	void				*obj,
@@ -63,6 +86,8 @@ attr_sf_entry_name_count(
 
 	ASSERT(bitoffs(startoff) == 0);
 	e = (struct xfs_attr_sf_entry *)((char *)obj + byteize(startoff));
+	if (e->flags & XFS_ATTR_PARENT)
+		return 0;
 	return e->namelen;
 }
 

