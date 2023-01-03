Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26E47C3DA7D
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Jan 2023 19:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233420AbjACTcm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Jan 2023 14:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239151AbjACTcY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jan 2023 14:32:24 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53D613F69
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jan 2023 11:32:20 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 303JDxup027985
        for <linux-xfs@vger.kernel.org>; Tue, 3 Jan 2023 19:32:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=bJUJroC2iZ9BKy4OCvktrdtS9qfaSMcmFT4NocF9VfI=;
 b=ZrlhhU4z92njYqqGo0VJxwJNbafW+YcxEc4CG80mr6JNKFnvo62UUj+HgoJPfg+bWFb+
 0WN/fFK0tTcr7DiiXzIQdryFoKOb/As4YkXkHTUoH7+tx4xq97pFPr5F44SpaqWqmUeU
 noqwlTX5qDYOOXAb3/VAvsL+AdM+yB2qQBoawzuYknwRIDy8w/VPMlQ+Gb+TVuCcj9yi
 Bl9UQm3+F+cokoRbVla0amgxaIndsrumY/GtpSJVt494eupUFsuUdzeAUp4w7gTklHUE
 GzgS2zGDk1ZowQTmNcssx5YMoQWr0Hm6NWh0Fl88Cf5IJWrxZdNhAlRbUKvlhBPIh0aK Aw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mtbv2vypk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 03 Jan 2023 19:32:20 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 303IPLYT024811
        for <linux-xfs@vger.kernel.org>; Tue, 3 Jan 2023 19:32:19 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mtbh58rbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 03 Jan 2023 19:32:19 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 303JWI3p012954
        for <linux-xfs@vger.kernel.org>; Tue, 3 Jan 2023 19:32:18 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-159-153-39.vpn.oracle.com [10.159.153.39])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3mtbh58rau-1;
        Tue, 03 Jan 2023 19:32:18 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     wen.gang.wang@oracle.com
Subject: [PATCH] xfs: fix extent busy updating
Date:   Tue,  3 Jan 2023 11:32:17 -0800
Message-Id: <20230103193217.4941-1-wen.gang.wang@oracle.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122.2)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-03_07,2023-01-03_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301030167
X-Proofpoint-GUID: fWvrDt2T1QBjo5Y3ywa1KTCbOfMjYefP
X-Proofpoint-ORIG-GUID: fWvrDt2T1QBjo5Y3ywa1KTCbOfMjYefP
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In xfs_extent_busy_update_extent() case 6 and 7, whenever bno is modified on
extent busy, the relavent length has to be modified accordingly.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/xfs/xfs_extent_busy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index ad22a003f959..f3d328e4a440 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -236,6 +236,7 @@ xfs_extent_busy_update_extent(
 		 *
 		 */
 		busyp->bno = fend;
+		busyp->length = bend - fend;
 	} else if (bbno < fbno) {
 		/*
 		 * Case 8:
-- 
2.21.0 (Apple Git-122.2)

