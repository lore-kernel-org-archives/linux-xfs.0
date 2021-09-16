Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6677EC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:07:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B81F61185
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:07:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236222AbhIPKIp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 06:08:45 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:50858 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235287AbhIPKIp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 06:08:45 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18G8xcQP029200;
        Thu, 16 Sep 2021 10:07:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=JkIG2HVCU0xddvQaOI1MbI0CLhmt/nEDzS+OxY+FKBI=;
 b=JtneG3wVpt6aMemcbbgst+hBm1Cy/0gcMx9yrmWnd45Tgrc8XNFPtNSy83hwJ6spgUvO
 XzMH5HrMm8OC3J6d2sC8ytUhibXQCSAULW/f4j1/qvamydIKJ8qJlXObN9dYUlN39tb9
 VamHsNJ0n1pPy8cncr91TkNsOzFifZD1IpZvSna0pW7xCSYb6Atk08IiYobGbbZOR5ls
 xQdbtKhiZ9+oZ2VqKG4r+pJTXdTwnt7pO+5UwPHZjYHBpS/4nZrRlpQ179ErFY+IuL2G
 ASbFAmcVZZCE4ehEQC0UDhrbjjW626gat14VKyZPcHnEyoq5cVOHrDa6dNtXyc/iWqbv mw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=JkIG2HVCU0xddvQaOI1MbI0CLhmt/nEDzS+OxY+FKBI=;
 b=ZnumcanzCi7j4i/x4UTXlDBv0RR9YD/SwRrF08CbXauziGPF3M7Zz41QEbOky6Wtqdhv
 5cu2hCdoR8u9z9LQ/JSYG5ItrAUZrrhwDg8WKR/mFCNODpRfojkI2zCkNHwnObnt5knW
 LvCzdQ0DMMYOYC7LfXWz7wrqCP4zbFPWjsxKgyd+/vquImueq8cLrFxjqXlTjLBeZj4/
 yRFOBeB+a8k57jVaLKyxohzGS+sh9pPb4ZRKyJEfM7o4iD7aaQ6L/nv2lCsIUeshMUHy
 J35nNCLI5lO8H7dLAzCJtUW0/uWSf6G40wa8VjPv/yufa0aChxlnVSHfF1Oc+SOkyYaF fg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3tnhsbgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:07:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GA5HKt030773;
        Thu, 16 Sep 2021 10:07:22 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by userp3030.oracle.com with ESMTP id 3b0hjxybk9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:07:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZTdboFMIThLaDR1yG4jyAPQrUhaKK3x4et+4oLYntMTPgYkVqG0z2aklnvpU+hy8ODX4hsCUIJ+n/n9GuCyUUQfIjJUVgur1cU/inJRPD3hliT+DdGsQWYT1P/2Gd31YBe0qsL6u48da3Xu/+i/NBQ7ivVjV8rJpqjanemV7TzPUY3WDLDY7BM3x9tIxjcOLDgixWpDPZN+6N1e+y5F+1a55PFOgtyGArEHG6r9t8Bbcu0I8+XlB2UdzAz2ZajSAWv+bNCWaocjtNvq9NmGYqGMBKGmuPtTGkiWCyQjG4HECZP1S/r0BMdzWKWSHrv+3oE8ufEtqbHrJuRR4kZFSEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=JkIG2HVCU0xddvQaOI1MbI0CLhmt/nEDzS+OxY+FKBI=;
 b=RxNQ5YbXTLok0SJiLH21DGtrWGrnuCWLdN8g0Zj4y9YPgUYs9l8A1sF5L9cZ6rnpxPyNljevCWdUIn/AKG+vI2Qfioj9J3Rc0Mm+d6d6aLuPlz88HhiBEhgIALlywkjHxydv5ZQmLAIjsVumphOTnhf7IdPMarD5Gqr9DLOLObHxh2Mt1dcJFNma0c+QdDxP6irmofzju3V3XK7R+GtXsb2Hwc81QMEUtZWooDTItVpuN8u88RMr7KSdDjy4V74jvcgdvU/BWvbMLjJetwVj8W1NUT7pxQCvMdn+dS3VmQE+u9kmCYVAJTRUfIuO9RNQY2AAwOnEo9cndCWXO3yriQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JkIG2HVCU0xddvQaOI1MbI0CLhmt/nEDzS+OxY+FKBI=;
 b=K8FRfT1eFQLYIFDniu9vicq2W3SSNYEYUGnS//awkQ5ykr5c7Ce9RJuAXBnXHLXAseKNuNdRSLocmn/qhimZH8h0aJ3zroe9ug5z9uVESpsmpH7pJ6rkGrxW191kqh94fqrd0r87Gy9ueJbTaaNA17+bASn2SVvraYvF/cTfHcw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2878.namprd10.prod.outlook.com (2603:10b6:805:d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Thu, 16 Sep
 2021 10:07:18 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 10:07:18 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org
Subject: [PATCH V3 02/12] xfs: Introduce xfs_iext_max_nextents() helper
Date:   Thu, 16 Sep 2021 15:36:37 +0530
Message-Id: <20210916100647.176018-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210916100647.176018-1-chandan.babu@oracle.com>
References: <20210916100647.176018-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0025.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:d::11) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.171.167.196) by MAXPR0101CA0025.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:d::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 10:07:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0855743-74cd-4a52-99c0-08d978f9c418
X-MS-TrafficTypeDiagnostic: SN6PR10MB2878:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB28786C41AE6909E2FF142311F6DC9@SN6PR10MB2878.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:546;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nEhcftvAqogolgzH96W60Qas4I7gNcpUApE6wgnZO8jj55+JVTbiNpSwy9EqQF88T7H1PRd1mnwS2ijjz2SZ4s8Hq5fY7u8qdUWXZiqp6UZWUuDmjk6SrV4Vslr7/vS1R517LzQhexKcBvPqKYjQ4M25AlSikaR4px9+B1Pi02a7yW9fVPB7Gx8kaQdiNaTWgDI83qJEnE/A57zaQXqqoPDey+i8fUsFTHjqCKf2QbXbb9Sb5yuYUrgFCash/kIXbLD65nNzkltu1CB3U3pRkAJK/kWCtACnFQoDrDczXaJt22lPKUqTgqbFcQ726/ad3Qf44RRgBUGo6weZATsBaKmt3UmU5Sz3DbJB6HEdDALVfNKKPugppZlJsAPnJSHvOCagl5gTA1zs2D6uBBMkstR+7aPTEeNuyJiiLmvIc3UNDno2m93H3WRlr4w+ym0qhsjyA1y2QaaVPhT20pmnmMZEFLilbr+QrxSknSXiW1l5X3MN+Xk0WKYQQW7e3Tc/b03ISAP0PUM0yyLUQH/wNhrdmPrnPd09rjo11weoIQbPVb48LSk8or5V99zWP6BSsOsdi9XhitflUZAJx7nHJG47F3EisbjzffBxS9g0oGkmgMF5g2zeLX347J7daAeWTyJlBRoAtRW4/9eONVW9F/egx0exyXOzI/XSbpbzipRjKkpE64yXcgSKyYaQvHh88RoXTQC+NOQUemk87cUulw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(136003)(346002)(478600001)(5660300002)(186003)(66946007)(86362001)(66476007)(66556008)(38100700002)(2616005)(83380400001)(6512007)(8676002)(956004)(4326008)(26005)(6916009)(52116002)(38350700002)(6666004)(6506007)(1076003)(36756003)(8936002)(6486002)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5aT5yeRxjHNt+Uhu3kH7yN4S3LcKubVgAdTfH91KZ6SRW14q2Yzno5c5N2M7?=
 =?us-ascii?Q?We02lbh1lEy38diDWrTD6eQmH2BhpbgqvoNjJwCy5PTyJntKMZoJW9kFovBO?=
 =?us-ascii?Q?D2CcYZc40riqMf9srKZPhQMXwvH3sSTEDn6LWLSmf7NLIOrZB8QUEWxWkEGm?=
 =?us-ascii?Q?mgJ7gonVHicVdQKLT7pH/fW1pnFuTMVJQ5iwHaEl88R3pGt/R0dxzX1gk0+u?=
 =?us-ascii?Q?NKQoC3IEv/hQRRYmu9mtD4ZeoJn+DofED+yjdSSW6YTIraOYsYQJcOuVv7+N?=
 =?us-ascii?Q?J5rqmssAi9n2gZFzKRWzHQvJ71y/j0T5To7lODio880JjJ42HaL7DSwUmYay?=
 =?us-ascii?Q?77KoHoLvTeLfcI0/q6NfA64jE9EpRIxqX00SY6Y79bpjPbCxllaZQXiGlVv3?=
 =?us-ascii?Q?cjdoxKN78F5DbfLbKLsqOc3ZKR2tl0TtOItLXZ8NvwwZy2qlhgJ56uzcJgN6?=
 =?us-ascii?Q?J4PdamMA7KfCwPU4Vuac0fXRrssGruT0DsY5dIIw1nE2bqGuEi8q98Od7VvW?=
 =?us-ascii?Q?kTAAXKtd/F90oy5a4EIkSRoRexRXXTcq5zqWMEHQ5N70iuQ2dVDplWS3nan7?=
 =?us-ascii?Q?LmJrxGpPI+pEXyWa/HrKzi0zYm64RSkj+fzzhZ6omZpkbqn63UoLlWDwBQn0?=
 =?us-ascii?Q?WUp6iAdzO03IE4cTxtYWz3qJjPeQNxpJiRaRoJN05GyhymB+6ArzC4tE6qE0?=
 =?us-ascii?Q?jO9pvSGL2Tp3+FzmqIkPuJDxCkHHmV9dxikyzgRC/9ze2aqJ/9esK7xrz4wc?=
 =?us-ascii?Q?JozHCYJA+J/Cn8RVs2hQxYhLFny/hVhyPLVFUSmtgO2PVVBp96FR9fEujAah?=
 =?us-ascii?Q?3ZvSwz1Eot2qfqZfDGfh7+aeQu/dHT5OrJfSsZuhGUbIWsHLHMb5PwvYY8Ui?=
 =?us-ascii?Q?qh2AWIpEwA21SWe36/iIfyPjXcZmKtuCYKYgUSpj0qXc9xh4jgVaA+c5zwKj?=
 =?us-ascii?Q?NtqkbfMnkKe1bkNjm6jUM5CL+P6ZYk373nytx3HmU4voI0GrftyjZCJwG9T6?=
 =?us-ascii?Q?aMxqn4DhoKE+E4F+RbdDgn3igqEVqcavBEXlkodch+5n0Kr9Bz0WpGSmP6nW?=
 =?us-ascii?Q?toL6YbT3B6DnKk+XhSyElr3rsxDtH/Wk9ekErcSWPaL0vmj65rxUG6inpMo1?=
 =?us-ascii?Q?eR2ncgRGXeHugIQFPRUmNCWc2AkoITT+p9q3MC1xEbpUP6cGiSMpkwy041+W?=
 =?us-ascii?Q?rZ6NLuHBfZQWTMKHiVRA3cuneUTGWPay9NyTSTQLWAnZzRIq6gJWkqE2uqH/?=
 =?us-ascii?Q?L+10u7CL5wqgmbHQJH6qxtR1qQRpDs0aQgj2Rapx9VmG2cWgvNej3PGGH3bn?=
 =?us-ascii?Q?W/oKjyb5zx3Bl9uUjOncEQ+u?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0855743-74cd-4a52-99c0-08d978f9c418
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 10:07:18.5057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rCR7mEWE033PVgfkhjX+sGBAPrZ0V6Bs+zX/1z0I3H+zH/CPGfFtzHzut8/NgSTQPPMVCmU8AV9DibUYzuvXGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2878
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109160064
X-Proofpoint-GUID: TMRexwZ3RAQiQ4TBGUjL7srdboXp0T22
X-Proofpoint-ORIG-GUID: TMRexwZ3RAQiQ4TBGUjL7srdboXp0T22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_iext_max_nextents() returns the maximum number of extents possible for one
of data, cow or attribute fork. This helper will be extended further in a
future commit when maximum extent counts associated with data/attribute forks
are increased.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 9 ++++-----
 fs/xfs/libxfs/xfs_inode_buf.c  | 8 +++-----
 fs/xfs/libxfs/xfs_inode_fork.c | 5 +++--
 fs/xfs/libxfs/xfs_inode_fork.h | 9 +++++++++
 fs/xfs/scrub/inode_repair.c    | 2 +-
 5 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index cd97288f6abc..88d4d17821b6 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -76,13 +76,12 @@ xfs_bmap_compute_maxlevels(
 	 * ATTR2 we have to assume the worst case scenario of a minimum size
 	 * available.
 	 */
-	if (whichfork == XFS_DATA_FORK) {
-		maxleafents = MAXEXTNUM;
+	maxleafents = xfs_iext_max_nextents(mp, whichfork);
+	if (whichfork == XFS_DATA_FORK)
 		sz = xfs_bmdr_space_calc(MINDBTPTRS);
-	} else {
-		maxleafents = MAXAEXTNUM;
+	else
 		sz = xfs_bmdr_space_calc(MINABTPTRS);
-	}
+
 	maxrootrecs = xfs_bmdr_maxrecs(sz, 0);
 	minleafrecs = mp->m_bmap_dmnr[0];
 	minnoderecs = mp->m_bmap_dmnr[1];
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 5834d46762d4..51d91ad98b50 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -343,6 +343,7 @@ xfs_dinode_verify_fork(
 	int			whichfork)
 {
 	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		max_extents;
 
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
 	case XFS_DINODE_FMT_LOCAL:
@@ -364,12 +365,9 @@ xfs_dinode_verify_fork(
 			return __this_address;
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		if (whichfork == XFS_ATTR_FORK) {
-			if (di_nextents > MAXAEXTNUM)
-				return __this_address;
-		} else if (di_nextents > MAXEXTNUM) {
+		max_extents = xfs_iext_max_nextents(mp, whichfork);
+		if (di_nextents > max_extents)
 			return __this_address;
-		}
 		break;
 	default:
 		return __this_address;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 801a6f7dbd0c..bc12d85df6e1 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -729,6 +729,7 @@ xfs_iext_count_may_overflow(
 	int			whichfork,
 	int			nr_to_add)
 {
+	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	uint64_t		max_exts;
 	uint64_t		nr_exts;
@@ -736,9 +737,9 @@ xfs_iext_count_may_overflow(
 	if (whichfork == XFS_COW_FORK)
 		return 0;
 
-	max_exts = (whichfork == XFS_ATTR_FORK) ? MAXAEXTNUM : MAXEXTNUM;
+	max_exts = xfs_iext_max_nextents(mp, whichfork);
 
-	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
 		max_exts = 10;
 
 	nr_exts = ifp->if_nextents + nr_to_add;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index cf82be263b48..6ba38c154647 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -133,6 +133,15 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
 	return ifp->if_format;
 }
 
+static inline xfs_extnum_t xfs_iext_max_nextents(struct xfs_mount *mp,
+		int whichfork)
+{
+	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
+		return MAXEXTNUM;
+
+	return MAXAEXTNUM;
+}
+
 struct xfs_ifork *xfs_ifork_alloc(enum xfs_dinode_fmt format,
 				xfs_extnum_t nextents);
 struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index f3140991ee5b..b58820d22304 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1202,7 +1202,7 @@ xrep_inode_blockcounts(
 			return error;
 		if (count >= sc->mp->m_sb.sb_dblocks)
 			return -EFSCORRUPTED;
-		if (nextents >= MAXAEXTNUM)
+		if (nextents >= xfs_iext_max_nextents(sc->mp, XFS_ATTR_FORK))
 			return -EFSCORRUPTED;
 		ifp->if_nextents = nextents;
 	} else {
-- 
2.30.2

