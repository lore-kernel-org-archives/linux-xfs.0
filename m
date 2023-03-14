Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B04B6C6FD1F
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Mar 2023 04:21:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjCNEV2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Mar 2023 00:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjCNEV0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Mar 2023 00:21:26 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563DD64232
        for <linux-xfs@vger.kernel.org>; Mon, 13 Mar 2023 21:21:25 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32E3xvQM009819
        for <linux-xfs@vger.kernel.org>; Tue, 14 Mar 2023 04:21:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=UWUhJIdmTPD19xYTMFABkrpqt/skMeNLkYm2FAQmq7U=;
 b=DKYChohsehDC3kN8PhsgV9ZiDRO/FF2PdF+7R3FykJuSU4KvDYBEmrtLWrcParB1PH1b
 mD64XSIQtwjB9NjHSityHYZDgohIyxq/VYSP+AlNhzfopC+eRbzJYPIPR3zTDwxKNaRA
 XZ3Yc1SfNiOSsiVrt3VRAyVtsSdLh8ZWPHX1OUZfAAKKOo6jCQQg6cNrsJB9Kfx8uCc4
 tERac0tZJfawH2buEH2U6/0OP/j3WGBMtlR/7kf33F2omTN0HHMKrtj9zFt3CtNezeN3
 fZjjs6wlrsxY3Nkmtev/DbDnB6u4Ox1Dtfc8jGIVy3leNJzNYMxBBMhuBoQJ4TsHmed8 bg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p8ge2wcw5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 14 Mar 2023 04:21:24 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32E12juq007583
        for <linux-xfs@vger.kernel.org>; Tue, 14 Mar 2023 04:21:23 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p8g3cba4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 14 Mar 2023 04:21:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VH5NcY8deCtAv349AsthXvW83f6W5NHSmlMeItNN1YP2Qj/o8b9ZCRHe4xIEDtk7M2rm3lC0DlGi6WYkcLgrhIjSLDQNgcQNsPYaKamIZ7w8DQu2FkNHE0y6lur5r4By4uS3/czWoYmcfcf0wZ+a7szT5GRZYx77NGWj4RJ5BgM2BClXCR4NTLoUq/gi/PVXnEpVtLKrD4WHip7wqXzSllV80Rbl9DSLztgJmNmz1yONpjxibJrhxOomU+bz2K3+xyjizordQ8HMmp8Gc4uQUx3YioQAr/v23/nTdgjMZGdQDVpo8LvVJpxMjCsXvq5Gr2qxAf1sU4dOjgTo4y1pBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UWUhJIdmTPD19xYTMFABkrpqt/skMeNLkYm2FAQmq7U=;
 b=Wt21kCcIrP2SOu0/q3Pjvc+yJrGiOBYBPm4ommIZ579Q/BoAOtDDFDtnJ3N0GomqEJUMMgX7PiufVd0uxELvbcEYTzSMyVavS3HzO+COa3CniJyzXNcCWtqKGkP+Uyc6RuR6nV+tlzTB7hDlB627ceKuYeX3N4ZHUOC+TgMkFtxziVbnUvD+3orkdfSE23bttwrnRzj8srFqQINx7XI5r7H5MLN7C3om62mj05hUSrFWOyleFQ7ESvp+JKfv8uJgw41DtiOTHRjHamoj4aMvZndg75+9TyNDiNKiDiLmweD784szZhjI5zxEi4Q0KHULzeyHonNmFZQ7xLLR/Ib2pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UWUhJIdmTPD19xYTMFABkrpqt/skMeNLkYm2FAQmq7U=;
 b=xyVGxUaR+UoKNP4/eqidHMUvMDGBNRQvlRq6381cldFoKlTrmr12dhKMqYY6yRIY4ETrwH8hylDhTo5IQMYByy0p2e/nuOPGGoEklUWKZ/tvKmy8PdwRfRDBoFZ5HrHmtFLylig+dDCFmIZIHsiD4u2cFoLZySYXhFt1m0ihO1M=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BY5PR10MB4371.namprd10.prod.outlook.com (2603:10b6:a03:210::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 04:21:21 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::b647:355b:b589:60c]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::b647:355b:b589:60c%4]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 04:21:21 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 2/4] xfs: implement custom freeze/thaw functions
Date:   Mon, 13 Mar 2023 21:21:07 -0700
Message-Id: <20230314042109.82161-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20230314042109.82161-1-catherine.hoang@oracle.com>
References: <20230314042109.82161-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0173.namprd03.prod.outlook.com
 (2603:10b6:a03:338::28) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BY5PR10MB4371:EE_
X-MS-Office365-Filtering-Correlation-Id: e1344cc5-7015-4aa5-95c7-08db24439071
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kyj0kMSpqHXHoN63x3+dYOthNOVGpT3FidEM1gM9ROnexCEwVCjiCIMzpue3PR5LF35X1GPFJE2WogYr2hJMvHq8vKpHkuhkNgUXzGA0NUn5pEqOyY6M5UIIPO5xJ+69aHVyPWARt9rUE3ZOYVeKKXWnN/zeFHoB5hmuewDhrkbyAeAxeF0EpQj9I7zZbZeR4r2es0LMOi2dHriWekPfdDUxlhgrJYDXiT6q35v7b1kVnZkeGwT1GY0vQ1IccumyxGQy9dOQWNdPOeHp9dp5bcSKb/htFahl3UXax/LXj1c16WpLpSgqLI1q6vbpRbTRDiZEEXkM/amcDLMGYZUnFsQ9jB2/g+hJaQbt9lZ99Pppj51b4CX9JVUqpKVtRicrJ/CZ2wHO5+XyuWDICeChRd5zID7bUYMmOru/8zwf972d+5ZoP6M/hpLk/Gz0i6tnaPgV4Wukl5gErqSR8II+8rUJsU8rl+V0p3Ij3Wciye8F/+pGxF0aXyb6pwgkX0p1g0iXJGHxVdp4qoi6ZTvLdpReFk+I7V0xANeZ5gTcw9sRDH41d6ruaVY49Pe8/7MuaQ4+TtHpSjUm9gPtKL45XVgei7UXWXBxVxLq3SKwotQc5VT9YqaeNVbKzW6po3HUE/j2ipzOMdPeI15L45bxsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(39860400002)(136003)(376002)(451199018)(36756003)(86362001)(6916009)(41300700001)(6512007)(6506007)(1076003)(186003)(5660300002)(2616005)(8936002)(316002)(478600001)(6486002)(8676002)(66556008)(66476007)(66946007)(38100700002)(6666004)(2906002)(44832011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bmyfHhPIQZiHlh7MU3gDrLwmFmTuaOoraplSkBxCLEhuOBGBkWDxQJ1TZ1Gx?=
 =?us-ascii?Q?GnePTY0pUy/jMruJuMcpmkCI1LWvNFVH/PCReAK81cqG+VxNts7BRnVWww4a?=
 =?us-ascii?Q?AFpYyETZA85ccb90YVZMt2sc3m7JFjA++k/g7AiA9+hOKEgrgT8uUY5D//1v?=
 =?us-ascii?Q?LY25HNQ0d6C+WVdBQ20/KlqZyQ6e4aljyPBWOwmPVr15f2g2eUSuw3PW9fJq?=
 =?us-ascii?Q?0GGsq6L+TGUGEd0r7Aw9VMB+WOY9vzrF2TelhowXZxjIPdrRXaiM+Fs+tYzI?=
 =?us-ascii?Q?HoODpwNkx0isr6i7GmrCFqPN3vATzqCvJBH0TztZNAsN4Nz/DEvlnQYsSYgl?=
 =?us-ascii?Q?ZE02MIMIfSohHiwpoW8Ng7KNcZ2Da1i3abz0gj8t4Idyakx13wXJhGfNLC0s?=
 =?us-ascii?Q?mN4YV04bmhaA3PFSZ+zZPPtHJSsf+yjYlpVw9wmdvVf5FJXJ8mDxJOvoaIV0?=
 =?us-ascii?Q?sM2EZg+p7MfNJ4VRhYAFQE4PVXoBVXVkqggz5vYT3je9lnK91wk5oe4z4p55?=
 =?us-ascii?Q?Vl5b2iTEUhb5980EdRrwpe2GQAGCYoyVjtBn67L7L/TVf5chhvVO2hLJgNPe?=
 =?us-ascii?Q?nIms0Ql4pk5vidi4zURxl8Kh3ZnzaMhc5bEAwmFE7edO2/Rng29Q4+VRLI0o?=
 =?us-ascii?Q?8G76ziG16cgPn+8QiV9aMIupmlWPavfQywhrwvpiWn+ayeA7xb1jdMjtLYjr?=
 =?us-ascii?Q?HOhamgLIF60JkAz7IjGfInOpM+lcjg4Y+m3gkgVBCn4gPCjSyRfE2IEIPYFj?=
 =?us-ascii?Q?EeCHbLiPGFmMFGYB/pJWp35hWYoxtYEW31D4fRxvc/7OPJ2PlFMhCKzLvwOa?=
 =?us-ascii?Q?CTc9UU9eTTP7AIBzjjDarklW6Q7lfvbTbsIjGAAgYwWBbU73M56niC0SZe5r?=
 =?us-ascii?Q?b06nE0mr+Bm6NYZ+o2Ye3blaxx2efYQX2pNznRtcJ1+xcQUI3UkHYqY92KmI?=
 =?us-ascii?Q?3N9kQpQzQHd+vC6efWQxcgZ3ATzz47VsmZVvb31IaJDX19OzW5sc499ZnyQS?=
 =?us-ascii?Q?8HL2EovYifkdMqr/e2jcJxebTTf6S9ddr+jZY69ZgDIaJHonlwnlSUPfhsNd?=
 =?us-ascii?Q?ofDk2CuVw8seTlh3tNa1SWj5G1+be3DGpeZDPRUC+fkPFfOyRqmxvJmCt/SU?=
 =?us-ascii?Q?Qrp/IhKDXGMRNhuiP/Fk80m59Zh1gw/KyTaz/w4jJq6RQUM1un6yHsCd3d5I?=
 =?us-ascii?Q?f+0C8CcvcOpE6H/U2vq+4LtwDgtoGfpnueCBM24e6NLT6q0aMUSO/3MoFFN/?=
 =?us-ascii?Q?CcGkELStPZdPbvyhOH1cgNYQjy5v/9GrkgIhTBt29+QKXB9eBs6m3Z4ay852?=
 =?us-ascii?Q?OjXq3TZpwFWYOhH7qcxuJia9HXYpYOmWm1OkzZf7SPnTLjYP16+fbo8crFNi?=
 =?us-ascii?Q?i6eeIYvJg+kEWkCEovnkWTFSBmuow4D2WTSsWrCfhrR8XcAUVDgb+Ln0RA70?=
 =?us-ascii?Q?SSpgrOR7Lt2/CFdvfN3VYKwDh37HwSp7AsB5y1KsEmudlgUeMTonim+ixHkm?=
 =?us-ascii?Q?9L6iluXOcvuvwlr0uOvu8uZfiOc7no4U15hh+dslPh2tdRzxSre6ZLLA1wwY?=
 =?us-ascii?Q?ew72CogUEJfoWwwFItgRZWg9YF3vNQv4iof8r389vOgHaaWHrIOh8azYzwZL?=
 =?us-ascii?Q?8ggu6dXqHpwHDb+asx40GkLYo8tLQ8LaPrdESWgnx6NzFqfPZZ1YvpWzgpHJ?=
 =?us-ascii?Q?KH855Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 0nBKNBSg/uEn7OUVdeigaXFDLSPGddSeX0MBXv91SCqr+FI/5HbwejVw9ahmMhImUlQ5Cas4clRi8ZgyImZKNQzYC/z4KkNeNHatKf0lXfEXsaGi7M1WR9+0xHBoXwjrkAlibTaz0bX9ptk4AuePbUGxgYrVU6CvVuObLOXWfv1A+KXCGIPGfqVf4axzuhIj9/qbL97OV5QJEpxwt45MfLM85+dYhYu2kd0DZTtcOUMNOmPpaXcanVL2bpATUTdh3YOSXw64c6qancVrV3uLxRKjATQwIIPWMMkLI5sEtmv0MXUuDUt8qSEbei6b/1jLU1jPIsTtu7ZNsFeFqgiirjWdoDqhFne9283s4tUlpvY5WrU/FX0lH9ylgXS6iwus3A1HxSfXV9pDiT9QXUIHCYl3L0z9A3XRUUNz/Ecrg5E0B9EpkkOBsbKT+C3dyEUl3BLoCdcOVwjteYv3qSpWYA/6Y9ZEhZkkF256g3DNBOmE8SxDtpXnTSMcS3BYStRtlvzZAiiXXH/yNW8ZtT/L42MRNU3A+ndFPStvq26LpMENuHeFvAdSXWVqlbxwBiF8GYEEFRjlA65WFWZpvlKF/RI2J5WljshRSnURSE9QsMxWTX/OGrc6ZFfLi+cFUNV8Z7nlRDxv/pOVEJ6DUwRK20SP/Xw5v9X2NpZfQk27OHQMXqRzx9UnLvbHc5xRdqacViJ3gDyx2sRplwy7Sxg2eAC5UZthNRDjFARHlHMsbkgXpWXyFH30prTeSU9i6YMV7XcQjujyUht5A6j//ov3OQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1344cc5-7015-4aa5-95c7-08db24439071
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 04:21:20.9547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Tni1bbi4QbWFttMi6au1k/SwcVge7jqWzfGf2pFJ8qmLs6fgV1oAE3IBtmkivwy5EcCxNnCpEaUc5mJF+tUKnLABC7NHsPWynULkwCKybQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4371
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-13_13,2023-03-13_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303140037
X-Proofpoint-GUID: kFjGS19wB1RTJAcJ4YJzmA2LeqYW_L8L
X-Proofpoint-ORIG-GUID: kFjGS19wB1RTJAcJ4YJzmA2LeqYW_L8L
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Implement internal freeze/thaw functions and prevent other threads from changing
the freeze level by adding a new SB_FREEZE_ECLUSIVE level. This is required to
prevent concurrent transactions while we are updating the uuid.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_super.c | 112 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_super.h |   5 ++
 2 files changed, 117 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 2479b5cbd75e..6a52ae660810 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2279,6 +2279,118 @@ static inline int xfs_cpu_hotplug_init(void) { return 0; }
 static inline void xfs_cpu_hotplug_destroy(void) {}
 #endif
 
+/*
+ * We need to disable all writer threads, which means taking the first two
+ * freeze levels to put userspace to sleep, and the third freeze level to
+ * prevent background threads from starting new transactions.  Take one level
+ * more to prevent other callers from unfreezing the filesystem while we run.
+ */
+int
+xfs_internal_freeze(
+	struct xfs_mount	*mp)
+{
+	struct super_block	*sb = mp->m_super;
+	int			level;
+	int			error = 0;
+
+	/* Wait until we're ready to freeze. */
+	down_write(&sb->s_umount);
+	while (sb->s_writers.frozen != SB_UNFROZEN) {
+		up_write(&sb->s_umount);
+		delay(HZ / 10);
+		down_write(&sb->s_umount);
+	}
+
+	if (sb_rdonly(sb)) {
+		sb->s_writers.frozen = SB_FREEZE_EXCLUSIVE;
+		goto done;
+	}
+
+	sb->s_writers.frozen = SB_FREEZE_WRITE;
+	/* Release s_umount to preserve sb_start_write -> s_umount ordering */
+	up_write(&sb->s_umount);
+	percpu_down_write(sb->s_writers.rw_sem + SB_FREEZE_WRITE - 1);
+	down_write(&sb->s_umount);
+
+	/* Now we go and block page faults... */
+	sb->s_writers.frozen = SB_FREEZE_PAGEFAULT;
+	percpu_down_write(sb->s_writers.rw_sem + SB_FREEZE_PAGEFAULT - 1);
+
+	/*
+	 * All writers are done so after syncing there won't be dirty data.
+	 * Let xfs_fs_sync_fs flush dirty data so the VFS won't start writeback
+	 * and to disable the background gc workers.
+	 */
+	error = sync_filesystem(sb);
+	if (error) {
+		sb->s_writers.frozen = SB_UNFROZEN;
+		for (level = SB_FREEZE_PAGEFAULT - 1; level >= 0; level--)
+			percpu_up_write(sb->s_writers.rw_sem + level);
+		wake_up(&sb->s_writers.wait_unfrozen);
+		up_write(&sb->s_umount);
+		return error;
+	}
+
+	/* Now wait for internal filesystem counter */
+	sb->s_writers.frozen = SB_FREEZE_FS;
+	percpu_down_write(sb->s_writers.rw_sem + SB_FREEZE_FS - 1);
+
+	xfs_log_clean(mp);
+
+	/*
+	 * To prevent anyone else from unfreezing us, set the VFS freeze
+	 * level to one higher than FREEZE_COMPLETE.
+	 */
+	sb->s_writers.frozen = SB_FREEZE_EXCLUSIVE;
+	for (level = SB_FREEZE_LEVELS - 1; level >= 0; level--)
+		percpu_rwsem_release(sb->s_writers.rw_sem + level, 0,
+				_THIS_IP_);
+done:
+	up_write(&sb->s_umount);
+	return 0;
+}
+
+void
+xfs_internal_unfreeze(
+	struct xfs_mount	*mp)
+{
+	struct super_block	*sb = mp->m_super;
+	int			level;
+
+	down_write(&sb->s_umount);
+	if (sb->s_writers.frozen != SB_FREEZE_EXCLUSIVE) {
+		/* somebody snuck in and unfroze us? */
+		ASSERT(0);
+		up_write(&sb->s_umount);
+		return;
+	}
+
+	if (sb_rdonly(sb)) {
+		sb->s_writers.frozen = SB_UNFROZEN;
+		goto out;
+	}
+
+	for (level = 0; level < SB_FREEZE_LEVELS; ++level)
+		percpu_rwsem_acquire(sb->s_writers.rw_sem + level, 0,
+				_THIS_IP_);
+
+	/*
+	 * We didn't call xfs_fs_freeze, so we can't call xfs_fs_thaw.  Start
+	 * the background gc workers that were shut down by xfs_fs_sync_fs
+	 * when we froze.
+	 */
+	xfs_blockgc_start(mp);
+	xfs_inodegc_start(mp);
+
+	sb->s_writers.frozen = SB_UNFROZEN;
+	for (level = SB_FREEZE_LEVELS - 1; level >= 0; level--)
+		percpu_up_write(sb->s_writers.rw_sem + level);
+out:
+	wake_up(&sb->s_writers.wait_unfrozen);
+	up_write(&sb->s_umount);
+	return;
+}
+
 STATIC int __init
 init_xfs_fs(void)
 {
diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
index 364e2c2648a8..0817cfc340ef 100644
--- a/fs/xfs/xfs_super.h
+++ b/fs/xfs/xfs_super.h
@@ -81,6 +81,8 @@ extern void xfs_qm_exit(void);
 # define XFS_WQFLAGS(wqflags)	(wqflags)
 #endif
 
+#define SB_FREEZE_EXCLUSIVE	(SB_FREEZE_COMPLETE + 1)
+
 struct xfs_inode;
 struct xfs_mount;
 struct xfs_buftarg;
@@ -98,6 +100,9 @@ extern void xfs_reinit_percpu_counters(struct xfs_mount *mp);
 
 extern struct workqueue_struct *xfs_discard_wq;
 
+extern int xfs_internal_freeze(struct xfs_mount *mp);
+extern void xfs_internal_unfreeze(struct xfs_mount *mp);
+
 #define XFS_M(sb)		((struct xfs_mount *)((sb)->s_fs_info))
 
 #endif	/* __XFS_SUPER_H__ */
-- 
2.34.1

