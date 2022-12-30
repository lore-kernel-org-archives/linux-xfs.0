Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5419C3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:47:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235883AbiLaAre (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:47:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235927AbiLaArc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:47:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5D71C90A;
        Fri, 30 Dec 2022 16:47:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C2B861D5F;
        Sat, 31 Dec 2022 00:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 687AAC433D2;
        Sat, 31 Dec 2022 00:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447650;
        bh=INURyWHALQie39VL7Dws4eI73u90p3cSfQVEvYfOorY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rcfESciM8u+V8/F0ussKseUK/oo4O0NyBCIOybRemAN8WKsxYOgz/KK2aAtEfV5Q0
         +ZZjYbrqOJsq9Ql8wh/r4hO+TTYPn8lwNr8rxpdd77+gAjID1sUwVys8sQ3APlPwui
         hjOlG0N8MtaLBBXAR0chtQZXI2LoGOTcoywcBKgDgd7yayeG4ISoof+RysI73LWzDl
         ps9vxUIYtVb+6mGCGigyjtpp4mf4FbxNr3V4ZAROG7age394P0qn1yqKYoBk0mFzCX
         yCT1wULKb4tij54y14wWpnUZH7rkdncZ6OO9oM4t9sqV/+7ahh6SB6qqALvj97T8Cw
         T258LPbnP7sdA==
Subject: [PATCH 13/24] common/fuzzy: fix some problems with the no-repair
 strategy
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:40 -0800
Message-ID: <167243878075.730387.14082368456840772775.stgit@magnolia>
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
problems with the no repair strategy -- the stages of the strategy
are not consistently logged to the kernel log, and we don't actually
verify that either online or offline scrubs notice the fuzz.  Rework the
error messages to make reading the golden output easier.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index 07f597627c..16fca67534 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -274,15 +274,29 @@ __scratch_xfs_fuzz_field_offline() {
 __scratch_xfs_fuzz_field_norepair() {
 	local fuzz_action="$1"
 
+	# Make sure offline scrub will catch whatever we fuzzed
+	__fuzz_notify "+ Detect fuzzed field (offline)"
+	_scratch_xfs_repair -P -n 2>&1
+	res=$?
+	test $res -eq 0 && \
+		(>&2 echo "${fuzz_action}: offline scrub didn't fail.")
+
 	# Mount or else we can't do anything in norepair mode
-	echo "+ Mount filesystem to try no repair"
+	__fuzz_notify "+ Mount filesystem to try online scan"
 	_try_scratch_mount 2>&1
 	res=$?
 	if [ $res -ne 0 ]; then
-		(>&2 echo "mount failed ($res) with ${fuzz_action}.")
-		return 0
+		(>&2 echo "${fuzz_action}: mount failed ($res).")
+		return 1
 	fi
 
+	# Make sure online scrub will catch whatever we fuzzed
+	__fuzz_notify "++ Detect fuzzed field (online)"
+	_scratch_scrub -n -a 1 -e continue 2>&1
+	res=$?
+	test $res -eq 0 && \
+		(>&2 echo "${fuzz_action}: online scrub didn't fail.")
+
 	__scratch_xfs_fuzz_unmount
 
 	return 0

