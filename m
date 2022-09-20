Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5F74C54EE9
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Sep 2022 12:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiITMtL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Sep 2022 08:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbiITMtK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Sep 2022 08:49:10 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413436C115
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2022 05:49:09 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KAA0N5024554;
        Tue, 20 Sep 2022 12:49:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=qHk0q8PABHBBA1CeTXQ3C3YFifcVVCJvCLoXW3zH8HQ=;
 b=vJ++qavy7MmwX/qR7XQygX/P2IfuTp+woWM/Ta8syzFVZ5hGPmu4hVBcpNLA35M0ltlE
 HDaDDEbAf4IQV5EWwobwvcbkkNt1xRk2F2Fe+ID2q29fYdPy9uSM7GnaBucTm+hpdBC5
 IsJi4SYJgfpfXK/C4P4cRhok45QH3Ua5+IhnHpMYiwDZoKc40PkrJc5tdhO29BCKyaSm
 REWOxmnTLhw7HEkdAoZtgBbGaD/q+rqDH1EAXUPg7oZU8repmAK5AcNukLxTe++9Kmv9
 tG2Jfz0SPcNlFDP23Y69QHP+AiiTVLu1DD2PhKFqkIQcmkuJaniprElJraS1ctooQHCJ Dw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn6stexee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:49:05 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28KArnRR022942;
        Tue, 20 Sep 2022 12:49:04 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39qh1hd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:49:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MV7KiO+paUBykv1dAFvg/mbPoilRX3dBBYxA7V2yUVSaHfmaM4nl6SLAPaEa1CI6cljEGuMRqNpndjWYhXwmqv9AN0FCxUoAF7EG8LkXDVt4T6fUCWhhfTzgy/33nHbYLiJ9PO1r2P25lF6xbcBLtbOtjAvVDTwz//P8v3fxEA+iLrgl69q582Nogwy3k4qGz/t6h8vd3DGDUMl2Hhy/guUbCZix7Xxqt5KciCk8BWj6VTvcP0HYY1/5BZN2eaBEfgrA2IxuUVnFr42KzluxNXDEnxHS9eYX7maccajMp0RAIbJK52UN32bvosPi17+hGOiX8sft0Xu1G2cJM6cGjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qHk0q8PABHBBA1CeTXQ3C3YFifcVVCJvCLoXW3zH8HQ=;
 b=OYZPak9S7kCZmY3UD4zVsQfzt+RyP7+euogej6eFtp0PkvV4SanAFsyy4N+ER1vFfNWbrUleXhHhn0Vbw9ZPuK5///wOH4m7uaMkirTDBFab7tO6o/ihGqJDm15hcapotcK8or7iHXt8bNYF1v5Ea4q6+FJBr54GAhhgXP/6SBPXo5IYV1IxmQjGYm6Tv2dgthF941p3dn2NBkq4VLZsdIeXZcFg2C68bAbJfbOtthP1rXJnm5UAzFTNB1Jvqg/FwtdyHpsfsxnoso21buJQlf2L+6FSwOfO4nzAfPW4i1mkDqYV68XnUZ4K/xyKBr0bs9ezZOZKgpVJFlhTD872bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qHk0q8PABHBBA1CeTXQ3C3YFifcVVCJvCLoXW3zH8HQ=;
 b=cXrMCFkoPuuROOHqJtmf+alTqw7VWhd+ZzxIGJjC/9pWuKqVcYTALuYj4VWT3JlQ0NyzeIJus1sdRvakWI6Viy4O0vYid7FGJIT1yYEaEk49DrTrHHqkSQIFKU5UgIPXY7ju8bLcvY/U7uhLzZwKzMBT67oJAKEMopyFQoiJzS4=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB4987.namprd10.prod.outlook.com (2603:10b6:610:c1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Tue, 20 Sep
 2022 12:49:03 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 12:49:03 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE V2 03/17] xfs: replace -EIO with -EFSCORRUPTED for corrupt metadata
Date:   Tue, 20 Sep 2022 18:18:22 +0530
Message-Id: <20220920124836.1914918-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220920124836.1914918-1-chandan.babu@oracle.com>
References: <20220920124836.1914918-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0004.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::23) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB4987:EE_
X-MS-Office365-Filtering-Correlation-Id: 98a217ea-9b4b-4127-2333-08da9b067ec7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jvWzHp3h7MyuUfCL/bTp2TpNKOJ9r9llqYB7Oru8Z5OuXYcAgFBVGaIk9rwP4r9wQ2yqSuN9T515ZMRb3TVmk7K2xhM0V08iCEs7l+Yh9pSqjmTdaBhhn1yA8I8OZrgi/mjFweKxZYoD9pWvnqdInclVl6V2cE26GYLT8MthQ/hfKJrpTv+FDs7B/hq8RebIwaQmvxP9XZMqVFw9L7CdVIbjKCjwa1vNFm4lMKeYyglAtWHEfSkmteknzk4jifduCwekdhEwrk0aPeFHOfWaKcM0Hk5Hyz2ifWolW3wtmhS5XlFTCGW6+xGS29Sut/+jN9JlWKZvX16jiHoWYXKsTHpFpEO5F9/wgdfAnSqnFfu3846OlMyppwc0/s265gAfQj2V2GlgHUp4jZUbs+1++tvkt0O7U/PGypZgxN67MBKy+L/YhIM3LjaADRCXpqngz8tPHJMdTLawPH00chEirvVtxawURNp5ucopoKtgc7X7Isfq3tJJ2m9tUCouFzm1lAr5saHukESh9WT05yoAtR3xlaKwKIkpFb+bgkM0Xvgv4AVtg6XdgVujkpIlkTtbWsEEvNJ0JZP5obzD9fldFKRJlVReOCloqyKWC+3iyB7UXoxWkR0kJrxqfBg3mcqK2DTlCVyy30YWpteNru2NiS2iWJsxpVg8NLfzuB3xzZzjTvp0tRCxAJ6EhXuCBm0h4cabLKev5J/9syLVCP+u+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(136003)(376002)(366004)(396003)(451199015)(66476007)(66556008)(66946007)(5660300002)(4326008)(86362001)(8936002)(6916009)(316002)(38100700002)(8676002)(83380400001)(41300700001)(6666004)(6506007)(6486002)(2616005)(478600001)(186003)(1076003)(6512007)(26005)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RdUOn/3yDaINF8YcdaFIN5J/mWDiL/SY1cRtBexBmar0fP70FKBBG4vwW2W/?=
 =?us-ascii?Q?u+UOnIw3VIUEV8wz3JgqR2p3Zpdi13aVcMZdPNp76i8PnNCVqvYpzQVPNa1N?=
 =?us-ascii?Q?e4TSqt5PV3zzRHxNVlywci86PLLvpOv+KGKAa2EPdFAk/T+NRqCySnUzJrox?=
 =?us-ascii?Q?QxWhunwmGItG5ZtNwGfOvAhHR8Q43C1zysHSe3smOlCt3T5NOVU4nZ0S21Ik?=
 =?us-ascii?Q?mQdg21HHQpddt5sSuppsvMO4YJexb2NY+bHoVNHTGorjmubdi8jToDB1Zrd6?=
 =?us-ascii?Q?01CaETrtJ1kebqM0HKW2cMKJ3x47j4xxm+GarlJwDpQ12yUcQq3DYB6mxBjV?=
 =?us-ascii?Q?BpmIkM4aoe6zhmzVRib1XehlC6wIVcZN3sv4cb+d2+DiMLFFHX9DeBli/WpB?=
 =?us-ascii?Q?aGc5Itrl9RYVMA4qvZYmFLLwcZMncPq/Nl70oCp3YfvKm1NqKEE2F8FMbE+5?=
 =?us-ascii?Q?W/U2ywk6YjBXMij91qEwOxyy2MJCMSdUwcUUL9mqgY4vviEsEmd1ITGgdNnV?=
 =?us-ascii?Q?rRtK5sXL/qLeWmPDw3j0UY9KVUE8aSly/9E/aLQddGclSG+l/DS4tAEwJftb?=
 =?us-ascii?Q?BrKBuIy6MJ+nZPKu+F/SaiNASFyYCJ3Dkot8rw9fynEzr16nw3N7LH1kbxEQ?=
 =?us-ascii?Q?TQPs+mpUmgFkNtcciF75z3mB1wdtxDhBhblKlVBxCC7/gpDvPwdu5k/2MvmA?=
 =?us-ascii?Q?lkbI2RYCWWlAA/gC67osf/y2wKWoY2L3jVosscKlE0yuBq4UgDa1EplDRvau?=
 =?us-ascii?Q?bAHhXqY41HVBByZWetkmqa9zWo1i/Wd/FLu7zQ6EKTj1GlIVNTzDHVefx7qH?=
 =?us-ascii?Q?SR+xCigp87h7qxoADW7IAURFLpDLHjrUl03M8QzzaK2WPkChr1bPhwXLQ3fc?=
 =?us-ascii?Q?6kuN8YNJl587afsiPy03DlfRR+mV7K2oiMrSjXPyUabzzFphIvSSiX5bsPjG?=
 =?us-ascii?Q?son3Vl5Cj/P5GBbtxX7idHtRRQHKK8i7f+KZ3kclTWXE4xJFCp8kWWo0amTk?=
 =?us-ascii?Q?1Se0qe+DcaffCwy5oTb1qy3PWvyg8ydk4YRRQH3SkXOiJ5qHdn6LPvVm/lrj?=
 =?us-ascii?Q?azNoOUySozdXP7oBEXL9gj4xiF96pdh4c3/a28Pbb8Pl40srSY16It1lTGCn?=
 =?us-ascii?Q?L69evHx0CFGSvKHnK3COIBT6mVlyMtjvNRk8T+GY1bf7U5iMYnJbODHWd0y8?=
 =?us-ascii?Q?x2f+aZDTYFwFFaPtwrHus3KWhm8Kk2zTYujJrXZoOJy1kPuH8rswT2NV9voD?=
 =?us-ascii?Q?R8HIYPILNVKKupluEpBSet6G+FwX4v4K7l/8A057RCX1Ubf6XCuAIRsFJ6pX?=
 =?us-ascii?Q?e2jJurWA+O4TCaFzF+/f9ElnDaGG0OnDHciNNLpUoG6YoThdEPwf9XOh27tZ?=
 =?us-ascii?Q?/zzhgZFFA7LWrJjrE6fZSpo+ucXyOgYjBoVGBGXcUcXqW2jSKjZFho+LDBJh?=
 =?us-ascii?Q?eOO+AEQyrrtYHGjSbsxlHvZr9CPKEEv3csAOSBqFGFcNh3M0rCn/76MfIQwB?=
 =?us-ascii?Q?IZRZRqLg8s4DCrwhPI1lkTj/qwn9pu2f0rReIZPRZOpfmxSkFnvxZadKSBw7?=
 =?us-ascii?Q?VfHbw6dhv9iy1OkBRk/rHq0Hg9tAisAaen+39qGt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98a217ea-9b4b-4127-2333-08da9b067ec7
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 12:49:02.9497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UFRZcQov7Unn/Rhk02Og6l0qUzFtzosp9KeqkiYKIzoLDdUcM94411hVSBaTYpVBkZSpKQC77WwyiYPUAtOppQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4987
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_04,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209200076
X-Proofpoint-GUID: JX1hVKfJDY0wZbNf63WM3ek-5X2fPR8L
X-Proofpoint-ORIG-GUID: JX1hVKfJDY0wZbNf63WM3ek-5X2fPR8L
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit c2414ad6e66ab96b867309454498f7fb29b7e855 upstream.

There are a few places where we return -EIO instead of -EFSCORRUPTED
when we find corrupt metadata.  Fix those places.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c   | 6 +++---
 fs/xfs/xfs_attr_inactive.c | 6 +++---
 fs/xfs/xfs_dquot.c         | 2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c114d24be619..de4e71725b2c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1374,7 +1374,7 @@ xfs_bmap_last_before(
 	case XFS_DINODE_FMT_EXTENTS:
 		break;
 	default:
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
@@ -1475,7 +1475,7 @@ xfs_bmap_last_offset(
 
 	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE &&
 	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS)
-	       return -EIO;
+		return -EFSCORRUPTED;
 
 	error = xfs_bmap_last_extent(NULL, ip, whichfork, &rec, &is_empty);
 	if (error || is_empty)
@@ -5872,7 +5872,7 @@ xfs_bmap_insert_extents(
 				del_cursor);
 
 	if (stop_fsb >= got.br_startoff + got.br_blockcount) {
-		error = -EIO;
+		error = -EFSCORRUPTED;
 		goto del_cursor;
 	}
 
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index a640a285cc52..f83f11d929e4 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -209,7 +209,7 @@ xfs_attr3_node_inactive(
 	 */
 	if (level > XFS_DA_NODE_MAXDEPTH) {
 		xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	node = bp->b_addr;
@@ -258,7 +258,7 @@ xfs_attr3_node_inactive(
 			error = xfs_attr3_leaf_inactive(trans, dp, child_bp);
 			break;
 		default:
-			error = -EIO;
+			error = -EFSCORRUPTED;
 			xfs_trans_brelse(*trans, child_bp);
 			break;
 		}
@@ -341,7 +341,7 @@ xfs_attr3_root_inactive(
 		error = xfs_attr3_leaf_inactive(trans, dp, bp);
 		break;
 	default:
-		error = -EIO;
+		error = -EFSCORRUPTED;
 		xfs_trans_brelse(*trans, bp);
 		break;
 	}
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 3cbf248af51f..aa5084180270 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1125,7 +1125,7 @@ xfs_qm_dqflush(
 		xfs_buf_relse(bp);
 		xfs_dqfunlock(dqp);
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	/* This is the only portion of data that needs to persist */
-- 
2.35.1

