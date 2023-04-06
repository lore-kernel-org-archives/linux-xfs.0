Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10AF4C7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:34:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236658AbjDFTe3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236625AbjDFTe2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:34:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C5B85277
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:34:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0765064B8E
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:34:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD01C433D2;
        Thu,  6 Apr 2023 19:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809666;
        bh=NRYK5b/zkT8VlzHeg09aajCcE/+YrYtVcvWEhuDjQ0w=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Okd9mqczZgo2CD72r/KYS5mTsHu4bq3sMWkgXJkCI7ObSOHZ4oWoexEa6sNB9JgOX
         3V7O84CwVzbHL+Z7uFGvrte1lATf1Xs/I0DgtnB8k/84YY+gEQXO5w9i9z4sNEHNhF
         yGKpUDwe4mDRhH7tLL+pm4z9JvCuF2F+kITdOn84guiHoBzbJBQ1o5NKvlEK3E9Rr3
         UCTC1biAQaoSvpqtx/8MgBISoyfq3D87EVmtUh2HOND/uw97yVOEsmp1S1g1b7WxOp
         JeXOXVD9Nzi3vULP0QToi6Ie59y8J4qFh1hlBryrZkiHFOaKBln5IB7kXTnU6BwyxZ
         vtNMAIfiVGvpA==
Date:   Thu, 06 Apr 2023 12:34:26 -0700
Subject: [PATCH 11/32] xfsprogs: pass the attr value to put_listent when
 possible
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080827702.616793.8420185075618409206.stgit@frogsfrogsfrogs>
In-Reply-To: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
References: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: 45a4366e940b853beb4d65efec08e204aee0113d

Pass the attr value to put_listent when we have local xattrs or
shortform xattrs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.h    |    5 +++--
 libxfs/xfs_attr_sf.h |    1 +
 2 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 3ad1f12a5..0185d29d5 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -47,8 +47,9 @@ struct xfs_attrlist_cursor_kern {
 
 
 /* void; state communicated via *context */
-typedef void (*put_listent_func_t)(struct xfs_attr_list_context *, int,
-			      unsigned char *, int, int);
+typedef void (*put_listent_func_t)(struct xfs_attr_list_context *context,
+		int flags, unsigned char *name, int namelen, void *value,
+		int valuelen);
 
 struct xfs_attr_list_context {
 	struct xfs_trans	*tp;
diff --git a/libxfs/xfs_attr_sf.h b/libxfs/xfs_attr_sf.h
index 37578b369..c6e259791 100644
--- a/libxfs/xfs_attr_sf.h
+++ b/libxfs/xfs_attr_sf.h
@@ -24,6 +24,7 @@ typedef struct xfs_attr_sf_sort {
 	uint8_t		flags;		/* flags bits (see xfs_attr_leaf.h) */
 	xfs_dahash_t	hash;		/* this entry's hash value */
 	unsigned char	*name;		/* name value, pointer into buffer */
+	void		*value;
 } xfs_attr_sf_sort_t;
 
 #define XFS_ATTR_SF_ENTSIZE_MAX			/* max space for name&value */ \

