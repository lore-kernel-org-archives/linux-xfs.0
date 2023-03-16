Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D3EAC6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:27:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjCPT1S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCPT1R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:27:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC40DCD66C
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:27:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C40AB82302
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:27:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B55C433EF;
        Thu, 16 Mar 2023 19:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994833;
        bh=Ju9MdpdeEQUlgZK2fVnT5yTcHmdA4LE9JQlaKk7P/1s=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=XsdVQ2LdLoOOaCuEeVm8Ms5ji01a2DHHd4PEgNKEXZGGpEu1PT40dBZEaqGxGT0aB
         2Qvm0oMFdsSQwV/GwHoXVBXzvk1huhdcVSLLrSd9yTm2EDrvRJl2lA61zPeaBhD4jZ
         y/gh2FUIt6y506wcBV/K7/XHy2xzDiML9K6lCBUJRblxoAbdq8aJ0QPFYRmADjuZ6u
         eJBSUdOwRUsplMQX73r0nlGC1gPU0PljVaOkjgOkKYCxR+VgN0DX8+WjYQiP0WCSZZ
         0vTSk4iwYmll0bBWFTeZTCx6bqbxwMunaWId/41mVzbhplay8hloHJ54ToN+IaYyV8
         ChP9PWQ+SJofA==
Date:   Thu, 16 Mar 2023 12:27:12 -0700
Subject: [PATCH 5/9] xfs_db: report parent pointer keys
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899415442.16278.1927282731092038026.stgit@frogsfrogsfrogs>
In-Reply-To: <167899415375.16278.9528475200288521209.stgit@frogsfrogsfrogs>
References: <167899415375.16278.9528475200288521209.stgit@frogsfrogsfrogs>
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
index f29e4a544..db7cf54b5 100644
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
index 872d771d5..7c8ac485d 100644
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
 

