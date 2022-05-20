Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F803C43219
	for <linux-xfs@archiver.kernel.org>; Fri, 20 May 2022 19:01:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353172AbiETTBD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 May 2022 15:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353123AbiETTAw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 May 2022 15:00:52 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1385F7F
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 12:00:51 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KIb59M022587
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=t7bssHZx9Z6E8wnFxnD/ZpgLELuc5ltv8xxX5g22hbc=;
 b=H9LiQ/VopfTLAsy6sWXiIHII6t/M9TumOvZSMzmj1dRC3/s/f9kY0ggmJZOkKZ/pBbue
 bEM1JBC9WGf74WZn2nTspV+hUJlkOZXAYf9QJ50zkQ8qb7tmzY6SFTGtFrN2BzstAygD
 dPfz8RDxdCYmpzFSk8xdZOUyd1egvPSU2/fSM0rgCViq7BZQoYSOQRbpTYRFWelFAp+d
 EhLoI+80a8gzaAf9LsVAQAHluU5sZDF+k0y7Ybagfkedrp6rUXJnbxtx6FpCHM/Qz2Kf
 4FkEqEFxchRaz18ejufsCnO43+WB/fKQCPPSegP26Zx0pXqZwuytDCuxSTFv2n1V3b8o 0g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24ytyx8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:50 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24KIoAPB034622
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:50 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2047.outbound.protection.outlook.com [104.47.56.47])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v6mhj7-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MKye7UmYTvTTcO7X0Oft+qBAeOML0M2WVaqHihWpa7x/THlBoCDSC0vZdEpKPu1gX5MFkgVerafIrqUPf0WZkQEbDWd35Kg349H70pGQO6GaWAtU0sxtY7x7X1CAjESJkh8NryAPkQ1A4RrJNU2/hwdpQwC3iU+J1z+mrOfZrn73vnDjkm0/BUfGvX2TwUukZ3/GNg7zuF7YjIz7iwSse8qBTOCuAeexQRc9ukA7hZG24w7pD2PMjQGDmHnkxZ2kqi5y4+zNjXjlYLADWJyt7tdcm+rpKi9Syo12BgLGByxVb4qAdflDUuiEKJR+mGPmGuj4hngxNgWvhzVVRtYkDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t7bssHZx9Z6E8wnFxnD/ZpgLELuc5ltv8xxX5g22hbc=;
 b=itfHwvqYDvgq/DR3EyWIDoI7iKaiN8SjK4QDIRahWaZtZyPrxd2qVadv/B1Gl2EbeEa8c8ngiKSkc2kKJpJZgPzAd4z2vfBzK/ZtT0NTBZAAndtkkRlN9gCKlzcy97GypRz/uG8Rkv1ySEwNatkYuXlf1d27KywTcZrDIt4W4qxV1EA8d1PqEgtKPgvUdyXJGsKpoITuthPMVAakFVtON3KClCnRFM1/je7id8xIz0mq7lAajXeqtryRzYMNWjywyc0eKNXrWeoydxkjK19gUoVY9xyi+CRX0XRbm9Qg7m3GzzX4Vx1SDCzmrdgwNKhzAz7/yOyxq6JOcIhGjyQEqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t7bssHZx9Z6E8wnFxnD/ZpgLELuc5ltv8xxX5g22hbc=;
 b=rovecG30+kAkhfgL7EN7SXt0MVff5tPbmzpaKeg6Rcn5z9kR+1lWaabLN8NSyNLKh1uiEUMhaciQQaZF/xZXZ4s86QbZPnurtfzvnLQp3CG1qgsydQ9Ui6kFnDs7tXgS54o4vXFUroXBuBwWdm0k4OAWdTcPmkWeYKTDq65gdNI=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM6PR10MB3658.namprd10.prod.outlook.com (2603:10b6:5:152::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Fri, 20 May
 2022 19:00:48 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.018; Fri, 20 May 2022
 19:00:48 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 16/18] xfsprogs: add leaf split error tag
Date:   Fri, 20 May 2022 12:00:29 -0700
Message-Id: <20220520190031.2198236-17-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220520190031.2198236-1-allison.henderson@oracle.com>
References: <20220520190031.2198236-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:a03:217::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df3094e3-cbb0-4ae1-24a9-08da3a9309a3
X-MS-TrafficTypeDiagnostic: DM6PR10MB3658:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3658A523C8BCA962D5B69E0395D39@DM6PR10MB3658.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +1AQFTRAXlqbXowp84mhwLJb0CFTMJG+8W7hSi+Sf3S7/Jkcn5mSQnCI7lcKeS9vbAQLAkrxq2DJcm5Zes3mBtnZ/p/CCGOVTeHNiLTq+yFR1Scb1qwn8R2cJcts+ZiJNJt94E2XVHaV86bFVXFkQgdpkwX2Q6niFg6PPRJ3+nK2AxicaE7hlId8uC5pgslvo+/sNfUijFqmhaxiVsWBBlYKyc2gt4WUpEBFXwk7Vgj2zT9WzxRZlxMcg6BwWjG5jQrndx1erZ3Akcv7S9wth7urpYXUb8s0nF6bT5cKl+aM+xKHkrBnRJeKOuAT/aR/NViL0EU4ok11Fxgy0nikiBOYPY53tOxAiR18fqFBNaSn9er1XGAibjbthVK1MNhaQhN5Zk7lH3euyIhp9XDFmm1exjanZyMOARwlZ3bnQZWJe6l31rXKI7wZzpjN1PIiSxRKgWK4z7c8sDTdqIhrB8jqbG4SnHMOy08jIYGtgT0ZVG35/YzSReBPSZMWZrQOGDgC7gV3rfQrQGQiPU1JF7Nadk30kLjP+bAjzQL/9HH1i4IA03rdsfE8BtwMtnDZOaij9alobqz6kFrUgWtvvYYg6dBQ+ut8WQp1wWzRk5ni7Ro9fUGUJJY09SE8cx2VCL+rV6NAsrjAI4prUQklhWAnCkkq/MWm4CSVYWtLuuE70Mf1B/1aMZhdRpOuv0pbFrF+JsApkvua1YkZQAtEdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38350700002)(86362001)(316002)(66946007)(2906002)(38100700002)(6916009)(8676002)(66556008)(66476007)(5660300002)(8936002)(44832011)(1076003)(508600001)(26005)(52116002)(6506007)(36756003)(83380400001)(6666004)(186003)(6486002)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?btKo5k7sGj+aIqPRbltCgZhFBl6n0eXDssCtmn4X71oPRjNCb9AXJb5ULiUY?=
 =?us-ascii?Q?Iy/YBj50u+dhD4uC8WOyRF7Rlj/FM1x5v5vgkI3RbB5nhZGJ950yP7NhExS7?=
 =?us-ascii?Q?eC04354n/8Jqf7VJHWJVKrxQR196xpznr4ya4UTHYBk6w1cjQ9rEyjW1YY13?=
 =?us-ascii?Q?qltkZZ5hg9XJ5zvsJZ0VXlN0NzEloEei/j1OMAiCqdm/CS53CCISvmdQuOsC?=
 =?us-ascii?Q?FXOda0fSgsJV/ZjRlvMpilw4dJrpcVq9eCOxss21hp9lL8PFms1vk2Y/GosK?=
 =?us-ascii?Q?l8tdBtG18bA+osXJ8jVTZHSHFg/z+o787Ezxxx33frDyAtnk5hycL4BzMSyF?=
 =?us-ascii?Q?VNwIWLxfZe3VGHCvMxjelw7+B92bkg7SQqzbGFf1f0InGqkJFehc7OPsy0/B?=
 =?us-ascii?Q?F9pyD6XJJOPYNs08Cy9OxM5Yzt6aDQ8lHPkTgOuhueC9VB6OzPpDTPxMD5Cz?=
 =?us-ascii?Q?EvbNJYH+wyhxonupOWxTEcGfcawviDy/B2+2dZJBsdGyEwZzYaexjfH9MBVQ?=
 =?us-ascii?Q?cKIjL+okePQHlGa9pbz17N8yNl6oGCWbjpCb+ZkQiA/EFkKQXYzcZD9kdLM4?=
 =?us-ascii?Q?/IYwukXHRw2hkBvE1bPVtbB8ywHAxBz7uYQeHLqBP+IbksY4RhwOc0oRB6wc?=
 =?us-ascii?Q?ltWeIyRPW+fS3nr9uBlyVm8smWAcy5dhZYLWHLQNOlg4qzHFsuLDOm6jpcKT?=
 =?us-ascii?Q?nqj9VIZ339NB4mTUyhBxqkLHQgpu5nMVm2AgG0xL2+Na2P0iKnO+t4Teiu3f?=
 =?us-ascii?Q?wWHGT5G3TOVdqy7e/xzCMuOUBEDkRFpA/a+a1jp25B9SDcK+mlb5ih12m69y?=
 =?us-ascii?Q?aXd18EHiCXy8oZl6caiLrw72jcuXhuum0ch7dV06sva3q72GuL9GBw7Anw0a?=
 =?us-ascii?Q?6zr30Mjr0aZkV0tHn0NBGR4FZbPgJapKF6qHiqV7MlFDN2Z0IPwQdnDNe707?=
 =?us-ascii?Q?mGVc3Eam+xRs0hbJ4FL2E4xtp2TA+1lr2kgLgLuvKXeihgFTMZcy9ZwwdKcH?=
 =?us-ascii?Q?reEUu54SBT0j0piOo0gx8/jY05cDBnmqoMrh5qP4q/paRC5nV8PYHUMlojb7?=
 =?us-ascii?Q?WeEaeMb+VmRqatMMi207wJwIm4UiNOa51CNWTNuQ0GVA13X6HEacVWe0kDBW?=
 =?us-ascii?Q?2eApYj5+Drn6zJ02YCSfl2tTHzJx4MfUQm205wjHOMg6OAWoi8eZBYFeiUPK?=
 =?us-ascii?Q?mvy+cLqhZj5/ZWiplfQQkGoiXgf4DuljPdqHj82LlOqsSe/XZEDU45z2AYhS?=
 =?us-ascii?Q?YyZDx20UeGXk3ufLxsHnRlr3WjHdAeyv9Vr5fUafh8kC8Ccg4TBUAhen3Km4?=
 =?us-ascii?Q?zTbawJS+ohUxCs9QI8kObehPldvxwmMFufWTTPKC26JmONd264jiGAPvW++o?=
 =?us-ascii?Q?1bxTWUHCEg8CYiX7i75czLcbsw+DcFE9G0xDOvWJoj8/DHgd76pgsUlPXwr7?=
 =?us-ascii?Q?+MI/Ywpjxs2c+UcFaw2d/x8rMpDF2nBql2iRXnS1eKBifktAHYBUiEbNsKOU?=
 =?us-ascii?Q?lTYP25oRY/CR7ecSxTq5wcH0sqq4qfATeRMDSpAbnMuqsn3G9w+tAb5JsWEe?=
 =?us-ascii?Q?a8ymX46MkufyiRFQlapziBkvS+AMRjieA3ku5lz1023FdiElIL5xhSMl/MaD?=
 =?us-ascii?Q?j41WTh/9zEEJvy123Ue4FWiw8wS+OpvHmDCrhOozwp6JanN87teuyhhS7tvJ?=
 =?us-ascii?Q?nf/cGhK1IhsoDVMKfvYbq33dzJxsDkoxuZHQj552wjIB/ZqaHxhX+oLRKu5m?=
 =?us-ascii?Q?mn17F5Z5wAkGGGyl9kVjXzxvezUWe8o=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df3094e3-cbb0-4ae1-24a9-08da3a9309a3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 19:00:42.4055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CgXueyOzMYr31hhosUvK/9K0js2poydfCevePyGelTrSQaSEWOEeKmVIXp0Zr570mePOaUANG7VlrZlKLNYnsRHexsEY2EIdUf5evLtdYi0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3658
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-20_06:2022-05-20,2022-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205200119
X-Proofpoint-GUID: btFjSN7jKrP87Sdvr4TCBci2ykGPgkcx
X-Proofpoint-ORIG-GUID: btFjSN7jKrP87Sdvr4TCBci2ykGPgkcx
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: c3b948be34702a0a81f10662c4040e500a90eb54

Add an error tag on xfs_da3_split to test log attribute recovery
and replay.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 io/inject.c           | 1 +
 libxfs/xfs_da_btree.c | 3 +++
 libxfs/xfs_errortag.h | 4 +++-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/io/inject.c b/io/inject.c
index 43b51db5b9cc..a7ad4df44503 100644
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
index 1f39c108782d..7ecbc6812725 100644
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
index c15d2340220c..6d06a502bbdf 100644
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

