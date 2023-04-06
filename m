Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED05BC76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237369AbjDFTmU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237553AbjDFTmQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:42:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF8B9ED1;
        Thu,  6 Apr 2023 12:42:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFD9D64876;
        Thu,  6 Apr 2023 19:42:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4206BC433EF;
        Thu,  6 Apr 2023 19:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680810134;
        bh=M/6Dya24VqVWqWcNd/upkKp9opJZ4q0M0/xVZ8L7TwQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=rCBm3aklA/pbjYpZoKYAxQ6pFAk0Cn/4d9wiRTtG0SH4Khqlya1eTXKn31dtA9K33
         1h2ihBX9NvF4nwyxBY+JfCXhith/wPKDj2tsSKm2PrSDDxbTO8JsGRR4+AdKdLCCIR
         SauQHTtwdp5YhzLkf1wu0JrSKvLv/9uOAakV2jbuB0RVvJlXzu1bMvFzh7DFk/7wEk
         xEL5mxcvKBJHJv/csVF3FmQ5orfs/nUi1LrIl/ZIZTwZJn0kIfNZawwlFWkwZF6oRG
         9fc8fHL+wRlFCSNGWXOKj19gP74k0BrE/ZEVqKP2I8M/wYCiQFrDwVnj9HfN60Dgkj
         tdnVehHX/Czrg==
Date:   Thu, 06 Apr 2023 12:42:13 -0700
Subject: [PATCH 02/11] xfs/122: update for parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <168080829033.618488.14902602123668221961.stgit@frogsfrogsfrogs>
In-Reply-To: <168080829003.618488.1769223982280364994.stgit@frogsfrogsfrogs>
References: <168080829003.618488.1769223982280364994.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Update test for parent pointers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 89f7b735b0..55138218dd 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -98,6 +98,8 @@ sizeof(struct xfs_fsop_ag_resblks) = 64
 sizeof(struct xfs_fsop_geom) = 256
 sizeof(struct xfs_fsop_geom_v1) = 112
 sizeof(struct xfs_fsop_geom_v4) = 112
+sizeof(struct xfs_getparents) = 96
+sizeof(struct xfs_getparents_rec) = 24
 sizeof(struct xfs_icreate_log) = 28
 sizeof(struct xfs_inode_log_format) = 56
 sizeof(struct xfs_inode_log_format_32) = 52
@@ -107,6 +109,7 @@ sizeof(struct xfs_legacy_timestamp) = 8
 sizeof(struct xfs_log_dinode) = 176
 sizeof(struct xfs_log_legacy_timestamp) = 8
 sizeof(struct xfs_map_extent) = 32
+sizeof(struct xfs_parent_name_rec) = 16
 sizeof(struct xfs_phys_extent) = 16
 sizeof(struct xfs_refcount_key) = 4
 sizeof(struct xfs_refcount_rec) = 12

