Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03FECC4707F
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 01:47:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8D3161429
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 01:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbhEZBsm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 21:48:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230123AbhEZBsk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 May 2021 21:48:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 562FA61090;
        Wed, 26 May 2021 01:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621993630;
        bh=YL/o1WyGAgqDY22nMhmz/PoqxP9YmmxmjN4nRAtvjN8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TDwh4mfMRCjWZeQdQ5Sgy2zjqPCcP/kiD+0wwBQJTSozV69e0zZLeYKUg41QjYuDu
         O0wKbCaQOMJGxUWyn/aK3bmkRb15Ua6KaqueXwgPsJliieQYzuYetcTiuTWyEBuJra
         x2xMVIQfy324yhqrkLAEP3ojV8OdFHz6jnaffaaUPuOOrIsG9fCwkJmuMt8yAOU/jN
         IbdH05L7OBONEJ0aEQ/PLsmGIDVy/s7zizuPGR8uQpoS5R9edXaqhPnW9SXMUhaTpM
         sLFUONpzgy9yOnrAuyrpPT6uQZ6BpHnyakoduwmg92rGlXlnHTkpw3h2qy/YzaROKz
         QrRcwS4kXouzA==
Subject: [PATCH 05/10] fstests: clean up open-coded golden output
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 25 May 2021 18:47:10 -0700
Message-ID: <162199363006.3744214.15458376927727153135.stgit@locust>
In-Reply-To: <162199360248.3744214.17042613373014687643.stgit@locust>
References: <162199360248.3744214.17042613373014687643.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix the handful of tests that open-coded 'QA output created by XXX'.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/btrfs/006.out   |    2 +-
 tests/btrfs/012.out   |    2 +-
 tests/generic/184.out |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/tests/btrfs/006.out b/tests/btrfs/006.out
index a9769721..b7f29f96 100644
--- a/tests/btrfs/006.out
+++ b/tests/btrfs/006.out
@@ -1,4 +1,4 @@
-== QA output created by 006
+QA output created by 006
 == Set filesystem label to TestLabel.006
 == Get filesystem label
 TestLabel.006
diff --git a/tests/btrfs/012.out b/tests/btrfs/012.out
index 2a41e7e4..7aa5ae94 100644
--- a/tests/btrfs/012.out
+++ b/tests/btrfs/012.out
@@ -1 +1 @@
-== QA output created by 012
+QA output created by 012
diff --git a/tests/generic/184.out b/tests/generic/184.out
index 2d19691d..4c300543 100644
--- a/tests/generic/184.out
+++ b/tests/generic/184.out
@@ -1 +1 @@
-QA output created by 184 - silence is golden
+QA output created by 184

