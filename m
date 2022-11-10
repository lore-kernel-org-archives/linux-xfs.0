Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68A8CC433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 06:36:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiKJGgn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 01:36:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbiKJGgm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 01:36:42 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 245682CC95
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 22:36:42 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AA6PnYY020199;
        Thu, 10 Nov 2022 06:36:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=XjqlhtbTDD68FOE8LTIDDVCQjaqlV4B6dNIPcnk/4hc=;
 b=iP7SV5L+/S9r16lB7fOLOQLMQbj6iU405UjTwmFQnW8sAt3DgqGwfSjizTJJJ17/yDpR
 AwnA7Fn+aB84PV1CpTqlkDLZLxCiHCvTk+AM6Tl0/6jLmpBEp/YfcjqB+w0VSsmXTIRy
 AFSBHbhroN1DK+PRanOdP68uOBiPycAGbsi2wcgR4kfE7/NVGvcvRNBtfh/YLHkDJxzf
 h/nq+wnn3HPia66o7ofUvk6o+X7Bf9rsPIq3fctGM1hAsmBy1Ei4j9tJUJyFMWWXsoVN
 k+vtU/Ueuoma622kKvIveOHddcYjO5Ct49QGa9Rt5lwF+z50DYAgNOaAh8BaLXjGzAu5 ew== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3krv1100vg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 06:36:38 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AA67nx9036364;
        Thu, 10 Nov 2022 06:36:37 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcyrcjwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 06:36:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VsXSQZX0CxekXDPQlDk5exPVruhYqxafrivHYnp+OdilTsumydY7trsbczgrSQv4s9GS8fFlUyMgKBqZ+ZDIHjMjL3r4YemUXhIngOzXCYe9gCIgjVP8WHMp7Y8tYpefvZ7SzsbhxgFsPa9VpcB6kGWg+yoV3AgHJd2gj2CbIvflZQlw0F/tv1ZERgjoXbNVMXX064yHKcR7oTaDWQSq1DhqcOG9jU8ZPOKsAI0cB15sCg9MPQendITm6+Rn32LAYm4u6Com1txaZ1dn8SOVMhOthtEZSDa03evJ+n/DlwUVEbIDhwIDIjpKdnCDAcffwVA56mdg8uHQkEUj0p2oZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XjqlhtbTDD68FOE8LTIDDVCQjaqlV4B6dNIPcnk/4hc=;
 b=P5+RrcPNKyc/7ohlEfMdyB4Aa2YyKE+GRoFfGt0PzzCS0DY36o+eIy1UfSZGx36ttyXw1DSknf+gv8Cs1K02+1Lz1hmkP4V9Loo2WkqYkYo9VaCzrgn40K3YZMoDiI04j2yHuB9TNLS4RB7mGzAyqrzOov9bOMFOcVyU8IKFvlcM2Wz4VaBBtchs7EwxFZ76SSnlEqh15gUsSGPgRH3OsRoMVsJNwjskVX0guTBBb7eFTiJi5Cx6WkLKHqOp5WsGAzybpfh1NaAvotz+QquRHqkrVSZQfYBD2gOWwVV/WJVZdLoWtW2j5IcYa4+TQvvYBO3BG2YhAVn3JIgmAErbpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XjqlhtbTDD68FOE8LTIDDVCQjaqlV4B6dNIPcnk/4hc=;
 b=dlgWhl9xonpoTdjh8FG0iosW+zPqO4h9n8GvZhg3O+eF+k+Kbknwraba5QvRSDdoqbd1hITmZo41ROaKE3d4bbMN0PsVGcFoARIxtH/5j005e02zEik8CaMoxgRN+a3FwFmEqVJNQQLjQBmpoa5WHFo5F7z97PBJdWv5rJBY9xE=
Received: from PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15)
 by SA2PR10MB4748.namprd10.prod.outlook.com (2603:10b6:806:112::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 10 Nov
 2022 06:36:30 +0000
Received: from PH0PR10MB5872.namprd10.prod.outlook.com
 ([fe80::3523:c039:eec9:c78b]) by PH0PR10MB5872.namprd10.prod.outlook.com
 ([fe80::3523:c039:eec9:c78b%5]) with mapi id 15.20.5791.027; Thu, 10 Nov 2022
 06:36:30 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 2/6] xfs: rename xfs_bmap_is_real_extent to is_written_extent
Date:   Thu, 10 Nov 2022 12:06:04 +0530
Message-Id: <20221110063608.629732-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221110063608.629732-1-chandan.babu@oracle.com>
References: <20221110063608.629732-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0184.apcprd04.prod.outlook.com
 (2603:1096:4:14::22) To PH0PR10MB5872.namprd10.prod.outlook.com
 (2603:10b6:510:146::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5872:EE_|SA2PR10MB4748:EE_
X-MS-Office365-Filtering-Correlation-Id: 46fd7f30-13ac-492b-0eb3-08dac2e5e6a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mWjYPyjii/PQgH0W/kv0rMi1hyaZRf2yAZ6DG+OWbNTxUS1rFk1X/X9LoOwBOISNrWlFxKWYpdjjhG2KjYDBtR367Q0JKtCIfGU/xCsIjWS7nTNK+O2dLMP2OkYrUwts3/mlyT3eYvZCdw8THQ20oA/c/xUaRzS8vOIwyKn/htfpmP0n3/Dz6VWQUiHFWySHze6NZPRwLe7Le/wlTUd0LpOAjeGsPhEh5GgOZA2vH10MT8+D5YKgsm0ecj/dxSE+WfJ+FZZPhw8NistoEXYXsG6h2MT0tLWugrWvC2K5CcJCRmzXik4tBh9IHMK2Ozb+C686UAxvc8CKADBNPu9g3P1tbx4yqDUG9QSFoIHwESdLeWH+4gpH7zHB1ccRjZ4QssvxjLLSekLiRDv1fk1Wr6HP7Hzq043RNB0AkRcDXX/FrZh9BJAujM2HxKzNpol7DB7xRF2Y0RCYV8sgdKTgoJegnM85CEo5sDV+P+Pya+kiCGKtT9YR0xeFI7o6GPzYagmrNvoinvrR01J7icFSCh9mbnhD29rCtbxxel/xJ1wNIOwyRRA4n2y1k4Xom/lAJ22tMJ2/hlIBw/1OhRyqENXvnmgr1AckU0UzZr2e2vqCBm3r+9T8ZZI8HaWsSmGOlXZGakv0pGXUqPDMqY554lnDHJkC7UVSZm/D9YZchkFL+QzhQAImzH+F3y6IodXkEVbeVN2LQT+T7ZR080A1xQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5872.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(366004)(136003)(396003)(346002)(451199015)(38100700002)(86362001)(66556008)(8676002)(4326008)(66476007)(66946007)(41300700001)(2616005)(5660300002)(316002)(6486002)(478600001)(6666004)(6916009)(8936002)(1076003)(186003)(83380400001)(2906002)(6506007)(6512007)(26005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JffZMEWnqIbIWoY7998XgOj6NJMtqxgMZ6Mi9XgQiaz9QUpdn/SSUyPooISW?=
 =?us-ascii?Q?Y5KRgk/B80XqCzv9Jp2gtI8MXRUK20U1JbPtsw5adpc97PBWFilW8e301yl3?=
 =?us-ascii?Q?oCWNpGBqG55Uo4ihR1nPDe87G5s+gwkltglV5TTPzEuiodBQ8MCFa4jOxc97?=
 =?us-ascii?Q?FFmQLN26xYTXbKkA374rhk0oKwZkQ7cfrKajfLCNp/XQ+uLCePS0LtVkkak4?=
 =?us-ascii?Q?zl+cYsMr1bGJoczGU2gbB9HkRqGnoYD9T9F+9+sP4p0ecKAJ335pzgZsJVhF?=
 =?us-ascii?Q?lej4+XE1caMPayE79Vn2MlJNnuG7CcG6EQPUrPPP6ay1c0igUpKV0JgLLSn/?=
 =?us-ascii?Q?+/kPdxubNzKOX6s0vop8IONAaQD/V1P6t4mD7Lyi6QqWPqmiMj5l20tL6UcK?=
 =?us-ascii?Q?6L8uYfcBb0XM8R+1FLN0aStHaEPXJjrOycQ7LM4NELIdqWuBUR/bzIP+bLGv?=
 =?us-ascii?Q?Grkj2woWk+NEr51yd03YWDhxK3MUiFBhj3wf+Fqv8N1SOwPjlKeIfV7MLUcb?=
 =?us-ascii?Q?QNor7Wpn0Uin3AUsY1nRi1tl/obOzx0xuqWalSRiWkrDfWpAYoPXIxSG7NHA?=
 =?us-ascii?Q?5t734DAb131jivhoakQ5fQK4iNAeuh1F9lDAMLA2g6g8zSU26tN0Dj4jXRnY?=
 =?us-ascii?Q?7exGvlhaslcFT+72ku0bkpgBmIAHHtYOmKanaq6e16nHnxukwsPorwMtz6uQ?=
 =?us-ascii?Q?Ss/yQ2o2UWOeFAoxRFG3ESXkPUidELGFtGo4TjanWvj1kPWTNrQ2vMVj0/XJ?=
 =?us-ascii?Q?9VcRDQlmpIQ3W82rhm0h4gy0piYdhABv0YiskRNKptHnLB4ecfeG3F06TUUK?=
 =?us-ascii?Q?vmre59fR4h8fwz2EVKXicSzBT0doaCKVWZQWO0B3pF+ylTBrpzirc2w+Mr7X?=
 =?us-ascii?Q?N035+Mc5bZLH3sLhonk+aPyM49VV8ehjICGZbydRaxx3T5N4WtEsqwqezuj2?=
 =?us-ascii?Q?6ErqjHFL9bbKiUt38cHNcWshlMNv5BfXNaOb+KCN2uMjMyEGGmk7688489tU?=
 =?us-ascii?Q?6tLdREDheUe5LlBrlyMhX4BmiZybanVak4gvkFOpdJFAsYcxBkRHN2e0ePTy?=
 =?us-ascii?Q?ksrUibdh0oE6z7qn6+Wr3FWY2vlGeWQ0AS83OEUsArawMp9v4gl2kAKXsGit?=
 =?us-ascii?Q?uuExs/nLDzxu1zRLTDxgcjqCo+RKAPEQKi8SMkPq7x12JqphG7C1hO8wMbq1?=
 =?us-ascii?Q?dAQ9ik41sF8lJ/TxHRMGiisZACh8kG3FKmDx1oYbmer6Z4tNeD6CEgeAjzFm?=
 =?us-ascii?Q?Cq0kkucSqKl8K6yQZFtCxNf8FWjOH/8KeWwyN656vchtoXho4JPNBrcpUe2N?=
 =?us-ascii?Q?2U6ed86NU9u5aoeRmSH5COoEoY0R+YJdOHzH80CvIZQINXZ5xn5cSiOc67p3?=
 =?us-ascii?Q?AL8F/o1pR0qfa2cfsewq+b6H4Gp3ohBKFco3srulejJi885NMO6KKQ74O86r?=
 =?us-ascii?Q?4g7JYyBOO/9oGBt5smjIn/iPd1gNQeUqstgWEl/CGwqYJvJscy3Lmxk6ZX9+?=
 =?us-ascii?Q?TkA2xXPU3w04/hAS5Tf/1XttuftxPJ7O+Qc+Rvv1aWqwk7L7881rcS9cPVbl?=
 =?us-ascii?Q?e1BUoZwQdRgM+yd4CUB5quOTUVnlGCjYdqF4z5ra?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46fd7f30-13ac-492b-0eb3-08dac2e5e6a6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5872.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 06:36:30.0069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Fpds3n1wgyf3DCXd3EmHS1TLE9xurifxPBiDTzeJZGVvUVzXzjuf6/o1nAnyJmzls0um9mvHxJ5vG62a1eTcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4748
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-09_06,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100048
X-Proofpoint-ORIG-GUID: 9H8n2KY0_CX-Q2bmIfCu9slByYjBCJip
X-Proofpoint-GUID: 9H8n2KY0_CX-Q2bmIfCu9slByYjBCJip
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 877f58f53684f14ca3202640f70592bf44890924 upstream.

[ Slightly modify fs/xfs/libxfs/xfs_rtbitmap.c & fs/xfs/xfs_reflink.c to
  resolve merge conflict ]

The name of this predicate is a little misleading -- it decides if the
extent mapping is allocated and written.  Change the name to be more
direct, as we're going to add a new predicate in the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.h     | 2 +-
 fs/xfs/libxfs/xfs_rtbitmap.c | 2 +-
 fs/xfs/xfs_reflink.c         | 8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 640dcc036ea9..b5363c6c88af 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -163,7 +163,7 @@ static inline int xfs_bmapi_whichfork(int bmapi_flags)
  * Return true if the extent is a real, allocated extent, or false if it is  a
  * delayed allocation, and unwritten extent or a hole.
  */
-static inline bool xfs_bmap_is_real_extent(struct xfs_bmbt_irec *irec)
+static inline bool xfs_bmap_is_written_extent(struct xfs_bmbt_irec *irec)
 {
 	return irec->br_state != XFS_EXT_UNWRITTEN &&
 		irec->br_startblock != HOLESTARTBLOCK &&
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 85f123b3dfcc..cf99e4cab627 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -70,7 +70,7 @@ xfs_rtbuf_get(
 	if (error)
 		return error;
 
-	if (nmap == 0 || !xfs_bmap_is_real_extent(&map)) {
+	if (nmap == 0 || !xfs_bmap_is_written_extent(&map)) {
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 		return -EFSCORRUPTED;
 	}
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index dfbf3f8f1ec8..77b7ace04ffd 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -181,7 +181,7 @@ xfs_reflink_trim_around_shared(
 	int			error = 0;
 
 	/* Holes, unwritten, and delalloc extents cannot be shared */
-	if (!xfs_is_cow_inode(ip) || !xfs_bmap_is_real_extent(irec)) {
+	if (!xfs_is_cow_inode(ip) || !xfs_bmap_is_written_extent(irec)) {
 		*shared = false;
 		return 0;
 	}
@@ -657,7 +657,7 @@ xfs_reflink_end_cow_extent(
 	 * preallocations can leak into the range we are called upon, and we
 	 * need to skip them.
 	 */
-	if (!xfs_bmap_is_real_extent(&got)) {
+	if (!xfs_bmap_is_written_extent(&got)) {
 		*end_fsb = del.br_startoff;
 		goto out_cancel;
 	}
@@ -998,7 +998,7 @@ xfs_reflink_remap_extent(
 	xfs_off_t		new_isize)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	bool			real_extent = xfs_bmap_is_real_extent(irec);
+	bool			real_extent = xfs_bmap_is_written_extent(irec);
 	struct xfs_trans	*tp;
 	unsigned int		resblks;
 	struct xfs_bmbt_irec	uirec;
@@ -1427,7 +1427,7 @@ xfs_reflink_dirty_extents(
 			goto out;
 		if (nmaps == 0)
 			break;
-		if (!xfs_bmap_is_real_extent(&map[0]))
+		if (!xfs_bmap_is_written_extent(&map[0]))
 			goto next;
 
 		map[1] = map[0];
-- 
2.35.1

