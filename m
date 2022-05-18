Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E370C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 00:12:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232355AbiERAMt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 20:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbiERAMo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 20:12:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF74349F01
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 17:12:42 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKTjjW012903
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=FbngtfzYyfpNTe0D1vPVep7igmHNQZ63vwmOjhc/7YY=;
 b=xBltJHuP/0GqiNxfb0e0lXkynhEpHY/J4JIJpSxYExy6gkAmokMJl9g/K0G6YvpDhosE
 98Hi49qUgoCW4guok1+yaKmwzalCIiG64T586kIH5MMdD+0D4YrqUXfYoKp/m6Cs1qfi
 20L+LOvkAfQix0enTL+cmYwQMwrz1D0kS9E1HIW/ON525rwda9f0n0nB0yR4BJYc6Lrr
 57HDnT4az6ZTlGmMK+tVEUW7DxERxZi5StvFArKkG+4kqasC2xsNRTrejUf42EQmKy2q
 3KmMybdIKG9KLhiQGq2bSKSqm0fOW+8SE9g/1Z5WycLbwpaWlAOrB+NWUyG1g90k9naw JQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24ytqv84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:42 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24I0A1OE021321
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:41 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v3nd6n-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h9sT570OV1rdzI6KqUkW/J8S9R+dfofcAnQAD3sKnVAAELTrhdBnicOfse2WWaFomo9z1YjJTa4jmJz+hnqEDR+5STjPc9D5sjaZ4gT/6eZ9SaZPAbC7567FneLYBh4mhYx8C9Gr3VWbRvfYH4ReHDE48li2wrgOQm/yRqUL4ubO33pNo3geDRmxNAI89aAH9JdEn0emI+rY3POxGs3kvsWxBr+b4vlfXCx+mY1RKGk4rZXH0M8bwzeXro0DyJYsuCslSth00m5pNc5305VunJyeKf51x7zWoDsFTtvZqjIy32Wkrn4NkBvKVnGZqaaazaidhM6RXAPXYtW0r1v/yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FbngtfzYyfpNTe0D1vPVep7igmHNQZ63vwmOjhc/7YY=;
 b=SPI0GeM0YGgAHDWTVTNhkJeRZRRLm4DEsyrAR+sJkQCCHqAr2TbAvopNnp3isu5roxV4DJrUTlYXpOqLqKXY3M2xxMxDAUgYtjxCeMu5q6YW31Rj1kEyYcJubKr2A9ky65BuxGEbQf3BwbhId4VxD5CA7Gvwl9gIjKukoNKsJ1vSH62IEuhVxPE++OdKfqsGMgbwxeKJLwvibke23Q/lV1GfHQdN43kxl8/lSVYomqaRr7aBKTtXqzLuUpXIotePFs8hJB4ix7uKqL9vwRFZALCJnWaXRfBy4MpBX7u/OOZSrmQpjld+Lp8o2zpXHJJB5g6k5nVZXGsp2Ozj+IZz5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FbngtfzYyfpNTe0D1vPVep7igmHNQZ63vwmOjhc/7YY=;
 b=Zf5S51UT8Ro5q4pr3ldLcKQVNItwidf1qqGvbslQxEetSQKk7sxySelgtsK8ldXV4/kuW8WMr5CGK44paYCJ5iytjRCyAJFIQ7L8HqrUT5rSs5xvqoYzKU3xjEhw0YaIZqqWzPoRNOCzD2CLSYbyUPM8RrTBsOzjXHMb7onwKXA=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CY4PR10MB1528.namprd10.prod.outlook.com (2603:10b6:903:2a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 00:12:38 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 00:12:38 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 10/18] xfsprogs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
Date:   Tue, 17 May 2022 17:12:19 -0700
Message-Id: <20220518001227.1779324-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220518001227.1779324-1-allison.henderson@oracle.com>
References: <20220518001227.1779324-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0028.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::17) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d79488e-8ca3-441c-d14e-08da38631e03
X-MS-TrafficTypeDiagnostic: CY4PR10MB1528:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB15282CE30F264E38AD9BF3CB95D19@CY4PR10MB1528.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Ca+UO5zJutNSWI8/mw5BD5VklNq/j0kby4k2DyYnCe5vUgTNXhPO5SafhWgwiSvIVUmixQ+O6sPC0VwiGHDfLi7gYY0r0Yihks8mYj5rgvX4gUpNUyLtOhAZQiT6A8lxPfDF36fhnXc4B+sNLKKvcr1EcM6VsKKTdEbRJr7DwUYqdhk+o+9QNsREYrAeH3Smj9fHjJT/1LaVLWjR3Gn79+1xwei2bY3wtZGs7nIWjuRbDorx5BxOWpl7Med7PQ50p5Xj9cxhlFdiBORiwgB0bgjGKaQ2s2K8zGpgAWJl+n5s0xzPrAEsPrtzOPTFFU0ONQgOlc2hK9sCEZ+EWUhEgFUnWDoNmA7LM0muKDTETPaxIKt1Dsn7cDHIosHgILyl88JZqe+pNpBl6WPmvlSWM0AEoirAkhJQ8J5ytB7pFrAX5aIIeXkbYYRfyLXvyFUjybt6dvd8uBuu24ZHg7D0ViaBCCgc7mmyn++qowpoFUf8ng2FDOVPlGMbUAqpnnt8lhLrbI/IH4bL/Jbk0HaQyHxP9gEvGsF4sjPlimDRM2RHZRSBhCUj2f9TcX+wNOx5ZOgkVGgqSclxS/b1LVpVqKM8Lu/03Zpfmc7VKOqyVdctaSvZnyry7Rt+bw5LFNsd57hTah1f7Q8phYxlICtp0gbldJLiVpsKcBfFhZW+0zfruw02ynaQSZNN240M7a6PpKxBrQQL/GEIbaE5F0p6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(508600001)(38350700002)(38100700002)(6506007)(26005)(6666004)(6916009)(66946007)(44832011)(2616005)(2906002)(5660300002)(52116002)(316002)(66556008)(8676002)(66476007)(6512007)(6486002)(186003)(86362001)(1076003)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BZCRnhruYBuQ6tXZwPmYfFLc9sUDmMPuAm+nsaiRIvbSkoV+tLwDHMFGxQHj?=
 =?us-ascii?Q?i/TDrlHN7UaxUlDQ4MJhlGC4EOUfAaRC6YnzIcQI3XoseNT8wPmmkWWgwck4?=
 =?us-ascii?Q?4hT29xa4Um7RB5sFRY7uQqQVg3CpiFGTaMLc5VGf08op40uutTNoAiDS/gTQ?=
 =?us-ascii?Q?vFtLa89MIPXhhBVGuFJaxP178Nq7mlAEoHccPb0GoEt96MS1oj6TgKZdPt/S?=
 =?us-ascii?Q?yDMSfWSChvEO0yH/nLWMOTgnltxX6WgsW705bDRFZpPybou2W2ak5EiXO+GK?=
 =?us-ascii?Q?hBugMb34z6SDdH8wjjVsxuogR2HZaNdu947TV0VIKluihRZjN+71J7latvB+?=
 =?us-ascii?Q?1SlBHgrzjluCWFYDsh2BVSV74m7t80Zmnsq6zwfbo4C5YQ5M/e2FPLwnlRCu?=
 =?us-ascii?Q?SF8GieqnnntZCJVRvNgvbn9fJYG+ZvS9z8zy7y4+oKmLR0qqFI4aw8rQUU3i?=
 =?us-ascii?Q?F9DOwD/Vd8q01aieuHuiqJh8z86KPcB6KaOnRkTOVG6nv1EYgditlNRlS4E1?=
 =?us-ascii?Q?7kC/nA2isu6YRfKf+IhPbuBuSNexOiKh1iRVetp5be5R4SSpjscnY+BgBPmv?=
 =?us-ascii?Q?I/e1iMicuigFkp1kidcQ3WtR2q6fnhtLM8ZkB4AYIlIuzRuHr3dAc19Od48Y?=
 =?us-ascii?Q?vh2IAD1ItI4eM9pt2yjWcQzYar62UcT93MXeM7FcGOy4grC/Unyu3BzXGz+T?=
 =?us-ascii?Q?H86q2Vt7d8gjVNKqv5IT5/eKzfI+mzTDubu2KrYJCDuHPGizRLNi2G34M6ou?=
 =?us-ascii?Q?hvkJOsLYPVYKSQ8M6nnEqJEFm1G2xzS8rBuLxxDy8P5pzKJxKys5q/jJ0Vb0?=
 =?us-ascii?Q?hfZ/WSG9zOGpqJWRTCD9Ydo10+qKlqeb5Hc4x2XU+s+DbnMXCgUpyvuanxDU?=
 =?us-ascii?Q?iyr4QDD0EFSGa0fskqVyXJSdDLKlP/Dfc7QR1Che06rMq/byNbJ1YvRnK1PI?=
 =?us-ascii?Q?q3eP6vnvJ7sFDdMFhskSZ3We9be9SBqlfoGynYx5evLCFLSuS3RWUbivpDJ3?=
 =?us-ascii?Q?yNKpByMM4jUxwXRB4SChDIa5EfZeG2CdGjq/mjM8L7lOfEzm7iUH5UW2XZvO?=
 =?us-ascii?Q?cW++JD32yCeA0a8QuqYaaoRkivhzLo9scGvH59FQp4D1PBEZh9tgIgJE5oq/?=
 =?us-ascii?Q?9Od4YDiIPXURq1qLyTGk8zpCbk0w9kaH9Op81BnhPSzhTlVFrVxjosfbTpVs?=
 =?us-ascii?Q?T1KqWlRLyJRJN1llD1Jjqm3qtlv1fiGGOJK8Ovkxrz2zncr/kENVhxi/+VHG?=
 =?us-ascii?Q?2mvFJXJJAp7fbPgCpeH8aES7bM6HnG8NQSTleOCLH7cDNRmRAjgvXmRoPqul?=
 =?us-ascii?Q?F0D4YxUazn0wBPPW86XveyfzZJ6FLXxuj3y4LvhsfE6FMwNji7taPq2fMu3R?=
 =?us-ascii?Q?6VelX756oWel0TlX7qTMK8czx6Uji7i/pyAQJBGKXWVIg6Fs6hPcfcJLs6Tl?=
 =?us-ascii?Q?b8SrstFGtgWAT5Fq0xAzPZ+K7RK4kqzT+Rrnra35lC07h8AaX0jaDCQ/XUFj?=
 =?us-ascii?Q?hSUSsoaqu0YOxCvpUYuMtKseiPyH7DjnZeDPquxP8ATH5pXI/gUzdn3h/7X9?=
 =?us-ascii?Q?TkN+f+2eCfeWztBoyrcao8fbAUMlindWVTQ8f2lHwa3qEbx4iVTKzky/u0od?=
 =?us-ascii?Q?32VFxk2z825qzL0UqhI282gmPO7pF3hWQqFjRedFUo++peuW+ZZKZhUEr5xP?=
 =?us-ascii?Q?8TzIqm82vN4zvaqxcJ8Xui/zNimlDOr1Ts6SZiNyULffuSJ5wCb33/e6a96E?=
 =?us-ascii?Q?gAqKWUmkEGLECCJIbcgrM7evuLsjgDQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d79488e-8ca3-441c-d14e-08da38631e03
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 00:12:38.4549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FfpSmc+AwDAIIW5AboYjvekN27V3f+ZAha8uUt+Dx1cC+cqpq6ZYLS7Q5jgJtsQJ1XoycmpMKrKACdlSt9/MGp0oONEo50qgOqCtxxHlFBQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1528
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170143
X-Proofpoint-GUID: Py55ILzM8jf1-Y0fCphRX0Y6JD2wEmZY
X-Proofpoint-ORIG-GUID: Py55ILzM8jf1-Y0fCphRX0Y6JD2wEmZY
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: f3f36c893f260275eb9229cdc3dabb4c79650591

These routines set up and queue a new deferred attribute operations.
These functions are meant to be called by any routine needing to
initiate a deferred attribute operation as opposed to the existing
inline operations. New helper function xfs_attr_item_init also added.

Finally enable delayed attributes in xfs_attr_set and xfs_attr_remove.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/libxfs_priv.h |  4 +++
 libxfs/xfs_attr.c    | 69 ++++++++++++++++++++++++++++++++++++++++++--
 libxfs/xfs_attr.h    |  2 ++
 3 files changed, 72 insertions(+), 3 deletions(-)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 12028efbf802..718fecf72614 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -601,9 +601,13 @@ typedef int (*xfs_rtalloc_query_range_fn)(
 int libxfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
                         xfs_off_t count_fsb);
 
+/* xfs_log.c */
+struct xlog;
 
 bool xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
 void xfs_log_item_init(struct xfs_mount *, struct xfs_log_item *, int);
+int xfs_attr_use_log_assist(struct xfs_mount *mp);
+void xlog_drop_incompat_feat(struct xlog *log);
 #define xfs_log_in_recovery(mp)	(false)
 
 /* xfs_icache.c */
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 6cda61adaca3..4550e0278d06 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -725,6 +725,7 @@ xfs_attr_set(
 	int			error, local;
 	int			rmt_blks = 0;
 	unsigned int		total;
+	int			delayed	= xfs_has_larp(mp);
 
 	if (xfs_is_shutdown(dp->i_mount))
 		return -EIO;
@@ -781,13 +782,19 @@ xfs_attr_set(
 		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
 	}
 
+	if (delayed) {
+		error = xfs_attr_use_log_assist(mp);
+		if (error)
+			return error;
+	}
+
 	/*
 	 * Root fork attributes can use reserved data blocks for this
 	 * operation if necessary
 	 */
 	error = xfs_trans_alloc_inode(dp, &tres, total, 0, rsvd, &args->trans);
 	if (error)
-		return error;
+		goto drop_incompat;
 
 	if (args->value || xfs_inode_hasattr(dp)) {
 		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
@@ -805,9 +812,10 @@ xfs_attr_set(
 		if (error != -ENOATTR && error != -EEXIST)
 			goto out_trans_cancel;
 
-		error = xfs_attr_set_args(args);
+		error = xfs_attr_set_deferred(args);
 		if (error)
 			goto out_trans_cancel;
+
 		/* shortform attribute has already been committed */
 		if (!args->trans)
 			goto out_unlock;
@@ -815,7 +823,7 @@ xfs_attr_set(
 		if (error != -EEXIST)
 			goto out_trans_cancel;
 
-		error = xfs_attr_remove_args(args);
+		error = xfs_attr_remove_deferred(args);
 		if (error)
 			goto out_trans_cancel;
 	}
@@ -837,6 +845,9 @@ xfs_attr_set(
 	error = xfs_trans_commit(args->trans);
 out_unlock:
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+drop_incompat:
+	if (delayed)
+		xlog_drop_incompat_feat(mp->m_log);
 	return error;
 
 out_trans_cancel:
@@ -845,6 +856,58 @@ out_trans_cancel:
 	goto out_unlock;
 }
 
+STATIC int
+xfs_attr_item_init(
+	struct xfs_da_args	*args,
+	unsigned int		op_flags,	/* op flag (set or remove) */
+	struct xfs_attr_item	**attr)		/* new xfs_attr_item */
+{
+
+	struct xfs_attr_item	*new;
+
+	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
+	new->xattri_op_flags = op_flags;
+	new->xattri_dac.da_args = args;
+
+	*attr = new;
+	return 0;
+}
+
+/* Sets an attribute for an inode as a deferred operation */
+int
+xfs_attr_set_deferred(
+	struct xfs_da_args	*args)
+{
+	struct xfs_attr_item	*new;
+	int			error = 0;
+
+	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_SET, &new);
+	if (error)
+		return error;
+
+	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+
+	return 0;
+}
+
+/* Removes an attribute for an inode as a deferred operation */
+int
+xfs_attr_remove_deferred(
+	struct xfs_da_args	*args)
+{
+
+	struct xfs_attr_item	*new;
+	int			error;
+
+	error  = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REMOVE, &new);
+	if (error)
+		return error;
+
+	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+
+	return 0;
+}
+
 /*========================================================================
  * External routines when attribute list is inside the inode
  *========================================================================*/
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index b8897f0dd810..8eb1da085a13 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -525,5 +525,7 @@ bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
 			      struct xfs_da_args *args);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
+int xfs_attr_set_deferred(struct xfs_da_args *args);
+int xfs_attr_remove_deferred(struct xfs_da_args *args);
 
 #endif	/* __XFS_ATTR_H__ */
-- 
2.25.1

