Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFDCDC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 00:39:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B650261209
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 00:39:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241740AbhIQAkl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 20:40:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241734AbhIQAkk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Sep 2021 20:40:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7603611C4;
        Fri, 17 Sep 2021 00:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631839159;
        bh=OhpvIYYjcsHGAGVl/WJmScC2CToDlD6/vnFiaRi1fU0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Pad/nNHG2FfZQWBC2Srl3p6M0+rSJtzBVFCOgqKrup1Kg8AVY9w+5Xb8IvFI/Tgny
         sJwKUuZxvDP1I0eEyEYooFSHue7XV0VywTU1KesuxjUL7tu19eutfstZ1suxk1Z6Gm
         G1AlPJxn4OHITX3PnZ4oHeFTjrHpWoRfuR+8i/L6HWqhiPs19LCtlgSKckhJgKpoX0
         gywdQGqI7LZg9lx+YbLaXDExdAk1fOyeRfT5TF/DHu7YYgk36DAeDzzSbYLS0d/Y94
         X/E48JphLPXkEEs+x6XcqeSjAcsMJRiF1IzELAGbjkXFvsCuhZwdUIjsBBOdnwU+rZ
         Kj5FYL3Zzg3BA==
Subject: [PATCH 3/8] xfs: fix incorrect fuzz test group name
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Christoph Hellwig <hch@lst.de>,
        Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Thu, 16 Sep 2021 17:39:19 -0700
Message-ID: <163183915942.952957.1401563314479536674.stgit@magnolia>
In-Reply-To: <163183914290.952957.11558799225344566504.stgit@magnolia>
References: <163183914290.952957.11558799225344566504.stgit@magnolia>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
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

