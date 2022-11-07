Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1668EC433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 09:03:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiKGJDD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 04:03:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbiKGJDB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 04:03:01 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA58165A7
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 01:02:59 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A77rhg5014980
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:02:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=6/CpM8uOcsaH+T2myRt881ZNxiH9A2jc39CdpScZEMg=;
 b=QFPWkq9pgSwaVNVE+PXz2suH7QKNSQF0e/LzPgiTqdPV5fEZPjiKjXA5K+RgeE4ubDKm
 9D7OHECKi3VOkxaN6tWxf4SXOOi7tjT49ElUuRHHCL1vEXSICfsi+ja2IVd0v5BjVIq1
 ksK2FsCIReQT1L7NMbD3GeQeiwOsbn/UrQgLOkI7687BsFavkDGRwE4At6SJyRC5aHU8
 l6J6MKafCXCIJq2gG52I3R+cx0bwMYmw9PtDI7rpLsAHRop952jE3Qq4FQJ5MdAtN+RD
 rzbPpn9t89qPhZHt3Pz5f9xB4WOj7cPdpxGIfEOfGecJTtvDRQK/ZAfwha/oDkEZE3x3 Nw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngmj30h5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:02:58 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A784nKe014429
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:02:57 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2043.outbound.protection.outlook.com [104.47.57.43])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpctatkrf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:02:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MJ9RCaJCvZkiyIGVXA3uJb06UCsWBaVxEbR9Jjspans14q+kMpl/Xqn7qswpC+YoWMD5ZCjdWOzTfYub2BcPvqxZ96KtAm2qW0g1EEnahQi5jfFaLSSW/X94aVvA8fBZG3T8BkZAQbUvSLLZAzoLIdGSf13XJpraPHnwpeAW7GvLnQaJUQkubB3PuXmFqhIs7vogl0d/uNBbGauNjtAevFzVNxrF5P2QVUJbtCYqfZqLW+VC7NgsgYcE0qFVFR2BF049RZIreHwgn5DMaQAEYfPKg4EQmgxmhc9Hr27uXLbrOMz5VwLsQumOOw8SfIIs+MshsRiWsfTV852CPECzow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6/CpM8uOcsaH+T2myRt881ZNxiH9A2jc39CdpScZEMg=;
 b=APW4frHLxHEVuQQyTIWK3HKa77xXMzKmitU2N8/s80QTxT90QdkmW07yCrV+/Y8ToUyFGdX894Jwbq7yquWhVLHhwezmSs0bRKlB5zlPteda7pzq0IIAyqWvK5jdi1q7Tp4AGlISrZXLMGA3yog8wR8r078TpPipqUET3Gl0TNQeNb8ufsp4d+IYWwNmcmjZlds48JmL1s/s+wdSgrcd3df+OgqFO21p8+dkiFOIiSW1+MP2Qc18H2lXJU0T1M1IbMI/sPzzC3kYaiSg7gtST2Ov4XuOcx9lpj/5+fJgVsUkTFySkknj2DMITwpm4WAqHQBLYqZNSAwPewlsZkzUIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6/CpM8uOcsaH+T2myRt881ZNxiH9A2jc39CdpScZEMg=;
 b=C4RlV2+mYKfONaEAMgdhGYshKuBghSKWaq5wKtiCfasT/Yh5jwaMUXrwkGCXxHkAbUUb0UugKDIKTjq/P93rW0flkfngjSpgcd0cEaZtOLM4JjSlyMfOe0HWW6szfVYKMIt+H7nzOp+B34NNKVZAVJh4qlbmaj78SIFYZRZxPWs=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5848.namprd10.prod.outlook.com (2603:10b6:510:149::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Mon, 7 Nov
 2022 09:02:56 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 09:02:56 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 05/26] xfs: Hold inode locks in xfs_rename
Date:   Mon,  7 Nov 2022 02:01:35 -0700
Message-Id: <20221107090156.299319-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107090156.299319-1-allison.henderson@oracle.com>
References: <20221107090156.299319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0030.namprd10.prod.outlook.com
 (2603:10b6:a03:255::35) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB5848:EE_
X-MS-Office365-Filtering-Correlation-Id: d1387704-4280-47db-1be9-08dac09edc80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SCNngGC2nvnxRt6MkMfoUV2Fr91uSLtdKtSQ6l9oCfE+s6NGXfU8TedM1mRcVAXwlVnrc4NK+7C/ZphOE9qsejH6/J7iNXVp47pLfjbr1vD7ANG2biiH1fm9YTnz0HFmqaB4D8NTguktqSvAnIRrsaf6B1qln0LLvw1+cBKmRnT5NaOUYu3IfwqybEgyKFrA9j4MfIqzqsJb/4Ru8bbkoywoiXOW87AYKiRCsffLibfFQP1K5II4kHPnvEdZDzARiu4F8t//e/+uWHjDo4bjO+GuZWwOql2lz+OgtzuZwRCG2Az2BkqnVMNZQtd9n5KXXkOO9sFqOeFdxTOnVViUTAVhMbOZ6g7uamfZ8EclIE4wef6jaavbAv1awsILKhTicW7VBhseHFtA3aKFMtU2HXAic0k1qkqcACWKV+Id0EB+x3iRyKZgapZhUzAYO2OUHq58x18cW4ZIr3h3hvBx9SoLJ86Yo1DzLExjzkf/3XvjsXjVeYun9Py+W6r9PKi1qZa0AChhaXjDs5OnG5WRFfFYwDEyPpNRw5PYzC7OatA0MaYuS2OmHo2q41h+IjqaVQqeEPkEEpwse35E+O09Ntm+XCx6NuDaAzSkuNQjIzJr+zwkrOXvpXox+ruyM9G9jtSz5FKyVxR+Ui5CwgR5LvSyyLAOyyo0nDCm9I06TmKDygYHnA8Sd2Lgko9m+dtI7eHeUvyb/+b6xKVkRm+mEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(36756003)(8676002)(66946007)(6916009)(66556008)(66476007)(83380400001)(2906002)(6486002)(41300700001)(5660300002)(8936002)(478600001)(6512007)(2616005)(186003)(1076003)(26005)(316002)(38100700002)(6666004)(86362001)(9686003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3nz2ReojrlBBD2EA9yXuOW5Y2ArwwJfK+pJE6L1ffwX9FUXL+QYVRCnCBPdP?=
 =?us-ascii?Q?FCyEqprd8UsWJJcJNn595ylV9l+eRXoD2ePCiT8t18BWzrJMnuI6Z5TyjHHC?=
 =?us-ascii?Q?rO3tkByQ6MnvT8Sy248UmQFGu/rSbxvIs0/FIhuw+qOHQpB1YPWsmhBxQ0wh?=
 =?us-ascii?Q?fRlaDdxDGtsCxl4TnvQjSTjKz+5LA4CTYMRIuoP60gzJDwkZ6Z0TORJdQSbE?=
 =?us-ascii?Q?71KuFaHHva+9Qgl3bz6syguh1QUjGtNEJjM295UkdlLFVQ0S1BLFqYo1FccV?=
 =?us-ascii?Q?Dbi0K5nW4GC2zZEAQmSDiKqGgYjHc80LbGcyuG8CP3hHk1D6k26wNmnmK2so?=
 =?us-ascii?Q?LNhyMksOqmb/61ks0PFj1TLaTv4vwUcoTZF/MidOels/p0s6z5nnSIGoevdF?=
 =?us-ascii?Q?WEuFg3VGVfyxho7M+f7FLiPrNN2XLwPbO3uYmGk3XiWjpj0NrM2ZWaKiifnV?=
 =?us-ascii?Q?4BSkaa+8NmgN3FHNjO8HxeQsn4WnKkhIaij7TNhIBBvX8rTkkNHfa67QIC6i?=
 =?us-ascii?Q?s53Ff8aeLg650RDgwOzaXYNOy0yp/Jx/+Bjb7huj1DyL7DQgxNNjt8qECNli?=
 =?us-ascii?Q?TlXoV8nF/nIc7jlClHOtE9Gih2tijDkW9sXRHJF5WtGKmxFMGU87MFoxOzOd?=
 =?us-ascii?Q?RB/PfJtbOMLWhP6Z3LE6NXLOzZCNzeN7czQhrogTO06vizZIEWu4CwzdBP8m?=
 =?us-ascii?Q?yp8h2kAJw+PyTiEObR2wNnUkVP/B5bNyp53Ym4MuvTVSZFPCGNKm5MBFBeBS?=
 =?us-ascii?Q?mEJN76mPJHccVim75YERFIcTPGzHxdIdJs43mti2MmsRkI39eg9ZNxFgttoE?=
 =?us-ascii?Q?Cy0rZkGFbmWMOlgsD46v+Z676//byjnxUDAW9Ux+ZtXzjuKyGC7Xka3z6Cuw?=
 =?us-ascii?Q?V2z0LR665/MPLGwP1bVXsI5jKKYLr8bogG/pVCbh3LfGDcrAkjk3CsB7IosS?=
 =?us-ascii?Q?0cEMreQAfhQINiU5EJ3hdlaKjiMgZxqifEzdqDK2twnAiwa7tyi4sqSz1FbY?=
 =?us-ascii?Q?zduo9remYe2xW65J8ZJzx0sWfFOutxyjA0sXyffPPKmpI9psHXFuBUQObr+9?=
 =?us-ascii?Q?5a4FFQquUorhXe3qYbBXmV3h7EnFDYOXJDtv0mA3Ukw/9HtT10dN63/TEOat?=
 =?us-ascii?Q?N+jCegzFTpBgo6Ysz1EZz9gYEwprd5QrUhHALSkM2Pn9boF/H2lSWs29iVyZ?=
 =?us-ascii?Q?21tiF7iPklUsTafJBbq0ILhH5b0C+zpnTaV1GAKGC3sh16STa0US5F9r/XmZ?=
 =?us-ascii?Q?QcQ3mfiNqzadMyZhLo8n6n/tyPaspJ3y+hDDdSQ9pCsBv9C7TXKMu0B0ipWR?=
 =?us-ascii?Q?eByD91zgmuoJVAYSNvPgQtn6O6fv6chGFqoQslwRkapjXWWaYmsp+kWReyQy?=
 =?us-ascii?Q?Wc39mGx7iAll1xEWompnBSgogTel9n2/LEcXhhsNpAp9Gdi066bUu1OhTMzJ?=
 =?us-ascii?Q?pcEifjU/qX1UCCsBMDmzBWCxXqkd8DoSRRZapZoBdMsJSkGWPXzNcGWu1gkP?=
 =?us-ascii?Q?p9g0ustRwjlqQVKI2HiAfDn7Lyvtx5R12JY3P8BqIgkyU+QNbWu88gmAA2mg?=
 =?us-ascii?Q?RhEC/PZf60hlDlNQep8EUTnaGSyENJVtlZo0reH1X4Uxpp7LYf2Xz/vd29Sa?=
 =?us-ascii?Q?8g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1387704-4280-47db-1be9-08dac09edc80
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 09:02:56.3719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NmC7UbwI6rLWK4c7J0wALdyTefYehFBTG5OGFHwaYX8j79/Aq/NG+oAIiYaHYDN60nuRDSjl7Lq1LX+Pto0zpfBezbZ5aV+trSbsk3MBECs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5848
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070076
X-Proofpoint-GUID: ypHUjQfhfXSGosissdCuMO1icjECkhAL
X-Proofpoint-ORIG-GUID: ypHUjQfhfXSGosissdCuMO1icjECkhAL
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Modify xfs_rename to hold all inode locks across a rename operation
We will need this later when we add parent pointers

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_inode.c | 42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index eb4a9c356e77..7c91a4507a65 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2539,6 +2539,21 @@ xfs_remove(
 	return error;
 }
 
+static inline void
+xfs_iunlock_after_rename(
+	struct xfs_inode	**i_tab,
+	int			num_inodes)
+{
+	int			i;
+
+	for (i = num_inodes - 1; i >= 0; i--) {
+		/* Skip duplicate inodes if src and target dps are the same */
+		if (!i_tab[i] || (i > 0 && i_tab[i] == i_tab[i - 1]))
+			continue;
+		xfs_iunlock(i_tab[i], XFS_ILOCK_EXCL);
+	}
+}
+
 /*
  * Enter all inodes for a rename transaction into a sorted array.
  */
@@ -2837,18 +2852,16 @@ xfs_rename(
 	xfs_lock_inodes(inodes, num_inodes, XFS_ILOCK_EXCL);
 
 	/*
-	 * Join all the inodes to the transaction. From this point on,
-	 * we can rely on either trans_commit or trans_cancel to unlock
-	 * them.
+	 * Join all the inodes to the transaction.
 	 */
-	xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, src_dp, 0);
 	if (new_parent)
-		xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, target_dp, 0);
+	xfs_trans_ijoin(tp, src_ip, 0);
 	if (target_ip)
-		xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, target_ip, 0);
 	if (wip)
-		xfs_trans_ijoin(tp, wip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, wip, 0);
 
 	/*
 	 * If we are using project inheritance, we only allow renames
@@ -2862,10 +2875,12 @@ xfs_rename(
 	}
 
 	/* RENAME_EXCHANGE is unique from here on. */
-	if (flags & RENAME_EXCHANGE)
-		return xfs_cross_rename(tp, src_dp, src_name, src_ip,
+	if (flags & RENAME_EXCHANGE) {
+		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
 					target_dp, target_name, target_ip,
 					spaceres);
+		goto out_unlock;
+	}
 
 	/*
 	 * Try to reserve quota to handle an expansion of the target directory.
@@ -3090,12 +3105,13 @@ xfs_rename(
 		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
 
 	error = xfs_finish_rename(tp);
-	if (wip)
-		xfs_irele(wip);
-	return error;
+
+	goto out_unlock;
 
 out_trans_cancel:
 	xfs_trans_cancel(tp);
+out_unlock:
+	xfs_iunlock_after_rename(inodes, num_inodes);
 out_release_wip:
 	if (wip)
 		xfs_irele(wip);
-- 
2.25.1

