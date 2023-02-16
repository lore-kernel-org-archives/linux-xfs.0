Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9969C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbjBPVOC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:14:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbjBPVOC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:14:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559CC528AE;
        Thu, 16 Feb 2023 13:13:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05865B82760;
        Thu, 16 Feb 2023 21:13:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4869C433EF;
        Thu, 16 Feb 2023 21:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676582030;
        bh=kGPS86Yoo1/xLbVI9OVbMJRmDqvXFvq8/UTINKDboSg=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=D7f56bBHp2jjR5UeLSF+0x5TrHoWVhot3HOQuCUq3ZNPzw0iHG1DKlYRij2ctRGNE
         ZiA2ho5PavFiEYlN1iwH3xdH1JuZy2a75beWSaXZcb7EI470YsRVKixOMvOdXdiRR+
         WbsganedP0ZvOB7OlxZfBo/kADsDO2eI/kWvgM+2M7BlGSyFe/JOICWKvS3fDZ1ge4
         IkufkyUuc34ESIrjkvOIUH9X/kpb6xy14KaD545ewjcR7sZPfdUEp5QFb27OFIbM0s
         B5DnxpR8gwm1sP2eMeQFrQX9eGXVeTbTVYxfUYS24ix/kZGEpTojdFPSamxOH3nvAC
         doWI1/OCRQoEA==
Date:   Thu, 16 Feb 2023 13:13:50 -0800
Subject: [PATCH 01/14] xfs/122: update for parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167657884498.3481377.10849605861429123968.stgit@magnolia>
In-Reply-To: <167657884480.3481377.14824439551809919632.stgit@magnolia>
References: <167657884480.3481377.14824439551809919632.stgit@magnolia>
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
 tests/xfs/122.out |    4 ++++
 tests/xfs/206     |    3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 43461e875c..c5958d1b99 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -109,7 +109,11 @@ sizeof(struct xfs_legacy_timestamp) = 8
 sizeof(struct xfs_log_dinode) = 176
 sizeof(struct xfs_log_legacy_timestamp) = 8
 sizeof(struct xfs_map_extent) = 32
+sizeof(struct xfs_parent_name_irec) = 32
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

