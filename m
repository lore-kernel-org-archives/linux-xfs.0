Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A5D0C43461
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:43:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D49BA212CC
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:43:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HqVwQC46"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgIOBn2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 21:43:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38840 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgIOBn0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 21:43:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1eQup041912;
        Tue, 15 Sep 2020 01:43:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=mhJ+x4AqhOb7nA9f5ck12rJoo1nOVSaXEQZWsRax6gA=;
 b=HqVwQC46MTXjRVPJHQdTSbZ7q+tPuX7dMXFjy0GMXarUIlsNVYZkt3h6HmckQhX65RQF
 9BGbJsXlAL5QteACYfJ6QTDh/LrHxybu+pRPYuMvwCmiZojtmwMadSn2XoDcotdmzA5U
 ZgsG1YG+iH4xL5wRQ4OJn73B1nwmQsPcsY/qyx2FcNMqGKRn0hykv6W54xDeDA2TrqYo
 QIbdI9NXhR2zkNGJ+jjRbtdnWQAi1LXWUxKNxZP2GrB+y6XffEhQfdOfa4E69BLRk0iY
 Y/4mGjnf+1SAVuq2WjnN3aqjg1VLAXxw4Jn0xqoCqBGZTE4DlVXVHx3UDNlRzA/RRYhL kA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33j91dbhkr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 01:43:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1dslN075960;
        Tue, 15 Sep 2020 01:43:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33h7wn6gf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 01:43:23 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08F1hMmE004026;
        Tue, 15 Sep 2020 01:43:22 GMT
Received: from localhost (/10.159.147.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 01:43:22 +0000
Subject: [PATCH 04/24] xfs: skip tests that rely on allocation behaviors of
 the data device
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 14 Sep 2020 18:43:21 -0700
Message-ID: <160013420138.2923511.15786976146213933728.stgit@magnolia>
In-Reply-To: <160013417420.2923511.6825722200699287884.stgit@magnolia>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 adultscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=2 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

A large number of xfs-specific tests rely on specific behaviors of the
data device allocator, such as fragmenting free space, carefully curated
inode and free space counts, or features like filestreams that only
exist on the data device.

These tests fail horribly if the test runner specified rtinherit=1 on
the mkfs command line, so skip them all.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/171 |    1 +
 tests/xfs/172 |    1 +
 tests/xfs/173 |    1 +
 tests/xfs/174 |    1 +
 tests/xfs/205 |    1 +
 tests/xfs/306 |    1 +
 tests/xfs/318 |    1 +
 tests/xfs/444 |    1 +
 8 files changed, 8 insertions(+)


diff --git a/tests/xfs/171 b/tests/xfs/171
index 050d02ab..a0d6e3f9 100755
--- a/tests/xfs/171
+++ b/tests/xfs/171
@@ -33,6 +33,7 @@ _supported_fs xfs
 _supported_os Linux
 
 _require_scratch
+_require_no_rtinherit
 
 _check_filestreams_support || _notrun "filestreams not available"
 
diff --git a/tests/xfs/172 b/tests/xfs/172
index c100481c..13f1f381 100755
--- a/tests/xfs/172
+++ b/tests/xfs/172
@@ -33,6 +33,7 @@ _supported_fs xfs
 _supported_os Linux
 
 _require_scratch
+_require_no_rtinherit
 
 _check_filestreams_support || _notrun "filestreams not available"
 
diff --git a/tests/xfs/173 b/tests/xfs/173
index 1569146f..47e1d029 100755
--- a/tests/xfs/173
+++ b/tests/xfs/173
@@ -33,6 +33,7 @@ _supported_fs xfs
 _supported_os Linux
 
 _require_scratch
+_require_no_rtinherit
 
 _check_filestreams_support || _notrun "filestreams not available"
 
diff --git a/tests/xfs/174 b/tests/xfs/174
index 781a1967..348f38c3 100755
--- a/tests/xfs/174
+++ b/tests/xfs/174
@@ -33,6 +33,7 @@ _supported_fs xfs
 _supported_os Linux
 
 _require_scratch
+_require_no_rtinherit
 
 _check_filestreams_support || _notrun "filestreams not available"
 
diff --git a/tests/xfs/205 b/tests/xfs/205
index 645e509a..6f1c2058 100755
--- a/tests/xfs/205
+++ b/tests/xfs/205
@@ -24,6 +24,7 @@ _supported_os Linux
 
 # single AG will cause xfs_repair to fail checks.
 _require_scratch_nocheck
+_require_no_rtinherit
 
 rm -f $seqres.full
 
diff --git a/tests/xfs/306 b/tests/xfs/306
index edbb6076..d2a0dd7f 100755
--- a/tests/xfs/306
+++ b/tests/xfs/306
@@ -35,6 +35,7 @@ _supported_fs xfs
 _supported_os Linux
 
 _require_scratch_nocheck	# check complains about single AG fs
+_require_no_rtinherit
 _require_xfs_io_command "fpunch"
 _require_command $UUIDGEN_PROG uuidgen
 
diff --git a/tests/xfs/318 b/tests/xfs/318
index 83b858ea..a45301e2 100755
--- a/tests/xfs/318
+++ b/tests/xfs/318
@@ -33,6 +33,7 @@ _supported_fs xfs
 _require_scratch
 _require_error_injection
 _require_xfs_io_error_injection "rmap_finish_one"
+_require_no_rtinherit
 
 rm -f $seqres.full
 
diff --git a/tests/xfs/444 b/tests/xfs/444
index 6ed88715..e84b2cca 100755
--- a/tests/xfs/444
+++ b/tests/xfs/444
@@ -40,6 +40,7 @@ _require_scratch
 _require_test_program "punch-alternating"
 _require_xfs_io_command "falloc"
 _require_xfs_db_write_array
+_require_no_rtinherit
 
 # This is only a v5 filesystem problem
 _require_scratch_xfs_crc

