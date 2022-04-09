Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A03FC433FE
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Apr 2022 13:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242034AbiDIN1B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Apr 2022 09:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242090AbiDIN0h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Apr 2022 09:26:37 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF03AA9947
        for <linux-xfs@vger.kernel.org>; Sat,  9 Apr 2022 06:24:12 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2393BiB2028053;
        Sat, 9 Apr 2022 13:24:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=+xf6DvTgfdcJAMtzzvZesGdcjK+rGoiLpG5NQFWj8AE=;
 b=nu76+6jerTRZI785uyc7hbc9gAeGYhrBvH3/EtGdF5Gr/R4NoYobuRG5BTPHkUQZOtK8
 Cb8K3+/6sSJv5ujPUslRESynKE9w7QEw+qtxmzf4IPlo7EvUSJj+iMtWu4gRmYJTn65l
 OpOMX7GM1mHbeuAKo+Ez0soieeFV+noFUiqLPbGVZabPwqT5UjjiazlsM5QJ1sKYMb6Q
 R4QsUhPf9qZBZ0Lr71a+VXOXkVVeVul5oeWgojhQuXG7sP3kF6OG5oW2fFyxPPnlwO62
 EP20Tf/AizRyamSNWDMEK4MSga8iWDAvPxNcQnRG7PRGV1lPhMbgHQMQkxwUxsG74ss5 Hw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb219rfyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 Apr 2022 13:24:06 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 239DGv6V011408;
        Sat, 9 Apr 2022 13:24:05 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fb0k0bsxf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 Apr 2022 13:24:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=joi5cnbGgMQTrnUYwJfAMsKZqSpRM5rfjwBesHvDr5I2QsVqpQKX2c3MDgELCFgCS38PLvedTIaad5P1pHKIUs9KUOoVAXZo0I1rOVWTTWZkbq+61uuYRhhcbKz0+gzWaWbA7wUlR0GUZVsZccl9BvAByOhdF1d3FjJPa5boSQfdaVgt1GCowzCPM1AAE2nivj6awVwL7mtUNNqoF0bQZgjKpvHE1IEC4FiQmq/NWjuDk+TJMnRHBG3BUXQsJBiTFHRLp5hZTe9D9AnpaXFD4wc0lpPECaHbqYGiRtoSqUS+DPbowK6olV/N5IPU6J3TKd5LMJJbzXqfCAqx+JmsGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+xf6DvTgfdcJAMtzzvZesGdcjK+rGoiLpG5NQFWj8AE=;
 b=KEMkm1YT9SLLYEC4yc/yeSsjUJPqvKBhydJaVkhGAxW+3Lrb6nr/moj8ifjUHj0YVZ57cS/8NbrLCD1RaA1NvSBAaOmj5ShBY0iB7ubRHCa1HNQb0B0o0i9swFJZF04WAH4ctmrExfwR4Qinp2la38FK6P8HvwSxhMdrXiv+3u1Y24bQ7MwJsMr2TJub7TnQ9hf59jqvaODG6WEqUkhZn2NeFSj8Fi4+jma42kN2NXCchyZcV4J/A0j+PVPBknxIoBSZrKuNIst+TDJI5OkjghZl6UrwdIX8jnRSRrJ1OvUXAoAcsnkxGg385oBNzP+3IxfzaMM4Vgx4qZ7ArL7q9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+xf6DvTgfdcJAMtzzvZesGdcjK+rGoiLpG5NQFWj8AE=;
 b=dh7XuoG6fmJfoZA6zqWDyzxkIJh6FHqwF0SIcbSOyhDmyBsg+YCOhIpN38V1zJU/bfq94T+/VoOEGsBL97TGqbK/WaJj6qVH43ms0eCL098iL/rnyHVw/adXxGrUnj9VduVVyKum20ehjoZQyuD+2xOoqJpsg69jkhmy9je1+zY=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM6PR10MB3963.namprd10.prod.outlook.com (2603:10b6:5:1f5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.27; Sat, 9 Apr
 2022 13:24:03 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d%8]) with mapi id 15.20.5144.027; Sat, 9 Apr 2022
 13:24:03 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH V9.1] xfs: Introduce macros to represent new maximum extent counts for data/attr forks
Date:   Sat,  9 Apr 2022 18:53:38 +0530
Message-Id: <20220409132338.413316-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406061904.595597-1-chandan.babu@oracle.com>
References: <20220406061904.595597-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0146.jpnprd01.prod.outlook.com
 (2603:1096:404:7e::14) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 926d89db-e600-44a6-e7f5-08da1a2c373a
X-MS-TrafficTypeDiagnostic: DM6PR10MB3963:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3963458401BA5B2A2AA35A34F6E89@DM6PR10MB3963.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: htNLPZcsuFNlZm0quGl803Gdi1Lx2t9Ju1xLuuiFhdUZEoOYkmGNhMlbJqstFr5GbfqIEgvZ7OgjozIAxY7weuK5ctkGhvSdhrlaKO81olAryypoeoBsu6/55uAtRJIc0Q4Wu0bGsOVI1KviTWmuMzFf/9z9PY0biH2CzWxfijeinz2qrM1rAQ56jIM7b0ZrpcoZSeK9JPMD1i9wfiGiQw4Gb9V66zkINe8fm14u4D61s96W7CetBLdg6UP+tT8xqq6irlM8tQtbKcfEzF7VNFXgcalVq7/eWeYlrd06Q7vA7sxPMA6A97OuOxdBEXYYRVuRwjvdNt2M4Udvp3al3sqRCySr4hGvc2OGVu4EPckWU8SAsV7xuVevakElOdUowRpbDhvktgEqENOC95jBK7FRSIdiETurwqX0aTC4rLKmQ1gyZmSA1ZhjtxBi1UtGlnNT9uo199ZCbQ3bXPt4F+4Y7HrvvDnoCESOGydpeCb2sO/m8hKGs1Chv6DISvodcQJrjrhZ3Q35UKv4OgcCeeBY7gR4HBrNC0zKlQZmeq/p85Bc72LLLM7E/vODQ5abU5P4GDGSw9y9TeKgKj5vVIsgtkW19Ug61bBM/SG7gkNHDO4PfJOltehPwzUb79odAY/vGcX0V8HEreA+TZMPkYmCB9HLHhGPgBU41Da1JOrUGei/axhd2XUaQxKa3gdBOTlxDsoaG4MdvBM/hCLrMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38350700002)(38100700002)(4326008)(8676002)(5660300002)(6486002)(52116002)(36756003)(6506007)(508600001)(8936002)(6666004)(186003)(26005)(6916009)(54906003)(316002)(83380400001)(6512007)(66476007)(66556008)(1076003)(2906002)(2616005)(86362001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vPCOyenafu3VWpGaZf34zp60/+c8hiP09I4cjDUscnihsQvo6cDdASrMU7Nc?=
 =?us-ascii?Q?YtqRkSajM3eEedDHQcHgDcs0rx/csEQDnJVPNGwtw75oIP90WKrkE2qYzBdi?=
 =?us-ascii?Q?v7LoQPlOoDotR+vRXKU8V2egiDGw1FYpX5NUtrtOoSf1r//Sr/gpbbT0QUmj?=
 =?us-ascii?Q?B4fh3Cr+hTNqVgtfn99qRY6NVyGkzp1BT20DrgqmpxKpAegEq5edMrFHgtaa?=
 =?us-ascii?Q?GT7kOBz/08zijWyHtAjo0n0EVkYUkCB9QdD5CKJpIViIA1+L5EBex+8IT7tV?=
 =?us-ascii?Q?p1P5wgADk9n6h6u1bH12wtOFYarC42Ms6ntsLyKsMR3z4+YpUyRC+B+wFjpD?=
 =?us-ascii?Q?AgkdI+uz9fTfjZAYtW+OYUdGaddfuBrEHvPgi6a1UR7bokSFsutlPyDIuZCE?=
 =?us-ascii?Q?8o6nODJ1sCl/MWnG4SQgkRTBDNfT04yffVSQLJjcVlNMm/BcYPceay3mHKYv?=
 =?us-ascii?Q?vuguzyD+3jY08QMvs48tJqy0hj/3rkSzGcMYrIa1J2kTRElmZJmMwUK7hqqv?=
 =?us-ascii?Q?Da2NJKi4OFGdRp1yugP1TWFkVG7p7C1YHl6noyli/VQJDEqEhpA/VjDzLmzU?=
 =?us-ascii?Q?emp6gUc/6gnhn/xGMOtqNW+KTc9FLj8xoAwlUpX5r+jHzCt3+qV9VF8BOCK1?=
 =?us-ascii?Q?jEJ9E+X+j8ZxWVqAY4CI20kpLyjzlTMMT04NNRLaLMmYcVb3Ma4H/t1S80gY?=
 =?us-ascii?Q?9TaJCG+LeZZnOMzPnxzrz2UrMS63bbY7Oem6s8mQ5Ci1/TgKuP7tRXugE8wb?=
 =?us-ascii?Q?1S6bZDUKNoNEr8C5NFijiSDwwik0KeYV3/dEUb4lCfp2+78wLbD/JkRlJxf3?=
 =?us-ascii?Q?OSGqXkIWKluzrE22cMD4f9ASHBA7MEHzCHasoWRzCTbLesPb/rsGbNzEkDQX?=
 =?us-ascii?Q?nYvoGUFjbH1WQnytEoIBmiVsIFJXeHPFEjXgNkJamM4fNx+oUQNXddRvEJ/q?=
 =?us-ascii?Q?sbbj8njO404oMZD+j7M4jjc+CBqCnXcXRKdsR8OX4ZzcBaH9vX4cWJqhXf1s?=
 =?us-ascii?Q?O0sx2ylHRCCqnlc9Js79CAcaeBnERMDAAbidbPgGhB6ucIyFJ3U4e16xkJ8K?=
 =?us-ascii?Q?HVhRP8vv4U66YKV1/SanxvSULBEO+xrH7WH7E9KbUqKi/j8GtUpdvctMZk2O?=
 =?us-ascii?Q?PwNYY9CbYU/v2/3k/P3zn7+W+2LTrwGT3LNbnRV2dl4pRAeJLeEkQVfQ/1an?=
 =?us-ascii?Q?gxU7Or9FZQ8Y4+RJ4icgxd4VahIVYCr3Et1vQ13WX0dtCwfiqN3aEhpN1yh0?=
 =?us-ascii?Q?EPfsxVvifuIwMWMgiqJ+3o1JCORfURhtqz3OP6NCOHlj+cM4Fjoyi8d4X7rC?=
 =?us-ascii?Q?MR4gt8N2YaML/CL3NmAyB7aKG4DFfo2Vv8qjUkwyK/Be6jBIslEhKfDdzC+z?=
 =?us-ascii?Q?LW68QjAIqEbMkKpQY8cVUGd1TNT1b1W2B02yYYgRGZsfEa43vitB3MFitRkZ?=
 =?us-ascii?Q?KJTcRLobGj0/HLDf++gv25IvCDJVmdrun4shdpvPaiHnl8Qa/YBFXcDRyBVg?=
 =?us-ascii?Q?C1fxfyNIq0+yM7gYoMFlhUq5vHqMf9POcJSPXQimdD4+JuC6iOszX7tQLnaN?=
 =?us-ascii?Q?Ik5emMxlV2J8JJNsJCiT0DnuTJjDW+khv47pLegJCq3tgjB//T9JMmh+vWJI?=
 =?us-ascii?Q?UXFtke9XFEOjbWKIHWCa++LOJj8F7USOqGB8vnHg+Kp3xurO3hdmma3l0wh+?=
 =?us-ascii?Q?tIs771TznQzQwgZ1AgAIPsAgyG6Y64kOKCM9b0ySWu7LMUt47EN4OfsDAcmz?=
 =?us-ascii?Q?JZux9cSxvQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 926d89db-e600-44a6-e7f5-08da1a2c373a
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2022 13:24:03.6493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nTufmO1EWBZH1/Kk1OV6tFSNzwsw2ic/7rPpmkHxeCYSZGQPsiPiJGzHPzQGiYWoN6GedwpVLo8UyQZdfb7ssw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3963
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-08_09:2022-04-08,2022-04-08 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204090088
X-Proofpoint-GUID: pSr30P60EyZWRxJD5SRm4f2o9NX78G-2
X-Proofpoint-ORIG-GUID: pSr30P60EyZWRxJD5SRm4f2o9NX78G-2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit defines new macros to represent maximum extent counts allowed by
filesystems which have support for large per-inode extent counters.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       |  9 ++++-----
 fs/xfs/libxfs/xfs_bmap_btree.c |  9 +++++++--
 fs/xfs/libxfs/xfs_format.h     | 24 ++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_inode_buf.c  |  4 +++-
 fs/xfs/libxfs/xfs_inode_fork.c |  3 ++-
 fs/xfs/libxfs/xfs_inode_fork.h | 21 +++++++++++++++++----
 6 files changed, 55 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index b317226fb4ba..1254d4d4821e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -61,10 +61,8 @@ xfs_bmap_compute_maxlevels(
 	int		sz;		/* root block size */
 
 	/*
-	 * The maximum number of extents in a file, hence the maximum number of
-	 * leaf entries, is controlled by the size of the on-disk extent count,
-	 * either a signed 32-bit number for the data fork, or a signed 16-bit
-	 * number for the attr fork.
+	 * The maximum number of extents in a fork, hence the maximum number of
+	 * leaf entries, is controlled by the size of the on-disk extent count.
 	 *
 	 * Note that we can no longer assume that if we are in ATTR1 that the
 	 * fork offset of all the inodes will be
@@ -74,7 +72,8 @@ xfs_bmap_compute_maxlevels(
 	 * ATTR2 we have to assume the worst case scenario of a minimum size
 	 * available.
 	 */
-	maxleafents = xfs_iext_max_nextents(whichfork);
+	maxleafents = xfs_iext_max_nextents(xfs_has_large_extent_counts(mp),
+				whichfork);
 	if (whichfork == XFS_DATA_FORK)
 		sz = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
 	else
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 453309fc85f2..2b77d45c215f 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -597,7 +597,11 @@ xfs_bmbt_maxrecs(
 	return xfs_bmbt_block_maxrecs(blocklen, leaf);
 }
 
-/* Compute the max possible height for block mapping btrees. */
+/*
+ * Calculate the maximum possible height of the btree that the on-disk format
+ * supports. This is used for sizing structures large enough to support every
+ * possible configuration of a filesystem that might get mounted.
+ */
 unsigned int
 xfs_bmbt_maxlevels_ondisk(void)
 {
@@ -611,7 +615,8 @@ xfs_bmbt_maxlevels_ondisk(void)
 	minrecs[1] = xfs_bmbt_block_maxrecs(blocklen, false) / 2;
 
 	/* One extra level for the inode root. */
-	return xfs_btree_compute_maxlevels(minrecs, MAXEXTNUM) + 1;
+	return xfs_btree_compute_maxlevels(minrecs,
+			XFS_MAX_EXTCNT_DATA_FORK_LARGE) + 1;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 57b24744a7c2..eb85bc9b229b 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -872,9 +872,29 @@ enum xfs_dinode_fmt {
 
 /*
  * Max values for extnum and aextnum.
+ *
+ * The original on-disk extent counts were held in signed fields, resulting in
+ * maximum extent counts of 2^31 and 2^15 for the data and attr forks
+ * respectively. Similarly the maximum extent length is limited to 2^21 blocks
+ * by the 21-bit wide blockcount field of a BMBT extent record.
+ *
+ * The newly introduced data fork extent counter can hold a 64-bit value,
+ * however the maximum number of extents in a file is also limited to 2^54
+ * extents by the 54-bit wide startoff field of a BMBT extent record.
+ *
+ * It is further limited by the maximum supported file size of 2^63
+ * *bytes*. This leads to a maximum extent count for maximally sized filesystem
+ * blocks (64kB) of:
+ *
+ * 2^63 bytes / 2^16 bytes per block = 2^47 blocks
+ *
+ * Rounding up 47 to the nearest multiple of bits-per-byte results in 48. Hence
+ * 2^48 was chosen as the maximum data fork extent count.
  */
-#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
-#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
+#define XFS_MAX_EXTCNT_DATA_FORK_LARGE	((xfs_extnum_t)((1ULL << 48) - 1))
+#define XFS_MAX_EXTCNT_ATTR_FORK_LARGE	((xfs_extnum_t)((1ULL << 32) - 1))
+#define XFS_MAX_EXTCNT_DATA_FORK_SMALL	((xfs_extnum_t)((1ULL << 31) - 1))
+#define XFS_MAX_EXTCNT_ATTR_FORK_SMALL	((xfs_extnum_t)((1ULL << 15) - 1))
 
 /*
  * Inode minimum and maximum sizes.
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index f0e063835318..e0d3140c3622 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -361,7 +361,9 @@ xfs_dinode_verify_fork(
 			return __this_address;
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		max_extents = xfs_iext_max_nextents(whichfork);
+		max_extents = xfs_iext_max_nextents(
+					xfs_dinode_has_large_extent_counts(dip),
+					whichfork);
 		if (di_nextents > max_extents)
 			return __this_address;
 		break;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 004b205d87b8..bb5d841aac58 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -744,7 +744,8 @@ xfs_iext_count_may_overflow(
 	if (whichfork == XFS_COW_FORK)
 		return 0;
 
-	max_exts = xfs_iext_max_nextents(whichfork);
+	max_exts = xfs_iext_max_nextents(xfs_inode_has_large_extent_counts(ip),
+				whichfork);
 
 	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
 		max_exts = 10;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 4a8b77d425df..967837a88860 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -133,12 +133,25 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
 	return ifp->if_format;
 }
 
-static inline xfs_extnum_t xfs_iext_max_nextents(int whichfork)
+static inline xfs_extnum_t xfs_iext_max_nextents(bool has_large_extent_counts,
+				int whichfork)
 {
-	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
-		return MAXEXTNUM;
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+	case XFS_COW_FORK:
+		if (has_large_extent_counts)
+			return XFS_MAX_EXTCNT_DATA_FORK_LARGE;
+		return XFS_MAX_EXTCNT_DATA_FORK_SMALL;
+
+	case XFS_ATTR_FORK:
+		if (has_large_extent_counts)
+			return XFS_MAX_EXTCNT_ATTR_FORK_LARGE;
+		return XFS_MAX_EXTCNT_ATTR_FORK_SMALL;
 
-	return MAXAEXTNUM;
+	default:
+		ASSERT(0);
+		return 0;
+	}
 }
 
 static inline xfs_extnum_t
-- 
2.30.2

