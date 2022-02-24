Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8FC5C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234155AbiBXNEy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234757AbiBXNEx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:04:53 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89EF037B59C
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:04:23 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYFnq007314;
        Thu, 24 Feb 2022 13:04:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=mlLTYCYA5ZyM26cXTKJHpNuWqVai+ZDZHs9vd5YF/yk=;
 b=k+FoKNJeDmO8Hdy0wzE+edqGVwkurQgUaP/62b+9YrTGBEMhyu+uJgeHk4X+6IC9aZ6B
 CBDiV02dKHverS2EsEqJhVqfLHgN9v+G2/tjIhkFBNsmqfTAG1Ca1k6XwdBEcSPuJC11
 KcSPPv6hLeLGD071e1qMoxKM5mQ3R0Z4C2p1QJru3s6xM9y5rZz7AL0W8+SOoZLT7gdL
 qRkUSDUcxOjQg1IR5YgEUjU2rCE1LiV6uGjOIU2F3iuLKfEgwpe/QmDzLnrNijqxYbGG
 Jks40jPkJB9TEMEfBGzxuCoGhZWwNpxDQ5uvRpridSp4VD6/GuqZVMqq700uZYEoZOAB 9g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ectsx7b5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD0Xhg120475;
        Thu, 24 Feb 2022 13:04:19 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by aserp3020.oracle.com with ESMTP id 3eb483k8ew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ooxtw6Zf1KjqsU8jtFzAckCCeL3BV4ouWMF0iO0yLNsJwZz3O3vyFbYGO8rfgv135sJKaka0+wHntxZWHfQ85CpzIUjJP7c5r4oya01BqtHgATiNXjynbv1jgYkOYeYRvjk1J1Dc+lGI02H2gko1cjSn8hmpxYZgt27qHtgFRmewuyLDCVLtde2Vd4hO0UuJ4c8M8vJkXIytxSX+Laz1elUAd09jd8wiD9sDpaxJHNgmVRyZCJkJwjsEdOAu3qfZqeaWpV+1b8dcmzAlggEPdt98qkQfYexzXaaCqprKBdCTKun7ZWzNDo2li8nLBbxIWshLY47QwkdLEzhoPtoC4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mlLTYCYA5ZyM26cXTKJHpNuWqVai+ZDZHs9vd5YF/yk=;
 b=azyaA5JVs5C5f+gZr4EYQmgVZkVkvhZsdTkhBr1reqnI1j0Oij7pNAOw0xgGDu80AD2OsO7R9GxJVN7WemGz98IZMLzdG5niH1eMLWKgkSZfX/BgO3mzBLnDV9fZvafA0NR+e4CgwHVaFTtCx9XCcYP1AdMnR1mAmsJmDHRtPPTQVVLj4x4O8tQFWjY2SNRMhe8l+TM9+uk7l0YFGHdAN6c1q/mwhy64fgOeji+lf4KmnC+Y88KaD9fE0t+sOvaYxG86SJIil2jUtyzQNJztXhh3Q/HOW0zlf+qyoumpvrM79bNvXMuF6kMKdDCtzBLZeKPJasO1wXcbWytn497Mzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mlLTYCYA5ZyM26cXTKJHpNuWqVai+ZDZHs9vd5YF/yk=;
 b=MEoGF3f4+QCnNSrUl6Jmvv39h+PUU0GybYqPr02HMWGvdon0aSt+9M1HxUE5n4PmwpnubYypwE0GnVu/mE3i7b40h4IkCFSzN0bRmINIPI2t7JnAArv4eHcpayN+MnI20cN7pxkuhIoPlm4YpJYn+md0YDDqBzXtLGbQmjn0bUo=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4634.namprd10.prod.outlook.com (2603:10b6:806:114::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Thu, 24 Feb
 2022 13:04:17 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:04:17 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 09/19] xfsprogs: Introduce XFS_FSOP_GEOM_FLAGS_NREXT64
Date:   Thu, 24 Feb 2022 18:33:30 +0530
Message-Id: <20220224130340.1349556-10-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220224130340.1349556-1-chandan.babu@oracle.com>
References: <20220224130340.1349556-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0013.apcprd04.prod.outlook.com
 (2603:1096:4:197::6) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8f492bb-e415-4298-ac45-08d9f7962a35
X-MS-TrafficTypeDiagnostic: SA2PR10MB4634:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB463481373D79EF4BB87D2B07F63D9@SA2PR10MB4634.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rNGKGSYIg87qcyx5Hdnjv1y0bj1KahKG11lwQz56E6Ewg0tzsk2zIUHbuQ3y65wm8owDPTitrr8VKsS+zrQs2+3y88mHfI+wT3F80r4AcfxgF4eXncPLOfl0pBudNlTNCiscFK0GbPRXyOEqiKozI3+JpGNkGHv6NPXyDCqgDfBZWFwebxZgkS3jg58bXsvTNUw5n+hJKVWDVpxc5WsBBh2i6aIbi7k4htF/CpWeTRaeqhbALn+qH/sS1eB26PZUb6uABf8hZhn0fOIrAfNtYGAL/YSrHJ6vsQhwkf/Zj1KBnf8EvzzB9dOvvC6PQLLz49WdothWLB4MPndDtXMTO6vtIyQOjk3LK0NJQRpbm2sgKiU7t80XWlkhOHqf6bfr0pLfUS5XoDgRUu+EmWF81D3x0p5y4hQkMXTT9lA+TgIFdNwkgUAAxm5hh1ipSsXa62/Fa9GlMvA4Qz5amMHWCghDR9QGQqPGA8aakGXCVSRj1kS+JO/3ym75RfyqLN/EyoeNBhWeK2NpzukDRYzmcyfANXbkYc9INe9uFG+jjPX7NxWfaHAjD7Sk6nEb1wPwKdqhtlfm7ZtvKoecb40TTQlWeRpIji66uJh62FLH7HX0AbMyUvwoC4J8ON1apN7Of1QPOTxUvvPX6PLgAopLUy+fo39oVn5DfrKoLfgK1mYh/RJEEqkXxEcrOXZ+Jm742PHUlgqBeIK2/uNxS/IhiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(66556008)(6666004)(38100700002)(38350700002)(508600001)(6486002)(66946007)(8676002)(4326008)(86362001)(66476007)(6916009)(1076003)(316002)(8936002)(36756003)(5660300002)(83380400001)(2616005)(186003)(26005)(6506007)(6512007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5dEMObmUvJHUjHerd0hYCDEftFdJDtq6Hc1iZcME42trePjwXJ99gSc4VJBy?=
 =?us-ascii?Q?tCd0k6mMnJFSLy/3I+EVF6tpH8b1oWy6sfmGbf8G5nTh8txcJdsLB/8/5647?=
 =?us-ascii?Q?uthJQhjp3rx9xS7WtqaBWCY8DPBRCBf5bFRejSrlJ1HQQw/5z2QktZXZeEzq?=
 =?us-ascii?Q?CBeIq5zKIzbxcgLxgUHNhPpNvgdCyLSR6aNRRR88zj/y/fNNKAInuoisSuGv?=
 =?us-ascii?Q?p7seo4JZWjthQ60n4J6v2Z1xCUgOSOFPzBC1uoxvSJo+6K5seusNgBXonwtA?=
 =?us-ascii?Q?j3Q3Xd+KynN+kvPsaNGKz+MecSGg5GVRP+MfV/EwkXB96J8+QmAQ+awj7IXZ?=
 =?us-ascii?Q?4dDULe5yx9jPhaWDTy41bV/YqK0c0oRoWM4K/fRwo9PAEItv1FqTi3xpLUMt?=
 =?us-ascii?Q?J16pGoVVoepCcL0jyxSyNrfpiR41oR3FxE/iyHHCSLbeIryliUj3zZ3aOH7n?=
 =?us-ascii?Q?e0Vv36E32RBJgGu0dne3ms5Somxs/wjqR4qKuXXmWSairnUNd6DpVes0Qlqh?=
 =?us-ascii?Q?B9MMGFjoGQu9mlQqbLcmu+83OdirhCzJftsEdzmqjmz4v5WUGZNM9ewBox+s?=
 =?us-ascii?Q?YtkDq5H1O0t8/wcWV2nlFVVuq81ThKP2b7jO+X4Dk9Ijo1BAPoibP8NNCvFY?=
 =?us-ascii?Q?6utNib1/8usHRFL8ydH/bLroQjjGqfiRikxhe7QjgMAwELeVobSl8RdbAuo/?=
 =?us-ascii?Q?9Fhkvtj+U84YjunD2bMowlRdTFhm1LD2ukDaSfAQnq03Bi5Kovche+I5izu5?=
 =?us-ascii?Q?7Xl9ArDUzKp4SGuFfiKCkq9tEbEyI+RV0ZobjVUjUVc3br/wMelZPV81htIq?=
 =?us-ascii?Q?i2DfnyLYw63Jo0leJkjzWEeHrOWKAfRjUY5w2J+nE9nLr3fmKcK1FwaZ377r?=
 =?us-ascii?Q?7Aru6XUqN4yRHLjVkQrEh3pozHIL83NKaAu3hwABEk/zwMZ2ZEI9hcEQkiaE?=
 =?us-ascii?Q?q98TW1SNKuNYw6akax0adJJfwHlEVeDRUCgwc8dgDFaKN2TyxPsV3kxeN9cX?=
 =?us-ascii?Q?jVDIZQtig4/dsHiwf5Fg3ZgKkfru+7iY7Byxxc9DDuXVS9BzoLvqnxKoWsvs?=
 =?us-ascii?Q?tGzRmm7kJcxfNy9AAPPMn3VgvJUn1UNtNHzBKMzpOgP+6xEg5TyqKL9dTngs?=
 =?us-ascii?Q?WHuqbolYxT8UU1+tezhMJRrJseAykRGlfRjkBxjTfYaVICrO3LMyLTqsx1Tr?=
 =?us-ascii?Q?rq3Ya1WFN9zDHUEKsrPtcAnBKriU17ou3azp7IHtu4zZxyCu2hQ80IUOml2b?=
 =?us-ascii?Q?bCt7J8py6vLXm3odcVr4RYpYZEFAOKiQVlxgTa51DMvr9TGRcv0tL9ymBZmA?=
 =?us-ascii?Q?zRemUih1lXtx/v64Zbre/OHImVN4qJrlgMhy8HdqTXq7yQhyirpBRVmt3swl?=
 =?us-ascii?Q?bLaWuM2gJPu5Kk2Cx35wrAmLdBjbyWx+7J5ln5z2QO9RxPWYwH/ezmZTGKo7?=
 =?us-ascii?Q?JakuNt5SeFB4AveCSIrGn81Xz6nhofwUQ2kPCJFibCjFQJwTyzGh032UKlFH?=
 =?us-ascii?Q?+AtMmdm4kvR9Vn2szpDBM5aeb869p3saUTCoHWHIIHFXB97sWicg/A2/S3us?=
 =?us-ascii?Q?/cST+KEZiXjFZ/m4f08t6cbTch1ieH1Q+2Ye3TM2qTEFzW00FApnkNDqzR2R?=
 =?us-ascii?Q?PjA72N46uTWoCD9HvmLv70Q=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8f492bb-e415-4298-ac45-08d9f7962a35
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:04:17.7763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s6SudOxl9p9sVA4GsCGofxE2rxwulIkpyGAD/pHAeTlzF54hc0r8RHhAx6lQY0A5atJORT3w7mBmrmRDYi0AGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4634
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202240078
X-Proofpoint-ORIG-GUID: nmIEMsRaZIxQodSh6UZLWRT8TEKhJpIH
X-Proofpoint-GUID: nmIEMsRaZIxQodSh6UZLWRT8TEKhJpIH
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS_FSOP_GEOM_FLAGS_NREXT64 indicates that the current filesystem instance
supports 64-bit per-inode extent counters.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_fs.h | 1 +
 libxfs/xfs_sb.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index c43877c8..42bc3950 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -251,6 +251,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_REFLINK	(1 << 20) /* files can share blocks */
 #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
 #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
+#define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* 64-bit extent counter */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 7ab13e07..6045266e 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1136,6 +1136,9 @@ xfs_fs_geometry(
 	} else {
 		geo->logsectsize = BBSIZE;
 	}
+	if (xfs_has_nrext64(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_NREXT64;
+
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
-- 
2.30.2

