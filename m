Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6551C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:24:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbjEZCYa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233245AbjEZCY3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:24:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622BA9B
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:24:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB43564C1F
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:24:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C3CC433A0;
        Fri, 26 May 2023 02:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067867;
        bh=8hyf1QOgRtFSZQJVdyDwJ4d3NdB9gJh9tEV2NIp4T+E=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=L7tb14bN40H7fGL6TmWaHm3iae/lIPHSsc5AmK9dlWW32GX7h61UY5FCQIv9g5f+X
         hi+21L9y7u0eSj0fAWG8YB7MNXoYA+Gd8mUQ/Q5hYwYfvEt3WH6xoh4ePp8k4fRlAS
         Af98DGh3edRrn6UWPDWieLhhsk9QTNl1a3ieMcKJ4GOXMtXj8S3qoRl2sFlMF/YOdo
         yYeYe7/W91ako9G+Pfk6f3rThihQoRK1reA31H6XybtDN1C047bzZJ6koeLkVMAiGv
         gKpDd/F0mp7ycIczU3vMcGknpLlvGBVIUfeRfJnUPGGYOwyIQPyTU0ABxqbuR3pZ1f
         C6nyk4Uay6/cg==
Date:   Thu, 25 May 2023 19:24:26 -0700
Subject: [PATCH 10/30] xfs: pass the attr value to put_listent when possible
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506078024.3749421.12872085514659465571.stgit@frogsfrogsfrogs>
In-Reply-To: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
References: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Pass the attr value to put_listent when we have local xattrs or
shortform xattrs.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.h    |    5 +++--
 libxfs/xfs_attr_sf.h |    1 +
 2 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 24616bb07e9..f3906d5690d 100644
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
index 37578b369d9..c6e259791bc 100644
--- a/libxfs/xfs_attr_sf.h
+++ b/libxfs/xfs_attr_sf.h
@@ -24,6 +24,7 @@ typedef struct xfs_attr_sf_sort {
 	uint8_t		flags;		/* flags bits (see xfs_attr_leaf.h) */
 	xfs_dahash_t	hash;		/* this entry's hash value */
 	unsigned char	*name;		/* name value, pointer into buffer */
+	void		*value;
 } xfs_attr_sf_sort_t;
 
 #define XFS_ATTR_SF_ENTSIZE_MAX			/* max space for name&value */ \

