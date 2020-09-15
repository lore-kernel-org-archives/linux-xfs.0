Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FAFFC433E2
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:44:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18EAD216C4
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:44:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UsMxCrhl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgIOBoM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 21:44:12 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45324 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgIOBoJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 21:44:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1hYkB147225;
        Tue, 15 Sep 2020 01:44:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=eZKy1mv5hVN1JNBYemKOsswtMGqgnrBbnzQ3/iigUBo=;
 b=UsMxCrhljCsEiU9DTxX7cAJgxmGV+2gaE0As3bUZB9t3POPcFvUl2r4l3UwRbPaQr2vI
 Jr8UkTz6j8eThO4dKFPTLy2rwQpREK+ubloKIkOVvEMUe60QPfajyv6X6u67kXr8ixkc
 b0EQ5+PZSnt0Qc2eiFPAHgzuPdos6U7wVP1qT0EdV8erkey98PaER3Vr06lm/5PPkUJG
 rb5T6/5pDlwfhM3X+0RcN763oykIfX7exkPSy9evBEqHN71uXW8wQIkQh8dURFJX2Ea5
 HDyK241Ivs/XKPtZHAb4kOYjdheyO471SS2Y15S0SfCBtLQTUsSeaZRiAa5NNIPO/Ec5 kQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 33gnrqsxv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 01:44:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1dm8t111649;
        Tue, 15 Sep 2020 01:44:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33hm2ycecp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 01:44:07 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08F1i7Ff020419;
        Tue, 15 Sep 2020 01:44:07 GMT
Received: from localhost (/10.159.147.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 01:44:06 +0000
Subject: [PATCH 11/24] overlay/{069,071}: fix undefined variables
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 14 Sep 2020 18:44:05 -0700
Message-ID: <160013424591.2923511.7236445306723372509.stgit@magnolia>
In-Reply-To: <160013417420.2923511.6825722200699287884.stgit@magnolia>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=829
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=0
 clxscore=1015 mlxlogscore=849 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150012
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Change OVL_BASE_TEST_MNT -> OVL_BASE_TEST_DIR, since the former is not
actually defined anywhere.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/overlay/069 |    2 +-
 tests/overlay/071 |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/tests/overlay/069 b/tests/overlay/069
index 77dfce63..f7eaec2d 100755
--- a/tests/overlay/069
+++ b/tests/overlay/069
@@ -53,7 +53,7 @@ _require_test_program "open_by_handle"
 _require_scratch_overlay_features index nfs_export redirect_dir
 
 # Lower overlay lower layer is on test fs, upper is on scratch fs
-lower=$OVL_BASE_TEST_MNT/$OVL_LOWER-$seq
+lower=$OVL_BASE_TEST_DIR/$OVL_LOWER-$seq
 upper=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
 work=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
 
diff --git a/tests/overlay/071 b/tests/overlay/071
index e083c29d..043fc4d3 100755
--- a/tests/overlay/071
+++ b/tests/overlay/071
@@ -56,7 +56,7 @@ _require_scratch_overlay_features index nfs_export redirect_dir
 _require_loop
 
 # Lower overlay lower layer is on test fs, upper is on scratch fs
-lower=$OVL_BASE_TEST_MNT/$OVL_LOWER-$seq
+lower=$OVL_BASE_TEST_DIR/$OVL_LOWER-$seq
 upper=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
 work=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
 # Lower dir of nested overlay is the scratch overlay mount at SCRATCH_MNT

