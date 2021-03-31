Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA90DC433F4
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 01:09:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D01BC619D7
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 01:09:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbhCaBIw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 21:08:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:42272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232892AbhCaBIt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Mar 2021 21:08:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33D4261935;
        Wed, 31 Mar 2021 01:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617152929;
        bh=/IORSqdy+Ox8dFWvtPo45m+ddaFqcKeIwkSWZfD/B8g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=AnLej2B2ZSBmuTUEhZFv94QDxzXRFEPWI1Oj+/ole7lZ05IoTK/9yP7FosliOlTkV
         9gybZgVWk146xE8yyZR8L2fAnnTo1gWzlJJ3dey8jpv4O+IUUvH3LRYD5zAN/HfCzz
         OsMCOM4L6OFN5sFqsyS2o64izEbByykIGo9VnrWKtNlc8CgJwfRWInIvG51H55PWr+
         AxiFiwMinP8DWyGcbeRH4NDu9MI/fpIF5B+eQw+wIgC1qEgcLhdlfW5sePgd2oLoGe
         eD+CsVNLk/MSWPBAJgx0GlhpQtZg1OdlML36y3mG2473FxEDtuySDbZmFBOfoQ7Xk5
         ZCTNrZVXI41yQ==
Subject: [PATCH 2/4] xfs/122: add legacy timestamps to ondisk checker
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 30 Mar 2021 18:08:46 -0700
Message-ID: <161715292687.2703979.6393758446727428463.stgit@magnolia>
In-Reply-To: <161715291588.2703979.11541640936666929011.stgit@magnolia>
References: <161715291588.2703979.11541640936666929011.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add these new ondisk structures.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/xfs/122     |    1 +
 tests/xfs/122.out |    1 +
 2 files changed, 2 insertions(+)


diff --git a/tests/xfs/122 b/tests/xfs/122
index 322e1d81..c8593315 100755
--- a/tests/xfs/122
+++ b/tests/xfs/122
@@ -181,6 +181,7 @@ struct xfs_iext_cursor
 struct xfs_ino_geometry
 struct xfs_attrlist
 struct xfs_attrlist_ent
+struct xfs_legacy_ictimestamp
 EOF
 
 echo 'int main(int argc, char *argv[]) {' >>$cprog
diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index b0773756..f229465a 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -97,6 +97,7 @@ sizeof(struct xfs_inode_log_format) = 56
 sizeof(struct xfs_inode_log_format_32) = 52
 sizeof(struct xfs_inumbers) = 24
 sizeof(struct xfs_inumbers_req) = 64
+sizeof(struct xfs_legacy_timestamp) = 8
 sizeof(struct xfs_log_dinode) = 176
 sizeof(struct xfs_map_extent) = 32
 sizeof(struct xfs_phys_extent) = 16

