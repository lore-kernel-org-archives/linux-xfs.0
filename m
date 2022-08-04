Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5067C25B07
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 19:40:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239266AbiHDTkg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 15:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiHDTk2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 15:40:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9361C6407
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 12:40:27 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 274HbggR021114
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=N49A7sfQSuou44N8vGldnB1tZBot+KCgxOMxLzq5p00=;
 b=H8uE3mHXyqprW6q7v3rtTvgqXdHNqRnPC6qZQTHPGhB0MyW0L2SkMliaoEjdlau8qAR1
 hNZTJadwIVB2edvmA6J2B1JO5eWvZy9K32wibQFVpLmNpfgCdRgpBJUlCG6CScJRx/RX
 bSPyWPKKDE53Nb3+TU2oiOUuJuojMeCBSMSdoMZy7q8YFJlLE+5xRzxYpB4dlvjb2Yiy
 bvAH6a9sg2CwDdkTS2cK+HYTNxomQjsqZu2wfpO5zkYVc80pHaHVo5m3R2ZLVUO9XjcO
 VjvLVkQ+XRci0JesuDcxZ2fCcka2KIQByQkNbHAOYoigRITYHUvwNF+/8UzHHwl9TUxb Eg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmu815xrt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:27 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 274IH90i007562
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:26 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu34b93d-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N+LUwFDLauxTtuFRVdee6Notq46cBJV92a3vsuJ70FlEwg8Gl02jgcSFPcZhV8Hsj0WfpaEcJUAtWxozX0pzweLILSyxXHlcAi/vzvc76S4oUsbNie9gp6GvWIlIaSsyeX0QzVPTuGi92cp7GIQj+DCY948puvnNZTPqOfEX2MhyJP+bFT9TJ4QFNn94vO9uWF14b68fJgIPFbzU8WiVRPpP6Bld5rBftuG9bkGha5WxHsyd+rctBuGeiVkJ/hXk+YAKr/pxrRQviC1G174nnXOeY4Q1hnC5Fw+7pI7ftfkoUOKXQipriJM/Q+dL2vi2rpLuJpULoAs7cQlTHBnrYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N49A7sfQSuou44N8vGldnB1tZBot+KCgxOMxLzq5p00=;
 b=hKRysOEjBtJ9nvtXoKdqA2YiDid81/YQz0KfrVGj9TiX6zQkUoJok3iISQEoCmmaH5s2V3ZOCZE2FPE6Mfti+odPKcip/vtA42Pf5On0+rgtTD7azlv8k8dDAY+RH/sm0sguWv9sejq46uBlLhgo0z+TtHKzLe2b4RPlGGL9/8CJpGnpindZ9A5U6TNiDkATS/LrhpFkZBVgGt93Na85ngrW40Nbn+4W9jaPaJpq3a1VjP2zWvWmUwWVqQobVGx+C0Mo5ESeODzAEFGX/3zjTV1PHuZ/rSmGRiKXd54x1bLBoB0gNH04bOCRXRKhdkZWX4GYFl/1NvbwKIAmrclekg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N49A7sfQSuou44N8vGldnB1tZBot+KCgxOMxLzq5p00=;
 b=xenBAyrkNakWk+uIkHR37vUhNaLuBwGBTqvt0gWOCWeS2Gm1/obhEuXpXnStVP4mohyDLyi8lku7Z3v77W2Whq8CEsWmE7HyVN14mm33ZIt/Jmse9ByQwCMzbymiTEGI2Ldv5SrEjWkz4okDgPO2nP1lo0cni4orieVuOQpbaYY=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5040.namprd10.prod.outlook.com (2603:10b6:5:3b0::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 19:40:25 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5504.016; Thu, 4 Aug 2022
 19:40:25 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RESEND v2 08/18] xfs: add parent pointer support to attribute code
Date:   Thu,  4 Aug 2022 12:40:03 -0700
Message-Id: <20220804194013.99237-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220804194013.99237-1-allison.henderson@oracle.com>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0198.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::23) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17123962-b702-4bbf-d586-08da76512c60
X-MS-TrafficTypeDiagnostic: DS7PR10MB5040:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +SSQakmDFxBSglcqA7uAp10vAFZheqeKvwRDoSZ6XkJ56NBavBlht8fGvWJtT3+soc4kQ1/WfScJTMC7pVWLbxNc2KdZQuPesUUkiAxzWn6ycZYC7hATmiccH4Bjt17cBqF/GwOQfn0GdUvNx7rnFrMLCykMby0z07WxazXm+vQIvpRCo2v/SkLryOX9mmk+3n8o9w0MHM6efwj7FyZVzae7hEsYw9/TFP2OHiHIokYzlc8eEk0/VQ8J9M/deyX8VRbrEQ24y1V5+vvkTk7Q4J/Dw5ZOE9bIOgE0lPMlfkTFHma/o4Dkm0AuyvfnSSxi1wawXY+ytdxXEqiSEM8gPzM4nB9ifBk63gRdmrp76oZmDvQBz02lSM42Qxi4tSgC4IS2CR5gMTH1AyfuaQ+GGGlXYB+9N9eQqybfIuLOn/Xkj/E8Sy3Xpxi1BoRy86Tkfz+KYHEx2vg527ubC6w59RZo6+V+s1gHVAIxa6NSLa4dBi/zGkvhxzxNX8/+Uv6jCBhs73vfbEgJix3UMYJKWJyhGVeEtNnU4VX5xK5UhP9xM2j+XyjBQ+prJAOcwZz90vB8c9bbouRYrWvvmJXgqBeJySFpl3e4iu0tmizQsAnjqKP2xG2fN8BUaT1WvTJd0z4j+fZrgUX8wmLBwEdx5uMOol3wTBdO0ILlIiEMXmccb1S5Qc9/KSpFDxUe+BR/duD98YqG0g0XX2UUxIYDeI0eDTv1bYKQ9sPfzBPjIlbLALuUlyp1IbO4Hi5vXkAlMcylk4s5MuQSYSidnrQ1vPRpnc3/5SkkDCkIZiokbKs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(376002)(136003)(39860400002)(346002)(396003)(41300700001)(6486002)(36756003)(2616005)(6666004)(2906002)(83380400001)(478600001)(316002)(1076003)(52116002)(66556008)(66946007)(26005)(6916009)(6512007)(66476007)(6506007)(8676002)(86362001)(8936002)(186003)(38350700002)(38100700002)(5660300002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MJZ4kWdikNsdZh13CTuFW2UV+ExO8FYZbBXH2Ym3kNXguQVfuadMzQQGK63V?=
 =?us-ascii?Q?IlhtHSMPNPcYtYuTPywbqtmkWw1tmh47Ayu0DddEFuJ1mJKXdOvYVcVqBrTA?=
 =?us-ascii?Q?I/wxRDe4GUmjvH4j3i4yv9cnkd6ahA3dcGve6Bew4oilJL2EHR0j5pOE+CjG?=
 =?us-ascii?Q?r6q6/4snnW193+Ap59TaPWCN6KrQpyzhjc33yOwtDleGvhyh6bkzEolAdJLi?=
 =?us-ascii?Q?XJTltSKuXg45bsQjcR/Pz9Yk5q/ko3CHLsmkM6gOoQMLAWDMZzhVX5d/5YTY?=
 =?us-ascii?Q?0/Yx/TssDWy7FRJxt/Osd6dGCLWVMXcasHY0ZQx3xoG/lBO5CyJ1rmYfiPk5?=
 =?us-ascii?Q?uy7sJR+ETF4hqj4qRvrdTp4dKL20Mol0pr8j4PQqxddEglVAeD0VEf/EhOmh?=
 =?us-ascii?Q?cxJOARTIAn5GXbCUURGEfRh1HymUCwkJw7vO3i5s/yM8lP6FLmDgb1fse3mo?=
 =?us-ascii?Q?eiMqFWPQOuLm3JAVNfePEvOHO772K9DXKW8954yJD9fw6cCguVWOkpCPBKB3?=
 =?us-ascii?Q?HRLwt/0R0VHgF6QlwY6dJZeHKfPvfFLP99muBxzaugPd9TKO2ftYCC6qFicL?=
 =?us-ascii?Q?MlrckgcC17ccTMSO9hnwutE0K/fCzLdqVZWEsW1hPCf/5yfgjOlHpaXiuFnz?=
 =?us-ascii?Q?XucPw3iIQwQr3wrKqJ7uq2aUfpAtycyRuVtmasp6wkUKvJM+12M74Q5ea5a7?=
 =?us-ascii?Q?ggpW5U4D+qL/qgT3LMklBd8mQIAcv0ddyufcHrTA6hAPQurNZMsWsCcVmFL4?=
 =?us-ascii?Q?TjkNL6rB2ujurmE4yL7im+939/17H0FOmAjKNn6F+vtQfhpKJDjT6sMLJtuY?=
 =?us-ascii?Q?Kz3MDNGTw5IM6Upm8zym0lYrz+FxnepGGmDeYs8RCUSz8ibDX8rzqaHvZe1K?=
 =?us-ascii?Q?gv8VKvnyf+5L3aJ8058apGFnddzPSVDFfItQH0pIAvrEKzkofvhHlVJnH8Cj?=
 =?us-ascii?Q?xHyKnDaMD2SWwIJOum3hnEdBCvPTSPMKwoKBAEOuwXa/2nMH72k3pJFQMsml?=
 =?us-ascii?Q?WcZd1UUAhtMqZ3ps0h9jE4p6xwcb2ADYsFMgnCwibpivyu2V4f3dlzUmWu2l?=
 =?us-ascii?Q?aQ5x3LZjWv4Fiq+amguShArenC919reoTqgwdlolFLaohSry4uMj7ROHExmw?=
 =?us-ascii?Q?MUH08x97nY4Bfi+z7UoCYEw323o04NBlSUofaa1P01xNNlqOD9KO+o7/TupV?=
 =?us-ascii?Q?N/UUme0QFcmNKOXjcJ7BBtnexDM5M9zOB0O06pfiCRcClnlMnmrgZjcJg1FR?=
 =?us-ascii?Q?lV/iSCVYabdisvLUiSG5gdWMAVRDUAsW7OXaDcE3WuIh5qMKWx7Lvors1E2d?=
 =?us-ascii?Q?Bb16+tSIAnNQMjkrZ0ZCWwx5KTYIyunG40SmszPogU7c2AX8P/TllH5qJFDF?=
 =?us-ascii?Q?kv/5HZDpV1cLpDXYVbTgwB4DveZ2Eh7e4w8ZMjriN/3ZEjDDL2nHMQKUQZXj?=
 =?us-ascii?Q?Ir0PdccToLtejNkOQuCry8BlIVaMQJVG2lhxBmLpwGXPeGBvoFanXKyRM/4f?=
 =?us-ascii?Q?w8K6PTDdVTijI8fLZtVjOSOrdii1WNyeYL4n+rXHA4PmnS23C6vblPAR1j/8?=
 =?us-ascii?Q?i9g9CKzAeeA1DrkZ1HP9qXjWLW5komUqxvU+4OPxAmzhVza7oXf060bGE1jV?=
 =?us-ascii?Q?6w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17123962-b702-4bbf-d586-08da76512c60
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 19:40:23.6255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1xP+IbY5NocM/qfX8xR6Nj1RSyva7xb5To+OuBge6XIHXiEXdcHYVJbfwSmbtJwVDqfVaDsEIWjbRKyUqCGfR1JnsZ1C5Jwmw+thR+LJD5M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5040
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208040085
X-Proofpoint-ORIG-GUID: EzWYpSVY8GWO21iDX2cp5r3TOu_NIyUO
X-Proofpoint-GUID: EzWYpSVY8GWO21iDX2cp5r3TOu_NIyUO
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add the new parent attribute type. XFS_ATTR_PARENT is used only for parent pointer
entries; it uses reserved blocks like XFS_ATTR_ROOT.

[dchinner: forward ported and cleaned up]
[achender: rebased]

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c       | 4 +++-
 fs/xfs/libxfs/xfs_da_format.h  | 5 ++++-
 fs/xfs/libxfs/xfs_log_format.h | 1 +
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e28d93d232de..8df80d91399b 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -966,11 +966,13 @@ xfs_attr_set(
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_trans_res	tres;
-	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
+	bool			rsvd;
 	int			error, local;
 	int			rmt_blks = 0;
 	unsigned int		total;
 
+	rsvd = (args->attr_filter & (XFS_ATTR_ROOT | XFS_ATTR_PARENT)) != 0;
+
 	if (xfs_is_shutdown(dp->i_mount))
 		return -EIO;
 
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 25e2841084e1..3dc03968bba6 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -688,12 +688,15 @@ struct xfs_attr3_leafblock {
 #define	XFS_ATTR_LOCAL_BIT	0	/* attr is stored locally */
 #define	XFS_ATTR_ROOT_BIT	1	/* limit access to trusted attrs */
 #define	XFS_ATTR_SECURE_BIT	2	/* limit access to secure attrs */
+#define	XFS_ATTR_PARENT_BIT	3	/* parent pointer attrs */
 #define	XFS_ATTR_INCOMPLETE_BIT	7	/* attr in middle of create/delete */
 #define XFS_ATTR_LOCAL		(1u << XFS_ATTR_LOCAL_BIT)
 #define XFS_ATTR_ROOT		(1u << XFS_ATTR_ROOT_BIT)
 #define XFS_ATTR_SECURE		(1u << XFS_ATTR_SECURE_BIT)
+#define XFS_ATTR_PARENT		(1u << XFS_ATTR_PARENT_BIT)
 #define XFS_ATTR_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
-#define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | XFS_ATTR_SECURE)
+#define XFS_ATTR_NSP_ONDISK_MASK \
+			(XFS_ATTR_ROOT | XFS_ATTR_SECURE | XFS_ATTR_PARENT)
 
 /*
  * Alignment for namelist and valuelist entries (since they are mixed
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index b351b9dc6561..eea53874fde8 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -917,6 +917,7 @@ struct xfs_icreate_log {
  */
 #define XFS_ATTRI_FILTER_MASK		(XFS_ATTR_ROOT | \
 					 XFS_ATTR_SECURE | \
+					 XFS_ATTR_PARENT | \
 					 XFS_ATTR_INCOMPLETE)
 
 /*
-- 
2.25.1

