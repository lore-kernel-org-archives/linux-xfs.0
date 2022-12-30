Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BC8BC3DA7C
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:56:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbiL3W45 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:56:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbiL3W4v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:56:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E041CB3F;
        Fri, 30 Dec 2022 14:56:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2C4AB81D95;
        Fri, 30 Dec 2022 22:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7120CC433D2;
        Fri, 30 Dec 2022 22:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441007;
        bh=18Vk5SdrtloXpub5avMYmbLMio9pDxg7VblV6vckqo0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PZsefOpVNRJtgBl8inWM25C9zLMbKx6gIDrOzHfBLgXRFYzGZnYTZXKH1LnBI9Ct4
         Z4qas8xGFqZzdqL7YSZ/2EUYzVCWRpaS2dlgluiytGsj0TZis/rKTr7CuDf0WnPYX9
         q0XVzZJKrEMB4sVZ3U8njuooSW5lTNdZUtL+plv3MrkSmkPFfaNUKiAGDlchq/vDhp
         w3+plAIbm1nEraQOsD0eg9Ji3b95W0/Q3H382Yu29Nbn0mSUw4Fy255M72gUNWKeUa
         ALGmamEax6Ncxp3VgDuxsTk9VxUunvgpEZGxaJHbag/cAmB6Pa5ee+A3rEjk/AQzWH
         UtJ9a1Zui7YTQ==
Subject: [PATCH 10/16] fuzzy: abort scrub stress testing if the scratch fs
 went down
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:12:54 -0800
Message-ID: <167243837433.694541.10388508931249405710.stgit@magnolia>
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

There's no point in continuing a stress test of online fsck if the
filesystem goes down.  We can't query that kind of state directly, so as
a proxy we try to stat the mountpoint and interpret any error return as
a sign that the fs is down.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)


diff --git a/common/fuzzy b/common/fuzzy
index 6519d5c1e2..f1bc2dc756 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -338,10 +338,17 @@ __stress_scrub_filter_output() {
 		    -e '/No space left on device/d'
 }
 
+# Decide if the scratch filesystem is still alive.
+__stress_scrub_scratch_alive() {
+	# If we can't stat the scratch filesystem, there's a reasonably good
+	# chance that the fs shut down, which is not good.
+	stat "$SCRATCH_MNT" &>/dev/null
+}
+
 # Decide if we want to keep running stress tests.  The first argument is the
 # stop time, and second argument is the path to the sentinel file.
 __stress_scrub_running() {
-	test -e "$2" && test "$(date +%s)" -lt "$1"
+	test -e "$2" && test "$(date +%s)" -lt "$1" && __stress_scrub_scratch_alive
 }
 
 # Run fs freeze and thaw in a tight loop.
@@ -486,6 +493,10 @@ _scratch_xfs_stress_scrub() {
 	done
 	_scratch_xfs_stress_scrub_cleanup
 
+	# Warn the user if we think the scratch filesystem went down.
+	__stress_scrub_scratch_alive || \
+		echo "Did the scratch filesystem die?"
+
 	echo "Loop finished at $(date)" >> $seqres.full
 }
 

