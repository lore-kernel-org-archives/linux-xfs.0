Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD38CC4320E
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 00:12:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9302061041
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 00:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243220AbhIAANm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Aug 2021 20:13:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243241AbhIAANm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Aug 2021 20:13:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 846406102A;
        Wed,  1 Sep 2021 00:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630455166;
        bh=vv3taoie8ul1L8HHj2xb8VOfSmARQrFndjaLNn81Orc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ELaIR7cnZtHTDpFtrXChK18wPXLy20ObW0DnTjQjR1QKCZYTS9XUB9D+B2Iy2Q09j
         b3s7Qo2PBJ4M23ycKklUWDtZ/IeSgJs4GrpL27rKKCWSdPG+3HzB7pEn1yVgqg7Rvq
         CeIevDxFwf3lD0WlU+fNn/M0OJ6gb36ambdTintEKWk7O6xEHU8aUkULu2Oz/t2ii2
         IAZPeKry331XHpWdmsfFMEefW+5JCCg/SVYPnIYrZMJe9W74AJk8cEtYiLk7sIZnOO
         t7LT9vz2YJlbYyP+gL5kB79JuxQrDSTfS4Eph0zayeFer8rNB7uJydWIW3xjCcockZ
         Br2xpsWC1Cq+A==
Subject: [PATCH 3/5] xfs: fix incorrect fuzz test group name
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 31 Aug 2021 17:12:46 -0700
Message-ID: <163045516624.771564.3811466819215120895.stgit@magnolia>
In-Reply-To: <163045514980.771564.6282165259140399788.stgit@magnolia>
References: <163045514980.771564.6282165259140399788.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The group name for fuzz tests is 'fuzzers'.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/491 |    2 +-
 tests/xfs/492 |    2 +-
 tests/xfs/493 |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/tests/xfs/491 b/tests/xfs/491
index 5c7c5d1f..7402b09a 100755
--- a/tests/xfs/491
+++ b/tests/xfs/491
@@ -7,7 +7,7 @@
 # Test detection & fixing of bad summary block counts at mount time.
 #
 . ./common/preamble
-_begin_fstest auto quick fuzz
+_begin_fstest auto quick fuzzers
 
 # Import common functions.
 . ./common/filter
diff --git a/tests/xfs/492 b/tests/xfs/492
index 8258e5d8..514ac1e4 100755
--- a/tests/xfs/492
+++ b/tests/xfs/492
@@ -7,7 +7,7 @@
 # Test detection & fixing of bad summary inode counts at mount time.
 #
 . ./common/preamble
-_begin_fstest auto quick fuzz
+_begin_fstest auto quick fuzzers
 
 # Import common functions.
 . ./common/filter
diff --git a/tests/xfs/493 b/tests/xfs/493
index 58fd9c99..58091ad7 100755
--- a/tests/xfs/493
+++ b/tests/xfs/493
@@ -8,7 +8,7 @@
 # Corrupt the AGFs to test mount failure when mount-fixing fails.
 #
 . ./common/preamble
-_begin_fstest auto quick fuzz
+_begin_fstest auto quick fuzzers
 
 # Import common functions.
 . ./common/filter

