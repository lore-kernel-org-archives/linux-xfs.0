Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E560C3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235948AbiLaArT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:47:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235927AbiLaArS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:47:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741BC1C921;
        Fri, 30 Dec 2022 16:47:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F8D2B81E6C;
        Sat, 31 Dec 2022 00:47:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D386EC433D2;
        Sat, 31 Dec 2022 00:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447634;
        bh=yIDSzMfEjuPZlNoi3JLGEwuIFaCmde6EJxyncZPGInY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oWmGvF79ho8k/DoqjE4tGL0J3nm0aO6lp/xdNu1pRN+DFjnOvR0heydXw/zMW/asU
         tXo5n1+QObvEBoJY80l/bcUqlKIIQiEyCceRsnIbaWDgmgTSmmdYtxwYk67VgV2x2s
         rHcOmInaGQ/RSus5m7eXCxZbL0bRQ2ZV3ybGDtaSfBEFRwTFmUnyTAhM8+epbfca79
         10CtnRQsqYgYuDEnMQvBSUoLnKl/NbeeZqPrAwbvHW6xOdYrsTzDP+6vNta0oWQ8gb
         U01R+jC9ocHjJTdnLwr13QZZoOZttVU8PQ57XcR1OBPboIb0uA+KvZ2iiAklrRIsZK
         cWxljEXPs/XHQ==
Subject: [PATCH 12/24] common/fuzzy: fix some problems with the offline repair
 strategy
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:40 -0800
Message-ID: <167243878062.730387.10548023765273866268.stgit@magnolia>
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
problems with the offline repair strategy -- the stages of the strategy
are not consistently logged to the kernel log, we don't actually check
that repair -n finds the fuzzed field, and since this is an offline
test, we don't need or want to mount or try to run the online scrubber.
Also, disable prefetch to reduce the chance of an OOM kill.  Rework the
error messages to make reading the golden output easier.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |   31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index 8b52d289d1..07f597627c 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -246,37 +246,26 @@ __scratch_xfs_fuzz_field_online() {
 __scratch_xfs_fuzz_field_offline() {
 	local fuzz_action="$1"
 
-	# Mount or else we can't do anything offline
-	echo "+ Mount filesystem to try offline repair"
-	_try_scratch_mount 2>&1
-	res=$?
-	if [ $res -ne 0 ]; then
-		(>&2 echo "mount failed ($res) with ${fuzz_action}.")
-		return 0
-	fi
-
-	# Make sure online scrub will catch whatever we fuzzed
-	echo "++ Online scrub"
-	_scratch_scrub -n -a 1 -e continue 2>&1
+	# Make sure offline scrub will catch whatever we fuzzed
+	__fuzz_notify "+ Detect fuzzed field (offline)"
+	_scratch_xfs_repair -P -n 2>&1
 	res=$?
 	test $res -eq 0 && \
-		(>&2 echo "scrub didn't fail with ${fuzz_action}.")
-
-	__scratch_xfs_fuzz_unmount
+		(>&2 echo "${fuzz_action}: offline scrub didn't fail.")
 
 	# Repair the filesystem offline
-	echo "+ Try to repair the filesystem offline"
-	_repair_scratch_fs 2>&1
+	__fuzz_notify "+ Try to repair the filesystem (offline)"
+	_repair_scratch_fs -P 2>&1
 	res=$?
 	test $res -ne 0 && \
-		(>&2 echo "offline repair failed ($res) with ${fuzz_action}.")
+		(>&2 echo "${fuzz_action}: offline repair failed ($res).")
 
 	# See if repair finds a clean fs
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

