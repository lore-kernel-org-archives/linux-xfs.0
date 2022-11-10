Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09AA1C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 21:06:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiKJVGi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:06:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbiKJVGf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 16:06:35 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7AB256554
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 13:06:34 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAL0ceM006976
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=MzkL1+og8BBbHcAd1pLc6d50XciaXfwXfxpcmboAL5A=;
 b=iiyStYjYmGZhF29yMf1/3KFOtk+bU479QofgFesx6k1qNNY29CzxcwVxeZexL+4eNdS2
 5nYUx2+Y2qQds11Pa7C64hodYttOhMhPHG3LD0TJvHWI5B1+EvwDQiAKKtPebUuZfrsb
 iIWk5zoagzo8QfaS3RQviG+y1yE0tb8NweaLRqkFnXoDIz85OxErKuuc4QoJxRzZXvfv
 eCUlWDxTROIjvjXHByb+rvSLFpZ0OHLi6FUpMdpMY6d5FvIYOSYFW743pKRGPzSdoJih
 54Mt/VlTuvnDOXwafKv/5eXbc14e/S6nNhYa76SyyQ8VrETE3dJH89ui5xCIc7ZtmC/X 2Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks8u5r1an-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:31 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAKpxbb014959
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:09 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpctfrek5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hXD943daaYzgrJ2I9XY7iVf0tDqueGi2WsEVMThnSyAivDWNKWbRt+IpAWSsEF66NzwmnRNWXKVInSfTEe/FIGYwlvdSx5HtZ+kp4citq7WlhHqoI6ftCEpRQCfQNswrY+sfmuwjrYYNq5Pdgo8rBrKz6528OP6JGzuQycoF6um0IiTZpu9vpkWguor+UdqnmAZdbPxDvax+B/RxnZdQJWlowPvybcqQ2oeCPINVOcvIrNOUW92cbCc0C+96OeJ1nqe7VOMFGhztpfwBorRh/z6MOH5dr4oMpxJk3lU6erCV7A5hEas5OqBXtets8yMDum5pTqPus+AXYjs8dF2dwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MzkL1+og8BBbHcAd1pLc6d50XciaXfwXfxpcmboAL5A=;
 b=E/vJ372tIK55lExQIA3Nq4MQ12J4MQrEB7irWuHetw+h1qTt0D4OsMm9qZCCpobZ2Kcu33wQeJFvIE12xuBjcLdJJiEOskO617k2jtYrTAZDDqhPp3vLIE1Q4MIS7AoKqtb1jMiArJO+kAd7TUwW2WFlTEUWGZ12ZVF8LKHVizF7ilTTyzNdU4YCcd/gm1ITSYll3of9opx1RJzRXyB1vnjARq4gjB9JJs7ugBhKhdSMddm0++Wm6o3vfeMIM+hAWvwkuYAIxBFO5UdKG8I5wSBCcNpwuP3c2avNdDK/11z36WxIq7QCs8pEGkZs82rDE/Jke2wXWOoLMh8fx6s2hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MzkL1+og8BBbHcAd1pLc6d50XciaXfwXfxpcmboAL5A=;
 b=QmTeLkR3ugcz1Q3+5cOg8aW4OMMHTFgzZxL/ZvkdKI+KH09H9iGNdkMkCgN23lExtxR6aP8GgWoK2WQNAn3oNxhrCpjmx3U1HgRfFMnSWkppFH9WyAp2fyIbQtK/TmbZ6BNL/RhA+CgRho1taW8PZOwAGadQ+Co/1X7jJRY4FD4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH8PR10MB6527.namprd10.prod.outlook.com (2603:10b6:510:229::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 10 Nov
 2022 21:06:08 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 21:06:08 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 20/25] xfsprogs: drop compatibility minimum log size computations for reflink
Date:   Thu, 10 Nov 2022 14:05:22 -0700
Message-Id: <20221110210527.56628-21-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110210527.56628-1-allison.henderson@oracle.com>
References: <20221110210527.56628-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0126.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::11) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH8PR10MB6527:EE_
X-MS-Office365-Filtering-Correlation-Id: 09e80fac-dd2d-434f-7559-08dac35f6372
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pnEqh8cTeiMfh+4848IbC8hpfJVsHRG7/uOo52qPk7xZy8jjZCTxtnwuTzz+YgazlMrwQrAeNu7NoSTyxiW1uGRfVWJI7eEokzZtT6+/7T13QSObbrEBGJI1D9xRb+v45qDoJck1zPqncaEayIdVUv0sSBh6zsysVAAraUlP2Lpu6r1kjLUz5Q2VublwPuaH7/nkC/MknHEPhG9e7BlgwjGM5d8Xe3qKaHgfGI/hPQHci4pjQgv4pT/XzsrYH/Kz+mdzAMsjoBESXcKc/Bz37/ePQox0vqn2NCiXVgwWCkWtYh/zMf1v+Ulxu2GuuWWKxkloj5XkUufcEY8RfW4KCvb8j8w+e+5A19RS5xJ0Sz08CBMUgHDif/Z0AhqkNg0MfYFXuGauVo9gzhARA/ofSWYzgl0m16JDlf9SE5byvF/mrh7/aF0KS5qkjgOtr5Ssyl/hbsTlSS7LAjz8z5UGD0tMdZf27VGU/HkDMcnLbAds4XVIpqe30HahTFdI9Kqhn6Mv6982lhXO/BfYX7pbeQTFmPdvf6opj902JiBki1VIVkBTIiutGOkn/JGFAJZfFZhKYGl3LWJrlvSIoku6as+toqnk9WfN2H7oaZkg45jjFJq1pR5zJK6xXXzZ/BqUVQCrxB/2uB2e3zZzYztrUDDMhzrf8Fke1qGskVyBmUeIH0IzwnVtMYF7uhmFf3LX0XJ8FcvVwvaa/19J6KKq7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(136003)(39860400002)(451199015)(1076003)(186003)(83380400001)(2616005)(478600001)(6486002)(6506007)(9686003)(26005)(6512007)(6666004)(86362001)(38100700002)(2906002)(66946007)(66556008)(66476007)(8676002)(41300700001)(8936002)(6916009)(5660300002)(316002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hBoqywX3TbIChYB4XJeUu6nT3UCtWoD+VzQne1gLBD2E419Af8NZPqUfYR8i?=
 =?us-ascii?Q?aSr8rcCO4Jzi9dQlkEt5MflNe92dzkw+8jtzWHoQYTDxXuLlAt66ZrWGXtxU?=
 =?us-ascii?Q?8w4sQlFpj/fTpExbGAcMZ5aP6ZBFSXrlH+EbHJ003Rets/ulOkjaHb/mLoND?=
 =?us-ascii?Q?L0unxr7ptoLoLEQzY+X2nOtHz5VbpKMN/SVCHoxYTuJ7n2hPJ35BbGgC2/T9?=
 =?us-ascii?Q?X+v1VsE/CnXwXC1wA2TRqb88ZZBW0z5QipF2yosgvhVVWaAsK38fB1Qpht3M?=
 =?us-ascii?Q?SqVMRLPrhGwzWZxCODuZJ/ztE/1v1DCMRHsJWCw0bWSngAAGLc8ziI6/Q60y?=
 =?us-ascii?Q?ekfl08UCvGiT2Luqzw6yRNCyFLxEZv7ETeG6rz7V6hI5hdG2iQfBLhluk/L4?=
 =?us-ascii?Q?TvJUQ8i2IUuhvWtkBxktWUt2QD5vjOY8Qq+e+gz/uNL3wQNhmChWPzQcUoEH?=
 =?us-ascii?Q?oHTUL/maG6oayulC6PcnM7OKl2p2Hi8dhKGqK858c/HsPWKZT7NMvRnZF6sv?=
 =?us-ascii?Q?IC5bR6ZqHyc2T4CQ7GiSB74UeVN1UA3GtsXKzp7Q1t5pYaMzBS74kYBk6CGv?=
 =?us-ascii?Q?w2/oTVrdy2p23c3Y5YcatqJ14DhQcIFzX8et3+XV0vpMl2kMKh4/mTyUCCrL?=
 =?us-ascii?Q?s4uBs/7lC0tSwzo0fzvo/8cAcYE80LQm46PXZVBlR4/DkBJ7wI22mC/2MmVx?=
 =?us-ascii?Q?MdsbwtuB/jBjv3PrMYQ6XBSNxB89OfZ6TUvXeIjctEE9C9PSOut/D4ee9VSK?=
 =?us-ascii?Q?PlETbyl3xtiDEEmIjvZlvjbnDEnrdYbEaAzUfQ7lBXC3JeEP4K5rAtRx1Qhq?=
 =?us-ascii?Q?FXkI4cZHtmbUdY+c4Ya5gze8u21Ed5TkxGD+6ofPGg1uF9QFZW5FhtxYcPUE?=
 =?us-ascii?Q?knmoVwVTO0hg0enCeRnVNX0aCiahKMKObGOzsJP5D7Euyl7SmLJ71f8hLIrg?=
 =?us-ascii?Q?G1ODwbfMh0+E/VlFAmSzNV4sDxfeLyef7hIng9y5vLh1Kn5DAxmDvwH70bIj?=
 =?us-ascii?Q?GZTfOsPLy6Lf+n4TGzCe2oh5+25R9gQEyGFBwWHamx6W3RGxoSUzkn6Ojb7M?=
 =?us-ascii?Q?vfktFJUyC/Mt/SrwW9yKTdJv82ZltNXN1+9AyE55Ho53gS+FgbW00LdwH3hL?=
 =?us-ascii?Q?wza2htYcZSVC/KNOfPu+C+ut2wTSaCYM6h0b+QF03YJSNinA+ULXUlOPgU1q?=
 =?us-ascii?Q?OGu25QZC4xz8+/3soEth3CkU0dqB3NbyKkhKQLpblzz24T8Rqp3OPhdi1P0B?=
 =?us-ascii?Q?Ul78SbB/uok627ENlBl4q7i//ZrqS8QFyFlPt77+cQX5Qni0p8XrSa8xgNqa?=
 =?us-ascii?Q?v5PPdYCjwQuGCAH8rlSLsgTcHdjPzZL5R5HzBxXVTCBVYRsOtedjanrDPoZP?=
 =?us-ascii?Q?fSdABwpLT1vEk13260Ds+wC01lyLisE2/V4WzFAEtdRww5LXBwxviciQZ22A?=
 =?us-ascii?Q?IVXxdz8IA9sFIr4HcFpj1Sy/taHCZYy3r7j8SRybW5O0tkv2WbwQKkU3hpSt?=
 =?us-ascii?Q?TmyK+pMC/oL9/Stn4O/kwfN8kNrtHOqprfiAvex8zXbtK1jvLhYH5UfHtz6/?=
 =?us-ascii?Q?V6dAhrT8ZZMbAy1VoVeMitMbj3eszObCJPkywU7/d6+e9jIHM74ZSNys+ae9?=
 =?us-ascii?Q?IQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09e80fac-dd2d-434f-7559-08dac35f6372
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 21:06:08.5038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b59WfPn4QIlVxOe7T65JVsmie8YBOyCQHzHFvX8A11olMhTs6f7iC184Y94mD30jrZ8kTd84LdhAWXmX9NkMAigcT5DNQlaTbG+Rie69+rA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6527
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100148
X-Proofpoint-ORIG-GUID: ifcp8i1xFT_3nMp14Jsy7sedfdC3-bYn
X-Proofpoint-GUID: ifcp8i1xFT_3nMp14Jsy7sedfdC3-bYn
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: c14b8c08a1dff8019bc4cd1674c5d5bd4248a1e5

Having established that we can reduce the minimum log size computation
for filesystems with parent pointers or any newer feature, we should
also drop the compat minlogsize code that we added when we reduced the
transaction reservation size for rmap and reflink.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_log_rlimit.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/libxfs/xfs_log_rlimit.c b/libxfs/xfs_log_rlimit.c
index 6ecb9ad51117..59605f0dc97a 100644
--- a/libxfs/xfs_log_rlimit.c
+++ b/libxfs/xfs_log_rlimit.c
@@ -91,6 +91,16 @@ xfs_log_calc_trans_resv_for_minlogblocks(
 {
 	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
 
+	/*
+	 * Starting with the parent pointer feature, every new fs feature
+	 * drops the oversized minimum log size computation introduced by the
+	 * original reflink code.
+	 */
+	if (xfs_has_parent_or_newer_feature(mp)) {
+		xfs_trans_resv_calc(mp, resv);
+		return;
+	}
+
 	/*
 	 * In the early days of rmap+reflink, we always set the rmap maxlevels
 	 * to 9 even if the AG was small enough that it would never grow to
-- 
2.25.1

