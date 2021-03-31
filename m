Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 044B9C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 01:09:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4C87619CB
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 01:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbhCaBJY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 21:09:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233018AbhCaBJH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Mar 2021 21:09:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E09661953;
        Wed, 31 Mar 2021 01:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617152947;
        bh=QbBo63TUrO5vkfeagbc7quVE29dg/RQI44IJK4tIwu4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TXtoNdzre6q5qLUL1easOJXPvI7V+OzzuI7X1rdo4hvUud1adaZs+jzo4nGdr8SKV
         XAdsk5XtpyGBtT/hTrxUZ3WA3u0iPf+l+6PBOM/iTrEz3ACTfI2CTFqiNja+BKny8G
         FNzPIU3WMpJBYBNI9OynIIBelNmo+cLoTRHWmrfN/q6eqU9+hUNXKSKt+J7XQmpe0y
         j01LCwtWLA1172fffea4UXTnlSPduxVTWLi9Deo3SQf0qNQ6WSNyOrmJN73d06zzct
         Y/h2m+SclCc0j3LKOUtxCuc52RPchhZd7ibZBsUxjdlkQ6p555KvykQAFBWIU6ET3v
         Ojiw8cKJn5fIw==
Subject: [PATCH 1/1] xfs/23[12]: abstractify the XFS cow prealloc trimming
 interval
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 30 Mar 2021 18:09:05 -0700
Message-ID: <161715294506.2704105.18365101912825541162.stgit@magnolia>
In-Reply-To: <161715293961.2704105.12379656102061134645.stgit@magnolia>
References: <161715293961.2704105.12379656102061134645.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a couple of helper functions to get and set the XFS copy on write
preallocation garbage collection interval.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs    |   23 +++++++++++++++++++++++
 tests/xfs/231 |   13 +++++++------
 tests/xfs/232 |   13 +++++++------
 3 files changed, 37 insertions(+), 12 deletions(-)


diff --git a/common/xfs b/common/xfs
index c430b3ac..ade76d5a 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1165,3 +1165,26 @@ _require_xfs_scratch_bigtime()
 		_notrun "bigtime feature not advertised on mount?"
 	_scratch_unmount
 }
+
+__xfs_cowgc_interval_knob1="/proc/sys/fs/xfs/speculative_cow_prealloc_lifetime"
+__xfs_cowgc_interval_knob2="/proc/sys/fs/xfs/speculative_prealloc_lifetime"
+
+_xfs_set_cowgc_interval() {
+	if [ -w $__xfs_cowgc_interval_knob1 ]; then
+		echo "$@" > $__xfs_cowgc_interval_knob1
+	elif [ -w $__xfs_cowgc_interval_knob2 ]; then
+		echo "$@" > $__xfs_cowgc_interval_knob2
+	else
+		_fail "Can't find cowgc interval procfs knob?"
+	fi
+}
+
+_xfs_get_cowgc_interval() {
+	if [ -w $__xfs_cowgc_interval_knob1 ]; then
+		cat $__xfs_cowgc_interval_knob1
+	elif [ -w $__xfs_cowgc_interval_knob2 ]; then
+		cat $__xfs_cowgc_interval_knob2
+	else
+		_fail "Can't find cowgc interval procfs knob?"
+	fi
+}
diff --git a/tests/xfs/231 b/tests/xfs/231
index 5930339d..119a71bb 100755
--- a/tests/xfs/231
+++ b/tests/xfs/231
@@ -22,9 +22,10 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 _cleanup()
 {
-    cd /
-    echo $old_cow_lifetime > /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime
-    rm -rf $tmp.*
+	cd /
+	test -n "$old_cowgc_interval" && \
+		_xfs_set_cowgc_interval $old_cowgc_interval
+	rm -rf $tmp.*
 }
 
 # get standard environment, filters and checks
@@ -40,7 +41,7 @@ _require_xfs_io_command "cowextsize"
 _require_xfs_io_command "falloc"
 _require_xfs_io_command "fiemap"
 
-old_cow_lifetime=$(cat /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime)
+old_cowgc_interval=$(_xfs_get_cowgc_interval)
 
 rm -f $seqres.full
 
@@ -74,7 +75,7 @@ md5sum $testdir/file2 | _filter_scratch
 md5sum $testdir/file2.chk | _filter_scratch
 
 echo "CoW and leave leftovers"
-echo 2 > /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime
+_xfs_set_cowgc_interval 2
 seq 2 2 $((nr - 1)) | while read f; do
 	$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz * f - 1)) 1" $testdir/file2 >> $seqres.full
 	$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz * f - 1)) 1" $testdir/file2.chk >> $seqres.full
@@ -91,7 +92,7 @@ done
 $XFS_IO_PROG -f -c "falloc 0 $filesize" $testdir/junk >> $seqres.full
 
 echo "CoW and leave leftovers"
-echo $old_cow_lifetime > /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime
+_xfs_set_cowgc_interval $old_cowgc_interval
 seq 2 2 $((nr - 1)) | while read f; do
 	$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz * f)) 1" $testdir/file2 >> $seqres.full
 	$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz * f)) 1" $testdir/file2.chk >> $seqres.full
diff --git a/tests/xfs/232 b/tests/xfs/232
index e56eb3aa..909f921c 100755
--- a/tests/xfs/232
+++ b/tests/xfs/232
@@ -23,9 +23,10 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 _cleanup()
 {
-    cd /
-    echo $old_cow_lifetime > /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime
-    rm -rf $tmp.*
+	cd /
+	test -n "$old_cowgc_interval" && \
+		_xfs_set_cowgc_interval $old_cowgc_interval
+	rm -rf $tmp.*
 }
 
 # get standard environment, filters and checks
@@ -41,7 +42,7 @@ _require_cp_reflink
 _require_xfs_io_command "falloc"
 _require_xfs_io_command "fiemap"
 
-old_cow_lifetime=$(cat /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime)
+old_cowgc_interval=$(_xfs_get_cowgc_interval)
 
 rm -f $seqres.full
 
@@ -75,7 +76,7 @@ md5sum $testdir/file2 | _filter_scratch
 md5sum $testdir/file2.chk | _filter_scratch
 
 echo "CoW and leave leftovers"
-echo 2 > /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime
+_xfs_set_cowgc_interval 2
 seq 2 2 $((nr - 1)) | while read f; do
 	$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz * f - 1)) 1" $testdir/file2 >> $seqres.full
 	$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz * f - 1)) 1" $testdir/file2.chk >> $seqres.full
@@ -93,7 +94,7 @@ done
 $XFS_IO_PROG -f -c "falloc 0 $filesize" $testdir/junk >> $seqres.full
 
 echo "CoW and leave leftovers"
-echo $old_cow_lifetime > /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime
+_xfs_set_cowgc_interval $old_cowgc_interval
 seq 2 2 $((nr - 1)) | while read f; do
 	$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz * f)) 1" $testdir/file2 >> $seqres.full
 	$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz * f)) 1" $testdir/file2.chk >> $seqres.full

