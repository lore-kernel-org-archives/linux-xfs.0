Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA95C3DA7C
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:57:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbiL3W5G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:57:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235647AbiL3W5E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:57:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A92B1B9E2;
        Fri, 30 Dec 2022 14:57:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B820A61C30;
        Fri, 30 Dec 2022 22:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2036DC433F1;
        Fri, 30 Dec 2022 22:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441023;
        bh=okdMoSbtkbYrBQB1NH2KJpgYM/rd0QyX4yIcR9uhfL4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hQvN9gmE3OqID5QXh+8NVNvPyQfZy0QvQV+RYvrSl6X3ze+b48MDEs4ZsGNVAlaQq
         3wy4dp5dC9qGLMWo/13O4OmzUuVT9CdaOta4hajfK0nEFyLlm8RN5ij/R5rBkX5jsh
         5tDrp6RxLuYcjd6MPe0zimvbR0hj8+SC0XZRFkKMNyXHU0MJAQL/vCLzmgHbY4NkPj
         zcX0R50FdmtiCRdr+iI+Oi1MoUJGLEKutA5HvD0u2iw8ep8oUXLOIQ5/EIQe3qxchD
         Wpv5QWttFOkJgG6rqQn9hydo1TFUxmGQtPP5Ua1HIX17l+P9JPS4u78eMcmqxgD6qy
         f/N4k8Vso/3yg==
Subject: [PATCH 11/16] fuzzy: clear out the scratch filesystem if it's too
 full
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:12:54 -0800
Message-ID: <167243837447.694541.8212586612646646637.stgit@magnolia>
In-Reply-To: <167243837296.694541.13203497631389630964.stgit@magnolia>
References: <167243837296.694541.13203497631389630964.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If the online fsck stress tests run for long enough, they'll fill up the
scratch filesystem completely.  While it is interesting to test repair
functionality on a *nearly* full filesystem undergoing a heavy workload,
a totally full filesystem is really only exercising the ENOSPC handlers
in the kernel.  That's not what we came here to test, so change the
fsstress loop to detect a nearly full filesystem and erase everything
before starting fsstress again.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)


diff --git a/common/fuzzy b/common/fuzzy
index f1bc2dc756..01cf7f00d8 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -380,6 +380,20 @@ __stress_one_scrub_loop() {
 	done
 }
 
+# Clean the scratch filesystem between rounds of fsstress if there is 2%
+# available space or less because that isn't an interesting stress test.
+#
+# Returns 0 if we cleared anything, and 1 if we did nothing.
+__stress_scrub_clean_scratch() {
+	local used_pct="$(_used $SCRATCH_DEV)"
+
+	test "$used_pct" -lt 98 && return 1
+
+	echo "Clearing scratch fs at $(date)" >> $seqres.full
+	rm -r -f $SCRATCH_MNT/p*
+	return 0
+}
+
 # Run fsstress while we're testing online fsck.
 __stress_scrub_fsstress_loop() {
 	local end="$1"
@@ -389,6 +403,8 @@ __stress_scrub_fsstress_loop() {
 	echo "Running $FSSTRESS_PROG $args" >> $seqres.full
 
 	while __stress_scrub_running "$end" "$runningfile"; do
+		# Need to recheck running conditions if we cleared anything
+		__stress_scrub_clean_scratch && continue
 		$FSSTRESS_PROG $args >> $seqres.full
 		echo "fsstress exits with $? at $(date)" >> $seqres.full
 	done

