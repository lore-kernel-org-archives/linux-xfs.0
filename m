Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 447A0C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 00:23:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C97A61424
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 00:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234501AbhDUAXs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 20:23:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234223AbhDUAXr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Apr 2021 20:23:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B494F6141C;
        Wed, 21 Apr 2021 00:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618964594;
        bh=/IORSqdy+Ox8dFWvtPo45m+ddaFqcKeIwkSWZfD/B8g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=t12Xpf9LrzydG/T7x/CfrzjwxWOIbmCRmHpYo4yO1JDG6DLc4TmBnR0EbaoR/XddF
         QnfvuX+sQgj8/6WO4afwMIKvAi21meFBIhTu4KGc6mhd6K/uc1Tbti1xyQ4rcfNyh4
         w0J1szaF3gv/2VlpHUecpqhFndkGeWgtsB3Tqq8wNCQNb+5S3QZVppPIL5O5XMiiEb
         dGUorCP4xVjxU/fWjqXMUrp6EOFLCzKh0hvMc+tbWKzyH4AgPKoiaDU2yLC1ghusA0
         yHchPy8vvK6+GjZQjEd0aBs9lxKmVA6J4HtOTaUj0zePgxJ/3CC1ESaXysVOVKd3sn
         No8wJQbZEuuyA==
Subject: [PATCH 2/4] xfs/122: add legacy timestamps to ondisk checker
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 20 Apr 2021 17:23:13 -0700
Message-ID: <161896459378.776452.5480197157832099240.stgit@magnolia>
In-Reply-To: <161896458140.776452.9583732658582318883.stgit@magnolia>
References: <161896458140.776452.9583732658582318883.stgit@magnolia>
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

