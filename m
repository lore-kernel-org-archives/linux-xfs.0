Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2E8FC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235933AbiLaAqP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:46:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235927AbiLaAqO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:46:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7447C55BF;
        Fri, 30 Dec 2022 16:46:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EEE161D63;
        Sat, 31 Dec 2022 00:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51072C433D2;
        Sat, 31 Dec 2022 00:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447572;
        bh=dEhlWmbmnxjiW8QH6B/a9Yb8GMBvcJ3lCezcSuOQFHo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XK4TsgYhFYJIsAayQkr0E+UqmZzGKpA6GOVcU3t2uc/8ylJdQBKdaPlNKuSV7TK5B
         RHSLXHZfll0c/XjqVNelPKks1PYd7Gtg2G8Ue8Ip4yfgpdIMJRjE6HvVrl4Gc7KQJJ
         GBeuh4C1DaCJey3yVgqydNJ5xkKVlTQgi93vVRO8QLOJiBXhqLCb78sC3zKqbXfeZM
         4OwbB1O9aWdTCLred8+UqU7TPfqrxQ3/v4WB8oCBGlpssaoo8swxqxXIfXZlcrchLw
         w1n7Vlh7qgjZrjNaPl8FNo14U32vvhnr2B/UhsL4zkI4iccTRIX4GYE70GD/7KYUyP
         qFPviDlfwDyxA==
Subject: [PATCH 08/24] common/fuzzy: split out each repair strategy into a
 separate helper
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:40 -0800
Message-ID: <167243878009.730387.6498387808305301701.stgit@magnolia>
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

Refactor __scratch_xfs_fuzz_field_test to split out each repair strategy
into a separate helper function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |  212 +++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 166 insertions(+), 46 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index 866901931e..ef42336fa6 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -194,6 +194,148 @@ __fuzz_notify() {
 	test -w /dev/ttyprintk && echo "$@" >> /dev/ttyprintk
 }
 
+# Perform the online repair part of a fuzz test.
+__scratch_xfs_fuzz_field_online() {
+	local fuzz_action="$1"
+
+	# Mount or else we can't do anything online
+	echo "+ Mount filesystem to try online repair"
+	_try_scratch_mount 2>&1
+	res=$?
+	if [ $res -ne 0 ]; then
+		(>&2 echo "mount failed ($res) with ${fuzz_action}.")
+		return 0
+	fi
+
+	# Make sure online scrub will catch whatever we fuzzed
+	echo "++ Online scrub"
+	_scratch_scrub -n -a 1 -e continue 2>&1
+	res=$?
+	test $res -eq 0 && \
+		(>&2 echo "scrub didn't fail with ${fuzz_action}.")
+
+	# Try fixing the filesystem online
+	__fuzz_notify "++ Try to repair filesystem online"
+	_scratch_scrub 2>&1
+	res=$?
+	test $res -ne 0 && \
+		(>&2 echo "online repair failed ($res) with ${fuzz_action}.")
+
+	__scratch_xfs_fuzz_unmount
+
+	# Offline scrub should pass now
+	echo "+ Make sure error is gone (offline)"
+	_scratch_xfs_repair -n 2>&1
+	res=$?
+	test $res -ne 0 && \
+		(>&2 echo "offline re-scrub failed ($res) with ${fuzz_action}.")
+
+	return 0
+}
+
+# Perform the offline repair part of a fuzz test.
+__scratch_xfs_fuzz_field_offline() {
+	local fuzz_action="$1"
+
+	# Mount or else we can't do anything offline
+	echo "+ Mount filesystem to try offline repair"
+	_try_scratch_mount 2>&1
+	res=$?
+	if [ $res -ne 0 ]; then
+		(>&2 echo "mount failed ($res) with ${fuzz_action}.")
+		return 0
+	fi
+
+	# Make sure online scrub will catch whatever we fuzzed
+	echo "++ Online scrub"
+	_scratch_scrub -n -a 1 -e continue 2>&1
+	res=$?
+	test $res -eq 0 && \
+		(>&2 echo "scrub didn't fail with ${fuzz_action}.")
+
+	__scratch_xfs_fuzz_unmount
+
+	# Repair the filesystem offline
+	echo "+ Try to repair the filesystem offline"
+	_repair_scratch_fs 2>&1
+	res=$?
+	test $res -ne 0 && \
+		(>&2 echo "offline repair failed ($res) with ${fuzz_action}.")
+
+	# See if repair finds a clean fs
+	echo "+ Make sure error is gone (offline)"
+	_scratch_xfs_repair -n 2>&1
+	res=$?
+	test $res -ne 0 && \
+		(>&2 echo "offline re-scrub failed ($res) with ${fuzz_action}.")
+
+	return 0
+}
+
+# Perform the no-repair part of a fuzz test.
+__scratch_xfs_fuzz_field_norepair() {
+	local fuzz_action="$1"
+
+	# Mount or else we can't do anything in norepair mode
+	echo "+ Mount filesystem to try no repair"
+	_try_scratch_mount 2>&1
+	res=$?
+	if [ $res -ne 0 ]; then
+		(>&2 echo "mount failed ($res) with ${fuzz_action}.")
+		return 0
+	fi
+
+	__scratch_xfs_fuzz_unmount
+
+	return 0
+}
+
+# Perform the online-then-offline repair part of a fuzz test.
+__scratch_xfs_fuzz_field_both() {
+	local fuzz_action="$1"
+
+	# Mount or else we can't do anything in both repair mode
+	echo "+ Mount filesystem to try both repairs"
+	_try_scratch_mount 2>&1
+	res=$?
+	if [ $res -ne 0 ]; then
+		(>&2 echo "mount failed ($res) with ${fuzz_action}.")
+		return 0
+	fi
+
+	# Make sure online scrub will catch whatever we fuzzed
+	echo "++ Online scrub"
+	_scratch_scrub -n -a 1 -e continue 2>&1
+	res=$?
+	test $res -eq 0 && \
+		(>&2 echo "online scrub didn't fail with ${fuzz_action}.")
+
+	# Try fixing the filesystem online
+	__fuzz_notify "++ Try to repair filesystem online"
+	_scratch_scrub 2>&1
+	res=$?
+	test $res -ne 0 && \
+		(>&2 echo "online repair failed ($res) with ${fuzz_action}.")
+
+	__scratch_xfs_fuzz_unmount
+
+	# Repair the filesystem offline?
+	echo "+ Try to repair the filesystem offline"
+	_repair_scratch_fs 2>&1
+	res=$?
+	test $res -ne 0 && \
+		(>&2 echo "offline repair failed ($res) with ${fuzz_action}.")
+
+	# See if repair finds a clean fs
+	echo "+ Make sure error is gone (offline)"
+	_scratch_xfs_repair -n 2>&1
+	res=$?
+	test $res -ne 0 && \
+		(>&2 echo "offline re-scrub ($res) with ${fuzz_action}.")
+
+	return 0
+}
+
 # Fuzz one field of some piece of metadata.
 # First arg is the field name
 # Second arg is the fuzz verb (ones, zeroes, random, add, sub...)
@@ -211,54 +353,32 @@ __scratch_xfs_fuzz_field_test() {
 	res=$?
 	test $res -ne 0 && return
 
-	# Try to catch the error with scrub
-	echo "+ Try to catch the error"
-	_try_scratch_mount 2>&1
-	res=$?
-	if [ $res -eq 0 ]; then
-		# Try an online scrub unless we're fuzzing ag 0's sb,
-		# which scrub doesn't know how to fix.
-		if [ "${repair}" != "none" ]; then
-			echo "++ Online scrub"
-			if [ "$1" != "sb 0" ]; then
-				_scratch_scrub -n -a 1 -e continue 2>&1
-				res=$?
-				test $res -eq 0 && \
-					(>&2 echo "scrub didn't fail with ${field} = ${fuzzverb}.")
-			fi
-		fi
-
-		# Try fixing the filesystem online?!
-		if [ "${repair}" = "online" ] || [ "${repair}" = "both" ]; then
-			__fuzz_notify "++ Try to repair filesystem online"
-			_scratch_scrub 2>&1
-			res=$?
-			test $res -ne 0 && \
-				(>&2 echo "online repair failed ($res) with ${field} = ${fuzzverb}.")
-		fi
-
-		__scratch_xfs_fuzz_unmount
-	elif [ "${repair}" = "online" ] || [ "${repair}" = "both" ]; then
-		(>&2 echo "mount failed ($res) with ${field} = ${fuzzverb}.")
-	fi
-
-	# Repair the filesystem offline?
-	if [ "${repair}" = "offline" ] || [ "${repair}" = "both" ]; then
-		echo "+ Try to repair the filesystem offline"
-		_repair_scratch_fs 2>&1
+	# Try to catch the error with whatever repair strategy we picked.
+	# The fs should not be mounted before or after the strategy call.
+	local fuzz_action="${field} = ${fuzzverb}"
+	case "${repair}" in
+	"online")
+		__scratch_xfs_fuzz_field_online "${fuzz_action}"
 		res=$?
-		test $res -ne 0 && \
-			(>&2 echo "offline repair failed ($res) with ${field} = ${fuzzverb}.")
-	fi
-
-	# See if repair finds a clean fs
-	if [ "${repair}" != "none" ]; then
-		echo "+ Make sure error is gone (offline)"
-		_scratch_xfs_repair -n 2>&1
+		;;
+	"offline")
+		__scratch_xfs_fuzz_field_offline "${fuzz_action}"
 		res=$?
-		test $res -ne 0 && \
-			(>&2 echo "offline re-scrub ($res) with ${field} = ${fuzzverb}.")
-	fi
+		;;
+	"none")
+		__scratch_xfs_fuzz_field_norepair "${fuzz_action}"
+		res=$?
+		;;
+	"both")
+		__scratch_xfs_fuzz_field_both "${fuzz_action}"
+		res=$?
+		;;
+	*)
+		(>&2 echo "unknown repair strategy ${repair}.")
+		res=2
+		;;
+	esac
+	test $res -eq 0 || return $res
 
 	# See if scrub finds a clean fs
 	echo "+ Make sure error is gone (online)"

