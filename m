Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02889C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:07:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDDF5600D4
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbhIOXIX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:08:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232684AbhIOXIW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:08:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5991E606A5;
        Wed, 15 Sep 2021 23:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747222;
        bh=tysK1yawfYQYmqKb7uOa4YN0VfdAC9UTqV5rixYZKQk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bwMgdi+BAVOQeVbUchE9l6CxkQcfkRIomHCvOq0T1qhzbL4hi6nzWs3UXv+ZHTr8U
         9temeUQegf+Xu6Et6RdgmjGoamSTdctZuTsB+Ml5PYLxfI1xSj4FbjrJ4zodsdbIJe
         7Ls1Ob3IDMqfDlGIqtDsgEZV2iI3APBodiOsxnuUsF4Gfj9Twpzatn0dxSKOPebPyw
         v0pXK9lp4bDMK0nzS74VbWYF0hcWf+jfoS7vXEjV48zdmSn+25jptvrlskVWrkXPKn
         Kbiae74FvoHLSOUkGxOcWu0auWrxKKm/x2Jsu25yAMKnBoxyP65w1s1Z0UCXA9Lnwd
         u1VuAJE1qEqQw==
Subject: [PATCH 05/61] libxfs: fix whitespace inconsistencies with kernel
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:07:02 -0700
Message-ID: <163174722210.350433.13099529255108655931.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix a few places where the whitespace isn't an exact match for the
kernel.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.h      |    2 +-
 libxfs/xfs_rmap_btree.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 0f790234..10e50cba 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -88,7 +88,7 @@ uint32_t xfs_btree_magic(int crc, xfs_btnum_t btnum);
  */
 #define XFS_BTREE_STATS_INC(cur, stat)	\
 	XFS_STATS_INC_OFF((cur)->bc_mp, (cur)->bc_statoff + __XBTS_ ## stat)
-#define XFS_BTREE_STATS_ADD(cur, stat, val)    \
+#define XFS_BTREE_STATS_ADD(cur, stat, val)	\
 	XFS_STATS_ADD_OFF((cur)->bc_mp, (cur)->bc_statoff + __XBTS_ ## stat, val)
 
 #define	XFS_BTREE_MAXLEVELS	9	/* max of all btrees */
diff --git a/libxfs/xfs_rmap_btree.h b/libxfs/xfs_rmap_btree.h
index 08c57dee..35b81fc8 100644
--- a/libxfs/xfs_rmap_btree.h
+++ b/libxfs/xfs_rmap_btree.h
@@ -4,7 +4,7 @@
  * All Rights Reserved.
  */
 #ifndef __XFS_RMAP_BTREE_H__
-#define	__XFS_RMAP_BTREE_H__
+#define __XFS_RMAP_BTREE_H__
 
 struct xfs_buf;
 struct xfs_btree_cur;

