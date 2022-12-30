Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B85AC4167B
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236337AbiLaDRF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236308AbiLaDRE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:17:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D042733;
        Fri, 30 Dec 2022 19:17:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 45EE1CE1AC8;
        Sat, 31 Dec 2022 03:17:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83099C433EF;
        Sat, 31 Dec 2022 03:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456619;
        bh=krotYh8JybgzAO1C4X5hqoygGSuQP0LrobVWG4/RKfY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cb6plXb1YSqS6qRkVmPcsN5qFkKkaUbHkueA8FKNw7CmgMFcSybDYKuLwnj/yArpg
         hbXFa4a/M+u4GU11sSw+0k/cY2FiV9/aKzJ81i86MaXsfbGg037+O8Hq1k3ctHaKFp
         WNNNHQdx/XvwrJPRUDwR0c3hiRaYzFdMslEURSjd62UUu+EniZHukwETyfsvfJ3y7i
         Atix7x4lmx37n9ejGBR4Hn1+GAxuASSs3RtXvL52G6oux4NISsoYt8+ikWZc2UpMgh
         gDcVzFZcvtGxeXjOny/bKbIWS4RBONjESGYJf7DEoaxKrlTfetZwQ5o9RKRKDvlZPa
         mXYU6dSK2e7sg==
Subject: [PATCH 04/10] xfs/27[24]: adapt for checking files on the realtime
 volume
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:49 -0800
Message-ID: <167243884906.740253.11551634099635190450.stgit@magnolia>
In-Reply-To: <167243884850.740253.18400210873595872110.stgit@magnolia>
References: <167243884850.740253.18400210873595872110.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Adapt both tests to behave properly if the two files being tested are on
the realtime volume.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/272 |   40 +++++++++++++++++++++++++------------
 tests/xfs/274 |   62 ++++++++++++++++++++++++++++++++++++++++-----------------
 2 files changed, 70 insertions(+), 32 deletions(-)


diff --git a/tests/xfs/272 b/tests/xfs/272
index 42b4a2edb5..2d7fc57d55 100755
--- a/tests/xfs/272
+++ b/tests/xfs/272
@@ -40,26 +40,40 @@ $here/src/punch-alternating $SCRATCH_MNT/urk >> $seqres.full
 ino=$(stat -c '%i' $SCRATCH_MNT/urk)
 
 echo "Get fsmap" | tee -a $seqres.full
-$XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT >> $seqres.full
 $XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT | tr '[]()' '    ' > $TEST_DIR/fsmap
+cat $TEST_DIR/fsmap >> $seqres.full
 
 echo "Get bmap" | tee -a $seqres.full
-$XFS_IO_PROG -c 'bmap -v' $SCRATCH_MNT/urk >> $seqres.full
 $XFS_IO_PROG -c 'bmap -v' $SCRATCH_MNT/urk | grep '^[[:space:]]*[0-9]*:' | grep -v 'hole' | tr '[]()' '    ' > $TEST_DIR/bmap
+cat $TEST_DIR/bmap >> $seqres.full
 
 echo "Check bmap and fsmap" | tee -a $seqres.full
-cat $TEST_DIR/bmap | while read ext offrange colon blockrange ag agrange total crap; do
-	qstr="^[[:space:]]*[0-9]*:[[:space:]]*[0-9]*:[0-9]*[[:space:]]*${blockrange} :[[:space:]]*${ino}[[:space:]]*${offrange}[[:space:]]*${ag}[[:space:]]*${agrange}[[:space:]]*${total}$"
-	echo "${qstr}" >> $seqres.full
-	grep "${qstr}" $TEST_DIR/fsmap >> $seqres.full
-	found=$(grep -c "${qstr}" $TEST_DIR/fsmap)
-	test $found -eq 1 || echo "Unexpected output for offset ${offrange}."
-done
+if $XFS_IO_PROG -c 'stat -v' $SCRATCH_MNT/urk | grep -q realtime; then
+	# file on rt volume
+	cat $TEST_DIR/bmap | while read ext offrange colon rtblockrange total crap; do
+		qstr="^[[:space:]]*[0-9]*:[[:space:]]*[0-9]*:[0-9]*[[:space:]]*${rtblockrange} :[[:space:]]*${ino}[[:space:]]*${offrange}[[:space:]]*${total}$"
+		echo "${qstr}" >> $seqres.full
+		grep "${qstr}" $TEST_DIR/fsmap >> $seqres.full
+		found=$(grep -c "${qstr}" $TEST_DIR/fsmap)
+		test $found -eq 1 || echo "Unexpected output for offset ${offrange}."
+	done
 
-echo "Check device field of FS metadata and regular file"
-data_dev=$(grep 'inode btree' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
-rt_dev=$(grep "${ino}[[:space:]]*[0-9]*\.\.[0-9]*" $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
-test "${data_dev}" = "${rt_dev}" || echo "data ${data_dev} realtime ${rt_dev}?"
+	echo "Check device field of FS metadata and regular file"
+else
+	# file on data volume
+	cat $TEST_DIR/bmap | while read ext offrange colon blockrange ag agrange total crap; do
+		qstr="^[[:space:]]*[0-9]*:[[:space:]]*[0-9]*:[0-9]*[[:space:]]*${blockrange} :[[:space:]]*${ino}[[:space:]]*${offrange}[[:space:]]*${ag}[[:space:]]*${agrange}[[:space:]]*${total}$"
+		echo "${qstr}" >> $seqres.full
+		grep "${qstr}" $TEST_DIR/fsmap >> $seqres.full
+		found=$(grep -c "${qstr}" $TEST_DIR/fsmap)
+		test $found -eq 1 || echo "Unexpected output for offset ${offrange}."
+	done
+
+	echo "Check device field of FS metadata and regular file"
+	data_dev=$(grep 'inode btree' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
+	rt_dev=$(grep "${ino}[[:space:]]*[0-9]*\.\.[0-9]*" $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
+	test "${data_dev}" = "${rt_dev}" || echo "data ${data_dev} realtime ${rt_dev}?"
+fi
 
 # success, all done
 status=0
diff --git a/tests/xfs/274 b/tests/xfs/274
index dcaea68804..25dd0c3f74 100755
--- a/tests/xfs/274
+++ b/tests/xfs/274
@@ -40,34 +40,58 @@ _cp_reflink $SCRATCH_MNT/f1 $SCRATCH_MNT/f2
 ino=$(stat -c '%i' $SCRATCH_MNT/f1)
 
 echo "Get fsmap" | tee -a $seqres.full
-$XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT >> $seqres.full
 $XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT | tr '[]()' '    ' > $TEST_DIR/fsmap
+cat $TEST_DIR/fsmap >> $seqres.full
 
 echo "Get f1 bmap" | tee -a $seqres.full
-$XFS_IO_PROG -c 'bmap -v' $SCRATCH_MNT/f1 >> $seqres.full
 $XFS_IO_PROG -c 'bmap -v' $SCRATCH_MNT/f1 | grep '^[[:space:]]*[0-9]*:' | grep -v 'hole' | tr '[]()' '    ' > $TEST_DIR/bmap
+cat $TEST_DIR/bmap >> $seqres.full
 
-echo "Check f1 bmap and fsmap" | tee -a $seqres.full
-cat $TEST_DIR/bmap | while read ext offrange colon blockrange ag agrange total crap; do
-	qstr="^[[:space:]]*[0-9]*:[[:space:]]*[0-9]*:[0-9]*[[:space:]]*${blockrange} :[[:space:]]*${ino}[[:space:]]*${offrange}[[:space:]]*${ag}[[:space:]]*${agrange}[[:space:]]*${total} 0100000$"
-	echo "${qstr}" >> $seqres.full
-	grep "${qstr}" $TEST_DIR/fsmap >> $seqres.full
-	found=$(grep -c "${qstr}" $TEST_DIR/fsmap)
-	test $found -eq 1 || echo "Unexpected output for offset ${offrange}."
-done
+if _xfs_is_realtime_file $SCRATCH_MNT/f1 && ! _xfs_has_feature $SCRATCH_MNT rtgroups; then
+	# file on rt volume
+	echo "Check f1 bmap and fsmap" | tee -a $seqres.full
+	cat $TEST_DIR/bmap | while read ext offrange colon rtblockrange total crap; do
+		qstr="^[[:space:]]*[0-9]*:[[:space:]]*[0-9]*:[0-9]*[[:space:]]*${rtblockrange} :[[:space:]]*${ino}[[:space:]]*${offrange}[[:space:]]*${total} 0100000$"
+		echo "${qstr}" >> $seqres.full
+		grep "${qstr}" $TEST_DIR/fsmap >> $seqres.full
+		found=$(grep -c "${qstr}" $TEST_DIR/fsmap)
+		test $found -eq 1 || echo "Unexpected output for offset ${offrange}."
+	done
+else
+	# file on data volume
+	echo "Check f1 bmap and fsmap" | tee -a $seqres.full
+	cat $TEST_DIR/bmap | while read ext offrange colon blockrange ag agrange total crap; do
+		qstr="^[[:space:]]*[0-9]*:[[:space:]]*[0-9]*:[0-9]*[[:space:]]*${blockrange} :[[:space:]]*${ino}[[:space:]]*${offrange}[[:space:]]*${ag}[[:space:]]*${agrange}[[:space:]]*${total} 0100000$"
+		echo "${qstr}" >> $seqres.full
+		grep "${qstr}" $TEST_DIR/fsmap >> $seqres.full
+		found=$(grep -c "${qstr}" $TEST_DIR/fsmap)
+		test $found -eq 1 || echo "Unexpected output for offset ${offrange}."
+	done
+fi
 
 echo "Get f2 bmap" | tee -a $seqres.full
-$XFS_IO_PROG -c 'bmap -v' $SCRATCH_MNT/f2 >> $seqres.full
 $XFS_IO_PROG -c 'bmap -v' $SCRATCH_MNT/f2 | grep '^[[:space:]]*[0-9]*:' | grep -v 'hole' | tr '[]()' '    ' > $TEST_DIR/bmap
+cat $TEST_DIR/bmap >> $seqres.full
 
-echo "Check f2 bmap and fsmap" | tee -a $seqres.full
-cat $TEST_DIR/bmap | while read ext offrange colon blockrange ag agrange total crap; do
-	qstr="^[[:space:]]*[0-9]*:[[:space:]]*[0-9]*:[0-9]*[[:space:]]*${blockrange} :[[:space:]]*${ino}[[:space:]]*${offrange}[[:space:]]*${ag}[[:space:]]*${agrange}[[:space:]]*${total} 0100000$"
-	echo "${qstr}" >> $seqres.full
-	grep "${qstr}" $TEST_DIR/fsmap >> $seqres.full
-	found=$(grep -c "${qstr}" $TEST_DIR/fsmap)
-	test $found -eq 1 || echo "Unexpected output for offset ${offrange}."
-done
+if _xfs_is_realtime_file $SCRATCH_MNT/f2 && ! _xfs_has_feature $SCRATCH_MNT rtgroups; then
+	echo "Check f2 bmap and fsmap" | tee -a $seqres.full
+	cat $TEST_DIR/bmap | while read ext offrange colon rtblockrange total crap; do
+		qstr="^[[:space:]]*[0-9]*:[[:space:]]*[0-9]*:[0-9]*[[:space:]]*${rtblockrange} :[[:space:]]*${ino}[[:space:]]*${offrange}[[:space:]]*${total} 0100000$"
+		echo "${qstr}" >> $seqres.full
+		grep "${qstr}" $TEST_DIR/fsmap >> $seqres.full
+		found=$(grep -c "${qstr}" $TEST_DIR/fsmap)
+		test $found -eq 1 || echo "Unexpected output for offset ${offrange}."
+	done
+else
+	echo "Check f2 bmap and fsmap" | tee -a $seqres.full
+	cat $TEST_DIR/bmap | while read ext offrange colon blockrange ag agrange total crap; do
+		qstr="^[[:space:]]*[0-9]*:[[:space:]]*[0-9]*:[0-9]*[[:space:]]*${blockrange} :[[:space:]]*${ino}[[:space:]]*${offrange}[[:space:]]*${ag}[[:space:]]*${agrange}[[:space:]]*${total} 0100000$"
+		echo "${qstr}" >> $seqres.full
+		grep "${qstr}" $TEST_DIR/fsmap >> $seqres.full
+		found=$(grep -c "${qstr}" $TEST_DIR/fsmap)
+		test $found -eq 1 || echo "Unexpected output for offset ${offrange}."
+	done
+fi
 
 # success, all done
 status=0

