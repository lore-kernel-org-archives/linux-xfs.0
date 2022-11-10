Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B948C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 06:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiKJGhI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 01:37:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbiKJGhH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 01:37:07 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0CEA2CDD8
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 22:37:06 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AA6AkFw018042;
        Thu, 10 Nov 2022 06:37:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=kaxW2RDcApFhW7m8PRkOl7vWk5m6HLyL6N8WeMcPm48=;
 b=adb0mMmYQWYVU/qUkmWAmDgdL/SabFK/UaYgqSfVKZsc74YLzOqZF0yuWbqpPcXfeurY
 wCOBBtRF4Jqd7I/X5ogjaIBLmQ/ZjXbIlgMbtzkr9Y6k0SQTlHmskUTZOjnQqxNsED4h
 9vc2o7Bf1YqG1mSA+WWshCASKIzgA6vnHFzKE1OooXEpBh8AE5VhFxMnTFCN5DEV1JQG
 rW+q6wLrk0jEk+UCC+eenPLKDNHeecZMCdFT/4sys1nYkXgNcBKFF52VKR5LfE9yvucS
 OXCcvGbzXKIK5++sHXD4wilYL32R3BHCWtpFMdUDmg3RC0TnkUvo+MpC65qy820YZCTd Gg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3krut203et-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 06:37:03 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AA6WhAH019195;
        Thu, 10 Nov 2022 06:37:01 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpctny9fa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 06:37:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=II+L0h5r1eU9LqZWAfhH643ECyDe6nSZLhguvxohVgV/d8sUwKjXG9oM1brpDGa7n8aEwRcxeCBjTQtrRjx/+M8iWgpokRGboLRo9yie2kavi8CBFltEpQtUkvucIjfNn89tjoB8F6LzT6GbX9Xbed12KDcqRcun0GOr9Ch2xg7LqGyt9p9doGREINy5QpNlO3FA36qn2gHfmlWRBOXaPr2fHcE7NU/EisNifZfCr8z0vQwvhXbq+cY13f3jJ1EIb3rSiSsLQ3oP4SSvhMSX7SuILZYbhmzrsgzMA1w2pRMGoTJKQHZ5ILlHe9Na+UgJ4moh8uVHI02HZTaBT9kUng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kaxW2RDcApFhW7m8PRkOl7vWk5m6HLyL6N8WeMcPm48=;
 b=bDI9pjRZ02+X2TPhOlIeNiHzx7NDNBo7ZpIP1vHI+PHeHWcxaVs5FxvJyYyRP4N0PQJMNhc7uOkNrmfssBlOMaBR6c1bZ6iCcc+8/JdusPV0GhptiLJoR31+T2lRyKSzBQMEpxUPHmRyHu1/yb/CNZVMeBz/dy8xyudM0VyNOB52266+fem8YBuby8BTPjiXhYTXxerVl8hu3dtwoo2SSXPVyMK7KxWlNi/aXYoo+XOe6hUtSNV/5rlHPG/QvBwJDt6fE1t3FDsuhxpUeiOd8sWe6mLbi0ctgLitjFyb559jR9wQqnhAEGkH4SuY9Sh4af09qdp92+YLnNm1sF6yng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kaxW2RDcApFhW7m8PRkOl7vWk5m6HLyL6N8WeMcPm48=;
 b=wsTWAF90nLw6jtfr0Rw5kxQyoib1c34Eufr197W198h7kCmU8GMepk4IQ/ByCNFx5AyJtDm8hwCPhmycCIeJLdLy9V1pp8Y1Ru6fNAkDJqo9xDqoonCqe85WLXo4ZPtuxRlEWYOsnLxNSHKvLL2OBIjuiZvO/OevME0kSKX4kOY=
Received: from PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15)
 by SA2PR10MB4748.namprd10.prod.outlook.com (2603:10b6:806:112::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 10 Nov
 2022 06:36:59 +0000
Received: from PH0PR10MB5872.namprd10.prod.outlook.com
 ([fe80::3523:c039:eec9:c78b]) by PH0PR10MB5872.namprd10.prod.outlook.com
 ([fe80::3523:c039:eec9:c78b%5]) with mapi id 15.20.5791.027; Thu, 10 Nov 2022
 06:36:59 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 6/6] xfs: drain the buf delwri queue before xfsaild idles
Date:   Thu, 10 Nov 2022 12:06:08 +0530
Message-Id: <20221110063608.629732-7-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221110063608.629732-1-chandan.babu@oracle.com>
References: <20221110063608.629732-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0198.apcprd06.prod.outlook.com (2603:1096:4:1::30)
 To PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5872:EE_|SA2PR10MB4748:EE_
X-MS-Office365-Filtering-Correlation-Id: 5909ca3d-b3aa-4497-6954-08dac2e5f806
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EhSQL52qHbci3TEChNmuPTtQCzwQuO2DfKpMsNBMuH2ZbMu1N/D7TsocdqKRNc6RB0KCP325ne7Qg/ERsSFNZGd+EPSvQb9TmnPN+Ev+UDgqwJFnkFZb1w3FFw01IFrUVvMWtjppMT+Lt8YfcJzHARbeT0g02U35RwcV2cnGm2uf1+3/L0lLamEm8SeEZ4/swN2XYO8A/1cboYngUWF4iACq9W/5Ix52w4LKvFRkxTd0e9OjrmhmpMQO5wUxOC9lQ381WCcY2p7g2+Fro/zlKS3humPZOz98KLjkN0HUYbRV8+VYusU5//5FItQ0Zw4/YJA0jaf1XN6vOvyymJbifGv9+1FqV7hXym5BcbNUlbdGhaiJK3PuwZa3XXJAaNYzxn2Fg3I6LZARReI+3xYgesidD3heNP6KAat31tueTUVSm3if/k5bTMl5cF9X4CXvARYEmve5KdblUvAxzH82a+AfXnn/kTnhyeSYr4r/IPjcCYzNl7Dwh1J66dr8R8tMepwWXy1BO3zT/efRoiGmFHyzxzg08fTq1xqhHRvrYN/MHu3i6GRddJxWxLsO6/1BCqS+rHxTHR91lVpNcA8PNfgdzXds4Au6yogRdrWD9dBOgst/pHooJHNOubKglZpCUpSNBNxvWW93k64dIlnqlHzoCYzfGBitnhMHY1u+Rv+eN7vGPV6dTVQq1pobF7g7ZChgpxVDiCMzuL+JCF3rwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5872.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(366004)(136003)(396003)(346002)(451199015)(38100700002)(86362001)(66556008)(8676002)(4326008)(66476007)(66946007)(41300700001)(2616005)(5660300002)(316002)(6486002)(478600001)(6666004)(6916009)(8936002)(1076003)(186003)(83380400001)(2906002)(6506007)(6512007)(26005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Gd2guitR1iCdz6ts9MW7auCMYOA5asTKi5laEbhkKh+7tjwsLRBsj3tJ8HSo?=
 =?us-ascii?Q?NxZ4hBq8GdoN578d0dWK7OYZWDLJPm+vNPdQtYeZPKcJDjW+G/tomxEBJ4W3?=
 =?us-ascii?Q?9CiJoxHOaunwEmlm6C2CcwNaaICwzIZ9FKjK09YmVzGDhiG4q2/cwdyLRvmt?=
 =?us-ascii?Q?XRt4XxDE99c8PuWqew9dYd9cxCs8vRNviWLHLZ/oOBQUdrX0xGtUfKiCJ+Aq?=
 =?us-ascii?Q?nTs0W1fSpsM4ZaoXfmzc7Um3SKX/zcdyTmGtHZnTR6X7qv3hOeYAy229b1sD?=
 =?us-ascii?Q?ZzTtDsk7jR5At0EIi53efQpYRhm8mt3w6fg9SFe+YpCVylH4uqD4lRuKXqVi?=
 =?us-ascii?Q?64TME9ruwREFIlkcrKGBb/o6ThfTeLW6I8o5/DRj5olCAcH+uDsxXuZfqXIa?=
 =?us-ascii?Q?ytpyWh4KpBFJre9BsNKsEMvo3BZC/4gyNQ4rHFVqPlXCrD/DtaacxYkuDTC0?=
 =?us-ascii?Q?aRcA9uAfqnkKWjixlXFmGRE5wVhkzP3QFnNkTUdwHCe0qel94PZB8+jTkHla?=
 =?us-ascii?Q?P+OGzxaJHNQ3VkJ2qRmb7WTFcBTdCGhjLA9ZSQ28D1vOm5K3C0yefb9Cn1QJ?=
 =?us-ascii?Q?evdy0ih7o4OCNBXhN29s3ZbbG6zNRqCcmEzBqt7g8lbrTUlftBiodsfN2+OZ?=
 =?us-ascii?Q?JGrLHEdWKqKa3O0lqcGnwEt6dV0PfNSausaQR+e+pAxc3PRtFVqLd0Sl+zOi?=
 =?us-ascii?Q?D3aFrRJdIpBRzIs4utmbjo3jhoA0dVDNfUQBF4fJOow1gQBmUGz4+/N4XF6w?=
 =?us-ascii?Q?GDALe2L3AK8vFihzFCN/FLxJduDITZXKDKFSEt9es5x7rb0iHayvXi/ZfjAm?=
 =?us-ascii?Q?l2/bL9zPVrAk3yS55rNE1zpHukNanZy/AUk4eC0QahIjiEjAXKim4TNNsWGG?=
 =?us-ascii?Q?cvz+b9G1r0bqhFe4erkxv0nTWVYE4MClsAGG5WLUkyuZn5k/9R9G2AyQFhSW?=
 =?us-ascii?Q?Xrxu1lZKZseIRU1Tf2TJfnXX6FFWNYfxopU00Vw64ZJXa9DS0RElZaVm/3cy?=
 =?us-ascii?Q?aCbFDgiCZAC1oJwehp5c6Lznw3WoSaQxqXYXav4Eh4hDBs1O2lnfJubfwzu0?=
 =?us-ascii?Q?9sADqtT+19lxGte+WE7NwQhAM1yGP42/JDoXaV0U4kQK4dbWMx+x2PTY7s2q?=
 =?us-ascii?Q?fCRpB/sUURV0SldS/rGG0UJur9M0eEHhfyUUotOWHQaCboa7Jz2d2Z9lTWfH?=
 =?us-ascii?Q?iA93BNnteJSJ7oQKcZOwOAzFzgvX2bi+dNMSbKaAhW1eDPa5qNJAmxTxUOWr?=
 =?us-ascii?Q?4cRQAlAHBs/mWkWHoSrj+j0s4KdOsncDsXNylW/9RQV7kto2qON+7Ipf+atn?=
 =?us-ascii?Q?l8+9qU/6x42tBVSo2ktZjADJdD4zwdx7f7IR4hzV+oxdqduY7LwIFJb4QVq6?=
 =?us-ascii?Q?fTCGudAHC6dWjQcN9J2u0wjtz63SLD/XfDLSxm1Ocnbs/FtrjJ+fP7oMtKka?=
 =?us-ascii?Q?1Ln92p3e4JdUOw47oXtnv/j3YoWbq7eFKYxVQap2TzTBb1fqmZYgUxnfBCZU?=
 =?us-ascii?Q?nq66Fauyxtd4ATNi5M7v7gsef3WoOk8cPZr5bNu7+Mq5PUIsF+mvNsz3Q3M2?=
 =?us-ascii?Q?Cz1mh1G7k3dCe91luz7GMXWzmJPYSA2M8rbmJbip?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5909ca3d-b3aa-4497-6954-08dac2e5f806
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5872.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 06:36:59.3627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MhxHWhif3ZOXsyaXu8GjJFf7c9IYAcOa/Z5fDMq2zaOIC3fw27J33iKNZPoQ+P5XglxPbW8DefIAlDNi8ZEbMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4748
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-09_06,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100048
X-Proofpoint-ORIG-GUID: DdMkOEkV0DihC48wTz2WE7J8_5mnKFxb
X-Proofpoint-GUID: DdMkOEkV0DihC48wTz2WE7J8_5mnKFxb
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit f376b45e861d8b7b34bf0eceeecfdd00dbe65cde upstream.

xfsaild is racy with respect to transaction abort and shutdown in
that the task can idle or exit with an empty AIL but buffers still
on the delwri queue. This was partly addressed by cancelling the
delwri queue before the task exits to prevent memory leaks, but it's
also possible for xfsaild to empty and idle with buffers on the
delwri queue. For example, a transaction that pins a buffer that
also happens to sit on the AIL delwri queue will explicitly remove
the associated log item from the AIL if the transaction aborts. The
side effect of this is an unmount hang in xfs_wait_buftarg() as the
associated buffers remain held by the delwri queue indefinitely.
This is reproduced on repeated runs of generic/531 with an fs format
(-mrmapbt=1 -bsize=1k) that happens to also reproduce transaction
aborts.

Update xfsaild to not idle until both the AIL and associated delwri
queue are empty and update the push code to continue delwri queue
submission attempts even when the AIL is empty. This allows the AIL
to eventually release aborted buffers stranded on the delwri queue
when they are unlocked by the associated transaction. This should
have no significant effect on normal runtime behavior because the
xfsaild currently idles only when the AIL is empty and in practice
the AIL is rarely empty with a populated delwri queue. The items
must be AIL resident to land in the queue in the first place and
generally aren't removed until writeback completes.

Note that the pre-existing delwri queue cancel logic in the exit
path is retained because task stop is external, could technically
come at any point, and xfsaild is still responsible to release its
buffer references before it exits.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_trans_ail.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index af782a7de21a..a41ba155d3a3 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -402,16 +402,10 @@ xfsaild_push(
 	target = ailp->ail_target;
 	ailp->ail_target_prev = target;
 
+	/* we're done if the AIL is empty or our push has reached the end */
 	lip = xfs_trans_ail_cursor_first(ailp, &cur, ailp->ail_last_pushed_lsn);
-	if (!lip) {
-		/*
-		 * If the AIL is empty or our push has reached the end we are
-		 * done now.
-		 */
-		xfs_trans_ail_cursor_done(&cur);
-		spin_unlock(&ailp->ail_lock);
+	if (!lip)
 		goto out_done;
-	}
 
 	XFS_STATS_INC(mp, xs_push_ail);
 
@@ -493,6 +487,8 @@ xfsaild_push(
 			break;
 		lsn = lip->li_lsn;
 	}
+
+out_done:
 	xfs_trans_ail_cursor_done(&cur);
 	spin_unlock(&ailp->ail_lock);
 
@@ -500,7 +496,6 @@ xfsaild_push(
 		ailp->ail_log_flush++;
 
 	if (!count || XFS_LSN_CMP(lsn, target) >= 0) {
-out_done:
 		/*
 		 * We reached the target or the AIL is empty, so wait a bit
 		 * longer for I/O to complete and remove pushed items from the
@@ -592,7 +587,8 @@ xfsaild(
 		 */
 		smp_rmb();
 		if (!xfs_ail_min(ailp) &&
-		    ailp->ail_target == ailp->ail_target_prev) {
+		    ailp->ail_target == ailp->ail_target_prev &&
+		    list_empty(&ailp->ail_buf_list)) {
 			spin_unlock(&ailp->ail_lock);
 			freezable_schedule();
 			tout = 0;
-- 
2.35.1

