Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46FD9C4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Nov 2023 17:08:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbjKMRI3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Nov 2023 12:08:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjKMRI2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Nov 2023 12:08:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 969B5D79
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 09:08:25 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3640BC433C7;
        Mon, 13 Nov 2023 17:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699895305;
        bh=6p6IDF7EbsBNCPQYEBK0LS9TiLJXJ/OgrqjbKgDeb3s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Apccmbz95uP98Mye0uSzuZr0zyA/AaubaVa6Rl+Tccd01Za5WBqFFTc2VYQAJMzcB
         19f7fNu/n6Uq6vxNOW9hPSHwFinPn4AgX7bScZytnSrnhbiN9Au+BlAzE2hVANlJEm
         etkMHuxEi8ida5wKRMLvOTxMJBk2imInx4zivvp5gwBh/XXzqY1h2iGE91VnhGzmr+
         M2C27K+EUMRQgIW1Ej39z03jOVpuC1lvStCjrZMXq0LBt/t1biMf5giTCJWRYIPJIU
         KahPNjZz1Ulkf7jQUIlWGHD9S1NWIbOYO8VAFA6yxu4OfhT2m5i1llcXbG92uNTGSM
         6ni0RPCfwp+PA==
Subject: [PATCH 1/2] common: make helpers for ttyprintk usage
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 13 Nov 2023 09:08:24 -0800
Message-ID: <169989530470.1034375.951939793781814847.stgit@frogsfrogsfrogs>
In-Reply-To: <169989529888.1034375.6695143880673011270.stgit@frogsfrogsfrogs>
References: <169989529888.1034375.6695143880673011270.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

A handful of tests write things to /dev/ttyprintk to make it easier to
pinpoint where in a test something went wrong.  This isn't entirely
robust, however, because ttyprintk is an optional feature.  In the grand
tradition of kernel design there's also a /dev/kmsg that does nearly the
same thing, is also optional, and there's no documentation spelling out
when one is supposed to use one or the other.

So.

Create a pair of helpers to append messages to the kernel log.  One
simply writes its arguments to the kernel log, and the other writes
stdin to the kernel log, stdout, and any other files specified as
arguments.

Underneath the covers, both functions will send the message to
/dev/ttyprintk if available.  If it isn't but /dev/kmsg is, they'll
send the messages there, prepending a "[U]" to emulate the only
discernable difference between ttyprintk and kmsg.

If neither are available, then either /dev or the kernel aren't allowing
us to write to the kernel log, and the messages are not logged.  The
second helper will still write the messages to stdout.

If this seems like overengineered nonsense, then yes it is.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 common/fuzzy  |    4 ++--
 common/rc     |   32 ++++++++++++++++++++++++++++++++
 tests/xfs/329 |    4 ++--
 tests/xfs/434 |    2 +-
 tests/xfs/435 |    2 +-
 tests/xfs/436 |    2 +-
 tests/xfs/444 |    2 +-
 tests/xfs/516 |    2 +-
 8 files changed, 41 insertions(+), 9 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index 7228158034..f5d45cb28f 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -303,9 +303,9 @@ __scratch_xfs_fuzz_mdrestore()
 
 __fuzz_notify() {
 	echo '========================================'
-	echo "$@"
+	echo "$*"
 	echo '========================================'
-	test -w /dev/ttyprintk && echo "$@" >> /dev/ttyprintk
+	_kernlog "$*"
 }
 
 # Perform the online repair part of a fuzz test.
diff --git a/common/rc b/common/rc
index 259a1ffb09..7d10f8425e 100644
--- a/common/rc
+++ b/common/rc
@@ -4432,6 +4432,38 @@ _check_dmesg()
 	fi
 }
 
+# Log the arguments to the kernel log with userspace annotation, if possible.
+# Output is not sent to stdout.
+_kernlog()
+{
+	if [ -w /dev/ttyprintk ]; then
+		echo "$*" >> /dev/ttyprintk
+		return
+	fi
+
+	if [ -w /dev/kmsg ]; then
+		echo "[U] $*" >> /dev/kmsg
+		return
+	fi
+}
+
+# Convey stdin to the kernel log with userspace annotation, if possible.
+# Output will be appended to any file paths provided as arguments.
+_tee_kernlog()
+{
+	if [ -w /dev/ttyprintk ]; then
+		tee -a /dev/ttyprintk "$@"
+		return
+	fi
+
+	if [ -w /dev/kmsg ]; then
+		awk '{printf("[U] %s\n", $0) >> "/dev/kmsg"; printf("%s\n", $0);}' | tee -a "$@"
+		return
+	fi
+
+	tee -a "$@"
+}
+
 # Make whatever configuration changes we need ahead of testing fs shutdowns due
 # to unexpected IO errors while updating metadata.  The sole parameter should
 # be the fs device, e.g.  $SCRATCH_DEV.
diff --git a/tests/xfs/329 b/tests/xfs/329
index 15dc3c242f..12b7c60842 100755
--- a/tests/xfs/329
+++ b/tests/xfs/329
@@ -53,11 +53,11 @@ $XFS_FSR_PROG -v -d $testdir/file1 >> $seqres.full 2>&1
 echo "FS should be shut down, touch will fail"
 touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
 
-echo "Remount to replay log" | tee /dev/ttyprintk
+echo "Remount to replay log" | _tee_kernlog
 _scratch_remount_dump_log >> $seqres.full
 new_nextents=$(_count_extents $testdir/file1)
 
-echo "Check extent count" | tee /dev/ttyprintk
+echo "Check extent count" | _tee_kernlog
 $XFS_IO_PROG -c 'stat -v' $testdir/file1 >> $seqres.full
 $XFS_IO_PROG -c 'stat -v' $testdir/file2 >> $seqres.full
 echo "extents: $old_nextents -> $new_nextents" >> $seqres.full
diff --git a/tests/xfs/434 b/tests/xfs/434
index de52531053..12d1a0c9da 100755
--- a/tests/xfs/434
+++ b/tests/xfs/434
@@ -65,7 +65,7 @@ $XFS_FSR_PROG -v -d $testdir/file1 >> $seqres.full 2>&1
 echo "FS should be shut down, touch will fail"
 touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
 
-echo "Remount to replay log" | tee /dev/ttyprintk
+echo "Remount to replay log" | _tee_kernlog
 _scratch_unmount
 _scratch_dump_log >> $seqres.full
 _scratch_xfs_db -x -c 'agf 0' -c 'addr refcntroot' -c 'fuzz -d recs[1].startblock ones' >> $seqres.full
diff --git a/tests/xfs/435 b/tests/xfs/435
index ded942a128..44135c7653 100755
--- a/tests/xfs/435
+++ b/tests/xfs/435
@@ -46,7 +46,7 @@ _pwrite_byte 0x62 0 $((blksz * blks)) $testdir/file1 >> $seqres.full
 _pwrite_byte 0x63 0 $blksz $testdir/file2 >> $seqres.full
 _reflink_range $testdir/file2 0 $testdir/file1 $blksz $blksz >> $seqres.full
 
-echo "Remount to check recovery" | tee /dev/ttyprintk
+echo "Remount to check recovery" | _tee_kernlog
 _scratch_unmount
 _scratch_xfs_db -x -c 'agf 0' -c 'addr refcntroot' -c 'fuzz -d recs[1].startblock ones' >> $seqres.full
 _scratch_xfs_db -x -c 'agf 0' -c 'addr refcntroot' -c p >> $seqres.full
diff --git a/tests/xfs/436 b/tests/xfs/436
index b95da8abf4..d010362785 100755
--- a/tests/xfs/436
+++ b/tests/xfs/436
@@ -62,7 +62,7 @@ $XFS_FSR_PROG -v -d $testdir/file1 >> $seqres.full 2>&1
 echo "FS should be shut down, touch will fail"
 touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
 
-echo "Remount to replay log" | tee /dev/ttyprintk
+echo "Remount to replay log" | _tee_kernlog
 _scratch_unmount
 _scratch_dump_log >> $seqres.full
 _scratch_xfs_db -x -c 'agf 0' -c 'addr refcntroot' -c 'fuzz -d recs[1].startblock ones' >> $seqres.full
diff --git a/tests/xfs/444 b/tests/xfs/444
index 8f06d73259..db7418c55d 100755
--- a/tests/xfs/444
+++ b/tests/xfs/444
@@ -62,7 +62,7 @@ runtest() {
 	cmd="$1"
 
 	# Format filesystem
-	echo "TEST $cmd" | tee /dev/ttyprintk
+	echo "TEST $cmd" | _tee_kernlog
 	echo "TEST $cmd" >> $seqres.full
 	_scratch_mkfs >> $seqres.full
 
diff --git a/tests/xfs/516 b/tests/xfs/516
index 9e1b993174..1bf6f858d5 100755
--- a/tests/xfs/516
+++ b/tests/xfs/516
@@ -31,7 +31,7 @@ _supports_xfs_scrub $TEST_DIR $TEST_DEV && run_scrub=1
 
 log()
 {
-	echo "$@" | tee -a $seqres.full /dev/ttyprintk
+	echo "$*" | _tee_kernlog $seqres.full
 }
 
 __test_mount_opts()

