Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6D75EB64DA
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jul 2023 01:15:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbjGMBPM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 21:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjGMBPM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 21:15:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380E7127
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 18:15:11 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36CLA0US030838
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jul 2023 01:15:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-03-30; bh=Gn/VGuP6pD+8qiCMd4WKnqX6EB/ksCVbM01vWLjBk1I=;
 b=wdyQVmvP0BAOFDTxsSYufQ8E9BEMPjv7vWRHok5KwYugIeuvXdmML4KZPMaj7Iuj0xJh
 qtKFJBzMZQyS58gVPrAjQeLj0ii4H1rJ72XV1EokUQ3/SoyYiAuQojvCnjmy+yP/QMAv
 /Ao4JpgwgLUX2O6auy6Q9ZBrtgnMqS9ZWzaI9ak07ngn5c7CxJjTDnadx/KJoyHqtg6/
 Ob3ypmeFkCicd5SyRx9huFbgL1C9RDZjZ9Cj+5Ys5JotKlgN9wOLKQm56VYbNnXY4hnQ
 U8KGt7MR7KBze2jDLiXJOehaZIjxqeA0G7+f19Bk9naM6aNVMdDj2EUsmmk9Y+Hk0UhW Fw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rrgn7x9f3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jul 2023 01:15:10 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36CNLw27033279
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jul 2023 01:15:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx880tbt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jul 2023 01:15:10 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36D1Al1H010626
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jul 2023 01:15:09 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-65-157-8.vpn.oracle.com [10.65.157.8])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3rpx880tba-1;
        Thu, 13 Jul 2023 01:15:09 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     wen.gang.wang@oracle.com
Subject: [PATCH] xfs: xfs_trans->t_flags overflow
Date:   Wed, 12 Jul 2023 18:15:08 -0700
Message-Id: <20230713011508.18071-1-wen.gang.wang@oracle.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122.2)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-12_17,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=937
 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307130009
X-Proofpoint-ORIG-GUID: tlN6iAD9pO_MecTw9Gz9k6Eo13qsLTbW
X-Proofpoint-GUID: tlN6iAD9pO_MecTw9Gz9k6Eo13qsLTbW
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Current xfs_trans->t_flags is of type uint8_t (8 bits long). We are storing
XFS_TRANS_LOWMODE, which is 0x100, to t_flags. The highest set bit of
XFS_TRANS_LOWMODE overflows.

Fix:
Change the type from uint8_t to uint16_t.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/xfs/libxfs/xfs_shared.h | 2 +-
 fs/xfs/xfs_log_priv.h      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index c4381388c0c1..5532d6480d53 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -82,7 +82,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
  * for free space from AG 0. If the correct transaction reservations have been
  * made then this algorithm will eventually find all the space it needs.
  */
-#define XFS_TRANS_LOWMODE	0x100	/* allocate in low space mode */
+#define XFS_TRANS_LOWMODE	(1u << 8)	/* allocate in low space mode */
 
 /*
  * Field values for xfs_trans_mod_sb.
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 1bd2963e8fbd..e4b03edbc87b 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -151,7 +151,7 @@ typedef struct xlog_ticket {
 	int			t_unit_res;	/* unit reservation */
 	char			t_ocnt;		/* original unit count */
 	char			t_cnt;		/* current unit count */
-	uint8_t			t_flags;	/* properties of reservation */
+	uint16_t		t_flags;	/* properties of reservation */
 	int			t_iclog_hdrs;	/* iclog hdrs in t_curr_res */
 } xlog_ticket_t;
 
-- 
2.21.0 (Apple Git-122.2)

