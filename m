Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 181E5C6FD19
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:20:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjCPTUG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbjCPTUD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:20:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09046227A6
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:19:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC152B82302
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64838C433EF;
        Thu, 16 Mar 2023 19:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994396;
        bh=dJ96YXuw0p8Qa/SmqctTRmPX3mSAorLuq+QZuYgWIAE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=mDvyQP9za9xqijjz9ycyaaTpDsAYlYdprmjiNsP56cXoAUepe0fr7y/OVKcdsLSwl
         t+/zsDIgVyFsqKXyx/GBfmJqTLIa1HErQgJ6XXXB54mnBPLxteyITtv20dw33PlFtg
         K7UJF8J3iwCzZm5igEoh/uGq2TLWVbTb4B64KuhJzT3k0MfG4BwIERv7BxY1+quWJR
         quLgIemVHuVJcLMAy4jByiACtfboAHASHTmCLETUKj0w3W4tFFjTc2cV2MjXxdiiML
         b6b4nl69TdWfB0JjxGCo4iyErHhlmge6gZdSZPkEQPcZEvt9cU8moQIlI5NQY3Mxpf
         DzG/L3oLnM2aQ==
Date:   Thu, 16 Mar 2023 12:19:55 -0700
Subject: [PATCH 1/7] xfs: validate parent pointer xattrs in getparent
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899413941.15157.14451428434116001870.stgit@frogsfrogsfrogs>
In-Reply-To: <167899413920.15157.15106630627506949304.stgit@frogsfrogsfrogs>
References: <167899413920.15157.15106630627506949304.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Actually validate the parent pointer xattr before we try to export it to
userspace.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_parent_utils.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_parent_utils.c b/fs/xfs/xfs_parent_utils.c
index 9c1c866346eb..f3cf8b33605d 100644
--- a/fs/xfs/xfs_parent_utils.c
+++ b/fs/xfs/xfs_parent_utils.c
@@ -49,6 +49,7 @@ xfs_getparent_listent(
 	struct xfs_getparent_ctx	*gp;
 	struct xfs_pptr_info		*ppi;
 	struct xfs_parent_ptr		*pptr;
+	struct xfs_parent_name_rec	*rec = (void *)name;
 	struct xfs_parent_name_irec	*irec;
 	struct xfs_mount		*mp = context->dp->i_mount;
 	int				arraytop;
@@ -62,19 +63,16 @@ xfs_getparent_listent(
 		return;
 
 	/*
-	 * Report corruption for xattrs with any other flag set, or for a
-	 * parent pointer that has a remote value.  The attr list functions
-	 * filtered any INCOMPLETE attrs for us.
+	 * Report corruption for anything that doesn't look like a parent
+	 * pointer.  The attr list functions filtered out INCOMPLETE attrs.
 	 */
-	if (XFS_IS_CORRUPT(mp,
-			   hweight32(flags & XFS_ATTR_NSP_ONDISK_MASK) > 1) ||
-	    XFS_IS_CORRUPT(mp, value == NULL)) {
+	if (XFS_IS_CORRUPT(mp, !xfs_parent_namecheck(mp, rec, namelen, flags)) ||
+	    XFS_IS_CORRUPT(mp, !xfs_parent_valuecheck(mp, value, valuelen))) {
 		context->seen_enough = -EFSCORRUPTED;
 		return;
 	}
 
-	xfs_parent_irec_from_disk(&gp->pptr_irec, (void *)name, value,
-			valuelen);
+	xfs_parent_irec_from_disk(&gp->pptr_irec, rec, value, valuelen);
 
 	/*
 	 * We found a parent pointer, but we've filled up the buffer.  Signal

