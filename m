Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2D4CC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jan 2022 21:50:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245501AbiAKVuc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jan 2022 16:50:32 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43000 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245510AbiAKVub (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jan 2022 16:50:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AA77617BB;
        Tue, 11 Jan 2022 21:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08A2C36AE3;
        Tue, 11 Jan 2022 21:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641937830;
        bh=cgrcmsN3xn8OYdW9Utr7c6frv7Qf4ER3N8cLlYqmuS8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=t0ZqNj7kNnYlAVzL6DnPM9Rn8iitpzmWyAze60Yf6lYiPPdsKVoaFEgeULfSy/1ji
         IqXvIpFNtgIgLqof7S8LMX1ggOe2nzQQogGTo+1NxRyvoWFLPEt8PlX3rZa7hIwnMP
         tVPQHEPeUiG3hTUGV6pPGXwLNrURrKRSsmnQYVld0qmGj2CSMuRVUS4wZMQZh8ufS5
         hn+LU6/2kSt3wIOC3b/uLcpQorSHy8ljaW303AyIBSfVdDpiEJk+j7cNvlNIIVoUA9
         lCOzeOgPjE7miFnrE/ipnGZ9Ixc6xEoiXOQbx+prSiEezMqyF1GyD12JukEI4KLutZ
         rrFr2kx8ksF7w==
Subject: [PATCH 4/8] xfs: test fixes for new 5.17 behaviors
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 11 Jan 2022 13:50:30 -0800
Message-ID: <164193783042.3008286.2591850180591285713.stgit@magnolia>
In-Reply-To: <164193780808.3008286.598879710489501860.stgit@magnolia>
References: <164193780808.3008286.598879710489501860.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

xfs/308 and xfs/130 are two tests that tried to mess with the refcount
btree to try to trip up the COW recovery code.  Now that we've made COW
recovery only happen during log recovery, we must adjust these tests to
force a log recovery.  Older kernels should be ok with this, since they
unconditionally try to recover COW on mount.

Add a helper function to unmount the filesystem with a dirty log and
convert the two tests to use it.  While we're at it, remove an xfs_check
test because xfs_check refuses to run on a dirty fs, and nobody cares
about xfs_check anymore.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs        |   12 ++++++++++++
 tests/xfs/130     |    6 +++++-
 tests/xfs/130.out |    1 +
 tests/xfs/308     |    5 +----
 tests/xfs/308.out |    2 --
 5 files changed, 19 insertions(+), 7 deletions(-)


diff --git a/common/xfs b/common/xfs
index bfb1bf1e..713e9fe7 100644
--- a/common/xfs
+++ b/common/xfs
@@ -776,6 +776,18 @@ _reset_xfs_sysfs_error_handling()
 	done
 }
 
+# Unmount an XFS with a dirty log
+_scratch_xfs_unmount_dirty()
+{
+	local f="$SCRATCH_MNT/.dirty_umount"
+
+	rm -f "$f"
+	echo "test" > "$f"
+	sync
+	_scratch_shutdown
+	_scratch_unmount
+}
+
 # Skip if we are running an older binary without the stricter input checks.
 # Make multiple checks to be sure that there is no regression on the one
 # selected feature check, which would skew the result.
diff --git a/tests/xfs/130 b/tests/xfs/130
index 0eb7d9c0..9465cbb0 100755
--- a/tests/xfs/130
+++ b/tests/xfs/130
@@ -44,12 +44,16 @@ _pwrite_byte 0x62 0 $((blksz * 64)) "${SCRATCH_MNT}/file0" >> "$seqres.full"
 _pwrite_byte 0x61 0 $((blksz * 64)) "${SCRATCH_MNT}/file1" >> "$seqres.full"
 _cp_reflink "${SCRATCH_MNT}/file0" "${SCRATCH_MNT}/file2"
 _cp_reflink "${SCRATCH_MNT}/file1" "${SCRATCH_MNT}/file3"
-umount "${SCRATCH_MNT}"
+_scratch_unmount
 
 echo "+ check fs"
 _scratch_xfs_repair -n >> "$seqres.full" 2>&1 || \
 	_fail "xfs_repair should not fail"
 
+echo "+ force log recovery"
+_scratch_mount
+_scratch_xfs_unmount_dirty
+
 echo "+ corrupt image"
 seq 0 $((agcount - 1)) | while read ag; do
 	_scratch_xfs_db -x -c "agf ${ag}" -c "agf ${ag}" -c "addr refcntroot" \
diff --git a/tests/xfs/130.out b/tests/xfs/130.out
index a0eab987..6ca21ad6 100644
--- a/tests/xfs/130.out
+++ b/tests/xfs/130.out
@@ -3,6 +3,7 @@ QA output created by 130
 + mount fs image
 + make some files
 + check fs
++ force log recovery
 + corrupt image
 + mount image
 + repair fs
diff --git a/tests/xfs/308 b/tests/xfs/308
index de5ee5c1..d0f47f50 100755
--- a/tests/xfs/308
+++ b/tests/xfs/308
@@ -23,7 +23,7 @@ echo "Format"
 _scratch_mkfs > $seqres.full 2>&1
 _scratch_mount >> $seqres.full
 is_rmap=$($XFS_INFO_PROG $SCRATCH_MNT | grep -c "rmapbt=1")
-_scratch_unmount
+_scratch_xfs_unmount_dirty
 
 _get_agf_data() {
 	field="$1"
@@ -121,9 +121,6 @@ fi
 
 _dump_status "broken fs config" >> $seqres.full
 
-echo "Look for leftover warning in xfs_check"
-_scratch_xfs_check | _filter_leftover
-
 echo "Look for leftover warning in xfs_repair"
 _scratch_xfs_repair -n 2>&1 | _filter_leftover
 
diff --git a/tests/xfs/308.out b/tests/xfs/308.out
index bea1de81..383cd07e 100644
--- a/tests/xfs/308.out
+++ b/tests/xfs/308.out
@@ -4,8 +4,6 @@ We need AG1 to have a single free extent
 Find our extent and old counter values
 Remove the extent from the freesp btrees
 Add the extent to the refcount btree
-Look for leftover warning in xfs_check
-leftover CoW extent (NR/NR) len NR
 Look for leftover warning in xfs_repair
 leftover CoW extent (NR/NR) len NR
 Mount filesystem

