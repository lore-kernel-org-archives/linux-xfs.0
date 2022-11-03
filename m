Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22C93C4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Nov 2022 11:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbiKCLyt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Nov 2022 07:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231421AbiKCLyr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Nov 2022 07:54:47 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA7312AE2
        for <linux-xfs@vger.kernel.org>; Thu,  3 Nov 2022 04:54:37 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A39OAnW008308;
        Thu, 3 Nov 2022 11:54:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=NiZyTDPtw6zZvVCQO6nCUsFUU1tlQltGZXPiKjVZN8g=;
 b=KsSO+apNC+yZRcuQhKLMXhxyZ1CtqZsYvSRrtYqAY8nOFLZRlNz5TSVrgzWeSMzph3Us
 4eLa6NiEjwdnJTAGxPslMVctVI7/Vis7J9GYoXgoXIonvTj8+JpZ3qT7qFJk0yENoLds
 klbfu/kSGc2rKr14WnD72uZW2MKKzPvr7Lhgjw8Pw/iB4OEShT/SxetUcftUoiqmW9s5
 0bqXHA6+rei1Pr2ICyjlbBms6ZCIvslQDKaTvrkAPh0Tw2Go38cjg2oW6LiDpfbXMJ9Z
 hvztWaYT6XlOg+ltjN3rBRNlebP4sGRr/sj+FzE4BBUg0bKxPNd8amakh3bSFCGyedGA UA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgts1cr12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Nov 2022 11:54:31 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A39Hiag029660;
        Thu, 3 Nov 2022 11:54:31 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kgtm6hhe6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Nov 2022 11:54:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=brA6JheOnVWZMb7SE6egjln4oKeUrLshctmfVEqXuXfggL5EUDol3phKlPtk3twFomfN190Zp1fK5Hozlky1ZtGlO7JYO+k4A4WQ62eE71js3Rl7vh5cbn5ACc8SEMyz8fTq41nSCxAPvrKUbHbnBu7yP/uAAnb3qvc7AlY0ZS80kLJOofpGmpOcxR1E2zqx1I0EPlA9SHS4sYzJ97QjvhxYFhZCxbLvHp1Dqrf2w2OlTtNKE/74BAZ3epNQv8urCoq9c06BXUrQ0orAdDSn3MpmTrkvq/5lQw4k1umO2K5AMj0JlmrtHHLHLOvRfxh04Tfw2px6YLv6ITx6I7yz8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NiZyTDPtw6zZvVCQO6nCUsFUU1tlQltGZXPiKjVZN8g=;
 b=iu+zsE4tV6RFr7gm7lOxCZZmYaa0WVHJJTsqHhWY/F/ub3vK+YQglUgd7oIQX7LPp7xthjsbhyBql+tJ3jKs1VC4eup3BVVYTa53IffXJbcRWV5VW2gyQxH0srLnSFdgw28oB4jp5lcq2/UHvZmUsuHiX5abp2sYtZ+BXo2lMIJA1s4Sfkg9IzF9V29u5DQ82nPBa8DtqBTowf+rxYag+/hmtD6TjYF7lCQWSnrgy5B9hTD1X1LtkV+Vv4M2sjdi+whSI0dKqA9RK4XcrR+GcndgTUVbzCvYhV4Fz5m0wDMMHqgaD43SmCV1iBY845upEha8sWOHo/OZw4+NnHarbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NiZyTDPtw6zZvVCQO6nCUsFUU1tlQltGZXPiKjVZN8g=;
 b=km0FhQlKoivfB5VLn4WvsUpKPn5lehQBQh5A0Rirx1m/65lSD3qUouHuMkn5pGP4Qgb3k/4LktHU2x3NvwJp2N5uM5gSgjeTbOco/8FUettq3qjDOaf+O5Uf+OY29SKmj8cbKtDs5UqhiC65qlNEiH4iVn8tmb+mOK18DU+UB6U=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CO6PR10MB5619.namprd10.prod.outlook.com (2603:10b6:303:14a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.21; Thu, 3 Nov
 2022 11:54:28 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1%3]) with mapi id 15.20.5769.019; Thu, 3 Nov 2022
 11:54:28 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 3/6] xfs: gut error handling in xfs_trans_unreserve_and_mod_sb()
Date:   Thu,  3 Nov 2022 17:23:58 +0530
Message-Id: <20221103115401.1810907-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221103115401.1810907-1-chandan.babu@oracle.com>
References: <20221103115401.1810907-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWPR01CA0049.jpnprd01.prod.outlook.com
 (2603:1096:400:17f::20) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO6PR10MB5619:EE_
X-MS-Office365-Filtering-Correlation-Id: 96758eae-6a83-4736-9129-08dabd922955
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DqxbqB5lw8y0byQ7UcXN2GHXRDwW7xTKdErpbJFMrxm9x2s/H/QmJZIHi/0akLx8A5TfDyMnE8GXofpK9D3LXjLfRWjcBcATZUkRF2FEaFn90+QCbu3oaPgbqKOXZxdAh5W8XYb2JLtkmSWpD9SaMQ9qAKrXNr5zG/u6tpHivHha7tttZRgcmWMMn3BbHDmRDRH1vZHU71O7EwB+F9XTtPl2c5UHd3Dc9HjUeZgkZB9ldryPMHHGWLiF49ZISYYOVDs7Duz8/Bu0tnGzk03BlAxk3x0gENWNHFxIFr0HXtg5kqYD/5paEAAvY+MUYfeOLO9ydEOBNxYqbqjPMv5tWPytKcCYLfeFkaad8sWkzuzhEpSOL/K1J8TVzQEUIrSgkLwOBV7x+8ioQNVDStXjK1Y5+pxnGceR/RtVNEye18gtmozFYARpKiovM1AQRIMasYtRv2jPCiAoIxWkSVW+Dvx9Fi72LgyiXRu70dqkPCPYETVgNirB+hq+D/h0Tts0j9vLoVHWmEdcUgkU/u77Jw7Iuc9n3G7PpuyTW+yALdcoW6z7bdnLgpQvweo/nMWFIJMKD769ghlJN0TwDUJsecdJfSTpcnP3iSmOLq72sXqs/F2vzps59y0G/m6mH7rVJisOFRUQLDq0dT7npVRcK+kTFMqau4hL6slZV61fwzoPbsos/3fyutK5c+DVjGFZ+ppkXrg0q6w7O4ZRyf+evw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(2906002)(83380400001)(86362001)(5660300002)(38100700002)(6506007)(4326008)(41300700001)(66476007)(66556008)(8676002)(186003)(26005)(2616005)(6512007)(6916009)(6666004)(1076003)(316002)(8936002)(478600001)(6486002)(66946007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EURjLoPqwFAAoy6/iAsRz3y989ggz72HRRyMvESRhzO+9L2cXzGPW3K1M4S4?=
 =?us-ascii?Q?IIfqWdUaL72EbpYBgbtL0OwnXcDe5T8AOXu7Zxi9w0KBUCr/oWVolwMIpeof?=
 =?us-ascii?Q?ZPCXFqaam5gS8nqcOfk6/XIrmTltHppnfKcYnXHL/GFy0ZKBJRp5fNorNlHq?=
 =?us-ascii?Q?2ajbb/5pN+HlT2tbf3LGiy/dSCaxGG97GpO044Hmg2LQNb9KRbJRNn9GTQ6M?=
 =?us-ascii?Q?T0P0ZXEb/EnOmtiuCmH/8PpMfqG2+FDjBDbo35DQv4F6rTQ9fHGC492Ua8lz?=
 =?us-ascii?Q?Tht1Y3e5AeK/S+zuKFnB4aA2wz2kHVKxXjbrs1DyAhWmEQ9M1PJnNG7vKycH?=
 =?us-ascii?Q?zafnfsEe3G0q2A5QRZmemkgsX8m2PVWIdgoMOpLpZ1l+gW2zSm0c1357jOV0?=
 =?us-ascii?Q?4ghCjTG6CAZ0TO1QWuI16jwUBzxNEM97maUHaLOLi1hoRih5WWgg+cFfhNn1?=
 =?us-ascii?Q?4KtxoORgKjjS5L1qIY5rzjV2yeWl+tDVfqwnF4MIT/WqH7yNqaBLN+74BD0U?=
 =?us-ascii?Q?KIfNs8LLPDSDMLCPifhRoEg1iVdafv22o64ziNFVO3I0gvAKkB/x9a74Hf+p?=
 =?us-ascii?Q?W/WZDrEGJB29OGQLsvIps0V4Svah7BiRXVmHCIdoyDy51RNJ2ceBBd0Ik3bE?=
 =?us-ascii?Q?PQmD/7nJfleuT8k9GRuakyoFAfyfATmnRAuKxXZujfeY44YubEp4AWBRs9Su?=
 =?us-ascii?Q?i869QdZQPcJOCphSyejrZOeBvWSW6RSbbRaYMUgE0zm5kDyy4OUnBd91PKEy?=
 =?us-ascii?Q?sbG+beIhhAoSMQcrZOqk5NyS8FmvVgPdWoGbQkrirFVR+GcZ45HfwZSIJKor?=
 =?us-ascii?Q?slcZs2zZjjBYNWtJbQx+ebB03kTXGnoIALcd1UPBPD/MTlfVBbMzWk5gtFy5?=
 =?us-ascii?Q?Nc3xav+pjSJwjSjbhkqPxve04/o4tBfNdvrt9Bap6IhcaUj4IaLcYUH0Woh9?=
 =?us-ascii?Q?htv+N9Bg+GXT3QGv81YGfj8vU3503CW7pkj5qqwRlg59wNYGaYandu8YlCJf?=
 =?us-ascii?Q?8RRgS58MHh/74s8XWW+9rfgFePqzE/39LFQG7+UVCyCFzNsEGFDscNz6zLpd?=
 =?us-ascii?Q?yY66hCa2/EI/7giP5rlWDyhms5MFNny1xX8T69RLBFFWRhc6AnHsgx68Le2v?=
 =?us-ascii?Q?8az23/YEGMpOreegw3WH8jcThMfdlk2JrsEgf6nrhmN+jR3z9pQWCnINQN+f?=
 =?us-ascii?Q?63GUYrxlVK8SRM98jz+u5/L6f7aF512T4YpvbFhEtK7KKmpJhxflGotfQ3BQ?=
 =?us-ascii?Q?Hx4wW7sMmNYflnHeeqFWbrCOyj5MAICZLE1fAQ9pscdFlofiz4NDuIArFEFd?=
 =?us-ascii?Q?9bOHJnxVy+IDZ96B7RZSejbgkHBDMMZ31rGL3P06IhO4BI9D5UPECQxNM2Ra?=
 =?us-ascii?Q?LMINlJ6/xMYcOeStFR3rkoNm9FQa/x23JBsfebkmBlkoh1kOdf3Fca+705Ir?=
 =?us-ascii?Q?xhfYsvKf/xAuLN8vCC8s7n0ki29tmcJBDE5sIbvCXaiaFKf3IS7/OAfq7sz7?=
 =?us-ascii?Q?Eqw8XqKsg6kAhSvnKN1M3ne8rY6kgK2VlJwAOKxN+DCCYTl4NOFU2cWSFU9S?=
 =?us-ascii?Q?KcBjOEH+gaswGZGgi/gChbee6CcMe2MtUCpj2SgHcznnOHWfEaTTclPYMkSl?=
 =?us-ascii?Q?6w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96758eae-6a83-4736-9129-08dabd922955
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 11:54:28.4881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0K8LsREG7IvFEhYv0F5NMVTVQ3Al4wYT4ToSW/h99ueg4hFZWoJCjmB67iFN6c5N2FGuQfB9SPXPjf/P7FSSZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5619
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-03_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211030082
X-Proofpoint-GUID: c9FxoSVszt1zYHFeWgqLnq3fGP2_xzck
X-Proofpoint-ORIG-GUID: c9FxoSVszt1zYHFeWgqLnq3fGP2_xzck
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <david@fromorbit.com>

From: Dave Chinner <dchinner@redhat.com>

commit dc3ffbb14060c943469d5e12900db3a60bc3fa64 upstream.

The error handling in xfs_trans_unreserve_and_mod_sb() is largely
incorrect - rolling back the changes in the transaction if only one
counter underruns makes all the other counters incorrect. We still
allow the change to proceed and committing the transaction, except
now we have multiple incorrect counters instead of a single
underflow.

Further, we don't actually report the error to the caller, so this
is completely silent except on debug kernels that will assert on
failure before we even get to the rollback code.  Hence this error
handling is broken, untested, and largely unnecessary complexity.

Just remove it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_trans.c | 163 ++++++---------------------------------------
 1 file changed, 20 insertions(+), 143 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index b32a66452d44..2ba9f071c5e9 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -532,57 +532,9 @@ xfs_trans_apply_sb_deltas(
 				  sizeof(sbp->sb_frextents) - 1);
 }
 
-STATIC int
-xfs_sb_mod8(
-	uint8_t			*field,
-	int8_t			delta)
-{
-	int8_t			counter = *field;
-
-	counter += delta;
-	if (counter < 0) {
-		ASSERT(0);
-		return -EINVAL;
-	}
-	*field = counter;
-	return 0;
-}
-
-STATIC int
-xfs_sb_mod32(
-	uint32_t		*field,
-	int32_t			delta)
-{
-	int32_t			counter = *field;
-
-	counter += delta;
-	if (counter < 0) {
-		ASSERT(0);
-		return -EINVAL;
-	}
-	*field = counter;
-	return 0;
-}
-
-STATIC int
-xfs_sb_mod64(
-	uint64_t		*field,
-	int64_t			delta)
-{
-	int64_t			counter = *field;
-
-	counter += delta;
-	if (counter < 0) {
-		ASSERT(0);
-		return -EINVAL;
-	}
-	*field = counter;
-	return 0;
-}
-
 /*
- * xfs_trans_unreserve_and_mod_sb() is called to release unused reservations
- * and apply superblock counter changes to the in-core superblock.  The
+ * xfs_trans_unreserve_and_mod_sb() is called to release unused reservations and
+ * apply superblock counter changes to the in-core superblock.  The
  * t_res_fdblocks_delta and t_res_frextents_delta fields are explicitly NOT
  * applied to the in-core superblock.  The idea is that that has already been
  * done.
@@ -627,20 +579,17 @@ xfs_trans_unreserve_and_mod_sb(
 	/* apply the per-cpu counters */
 	if (blkdelta) {
 		error = xfs_mod_fdblocks(mp, blkdelta, rsvd);
-		if (error)
-			goto out;
+		ASSERT(!error);
 	}
 
 	if (idelta) {
 		error = xfs_mod_icount(mp, idelta);
-		if (error)
-			goto out_undo_fdblocks;
+		ASSERT(!error);
 	}
 
 	if (ifreedelta) {
 		error = xfs_mod_ifree(mp, ifreedelta);
-		if (error)
-			goto out_undo_icount;
+		ASSERT(!error);
 	}
 
 	if (rtxdelta == 0 && !(tp->t_flags & XFS_TRANS_SB_DIRTY))
@@ -648,95 +597,23 @@ xfs_trans_unreserve_and_mod_sb(
 
 	/* apply remaining deltas */
 	spin_lock(&mp->m_sb_lock);
-	if (rtxdelta) {
-		error = xfs_sb_mod64(&mp->m_sb.sb_frextents, rtxdelta);
-		if (error)
-			goto out_undo_ifree;
-	}
-
-	if (tp->t_dblocks_delta != 0) {
-		error = xfs_sb_mod64(&mp->m_sb.sb_dblocks, tp->t_dblocks_delta);
-		if (error)
-			goto out_undo_frextents;
-	}
-	if (tp->t_agcount_delta != 0) {
-		error = xfs_sb_mod32(&mp->m_sb.sb_agcount, tp->t_agcount_delta);
-		if (error)
-			goto out_undo_dblocks;
-	}
-	if (tp->t_imaxpct_delta != 0) {
-		error = xfs_sb_mod8(&mp->m_sb.sb_imax_pct, tp->t_imaxpct_delta);
-		if (error)
-			goto out_undo_agcount;
-	}
-	if (tp->t_rextsize_delta != 0) {
-		error = xfs_sb_mod32(&mp->m_sb.sb_rextsize,
-				     tp->t_rextsize_delta);
-		if (error)
-			goto out_undo_imaxpct;
-	}
-	if (tp->t_rbmblocks_delta != 0) {
-		error = xfs_sb_mod32(&mp->m_sb.sb_rbmblocks,
-				     tp->t_rbmblocks_delta);
-		if (error)
-			goto out_undo_rextsize;
-	}
-	if (tp->t_rblocks_delta != 0) {
-		error = xfs_sb_mod64(&mp->m_sb.sb_rblocks, tp->t_rblocks_delta);
-		if (error)
-			goto out_undo_rbmblocks;
-	}
-	if (tp->t_rextents_delta != 0) {
-		error = xfs_sb_mod64(&mp->m_sb.sb_rextents,
-				     tp->t_rextents_delta);
-		if (error)
-			goto out_undo_rblocks;
-	}
-	if (tp->t_rextslog_delta != 0) {
-		error = xfs_sb_mod8(&mp->m_sb.sb_rextslog,
-				     tp->t_rextslog_delta);
-		if (error)
-			goto out_undo_rextents;
-	}
+	mp->m_sb.sb_frextents += rtxdelta;
+	mp->m_sb.sb_dblocks += tp->t_dblocks_delta;
+	mp->m_sb.sb_agcount += tp->t_agcount_delta;
+	mp->m_sb.sb_imax_pct += tp->t_imaxpct_delta;
+	mp->m_sb.sb_rextsize += tp->t_rextsize_delta;
+	mp->m_sb.sb_rbmblocks += tp->t_rbmblocks_delta;
+	mp->m_sb.sb_rblocks += tp->t_rblocks_delta;
+	mp->m_sb.sb_rextents += tp->t_rextents_delta;
+	mp->m_sb.sb_rextslog += tp->t_rextslog_delta;
 	spin_unlock(&mp->m_sb_lock);
-	return;
 
-out_undo_rextents:
-	if (tp->t_rextents_delta)
-		xfs_sb_mod64(&mp->m_sb.sb_rextents, -tp->t_rextents_delta);
-out_undo_rblocks:
-	if (tp->t_rblocks_delta)
-		xfs_sb_mod64(&mp->m_sb.sb_rblocks, -tp->t_rblocks_delta);
-out_undo_rbmblocks:
-	if (tp->t_rbmblocks_delta)
-		xfs_sb_mod32(&mp->m_sb.sb_rbmblocks, -tp->t_rbmblocks_delta);
-out_undo_rextsize:
-	if (tp->t_rextsize_delta)
-		xfs_sb_mod32(&mp->m_sb.sb_rextsize, -tp->t_rextsize_delta);
-out_undo_imaxpct:
-	if (tp->t_rextsize_delta)
-		xfs_sb_mod8(&mp->m_sb.sb_imax_pct, -tp->t_imaxpct_delta);
-out_undo_agcount:
-	if (tp->t_agcount_delta)
-		xfs_sb_mod32(&mp->m_sb.sb_agcount, -tp->t_agcount_delta);
-out_undo_dblocks:
-	if (tp->t_dblocks_delta)
-		xfs_sb_mod64(&mp->m_sb.sb_dblocks, -tp->t_dblocks_delta);
-out_undo_frextents:
-	if (rtxdelta)
-		xfs_sb_mod64(&mp->m_sb.sb_frextents, -rtxdelta);
-out_undo_ifree:
-	spin_unlock(&mp->m_sb_lock);
-	if (ifreedelta)
-		xfs_mod_ifree(mp, -ifreedelta);
-out_undo_icount:
-	if (idelta)
-		xfs_mod_icount(mp, -idelta);
-out_undo_fdblocks:
-	if (blkdelta)
-		xfs_mod_fdblocks(mp, -blkdelta, rsvd);
-out:
-	ASSERT(error == 0);
+	/*
+	 * Debug checks outside of the spinlock so they don't lock up the
+	 * machine if they fail.
+	 */
+	ASSERT(mp->m_sb.sb_imax_pct >= 0);
+	ASSERT(mp->m_sb.sb_rextslog >= 0);
 	return;
 }
 
-- 
2.35.1

