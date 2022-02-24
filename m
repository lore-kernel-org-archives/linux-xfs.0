Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F41E5C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:03:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234747AbiBXNDz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:03:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234748AbiBXNDx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:03:53 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1EB37B591
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:03:23 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYR9k023280;
        Thu, 24 Feb 2022 13:03:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=9Ix1IW75+DCK6Nb+rO/JYajrSAd3F1MEMwIDVCSQxfU=;
 b=bcSWU5/xHIiGJ8J2MsKzDH3LXNrey1d5Dcq4EGjlTfUJbonr8AJjaQ48O7pIVgWghl92
 PkYeHzzsEmmG7OrVl/tReiASoTf/LkYnHJIvGLBhCrWEjWEOBC38Up14WZl9kU2kebuE
 AMzW6MMGsyxFBNRSMWimihtgaWFT2EXgNd6i22Z8VFBwMlEP2XNvuyOOc4HAqxSuYY3E
 xUAxRSvXNvluZuH9gYwkjJjJ3rH6YvW4bPzTJbW8rEfEPlIuM114MTnqJ+YAI1Kvcoa4
 QqdQHhEdwWPMjE1ThR615vERtusL3bABHs7FUZ8Q4XqwGt57jzbxDPE4HJyVolXF+zRk rg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ecxfaxmgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:03:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD1gFW039568;
        Thu, 24 Feb 2022 13:03:18 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by userp3030.oracle.com with ESMTP id 3eannxddtm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:03:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d4p+FRatPeqJAP4qeRJ32SMCP1zgya0OSUPNNsSwbOgkdzD6AyK53L7m2rDPjAjNriU2hXo7QV4VscruGGiqGMEqRWXFXOHLSVEBBbeCL8SRc8yQmjzPfLYqYhW1M6kvdJ8BCgae8vwWXM5nHIS0HO+DuAFvyaHdY7ayfet0IErAGx+DQPIEnJaj24Ph8SMjXBqnw9A2Ghe/5SU7pHRypdpRbxQZId6LZb+YLj5IQ4ZDtJKlV1vi58VSl7BghftHETgbKOsukBo5HyjA6N6M7kPRMvBQd2BjJjIN894FcW6OAbp9tdg4wkYO7C11cqYEc5sguS41xxHb2ocj/f4b8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Ix1IW75+DCK6Nb+rO/JYajrSAd3F1MEMwIDVCSQxfU=;
 b=fb/jATHt1kk8d1VGA6Ni+XDq/rpto2ZWq+KW2ypKX0q9aHErTBaE4xBlPXR7iMkez592mmrfJoTg2fx0Lh9k5cA6OgCTyjN/nh9PLE9mQWD5qo13jj0py0pyRb8lZ9mGWsua3Be5wjWTHGbQUUTrn95SSbIyCM4KHYAsyfmK4D8stGmsAnZ3WQIsV9sHUkneOQ3dfBtaVAiUOpdPKDJse6ubaIKIPRkJiHPuM9apFYFSbBd6geMByHCff6r5tiipIT/tD/X/5Eso01BxeaovSbTK/aiFlDirOn9FE6hoHYbxOnTDAhQGCBz7eFOHEQ9ZpAxB1xgyryOzS1LETIYEHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Ix1IW75+DCK6Nb+rO/JYajrSAd3F1MEMwIDVCSQxfU=;
 b=JGLyPocYwGWP/d3+l7o96eHy72lpj+KznN/jyXTeeHwpjATsvcVduFk/pnG6w1EzFQMCdeeQEu5BSwSUN+mHZPLVx9PxtvSMTE4V/kEQ1ySBf40Tbjto6fV+mkQlBsehFuhy3auSUdKmGNCvBh3HaNiDk22+8tC7qx6bkKPwZS0=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4634.namprd10.prod.outlook.com (2603:10b6:806:114::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Thu, 24 Feb
 2022 13:03:15 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:03:15 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 17/17] xfs: Define max extent length based on on-disk format definition
Date:   Thu, 24 Feb 2022 18:32:11 +0530
Message-Id: <20220224130211.1346088-18-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220224130211.1346088-1-chandan.babu@oracle.com>
References: <20220224130211.1346088-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0009.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::18) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e368d71-06d9-469a-5a80-08d9f796048e
X-MS-TrafficTypeDiagnostic: SA2PR10MB4634:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB4634A8CB690D07D294DAAD7AF63D9@SA2PR10MB4634.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ksGWvcl9jAOE6uGU4WMCjB1XdcF4i3sjIBufCE0M8Q3Ijek/2fpBVGiIyJ+cjo497qJid9Q9Us0lKXbGGc2N+poxk16epeh4ooU5+6X9iJyxNctaK4XGU3F+wI8+K6X7XuL7+gwI6/MmTMbMT5jk7U232FX6zLrdTtoHRy8NEc86Y8FWEc+IxyeAeNOpVBJFeokvVKXgY+RXTKZsQZn4sgstOpoP8Uqsj+BmIuyjI3DjcqEfHvgGczaC7tZGgdLmqjWfPKcJ+kR2LNRGnpIYy8Xb0bGuRWF0p6oSQJkit7hlI5tcii6Bo9GczOz3D6EcmnQvRL4tTnStYZdUAWAy7GcJf3r50BvKMa2JxA3u/UzMFYtYQcw7/S/WPpKMhO1bJAXmPz98TlIp1r4tQflAhhRNnzawtVN59oOGueh/A9KRBEbMnuAxVVQ01M7Zewt4EZGkglsreF/e2eNaZZrE451jOPw8lpPdIbblH8tFKjTV8aOZ9OYrjfs5I11vWEef7Mxu5fASpkB/NpRT9c8RULCHM4iNCT9BrZKO1ZeE4pSNBdZvHGAjS5ekk1WWLYefcOH1gvIOOR7WNxXYOaYg0kaCJ34/GC72d1erisxtirvXJkfWV7NXCQRF+5HzXGHcpqyLi10kP+LSzQ67r4geMnSrv//HfQCb17hOsLzMIio0ga/wxXgCYML57AlFrCUvWrolAPi78PryjoQqK+Og/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(66556008)(6666004)(38100700002)(38350700002)(508600001)(6486002)(66946007)(8676002)(4326008)(86362001)(66476007)(6916009)(1076003)(316002)(8936002)(36756003)(5660300002)(83380400001)(2616005)(186003)(26005)(6506007)(6512007)(52116002)(30864003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XuNYAh2DFw/C+pxynMiwgN+qhL9kX8qCQQ5NuJBRaWpULy7+Mvz/2xF7nTjZ?=
 =?us-ascii?Q?UPn9ptAZ7bUvyFgNdsUsHTcUNLQ4dztTHEzQwnPrq2ota1Gms4WuUCW1U8o9?=
 =?us-ascii?Q?xQBHYrbyAZhRR8yCSBK851cxUXyXM9U/3JA2VuHAIXC/u4TvcdejsO9lrx1a?=
 =?us-ascii?Q?wm82QKKmR17/C+jwc0mkEwXPfcafP/lUv2TUoagiq7bFq5pvbvA/DAF4zgq5?=
 =?us-ascii?Q?VLXpn342wglKM+xR9JFUNldF42DIAxeSsb/qB17JaDdThiodRYnRfygDXj2j?=
 =?us-ascii?Q?dEYvD18K9kjmt9Yvs8VUfgtSQcHQOogk0Mh6PSd62LpEY7RnAz8QRVOy1bhI?=
 =?us-ascii?Q?orQdKI/zbpQXyVwBmXG9uF6Oareu+uP3i4SYMjM15oTHmQ3apY4+EmcThoRN?=
 =?us-ascii?Q?44rZ65NPqkwEyeqT+BcwnU34U2e/Jwzj/2miZEcFk0jEEEdVETqdQ4kqmDBz?=
 =?us-ascii?Q?udIf/YEHLWYFeu5Bc6DwiMyIFmNOEdfkmwWSfc1Ma+uED/xE077g34FVsd3O?=
 =?us-ascii?Q?NeaVTDN6IkX8TAGzwIeXQrq3Du5UDojQ6FOicAirnqhflN4eqQVvweDuHMwJ?=
 =?us-ascii?Q?yJFtGjHJLIsUHCnVl8nucimPLMRTa19wgFMJcfUi18wsfy2xMI5hbKJPZ+sg?=
 =?us-ascii?Q?uPyK0SNrg2z5Igh1aYhM6XpwH+LBA4y6CMB1sNAvwb4KrSuVC3a0tpjGmvBD?=
 =?us-ascii?Q?KwdObpxUrcZ54vXFNDhE6+wY/mVlO75Jkn8PPitqgOg76SnYNXs2hbVewzgG?=
 =?us-ascii?Q?1J2JRtm6YNJS6FZPZr0WVGNWzOCHoS2Se+xgRH3vOCwzSrLedWG3Vul1N/nN?=
 =?us-ascii?Q?Qxj20ceOPyDmJYwAnjzGn9LIlnpaDuZCULsHddAP0GmawpFfy8wRNMnUOKwN?=
 =?us-ascii?Q?CTgkjHxKSBvtIXu3Ss9UiKaK1Q7sWTnGDSy5lJVYt1bjERl6Klao8GfXO0FE?=
 =?us-ascii?Q?mSo+1jXP2eEJj64t55680FRfwmxOViJq2CE1mXM750RmUOxtrC60URfEhk6L?=
 =?us-ascii?Q?jrljVofCtvFmyGwZwWKId6hvuGqTBD/ZabzkIdJNBx9ZAsZcPcFHEOmNiuj0?=
 =?us-ascii?Q?HDxXgieTjxxRcFbsGNPvGqWbk+b1SJ4+aVOeAFDm6UVfdOSU/vjcgPC+YMEl?=
 =?us-ascii?Q?irzEU8n5nLiiUKBpvNcDkpYktSUDs5ovHTYxCY1Vttr4YqCE2wu7sHXZpjsi?=
 =?us-ascii?Q?oldsPJ3s4FjhvqWcpdhEGL4eqssKnpwAxiI4QrwyEQLKwxK0pbJ9vQ5xuMoS?=
 =?us-ascii?Q?5awzugw9q1nDt+pPu8R8me4iHBrlvWh04Ozh5kMLp3vmQeKAKc+TID/XzZF0?=
 =?us-ascii?Q?iMt8qYn+mzBK85ZB+JQuKKzuiv25qr0Ubins/3K3mVPVD8s/L7a9vCkwhDKh?=
 =?us-ascii?Q?z0f7Ilf5L7TsiK4C/UDMqXQlWA1GMmQ7m1/OnpiIrS6VNZZ2iUkf+9DGQtzg?=
 =?us-ascii?Q?tHRUD+8ZpvYuMbtp5n4pfBCQqy1rmLDM58OfAY5YxtltFxYWXxgqdKX51gxQ?=
 =?us-ascii?Q?0pgWf5CXuPg6DCORKBY5mi+2E7kuzDBPVAGrkZ9mMYXKt6jzThkzMOn4Ue0+?=
 =?us-ascii?Q?BTPenZz/ArKNAcpMQ7ZtTILKaUqj3d5383LZZawjSqc2/AwJN4rWBOYbTUUA?=
 =?us-ascii?Q?AjAnTBzDuJFUyywX+cMKal8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e368d71-06d9-469a-5a80-08d9f796048e
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:03:15.4633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nR1LvZsLy9L1MfTTm7BV339nnObq4UNn0m8xwDKEewuOeZpZRIe80oc5pN9c/SEBdHTa9lr2aAzScL3i8tOeTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4634
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202240078
X-Proofpoint-GUID: JUiq4Ja1tnAW8Dq4g8yItI56IyIkbeZT
X-Proofpoint-ORIG-GUID: JUiq4Ja1tnAW8Dq4g8yItI56IyIkbeZT
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

