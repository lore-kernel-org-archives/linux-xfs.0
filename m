Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A477CC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:57:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235668AbiL3W5w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235581AbiL3W5v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:57:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA7D1B9E2;
        Fri, 30 Dec 2022 14:57:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC34361C30;
        Fri, 30 Dec 2022 22:57:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B2FC433D2;
        Fri, 30 Dec 2022 22:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441070;
        bh=N7ng7JtzN4kW7DNFVLF0bvK5xmgiuIB/v1OJKPdAJqg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=taPrPJgG1byzU5mjLTth/jW36w3PcBLyc9Cx8eJLLVmFFPwjAOxgGniH5vQP98Sok
         lzPS72RgDgPOgJsdbSmBfE3m1UIDsQnkSvicZmJMApym8YulD7BvntJ735pu1Zx/dO
         GQ0xfAtt/k/7CT4y/dmTFXZo3BD/9Jhgt5A37h4kKpZj3GnUI/D6JDJ/0DaGiXXyTo
         Eknj2+OHHHEKhQQA1cFSHjIZF+v8OC8+R2c03b/OV5apd+yfB/hrqAuHPxYwp0hHx7
         9iAcw1NSJeqJtBPpsM5rdq1sTgaLuDYc4pEXnh1eUmNSYHfCFCLUc3K3U7y1LxT5zn
         NygyaaUMh2DNA==
Subject: [PATCH 14/16] fuzzy: make freezing optional for scrub stress tests
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:12:54 -0800
Message-ID: <167243837487.694541.11855121854386930402.stgit@magnolia>
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

Make the freeze/thaw loop optional, since that's a significant change in
behavior if it's enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy  |   13 ++++++++++---
 tests/xfs/422 |    2 +-
 2 files changed, 11 insertions(+), 4 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index 0f6fc91b80..219dd3bb0a 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -499,6 +499,8 @@ __stress_scrub_check_commands() {
 #
 # Various options include:
 #
+# -f	Run a freeze/thaw loop while we're doing other things.  Defaults to
+#	disabled, unless XFS_SCRUB_STRESS_FREEZE is set.
 # -s	Pass this command to xfs_io to test scrub.  If zero -s options are
 #	specified, xfs_io will not be run.
 # -t	Run online scrub against this file; $SCRATCH_MNT is the default.
@@ -506,14 +508,16 @@ _scratch_xfs_stress_scrub() {
 	local one_scrub_args=()
 	local scrub_tgt="$SCRATCH_MNT"
 	local runningfile="$tmp.fsstress"
+	local freeze="${XFS_SCRUB_STRESS_FREEZE}"
 
 	__SCRUB_STRESS_FREEZE_PID=""
 	rm -f "$runningfile"
 	touch "$runningfile"
 
 	OPTIND=1
-	while getopts "s:t:" c; do
+	while getopts "fs:t:" c; do
 		case "$c" in
+			f) freeze=yes;;
 			s) one_scrub_args+=("$OPTARG");;
 			t) scrub_tgt="$OPTARG";;
 			*) return 1; ;;
@@ -529,8 +533,11 @@ _scratch_xfs_stress_scrub() {
 		   "ending at $(date --date="@${end}")" >> $seqres.full
 
 	__stress_scrub_fsstress_loop "$end" "$runningfile" &
-	__stress_scrub_freeze_loop "$end" "$runningfile" &
-	__SCRUB_STRESS_FREEZE_PID="$!"
+
+	if [ -n "$freeze" ]; then
+		__stress_scrub_freeze_loop "$end" "$runningfile" &
+		__SCRUB_STRESS_FREEZE_PID="$!"
+	fi
 
 	if [ "${#one_scrub_args[@]}" -gt 0 ]; then
 		__stress_one_scrub_loop "$end" "$runningfile" "$scrub_tgt" \
diff --git a/tests/xfs/422 b/tests/xfs/422
index faea5d6792..ac88713257 100755
--- a/tests/xfs/422
+++ b/tests/xfs/422
@@ -31,7 +31,7 @@ _require_xfs_stress_online_repair
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount
 _require_xfs_has_feature "$SCRATCH_MNT" rmapbt
-_scratch_xfs_stress_online_repair -s "repair rmapbt 0" -s "repair rmapbt 1"
+_scratch_xfs_stress_online_repair -f -s "repair rmapbt 0" -s "repair rmapbt 1"
 
 # success, all done
 echo Silence is golden

