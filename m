Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40D78C4708A
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 21:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236900AbiK2VN0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236976AbiK2VMx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 16:12:53 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158AA1571C
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:12:52 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATIhsFv013826
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:12:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=8hCopp/nA2uT3LddAeVVvUGVEsFmCIiF3XYQIYuJc8E=;
 b=w/A46qMNRWFx4FHVNMHVga+g0EQK39Z+mEbkEJmZqU7JUn4YvwuyNdtQbfxT/5FQGVUV
 vquTFx1+B/csK584sJVd+rRfpPTxYraVyzeamz6XQ5bHuu0DliGLjvZVDj441uxzZv3g
 sA+BHagr+oSRYmojXLta60Eqf1Z+lrBBlUQiMr/kEDvhzk+vfPM7XWZhhrA2VSeUxaNA
 aKsYHJTaKWRIBaE3AVEyW5rLIbtiClKOsWZOfhqe1gtCgHmTOZO2WBifkIKGxK2RxNgy
 H4PFMNQtxZJCNqjUGOfQDa3UaOdlXtDp93zhR1QNEjdO7FPbT8UBlh2bAYzayozLZxzk dA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m3adt889v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:12:51 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ATJhwtr030987
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:12:50 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m3987na4r-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:12:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D0yE6YqbLNwrgKC0cl40xtXaqhYtX/leE0aGXMM79RUBFrkck8Al0D5h5FK1MThEl9+beIYT2VuQrvr0KvxRLEwERTbPKkp5JkVq1u7JTn3cRAe8ciHLNoGn1fhxz3zm2Wy1I4PLUch5/sWLFbx8knCUWz5vgKYcZWZjQ0NrBzcdS/huFWWNzz9+YoYHfOO0vBPcX1Ywpnbk4Nbp1VnTdv0xZB2stpp57eRoRS55WyonjsQ7w88SjMybqoXTPNmDNgHH2LfxU7vvdwSZJVZ8w7emtzmpRgy5R/L6cg8fp8W5d93sZ0fQFcut0dMlXaACg+VgW4fsbknfKy2Ls8yg/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8hCopp/nA2uT3LddAeVVvUGVEsFmCIiF3XYQIYuJc8E=;
 b=JFLmwIlV0ApBO1vcvtmnKa9bobfl5FRHTj7CYxZxsrtnibHeOBiRYVKA6DLZ8j6hOo3WVZWCpsNIUSAxKEN9YLEZDunfoK5WtlfBFC5vjUXewusP04kx3YO7ZSoL5VWXJhooyOzJ7cJqWV/XoWbI192cQT/QmIvb8rwAl/ehkt37LZye1UFRUIeBd4og91EDUp6H/D9CAEzhhpSCH+BhL9gaaFxT9BoSeSCZZ2s1ra+hfCIaadk7zG5z/KOy6rmpoEbqCDvnOLj9r91yjAplkKzSrHv8+G8XMHNY96/SRV4QrQoOqfVSzoF5YBJPa0DsqVEXPUP8E/jfcbXwxEPC9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8hCopp/nA2uT3LddAeVVvUGVEsFmCIiF3XYQIYuJc8E=;
 b=VpFIpzg5gVKUTZGq2WBUcdl/ujpO1JEASOkIX1IuW/UKkCvGiOkgDujEwVsQFONMWnKyVNCvpjxpgy0utBRYZkYkioF0REhxXamsZF/kgS8Vpd96t7/C2p7nn9yYto8bh2+BzxpSGxL5O8om40DMEdeQF4oIeT972WrBZ/l4P3A=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4259.namprd10.prod.outlook.com (2603:10b6:a03:212::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 21:12:49 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 21:12:49 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 03/27] xfs: Increase XFS_QM_TRANS_MAXDQS to 5
Date:   Tue, 29 Nov 2022 14:12:18 -0700
Message-Id: <20221129211242.2689855-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129211242.2689855-1-allison.henderson@oracle.com>
References: <20221129211242.2689855-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0003.namprd05.prod.outlook.com
 (2603:10b6:a03:254::8) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|BY5PR10MB4259:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dc0c7ca-657b-4a9e-7428-08dad24e7818
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9WYMl3bUdw8PZ1fgH4Q6dlw9/kOMNs5c6GbCLxwi/DpnHaJ63tUzNOP2/01iBiUzKn1Vdm40a4HxGnelBoyjKct3atKLOi8zsD1pznCfEeXaQbVItzoYzi+wjavBdl536Aq/WPyalB2CGTxFKTSRqnvRLFEe/rqmq+ljM2qNuGghJKQoYBniWCneCkys8Ln38z0vHVnzatsEidCmpLYsQLsvUPAxYKi1maT4DETnGDSbgxZM5GcZO8ct5I7EYSzw77NWekCxByL8FrAPYWzqkupNZGSgsDQTkEoG+hsL+NfsxIdtOl61IVbRfiM3dACI6fXnG13Xxz+y8ANlTyX+AoTQJ8CMMEA52gz0vTTLCSsAaJmm/trruXSGsAVY7wabx269lJh3IF9QnILQohEappECuiSxuncvjch6kUNqdiUc8baUt2KdQhOtoYO4zst8jpIvMSL9XlqADFuycjCvycAkQEwU7Yt0dc31Oe4aDe3RAalaYnFRDgoRQoL9ccg9IDkzhikEWbPHPuXV4VnM+LBvI3R08LnC9CLKObLmtQ6ZFh28aFXB/AaHST6lps6X4rBv0IlOiW1QpSY3pFR75UA9e1s+6abldxby0mU/MNzknI2+4uhGDyOwz0YxhTyF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(396003)(376002)(136003)(346002)(451199015)(8936002)(5660300002)(8676002)(36756003)(186003)(66556008)(41300700001)(66476007)(6506007)(6916009)(316002)(38100700002)(83380400001)(2616005)(6666004)(6486002)(26005)(86362001)(6512007)(478600001)(66946007)(9686003)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K9SYpYr6MsC/CxE1TSFKCJAStOv4Nw2QfYjIXLPJtK3ErC2N1I75UJlN4Lou?=
 =?us-ascii?Q?b7h/vIECxSPm9h5vjq9s6W3sTjACowuVLQoiGgzf9hmw5j76ix+/Gh3hSqFD?=
 =?us-ascii?Q?UFopdUumIeicz89iY9RGP2eNTJ2kxhSOPZbnrvPzNC/tUHJBsn3jnwljnalb?=
 =?us-ascii?Q?541vjNhW0eowqL9QGbfuu6twGgM9Ej0whnVAqmuJaTpav6laCxo/+sNOTaM7?=
 =?us-ascii?Q?xYiiSZUFfwUG3gs6//H2c6EB2kOQfjVggUvc2WHzno9Sir5uz2l3X7fXFiQs?=
 =?us-ascii?Q?ZRAZxctiAXpc4IZ2cKhWl1lrdOkBbOjf1shhbADPhpyqhOfxuiruEzGWg227?=
 =?us-ascii?Q?Zs4BagvGugM7VvMPsI5c1+TnS++Qb7X6x59fCn/Awa5bckffCQmQDRVGuqSN?=
 =?us-ascii?Q?rOmi6EuLqmlxp0uTtSx4qqmbzV1DXvRgAffPtPxyhuwD23s7+WeVrSv1eC3W?=
 =?us-ascii?Q?JmwJ4fu9/kJNT+011jZXx4Z4CjPevlE23daQuVCHaE15XRa7MCEd9x3K08r/?=
 =?us-ascii?Q?MR/2unKQP2erAA/uZU56F1DjWmoOTVCQFsnbMVe/pk4+Eo3B/kGDVrMR+ckQ?=
 =?us-ascii?Q?EAKY4+g3z1YnNSPslK8MnXQ8fC4uelfP3GbIi8hHZ5t58jJbhWCkNKhqFbyi?=
 =?us-ascii?Q?q6dGIr7Krw/lK2sgTZuhMDxpv/qV1a608li5NPqC7x9N6ZrXK45fGne44pPO?=
 =?us-ascii?Q?FCsSqYxoR9jroPmG8vBuvmmFavpp1SGbBI7Uj+sH+MwY78bQGhshsU8kCbDO?=
 =?us-ascii?Q?ARf7YeHVCxONRVYdG6S16oWFBlmDoEpjM0BIfsVd1nFLERuEL15EyrToXjoM?=
 =?us-ascii?Q?5O98aYDglIvTCZUVwOjfsQ991P+jWLQNuVfP5f0AzJRJ532vU311B4nFpKO5?=
 =?us-ascii?Q?eLRNB08gTYgTOd9gr/0tWfeF5lOhK8SZ2ANnKc7U9deYqF8b1e3dK1VqT4dy?=
 =?us-ascii?Q?95ObuJD1EYgYoj3z4Sina++UBs54J4bFDwAO0OYTV6VnnQLk7s5AbZ/bexaS?=
 =?us-ascii?Q?MJb/hwb9JaCe2IR13I/2Ls47Hhv4ptYHzW7aZummR89Ri/GLnm84qAuOgA0X?=
 =?us-ascii?Q?nU3l7rVD5o5KmQI0+Lz5MC3NqxJHWG2u2FrOUYleEM4nB0VFhFCaGiGgG/D+?=
 =?us-ascii?Q?pCm2Gh5YObN5C79/huQp5X3Wdyg6lg7h9ewQXOGXxVC+Du2MPQYR2UNAZT/z?=
 =?us-ascii?Q?GVNcETVU0SsYrrm/D1pLFxXvt40vIokhlZ2tiBrMT+pbADeRmuV2D+sKa4C2?=
 =?us-ascii?Q?gnG8ThtrOW6np9O3WWvJyx+aXyW7oIOt+9dJrx6Ac6rVUHLaTGqb9+DpyBTb?=
 =?us-ascii?Q?oIqalmdO9mPjH5rIBsUrSuUn1dmaymONEWgQsrgvFvR9fPW1WNGrMiWQ46Yf?=
 =?us-ascii?Q?xyccSEPXke93kV5h4kBf2b8FWjrWQqiyZ3Vioz8kvIi0CvLN/L7o0GKgMJSp?=
 =?us-ascii?Q?uxTq7QoDPvOt4TJEFNCDv7+vp3hARU5CfjocUSiTN21vusZIE9onF53TUuWT?=
 =?us-ascii?Q?LsSuOZqEUwzurOwc8ZGW21xt3sdmYCoZxuhba+jj3842vh7CBdDAw3rP3LGJ?=
 =?us-ascii?Q?WQt7yuBMI674zNGXgIU8kLgw7MTlXLm323FvzWmN39+7DVReNcVAPCszaG+Z?=
 =?us-ascii?Q?Nw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: E+q85+Hm52VQngTNJjg77+ooNdbD6PPDCJKW4+2wcqiz1N7v/bxMDzW43hSd//JwcCrkdH18/Edz+ImMhKWLauBZQb940Ht+7WJ+HEYhzG6g/fxCwv9tRV191ShewnV+0w/10xA1Lda/1+JkReyy5zVfyJ8ocd3/qQySt2bQ+y8O1XtC5gm4vWWd3SrswjO6p2jPlNxgg4DQ3bzBSGB3aQYQTfKeshEtV1fRJ6pqf0fRWiU6qBFF5EEMWcbY9mA0/gU4THysKNyZWzu2Hse459HuU/Jb6kpvOEvKnk2fegQu6dsyctQ1E05tAIfh6l4mmZea49RZ/Dti7vQLZZP+uCd3/tprpfZSbMji763fHyU6G/wgOqQO+pD4s+yDnL44meG+ExjPnsEMq4T2gDvODqKfg8RTtB+KHod081RzArpWLUvhJRqtd1MASyC70dB68Kmup206PJ9hx/vih26NXqDVX2PUlAgmiw6EMZutKoL6r1u5+toM0yy7NRXSpSnfPVptV1HZ6tB6FfQXPmzMkkTFwrIKB3h4p3+9/Us7CZI73Fnjy54zOrrPll/nYuLDdozpR3HqtGuXMgjgvqGbsmF8W+PhRAkhkBiO3vf4IGayGNyTcJTIDX0KQp+J+Xs+63O7B3St6nH8If82Rm78xzuwfYSKvlt0rhxDplLytOYfgstSasMBXoikSGoJguw2iiwuQo71xv6IS3wWAMBN/maTuF7jiMiFlk124dMx7IiqzWuYaYN1aDVMw7lGFz80fJXKnXSB39cSqsM4iFcQFw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dc0c7ca-657b-4a9e-7428-08dad24e7818
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 21:12:49.1590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I5/TEbUKCYxnZh88trs3m5MUUJafMgi+7DCOHtNaR7Wd511BOeQDAIrPgI8l3sMntBMQxszpkftUr3/XXJ2xHwP9M3lEI9F6cNSx82yjbKs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4259
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_12,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211290124
X-Proofpoint-ORIG-GUID: Bfq_wqBYeSpVWhG5vSaHXpdYi9bDb6yr
X-Proofpoint-GUID: Bfq_wqBYeSpVWhG5vSaHXpdYi9bDb6yr
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

