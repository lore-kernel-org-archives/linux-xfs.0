Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EE4CC4167B
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Dec 2022 10:03:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiLRKD0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Dec 2022 05:03:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiLRKDT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 05:03:19 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6FA65FD
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 02:03:16 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BI5weh4028846
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=8hCopp/nA2uT3LddAeVVvUGVEsFmCIiF3XYQIYuJc8E=;
 b=T3k9lUvyOLbH8GKonMpX47sgqVTAPGLSAzk3Mv5o41QDcI9JbrLeZz+V6XbShRZATvYT
 L5w0MwCTJeFIpRlVN4Pyl2ippoTH0ehAcEJaF2Em5G4TJW7kyKIZQsBjMTplcFSNVqLK
 c7vzZsbHDr1lFMfn6AFTLZunJnz0Yq+DtBX8AHHCydE8kObGuEKib5UxRf/MqYLNtynj
 QS+Wwh1Wapmp+iUNLaMYExrYKMa3Nxk7ynwCmZxWR51o7lsC9eGPFXnj3r+0ObY8hr6/
 M7AxRDUm07EPA1jtv0k8j3vF7bOuHCyp8c2yZSnSVE+nVCwkriCQ8p5vniuGzQg8+Kzn 0w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tm19a0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:15 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BI8AaIK006861
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:14 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mh478n3n1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VernPWd5g89v8nEbUhYIYMUovNO5H9FCH5NTAhwWZ6FsBGrzGtzifG8UKZ0tJrTYcSfG+qnoClJJLc6exdfk8Q3bCSxCAHGge48a1dyb2hi/QGEDih6FM9vb4ggVG8kY8UJ0HcnhTYhaeFo5VLLGPxMIFtxaBbdlCGorGUXWmCM9aWVCtLziUFqiyQOC4ymuZOvUYpKIyRM8e4/+eBRLTTjq/pm00DaTsT97Bp1L/VlQXxzG9F5l0jmv9x3pShHkXKHmZAlMj5CwGSfKwR8seOmuKCtAW47wNXRcOs5uQNfnAL3S9FEom1DRdaFrT7+HLUuNRTkMDTiV9sGsU7rhEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8hCopp/nA2uT3LddAeVVvUGVEsFmCIiF3XYQIYuJc8E=;
 b=ju92i8mw1ii2wj7Bnntr6wkusBCyK1Gwr3M3fhrU0wLxGii5yVaDdTJ2qbf37K8iBXAFYQ7yjYdCQ/w/eeEkLLRTP3sjqyI5YcDWyTNsTfoviz0HLup2wWBaRH2gJ/YeIC9HlQaq+2g+NkuWROhwjymHFZdwKi3RIiEpB5a/pDTbTr3INLn3qybrRhXde80pefFQ4mY042qlwt5RAxAuvSzxNjbdmhjxBbL77AacQo8V3iU9SJUpsNWfeHxgKyC0AFHtCLfd676sFKIopgCJXg6+YSeiONRLXvH030ivaseXrbfWBQtZqftAL4ST7efwaPgSVe3yvgZgLJDvCm6Giw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8hCopp/nA2uT3LddAeVVvUGVEsFmCIiF3XYQIYuJc8E=;
 b=wzE7WVn/shTL72GWSXhaU9JQoroa8+oQ736uOSdJYCDMUoTk2MAYayPcUOiS6JjGj9J4NoVRaGrbg2DUrRaZFKWu0bX9QOqWAVjnvHC1eRuKTTlQct/06PlAOMG4gCEDrPOGyL0BsEI2ZofObGnF39n6jB1kiLVZYAX7Fy3MUaY=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4536.namprd10.prod.outlook.com (2603:10b6:510:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 18 Dec
 2022 10:03:13 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 10:03:13 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 03/27] xfs: Increase XFS_QM_TRANS_MAXDQS to 5
Date:   Sun, 18 Dec 2022 03:02:42 -0700
Message-Id: <20221218100306.76408-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218100306.76408-1-allison.henderson@oracle.com>
References: <20221218100306.76408-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0020.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::33) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4536:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a1b12e1-af77-4d12-ab0b-08dae0df134b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9/1oLt9kQ5/I2N29WolI0i4E3kJ5y4fzJk5cvE0dEZuNkTppbO5fZsZpcxbP5lVDhMh0qYxxEmInjeIT+rITpKfou9zohSacoHzKUDY88wa7k7nnNB4gdyTLuWa4b0HH1H1dOxGaaBoNcAi76VFlItpgS6w1Ubik456yjkjE2RW9FfDFmWFMHDhtVSVSvzICNy9MrmqjnwivrqojlE3mRpYKsQQme0AhZS9D1H9DNhwYZnvkSV20HwjtrEda+Wwr+qBCT0RhzO+WmJFin7Qy3IXL5yh/PTOBMOhxMXVmNLH8Umb3/Wqi0PhRpoRTKT1kHI2kXqLHkamySLXhEsMB7mjLY29Mu+wnVKUVMQQ+pduiHBRUGfSaK+9vYlL0sWIcV8jE7mvgPdVcQLg6ihMjkuSrLsXiG4A7/P1pCA+avz7JNTMyzTsieHoAokBafQHobpnIFwbcGNava4P4GTkZB4tEhJY71pdOGwf4EidzLAA6u04fQfLNRqgkSA+DxE3/LsV7TX1JlXfOrJ+h+stUu+dwV7xanSpybiafv6d6knEkDl2qyH9Hqu7/qVxLbO3kASw9PLUnKm3Oeh8hOWZW1f23y4CT4S696RkAngB0TPIbXv80Aem3Ja9iVOAwxsGj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(66476007)(2906002)(8676002)(66556008)(5660300002)(66946007)(8936002)(41300700001)(1076003)(9686003)(26005)(186003)(6512007)(6506007)(6666004)(2616005)(6916009)(316002)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qWuKqv6gdwF8mZj7+M4wf6PkOF4XOB+B6wI8OskN3HBuhsn3Qm9GIWfQxbxv?=
 =?us-ascii?Q?1szFP0bqyi0R1E5QFlvluq05r8MamsM/u0LB4T5YAX24qYKZIElRABj2l8DB?=
 =?us-ascii?Q?VvOccmF0kdHh4JZ6Sa23uAuDXCRdBhL4sdy6cxxeQ0rq25x019IKpUiE3O81?=
 =?us-ascii?Q?6UabuMBusz+nXtV0m18kDgjnlKBUn7tjqo9rWjzrCEcOs4kHqNrA/AV5Mt0S?=
 =?us-ascii?Q?OmMAOMAQNKJa4VS1Mf6WpTPXeaFHjTvowaOgI6PClSAshWWDV4AaHMLoc6v5?=
 =?us-ascii?Q?HhfAy0mO4k53cFLmtTBtSziu49fbrUiDbxGJCY1/siIFwyiVZa2la4FT/Xj0?=
 =?us-ascii?Q?MqV+trsuvcVN01oXfr7TrXgsT1VVr3NZNQSovBmo3RzLBYGY/60VwUVBaqSp?=
 =?us-ascii?Q?4giJBoVvOyuT8pkIZVhEET3J9/sIlj3O3pJJcYkyIEdhrVhqBnQRj2zzDVm8?=
 =?us-ascii?Q?bAbOoG6dMKFoE+fihc234ggXzy9Zch3gGUnBr1OWciQnAFR5ElepvsYi8zml?=
 =?us-ascii?Q?w7faJ0QhQQyVJAlqPq+N5R3a5T81JPUWD/izwtDItH0J/HkhGcYV6WnAKGek?=
 =?us-ascii?Q?VDXLfjUUFgZnze3L6nN/8gI7ZSxNZFMb7aogZF8fWzrWUxYFQFujaOo4bZKo?=
 =?us-ascii?Q?gFn9dDYf9O52rVgkrYcSqkp6tXP47RzyLvC0d8Jx3Ffz5j+TW7jcNBWf55Vc?=
 =?us-ascii?Q?K7ddNyTVnakaN6Xt/QnzcyJbWEmq3fBdnHlC03hCMY9djvTR+LhED9GvyzOe?=
 =?us-ascii?Q?dNWJEWSu8LXteAyZoZ9vNIpVy2fMuJz4myIfcwLexu3s42Fc2gZ8uk+F9MF6?=
 =?us-ascii?Q?LrSwsW1etMn2BzGo/PyJu+1kiZogNIPxYcWxoOYFojNOEl3TPsf8rXLpGHky?=
 =?us-ascii?Q?a1qxKhc2Hyyc6RXqNLo6lWCTnvbFpuIxXnnOaqqSGl1bgRHGpV9hWAs+Tsx+?=
 =?us-ascii?Q?/vsWWvVPre+Gmw3iBP7O/eoLobe6r7vnYLxxx9EKLWSWdIqoJCBJGXZevYrg?=
 =?us-ascii?Q?cm1cGlcuQLP7URTpeqyA9+reR4B26OqckIjzzQl/qAShlmkVWD2DMo7F8k1T?=
 =?us-ascii?Q?rAUfT8wR4yBQw4P0ccrgVHRJZruXadmN2ZEMPGusLJIJ7sRcuuup1vs5XKmA?=
 =?us-ascii?Q?Y7IHt7db8i8mYXNYXW9IgnpWKtQ+FCOrnVV2Q4kVu92hSb1L/JXpwAlzb1Xh?=
 =?us-ascii?Q?wOWnAqZ7al99kqS8U1IwbetT9Ch4Pms5Dq8/Ab3HJ8LRCqDEc4Xh/biKWRrj?=
 =?us-ascii?Q?KlIMXW1ypD5bcYgT7CUXvyHbXr9BRAm0cW2Vf/tjnR1W252GIBcTmoaiCnAt?=
 =?us-ascii?Q?r+psT4Zajjfu7QgIFzQ7ebJ/0AlOFLT2YfHhWnYE4aZPWoup4qpWkc+jaId0?=
 =?us-ascii?Q?xiZfOvyIrL1qpk5iynUSLDyMa29jrKkT68VI/wHBtCIV6auypaSwyRQHeOmj?=
 =?us-ascii?Q?WhBdwiX6r83o0c5LrFjBXGZ7IktiJjaSLsFXYuuur16qR6MyJC6fFWSqUN/C?=
 =?us-ascii?Q?AYX26nvEVB1jN2eTrYrZu67e82mScGp2tWvE+owMp7JDoBSU6ZZWwtk3OvX0?=
 =?us-ascii?Q?harQPESLfbk826CHRixd/31nhKLnajG0FRbkt//LkZCOt38+AS8hxqenEVSO?=
 =?us-ascii?Q?5A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a1b12e1-af77-4d12-ab0b-08dae0df134b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 10:03:13.3495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gCpUtsVAjFdJRxS6PHYlEdn+t8I/Cp7++Q3wPJeGjfzS0FwOqHq9jK0t7Ugc3kUDYwK1Yhku8CtyKB6LeociFpBffAsOGSEdM9rHq6ROZUM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4536
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-18_02,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212180095
X-Proofpoint-GUID: V36JtkkAjkEgjyRrQaRtZ0lOJ6avamkd
X-Proofpoint-ORIG-GUID: V36JtkkAjkEgjyRrQaRtZ0lOJ6avamkd
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

With parent pointers enabled, a rename operation can update up to 5
inodes: src_dp, target_dp, src_ip, target_ip and wip.  This causes
their dquots to a be attached to the transaction chain, so we need
to increase XFS_QM_TRANS_MAXDQS.  This patch also add a helper
function xfs_dqlockn to lock an arbitrary number of dquots.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_dquot.c       | 25 +++++++++++++++++++++++++
 fs/xfs/xfs_dquot.h       |  1 +
 fs/xfs/xfs_qm.h          |  2 +-
 fs/xfs/xfs_trans_dquot.c | 15 ++++++++++-----
 4 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 8fb90da89787..1a602d22bcbc 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1333,6 +1333,31 @@ xfs_dqlock2(
 	}
 }
 
+void
+xfs_dqlockn(
+	struct xfs_dqtrx	*q)
+{
+	struct xfs_dquot	*d;
+	unsigned int		i, j;
+
+	for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
+		d = q[i].qt_dquot;
+
+		if (d == NULL)
+			break;
+
+		for (j = 0; j < i; j++) {
+			ASSERT(d != q[j].qt_dquot);
+			ASSERT(q[j].qt_dquot->q_id > d->q_id);
+		}
+
+		if (i == 0)
+			mutex_lock(&d->q_qlock);
+		else
+			mutex_lock_nested(&d->q_qlock, XFS_QLOCK_NESTED);
+	}
+}
+
 int __init
 xfs_qm_init(void)
 {
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 80c8f851a2f3..dc7d0226242b 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -223,6 +223,7 @@ int		xfs_qm_dqget_uncached(struct xfs_mount *mp,
 void		xfs_qm_dqput(struct xfs_dquot *dqp);
 
 void		xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
+void		xfs_dqlockn(struct xfs_dqtrx *q);
 
 void		xfs_dquot_set_prealloc_limits(struct xfs_dquot *);
 
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 9683f0457d19..c6ec88779356 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -120,7 +120,7 @@ enum {
 	XFS_QM_TRANS_PRJ,
 	XFS_QM_TRANS_DQTYPES
 };
-#define XFS_QM_TRANS_MAXDQS		2
+#define XFS_QM_TRANS_MAXDQS		5
 struct xfs_dquot_acct {
 	struct xfs_dqtrx	dqs[XFS_QM_TRANS_DQTYPES][XFS_QM_TRANS_MAXDQS];
 };
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index aa00cf67ad72..8a48175ea3a7 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -268,24 +268,29 @@ xfs_trans_mod_dquot(
 
 /*
  * Given an array of dqtrx structures, lock all the dquots associated and join
- * them to the transaction, provided they have been modified.  We know that the
- * highest number of dquots of one type - usr, grp and prj - involved in a
- * transaction is 3 so we don't need to make this very generic.
+ * them to the transaction, provided they have been modified.
  */
 STATIC void
 xfs_trans_dqlockedjoin(
 	struct xfs_trans	*tp,
 	struct xfs_dqtrx	*q)
 {
+	unsigned int		i;
 	ASSERT(q[0].qt_dquot != NULL);
 	if (q[1].qt_dquot == NULL) {
 		xfs_dqlock(q[0].qt_dquot);
 		xfs_trans_dqjoin(tp, q[0].qt_dquot);
-	} else {
-		ASSERT(XFS_QM_TRANS_MAXDQS == 2);
+	} else if (q[2].qt_dquot == NULL) {
 		xfs_dqlock2(q[0].qt_dquot, q[1].qt_dquot);
 		xfs_trans_dqjoin(tp, q[0].qt_dquot);
 		xfs_trans_dqjoin(tp, q[1].qt_dquot);
+	} else {
+		xfs_dqlockn(q);
+		for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
+			if (q[i].qt_dquot == NULL)
+				break;
+			xfs_trans_dqjoin(tp, q[i].qt_dquot);
+		}
 	}
 }
 
-- 
2.25.1

