Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C963C433E2
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:44:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C59F4208DB
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:44:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HCsFUECL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgIOBop (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 21:44:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39716 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgIOBoo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 21:44:44 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1igJK059246;
        Tue, 15 Sep 2020 01:44:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=kTsdAQYeyMCJr1nEM6SpNRfcqlTdh5wEAo3ts+HS6pQ=;
 b=HCsFUECLr03J0f4nNhMJkyYzqQd8oAQwoQl812D44tU7AFLk/20UYlM62rR9Kddfbuft
 JnEyRTumkP8X8vew2yT5j31/wHJirm059VPYM5BqA1tTZijXJnWcVh7DBo9tOjjBmbCd
 DUh7u4vrSLP9fvoPYf64fgLcnz4KDSty1gdsZ8lX4/vqBZeVsynkWeYAc5ywM7uiePWV
 VjLuS5STjMZTm6SU6XcpKTQeaa9k4PVtEhNi7jyD6swdCHbA5WP6BNl5d2jbSlW3Txja
 6Ay3XFZXhXcNzgvBYwUbTWftdvoHqBas1H7ZphAKHtvLchy3VGu046UOR5Bo1lE+f+QW wA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33j91dbhpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 01:44:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1ifwO028965;
        Tue, 15 Sep 2020 01:44:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33h88x2vx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 01:44:42 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08F1icrT020647;
        Tue, 15 Sep 2020 01:44:39 GMT
Received: from localhost (/10.159.147.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 01:44:38 +0000
Subject: [PATCH 16/24] xfs/098: adapt to external log devices
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 14 Sep 2020 18:44:37 -0700
Message-ID: <160013427739.2923511.11743171089779718213.stgit@magnolia>
In-Reply-To: <160013417420.2923511.6825722200699287884.stgit@magnolia>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150012
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Teach this test to deal with external log devices correctly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/098 |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/098 b/tests/xfs/098
index c63b9d60..b7d3253e 100755
--- a/tests/xfs/098
+++ b/tests/xfs/098
@@ -76,7 +76,13 @@ echo "+ corrupt image"
 logstart="$(_scratch_xfs_get_sb_field logstart)"
 logstart="$(_scratch_xfs_db -c "convert fsblock ${logstart} byte" | sed -e 's/^.*(\([0-9]*\).*$/\1/g')"
 logblocks="$(_scratch_xfs_get_sb_field logblocks)"
-$XFS_IO_PROG -f -c "pwrite -S 0x62 ${logstart} $((logblocks * blksz))" "${SCRATCH_DEV}" >> $seqres.full
+
+if [ "$USE_EXTERNAL" = yes ] && [ ! -z "$SCRATCH_LOGDEV" ]; then
+	logdev=$SCRATCH_LOGDEV
+else
+	logdev=$SCRATCH_DEV
+fi
+$XFS_IO_PROG -f -c "pwrite -S 0x62 ${logstart} $((logblocks * blksz))" $logdev >> $seqres.full
 
 echo "+ mount image"
 _try_scratch_mount 2>/dev/null && _fail "mount should not succeed"

