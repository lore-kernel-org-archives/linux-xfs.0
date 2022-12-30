Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B847DC3DA7C
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:55:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235541AbiL3Wzc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:55:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235490AbiL3Wzb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:55:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542151AA29;
        Fri, 30 Dec 2022 14:55:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E501B61C31;
        Fri, 30 Dec 2022 22:55:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC01C433EF;
        Fri, 30 Dec 2022 22:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440929;
        bh=3ueXZBy0OcKUPBcpEcvUNhRW2rGIy9ymN6thpWt/1Ao=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iuyPWHqaEmxwqlF8KMaNI0cNzIdVJ5ibo+d4ZOVMCuwFbpna4FHv9xcLT3/tN4uGb
         irwRjC/Yy1lcUfdoVr+CiuF232ExLRPDyUSQrE2vnPYqwHG3u142PiOUyy2wKdxsHv
         s8KeUOY98Ks3DJ6dszKghEOk6r6JrIG1TU+EgjqwX3T36UfIuCDiQgaZDQHIleAheS
         po9KBsgnbf9UMS8MxnieilQUcFNpAGIb9cJvK8EmwNmuyvxm9PADIDuY+RNUG2AnIf
         bIMaHsqR8axGPh0j9xBgtBwM3CoPYcN7v3mNrTO342FAabRnfBNfCSRzNxV/WV1cNn
         rQS/1KCfgo5uw==
Subject: [PATCH 05/16] fuzzy: rework scrub stress output filtering
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:12:53 -0800
Message-ID: <167243837366.694541.12412040391997627012.stgit@magnolia>
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

Rework the output filtering functions for scrub stress tests: first, we
should use _filter_scratch to avoid leaking the scratch fs details to
the output.  Second, for scrub and repair, change the filter elements to
reflect outputs that don't indicate failure (such as busy resources,
preening requests, and insufficient space to do anything).  Finally,
change the _require function to check that filter functions have been
sourced.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index e52831560d..94a6ce85a3 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -323,14 +323,19 @@ _scratch_xfs_fuzz_metadata() {
 # Filter freeze and thaw loop output so that we don't tarnish the golden output
 # if the kernel temporarily won't let us freeze.
 __stress_freeze_filter_output() {
-	grep -E -v '(Device or resource busy|Invalid argument)'
+	_filter_scratch | \
+		sed -e '/Device or resource busy/d' \
+		    -e '/Invalid argument/d'
 }
 
 # Filter scrub output so that we don't tarnish the golden output if the fs is
 # too busy to scrub.  Note: Tests should _notrun if the scrub type is not
 # supported.
 __stress_scrub_filter_output() {
-	grep -E -v '(Device or resource busy|Invalid argument)'
+	_filter_scratch | \
+		sed -e '/Device or resource busy/d' \
+		    -e '/Optimization possible/d' \
+		    -e '/No space left on device/d'
 }
 
 # Run fs freeze and thaw in a tight loop.
@@ -369,6 +374,8 @@ _require_xfs_stress_scrub() {
 	_require_xfs_io_command "scrub"
 	_require_command "$KILLALL_PROG" killall
 	_require_freeze
+	command -v _filter_scratch &>/dev/null || \
+		_notrun 'xfs scrub stress test requires common/filter'
 }
 
 # Make sure we have everything we need to run stress and online repair

