Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF5D7C07E9C
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 00:21:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAC9161CAD
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 00:21:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhGGAYO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jul 2021 20:24:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229919AbhGGAYO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Jul 2021 20:24:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C550C61C91;
        Wed,  7 Jul 2021 00:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625617294;
        bh=nr9OVZYxHAbfh9voBUxv1+S94pQ3NcNKVzG/jNmUiyk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=A0tXrkzWbDeAOJU25EClO3bfq0yjdZUuuNh8LNWUqggY2vff+OJWC6TFseqwCDtr7
         +61+06TqTCR/5/yVGKiqJgRb0tdsb8crexO1wFB4FjfrHuETG1BCF77c9xdmqibmTS
         qvSdkr288v/YIe16q+5NipCDRDXzBW1LOxxDTWh0ZoOabobdzQQjOVOZhFMK3dY5BS
         zGiAV3nmqlYT2SQQ7julFp1tmGNXd/iBCjmKhlsMn5wdirpjAQEkASYEvY1s7edn5c
         GFIk1Q/3u91ITN02EvPdK/5sWOVBoKTVNn4TISITVXkG//HctmYkauYXa6N3fj59UE
         GTzV9tNPxwI+A==
Subject: [PATCH 5/8] check: run _check_filesystems in an OOM-happy subshell
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 06 Jul 2021 17:21:34 -0700
Message-ID: <162561729448.543423.13588309966120368094.stgit@locust>
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

While running fstests one night, I observed that fstests stopped
abruptly because ./check ran _check_filesystems to run xfs_repair.  In
turn, repair (which inherited oom_score_adj=-1000 from ./check) consumed
so much memory that the OOM killer ran around killing other daemons,
rendering the system nonfunctional.

This is silly -- we set an OOM score adjustment of -1000 on the ./check
process so that the test framework itself wouldn't get OOM-killed,
because that aborts the entire run.  Everything else is fair game for
that, including subprocesses started by _check_filesystems.

Therefore, adapt _check_filesystems (and its children) to run in a
subshell with a much higher oom score adjustment.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 check |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)


diff --git a/check b/check
index de8104d0..bb7e030c 100755
--- a/check
+++ b/check
@@ -525,17 +525,20 @@ _summary()
 
 _check_filesystems()
 {
+	local ret=0
+
 	if [ -f ${RESULT_DIR}/require_test ]; then
-		_check_test_fs || err=true
+		_check_test_fs || ret=1
 		rm -f ${RESULT_DIR}/require_test*
 	else
 		_test_unmount 2> /dev/null
 	fi
 	if [ -f ${RESULT_DIR}/require_scratch ]; then
-		_check_scratch_fs || err=true
+		_check_scratch_fs || ret=1
 		rm -f ${RESULT_DIR}/require_scratch*
 	fi
 	_scratch_unmount 2> /dev/null
+	return $ret
 }
 
 _expunge_test()
@@ -558,11 +561,15 @@ test $? -eq 77 && HAVE_SYSTEMD_SCOPES=yes
 
 # Make the check script unattractive to the OOM killer...
 OOM_SCORE_ADJ="/proc/self/oom_score_adj"
-test -w ${OOM_SCORE_ADJ} && echo -1000 > ${OOM_SCORE_ADJ}
+function _adjust_oom_score() {
+	test -w "${OOM_SCORE_ADJ}" && echo "$1" > "${OOM_SCORE_ADJ}"
+}
+_adjust_oom_score -1000
 
 # ...and make the tests themselves somewhat more attractive to it, so that if
 # the system runs out of memory it'll be the test that gets killed and not the
-# test framework.
+# test framework.  The test is run in a separate process without any of our
+# functions, so we open-code adjusting the OOM score.
 #
 # If systemd is available, run the entire test script in a scope so that we can
 # kill all subprocesses of the test if it fails to clean up after itself.  This
@@ -875,9 +882,12 @@ function run_section()
 			rm -f ${RESULT_DIR}/require_scratch*
 			err=true
 		else
-			# the test apparently passed, so check for corruption
-			# and log messages that shouldn't be there.
-			_check_filesystems
+			# The test apparently passed, so check for corruption
+			# and log messages that shouldn't be there.  Run the
+			# checking tools from a subshell with adjusted OOM
+			# score so that the OOM killer will target them instead
+			# of the check script itself.
+			(_adjust_oom_score 250; _check_filesystems) || err=true
 			_check_dmesg || err=true
 		fi
 

