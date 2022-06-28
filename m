Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC8C5C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:48:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiF1Us5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbiF1Us4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:48:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95BF12F39E
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 13:48:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 325B061851
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 20:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905AFC341C8;
        Tue, 28 Jun 2022 20:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656449334;
        bh=k0NLvDtWRCasBJGV+FCCK4c6B0wMXMNwlpkQK/TLa2s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gRUgMwSTMqNUpF9ndvy6Ve8RHgEXBOQINTPWBsj9N0Oy3JjWqadm/4HsDtVdsh53/
         abl+pwSxNTP0MP63uURuQUFRgQs8+f9A+4txnBOFR4h99TgGjATqnHIU7lkBh19bph
         o+M70NZpAA/iNnERLUE0IZquV5dZcrOuoDGNArU5pjYDimhz/bb08SHDK59XG4dbbt
         Jmv+kObHypexSvtY50TkeVe9kLDsNgzMHGMivtwSlnxkXPPs9+lfKbYufGBLnpGmEc
         462fEjIX+kAVNpR29G5HcfnuGEYqobK02cwgq+gckCP5IrP/1U9iKS3PV4DiYQ68HQ
         4rRKwkpFNZV6Q==
Subject: [PATCH 5/8] xfs: fix variable state usage
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 28 Jun 2022 13:48:54 -0700
Message-ID: <165644933419.1089724.10811377112251235277.stgit@magnolia>
In-Reply-To: <165644930619.1089724.12201433387040577983.stgit@magnolia>
References: <165644930619.1089724.12201433387040577983.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: e387f3c8beb10f2f557d6fb1d31a0c0252a2b65d

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
---
 libxfs/xfs_attr.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index d2e28a27..dba528e6 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1439,12 +1439,11 @@ static int
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

