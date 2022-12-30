Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF249C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:40:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235723AbiLaAkT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235671AbiLaAkS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:40:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C5A1EAC0;
        Fri, 30 Dec 2022 16:40:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E72C8B81E34;
        Sat, 31 Dec 2022 00:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC610C433D2;
        Sat, 31 Dec 2022 00:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447214;
        bh=0UPMJQf5vqyCAPmX4K1gQtzjerlcCpKM2aRgGbVISyw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MBFCS1jZnjtPxLrj5b9RX2ktCVTPGSXfVRW2okX7blI2D5Pw+em/WQHbZgF8u7Yr6
         Q1yHiCquQUE/ArVm/jLcNuoFJeJCY61vx1YO94HZe/hHMJahB1KFytMYD1NywE9ZiH
         0SUW27uXLueA8bNWkqkUxqdEPRtI65PJ9NPicOYUwE8X516O8no+bxwDlqEZP6I1Bz
         iPtpTmGmXFcvoFVIuGaUy/K87NPbb/58QixVpNse453Ir1dEA8Rr76cEPZDqANcxIk
         aS+5LSPXvncYiH0kROxtnZDLx9RDhObQXcsya8Et0cfb90xTX3EzWNDJ6svImqOrOe
         JKJ4EmPtDopag==
Subject: [PATCH 1/1] fuzzy: use FORCE_REBUILD over injecting force_repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:09 -0800
Message-ID: <167243874964.722591.9199494099572054329.stgit@magnolia>
In-Reply-To: <167243874952.722591.1496636246267309523.stgit@magnolia>
References: <167243874952.722591.1496636246267309523.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

For stress testing online repair, try to use the FORCE_REBUILD ioctl
flag over the error injection knobs whenever possible because the knobs
are very noisy and are not always available.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |   34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index f7f660bc31..14f7fdf03c 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -398,6 +398,9 @@ __stress_one_scrub_loop() {
 
 	local xfs_io_args=()
 	for arg in "$@"; do
+		if [ -n "$SCRUBSTRESS_USE_FORCE_REBUILD" ]; then
+			arg="$(echo "$arg" | sed -e 's/^repair/repair -R/g')"
+		fi
 		if echo "$arg" | grep -q -w '%agno%'; then
 			# Substitute the AG number
 			for ((agno = 0; agno < agcount; agno++)); do
@@ -695,13 +698,21 @@ _require_xfs_stress_scrub() {
 		_notrun 'xfs scrub stress test requires common/filter'
 }
 
+# Make sure that we can force repairs either by error injection or passing
+# FORCE_REBUILD via ioctl.
+__require_xfs_stress_force_rebuild() {
+	local output="$($XFS_IO_PROG -x -c 'repair -R probe' $SCRATCH_MNT 2>&1)"
+	test -z "$output" && return
+	_require_xfs_io_error_injection "force_repair"
+}
+
 # Make sure we have everything we need to run stress and online repair
 _require_xfs_stress_online_repair() {
 	_require_xfs_stress_scrub
 	_require_xfs_io_command "repair"
 	command -v _require_xfs_io_error_injection &>/dev/null || \
 		_notrun 'xfs repair stress test requires common/inject'
-	_require_xfs_io_error_injection "force_repair"
+	__require_xfs_stress_force_rebuild
 	_require_freeze
 }
 
@@ -783,7 +794,11 @@ __stress_scrub_check_commands() {
 	esac
 
 	for arg in "$@"; do
-		local cooked_arg="$(echo "$arg" | sed -e "s/%agno%/0/g")"
+		local cooked_arg="$arg"
+		if [ -n "$SCRUBSTRESS_USE_FORCE_REBUILD" ]; then
+			cooked_arg="$(echo "$cooked_arg" | sed -e 's/^repair/repair -R/g')"
+		fi
+		cooked_arg="$(echo "$cooked_arg" | sed -e "s/%agno%/0/g")"
 		testio=`$XFS_IO_PROG -x -c "$cooked_arg" "$cooked_tgt" 2>&1`
 		echo $testio | grep -q "Unknown type" && \
 			_notrun "xfs_io scrub subcommand support is missing"
@@ -943,10 +958,23 @@ _scratch_xfs_stress_scrub() {
 	echo "Loop finished at $(date)" >> $seqres.full
 }
 
+# Decide if we're going to force repairs either by error injection or passing
+# FORCE_REBUILD via ioctl.
+__scratch_xfs_stress_setup_force_rebuild() {
+	local output="$($XFS_IO_PROG -x -c 'repair -R probe' $SCRATCH_MNT 2>&1)"
+
+	if [ -z "$output" ]; then
+		export SCRUBSTRESS_USE_FORCE_REBUILD=1
+		return
+	fi
+
+	$XFS_IO_PROG -x -c 'inject force_repair' $SCRATCH_MNT
+}
+
 # Start online repair, freeze, and fsstress in background looping processes,
 # and wait for 30*TIME_FACTOR seconds to see if the filesystem goes down.
 # Same requirements and arguments as _scratch_xfs_stress_scrub.
 _scratch_xfs_stress_online_repair() {
-	$XFS_IO_PROG -x -c 'inject force_repair' $SCRATCH_MNT
+	__scratch_xfs_stress_setup_force_rebuild
 	XFS_SCRUB_FORCE_REPAIR=1 _scratch_xfs_stress_scrub "$@"
 }

