Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 026FFC10F1E
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Dec 2022 10:03:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiLRKDs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Dec 2022 05:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiLRKDq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 05:03:46 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3930655B2
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 02:03:44 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BI5xtWv012952
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=4VBrNxMZQEeLepM/geuKUuUyquKAEv/4X48t+t0DtxM=;
 b=vSgncTyP0iPjM/AZIUgwS6+vXJge0baIiH0IePM5j3QsCquAiwNjsIzgFtEsrs4eVl1b
 /zuF9NU5lLpk8ENi072DOZ0SK/vQqv+aZ6mywp5bn3gpWDRprLtqSDM+c80r3npal0Zd
 7BXABO4fgzFCOHn56zbPZafg/7my1PExWHnUbiBs9Zz+SzJKhCWC+rGBVcJjxBOwg5pW
 7jkRz5ONTS7OR2keV2vYZJ+rnXJG+pSJ2lisXOaEM+4rAtRHN5cz5si1PPpNxz59xgUt
 WDsdD4ZYti73rg6m4hrEkN92b72obSkhWzJ/pigLZQRRGcBuFuyWXAiszGb4vn9uWbZR Og== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tms9ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:43 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BI909Wr012804
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:42 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mh472cfxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EDZIBCS68JbVqlVu4J6Uuty/lpoi4qPbXhQNh316tA7/h9Gu1gRI62RHfXj/Edw6Ub41Zdl3/hrs16GEVlU0qwnxE/eumNVtnl4LCBVXJDZc+FOL0485Z5ZF+SqsKw4Ti7G8gl9hSlfKKF/iZfPWjqHFvtizPRSEYyfCkJX76thCyF2L5hRdrplvDm6umF41tb373GMBzYqBW13XWKa3KmOeveIERW7JuzwOndeank3I9g+OZcdf38fmI3fWZpsLdTjqRp6GavKAZXpiWIKUWlnMMkZ4VLgFgoK6cX8odHw8BXwuaxspCPbYqw5BE7aOfPIHOnZCEC0fuxHmPFqscw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4VBrNxMZQEeLepM/geuKUuUyquKAEv/4X48t+t0DtxM=;
 b=VJkIsCZoAQB+J4ueY87d0E+CsBPFTQ422gv5q5vNIfXYwFuy8Nue80uLc5Y4FtcslWDqHyCLMLKkrsq8u9Hw3ZO5t5QapSPHxCIkBwxESrdwOvofOn9y4iMviyHFr1yr1gXO5KXC8pIyAQVGbbVjXO8KBONF2OIsbZ6F0IyaGQHdC0LVYFXg4B3vmbCgG6GU2Zx6s+auF0Y58RxPgjQOznNXLIlm3TB57wBkkO35G0tT8jl7hYcEel5q5ENdJ3h6gnDErSQyAOz6qXHitvoe5S304YHSd/pgX4CnrlbbtRbIxZvm7eGyGdkQhHQVVswbvmax38oG5KUNEPVjBSqU3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4VBrNxMZQEeLepM/geuKUuUyquKAEv/4X48t+t0DtxM=;
 b=P0wS+W4MqS8t3GHVvI8uh/qwl8k+UPMtY4MRkprU5VIYVoBqAtgqxGfYi4ecZ1Sh4hDZiRpoVIZG9RiODiuInM9x8bSznkRRhSpVQ9Yuh/BUl/mjiNFLKvSG7OUe+Urf7bHAj6axYRv+0FHCMF/N8oV7LNUhat5GrKHwRTbAPuY=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by IA0PR10MB7181.namprd10.prod.outlook.com (2603:10b6:208:400::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 18 Dec
 2022 10:03:39 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 10:03:39 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 21/27] xfs: Add parent pointers to xfs_cross_rename
Date:   Sun, 18 Dec 2022 03:03:00 -0700
Message-Id: <20221218100306.76408-22-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218100306.76408-1-allison.henderson@oracle.com>
References: <20221218100306.76408-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0169.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::24) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|IA0PR10MB7181:EE_
X-MS-Office365-Filtering-Correlation-Id: b82ab37e-cfd6-4ed2-f3b9-08dae0df231c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Q0W4tLaB+q9hAUnBQvDMT86QYtx7Xbf2sg/z5u16BVk0/fLeETXsWnTrW+o8R/S+sVgs9sjk5cbx1+2NQENNWdgkMSLofXufP0Zx/wJznQH5e4MDz9rIDuNujFp6zq6SD2ZstUstLQxs8VE1ttWV/0OslDthF3yBhYU95nIlzx3qqSLX6XyZLgjIxkv6xlXEVb3kgNU26PFElHFtMh6HX+l9F4gIi4ayLPdGL/VFf2BKkYmI1+vd6c5cYP7aTH8bFIE8kEOZwKDncXnE9v5Gclx6J7ZSjHNY/TB8F9CMThoGHmIq4XbY4hv7UyPB1cYlxMsrvV3w3q6lLMZcpS8OGksUJxVvYYmicH+tQoQOOAqb4DB3dYDJLKp8KviGJ1qxWHzW+m5gAKsnTQHyOCQUpEo+rYkV9+8vt+a/NsXQCXP8U2KmyJoT/uiCyw1xly4gfwbFOujBgeMd65APIQneMKhvbYs0iunRof34Q2XBUtMmc0bafMMaCmpu7/Lwi/qsy6Mb2wEahZQ912ZcIobob1hTFA8wAnESRdpV57xiPQ0F9AtpZ5ix73WC/Sb8ODNEVz9p2B5mxgfisUynBGBEvSh9qyPJNK/T4+qrSwVui7GMHM8hSclmNQ0cK4HTZyW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(366004)(376002)(396003)(346002)(451199015)(83380400001)(2906002)(41300700001)(8936002)(5660300002)(86362001)(38100700002)(36756003)(316002)(6506007)(6916009)(478600001)(6486002)(186003)(26005)(6512007)(66946007)(9686003)(2616005)(66476007)(8676002)(6666004)(66556008)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?owRfTHuw+vwmWgRgz06M71HRhplfkIMJXe0Zu0JVicnEJEYgln8K6fEJ4LkD?=
 =?us-ascii?Q?OzNl8Xv+xNhZDvJhS4VwmI8sM72hMHOxY0bU8ErPgUEfXFfDk13tUNQGxLPS?=
 =?us-ascii?Q?RJoZO2ygP/mgwCgJ5hPgRcxp1i8kfBeA6TP0pHdxkzBwSDv6/FeUo7tckn/E?=
 =?us-ascii?Q?WF6FotAd1YX3onn58PEjhnfR/R+6e4Bkaxkk2FCIhkz0G2ETkUSc5rz1SfmD?=
 =?us-ascii?Q?yeRnEEnHjgjURssTIuYXz0CvtkislyO3blCkaz9hssKhoWHyq7qrK/GKYxNn?=
 =?us-ascii?Q?sMyb7n32Rc2INVaqxvaW0xPFp8N+IDV2AiyVXTYIgTz1XOOrPA2nsm0Huzxd?=
 =?us-ascii?Q?0Fqyn0c4hBepPpOEh4+wibQ0FIfBWffPso5u7PU3XNFjNAjLRF+b5Bg2rNMp?=
 =?us-ascii?Q?vyCQPTpd/6ZMiX0Hv6IrDGRd07L0snNYEijxJ1gnv9tRAtyaaoQyhZ/of2DU?=
 =?us-ascii?Q?w2LJy3hdWCmN4Osl/G0M0MXCWWlMhiXnuU6Xb1+R4sFjqtolUfygfOqVw21m?=
 =?us-ascii?Q?WsE2kXtRudRZsIsknapt6xuDCjJ+YJrL4Vs/1tk8ADGO00vksB5zX5lOKH4/?=
 =?us-ascii?Q?BfIVzqYdLqfSj9gwoOGK3wBxEN6FrBw4w9W097K4EM299WOL92lLHcuMWzOZ?=
 =?us-ascii?Q?hJwJMmcHty/XrPWmIzvA3Y0oxTbMOPFiiNkIxIFJ4zRHAiJchCnKhtvFNZRa?=
 =?us-ascii?Q?xW+xb04j2tQ/NIeb2DBeFm/QcTrOZ8l4Ux8e7Qb+K5KVIHIvQnZQ1wDT0DxH?=
 =?us-ascii?Q?8ilT4raeyk7ox5f7BmACqrrYGthO9Mh/lYz8JaklzfbffxUo2EMYStWfN8za?=
 =?us-ascii?Q?9BjhDuAhMT356PTzGpY1eNYv8FTPmKFZFAc26knVt8Ug7qGrR1sWAhR/tVJs?=
 =?us-ascii?Q?OGFbULWDmbJ6z6DmuQM3gSWj0J6AZ5LPfUhiEaBHy4qBeILT21Z3EhZtPfMj?=
 =?us-ascii?Q?L/eqCStZKRBIh9zofXm34n74bSe43SiSXqCHhdqilvRrf5s2knYKArlCgXEI?=
 =?us-ascii?Q?ipjceeMEhyRXA20d3hohwqKl8gfuWrqZidPcWcirkj8zi3ZVpllro4tVt9wM?=
 =?us-ascii?Q?dRsgcGvjtMf0HxzjNLJmWvwobDv2zAyKcBPp/UJ8pKWq5dWZbgjJsfAWBPki?=
 =?us-ascii?Q?s4soN4BkUnrtJJSI68D6BIYYxADQ0ou+lLNxAcq8Yq0jIe1O1JPYapi9mXE+?=
 =?us-ascii?Q?dycZvAwEZcGOCDz8xbdtklRqdyk3sEJTqxeBAbyHGgfpRvAWeyrdslsW2qaY?=
 =?us-ascii?Q?NnQO/3sn0LzrEo6VFg5PHkZY/R5Z4kqcCeERIIzVbp+0177zeCgAI211OQ+S?=
 =?us-ascii?Q?/fbBAvj+0m2JpNeiJjbrBLPCXVRf2NWgW2uzh3fw+t1TJlfZFa1KGJYSM+qu?=
 =?us-ascii?Q?Q/6SQN2d7CxuF/Kh2Tsx4Avi6MbGYcOMJ6UDGlsx417luoAbeVQKHadz7Qq8?=
 =?us-ascii?Q?dkFXOp4aqGUjHgoI85dnfOXFFAehlOOhh/b7JLupirQZbeLqogtSHt3zjcVK?=
 =?us-ascii?Q?yME8nI6mKX0O58I0VAAQ96SOo4DHZYGr5r4cjfDxt0u1HAtWghlpgXz9eSiu?=
 =?us-ascii?Q?RjDbyV1cS3rGn/H3+cvy8Kc010eNUHY4sBdUR/5hl3ujVSigteKaXqYtBVax?=
 =?us-ascii?Q?fQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b82ab37e-cfd6-4ed2-f3b9-08dae0df231c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 10:03:39.8556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: apbMibz5hDLs5WYvPvnJx0FFLVghcj8ALAozA2IvqHjvmUXwhijlP4/hhIv2A5EYTsgCQvaRPfObvBe1rbu3/+iR4bzh33/3Kari9m2q9Bk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7181
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-18_02,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212180095
X-Proofpoint-ORIG-GUID: TqK8o0bfSpZu0iv1d8ryeyXQDiFyVpPo
X-Proofpoint-GUID: TqK8o0bfSpZu0iv1d8ryeyXQDiFyVpPo
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Cross renames are handled separately from standard renames, and
need different handling to update the parent attributes correctly.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_inode.c | 64 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 48 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 713ced7fa87a..cc0a994599d0 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2745,27 +2745,40 @@ xfs_finish_rename(
  */
 STATIC int
 xfs_cross_rename(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*dp1,
-	struct xfs_name		*name1,
-	struct xfs_inode	*ip1,
-	struct xfs_inode	*dp2,
-	struct xfs_name		*name2,
-	struct xfs_inode	*ip2,
-	int			spaceres)
-{
-	int		error = 0;
-	int		ip1_flags = 0;
-	int		ip2_flags = 0;
-	int		dp2_flags = 0;
+	struct xfs_trans		*tp,
+	struct xfs_inode		*dp1,
+	struct xfs_name			*name1,
+	struct xfs_inode		*ip1,
+	struct xfs_inode		*dp2,
+	struct xfs_name			*name2,
+	struct xfs_inode		*ip2,
+	int				spaceres)
+{
+	struct xfs_mount		*mp = dp1->i_mount;
+	int				error = 0;
+	int				ip1_flags = 0;
+	int				ip2_flags = 0;
+	int				dp2_flags = 0;
+	int				new_diroffset, old_diroffset;
+	struct xfs_parent_defer		*parent_ptr = NULL;
+	struct xfs_parent_defer		*parent_ptr2 = NULL;
+
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, &parent_ptr);
+		if (error)
+			goto out_trans_abort;
+		error = xfs_parent_init(mp, &parent_ptr2);
+		if (error)
+			goto out_trans_abort;
+	}
 
 	/* Swap inode number for dirent in first parent */
-	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres, NULL);
+	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres, &old_diroffset);
 	if (error)
 		goto out_trans_abort;
 
 	/* Swap inode number for dirent in second parent */
-	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres, NULL);
+	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres, &new_diroffset);
 	if (error)
 		goto out_trans_abort;
 
@@ -2826,6 +2839,18 @@ xfs_cross_rename(
 		}
 	}
 
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_defer_replace(tp, parent_ptr, dp1,
+				old_diroffset, name2, dp2, new_diroffset, ip1);
+		if (error)
+			goto out_trans_abort;
+
+		error = xfs_parent_defer_replace(tp, parent_ptr2, dp2,
+				new_diroffset, name1, dp1, old_diroffset, ip2);
+		if (error)
+			goto out_trans_abort;
+	}
+
 	if (ip1_flags) {
 		xfs_trans_ichgtime(tp, ip1, ip1_flags);
 		xfs_trans_log_inode(tp, ip1, XFS_ILOG_CORE);
@@ -2840,10 +2865,17 @@ xfs_cross_rename(
 	}
 	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);
-	return xfs_finish_rename(tp);
 
+	error = xfs_finish_rename(tp);
+	goto out;
 out_trans_abort:
 	xfs_trans_cancel(tp);
+out:
+	if (parent_ptr)
+		xfs_parent_cancel(mp, parent_ptr);
+	if (parent_ptr2)
+		xfs_parent_cancel(mp, parent_ptr2);
+
 	return error;
 }
 
-- 
2.25.1

