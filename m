Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD015C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 09:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbiKGJDj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 04:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbiKGJDh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 04:03:37 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD1A95A6
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 01:03:36 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A78uats012294
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=DcMUyRUZYA4vB/KdiDXo39mEVzUdDBMQmpLf2vnIp20=;
 b=07oKBpP5uRsxFdYm5iC9E4qwoHjBM91ggocvAcnS6vNNDo9bDr8GxUfy78dCHXb5FejW
 FJHbmGgFJqv6xTTGOMvTerRGGuZ+EBSpXTRhAMpg418xQT+UQ0qo2L2gBqIOioHWgePm
 SPWPvCfL4jdnK7YMfcSp3+bR/F0mB25MLC4GSBMIUW7s/CuFIEAY7G+NFj5jessvXYAy
 RcgHyD9FbzDfBfd2ie7OGtQCX3t5EOJ0zVKu0/Ia+QOwqAsAhf18sU01xknrsC8tC2xi
 QfHNXQ4tkIS5sqjuHcAn+8owZKR2SII+0sIcOyXs5fAEVtLkhbNW/ZMkFpXmf4gC31wL eQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngkfu7v0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:36 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A77JXo6025146
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:34 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcqek6ua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nBfYPlNUxz9ULQWeO0zHbHn1nrHbsNKQX2XL7Wnou4+t5io7zzRJ9DqrhiJHJRb9Le9mq+EVPWPe/OVrRLfT9uPr7t4xa732r4mwaVNvnAaLDEwsMPmucMz92es/d3YBslEWAW0h7EcyUEle4256/StnpjMdcCoq+wPLatk0sXoFbR6fDo7jkDdNIb2stotslpYx6VeQb0L5svajYmTQQ0HVO6dUcA9sy+7oHM/QGu5EFQxqykgWlUxiHF7TubMtQDG1OX/3I9zVt9vD47IetR70IP3Xe/ugvJDH0o27oESwDVPh4kRilkjtRTzXLIbEnGIzF0Mb92UYp/dSMlVk5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DcMUyRUZYA4vB/KdiDXo39mEVzUdDBMQmpLf2vnIp20=;
 b=MF6qWxnpZpfxQwdUB/WYL0I91G2Hqo6N+6S9Bfa63aAiiWJ+NhwZXNvMQd8czFqoqr+UZFG7nIE3i9h0wwzLLTrKzzf3S6CZF+peCFiU6Gwwm5kk1tKnz0xWp7JKxcfoj9KCNrhYZCsLLCeOjI+L6dEihF/+mvy7TxZVtmw6Y4KNXDjBlDrxyrQvbeIsnAKhprN7TTMVfztAe3s+aclcTzPayYasufWJU1aE6EpiW9IT8NHV68hlN0FzQ9IsyWGIrG3QhlAo94Iw/lJH8ddmzdQvW69wpPB1zn8crIu7Znn8guJ1rCK4uY0y/fsLA0F80H8zQBO/rt2wN/DOvbyhKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DcMUyRUZYA4vB/KdiDXo39mEVzUdDBMQmpLf2vnIp20=;
 b=fBPVwK0sP1PJa56TIO/Q04/5MlAoL52kQKIR3vX+YtkbhGQucJvYply6Yoi6u52+CjVJ7gBpng/84GT1NhvEc9b0HupRuiwoo04PVQyDo6aA2w1sDTzFo+IAc6wWJ9ueqLOzG3G3Uv/TNO6DSRiEAyu/YvE8Lm4/8+TNQZIFFko=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by MW4PR10MB6346.namprd10.prod.outlook.com (2603:10b6:303:1ec::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 7 Nov
 2022 09:03:25 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 09:03:25 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 20/26] xfs: Add parent pointers to xfs_cross_rename
Date:   Mon,  7 Nov 2022 02:01:50 -0700
Message-Id: <20221107090156.299319-21-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107090156.299319-1-allison.henderson@oracle.com>
References: <20221107090156.299319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::38) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|MW4PR10MB6346:EE_
X-MS-Office365-Filtering-Correlation-Id: 5577d47d-1f2b-4dea-a67e-08dac09eedae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6PTCVxI32CqmiWwl6a+nM2ATUQdnoyqMFwL1dgGBfd2NhNmeUlkkpb0Dr2ZI3s+E9vbAj/a6yaJ2xN/fuq9VryHdMxkzMn6y8ffetWhYzpF+KClL1SnhPB2IPdLH3h7EvEB8vseUK07ePvi/zIJZkcs+Wv6zCQO157u1A6ZfxKAvcNXRTFCFuR3iULBongK9Wk+D1gMPUwQ3LZI2A/QfnoI+GTubzl+g0MgqyLW4kwZGqkD1UzDpT/hL1lBBWSYqOJ/S88hxWZwa2H7MFq5UWvTluFxsQG6VmpEXTIrZWSrG6R7V29RWfb8PcuOd9GV1Trbf9Gxowb30EJzrfxa+Cf58/Bxas546aveUD7dHMCnyu/OcXV9bSmdpbHzd8x/osvCjqsbtkbBlajsMMRhaGu9q5xFcXevbblvJkreIULnLSH1joyyS/p9TZyUDY4tft3Lmf3bhZJcawwEUZduPAW+JMnKE6MPJw52G//SrGvRbJ6GwgU0fSkrMJpRDSPUNZNmzVunHjRwsZZoIKv6/wYDqGjyZlPndvCyi4sKN+rI8A3XBg4UIQzp5hdpJwlTTUbNpVqqltHHlxofemvuJEIafFfPVQsUwRiXHXrjdb/VLIBpyRgghdS3Hc5HyWZKNPdYcuGPBCnPzh+7bwY4EskTseiHjLlURnuTZkLK7O4ZEyNQ0vg9ODjc4hCMKU+HU8p5Ag+Trc9g/TyWDSVu3rA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(396003)(376002)(39860400002)(346002)(451199015)(38100700002)(6506007)(36756003)(478600001)(316002)(66946007)(66556008)(8676002)(41300700001)(6916009)(8936002)(1076003)(5660300002)(6486002)(2906002)(86362001)(66476007)(83380400001)(2616005)(6666004)(9686003)(6512007)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n2Um9L/GrHrZmIwAb3AgjEPMzMTr3pQPk6D9VopLPl4tr846IAfKH6+mBmPl?=
 =?us-ascii?Q?uhMnMXYHtPXEu+WsVyu72dEI01XJ3I+boFj/1Ds00+57FCDH70JleROyypHN?=
 =?us-ascii?Q?1W/bZ5Ip9Yi3va4YlbJ2eTbQv1qPTntNtq2IHqk+7bqQl6Ih5Yzio6bq+Ymz?=
 =?us-ascii?Q?YXExtrUKP1B2Eh5WYvesZrO7VBClsDUAERY1bsTk3ctojt5RiyiiM7c3pEPC?=
 =?us-ascii?Q?N9Lyw93dbBvIqfyLKZiokH6LjdG2a7CxH9f505yKg/Z7bsqt96e0j5yEHSzh?=
 =?us-ascii?Q?s0WCzHJTBwTgeJvH3VpAvUrojQR7o+0HVnQ29P54qTodnJTSaH01NBXWmlo9?=
 =?us-ascii?Q?I36BwWame/wZRSig13rfn8B9WXZx+nuIKQZA7OhDWztvIrcVfXVLFkk42gj7?=
 =?us-ascii?Q?wS6UWOWJrGgS5ipXW4Ziap7iebEY5LgEqndsJMrf1c6WprHR+JJSOLtlW5n4?=
 =?us-ascii?Q?p7nNJTQ+VCbGOGnFiZhzBBxa1tGfDwtr28GvK7zRLk0KcEW8nCBGeASUnRgt?=
 =?us-ascii?Q?7EIN9M9sSo67IzF0q/OBGwxvXVRzjKXC/7KtYsDERD9VdBEY+3fSWAIFycGU?=
 =?us-ascii?Q?LxFPhbcUx2C3YXQ4YncD0yvDKTXkl7AkJEi8drV/TmiPO9FO0Ee0KlvTC39+?=
 =?us-ascii?Q?k+Yxz6DfO4/Go/J/E29IvrLNAySOjYEI6PtYlE23UXcYgvRciCCqNFeiz2gi?=
 =?us-ascii?Q?1lxbEsU/9uCYhqjtdb4U3WFAlfy63V2J7U9UoqWHS9f7In91egiNgssghs1N?=
 =?us-ascii?Q?PLqg1O+xe94+8HFpKjwhOk1p52dpEdaQQV7jJrHeNZ7OqjBJrEcMnxEWg3Ez?=
 =?us-ascii?Q?aWsjaBP2yDU/sOripjQ7P8BUGX9mHsqWk960LPgomflxzRrvEJFrU4RBakGM?=
 =?us-ascii?Q?YfDZ8fWdi9pd+eaVbX32wBlYm2+APAoNkWXQ4XB3iIvnyCBtmQCxvMjmKXuZ?=
 =?us-ascii?Q?19xnhDV8srkBdhrzeUxEMXCOnFGxPFFS8U+S2+xUpZy+FoH7jU2sQ7MX/ZWc?=
 =?us-ascii?Q?YA6He4y+F1XyloZ9hf/nKFVGJof3s8YBt6D8SKGuD2RMraOebpSXDklKP73D?=
 =?us-ascii?Q?WpTFPX+WK3/XKFnMBuijTqXSlZWbU3yxZzi7onAxW/XhhZaoP7eWkc9gtiQ4?=
 =?us-ascii?Q?+4OgqfLnQJ3qb0jF0UYALyQqUH7JTq+RMOb7B/6jxYeJp4BBhLCrpoOmhu47?=
 =?us-ascii?Q?j2UVpFbL1iM3Q0fPgAFU9ZC1vUMWV+qvDssC4rbSgmk1+3+tzueTHIxf8itf?=
 =?us-ascii?Q?S1+JV7W9BYhnGR8ZlNcXACHeRFuwFlBJp2oRv11Segsj9EMORr1RQ3rbFdTX?=
 =?us-ascii?Q?1Mg0WFs+TfwcyeufBFB9SPATBXddje9EEIf8kGmE6K2+BtflBb8L749LFdg2?=
 =?us-ascii?Q?KM4iAykJpnleNJt38whQgwP5hETWfpsw9+iywPr5Kvjxxc0/iTbrnRRl/UtN?=
 =?us-ascii?Q?BKgauKhQ0Jfr028EzO8XHoXIUkE7oUiQtOJiBzbz6fb+JnstxsHnV+LnrNnl?=
 =?us-ascii?Q?gEmVdVszepBc4Q+IwIh1QOGo6LE/svDUg2OwZUT7jWdJgyaQxwZ2MpvFxowg?=
 =?us-ascii?Q?Ska/hYLwVQPblBf4rqsGDwOXzWUPU8xMMGiexSiVUlvJN+jdA4sYXvxNwsky?=
 =?us-ascii?Q?yg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5577d47d-1f2b-4dea-a67e-08dac09eedae
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 09:03:25.2295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qsQyPMLt0T8r/OXW4iX1M7b0WmWKkllg68Z7JEmNLCpin4XJmnzHyH1KJEG6bM4GszGA3zbW6dM+0uRvj/r7ws6tQ2FJQZzWJZPHMqe6VGo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6346
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070077
X-Proofpoint-ORIG-GUID: LNtmAsZvKPBGBCxcuuxdaA_bbNBOAw44
X-Proofpoint-GUID: LNtmAsZvKPBGBCxcuuxdaA_bbNBOAw44
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
index d0b7a93655bd..8cedf76f8e39 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2744,27 +2744,40 @@ xfs_finish_rename(
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
 
@@ -2825,6 +2838,18 @@ xfs_cross_rename(
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
@@ -2839,10 +2864,17 @@ xfs_cross_rename(
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

