Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C28E9C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jun 2022 04:07:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbiFHEGq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jun 2022 00:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235180AbiFHEFL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jun 2022 00:05:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498B920E53E
        for <linux-xfs@vger.kernel.org>; Tue,  7 Jun 2022 14:03:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE58EB823EF
        for <linux-xfs@vger.kernel.org>; Tue,  7 Jun 2022 21:03:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37E4C385A2;
        Tue,  7 Jun 2022 21:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654635794;
        bh=sPdlS4XioxspyVnwiRZ6X41x+1aXMojBrdhZPbEQ44w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=a4FjuJ3W4uMIBnfwuM+Ij7iqGO9YqrapGBSKtHnalvx1EiDZHG9CLKLZ6RUXxITt8
         jbPXk+fmLgfJN1eFI0w7KHbBNIdEraSUaB5R1AukYrQA85C/3+SC5mTwVDFtRRBup2
         y+CENusCOVtcMdbZY4XE/8mlTkwcEL5yvQ2E82Vtl0ct0I92lsXHOs22slfJa4vIDa
         fwnVKp8h69KpCH+Efdg2v8CLeAcqKH0k+gJqstd8uBI/U5QIcjRmTiQfOA0lecnW+B
         rCbmjEEhJ2QoJPPYQZKqan4+jEmjKk4yeFI0sT6mxAR7kuhziKIANo6Rr9Z0w6hHwy
         C7ySwEPHPBd+w==
Subject: [PATCH 2/3] xfs: fix variable state usage
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, allison.henderson@oracle.com,
        chandan.babu@oracle.com
Date:   Tue, 07 Jun 2022 14:03:14 -0700
Message-ID: <165463579422.417102.2354416446860242047.stgit@magnolia>
In-Reply-To: <165463578282.417102.208108580175553342.stgit@magnolia>
References: <165463578282.417102.208108580175553342.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The variable @args is fed to a tracepoint, and that's the only place
it's used.  This is fine for the kernel, but for userspace, tracepoints
are #define'd out of existence, which results in this warning on gcc
11.2:

xfs_attr.c: In function ‘xfs_attr_node_try_addname’:
xfs_attr.c:1440:42: warning: unused variable ‘args’ [-Wunused-variable]
 1440 |         struct xfs_da_args              *args = attr->xattri_da_args;
      |                                          ^~~~

Clean this up.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 0847b4e16237..1824f61621a2 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1441,12 +1441,11 @@ static int
 xfs_attr_node_try_addname(
 	struct xfs_attr_intent		*attr)
 {
-	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_da_state		*state = attr->xattri_da_state;
 	struct xfs_da_state_blk		*blk;
 	int				error;
 
-	trace_xfs_attr_node_addname(args);
+	trace_xfs_attr_node_addname(state->args);
 
 	blk = &state->path.blk[state->path.active-1];
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);

