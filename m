Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0200EC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 00:39:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0FE6611F2
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 00:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241759AbhIQAkq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 20:40:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241734AbhIQAkq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Sep 2021 20:40:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D59D611C8;
        Fri, 17 Sep 2021 00:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631839165;
        bh=OyVRrQTPWv472b+ESjoSANWBJN7Q0T7nSMZxZggP/gM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mKJFBUlL5/sAWvoTWv+MkoKL+5L20ZCYEZYsJ6hBIH3b6vffIgoe3M5M+j0Qn4Ka0
         bdkmf6K5+xsUH7xqt8us79cFBpfdvBX0vWP6goTOeK8+up16iOgZDbX5mgT2gDjmfD
         +gLfwjq/fp/WX9NUPBisdTZLEMOM8fY1L/xGDzeIqJDzGsK4Mzjftq/wBDA5d7fJuY
         UGVoawP1UHR1U1ZC1Tx2dsC93oDyPyXar0iO+ff/JLLjBH1jSgYLcJx9ZYtzSr/A/9
         sNi8kHtIRUrG6wIM5uVOpkl5shN+vCkBfb5wPT2C6Lpny0wVpz2wCbLKme19EUtrwb
         AbsASsG14Du4A==
Subject: [PATCH 4/8] btrfs: fix incorrect subvolume test group name
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Thu, 16 Sep 2021 17:39:24 -0700
Message-ID: <163183916490.952957.8936273272302960250.stgit@magnolia>
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

The group for testing subvolume functionality is 'subvol', not
'subvolume'.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/btrfs/233 |    2 +-
 tests/btrfs/245 |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/tests/btrfs/233 b/tests/btrfs/233
index f3e3762c..6a414443 100755
--- a/tests/btrfs/233
+++ b/tests/btrfs/233
@@ -9,7 +9,7 @@
 # performed.
 #
 . ./common/preamble
-_begin_fstest auto quick subvolume
+_begin_fstest auto quick subvol
 
 # Override the default cleanup function.
 _cleanup()
diff --git a/tests/btrfs/245 b/tests/btrfs/245
index 2b9c63c7..f3380ac2 100755
--- a/tests/btrfs/245
+++ b/tests/btrfs/245
@@ -8,7 +8,7 @@
 # as subvolume and snapshot creation and deletion.
 #
 . ./common/preamble
-_begin_fstest auto quick idmapped subvolume
+_begin_fstest auto quick idmapped subvol
 
 # get standard environment, filters and checks
 . ./common/rc

