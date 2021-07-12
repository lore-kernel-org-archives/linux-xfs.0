Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 763FFC07E9C
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jul 2021 11:13:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6052A61152
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jul 2021 11:13:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234272AbhGLLQB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jul 2021 07:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234262AbhGLLQA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jul 2021 07:16:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8980AC0613DD;
        Mon, 12 Jul 2021 04:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=SKx/k8h0UhNtZSTjHvFoBuK2uLppCQfMzMqbe1klMRU=; b=L0pFvxtkO4kq3L0X2xEGqS71Zs
        qpYcyMd9x9r4J2AqOL/Hyu7uI8F1O2yyxpI2+9iOcF9M13qcq+ZcDPhTPr72MHJ50YeBEcZrGEHUu
        5pzI86iMxYkIMASKh/klpmofqU9JNaN9aRvEqnEWAUXA7u0S65nfHQqzNjiQbBT/+1YmLW2lv5u7g
        0Y+UuVbBG9bXli8DpvbSBuC96dMrllPYfJnLKLZV5xlAODldKC9Kbg1z3p4VIE21HVb+l/hzfZdVZ
        7/WkhIzjrKU+QNGXbIAd76dmV3YKSvxuI/b9HX4pkrryAa/d/iZII5LgO1fJlZLw91NaHm9CAR9xq
        e57PBF9w==;
Received: from [2001:4bb8:184:8b7c:bd9:61b8:39ba:d78a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2trm-00HXGU-FQ; Mon, 12 Jul 2021 11:12:54 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/6] xfs/106: don't test disabling quota accounting
Date:   Mon, 12 Jul 2021 13:11:43 +0200
Message-Id: <20210712111146.82734-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210712111146.82734-1-hch@lst.de>
References: <20210712111146.82734-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Switch the test that removes the quota files to just disable
enforcement and then unmount the file system as disabling quota
accounting is about to go away.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/106     | 45 ++++++++++++++++++-------------------
 tests/xfs/106.out | 57 +++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 70 insertions(+), 32 deletions(-)

diff --git a/tests/xfs/106 b/tests/xfs/106
index f1397f94..5f0512d6 100755
--- a/tests/xfs/106
+++ b/tests/xfs/106
@@ -153,13 +153,6 @@ test_enable()
 			-c "enable -$type -v" $SCRATCH_MNT | filter_state
 }
 
-test_off()
-{
-	echo "checking off command (type=$type)"
-	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
-			-c "off -$type -v" $SCRATCH_MNT | _filter_scratch
-}
-
 test_remove()
 {
 	echo "checking remove command (type=$type)"
@@ -194,6 +187,15 @@ test_restore()
 
 test_xfs_quota()
 {
+	_qmount_option $1
+	_qmount
+
+	if [ $type == "p" ]; then
+		_require_prjquota $SCRATCH_DEV
+		$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
+			-c "project -s $id" $SCRATCH_MNT > /dev/null
+	fi
+
 	# init quota
 	echo "init quota limit and timer, and dump it"
 	echo "create_files 1024k 15"; create_files 1024k 15
@@ -236,14 +238,21 @@ test_xfs_quota()
 	echo ; test_report -N
 
 	# off and remove test
-	echo "off and remove test"
+	echo "disable and remove test"
 	echo ; test_limit 100m 100m 100 100
 	echo ; test_quota -N
-	echo ; test_off
+	echo ; test_disable
 	echo ; test_state
+	_scratch_unmount
+	_qmount_option ""
+	_qmount
 	echo ; test_remove
 	echo ; test_report -N
-	echo "quota remount"; _qmount
+	_scratch_unmount
+
+	echo "quota remount";
+	_qmount_option $1
+	_qmount
 	echo ; test_report -N
 
 	# restore test
@@ -255,33 +264,23 @@ test_xfs_quota()
 }
 
 echo "----------------------- uquota,sync ---------------------------"
-_qmount_option "uquota,sync"
-_qmount
 type=u
 id=$uqid
-test_xfs_quota
+test_xfs_quota "uquota,sync"
 
 echo "----------------------- gquota,sync ---------------------------"
-_qmount_option "gquota,sync"
-_qmount
 type=g
 id=$gqid
-test_xfs_quota
+test_xfs_quota "gquota,sync"
 
 echo "----------------------- pquota,sync ---------------------------"
 # Need to clean the group quota before test project quota, because
 # V4 xfs doesn't support separate project inode. So mkfs at here.
 _scratch_unmount
 _scratch_mkfs_xfs >>$seqres.full 2>&1
-_qmount_option "pquota,sync"
-_qmount
 type=p
 id=$pqid
-_require_prjquota $SCRATCH_DEV
-$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
-		-c "project -s $id" \
-		$SCRATCH_MNT > /dev/null
-test_xfs_quota
+test_xfs_quota "pquota,sync"
 
 _scratch_unmount
 # success, all done
diff --git a/tests/xfs/106.out b/tests/xfs/106.out
index e36375d3..2af17bc9 100644
--- a/tests/xfs/106.out
+++ b/tests/xfs/106.out
@@ -124,17 +124,30 @@ Realtime Blocks grace time: [7 days]
 checking report command (type=u)
 fsgqa 1024 512 2048 00 [3 days] 15 10 20 00 [3 days]
 
-off and remove test
+disable and remove test
 
 checking limit command (type=u, bsoft=100m, bhard=100m, isoft=100, ihard=100)
 
 checking quota command (type=u)
 SCRATCH_DEV 1024 102400 102400 00 [--------] 15 100 100 00 [--------] SCRATCH_MNT
 
-checking off command (type=u)
-User quota are not enabled on SCRATCH_DEV
+checking disable command (type=u)
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+ Accounting: ON
+ Enforcement: OFF
+ Inode: #[INO] (X blocks, Y extents)
+Blocks grace time: [3 days]
+Inodes grace time: [3 days]
+Realtime Blocks grace time: [7 days]
 
 checking state command (type=u)
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+ Accounting: ON
+ Enforcement: OFF
+ Inode: #[INO] (X blocks, Y extents)
+Blocks grace time: [3 days]
+Inodes grace time: [3 days]
+Realtime Blocks grace time: [7 days]
 
 checking remove command (type=u)
 User quota are not enabled on SCRATCH_DEV
@@ -288,17 +301,30 @@ Realtime Blocks grace time: [7 days]
 checking report command (type=g)
 fsgqa 1024 512 2048 00 [3 days] 15 10 20 00 [3 days]
 
-off and remove test
+disable and remove test
 
 checking limit command (type=g, bsoft=100m, bhard=100m, isoft=100, ihard=100)
 
 checking quota command (type=g)
 SCRATCH_DEV 1024 102400 102400 00 [--------] 15 100 100 00 [--------] SCRATCH_MNT
 
-checking off command (type=g)
-Group quota are not enabled on SCRATCH_DEV
+checking disable command (type=g)
+Group quota state on SCRATCH_MNT (SCRATCH_DEV)
+ Accounting: ON
+ Enforcement: OFF
+ Inode: #[INO] (X blocks, Y extents)
+Blocks grace time: [3 days]
+Inodes grace time: [3 days]
+Realtime Blocks grace time: [7 days]
 
 checking state command (type=g)
+Group quota state on SCRATCH_MNT (SCRATCH_DEV)
+ Accounting: ON
+ Enforcement: OFF
+ Inode: #[INO] (X blocks, Y extents)
+Blocks grace time: [3 days]
+Inodes grace time: [3 days]
+Realtime Blocks grace time: [7 days]
 
 checking remove command (type=g)
 Group quota are not enabled on SCRATCH_DEV
@@ -452,17 +478,30 @@ Realtime Blocks grace time: [7 days]
 checking report command (type=p)
 fsgqa 1024 512 2048 00 [3 days] 15 10 20 00 [3 days]
 
-off and remove test
+disable and remove test
 
 checking limit command (type=p, bsoft=100m, bhard=100m, isoft=100, ihard=100)
 
 checking quota command (type=p)
 SCRATCH_DEV 1024 102400 102400 00 [--------] 15 100 100 00 [--------] SCRATCH_MNT
 
-checking off command (type=p)
-Project quota are not enabled on SCRATCH_DEV
+checking disable command (type=p)
+Project quota state on SCRATCH_MNT (SCRATCH_DEV)
+ Accounting: ON
+ Enforcement: OFF
+ Inode: #[INO] (X blocks, Y extents)
+Blocks grace time: [3 days]
+Inodes grace time: [3 days]
+Realtime Blocks grace time: [7 days]
 
 checking state command (type=p)
+Project quota state on SCRATCH_MNT (SCRATCH_DEV)
+ Accounting: ON
+ Enforcement: OFF
+ Inode: #[INO] (X blocks, Y extents)
+Blocks grace time: [3 days]
+Inodes grace time: [3 days]
+Realtime Blocks grace time: [7 days]
 
 checking remove command (type=p)
 Project quota are not enabled on SCRATCH_DEV
-- 
2.30.2

