Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EB8CC433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 09:38:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347386AbiDFJkE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 05:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1586127AbiDFJg6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 05:36:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99672AD5FF
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 23:20:43 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2361urMo014702;
        Wed, 6 Apr 2022 06:20:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=WCbP4CA+4aCC0/wxf8/JJ8v3Wy2HP8BJZOeYq90GxMw=;
 b=jQZGKXCNNdxOt5tWJ8qXG4OeMRE8FNif8VFhVjBK7h7uYWrjLkgtv0siWQfhpwBt2yoA
 6o2ixksf8LPB/cAv2aKmoN9sLTXNtlgzWSvrzQ+kzJ7BoL99L/qvvxIXHZiZubOPRVfz
 S19KgBjYK5b6ic1TMn7G9GkteSnGttQGpIdbNZdt/RprRocOdsrSkKEHLJxyBCfdKvgV
 vrPhqES5jtkEKVhQEU7BcZRFrCzfOEgbpudJDICpWQTMNFPAbiZrKh/kRLYy3W8CykbM
 nubs4hk5zb1Kp9i6hKxzNY0Ab8dNgPIFWkxxx1y1llQLVYBCC6VgHA5xkaq5Whdl5K0I Bw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6ec9qrs4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:35 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2366Aqo1037154;
        Wed, 6 Apr 2022 06:20:34 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f6cx47tbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m7L1ukQXelnIwcbMu1qHGmDajMtJjhb+3IYHo/xlg8hSuDDk37fj0bxvqCcoCtxnXw83XU6bMG/0NR9r+cJFquqmFGoNbQ2fZtZghePZDe2MW7wkAmSMJdLtrtRcjgwLiR9xUKbCE9e/hxdO8A99KygW06wmDBZIcG9nYUqelCVRqGZbIES6oCuIwvZc5tZF5YvyKC0yDjV3EwW7dvsI3s0UdON/3p2aYlxR8Z4C40EmLG0O6xhhKerLN3L5eYmyr16DhA/k/8xVlO4iUF1hkHrkbLrLJPwbpEDb0AOWrFHUCZEuHrITiA7Ntolcghm4WDHjFx62LaWZ/8PFJpCZ5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WCbP4CA+4aCC0/wxf8/JJ8v3Wy2HP8BJZOeYq90GxMw=;
 b=QmTVnRFdF7lvjzt4q7F9IzAfshV9TIaQNZUMVO1N+tlmJLJRPeJYtedCXu4RxTd9KJY/pxC2nGmrcrOcwnq0zrBdHAOhZ2mUwe/q7eAT/LWYeZIya/GMHhLBYuZGJKx6MD0kXHTNB8tMKCVGM5EHRhxVNPFx87kuY8Bj+krlTqpE5ErGcSsumgLolJQkJwU8rYIZOwWe3BQNOBQg1ErDGksYjPhMuteyYTn26uRG3bW6IaaJXRExpBPVV8KENYNsbF9Nwe5SUvz7himZgU4UHZJhqiboxerfsPdzW6xHu+JR/2DgqYCKayKnY+jgZ2yom04P9H4F08JzRr69INQD9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WCbP4CA+4aCC0/wxf8/JJ8v3Wy2HP8BJZOeYq90GxMw=;
 b=skufif+gpk1L406ZNQtTXFhMH08CuF5KDwGd7BLKgxtum+ceEQw57sI/GOdFVBy3xvIkbiFmQzb4fTFYe7ZKbpN/5jDCYBOAmUZXW0pQnB9Eyal+NzRZ6KMKKwJEtYzM0IuBjy7BefYJ/F/8tFG/iXXb5X/OeK0N3I/gGTCaHqA=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5564.namprd10.prod.outlook.com (2603:10b6:510:f3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 06:20:32 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d%8]) with mapi id 15.20.5144.021; Wed, 6 Apr 2022
 06:20:32 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH V9 13/19] xfs: Replace numbered inode recovery error messages with descriptive ones
Date:   Wed,  6 Apr 2022 11:48:57 +0530
Message-Id: <20220406061904.595597-14-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406061904.595597-1-chandan.babu@oracle.com>
References: <20220406061904.595597-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0047.jpnprd01.prod.outlook.com
 (2603:1096:405:1::35) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb31db27-b637-4a54-4513-08da17958dc5
X-MS-TrafficTypeDiagnostic: PH0PR10MB5564:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5564E28D62F9C65E3425B5C1F6E79@PH0PR10MB5564.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bTnxVX17ODOWYhk8A0u+kgzD8YBsccjIIAp7sb59bVy1uPtVpmFPf9YglkbO3x+vugi7W1EAeK+pQE9HLCEL+JuMDN4zH+2jVdZns2E+eUPeYSvkzrer608266ngqpcIx9RziCvqu6Eh98vztKFPYDDIVjFNJuxlRDXEZWUlhseq28hhjSsryjwn55E0mWHfUuM9+JB0UP0nfr+YOeXL2XZHeQ7OtuglzyTrXRs417UkmUCGgNAAx/PrwQ7xJbhttjQpTZZzmMyu2wNCQnsIIrKJiRVrKikMbpBXBug8o0Ug9iJhTAKa3RIy9vumMyDkFN/xxVIgR3mN4zYaWUl6J6xC5PhRkVnBlOJ4/DTHH+YiOlz1GLa1DOX7GWMNBGNC5WVW73zIJO0yp9IiN/MXK7KYbtfwwAsghVCqNy9ooU3cmcTl1SYkTmgVxCLIfNqvutw72RW0G1Cf15EcGw4yYV87jZ9SHnlJvAF10sEEQFaznoPDhc4p5V84otUe7xXErKqqUHNpelox5MIp2kL4yco9uAiTZ03JWa3xp2oEinxKsxl/3kPD+l/fPsfdW2cJ7310oyibhMtkqEV0ma3bmZVt4B/4qgdQfC0FPt85+OzKIFiolbVjDeFPzYg03VIl5IdxAXqUs17NzTzfcLurY0pwkqqAEzDymBXDvELXNzKPORl4ggxWOMxMV+keDb6h
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66476007)(66946007)(6506007)(66556008)(52116002)(6512007)(6486002)(54906003)(6916009)(4326008)(8676002)(6666004)(316002)(5660300002)(1076003)(8936002)(2616005)(83380400001)(86362001)(38350700002)(38100700002)(2906002)(26005)(186003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?krOCJKcsgpR1TFw6tXZBzgg3zsJiepHmZSc/BwpUpbbJ/cSYBwndARLLcPyp?=
 =?us-ascii?Q?zVN+5e+Y4keLOIReaw7zJyF6ZbZSGG377p0J1Ljjd7YHtNUoOg8AMKIQIjQV?=
 =?us-ascii?Q?CNy1op1bEVDYSzsk+bq6WJsuNGg9hAGmAqyPF6WZEYU+4e9djJ0ViuKUQTkJ?=
 =?us-ascii?Q?DdtlMnM/NSSoKAavtirSXLfjuEgD9mVH8SuRogwSFA9cpVLEBR3tF7vlIN+4?=
 =?us-ascii?Q?dbEQsbo3hWCnxttJ2wUSN4Rgpc7vI3onXVH6/duafkuyICH7UCxuW4g5K6Ai?=
 =?us-ascii?Q?XirTjwX5eiv3qnLUReCzlnRuVRtf2Mh4N5OQfeNMEJAPEnh0jH0UwMdPzZto?=
 =?us-ascii?Q?LB0Ln3fuiu+dBjWOYreaPAH5htxo8YVU/hTh8d8uRU3ueWtfyhWdilD2PzTu?=
 =?us-ascii?Q?Xa+qAwDgcqQEfvQ8cXncGEm8latFlgd7bxbPRUAd/bdfSBC4vv8XS5wAYGDY?=
 =?us-ascii?Q?Ff2aC4Ry/5kf+glpMJzgj4kattakwSVr9J3tMa+5sNHyMCfFNouJaFjuiL+4?=
 =?us-ascii?Q?PI/RI4mxfDrV66Y4Gt72L1hR5fInbdCAE77Xxsk7hv1qPwp+tYtfNaIOovS5?=
 =?us-ascii?Q?bkOaoSQ3/iiGIffeQs9IB+Dhg1wamo79kqXxop7Wv6cIoKP/KedH70Vlp9Mw?=
 =?us-ascii?Q?t4cTXq1K+NspUIZMMb+tPQMeB9Qt6YnmtaV0AMC6mLk9MDhk0/Pf87Itf1VG?=
 =?us-ascii?Q?YnPBUqE/O6+iok2K7ux8qq0OdGk93G3H6yGacFgMZtYHLeL8/WJKq8WiWu+2?=
 =?us-ascii?Q?jSJuavv5AKTz4ty0jqiDVToIxcme+R0l1AHH1ZtbCcACWbWcgJT5F4ud22RW?=
 =?us-ascii?Q?9up3RUL9pfSknLgPVbXsz2jWsqrqNuvrL80jp4xPmgvyUVQi6J0BnohG/5QU?=
 =?us-ascii?Q?ohTKZNj++0Oc2pXp8r/NyawIL1YhiY5yWkw9GG24+RfFH3pEBW/+sDlLvNKg?=
 =?us-ascii?Q?CZgqDpyo2W/x4Rmkqa4rzARgjDrbQBABa0iM07aYMFHC1ylmahv2q3ca6oam?=
 =?us-ascii?Q?EyTporkO1yCl+S4TYm1TLu2DErVipkLHztcYWzxQO8kaxGAsJ1zdEJvTJuNg?=
 =?us-ascii?Q?3M3YjanrqXSArlxsK2QMhTaIFjzboQK3DO5Bv6DnM2xnEblvoUh2kFbzPDkZ?=
 =?us-ascii?Q?dFlOjyAaf8NLvfL2vsubUs+MVQ/ffbY2yjcXK7gLQRuLyvSEyPBrlF6nAN5s?=
 =?us-ascii?Q?JNFGiQLgZHV9b0yQld32WQWXXalecgmWmVTnJQ2a7wPvXCIjPkwWLUo4csf/?=
 =?us-ascii?Q?bAIS8BOBUWxHKL/BjMrVNj5vJuObgDmV0nGqSk58aHp1msX9xKHQnAVDz4Re?=
 =?us-ascii?Q?NTbmwXo0ZbtGdEjGdPOoGuLwbPje4WNtp6oKX3BXE5ts+H9lXDUeX0gwTy3O?=
 =?us-ascii?Q?EINnMzRflEwdeLV0CW5BHvNnBJ1nsxXLqVVSriLUTgLXZdLj5FdSq3MIjj0X?=
 =?us-ascii?Q?lHP2f13QeADHU+7V7L2f+ApCDCkuDHDRdSXL3+9C9f3k4GlJc9QC8ndQvZ6A?=
 =?us-ascii?Q?vCiYEodpzbJQ2DrSghKhPkNMvhdLhC65ikucRq/8nvbEMwEKzT2V15+K5DeR?=
 =?us-ascii?Q?HB4Xl+wjTASIxKP0MVUrSgDXJHyRHUkUdnGpfLxF5YdmjJsclh7CDQ9oZpYl?=
 =?us-ascii?Q?6liPO1HkKIS0a9rILTdAAHsHcmOtjVKRDK7FDb/YVl1os+aS8hPL9qoh+zOg?=
 =?us-ascii?Q?tUBJEV9blhXfR6V9EyH3VfLD347SB3HWYhWIvrma+U9/6rmpUEoJB3JN1yt/?=
 =?us-ascii?Q?LjmuTOOZwJzv2c09mp6OdqDizGDZkhc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb31db27-b637-4a54-4513-08da17958dc5
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 06:20:32.4302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JiG2xKTRts6vpowL6pJNomFEbeIwpnog8ym+P1sSgx4Gm2yPRpZo6dmPQ2BoKSwD2xjPw2hKQYJIcInNBSfi+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_02:2022-04-04,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204060027
X-Proofpoint-GUID: NZYEHVF9LnZY_-tYOfiT5RDPpIuA7_E5
X-Proofpoint-ORIG-GUID: NZYEHVF9LnZY_-tYOfiT5RDPpIuA7_E5
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit also prints inode fields with invalid values instead of printing
addresses of inode and buffer instances.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Suggested-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode_item_recover.c | 52 ++++++++++++++-------------------
 1 file changed, 22 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 44b90614859e..96b222e18b0f 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -324,13 +324,12 @@ xlog_recover_inode_commit_pass2(
 	if (unlikely(S_ISREG(ldip->di_mode))) {
 		if ((ldip->di_format != XFS_DINODE_FMT_EXTENTS) &&
 		    (ldip->di_format != XFS_DINODE_FMT_BTREE)) {
-			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(3)",
-					 XFS_ERRLEVEL_LOW, mp, ldip,
-					 sizeof(*ldip));
+			XFS_CORRUPTION_ERROR(
+				"Bad log dinode data fork format for regular file",
+				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
 			xfs_alert(mp,
-		"%s: Bad regular inode log record, rec ptr "PTR_FMT", "
-		"ino ptr = "PTR_FMT", ino bp = "PTR_FMT", ino %Ld",
-				__func__, item, dip, bp, in_f->ilf_ino);
+				"Bad inode 0x%llx, data fork format 0x%x",
+				in_f->ilf_ino, ldip->di_format);
 			error = -EFSCORRUPTED;
 			goto out_release;
 		}
@@ -338,49 +337,42 @@ xlog_recover_inode_commit_pass2(
 		if ((ldip->di_format != XFS_DINODE_FMT_EXTENTS) &&
 		    (ldip->di_format != XFS_DINODE_FMT_BTREE) &&
 		    (ldip->di_format != XFS_DINODE_FMT_LOCAL)) {
-			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(4)",
-					     XFS_ERRLEVEL_LOW, mp, ldip,
-					     sizeof(*ldip));
+			XFS_CORRUPTION_ERROR(
+				"Bad log dinode data fork format for directory",
+				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
 			xfs_alert(mp,
-		"%s: Bad dir inode log record, rec ptr "PTR_FMT", "
-		"ino ptr = "PTR_FMT", ino bp = "PTR_FMT", ino %Ld",
-				__func__, item, dip, bp, in_f->ilf_ino);
+				"Bad inode 0x%llx, data fork format 0x%x",
+				in_f->ilf_ino, ldip->di_format);
 			error = -EFSCORRUPTED;
 			goto out_release;
 		}
 	}
 	if (unlikely(ldip->di_nextents + ldip->di_anextents > ldip->di_nblocks)){
-		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
-				     XFS_ERRLEVEL_LOW, mp, ldip,
-				     sizeof(*ldip));
+		XFS_CORRUPTION_ERROR("Bad log dinode extent counts",
+				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
 		xfs_alert(mp,
-	"%s: Bad inode log record, rec ptr "PTR_FMT", dino ptr "PTR_FMT", "
-	"dino bp "PTR_FMT", ino %Ld, total extents = %d, nblocks = %Ld",
-			__func__, item, dip, bp, in_f->ilf_ino,
-			ldip->di_nextents + ldip->di_anextents,
+			"Bad inode 0x%llx, nextents 0x%x, anextents 0x%x, nblocks 0x%llx",
+			in_f->ilf_ino, ldip->di_nextents, ldip->di_anextents,
 			ldip->di_nblocks);
 		error = -EFSCORRUPTED;
 		goto out_release;
 	}
 	if (unlikely(ldip->di_forkoff > mp->m_sb.sb_inodesize)) {
-		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(6)",
-				     XFS_ERRLEVEL_LOW, mp, ldip,
-				     sizeof(*ldip));
+		XFS_CORRUPTION_ERROR("Bad log dinode fork offset",
+				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
 		xfs_alert(mp,
-	"%s: Bad inode log record, rec ptr "PTR_FMT", dino ptr "PTR_FMT", "
-	"dino bp "PTR_FMT", ino %Ld, forkoff 0x%x", __func__,
-			item, dip, bp, in_f->ilf_ino, ldip->di_forkoff);
+			"Bad inode 0x%llx, di_forkoff 0x%x",
+			in_f->ilf_ino, ldip->di_forkoff);
 		error = -EFSCORRUPTED;
 		goto out_release;
 	}
 	isize = xfs_log_dinode_size(mp);
 	if (unlikely(item->ri_buf[1].i_len > isize)) {
-		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(7)",
-				     XFS_ERRLEVEL_LOW, mp, ldip,
-				     sizeof(*ldip));
+		XFS_CORRUPTION_ERROR("Bad log dinode size", XFS_ERRLEVEL_LOW,
+				     mp, ldip, sizeof(*ldip));
 		xfs_alert(mp,
-			"%s: Bad inode log record length %d, rec ptr "PTR_FMT,
-			__func__, item->ri_buf[1].i_len, item);
+			"Bad inode 0x%llx log dinode size 0x%x",
+			in_f->ilf_ino, item->ri_buf[1].i_len);
 		error = -EFSCORRUPTED;
 		goto out_release;
 	}
-- 
2.30.2

