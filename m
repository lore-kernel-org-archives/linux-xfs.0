Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 467A1C43460
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 01:05:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DDB0613C7
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 01:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348962AbhDNBFa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Apr 2021 21:05:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:38014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348961AbhDNBF3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Apr 2021 21:05:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EF3E613B6;
        Wed, 14 Apr 2021 01:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618362308;
        bh=yVCTxakyZU3lgyVj63fpYJS/4nk3ZSvUiHgdX6m/wH8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Wpu4oKDHk7Jl2+ymKFvSRFIXPJ5RuDiA5aCnWbpAoqjSmU78v8XqIbgCnZDrA8xA0
         ua+QW2kWutzqYI6cz06m13jLRGJ1BvefGyFniLvVnplAhTLmW4hzLl03qy1cYQU2Wx
         JYQuMvkglG8kQhiLkOrFoPbXBvmZ69Ia8EJ3crWUGhozaJTPRZrGtcGT0JdzwUu/89
         VVTMKE+JtfDojrTudYZIKwLcYlLYORjsvkGE8g8KtgSHTWQTuqeVxF42zOUm7l+pkH
         2RQUvHpF4Rsq05xe6tAJgW0f+IFyRjCTtpi8eu0VPjmO7UZSrJWKS1CEXimEIZ5Reh
         zjYHopTyT6uaQ==
Subject: [PATCH 6/9] misc: replace more open-coded _scratch_xfs_db calls
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 13 Apr 2021 18:05:07 -0700
Message-ID: <161836230786.2754991.7641118311374470635.stgit@magnolia>
In-Reply-To: <161836227000.2754991.9697150788054520169.stgit@magnolia>
References: <161836227000.2754991.9697150788054520169.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Replace the last remaining open-coded calls to xfs_db for the scratch
device with calls to _scratch_xfs_db.  This fixes these tests when
external logs are enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/repair |    2 +-
 tests/xfs/030 |    2 +-
 tests/xfs/083 |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/common/repair b/common/repair
index 8adc2178..5a957f4e 100644
--- a/common/repair
+++ b/common/repair
@@ -10,7 +10,7 @@ _zero_position()
 	struct="$2"
 
 	# set values for off/len variables provided by db
-	eval `xfs_db -r -c "$struct" -c stack $SCRATCH_DEV | perl -ne '
+	eval `_scratch_xfs_db -r -c "$struct" -c stack | perl -ne '
 		if (/byte offset (\d+), length (\d+)/) {
 			print "offset=$1\nlength=$2\n"; exit
 		}'`
diff --git a/tests/xfs/030 b/tests/xfs/030
index 906d9019..81198155 100755
--- a/tests/xfs/030
+++ b/tests/xfs/030
@@ -81,7 +81,7 @@ else
 	_scratch_unmount
 fi
 clear=""
-eval `xfs_db -r -c "sb 1" -c stack $SCRATCH_DEV | perl -ne '
+eval `_scratch_xfs_db -r -c "sb 1" -c stack | perl -ne '
 	if (/byte offset (\d+), length (\d+)/) {
 		print "clear=", $1 / 512, "\n"; exit
 	}'`
diff --git a/tests/xfs/083 b/tests/xfs/083
index a548be2a..a3f32cb7 100755
--- a/tests/xfs/083
+++ b/tests/xfs/083
@@ -108,7 +108,7 @@ echo "+ check fs" >> $seqres.full
 _scratch_xfs_repair >> $seqres.full 2>&1 || _fail "should pass initial fsck"
 
 echo "++ corrupt image" >> $seqres.full
-xfs_db -x -c blockget -c "blocktrash ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full 2>&1
+_scratch_xfs_db -x -c blockget -c "blocktrash ${FUZZ_ARGS}" >> $seqres.full 2>&1
 
 echo "++ mount image" >> $seqres.full
 _try_scratch_mount >> $seqres.full 2>&1

