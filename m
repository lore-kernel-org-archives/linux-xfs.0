Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33458C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 10:40:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234232AbiCAKlg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Mar 2022 05:41:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233511AbiCAKlf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Mar 2022 05:41:35 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B1F90263
        for <linux-xfs@vger.kernel.org>; Tue,  1 Mar 2022 02:40:54 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2219eD3I013679;
        Tue, 1 Mar 2022 10:40:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=9Ix1IW75+DCK6Nb+rO/JYajrSAd3F1MEMwIDVCSQxfU=;
 b=c+8VKws58cv5+F1gTpkx6EEMZrR9P4l6PRNuUoMjcExCJp53aXpaRctWLwBv/6rSuAVP
 5p1IiE6WKzT9aA62SLcXodjwYqn9XpstbzhxXUfEoAZRIzKHjmN6OhAbwAjHWzxqC1IQ
 zp9GJ8fucaBEEhw7ygTELsRltj6hlivICkKe+iHZib5K49gMWj1AGawk8wRKVKoXZBtL
 w7QteUDGabWQrTGm3OjokIutUq5H+F002YEXY/lMpWACkks+pU2BO8/ld6Lk4//Bq0nW
 mZsl+eLW45odTFhvbZNRUt6YBhBH6B4wq9bJEvQVciLD6zF+eokmTzVLrLtsJUj6y7TD FQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ehh2eg5mf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 221Aa42G030175;
        Tue, 1 Mar 2022 10:40:48 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by userp3030.oracle.com with ESMTP id 3ef9awysm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S1JNyoklUiPijNM8VDbHgawddSKtgzE/bWf2mEKdB+EON+RosVhQi0aySIqBoOM6XVU2Qg6aLHDyZ2PnEziuBQ4Nsojy6rQeEP9GHxtwGvVPoQ8nZkLjIiM0fjh3SRL40AX+hVKI9Vgi/HkoYROUCA6vB2rB2hq2QG37W5uKJxbwkDMPTa6Ak3VBtfjxZNPNneVh1dXvnp6IidSYL4Hxk9mVfBJiVW8Tgyh8wGQrwbTmEe/auVTkcpQ5K2jYRqFZuWR2Yzg0tvbkmyUKy9pEJCxhFwc7ZGGV2Jjhz06RGHePRq1tMiTyHQFpNN3g/TpcZkOxcj0j3/Zln9Q+Y+Wsww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Ix1IW75+DCK6Nb+rO/JYajrSAd3F1MEMwIDVCSQxfU=;
 b=HIrcjpkFaRXwsXzuK0LSIj6SF48U+uBOPBOArp8Zqd+o153yIOstO6NubCrROJztrm70FNr7uXpIN7/QaNN3Tk/EO468X8KlDW/2xNGtMnrZ36LVsGMfIwrPG9r2ri6NE+Xn0JK79DLrsGFGU6JU/hDbfQ2W5OOEUh9qFkoQtS71E2Ox0yup7Wsri0S22049BiY4NQBfWVdxhKY3m47aoBscUlFVfpLwcYxpAoQhoGCuAmd0paS+Ra1GM+r/DHKMU9N7rFXUCg9DHJx8PgjsYzgZ/vqMW//QNMkl3xiIGvpI1a7ErEyWo1MuDZ43P2F0Pz1rnzB0RR5gZErzcSSBbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Ix1IW75+DCK6Nb+rO/JYajrSAd3F1MEMwIDVCSQxfU=;
 b=s7v7BqH+f8xxHcTGQPN3pO/LsNIOhaWO2Sr6HgDah3fmlOutj2W3HhzT9aMjwBd9m9EUMBCkvWiORKlk373SbLJVkxUy+jjeliYDx1v+OrLkh0Nz/kO6mKIKMjosK2oeiSpRAvXnF6w+7eOiyMeft4E/AIJz105A1IFi333JYF4=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by MN2PR10MB4160.namprd10.prod.outlook.com (2603:10b6:208:1df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Tue, 1 Mar
 2022 10:40:46 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 10:40:46 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 17/17] xfs: Define max extent length based on on-disk format definition
Date:   Tue,  1 Mar 2022 16:09:38 +0530
Message-Id: <20220301103938.1106808-18-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220301103938.1106808-1-chandan.babu@oracle.com>
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:195::23) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0c20f60-a905-4e46-3b2b-08d9fb6ff0b9
X-MS-TrafficTypeDiagnostic: MN2PR10MB4160:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB41602214BB7F4C6CF4CC2B2BF6029@MN2PR10MB4160.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9bDSh8hunbujyu+OtmsDlN0aOXWr0gvFk8iJMiI0asiN72/kKZD8yRFDsDexYENUbJexCqgF+0zuTwu5vApD0oSUD+6psL0MxhUzK6nhZFomm5+4gLI5dPu2fr9uUUcICyR0ZuaBC+nJlNQVMU3LHYtSSaHOwOLYUDcbv7+QBvGjW9y/MJC3PKKT3jGBH8pKUU3opdh7zLi6r9BNGh7AO6EnOLPTh+e5zja5a/JTE9QCipk43TqYMyp/VzVqPohQwDvj9xvrQSKNYyBA//mQjd5sig+YI0UyEljxBNsQ2ib+DJgn/TZgQ2MWX6bflT7+OV+AwngO0ZxU6ZdQHf2b+Cl7E4Wx0s5drB6SJ1/mLZ2DmN/ILbk29BHKn+9RaF/uSMuH1BmcCIrYgizeAwwC/tH7QmdRgutm8Y01Eb9rhMUn5/Hxsuo/ncwv04QjacrlwYnhRKoFkjQSXj8/mOS3Q3Nff9qxIJw3zWvBTaVmoPfhQVH1clmina8wFHPMUj5xrZsl4O6wiy8d3d+lL1cpixWXA5So8dG3widzATuzxD24BVR6z40fzqk4Iykit1XDs3xdKjLfUOLOVhln0ldAeFDd+ZlVf3s6wGCTalPjWzn2ve1ARTXGKvnbyDe4yg7Evcg5rvqZdlNFCrBnC3v8IRh4xioOd9WgryBNJPqk/SnZCRB3SpJC3xnKEHYrfNHTuudxS5EOucbYy5qrasDzFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(38100700002)(38350700002)(186003)(83380400001)(1076003)(2616005)(8936002)(36756003)(2906002)(30864003)(5660300002)(66946007)(6512007)(6486002)(508600001)(6506007)(52116002)(6916009)(316002)(8676002)(4326008)(66476007)(86362001)(66556008)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5vIPkXM7Y/HMv3u0idjMNCNZj5WN3FrLNcStmG5QhEP/pEZIcbNCVaa+Ncsp?=
 =?us-ascii?Q?QiJYhNDcXb4ADyzSNVwRO95CbSIDVwTYdupcG6GFr66ZwLg3fAitoDP+ceoe?=
 =?us-ascii?Q?Mi/I2lUM5aJ/2eYa9dmrnCR7ub2nlhGUcZK7cYW67nXslGPWopGbIAnjvvkc?=
 =?us-ascii?Q?wdOjkKEKZ+u9+vomhAXcxMzlAuy3wzbMcY6DblApvzfdXZTx3q6MJDpJylp8?=
 =?us-ascii?Q?JVSlqHgpTxe9F8+Tc+wjf6UVE0IgsAmjm40YUyB1q4EQY4yhwJXa99OaTNQK?=
 =?us-ascii?Q?sV7pZ8gAa2sgAlXz7nyS/wmfXTvWetRZ8mDAIiqoRLH9jBkZJweIZc0w6/si?=
 =?us-ascii?Q?YDM+BSorDIBtUHfwTVYIIvBp8RJTm9amA9a+i93Pg/lMbtcX7zY5u4h8wN96?=
 =?us-ascii?Q?MRi6Sxli/R0hDgeNSPA+UDibC3br+fS7cGzyld8k6SQMXrRkluCvnNQaDHVd?=
 =?us-ascii?Q?aXuXSoQ1h+9ADU/79p/Z3MX2zGC8HIxadK9a7nNs1Q/O2bctOACCiAyDbCjt?=
 =?us-ascii?Q?FVGKkyfS+M5tWl6yM7DIO61XV5x0CP5a5a0UjWHbuhicx2vQbD1IZflqoXkD?=
 =?us-ascii?Q?Yqntafas80N6yAvDYn9iz345dGyWayxDCqTmLhtv/NN1czNJqa627y8G7msk?=
 =?us-ascii?Q?+5PIRjPps6WUk7IlOdX1vvfzsw/WDA24rWHDiKRERF2RnvqHrGKkTSmjRUF7?=
 =?us-ascii?Q?H7F4K0YhV5BRMlFH8b/uzz/T/t0SBb5a1C2WuMvTzKyWj27RA10s7ry20dwF?=
 =?us-ascii?Q?9Dfi/lfONrlhnuqAS44X4LtwUE0q2R5/5wtc+qZpxRW4X1E2ufodyNmRfO1Y?=
 =?us-ascii?Q?vSgFX79Bila78IAmWdMZIn1xGg3W6BSk/S1RDk6NWil9peTZ3RNLIFXklIhp?=
 =?us-ascii?Q?qtlGRj0Hcsw7SN7C3zax1TljEn98Av0jMb40kNIuMvCUNRxypaucQhe2A02L?=
 =?us-ascii?Q?uzJzTTuT3by676u1BOMQObY4ZxtFH5F7G/EC1LPDTiAj7n8aWtrVwlkk53G8?=
 =?us-ascii?Q?eOBnSDfjp69Sa87PyzIzh7ysV2+xqmxl3HCzT7gZzEgM/fAb/z/LMmpfpcPd?=
 =?us-ascii?Q?m1AKN8EwL9XLlVUbhvUOwzsOh07kxg9mNzHsRX2/n+U8Tu7lcQIJZqMR4bYq?=
 =?us-ascii?Q?qJDo2Q57bH3MbOKjDJ52H4WAgZwbYoV6UNm+siFxsykdeWK7RMxPF6I+Rtr4?=
 =?us-ascii?Q?TBYbzRWRpeBrP2NePLfK3HK+goMmfC9Dt+cRGJTUi9WMWucOqblJBWk2e4hU?=
 =?us-ascii?Q?FKYbyfo+YFNGME1iYod19EDowv2bALWWfS8PprjOPPWGtgTr9CgU1ZA/YqbU?=
 =?us-ascii?Q?C9hMw/IdH+L1pVAay4nbtJrZA6XWOuW3LzshzONGKcIcZ9Q42ktzWB098joT?=
 =?us-ascii?Q?TxYNML1wTWM2p2ZP+fPs1BiWgH0YO7VAF/PVDZQQkGPe6TntFAlH9t7HZJQf?=
 =?us-ascii?Q?cKVHyNcMi3iNJpUqP/vk2mDu8PjKg4N46gNHDCQa7rLoNAlxv3TCi/O3RpNG?=
 =?us-ascii?Q?DWsEJRB7xOZRIWZEPMrarIGILLHqv/4yq1Jvl0PmNw0NIOFQrj0U36iLSzey?=
 =?us-ascii?Q?H/fzTlYR1KVSjrl4K1p9/gE5x3HFH9VWfKRCWTKFrrYt5YPirNn70k5FUWKh?=
 =?us-ascii?Q?H/jzwM6dc7FivySFrazj7H0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0c20f60-a905-4e46-3b2b-08d9fb6ff0b9
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 10:40:46.0290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KhmYZR7DnrE3v4feqXyBzQK8lyNjLEgJlKF+9RLjlKEZiWg3EQNsZ+sCIPWz9ysMtGb7T3iZCgceRonkwWaQtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4160
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203010056
X-Proofpoint-ORIG-GUID: Qjq5bPlHs2B3e4klEcdprxURw6BTiAFn
X-Proofpoint-GUID: Qjq5bPlHs2B3e4klEcdprxURw6BTiAFn
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The maximum extent length depends on maximum block count that can be stored in
a BMBT record. Hence this commit defines MAXEXTLEN based on
BMBT_BLOCKCOUNT_BITLEN.

While at it, the commit also renames MAXEXTLEN to XFS_MAX_BMBT_EXTLEN.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c      |  2 +-
 fs/xfs/libxfs/xfs_bmap.c       | 57 +++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_format.h     |  5 +--
 fs/xfs/libxfs/xfs_inode_buf.c  |  4 +--
 fs/xfs/libxfs/xfs_trans_resv.c | 11 ++++---
 fs/xfs/scrub/bmap.c            |  2 +-
 fs/xfs/xfs_bmap_util.c         | 14 +++++----
 fs/xfs/xfs_iomap.c             | 28 ++++++++---------
 8 files changed, 64 insertions(+), 59 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 353e53b892e6..3f9b9cbfef43 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2493,7 +2493,7 @@ __xfs_free_extent_later(
 
 	ASSERT(bno != NULLFSBLOCK);
 	ASSERT(len > 0);
-	ASSERT(len <= MAXEXTLEN);
+	ASSERT(len <= XFS_MAX_BMBT_EXTLEN);
 	ASSERT(!isnullstartblock(bno));
 	agno = XFS_FSB_TO_AGNO(mp, bno);
 	agbno = XFS_FSB_TO_AGBNO(mp, bno);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 3a3c99ef7f13..f604d45e1712 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1449,7 +1449,7 @@ xfs_bmap_add_extent_delay_real(
 	    LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
 	    LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock &&
 	    LEFT.br_state == new->br_state &&
-	    LEFT.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+	    LEFT.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
 		state |= BMAP_LEFT_CONTIG;
 
 	/*
@@ -1467,13 +1467,13 @@ xfs_bmap_add_extent_delay_real(
 	    new_endoff == RIGHT.br_startoff &&
 	    new->br_startblock + new->br_blockcount == RIGHT.br_startblock &&
 	    new->br_state == RIGHT.br_state &&
-	    new->br_blockcount + RIGHT.br_blockcount <= MAXEXTLEN &&
+	    new->br_blockcount + RIGHT.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
 	    ((state & (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
 		       BMAP_RIGHT_FILLING)) !=
 		      (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
 		       BMAP_RIGHT_FILLING) ||
 	     LEFT.br_blockcount + new->br_blockcount + RIGHT.br_blockcount
-			<= MAXEXTLEN))
+			<= XFS_MAX_BMBT_EXTLEN))
 		state |= BMAP_RIGHT_CONTIG;
 
 	error = 0;
@@ -1997,7 +1997,7 @@ xfs_bmap_add_extent_unwritten_real(
 	    LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
 	    LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock &&
 	    LEFT.br_state == new->br_state &&
-	    LEFT.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+	    LEFT.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
 		state |= BMAP_LEFT_CONTIG;
 
 	/*
@@ -2015,13 +2015,13 @@ xfs_bmap_add_extent_unwritten_real(
 	    new_endoff == RIGHT.br_startoff &&
 	    new->br_startblock + new->br_blockcount == RIGHT.br_startblock &&
 	    new->br_state == RIGHT.br_state &&
-	    new->br_blockcount + RIGHT.br_blockcount <= MAXEXTLEN &&
+	    new->br_blockcount + RIGHT.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
 	    ((state & (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
 		       BMAP_RIGHT_FILLING)) !=
 		      (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
 		       BMAP_RIGHT_FILLING) ||
 	     LEFT.br_blockcount + new->br_blockcount + RIGHT.br_blockcount
-			<= MAXEXTLEN))
+			<= XFS_MAX_BMBT_EXTLEN))
 		state |= BMAP_RIGHT_CONTIG;
 
 	/*
@@ -2507,15 +2507,15 @@ xfs_bmap_add_extent_hole_delay(
 	 */
 	if ((state & BMAP_LEFT_VALID) && (state & BMAP_LEFT_DELAY) &&
 	    left.br_startoff + left.br_blockcount == new->br_startoff &&
-	    left.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+	    left.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
 		state |= BMAP_LEFT_CONTIG;
 
 	if ((state & BMAP_RIGHT_VALID) && (state & BMAP_RIGHT_DELAY) &&
 	    new->br_startoff + new->br_blockcount == right.br_startoff &&
-	    new->br_blockcount + right.br_blockcount <= MAXEXTLEN &&
+	    new->br_blockcount + right.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
 	    (!(state & BMAP_LEFT_CONTIG) ||
 	     (left.br_blockcount + new->br_blockcount +
-	      right.br_blockcount <= MAXEXTLEN)))
+	      right.br_blockcount <= XFS_MAX_BMBT_EXTLEN)))
 		state |= BMAP_RIGHT_CONTIG;
 
 	/*
@@ -2658,17 +2658,17 @@ xfs_bmap_add_extent_hole_real(
 	    left.br_startoff + left.br_blockcount == new->br_startoff &&
 	    left.br_startblock + left.br_blockcount == new->br_startblock &&
 	    left.br_state == new->br_state &&
-	    left.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+	    left.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
 		state |= BMAP_LEFT_CONTIG;
 
 	if ((state & BMAP_RIGHT_VALID) && !(state & BMAP_RIGHT_DELAY) &&
 	    new->br_startoff + new->br_blockcount == right.br_startoff &&
 	    new->br_startblock + new->br_blockcount == right.br_startblock &&
 	    new->br_state == right.br_state &&
-	    new->br_blockcount + right.br_blockcount <= MAXEXTLEN &&
+	    new->br_blockcount + right.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
 	    (!(state & BMAP_LEFT_CONTIG) ||
 	     left.br_blockcount + new->br_blockcount +
-	     right.br_blockcount <= MAXEXTLEN))
+	     right.br_blockcount <= XFS_MAX_BMBT_EXTLEN))
 		state |= BMAP_RIGHT_CONTIG;
 
 	error = 0;
@@ -2903,15 +2903,15 @@ xfs_bmap_extsize_align(
 
 	/*
 	 * For large extent hint sizes, the aligned extent might be larger than
-	 * MAXEXTLEN. In that case, reduce the size by an extsz so that it pulls
-	 * the length back under MAXEXTLEN. The outer allocation loops handle
-	 * short allocation just fine, so it is safe to do this. We only want to
-	 * do it when we are forced to, though, because it means more allocation
-	 * operations are required.
+	 * XFS_BMBT_MAX_EXTLEN. In that case, reduce the size by an extsz so
+	 * that it pulls the length back under XFS_BMBT_MAX_EXTLEN. The outer
+	 * allocation loops handle short allocation just fine, so it is safe to
+	 * do this. We only want to do it when we are forced to, though, because
+	 * it means more allocation operations are required.
 	 */
-	while (align_alen > MAXEXTLEN)
+	while (align_alen > XFS_MAX_BMBT_EXTLEN)
 		align_alen -= extsz;
-	ASSERT(align_alen <= MAXEXTLEN);
+	ASSERT(align_alen <= XFS_MAX_BMBT_EXTLEN);
 
 	/*
 	 * If the previous block overlaps with this proposed allocation
@@ -3001,9 +3001,9 @@ xfs_bmap_extsize_align(
 			return -EINVAL;
 	} else {
 		ASSERT(orig_off >= align_off);
-		/* see MAXEXTLEN handling above */
+		/* see XFS_BMBT_MAX_EXTLEN handling above */
 		ASSERT(orig_end <= align_off + align_alen ||
-		       align_alen + extsz > MAXEXTLEN);
+		       align_alen + extsz > XFS_MAX_BMBT_EXTLEN);
 	}
 
 #ifdef DEBUG
@@ -3968,7 +3968,7 @@ xfs_bmapi_reserve_delalloc(
 	 * Cap the alloc length. Keep track of prealloc so we know whether to
 	 * tag the inode before we return.
 	 */
-	alen = XFS_FILBLKS_MIN(len + prealloc, MAXEXTLEN);
+	alen = XFS_FILBLKS_MIN(len + prealloc, XFS_MAX_BMBT_EXTLEN);
 	if (!eof)
 		alen = XFS_FILBLKS_MIN(alen, got->br_startoff - aoff);
 	if (prealloc && alen >= len)
@@ -4101,7 +4101,7 @@ xfs_bmapi_allocate(
 		if (!xfs_iext_peek_prev_extent(ifp, &bma->icur, &bma->prev))
 			bma->prev.br_startoff = NULLFILEOFF;
 	} else {
-		bma->length = XFS_FILBLKS_MIN(bma->length, MAXEXTLEN);
+		bma->length = XFS_FILBLKS_MIN(bma->length, XFS_MAX_BMBT_EXTLEN);
 		if (!bma->eof)
 			bma->length = XFS_FILBLKS_MIN(bma->length,
 					bma->got.br_startoff - bma->offset);
@@ -4421,8 +4421,8 @@ xfs_bmapi_write(
 			 * xfs_extlen_t and therefore 32 bits. Hence we have to
 			 * check for 32-bit overflows and handle them here.
 			 */
-			if (len > (xfs_filblks_t)MAXEXTLEN)
-				bma.length = MAXEXTLEN;
+			if (len > (xfs_filblks_t)XFS_MAX_BMBT_EXTLEN)
+				bma.length = XFS_MAX_BMBT_EXTLEN;
 			else
 				bma.length = len;
 
@@ -4556,7 +4556,8 @@ xfs_bmapi_convert_delalloc(
 	bma.ip = ip;
 	bma.wasdel = true;
 	bma.offset = bma.got.br_startoff;
-	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount, MAXEXTLEN);
+	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount,
+			XFS_MAX_BMBT_EXTLEN);
 	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
 
 	/*
@@ -4637,7 +4638,7 @@ xfs_bmapi_remap(
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT(len > 0);
-	ASSERT(len <= (xfs_filblks_t)MAXEXTLEN);
+	ASSERT(len <= (xfs_filblks_t)XFS_MAX_BMBT_EXTLEN);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC |
 			   XFS_BMAPI_NORMAP)));
@@ -5637,7 +5638,7 @@ xfs_bmse_can_merge(
 	if ((left->br_startoff + left->br_blockcount != startoff) ||
 	    (left->br_startblock + left->br_blockcount != got->br_startblock) ||
 	    (left->br_state != got->br_state) ||
-	    (left->br_blockcount + got->br_blockcount > MAXEXTLEN))
+	    (left->br_blockcount + got->br_blockcount > XFS_MAX_BMBT_EXTLEN))
 		return false;
 
 	return true;
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 76bd5181f7d3..b2228558f798 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -897,7 +897,7 @@ enum xfs_dinode_fmt {
 	{ XFS_DINODE_FMT_UUID,		"uuid" }
 
 /*
- * Max values for extlen, extnum, aextnum.
+ * Max values for ondisk inode's extent counters.
  *
  * The newly introduced data fork extent counter is a 64-bit field. However, the
  * maximum number of extents in a file is limited to 2^54 extents (assuming one
@@ -909,7 +909,6 @@ enum xfs_dinode_fmt {
  * Rounding up 47 to the nearest multiple of bits-per-byte results in 48. Hence
  * 2^48 was chosen as the maximum data fork extent count.
  */
-#define	MAXEXTLEN			((xfs_extlen_t)((1ULL << 21) - 1)) /* 21 bits */
 #define XFS_MAX_EXTCNT_DATA_FORK	((xfs_extnum_t)((1ULL << 48) - 1)) /* Unsigned 48-bits */
 #define XFS_MAX_EXTCNT_ATTR_FORK	((xfs_extnum_t)((1ULL << 32) - 1)) /* Unsigned 32-bits */
 #define XFS_MAX_EXTCNT_DATA_FORK_OLD	((xfs_extnum_t)((1ULL << 31) - 1)) /* Signed 32-bits */
@@ -1646,6 +1645,8 @@ typedef struct xfs_bmdr_block {
 #define BMBT_STARTOFF_MASK	((1ULL << BMBT_STARTOFF_BITLEN) - 1)
 #define BMBT_BLOCKCOUNT_MASK	((1ULL << BMBT_BLOCKCOUNT_BITLEN) - 1)
 
+#define XFS_MAX_BMBT_EXTLEN	((xfs_extlen_t)(BMBT_BLOCKCOUNT_MASK))
+
 /*
  * bmbt records have a file offset (block) field that is 54 bits wide, so this
  * is the largest xfs_fileoff_t that we ever expect to see.
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index a11d3ea5ebfe..b8e2a542643f 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -685,7 +685,7 @@ xfs_inode_validate_extsize(
 	if (extsize_bytes % blocksize_bytes)
 		return __this_address;
 
-	if (extsize > MAXEXTLEN)
+	if (extsize > XFS_MAX_BMBT_EXTLEN)
 		return __this_address;
 
 	if (!rt_flag && extsize > mp->m_sb.sb_agblocks / 2)
@@ -742,7 +742,7 @@ xfs_inode_validate_cowextsize(
 	if (cowextsize_bytes % mp->m_sb.sb_blocksize)
 		return __this_address;
 
-	if (cowextsize > MAXEXTLEN)
+	if (cowextsize > XFS_MAX_BMBT_EXTLEN)
 		return __this_address;
 
 	if (cowextsize > mp->m_sb.sb_agblocks / 2)
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 6f83d9b306ee..19313021fb99 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -199,8 +199,8 @@ xfs_calc_inode_chunk_res(
 /*
  * Per-extent log reservation for the btree changes involved in freeing or
  * allocating a realtime extent.  We have to be able to log as many rtbitmap
- * blocks as needed to mark inuse MAXEXTLEN blocks' worth of realtime extents,
- * as well as the realtime summary block.
+ * blocks as needed to mark inuse XFS_BMBT_MAX_EXTLEN blocks' worth of realtime
+ * extents, as well as the realtime summary block.
  */
 static unsigned int
 xfs_rtalloc_log_count(
@@ -210,7 +210,7 @@ xfs_rtalloc_log_count(
 	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
 	unsigned int		rtbmp_bytes;
 
-	rtbmp_bytes = (MAXEXTLEN / mp->m_sb.sb_rextsize) / NBBY;
+	rtbmp_bytes = (XFS_MAX_BMBT_EXTLEN / mp->m_sb.sb_rextsize) / NBBY;
 	return (howmany(rtbmp_bytes, blksz) + 1) * num_ops;
 }
 
@@ -247,7 +247,7 @@ xfs_rtalloc_log_count(
  *    the inode's bmap btree: max depth * block size
  *    the agfs of the ags from which the extents are allocated: 2 * sector
  *    the superblock free block counter: sector size
- *    the realtime bitmap: ((MAXEXTLEN / rtextsize) / NBBY) bytes
+ *    the realtime bitmap: ((XFS_BMBT_MAX_EXTLEN / rtextsize) / NBBY) bytes
  *    the realtime summary: 1 block
  *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
  * And the bmap_finish transaction can free bmap blocks in a join (t3):
@@ -299,7 +299,8 @@ xfs_calc_write_reservation(
  *    the agf for each of the ags: 2 * sector size
  *    the agfl for each of the ags: 2 * sector size
  *    the super block to reflect the freed blocks: sector size
- *    the realtime bitmap: 2 exts * ((MAXEXTLEN / rtextsize) / NBBY) bytes
+ *    the realtime bitmap: 2 exts * ((XFS_BMBT_MAX_EXTLEN / rtextsize) / NBBY)
+ *    bytes
  *    the realtime summary: 2 exts * 1 block
  *    worst case split in allocation btrees per extent assuming 2 extents:
  *		2 exts * 2 trees * (2 * max depth - 1) * block size
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index a4cbbc346f60..c357593e0a02 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -350,7 +350,7 @@ xchk_bmap_iextent(
 				irec->br_startoff);
 
 	/* Make sure the extent points to a valid place. */
-	if (irec->br_blockcount > MAXEXTLEN)
+	if (irec->br_blockcount > XFS_MAX_BMBT_EXTLEN)
 		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 	if (info->is_rt &&
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 8d86d8d5ad88..fc110fe7cb51 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -119,14 +119,14 @@ xfs_bmap_rtalloc(
 	 */
 	ralen = ap->length / mp->m_sb.sb_rextsize;
 	/*
-	 * If the old value was close enough to MAXEXTLEN that
+	 * If the old value was close enough to XFS_BMBT_MAX_EXTLEN that
 	 * we rounded up to it, cut it back so it's valid again.
 	 * Note that if it's a really large request (bigger than
-	 * MAXEXTLEN), we don't hear about that number, and can't
+	 * XFS_BMBT_MAX_EXTLEN), we don't hear about that number, and can't
 	 * adjust the starting point to match it.
 	 */
-	if (ralen * mp->m_sb.sb_rextsize >= MAXEXTLEN)
-		ralen = MAXEXTLEN / mp->m_sb.sb_rextsize;
+	if (ralen * mp->m_sb.sb_rextsize >= XFS_MAX_BMBT_EXTLEN)
+		ralen = XFS_MAX_BMBT_EXTLEN / mp->m_sb.sb_rextsize;
 
 	/*
 	 * Lock out modifications to both the RT bitmap and summary inodes
@@ -839,9 +839,11 @@ xfs_alloc_file_space(
 		 * count, hence we need to limit the number of blocks we are
 		 * trying to reserve to avoid an overflow. We can't allocate
 		 * more than @nimaps extents, and an extent is limited on disk
-		 * to MAXEXTLEN (21 bits), so use that to enforce the limit.
+		 * to XFS_BMBT_MAX_EXTLEN (21 bits), so use that to enforce the
+		 * limit.
 		 */
-		resblks = min_t(xfs_fileoff_t, (e - s), (MAXEXTLEN * nimaps));
+		resblks = min_t(xfs_fileoff_t, (e - s),
+				(XFS_MAX_BMBT_EXTLEN * nimaps));
 		if (unlikely(rt)) {
 			dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
 			rblocks = resblks;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 4078d5324090..8bbf4a2cca9f 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -403,7 +403,7 @@ xfs_iomap_prealloc_size(
 	 */
 	plen = prev.br_blockcount;
 	while (xfs_iext_prev_extent(ifp, &ncur, &got)) {
-		if (plen > MAXEXTLEN / 2 ||
+		if (plen > XFS_MAX_BMBT_EXTLEN / 2 ||
 		    isnullstartblock(got.br_startblock) ||
 		    got.br_startoff + got.br_blockcount != prev.br_startoff ||
 		    got.br_startblock + got.br_blockcount != prev.br_startblock)
@@ -415,23 +415,23 @@ xfs_iomap_prealloc_size(
 	/*
 	 * If the size of the extents is greater than half the maximum extent
 	 * length, then use the current offset as the basis.  This ensures that
-	 * for large files the preallocation size always extends to MAXEXTLEN
-	 * rather than falling short due to things like stripe unit/width
-	 * alignment of real extents.
+	 * for large files the preallocation size always extends to
+	 * XFS_BMBT_MAX_EXTLEN rather than falling short due to things like stripe
+	 * unit/width alignment of real extents.
 	 */
 	alloc_blocks = plen * 2;
-	if (alloc_blocks > MAXEXTLEN)
+	if (alloc_blocks > XFS_MAX_BMBT_EXTLEN)
 		alloc_blocks = XFS_B_TO_FSB(mp, offset);
 	qblocks = alloc_blocks;
 
 	/*
-	 * MAXEXTLEN is not a power of two value but we round the prealloc down
-	 * to the nearest power of two value after throttling. To prevent the
-	 * round down from unconditionally reducing the maximum supported
-	 * prealloc size, we round up first, apply appropriate throttling,
-	 * round down and cap the value to MAXEXTLEN.
+	 * XFS_BMBT_MAX_EXTLEN is not a power of two value but we round the prealloc
+	 * down to the nearest power of two value after throttling. To prevent
+	 * the round down from unconditionally reducing the maximum supported
+	 * prealloc size, we round up first, apply appropriate throttling, round
+	 * down and cap the value to XFS_BMBT_MAX_EXTLEN.
 	 */
-	alloc_blocks = XFS_FILEOFF_MIN(roundup_pow_of_two(MAXEXTLEN),
+	alloc_blocks = XFS_FILEOFF_MIN(roundup_pow_of_two(XFS_MAX_BMBT_EXTLEN),
 				       alloc_blocks);
 
 	freesp = percpu_counter_read_positive(&mp->m_fdblocks);
@@ -479,14 +479,14 @@ xfs_iomap_prealloc_size(
 	 */
 	if (alloc_blocks)
 		alloc_blocks = rounddown_pow_of_two(alloc_blocks);
-	if (alloc_blocks > MAXEXTLEN)
-		alloc_blocks = MAXEXTLEN;
+	if (alloc_blocks > XFS_MAX_BMBT_EXTLEN)
+		alloc_blocks = XFS_MAX_BMBT_EXTLEN;
 
 	/*
 	 * If we are still trying to allocate more space than is
 	 * available, squash the prealloc hard. This can happen if we
 	 * have a large file on a small filesystem and the above
-	 * lowspace thresholds are smaller than MAXEXTLEN.
+	 * lowspace thresholds are smaller than XFS_BMBT_MAX_EXTLEN.
 	 */
 	while (alloc_blocks && alloc_blocks >= freesp)
 		alloc_blocks >>= 4;
-- 
2.30.2

