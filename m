Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29DD2C07E9C
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 00:21:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1163461C91
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 00:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbhGGAX5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jul 2021 20:23:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:52322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229873AbhGGAX5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Jul 2021 20:23:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CEBF61CAC;
        Wed,  7 Jul 2021 00:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625617278;
        bh=NO12Tw6QZY5DocZQ9diAFbXa7mcr1ltqynm3BdIKO2I=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bBbnEUmU7hsYQNwcwAum9oBg75rMyU+bqrvsDXzgs14nbBdci9Ku8QA4inj85HfAw
         NE6DzD1OKBr/2HfXhIeHxgPTRVJgeVWQgZ4rhNblY2XUUH/+X694kU+mnW4gAkucmi
         /kMikwtyvHRqg1WnQ4U6efH+JB5a23mwAVbYHDhbJ4P7eT3NK6yLpT285YIMOH/3lX
         ohFqnWIgo4tZTzqlquU+r+LIooFwQgo/h/aFm97/+prBBavKAOHg06BtmqkTN0uesS
         uZQEv26MGsffmqJuMAUPXtknHgJSO/pJMY/1XwAJsHGa3PcHevHNQefQgrzjiL8958
         QYa06VVuEh65w==
Subject: [PATCH 2/8] generic/561: hide assertions when duperemove is killed
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 06 Jul 2021 17:21:17 -0700
Message-ID: <162561727795.543423.1496821526582808789.stgit@locust>
In-Reply-To: <162561726690.543423.15033740972304281407.stgit@locust>
References: <162561726690.543423.15033740972304281407.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Use some bash redirection trickery to capture in $seqres.full all of
bash's warnings about duperemove being killed due to assertions
triggering.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/561 |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)


diff --git a/tests/generic/561 b/tests/generic/561
index bfd4443d..85037e50 100755
--- a/tests/generic/561
+++ b/tests/generic/561
@@ -62,8 +62,13 @@ dupe_run=$TEST_DIR/${seq}-running
 touch $dupe_run
 for ((i = 0; i < $((2 * LOAD_FACTOR)); i++)); do
 	while [ -e $dupe_run ]; do
-		$DUPEREMOVE_PROG -dr --dedupe-options=same $testdir \
-			>>$seqres.full 2>&1
+		# Employ shell trickery here so that the golden output does not
+		# capture assertions that trigger when killall shoots down
+		# dupremove processes in an arbitrary order, which leaves the
+		# memory in an inconsistent state long enough for the assert
+		# to trip.
+		cmd="$DUPEREMOVE_PROG -dr --dedupe-options=same $testdir"
+		bash -c "$cmd" >> $seqres.full 2>&1
 	done 2>&1 | sed -e '/Terminated/d' &
 	dedup_pids="$! $dedup_pids"
 done

