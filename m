Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D3CC38A2D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 04:54:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiJXEyO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 00:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbiJXEyI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 00:54:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EC979EFC
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 21:54:05 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29O2eWiO025813;
        Mon, 24 Oct 2022 04:54:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Nznuq4FRySiP7+k27RnzFQqbveqt1ciJ/CKUaIg3dAI=;
 b=ij8zjM40FPPyGsNsCfcf6RRhTtC/WSUaWz1tFyXEdSZ46U1CwLvINcfDK2+LfuNabz0H
 1nHeGPWhyYs56ERxR7cCD5UcC3xWv2J6e+hGMeEp5/gx8y188LCJNgDPnu2nsgYdnVpI
 cep4nhw8dWPPsdLV9Bww3Mi1MzxjChoDwxCR9tS59GO5wQbV5a5tQVQXOvkUZ0Pg84G6
 u4ekPwQ6hi/oqRQjapAqd4aE3TGEIUVsXLqOtyvKWTDD33Yz0LnC5sTZKYD11qyIDV1x
 2l6sDjzKGt4Ul5fqel1CqaVAwa042XH+t2gz6avfiTvyGPfDauZ+vHIuvUNFM/wKbhXt Ag== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc6xdtn3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:54:01 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29O02nep030649;
        Mon, 24 Oct 2022 04:54:00 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y3bmpy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:54:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GvPioCxGtqoFDgzLG3GSp1g0UPbhTTXi8E/t1CP7bKRjvQqd5gX6lSBZvr4djmtcIJEHJHg46Ka2UURQE8JsburponYurNAlaFWM509Ma9aMwQybH4JKxD6kdPeM6Q6XFqRpgyzk2rP/qn0wn7t7uNZLI5nwirZ1CV2xmfK1zRe7MCqp60zi9QdkTUZM6uk0tTDvbHyYzznhHkeMPpzmITw8znZvX1fv0y0AOcVcO84Dyd5CpDsQMRGebWML8Jrm6DW/HZBVa9P7tXRERLo9uPYE3WZqvz6Y9hrhnm/foF9p5ErRMQoyNM6VLX5hqJV9fmIwrtTCkjkSNtTrbGYFIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nznuq4FRySiP7+k27RnzFQqbveqt1ciJ/CKUaIg3dAI=;
 b=dvJxeCZdapvehaihTtfqsqpToSTOV93gIDpOCqLd5Hj2FP84zESHLoMFojl1P2aqpBzT5ltKJPfNYVCxD3n6nDv/8KsEgP4yMccOk4T6vPDg7ypNuf54HhmEk2uUgwmLbrJmO7ny3oW+6Q8gMN/yTDX+l8fPpr4iu1hxTG9UlRjId8ktToOqOfxtSzTjCHUNM8LLooBa6KSy+n/4Bo/2c8hxV4byBOfmFWY4fJcRFzR7ZdkpMANXDHjiKoTaolS358rGAuK5D47FZfIds81saqnp3zoQMez1wmrihPQmKvRLRyn4Z/1o20iD0dg2JqFWq/M7E+AZ7Qd8F6aShq7LYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nznuq4FRySiP7+k27RnzFQqbveqt1ciJ/CKUaIg3dAI=;
 b=L08B3dLJV0WjgZLQBZ1bX3+z1DR6ewM+Gwb0gZk0IeA49S4wo4UvShlWaeCkGONUZO5WGx3+Qkwmn06ytHMmj6bTAWSLiFQXocsQyQSEFCqVn/Cu1u2IJM9mWUnud2kga+4VQFE5SwaB5lA5wv7QaPzp4jw+D55RfpK3FWVd8bY=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5374.namprd10.prod.outlook.com (2603:10b6:5:3aa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 04:53:58 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Mon, 24 Oct 2022
 04:53:58 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 05/26] xfs: xfs_buf_corruption_error should take __this_address
Date:   Mon, 24 Oct 2022 10:22:53 +0530
Message-Id: <20221024045314.110453-6-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221024045314.110453-1-chandan.babu@oracle.com>
References: <20221024045314.110453-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYBP286CA0044.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:404:10a::32) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5374:EE_
X-MS-Office365-Filtering-Correlation-Id: bdb5d7ff-25fc-44ab-288b-08dab57bc2e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h33TQ10bqcPiuYy5kol56ilqqHcE2wtfQ9w6bcZK4kFVu6iGgTVqtwCuL5WMJ/onXskW9XCJfkEdO7F3E6/7vsXf0zJ78CjD6EBtkfeV4+9nbtaIPMPNDGi4K0XxvAaeJOIk8YzRj7lmYRl2v0KhKT24hNc0URHLIwoOzOhBir18tKuzMuaI70LQAJ+X5lEuDfe6PNJCboR6prLdQ1FqjEYhiZr+4nhZ20P0Q3e0hOXrDVNs+GFv3Sg98n9siFHO2eqYfSIWbssgXFtZV+uwwbMbIsX8x9l7Ki62uHqCS/sdf6HKOerYnLEBTvUr8ruNqgIynTbi7noS8IhGQUxUhkFCIFDaqc0GSiNpAR2ni6yyFWkSURJH9hsQG4b2Efgq1W9+ZevE5F9N7VY/5We5zz1WnfDPLSHqfyk2uH1v9itloanpllhxIEsP4LjEgPnSpp+k0mKkQdj38AYBtwM6GkkkHvqnbV3uDwylfWDBHhi1pvY9QnvVkwwZh5PJ1QS1E4wXLhpZ9smoBZoQYT/9DAjXZ6tIhiMS1bn7+vsgeXsy2IkTwCneJTtVu8JGI+KNmWCLqf45OxOARsNSBPpjLfcZbn3I8zvTRxZvmocyToJx0shOVdinI0SI4srcMpMSJ839+wwsEVexmRQxSD9YlKaFfs9hYexom8Rq8edkbH2KRN69kNlG/5/ice40BmrtSDI/m2m5t3Zc/jPB8Yd7lw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199015)(6916009)(83380400001)(2906002)(5660300002)(6512007)(26005)(6486002)(4326008)(8676002)(8936002)(86362001)(66556008)(66946007)(36756003)(66476007)(2616005)(316002)(1076003)(186003)(478600001)(38100700002)(6506007)(41300700001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qXy8E/BagDAG3PcGafyBwb6LgO6k6467hG+wUKJkRO3UhUojVt0MEiGGruTS?=
 =?us-ascii?Q?tEk6jYE5cXz0IcCEaKsrH9ULeydW1A1a/DsZnedhI5gd9HPc9ahOZVWhZe38?=
 =?us-ascii?Q?WNYpKJmk2GpvGB3lhSknYG1BsQMdCQSEvWgjl5KZkiGT151iq8fjuofrtx5R?=
 =?us-ascii?Q?x0wFGRWP7oyHmIfYHuHrO4X64cQ+2IAjU3un0K9h/eSlYFJiD8JoYWc3dB5k?=
 =?us-ascii?Q?e46dWFebNTdoZM9VwgmOZbz0MzfB1u7KqERwTtoT8wvB54sZTdE/+cSdrDw1?=
 =?us-ascii?Q?YCtNIQZLGldyTmSA2pg45FZTxSxdWZxEqXwQ5kBThm9IlWQCrnngRyoxfbVB?=
 =?us-ascii?Q?AgwSATtmAxelTuvXZJj+BhoBWGBNHgDekdj7WxlMfGOfBGm0/EyVvYFJJIx8?=
 =?us-ascii?Q?LgLBiuUurZxbU/SducAVb3EcPK95hgp7leeiOWMh5SDkjzgT2wPAwIIq6/zq?=
 =?us-ascii?Q?k4i+Rn9FQ8MNAkJjkynWFaJ8UA04VlCMwfwb9jo3Q4CS0a7NG/EIYqCaVi8M?=
 =?us-ascii?Q?X8KPOGPSco28tQkZkOOp6PDNyEx2XJJCgY1aDg8oWRxQjqh/xMuo1j+Xzsk+?=
 =?us-ascii?Q?Qg0WDlPmyGKGZUegyT2nDMUdp+t0nkeCAnga5rmy0h+lTd4Acg5mADeBqYoD?=
 =?us-ascii?Q?5Kxk+M9RDH5Vqxu5RhFu1LHcNdyepZ+8Fk0xnIHi2vQzs97jEq56p+x+8Lap?=
 =?us-ascii?Q?dwsRjJ+MvLC2S2uN0PEWZNogOLmAdwJE5mwcwfc+/eQDASnCv6hQFYEBmAWN?=
 =?us-ascii?Q?4ks8p3nS58cQlNQqn8nj6qlZTpNTImWFmPr2PGkBNKNVRieD8E36HSsrmJEf?=
 =?us-ascii?Q?PgNKH9tGrLYIks0lKwUBy7yQI3c7lvs3yf2lTEYW3Ohj8DcLol70FAazWtXH?=
 =?us-ascii?Q?S8/9rPzRZwWKYA4zMcWn8wsDO8sbfvTf5RW07WCS1CxR35vAsMCdHQ/TMxcu?=
 =?us-ascii?Q?H2WFhUQwR3Apz1EDHBKgAgVzObjBTunyj4ruaDD7LhoA74JFsFOlVNBeF/tj?=
 =?us-ascii?Q?z71HXFK2VPuZ9PpnoPIpTtdzFRrwkAtoq2lkxQS8bU49USX7AWK9EXe/ake/?=
 =?us-ascii?Q?vUBhWmt/1rstWBAdbsScjKjiStpAD5ZwtsDsKZfMG8HwzY+ZIjfmheHzw+9N?=
 =?us-ascii?Q?qEc+Qda/vg/ZAU2aSuAOhqfawMq9vyoO1X0zxmhwP0h5LPNoI501bUZteh+J?=
 =?us-ascii?Q?XE7u4+jKGSVWmNPdQk9tv8XXkvoAORvXA4Vnt4Zcj622F5ZO0Q9rBCbDSG4p?=
 =?us-ascii?Q?iBfzK0j8WzJRzIn9Al1uT+II/0WPMEFyvLq+7r/xYqlx233fd99PdEV66Oer?=
 =?us-ascii?Q?qbEAacumdlFXS9Rou/vomQLmVdKJmR1yxHkw3r3slDy8QgqQ1qOnLXQzg0ha?=
 =?us-ascii?Q?YeumY5gnXts1ANQRj5qIPlZpb40GOs0wbmFJfKUlK+K8leEBnXhhBSwqBaeF?=
 =?us-ascii?Q?ZOBR7zFR2CxYU7fgp4L4sYZYkmb9MB7xbjPagg94/Byve3Hb44ullx5+cbpT?=
 =?us-ascii?Q?M7xWRa9ZTQys6dMALW3fpFYp+y/yRE6YnjRRnhkQMjZLcy9Ny6KRNUsAlJLr?=
 =?us-ascii?Q?EFAJ6kfCfkxBXHIU0H2ir69pTwIDYkSiMEBP91CTzk7mGA5XSbZ1GMbHJBqK?=
 =?us-ascii?Q?8g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdb5d7ff-25fc-44ab-288b-08dab57bc2e1
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 04:53:58.3518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kkqdt30Sgfd9d5/5yF/rTHUulsAykSSQlMtv7ckqtV/magjCKo/yYMaxVsz4bs96fDNjXH0sHiZoh6VkQgMxVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5374
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-23_02,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210240031
X-Proofpoint-GUID: VO6sl4DA0kPYSRVY2QSbvj_R2aXYpxLb
X-Proofpoint-ORIG-GUID: VO6sl4DA0kPYSRVY2QSbvj_R2aXYpxLb
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit e83cf875d67a6cb9ddfaa8b45d2fa93d12b5c66f upstream.

Add a xfs_failaddr_t parameter to this function so that callers can
potentially pass in (and therefore report) the exact point in the code
where we decided that a metadata buffer was corrupt.  This enables us to
wire it up to checking functions that have to run outside of verifiers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_buf.c   | 2 +-
 fs/xfs/xfs_error.c | 5 +++--
 fs/xfs/xfs_error.h | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 948824d044b3..4f18457aae2a 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1564,7 +1564,7 @@ __xfs_buf_mark_corrupt(
 {
 	ASSERT(bp->b_flags & XBF_DONE);
 
-	xfs_buf_corruption_error(bp);
+	xfs_buf_corruption_error(bp, fa);
 	xfs_buf_stale(bp);
 }
 
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index b32c47c20e8a..e9acd58248f9 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -350,13 +350,14 @@ xfs_corruption_error(
  */
 void
 xfs_buf_corruption_error(
-	struct xfs_buf		*bp)
+	struct xfs_buf		*bp,
+	xfs_failaddr_t		fa)
 {
 	struct xfs_mount	*mp = bp->b_mount;
 
 	xfs_alert_tag(mp, XFS_PTAG_VERIFIER_ERROR,
 		  "Metadata corruption detected at %pS, %s block 0x%llx",
-		  __return_address, bp->b_ops->name, bp->b_bn);
+		  fa, bp->b_ops->name, bp->b_bn);
 
 	xfs_alert(mp, "Unmount and run xfs_repair");
 
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index c319379f7d1a..c6bb7d7a2161 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -15,7 +15,7 @@ extern void xfs_corruption_error(const char *tag, int level,
 			struct xfs_mount *mp, const void *buf, size_t bufsize,
 			const char *filename, int linenum,
 			xfs_failaddr_t failaddr);
-void xfs_buf_corruption_error(struct xfs_buf *bp);
+void xfs_buf_corruption_error(struct xfs_buf *bp, xfs_failaddr_t fa);
 extern void xfs_buf_verifier_error(struct xfs_buf *bp, int error,
 			const char *name, const void *buf, size_t bufsz,
 			xfs_failaddr_t failaddr);
-- 
2.35.1

