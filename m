Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D8AEC7618A
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjCPTdO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbjCPTdN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:33:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A200815CAA;
        Thu, 16 Mar 2023 12:33:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A03D62100;
        Thu, 16 Mar 2023 19:33:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93403C433D2;
        Thu, 16 Mar 2023 19:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678995191;
        bh=VHn4cJ+oAVXTAVvvC8zIdGmhcTu1MwoYgoCHPIWfsTI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=YTu27ZYAXXo2NnA6AcqxvGFmvq/XM7i3wRefKo/p5rZBSsCigcoC3yea1dLk72ciL
         tA8PPKVKIX+wQ7l7VgNgYWu4zfkDIwngA85aa4VGxQjb+KiwdpdssyyuitYaHzwVxz
         fXb0sroLpMTjvLccMgFgxLMZAj7Zt/HpPp/sE4D4V++LusGULMcmQrwg3hJnoyeqrM
         PfhXa4GuzA2z9def4bVSIKCUz5raSk0+JhQI+PsMZ6u9AT0b8/wNIygYo1gN49mgo1
         S4UVLEJoKMDk2cNfJ/n8rd0UXV7JcGVALvqzuwePe1R84TSSrGqZ07IunwEr2BKvjB
         svr0DlV4VeYKQ==
Date:   Thu, 16 Mar 2023 12:33:11 -0700
Subject: [PATCH 01/14] xfs/122: update for parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167899417668.17926.7983061083890838561.stgit@frogsfrogsfrogs>
In-Reply-To: <167899417650.17926.7405859750613330339.stgit@frogsfrogsfrogs>
References: <167899417650.17926.7405859750613330339.stgit@frogsfrogsfrogs>
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
 tests/xfs/206     |    3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 43461e875c..0877f14bf2 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -109,7 +109,10 @@ sizeof(struct xfs_legacy_timestamp) = 8
 sizeof(struct xfs_log_dinode) = 176
 sizeof(struct xfs_log_legacy_timestamp) = 8
 sizeof(struct xfs_map_extent) = 32
+sizeof(struct xfs_parent_name_rec) = 16
+sizeof(struct xfs_parent_ptr) = 280
 sizeof(struct xfs_phys_extent) = 16
+sizeof(struct xfs_pptr_info) = 104
 sizeof(struct xfs_refcount_key) = 4
 sizeof(struct xfs_refcount_rec) = 12
 sizeof(struct xfs_rmap_key) = 20
diff --git a/tests/xfs/206 b/tests/xfs/206
index 904d53deb0..b29edeadf0 100755
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -66,7 +66,8 @@ mkfs_filter()
 	    -e "/.*crc=/d" \
 	    -e "/^Default configuration/d" \
 	    -e "/metadir=.*/d" \
-	    -e '/rgcount=/d'
+	    -e '/rgcount=/d' \
+	    -e '/parent=/d'
 }
 
 # mkfs slightly smaller than that, small log for speed.

