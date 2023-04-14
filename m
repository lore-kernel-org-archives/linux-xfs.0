Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C094C77B71
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Apr 2023 22:58:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjDNW6l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Apr 2023 18:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjDNW6k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Apr 2023 18:58:40 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1AD57698
        for <linux-xfs@vger.kernel.org>; Fri, 14 Apr 2023 15:58:38 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33EMO67g018322
        for <linux-xfs@vger.kernel.org>; Fri, 14 Apr 2023 22:58:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-03-30; bh=/iH7DzPvorGnDgrvxfb5VuYh9eE0lL4d3JyPvJL8+jA=;
 b=UGCOeezKtdwBGxhhTRWu5XnYJpbB2S9tkkmbHiS1Ba71J5RyBfbZQlO6dT4p0q1+4Ocd
 YitzOmovF/uzplhwUFtSDT4Erao5vtlPrRWwbJV8dZSvviKjldxxHC1xYbCniVGNIY19
 f7hL7AyQ0P+DwDGckkG/RrSSKK50KNrfwJOkLOCjn4smAqWm46wcLbETQiMjVhrNvAx+
 G7Lm8sEl1MfvJBuINvD1qEnkrVv/ugm3rshGO5jBcieGoS4xEfsk5idK2cgdW6mNOsz2
 KA3ARZZA/fiHSmhITU8/EYQapKcRaNaQZUwwQd5rAbzIuMyU7OlgaZz+upiTu5UOZR/O eg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0eqf4pa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 14 Apr 2023 22:58:37 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33EKQ153011501
        for <linux-xfs@vger.kernel.org>; Fri, 14 Apr 2023 22:58:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puw96nvnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 14 Apr 2023 22:58:36 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33EMwapu026359
        for <linux-xfs@vger.kernel.org>; Fri, 14 Apr 2023 22:58:36 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-159-159-110.vpn.oracle.com [10.159.159.110])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3puw96nvnq-1;
        Fri, 14 Apr 2023 22:58:36 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     wen.gang.wang@oracle.com
Subject: [PATCH 0/2] xfs: one extent per EFI
Date:   Fri, 14 Apr 2023 15:58:34 -0700
Message-Id: <20230414225836.8952-1-wen.gang.wang@oracle.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122.2)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-14_14,2023-04-14_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=643 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304140202
X-Proofpoint-GUID: rDLOj3FysD4vSrH2gukaq3iSwj8Bcez1
X-Proofpoint-ORIG-GUID: rDLOj3FysD4vSrH2gukaq3iSwj8Bcez1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We are hitting the deadlock described in patch 1.
This patchset doesn't want to disturb the existing block allocation
routine, that would make the allocation routime even complex. Instead,
this patch avoids doing AGFL block allocation holding busy extents in current
memory transaction.

Patch 1 fixes the IO path and Patch 2 takes care of log recovery.

Wengang Wang (2):
  xfs: IO time one extent per EFI
  xfs: log recovery stage split EFIs with multiple extents

 fs/xfs/xfs_extfree_item.c | 104 ++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_extfree_item.h |   9 +++-
 2 files changed, 101 insertions(+), 12 deletions(-)

-- 
2.21.0 (Apple Git-122.2)

