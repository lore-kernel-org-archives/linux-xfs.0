Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC9DFC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 16 May 2022 03:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbiEPDcJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 May 2022 23:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239665AbiEPDcI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 May 2022 23:32:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F28F1FCC4
        for <linux-xfs@vger.kernel.org>; Sun, 15 May 2022 20:32:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20AB2B80D2C
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 03:32:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC9EBC385AA;
        Mon, 16 May 2022 03:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652671923;
        bh=wjhQDDxUEWVl+wq8/HogUZ5eor/mfW5Y35gIqidtJ8g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iqTLbOXaL5sNUiFSDIh1szqFcxscAk/xSDI2S3eg/7lFIgInZnphRjNKK8AihFAtj
         Tf3MwGhIK0h7zhMpPioy0NxW8NcqZZarOi3uX8QvAxZTPAHoJf3alvjwgtyQJS/Xsx
         BLuHmFinQr8lWF4tbpdUDFUjvJWWZMKoV/zf1iRKHvJGQHVjA3YFT4w1X+60v9MAO6
         Ep4fgewmwr3Mtrp7H/VYR+0cBVVo04jE8PumBPsKVYrDdTDRPe/Td2nSJUbVx67Nlz
         /7frvCmi5qiP2LiHzuTSetsWW+4oIcNtbBRmsROyihLGYwOWY7MOB4lGIEV1YiTuXv
         a98iGJ51cJvmg==
Subject: [PATCH 2/4] xfs: don't leak the retained da state when doing a leaf
 to node conversion
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Sun, 15 May 2022 20:32:03 -0700
Message-ID: <165267192341.625255.6169607924858686457.stgit@magnolia>
In-Reply-To: <165267191199.625255.12173648515376165187.stgit@magnolia>
References: <165267191199.625255.12173648515376165187.stgit@magnolia>
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
---
 fs/xfs/libxfs/xfs_attr.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 2da24954b2d7..499a15480b57 100644
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

