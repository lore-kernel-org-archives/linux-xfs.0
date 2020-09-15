Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63205C433E2
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:47:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25CCA20771
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:47:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HRWfYpMd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgIOBrD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 21:47:03 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47144 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgIOBrC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 21:47:02 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1i5Uo147445;
        Tue, 15 Sep 2020 01:46:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=76hQgMbEEeHLaojm+wBPtYPe43PNt6BTtsupBb5F3j8=;
 b=HRWfYpMdZthkPj8pl1GqkhYl91XIPLLEPL2nyKgY1VvSYXMVTJvFg9dN68HLjGzPJVe/
 324zz+YeNlZYibTLpE02eSA+cNXkKA7ITuslU2Nh26Two6BAPKIKA99c+SdJb5tDA+o+
 VE/GR9bdHldnH38iPK/jKx7YWZjlntO0wnV5DFSG3tROF8awzhCPSDiD1gQ8glzCJvJ1
 wQQLr3FBI7ltGx77mC4GRzNWQwsVpiDedK6MLroYkn06fOy+fV5MujGNedvVwYvwPRES
 89RBkewgm0SCDEelG0bsti9m3j0YfNFuo7oxjfRd2fzKWnN7cI26qMsgOLQh5JJETmP9 Rg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 33gnrqsy2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 01:46:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1fP1V109475;
        Tue, 15 Sep 2020 01:44:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 33h88381v1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 01:44:58 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08F1iv3s020784;
        Tue, 15 Sep 2020 01:44:57 GMT
Received: from localhost (/10.159.147.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 01:44:57 +0000
Subject: [PATCH 19/24] xfs/424: disable external devices
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 14 Sep 2020 18:44:56 -0700
Message-ID: <160013429643.2923511.17476130717295164051.stgit@magnolia>
In-Reply-To: <160013417420.2923511.6825722200699287884.stgit@magnolia>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150012
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

This test uses an open-coded call to mkfs, so we need to disable the
external devices so that _scratch_xfs_db doesn't get confused.  We also
disable the post-check fsck because it's run by the parent ./check
program, which won't know that we didn't use the external devices.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/424 |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/424 b/tests/xfs/424
index 66d79458..4907cf0f 100755
--- a/tests/xfs/424
+++ b/tests/xfs/424
@@ -47,7 +47,13 @@ rm -f $seqres.full
 # Modify as appropriate
 _supported_os Linux
 _supported_fs xfs
-_require_scratch
+
+# Since we have an open-coded mkfs call, disable the external devices and
+# don't let the post-check fsck actually run since it'll trip over us not
+# using the external devices.
+_require_scratch_nocheck
+export SCRATCH_LOGDEV=
+export SCRATCH_RTDEV=
 
 echo "Silence is golden."
 

