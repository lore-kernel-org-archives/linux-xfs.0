Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2954BC3DA7D
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:58:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235581AbiL3W6K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235671AbiL3W6J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:58:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673B01CB3F;
        Fri, 30 Dec 2022 14:58:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12B70B81DA0;
        Fri, 30 Dec 2022 22:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF14DC433EF;
        Fri, 30 Dec 2022 22:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441085;
        bh=BfjqOk88ZtFx6eLVmz4NC6IzcTQjwPAa+NLXr7NEQ7Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iIAjnb94P8z1z1WiIeXvb1frkWxgSdVAzbuf5SsrlUoaqkOYP8iCi0OGi0cv63VRv
         TH7AQCUGIqI154rov3rPj0+ORTgXau146vDJfO87UGzXoefsXbwDxyjaD97TqB9kgb
         gjECpvvzt0kHjl0Aie5upRtmkobRA0EEtSD+hjJDF6Mic1JXHHzen1AaMZzjMK2woh
         c/jCKKQwKf9ZT5DKKx1fhAR1HR3GQnznXM9y1qhe4yyRLaqo2ru+Z9jeuTTCdL6ogt
         WIgBvunckqcvYM2OXThzESh4OdgAgOIYKHg6k/7osVlwjh5kgbVHc9yBf9CJQwW9By
         WgeOXm7yjSzdQ==
Subject: [PATCH 15/16] fuzzy: allow substitution of AG numbers when
 configuring scrub stress test
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:12:55 -0800
Message-ID: <167243837501.694541.13900520713966204152.stgit@magnolia>
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

Allow the test program to use the metavariable '%agno%' when passing
scrub commands to the scrub stress loop.  This makes it easier for tests
to scrub or repair every AG in the filesystem without a lot of work.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy  |   14 ++++++++++++--
 tests/xfs/422 |    2 +-
 2 files changed, 13 insertions(+), 3 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index 219dd3bb0a..e42e2ccec1 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -368,10 +368,19 @@ __stress_one_scrub_loop() {
 	local runningfile="$2"
 	local scrub_tgt="$3"
 	shift; shift; shift
+	local agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
 
 	local xfs_io_args=()
 	for arg in "$@"; do
-		xfs_io_args+=('-c' "$arg")
+		if echo "$arg" | grep -q -w '%agno%'; then
+			# Substitute the AG number
+			for ((agno = 0; agno < agcount; agno++)); do
+				local ag_arg="$(echo "$arg" | sed -e "s|%agno%|$agno|g")"
+				xfs_io_args+=('-c' "$ag_arg")
+			done
+		else
+			xfs_io_args+=('-c' "$arg")
+		fi
 	done
 
 	while __stress_scrub_running "$end" "$runningfile"; do
@@ -481,7 +490,8 @@ __stress_scrub_check_commands() {
 	shift
 
 	for arg in "$@"; do
-		testio=`$XFS_IO_PROG -x -c "$arg" $scrub_tgt 2>&1`
+		local cooked_arg="$(echo "$arg" | sed -e "s/%agno%/0/g")"
+		testio=`$XFS_IO_PROG -x -c "$cooked_arg" $scrub_tgt 2>&1`
 		echo $testio | grep -q "Unknown type" && \
 			_notrun "xfs_io scrub subcommand support is missing"
 		echo $testio | grep -q "Inappropriate ioctl" && \
diff --git a/tests/xfs/422 b/tests/xfs/422
index ac88713257..995f612166 100755
--- a/tests/xfs/422
+++ b/tests/xfs/422
@@ -31,7 +31,7 @@ _require_xfs_stress_online_repair
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount
 _require_xfs_has_feature "$SCRATCH_MNT" rmapbt
-_scratch_xfs_stress_online_repair -f -s "repair rmapbt 0" -s "repair rmapbt 1"
+_scratch_xfs_stress_online_repair -f -s "repair rmapbt %agno%"
 
 # success, all done
 echo Silence is golden

