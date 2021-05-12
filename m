Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83B50C43460
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 02:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51533611BD
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 02:02:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbhELCDS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 May 2021 22:03:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230095AbhELCDS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 May 2021 22:03:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B00761166;
        Wed, 12 May 2021 02:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620784930;
        bh=Fq8RAKDaHHM2N1AM49LV4Ew8DIzwMHKadaKU08rm+qI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=g7XCoikK/MteShw/DpBzniG28t2A911OdSFJI+jVOBq/QpL8h+YigQSfDmZH50cVd
         Nygbgfai42uvzYyhJLmKSJ7P++fgVOLOO5ETjSmP8RJRrdwnuXuYLgb4wxs0jZia9X
         Ek9zwgr05CwYhU7dqHniF1GPKnlEyTo5n9FALN7O3Hfpsy24YbmzLweF3thHLaN5uO
         P1bTnomTb1e/M17wLw7riX6iJMm5BYjvqbpbq9Ay/XG5sqaut6ggt9yx0O3/R1A0oy
         EY2PFqCynOnF+shyvNVtkTwtDgtDIdT465abkV0n82deBr0AJqLseGp/G+sUL6ApT7
         t+mp2EtV3M6JQ==
Subject: [PATCH 5/8] common: always pass -f to $DUMP_COMPRESSOR
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 11 May 2021 19:02:08 -0700
Message-ID: <162078492804.3302755.5107477157116858438.stgit@magnolia>
In-Reply-To: <162078489963.3302755.9219127595550889655.stgit@magnolia>
References: <162078489963.3302755.9219127595550889655.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If the test runner gave us the name of a program to use to compress
dumps, always pass -f to overwrite older compressed images, like the
documentation says we do. This prevents the test suite from stalling on
"foo.md.gz exists, overwrite?" prompts.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc  |    2 +-
 common/xfs |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/common/rc b/common/rc
index 919028ef..b18cf61e 100644
--- a/common/rc
+++ b/common/rc
@@ -628,7 +628,7 @@ _ext4_metadump()
 	test -n "$E2IMAGE_PROG" || _fail "e2image not installed"
 	$E2IMAGE_PROG -Q "$device" "$dumpfile"
 	[ "$compressopt" = "compress" ] && [ -n "$DUMP_COMPRESSOR" ] &&
-		$DUMP_COMPRESSOR "$dumpfile" &>> "$seqres.full"
+		$DUMP_COMPRESSOR -f "$dumpfile" &>> "$seqres.full"
 }
 
 _test_mkfs()
diff --git a/common/xfs b/common/xfs
index 49bd6c31..add33008 100644
--- a/common/xfs
+++ b/common/xfs
@@ -503,7 +503,7 @@ _xfs_metadump() {
 	$XFS_METADUMP_PROG $options "$device" "$metadump"
 	res=$?
 	[ "$compressopt" = "compress" ] && [ -n "$DUMP_COMPRESSOR" ] &&
-		$DUMP_COMPRESSOR "$metadump" &> /dev/null
+		$DUMP_COMPRESSOR -f "$metadump" &> /dev/null
 	return $res
 }
 

