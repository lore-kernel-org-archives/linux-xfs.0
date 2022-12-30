Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52C54C3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:48:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235935AbiLaAsG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:48:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235851AbiLaAsF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:48:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035341C90A;
        Fri, 30 Dec 2022 16:48:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3D4FB81DE6;
        Sat, 31 Dec 2022 00:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74415C433D2;
        Sat, 31 Dec 2022 00:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447681;
        bh=1wtoFtDm/6CQJOn2zVo4LsS5ocZt8ThnrjDTHAKBiR8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cm2stuGqhFtK8yvjD1ujabqfwf5cJT3mfvUmRNrvRehyH0SBgSov0Ki+G7yuQkHZ6
         jdYgSXr3j1hy3k5dk6o3tBQAdaHQrg400Shp4HjXKkE2O4N4g/9Rk2rw1wpGqcStpI
         jr8bTMV7BJVXilyfzAXSMU3vPBGnbVvUqXCFhNKkNaW3f4Rini/yZxPG8RjZL3xca0
         ysokw4l3m/U/KwhR1rj2C9gBezBP5pD823z2KjmVk55UEnqX6wqDnWpiW1Rhj77L9Y
         n1dgYEVBrw6iqS7UqeXpCIzTEhl1+kkL2gev/BRlY493LURMbORZfQp8F3t7YnGuc1
         JB3nCFDlo49Gg==
Subject: [PATCH 15/24] common/fuzzy: fix some problems with the post-repair fs
 modification code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:41 -0800
Message-ID: <167243878102.730387.2695454576885664463.stgit@magnolia>
In-Reply-To: <167243877899.730387.9276624623424433346.stgit@magnolia>
References: <167243877899.730387.9276624623424433346.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While auditing the fuzz tester code, I noticed there were numerous
problems with the code that test-drives the filesystem after we've run
the repair strategy.  Now that we've made sure that the repair strategy
checks its own efficacy, we can rearrange this function to try making
mods and then re-check the filesystem afterwards.  Also, disable
xfs_repair prefetch to reduce the likelihood of OOM kills.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |   56 +++++++++++++++++++++++++++++++-------------------------
 1 file changed, 31 insertions(+), 25 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index a33c230b40..e9a5d67592 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -380,37 +380,43 @@ _scratch_xfs_fuzz_field_modifyfs() {
 	local fuzz_action="$1"
 	local repair="$2"
 
-	# Try to mount the filesystem
-	echo "+ Make sure error is gone (online)"
+	# Try to mount the filesystem so that we can make changes
+	__fuzz_notify "+ Mount filesystem to make changes"
 	_try_scratch_mount 2>&1
 	res=$?
-	if [ $res -eq 0 ]; then
-		# Make sure online scrub says the filesystem is clean now
-		if [ "${repair}" != "none" ]; then
-			echo "++ Online scrub"
-			_scratch_scrub -n -e continue 2>&1
-				res=$?
-				test $res -ne 0 && \
-					(>&2 echo "online re-scrub ($res) with ${field} = ${fuzzverb}.")
-			fi
-		fi
+	if [ $res -ne 0 ]; then
+		(>&2 echo "${fuzz_action}: pre-mod mount failed ($res).")
+		return $res
+	fi
 
-		# Try modifying the filesystem again
-		__fuzz_notify "++ Try to write filesystem again"
-		_scratch_fuzz_modify 100 2>&1
+	# Try modifying the filesystem again
+	__fuzz_notify "++ Try to write filesystem again"
+	_scratch_fuzz_modify 100 2>&1
+
+	# If we didn't repair anything, there's no point in checking further,
+	# the fs is still corrupt.
+	if [ "${repair}" = "none" ]; then
 		__scratch_xfs_fuzz_unmount
-	else
-		(>&2 echo "re-mount failed ($res) with ${fuzz_action}.")
+		return 0
 	fi
 
-	# See if repair finds a clean fs
-	if [ "${repair}" != "none" ]; then
-		echo "+ Re-check the filesystem (offline)"
-		_scratch_xfs_repair -n 2>&1
-		res=$?
-		test $res -ne 0 && \
-			(>&2 echo "re-repair failed ($res) with ${field} = ${fuzzverb}.")
-	fi
+	# Run an online check to make sure the fs is still ok, unless we
+	# are running the norepair strategy.
+	__fuzz_notify "+ Re-check the filesystem (online)"
+	_scratch_scrub -n -e continue 2>&1
+	res=$?
+	test $res -ne 0 && \
+		(>&2 echo "${fuzz_action}: online post-mod scrub failed ($res).")
+
+	__scratch_xfs_fuzz_unmount
+
+	# Run an offline check to make sure the fs is still ok, unless we
+	# are running the norepair strategy.
+	__fuzz_notify "+ Re-check the filesystem (offline)"
+	_scratch_xfs_repair -P -n 2>&1
+	res=$?
+	test $res -ne 0 && \
+		(>&2 echo "${fuzz_action}: offline post-mod scrub failed ($res).")
 
 	return 0
 }

