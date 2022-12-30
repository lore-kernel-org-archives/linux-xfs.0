Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF983C3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:46:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235943AbiLaAqq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:46:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235927AbiLaAqp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:46:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941451117D;
        Fri, 30 Dec 2022 16:46:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3026661D61;
        Sat, 31 Dec 2022 00:46:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91776C433D2;
        Sat, 31 Dec 2022 00:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447603;
        bh=6WFWw1kRbCys3xc/fWAkBwSJNwV2wh9829aSxPbQYms=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=vN3IIleau7fv0Fwzh/NKbKVvChAz4mQRs9hdslLxfhsYm4C6YKZGkwkNGFhL1BY0M
         z+grZ71Olou/uo6xdyPhMlqAU5Nwv/O5jRr9GcJuZyzE9onASyDqOr5EpywcYfdarf
         Y6+ckx+y7/Z5g+b4d6BbEkUPQIrnP8nS0Q72uPJ44HAScRwRpHGWCD0X+Z85unBNEH
         eN0wZtqgP8EgkIzYS42j0nIRR/xVL9IMHyOXOvW3H4JGiewEzYgQ1ML6ONhQ/8Ho+x
         Ywd7Pk+om+UxbL2sRmG06ypJs/i0h/dg9J7KkDFJaIV4/8McZb5fIxBcA9PSscojBY
         8IuKjqOB3Rp8Q==
Subject: [PATCH 10/24] common/fuzzy: hoist the post-repair fs modification
 step
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:40 -0800
Message-ID: <167243878035.730387.5749474229580708524.stgit@magnolia>
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

Hoist the code that tries to modify an fs after repairing our fuzz
damage into a separate function, so that we can further simplify the
caller.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |   77 +++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 44 insertions(+), 33 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index 7efa5eeaf7..e90f414d34 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -338,6 +338,47 @@ __scratch_xfs_fuzz_field_both() {
 	return 0
 }
 
+# Assess the state of the filesystem after a repair strategy has been run by
+# trying to make changes to it.
+_scratch_xfs_fuzz_field_modifyfs() {
+	local fuzz_action="$1"
+	local repair="$2"
+
+	# Try to mount the filesystem
+	echo "+ Make sure error is gone (online)"
+	_try_scratch_mount 2>&1
+	res=$?
+	if [ $res -eq 0 ]; then
+		# Make sure online scrub says the filesystem is clean now
+		if [ "${repair}" != "none" ]; then
+			echo "++ Online scrub"
+			_scratch_scrub -n -e continue 2>&1
+				res=$?
+				test $res -ne 0 && \
+					(>&2 echo "online re-scrub ($res) with ${field} = ${fuzzverb}.")
+			fi
+		fi
+
+		# Try modifying the filesystem again
+		__fuzz_notify "++ Try to write filesystem again"
+		_scratch_fuzz_modify 100 2>&1
+		__scratch_xfs_fuzz_unmount
+	else
+		(>&2 echo "re-mount failed ($res) with ${fuzz_action}.")
+	fi
+
+	# See if repair finds a clean fs
+	if [ "${repair}" != "none" ]; then
+		echo "+ Re-check the filesystem (offline)"
+		_scratch_xfs_repair -n 2>&1
+		res=$?
+		test $res -ne 0 && \
+			(>&2 echo "re-repair failed ($res) with ${field} = ${fuzzverb}.")
+	fi
+
+	return 0
+}
+
 # Fuzz one field of some piece of metadata.
 # First arg is the field name
 # Second arg is the fuzz verb (ones, zeroes, random, add, sub...)
@@ -381,39 +422,9 @@ __scratch_xfs_fuzz_field_test() {
 	esac
 	test $res -eq 0 || return $res
 
-	# See if scrub finds a clean fs
-	echo "+ Make sure error is gone (online)"
-	_try_scratch_mount 2>&1
-	res=$?
-	if [ $res -eq 0 ]; then
-		# Try an online scrub unless we're fuzzing ag 0's sb,
-		# which scrub doesn't know how to fix.
-		if [ "${repair}" != "none" ]; then
-			echo "++ Online scrub"
-			if [ "$1" != "sb 0" ]; then
-				_scratch_scrub -n -e continue 2>&1
-				res=$?
-				test $res -ne 0 && \
-					(>&2 echo "online re-scrub ($res) with ${field} = ${fuzzverb}.")
-			fi
-		fi
-
-		# Try modifying the filesystem again!
-		__fuzz_notify "++ Try to write filesystem again"
-		_scratch_fuzz_modify 100 2>&1
-		__scratch_xfs_fuzz_unmount
-	else
-		(>&2 echo "re-mount failed ($res) with ${field} = ${fuzzverb}.")
-	fi
-
-	# See if repair finds a clean fs
-	if [ "${repair}" != "none" ]; then
-		echo "+ Re-check the filesystem (offline)"
-		_scratch_xfs_repair -n 2>&1
-		res=$?
-		test $res -ne 0 && \
-			(>&2 echo "re-repair failed ($res) with ${field} = ${fuzzverb}.")
-	fi
+	# See what happens when we modify the fs
+	_scratch_xfs_fuzz_field_modifyfs "${fuzz_action}" "${repair}"
+	return $?
 }
 
 # Make sure we have all the pieces we need for field fuzzing

