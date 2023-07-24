Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF5AEB64DD
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 04:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjGXEhk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 00:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjGXEhj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 00:37:39 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C441A1
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2023 21:37:38 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36NMWNo4001972;
        Mon, 24 Jul 2023 04:37:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=By86vlQ/X4kg1XvfAL8vVwvDmHQQ5vV/ZDYs0A1YsnE=;
 b=Fg7pVd7b7eisx2LTt9vjirDQEIuMTLyXT6W9/rLCG8q+qGdhP9xR/pyxBGPsWYCw5DZE
 194u1vKACYo8QMoY7rjDdnIuiRwE1RW5k+ra+8awd6xO6hZjOxDgL0ngFqo3RS66YlR5
 JT6LKjdJ6NhWbs+fV1BSW1lK433scilPDyw7u5CecvqEqfQw6ZoFwKY18cMxhl0lUOio
 r7ioTWseO0KoJD8NCtn+u0MTFlGhkBLf/6zZb2YGI3fyIwAy59ad2t9lhXzM5Lk4PWBb
 7B7sjjKii0h2I+2SrPpyp18LY1HwCf20V3fEDRs84iTZBCqKuqt+TetP9Xvyo+Whp12U +w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s070astg2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:37:36 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36O196dU027551;
        Mon, 24 Jul 2023 04:37:35 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j96cam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:37:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LagbaeoadG05doxojjPtBh9JevJTCbF2JMaHcMSOgcn1vPELKfpEmV9hLrpdJH2f1+QOa/I974zeshVKJcvKIg/NrmKxQrMuQHlxr+czf2wOrEqvq4SaAloHN6TEilez+BMKP4kLNUHOmvwsRo89irtUlmUAtS2gUlQNOv783NVUylxChIW5yTv7KX6zArkw0bB8nVjyUswUq6OlBc5FA89R3xaL7E1XesS4FRCMHZdMIgciLdpFcwhs5MiGaedTsGblxkBOE2kg3mk6uM4CdCZC1J53Xm2T/MtUHzilCcjZKFL+WAYKFSKD+GAezOG4+zJMquzmo6bQyi19d1jShg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=By86vlQ/X4kg1XvfAL8vVwvDmHQQ5vV/ZDYs0A1YsnE=;
 b=BYz0CutLTV/aKx1+LH/cmCjYjM83hFmYsh/V8J8AGiJCjuHrNyxrcwmGrvyAwzQxNUZNvOgvxBz5aTI80SkjyLHaETUCoL3rI+VKnE0xA9wNk8/yy176rs+6P/6oZNW67c6sRQ5Uu0Mp7CSaIfwuMf1Et+j+CeIAky0bIm2Yb4mDaL7g89LceVDGDP99LOPLllNmR5rP1ruIavAaeDnY+s/qmlE1mxM269A1mO0EoQRwd08lNzzuopW8wkXaSqVTeAe0/C91QXgSP5GQZjfV29w9XP5zNUmUrIx9kfaIFbaF9TiXqrANjIDsAdltKhdwcTbPgC9TxThOv4kNmiIrQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=By86vlQ/X4kg1XvfAL8vVwvDmHQQ5vV/ZDYs0A1YsnE=;
 b=VE78pq1yIZsbwor7dMo9siInXiriQvgSV7y0/IqbGHt79V9Jw/ivb0agfglzX39HpV8pXrcmXldfYtc2VsTFY/h7+Q0WJLd9kmINjuieFV4LPHmO3WsiKRD4djuYhOtxzaxqTFY9nbDUZbgStubgfZckh1qAc746aCuJU5YqKAA=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by PH0PR10MB4774.namprd10.prod.outlook.com (2603:10b6:510:3b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Mon, 24 Jul
 2023 04:37:33 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.031; Mon, 24 Jul 2023
 04:37:33 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 11/23] metadump: Define metadump ops for v2 format
Date:   Mon, 24 Jul 2023 10:05:15 +0530
Message-Id: <20230724043527.238600-12-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230724043527.238600-1-chandan.babu@oracle.com>
References: <20230724043527.238600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0185.jpnprd01.prod.outlook.com
 (2603:1096:404:ba::29) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4774:EE_
X-MS-Office365-Filtering-Correlation-Id: 7982df21-75d8-441f-fe0d-08db8bffb264
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VOChuNfUPLRofTeqMJPZ8jz1KeR128NerIa17P0kAMV+/ow84wP/kYewP77nTMGqAuqNStBUevk1jRmJhR692V6A70/AwWDalz+xzpUWimE6GU40zpXVSd9I+kDIjzU3C1c74bh45JPRIUappFp7IR2zSsA7Z0inCOKbzTwxuZm8DocFs4IPKSaZx40ZOizO22SYok1+M9FmFq9tbbFYsuNfTLquNPQ6pOEb84dHvDNJcvZyvNWKN+zgXDtidaGNS2qgHu8OtWwVlhpul3w/Hbp/F++xviuRR+H2lyIJrVM46zXmELCcsuZ2U5n13h/qmyWxf2fD3uhvV6mXMBf3RZmGEk13cu3ZKpTm0kFGC/WGRt1iz+1fBPUFZOGg1JBpKbvY6ierwuOESZugA6AQJHvxP7893WTfco1Y5pyOHuWuA36B09ZIOX7Df9/83OjPw0g9FrnB1teOslBbQbA66iGqNKMb75Or+D0xvplMM0tc+pP5z9ortEGAxWv+kPnMOtyMxEqpaOLeojQcGNyWgXlkWPf6EA94kdVqlnppR0etld35btyrlhsBr9C0z2NM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199021)(2906002)(66946007)(66556008)(66476007)(4326008)(6916009)(6486002)(6666004)(478600001)(86362001)(6512007)(83380400001)(36756003)(186003)(2616005)(26005)(1076003)(6506007)(38100700002)(41300700001)(8936002)(8676002)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hlZSpcixe9WEqu0JdSSfHfj/bpPrYJB/I3/XqfwLjNYejeFgGdrq1Vuyry7c?=
 =?us-ascii?Q?UN+fco5/2+jdMK+3Y9zCs5970dQzp0ztLL21fW5TeQjUftYBTlHMNKD8mTZg?=
 =?us-ascii?Q?JxwQv4XXf8sx0Z3FQOSt+fxeX620+BMoAvfNeefGVinOFmpIisGyXh+VWJYu?=
 =?us-ascii?Q?sOI9YLwQNdKnZ/N1bSom3anMx7+WHPf2nylWjqutBQt/TUFY63WS58mOiRU9?=
 =?us-ascii?Q?q1CeZG5gbkfKYNkAc/rns9GR/rZywJTVvVDVfBOkdLn182w87riwTryZLckh?=
 =?us-ascii?Q?9Hd4rb46LkypAmmedQbg2lzx6sSi6aIACM7jalkp2BG8Chv0UVuAlMtsyPdL?=
 =?us-ascii?Q?bcIHe2vJNAm1LQIIBc9gCVbDog+bxWwcgk56WLNvOIckdOCNpDCQvCiijSZ9?=
 =?us-ascii?Q?jm/mtmpY7MBRFxxpF48geOrJe4thIlEmeRLMX2uJm0Pn8VvQUQ+bAULVq4lX?=
 =?us-ascii?Q?lxGWyuuTNK4rj3vfX51qKjPAa/T2g05TUcB58hIlL5FvtdiqaB+wfkDlpj4o?=
 =?us-ascii?Q?XYpPltpIxItXey+aIAgWXU+FIgGuY/JV/ML5pT2upnGOPYLkRl2r7bRTx1rK?=
 =?us-ascii?Q?mKMsyBjB780T4U6U8wgn0wbgPFCovdqccipSDegjUCfOlm6O0aajD1xEOVWa?=
 =?us-ascii?Q?5kMXh4lIWgPrjzstFpcfsssRv7X8Y7x/iZOWtL/4SnIXvEzZrQTth+gD9vyL?=
 =?us-ascii?Q?C8W0r/bvx/PSxuS8paLYFzNwI85SLuglR5En4ax5PG5nHlA0OMOsOclFtayW?=
 =?us-ascii?Q?SZkwyf90Z4jE+QypBokCzJm/HhUcJO9oXXrMaiGdB35pQIjEiWqrVsJL6S+c?=
 =?us-ascii?Q?IBptys2L6+Ke/w7hYmGbQdYkCba2fezPH0OZu/5OXhvVbcxVDVKQvV0zNmLN?=
 =?us-ascii?Q?uAAlShiHYYzXRmcSyJkw0QgSNOQ5kXmJ/ouvJbsTEXiHwaYftgBqcNcj7ccG?=
 =?us-ascii?Q?cTnQBqIpUDTaeh+ro9knDMsgvkmpd0Ce5EX8Ne4KxYMkldlQJaDap5goqWZK?=
 =?us-ascii?Q?VIY6AMIN9Z/zaYKmODqYvAZOssY/ZcDR3rM1hwbfT/PtQHFk/aMAARHuB0tf?=
 =?us-ascii?Q?H/nnH+5qYVuSL/wbB6d2H18+EO+T4haF1Sz+00hnOZK6e9U29m2YS28YiAK1?=
 =?us-ascii?Q?JwN/G5h57VFs5PkLtdYqLfeAuBGlGpajzqIqdUQ3N2bHj16ptlAnMh5Alyf0?=
 =?us-ascii?Q?3rmC9XsJ9Ht3Qu9tasEBwegTbl5j8LY3TKQd4e3Z2YU6RMPEHzbHPvzYgB7e?=
 =?us-ascii?Q?tBvdWZKbJR6mBO0TmZTOCsdcd6cBrQPNd+uX40ztLULoq5ydPJ4t4+By2bqn?=
 =?us-ascii?Q?Z81Eegc0bBlTSkYWwV/URC3TKz0jd5JZuqAgiC9cJXc4uXBVSf91DNwQVY6F?=
 =?us-ascii?Q?7UBFNBA22ixygf4yeySbC7C2aiFqayTlr4CjGaf4jF23JRJDkD2pz/wkXQL5?=
 =?us-ascii?Q?biLhQtSussHxTR7clE44mXmDTpTcawEJCjLB84A+kP5rpKdzwHAxUbDsbJbg?=
 =?us-ascii?Q?XxX/Bwe6IWufXhvRwLBf1DL2tVg6rtiA12C1YeDdvwwUtQegmko1vp8VMNFe?=
 =?us-ascii?Q?99L04Fuj3Uld4qDFFqKNUEI2DvQ7Ty6DrEPWfmVeZh6Nv5ncQKYtkjrqWIra?=
 =?us-ascii?Q?HQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: YDI+iXHypN5uL3sHF+FTEnf/1+zpFKkSzQucn4pzdNYOTy9UZVYzjk6ruKsEB2qkKHXSWwQTU6HCMffYHJ3Jd7lNgu2E5E0NRWjQp6UxjXJmVOgdT+5dRjrbwQNUwtG8A23XLXq+dIfMyP6FG+0lKvju8Jn4OHOFzShIk4/HfHLRFsCyYoE48Lcu9D9ZrHWHG4pUWo00VEKgTOCmkHlndlXh7aQ4GDEup7HL7N/xvJw8nWy9WNVTH+2uQXbxaNBvzEUBvZtPrlEWszdFXBcL6RuyS+FM6wWrs9WUYRkmw5rK8UxbmbH0uAcQ/ppqKAZPz0w9d3RmH1YfemTug770zX6XvWBc6tZsm5rL3reIOeqGK80QOtLgkVH0L0Dy3PvWIYxO9h7In8GBTFFtO7gCCAuqLLszsq0Nm+4VZ3oY+ww58ndJdAx/rHgrLwJJRlVHaUhuyHMaVZdZxGwqINiWyu/v9XWiHJ4w9zUR5uVuqlhAtKkwsEYXZQvsBI4Yntd8U4uXOj2lAnn2lt2MDK13bttBsViVlN7UsEfnqYzjM9R+jIV6OVPDdkaq3ElLHf8uynLqAMt6ttaS8urNUw5j0zRbVnot9cK8dQa2jCxuHejO3QPtYh3xYietRX3N8N349TlthPu3NNQJjfoAnt/8r/r5sVrp5R6rfTfCpnYgvGsI0viMfkHOeBSPG/QohtaFDLazccDCd0oXp2U8itD4Mo0PKGIH+Hp2eWVJzalQT+qIYhVH/I3zHXwTLrbQA55l9Oo9HEqZG8bHTGMSBDLYkn0bEX47ohVuzV++C8kwuVI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7982df21-75d8-441f-fe0d-08db8bffb264
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 04:37:33.0786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zt4ugYS4Q+kZAo/toYndot61nQb6Rn6iYT2ZznXFpfKmenbG4TAy+yeWFqaL1iFSIlAnRmWGEXV5ILVqNq20PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4774
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-24_03,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307240041
X-Proofpoint-GUID: DWpSigOl-kiUS0eVeQS7qGI3nDnKCyTQ
X-Proofpoint-ORIG-GUID: DWpSigOl-kiUS0eVeQS7qGI3nDnKCyTQ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds functionality to dump metadata from an XFS filesystem in
newly introduced v2 format.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 71 insertions(+), 3 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 7f4f0f07..9b4ed70d 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -3056,6 +3056,70 @@ static struct metadump_ops metadump1_ops = {
 	.release	= release_metadump_v1,
 };
 
+static int
+init_metadump_v2(void)
+{
+	struct xfs_metadump_header xmh = {0};
+	uint32_t compat_flags = 0;
+
+	xmh.xmh_magic = cpu_to_be32(XFS_MD_MAGIC_V2);
+	xmh.xmh_version = cpu_to_be32(2);
+
+	if (metadump.obfuscate)
+		compat_flags |= XFS_MD2_INCOMPAT_OBFUSCATED;
+	if (!metadump.zero_stale_data)
+		compat_flags |= XFS_MD2_INCOMPAT_FULLBLOCKS;
+	if (metadump.dirty_log)
+		compat_flags |= XFS_MD2_INCOMPAT_DIRTYLOG;
+
+	xmh.xmh_compat_flags = cpu_to_be32(compat_flags);
+
+	if (fwrite(&xmh, sizeof(xmh), 1, metadump.outf) != 1) {
+		print_warning("error writing to target file");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int
+write_metadump_v2(
+	enum typnm	type,
+	const char	*data,
+	xfs_daddr_t	off,
+	int		len)
+{
+	struct xfs_meta_extent	xme;
+	uint64_t		addr;
+
+	addr = off;
+	if (type == TYP_LOG &&
+	    mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev)
+		addr |= XME_ADDR_LOG_DEVICE;
+	else
+		addr |= XME_ADDR_DATA_DEVICE;
+
+	xme.xme_addr = cpu_to_be64(addr);
+	xme.xme_len = cpu_to_be32(len);
+
+	if (fwrite(&xme, sizeof(xme), 1, metadump.outf) != 1) {
+		print_warning("error writing to target file");
+		return -EIO;
+	}
+
+	if (fwrite(data, len << BBSHIFT, 1, metadump.outf) != 1) {
+		print_warning("error writing to target file");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static struct metadump_ops metadump2_ops = {
+	.init	= init_metadump_v2,
+	.write	= write_metadump_v2,
+};
+
 static int
 metadump_f(
 	int 		argc,
@@ -3192,7 +3256,10 @@ metadump_f(
 		}
 	}
 
-	metadump.mdops = &metadump1_ops;
+	if (metadump.version == 1)
+		metadump.mdops = &metadump1_ops;
+	else
+		metadump.mdops = &metadump2_ops;
 
 	ret = metadump.mdops->init();
 	if (ret)
@@ -3216,7 +3283,7 @@ metadump_f(
 		exitcode = !copy_log();
 
 	/* write the remaining index */
-	if (!exitcode)
+	if (!exitcode && metadump.mdops->finish_dump)
 		exitcode = metadump.mdops->finish_dump() < 0;
 
 	if (metadump.progress_since_warning)
@@ -3236,7 +3303,8 @@ metadump_f(
 	while (iocur_sp > start_iocur_sp)
 		pop_cur();
 
-	metadump.mdops->release();
+	if (metadump.mdops->release)
+		metadump.mdops->release();
 
 out:
 	return 0;
-- 
2.39.1

