Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2877C636D6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:18:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjBPVSe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:18:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjBPVSd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:18:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE28B497D2;
        Thu, 16 Feb 2023 13:18:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59F5760C77;
        Thu, 16 Feb 2023 21:18:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8B5FC4339B;
        Thu, 16 Feb 2023 21:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676582311;
        bh=2xZ60o7ocy8EyS4tyeU0XeSpJ5QYLdFg9rcWIEo/Peg=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=h8qmNPRpRDjC38Z/F0ikmP3uE3GjlNhaGKF6gJ2594R08wT0bpn2MPZtLn+k5X+VR
         TonKnjj9IlRMuOoCV9eXa1wJgIFw7wIvABP5Gda57UmLWLoQt/xEwbAg36K1gpmNjq
         AA2R+9ujAlAPlv1jkF0hcaSlaK8y50XHsbboXBPmvpLE+dmkrRwQ2lE7fveF6wiTmE
         nfAx8b1SXQKmDGVZUqWnZUds3IZj2cA5sc2/3cClWI2qij4BNFRhRTxr8+LxBI7KuZ
         7hNKqo+LvqZ9Fk5gyM3HhYy02xu2J+DttS9ZNUjH/0GSm9XTYqQbmvFMuLZRyTaOn3
         RDTHTFTVPDRIA==
Date:   Thu, 16 Feb 2023 13:18:31 -0800
Subject: [PATCH 1/1] xfs/122: adjust for flex-array XFS_IOC_GETPARENTS ioctl
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167657885337.3481879.210531807700194954.stgit@magnolia>
In-Reply-To: <167657885325.3481879.849107578244828019.stgit@magnolia>
References: <167657885325.3481879.849107578244828019.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Adjust the values here for the flex-array based GETPARENTS structure
definitions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 5233aaad5f..fe67a0206d 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -100,6 +100,8 @@ sizeof(struct xfs_fsop_ag_resblks) = 64
 sizeof(struct xfs_fsop_geom) = 256
 sizeof(struct xfs_fsop_geom_v1) = 112
 sizeof(struct xfs_fsop_geom_v4) = 112
+sizeof(struct xfs_getparents) = 96
+sizeof(struct xfs_getparents_rec) = 24
 sizeof(struct xfs_icreate_log) = 28
 sizeof(struct xfs_inode_log_format) = 56
 sizeof(struct xfs_inode_log_format_32) = 52
@@ -111,9 +113,7 @@ sizeof(struct xfs_log_legacy_timestamp) = 8
 sizeof(struct xfs_map_extent) = 32
 sizeof(struct xfs_parent_name_irec) = 96
 sizeof(struct xfs_parent_name_rec) = 12
-sizeof(struct xfs_parent_ptr) = 280
 sizeof(struct xfs_phys_extent) = 16
-sizeof(struct xfs_pptr_info) = 104
 sizeof(struct xfs_refcount_key) = 4
 sizeof(struct xfs_refcount_rec) = 12
 sizeof(struct xfs_rmap_key) = 20

