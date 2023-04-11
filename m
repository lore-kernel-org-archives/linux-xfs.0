Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC631C76196
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 18:14:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbjDKSOH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 14:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjDKSOG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 14:14:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FFBE4E;
        Tue, 11 Apr 2023 11:14:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10AF662083;
        Tue, 11 Apr 2023 18:14:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF1BC433D2;
        Tue, 11 Apr 2023 18:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681236844;
        bh=PDfyAvPPKWv5okF2Jx64vv3q6inzoHRvbT88+0YaFBA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gUDcZyGrHrd+btkw3qwterCEevnoYiWB02Wl0KdrXrtKW5H2y9s40Pe8TQY8OCpqt
         Kqol2S/RhNuCeBgXBbCQHwWv14yzhUXdCBIONz+Hclcygtbt//kSkkUq2VugIn3dzm
         8QQD+ACWrBKmPXOXzRCMcfHujYRfpFq3D3mF6av7AW5XH0GOctG2Qj0OKQIkJSFtNc
         6bmqLhFeFwUf6o5TVlIHHo0nMhAVGg/ApuYo/pXMYcaYRIOPE2ZZHs9fMScfMeuynU
         xofiRlzsUFS9Gw46QRMkupAKLRgNZLDu9ojmF2zNNPj3eCeoc9ufSQVV18Okhtgdew
         mrs68yI1vSrhQ==
Subject: [PATCH 3/3] misc: add duration for recovery loop tests
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 11 Apr 2023 11:14:03 -0700
Message-ID: <168123684394.4086541.1780469729949319721.stgit@frogsfrogsfrogs>
In-Reply-To: <168123682679.4086541.13812285218510940665.stgit@frogsfrogsfrogs>
References: <168123682679.4086541.13812285218510940665.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make it so that we can run recovery loop tests for an exact number of
seconds.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc         |   34 ++++++++++++++++++++++++++++++++++
 tests/generic/019 |    1 +
 tests/generic/388 |    2 +-
 tests/generic/475 |    2 +-
 tests/generic/482 |    5 +++++
 tests/generic/648 |    8 ++++----
 6 files changed, 46 insertions(+), 6 deletions(-)


diff --git a/common/rc b/common/rc
index e89b0a3794..090f3d4938 100644
--- a/common/rc
+++ b/common/rc
@@ -5078,6 +5078,40 @@ _save_coredump()
 	$COREDUMP_COMPRESSOR -f "$out_file"
 }
 
+# Decide if a soak test should continue looping.  The sole parameter is the
+# number of soak loops that the test wants to run by default.  The actual
+# loop iteration number is stored in SOAK_LOOPIDX until the loop completes.
+#
+# If the test runner set a SOAK_DURATION value, this predicate will keep
+# looping until it has run for at least that long.
+_soak_loop_running() {
+	local max_soak_loops="$1"
+
+	test -z "$SOAK_LOOPIDX" && SOAK_LOOPIDX=1
+
+	if [ -n "$SOAK_DURATION" ]; then
+		if [ -z "$SOAK_DEADLINE" ]; then
+			SOAK_DEADLINE="$(( $(date +%s) + SOAK_DURATION))"
+		fi
+
+		local now="$(date +%s)"
+		if [ "$now" -gt "$SOAK_DEADLINE" ]; then
+			unset SOAK_DEADLINE
+			unset SOAK_LOOPIDX
+			return 1
+		fi
+		SOAK_LOOPIDX=$((SOAK_LOOPIDX + 1))
+		return 0
+	fi
+
+	if [ "$SOAK_LOOPIDX" -gt "$max_soak_loops" ]; then
+		unset SOAK_LOOPIDX
+		return 1
+	fi
+	SOAK_LOOPIDX=$((SOAK_LOOPIDX + 1))
+	return 0
+}
+
 init_rc
 
 ################################################################################
diff --git a/tests/generic/019 b/tests/generic/019
index b68dd90c0d..b81c1d17ba 100755
--- a/tests/generic/019
+++ b/tests/generic/019
@@ -30,6 +30,7 @@ _cleanup()
 }
 
 RUN_TIME=$((20+10*$TIME_FACTOR))
+test -n "$SOAK_DURATION" && RUN_TIME="$SOAK_DURATION"
 NUM_JOBS=$((4*LOAD_FACTOR))
 BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
 FILE_SIZE=$((BLK_DEV_SIZE * 512))
diff --git a/tests/generic/388 b/tests/generic/388
index 9cd737e8eb..4a5be6698c 100755
--- a/tests/generic/388
+++ b/tests/generic/388
@@ -42,7 +42,7 @@ _scratch_mkfs >> $seqres.full 2>&1
 _require_metadata_journaling $SCRATCH_DEV
 _scratch_mount
 
-for i in $(seq 1 $((50 * TIME_FACTOR)) ); do
+while _soak_loop_running $((50 * TIME_FACTOR)); do
 	($FSSTRESS_PROG $FSSTRESS_AVOID -d $SCRATCH_MNT -n 999999 -p 4 >> $seqres.full &) \
 		> /dev/null 2>&1
 
diff --git a/tests/generic/475 b/tests/generic/475
index c426402ede..0cbf5131c2 100755
--- a/tests/generic/475
+++ b/tests/generic/475
@@ -41,7 +41,7 @@ _require_metadata_journaling $SCRATCH_DEV
 _dmerror_init
 _dmerror_mount
 
-for i in $(seq 1 $((50 * TIME_FACTOR)) ); do
+while _soak_loop_running $((50 * TIME_FACTOR)); do
 	($FSSTRESS_PROG $FSSTRESS_AVOID -d $SCRATCH_MNT -n 999999 -p $((LOAD_FACTOR * 4)) >> $seqres.full &) \
 		> /dev/null 2>&1
 
diff --git a/tests/generic/482 b/tests/generic/482
index 28c83a232e..b980826b14 100755
--- a/tests/generic/482
+++ b/tests/generic/482
@@ -62,8 +62,13 @@ nr_cpus=$("$here/src/feature" -o)
 if [ $nr_cpus -gt 8 ]; then
 	nr_cpus=8
 fi
+
 fsstress_args=$(_scale_fsstress_args -w -d $SCRATCH_MNT -n 512 -p $nr_cpus \
 		$FSSTRESS_AVOID)
+
+# XXX dm-logwrites pins kernel memory for every write!
+# test -n "$SOAK_DURATION" && fsstress_args="$fsstress_args --duration=$SOAK_DURATION"
+
 devsize=$((1024*1024*200 / 512))	# 200m phys/virt size
 csize=$((1024*64 / 512))		# 64k cluster size
 lowspace=$((1024*1024 / 512))		# 1m low space threshold
diff --git a/tests/generic/648 b/tests/generic/648
index d7bf5697e1..3b3544ff49 100755
--- a/tests/generic/648
+++ b/tests/generic/648
@@ -74,14 +74,14 @@ snap_loop_fs() {
 
 fsstress=($FSSTRESS_PROG $FSSTRESS_AVOID -d "$loopmnt" -n 999999 -p "$((LOAD_FACTOR * 4))")
 
-for i in $(seq 1 $((25 * TIME_FACTOR)) ); do
+while _soak_loop_running $((25 * TIME_FACTOR)); do
 	touch $scratch_aliveflag
 	snap_loop_fs >> $seqres.full 2>&1 &
 
 	if ! _mount $loopimg $loopmnt -o loop; then
 		rm -f $scratch_aliveflag
 		_metadump_dev $loopimg $seqres.loop.$i.md
-		_fail "iteration $i loopimg mount failed"
+		_fail "iteration $SOAK_LOOPIDX loopimg mount failed"
 		break
 	fi
 
@@ -126,12 +126,12 @@ for i in $(seq 1 $((25 * TIME_FACTOR)) ); do
 	done
 	if [ $is_unmounted -ne 0 ];then
 		cat $tmp.unmount.err
-		_fail "iteration $i scratch unmount failed"
+		_fail "iteration $SOAK_LOOPIDX scratch unmount failed"
 	fi
 	_dmerror_load_working_table
 	if ! _dmerror_mount; then
 		_metadump_dev $DMERROR_DEV $seqres.scratch.$i.md
-		_fail "iteration $i scratch mount failed"
+		_fail "iteration $SOAK_LOOPIDX scratch mount failed"
 	fi
 done
 

