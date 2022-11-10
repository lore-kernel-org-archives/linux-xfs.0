Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3699C4321E
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 21:05:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbiKJVF4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:05:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbiKJVFw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 16:05:52 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31DCA4AF1F
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 13:05:52 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAL32JR013905
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=xD5mP5dpC4+a1UPW7ituntmI7zdOU43lIZC3jbJvpNA=;
 b=vC9T5vOWBzz3apxbiWRskcfGFbFE2fgNVh8HeWOG2/fiz/dwq8T9O+xjnNw5H90qESCj
 6QsjVHBKehtt7aNeboGEWFP10G9tTuXMaPF32XjiuW1x/GhKTlnM8iea5oxSyOmddxlx
 ZUU8iUZc64M//OLbJ5MsuAyF2otVixAGxDIKbkyjIaX1+zyhrlnc2BUvlM9EnlCu6OJ8
 Jw8vV7ZtfED/Ny2zxgdWn9FTjk6bFlPesL2TOxdtLXOZloJij7YOWz/WCW4Eysa7UToP
 vSj2N6SUwEQct7rvJpE+oi2NlgU6jmc968SHebEYVb5CYKqdl7yISM7e64CRtlongxtf 4w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks8vbg085-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:50 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAKeTiZ038169
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:48 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcsh4fjb-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=akSDgHw9ECEi1+0b0Di9FxpTTHE1w1lFcN+oVYNp9tF/Kb9DWF7h8HKvEjEiK0JrjNWlve2eWP2z1jKBqAKA9Ua5lfzGUJDRHfgqBvirtE5DjeWiToH5FIDNIGwAMg4NaJCnTPIimqwEoy6cYTUaPJupeLHYbh/opvRpGZoTXBUtDEhLlHkH6+wF62I0v8NTIlCeTue37YbND8z1chQXN5XRyI9sPxDUUyd9AoPEBa4f+15VBE1mBttrVA9Y8ngSymRGgIiT46l6Ptygaz/Yqd6P6uGfpaPL/fQxo3kHC5mxG91tuFaC9wh/GuPDcwcKavnZXvPcEFvqV5CnNBRL9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xD5mP5dpC4+a1UPW7ituntmI7zdOU43lIZC3jbJvpNA=;
 b=nk/RBDvFK4PiGbmmsUevUXvfSmVHL1nW8OPmLJvftriUcD/63VN4mtsQTrftQNz4VnvOMx1TEVIL4AWxF0RB/8MTgWG8kKzcpZTlOy51LB4e5Cx8j3T+6SX+Y5qiO3JjUnY40QY9EzOLSSVbLS8NIkIw81wRKYJr7BvX9TBIkLntpefCTZXiKfTRh2eVK39y/sQyJ302aQLjYnOe2MTmtjbgGRfcX2NZHbIa6a91WxDUB/tY6ea9hx8nzOIoMybssu1mJ6nBHnbzeeZQmxlsFGhrEVvbumnJej0NYGGzbRs5B6K16GFWP30yrg1NlQUgelEN2jvZN3ZNYjvSW0wTdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xD5mP5dpC4+a1UPW7ituntmI7zdOU43lIZC3jbJvpNA=;
 b=OZPFCxy2FN2fnPnoid2b3rbSzSrTJRLEMHwLY4u6yGedo4vrBFAjJrufzQfQquEZ+mAaCcZwY9l8MftP7d5c26yaBoV+RhkAo5dAoyd3qX38rf/8Hg6wEYMy/viunTmHYSiUARHvIt5aymVGIUM9Yixlv5iHj0pvKACFkgG2bHk=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO6PR10MB5553.namprd10.prod.outlook.com (2603:10b6:303:140::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 21:05:46 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 21:05:46 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 12/25] xfsprogs: add parent attributes to link
Date:   Thu, 10 Nov 2022 14:05:14 -0700
Message-Id: <20221110210527.56628-13-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110210527.56628-1-allison.henderson@oracle.com>
References: <20221110210527.56628-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0102.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::17) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|CO6PR10MB5553:EE_
X-MS-Office365-Filtering-Correlation-Id: 41c21e10-a742-4ce5-0bf7-08dac35f5652
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MxJ/ZnKIFzqpITQNjXM7Oxdkt+HXzBfnmXCQJkwd9MSL3KytabuzdMDg9qPvybCSQbcGc71EZfGfNyGuebMCaDp2ay4QX2vWO22X/lAYReS6XPrHiuL4XVXpZN9e6VeS8uwZ/beHCYG9FSzSps87xGzgkWvjtUjOla9Y9zdwbpa+JooP+07FHg7aFYieG7lnHYqOREIDItnenrBhEQhm4d9JwYY7dSrE2f/e0jWwLYQxY2PMq3UknZ5AAuF6YxVOgWpjjCO0kTwR8ZzX1hD7dsdS5oD524u4dieOnZUKx8SR+pHba6t45Ap5WlPo4PemZh56Tp448rHtT4jy6FW6uwQhHEjNBCDPXUAGAfVM9TxlmgPZ/DegdpLH+bcBKQlrIIGBfSlBNIyUfybtetdVTYedgg514nN2WGD9poQNu6vJoK/7Eo1YkNvuhtKcl79KdFbmLKEXfV6PXCRb8R8d3MLUKkeIaque7H4MVmrYs+rtOsr5MQLfDAZ/f61Vvl8XlyhaKKqXblR3Uck4FMBwQzrA6D8pvs0ZMYFIfeOWtxLCUHEQlzbO/Q/Yaptwii9saqAgqo09ka7ESn2XYGfV/TkoYKJjtt8apCbYVzb89HNRhYRxkWk6SngOshcz+yeDgRjRV1hdZ6z0ZDVHpjsQPJnht+SnoVvlE7U5JAHE6lH2zTbH6rOr+FdBJxNtBh/SsTdZPWNYB93O57FiTDFrcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(366004)(39860400002)(346002)(376002)(451199015)(8676002)(6506007)(66556008)(66476007)(316002)(66946007)(4744005)(2616005)(186003)(1076003)(6916009)(5660300002)(2906002)(478600001)(86362001)(36756003)(6486002)(41300700001)(26005)(6512007)(9686003)(8936002)(83380400001)(38100700002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UqE9tm0pP350JDE51udI4ExlHcM2I26Xn6nbX57VM4ES0jWv63MRsUY5/MnE?=
 =?us-ascii?Q?R+VaQsNLJREK+AdqO5ovRg8CRtyXuzVffULVLQF+1Y/bjsvktMRXqS8uSOqu?=
 =?us-ascii?Q?Q8TzFh5E8ZzZvXIlde54nqFQK7pheJjb+Eakso9ABlGx4d70oRkSg3ZmvhM+?=
 =?us-ascii?Q?N+3HhWZBkM5jRHhuBFUtJT1PLg14LnKBy1s27FJZNdo7yeMYAFrKTMC2otrl?=
 =?us-ascii?Q?y7RuFm6RKPQTbwaQswin+cEwZKa0QlrikP1HuRQ1N26Aw166OSuniDn0+oLZ?=
 =?us-ascii?Q?9B2irURp51Fi4NNoLZAtrV2ixk40nCrKwDrJZubiHVCzv9B49N3V7JlNHX2b?=
 =?us-ascii?Q?mwBtZ5QhZARX1k+mZqJNLOvynXe4+VTK3B40k0FcWMDsTNQGHFp8zkpoMJ0N?=
 =?us-ascii?Q?6AB5RwKmQQjp1RW//yG18htEYmJjNHUlBRiQIta7h684g21R+oYP9mRLEn5o?=
 =?us-ascii?Q?SqJbBHvheD6kfeV3Xc5XtwZRMWCAcjRDWduoVVWGGoawFA8bmYH2ZPVO7yBm?=
 =?us-ascii?Q?/n1lWmsf/T5HMPz27uNSoMV/fO8B5U6YXa1XsymEfWMAJlZ/lFq6cg3JJ2E1?=
 =?us-ascii?Q?TAgGLoFBE5mIAlSUZUjnPUJUqf0pobXx8s+rzId44pVw+wMn9xbwOpeilb4c?=
 =?us-ascii?Q?hap9GMdYNrf0Avg19skZl8ghDZ5EDswOWHDYv+j8w5cFvD48n4edl66tH9BU?=
 =?us-ascii?Q?WR0j8tALN7MDEGviN2GoQKdFpZmnHoKv/MxEmMQ2TFAc7m4yqrvDCyUj08vv?=
 =?us-ascii?Q?8tRkDMaoi3DKhi1Bz7x2S97ZR3FZiyNvk9856CpCdoK1boe/B1GB0OST/5+F?=
 =?us-ascii?Q?bUouSB3Etma7Rl2yZfdi87JE3xYN6u3FfWyE0R7Mjw+Lpl87zlW7/HKAiey3?=
 =?us-ascii?Q?f0BdDTtZ7qfqO/rk5HioHUGTeU2kGtOCa1x6traRbx+Zr3QVJtSdI1Uq+WUf?=
 =?us-ascii?Q?pzr9FM46F7mgF9j4I1TWKCcPryrGeTg5FSb3qmQLB6Ceqz8RiBeA9FMp7DO/?=
 =?us-ascii?Q?KDPlyUaT3jFiGYma7jLqWMPyCfyJVYPIGa/tW8Cyp1ct2OkO3XYiXQFKgbF6?=
 =?us-ascii?Q?pgN9n3qalmLv+Z10oAqiZ/sEipNVVy1mdO/RxMj4H3m42OFT+cAd7HBewbX+?=
 =?us-ascii?Q?FaqVSrmwkFwUx87MzHeFUAsziSlXiODh5phMqXuMpK+uFU6zkXNH6EE8y7o5?=
 =?us-ascii?Q?NPdw8gymLaIhkW91wHTkHGETjfLWFDrf3NyDbP9V1716MAUKNbrwppjsDNHZ?=
 =?us-ascii?Q?7y3gMJUNuIDdxhIpzmibqqHwE7Akr8Y5AcKsw+jRC7UXvjOAA/B/QhtOIfR0?=
 =?us-ascii?Q?/T8jtojaarMe+qnM8jXz5Sc9jQUY3J3+AqKokZUSmmHxET0ylx0/rHWtVmUh?=
 =?us-ascii?Q?e7Uj74YtY9BznMLadb4OyJT+mdbCA791yoy9unlZfGgoF7n5VRJMio1JaVfw?=
 =?us-ascii?Q?YyXr9VCSgtlfWRb3O9PB0zNwMf2wdtDKGi+DlQ+J+frhKCERAN27l9NQ6/hf?=
 =?us-ascii?Q?D/O4bRiGA8qAcJwLWmpx56JV+hwESXTAyAZcH8IEtsNBUOxH80SmwwHWtpFy?=
 =?us-ascii?Q?G8u5DP2XFmu6Y0KxK1imuRlRlnTfNDfezM7T4ykLenzd1/x5a3lKj0pHd7gS?=
 =?us-ascii?Q?Pw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41c21e10-a742-4ce5-0bf7-08dac35f5652
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 21:05:46.4498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RenqjuesNTbmumOqzt6pXgxsY1UeH9dqkedi1dfR5GntVrlOJlTvdj0VVbDv4ThWcguMVOv2K2uTPgCPLZUHyqY1zOXH6e/1BH6RGLQONMI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5553
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100148
X-Proofpoint-GUID: QR9P3OYiJDjHP5rF9_1AitOETo-JT0fN
X-Proofpoint-ORIG-GUID: QR9P3OYiJDjHP5rF9_1AitOETo-JT0fN
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch modifies xfs_link to add a parent pointer to the inode.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_trans_space.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/libxfs/xfs_trans_space.h b/libxfs/xfs_trans_space.h
index 87b31c69a773..f72207923ec2 100644
--- a/libxfs/xfs_trans_space.h
+++ b/libxfs/xfs_trans_space.h
@@ -84,8 +84,6 @@
 	(2 * (mp)->m_alloc_maxlevels)
 #define	XFS_GROWFSRT_SPACE_RES(mp,b)	\
 	((b) + XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK))
-#define	XFS_LINK_SPACE_RES(mp,nl)	\
-	XFS_DIRENTER_SPACE_RES(mp,nl)
 #define	XFS_MKDIR_SPACE_RES(mp,nl)	\
 	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
 #define	XFS_QM_DQALLOC_SPACE_RES(mp)	\
-- 
2.25.1

