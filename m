Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24819C3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:47:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235945AbiLaArD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:47:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235927AbiLaArC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:47:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04EF1C90A;
        Fri, 30 Dec 2022 16:47:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D73FB81D68;
        Sat, 31 Dec 2022 00:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F98C433D2;
        Sat, 31 Dec 2022 00:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447619;
        bh=2S9+pgHHA1t+8JkskRd1FzxnP7+67kCrRVzQkDL717Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DCA4urG/SfB7Q/6Tc7q22uosZDGpNq3oyEYEGc9695IyTVkH4nSCG79ADCAQgBYIF
         CrY/QtA8rRVs4Iuj7cbqM4KWgcUTyiXu+gCBKy3v1/2AyDZ5mkGlVyhNir3zJrGLum
         ms6H/fl9iRARkfF64oLcfc9XDU9cDCbzvYmBN9K8zQ/WBGnYtScEsam84cTvDVgNEM
         Yci5BjEr+66igwFF+us0wWvudoPmn98GV4ppOYW2OWnRXu0RqWddB3SddutO4XPqlU
         N0pn+1gC+6YFe60i2IJHmj7DIgn2ICM07NjABIBifYpo/wu1LnyUoXp2gzwmU2lEOs
         6AiBeTADEHghw==
Subject: [PATCH 11/24] common/fuzzy: fix some problems with the online repair
 strategy
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:40 -0800
Message-ID: <167243878049.730387.5152774047260379132.stgit@magnolia>
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
problems with the online repair strategy -- the stages of the strategy
are not consistently logged to the kernel log, some of the error
messages don't identify /which/ scrubber we're calling, and we don't
actually re-run online scrub after a repair to make sure that it's
verification is ok.  Disable xfs_repair prefetch to reduce the chances
of an OOM kill, and abort the fuzz test if we can't mount.  We also
reorganize the error messages to make reading the golden output easier.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index e90f414d34..8b52d289d1 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -201,36 +201,43 @@ __scratch_xfs_fuzz_field_online() {
 	local fuzz_action="$1"
 
 	# Mount or else we can't do anything online
-	echo "+ Mount filesystem to try online repair"
+	__fuzz_notify "+ Mount filesystem to try online repair"
 	_try_scratch_mount 2>&1
 	res=$?
 	if [ $res -ne 0 ]; then
-		(>&2 echo "mount failed ($res) with ${fuzz_action}.")
-		return 0
+		(>&2 echo "${fuzz_action}: mount failed ($res).")
+		return 1
 	fi
 
 	# Make sure online scrub will catch whatever we fuzzed
-	echo "++ Online scrub"
+	__fuzz_notify "++ Detect fuzzed field (online)"
 	_scratch_scrub -n -a 1 -e continue 2>&1
 	res=$?
 	test $res -eq 0 && \
-		(>&2 echo "scrub didn't fail with ${fuzz_action}.")
+		(>&2 echo "${fuzz_action}: online scrub didn't fail.")
 
 	# Try fixing the filesystem online
-	__fuzz_notify "++ Try to repair filesystem online"
+	__fuzz_notify "++ Try to repair filesystem (online)"
 	_scratch_scrub 2>&1
 	res=$?
 	test $res -ne 0 && \
-		(>&2 echo "online repair failed ($res) with ${fuzz_action}.")
+		(>&2 echo "${fuzz_action}: online repair failed ($res).")
+
+	# Online scrub should pass now
+	__fuzz_notify "++ Make sure error is gone (online)"
+	_scratch_scrub -n -a 1 -e continue 2>&1
+	res=$?
+	test $res -ne 0 && \
+		(>&2 echo "${fuzz_action}: online re-scrub failed ($res).")
 
 	__scratch_xfs_fuzz_unmount
 
 	# Offline scrub should pass now
-	echo "+ Make sure error is gone (offline)"
-	_scratch_xfs_repair -n 2>&1
+	__fuzz_notify "+ Make sure error is gone (offline)"
+	_scratch_xfs_repair -P -n 2>&1
 	res=$?
 	test $res -ne 0 && \
-		(>&2 echo "offline re-scrub failed ($res) with ${fuzz_action}.")
+		(>&2 echo "${fuzz_action}: offline re-scrub failed ($res).")
 
 	return 0
 }

