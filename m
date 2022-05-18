Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56C23C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 18:54:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241681AbiERSyu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 May 2022 14:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241646AbiERSyu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 14:54:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FBA01F90E0
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 11:54:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87C0461866
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 18:54:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41EBC385A5;
        Wed, 18 May 2022 18:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652900088;
        bh=h7TDox8VdjZ7GK8nlKEJaPvVSlIoUZxRLVnCjYjNoO4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uHehN4Frj1+2rYuPTV/mErqkRS5BziVYLA9x6Ha4BNfH6q+r4w2VMIN2j7STRyWqy
         0N4lFuKWjR6472fVSwjzxZdGaxBn400yNb8KxNfqMEYlzYKDhLUb6ZeKQbLpL7WwDQ
         wbMDJBRvegerL4WMSco20Y7ymcTWcMx9T+Gw9xM5BcGvKvncqdIINRPupEyEzlTlKL
         pmiFPqPfiNxq7jbvBMz7IU8wpK8hz39c/FhOiORyKhCX5Vh0ZjNz/GygjMGK5zX3TM
         EP+6vn1fULDa7tRgpb3kT9+RJ9ZslPe9RtUVyU9H5Sd9KXdq9V+135ergF5aBtvpPm
         SM6UePWsoYS8g==
Subject: [PATCH 2/4] xfs: don't leak the retained da state when doing a leaf
 to node conversion
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Wed, 18 May 2022 11:54:47 -0700
Message-ID: <165290008743.1646028.12364052366051039965.stgit@magnolia>
In-Reply-To: <165290007585.1646028.11376304341026166988.stgit@magnolia>
References: <165290007585.1646028.11376304341026166988.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If a setxattr operation finds an xattr structure in leaf format, adding
the attr can fail due to lack of space and hence requires an upgrade to
node format.  After this happens, we'll roll the transaction and
re-enter the state machine, at which time we need to perform a second
lookup of the attribute name to find its new location.  This lookup
attaches a new da state structure to the xfs_attr_item but doesn't free
the old one (from the leaf lookup) and leaks it.  Fix that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index d0418b79056f..576de34cfca0 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1401,8 +1401,10 @@ xfs_attr_node_hasname(
 	int			retval, error;
 
 	state = xfs_da_state_alloc(args);
-	if (statep != NULL)
+	if (statep != NULL) {
+		ASSERT(*statep == NULL);
 		*statep = state;
+	}
 
 	/*
 	 * Search to see if name exists, and get back a pointer to it.
@@ -1428,6 +1430,10 @@ xfs_attr_node_addname_find_attr(
 	struct xfs_da_args	*args = attr->xattri_da_args;
 	int			error;
 
+	if (attr->xattri_da_state)
+		xfs_da_state_free(attr->xattri_da_state);
+	attr->xattri_da_state = NULL;
+
 	/*
 	 * Search to see if name already exists, and get back a pointer
 	 * to where it should go.
@@ -1593,7 +1599,7 @@ STATIC int
 xfs_attr_node_get(
 	struct xfs_da_args	*args)
 {
-	struct xfs_da_state	*state;
+	struct xfs_da_state	*state = NULL;
 	struct xfs_da_state_blk	*blk;
 	int			i;
 	int			error;

