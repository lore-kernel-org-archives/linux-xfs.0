Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80127C07E9D
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 01:11:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C79E611ED
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 01:11:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236842AbhGTAbC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Jul 2021 20:31:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380874AbhGTA1u (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Jul 2021 20:27:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F197600D1;
        Tue, 20 Jul 2021 01:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626743309;
        bh=ltHUv5SYK8uwTC+Kmh832KUqB5N7CIuDox1+NMXQXaE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UTKsIiPp6LHRCT1QMjmJ5w0gPznqFFYn/DYOcjdq6lumETKru8l6yKaUZhYlDfZnV
         UcMC5QCxgBPNTnl6fZkPiaEQ87Wjc+SqMhYllgNOp7FWtMyfsBbr41z70Xvf2fEqEz
         zZckPFqqlNz+Dj9udB4kBw13d9N83zmYUUXDr2pGgQcg4Rkao5LNDoCR2hz9h1Ia1Q
         0KfLfGp1SSy3E9VgGTTZQw5pcbOfBi0q24TMNe75ceWNU2fhLS5KzEljd24v5XVw/d
         oAEYEBcOfH6UzgLkhjgykguR6nxE/Wobcfu+sKd3bCHtEnsZQI6pxnyauAubZRosVa
         CQw4lAyzEnUoA==
Subject: [PATCH 1/1] generic/561: hide assertions when duperemove is killed
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 19 Jul 2021 18:08:29 -0700
Message-ID: <162674330933.2650745.11380233368495712613.stgit@magnolia>
In-Reply-To: <162674330387.2650745.4586773764795034384.stgit@magnolia>
References: <162674330387.2650745.4586773764795034384.stgit@magnolia>
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
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 tests/generic/561 |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)


diff --git a/tests/generic/561 b/tests/generic/561
index bfd4443d..44f07802 100755
--- a/tests/generic/561
+++ b/tests/generic/561
@@ -62,8 +62,13 @@ dupe_run=$TEST_DIR/${seq}-running
 touch $dupe_run
 for ((i = 0; i < $((2 * LOAD_FACTOR)); i++)); do
 	while [ -e $dupe_run ]; do
-		$DUPEREMOVE_PROG -dr --dedupe-options=same $testdir \
-			>>$seqres.full 2>&1
+		# Run cmd in a subshell so that the golden output does not
+		# capture assertions that trigger when killall shoots down
+		# dupremove processes in an arbitrary order, which leaves the
+		# memory in an inconsistent state long enough for the assert
+		# to trip.
+		cmd="$DUPEREMOVE_PROG -dr --dedupe-options=same $testdir"
+		bash -c "$cmd" >> $seqres.full 2>&1
 	done 2>&1 | sed -e '/Terminated/d' &
 	dedup_pids="$! $dedup_pids"
 done

