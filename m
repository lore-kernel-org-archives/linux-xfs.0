Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E432C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243430AbiCUFWT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbiCUFWR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:22:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616A53B3FD
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:20:53 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22KKn1Si008844;
        Mon, 21 Mar 2022 05:20:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=JI5SLFTJCQWn1foMdo9jv/v98rZmt/TKXagiVOZGs0Y=;
 b=di1w20VgBr4iptVyylk4kVI0yfYCCoaBObxGsn8GMB9kFuzMi7Zpvdgs8r3LkKFuBzkW
 U5RQ2IM7Nb+Z7re5+3YR+zdaUFQBzwjCsDCXneDAHJvmNJtoTeC87vxNd/KV4Ob+E550
 8LaK1ncFqrk3+TvjqhulnEk8mgrI6bIDdMI6hOSkbh3HxM/vB23E6GR3W6Y6ivdzY25C
 g1S28DUK13F/lXs02RjUIQpQ8S0GM3iihJ0owJHgbCPgOXXWoWp+ZIEqDh9u1HZ3Chzn
 DsY486ysZIiGyHBZD/J2ic7xLjeHmJYnOu2KeP7FDvBzaBDG38mFoGUZf/LHn9M5CCEM CQ== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew7qt22yb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:20:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5Kno4125191;
        Mon, 21 Mar 2022 05:20:49 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by aserp3030.oracle.com with ESMTP id 3ew578rnv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:20:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OaTHmGd5uxI6wyN/WPTmEJyKadQNplu0mUo33c3WiyRNl5Q3TZCL+oWvVbrAXrEsdTTkluPQFjz+/krfyQk7HFk1+2IbNj75geiiz+vzB0Sr4b6clmzJBUW2DAH7K02zh5y1g4wN+OPWqMxyT9kbvYhYB3zjDVtvZGcfuxQVZYhozDFtrvFdyUMbBQK1MBd/t7c8shIay/g/JX+Z/cmdAU2UbLZV0zWkKqhiMdHZ+4kCci8pRXSGDohdKExYYVPH1jw1fVYzOq501naZnzqlRnzvKRvPHgZWCHxLHocoq4cAr2oIhlkRBxKqNS4bT0BVzwQ5fqPYxKrlD4P+f9eMIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JI5SLFTJCQWn1foMdo9jv/v98rZmt/TKXagiVOZGs0Y=;
 b=RjEIZWIC0EQs3y9XUay/JcNmDg+2JPrGLnN+YKan1O1jpPtUKTJSz8F/jmZfw2Q7TBhOd27HIq9iFuX8I96508DIw4yNnwwIBOSSnUYSLG0S9Xsb3W6gsRcemnqOMqqiQ9bL+zb93ayfa7XQAVZBcfNxfDaDt6EE5U4h6B26QaDIxGAmv2jjiX72vFGKP2o5MM4Ww3zR3RUBbtMhScpm6qsnF7XMIZx61Fy+JsSL+iMh9kMaPd25aQ1Tg8b3BEIMnrcyL6fsz0jO2/Wc+PFjcSukVMtkNeXM5GAaHc1Ho+OXMpzm8Eq6kBhrxFk2hAg2/Bgf+LLc64/mxj/1e6ZJGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JI5SLFTJCQWn1foMdo9jv/v98rZmt/TKXagiVOZGs0Y=;
 b=HEMqsCFaQyIyMKEyjAkfmPFbJn+uyhMOPv8Z5WcYFag8NEVunzQ8PcC1olBkfKixKC6q4hqgAwcS/poPWI+kA+W9fRMlfYp/1RaruzfLfiwATS2e22lYR+1RjgILGt3rQEDakie859Oz7V1mOVm06lEvm4n82XJWSkEEu6IE+zE=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5563.namprd10.prod.outlook.com (2603:10b6:510:f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.19; Mon, 21 Mar
 2022 05:20:48 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:20:48 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 03/18] xfsprogs: Introduce xfs_iext_max_nextents() helper
Date:   Mon, 21 Mar 2022 10:50:12 +0530
Message-Id: <20220321052027.407099-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321052027.407099-1-chandan.babu@oracle.com>
References: <20220321052027.407099-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0004.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::22) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b2b5c12-fce2-4f99-707a-08da0afa8eab
X-MS-TrafficTypeDiagnostic: PH0PR10MB5563:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB556343D3A71CF01902787D53F6169@PH0PR10MB5563.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3uAV2GpvOHt7dgpVC1Yww8lRtVq4voxLFOTnkDhzKnV6EdVlrXsHkyucTJTpO8Q4ABTWxQ/isAxSPRe8fbKggcH/NAcCJEkl8PtI70Wczk7lInby2ifB0+QwZHloROSzhdB8dA5ukJyAyoADgKYbT/f6ysNeLjf8t7x8iRlTzk7LKbSRD2RzeJBtlddAekUPZQQFEmAa2643l148tKjATDzTbdeR7xaefq7n/3lkFnPyKaAi6aSWa7q0K9YUKxdQ+sj2naNJT+IBqCSuasrAKE3Wvk5bDhKscQlZ8C6hBMs3Leyz1+RtZPYWTBmDzn2iX9i6G6zrTheZ9uvx6jqQfSNdJo2eiKbGWGtUV+1Y35qxNrC2PY8P66u6XsTZtrmLU23Z7fJgvMJzr75yYUERoFuh+S2qhUdz9a3zRsKSY3v/MUl1Tqav0W1FknnLShrmyL3ck0faN/XZIOz2Pq/B993SKO7VNOY3/KcLPZpb3kiXiI8g6czr0gftYREblwMDcsDdJPFhNixDjQHdM5Hv9+oLV00rxRS0DWp/Fs6KdsHHeb84jBQEApunf68UHJ5ihUGr0AQ38ubONaO5V3eL1SLuUotCib3MI+qfwguXoKJntAZFzePVRLWKSNjL+7naGOgUW1Lxp1ensWRhxnxdIb+tKzNpYJFWFJfsEXZ5oJdQ0xhxYDIw0GBDJXprn2RhVDs5InzZo3xbu7+OeZmQtg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(6506007)(6512007)(86362001)(52116002)(2906002)(38100700002)(38350700002)(6486002)(6916009)(316002)(5660300002)(8936002)(508600001)(8676002)(4326008)(66946007)(66556008)(66476007)(26005)(2616005)(1076003)(186003)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3cNbSahHXMksjhbAA+5766vvj4ZevU9V9piDMYSUTHfSFuzLsJUXrIFxyuRe?=
 =?us-ascii?Q?7SgItvJJKxYSxlQqKJ5ULJ8m0Ddc/taF7vW2/O+aQTao8w+bH454EM5KymSU?=
 =?us-ascii?Q?F+lCM8F5p3qrfNf/eYWvbRSZaZi/e7StmItGovuZr1+dGjrrOmoFp30hueYf?=
 =?us-ascii?Q?UlNcmstruT2rzwTNU8AQO00de5voCecFesbuYUbXjBny8/TlULQq8bYBGV7X?=
 =?us-ascii?Q?eJaRbEI6KVst5sIZlZUKYWNfD60TbuxRjVdqLQu4GlCWnhKDXYdNisfY43Mf?=
 =?us-ascii?Q?7ZTydUrMCi1WcTw2BVIQ8if6GGIRtV7cxrajB82eOrndq23m1W8Ii8yz0ck8?=
 =?us-ascii?Q?CKnik6MnLqD6vbUkD8+oqBi40jP1FwtxM/ah6VQWNqrIf1SrGLC/RFw6N8p/?=
 =?us-ascii?Q?v8YpRTmdtTXwvIU4CmtSRyLdKUkiN9VkyNqayfU7b3aIzIMhnEIts7PoUBrR?=
 =?us-ascii?Q?K668cN6E1db9cRIorM+cAG+2payg+hPSHOfe3Wxgsb5FOTXXkPhytfqviWaI?=
 =?us-ascii?Q?xXaVFIGFO8josXAxnePuMm2V09VjrJ4jYMrN+apKUYam2wUBtSNjeBSsrnI5?=
 =?us-ascii?Q?KFfJRJlLCRPN++GI4uCBipwBgaw554s+A7KAODSCQ18a+GBwm3HU5NkQHYGB?=
 =?us-ascii?Q?4BnNCyYKcND8EHXwLggNSv/wC7NYPFcx5zesrm0644wZrdhgD9A8oRfEuuv2?=
 =?us-ascii?Q?nO29M6VquDgUffXig0nayLdwQRsyT1ea8GLmQHMwPBLc3u70sgt5ABsAbTbM?=
 =?us-ascii?Q?AmH+XhFN0y6oo4auDPVejfv2RC/s/7fQpw5qYBvlOxbI3Z39jvrRlXbco34I?=
 =?us-ascii?Q?eLZ1j67BSEVKjWasxNitycUTRS7lk4giFcm3rV10Y+7B9D0qVN5l1RM4CPyP?=
 =?us-ascii?Q?vbFU32XL4af02zg8AqFaTWCYFsJvz3o5J1QEc6zEjlLYi4njM/z8W3B3FTeG?=
 =?us-ascii?Q?/kaobxvLAEJAFScHsj7/43CMzXb0p2hZXHJkQVxhh6nWeoiQGY0naaXpLRMA?=
 =?us-ascii?Q?jkd49APnKOSOt6nXn1VmYtmdtyd7F/A6v3oLDh5+8zhLJnVrBi4PRrNS2dyR?=
 =?us-ascii?Q?IZ3GkfYnOEUshkPgQdM/q5xjac6hQ5065Z9gyZM/hxUPfV/KEavDoaEFiCd3?=
 =?us-ascii?Q?8ZRVyXhyL/PyprKY4O0PR2U/jLAYg9yE5epya+e303Kfqj4wCXYWEZ8rMFVb?=
 =?us-ascii?Q?EbqNUr+oVY/ndSKxkQiVDtnF0oTugissOA9mZx7y7T+zq1D/x1qABrxLIaUT?=
 =?us-ascii?Q?fdkyGDM+P9F4mD0HM/EeIqXs8eg4krapGwaAz+FSg/ctXLq1BmLr5z4/nESG?=
 =?us-ascii?Q?WsuV0HE6dyBGV3cKaSKzkgh+5Ix5gMdtf6Ia/y/46Ue/Vi8pvka4wCqAP0/3?=
 =?us-ascii?Q?Uxbi5LjzPnP7mnEDARhG6qaNpAvfDS+73am3ob5tor4FVW0tya3KZaA6o1xg?=
 =?us-ascii?Q?2x5uB04myWkmUWA4qa++Ul8T9BiLYC9AQSz5B8F499lhReUZU1AC6g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b2b5c12-fce2-4f99-707a-08da0afa8eab
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:20:48.0548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JGDFRn/ZYe+qLbXNhsyMOsSYm86ovz/Bsx1Bj6PFWydUXfbF/xcHF0eKGrTEt5fG10GX6DhF+fTdtZhMRz/f5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5563
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203210034
X-Proofpoint-GUID: kuT63b7VjVl5QxoqdAI51P9XSKe94ULr
X-Proofpoint-ORIG-GUID: kuT63b7VjVl5QxoqdAI51P9XSKe94ULr
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_iext_max_nextents() returns the maximum number of extents possible for one
of data, cow or attribute fork. This helper will be extended further in a
future commit when maximum extent counts associated with data/attribute forks
are increased.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_bmap.c       | 9 ++++-----
 libxfs/xfs_inode_buf.c  | 8 +++-----
 libxfs/xfs_inode_fork.c | 2 +-
 libxfs/xfs_inode_fork.h | 8 ++++++++
 repair/dinode.c         | 4 ++--
 5 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 9057370f..64729413 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -67,13 +67,12 @@ xfs_bmap_compute_maxlevels(
 	 * ATTR2 we have to assume the worst case scenario of a minimum size
 	 * available.
 	 */
-	if (whichfork == XFS_DATA_FORK) {
-		maxleafents = MAXEXTNUM;
+	maxleafents = xfs_iext_max_nextents(whichfork);
+	if (whichfork == XFS_DATA_FORK)
 		sz = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
-	} else {
-		maxleafents = MAXAEXTNUM;
+	else
 		sz = XFS_BMDR_SPACE_CALC(MINABTPTRS);
-	}
+
 	maxrootrecs = xfs_bmdr_maxrecs(sz, 0);
 	minleafrecs = mp->m_bmap_dmnr[0];
 	minnoderecs = mp->m_bmap_dmnr[1];
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 28662aa7..12c117c9 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -334,6 +334,7 @@ xfs_dinode_verify_fork(
 	int			whichfork)
 {
 	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		max_extents;
 
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
 	case XFS_DINODE_FMT_LOCAL:
@@ -355,12 +356,9 @@ xfs_dinode_verify_fork(
 			return __this_address;
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		if (whichfork == XFS_ATTR_FORK) {
-			if (di_nextents > MAXAEXTNUM)
-				return __this_address;
-		} else if (di_nextents > MAXEXTNUM) {
+		max_extents = xfs_iext_max_nextents(whichfork);
+		if (di_nextents > max_extents)
 			return __this_address;
-		}
 		break;
 	default:
 		return __this_address;
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index d6ac13ee..625d8173 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -742,7 +742,7 @@ xfs_iext_count_may_overflow(
 	if (whichfork == XFS_COW_FORK)
 		return 0;
 
-	max_exts = (whichfork == XFS_ATTR_FORK) ? MAXAEXTNUM : MAXEXTNUM;
+	max_exts = xfs_iext_max_nextents(whichfork);
 
 	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
 		max_exts = 10;
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 3d64a3ac..2605f7ff 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -133,6 +133,14 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
 	return ifp->if_format;
 }
 
+static inline xfs_extnum_t xfs_iext_max_nextents(int whichfork)
+{
+	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
+		return MAXEXTNUM;
+
+	return MAXAEXTNUM;
+}
+
 struct xfs_ifork *xfs_ifork_alloc(enum xfs_dinode_fmt format,
 				xfs_extnum_t nextents);
 struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
diff --git a/repair/dinode.c b/repair/dinode.c
index 909fea8e..1c5e71ec 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1796,7 +1796,7 @@ _("bad nblocks %llu for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
 		}
 	}
 
-	if (nextents > MAXEXTNUM)  {
+	if (nextents > xfs_iext_max_nextents(XFS_DATA_FORK)) {
 		do_warn(
 _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			nextents, lino);
@@ -1819,7 +1819,7 @@ _("bad nextents %d for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
 		}
 	}
 
-	if (anextents > MAXAEXTNUM)  {
+	if (anextents > xfs_iext_max_nextents(XFS_ATTR_FORK))  {
 		do_warn(
 _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			anextents, lino);
-- 
2.30.2

