Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DC1AC433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Feb 2022 17:18:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240704AbiBARSJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Feb 2022 12:18:09 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:39334 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240805AbiBARSI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Feb 2022 12:18:08 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 211HEC7h002994
        for <linux-xfs@vger.kernel.org>; Tue, 1 Feb 2022 17:18:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=e+UsZEPWGeKmx/mXlx0YWGFzuaDWqp+8Z+TpIE5F9TI=;
 b=FMGlmlY+gXuwYAwMm/DCU3jvH2QVx/oiV5Y4TBUVRW25OXRcQYhKt6TleNqqFrazAE/w
 aHxhmWi92wTJRqlvSR9g7NRAnzuq07W23gLkATO/u7jAh4OsCnsTRgkS9T2n/tb3SQZk
 4R7i3eAQG/ibbA/tTygGAgI39ffXkHe9/XFlMU4Xa63wQTh4/0/aIzepBz1QbT7zEFXO
 lAN8ujyluMORtz6cbtFqNPCpm6OQnZ0M22SCTgg+HCt/sbMDK1ARjS8FdDd37B89GcUa
 RfalI1LjBduLARkmy8nJ9VM1q21EP1yRB5uWsaVLDsO4HgtOG3RWiavinzUy6DSqAMJv Cg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxjatuph2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Feb 2022 17:18:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 211HFf7t044953
        for <linux-xfs@vger.kernel.org>; Tue, 1 Feb 2022 17:18:05 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2177.outbound.protection.outlook.com [104.47.73.177])
        by aserp3030.oracle.com with ESMTP id 3dvumftbhw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Feb 2022 17:18:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H1VT/+12882cwnrN4MTRfUGEbuQKEYxGJfmRHWlcKcGfFFUhrQNyhRhRkW0XQU9uC3YdEB/amsPMCmE3GorAreVdlxlrWZ4eZouD4F/1UPHL0SBNn6vsCrQslPnuetjEtaY/DYW8URMt8vrgpVkuDTdRRbsBnTeiPfp0KtMLF3tAMfvxhMRx9PJytyUtPEOr3K+WfKVnXNq+cD96Fakz5EjZzV7ZebJ/B6Sx05c4loCfMENQZGlrbg+Jc7tXn6NTWn2ty04wqFg8FODyj8TDG34dQzeBdv0bjwW+3qnIvnfSD0/4X0VswGl1rQtt6PaizMb8MvzaviUynHtfSVcVXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e+UsZEPWGeKmx/mXlx0YWGFzuaDWqp+8Z+TpIE5F9TI=;
 b=GlvwLAsItFwHMTYDojDA67jj8vKYSMCEDWrEZ0RfGhnowL1/ZYYSvmnGs83xKLS4+Qh5a3xD5VrtOmu24TX7gdwq7T6T3luj8dnj9LvjJUjbXA67nBW+9Q6ojHJOiRN4rU3yUCWmhpvmKWRplcFqxqwfkYhalyo13i5xE3P8HvyvYTHkD499cUR7HSTP6zujbjfCt33stcVCBNamqceR7lAecsKp3BZUDqWt15ru/bfHD2md3L2w8zi2H6R5B52SwY6R2LH3PXoanE5RtJi4CFgCLtG0HGMtvGIwlcH4ZGgsG0YYmZ9ImBaFCAMgSPM1YpQiIAwKBXL4ZZgHSPaSiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e+UsZEPWGeKmx/mXlx0YWGFzuaDWqp+8Z+TpIE5F9TI=;
 b=QtnESgzBwNdmL5FFRBg0s34qEcfP2+dMeMrH9V2P7xou/q4ndpXrgWSo9GzzUFj3fTrcwPeew8YRlp3FiYVAe/R0bhZFSJjOESk1zemr56/4dKEfDlVt2Dv1n4OTP1DD6t2c8SVCdJmgnwXGZxq3MKOeqaG/1E4IL1z0/fRJ6z0=
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 CY4PR1001MB2344.namprd10.prod.outlook.com (2603:10b6:910:44::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Tue, 1 Feb
 2022 17:18:03 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::2927:5d4f:3a19:5f0b]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::2927:5d4f:3a19:5f0b%3]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 17:18:03 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH v3 1/2] xfsprogs: add leaf split error tag
Date:   Tue,  1 Feb 2022 17:17:54 +0000
Message-Id: <20220201171755.22651-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220201171755.22651-1-catherine.hoang@oracle.com>
References: <20220201171755.22651-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR06CA0026.namprd06.prod.outlook.com
 (2603:10b6:208:23d::31) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 207393fa-18c4-4cba-11c8-08d9e5a6cdaf
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2344:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1001MB2344B9E346F0EF0ABC3B6B9D89269@CY4PR1001MB2344.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iiK7bYf13MsiphzgQjSjAzXKhkIUU+6hhH1SKlA8N0xRjk19kZbiehtW/YawXNMF6kXYpIaNffgSTLLT5+fmKclMwKLdtcf0CUjewpy9Xt7WeCI2pvQyMr5z9VZHaikyDPtoczVIekMwzhmyUkUc+CM45cWQEWJkJRDvMVaYxFhUJzYqmKB6bA0Ow2xYMtc0OYMTSDaUCAe9IMen/DdIqyj5HTgwGjXa6vkxbv5pgUQjOHFMEbXBmHwGVLlvLQT9HhFhlfvAfgNGFz0jaoMQu08HhID7b4cGrk4hZD9favF7MpZhynhCs7Xf/9bLGWQ7cYNBG0E6hi0l2fXIHz+awpZ9ymGC8P7njtBBnupTNcib7kjaXEZoteYw2qrKPCE3l+112LTGo/Is/X1HnHo5mFQ9THH3tSxc/lk21UjEuND60bTO+5uViy6iaUu7NDGLsFmE66TR3Ipjp6k4DWhD/cUFt9STMzG6WQ5mgl+tcRmIBBJOSxVYUshVOY+d9m7ISP3ufV2z4DSnALr6GEy0D5+VBIeN7+ZLDPwhHdvMSIOD+1EU6BiGxDSyJJL6JLUc2xER4Y+uqpKA/LyL2SnUnb5nGUgXjKB09O3OoZ0Uo1PN/lfFJKLB7c1eHK+Jw0vmNdUWEaKrkVRmWET4scXWRfsa870RD2QbxEoDxrxKjjAE772DMrW7IFCzRelQhfNQprC15Rl8tY/+f6EGw6C5Zw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(66476007)(66556008)(38350700002)(6486002)(316002)(86362001)(6666004)(66946007)(8676002)(8936002)(36756003)(6916009)(508600001)(52116002)(5660300002)(1076003)(186003)(26005)(6512007)(6506007)(2906002)(44832011)(2616005)(83380400001)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?me9l5wSYDYDTgTa/ppYODt5ZHZgMOd7XtNIxShvwyr5pqsjMOd8vzCb4vAJK?=
 =?us-ascii?Q?Wweqrtwzxip5Zmvm9bg7ykz8G/nI93KCtPccxBH3PjpXciRdWFYEq0Ve8VWi?=
 =?us-ascii?Q?RAqplwjzIMo/RO7KcWzArk9cVwzFOSmKbPi6afG+tClBKXqbuF0qNEz2sWx7?=
 =?us-ascii?Q?G1sw+i9qqqzzHpU931D0TqAUY/zXlN9jLziOV8q8VAnpYkWrIfzJa3y6a1p9?=
 =?us-ascii?Q?v6s5oAO3K60QhU004epG9ylKlzn/SWmNw76lH7WEcOsJBri4YCS2ew+WV+pC?=
 =?us-ascii?Q?rm8s/enCGl4u5eP8GTxAUILOVqS26aCLM9Wqo5m20DCIESMx6FLXo2nSw/RE?=
 =?us-ascii?Q?CNCC7KWzYBTHryN8kBQnrpM+GuCO1Y5OQzZYvyQ9F7nPWUrM5o1xvfLn+TXC?=
 =?us-ascii?Q?HsVc3Po3b93mQiFX0yOonR8YLxdPVJtmDEUAGGqexU+4sopidX0GtUj/AMJ8?=
 =?us-ascii?Q?gVRk3YGeIuGIoubZ0/0l8+KaP+DJdxhmnH+pkvfLrxMe4qW9465xf4gRtZoI?=
 =?us-ascii?Q?hj6czipcf7qlHU0fsBMlzYF9uig3ucEf021TsK9XaWuJpG/82vi+NXzv81rU?=
 =?us-ascii?Q?pxEB334jnt3zCg1QrZUZ7d0H11dJ5nSvhg14PDCKXMQXHKL0kz1Ps/htK4tz?=
 =?us-ascii?Q?jP1TBITn6UWwRbCFn/qNpmFI/ltKA2jCWuXnT/rSrEcsY3IMldQD7lJfDziW?=
 =?us-ascii?Q?RQkdxYLwrmfExa9qI2JAkYjrHLpoclDSYIVO/o1FoqdJdb5wtC+YGuh5ux36?=
 =?us-ascii?Q?8VwmDWyfL+sQpXeg94tfq9/cOeZrsqmae65YnnqATx9YRwbL2kLqlDcBpjB9?=
 =?us-ascii?Q?nbQB3TYeWfgKeNdtBCnE4ec/UW2yGQe3rf/ci6zcqUj+LH5ar/EOxw5zFAS9?=
 =?us-ascii?Q?Lhas/RoOoH0oxuvQ5BTVpKwan/ryhqedjbQ4YZRdxwHj2HSJNqAjdugrpV5r?=
 =?us-ascii?Q?LEW7L0VpnTmi/7zz380ZwD5MUj0O0P+VqFmn0IYhF4pkB2F1XB+PhTDmfMWw?=
 =?us-ascii?Q?L9N8T15eirEAxc2dFdBPUyp1g0ew3gv2OR0sdcq2hNiqVz2GK13PxVCS/sn9?=
 =?us-ascii?Q?/UF3RVeh6QTqzS+WkdeK9/Nrm6IU+CQJCnLBJBbIyNyriB+IkHmD73nGnoWs?=
 =?us-ascii?Q?vQ1XySTgVZa48EDm07E8wLffhbXKqoZ0blMKzL4BAIjGkkUAMyYuNz9Lhdq6?=
 =?us-ascii?Q?HeKOO6rvr/uBOjNChlwPw3A9D0VohmKjew18lKVhX/0DJobN8pTBcMMwDrJx?=
 =?us-ascii?Q?I5SjJBviA6AQ/LFMPF9HHGgXOSAgjNIJsjCJrp1nzh75Qs7U+ULwsPbB49XW?=
 =?us-ascii?Q?iZD8qrp+zdmwBoNWqIMpGGeh0M2N2lo5+CCCm0icCAOtKDOUC0p4cvwqyOby?=
 =?us-ascii?Q?wA0uo+XnuxJc8JzEaUu+72za487H59+kNVvzObSQORXlZMaW3SA2glt2eB4j?=
 =?us-ascii?Q?R7kvcwUOW0m0Ig+PlnUnib909pWPEhqqiQBF4Sv3agJ2Jz11dNxGhzVOF1md?=
 =?us-ascii?Q?AHZ2rUl+R4QX0CDqlqK+nO+gKG2fMO7syEA5yQaysOulvjF/tJ6cgnBQhOPr?=
 =?us-ascii?Q?G41FQHDdrKZIDS/+3yBmXRT823iTXcgtjJdwHC1laBgrXJuNWEutIQhc+FSe?=
 =?us-ascii?Q?hOIka/flCv3NCzAcbq0e4vLuAaVHT2ewGqyGs4uBEtbgeO0O8aYVUtuDxuIY?=
 =?us-ascii?Q?VC19/w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 207393fa-18c4-4cba-11c8-08d9e5a6cdaf
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 17:18:02.9020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OF/ttVsasG0B7oPffvXBlb1Dh1ig+PKKhvWxWd08M0LjdUTCg4+N2MLlo2gFT2XWgTda4UilZgzbty89CM+aLjKiU27kkHY53k/Phuhscx8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2344
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10245 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202010097
X-Proofpoint-GUID: BB4IYLrt5AU-SFi5Pd185U3jerzjqqTv
X-Proofpoint-ORIG-GUID: BB4IYLrt5AU-SFi5Pd185U3jerzjqqTv
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add an error tag on xfs_da3_split to test log attribute recovery
and replay.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 io/inject.c           | 1 +
 libxfs/xfs_da_btree.c | 3 +++
 libxfs/xfs_errortag.h | 4 +++-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/io/inject.c b/io/inject.c
index 43b51db5..a7ad4df4 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -59,6 +59,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT,	"bmap_alloc_minlen_extent" },
 		{ XFS_ERRTAG_AG_RESV_FAIL,		"ag_resv_fail" },
 		{ XFS_ERRTAG_LARP,			"larp" },
+		{ XFS_ERRTAG_DA_LEAF_SPLIT,		"da_leaf_split" },
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index f4e1fe80..6474f6cd 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -479,6 +479,9 @@ xfs_da3_split(
 
 	trace_xfs_da_split(state->args);
 
+	if (XFS_TEST_ERROR(false, state->mp, XFS_ERRTAG_DA_LEAF_SPLIT))
+		return -EIO;
+
 	/*
 	 * Walk back up the tree splitting/inserting/adjusting as necessary.
 	 * If we need to insert and there isn't room, split the node, then
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index c15d2340..6d06a502 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -60,7 +60,8 @@
 #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
 #define XFS_ERRTAG_AG_RESV_FAIL				38
 #define XFS_ERRTAG_LARP					39
-#define XFS_ERRTAG_MAX					40
+#define XFS_ERRTAG_DA_LEAF_SPLIT			40
+#define XFS_ERRTAG_MAX					41
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -105,5 +106,6 @@
 #define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
 #define XFS_RANDOM_AG_RESV_FAIL				1
 #define XFS_RANDOM_LARP					1
+#define XFS_RANDOM_DA_LEAF_SPLIT			1
 
 #endif /* __XFS_ERRORTAG_H_ */
-- 
2.25.1

