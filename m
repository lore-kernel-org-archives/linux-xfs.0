Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 205EDC3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:14:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236338AbiLaDOI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:14:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236216AbiLaDNi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:13:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45CBE1104;
        Fri, 30 Dec 2022 19:13:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D964661C7A;
        Sat, 31 Dec 2022 03:13:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F287C433EF;
        Sat, 31 Dec 2022 03:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456417;
        bh=jfYLF3Re+dwp7FUKkBZwhLg+BKZUEYdY4iW3sqaOWOs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Mpp3t8kR+IdAfVZGCYBhYITZ2gClbzTklAVf/o+qae2Y+b8mN6ufx5w9O+TwNQvHK
         i3atS5vCM45zV0fD2DwyD9pGHOWCqM7+mYrakB9poYSLZ8p7vIe++yuUo1UMGOxci0
         VsNC5VepY9EzeMhbOivWWDPweZEyfTryt6F/F7kyq/FQb1STqm1RAEzxChJOmqguHw
         hlXOkgt3/P6Le4o+8s2QyjOaSlbmOJIL9QVIS1QVfLo6Y6dTz+hzRYzK/KFbMj3Lps
         3ADUgy5404Kt0LeDRvYlacH657dB1gMMBy6FqtoPUEi3ISRUdujZPbp1WBlFqGY4Eg
         HJIXDF7ns98yw==
Subject: [PATCH 04/13] xfs/769: add rtrmapbt upgrade to test matrix
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:44 -0800
Message-ID: <167243884448.739669.13756867615096925280.stgit@magnolia>
In-Reply-To: <167243884390.739669.13524725872131241203.stgit@magnolia>
References: <167243884390.739669.13524725872131241203.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add realtime reverse mapping btrees to the features that this test will
try to upgrade.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/769 |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/769 b/tests/xfs/769
index 624dd2a338..ccc3ea10bc 100755
--- a/tests/xfs/769
+++ b/tests/xfs/769
@@ -35,11 +35,36 @@ rt_configured()
 	test "$USE_EXTERNAL" = "yes" && test -n "$SCRATCH_RTDEV"
 }
 
+need_rtgroups()
+{
+	local feat="$1"
+
+	# if realtime isn't configured, we don't need rt groups
+	rt_configured || return 1
+
+	# rt rmap btrees require rt groups but rt groups cannot be added to
+	# an existing filesystem, so we must force it on at mkfs time
+	test "${FEATURE_STATE["rmapbt"]}" -eq 1 && return 0
+	test "$feat" = "rmapbt" && return 0
+
+	return 1
+}
+
 # Compute the MKFS_OPTIONS string for a particular feature upgrade test
 compute_mkfs_options()
 {
+	local feat="$1"
 	local m_opts=""
 	local caller_options="$MKFS_OPTIONS"
+	local rtgroups
+
+	need_rtgroups "$feat" && rtgroups=1
+	if echo "$caller_options" | grep -q 'rtgroups='; then
+		test -z "$rtgroups" && rtgroups=0
+		caller_options="$(echo "$caller_options" | sed -e 's/rtgroups=*[0-9]*/rtgroups='$rtgroups'/g')"
+	elif [ -n "$rtgroups" ]; then
+		caller_options="$caller_options -r rtgroups=$rtgroups"
+	fi
 
 	for feat in "${FEATURES[@]}"; do
 		local feat_state="${FEATURE_STATE["${feat}"]}"
@@ -171,10 +196,12 @@ function post_exercise()
 # upgrade don't spread failure to the rest of the tests.
 FEATURES=()
 if rt_configured; then
+	# rmap wasn't added to rt devices until after metadir
 	check_repair_upgrade finobt && FEATURES+=("finobt")
 	check_repair_upgrade inobtcount && FEATURES+=("inobtcount")
 	check_repair_upgrade bigtime && FEATURES+=("bigtime")
 	check_repair_upgrade metadir && FEATURES+=("metadir")
+	check_repair_upgrade rmapbt && FEATURES+=("rmapbt")
 else
 	check_repair_upgrade finobt && FEATURES+=("finobt")
 	check_repair_upgrade rmapbt && FEATURES+=("rmapbt")
@@ -197,7 +224,7 @@ for feat in "${FEATURES[@]}"; do
 
 	upgrade_start_message "$feat" | tee -a $seqres.full /dev/ttyprintk > /dev/null
 
-	opts="$(compute_mkfs_options)"
+	opts="$(compute_mkfs_options "$feat")"
 	echo "mkfs.xfs $opts" >> $seqres.full
 
 	# Format filesystem

