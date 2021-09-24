Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83CB0C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 01:27:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67A4261214
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 01:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243766AbhIXB3H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Sep 2021 21:29:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243758AbhIXB3G (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Sep 2021 21:29:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D15061108;
        Fri, 24 Sep 2021 01:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632446854;
        bh=1NX2Ybc63jUEpuOVeUNbIRmpPsZRsagdGx62/MwdTwE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TtDlvtnv/rgEh2oNQGj3sdj9cihMb3/P2cqJsWUcbiL/StkmJbsu1czOBov22k8NE
         3LzrK5i+7/x1nusXfmHN9tmKVzvWgRfFPbTTQgoTknYOdD/uulUH4bYhuhtsN1sJ6s
         dcN64dQxKfUFsUzOIaIiChMP6HyDSy9CPh+1KPdfNBXi+bpoGb5fcY6+FKWx87GhJr
         BNmycaxVBehNK38NK/Bv3jO2tsojOQghZJoBj3vs3ogk6qjUr/2CP9KPio/D2LOfnr
         aVV8/kGi1UB5QdlCQGVCYCJ/z3etV2UGD7kPARZJwNDcM/7q6Uw2CTZTQayWDOM/6H
         1Ubt7vD5AV0ig==
Subject: [PATCH 15/15] xfs: kill XFS_BTREE_MAXLEVELS
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@oracle.com, chandanrlinux@gmail.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 23 Sep 2021 18:27:34 -0700
Message-ID: <163244685429.2701302.6992183393252816361.stgit@magnolia>
In-Reply-To: <163244677169.2701302.12882919857957905332.stgit@magnolia>
References: <163244677169.2701302.12882919857957905332.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Nobody uses this symbol anymore, so kill it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.h |    2 --
 1 file changed, 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index b848571f999b..89239b2be096 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -92,8 +92,6 @@ uint32_t xfs_btree_magic(int crc, xfs_btnum_t btnum);
 #define XFS_BTREE_STATS_ADD(cur, stat, val)	\
 	XFS_STATS_ADD_OFF((cur)->bc_mp, (cur)->bc_statoff + __XBTS_ ## stat, val)
 
-#define	XFS_BTREE_MAXLEVELS	9	/* max of all btrees */
-
 /*
  * The btree cursor zone hands out cursors that can handle up to this many
  * levels.  This is the known maximum for all btree types.

