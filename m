Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E28C2F23;
	Sat, 17 Aug 2024 06:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723877452; cv=none; b=rUkZCWOmY+wCDTzvWHwOWY8Rh4t/8/t/NYmb8GLHCcegTls2+bgqdVHQ6R+yBcXeeBK/3UVMaUVgekqO4AL2G1i530IkukNDm8QwJ4NVYjM+bWHpSPBtM1gGiCy/A7A+G1dfXQlQHv3fHPVZv3wgUJ81Dua2ovwSyVhlCqC1doA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723877452; c=relaxed/simple;
	bh=vEC/k3f/izlv8Lu9Ht6GI/1ZAX3WaNtFd0MYnBUW0EM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P4R8jNpD+R/tbV5reLqKpS8ny+9FuOLbE1Poz5zd0GvC+2mnMkwy44CTvc8fCcqSIYRVwHCQP2EdofVdlqC6AgJ7jHfeQZ6xMaodSPb6LrXOHGiGhTh0nimQnorZVcixNkjYDXGHNoqpc1TiqkhwxFIljCW+Kantu+ScbIQhYik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 053fcc785c6511efa216b1d71e6e1362-20240817
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN, HR_SJ_LANG
	HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN
	HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME, IP_UNTRUSTED
	SRC_UNTRUSTED, IP_LOWREP, SRC_LOWREP, DN_TRUSTED, SRC_TRUSTED
	SA_UNTRUSTED, SA_UNFAMILIAR, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_T1, AMN_GOOD, AMN_C_TI, AMN_C_BU
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:6e80485d-4ca5-42b3-8bc1-0729d7dc5c1d,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.1.38,REQID:6e80485d-4ca5-42b3-8bc1-0729d7dc5c1d,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:82c5f88,CLOUDID:0f84854488b00209a74079bda75d970a,BulkI
	D:2408171429134FIR45HT,BulkQuantity:1,Recheck:0,SF:43|74|66|23|17|19|102,T
	C:nil,Content:0,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,
	COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-UUID: 053fcc785c6511efa216b1d71e6e1362-20240817
X-User: liuhuan01@kylinos.cn
Received: from localhost.localdomain [(123.149.3.232)] by mailgw.kylinos.cn
	(envelope-from <liuhuan01@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 75004969; Sat, 17 Aug 2024 14:50:42 +0800
From: liuhuan01@kylinos.cn
To: djwong@kernel.org
Cc: dchinner@redhat.com,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org,
	liuhuan01@kylinos.cn
Subject: [PATCH] xfs: use FICLONE/FICLONERANGE/FIDEDUPERANGE for test cases
Date: Sat, 17 Aug 2024 14:50:27 +0800
Message-Id: <20240817065027.14459-1-liuhuan01@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240809150455.GV6051@frogsfrogsfrogs>
References: <20240809150455.GV6051@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: liuh <liuhuan01@kylinos.cn>

With the patch "xfs_io: use FICLONE/FICLONERANGE/FIDEDUPERANGE for reflink/dedupe IO commands", and modify relevant test cases.

Signed-off-by: liuh <liuhuan01@kylinos.cn>
---
 common/reflink        |  2 +-
 tests/generic/122.out |  2 +-
 tests/generic/136.out |  2 +-
 tests/generic/157.out | 18 +++++++++---------
 tests/generic/158.out | 20 ++++++++++----------
 tests/generic/303.out |  8 ++++----
 tests/generic/304.out | 14 +++++++-------
 tests/generic/493.out |  4 ++--
 tests/generic/516.out |  2 +-
 tests/generic/518.out |  2 +-
 tests/xfs/319.out     |  2 +-
 tests/xfs/321.out     |  2 +-
 tests/xfs/322.out     |  2 +-
 tests/xfs/323.out     |  2 +-
 14 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/common/reflink b/common/reflink
index 22adc444..21df20e2 100644
--- a/common/reflink
+++ b/common/reflink
@@ -261,7 +261,7 @@ _dedupe_range() {
 # Unify xfs_io dedupe ioctl error message prefix
 _filter_dedupe_error()
 {
-	sed -e 's/^dedupe:/XFS_IOC_FILE_EXTENT_SAME:/g'
+	sed -e 's/^dedupe:/FIDEDUPERANGE:/g'
 }
 
 # Create a file of interleaved unwritten and reflinked blocks
diff --git a/tests/generic/122.out b/tests/generic/122.out
index 4459985c..f243d153 100644
--- a/tests/generic/122.out
+++ b/tests/generic/122.out
@@ -4,7 +4,7 @@ Create the original files
 5e3501f97fd2669babfcbd3e1972e833  TEST_DIR/test-122/file2
 Files 1-2 do not match (intentional)
 (Fail to) dedupe the middle blocks together
-XFS_IOC_FILE_EXTENT_SAME: Extents did not match.
+FIDEDUPERANGE: Extents did not match.
 Compare sections
 35ac8d7917305c385c30f3d82c30a8f6  TEST_DIR/test-122/file1
 5e3501f97fd2669babfcbd3e1972e833  TEST_DIR/test-122/file2
diff --git a/tests/generic/136.out b/tests/generic/136.out
index 508953f6..eee44f07 100644
--- a/tests/generic/136.out
+++ b/tests/generic/136.out
@@ -7,7 +7,7 @@ c4fd505be25a0c91bcca9f502b9a8156  TEST_DIR/test-136/file2
 Dedupe the last blocks together
 1->2
 1->3
-XFS_IOC_FILE_EXTENT_SAME: Extents did not match.
+FIDEDUPERANGE: Extents did not match.
 c4fd505be25a0c91bcca9f502b9a8156  TEST_DIR/test-136/file1
 c4fd505be25a0c91bcca9f502b9a8156  TEST_DIR/test-136/file2
 07ac67bf7f271195442509e79cde4cee  TEST_DIR/test-136/file3
diff --git a/tests/generic/157.out b/tests/generic/157.out
index d4f64b44..0ef12f80 100644
--- a/tests/generic/157.out
+++ b/tests/generic/157.out
@@ -2,23 +2,23 @@ QA output created by 157
 Format and mount
 Create the original files
 Try cross-device reflink
-XFS_IOC_CLONE_RANGE: Invalid cross-device link
+FICLONERANGE: Invalid cross-device link
 Try unaligned reflink
-XFS_IOC_CLONE_RANGE: Invalid argument
+FICLONERANGE: Invalid argument
 Try overlapping reflink
-XFS_IOC_CLONE_RANGE: Invalid argument
+FICLONERANGE: Invalid argument
 Try reflink past EOF
-XFS_IOC_CLONE_RANGE: Invalid argument
+FICLONERANGE: Invalid argument
 Try to reflink a dir
-XFS_IOC_CLONE_RANGE: Is a directory
+FICLONERANGE: Is a directory
 Try to reflink a device
-XFS_IOC_CLONE_RANGE: Invalid argument
+FICLONERANGE: Invalid argument
 Try to reflink to a dir
 TEST_DIR/test-157/dir1: Is a directory
 Try to reflink to a device
-XFS_IOC_CLONE_RANGE: Invalid argument
+FICLONERANGE: Invalid argument
 Try to reflink to a fifo
-XFS_IOC_CLONE_RANGE: Invalid argument
+FICLONERANGE: Invalid argument
 Try to reflink an append-only file
-XFS_IOC_CLONE_RANGE: Bad file descriptor
+FICLONERANGE: Bad file descriptor
 Reflink two files
diff --git a/tests/generic/158.out b/tests/generic/158.out
index 8df9d9a5..2b304820 100644
--- a/tests/generic/158.out
+++ b/tests/generic/158.out
@@ -2,26 +2,26 @@ QA output created by 158
 Format and mount
 Create the original files
 Try cross-device dedupe
-XFS_IOC_FILE_EXTENT_SAME: Invalid cross-device link
+FIDEDUPERANGE: Invalid cross-device link
 Try unaligned dedupe
-XFS_IOC_FILE_EXTENT_SAME: Invalid argument
+FIDEDUPERANGE: Invalid argument
 Try overlapping dedupe
-XFS_IOC_FILE_EXTENT_SAME: Invalid argument
+FIDEDUPERANGE: Invalid argument
 Try dedupe from past EOF
-XFS_IOC_FILE_EXTENT_SAME: Invalid argument
+FIDEDUPERANGE: Invalid argument
 Try dedupe to past EOF, destination offset beyond EOF
-XFS_IOC_FILE_EXTENT_SAME: Invalid argument
+FIDEDUPERANGE: Invalid argument
 Try dedupe to past EOF, destination offset behind EOF
-XFS_IOC_FILE_EXTENT_SAME: Invalid argument
+FIDEDUPERANGE: Invalid argument
 Try to dedupe a dir
-XFS_IOC_FILE_EXTENT_SAME: Is a directory
+FIDEDUPERANGE: Is a directory
 Try to dedupe a device
-XFS_IOC_FILE_EXTENT_SAME: Invalid argument
+FIDEDUPERANGE: Invalid argument
 Try to dedupe to a dir
 TEST_DIR/test-158/dir1: Is a directory
 Try to dedupe to a device
-XFS_IOC_FILE_EXTENT_SAME: Invalid argument
+FIDEDUPERANGE: Invalid argument
 Try to dedupe to a fifo
-XFS_IOC_FILE_EXTENT_SAME: Invalid argument
+FIDEDUPERANGE: Invalid argument
 Try to dedupe an append-only file
 Dedupe two files
diff --git a/tests/generic/303.out b/tests/generic/303.out
index 39a88038..256ef66f 100644
--- a/tests/generic/303.out
+++ b/tests/generic/303.out
@@ -4,14 +4,14 @@ Create the original files
 Reflink large single byte file
 Reflink large empty file
 Reflink past maximum file size in dest file (should fail)
-XFS_IOC_CLONE_RANGE: Invalid argument
+FICLONERANGE: Invalid argument
 Reflink high offset to low offset
 Reflink past source file EOF (should fail)
-XFS_IOC_CLONE_RANGE: Invalid argument
+FICLONERANGE: Invalid argument
 Reflink max size at nonzero offset (should fail)
-XFS_IOC_CLONE_RANGE: Invalid argument
+FICLONERANGE: Invalid argument
 Reflink with huge off/len (should fail)
-XFS_IOC_CLONE_RANGE: Invalid argument
+FICLONERANGE: Invalid argument
 Check file creation
 file3
 7ffffffffffffffe:  61  a
diff --git a/tests/generic/304.out b/tests/generic/304.out
index a979099b..d43dd70c 100644
--- a/tests/generic/304.out
+++ b/tests/generic/304.out
@@ -2,19 +2,19 @@ QA output created by 304
 Format and mount
 Create the original files
 Dedupe large single byte file
-XFS_IOC_FILE_EXTENT_SAME: Invalid argument
+FIDEDUPERANGE: Invalid argument
 Dedupe large empty file
-XFS_IOC_FILE_EXTENT_SAME: Invalid argument
+FIDEDUPERANGE: Invalid argument
 Dedupe past maximum file size in dest file (should fail)
-XFS_IOC_FILE_EXTENT_SAME: Invalid argument
+FIDEDUPERANGE: Invalid argument
 Dedupe high offset to low offset
-XFS_IOC_FILE_EXTENT_SAME: Invalid argument
+FIDEDUPERANGE: Invalid argument
 Dedupe past source file EOF (should fail)
-XFS_IOC_FILE_EXTENT_SAME: Invalid argument
+FIDEDUPERANGE: Invalid argument
 Dedupe max size at nonzero offset (should fail)
-XFS_IOC_FILE_EXTENT_SAME: Invalid argument
+FIDEDUPERANGE: Invalid argument
 Dedupe with huge off/len (should fail)
-XFS_IOC_FILE_EXTENT_SAME: Invalid argument
+FIDEDUPERANGE: Invalid argument
 Check file creation
 file3
 7ffffffffffffffe:  61  a
diff --git a/tests/generic/493.out b/tests/generic/493.out
index d3426ee6..8bb71d3b 100644
--- a/tests/generic/493.out
+++ b/tests/generic/493.out
@@ -2,6 +2,6 @@ QA output created by 493
 Format and mount
 Initialize file
 Try to dedupe
-XFS_IOC_FILE_EXTENT_SAME: Text file busy
-XFS_IOC_FILE_EXTENT_SAME: Text file busy
+FIDEDUPERANGE: Text file busy
+FIDEDUPERANGE: Text file busy
 Tear it down
diff --git a/tests/generic/516.out b/tests/generic/516.out
index 90308c49..53611b3b 100644
--- a/tests/generic/516.out
+++ b/tests/generic/516.out
@@ -4,7 +4,7 @@ Create the original files
 39578c21e2cb9f6049b1cf7fc7be12a6  TEST_DIR/test-516/file2
 Files 1-2 do not match (intentional)
 (partial) dedupe the middle blocks together
-XFS_IOC_FILE_EXTENT_SAME: Extents did not match.
+FIDEDUPERANGE: Extents did not match.
 Compare sections
 35ac8d7917305c385c30f3d82c30a8f6  TEST_DIR/test-516/file1
 39578c21e2cb9f6049b1cf7fc7be12a6  TEST_DIR/test-516/file2
diff --git a/tests/generic/518.out b/tests/generic/518.out
index 726c2073..57ae9155 100644
--- a/tests/generic/518.out
+++ b/tests/generic/518.out
@@ -3,7 +3,7 @@ wrote 262244/262244 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 wrote 1048576/1048576 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-XFS_IOC_CLONE_RANGE: Invalid argument
+FICLONERANGE: Invalid argument
 File content after failed reflink:
 0000000 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5 b5
 *
diff --git a/tests/xfs/319.out b/tests/xfs/319.out
index 160f5fd2..25f1ed2e 100644
--- a/tests/xfs/319.out
+++ b/tests/xfs/319.out
@@ -7,7 +7,7 @@ Check files
 4155b81ac6d45c0182fa2bc03960f230  SCRATCH_MNT/file3
 Inject error
 Try to reflink
-XFS_IOC_CLONE_RANGE: Input/output error
+FICLONERANGE: Input/output error
 FS should be shut down, touch will fail
 touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
 Remount to replay log
diff --git a/tests/xfs/321.out b/tests/xfs/321.out
index c0abd52b..59fd7b7b 100644
--- a/tests/xfs/321.out
+++ b/tests/xfs/321.out
@@ -6,7 +6,7 @@ Check files
 b5cfa9d6c8febd618f91ac2843d50a1c  SCRATCH_MNT/file3
 Inject error
 Try to reflink
-XFS_IOC_CLONE_RANGE: Input/output error
+FICLONERANGE: Input/output error
 FS should be shut down, touch will fail
 touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
 Remount to replay log
diff --git a/tests/xfs/322.out b/tests/xfs/322.out
index b3fba5d0..695dd48b 100644
--- a/tests/xfs/322.out
+++ b/tests/xfs/322.out
@@ -6,7 +6,7 @@ Check files
 b5cfa9d6c8febd618f91ac2843d50a1c  SCRATCH_MNT/file3
 Inject error
 Try to reflink
-XFS_IOC_CLONE_RANGE: Input/output error
+FICLONERANGE: Input/output error
 FS should be shut down, touch will fail
 touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
 Remount to replay log
diff --git a/tests/xfs/323.out b/tests/xfs/323.out
index 99b9688c..f7f36c05 100644
--- a/tests/xfs/323.out
+++ b/tests/xfs/323.out
@@ -6,7 +6,7 @@ Check files
 4155b81ac6d45c0182fa2bc03960f230  SCRATCH_MNT/file3
 Inject error
 Try to reflink
-XFS_IOC_CLONE_RANGE: Input/output error
+FICLONERANGE: Input/output error
 FS should be shut down, touch will fail
 touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
 Remount to replay log
-- 
2.43.0

