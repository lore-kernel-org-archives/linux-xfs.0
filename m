Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F21B7C33CB1
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 05:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8AA12087E
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 05:13:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mG/+dHvl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgAPFNF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 00:13:05 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48824 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbgAPFNF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 00:13:05 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G58N30169843;
        Thu, 16 Jan 2020 05:13:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=+WmB4UFMFOUh2LovplU5sy9FMiyIRQjaFmm991JqX3A=;
 b=mG/+dHvlpg5nJtGa0wgkC2YzI1gtSwutff1KpGFfRPIdo8rJoYMmaNqSoebmkG+/XQMj
 EkfJFiM92oOux9GtyUG8hZcHEEJLkv8npLASokPUK5dZ8linamVephiJMMg+BP7uPN4l
 D6KcCRpaKhsikPsoMdpKpXOXRYBICPrbK2jkhMGTWfGjnjr7pRQOJkjsGlsB0hvour3D
 7guRtwYO1np809Gcy7liN6rbsDg/UfLzkT3xDvCZnlu+0x5cFOd8MELrBnkNzPoQ774p
 z/dto9giz3LQ6kM7JVMqCaT1oN5FnOkByWLJPe4dxXgoXIcd+PoI6P12+TP8EZ+YqReb HA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2xf73yr7eq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 05:13:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G59Em8085423;
        Thu, 16 Jan 2020 05:11:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2xj1psd0x5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 05:11:02 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00G5B1CD023964;
        Thu, 16 Jan 2020 05:11:02 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 21:11:01 -0800
Subject: [PATCH 4/7] xfs/279: skip test if we can't allocate scsi_debug
 device
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Wed, 15 Jan 2020 21:11:00 -0800
Message-ID: <157915146054.2374854.14308605711454193767.stgit@magnolia>
In-Reply-To: <157915143549.2374854.7759901526137960493.stgit@magnolia>
References: <157915143549.2374854.7759901526137960493.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=863
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=909 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160042
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Due to the unique structure of xfs/279 running _get_scsi_debug_dev from
a backtick from inside subshell, the "could not get scsi_debug device"
checks do not actually stop the test when modprobe scsi_debug fails.

Therefore, check the value of SCSI_DEBUG_DEV from the subshell and
_notrun the test if we couldn't get memory.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/279 |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/tests/xfs/279 b/tests/xfs/279
index 7ab8bdd5..0ddc6a00 100755
--- a/tests/xfs/279
+++ b/tests/xfs/279
@@ -65,6 +65,7 @@ _check_mkfs()
 echo "==================="
 echo "4k physical 512b logical aligned"
 SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 512 0 128`
+test -b "$SCSI_DEBUG_DEV" || _notrun "Could not get scsi_debug device"
 # sector size should default to 4k
 _check_mkfs $SCSI_DEBUG_DEV
 # blocksize smaller than physical sectorsize should revert to logical sectorsize
@@ -77,6 +78,7 @@ _put_scsi_debug_dev
 echo "==================="
 echo "4k physical 512b logical unaligned"
 SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 512 1 128`
+test -b "$SCSI_DEBUG_DEV" || _notrun "Could not get scsi_debug device"
 # should fail on misalignment
 _check_mkfs $SCSI_DEBUG_DEV
 # should fall back to logical sector size with force
@@ -93,6 +95,7 @@ _put_scsi_debug_dev
 echo "==================="
 echo "hard 4k physical / 4k logical"
 SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 4096 0 128`
+test -b "$SCSI_DEBUG_DEV" || _notrun "Could not get scsi_debug device"
 # block size smaller than sector size should fail 
 _check_mkfs -b size=2048 $SCSI_DEBUG_DEV
 # sector size smaller than physical sector size should fail

