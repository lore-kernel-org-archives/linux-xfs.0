Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64504C43219
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Nov 2022 11:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbiKCLyd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Nov 2022 07:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbiKCLyb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Nov 2022 07:54:31 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A9E12610
        for <linux-xfs@vger.kernel.org>; Thu,  3 Nov 2022 04:54:29 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A39O8QH013506;
        Thu, 3 Nov 2022 11:54:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=xjwTNve4kx9lUYh4dvgo+j8BYv2W9N8Mj5Ye9iBCM/8=;
 b=JZETq7DwYNmCHszgzrD7Hxgo4IUy/bwPEattK5V+9o5N5o6qk0yPMXM4rjm24fDZA978
 ThTXPOOnYkvEVvpe1Nq/Cl+mWsrCuRAjmY34sKAe6ygtH73Dc71VLzaNBLZXYNHC+9S0
 MWZFrv+Dcglymc1qjbIQx+wOkgkih057s2lRBuLaycwrhEGmbjU4mxK9setzkRXCJNqR
 h07rTdM9H+LlqIWp8K+TNIM1+V2siOL1FneylZXTJL6wITZPS+2Nl2ditGxKXiDMT5zN
 N7ZL4P/sXq1ZjwbUNSyWFeJvBb5DPkh5sDGHG6LxIW9egWwedx5UcUmJYvJNsHBRKGV0 pQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgvqtmqm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Nov 2022 11:54:26 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A38rXoE035602;
        Thu, 3 Nov 2022 11:54:24 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2176.outbound.protection.outlook.com [104.47.73.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kgtmcmk54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Nov 2022 11:54:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MjOLb2doUeAwN88L6Uov6n2e9f5Ao0DdUVySpjIPqyrMN5mrrjXxhYbi3+IJJxsQMQbqoCkmlpd2IiMjj1lAds1RRtnhyl11v7U0CCMW+NIRkr2YIjvMzaOUv5icteHzcKW7HPYLLjTeI+EwBb+kQszCMs/n4+/oO3YhPr6YVdiXTPXZyBrHGdK/lGl/Njw1RfWHEl0GWIM9NgVvHq01UOAhH881Wx5P/x3bdl9QFBvFad69w/nNEloYJ9EZU8ree55BnhYBOqMmrMUUSINOM2s+o2SSXXFno8N7xhuB9H3V9ClMBzjQzNUPGfMWSZaaI23SeVRxauvCAv81KvjN+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xjwTNve4kx9lUYh4dvgo+j8BYv2W9N8Mj5Ye9iBCM/8=;
 b=L8TF5FroL4eHsDyH4M5F2G16Xv3tjK6YSQs2Q1K2opdqExtyObWy7OzdYx9oujQ2FuSKCzx8H1k19r/gHtUoKKXwFCWqjlEMv+GEixlrU4jPKpm69AW0McQIi0qA6GKRAB32KhUVUkK8bwC5kpH1VnScnonHlbINgIOQYo7aQU7you0vdzwN+wc2JRnQhk7DFLjBM7D7brDYzktHvr6EKe2+kn1SX8cZpGf2aTVf+tX53eeWqFB5LyK7g0FBCA6/ipLCbfgJ5fE+rYWi3xazgWYHkjLbcIdhaeqcdHuSdVvPjw13+OVmH+AH/FkRMsuUi/b33yoD9+8m3VwSJ6Evew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xjwTNve4kx9lUYh4dvgo+j8BYv2W9N8Mj5Ye9iBCM/8=;
 b=ffcpu00juul7HOrF5hFl+DB6zwJLqN4r35HoqZmDW2UGcI+JUX88o1SsQSRYQ66xnmOA2SYXWU7O6OwpfSuNjhYodGBVARmbmjNlwPEvuvWXc8uBLVDbdrz/Q1hlRIwhT97boW4k+GEkzSdDoy5rb0NIZAxoSWuhOl0LKhHMsWw=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH7PR10MB5831.namprd10.prod.outlook.com (2603:10b6:510:132::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Thu, 3 Nov
 2022 11:54:22 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1%3]) with mapi id 15.20.5769.019; Thu, 3 Nov 2022
 11:54:22 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 2/6] xfs: use ordered buffers to initialize dquot buffers during quotacheck
Date:   Thu,  3 Nov 2022 17:23:57 +0530
Message-Id: <20221103115401.1810907-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221103115401.1810907-1-chandan.babu@oracle.com>
References: <20221103115401.1810907-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0013.jpnprd01.prod.outlook.com (2603:1096:404::25)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH7PR10MB5831:EE_
X-MS-Office365-Filtering-Correlation-Id: e3ef8dc2-271e-4af5-66e4-08dabd92259b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UUSKssJ399cfy5iXMtb3ILoLs8torL0nbbMVjTDz8bJha1wRXPdEzRXiLgUvhE0Guul+aZqs4cxwsouKnK+FIpYM0YKhodCMeNMvF9XdRXB01GoGgWx5AFGj7ESH4JCmKZwjXapyCiciZCSqkrisECXHuebEfZmKmXWUE57QFq6ORMs9LPrhRDbsOBNVWBEjsplS4QSZdMMhhvx8JGPtdYhufOQ0Qjxv9KUDooMAo1NArMlyt+Vpw0k+u5sOjDkFCDEwAucesdJLGvNGbQNvCYuUJa2AyEiP3xvPxk0iZDcFT/mhwnYt5UwIuIwwr53Cdn6DSCEB3J7rB26zT0sWTCbjHIyg5ZDQL6bSAB9e4e9/VZor+dHbtvc5xDWaF2+Ak1AqqyipAb+T9OqcEt0Bv8X0I7AQebSqiRhpxwOwHP9hMx0knRBzJQ7b+lSf7sol+inv0EUUTyF/2zFqQ2Ld33cypcZbaPQtplP7QTPEuhwVo29UGn7Wt7IY+c9irll5O9dM8cpddJbkpL5vRVENQsHeNDdvFhgRNg9jw3dbMrlFVySIeeeSMMtk9FCu1rao9CNqDki95YBJY3KoI+87JXHQ2X6155gbPTvObwDUm4UW60NQd52ldA9xdOwB85zmsDUyA6zkax6YiW0Nll2a+B3gO3mTav8+Z9U09iw5E9z+MK8XbHCYxDFbLT7Fyi+lozxGx8w7c4xvPoE6n0Hraw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(136003)(346002)(366004)(396003)(451199015)(186003)(6916009)(6506007)(6666004)(83380400001)(2616005)(6512007)(26005)(15650500001)(6486002)(41300700001)(8676002)(4326008)(8936002)(66556008)(66476007)(2906002)(316002)(1076003)(5660300002)(66946007)(478600001)(38100700002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fBchKZDXMr//1IbZ6y7jn3bTanbC++L3PKCFg2BHOcEDU9EeIP4cMR9E2ME2?=
 =?us-ascii?Q?eaVIAAsgeMUVNoRq7jWV51etDIZXLC8NPszqFWW9XqwdzntXzOEfFEM1+4le?=
 =?us-ascii?Q?X9svWkMhEqGd5h8WfsUOGBVdK8r8mS7RPg6tO7jOeaGslI9smTwsKTa/pjlL?=
 =?us-ascii?Q?QNcrvTozEHA4hqX12Vgw1Rrw0712YbzS/kuCvb+03A52kbp0yjZ7jVewsydV?=
 =?us-ascii?Q?TJYxYGxsN/96v06CrYLjUg+WJ4CPelLNlzvcW6h4+9Y+t/PZ7mw69/hPDARz?=
 =?us-ascii?Q?WA7msD6k2o9U2BVVYoQmvL/y5ogKA7pMo4H0dT3E3ISCy+zPSv6Ho7ZBKve4?=
 =?us-ascii?Q?w2PveFp62++YygGPSWqtMzs5OCiSUWFi6SrL48XCAjajYQ4oi4jN/ZCGNvLc?=
 =?us-ascii?Q?C8NnY9nrrSn9jPrtQE6RJ7ddoq5gRmLkIDN916VrWP/aL62otUuAKrajhKY6?=
 =?us-ascii?Q?UPaME3aV5GTP0r5LZ6c8lTSxAubkmlQ7w06+4b/IGaG0h2wkAKFpm8YTkSpy?=
 =?us-ascii?Q?WoouysuFr2STpm3nBXT5JRZFGy3MxC4PKPJk3kZ4Sk6Vgyu5/nIFsikvtx1m?=
 =?us-ascii?Q?6vEPUbryRqi2DkfdJyWRZdHjG4Gm3RW7Hk8Ys4DNcogWxBIQxuXffQf2c+oj?=
 =?us-ascii?Q?pYuzetvwq+5XVVXGV4JLPMsvTKYGNBSrUcYQES3QQo94ebw7TYPZt2SJI+05?=
 =?us-ascii?Q?aqD+bW/WwkWiKQwUi02vYEDdR4fyb0nnymbuEeB0SLQxtjYsxGfnn4aRRF3B?=
 =?us-ascii?Q?mHBHJGYd4unltHRATHEs6LOUP/FrAWcugGblJ2cWw1z6vwNjAmPDNFOlUh8P?=
 =?us-ascii?Q?zNZarjAAAi5JkPjPPWR20sgskNATcJEmke8jKUQBU531AGMg75ax2bHhp8U1?=
 =?us-ascii?Q?RlmI6FQqFQNx/6Y9QYsxFQNCcy7kg0nH0Gb9tK8gCJA4H4lFn0xSh2/r7h5D?=
 =?us-ascii?Q?ghprrGNtS8nFeA8VbxtXk9J+yhTSb9lHPBkAWoV0QaqGfVZ2OA98jVUa1/wg?=
 =?us-ascii?Q?XgdZzDdSFYVE6oblpY14ZiTfbS1LgWpFCQJFgls5/3J8MCpmL1AI8SZUYhS8?=
 =?us-ascii?Q?7WSmnLO+aDHMDKNLTA1pkOtsQhtpA5mtE7y8szKewHJ8wE1p5ai42kBgw0OK?=
 =?us-ascii?Q?QbBK5C56WLAV0jDYR6jOHtYtyLM+UX+qnSdgucOe/FwEQBPz9cgdctg5RSZm?=
 =?us-ascii?Q?q7UnIoOh4IwKW3znVJn318SbsILuSkY0uQ0S4WPJiie2gIFHC46hhmyGDYYC?=
 =?us-ascii?Q?crqVE8NKLcQ+jDFFCQ9VQgEezezp1HgB275/au5Mdl55zqnRop5EHcq4LNdi?=
 =?us-ascii?Q?0Pc7NBnFBym9+sGCaCTBUbTA8WtBCQshIigRKBaNISklBVI4KTBrVmgRg+zl?=
 =?us-ascii?Q?KdMIqrwFLPADK1mLNLuk4XAwXo4e0NtHP/YbwhDVVtUjgRZnrIXs4a1yq/ek?=
 =?us-ascii?Q?yNLmdiY0z/lfRTEZl/74YnYYwZ+plnWW9/9/+6PRFzrumI3udgChLr6YiKva?=
 =?us-ascii?Q?RMSH5ffV0HlU0g9wjaBeGDQtP7sfKErK4c8SojtC+ArMepuUKQAXJZqnOGVI?=
 =?us-ascii?Q?UhgHweAwu8NYwudIEiIfICYmFmgmDmQYyt86+Luyc+Jg2V3azBh1pGJhcEnZ?=
 =?us-ascii?Q?KA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3ef8dc2-271e-4af5-66e4-08dabd92259b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 11:54:22.1256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e61ASQ0NR/NhctnCaU+oHx88easx++eyEnBPpmjA4LvhAmFmanVvL8uwiD574a2Ij0sjKTV/5mqTXHboueho7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5831
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-03_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211030082
X-Proofpoint-GUID: zsXmmkjUPBv9UfILFQVgHw8vW6zBGtH3
X-Proofpoint-ORIG-GUID: zsXmmkjUPBv9UfILFQVgHw8vW6zBGtH3
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 78bba5c812cc651cee51b64b786be926ab7fe2a9 upstream.

While QAing the new xfs_repair quotacheck code, I uncovered a quota
corruption bug resulting from a bad interaction between dquot buffer
initialization and quotacheck.  The bug can be reproduced with the
following sequence:

User quota on /opt (/dev/sdf)
                        Inodes
User ID      Used   Soft   Hard Warn/Grace
---------- ---------------------------------
root            3      0      0  00 [------]
nobody          1      0      0  00 [------]

User quota on /opt (/dev/sdf)
                        Inodes
User ID      Used   Soft   Hard Warn/Grace
---------- ---------------------------------
root            1      0      0  00 [------]
nobody          1      0      0  00 [------]

Notice how the initial quotacheck set the root dquot icount to 3
(rootino, rbmino, rsumino), but after shutdown -> remount -> recovery,
xfs_quota reports that the root dquot has only 1 icount.  We haven't
deleted anything from the filesystem, which means that quota is now
under-counting.  This behavior is not limited to icount or the root
dquot, but this is the shortest reproducer.

I traced the cause of this discrepancy to the way that we handle ondisk
dquot updates during quotacheck vs. regular fs activity.  Normally, when
we allocate a disk block for a dquot, we log the buffer as a regular
(dquot) buffer.  Subsequent updates to the dquots backed by that block
are done via separate dquot log item updates, which means that they
depend on the logged buffer update being written to disk before the
dquot items.  Because individual dquots have their own LSN fields, that
initial dquot buffer must always be recovered.

However, the story changes for quotacheck, which can cause dquot block
allocations but persists the final dquot counter values via a delwri
list.  Because recovery doesn't gate dquot buffer replay on an LSN, this
means that the initial dquot buffer can be replayed over the (newer)
contents that were delwritten at the end of quotacheck.  In effect, this
re-initializes the dquot counters after they've been updated.  If the
log does not contain any other dquot items to recover, the obsolete
dquot contents will not be corrected by log recovery.

Because quotacheck uses a transaction to log the setting of the CHKD
flags in the superblock, we skip quotacheck during the second mount
call, which allows the incorrect icount to remain.

Fix this by changing the ondisk dquot initialization function to use
ordered buffers to write out fresh dquot blocks if it detects that we're
running quotacheck.  If the system goes down before quotacheck can
complete, the CHKD flags will not be set in the superblock and the next
mount will run quotacheck again, which can fix uninitialized dquot
buffers.  This requires amending the defer code to maintaine ordered
buffer state across defer rolls for the sake of the dquot allocation
code.

For regular operations we preserve the current behavior since the dquot
items require properly initialized ondisk dquot records.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c | 10 ++++++-
 fs/xfs/xfs_dquot.c        | 56 ++++++++++++++++++++++++++++++---------
 2 files changed, 52 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 22557527cfdb..8cc3faa62404 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -234,10 +234,13 @@ xfs_defer_trans_roll(
 	struct xfs_log_item		*lip;
 	struct xfs_buf			*bplist[XFS_DEFER_OPS_NR_BUFS];
 	struct xfs_inode		*iplist[XFS_DEFER_OPS_NR_INODES];
+	unsigned int			ordered = 0; /* bitmap */
 	int				bpcount = 0, ipcount = 0;
 	int				i;
 	int				error;
 
+	BUILD_BUG_ON(NBBY * sizeof(ordered) < XFS_DEFER_OPS_NR_BUFS);
+
 	list_for_each_entry(lip, &tp->t_items, li_trans) {
 		switch (lip->li_type) {
 		case XFS_LI_BUF:
@@ -248,7 +251,10 @@ xfs_defer_trans_roll(
 					ASSERT(0);
 					return -EFSCORRUPTED;
 				}
-				xfs_trans_dirty_buf(tp, bli->bli_buf);
+				if (bli->bli_flags & XFS_BLI_ORDERED)
+					ordered |= (1U << bpcount);
+				else
+					xfs_trans_dirty_buf(tp, bli->bli_buf);
 				bplist[bpcount++] = bli->bli_buf;
 			}
 			break;
@@ -289,6 +295,8 @@ xfs_defer_trans_roll(
 	/* Rejoin the buffers and dirty them so the log moves forward. */
 	for (i = 0; i < bpcount; i++) {
 		xfs_trans_bjoin(tp, bplist[i]);
+		if (ordered & (1U << i))
+			xfs_trans_ordered_buf(tp, bplist[i]);
 		xfs_trans_bhold(tp, bplist[i]);
 	}
 
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 9596b86e7de9..6231b155e7f3 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -205,16 +205,18 @@ xfs_qm_adjust_dqtimers(
  */
 STATIC void
 xfs_qm_init_dquot_blk(
-	xfs_trans_t	*tp,
-	xfs_mount_t	*mp,
-	xfs_dqid_t	id,
-	uint		type,
-	xfs_buf_t	*bp)
+	struct xfs_trans	*tp,
+	struct xfs_mount	*mp,
+	xfs_dqid_t		id,
+	uint			type,
+	struct xfs_buf		*bp)
 {
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
-	xfs_dqblk_t	*d;
-	xfs_dqid_t	curid;
-	int		i;
+	struct xfs_dqblk	*d;
+	xfs_dqid_t		curid;
+	unsigned int		qflag;
+	unsigned int		blftype;
+	int			i;
 
 	ASSERT(tp);
 	ASSERT(xfs_buf_islocked(bp));
@@ -238,11 +240,39 @@ xfs_qm_init_dquot_blk(
 		}
 	}
 
-	xfs_trans_dquot_buf(tp, bp,
-			    (type & XFS_DQ_USER ? XFS_BLF_UDQUOT_BUF :
-			    ((type & XFS_DQ_PROJ) ? XFS_BLF_PDQUOT_BUF :
-			     XFS_BLF_GDQUOT_BUF)));
-	xfs_trans_log_buf(tp, bp, 0, BBTOB(q->qi_dqchunklen) - 1);
+	if (type & XFS_DQ_USER) {
+		qflag = XFS_UQUOTA_CHKD;
+		blftype = XFS_BLF_UDQUOT_BUF;
+	} else if (type & XFS_DQ_PROJ) {
+		qflag = XFS_PQUOTA_CHKD;
+		blftype = XFS_BLF_PDQUOT_BUF;
+	} else {
+		qflag = XFS_GQUOTA_CHKD;
+		blftype = XFS_BLF_GDQUOT_BUF;
+	}
+
+	xfs_trans_dquot_buf(tp, bp, blftype);
+
+	/*
+	 * quotacheck uses delayed writes to update all the dquots on disk in an
+	 * efficient manner instead of logging the individual dquot changes as
+	 * they are made. However if we log the buffer allocated here and crash
+	 * after quotacheck while the logged initialisation is still in the
+	 * active region of the log, log recovery can replay the dquot buffer
+	 * initialisation over the top of the checked dquots and corrupt quota
+	 * accounting.
+	 *
+	 * To avoid this problem, quotacheck cannot log the initialised buffer.
+	 * We must still dirty the buffer and write it back before the
+	 * allocation transaction clears the log. Therefore, mark the buffer as
+	 * ordered instead of logging it directly. This is safe for quotacheck
+	 * because it detects and repairs allocated but initialized dquot blocks
+	 * in the quota inodes.
+	 */
+	if (!(mp->m_qflags & qflag))
+		xfs_trans_ordered_buf(tp, bp);
+	else
+		xfs_trans_log_buf(tp, bp, 0, BBTOB(q->qi_dqchunklen) - 1);
 }
 
 /*
-- 
2.35.1

