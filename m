Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80C9BCCA485
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 20:20:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234968AbiGRUUi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234980AbiGRUUf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 16:20:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407CB2CCAB
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:20:34 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IHXEeG023346
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=4tYTG1i3xl4YL9FHaKHjO/ZrgsZjMgjGS4H8bMNkzko=;
 b=OInd7YBr0Y9xzkpMnsFz01EYvKPDB75/CR7TDxZ6LiCRXEl/+PS86TWFyuWN0rVmvhO6
 TX/oIFHsmkUC54XZKKBaIbLT76VCc+m5mtMI8BsTFdR8S0AtveKKxidTxWjn1mDUdUPi
 taUDG8lizLMMIJGsLFk29ivi/2VMQKM7rko0xA4HlNVGeObmHsxN8Y6rLyDlG9QDAP5Q
 oaODJlZtdnXy5jf5WaQ7cRIAmsCEgDGWO/Aif8URZmPx3XKC9jvrmBllHvv4sP2b9P0N
 eNuhL5kSq3pzg63WtS9l5v1ltqww9pXZYTdxiDyE3eufBmpo3jpbF+Gk2KsHBm5iOHGL sQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbnvtce3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:33 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26IIp4t6001290
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:32 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1k2sfbn-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kcvETGKXCMYYR5MN4T+FlyXqjRNZqFV7euJfi9hzg8QdfRsyNSHtMPvpIIvZGm12widyEke9wuIxolQxpmQTiQXLZ356Znq4aSn9lHNJDS2CzpOrCy9hLsWrs+qV1MhzPyiOyJuvXQORR9NLYJGyCGdUylyheLx/ZX9BFzbgOI7WN9eKcnN/5lm5JEpX6C3RjvA7p+Ma5dF0qyDg7TwRzrTMi/3M7D3ryhg4KlBPVNAYze/tUr32V3k6SazpNPQ2HlhDdi6cqPOQKkvqXys7+2Ucektig0GPkeF242p3xGQpl75KMHvmFDae1Pyfo4Tgv3pSTv2UqLRnhJqRbrFcig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4tYTG1i3xl4YL9FHaKHjO/ZrgsZjMgjGS4H8bMNkzko=;
 b=ogVG1FsysKKOxIgqwJ+NtmCzleC7qwY/MhH5PZEdIufnwLjHA7aY+0qzCI3R9s4jY0YJygk+d5t1WOE/WWozxnH/1qfSRAnFJr/oVc9uHz/7EsmzB+GKOEqZY6eAOCoRXwxQJcJBZKq7Fmo4igFVHk+/Ll9dQ4sNzxCt6rIVLMBHPlo6ztPe3/Qi+NnyNjjuoP3ydLwRgGFE2XUZcvcIzmyXcM6T8nmcc7nTudPq5/lwQLrKlOSEEcLc36atz41biobcgpj6KFt4PXyYqousS4DivZCTraFxXXxk9PNvqMPQU41oLf/ib+kEyhb9smqpUA43SQ0ydgQkJMI0tlWOiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4tYTG1i3xl4YL9FHaKHjO/ZrgsZjMgjGS4H8bMNkzko=;
 b=tiSmwGfNtUQhVWOPh0Flj6iBUVhY+M2OKMc1wKE+WPLFIVWoaNqgeOgaZwcVBNMUoDN9ITJsNis8W7RDzXxrxwoePhztvC1IuVlbKOXSObonz+KhSSh6looQ8k2z94Gi+aZYDXGeBMn0MByzcek88bvtN4ujd/3z10AqtLt0cNA=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS0PR10MB6128.namprd10.prod.outlook.com (2603:10b6:8:c4::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.23; Mon, 18 Jul 2022 20:20:30 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 20:20:30 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 03/18] xfs: Hold inode locks in xfs_ialloc
Date:   Mon, 18 Jul 2022 13:20:07 -0700
Message-Id: <20220718202022.6598-4-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 55ced0d3-4865-4e2a-9d02-08da68faf581
X-MS-TrafficTypeDiagnostic: DS0PR10MB6128:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NDoVwZIPFzz8u+2uVpzrsnqLH+yJOlpMkErkZwIbDb0NGPl5KnnuCyISRKjA83IFwJy7+RlozVqZjQwALrP2lt/pJHRq1DWpi4hbzsiqWsQoaH7nzZLftUgCJ0S4X/AsROOuDebDGcFfY2sQkat71euK5b2kkhdXguUifhhoOHJKB2kpUECC0abt8rSyfafFbQP9CJ7V83obas/glLRUDyKPTJjavIXJsWwVegU1uZtaDaU2Pkid2vOhXwFnPvl/9pfU3hlFfIz7YTfgWLTifAVupREQlR5uSY/KcDwycza19u6/vEfy2XLR6ggYXR/6wQPf27GBwdu7xzFVHJOrSt0aVmT8lMvme73U4OcHkFs5X5LVmWOqr5g9Da/oFxMHbNDvPDBwI8Y/vxzHtQTcGlGOLgYxK64pjcyS8eOEJyN6KeNBTH2Sv3GBF7HKw1GfnoIIiO3gr1WmhCCkdu5yFsDW/DpB0rkUiIMh5ruJLiyZcwF5bNwKFk+u7oqG8GCgZ1Q9TemNl0xC+wM7EFrPPqRgmxcfh9EdIMYjD5q6roCVKcgu7S/GMXlNXqaL70DFXMxRSIlU6ndDZJkLi9sQaGr2gvmbar4RhuieFkRWPflYOJwwCiGtO4OjkIbYMkePnw2TyYMt5b4zhbj10JUxX3wWZpk01itD+zZRf+F+viVdECFhmYcPMXLTG7w0ckSbhf/Yqbs/Qt26PSwQgyvHc6b7lMaOFvIabPA3n1D5dY7aNl7vBYX/gJdv6Nrl7wFf6G1XrE0fm1kIHum/vgxQxizxrFUHvroNvDUddAsx4J8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(136003)(376002)(346002)(366004)(6506007)(52116002)(6666004)(41300700001)(6486002)(83380400001)(5660300002)(478600001)(26005)(1076003)(186003)(2906002)(2616005)(6512007)(44832011)(6916009)(316002)(66476007)(66556008)(8676002)(66946007)(8936002)(38350700002)(36756003)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j/GPjkbC2c/Jx0Y1JrIFpLCKMp60+MGaHIHHHUyrxO9sMr6CRmnkmrf9qIi8?=
 =?us-ascii?Q?WQbUrqAzL1gg+vQOFpLc5XolehLhNoiGmptbMp2ghOw9ghLjhg5s8ip0nFCG?=
 =?us-ascii?Q?XVaOSE5BtJgAFVOuHvr75o1bcvht9gQ4vUCaiOcTyqhh2ENip8iNunpEIr3P?=
 =?us-ascii?Q?A0BrJI/OaDEmJ3YwKPHmnLjZCnWh4KjtwaomijKAU+QPeMX4QW+Oj1mi8gIL?=
 =?us-ascii?Q?vxhmTUhwyf/Ry40dke8+Gbtjz7j1/u6AxkulF/gRyKNkZh4bBN1/fS7Rr+dC?=
 =?us-ascii?Q?a7z8tAOFPhgnz4Dk3w76qImD72stOVFoQK+J/wKv6CNkZUs9+Urya1Dac7G8?=
 =?us-ascii?Q?tbGnIKeDQV3F01XyELe3cTMq4jvSM2uKPW40AE7eqEie+4QfWaVIA0qST2FY?=
 =?us-ascii?Q?8xUewBjz6IAr63cv+v4MOqin+I5QUiVH7kBN5Wy2BFnt1VS61VociECIVUAD?=
 =?us-ascii?Q?BFvsDYBqGiDLqaR8+rzNYcSjUdr0owsxTQs2WN+p1x1DDmULFmlzsZ+9qffZ?=
 =?us-ascii?Q?G1cyvapXrDtwzwfLlbf6pGcdzKtXz0YeTod3TTG2TawWHLErceFgLurdFfzI?=
 =?us-ascii?Q?h884UiPqwFlLLXeoohqyAl8rwFtAs1f5gX7Rjblpz80z9v1P7gKyYXr7WZKi?=
 =?us-ascii?Q?8/npbKKqcuqFFYTrsv3hOjzAV48Gci4e+bcI+F+SWy381gAixfl/mCEfX3Yg?=
 =?us-ascii?Q?jXHvUSkB7cn/2VvI8pT8X8aAoLE850B7/Irphw0NfDIq11U27I2tsj2f/xiK?=
 =?us-ascii?Q?B1e3Qwayv51js/FERTO3Mp+87k9sMTDk5HUGFoc5xa5boj37C769zyqVC97h?=
 =?us-ascii?Q?AdVCSp2mrUPWwR+iyuXkrdh1CBEUMt1GfChmXkvGKsxwqGdRG5W+X35u036f?=
 =?us-ascii?Q?IL9NIPc2V5xt6TyUTKLX/CUZ6SDYh57X85tP/NqcBMwOvKFBtbz5jZi5vMk9?=
 =?us-ascii?Q?58wocTIWJwEUzNoUM5yNBNIrSNWnhnEJxE4YWuadG1n7UQxHU4gJIPnGyAkB?=
 =?us-ascii?Q?+3p8z2tkqXUC2nQFHGvl1zENvxz8XOitBvXFeEGuT5M/VrtyAvps2eMg6bJ0?=
 =?us-ascii?Q?/QAE7cS6Qx9q9f4+Q047JprUSSjWb0aOcrFnhMJ132JGMDekD/lTwxfqxt70?=
 =?us-ascii?Q?Nqg3c36iewMoJGYyahNJ+kgCRF0NTVdXTysIeDXqNjDKEXDMwazxnHlOSz9p?=
 =?us-ascii?Q?Dh9a9osGlFg632q070PCupqLYcTpjzRqMjDvZx2m4XPOYUjerez1cD9kG6wb?=
 =?us-ascii?Q?VtRqcoKBCi7MMzeiS07vVRlg7b3UOrIzXu17D6c6FjcN0lJ9/tWZzgxYdQD3?=
 =?us-ascii?Q?hNJ7IphbpzBC50XDjidanksvvYoGbAFB/GJb0PPxlrnApU+zF9kEpPFy5G7E?=
 =?us-ascii?Q?92fd2L72WhpRj1k/5IEURDl+WdenoW5OqxYuQ9J2yjNem8yYxHgQwHQRx+pO?=
 =?us-ascii?Q?i5t1DNzj8UBf2wpsRL93VU5bvwOUFnfSTbo7dh2S8+LsghJq3axENh1MekMP?=
 =?us-ascii?Q?jlioPfeGLu1fCqnrQGBcNKvS0Jj6qDtb8towwFWo4yn3OcXmecWMRJj2lrsO?=
 =?us-ascii?Q?LGqoVQfGBBi13i/9VCeqGO7E3sOvGEPnozfO0Dj75zHzRp5rlRKPakgfyo+e?=
 =?us-ascii?Q?fA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55ced0d3-4865-4e2a-9d02-08da68faf581
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 20:20:29.8246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NzpMRz+kpckzmyNRdOQ/HYPn1DRq6IihgS3k1qWAEb/sKKZZXwWYjB56jCtzh6rFLP+6sj1Ko7k5HG3/0a+zYE39DqrWmmsR4Hfwc9c0b8M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6128
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_20,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207180086
X-Proofpoint-GUID: EV4m0BefuQJQ2Y6otBksaLZgK3xDa3uw
X-Proofpoint-ORIG-GUID: EV4m0BefuQJQ2Y6otBksaLZgK3xDa3uw
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Modify xfs_ialloc to hold locks after return.  Caller will be
responsible for manual unlock.  We will need this later to hold locks
across parent pointer operations

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c   | 6 +++++-
 fs/xfs/xfs_qm.c      | 4 +++-
 fs/xfs/xfs_symlink.c | 3 +++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index cfdcca95594f..cce5fe7c048e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -774,6 +774,8 @@ xfs_inode_inherit_flags2(
 /*
  * Initialise a newly allocated inode and return the in-core inode to the
  * caller locked exclusively.
+ *
+ * Caller is responsible for unlocking the inode manually upon return
  */
 int
 xfs_init_new_inode(
@@ -900,7 +902,7 @@ xfs_init_new_inode(
 	/*
 	 * Log the new values stuffed into the inode.
 	 */
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
 	xfs_trans_log_inode(tp, ip, flags);
 
 	/* now that we have an i_mode we can setup the inode structure */
@@ -1077,6 +1079,7 @@ xfs_create(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
@@ -1173,6 +1176,7 @@ xfs_create_tmpfile(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 57dd3b722265..5582c44f12ab 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -817,8 +817,10 @@ xfs_qm_qino_alloc(
 		ASSERT(xfs_is_shutdown(mp));
 		xfs_alert(mp, "%s failed (error %d)!", __func__, error);
 	}
-	if (need_alloc)
+	if (need_alloc) {
 		xfs_finish_inode_setup(*ipp);
+		xfs_iunlock(*ipp, XFS_ILOCK_EXCL);
+	}
 	return error;
 }
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 8389f3ef88ef..d8e120913036 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -337,6 +337,7 @@ xfs_symlink(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 
 out_trans_cancel:
@@ -358,6 +359,8 @@ xfs_symlink(
 
 	if (unlock_dp_on_error)
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	if (ip)
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
 
-- 
2.25.1

