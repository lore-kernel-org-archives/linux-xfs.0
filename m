Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 239C7C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C95760EB6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236408AbhIPKKY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 06:10:24 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:55462 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236314AbhIPKKY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 06:10:24 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18G908Aw028347;
        Thu, 16 Sep 2021 10:09:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=STJSI1+XM9zk0H38awDnph1iNIlCTWh05FDJb1p9xjc=;
 b=GgVEC8SNVkQoA/8Ne3E55vsbXxbFHpFO6JmEtYau4OIbF6Cow25UCIqnV4MZ+F0fa+gY
 A3kqV9iIr2iYzAg1u4Vs9Hbg0t5+lkP19/6UV7q5zzsn7Q66Ui3k9n8NB6rohH5bTszB
 VRFCr4lZtfj4XCaOjxhqcO2RE02bR3RVywNroeuA1gTosknRsUUncKE8A8U5rFpZgh1u
 guEcps5N5YGfBmaj3mId0op7KqgHu+nxFCMJxR5xQBbByGgsatGUJxKaL/EBAELV/vR0
 LzCDgrf5cJEvIK2V7/+KWhm/7fXyX3OU4uzY4IpXwzm0CfL2S176Kw+gHzaBu7j8FdYx 6w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=STJSI1+XM9zk0H38awDnph1iNIlCTWh05FDJb1p9xjc=;
 b=p4Mg2nKw5VeItL7WYxoS8g2RUM9AzgCopa5y5UnFxQnXpNlS99xxHl7hy9+OufGMThLd
 DD+PY0EO3cVpsvtFDNab63SHjHhP3uMNOgOl8xr6pDHPNYrCX/gdkFKUrILTEvjHZv5u
 4dFiL5aq4fRcfUwwiMFdnuNodI7qzwAUSML0Adoci7rmDFOD7Pr/KPC56sgpvdNdLKkn
 xKSeXUbjz/H04UGPkhzizeknM3uMaCxRJgItEj+iR2AEI6XODcT9LjYMMJ5I/XUs+Rl+
 a2HrP/PkcLilP7OM/9xaWJTlDVwHlKZb8GbgdmywviUgGaGppNF3kL3OAJ8sZCl5hrnt qQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3t92hd6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:09:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GA6dw2160440;
        Thu, 16 Sep 2021 10:09:02 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by aserp3030.oracle.com with ESMTP id 3b0jgfv5s2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:09:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QF52pBHcyVYjhDhyigr7iOH6MhzzQihNx0FIAYvRhDRd0mUEbRBkI5eReHGmq6XwDjPawGD05+XcbDn60mVAGOl5L3LMnlt42cPUd+ex5pK8PYbyJ3JrD2KHWAg2O+QnQfLocLTRcHZlVvll9O5LQ15kzDmRTEdNJtB5Q/mxxafJ75s2lMjuD9IvcUirnv0xiwWM1yflm2/QibiqbHyyqSHFyuAWTN8yW9i7Stlw3/M05AZXJNgjZTYjj1Q4jPa9WcWzQj49WVMqMojPyXe7h71fXCLO2Kl1qj7fx+dK2nwkEycrVZyNsYXt/V8ghpVggJD1lMg4PDFilcuo/hG03g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=STJSI1+XM9zk0H38awDnph1iNIlCTWh05FDJb1p9xjc=;
 b=ncxmFwev7hbr64jNZ2V7RIh9eO8TCOvscFO1iO8DERa/mu5rzkwyCVJdQMzHshti+8UFYp6X5FmiO9Cu47DhXrRzAK3KQEnqzytD4uaHmKHe3kTOybmHOjJ8xLA+lkIEVRDzR0Ik+NR7zBuB0ALhUbFEFk1rxvCoPW6QlNDpqyPy+YPkSyBkBclmLDOjroEpkhsjrj6gOUtJs9pxpuEwwbOAw/2VNcPTYPkQIrw4m3uxhzcsH/7dLesoCsNJqNczLK8EqAXUdT8U1F0PZZSQ0v2uGiixxCP1gM4222iGzfw0Ev25UMVXruJiUJ4hgQeX5meBUC4TcDb1UPO+wOXZ9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=STJSI1+XM9zk0H38awDnph1iNIlCTWh05FDJb1p9xjc=;
 b=Ogl7g+KlAMX/GUJOMYOPnayH8vltDW/XJKIOvG0La22QQwA/9hukk9Ntgg8WywPsNG4p5shs5d17d0w/hFyWEyQVpVpo0QX+APz9mEz+37wJcMTnKvUs4VK453ool8WS00CX2GH7Q2SfA1zraczU9JkRI6pskDf7HvkPxHxf6zo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4748.namprd10.prod.outlook.com (2603:10b6:806:112::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 10:09:00 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 10:09:00 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org
Subject: [PATCH V3 05/16] xfsprogs: Use xfs_extnum_t instead of basic data types
Date:   Thu, 16 Sep 2021 15:38:11 +0530
Message-Id: <20210916100822.176306-6-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210916100822.176306-1-chandan.babu@oracle.com>
References: <20210916100822.176306-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::28) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.171.167.196) by MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 10:08:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8566b510-fa15-48e6-058f-08d978fa00e5
X-MS-TrafficTypeDiagnostic: SA2PR10MB4748:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB4748AD5315A4B8827756C0DCF6DC9@SA2PR10MB4748.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:77;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hkbivV0aZVSgsH+IIH8iGJ2x2qzGdomlxUWmznE8tL0X08spKAPz/SxUr72U69nOADVFHACMHbCXSPtYAO7FzDFldQqMp8CbWI9K6kCKLlFf9dFENUlMH9/kYzkDn8kZZSNiNSI8fY333P+ti+GU1GeNIcNctXF8JQ787ZXFStgFwF1TAVlLcB5zJyBUBhmKWQHCY6eP1Sk8HiJykSMx6TzlAi4X1YyDXCL1smYTUyeCr2lALRIlUD0Ad9Nc03/aCD31n0QgalvxNabzHMMAlu49C7gJDJoNRO13vEZ1gxoZKkRBnnwC0fp4MxYQPxkQRkAZZKW0Fv33eKLnybuEw1pFd4zBA/2aIiLAuPkYREesKVnbbxfQGQz133hZijdV8MipW2JGenH0JYO6W+4wXyxrdazl/S1RyQSN0izG/DYkIpyJjpHRT36LnPSIeLAwqfAM1tMISxjvQjkJWvfPZNLmn5GDsiQrzXq+aqrN/Hw8TZKJyB7IyZ6RAP2/9nTUYU+s4Pdnr6d7x9n3eAmbAXYFyh4OvSKJ9P4O7pEZGSIZucnqThsW0xEzUF0GELICev0a/yo8+mMbuEruaCEXIQ7KqbvNrSewn87I+/7AaElQK1KF9JS5FajbzxSoUKWvdad53E38BWjZgkTEDT/CsUhb0ELh+s8PB206oQMmckn/GOIChNa9wZgW+QjjlTwbFO5OUsAKr8gpQnar4HyieQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(136003)(346002)(66476007)(2616005)(66556008)(66946007)(6916009)(2906002)(1076003)(4326008)(956004)(6506007)(83380400001)(316002)(8676002)(36756003)(478600001)(38100700002)(38350700002)(6666004)(52116002)(6486002)(8936002)(5660300002)(26005)(86362001)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aMn6LX7UqYwR9mOLsWKvh1NHnIlZEHAAMdkGca7C7gqs6LniX0eayxxJ9PG0?=
 =?us-ascii?Q?NTbicZ+U/e2F+pjxxxWBfUoYLyeCnlxDhLHxsknnBIabiMGH1ZHLRQdSXrCK?=
 =?us-ascii?Q?AqFVdoCPaoLqTJ6FfRJ+yB6D9WBxGz6R/Z/IC+Qt0Ym5XIRl1CkF4cyFeufz?=
 =?us-ascii?Q?6MOqhnzoECF/2IPP5qWc4YwOvIRviRid/Jqe6G6urX7bZgqeGWt0SA4zLmbX?=
 =?us-ascii?Q?L7l6OhsspS7QQT80Sz8DwAQwLi5Kq2qY9mKfzgknbzb83qTnMyOPzree1yIz?=
 =?us-ascii?Q?lP3ypm6Pe3FtJz4ZFFTJtALtBFQgFHK9VNON2dD2nqilT/suT99NzhH2vNO/?=
 =?us-ascii?Q?nq2SoBQEDj3itad7UYnk4651VIwZcpyyhOAoqqN+tCBxZUM7bAXlIVunj6GC?=
 =?us-ascii?Q?kHr3B5kL5211yuGE3b+V+23sU9D9PP7DmJINrBdGudJL2DaEesriSnytpgau?=
 =?us-ascii?Q?aNDP9qiQE0u9FtGRuD/ZGI4OZoW2ezX1+W1N0oZpi54GkSKAm9L7n0KfxHT4?=
 =?us-ascii?Q?t08cXghQ5SFT8HYzEKH5ZcC/oc+wGBDaBktp6SKqu6T2koXQ/La5HZUlXszG?=
 =?us-ascii?Q?cWEVm9KxrJB9BQFX5sIcw+FqFYik5ZEPp1A6fmWFhZYsudtF+dFmF9janTEE?=
 =?us-ascii?Q?M/1TR50VrKfspw/G7yW+Y/+bDprapg6mNT6g7M+JjNnSD67MvctbeTPxJ/SD?=
 =?us-ascii?Q?uaau6pnThCvHcAvQC1uFXEBBBBAo+yOuxQEXErJkOvfrJbcFaIHMsWDUVGlT?=
 =?us-ascii?Q?ML3Ae8Ni28AtRLSy68tXvOr09f5OVn81IxTkppFmH80Vro8z0ApYCXdmb9kU?=
 =?us-ascii?Q?at9V+9zg6Fiq5DcBEas5yGCBiuFiE8jsZwwZXCcmvvKo30aUVxmNz0NGga0f?=
 =?us-ascii?Q?L9DLYF+NVlL+S+NsH+w3M+NF4IdRn1cSo25i4nfDb+2WLO6q3yHjR4dEiBni?=
 =?us-ascii?Q?2+s3evxaWHJfuUV+TwmRxnqHCQCiJ2PyzJIcIpRkCC3WdBPVL4hQJIO1QyHK?=
 =?us-ascii?Q?KCFU1EztVvf6GKZbXFZKd9uzW1TPBMN093Ut8rnbxDXmOCEsIv5sraCQgfDI?=
 =?us-ascii?Q?sai/p7Lq+nfPWtAdLweqItsqNbd7l3kYVPFAXMBX3e6ZvBnkxEL2DIr7CfXO?=
 =?us-ascii?Q?/KfmLnIaHezlRP6UfO+4aivvfsp7sQPW3/Ao7hCgMAlmD7/jNEVWGBotzpGo?=
 =?us-ascii?Q?Uzt/Haw7vrbVTGYpmKVyCM9A1+MSMh5+5qQmOKHRxHuNIvieDdKex8DNxSAY?=
 =?us-ascii?Q?L6aFGtoeW7+gibwnKXuwpBgyCvDHlvcNS5HKcQdRte860wsLMYkgOSHBNXVa?=
 =?us-ascii?Q?rXFwalE+0nl3alAbsP14qrHQ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8566b510-fa15-48e6-058f-08d978fa00e5
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 10:09:00.5207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z0LNAUjIGFvm/I03k714pgKjLA5FNgZ4HG4nkZonQo8kT+bRoy1ObdkR8WPYr2hO71twjQk9bwZb5FmaxllGfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4748
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109160064
X-Proofpoint-ORIG-GUID: mMJmkDfLX_PiXeyCJvBZPkyPlGqKAy4S
X-Proofpoint-GUID: mMJmkDfLX_PiXeyCJvBZPkyPlGqKAy4S
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_extnum_t is the type to use to declare variables which have values
obtained from xfs_dinode->di_[a]nextents. This commit replaces basic
types (e.g. uint32_t) with xfs_extnum_t for such variables.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/bmap.c               | 2 +-
 db/frag.c               | 2 +-
 libxfs/xfs_bmap.c       | 2 +-
 libxfs/xfs_inode_buf.c  | 2 +-
 libxfs/xfs_inode_fork.c | 2 +-
 repair/dinode.c         | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/db/bmap.c b/db/bmap.c
index 5f81d2b5..50f0474b 100644
--- a/db/bmap.c
+++ b/db/bmap.c
@@ -47,7 +47,7 @@ bmap(
 	int			n;
 	int			nex;
 	xfs_fsblock_t		nextbno;
-	int			nextents;
+	xfs_extnum_t		nextents;
 	xfs_bmbt_ptr_t		*pp;
 	xfs_bmdr_block_t	*rblock;
 	typnm_t			typ;
diff --git a/db/frag.c b/db/frag.c
index 26c3c87e..f324e776 100644
--- a/db/frag.c
+++ b/db/frag.c
@@ -273,7 +273,7 @@ process_fork(
 	int		whichfork)
 {
 	extmap_t	*extmap;
-	int		nex;
+	xfs_extnum_t	nex;
 
 	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
 	if (!nex)
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index cb34c768..19db26e6 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -49,7 +49,7 @@ xfs_bmap_compute_maxlevels(
 {
 	int		level;		/* btree level */
 	uint		maxblocks;	/* max blocks at this level */
-	uint		maxleafents;	/* max leaf entries possible */
+	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index fb271ef1..72c1c579 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -339,7 +339,7 @@ xfs_dinode_verify_fork(
 	struct xfs_mount	*mp,
 	int			whichfork)
 {
-	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
 	xfs_extnum_t		max_extents;
 
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index c943aeb2..61fb0341 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -105,7 +105,7 @@ xfs_iformat_extents(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	int			state = xfs_bmap_fork_to_state(whichfork);
-	int			nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
 	int			size = nex * sizeof(xfs_bmbt_rec_t);
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_rec	*dp;
diff --git a/repair/dinode.c b/repair/dinode.c
index 7b472a54..94b30ae5 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -967,7 +967,7 @@ process_exinode(
 	xfs_bmbt_rec_t		*rp;
 	xfs_fileoff_t		first_key;
 	xfs_fileoff_t		last_key;
-	int32_t			numrecs;
+	xfs_extnum_t		numrecs;
 	int			ret;
 
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
-- 
2.30.2

