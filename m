Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14608C433E2
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2F2E214F1
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:44:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BKVRv7Uc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbgIOBo4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 21:44:56 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45844 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgIOBoz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 21:44:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1ier2147835;
        Tue, 15 Sep 2020 01:44:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=330miZwVEX4Rpugn8t8zKpEMqqoSKmffYc/nOOKEac8=;
 b=BKVRv7Uc/POfehjWJfGPDbFpmcbj2UqN1CMe1Stk6R3wTKwzdXb32CVXaoO2EPfQ5j3Z
 gUf6eYxkGbYni+416wFQ05Qr2AvVCiu8GVXZ1VeWcY6xKZfsP7myfgxK2fFxXU5aoLeR
 F0hvithQ3KL+M+nYjfbW2pZPBnRbWDr3UDLTbkJf0EteWBruDaJep3pHDqDLO7Wt0F7M
 3Q7Qe3vi4rYLtidNlCZnS2LXBTrIYabD1RY9UMMdHPgxd/JXqoRZczMvlb24LEeb7Xg9
 x5PHNVIxaMjiQ9pNV8it4ovnaDmXd/JHlPS8FyRw4Gmj+OfNqMT+38kxj030obOzJG5k OA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 33gnrqsxwn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 01:44:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1fPfM109437;
        Tue, 15 Sep 2020 01:44:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 33h88381mv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 01:44:52 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08F1ipOX020679;
        Tue, 15 Sep 2020 01:44:51 GMT
Received: from localhost (/10.159.147.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 01:44:51 +0000
Subject: [PATCH 18/24] xfs/291: fix open-coded repair call to mdrestore'd fs
 image
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 14 Sep 2020 18:44:50 -0700
Message-ID: <160013429012.2923511.7187414322832672163.stgit@magnolia>
In-Reply-To: <160013417420.2923511.6825722200699287884.stgit@magnolia>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=975
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=0
 clxscore=1015 mlxlogscore=982 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150012
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Attach any external log devices to the open-coded repair call.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/291 |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/291 b/tests/xfs/291
index adef2536..5d4f1ac4 100755
--- a/tests/xfs/291
+++ b/tests/xfs/291
@@ -110,7 +110,9 @@ _scratch_metadump $tmp.metadump || _fail "xfs_metadump failed"
 xfs_mdrestore $tmp.metadump $tmp.img || _fail "xfs_mdrestore failed"
 [ "$USE_EXTERNAL" = yes ] && [ -n "$SCRATCH_RTDEV" ] && \
 	rt_repair_opts="-r $SCRATCH_RTDEV"
-$XFS_REPAIR_PROG $rt_repair_opts -f $tmp.img >> $seqres.full 2>&1 || \
+[ "$USE_EXTERNAL" = yes ] && [ -n "$SCRATCH_LOGDEV" ] && \
+	log_repair_opts="-l $SCRATCH_LOGDEV"
+$XFS_REPAIR_PROG $rt_repair_opts $log_repair_opts -f $tmp.img >> $seqres.full 2>&1 || \
 	_fail "xfs_repair of metadump failed"
 
 # Yes it can; success, all done

