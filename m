Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 888B3C7EE23
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 09:01:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbjEWJBW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 05:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236259AbjEWJBR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 05:01:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005FC100
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 02:01:16 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34N6EF50027123;
        Tue, 23 May 2023 09:01:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=Tiq59H3WNYtrILpA3KGek33W1g+uwqBzFWm+PtgfqQw=;
 b=lha6QxZuhvTdxOTQwXHtHsO6kC4dyWZkjKBVYJgF30r0njSt6qxkHQM2M/BVlqZg6R8E
 diCoCGBGfFz2u1wsJ6mFrNOptiQ86SI79MOOkXPqh54iaD2bUHH+QQbdbyLwEJd1MLLe
 99CxALZNmqeuJ7SPkrkIdFuq9JOHteZsQneg1MTugRL4R60KTSSnHGBe04XtBAjbKmmK
 +/wZgAoFhmYvSXGvM14vv8Fz2nryb9ufQnFpRCzZOyK5crg7YrFqVgkjBpUqJy5wY0Pf
 vcUqPPcrbSj8UGZWw7USFTXf3SykW7fix/NGWYEjWirUVDw9WMbgEJ3jQ2noYLz5Wewx 2g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpp8ccp8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:14 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34N916T4029019;
        Tue, 23 May 2023 09:01:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2aj7h3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:13 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34N8xwrj007681;
        Tue, 23 May 2023 09:01:12 GMT
Received: from chanbabu-fstest.osdevelopmeniad.oraclevcn.com (chanbabu-fstesting.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.250.50])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3qqk2aj76a-12;
        Tue, 23 May 2023 09:01:12 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     cem@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: [PATCH 11/24] metadump: Define metadump v2 ondisk format structures and macros
Date:   Tue, 23 May 2023 14:30:37 +0530
Message-Id: <20230523090050.373545-12-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230523090050.373545-1-chandan.babu@oracle.com>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-23_05,2023-05-22_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305230074
X-Proofpoint-ORIG-GUID: Xv0cPAumugli8ityBiygUHb0g0FhGT24
X-Proofpoint-GUID: Xv0cPAumugli8ityBiygUHb0g0FhGT24
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 include/xfs_metadump.h | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/include/xfs_metadump.h b/include/xfs_metadump.h
index a4dca25cb..1d8d7008c 100644
--- a/include/xfs_metadump.h
+++ b/include/xfs_metadump.h
@@ -8,7 +8,9 @@
 #define _XFS_METADUMP_H_
 
 #define	XFS_MD_MAGIC_V1		0x5846534d	/* 'XFSM' */
+#define	XFS_MD_MAGIC_V2		0x584D4432	/* 'XMD2' */
 
+/* Metadump v1 */
 typedef struct xfs_metablock {
 	__be32		mb_magic;
 	__be16		mb_count;
@@ -23,4 +25,34 @@ typedef struct xfs_metablock {
 #define XFS_METADUMP_FULLBLOCKS	(1 << 2)
 #define XFS_METADUMP_DIRTYLOG	(1 << 3)
 
+/* Metadump v2 */
+struct xfs_metadump_header {
+	__be32 xmh_magic;
+	__be32 xmh_version;
+	__be32 xmh_compat_flags;
+	__be32 xmh_incompat_flags;
+	__be64 xmh_reserved;
+} __packed;
+
+#define XFS_MD2_INCOMPAT_OBFUSCATED	(1 << 0)
+#define XFS_MD2_INCOMPAT_FULLBLOCKS	(1 << 1)
+#define XFS_MD2_INCOMPAT_DIRTYLOG	(1 << 2)
+
+struct xfs_meta_extent {
+        /*
+	 * Lowest 54 bits are used to store 512 byte addresses.
+	 * Next 2 bits is used for indicating the device.
+	 * 00 - Data device
+	 * 01 - External log
+	 */
+        __be64 xme_addr;
+        /* In units of 512 byte blocks */
+        __be32 xme_len;
+} __packed;
+
+#define XME_ADDR_DATA_DEVICE	(1UL << 54)
+#define XME_ADDR_LOG_DEVICE	(1UL << 55)
+
+#define XME_ADDR_DEVICE_MASK (~(XME_ADDR_DATA_DEVICE | XME_ADDR_LOG_DEVICE))
+
 #endif /* _XFS_METADUMP_H_ */
-- 
2.39.1

