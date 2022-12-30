Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 213FBC3DA7C
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:57:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235665AbiL3W5W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:57:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235647AbiL3W5W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:57:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB241B9E2;
        Fri, 30 Dec 2022 14:57:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E086B81D95;
        Fri, 30 Dec 2022 22:57:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE989C433EF;
        Fri, 30 Dec 2022 22:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441038;
        bh=28h2JW4kYwgtShJujLRwlnsZt43YsOlA6fDOLH1qXL4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QxX0Ivy+aMHlukTCOMvLoh6SgDhPmz3Tml1xv0Oo05/E4qGjAVCST8SrBll7nAFDQ
         ixz9uW2i/R+Ak2K2m20PrgbS6z3/2Sdu9N3gKvh1Aj6cH9tq3JO1cYwKUirctzvil/
         JsyzY4Afh9NgFvJaJCfluXX261dfaj5zb5FqoCzdsqTt18xrkO6lhVZ2A04wr0z92Y
         nCOxRsOXWCjbtmqmv+P84q2SAHYctimEOmKDAL5bRivnSbwVoSmunABjM0fMJ8FmH5
         EZ25QOfW4WnE9C6HcgUsnuVPXMTIMi5qeq/LabV3mj1Eqdj+36F802eTmEjO0zClFD
         jYz0mAXQZ6fww==
Subject: [PATCH 12/16] fuzzy: increase operation count for each fsstress
 invocation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:12:54 -0800
Message-ID: <167243837460.694541.14076101650568669658.stgit@magnolia>
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

For online fsck stress testing, increase the number of filesystem
operations per fsstress run to 2 million, now that we have the ability
to kill fsstress if the user should push ^C to abort the test early.
This should guarantee a couple of hours of continuous stress testing in
between clearing the scratch filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/common/fuzzy b/common/fuzzy
index 01cf7f00d8..3e23edc9e4 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -399,7 +399,9 @@ __stress_scrub_fsstress_loop() {
 	local end="$1"
 	local runningfile="$2"
 
-	local args=$(_scale_fsstress_args -p 4 -d $SCRATCH_MNT -n 2000 $FSSTRESS_AVOID)
+	# As of March 2022, 2 million fsstress ops should be enough to keep
+	# any filesystem busy for a couple of hours.
+	local args=$(_scale_fsstress_args -p 4 -d $SCRATCH_MNT -n 2000000 $FSSTRESS_AVOID)
 	echo "Running $FSSTRESS_PROG $args" >> $seqres.full
 
 	while __stress_scrub_running "$end" "$runningfile"; do

