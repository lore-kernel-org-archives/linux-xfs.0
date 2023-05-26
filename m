Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C5A4C7EE31
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbjEZCII (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjEZCHv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:07:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5207A3
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:07:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5432C64C4F
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5FF6C433EF;
        Fri, 26 May 2023 02:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066869;
        bh=OG8frxnH6VX2sp3lQjJTi1cJ2qrH1U/Yh7zP+al7tP4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=DVXtwywXCSbYWWg72dfILLKVabDPNKPNpJfsagaL0E3h58XlbfWAfoKAX/ee8yqih
         q97P44J1MMsokRP+iTLJigCHqC05BElzz78EDbB90trnYRj9O6qRqGUcKTscf0KirJ
         zZTBuKF0/AEDonbhhcbLPPZdJUhFhUxKGEUEQJNDY0BsBJ8YqoHXvDynTzfzd/EJrx
         OftOKtXOLsJoPPKlMayErLSwUFZJ4+md59FZfZ/12FEFPoGXFB14BoVcmf35Jp1xG3
         ZbUl1WzzX0QXQ2fRsV+8tS22DAuLfLq+3z0Nhvriny34bpau3JYNC59ombuOizU1d3
         hAeD84gr2hJHA==
Date:   Thu, 25 May 2023 19:07:49 -0700
Subject: [PATCH 04/12] xfs: preserve NVLOOKUP in xfs_attr_set
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506072239.3743652.9612896925228984723.stgit@frogsfrogsfrogs>
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

Preserve the attr-value lookup flag when calling xfs_attr_set.  Normal
xattr users will never use this, but parent pointer fsck will.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 343fa2bf0227..3c999b145a6a 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -986,11 +986,11 @@ xfs_attr_set(
 	/*
 	 * We have no control over the attribute names that userspace passes us
 	 * to remove, so we have to allow the name lookup prior to attribute
-	 * removal to fail as well.  Preserve the logged flag, since we need
-	 * to pass that through to the logging code.
+	 * removal to fail as well.  Preserve the logged and vlookup flags,
+	 * since we need to pass them through to the lower levels.
 	 */
-	args->op_flags = XFS_DA_OP_OKNOENT |
-					(args->op_flags & XFS_DA_OP_LOGGED);
+	args->op_flags &= (XFS_DA_OP_LOGGED | XFS_DA_OP_NVLOOKUP);
+	args->op_flags |= XFS_DA_OP_OKNOENT;
 
 	if (!is_remove) {
 		XFS_STATS_INC(mp, xs_attr_set);

