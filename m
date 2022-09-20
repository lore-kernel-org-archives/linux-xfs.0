Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 420BAC54EE9
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Sep 2022 12:50:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbiITMuA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Sep 2022 08:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiITMt7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Sep 2022 08:49:59 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B702925C68
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2022 05:49:58 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KATlj9004744;
        Tue, 20 Sep 2022 12:49:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=y62Pbhksm+2s/dIkDvxN93fOQi2HC3jW6Y3YIZdTHeo=;
 b=EPtuHgCafDoXUzm/bpzd4p4Td/bgTFGXWc7JG5eXHDIC+8n8TI2sRim4T7i7b8mJYU6r
 aJ+ckVdUZrJR/GMqA+f0nYjV99mTW57Q6P0YxpBJPNtYXwHiEzTSY5g3Z9VlBp4qo6nv
 tHQvDdDjt1pSY7ZEKMlDrZwey4T4wXFJIZRv6JWW9GQe7M4FBF69fgwZCA8c/+GiK13K
 1Rmz4vY5tICMZYG0lzYrHxzA5kRC1wjCI36rBQSujyf9fx2BgLszmX5lVxOwgZx3AQBd
 0IXIx9+dOA/zNP/IHFCd5cOv+PHXjlXBU0mFIPWTVXlUDIUNdyJtkg1hIxtSu+gmmbcw EA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn68retea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:49:52 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28KArnxE022903;
        Tue, 20 Sep 2022 12:49:51 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39qh292-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:49:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RP9n6bWFSJ+2+GwNilPkRvvfh5AFRSNKRloPhaw4nC71E42OB4LDDyxGmT9A79sAUWPzGd05O9BH6payZ3bwdsD1G/DDwccq9FcUIq2S9fjRRUdTbFW3N62S2YiByKNS+GZchz6O025ao5/BfYhIv+mAgf2DvMOFwoRPjCBYkdeKrYV3f4zcH7HDG/McGD557FSiDFbCavMMZjUa4G5sw+eMIgHWe3wcp4cRY93/P/7i0nQKwsBOQkQWUKWzJwBTJBYoGUZGpug8ng9Rr1c8ejsqb13SgYI4hBgaIfJDtsRKuVzU90DfFECpidYBIkXJz5RDeYPGqnOJ3PRya+QIYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y62Pbhksm+2s/dIkDvxN93fOQi2HC3jW6Y3YIZdTHeo=;
 b=d180LSP5sS4lfvmdTysakScBsDE7GdAKff4P8PeJlhKT2QuqOyxlxChYQEp3hSJN+v/65nhcL3aQsvw9RNhHOdKNKuw7rWktFfU/wN9N0UcNYFN2M/Q4yrmg7uX760tG8LeGu4aS1wxsHesFm7RTR1a9GGGp5I5WHkGwfE77wg9XCfYl4hlWhRU61MqZENtU56/t0eUK/zHMofGHg2Tzbm1CGIf90RV3f7UUR4qQ1cC8hIHnS93OQJgjBPDBV82BTBBHLfgqZkOkk8aIVZKvOF6h014TI7e5eJFUnD3gln0RpNKhej871kB55QOYzlhmtm8hL6ZWpgZRVG7T/JHpmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y62Pbhksm+2s/dIkDvxN93fOQi2HC3jW6Y3YIZdTHeo=;
 b=MhYTYYGHqKUX3o628dvzM5kyiob9EP4gumCFcFsXyYUwo7uHYwK25EXk0yPZEV+RLJiG6BxtJ6g0bmw4lfJT6SIkRzsvwCANjihDSqj1M3jaihb02VhEprGtv0Yu9kqYKdFhp6hC1pKBuK+RA7ulIVkbFhFem/Z7RF0+xpHimGM=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SA1PR10MB5784.namprd10.prod.outlook.com (2603:10b6:806:23f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Tue, 20 Sep
 2022 12:49:49 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 12:49:49 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE V2 10/17] xfs: constify the buffer pointer arguments to error functions
Date:   Tue, 20 Sep 2022 18:18:29 +0530
Message-Id: <20220920124836.1914918-11-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220920124836.1914918-1-chandan.babu@oracle.com>
References: <20220920124836.1914918-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR0101CA0007.apcprd01.prod.exchangelabs.com
 (2603:1096:404:92::19) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA1PR10MB5784:EE_
X-MS-Office365-Filtering-Correlation-Id: f02aeed7-6752-41ab-2390-08da9b069ac2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6m7/0dqaXX9A8ebMN3BBpHIUqg9FPgyop2vu+DEsY3utxb2q0NWYnSxo5S54tgwv0zcQaqzFrANn8e6fiGxPzAZ9HoG02rbcblbZs/hfTYErv8XQR6z4rFXqone7ULz77MI+zFFyWb2EV0Gsyh5t3djGdtvRpay5XXU4q12apn5Y2OZZ1iRR2Ef/wR3buWoZG7cKiMVu8GM0ORsG+sG89ZJgYCyvd38Y1eZSSmHMarXc+FNaF188Zr1uoVPUbmWgAd5B58BPYS1xxRGjHXpxlqcuPsuUKs94bdbkptmSiMJu1Ou8G5TKfROpZfnflb61D9rFKUtpYpvkdnv7L0enZ7MaRntGyWtpzhqR/MtFSwSxNlGZ+hWo2HeMEj+B8r93N99WM6Ljue/1avFUmWDxYH1LoG+1d8wIaeonEFX02MW+5SlZ6V54oERteVupTVJ0JkRs6AAYuxGVbYQuMoDlxZLYHv+8NCaJYMcKo3Rnap6QBcxSyNEG2xJdsksDUnekqzoxJLNR4vopwIwi3cZF4E9JwlW21mlzGsPYZqoaG76nVAkyimARhUgU/eM1qC1F3dy+LtY3zR97shk3yECRMrPFBv1B4O3GmEH496jkPJDuK1ZFB0RBHreKvHlp0NB7diCuXSnhuRCf8OIXZTXYqXu1Gp0pGv5CrobeVwuVggbRxh2TQXwzkyIJYv8hjxQ0KArQUHjUzEKNyTQxpJ1NXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199015)(8676002)(36756003)(478600001)(66556008)(186003)(6486002)(66946007)(6916009)(6506007)(86362001)(26005)(66476007)(4326008)(41300700001)(8936002)(6666004)(83380400001)(38100700002)(5660300002)(6512007)(1076003)(316002)(2906002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iUED3+0Md302wynXTzvZVTKcM7C8rpdeeVaEq4WZhPaRJRFZ6sBrUGG75bDO?=
 =?us-ascii?Q?usBMIss/SbsS/pI74JljwCH9+F0m8BXgalhoW9DDaBdoKmLT8l9mOprCYIhQ?=
 =?us-ascii?Q?x3Ouf4cfQouRiN6XzTjf9ApLnkiWSvqMWg+3uez0DDGD2N8FBhAZXO/YG4Ug?=
 =?us-ascii?Q?+Ew7L8L14Uiv/vxjMn6W+yEk+SIRy12XmKMgyD8UH23c+p+Qo//dOe0ci4wg?=
 =?us-ascii?Q?y1YIs7ERKYprcrHKOsTybfnbherh5EpLFvL8p9AA4LPiRGewpBsTto+c3GiS?=
 =?us-ascii?Q?573EtAxSq1YNJE6/jG2fWwxHILrFQWS5nwUoKRQX6Fkle8WWrr1Zmx4+pouy?=
 =?us-ascii?Q?8ytKhZ1Nk7Fb8EBzkV9oWirHZ6RfoEpBknZD7ItbLHNnWq3G4zYcRw0Y9Xg7?=
 =?us-ascii?Q?dylSojheS79qEEAhnX7lv3Ym032qiKOD89xT3fFlmyzcSC+virEPmsbx3Eu9?=
 =?us-ascii?Q?dHgEUt2qUwbKE32UFQkYF5inM9cU9Ki01D4jmBZGDkvIiAlQVLvcJbH+kxAt?=
 =?us-ascii?Q?vJMfwaE91UxOw1+3ZLzQ6sX02VPpMs9ZPA5IS84kott3m0UmHqCXRQr4A/Fk?=
 =?us-ascii?Q?RleGZx622awwwKwnNlvZmNJfixoLejkd4iOkBvvxdn7ZdItyNjWIG5g4Yj4k?=
 =?us-ascii?Q?aq2HZXfSJTmBJMAVDV0aNR8NgJlGXh/eNPK+liFW421Wlb7Gy0tczk/pJ0nf?=
 =?us-ascii?Q?Bs7K+/6HOi5sggnxuaDvnr9KuWr3F5KW7DOE7x4Gjl8//NX2yV1vq2zH8eEV?=
 =?us-ascii?Q?KIx206P8Eio3RUGS3gkPDR/WF25sasbZPOmBDTRnRZ0ylc4bKSAlMAia5fye?=
 =?us-ascii?Q?YxarMpR2WTnxe7sTvjyT6q2RFGz0iqAWp6RMhhPkcqaMqOMzVV6gW9Dctna7?=
 =?us-ascii?Q?CbkJCXlsGxcLVot+5xKxjvzvu9g7PVVJXjTdYxJywRuS5EPN2dFuZ4xd792O?=
 =?us-ascii?Q?C65KRxYYonEaH8o+eXNfzx0GwiWgitGsYy5BmXYdKrQFk/TiZcclpq+s2op3?=
 =?us-ascii?Q?OVUDUCDMBAS6WIKDBVNiBDvNk1yWnqFbtpwHTA8+c958NZITnnfU+oGCZ+8p?=
 =?us-ascii?Q?Xqkl1U6guhETFGzWSi6HkNb1pzhl0eISUzw2jhMms6JyLrOYwCf62pwXJ1Mr?=
 =?us-ascii?Q?2cnWhVcymSBavVqvHueMTMfk3DVcwn1vFsVwx8br8uoCpgzeUdbboJq2hZs0?=
 =?us-ascii?Q?JYYR1Jx+3mN27jZ4y9XqTOgv2fkfy+Lg7n/qj601pKFxso0IV+5oyAPC4k1c?=
 =?us-ascii?Q?lK3QvkuiE/RFECDvWgOQOMPuzSx/QASo7UCsyco12VwaskgG3FTQUsZW5L95?=
 =?us-ascii?Q?S6fK+nltCgj12NOy9KghKFWa8m+uUicgeSh6KY6G9Cgv2zQ/wlNZghgiIfsL?=
 =?us-ascii?Q?nEOWoeODpFVvjpHpeCneoczd213YMiD5pktkbIS9OVQ8KMAbKTzCDhugd8Lf?=
 =?us-ascii?Q?arH1S/JL5VU6CpZE5Qbnfv3fHLqyQtFYGfmjrUZLMzERvBS3eU5/wQZek6n0?=
 =?us-ascii?Q?fubR1VQ0jA9Io+jAClblZcE+xxxFusmQ609oc5tj05n/103woDhLBgLA3zED?=
 =?us-ascii?Q?4yKqcrFQI8LFtctwfZOUMd58AxEwHMWg/V0PYezNYdKgLFJOxbOXNbM0cztf?=
 =?us-ascii?Q?Lw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f02aeed7-6752-41ab-2390-08da9b069ac2
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 12:49:49.7056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FNrq2WSso4JeR1X8BtVk1qOHUkhFfj9aBuWmWfAnU/vLnBz9WrR6puoOlVXs8mOpWk2AqO6gKG+Y2mf7ia//ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5784
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_04,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209200076
X-Proofpoint-GUID: iAb3ryoSC_Xc4LOode_CklSZBuOmOwgv
X-Proofpoint-ORIG-GUID: iAb3ryoSC_Xc4LOode_CklSZBuOmOwgv
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit d243b89a611e83dc97ce7102419360677a664076 upstream.

Some of the xfs error message functions take a pointer to a buffer that
will be dumped to the system log.  The logging functions don't change
the contents, so constify all the parameters.  This enables the next
patch to ensure that we log bad metadata when we encounter it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_error.c   | 6 +++---
 fs/xfs/xfs_error.h   | 6 +++---
 fs/xfs/xfs_message.c | 2 +-
 fs/xfs/xfs_message.h | 2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 849fd4476950..0b156cc88108 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -329,7 +329,7 @@ xfs_corruption_error(
 	const char		*tag,
 	int			level,
 	struct xfs_mount	*mp,
-	void			*buf,
+	const void		*buf,
 	size_t			bufsize,
 	const char		*filename,
 	int			linenum,
@@ -350,7 +350,7 @@ xfs_buf_verifier_error(
 	struct xfs_buf		*bp,
 	int			error,
 	const char		*name,
-	void			*buf,
+	const void		*buf,
 	size_t			bufsz,
 	xfs_failaddr_t		failaddr)
 {
@@ -402,7 +402,7 @@ xfs_inode_verifier_error(
 	struct xfs_inode	*ip,
 	int			error,
 	const char		*name,
-	void			*buf,
+	const void		*buf,
 	size_t			bufsz,
 	xfs_failaddr_t		failaddr)
 {
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 602aa7d62b66..e6a22cfb542f 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -12,16 +12,16 @@ extern void xfs_error_report(const char *tag, int level, struct xfs_mount *mp,
 			const char *filename, int linenum,
 			xfs_failaddr_t failaddr);
 extern void xfs_corruption_error(const char *tag, int level,
-			struct xfs_mount *mp, void *buf, size_t bufsize,
+			struct xfs_mount *mp, const void *buf, size_t bufsize,
 			const char *filename, int linenum,
 			xfs_failaddr_t failaddr);
 extern void xfs_buf_verifier_error(struct xfs_buf *bp, int error,
-			const char *name, void *buf, size_t bufsz,
+			const char *name, const void *buf, size_t bufsz,
 			xfs_failaddr_t failaddr);
 extern void xfs_verifier_error(struct xfs_buf *bp, int error,
 			xfs_failaddr_t failaddr);
 extern void xfs_inode_verifier_error(struct xfs_inode *ip, int error,
-			const char *name, void *buf, size_t bufsz,
+			const char *name, const void *buf, size_t bufsz,
 			xfs_failaddr_t failaddr);
 
 #define	XFS_ERROR_REPORT(e, lvl, mp)	\
diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index 9804efe525a9..c57e8ad39712 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -105,7 +105,7 @@ assfail(char *expr, char *file, int line)
 }
 
 void
-xfs_hex_dump(void *p, int length)
+xfs_hex_dump(const void *p, int length)
 {
 	print_hex_dump(KERN_ALERT, "", DUMP_PREFIX_OFFSET, 16, 1, p, length, 1);
 }
diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index 34447dca97d1..7f040b04b739 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -60,6 +60,6 @@ do {									\
 extern void assfail(char *expr, char *f, int l);
 extern void asswarn(char *expr, char *f, int l);
 
-extern void xfs_hex_dump(void *p, int length);
+extern void xfs_hex_dump(const void *p, int length);
 
 #endif	/* __XFS_MESSAGE_H */
-- 
2.35.1

