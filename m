Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55EACC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 20 May 2022 19:00:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233482AbiETTAr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 May 2022 15:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347982AbiETTAp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 May 2022 15:00:45 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D842DE5A
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 12:00:43 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KIeRZO022596
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=zo4h1a8Dmi3hrySNBjPGfgop+JYGOVWf3w8RAjoZryo=;
 b=k9BP6GtkRIa4dkofYJAM/8YeWmvcqpX6Ydc+d8JApw9UPdi5YP7jne2u07X0HzaPCxy4
 LI8epKg4qEEbFcSBbeUUFBGStnNOO1DEXVZCk6Pl0l95RoCjwLOlehwKdatqUw9kaLIj
 /3WPNhIH7+oPXTVluQ4g5nUPVRFwBlWvxDREptNli/8N+lBAGTB+QPTSfv1xpTrQnxr8
 VutmzB/YQap/CilLlbJ1M24gcR6DARX98ZN8druazYvtw/VTvBL1s1b7STlQ1YwxBYyG
 pnjoox5kL23GPsp/pSicyJYfgrMlKGJKzI7VGV9QsX/u1zYTZbuSFYBi9Ka2VIMXJI6s LQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24ytyx7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:41 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24KInuZO009768
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:41 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2041.outbound.protection.outlook.com [104.47.56.41])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v6rkwr-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=efaJUxps0Leln5ageEpoEIAc3EjsDwHMpAItj8g1EoZzZT8xxRcwJeyXEAwm6pbmXJASMlEfK1Pr8BMha6ILqjX7q1iKKcR2/LamPQX8steh2nPnUc+RPDV5ICTcpzLBVSdunwP5KFUCFqPv/drmprSCj8TY9nrSrtHlfuM5kySC0E4PbhptfISJKn9wXe5N7L2CZJQigUBWyLCRaMoLXbth5ovKKdpaw60CKC/7kFNua/FXh4jC8KxSOrrPmI9OZ5O/ihbAfT+r3gckob1Ez12oZGml3F2y2mVPVrD6RaIThYXrmp/QrKKTXlrd6qDitEsIgTf2+iVpa9og4kRCig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zo4h1a8Dmi3hrySNBjPGfgop+JYGOVWf3w8RAjoZryo=;
 b=R0IpICTDITN4tKHnpAtmA6PDH8Hz47z4o0LXimuZ1Xlzelag0TdS26bCJFwpk1LKBqStwiTvO2TPeLhVv5G6zhMTFszPoT+6KcdVVVmZ8yuzMPSIhEkTjCmp4Q86PQDPx0XQMgZQOuwKSLtRLGK+6oT0Hdplgcu1Y5G1YpQ3h393Wt5flwdVGYiQslyeZysoI24WYwoO2Ttm9Y+4b1Sfa4kLpX0StdzBic7iBSrb/MmTVsKfqMONhdmBUemZcpTGKnPpvCcnnhzhOCrORvw+wlZLiYYTIJw1/AtereR8dHwb2eGABf9AK2SAY5LBP118zPnirZjVv3Sr24Z6icX/bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zo4h1a8Dmi3hrySNBjPGfgop+JYGOVWf3w8RAjoZryo=;
 b=OpKpIfiFPsndJbFVOnAB+Ve7bCJssd5HomG4CGgTt4kPfZs/eWT+FQwsSWwXCSRioGBSduvA1HM4xD+GXf71wEhaYMzVvXnTIdcOdMvrTR6YUAtSX2ml0cYVf+tOtCXNQKdqYddjJcAg/5EsIC8ltPO+9O+OzBF8X0SDNFgt8Pc=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM6PR10MB3658.namprd10.prod.outlook.com (2603:10b6:5:152::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Fri, 20 May
 2022 19:00:38 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.018; Fri, 20 May 2022
 19:00:38 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 02/18] xfsprogs: hide log iovec alignment constraints
Date:   Fri, 20 May 2022 12:00:15 -0700
Message-Id: <20220520190031.2198236-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220520190031.2198236-1-allison.henderson@oracle.com>
References: <20220520190031.2198236-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:a03:217::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d53736e-32a4-46b7-dd06-08da3a93070b
X-MS-TrafficTypeDiagnostic: DM6PR10MB3658:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3658AF5FF0C2DBEBE039933A95D39@DM6PR10MB3658.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HQH/f4fO3Q37/vWxXn68SddW6v4N0EebJiHDdCyJTAIXVpHeYZRTTPYNIGkiOkm12mfAzGQkyxSSTywVklV9HXr7pZCKKZR8v+KRoJTvVyaDxtZrroaXljP8XlGELuv9FPKdfLc9Qf6T5z04fPzR5w3BJBjp5G59dYsZVj6x8KpD0xicqTPkhlQwSUt0NzV3ceWW+mg0HKrCttFwTTw9JfzlU2C3o4UrGZGmy2rz+HTYNb92HXQvj/6HPv2R/WPFlswlp+UTEeQF2iDrUYB8uZ5dhD8RAvXrOlPELQi7KnMqlF8LqvdZKvUg92QGxmnOH0qu5CuRj2IwcvVKNZXkHaC5VwjPLeBmeA5ruXqbxbZNZyLwXVbgO92LyOT25Fhbxkkgh8BTH+Be1PQ7gE8ryL0EG6WTs/Vn60U+6XnGRQ8ld1RvyRcNQN4bBzyxWhOVDH2TpXimUat0EWh/Sr5A3+sUSmBmS1QFHnDySWa8CSpy3e6iU6GRAMw1zATAKZOrx/SCfpx1Z9EJIZOJZ3Jsn2TqN9HRG5E5n4G/anNzDI1LAxfmuyEY2oh83hs6VXTzMSPdtGuzI/mFpCdb51pSFZkA5sHz4QPKWGwclaRTqNffnjO6gUQcjUUyaIHhENgAha++mDJQ+nx00aklI7CEMxjEHCllIQ7UNEViFv5pCaGVzxuWKG9HgH0YPZ2Mie9x2tOOej7kvzny0MUemkmjvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38350700002)(86362001)(316002)(66946007)(2906002)(38100700002)(6916009)(8676002)(66556008)(66476007)(5660300002)(8936002)(44832011)(1076003)(508600001)(26005)(52116002)(6506007)(36756003)(83380400001)(6666004)(186003)(6486002)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+qtPEtqPmqRKajlbsDgSjvioE/54b+NkrZ4WsTgg+CjBDmsl+1K3cj6ZyGMD?=
 =?us-ascii?Q?zVoL4r4adMIaowcfVnUlM/5X7gTyYxR4BJLtFkHbnoCbJaaHK1F+HSkfl7A5?=
 =?us-ascii?Q?zfld8KP81ZzNzD4RfQlyewVtn4t8m2DEMLCogp7TNEyeCncSkq5KTg+Xz9ia?=
 =?us-ascii?Q?uOR36w4gD6Jb/pACDJudjh7a/6RHCi+RNUkZZW6v2yL0M1izhf5hmzZO48gN?=
 =?us-ascii?Q?gwY0p00eCQmnsY4gWEnIyPMlWZ5txJbqVemwphh43F/mCCAJPqHlR+Bo45go?=
 =?us-ascii?Q?oPNUS4//3xF5XOT8LdbP5mZMLoGJPHcOouBAvc1D1q2ygNIl0cW/Ue0DUQyT?=
 =?us-ascii?Q?0TUMllT8FbomwFz4wwBxVBXY8OTXkIMweEcpgGiPoTNJpdizAnhYunzirMOY?=
 =?us-ascii?Q?+V0eu3/5qbR3SFz6BnTxmi9Z4iAA7vg5sDQFK6smxOhN5fFpxIgWUaoeD9cO?=
 =?us-ascii?Q?hg4JBUKmbp2GDwcokv2VYUJcxMDMoVeykE/TTInOVg7fZtDjVXV+75KoWe+G?=
 =?us-ascii?Q?ZHxos5z/kR6laTyheBh0zLr8kGJ0HJNRcUVDbD+lDmpiAhL/OpIVXkVHEnNi?=
 =?us-ascii?Q?KIpy8agwgkVXowxX/AH0Au/uAVeyBpoRk1obWDGs6wywOaViUhjsTaaKFGYF?=
 =?us-ascii?Q?FF6Etsxtev17coFJunVeYm+FKoCnCepTA5uhVqJYG3Vf2AtTCFjLz7Geqfdx?=
 =?us-ascii?Q?issKRNDOAVW44/5u9qXhee6B3X3i1Wx1xAu1AuA7gLJ+p4NstT1QDRLA1tt/?=
 =?us-ascii?Q?ad76EL5wgQ1eZ/58cDDrhJZUf6bRN9ocC7ifFf4WZFxT/mHE88DA2DYrDw+v?=
 =?us-ascii?Q?7X2RM7EkxCxQLv6/tZzXG/7hTGaebB9wGxEZlExUPJkpjuxtsJlUmVIA8UAv?=
 =?us-ascii?Q?z7svKL/thFGNgmCEda89DKMAGRXoc2l/9ex3ki83x6rWfBzCDKwk3CbPMOlh?=
 =?us-ascii?Q?+EvqHTt2aS9y4wyr7+1rlj/v8JMcBk5QiwSbh3T/c7giGifpI7vFfb2WQU9n?=
 =?us-ascii?Q?4zL+ZsBQwKGkZGdct/SE6QC6NfWN59QXj7jpsmHh498FojIQ+kB9ewN3Jl0L?=
 =?us-ascii?Q?387XLLKYHZCOjL0FG5RBziG0j+d4DR0vw1GuH5UaMlBRWqFDEs0P2kUOA3t3?=
 =?us-ascii?Q?oP6VR/R2nt6qNopblZFni1RhRE2+lX539JA6//AWi6Au6A9hXdbRf4XkZde3?=
 =?us-ascii?Q?NOUT7A7scS6syZojc1wGqqxVy0R47fbEYFXsmVFlAXT2Ko4bR3EjiJV6o/GM?=
 =?us-ascii?Q?aJCv9MzfNDxYtDS6te4KoC2ekhu5YjJDEZjjVic+JHmoy07zEL5IN/lrlsI+?=
 =?us-ascii?Q?6BzODoxpfvoAskB4AGTUHadYXdUMxnT+aepvcLCYkxLNwyNnpHqS0FgX+fl8?=
 =?us-ascii?Q?9yVI7leG8jJAMnMkSJ35UUvSWNkMwoJlH3Q1e/sHKQq+4xxZqwSwIJMlM79C?=
 =?us-ascii?Q?H/RYV1qPwnhfdeGn1Ry0DHElKkpgIwhEsozdL1CLonytmYVJRlCrO2vQNGuz?=
 =?us-ascii?Q?bTEupXMJhkL/naZWSJf8idtqhRD6OIwN8cektD9DCsGgmIau/tZx47jE56R7?=
 =?us-ascii?Q?HonVqwWnh3q3NM7AtzZ0QKeE9l5r3xYQHoWFQGzILmc9VA1dY6rEVNu8Gs+d?=
 =?us-ascii?Q?idJ64Un5RxtM38RkB8xp/SQzeAPS5QqBnSHFZsObNOvkOaMSMg3tdhaoOdaU?=
 =?us-ascii?Q?DjHsPyEW2a0/Eo7QUNk3NFuqIKufhtyyK3shliLJE0dCugBj1a3P4hlAT7MZ?=
 =?us-ascii?Q?8XmpzQvZYBBlOImRhgLc878AzkKuy9A=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d53736e-32a4-46b7-dd06-08da3a93070b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 19:00:38.0105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aKK97ZXZ2ppkGV+WELCtnviknSgTzsZcjGdj8XLu0CK++2K6FRLDx3kspnC0fLEahg7Buhh3tecWQUg4CVqTuMbRJoo4KB6Vod/gYKx1++I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3658
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-20_06:2022-05-20,2022-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205200119
X-Proofpoint-GUID: BDLqoxSQ-441J-PohdSsGkSPjz62_Oqa
X-Proofpoint-ORIG-GUID: BDLqoxSQ-441J-PohdSsGkSPjz62_Oqa
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: b2c28035cea290edbcec697504e5b7a4b1e023e7

Callers currently have to round out the size of buffers to match the
aligment constraints of log iovecs and xlog_write(). They should not
need to know this detail, so introduce a new function to calculate
the iovec length (for use in ->iop_size implementations). Also
modify xlog_finish_iovec() to round up the length to the correct
alignment so the callers don't need to do this, either.

Convert the only user - inode forks - of this alignment rounding to
use the new interface.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_inode_fork.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index a2af6d71948e..a1b2b9029195 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -34,7 +34,7 @@ xfs_init_local_fork(
 	int64_t			size)
 {
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
-	int			mem_size = size, real_size = 0;
+	int			mem_size = size;
 	bool			zero_terminate;
 
 	/*
@@ -48,13 +48,7 @@ xfs_init_local_fork(
 		mem_size++;
 
 	if (size) {
-		/*
-		 * As we round up the allocation here, we need to ensure the
-		 * bytes we don't copy data into are zeroed because the log
-		 * vectors still copy them into the journal.
-		 */
-		real_size = roundup(mem_size, 4);
-		ifp->if_u1.if_data = kmem_zalloc(real_size, KM_NOFS);
+		ifp->if_u1.if_data = kmem_alloc(mem_size, KM_NOFS);
 		memcpy(ifp->if_u1.if_data, data, size);
 		if (zero_terminate)
 			ifp->if_u1.if_data[size] = '\0';
@@ -500,14 +494,8 @@ xfs_idata_realloc(
 		return;
 	}
 
-	/*
-	 * For inline data, the underlying buffer must be a multiple of 4 bytes
-	 * in size so that it can be logged and stay on word boundaries.
-	 * We enforce that here, and use __GFP_ZERO to ensure that size
-	 * extensions always zero the unused roundup area.
-	 */
-	ifp->if_u1.if_data = krealloc(ifp->if_u1.if_data, roundup(new_size, 4),
-				      GFP_NOFS | __GFP_NOFAIL | __GFP_ZERO);
+	ifp->if_u1.if_data = krealloc(ifp->if_u1.if_data, new_size,
+				      GFP_NOFS | __GFP_NOFAIL);
 	ifp->if_bytes = new_size;
 }
 
-- 
2.25.1

