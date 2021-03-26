Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 403F1C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 02:49:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 060F961A45
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 02:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbhCZCsx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 22:48:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230415AbhCZCsh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 22:48:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C92CC61A36;
        Fri, 26 Mar 2021 02:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616726917;
        bh=oVXlbmT0uZfQHg/Y+LnWcHqw0B1dwfEfhp+7uXFQSRo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tt3dhFrAnr6Ufnlj6KQWl9RZAII+8w+yH2FAczV2gGbS1ls9e7OtH/+fkUw/BMl6o
         0Wbmg4Bj78NbzHLb/9fNKJrO4dn++k+no4Wv+AkdtHAtZcZRFUndaBnVX3Y3YY1+VV
         MJwhtJmfQa4RtyVBkbWUP3GUWaK95s1/S0VqSqWoYUJxd8AkJcxc094vHGWyCibB6T
         z2nzPhzKmJtjsVBzgBpEz/UnuYlBt1Vjr42LYxheLih02v6MzyTAq+M7Sa1qrCR1KT
         LRHLtLwObIPvtKxAHzq7MBzzckFXuWBUFnM3HoUzqv4y7xT0XTSGGHIjQQYTADTU9M
         FKWZTayqtRI0A==
Subject: [PATCH 1/2] design: document the new inode btree counter feature
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 25 Mar 2021 19:48:36 -0700
Message-ID: <161672691610.721010.7862802842151633155.stgit@magnolia>
In-Reply-To: <161672690975.721010.3851165011742824524.stgit@magnolia>
References: <161672690975.721010.3851165011742824524.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Update the ondisk format documentation to discuss the inode btree
counter feature.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 .../allocation_groups.asciidoc                     |   21 ++++++++++++++++++++
 1 file changed, 21 insertions(+)


diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index 992615d..2e78f56 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -405,6 +405,13 @@ reference counts of AG blocks.  This enables files to share data blocks safely.
 See the section about xref:Reflink_Deduplication[reflink and deduplication] for
 more details.
 
+| +XFS_SB_FEAT_RO_COMPAT_INOBTCNT+ |
+Inode B+tree block counters.  Each allocation group's inode (AGI) header
+tracks the number of blocks in each of the inode B+trees.  This allows us
+to have a slightly higher level of redundancy over the shape of the inode
+btrees, and decreases the amount of time to compute the metadata B+tree
+preallocations at mount time.
+
 |=====
 
 *sb_features_incompat*::
@@ -928,6 +935,10 @@ struct xfs_agi {
 
      __be32              agi_free_root;
      __be32              agi_free_level;
+
+     __be32              agi_iblocks;
+     __be32              agi_fblocks;
+
 }
 ----
 *agi_magicnum*::
@@ -984,6 +995,16 @@ B+tree.
 *agi_free_level*::
 Specifies the number of levels in the free inode B+tree.
 
+*agi_iblocks*::
+The number of blocks in the inode B+tree, including the root.
+This field is zero if the +XFS_SB_FEAT_RO_COMPAT_INOBTCNT+ feature is not
+enabled.
+
+*agi_fblocks*::
+The number of blocks in the free inode B+tree, including the root.
+This field is zero if the +XFS_SB_FEAT_RO_COMPAT_INOBTCNT+ feature is not
+enabled.
+
 [[Inode_Btrees]]
 == Inode B+trees
 

