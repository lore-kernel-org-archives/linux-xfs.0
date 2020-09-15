Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E700C43461
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:46:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCAD720771
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:46:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JAKTgZv4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgIOBqE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 21:46:04 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51858 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbgIOBqD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 21:46:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1irtF031281;
        Tue, 15 Sep 2020 01:46:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=BnJSZN8DIoLR3+BnhQP8IlL54jmgq8FGkBsMbcLnh2I=;
 b=JAKTgZv4C9XZwjJ6x7zMcYndt6iQbxW7H3qbwNu1CGMvxnMgW0+xLtOMzgXe0dDat08j
 6w2+z0tVBTBOoxpU1AKYPBI7Rn/GA/ma+zoyJyan98PHzAzeNUMZmwzW/v3yvzAEtq+f
 3N8lKNgCHERPqBgvm1zbXoLdSoxTlAvSLIo/z9+mS+nP4/T1/PLAQUfI+aSx90xdKlEs
 8TOFCM4aSk0IxLNo+9QO0jMlpKMyN7ZEFl4zDY2OpbNIB0J5Eu7iSMODGDg3iHNl1EVE
 PDGhTHadtKuPvAW2fRoTFzZgooBu5aRg+iuwuKzTx4fFOlWpN6aHfwlPqX3zGtCfuTaU zg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33gp9m1wx2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 01:46:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1dscM076003;
        Tue, 15 Sep 2020 01:44:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33h7wn6h21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 01:44:01 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08F1i05R001220;
        Tue, 15 Sep 2020 01:44:00 GMT
Received: from localhost (/10.159.147.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 01:44:00 +0000
Subject: [PATCH 10/24] xfs: add a _require_xfs_copy helper
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 14 Sep 2020 18:43:59 -0700
Message-ID: <160013423963.2923511.3348023490177095472.stgit@magnolia>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150012
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a _require helper so that tests can ensure that they're running in
the correct environment for xfs_copy to work (no external devices).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/xfs    |    7 +++++++
 tests/xfs/032 |    4 +---
 tests/xfs/073 |    5 +----
 tests/xfs/077 |    3 +--
 tests/xfs/284 |    3 +--
 tests/xfs/503 |    1 +
 6 files changed, 12 insertions(+), 11 deletions(-)


diff --git a/common/xfs b/common/xfs
index eab5e292..f4a47dfb 100644
--- a/common/xfs
+++ b/common/xfs
@@ -945,3 +945,10 @@ _try_wipe_scratch_xfs()
 	fi
 	rm -f $tmp.mkfs
 }
+
+_require_xfs_copy()
+{
+	[ -n "$XFS_COPY_PROG" ] || _notrun "xfs_copy binary not yet installed"
+	[ "$USE_EXTERNAL" = yes ] && \
+		_notrun "Cannot xfs_copy with external devices"
+}
diff --git a/tests/xfs/032 b/tests/xfs/032
index af18f755..8ece957d 100755
--- a/tests/xfs/032
+++ b/tests/xfs/032
@@ -25,9 +25,7 @@ _supported_os Linux
 
 _require_scratch
 _require_test_program "feature"
-
-[ "$USE_EXTERNAL" = yes ] && _notrun "Cannot xfs_copy with external devices"
-[ -n "$XFS_COPY_PROG" ] || _notrun "xfs_copy binary not yet installed"
+_require_xfs_copy
 
 rm -f $seqres.full
 
diff --git a/tests/xfs/073 b/tests/xfs/073
index 6939e102..dc0cde4f 100755
--- a/tests/xfs/073
+++ b/tests/xfs/073
@@ -113,10 +113,7 @@ _supported_fs xfs
 _supported_os Linux
 _require_test
 _require_attrs
-
-[ "$USE_EXTERNAL" = yes ] && _notrun "Cannot xfs_copy with external devices"
-[ -n "$XFS_COPY_PROG" ] || _notrun "xfs_copy binary not yet installed"
-
+_require_xfs_copy
 _require_scratch
 _require_loop
 
diff --git a/tests/xfs/077 b/tests/xfs/077
index 02bcc9f7..b11b2c07 100755
--- a/tests/xfs/077
+++ b/tests/xfs/077
@@ -35,8 +35,7 @@ _cleanup()
 
 _supported_fs xfs
 _supported_os Linux
-# xfs_copy does not support realtime devices
-_require_no_realtime
+_require_xfs_copy
 _require_scratch
 _require_no_large_scratch_dev
 _require_xfs_crc
diff --git a/tests/xfs/284 b/tests/xfs/284
index 7af77634..8f997e17 100755
--- a/tests/xfs/284
+++ b/tests/xfs/284
@@ -34,8 +34,7 @@ rm -f $seqres.full
 # real QA test starts here
 _supported_fs xfs
 _supported_os Linux
-# xfs_copy does not support realtime devices
-_require_no_realtime
+_require_xfs_copy
 _require_test
 _require_scratch
 _require_no_large_scratch_dev
diff --git a/tests/xfs/503 b/tests/xfs/503
index 41754353..756bcda3 100755
--- a/tests/xfs/503
+++ b/tests/xfs/503
@@ -33,6 +33,7 @@ testdir=$TEST_DIR/test-$seq
 _supported_os Linux
 _supported_fs xfs
 
+_require_xfs_copy
 _require_scratch_nocheck
 _require_populate_commands
 

