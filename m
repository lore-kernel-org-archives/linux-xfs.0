Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF2F4C4332D
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 22:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92A6364E89
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 22:35:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbhCRWe3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Mar 2021 18:34:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232529AbhCRWeQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Mar 2021 18:34:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3EF864E0C;
        Thu, 18 Mar 2021 22:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616106856;
        bh=hvDtS7HhG501PZE5Jt0zTjIEThh/dy9/Z3vAuCZ38/Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HhRsK2oYScQ2AolLBdyz5CY01wf1H02gPR/RN0Mw/zuMNMfl7Nmw4HqH0UHren1Y1
         MBa3wd7xBoLuY7Kv/cl4B0Tx5Ywav9/jVmtRs2j0GX5bIRCe1k0w40ENfsg4ZyB06Z
         iqOaTvzl1qv19iDcQHcEbjLbX9w/hCghmntaaE4NnkTq01TIbsn/ky5wI36Za0yCMa
         VFY/f5+5L7H7bb8GUraPdg+XZ1zi+FjyZTM3Z/IL+kDHM17Lt09S+KmblMbGzrvbVU
         UAzLRLCZOSm4AytoLC2LNfWCOMLnsolMRJ3IKLvgqPENv62+VWbZRKiYcJdNb64zTw
         VgRhzkYhd9yQQ==
Subject: [PATCH 3/7] xfs: force inode inactivation and retry fs writes when
 there isn't space
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Thu, 18 Mar 2021 15:34:15 -0700
Message-ID: <161610685558.1887744.12581733634906087618.stgit@magnolia>
In-Reply-To: <161610683869.1887744.8863884017621115954.stgit@magnolia>
References: <161610683869.1887744.8863884017621115954.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Any time we try to modify a file's contents and it fails due to ENOSPC
or EDQUOT, force inode inactivation work to try to free space.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index c0a0f6055cc1..8c74e6f08d10 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1866,9 +1866,15 @@ xfs_blockgc_free_space(
 	struct xfs_mount	*mp,
 	struct xfs_eofblocks	*eofb)
 {
+	int			error;
+
 	trace_xfs_blockgc_free_space(mp, eofb, _RET_IP_);
 
-	return xfs_inode_walk(mp, xfs_blockgc_scan_inode, eofb);
+	error = xfs_inode_walk(mp, xfs_blockgc_scan_inode, eofb);
+	if (error)
+		return error;
+
+	return xfs_inodegc_free_space(mp, eofb);
 }
 
 /*

