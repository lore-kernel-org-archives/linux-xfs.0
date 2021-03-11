Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC4BDC4332E
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 03:07:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 947FD64FDF
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 03:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhCKDGg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 22:06:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:45852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229900AbhCKDGZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Mar 2021 22:06:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59B4164FC4;
        Thu, 11 Mar 2021 03:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615431985;
        bh=80TvvDWVCGz28cbyAa5zmk1OIJVYp8lU/u1j1GPkfK8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=r8aU1+IRBBH9EYM4pdJFFD/HxQryuzAw4FqfHWEWwQdBSGsZcyw03jCag+1PxsmeY
         zk1vtwVoQTV5fbxArzMjW2Do5KqHZdcNjlRa/5n8UqOfz8DiVYKcZCuT1lpSDuKfgO
         9K29BKXfARPkYnG9Er5CnWh6NsX1HCQX+xmXr2lW/j95rZOA3ll7n4zQweFcCaFpui
         cusU5DcEMq6EgwtIqLJCiS48HQXtJU/KJFIF3Q0qNyZH8C1r1rIfbCUkJ6y45JriLw
         2LpOGDfaHD/6s9xgwv4D8kaqHWyiI+4ZO24fwUPJ3f/dodei2bBj22F52Z9cLOSFuZ
         aZ9vJDKdST7hg==
Subject: [PATCH 08/11] xfs: force inode inactivation and retry fs writes when
 there isn't space
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 10 Mar 2021 19:06:25 -0800
Message-ID: <161543198495.1947934.14544893595452477454.stgit@magnolia>
In-Reply-To: <161543194009.1947934.9910987247994410125.stgit@magnolia>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Any time we try to modify a file's contents and it fails due to ENOSPC
or EDQUOT, force inode inactivation work to try to free space.  We're
going to use the xfs_inodegc_free_space function externally in the next
patch, so add it to xfs_icache.h now to reduce churn.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   10 ++++++++--
 fs/xfs/xfs_icache.h |    1 +
 2 files changed, 9 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 6081bba3c6ce..594d340bbe37 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1868,10 +1868,16 @@ xfs_blockgc_free_space(
 	struct xfs_mount	*mp,
 	struct xfs_eofblocks	*eofb)
 {
+	int			error;
+
 	trace_xfs_blockgc_free_space(mp, eofb, _RET_IP_);
 
-	return xfs_inode_walk(mp, 0, xfs_blockgc_scan_inode, eofb,
+	error =  xfs_inode_walk(mp, 0, xfs_blockgc_scan_inode, eofb,
 			XFS_ICI_BLOCKGC_TAG);
+	if (error)
+		return error;
+
+	return xfs_inodegc_free_space(mp, eofb);
 }
 
 /*
@@ -2054,7 +2060,7 @@ xfs_inactive_inode(
  * corrupted, we still need to clear the INACTIVE iflag so that we can move
  * on to reclaiming the inode.
  */
-static int
+int
 xfs_inodegc_free_space(
 	struct xfs_mount	*mp,
 	struct xfs_eofblocks	*eofb)
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index c199b920722a..9d5a1f4c0369 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -86,5 +86,6 @@ void xfs_inodegc_worker(struct work_struct *work);
 void xfs_inodegc_force(struct xfs_mount *mp);
 void xfs_inodegc_stop(struct xfs_mount *mp);
 void xfs_inodegc_start(struct xfs_mount *mp);
+int xfs_inodegc_free_space(struct xfs_mount *mp, struct xfs_eofblocks *eofb);
 
 #endif

