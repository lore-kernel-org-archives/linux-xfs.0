Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CE53C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 23:57:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62D5A600CC
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 23:57:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhESX6c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 19:58:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229556AbhESX6b (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 May 2021 19:58:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 445A7600CC;
        Wed, 19 May 2021 23:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621468631;
        bh=jtZ+BVQ1OTCwkIANLmYBRfwz4ehrvttO0CykMrsV1qY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RYuCiF8uJRy/zmDbT7FoDKvsRRPVx/ZRcBjPj4yfgXgYmGzyrkejPmzVeo1VVyRCF
         bT6nentf/sHbHpFJAcHkLR1wsxOdpSMVVz+ASH4iJoxGwO02TcfIDjlp1bcOJnhcde
         p1MYaRkvDLr+0W7ymaUr4k10PMx4ommMLlnD3Ls9f+E2fAcVgXIJ+PXlmMdDYBTRWu
         1y8UjrxZQqnGDYKyi43snfOS1iWoSRTRS9oBm+lAsoSAjYYvIZg7EZ1whhYS2yRCni
         YOEmsy6zBMlzsA3hMcw/iVgNrzOjNcGSh7SdD+lc32rEhi7RyQtLaiCm7VVvLHfpKf
         Ys8j710ANjRNQ==
Subject: [PATCH 5/6] xfs/178: fix mkfs success test
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 19 May 2021 16:57:10 -0700
Message-ID: <162146863062.2500122.10306270841818355198.stgit@magnolia>
In-Reply-To: <162146860057.2500122.8732083536936062491.stgit@magnolia>
References: <162146860057.2500122.8732083536936062491.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix the obviously incorrect code here that wants to fail the test if
mkfs doesn't succeed.  The return value ("$?") is always the status of
the /last/ command in the pipe.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/178 |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/tests/xfs/178 b/tests/xfs/178
index a24ef50c..122d63d2 100755
--- a/tests/xfs/178
+++ b/tests/xfs/178
@@ -57,8 +57,8 @@ _supported_fs xfs
 #             fix filesystem, new mkfs.xfs will be fine.
 
 _require_scratch
-_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs \
-        || _fail "mkfs failed!"
+_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
+test "${PIPESTATUS[0]}" -eq 0 || _fail "mkfs failed!"
 
 # By executing the followint tmp file, will get on the mkfs options stored in
 # variables

