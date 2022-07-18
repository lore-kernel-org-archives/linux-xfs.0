Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C563C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 20:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234253AbiGRUUo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235196AbiGRUUi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 16:20:38 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B482CCAB
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:20:37 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IHZ5Gn026736
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=QmqzOcgnG9Wlu661xvk4KAibIhyTM3ZJiJGmHaN7aO0=;
 b=Jv2oSPY2y8pOKigkN9ZQ7EYdqBDqNVyHrmjAcSDL6Dpb4WPqLnTxXa/N1IdsjADtcT3n
 b2QzYVFFqyRZses1KPNHOkaMVLDq8Jd3v1q4cNAcvZ1ZqJGAzs5lEEn/eX49sBwrE2B2
 MOzoVwPSFTDviOrunun4ZEImIeZhbxcMNfhoVjmo/iVPi9e+MFrp+f8LdXIoNEYonXNj
 R+FI4WNngzJZwXX6SFzvmequvUsJmk4qsQmA4lHd65vgwku6Zs9p7TOg65Y2dgRc5L0A
 gYsSmw2shlA6/0L0Kc0A1cFc/sGstI+AT4eg+b24PbPZ4CSQ9dnhHlO2ax6janrA7BFy TA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbn7a4cg2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:37 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26IIp4tF001290
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:35 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1k2sfbn-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CskFLjcEDJEAaxpEKagb53D6AzWglH/NWOC5jQEDk/CeZ2ecglkD5vxwB787EmDTL+1esCZ0envUBz7P8d2i/TFOFArpdW9dDQtHSL60nOhgEdIhmv9R+y4V5gBacTu6t59zc1pfPSfreeQPeaV+WNaIiu3c9Hi59BM3f63EKUOjIlxVMbp4NNBnZJDkCGKbj17WHJPvaJfS8gDR5xP71Kl6QLxyNXpzxfgdjJlTPC1WhMNJON3RFULIRxmP+2NscZ0+YemMkW+ZmE5oblLOO4QK+6RsPt2j/U7I2vxNPFvGJl5504EBjlmqFmYvG/WR9ILtGjVFwd5q0jtQbCKRLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QmqzOcgnG9Wlu661xvk4KAibIhyTM3ZJiJGmHaN7aO0=;
 b=c2jqQTV7pVjqLOgY7LDR1mUC7hwcyDhZQzc+/J9FqiJF7MvGd8y3GuIgjvNm87nQCsTOqn7IBodLleTAUYyEzBh0h8akQmYqcdrz3KekfHvEg2nnzY+lL8/K579cCydh/XgcGTKGM9YKI4NONOCY5w76XlQbjMOQ125V9h7G9NrLGHD+TThKKz8MPfujcSakyHaHcuX8F2ud9CfDIOzQeXQOnQqiss5GECqFlhQKvco08VDjwcWu9eWyZVN2geHJoTfJN+3jePqRwUND4cRyMn7TSycrK2UopnmqUtFl30GmolSR6MT29L08W9TY3tERbxvnyThiA/kayN2AMHux+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QmqzOcgnG9Wlu661xvk4KAibIhyTM3ZJiJGmHaN7aO0=;
 b=PuBFp5L6maZznvARXAQIRK+6as5MoR0OZFZ6EoMfNorIIBO1Ohg7GOFbir4UryBs6ZVwZuS2llbvZp/dOIs7m4jgGmNamAxG13NdT+UHWic42nztnD6ebHcp/vg1BjUjhRT19sRbRnT/Q+AtrU+yjbOihUa0bLkoj8bgCblYwmI=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS0PR10MB6128.namprd10.prod.outlook.com (2603:10b6:8:c4::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.23; Mon, 18 Jul 2022 20:20:34 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 20:20:34 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 11/18] xfs: extend transaction reservations for parent attributes
Date:   Mon, 18 Jul 2022 13:20:15 -0700
Message-Id: <20220718202022.6598-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220718202022.6598-1-allison.henderson@oracle.com>
References: <20220718202022.6598-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 199cf843-40ca-42c6-7a9f-08da68faf6ee
X-MS-TrafficTypeDiagnostic: DS0PR10MB6128:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gnFnHi7bjmLobHQe1PSU9Uw2fvkWXvj3UWd28RxSiomSVtBlVA+gwPRBVMwtO7dmW7qBAiwyUkv8NhaO9ZAUxpqwn9ubmTT+TGHYe0VEoYeNQAZdvvDwXTcpoyEPBmR+sbToavmazDs/WJXMa3WkFl8PDWGuszN2dbrBu9D9Cj62rqJM4KPv8c9Y2GVSkV9NfwBMyHxQHGC5u9vtJeu/kmFewuHytyT0rKDfxAvCP93TzIVLcy9w/CR8Z3usvjqP48EU1BRf9RAzy/6aeZYXU8W6HTfAQ2Aj8B2T2Zg5+BTPTlGvI6UbhpgV2gHKr2I7n52+wA9FX2Bi6sfqz2FZYHGYhoq8YwxuQFytTtF0AgYQRynfmTSsvm6Di4eH5mvYePC2R25530Ccpd9EXfWEk+iWM4AVKt1IzbKr4saofcsSwzVjlVJMZfbGppwuajtlKXlzLEpIS3ppDgfwfguw3EcvW2QXgEFds0Gy8OJ2rTezCi8LKpl/j8NGO9Bnvi06ks9JgPMWjRfd8a7MSTMjMqtT6SrTFeDghwxSR07FUaib0ccAKsbIx0symmL/jpsVb/3SbsXp8cgvBlCMAQ+aTm2Aw5Bo+Ny3VChYBe5Aye96M6YnAEAO5xSlKfM8+DKgasQ0IYjjBD0Ya87/yXphDGBkascVvSFEqbQd16aKRfelnt3OlKk/0E51ZsNLTWlyXow6Hx+7ZLJ8lncvHwwcCpPApVh/XlWMQcEBDIlz895tDNEy4zrrW46nb6Ww3PAj+c40NqwIcZpUWu76cZDVyacQtFSnlJc2KsbrrU3J0FQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(136003)(376002)(346002)(366004)(6506007)(52116002)(6666004)(41300700001)(6486002)(83380400001)(5660300002)(478600001)(26005)(1076003)(186003)(2906002)(2616005)(6512007)(44832011)(6916009)(316002)(66476007)(66556008)(8676002)(66946007)(8936002)(38350700002)(36756003)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bydyVIxUdZ7+v6FEZh7ng6dFeQ5ivPeOSF1Kj2sm/pFI7xtVm7paLKbc3F71?=
 =?us-ascii?Q?+S37wEwC7LcvLS9J+9t+mFf5jZJcBlC6mFDd8l8ZCfLQSea3B0k5x7vhEhij?=
 =?us-ascii?Q?+nJyzq4kHpNLxcyo76d9NGK6AKF7gD1EeQ/VOL3189RhMVu/Gr5h8CGS3Ji+?=
 =?us-ascii?Q?tbIPksZgpC97+4EVWvepWAUi25M6AOwD1AQUqHiDw+4/R/rQ7qCs/+fA4dTM?=
 =?us-ascii?Q?PI0/XdpcvxkZn9lFDtL2386jmxunsb5Gzj31yHcxssYUvRazR1oz2U4YUyez?=
 =?us-ascii?Q?Hj2+/zRUmHPvPqninul/ZXM32l7RsA+hmkSvmQPMyvhKR6aZ/j8W1vAEQclA?=
 =?us-ascii?Q?/jcciT/ZaeYgmRFcDer3FycUxarrN3Oc6S/YOM2kDjfbkMDrjcdpulzv+PF/?=
 =?us-ascii?Q?FCx5SQ7fbzAZVo1P0KrWpwrs0Rd4MEr1lz0DEgZ4uu0CIgtSuQDZM+/97JhE?=
 =?us-ascii?Q?ifHgdIuwWL9U6KD5+noZwhME2HciLt7ORpAOfnPwnuEs4wIRSrkRdAH65Njh?=
 =?us-ascii?Q?HfuXc4jZRVz2XjPUZJNVdJ1G3MTD6jvevWjSMAl/IA/H3EPirk1HOfV2N6rF?=
 =?us-ascii?Q?AxerJq+oMwd8UkHif8WODi2YB3rlxesuafKEXqRq/COQgio9RePEsXSYFmhj?=
 =?us-ascii?Q?TS6ZPZIGRxQhEQz1ZLq49JOlMLQa97COdkMSvvIvC9Pmh9BQL7T7Ts8+LSg8?=
 =?us-ascii?Q?uboKQ8bKqn+5gFs28xhYgwt76+N6/449Rb54HAzRdU0UcYxf+TjVgLYjCrzQ?=
 =?us-ascii?Q?du9fsb9CIsTMjc6PHG/DDatR98Ge6BXY29LoBipVhbq6U5tsYt2hvddnMig8?=
 =?us-ascii?Q?mzdrOH75spFWmFWc3CFDG4K1M1g4zEdl+d4KTZm+k6imrxJnRCZ65RPGf90E?=
 =?us-ascii?Q?yhdHxjqwA/4W5/4Jqsh/MWsQvul2n5IEy82FwvWbZwnIi+DtwwHE/N/qKNTQ?=
 =?us-ascii?Q?f2Ry2V851KJN7Pk9S5fN2kYBtqRvBQuDNsUshk1IOoi4DTtgurOM7ybP/H4/?=
 =?us-ascii?Q?PgaPThNTY/kijPP8ObIJ9QA6OvCBV2eZxKluF/h89+6ZbUAo3QJoBc5WbjjF?=
 =?us-ascii?Q?xq8VnZfjofd5k6EDj34VAmk4ozlcTL2iFsoQJuUo+pObL665Ue2TUE6/kr1m?=
 =?us-ascii?Q?mSBNXKioYTrlbNm5ZkHqJvJIL0snQ5P6blSZFUe9Bj/MXEBqGDk5XHdq44d6?=
 =?us-ascii?Q?6NrmSiPfXhd+sKySeWjLi2Pz8UeVJNvvU9EKEGqEG2BuWpJr2gLclK3TN+UH?=
 =?us-ascii?Q?rrdFnyrvPtFrcmEE5Sp6koYu4vtFDqRjssLzDZRxtFaAWXKddB2CMA4z580B?=
 =?us-ascii?Q?TvwGCEsNCMiggkiloaKI9Xba7Dq1KBVy4/wW+EQ/lEzN5VrmEzDj+17M2mRY?=
 =?us-ascii?Q?xmk+U0BM/ssKW7E7HGfcqnrfVijjo5gB7GZYAJYsEYof27WMSHnqqYexHFzl?=
 =?us-ascii?Q?+gKTE7O9dMyQ5R8i8dkgbhFL/DGD1o36WgTI1xcfqI1n/xPi3fARGoA88cKy?=
 =?us-ascii?Q?F6vQzMATJ6yaOzxgr6UW8HSFsdLyx6sOqKUfvyYahClmDVhO1r13H5wl2Wdf?=
 =?us-ascii?Q?7FPEuKEeg4agPp6UvIkwWATxSr316ckuDUlwpxY5rLlJu3rB9VXSucrs3j+F?=
 =?us-ascii?Q?kQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 199cf843-40ca-42c6-7a9f-08da68faf6ee
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 20:20:32.1702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EekSEoHDsTOMuR2Z6zFbzZokhBaFPBf35wtjoNT8xqn5M5Tf3DthxtzheR7QocorIjjpUZcHSk7b36o4fx3bkFjRF62LB+JRxQqCWCTk+k0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6128
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_20,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207180086
X-Proofpoint-ORIG-GUID: N2RDSNJzoShwmLT5acAmbjCDPXY2YsLm
X-Proofpoint-GUID: N2RDSNJzoShwmLT5acAmbjCDPXY2YsLm
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We need to add, remove or modify parent pointer attributes during
create/link/unlink/rename operations atomically with the dirents in the
parent directories being modified. This means they need to be modified
in the same transaction as the parent directories, and so we need to add
the required space for the attribute modifications to the transaction
reservations.

[achender: rebased]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c | 105 +++++++++++++++++++++++++++------
 1 file changed, 86 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index e9913c2c5a24..b43ac4be7564 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -909,24 +909,67 @@ xfs_calc_sb_reservation(
 	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
 }
 
-void
-xfs_trans_resv_calc(
-	struct xfs_mount	*mp,
-	struct xfs_trans_resv	*resp)
+STATIC void
+xfs_calc_parent_ptr_reservations(
+	struct xfs_mount     *mp)
 {
-	int			logcount_adj = 0;
+	struct xfs_trans_resv   *resp = M_RES(mp);
 
-	/*
-	 * The following transactions are logged in physical format and
-	 * require a permanent reservation on space.
-	 */
-	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp, false);
-	resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
-	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+	/* Calculate extra space needed for parent pointer attributes */
+	if (!xfs_has_parent(mp))
+		return;
 
-	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp, false);
-	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
-	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+	/* rename can add/remove/modify 4 parent attributes */
+	resp->tr_rename.tr_logres += 4 * max(resp->tr_attrsetm.tr_logres,
+					 resp->tr_attrrm.tr_logres);
+	resp->tr_rename.tr_logcount += 4 * max(resp->tr_attrsetm.tr_logcount,
+					   resp->tr_attrrm.tr_logcount);
+
+	/* create will add 1 parent attribute */
+	resp->tr_create.tr_logres += resp->tr_attrsetm.tr_logres;
+	resp->tr_create.tr_logcount += resp->tr_attrsetm.tr_logcount;
+
+	/* mkdir will add 1 parent attribute */
+	resp->tr_mkdir.tr_logres += resp->tr_attrsetm.tr_logres;
+	resp->tr_mkdir.tr_logcount += resp->tr_attrsetm.tr_logcount;
+
+	/* link will add 1 parent attribute */
+	resp->tr_link.tr_logres += resp->tr_attrsetm.tr_logres;
+	resp->tr_link.tr_logcount += resp->tr_attrsetm.tr_logcount;
+
+	/* symlink will add 1 parent attribute */
+	resp->tr_symlink.tr_logres += resp->tr_attrsetm.tr_logres;
+	resp->tr_symlink.tr_logcount += resp->tr_attrsetm.tr_logcount;
+
+	/* remove will remove 1 parent attribute */
+	resp->tr_remove.tr_logres += resp->tr_attrrm.tr_logres;
+	resp->tr_remove.tr_logcount += resp->tr_attrrm.tr_logcount;
+}
+
+/*
+ * Namespace reservations.
+ *
+ * These get tricky when parent pointers are enabled as we have attribute
+ * modifications occurring from within these transactions. Rather than confuse
+ * each of these reservation calculations with the conditional attribute
+ * reservations, add them here in a clear and concise manner. This assumes that
+ * the attribute reservations have already been calculated.
+ *
+ * Note that we only include the static attribute reservation here; the runtime
+ * reservation will have to be modified by the size of the attributes being
+ * added/removed/modified. See the comments on the attribute reservation
+ * calculations for more details.
+ *
+ * Note for rename: rename will vastly overestimate requirements. This will be
+ * addressed later when modifications are made to ensure parent attribute
+ * modifications can be done atomically with the rename operation.
+ */
+STATIC void
+xfs_calc_namespace_reservations(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	ASSERT(resp->tr_attrsetm.tr_logres > 0);
 
 	resp->tr_rename.tr_logres = xfs_calc_rename_reservation(mp);
 	resp->tr_rename.tr_logcount = XFS_RENAME_LOG_COUNT;
@@ -948,15 +991,37 @@ xfs_trans_resv_calc(
 	resp->tr_create.tr_logcount = XFS_CREATE_LOG_COUNT;
 	resp->tr_create.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
+	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
+	resp->tr_mkdir.tr_logcount = XFS_MKDIR_LOG_COUNT;
+	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	xfs_calc_parent_ptr_reservations(mp);
+}
+
+void
+xfs_trans_resv_calc(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	int			logcount_adj = 0;
+
+	/*
+	 * The following transactions are logged in physical format and
+	 * require a permanent reservation on space.
+	 */
+	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp, false);
+	resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
+	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp, false);
+	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
+	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
 	resp->tr_create_tmpfile.tr_logres =
 			xfs_calc_create_tmpfile_reservation(mp);
 	resp->tr_create_tmpfile.tr_logcount = XFS_CREATE_TMPFILE_LOG_COUNT;
 	resp->tr_create_tmpfile.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
-	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
-	resp->tr_mkdir.tr_logcount = XFS_MKDIR_LOG_COUNT;
-	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
-
 	resp->tr_ifree.tr_logres = xfs_calc_ifree_reservation(mp);
 	resp->tr_ifree.tr_logcount = XFS_INACTIVE_LOG_COUNT;
 	resp->tr_ifree.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
@@ -986,6 +1051,8 @@ xfs_trans_resv_calc(
 	resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
 	resp->tr_qm_dqalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
+	xfs_calc_namespace_reservations(mp, resp);
+
 	/*
 	 * The following transactions are logged in logical format with
 	 * a default log count.
-- 
2.25.1

