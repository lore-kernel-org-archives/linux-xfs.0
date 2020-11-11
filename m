Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89754C55ABD
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:45:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38750221E9
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:45:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QEVdO8it"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732432AbgKKApo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 19:45:44 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48998 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731234AbgKKApo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 19:45:44 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0XmXW110516;
        Wed, 11 Nov 2020 00:45:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=5fcN2c6x1qnJaONISOZWck2J1DwRXoh1U4OLT3bUnLw=;
 b=QEVdO8itcVedVEbiwTpagC5WLKA2CkXOLb4Zh0fe2v52Gb7m4TdqyTpB3leuAP4+1F/S
 +B2d/O3sMIVZq7JWACgvdE9av1B+yeaOnCjTdRHaM7//H07waGcVQlwe9VdUUEEFPhPa
 oFRVwJRCZ+UKJoJxtCqqN77yYNOd5kn8iQ+VNc/YDvez1qRuH6R7ckzycWxBvyqRNHoI
 u+XhDxlLYF7zoC+P/qMjFsLOBcd40hB+A0LLAopXsiayIPslbj9lfkXcP/ZEvSk1bffB
 wYT1wxgeff/r2yUqztKAnNKqHD2VWDNdTAniMfwiX0OKyFFrt/XaReCz4nR0oi0zeuux TQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34nkhkxnqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 00:45:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0VEuH095476;
        Wed, 11 Nov 2020 00:43:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 34p55pattn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 00:43:42 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AB0heqm028935;
        Wed, 11 Nov 2020 00:43:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 16:43:40 -0800
Subject: [PATCH 5/6] misc: fix _get_file_block_size usage
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 10 Nov 2020 16:43:39 -0800
Message-ID: <160505541965.1388647.5276414050359284933.stgit@magnolia>
In-Reply-To: <160505537312.1388647.14788379902518687395.stgit@magnolia>
References: <160505537312.1388647.14788379902518687395.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix these tests that rely on the allocation unit size of a file, which
might not necessarily be the fs block size.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/157 |    2 +-
 tests/generic/175 |    2 +-
 tests/xfs/129     |    2 +-
 tests/xfs/169     |    2 +-
 tests/xfs/208     |    2 +-
 tests/xfs/336     |    2 +-
 tests/xfs/344     |    2 +-
 tests/xfs/345     |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)


diff --git a/tests/generic/157 b/tests/generic/157
index 5ec8999e..379c38b9 100755
--- a/tests/generic/157
+++ b/tests/generic/157
@@ -46,7 +46,7 @@ testdir2=$SCRATCH_MNT/test-$seq
 mkdir $testdir2
 
 echo "Create the original files"
-blksz="$(_get_block_size $testdir1)"
+blksz="$(_get_file_block_size $testdir1)"
 blks=1000
 margin='7%'
 sz=$((blksz * blks))
diff --git a/tests/generic/175 b/tests/generic/175
index f1b73522..436d2cca 100755
--- a/tests/generic/175
+++ b/tests/generic/175
@@ -41,7 +41,7 @@ testdir="$SCRATCH_MNT/test-$seq"
 mkdir "$testdir"
 
 echo "Create a one block file"
-blksz="$(_get_block_size $testdir)"
+blksz="$(_get_file_block_size $testdir)"
 _pwrite_byte 0x61 0 $blksz "$testdir/file1" >> "$seqres.full"
 
 fnr=19
diff --git a/tests/xfs/129 b/tests/xfs/129
index 5e348805..78baf5c4 100755
--- a/tests/xfs/129
+++ b/tests/xfs/129
@@ -44,7 +44,7 @@ mkdir $testdir
 metadump_file=$TEST_DIR/${seq}_metadump
 
 echo "Create the original file blocks"
-blksz="$(_get_block_size $testdir)"
+blksz="$(_get_file_block_size $testdir)"
 nr_blks=$((4 * blksz / 12))
 _pwrite_byte 0x61 0 $((blksz * nr_blks)) $testdir/file1 >> $seqres.full
 
diff --git a/tests/xfs/169 b/tests/xfs/169
index 44577fbf..2051091f 100755
--- a/tests/xfs/169
+++ b/tests/xfs/169
@@ -42,7 +42,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(_get_block_size $testdir)"
+blksz="$(_get_file_block_size $testdir)"
 nr_blks=$((8 * blksz / 12))
 
 for i in 1 2 x; do
diff --git a/tests/xfs/208 b/tests/xfs/208
index 104763d5..2a899fc0 100755
--- a/tests/xfs/208
+++ b/tests/xfs/208
@@ -56,7 +56,7 @@ bufnr=16
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(_get_block_size $testdir)
+real_blksz=$(_get_file_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/xfs/336 b/tests/xfs/336
index 5f32f060..a006938d 100755
--- a/tests/xfs/336
+++ b/tests/xfs/336
@@ -39,7 +39,7 @@ _scratch_mkfs | _filter_mkfs 2>$tmp.mkfs >/dev/null
 . $tmp.mkfs
 cat $tmp.mkfs > "$seqres.full" 2>&1
 _scratch_mount
-blksz="$(_get_block_size $SCRATCH_MNT)"
+blksz="$(_get_file_block_size $SCRATCH_MNT)"
 
 metadump_file=$TEST_DIR/${seq}_metadump
 rm -rf $metadump_file
diff --git a/tests/xfs/344 b/tests/xfs/344
index b00541f6..46868fa5 100755
--- a/tests/xfs/344
+++ b/tests/xfs/344
@@ -55,7 +55,7 @@ bufnr=16
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(_get_block_size $testdir)
+real_blksz=$(_get_file_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/xfs/345 b/tests/xfs/345
index ceb1dce9..4204cc22 100755
--- a/tests/xfs/345
+++ b/tests/xfs/345
@@ -53,7 +53,7 @@ bufnr=16
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(_get_block_size $testdir)
+real_blksz=$(_get_file_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"

