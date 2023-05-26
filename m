Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1274BC77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:08:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjEZCIk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjEZCIi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:08:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814C318D
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:08:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14DBF614A2
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:08:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744C5C433D2;
        Fri, 26 May 2023 02:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066916;
        bh=h2wL/r7NbtKMjv0b7XhaRB3No6hDzhuplduIVPQk410=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=oYuHGXJEw+UZmXCjsJESPrHyCWjOewW1lNmyAL86Iuhp57lF7xigYm/nrB2t9zdUW
         tEkmRjZ1Vqj0bRsjGxizR/QVbQ4IOSZdJLMotmIMGPOrQaPRrbZs9B/4DAjujQs58N
         626PugTlLpqzBa93h5LGsjMYm9JLVQijRTTZrmgHpq2JQNELeXJzNzeRmpT8EjMKZy
         o3z4TKRjO/esiVan6J/dp6KoL3UbPi+lmk8F3/7OsQ5xhJVyv/er7WOKk6b4lRAjwu
         pBljjr1SejeQTGJHmMBl3Q++SIOt8OejM+Ar6EGMiUHQrf1pD1gvYvuEYID5GT8XR0
         oLiJXbvnTe8TQ==
Date:   Thu, 25 May 2023 19:08:36 -0700
Subject: [PATCH 07/12] xfs: validate recovered name buffers when recovering
 xattr items
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506072283.3743652.3353134416404082757.stgit@frogsfrogsfrogs>
In-Reply-To: <168506072168.3743652.12378764451724622618.stgit@frogsfrogsfrogs>
References: <168506072168.3743652.12378764451724622618.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Strengthen the xattri log item recovery code by checking that we
actually have the required name and newname buffers for whatever
operation we're replaying.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c |   58 +++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 47 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index f6a54efcd102..c8621bcac22a 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -715,22 +715,20 @@ xlog_recover_attri_commit_pass2(
 	const void			*attr_value = NULL;
 	const void			*attr_name;
 	size_t				len;
-	unsigned int			op;
-
-	attri_formatp = item->ri_buf[0].i_addr;
-	attr_name = item->ri_buf[1].i_addr;
+	unsigned int			op, i = 0;
 
 	/* Validate xfs_attri_log_format before the large memory allocation */
 	len = sizeof(struct xfs_attri_log_format);
-	if (item->ri_buf[0].i_len != len) {
+	if (item->ri_buf[i].i_len != len) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
 		return -EFSCORRUPTED;
 	}
 
+	attri_formatp = item->ri_buf[i].i_addr;
 	if (!xfs_attri_validate(mp, attri_formatp)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
 
@@ -759,31 +757,69 @@ xlog_recover_attri_commit_pass2(
 				     attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
+	i++;
 
 	/* Validate the attr name */
-	if (item->ri_buf[1].i_len !=
+	if (item->ri_buf[i].i_len !=
 			xlog_calc_iovec_len(attri_formatp->alfi_name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
 
+	attr_name = item->ri_buf[i].i_addr;
 	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[1].i_addr, item->ri_buf[1].i_len);
+				attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
+	i++;
 
 	/* Validate the attr value, if present */
 	if (attri_formatp->alfi_value_len != 0) {
-		if (item->ri_buf[2].i_len != xlog_calc_iovec_len(attri_formatp->alfi_value_len)) {
+		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(attri_formatp->alfi_value_len)) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					item->ri_buf[0].i_addr,
 					item->ri_buf[0].i_len);
 			return -EFSCORRUPTED;
 		}
 
-		attr_value = item->ri_buf[2].i_addr;
+		attr_value = item->ri_buf[i].i_addr;
+		i++;
+	}
+
+	/*
+	 * Make sure we got the correct number of buffers for the operation
+	 * that we just loaded.
+	 */
+	if (i != item->ri_total) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				attri_formatp, len);
+		return -EFSCORRUPTED;
+	}
+
+	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		/* Regular remove operations operate only on names. */
+		if (attr_value != NULL || attri_formatp->alfi_value_len != 0) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		fallthrough;
+	case XFS_ATTRI_OP_FLAGS_SET:
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		/*
+		 * Regular xattr set/remove/replace operations require a name
+		 * and do not take a newname.  Values are optional for set and
+		 * replace.
+		 */
+		if (attr_name == NULL || attri_formatp->alfi_name_len == 0) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
 	}
 
 	/*

