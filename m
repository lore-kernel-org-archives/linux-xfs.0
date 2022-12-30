Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E17CEC3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235949AbiLaArs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:47:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235927AbiLaArr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:47:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA59B1C90A;
        Fri, 30 Dec 2022 16:47:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 882FE61D5F;
        Sat, 31 Dec 2022 00:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9023C433D2;
        Sat, 31 Dec 2022 00:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447666;
        bh=dBIFgGCfTw8/pgQf0NYYFCMIwKpmMJBXQ28G0Aqh2lY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TpdI7vNuEAwhAv7UQQegtfw/T9lQxMBX+VM200Hv7u+PA1MijmmSit4UungSZlqQW
         6aeVLqEb7oSVTOFz986/nTsE44iRE1q0zUi51V/4V2udLYc6nzdxJBxo4JfYh3ys4Z
         8VS5bTqmzkFoFWwbL7h+ftUFCIJfVRp4idfncA8LdtJCzCusWL/mvC/7Vr7M3vdGjZ
         R0QBAkLnrzE68hMc32sH4TW7tVf0NUrnRwKuZHVaqddrPISau+mDA7pr/umDsQVaPM
         gQ92QkRnSIazEzccE7iYFJotHPunVb6X12L9EPa7HV+/ri9jMDx8Y2k8lwjBfMuKbc
         Nn8qJwvEBEk3w==
Subject: [PATCH 14/24] common/fuzzy: fix some problems with the
 online-then-offline repair strategy
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:40 -0800
Message-ID: <167243878089.730387.3339474427317162674.stgit@magnolia>
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
problems with the online-then-offline repair strategy -- the stages of
the strategy are not consistently logged to the kernel log, some of the
error messages don't identify /which/ scrubber we're calling, we don't
do a pre-repair check to make sure we detect the fuzzed fields, and we
don't actually re-run online scrub after a repair to make sure that it's
ok.  Disable xfs_repair prefetch to reduce the possibility of OOM kills.
Rework the error messages to make reading the golden output easier.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |   80 ++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 53 insertions(+), 27 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index 16fca67534..a33c230b40 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -306,45 +306,71 @@ __scratch_xfs_fuzz_field_norepair() {
 __scratch_xfs_fuzz_field_both() {
 	local fuzz_action="$1"
 
+	# Make sure offline scrub will catch whatever we fuzzed
+	__fuzz_notify "+ Detect fuzzed field (offline)"
+	_scratch_xfs_repair -P -n 2>&1
+	res=$?
+	test $res -eq 0 && \
+		(>&2 echo "${fuzz_action}: offline scrub didn't fail.")
+
 	# Mount or else we can't do anything in both repair mode
-	echo "+ Mount filesystem to try both repairs"
+	__fuzz_notify "+ Mount filesystem to try both repairs"
 	_try_scratch_mount 2>&1
 	res=$?
 	if [ $res -ne 0 ]; then
-		(>&2 echo "mount failed ($res) with ${fuzz_action}.")
-		return 0
+		(>&2 echo "${fuzz_action}: mount failed ($res).")
+	else
+		# Make sure online scrub will catch whatever we fuzzed
+		__fuzz_notify "++ Detect fuzzed field (online)"
+		_scratch_scrub -n -a 1 -e continue 2>&1
+		res=$?
+		test $res -eq 0 && \
+			(>&2 echo "${fuzz_action}: online scrub didn't fail.")
+
+		# Try fixing the filesystem online
+		__fuzz_notify "++ Try to repair filesystem (online)"
+		_scratch_scrub 2>&1
+		res=$?
+		test $res -ne 0 && \
+			(>&2 echo "${fuzz_action}: online repair failed ($res).")
+
+		__scratch_xfs_fuzz_unmount
+	fi
+
+	# Repair the filesystem offline if online repair failed?
+	if [ $res -ne 0 ]; then
+		__fuzz_notify "+ Try to repair the filesystem (offline)"
+		_repair_scratch_fs -P 2>&1
+		res=$?
+		test $res -ne 0 && \
+			(>&2 echo "${fuzz_action}: offline repair failed ($res).")
+	fi
+
+	# See if repair finds a clean fs
+	__fuzz_notify "+ Make sure error is gone (offline)"
+	_scratch_xfs_repair -P -n 2>&1
+	res=$?
+	test $res -ne 0 && \
+		(>&2 echo "${fuzz_action}: offline re-scrub failed ($res).")
+
+	# Mount so that we can see what scrub says after we've fixed the fs
+	__fuzz_notify "+ Re-mount filesystem to re-try online scan"
+	_try_scratch_mount 2>&1
+	res=$?
+	if [ $res -ne 0 ]; then
+		(>&2 echo "${fuzz_action}: mount failed ($res).")
+		return 1
 	fi
 
-	# Make sure online scrub will catch whatever we fuzzed
-	echo "++ Online scrub"
+	# Online scrub should pass now
+	__fuzz_notify "++ Make sure error is gone (online)"
 	_scratch_scrub -n -a 1 -e continue 2>&1
 	res=$?
-	test $res -eq 0 && \
-		(>&2 echo "online scrub didn't fail with ${fuzz_action}.")
-
-	# Try fixing the filesystem online
-	__fuzz_notify "++ Try to repair filesystem online"
-	_scratch_scrub 2>&1
-	res=$?
 	test $res -ne 0 && \
-		(>&2 echo "online repair failed ($res) with ${fuzz_action}.")
+		(>&2 echo "${fuzz_action}: online re-scrub failed ($res).")
 
 	__scratch_xfs_fuzz_unmount
 
-	# Repair the filesystem offline?
-	echo "+ Try to repair the filesystem offline"
-	_repair_scratch_fs 2>&1
-	res=$?
-	test $res -ne 0 && \
-		(>&2 echo "offline repair failed ($res) with ${fuzz_action}.")
-
-	# See if repair finds a clean fs
-	echo "+ Make sure error is gone (offline)"
-	_scratch_xfs_repair -n 2>&1
-	res=$?
-	test $res -ne 0 && \
-		(>&2 echo "offline re-scrub ($res) with ${fuzz_action}.")
-
 	return 0
 }
 

