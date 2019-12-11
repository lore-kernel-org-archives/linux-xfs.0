Return-Path: <SRS0=bXuc=2B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2F5BC2D0C4
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Dec 2019 05:39:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 896C021D7D
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Dec 2019 05:39:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rXMlnqVP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfLKFjr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Dec 2019 00:39:47 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:33722 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbfLKFjr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Dec 2019 00:39:47 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBB5dToU031995;
        Wed, 11 Dec 2019 05:39:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=JBpHOfNoea4nvciwYQcUWfhCXjFLjW5g47pz+lARVuA=;
 b=rXMlnqVPDv1TUC6U2fsWpMdZbU5w0Xp1aGBbuDSLLZ1gXUhO1oTD1hWwEUP2S6CVFJGM
 8P5k7XhA+iBUTQ/8J3GK4UdUT0ZcsXXCrrvxmf5nT1H29kuoxCdE710RrQ7FEUdkbDDu
 wnjgzXM35KdOMxjcHosqjezHXZQIBBMkW/fJeIDRKL0gXNZwXuwCKIqp73ZWQCakr6oc
 vP03MHjaocrn2MJIQec6JEjrS8H4/mR0rmv1AdtF9LD/B1M4f40uLWRJyuoGYE//wd3l
 KSx9tI7I9d1Z6iKiDdWqxyy8Y2/av2Khn2RlNFwOrzzHiXC1w8KjHXu468RskIlh+GEt HQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2wr4qrj8gp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Dec 2019 05:39:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBB5dbYY013675;
        Wed, 11 Dec 2019 05:39:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2wtk2gx2bh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Dec 2019 05:39:42 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBB5cXpI014942;
        Wed, 11 Dec 2019 05:38:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Dec 2019 21:38:32 -0800
Subject: [PATCH 1/2] common/dmerror: always try to resume device
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 10 Dec 2019 21:38:31 -0800
Message-ID: <157604271185.578515.14919906805385029384.stgit@magnolia>
In-Reply-To: <157604270553.578515.11375769780919670829.stgit@magnolia>
References: <157604270553.578515.11375769780919670829.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9467 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912110049
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9467 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912110049
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're reloading the error-target dm table, always resume the device
even if the reload fails because (a) we shouldn't leave dm state for the
callers to clean up and (b) the caller don't clean up the state which
just leads to the scratch filesystem hanging on the suspended dm error
device.  Resume the dm device when we're cleaning up so that cleaning up
the scratch filesystem won't hang.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/dmerror |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)


diff --git a/common/dmerror b/common/dmerror
index 8c52e127..ca1c7335 100644
--- a/common/dmerror
+++ b/common/dmerror
@@ -44,6 +44,7 @@ _dmerror_unmount()
 
 _dmerror_cleanup()
 {
+	$DMSETUP_PROG resume error-test > /dev/null 2>&1
 	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
 	_dmsetup_remove error-test
 }
@@ -62,10 +63,13 @@ _dmerror_load_error_table()
 	[ $? -ne 0 ] && _fail  "dmsetup suspend failed"
 
 	$DMSETUP_PROG load error-test --table "$DMERROR_TABLE"
-	[ $? -ne 0 ] && _fail "dmsetup failed to load error table"
+	load_res=$?
 
 	$DMSETUP_PROG resume error-test
-	[ $? -ne 0 ] && _fail  "dmsetup resume failed"
+	resume_res=$?
+
+	[ $load_res -ne 0 ] && _fail "dmsetup failed to load error table"
+	[ $resume_res -ne 0 ] && _fail  "dmsetup resume failed"
 }
 
 _dmerror_load_working_table()
@@ -82,8 +86,11 @@ _dmerror_load_working_table()
 	[ $? -ne 0 ] && _fail  "dmsetup suspend failed"
 
 	$DMSETUP_PROG load error-test --table "$DMLINEAR_TABLE"
-	[ $? -ne 0 ] && _fail "dmsetup failed to load error table"
+	load_res=$?
 
 	$DMSETUP_PROG resume error-test
-	[ $? -ne 0 ] && _fail  "dmsetup resume failed"
+	resume_res=$?
+
+	[ $load_res -ne 0 ] && _fail "dmsetup failed to load error table"
+	[ $resume_res -ne 0 ] && _fail  "dmsetup resume failed"
 }

