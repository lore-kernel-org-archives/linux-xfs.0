Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A880AC433E2
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:43:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 752BE212CC
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:43:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hVLYYC2v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgIOBnk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 21:43:40 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38948 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgIOBni (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 21:43:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1eGWa041853;
        Tue, 15 Sep 2020 01:43:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=sFgvWjRam3hAYwB94wb0Ny+jW41SlWwIQJShEkkRu8I=;
 b=hVLYYC2vmd+T741chFBgjDNVhhEkhBt5pcXhojCiotyTwn6gQ7VQogxh7YbqpFu/L3aq
 bU8y5toc/unls72jEQy3EID3yWpTmY/tJNWwVqEwJ+lre7/mQYQEeljHYGYiLHDZN/et
 LdUjdUrIWpZSbvf8nM0LlG46RwoXNG2MsrNDY59GfmgvKZ/ausfz2Yf7ZR0qutm+iUWA
 m6VrZRJG9eeueNXh9ThWFPPHHj6OBlesZbq3R3G7rcgVencGqcZ0tfiPC0n6ycMOVQ+P
 b8JIWyiOxNR7AS+hltulGRlEp8UjBIcb8s7kFInviYja3QCOoYHS1lUAAgcDF2CyfhPy OQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33j91dbhm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 01:43:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1du09076090;
        Tue, 15 Sep 2020 01:43:36 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33h7wn6gnb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 01:43:35 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08F1hZ3t004108;
        Tue, 15 Sep 2020 01:43:35 GMT
Received: from localhost (/10.159.147.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 01:43:35 +0000
Subject: [PATCH 06/24] xfs: wrap xfs_db calls to the test device
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 14 Sep 2020 18:43:34 -0700
Message-ID: <160013421410.2923511.10970678307725348190.stgit@magnolia>
In-Reply-To: <160013417420.2923511.6825722200699287884.stgit@magnolia>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a _test_xfs_db analogue to _scratch_xfs_db so that we can
encapsulate whatever strange test fs options were fed to us by the test
runner.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/xfs    |   13 +++++++++++++
 tests/xfs/003 |   14 +++++++-------
 tests/xfs/016 |    4 ++--
 tests/xfs/045 |    2 +-
 4 files changed, 23 insertions(+), 10 deletions(-)


diff --git a/common/xfs b/common/xfs
index d9a9784f..eab5e292 100644
--- a/common/xfs
+++ b/common/xfs
@@ -218,6 +218,19 @@ _scratch_xfs_db()
 	$XFS_DB_PROG "$@" $(_scratch_xfs_db_options)
 }
 
+_test_xfs_db_options()
+{
+	TEST_OPTIONS=""
+	[ "$USE_EXTERNAL" = yes -a ! -z "$TEST_LOGDEV" ] && \
+		TEST_OPTIONS="-l$TEST_LOGDEV"
+	echo $TEST_OPTIONS $* $TEST_DEV
+}
+
+_test_xfs_db()
+{
+	$XFS_DB_PROG "$@" $(_test_xfs_db_options)
+}
+
 _scratch_xfs_admin()
 {
 	local options=("$SCRATCH_DEV")
diff --git a/tests/xfs/003 b/tests/xfs/003
index 1ce3e5ce..736bf206 100755
--- a/tests/xfs/003
+++ b/tests/xfs/003
@@ -38,32 +38,32 @@ test_done()
 # real QA test starts here
 
 echo "=== TEST 1 ==="
-xfs_db -r -c 'pop' -c 'type sb' $TEST_DEV
+_test_xfs_db -r -c 'pop' -c 'type sb'
 test_done
 
 echo "=== TEST 2 ==="
-xfs_db -r -c 'push sb' $TEST_DEV
+_test_xfs_db -r -c 'push sb'
 test_done
 
 echo "=== TEST 3 ==="
-xfs_db -r -c 'pop' -c 'push sb' $TEST_DEV
+_test_xfs_db -r -c 'pop' -c 'push sb'
 test_done
 
 echo "=== TEST 4 ==="
-xfs_db -r -c 'type sb' -c 'print' $TEST_DEV
+_test_xfs_db -r -c 'type sb' -c 'print'
 test_done
 
 echo "=== TEST 5 ==="
-xfs_db -r -c 'inode 128' -c 'push' -c 'type' $TEST_DEV >$tmp.out 2>&1
+_test_xfs_db -r -c 'inode 128' -c 'push' -c 'type' >$tmp.out 2>&1
 test_done
 if ! grep -q "current type is \"inode\"" $tmp.out; then
     cat $tmp.out
 fi
 
 echo "=== TEST 6 ==="
-xfs_db -r -c 'sb' -c 'a' $TEST_DEV >$tmp.out 2>&1 # don't care about output
+_test_xfs_db -r -c 'sb' -c 'a' >$tmp.out 2>&1 # don't care about output
 test_done
 
 echo "=== TEST 7 ==="
-xfs_db -r -c 'ring' $TEST_DEV
+_test_xfs_db -r -c 'ring'
 test_done
diff --git a/tests/xfs/016 b/tests/xfs/016
index 2b41127e..e1b1b6b8 100755
--- a/tests/xfs/016
+++ b/tests/xfs/016
@@ -149,7 +149,7 @@ _log_sunit()
 
 _after_log()
 {
-    xfs_db -r $1 -c "sb" -c "print" | $AWK_PROG '
+    _scratch_xfs_db -r -c "sb" -c "print" | $AWK_PROG '
         /logstart/  { logstart = $3 }
         /logblocks/ { logblocks = $3 }
         END {
@@ -163,7 +163,7 @@ _check_corrupt()
     f="c6c6c6c6"
     echo "*** check for corruption"
     echo "expect $f..." >>$seqres.full
-    xfs_db -r -c "fsblock $2" -c "print" $1 | head | tee -a $seqres.full | \
+    _scratch_xfs_db -r -c "fsblock $2" -c "print" | head | tee -a $seqres.full | \
         grep -q -v "$f $f $f $f $f $f $f $f" && \
             _fail "!!! block $2 corrupted!"
 }
diff --git a/tests/xfs/045 b/tests/xfs/045
index 0c9e1b79..6a44da56 100755
--- a/tests/xfs/045
+++ b/tests/xfs/045
@@ -21,7 +21,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
 _get_existing_uuid()
 {
-    xfs_db -r $TEST_DEV -c "uuid" | $AWK_PROG '/^UUID/ { print $3 }'
+	_test_xfs_db -r -c "uuid" | $AWK_PROG '/^UUID/ { print $3 }'
 }
 
 # real QA test starts here

