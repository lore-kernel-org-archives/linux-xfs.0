Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31F68C43216
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:21:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 133EA60F94
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:21:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235616AbhG0GVT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:21:19 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:5026 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235477AbhG0GVQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:21:16 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6HliL023082
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=dDwQ84Yk+yx5xmtLjhTBPSRKsW+fTbSsLdbl0Sw2Ia0=;
 b=eIz8Fd+t8JdAClegGibMZmU/DnuIT93MBN1/nOptMKEPUdy35xVMM7G9KzXFjFo5bzbj
 1D4XUpm0vE495r2Fyf7cE51qTIJ0yVqSx+MMlvxMG26dZY9SqCjlUovXnX1RGZCVCu7s
 pZU/2tyznt8Dw17/ichaIy40Jlf1BLcadCDNTxLiaWBcVJcpQxZM32x5DIMdsrPoBHs3
 IyCPlSr9I7WoIY+kGw4eP6ZQaiIG8tAEg8Y/ZalKnPh/mO1zTRfcR4qEQHvpkYaGD0Dt
 EpSBNZiFW5Ozy+TmHYFfvHDyLeH/SHSfwaU7/z0k9OzdWoilNWLDA7wtJMdl5i2XhCK0 oQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=dDwQ84Yk+yx5xmtLjhTBPSRKsW+fTbSsLdbl0Sw2Ia0=;
 b=d93cv0nIR8Kmx0kzxepTi2qntlwywG3EXOmzorH3GJEsY6LesgoakUjlHcJ0JQSQlno6
 ezVP+bRfDTUSw/s2/LvaJgw+7IkNPkkPewYCoYKqXwWyZQWHLwf//YhHbN/hOaA1uzxS
 /S+0x2RaWGgHRsxxnP1tJARuTyX6r0p6X0pofffSMD/f/l6ragGECqlN/PhpmYkYE1VZ
 3UBQbgCbiNPekTTqMitospzpVyoChfVz/6otb8ujaSbEjqp397q8vOeG5R5bUeSf3T0y
 dE9gXIQdAULfGUY2wXD4KtAaqZaA8ADkB8HUaGZi50i8iCyWNIKUAmEwO8OwxdEroaF4 1w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a23538uy2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6FT1s019894
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:14 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by aserp3020.oracle.com with ESMTP id 3a2347k0as-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HhVGihSdxxqL2l0z+QgcJ2umTj5Th4VqF4j+uRTsDBGUHXWWFC68CljQ1Wz1YjO5sKA/lDx0eEzKmDwEO3DMF+12uCVRe4tWlJlld/3RbnTdsVkZEFiZxWeYgDueLgHQf/hAnO8B+Xc1DpGMtzNudubyarFj6jpL9q7nCIvV9H3q6TXbl0mJbbQ0E2OgFsnPWFVzKeEgRbdlEb7lcE2IK+vJE5v8T1P9iQVqHldV6YiyLusQC39xqGzVgixcOQi9N7FnVAXzLTy2RvzbHL2d8R4yJzrd+40VDpdYqlV+Zg0BbZyhqcG/TLK87redXu2GdMuYucfOrJIS0xFehl6tUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dDwQ84Yk+yx5xmtLjhTBPSRKsW+fTbSsLdbl0Sw2Ia0=;
 b=BMopqQ83LtXBupUySMkaF5CNkxI+kv96oNAe77Z6m6iPCdQr96qU3WmhpF6zWsy8rNGBSaWaRqiI1M4f4EFw4EHGGVoWTJEwgvi8ck0+/BuWI4afuBmlT4+7556rJ4LEX6GeZq9es2YRLlfxU82Hu48VrsbuhKXtl0wDM8ujX890WTL5xJVDb+/alRFbRMGp3z1qnH+Gw1xQRJ5Z/pE5jqBfcRvH/Po0dIU/mjGZLGPUCZYLtTZEsq8R2v6HYv3fAjo7QBlJoWtxT8f1a/ZkarUTGWjA6eQQ0Trom6j9MihZz7xnPcyR1BHatQIlL5KCHq3o1y3Hre9yjSKUT6heUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dDwQ84Yk+yx5xmtLjhTBPSRKsW+fTbSsLdbl0Sw2Ia0=;
 b=XLvNUu9baWVprxb8+dZccEvIBV7iu3YS1XHXJ9orHm4Xe268h3/OBJE+K3aX/q3Ngkq0eogyuh1LVPnt/wDHkeXnBNVmTPY6MvkVLtVSt6hiPkF0MVg5GTWiMEKe+dIe7FWPoC9K/vkQYdzjCcs3OVG+mc4T+cgrVs0bCi45Mk0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3383.namprd10.prod.outlook.com (2603:10b6:a03:15c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 06:21:12 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:21:12 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 09/16] xfs: Implement attr logging and replay
Date:   Mon, 26 Jul 2021 23:20:46 -0700
Message-Id: <20210727062053.11129-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727062053.11129-1-allison.henderson@oracle.com>
References: <20210727062053.11129-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0191.namprd05.prod.outlook.com
 (2603:10b6:a03:330::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0191.namprd05.prod.outlook.com (2603:10b6:a03:330::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:21:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 421e3e53-3130-454e-7fe0-08d950c6ba89
X-MS-TrafficTypeDiagnostic: BYAPR10MB3383:
X-Microsoft-Antispam-PRVS: <BYAPR10MB33839ED9EACB283D40C5B7B195E99@BYAPR10MB3383.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:392;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fHgTF5qNKi1x8hHM3HRHouSb+/V3RAbPbcdhvSV+cmcz3E8WL2GqlOKJGSP4nIW1X6RIPzQQmwfFxp8qyZ/YxDeBHyhsnKzRzOK+HhCtX58Gn01o3fWZjKHPk1iu8oHYKQavoHzcUKy4cAdIB7K7WXivnbDR7hUnMLVOCjeFccGV73BC7aCyKnpPjpkNVRQTvUDoQcCEeIz1VC5vaHWF2RtFickcosGNW1WcC0x4lpoK8UKCq9zEVlt6bl2Hfl2JZBNfPClwx2oOc/s8V1LJcmPoE5UlYKI9+OcbeW7juCAls+b+i7K6lZUgPVRa1p/UrrEr6eOkGkKb2KYjF36SVaqfuvdNixmQzam8lvE9aKHuz1ISnXtzCN27oX/MndwgS7W/G02cS3ibNaRZXRaKm3HoFk340VUs0weIPZY0N22w4KmkP9AqCmN1biLOsHV8gjcgYwKdnfa5vg1xMF0/Daf5MZavFaE9lutavaxShMmT0V7MwJuotGwxKKqzG4OPfakOVUgxwXSn88g1H9KeVRRL/4svSk7xnCKiy8/HuND4j5mcnjq03xXXyH96PnOagm3pjEBm3T7KGAh8aIk7sXBplcofgi6ru+UiTu4yh1MlJ8tH4+Aj4bHlDdGzBT6/dM24oNqrpYjw6Lr/BsWEA/cB48vPyu9RjXmYOcneVjL882vDSLFH2FuOrRJiD/IQF4BiZo8P+SJcnNBYbDw8BQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(39860400002)(136003)(346002)(44832011)(956004)(36756003)(26005)(2616005)(6512007)(6506007)(186003)(6486002)(86362001)(6666004)(2906002)(8936002)(1076003)(6916009)(66946007)(52116002)(83380400001)(66476007)(66556008)(38350700002)(38100700002)(30864003)(8676002)(316002)(5660300002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bmG+vnnrHSfbSf6YIpuwGy42RwYsVwnB2TqjgSrOdtw0E27ED4lulXu9L2sI?=
 =?us-ascii?Q?BGp4tFSbaItnmIGdXR5uxH0Nr1pT7BYuStYB0U/0UKifKTE0Uxue2e/9tfu1?=
 =?us-ascii?Q?kXRG7Ckcq4KtErqtvqOAX7uxFhOakNIBbx+D2SwBTgz5FH5TO2ThIB+ZwqeU?=
 =?us-ascii?Q?i/toOzvlBJUIFeqMeXWDVfbkiZWxTS+u9LqIEG00b4rlTtdUYSO0SUm4905B?=
 =?us-ascii?Q?d3RxWahdFiOl5Sfh+KuSWk+HConO4upF4b1rDS5ackSsywybCdNfHdorDqae?=
 =?us-ascii?Q?jdPm8lEWOrlbXck3wvtIdZJrNrMdu/uNeicT9LyjOlJ7oc3senDppFkhIPIg?=
 =?us-ascii?Q?ZQa+ZwjBlirH96HiYvuE0UbFRPdUPqgcBD7NRXJmZjODPdTruOuvnrpgulWx?=
 =?us-ascii?Q?8AsIYVtcHuDYb3X376ebRTKJggycGpZ2eGSmUUrqiTFDIODmkeDzEAu99R29?=
 =?us-ascii?Q?R/vjy1m9BoJhK6ZClhxC9oZ3KMIqPJHDPpuXrL3xZlU4BhQwQ54R9YIzSfDT?=
 =?us-ascii?Q?pSj+oZ4BBfp/c7leajPMnC0nayKRK57ECxDGmx927Z6oxgz+60ZuT/s+8Ot5?=
 =?us-ascii?Q?+bbnC25x9zJTRZHYNuqPQ6W6zUDo2lIINs5Rs7xiaVFeJLh6PDEWnoEMJ8ll?=
 =?us-ascii?Q?UexHyLtmKRlRu9l6g8fgOgVH4zDTzU2eoGB2d3htrSIdtsSYPnfxtqE5IVaj?=
 =?us-ascii?Q?fK+vcWa8xtCCM4wku3DtuVt/qxyVKeeej8P/Gz6xqY+LbkIJNulZkouOoA/c?=
 =?us-ascii?Q?D0CgoR9L4eomH4ihTgOUj7H+5DyZIY95QnZAGt69WwVo7C5Xj2ljfsOiiNo4?=
 =?us-ascii?Q?0p9UJ9jBEywtRDlQfOlLtEDkMVNPnisZ/izEhiT5NKfwddeV92GwL5BhOjjX?=
 =?us-ascii?Q?3E14vmT5RKNpqonsH4yBiV+ujeJe+rtEspNSytw3jH1iE+awBHQAjw734HEh?=
 =?us-ascii?Q?KFu+znQhUwzYrlYcV/OQX/QmfbEZtHEtKKX4OXEF0TrxCdhJpVZyqBvOmSWy?=
 =?us-ascii?Q?37lZEK3Wj6mt7mOZ9h6OC+adRs7nKPPOFUQBh3vCW48SuuVXQYmGPtVul92d?=
 =?us-ascii?Q?WPmATif0Kb1wYrYvSlO98LOqtQQEJKIGG377Y+mue4L/Mnk0LIxiV2qMxj+W?=
 =?us-ascii?Q?YiPIeFh5K4ROxLZEkhH00Um4D/fuW8JG3PHc2z2IJudkpgNuNn6IsApBqk0s?=
 =?us-ascii?Q?cHHAvtIsHQ13ZTYjsFJEfUw1qlYDfoIqff7BOlmqodZ2sVhiahj60/QnG+86?=
 =?us-ascii?Q?y8YuxaNC62w/ndURkVrvLs4+fdiJfahbYL+NVvLgZxhG4b8cSzdC2XX9PBdJ?=
 =?us-ascii?Q?1vsyb8YXvs4gzCYSinfJ6F2p?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 421e3e53-3130-454e-7fe0-08d950c6ba89
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:21:11.4359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0VrU+5Q90fUBOTcxqfC4owWK267r7T4U7x9AA39uIdAuJD2UqqzIUWl8hhCCnyJ8e6pCRcrYS4n0elzaibb+gljYgLZyK7uRX8wcfDXlzAg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3383
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107270037
X-Proofpoint-GUID: VEW-gDa9otxeg2Z-wvVqCF7UUVsYAZQ0
X-Proofpoint-ORIG-GUID: VEW-gDa9otxeg2Z-wvVqCF7UUVsYAZQ0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds the needed routines to create, log and recover logged
extended attribute intents.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c  |   1 +
 fs/xfs/libxfs/xfs_defer.h  |   1 +
 fs/xfs/libxfs/xfs_format.h |  10 +-
 fs/xfs/xfs_attr_item.c     | 377 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 388 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index eff4a12..e9caff7 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -178,6 +178,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
 	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
 	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
+	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
 };
 
 static void
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 0ed9dfa..72a5789 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -19,6 +19,7 @@ enum xfs_defer_ops_type {
 	XFS_DEFER_OPS_TYPE_RMAP,
 	XFS_DEFER_OPS_TYPE_FREE,
 	XFS_DEFER_OPS_TYPE_AGFL_FREE,
+	XFS_DEFER_OPS_TYPE_ATTR,
 	XFS_DEFER_OPS_TYPE_MAX,
 };
 
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 3a4da111..93c1263 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -485,7 +485,9 @@ xfs_sb_has_incompat_feature(
 	return (sbp->sb_features_incompat & feature) != 0;
 }
 
-#define XFS_SB_FEAT_INCOMPAT_LOG_ALL 0
+#define XFS_SB_FEAT_INCOMPAT_LOG_DELATTR   (1 << 0)	/* Delayed Attributes */
+#define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
+	(XFS_SB_FEAT_INCOMPAT_LOG_DELATTR)
 #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
 static inline bool
 xfs_sb_has_incompat_log_feature(
@@ -590,6 +592,12 @@ static inline bool xfs_sb_version_hasbigtime(struct xfs_sb *sbp)
 		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_BIGTIME);
 }
 
+static inline bool xfs_sb_version_hasdelattr(struct xfs_sb *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_LOG_DELATTR);
+}
+
 /*
  * Inode btree block counter.  We record the number of inobt and finobt blocks
  * in the AGI header so that we can skip the finobt walk at mount time when
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index a810c2a..44c44d9 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -275,6 +275,182 @@ xfs_attrd_item_release(
 	xfs_attrd_item_free(attrdp);
 }
 
+/*
+ * Performs one step of an attribute update intent and marks the attrd item
+ * dirty..  An attr operation may be a set or a remove.  Note that the
+ * transaction is marked dirty regardless of whether the operation succeeds or
+ * fails to support the ATTRI/ATTRD lifecycle rules.
+ */
+STATIC int
+xfs_trans_attr_finish_update(
+	struct xfs_delattr_context	*dac,
+	struct xfs_attrd_log_item	*attrdp,
+	struct xfs_buf			**leaf_bp,
+	uint32_t			op_flags)
+{
+	struct xfs_da_args		*args = dac->da_args;
+	unsigned int			op = op_flags &
+					     XFS_ATTR_OP_FLAGS_TYPE_MASK;
+	int				error;
+
+	error = xfs_qm_dqattach_locked(args->dp, 0);
+	if (error)
+		return error;
+
+	switch (op) {
+	case XFS_ATTR_OP_FLAGS_SET:
+		args->op_flags |= XFS_DA_OP_ADDNAME;
+		error = xfs_attr_set_iter(dac, leaf_bp);
+		break;
+	case XFS_ATTR_OP_FLAGS_REMOVE:
+		ASSERT(XFS_IFORK_Q(args->dp));
+		error = xfs_attr_remove_iter(dac);
+		break;
+	default:
+		error = -EFSCORRUPTED;
+		break;
+	}
+
+	/*
+	 * Mark the transaction dirty, even on error. This ensures the
+	 * transaction is aborted, which:
+	 *
+	 * 1.) releases the ATTRI and frees the ATTRD
+	 * 2.) shuts down the filesystem
+	 */
+	args->trans->t_flags |= XFS_TRANS_DIRTY;
+
+	/*
+	 * attr intent/done items are null when delayed attributes are disabled
+	 */
+	if (attrdp)
+		set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
+
+	return error;
+}
+
+/* Log an attr to the intent item. */
+STATIC void
+xfs_attr_log_item(
+	struct xfs_trans		*tp,
+	struct xfs_attri_log_item	*attrip,
+	struct xfs_attr_item		*attr)
+{
+	struct xfs_attri_log_format	*attrp;
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	set_bit(XFS_LI_DIRTY, &attrip->attri_item.li_flags);
+
+	/*
+	 * At this point the xfs_attr_item has been constructed, and we've
+	 * created the log intent. Fill in the attri log item and log format
+	 * structure with fields from this xfs_attr_item
+	 */
+	attrp = &attrip->attri_format;
+	attrp->alfi_ino = attr->xattri_dac.da_args->dp->i_ino;
+	attrp->alfi_op_flags = attr->xattri_op_flags;
+	attrp->alfi_value_len = attr->xattri_dac.da_args->valuelen;
+	attrp->alfi_name_len = attr->xattri_dac.da_args->namelen;
+	attrp->alfi_attr_flags = attr->xattri_dac.da_args->attr_filter;
+
+	attrip->attri_name = (void *)attr->xattri_dac.da_args->name;
+	attrip->attri_value = attr->xattri_dac.da_args->value;
+	attrip->attri_name_len = attr->xattri_dac.da_args->namelen;
+	attrip->attri_value_len = attr->xattri_dac.da_args->valuelen;
+}
+
+/* Get an ATTRI. */
+static struct xfs_log_item *
+xfs_attr_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_attri_log_item	*attrip;
+	struct xfs_attr_item		*attr;
+
+	ASSERT(count == 1);
+
+	if (!xfs_hasdelattr(mp))
+		return NULL;
+
+	attrip = xfs_attri_init(mp, 0);
+	if (attrip == NULL)
+		return NULL;
+
+	xfs_trans_add_item(tp, &attrip->attri_item);
+	list_for_each_entry(attr, items, xattri_list)
+		xfs_attr_log_item(tp, attrip, attr);
+	return &attrip->attri_item;
+}
+
+/* Process an attr. */
+STATIC int
+xfs_attr_finish_item(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*done,
+	struct list_head		*item,
+	struct xfs_btree_cur		**state)
+{
+	struct xfs_attr_item		*attr;
+	struct xfs_attrd_log_item	*done_item = NULL;
+	int				error;
+	struct xfs_delattr_context	*dac;
+
+	attr = container_of(item, struct xfs_attr_item, xattri_list);
+	dac = &attr->xattri_dac;
+	if (done)
+		done_item = ATTRD_ITEM(done);
+
+	/*
+	 * Corner case that can happen during a recovery.  Because the first
+	 * iteration of a multi part delay op happens in xfs_attri_item_recover
+	 * to maintain the order of the log replay items.  But the new
+	 * transactions do not automatically rejoin during a recovery as they do
+	 * in a standard delay op, so we need to catch this here and rejoin the
+	 * leaf to the new transaction
+	 */
+	if (attr->xattri_dac.leaf_bp &&
+	    attr->xattri_dac.leaf_bp->b_transp != tp) {
+		xfs_trans_bjoin(tp, attr->xattri_dac.leaf_bp);
+		xfs_trans_bhold(tp, attr->xattri_dac.leaf_bp);
+	}
+
+	/*
+	 * Always reset trans after EAGAIN cycle
+	 * since the transaction is new
+	 */
+	dac->da_args->trans = tp;
+
+	error = xfs_trans_attr_finish_update(dac, done_item, &dac->leaf_bp,
+					     attr->xattri_op_flags);
+	if (error != -EAGAIN)
+		kmem_free(attr);
+
+	return error;
+}
+
+/* Abort all pending ATTRs. */
+STATIC void
+xfs_attr_abort_intent(
+	struct xfs_log_item		*intent)
+{
+	xfs_attri_release(ATTRI_ITEM(intent));
+}
+
+/* Cancel an attr */
+STATIC void
+xfs_attr_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_attr_item		*attr;
+
+	attr = container_of(item, struct xfs_attr_item, xattri_list);
+	kmem_free(attr);
+}
+
 STATIC xfs_lsn_t
 xfs_attri_item_committed(
 	struct xfs_log_item		*lip,
@@ -306,6 +482,30 @@ xfs_attri_item_match(
 	return ATTRI_ITEM(lip)->attri_format.alfi_id == intent_id;
 }
 
+/*
+ * This routine is called to allocate an "attr free done" log item.
+ */
+static struct xfs_attrd_log_item *
+xfs_trans_get_attrd(struct xfs_trans		*tp,
+		  struct xfs_attri_log_item	*attrip)
+{
+	struct xfs_attrd_log_item		*attrdp;
+	uint					size;
+
+	ASSERT(tp != NULL);
+
+	size = sizeof(struct xfs_attrd_log_item);
+	attrdp = kmem_zalloc(size, 0);
+
+	xfs_log_item_init(tp->t_mountp, &attrdp->attrd_item, XFS_LI_ATTRD,
+			  &xfs_attrd_item_ops);
+	attrdp->attrd_attrip = attrip;
+	attrdp->attrd_format.alfd_alf_id = attrip->attri_format.alfi_id;
+
+	xfs_trans_add_item(tp, &attrdp->attrd_item);
+	return attrdp;
+}
+
 static const struct xfs_item_ops xfs_attrd_item_ops = {
 	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
 	.iop_size	= xfs_attrd_item_size,
@@ -313,6 +513,29 @@ static const struct xfs_item_ops xfs_attrd_item_ops = {
 	.iop_release    = xfs_attrd_item_release,
 };
 
+
+/* Get an ATTRD so we can process all the attrs. */
+static struct xfs_log_item *
+xfs_attr_create_done(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*intent,
+	unsigned int			count)
+{
+	if (!intent)
+		return NULL;
+
+	return &xfs_trans_get_attrd(tp, ATTRI_ITEM(intent))->attrd_item;
+}
+
+const struct xfs_defer_op_type xfs_attr_defer_type = {
+	.max_items	= 1,
+	.create_intent	= xfs_attr_create_intent,
+	.abort_intent	= xfs_attr_abort_intent,
+	.create_done	= xfs_attr_create_done,
+	.finish_item	= xfs_attr_finish_item,
+	.cancel_item	= xfs_attr_cancel_item,
+};
+
 /* Is this recovered ATTRI ok? */
 static inline bool
 xfs_attri_validate(
@@ -340,13 +563,167 @@ xfs_attri_validate(
 	return xfs_hasdelattr(mp);
 }
 
+/*
+ * Process an attr intent item that was recovered from the log.  We need to
+ * delete the attr that it describes.
+ */
+STATIC int
+xfs_attri_item_recover(
+	struct xfs_log_item		*lip,
+	struct list_head		*capture_list)
+{
+	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
+	struct xfs_attr_item		*attr;
+	struct xfs_mount		*mp = lip->li_mountp;
+	struct xfs_inode		*ip;
+	struct xfs_da_args		*args;
+	struct xfs_trans		*tp;
+	struct xfs_trans_res		tres;
+	struct xfs_attri_log_format	*attrp;
+	int				error, ret = 0;
+	int				total;
+	int				local;
+	struct xfs_attrd_log_item	*done_item = NULL;
+
+	/*
+	 * First check the validity of the attr described by the ATTRI.  If any
+	 * are bad, then assume that all are bad and just toss the ATTRI.
+	 */
+	attrp = &attrip->attri_format;
+	if (!xfs_attri_validate(mp, attrip))
+		return -EFSCORRUPTED;
+
+	error = xlog_recover_iget(mp,  attrp->alfi_ino, &ip);
+	if (error)
+		return error;
+
+	attr = kmem_zalloc(sizeof(struct xfs_attr_item) +
+			   sizeof(struct xfs_da_args), KM_NOFS);
+	args = (struct xfs_da_args *)((char *)attr +
+		   sizeof(struct xfs_attr_item));
+
+	attr->xattri_dac.da_args = args;
+	attr->xattri_op_flags = attrp->alfi_op_flags;
+
+	args->dp = ip;
+	args->geo = mp->m_attr_geo;
+	args->op_flags = attrp->alfi_op_flags;
+	args->whichfork = XFS_ATTR_FORK;
+	args->name = attrip->attri_name;
+	args->namelen = attrp->alfi_name_len;
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	args->attr_filter = attrp->alfi_attr_flags;
+
+	if (attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_SET) {
+		args->value = attrip->attri_value;
+		args->valuelen = attrp->alfi_value_len;
+		args->total = xfs_attr_calc_size(args, &local);
+
+		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
+				 M_RES(mp)->tr_attrsetrt.tr_logres *
+					args->total;
+		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
+		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
+		total = args->total;
+	} else {
+		tres = M_RES(mp)->tr_attrrm;
+		total = XFS_ATTRRM_SPACE_RES(mp);
+	}
+	error = xfs_trans_alloc(mp, &tres, total, 0, XFS_TRANS_RESERVE, &tp);
+	if (error)
+		goto out;
+
+	args->trans = tp;
+	done_item = xfs_trans_get_attrd(tp, attrip);
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
+
+	ret = xfs_trans_attr_finish_update(&attr->xattri_dac, done_item,
+					   &attr->xattri_dac.leaf_bp,
+					   attrp->alfi_op_flags);
+	if (ret == -EAGAIN) {
+		/* There's more work to do, so add it to this transaction */
+		xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr->xattri_list);
+	} else
+		error = ret;
+
+	if (error) {
+		xfs_trans_cancel(tp);
+		goto out_unlock;
+	}
+
+	error = xfs_defer_ops_capture_and_commit(tp, ip, capture_list);
+
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_irele(ip);
+out:
+	if (ret != -EAGAIN)
+		kmem_free(attr);
+	return error;
+}
+
+/* Re-log an intent item to push the log tail forward. */
+static struct xfs_log_item *
+xfs_attri_item_relog(
+	struct xfs_log_item		*intent,
+	struct xfs_trans		*tp)
+{
+	struct xfs_attrd_log_item	*attrdp;
+	struct xfs_attri_log_item	*old_attrip;
+	struct xfs_attri_log_item	*new_attrip;
+	struct xfs_attri_log_format	*new_attrp;
+	struct xfs_attri_log_format	*old_attrp;
+	int				buffer_size;
+
+	old_attrip = ATTRI_ITEM(intent);
+	old_attrp = &old_attrip->attri_format;
+	buffer_size = old_attrp->alfi_value_len + old_attrp->alfi_name_len;
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	attrdp = xfs_trans_get_attrd(tp, old_attrip);
+	set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
+
+	new_attrip = xfs_attri_init(tp->t_mountp, buffer_size);
+	new_attrp = &new_attrip->attri_format;
+
+	new_attrp->alfi_ino = old_attrp->alfi_ino;
+	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
+	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
+	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
+	new_attrp->alfi_attr_flags = old_attrp->alfi_attr_flags;
+
+	new_attrip->attri_name_len = old_attrip->attri_name_len;
+	new_attrip->attri_name = ((char *)new_attrip) +
+				 sizeof(struct xfs_attri_log_item);
+	memcpy(new_attrip->attri_name, old_attrip->attri_name,
+		new_attrip->attri_name_len);
+
+	new_attrip->attri_value_len = old_attrip->attri_value_len;
+	if (new_attrip->attri_value_len > 0) {
+		new_attrip->attri_value = new_attrip->attri_name +
+					  new_attrip->attri_name_len;
+
+		memcpy(new_attrip->attri_value, old_attrip->attri_value,
+		       new_attrip->attri_value_len);
+	}
+
+	xfs_trans_add_item(tp, &new_attrip->attri_item);
+	set_bit(XFS_LI_DIRTY, &new_attrip->attri_item.li_flags);
+
+	return &new_attrip->attri_item;
+}
+
 static const struct xfs_item_ops xfs_attri_item_ops = {
 	.iop_size	= xfs_attri_item_size,
 	.iop_format	= xfs_attri_item_format,
 	.iop_unpin	= xfs_attri_item_unpin,
 	.iop_committed	= xfs_attri_item_committed,
 	.iop_release    = xfs_attri_item_release,
+	.iop_recover	= xfs_attri_item_recover,
 	.iop_match	= xfs_attri_item_match,
+	.iop_relog	= xfs_attri_item_relog,
 };
 
 
-- 
2.7.4

