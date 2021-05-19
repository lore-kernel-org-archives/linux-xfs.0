Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8BB3C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 23:57:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A4EC61355
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 23:57:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbhESX6U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 19:58:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhESX6T (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 May 2021 19:58:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4672D61007;
        Wed, 19 May 2021 23:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621468619;
        bh=Yu+eAjhxeMKVLsBYZVl6EusGwPVpt+1jAIWovF6dlvQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QIwvHApgjGpNXR1fA81V9mKsCZYx+ShfjDWTEbpyVFel8WX+8ukQKyrQ9bis2HcvU
         VpwPMmcj+FEfih9zxbhw/7G3Qb/hNO/mapL3T6YnzVtdiXia6L0hpJqlQr2qsG7RpK
         AMI4ukjKnOqje7tIJ6jn5nAhrsYYz/7z8MVjhL9Aq6LvYHsEsTjrXN9peqkprgutSN
         UJjG60g0owSmjE+MvgghpMoy++OeGxvlVQHm3zx0PGpgRdKsBJysZVP37bYPW3Bf8c
         bQ6e0/dSwO3XpEhjkBUDxXTb6ReUstVKRrtL56DihG9JCpJvWLi5p14UvLCzHT+T/E
         ppOBWGQEU66zQ==
Subject: [PATCH 3/6] xfs/117: fix fragility in this fuzz test
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 19 May 2021 16:56:58 -0700
Message-ID: <162146861868.2500122.10790450415786633712.stgit@magnolia>
In-Reply-To: <162146860057.2500122.8732083536936062491.stgit@magnolia>
References: <162146860057.2500122.8732083536936062491.stgit@magnolia>
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

