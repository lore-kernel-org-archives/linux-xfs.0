Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E4BC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Feb 2022 01:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245521AbiBPBhn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Feb 2022 20:37:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245513AbiBPBhl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Feb 2022 20:37:41 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E6B19C2B
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 17:37:29 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FMrdxM024697
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=piXmY+S1S6x5J8G42q3OPS42p4KfHP7SjH6+nGTm5Xw=;
 b=ec7Xuj+onWBhwUOcH6V/t6xaxjRYkOwewBirU7rcKQDTWF1DU7+5pq7Nb/TcOjr9nvY8
 AY0LUjBMvQJB++j5L55hAcpZqkGxxSSTwPVyBdFOIXdpZb2+1D46IApvjWHa+SDTK0lv
 rX+y7zfNRU5c9iTcLbIRkZ3hdtJ2bprLdNROSwUv1LCvhl5qWS3wGqWyVRCBIRUQcZ/1
 HPIDwiYRAInqiWJ0Lx3meSNrMoftr6Dcwg5LkAyeqkUqFjsNAEnq+sUBzuhOQe5qxeAv
 yAkkzJ62qXZbw/NKZJqLSKGjdz0kObCRAs0L6N/aDcVAU+n23taLqPilHfn6EiQ2VrsH Sw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8ncar77b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21G1UZxK165528
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:27 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3020.oracle.com with ESMTP id 3e8n4tuxvp-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aLDb3ppU5EI0R0tueOl3skzg6c7Nh9dQDrGJByKEA7oTMF+i4dbA9sX1atG7o3vHbCwfEMLDpZimy/9p0pk9E/Lk7rrcrY+jhPOq3vJ/Bbj9UwUlm2QBC56GYQVrv7jMy0ylDMi6++Gvv2MoAwNR6pejgmouSTq7/D+jeELIZuxaxK8XoumuYJKq7T73ZRfTi95Ygs2o+hQnhXHloy5RaJ4ZDYSxVF7TkcMmIj/NxksciZyECNyXkkMzY/lfCob1tpohSu3GBJNpDqZTBuQbwaVwb1BShEtOMPvfCB0FjxDNl5HkbQxx7L7bFb/7htefkJz+raopzY8OwSCrd9+89w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=piXmY+S1S6x5J8G42q3OPS42p4KfHP7SjH6+nGTm5Xw=;
 b=l4IDfJhb0ZyLSPhdu38eyyjbDYeLwfCCqQ2osUXSR5ddfH9Ev1z6apvhRBjNeNx5KSViho6WwTbkYfkYILv9coHqSCanGV0GAwPTyGLDRl2tgvl0Cf16YU1mvGEzaoioFtVHV44nXLtakY9xgHroWWDKO95AlZVlhOpsFxyExK8hiF7wvEzQnQ8ln5jha8dp7c8xOfY4Wums26CbVXZjoSEXoSvNRsja1cIgqlpkpziQ1kxJizX4mxHurzEgC3CIlFhhj53n12pM5XZNCDcx+htb/vd+NYI8obrPpH3T4qZkI185a0dLJJVRTUA2W9zHT6gY5WANMwdT5ieBqAnNlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=piXmY+S1S6x5J8G42q3OPS42p4KfHP7SjH6+nGTm5Xw=;
 b=Dv+0KlbIbLnJuExNrYEj+b8wUQYbsdvLsgy42gAwW98U6o0pM8fUtvXoQSa4GtCEdfyociU5mu6SJkbDLxIPZAl5cPUVzqfh4iIejSgKw1SBKR0QtSC7GYlxucH5ROUHiPCF5zF/teeQMDlydj+ewksolzNMjAxndar+K6jb10Y=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BL0PR10MB2802.namprd10.prod.outlook.com (2603:10b6:208:33::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Wed, 16 Feb
 2022 01:37:25 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119%6]) with mapi id 15.20.4995.015; Wed, 16 Feb 2022
 01:37:25 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v27 06/15] xfs: Skip flip flags for delayed attrs
Date:   Tue, 15 Feb 2022 18:37:04 -0700
Message-Id: <20220216013713.1191082-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216013713.1191082-1-allison.henderson@oracle.com>
References: <20220216013713.1191082-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0046.namprd07.prod.outlook.com
 (2603:10b6:510:e::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69b0ae9e-5b14-42ab-b1bb-08d9f0ece09e
X-MS-TrafficTypeDiagnostic: BL0PR10MB2802:EE_
X-Microsoft-Antispam-PRVS: <BL0PR10MB2802F3E3D87C52DEB612E2BB95359@BL0PR10MB2802.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y5nwANfWYA54HcygPD7DgU+0Qf7ohasyjQaxLp6YMZws61QjKzRIp9ie1mQ3SU/6zh2oLVkIs0C+XJpsA4STu1+M8J1HzAFekZQ/ykwDHk37bgXsP/T1vr2xBWqWoTx+JIulu2EeSBf/Ost7qVdwV/IObDhT3Mu+bXJtxcU629BHSrCrDllPN67nqR5yWHlB3Sf3tlaLDIoaAmxqVqyY0LQjQRy6EQA2bx9ffHs0EcBYalKuGUNsid66zefQmRNpBmvoU2HLcjej/mhLrM5UW5kTv7d6ckMOtz/saD+KaQ5mzHH0bIp5D2N2lSctFi6qhRJr33k7amysfQdpzJsBDxDv+R08D9KlgAItC8cD4l4cTQcf5uXi514Zw9pKKsg7hHIBumHd7xj3IzI+qhujCPU3jbhign2oM6F6mv/rjsXrXyLFRvh1eOT7OSI8UV1H8JOyL2CryZ/Xccq5b6LRFlXgoa5kM8ysskvLWo0UsI3GvyT0D74uTEOFxQOMRBwQwybXS2ufloKTTfR5EU3ymlIoPrH4Wa3t9Xa2RLiweIC0sGu2NeCLXNnetlm0fu7Fouww77MMIftydHhU9p7vigUsh+VWSs1xPdsOQD4D1OOuFfwtaBNscy+NqKB6505z+r6MY9rZRFC1umX28/ylvA5MW8FAhiB1uPoicNxtmqSCLekI/iYK4YEfD3WA3Gs56EaXBvJpzjOnnoygM8Q6ZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(186003)(26005)(1076003)(6512007)(508600001)(2616005)(6666004)(66946007)(5660300002)(44832011)(38350700002)(38100700002)(6916009)(6486002)(66476007)(52116002)(36756003)(316002)(8936002)(86362001)(2906002)(8676002)(66556008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y8w9Tz2s/2/No1dd6bcJeiwr+Vgi3mchWPmi8ONSVTMv48RkZFOuRa+/vJTp?=
 =?us-ascii?Q?mJJhmG7oVE1kJkmGUGItNPoPTL+JrkMTX4i9xwqmqllMMY16Zd9JT1/0PUeu?=
 =?us-ascii?Q?dccf/u9xu8TTmIVeSrmN8k6fuJ/XjazlMkmNgJLI5UWRLLWOM/DHRTcnfqs7?=
 =?us-ascii?Q?rFhgDDU9HJbjeUhdEt9sLJj59z4YJdKtZqFg0IdgdUrFAIH9+bc69Ezl9/Ed?=
 =?us-ascii?Q?QZVqOyVuf3ZaaGJsGyIBt316/f1s5HTJJvqNb/gjTRp4Jl8H4aU2dvToM0nI?=
 =?us-ascii?Q?gxdHcURuNlSfSCr5UHOguo0z7F/4Bb9uWsM+EGTeCRhopdavWxeFDcbWQ0lO?=
 =?us-ascii?Q?9F2O2qGu8EX0CEPilA5jF8d1u9Vq3GwojXYfm+Mj6DKLjoViE5dgr5XlETNK?=
 =?us-ascii?Q?wR0Qew+LlQxbk8tOpfOWbNfZksjxw9VP5q3ufrw6hZSiMdcizD1rP23Vh/4s?=
 =?us-ascii?Q?qOA1Voo4NGgp0p1eUCcewbLUVgxIKwkVLFhGkLdrlR46kjRJP/N3whHU6HJ9?=
 =?us-ascii?Q?1mrXEHOnTHoZjKmlAwwf1NY7ZLvfWm/BewiYE+sqiMuWpyLbqtx5fV6oJgdW?=
 =?us-ascii?Q?MP7EwlB364NZIByRXjT6k+lKq3IrXjDRj4yDwR4owprwCNbD8bSNuUetYz+k?=
 =?us-ascii?Q?6CTR2splEwI+YNIsK59vNXI7lh4Q3GfYHXB6lQG6cU/EA4s3xJuOot0wFS7g?=
 =?us-ascii?Q?wP7IMVSGDiZSrRZdd0zjLbMSUeOhxnOhe0K4itj1exnZCa1Cf2zA9vTcoJUP?=
 =?us-ascii?Q?xe2U+r0T2rstloE6zxhGzV6/w2H5ZqAEMN0swP1OnP5BrbeuwAHdGZSKacUX?=
 =?us-ascii?Q?zFY0g2mC3TzFuek2lrHEd7J4qGzqhoXJn+po8rm9uImY+ZtCXBHzYRRqxasp?=
 =?us-ascii?Q?T5ojXM7fNmRksGQyz7wJJOML12vm7sMT8IdVb4YtJJJ2OZW06vD+0orAGPP3?=
 =?us-ascii?Q?6j4ywITt71qErAL+9altQt6s4gLBF/xNIBUhBVGWBSPpAwIikL1bANBJNvaP?=
 =?us-ascii?Q?HnoYR4py79p5TkDPFBh1X/9oDAi+oEzSK7tahLpH5ZCZzXXj4WTTb45I8+jG?=
 =?us-ascii?Q?psbN6S8H2ZsPe6YdGG0KcaVEni6/KvHwachmyhx2Pk6M8sK8CebzODG0JZpt?=
 =?us-ascii?Q?9qSNTIQceJ7n9tLJSCxmLqZDisOq5DK6kpeo39jTMdA0KZ+4kxMMEg3L5Gic?=
 =?us-ascii?Q?sLjuNqKsqQ2HqjNKTzP4talySFWoGrTuetKpXqy4ogkr2j5C1qx9kGbFX43J?=
 =?us-ascii?Q?uCpmeHy+3JnWE/S2gQrnUQ28jFGoAOdO8uwph9w8yLwW1wc3PoiDUoSMp9YA?=
 =?us-ascii?Q?nQvqr3Kf9dVukevJROAIM2/tvxtlnU6GHylrytM4f4Cjavs+F7dDWxLSkDFo?=
 =?us-ascii?Q?EwUc64pBr1+ZClsF6IfMWlv3lkRT+4iNKM5xFWdz1hgHAZieDiT5fU2Egu1S?=
 =?us-ascii?Q?hjmhVsKyBel5Yv6ijcPa6WvEk/ZWOdLZLDcKqhJtJb+R1Y+XSqQpD0EopSgo?=
 =?us-ascii?Q?IQJ7BiVnuRAULcIbM4tRDxj9XDH8gjitZLnZM2lDU1RRlvBf2R5H/IpfLYnr?=
 =?us-ascii?Q?AtFzmw0JvtOU5m+Z0walCkx5XKD6oME+0n+R73o+YfHog6iqL9UDmSS/MWR8?=
 =?us-ascii?Q?yH3ruQOt++FXmBO2erbSmDMoreYHYRm/iz+1Xmq2AEPhwsLgcPYslXdpAMS/?=
 =?us-ascii?Q?/PnRvg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69b0ae9e-5b14-42ab-b1bb-08d9f0ece09e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 01:37:22.2330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HtB2rK78gq/0bHhrPlVQ3ba7WdShI9EgU0wgjL7whKU1JT4SXf+QjBstxS3azyWONSJ8VD9jUdgfyRFzKwJeNdqQEULpLiq43cQZ8kfR6Gk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2802
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10259 signatures=675924
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202160007
X-Proofpoint-ORIG-GUID: KEUtBTYs5qwYYhrwsDbJXISrOip_QQH3
X-Proofpoint-GUID: KEUtBTYs5qwYYhrwsDbJXISrOip_QQH3
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a clean up patch that skips the flip flag logic for delayed attr
renames.  Since the log replay keeps the inode locked, we do not need to
worry about race windows with attr lookups.  So we can skip over
flipping the flag and the extra transaction roll for it

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c      | 54 +++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_attr_leaf.c |  3 +-
 2 files changed, 35 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 21594f814685..da257ad22f1f 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -358,6 +358,7 @@ xfs_attr_set_iter(
 	struct xfs_inode		*dp = args->dp;
 	struct xfs_buf			*bp = NULL;
 	int				forkoff, error = 0;
+	struct xfs_mount		*mp = args->dp->i_mount;
 
 	/* State machine switch */
 	switch (dac->dela_state) {
@@ -480,16 +481,21 @@ xfs_attr_set_iter(
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-		error = xfs_attr3_leaf_flipflags(args);
-		if (error)
-			return error;
-		/*
-		 * Commit the flag value change and start the next trans in
-		 * series.
-		 */
-		dac->dela_state = XFS_DAS_FLIP_LFLAG;
-		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
-		return -EAGAIN;
+		if (!xfs_has_larp(mp)) {
+			error = xfs_attr3_leaf_flipflags(args);
+			if (error)
+				return error;
+			/*
+			 * Commit the flag value change and start the next trans
+			 * in series.
+			 */
+			dac->dela_state = XFS_DAS_FLIP_LFLAG;
+			trace_xfs_attr_set_iter_return(dac->dela_state,
+						       args->dp);
+			return -EAGAIN;
+		}
+
+		fallthrough;
 	case XFS_DAS_FLIP_LFLAG:
 		/*
 		 * Dismantle the "old" attribute/value pair by removing a
@@ -592,17 +598,21 @@ xfs_attr_set_iter(
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-		error = xfs_attr3_leaf_flipflags(args);
-		if (error)
-			goto out;
-		/*
-		 * Commit the flag value change and start the next trans in
-		 * series
-		 */
-		dac->dela_state = XFS_DAS_FLIP_NFLAG;
-		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
-		return -EAGAIN;
+		if (!xfs_has_larp(mp)) {
+			error = xfs_attr3_leaf_flipflags(args);
+			if (error)
+				goto out;
+			/*
+			 * Commit the flag value change and start the next trans
+			 * in series
+			 */
+			dac->dela_state = XFS_DAS_FLIP_NFLAG;
+			trace_xfs_attr_set_iter_return(dac->dela_state,
+						       args->dp);
+			return -EAGAIN;
+		}
 
+		fallthrough;
 	case XFS_DAS_FLIP_NFLAG:
 		/*
 		 * Dismantle the "old" attribute/value pair by removing a
@@ -1270,6 +1280,7 @@ xfs_attr_node_addname_clear_incomplete(
 {
 	struct xfs_da_args		*args = dac->da_args;
 	struct xfs_da_state		*state = NULL;
+	struct xfs_mount		*mp = args->dp->i_mount;
 	int				retval = 0;
 	int				error = 0;
 
@@ -1277,7 +1288,8 @@ xfs_attr_node_addname_clear_incomplete(
 	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
 	 * flag means that we will find the "old" attr, not the "new" one.
 	 */
-	args->attr_filter |= XFS_ATTR_INCOMPLETE;
+	if (!xfs_has_larp(mp))
+		args->attr_filter |= XFS_ATTR_INCOMPLETE;
 	state = xfs_da_state_alloc(args);
 	state->inleaf = 0;
 	error = xfs_da3_node_lookup_int(state, &retval);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 014daa8c542d..74b76b09509f 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1487,7 +1487,8 @@ xfs_attr3_leaf_add_work(
 	if (tmp)
 		entry->flags |= XFS_ATTR_LOCAL;
 	if (args->op_flags & XFS_DA_OP_RENAME) {
-		entry->flags |= XFS_ATTR_INCOMPLETE;
+		if (!xfs_has_larp(mp))
+			entry->flags |= XFS_ATTR_INCOMPLETE;
 		if ((args->blkno2 == args->blkno) &&
 		    (args->index2 <= args->index)) {
 			args->index2++;
-- 
2.25.1

