Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 370C6C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 23:52:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E95061051
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 23:52:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345143AbhIBXxj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Sep 2021 19:53:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345048AbhIBXxj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Sep 2021 19:53:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E421F6101A;
        Thu,  2 Sep 2021 23:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630626760;
        bh=rxk/t4cR1g4piI1VKbOEcrL83pmv/7seWPEVoC2Ns3s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=o0uwmXPWeKoAgVg1ohqKrkHgWlmOwusKoqoDnTkqWOdzYMiicMgo9kydmyPl+z8WZ
         1xZuypLw6C9xepJvlhEdViTlO7mvtJhW+XzFavp/eqRLCVOTsYjV1+vL43AzOB0XJt
         90nWUWUip0YUNsZv9QsI5dJ0NvHf9HKlTtTHw7+WHwhMXhIF3a+KFOB+etV7nNezX4
         rJOu2j23p0oWLpvr5QsBDHHlM2cuOujWRmAiX4aseZCVZmKQjAaoYIMTpwk6iaEcFQ
         dfjC8pp7Yno3orzewWa/WrSRaHs+QbEkyh+xheaEOrq2ca6j3DCu/pcwlZJh2+iWPv
         t1PU2NjrTDilg==
Subject: [PATCH 3/8] xfs: fix incorrect fuzz test group name
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Thu, 02 Sep 2021 16:52:39 -0700
Message-ID: <163062675965.1579659.16363145615876546346.stgit@magnolia>
In-Reply-To: <163062674313.1579659.11141504872576317846.stgit@magnolia>
References: <163062674313.1579659.11141504872576317846.stgit@magnolia>
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

