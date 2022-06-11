Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AF0AC43334
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 09:42:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiFKJmZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Jun 2022 05:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232608AbiFKJmR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jun 2022 05:42:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35B560DE
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 02:42:14 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25B1hwNo021516
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=rJetYnhE34E5V1I38EQLNvmIRRtMx6Tp08CJ5Rl3wI0=;
 b=p79+rGwzNln6Lysao45j0BhbcFMSe2zi0s+gI8Q8B4kC/AKpCp+VfNkR8rpYjIjd/01V
 BLej3W4jIw3Wa+RTbSG5aswTpKJsC9NAbeMD21rJImDCvdaGYt3dRs2OPUdp8lPWoySN
 jeXdFNQO5MwU8nLGOzyxhEIPUrCq1+WhTnkziYO5UGeNDpav7Hx3QjKx005+sK0fwHaM
 SiR7/9byLo3afmNqWtujzFYrbCJp26HuZ3JixTSo65eIN5eyaE2k33SAIjco+NfISZ8E
 9rQuHjPEWZ42PFIrMqyXe2K7hK0dW3QJK9C6OJR7dHsiCqsAQgo7IKj0qI5mPe46V/vk mw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhn08c71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:14 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25B9ZMQD025527
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:13 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2046.outbound.protection.outlook.com [104.47.56.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gmhg6urjp-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lWmO5Jk0yjLUrS5017hcIZ30T9ZCvFNqWhEekARY2rplebb2Wv2NUf91yPuS83+Ka7zprwb4HnyKSodhqSW7rnS1HvwmNv6ZgCWK/D+rILq9wmDA92Kw7WoBOY0OlNC3r1RUAulY34QF0bo8bqTriGcRj7StRedCfdPrPlpH8XoQU/EGOIhZECtdNZTWo6NupyKm6TY09vXyhwrHHtV0Gs25NX+uhCdpsLqAGp27KuCxzZEfq7JsJXvIel4a05JNHD0cMSWm4sS3Ao4AmIZ6FgUKmlyF1dj+qcvIf4ZzB3MmpAHpUFuRDGOx1rG8slua4XTJTM3bbY3HFHFcJauK/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rJetYnhE34E5V1I38EQLNvmIRRtMx6Tp08CJ5Rl3wI0=;
 b=kO433S2vHapwEKWnOc4f1pC4iYewbuZWoaUw9y26+XHl0Slt4jja2+GvVe/ROn5H6lPfdUFNPmra34jzCWkZ4iDJXlA3pfx/0OuELRLTuGbYMFKswdiO4JbpYNwDGZZIVADqpgrt+ef1vuNEQzu7MdL/ffaVOqyWCzgNfyY4B7CT17MUuVkpNB2Xb6cdJx2l62AgOkCaXyzkasQ5ohSuzaYzeznZ6xITVGS0hp/NXzfP9tNCnjiGkGkHTxL8aoJT3v6/fkY0l2qxpZu/GZK76WrFrQvM9npwu+IX8rmL9I1qafdanLy5gtyeE9GClUk+4DeRlulMYGy5df8JsqWM3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rJetYnhE34E5V1I38EQLNvmIRRtMx6Tp08CJ5Rl3wI0=;
 b=fxuP7xjxGhHDeOYXjpMCIokskf5MnVTV/SO34GXfK2HXngVMWZxidXBCeBp2si9hPHDTb4mrjPxdIrxQg5LNnXfT2MJDBjZxQ6Fy8EHiflMVf6QMUqFpE8B3QfvCplIieDUSAguujKsuaBd1NmoEsqaceQn6yCPkINaExpVcaVk=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4606.namprd10.prod.outlook.com (2603:10b6:a03:2da::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Sat, 11 Jun
 2022 09:42:08 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94%7]) with mapi id 15.20.5332.013; Sat, 11 Jun 2022
 09:42:08 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 09/17] xfs: extent transaction reservations for parent attributes
Date:   Sat, 11 Jun 2022 02:41:52 -0700
Message-Id: <20220611094200.129502-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220611094200.129502-1-allison.henderson@oracle.com>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:a03:180::15) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06ef282d-2cca-4aa4-77a4-08da4b8ea6f4
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4606:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4606707F6E3976C43D4A55B395A99@SJ0PR10MB4606.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: saw78AQF5D2CwbBrVetqG6DiGmMPuE2CEMSJjRu7l3jLEuCdozINT98Um1+VVtey9wUgnWU39nP/1mvBfBwVvuCv2+Qv6SMJxlEIRFcVEfvUkTHTaLO/QOlGCNBmCeU+RNH6zcSvW+GM0I9xR5TfDEzC74SLnGb+GjarBU7PtNuC0KW8lSyLYkLO+jPbnfmYYYzSWhOZMHthuUb5fNCvL0b1WtYqkyq6oEQOGLwsG9/c8ORrDNwwq6PEJ/Sq7u7jbNqBc4lnuVj5p/MOMwFhg4fhze7Yucp9rEv9g2WrBEs90q4PS2doxM3IltZKdAMm8hT4drzP/37qlCEnbvhNr340xJM/tzf+hWK/m/i2cT++S8P5/4dVYuSQhVaQ/g4AOcwbuNlotN5ntU3ItFzSYKszvnj7p3jNB36KOwi27JgVyrTikrzQ2snCv7CetpKKOYvaV38nV88yaF9sxOwmSMnL3pe7EcAjp1rSfj8SR+4RCguZjxAPAGcQlUkmQ3G3S2JTzcq4N8XKpb5IpdedgEutWkVDvzVZO30vmnVWI2L1AYkGNMEJBKxMeIIr6mgLbQ7iIyh7azlvEomOQDi0/JLbAzADuYFcL+7H0yR/E5Xx7OfD8E6J/cG5WoV9c9xnlP2e41swpDX47IMZMP/swxBZlgoiEebEtmA8F8Z2W+Lfax2p9RQ6Pi0Vh9VydjoY8kp8WCpXvZFfgsOd1MLPLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(6486002)(44832011)(86362001)(2906002)(186003)(83380400001)(36756003)(66946007)(66556008)(66476007)(8676002)(5660300002)(508600001)(8936002)(6916009)(316002)(2616005)(6666004)(6506007)(52116002)(6512007)(26005)(1076003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dfND/qI/fxlNz5ugabNLN8TIcy+57kbXanwKKcpti1n6Cr1/tsL1qJnVnK1u?=
 =?us-ascii?Q?+z9BIYjSNhwnS8Qww60vx/889hLTbstp8spMScxmnnyrWIZke3KNllZwlMnk?=
 =?us-ascii?Q?0iiJvDuBhPD59g7OsvKP0B8XL7xUDztYFnSzVufTWndDQX6Wc+d/NfVEC/tU?=
 =?us-ascii?Q?rscud+5v226K+Ooi9z3bEt1uRO7LD2EHAE+uikbkXkT+6zAvy40X4kjJI5H4?=
 =?us-ascii?Q?dCwvUuxfehih6hso5FJpb+66oAb0gAdd1xJyasQpZ8EOUDcT0pLq6hqzdz/9?=
 =?us-ascii?Q?uaSfe+BWoqkiCsMEptqX6QK+KivnNsSNTyvonZRMUTj4ANXP6GAG8ThEWzyF?=
 =?us-ascii?Q?HPkVC5Bp15aBz21sI2M7pIHZKkl/t4NZQRdy8sRzXyplmhqH+mLg0+sY6b5W?=
 =?us-ascii?Q?OXaJIV35lQ7NFkJUHqiEUMpc7/SF7YTMdW/dgt+hg71Uyt5k5SV7TO946Fzp?=
 =?us-ascii?Q?xskxtWGktTlgm907S63EyMPQ9KRHgTFu/YfNqUK9tcfHLWWHH3vJxgmKpxVF?=
 =?us-ascii?Q?eiv+XxVy45GhhfFPYVu8dV0CyKh4NqamhERfCWdSGjIsiQ7D1NBtJAw5t3NQ?=
 =?us-ascii?Q?IOAhtAB/YiQVGRlxPMTABHz80B3tb7+0X2ANCMvAKRfaaV70nAXCehPgdS87?=
 =?us-ascii?Q?yC+L9/opuBxwzC75COlS/gI3UdKTSrytiuY9cWXx78v1Tmt+esjWtGCIuLg+?=
 =?us-ascii?Q?DQ1MVVsatFDsiJiJPF/5ekhURM8MOOmJDzlfvd4pyvxF/nMyBVgSUqe+IyXK?=
 =?us-ascii?Q?QaMeSzEYK2R7LrX7EMk2kYKX8CdOjME6PHeq+C66211bKdM+PQV9QsPIEV2d?=
 =?us-ascii?Q?TsyJTp2d6hi9k/iRqUVrJN91Ib/Hcm+M8gQLBWjUG6PWOc+qUuY7OSGOoRxY?=
 =?us-ascii?Q?+tbXWNVdnZfWUyqD0XByl8gvuKHifm2qk/UHlRepBWyUi9V71+6oMIomQanx?=
 =?us-ascii?Q?OOafs17q6Aj2ICf5fRhf6FzsJuKbj/W1teth5RFGNoVA5g7P9Eeca8XG9Jm8?=
 =?us-ascii?Q?9H8W6IOQIRw+ZJ0EpyJ6MoT5cS/AZ6+lKmhrzZTlx5so0fJMGGTO/S27UIZR?=
 =?us-ascii?Q?EzSE9rcpul9GqoUDMKvuZorhr2YgjmmtMsTxfsghPLtpc7XGKdfH4+IIRDKY?=
 =?us-ascii?Q?fI2Ca6MmGfM4Sn//fC1n8rasLWnB9cM5DRL7BFg/zVZWrPJ+KRC7BDCOIPhe?=
 =?us-ascii?Q?o88RfZXn2N1iFxLT/X3Jx0QcoSEO2tuehbBRsa9CPC3xo5VIvbgNSd0CevPY?=
 =?us-ascii?Q?5wSmIQybCLR/Eu5nBa0t/vPgjOfGMH0W0ddguQSgo5/jPnsanhTQ+iBJkk71?=
 =?us-ascii?Q?Cm56nXRly/oDSN8T0dPEMf+aKwQ0k017+fs25kiaEUiSHPL5aZvsmvYMrGfy?=
 =?us-ascii?Q?fo3jEUOkB7WMeW3dJi4j1Dt396UNSDYk+pk75CBiqXIMeHzXWia2Idx94MPP?=
 =?us-ascii?Q?U7Lynq4D/G/Q1yhaX9ppgKHUYYRa4HP9wG0udITg3LM1SoWXBg/enE76On3b?=
 =?us-ascii?Q?OR8P3wJylgozVAvOGHwqXPtRcWFr5AXwayJ1NRMnKN6l9kHSmvYwniliF6Ko?=
 =?us-ascii?Q?t9G2YRVpw8Mu60dECRv0DHgwriXyowGZRRr6Wq6T6HwvUbKeetQ6DL2bVFOy?=
 =?us-ascii?Q?ujQD3Q9OiFt+CxIZUTdiVXAeLA4w2zQIkKV2BJrdf046MGzphyfz9BFmevH4?=
 =?us-ascii?Q?BWOGPMmoI4Mz0RNjyNqL3TKjb7RgmuOjMZkGxOTKxlQCzo2k7N3jHRfl8r+v?=
 =?us-ascii?Q?6KtMr2kj5TuFqtgaGD4xZfPSa7EmUpA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06ef282d-2cca-4aa4-77a4-08da4b8ea6f4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2022 09:42:08.5918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dx9A1bQxJ3ty3L0pvxti5zlSm4csRSCDeZW9OTp19SA74anK64ykWlRr4uloJ5HlMeydcvZFdYPbhPwVP75XsqgJlT8iBxYeF7RqyfOS5f8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4606
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-11_04:2022-06-09,2022-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206110038
X-Proofpoint-GUID: ZxEIjrYC6o7U2wRFgA6d5_gaORTrnhI4
X-Proofpoint-ORIG-GUID: ZxEIjrYC6o7U2wRFgA6d5_gaORTrnhI4
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We need to add, remove or modify parent pointer attributes during
create/link/unlink/rename operations atomically with the dirents in the
parent directories being modified. This means they need to be modified
in the same transaction as the parent directories, and so we need to add
the required space for the attribute modifications to the transaction
reservations.

[achender: rebased, added xfs_sb_version_hasparent stub]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h     |   5 ++
 fs/xfs/libxfs/xfs_trans_resv.c | 103 +++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_trans_resv.h |   1 +
 3 files changed, 90 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index afdfc8108c5f..96976497306c 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -390,6 +390,11 @@ xfs_sb_has_incompat_feature(
 	return (sbp->sb_features_incompat & feature) != 0;
 }
 
+static inline bool xfs_sb_version_hasparent(struct xfs_sb *sbp)
+{
+	return false; /* We'll enable this at the end of the set */
+}
+
 #define XFS_SB_FEAT_INCOMPAT_LOG_XATTRS   (1 << 0)	/* Delayed Attributes */
 #define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
 	(XFS_SB_FEAT_INCOMPAT_LOG_XATTRS)
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index e9913c2c5a24..fbe46fd3b722 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -909,24 +909,30 @@ xfs_calc_sb_reservation(
 	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
 }
 
-void
-xfs_trans_resv_calc(
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
 	struct xfs_mount	*mp,
 	struct xfs_trans_resv	*resp)
 {
-	int			logcount_adj = 0;
-
-	/*
-	 * The following transactions are logged in physical format and
-	 * require a permanent reservation on space.
-	 */
-	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp, false);
-	resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
-	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
-
-	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp, false);
-	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
-	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+	ASSERT(resp->tr_attrsetm.tr_logres > 0);
 
 	resp->tr_rename.tr_logres = xfs_calc_rename_reservation(mp);
 	resp->tr_rename.tr_logcount = XFS_RENAME_LOG_COUNT;
@@ -948,15 +954,72 @@ xfs_trans_resv_calc(
 	resp->tr_create.tr_logcount = XFS_CREATE_LOG_COUNT;
 	resp->tr_create.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
+	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
+	resp->tr_mkdir.tr_logcount = XFS_MKDIR_LOG_COUNT;
+	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	xfs_calc_parent_ptr_reservations(mp);
+}
+
+void xfs_calc_parent_ptr_reservations(struct xfs_mount     *mp)
+{
+	struct xfs_trans_resv   *resp = M_RES(mp);
+
+	/* Calculate extra space needed for parent pointer attributes */
+	if (!xfs_sb_version_hasparent(&mp->m_sb))
+		return;
+
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
@@ -986,6 +1049,8 @@ xfs_trans_resv_calc(
 	resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
 	resp->tr_qm_dqalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
+	xfs_calc_namespace_reservations(mp, resp);
+
 	/*
 	 * The following transactions are logged in logical format with
 	 * a default log count.
diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
index 0554b9d775d2..cab8084a84d6 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.h
+++ b/fs/xfs/libxfs/xfs_trans_resv.h
@@ -101,5 +101,6 @@ uint xfs_allocfree_block_count(struct xfs_mount *mp, uint num_ops);
 unsigned int xfs_calc_itruncate_reservation_minlogsize(struct xfs_mount *mp);
 unsigned int xfs_calc_write_reservation_minlogsize(struct xfs_mount *mp);
 unsigned int xfs_calc_qm_dqalloc_reservation_minlogsize(struct xfs_mount *mp);
+void xfs_calc_parent_ptr_reservations(struct xfs_mount *mp);
 
 #endif	/* __XFS_TRANS_RESV_H__ */
-- 
2.25.1

