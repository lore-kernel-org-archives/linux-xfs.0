Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B82BEC433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 02:02:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82423613AA
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 02:02:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhELCDM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 May 2021 22:03:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:49698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230095AbhELCDM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 May 2021 22:03:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE1A761166;
        Wed, 12 May 2021 02:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620784925;
        bh=Yu+eAjhxeMKVLsBYZVl6EusGwPVpt+1jAIWovF6dlvQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BoZK0JeoB//EkdE6JEl3MjJZ4gtP+YajmXzTIhmhIpsxa27HhiEylZiqs8TV5ABo4
         wYPB6Uv5HEDp1hWJ0SlWRt2P9rXkaPM+dhPXAGtHUl2g8yMg1PIb4EEcmq69wKnn9t
         p6CjjPqMQ2O55/DpPJ8TjWFumvpxc4HM1La3YTaX8a47vTUi9eMoeae2ORaTgln5XL
         Y2Gz5hw9T+UL6HiSLaSTlbBGaqpr/4zaTGSrc9LK+U5+YrEa8uyQtyfs1j+cn08qdM
         RCkiHU4m/Vk8y+uMbWZ2yCYGzO4q5yViPV64QypdWywpEfAFtWipHXB85xRpR49nJW
         TfYaRh1kolefA==
Subject: [PATCH 4/8] xfs/117: fix fragility in this fuzz test
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 11 May 2021 19:02:02 -0700
Message-ID: <162078492228.3302755.2845906763358077143.stgit@magnolia>
In-Reply-To: <162078489963.3302755.9219127595550889655.stgit@magnolia>
References: <162078489963.3302755.9219127595550889655.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This fuzz test has some fragility problems -- it doesn't do anything to
guarantee that the inodes that it checks for EFSCORRUPTED are the same
ones that it fuzzed, and it doesn't explicitly try to avoid victimizing
inodes in the same chunk as the root directory.  As a result, this test
fails annoyingly frequently.

Fix both of these problems and get rid of the confusingly named TESTDIR
variable.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/117 |   47 +++++++++++++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 18 deletions(-)


diff --git a/tests/xfs/117 b/tests/xfs/117
index d3f4675f..32be525f 100755
--- a/tests/xfs/117
+++ b/tests/xfs/117
@@ -39,8 +39,7 @@ _require_xfs_db_blocktrash_z_command
 test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -3"
 
 rm -f $seqres.full
-TESTDIR="${SCRATCH_MNT}/scratchdir"
-TESTFILE="${TESTDIR}/testfile"
+victimdir="${SCRATCH_MNT}/scratchdir"
 
 echo "+ create scratch fs"
 _scratch_mkfs_xfs > /dev/null
@@ -50,37 +49,49 @@ _scratch_mount
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 
 echo "+ make some files"
-mkdir -p "${TESTDIR}"
-for x in `seq 1 1024`; do
-	touch "${SCRATCH_MNT}/junk.${x}"
-	inode="$(stat -c '%i' "${SCRATCH_MNT}/junk.${x}")"
-	if [ "$x" -gt 512 ] && [ "$((inode % 64))" -eq 0 ]; then
-		mv "${SCRATCH_MNT}/junk.${x}" "${TESTFILE}.1"
-		break
-	fi
+mkdir -p "$victimdir"
+
+rootdir="$(stat -c '%i' "$SCRATCH_MNT")"
+rootchunk=$(( rootdir / 64 ))
+
+# First we create some dummy file so that the victim files don't get created
+# in the same inode chunk as the root directory, because a corrupt inode in
+# the root chunk causes mount to fail.
+for ((i = 0; i < 256; i++)); do
+	fname="$SCRATCH_MNT/dummy.$i"
+	touch "$fname"
+	ino="$(stat -c '%i' "$fname")"
+	ichunk=$(( ino / 64 ))
+	test "$ichunk" -gt "$rootchunk" && break
 done
-for x in `seq 2 64`; do
-	touch "${TESTFILE}.${x}"
+
+# Now create some victim files
+inos=()
+for ((i = 0; i < 64; i++)); do
+	fname="$victimdir/test.$i"
+	touch "$fname"
+	inos+=("$(stat -c '%i' "$fname")")
 done
-inode="$(stat -c '%i' "${TESTFILE}.1")"
+echo "First victim inode is: " >> $seqres.full
+stat -c '%i' "$fname" >> $seqres.full
 umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
 
 echo "+ corrupt image"
-seq "${inode}" "$((inode + 63))" | while read ino; do
+for ino in "${inos[@]}"; do
 	_scratch_xfs_db -x -c "inode ${ino}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full 2>&1
 done
 
 echo "+ mount image && modify files"
 broken=1
 if _try_scratch_mount >> $seqres.full 2>&1; then
-
-	for x in `seq 1 64`; do
-		stat "${TESTFILE}.${x}" >> $seqres.full 2>&1
+	for ((i = 0; i < 64; i++)); do
+		fname="$victimdir/test.$i"
+		stat "$fname" &>> $seqres.full
 		test $? -eq 0 && broken=0
-		touch "${TESTFILE}.${x}" >> $seqres.full 2>&1
+		touch "$fname" &>> $seqres.full
 		test $? -eq 0 && broken=0
 	done
 	umount "${SCRATCH_MNT}"

