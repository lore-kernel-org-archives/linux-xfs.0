Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C1EFC4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234748AbiBXNEq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:04:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234755AbiBXNEq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:04:46 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FB7230E67
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:04:15 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYIAW000620;
        Thu, 24 Feb 2022 13:04:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=FH7qW8uToFPySZmBHjMUAUD0ZerDqw5dJwpvXkcfF+k=;
 b=pnyWTklLBms/vP8fmcafo9gD4bUw6xE0WOjATm5c5uE7S3ziCxkkP5B5b5rS19j0e/x9
 T11kG1TcUmHv3DinJyoPf3CVAgt9diXlUy3O2rcpIph+DUq8sLUUEalGentR+Uu3oumb
 T/oloZbP9PLtYDJK7pUlmfe1PwdZRYsqobAijsPwEx9zz+AdlPusT8+3ZCyGuZ/LJcPw
 E/WCq6+D/HrvCkHWICe5XKqrafmYRAExLqeQ6SHLb7EwJ8khdaYhJn20YPApemb8Ikzv
 xHGPewor9m3xw7poZRNSQgbHwWCgcqMnl/rm/96mhdvzcPUxUHICWACIibyP01rCN7c0 ZA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ecv6ey5tp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD0wJQ002441;
        Thu, 24 Feb 2022 13:04:10 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by aserp3030.oracle.com with ESMTP id 3eapkk43kb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fJEV9KYW9vSlZzUwR2guxeGeobpENzEKPGCgC/m8sMyc5aALo+Rlj+cN/wCcdMXtyFchLlUo21pMcGeyrJD1b7k3bsu6EAktUvjPQ5Mc6XBFBYBJTn5M7GeNGm5EYdCptl+AqPl3k4sG1jZJUna8dXLDrJk6EUXi51QMg1bJ70vGLwQGKj1I+Gojhh9UiFqy+58bIxorIGeR7Tx5VjTgXXmO+ZxwNaJtzSNrt4qGsqDkvhdOkG9TE1ylYwJmcBjuO48Ef+Bn6IJYebVMKeaj0toAJX2ZNW4R4Ki54zJ28fU27s4SJrUNfmOHih+EvE2kNQitLriKYtWC8kH8XcceGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FH7qW8uToFPySZmBHjMUAUD0ZerDqw5dJwpvXkcfF+k=;
 b=IWuKMOuSBeIwXRyf/zh9BpBvFQqZ+M2lu1KMRV8GniabpNhx90mNy5Md3/VhOCSujGKrCbdmrcDu0bSwEREQYqmv4Szzc5f/V1eTxf2uqoOmokAdr2osmNvbEEK3CjPzLD8DiJO97gL31bcVlPA61+St0fysnMIqq8pMaJLTcqGGrFj59hXRmh6e6YJz7J2dIP3Ddp5qTjaJy/+oC8V40yovnc0PDYDKF2100ptIM5RAvahrrVz2tg3UWwOgVV7VNVNzoupArvxu7SdHg+2wwA4FvH36YVqL9tO0s8a+ZZZBZwyeDs+lUq4GWboPieHuobdbNaqw94B+Xm/PL0rlDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FH7qW8uToFPySZmBHjMUAUD0ZerDqw5dJwpvXkcfF+k=;
 b=dG/B/3hYSJ5SYhOkMP25fEgsj/3iykv+T0VB8KtVMh1phUjqce9E0J6o0fHHOevHHtQu2/HFHf9KkPt5idkemg9kJ/BpEK8RhJnEPTEgSKtVamwfHGMyM+rzIcgI77rD3p5/ayAViXEQXE//L3atzaKyzS4sYAgs6ta44adiIAg=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4634.namprd10.prod.outlook.com (2603:10b6:806:114::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Thu, 24 Feb
 2022 13:04:08 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:04:08 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 05/19] xfsprogs: Introduce xfs_dfork_nextents() helper
Date:   Thu, 24 Feb 2022 18:33:26 +0530
Message-Id: <20220224130340.1349556-6-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1e04b84a-7506-4326-351c-08d9f7962499
X-MS-TrafficTypeDiagnostic: SA2PR10MB4634:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB46343ED927A97B21EE363888F63D9@SA2PR10MB4634.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fRHQwp6+T4072GtEfKrbfKfe5LnANh5abhmXHO9k7ECcsKovoiQRO+RKE/cMLcQjyhAF/8lzBKDtj0TGDJWaBGXg5Gh0owr+N1Kk6fd3Jouu+uu0SznNwhs+q8v8elwQICiPorMqzjV7zebYEe4SFEyMsh+okUhar4WLh9oXafT1CkkXmYH0qJycG8QsjIYDkvCatkQi9po+cQu8nAygSVJgDRK/1AjVae3x8Bttq6K2h7l40z6daeYSPmU+BSb4FtlC66WZhW5tqwENMAGLAlpyVAzeUrUdlVdGFPjdi3O+UIaEu74nviFZPx+eZcYyd0xQeZmE21EMmkm75FK/hGlHGbB1jy/Qu7GzV0lklVlKEx2oDQ+aTJ9S1VQCVCjf96ZIi9w8pz+HaaF4MuEvuXMl1cyGNgkb26CMYVjoahG41DZTiJ+hmtPxlwnukYRETXTbKTWVYMJDixk0jcLaiJc1MvQGnzwIV/sdWSUqMOcmT8W3IlXQz3NDBEcamf+HwHjoHveuAhi3ah4cOf+dpOj2RSsdofK0Kj/fK58tT0h2AO8eexEsMC+bawXSCHz+uZju5lArxKOMzdqXxlssWyp/Q4Ero58TP0cY8goUgaABty6czFkoBFOZBM09I6It7rHqvvHBB1oJ3onrYYOv0zgRBa0aDzuJN5to4OjG2yMUHWTwbfIZy8OhrlWABRDyqE2rR3ANSGOZh0VNqXug3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(66556008)(6666004)(38100700002)(38350700002)(508600001)(6486002)(66946007)(8676002)(4326008)(86362001)(66476007)(6916009)(1076003)(316002)(8936002)(36756003)(5660300002)(83380400001)(2616005)(186003)(26005)(6506007)(6512007)(52116002)(30864003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4TWLBb7pzK+z1JNrQkggg6fuURFkrZiRS6Rim9g4/VParzg7+xUZ3mStUwz+?=
 =?us-ascii?Q?fiiXeoOpqGfRX1oqMGBxGUbJjJaPqBrZ0xk0jB62p+RLP3ISOyMWbxF44aO6?=
 =?us-ascii?Q?/PULs1mDchfMNbJVI+UnUJi+v3Gj0R0aegA/92RsWofFUq9ITmAhq+aQvuGK?=
 =?us-ascii?Q?yXclNLaTpQRpoP6T7xir/QVntIe9OlmAqX9cgQKEMub6joDjH5dkF/xLzBix?=
 =?us-ascii?Q?UOIINF92Z3xnpoj8mE654b441df+W0Vb4GqL9R8eONbjCquMlpbewEo3HY+e?=
 =?us-ascii?Q?RTWvLXQm4P0CEFJ983n9yR656q/HLlQDgy1yDwQxEHIsbw8gGAg1EHsi8enU?=
 =?us-ascii?Q?nFaETjZQiSmXmjhWyKIo/vMs9TRf4pw5CW0KUw3lHqRslV+5vzYxq/fHHQEI?=
 =?us-ascii?Q?xMO0ab29p/S8TrsVAsp/yAT8/f5EFkqQEDX7udT7I9BYuIBtXjPpxNK3KFng?=
 =?us-ascii?Q?K4rsTb5XMtEUbe+PQ0YkY/sq3Jmzzv+MrYuQCFHTgcNJWp5YCG5KIHJ8blmF?=
 =?us-ascii?Q?Zr5YbfWSkKweEePAPDkZNK7oHEvkddZZwfd6Mb47p5TIJfOnxLLsawueBJsS?=
 =?us-ascii?Q?GbTmRF03o7SysuIygHJ2KopLoLiN+GGy2uPVPgzDc0NLcHCkSG/uyV6CRIu2?=
 =?us-ascii?Q?ouP0d5WF0NyyMxPL4P7Ug/o9Wsa/722c3CVysMOvv6UQ93CaUSQovcMy/Q8i?=
 =?us-ascii?Q?FylIYgRd09sl/158QnkWMm0+cpuKf7Lz/7AhgLbdf7BzvbD9AZiDsGeqVV+I?=
 =?us-ascii?Q?+KFDg6Av8gKEr9bwCOL2XmEVMIHtG2l+3G1NV7REuNPDgptltpcveG7WeDCc?=
 =?us-ascii?Q?oL3xKuC93giicIBLUA+9kro3DLsvyGgctP1II9qkdgLrNijD6Zr+rtIta+mH?=
 =?us-ascii?Q?vGo/Hvw/hl6XRjzOoln6BTaGbIX+5Q2d2NHeJIP6Rqs5eilQL5lwUyPRzaZE?=
 =?us-ascii?Q?38epBK+Yn/Kh/nLawyxyWfTBaVY1oYhbyandezHAN5uib20Cr6rab2pA1Vnh?=
 =?us-ascii?Q?LioF8/D37AF3T8ZLHeR4VK3RZOsYC8obGA3brXei+KB4wkmV+w5iFEXGMxS9?=
 =?us-ascii?Q?PeY3Zllzi2c0qp7t9ikeLA9//UCK197ItkGJJBflnFGEHepWCqyP2oC4nb4z?=
 =?us-ascii?Q?I5emqP5prHwK8JEjEk2mIDjFOaQr0avlLBapm/8Beza1/eF6qM9q8JHlDX6m?=
 =?us-ascii?Q?J2fLuzzvBRQkUOThTzFEVNgt3OvMCWpqMDnV8kTJiR0RUruE18Pj9DLgEpek?=
 =?us-ascii?Q?AOFfxxZhn87E1u+tv9JprVFxnREizTrO70mSVamM/+qVWPNEblD/zFGLFVWp?=
 =?us-ascii?Q?hZpJJ4i12bAyqkoHNS75MFmh5kuMW6/VD4GHQ+XLD9gzBUh1a+TLLFv0+QB+?=
 =?us-ascii?Q?0IR8f0TDP6abnu8F4lM7Bg3ChjYAJ5YDE6ZCtQ2VtULt+7aNKLn3D21cV1a/?=
 =?us-ascii?Q?0bheyKCNq7SbeDjWpUeLg7VRsA6FeRSbK2byyriu4HvCKQPOyCtYd/8HadZ/?=
 =?us-ascii?Q?qHCYSyhwX/TY+FDi/4wOsDaDC3lQ3ymD3aKPjrKtMQGtVHnFWzCtRs/Gu4Zb?=
 =?us-ascii?Q?1R7l6xqf3LRGuEBmzDEVwvgfChLvxKS8akSyKfisr6+FbJWdk5uC6Wl848ke?=
 =?us-ascii?Q?o0T+3DaeTacntjPoKm72oCs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e04b84a-7506-4326-351c-08d9f7962499
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:04:08.4572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4kxYW35dD5cOvg3Sn2TcVLz0fF2qCzdRQengHGEqyxoR+tAr3kLQ8x1IcKPlhnhonCX6u6KiyvtkC3l4epVIUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4634
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202240078
X-Proofpoint-GUID: HAK3KF1XQx1tG4eCQVDvImsu6u4RhyH5
X-Proofpoint-ORIG-GUID: HAK3KF1XQx1tG4eCQVDvImsu6u4RhyH5
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit replaces the macro XFS_DFORK_NEXTENTS() with the helper function
xfs_dfork_nextents(). As of this commit, xfs_dfork_nextents() returns the same
value as XFS_DFORK_NEXTENTS(). A future commit which extends inode's extent
counter fields will add more logic to this helper.

This commit also replaces direct accesses to xfs_dinode->di_[a]nextents
with calls to xfs_dfork_nextents().

No functional changes have been made.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/bmap.c               |  6 ++---
 db/btdump.c             |  4 ++--
 db/check.c              | 28 +++++++++++++---------
 db/frag.c               |  6 +++--
 db/inode.c              | 16 +++++++------
 db/metadump.c           |  4 ++--
 libxfs/xfs_format.h     |  4 ----
 libxfs/xfs_inode_buf.c  | 16 +++++++++----
 libxfs/xfs_inode_fork.c |  9 +++----
 libxfs/xfs_inode_fork.h | 32 +++++++++++++++++++++++++
 repair/attr_repair.c    |  2 +-
 repair/dinode.c         | 53 +++++++++++++++++++++++------------------
 repair/prefetch.c       |  2 +-
 13 files changed, 117 insertions(+), 65 deletions(-)

diff --git a/db/bmap.c b/db/bmap.c
index 8fa623bc..d0c0ebac 100644
--- a/db/bmap.c
+++ b/db/bmap.c
@@ -68,7 +68,7 @@ bmap(
 	ASSERT(fmt == XFS_DINODE_FMT_LOCAL || fmt == XFS_DINODE_FMT_EXTENTS ||
 		fmt == XFS_DINODE_FMT_BTREE);
 	if (fmt == XFS_DINODE_FMT_EXTENTS) {
-		nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+		nextents = xfs_dfork_nextents(dip, whichfork);
 		xp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
 		for (ep = xp; ep < &xp[nextents] && n < nex; ep++) {
 			if (!bmap_one_extent(ep, &curoffset, eoffset, &n, bep))
@@ -158,9 +158,9 @@ bmap_f(
 		push_cur();
 		set_cur_inode(iocur_top->ino);
 		dip = iocur_top->data;
-		if (be32_to_cpu(dip->di_nextents))
+		if (xfs_dfork_data_extents(dip))
 			dfork = 1;
-		if (be16_to_cpu(dip->di_anextents))
+		if (xfs_dfork_attr_extents(dip))
 			afork = 1;
 		pop_cur();
 	}
diff --git a/db/btdump.c b/db/btdump.c
index cb9ca082..81642cde 100644
--- a/db/btdump.c
+++ b/db/btdump.c
@@ -166,13 +166,13 @@ dump_inode(
 
 	dip = iocur_top->data;
 	if (attrfork) {
-		if (!dip->di_anextents ||
+		if (!xfs_dfork_attr_extents(dip) ||
 		    dip->di_aformat != XFS_DINODE_FMT_BTREE) {
 			dbprintf(_("attr fork not in btree format\n"));
 			return 0;
 		}
 	} else {
-		if (!dip->di_nextents ||
+		if (!xfs_dfork_data_extents(dip) ||
 		    dip->di_format != XFS_DINODE_FMT_BTREE) {
 			dbprintf(_("data fork not in btree format\n"));
 			return 0;
diff --git a/db/check.c b/db/check.c
index 654631a5..1fdc1817 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2713,7 +2713,7 @@ process_exinode(
 	xfs_bmbt_rec_t		*rp;
 
 	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
-	*nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	*nex = xfs_dfork_nextents(dip, whichfork);
 	if (*nex < 0 || *nex > XFS_DFORK_SIZE(dip, mp, whichfork) /
 						sizeof(xfs_bmbt_rec_t)) {
 		if (!sflag || id->ilist)
@@ -2737,12 +2737,14 @@ process_inode(
 	inodata_t		*id = NULL;
 	xfs_ino_t		ino;
 	xfs_extnum_t		nextents = 0;
+	xfs_extnum_t		dnextents;
 	int			security;
 	xfs_rfsblock_t		totblocks;
 	xfs_rfsblock_t		totdblocks = 0;
 	xfs_rfsblock_t		totiblocks = 0;
 	dbm_t			type;
 	xfs_extnum_t		anextents = 0;
+	xfs_extnum_t		danextents;
 	xfs_rfsblock_t		atotdblocks = 0;
 	xfs_rfsblock_t		atotiblocks = 0;
 	xfs_qcnt_t		bc = 0;
@@ -2871,14 +2873,17 @@ process_inode(
 		error++;
 		return;
 	}
+
+	dnextents = xfs_dfork_data_extents(dip);
+	danextents = xfs_dfork_attr_extents(dip);
+
 	if (verbose || (id && id->ilist) || CHECK_BLIST(bno))
 		dbprintf(_("inode %lld mode %#o fmt %s "
 			 "afmt %s "
 			 "nex %d anex %d nblk %lld sz %lld%s%s%s%s%s%s%s\n"),
 			id->ino, mode, fmtnames[(int)dip->di_format],
 			fmtnames[(int)dip->di_aformat],
-			be32_to_cpu(dip->di_nextents),
-			be16_to_cpu(dip->di_anextents),
+			dnextents, danextents,
 			be64_to_cpu(dip->di_nblocks), be64_to_cpu(dip->di_size),
 			diflags & XFS_DIFLAG_REALTIME ? " rt" : "",
 			diflags & XFS_DIFLAG_PREALLOC ? " pre" : "",
@@ -2893,25 +2898,26 @@ process_inode(
 		type = DBM_DIR;
 		if (dip->di_format == XFS_DINODE_FMT_LOCAL)
 			break;
-		blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
+
+		blkmap = blkmap_alloc(dnextents);
 		break;
 	case S_IFREG:
 		if (diflags & XFS_DIFLAG_REALTIME)
 			type = DBM_RTDATA;
 		else if (id->ino == mp->m_sb.sb_rbmino) {
 			type = DBM_RTBITMAP;
-			blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
+			blkmap = blkmap_alloc(dnextents);
 			addlink_inode(id);
 		} else if (id->ino == mp->m_sb.sb_rsumino) {
 			type = DBM_RTSUM;
-			blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
+			blkmap = blkmap_alloc(dnextents);
 			addlink_inode(id);
 		}
 		else if (id->ino == mp->m_sb.sb_uquotino ||
 			 id->ino == mp->m_sb.sb_gquotino ||
 			 id->ino == mp->m_sb.sb_pquotino) {
 			type = DBM_QUOTA;
-			blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
+			blkmap = blkmap_alloc(dnextents);
 			addlink_inode(id);
 		}
 		else
@@ -2993,17 +2999,17 @@ process_inode(
 				be64_to_cpu(dip->di_nblocks), id->ino, totblocks);
 		error++;
 	}
-	if (nextents != be32_to_cpu(dip->di_nextents)) {
+	if (nextents != dnextents) {
 		if (v)
 			dbprintf(_("bad nextents %d for inode %lld, counted %d\n"),
-				be32_to_cpu(dip->di_nextents), id->ino, nextents);
+				dnextents, id->ino, nextents);
 		error++;
 	}
-	if (anextents != be16_to_cpu(dip->di_anextents)) {
+	if (anextents != danextents) {
 		if (v)
 			dbprintf(_("bad anextents %d for inode %lld, counted "
 				 "%d\n"),
-				be16_to_cpu(dip->di_anextents), id->ino, anextents);
+				danextents, id->ino, anextents);
 		error++;
 	}
 	if (type == DBM_DIR)
diff --git a/db/frag.c b/db/frag.c
index f30415f6..1d013686 100644
--- a/db/frag.c
+++ b/db/frag.c
@@ -262,9 +262,11 @@ process_exinode(
 	int			whichfork)
 {
 	xfs_bmbt_rec_t		*rp;
+	xfs_extnum_t		nextents;
 
 	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
-	process_bmbt_reclist(rp, XFS_DFORK_NEXTENTS(dip, whichfork), extmapp);
+	nextents = xfs_dfork_nextents(dip, whichfork);
+	process_bmbt_reclist(rp, nextents, extmapp);
 }
 
 static void
@@ -275,7 +277,7 @@ process_fork(
 	extmap_t	*extmap;
 	xfs_extnum_t	nex;
 
-	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	nex = xfs_dfork_nextents(dip, whichfork);
 	if (!nex)
 		return;
 	extmap = extmap_alloc(nex);
diff --git a/db/inode.c b/db/inode.c
index 083888d8..57cc127b 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -275,7 +275,7 @@ inode_a_bmx_count(
 		return 0;
 	ASSERT((char *)XFS_DFORK_APTR(dip) - (char *)dip == byteize(startoff));
 	return dip->di_aformat == XFS_DINODE_FMT_EXTENTS ?
-		be16_to_cpu(dip->di_anextents) : 0;
+		xfs_dfork_attr_extents(dip) : 0;
 }
 
 static int
@@ -328,7 +328,8 @@ inode_a_size(
 	int				idx)
 {
 	struct xfs_attr_shortform	*asf;
-	struct xfs_dinode			*dip;
+	struct xfs_dinode		*dip;
+	xfs_extnum_t			nextents;
 
 	ASSERT(startoff == 0);
 	ASSERT(idx == 0);
@@ -338,8 +339,8 @@ inode_a_size(
 		asf = (struct xfs_attr_shortform *)XFS_DFORK_APTR(dip);
 		return bitize(be16_to_cpu(asf->hdr.totsize));
 	case XFS_DINODE_FMT_EXTENTS:
-		return (int)be16_to_cpu(dip->di_anextents) *
-							bitsz(xfs_bmbt_rec_t);
+		nextents = xfs_dfork_attr_extents(dip);
+		return nextents * bitsz(struct xfs_bmbt_rec);
 	case XFS_DINODE_FMT_BTREE:
 		return bitize((int)XFS_DFORK_ASIZE(dip, mp));
 	default:
@@ -500,7 +501,7 @@ inode_u_bmx_count(
 	dip = obj;
 	ASSERT((char *)XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
 	return dip->di_format == XFS_DINODE_FMT_EXTENTS ?
-		be32_to_cpu(dip->di_nextents) : 0;
+		xfs_dfork_data_extents(dip) : 0;
 }
 
 static int
@@ -586,6 +587,7 @@ inode_u_size(
 	int		idx)
 {
 	struct xfs_dinode	*dip;
+	xfs_extnum_t		nextents;
 
 	ASSERT(startoff == 0);
 	ASSERT(idx == 0);
@@ -596,8 +598,8 @@ inode_u_size(
 	case XFS_DINODE_FMT_LOCAL:
 		return bitize((int)be64_to_cpu(dip->di_size));
 	case XFS_DINODE_FMT_EXTENTS:
-		return (int)be32_to_cpu(dip->di_nextents) *
-						bitsz(xfs_bmbt_rec_t);
+		nextents = xfs_dfork_data_extents(dip);
+		return nextents * bitsz(struct xfs_bmbt_rec);
 	case XFS_DINODE_FMT_BTREE:
 		return bitize((int)XFS_DFORK_DSIZE(dip, mp));
 	case XFS_DINODE_FMT_UUID:
diff --git a/db/metadump.c b/db/metadump.c
index 2993f06e..90b2979d 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2282,7 +2282,7 @@ process_exinode(
 
 	whichfork = (itype == TYP_ATTR) ? XFS_ATTR_FORK : XFS_DATA_FORK;
 
-	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	nex = xfs_dfork_nextents(dip, whichfork);
 	used = nex * sizeof(xfs_bmbt_rec_t);
 	if (nex < 0 || used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
 		if (show_warnings)
@@ -2335,7 +2335,7 @@ static int
 process_dev_inode(
 	struct xfs_dinode		*dip)
 {
-	if (XFS_DFORK_NEXTENTS(dip, XFS_DATA_FORK)) {
+	if (xfs_dfork_data_extents(dip)) {
 		if (show_warnings)
 			print_warning("inode %llu has unexpected extents",
 				      (unsigned long long)cur_ino);
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index d75e5b16..e5654b57 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -925,10 +925,6 @@ enum xfs_dinode_fmt {
 	((w) == XFS_DATA_FORK ? \
 		(dip)->di_format : \
 		(dip)->di_aformat)
-#define XFS_DFORK_NEXTENTS(dip,w) \
-	((w) == XFS_DATA_FORK ? \
-		be32_to_cpu((dip)->di_nextents) : \
-		be16_to_cpu((dip)->di_anextents))
 
 /*
  * For block and character special files the 32bit dev_t is stored at the
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index b15a0166..29204e4a 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -333,9 +333,11 @@ xfs_dinode_verify_fork(
 	struct xfs_mount	*mp,
 	int			whichfork)
 {
-	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		di_nextents;
 	xfs_extnum_t		max_extents;
 
+	di_nextents = xfs_dfork_nextents(dip, whichfork);
+
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
 	case XFS_DINODE_FMT_LOCAL:
 		/*
@@ -402,6 +404,8 @@ xfs_dinode_verify(
 	uint16_t		flags;
 	uint64_t		flags2;
 	uint64_t		di_size;
+	xfs_rfsblock_t		nblocks;
+	xfs_extnum_t            nextents;
 
 	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
 		return __this_address;
@@ -432,10 +436,12 @@ xfs_dinode_verify(
 	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
 		return __this_address;
 
+	nextents = xfs_dfork_data_extents(dip);
+	nextents += xfs_dfork_attr_extents(dip);
+	nblocks = be64_to_cpu(dip->di_nblocks);
+
 	/* Fork checks carried over from xfs_iformat_fork */
-	if (mode &&
-	    be32_to_cpu(dip->di_nextents) + be16_to_cpu(dip->di_anextents) >
-			be64_to_cpu(dip->di_nblocks))
+	if (mode && nextents > nblocks)
 		return __this_address;
 
 	if (mode && XFS_DFORK_BOFF(dip) > mp->m_sb.sb_inodesize)
@@ -492,7 +498,7 @@ xfs_dinode_verify(
 		default:
 			return __this_address;
 		}
-		if (dip->di_anextents)
+		if (xfs_dfork_attr_extents(dip))
 			return __this_address;
 	}
 
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 4d908a7a..14b29722 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -103,7 +103,7 @@ xfs_iformat_extents(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	int			state = xfs_bmap_fork_to_state(whichfork);
-	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		nex = xfs_dfork_nextents(dip, whichfork);
 	int			size = nex * sizeof(xfs_bmbt_rec_t);
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_rec	*dp;
@@ -228,7 +228,7 @@ xfs_iformat_data_fork(
 	 * depend on it.
 	 */
 	ip->i_df.if_format = dip->di_format;
-	ip->i_df.if_nextents = be32_to_cpu(dip->di_nextents);
+	ip->i_df.if_nextents = xfs_dfork_data_extents(dip);
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFIFO:
@@ -293,14 +293,15 @@ xfs_iformat_attr_fork(
 	struct xfs_inode	*ip,
 	struct xfs_dinode	*dip)
 {
+	xfs_extnum_t		naextents;
 	int			error = 0;
 
 	/*
 	 * Initialize the extent count early, as the per-format routines may
 	 * depend on it.
 	 */
-	ip->i_afp = xfs_ifork_alloc(dip->di_aformat,
-				be16_to_cpu(dip->di_anextents));
+	naextents = xfs_dfork_attr_extents(dip);
+	ip->i_afp = xfs_ifork_alloc(dip->di_aformat, naextents);
 
 	switch (ip->i_afp->if_format) {
 	case XFS_DINODE_FMT_LOCAL:
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 2605f7ff..7ed2ecb5 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -141,6 +141,38 @@ static inline xfs_extnum_t xfs_iext_max_nextents(int whichfork)
 	return MAXAEXTNUM;
 }
 
+static inline xfs_extnum_t
+xfs_dfork_data_extents(
+	struct xfs_dinode	*dip)
+{
+	return be32_to_cpu(dip->di_nextents);
+}
+
+static inline xfs_extnum_t
+xfs_dfork_attr_extents(
+	struct xfs_dinode	*dip)
+{
+	return be16_to_cpu(dip->di_anextents);
+}
+
+static inline xfs_extnum_t
+xfs_dfork_nextents(
+	struct xfs_dinode	*dip,
+	int			whichfork)
+{
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+		return xfs_dfork_data_extents(dip);
+	case XFS_ATTR_FORK:
+		return xfs_dfork_attr_extents(dip);
+	default:
+		ASSERT(0);
+		break;
+	}
+
+	return 0;
+}
+
 struct xfs_ifork *xfs_ifork_alloc(enum xfs_dinode_fmt format,
 				xfs_extnum_t nextents);
 struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 50c46619..954a2f1e 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -1083,7 +1083,7 @@ process_longform_attr(
 	bno = blkmap_get(blkmap, 0);
 	if (bno == NULLFSBLOCK) {
 		if (dip->di_aformat == XFS_DINODE_FMT_EXTENTS &&
-				be16_to_cpu(dip->di_anextents) == 0)
+			xfs_dfork_attr_extents(dip) == 0)
 			return(0); /* the kernel can handle this state */
 		do_warn(
 	_("block 0 of inode %" PRIu64 " attribute fork is missing\n"),
diff --git a/repair/dinode.c b/repair/dinode.c
index e0b654ab..386c39f6 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -68,7 +68,7 @@ _("clearing inode %" PRIu64 " attributes\n"), ino_num);
 		fprintf(stderr,
 _("would have cleared inode %" PRIu64 " attributes\n"), ino_num);
 
-	if (be16_to_cpu(dino->di_anextents) != 0)  {
+	if (xfs_dfork_attr_extents(dino) != 0) {
 		if (no_modify)
 			return(1);
 		dino->di_anextents = cpu_to_be16(0);
@@ -938,7 +938,7 @@ process_exinode(
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
 	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
 	*tot = 0;
-	numrecs = XFS_DFORK_NEXTENTS(dip, whichfork);
+	numrecs = xfs_dfork_nextents(dip, whichfork);
 
 	/*
 	 * We've already decided on the maximum number of extents on the inode,
@@ -1015,7 +1015,7 @@ process_symlink_extlist(xfs_mount_t *mp, xfs_ino_t lino, struct xfs_dinode *dino
 	xfs_fileoff_t		expected_offset;
 	xfs_bmbt_rec_t		*rp;
 	xfs_bmbt_irec_t		irec;
-	int			numrecs;
+	xfs_extnum_t		numrecs;
 	int			i;
 	int			max_blocks;
 
@@ -1037,7 +1037,7 @@ _("mismatch between format (%d) and size (%" PRId64 ") in symlink inode %" PRIu6
 	}
 
 	rp = (xfs_bmbt_rec_t *)XFS_DFORK_DPTR(dino);
-	numrecs = be32_to_cpu(dino->di_nextents);
+	numrecs = xfs_dfork_data_extents(dino);
 
 	/*
 	 * the max # of extents in a symlink inode is equal to the
@@ -1543,6 +1543,8 @@ process_check_sb_inodes(
 	int		*type,
 	int		*dirty)
 {
+	xfs_extnum_t	nextents;
+
 	if (lino == mp->m_sb.sb_rootino) {
 		if (*type != XR_INO_DIR)  {
 			do_warn(_("root inode %" PRIu64 " has bad type 0x%x\n"),
@@ -1597,10 +1599,12 @@ _("realtime summary inode %" PRIu64 " has bad type 0x%x, "),
 				do_warn(_("would reset to regular file\n"));
 			}
 		}
-		if (mp->m_sb.sb_rblocks == 0 && dinoc->di_nextents != 0)  {
+
+		nextents = xfs_dfork_data_extents(dinoc);
+		if (mp->m_sb.sb_rblocks == 0 && nextents != 0)  {
 			do_warn(
-_("bad # of extents (%u) for realtime summary inode %" PRIu64 "\n"),
-				be32_to_cpu(dinoc->di_nextents), lino);
+_("bad # of extents (%d) for realtime summary inode %" PRIu64 "\n"),
+				nextents, lino);
 			return 1;
 		}
 		return 0;
@@ -1618,10 +1622,12 @@ _("realtime bitmap inode %" PRIu64 " has bad type 0x%x, "),
 				do_warn(_("would reset to regular file\n"));
 			}
 		}
-		if (mp->m_sb.sb_rblocks == 0 && dinoc->di_nextents != 0)  {
+
+		nextents = xfs_dfork_data_extents(dinoc);
+		if (mp->m_sb.sb_rblocks == 0 && nextents != 0)  {
 			do_warn(
-_("bad # of extents (%u) for realtime bitmap inode %" PRIu64 "\n"),
-				be32_to_cpu(dinoc->di_nextents), lino);
+_("bad # of extents (%d) for realtime bitmap inode %" PRIu64 "\n"),
+				nextents, lino);
 			return 1;
 		}
 		return 0;
@@ -1780,6 +1786,8 @@ process_inode_blocks_and_extents(
 	xfs_ino_t	lino,
 	int		*dirty)
 {
+	xfs_extnum_t		dnextents;
+
 	if (nblocks != be64_to_cpu(dino->di_nblocks))  {
 		if (!no_modify)  {
 			do_warn(
@@ -1802,20 +1810,19 @@ _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			nextents, lino);
 		return 1;
 	}
-	if (nextents != be32_to_cpu(dino->di_nextents))  {
+
+	dnextents = xfs_dfork_data_extents(dino);
+	if (nextents != dnextents)  {
 		if (!no_modify)  {
 			do_warn(
 _("correcting nextents for inode %" PRIu64 ", was %d - counted %" PRIu64 "\n"),
-				lino,
-				be32_to_cpu(dino->di_nextents),
-				nextents);
+				lino, dnextents, nextents);
 			dino->di_nextents = cpu_to_be32(nextents);
 			*dirty = 1;
 		} else  {
 			do_warn(
 _("bad nextents %d for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
-				be32_to_cpu(dino->di_nextents),
-				lino, nextents);
+				dnextents, lino, nextents);
 		}
 	}
 
@@ -1825,19 +1832,19 @@ _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			anextents, lino);
 		return 1;
 	}
-	if (anextents != be16_to_cpu(dino->di_anextents))  {
+
+	dnextents = xfs_dfork_attr_extents(dino);
+	if (anextents != dnextents)  {
 		if (!no_modify)  {
 			do_warn(
 _("correcting anextents for inode %" PRIu64 ", was %d - counted %" PRIu64 "\n"),
-				lino,
-				be16_to_cpu(dino->di_anextents), anextents);
+				lino, dnextents, anextents);
 			dino->di_anextents = cpu_to_be16(anextents);
 			*dirty = 1;
 		} else  {
 			do_warn(
 _("bad anextents %d for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
-				be16_to_cpu(dino->di_anextents),
-				lino, anextents);
+				dnextents, lino, anextents);
 		}
 	}
 
@@ -1879,7 +1886,7 @@ process_inode_data_fork(
 	 * uses negative values in memory. hence if we see negative numbers
 	 * here, trash it!
 	 */
-	nex = be32_to_cpu(dino->di_nextents);
+	nex = xfs_dfork_data_extents(dino);
 	if (nex < 0)
 		*nextents = 1;
 	else
@@ -2000,7 +2007,7 @@ process_inode_attr_fork(
 		return 0;
 	}
 
-	*anextents = be16_to_cpu(dino->di_anextents);
+	*anextents = xfs_dfork_attr_extents(dino);
 	if (*anextents > be64_to_cpu(dino->di_nblocks))
 		*anextents = 1;
 
diff --git a/repair/prefetch.c b/repair/prefetch.c
index a1c69612..1a7a4eab 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -393,7 +393,7 @@ pf_read_exinode(
 	struct xfs_dinode		*dino)
 {
 	pf_read_bmbt_reclist(args, (xfs_bmbt_rec_t *)XFS_DFORK_DPTR(dino),
-			be32_to_cpu(dino->di_nextents));
+			xfs_dfork_data_extents(dino));
 }
 
 static void
-- 
2.30.2

