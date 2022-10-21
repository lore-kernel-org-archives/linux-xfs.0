Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 195FEFA3740
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Oct 2022 22:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiJUWaH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Oct 2022 18:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiJUWaA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2022 18:30:00 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E4F13ECEB
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 15:29:58 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLDvFJ010115
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=u8ANFXJemEPEl5G2uQUXpknnREMAMf1WLaiUz9lWhI8=;
 b=H0i3o+vvgel9AlSIdmvwf/B+RJLmEQtmpWIH/syxtzKCGqphdyRCP3/IPFJ80/v89IiS
 hFQH32ljddfEYmhyzFJ4r7URQvdvoS7PREZUZsCkbyX4gmIyZN4KoLNTo1JWfi6uRkaF
 uFuF9w/fCLNRFF6GG3RgxItwE1HSj8V+aayzMDVZRC6C/ufnPqxZFhx/VlVBU4gJFf/5
 mJR0xibrdIN5mKd2Wb5InipKTYNZ+WEitKaanFWrCDEv8ruN0rpqByLh0tvTW3ioyoXg
 wYToFVfjXiY2bEbp2sm73ePSL21KbyqmtAMbv1CNn2cIeuaY32/bMm0R45nVOSqnPaKd +w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k99ntpm11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:58 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLTkFH027359
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:57 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8htm00hn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=es0ZHwb/l/SyX8WaZc+mNR2gwbq21enkviShcHNdncRQMG/U2kCdKGCQhYb/0q+kygpeYY7EK0iGxQ1UlZW+J+Mpoz02d+J+T2uknwY3420OXXjB73e/QpUyAZrEXmf6JH3ECF2cWecccmUburofe5OOlyiOUzE0HCbmQj/oEURgfRpdfPrHwDT97dqBEucg1ma/l7OInXYDyZCdOtMFSwXZIThzYrZXyLtSY9hfDNNbMNcndnw3K4JqLWQ4E7d7Jud1DSqHtwH+3lfgw+qkTsqY356553PGkBRWIOGDnYlWmVOB5vExyuJDum+6+yCsiTZIX1vA+iph04mSLbR6fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u8ANFXJemEPEl5G2uQUXpknnREMAMf1WLaiUz9lWhI8=;
 b=Zkwp5EGhu6nSoUTlcHnVFQlzbx1tJvFs4E4mKhnItThD83JXO2+39injmX+jczuyKm/99j1KAfz/gC9+d50zG42uXdKfjJ1e9MpwPQr++h3/ejtb+W/9/u+uGR8P7NWR33IgCzW5qjSsD60KMPPRcBqmY2r7r1X3EtYnFJyG9oar4WZYYw2nD8tQ2arVbqRKMiPFgzBUvad3vWyZmsqz2I4buBS8x676oRtkrm17toSWqOfP03vHs5hJDxPkmyMYjGdFIwZxyy2HGN9XscEbDInLOQFJkod+CqNuZUGagqkqvEwu6aaZcZPTo+p39rY7j4rPaLDlW9x2LJ1kcBbDkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u8ANFXJemEPEl5G2uQUXpknnREMAMf1WLaiUz9lWhI8=;
 b=vbzg+cIrEhCGBcHbvCcBGrhH/tg+byX/h69VpvfBHBpSMqGSDIUIbwc4blUiAqClesve2AP1HZn/ziHLhng1jPGpj/eKTWL18uLwa6F4aXWYfVDtXcZq8Bbjt5I5nolgSpARxFH0AK1nmJoePBTnrYrgVktwJjt6NYIzI6eZRBE=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5213.namprd10.prod.outlook.com (2603:10b6:5:3aa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Fri, 21 Oct
 2022 22:29:55 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 22:29:54 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 11/27] xfs: define parent pointer xattr format
Date:   Fri, 21 Oct 2022 15:29:20 -0700
Message-Id: <20221021222936.934426-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021222936.934426-1-allison.henderson@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::23) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|DS7PR10MB5213:EE_
X-MS-Office365-Filtering-Correlation-Id: cbd28f1f-99ba-42d0-5206-08dab3b3c6b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C4m6tTnx4OpVt3BF/ahfa6quHXYJsg9J8eZK8CroweIyLmS4m/v+O7+vvWYaQ9xtnb7uvNUSsnQQKkCYQaQyQ8D3NEaJ8JPzUVWbBL3iSIHNLTQqP3CvDrjdOJwgP0B7MOSQBiukfR1U+8AArLU/tRcJoKecMEJa7zgr3bQFCiBdikJ9FCYI9XnqDwmQ65Sawx1eN7x3j/Zq6YdhKM4VCbVHC7IaJgiE/U1+Wm2wcvR8wP60vx64x84LgAmMPyqiUDyPhOiLWuaGVyAXIYedsbtipMcyKEM2S8M7/A76eMteWRP4HEG3pgPFwkvTNQSCH4LnXFUkUQZwVJH+rJWgQWuDjwnwnRKUFXw2+cO0/lrxG3d1PrVrB8Ka3Czx+32Muu97uB+O5FIi6WmRUtT42lAZAXKTWoFJLtykkJ3Rpo1Zw3eCYK9GBDIe/ALFdWZe1bMSamGV3fuTu+CToyQZOW+8KjjOS2h/FtcbZgeiZHzEZzf4ias0jH9n1wpGWdNNNZv8VyJ1H2//oZm8VBlpaXdbiE1h2ivxDYDRVofaHPud6pVM2dyQBFuyJgUPGb6Qc0eruenci1p7MmZKXCBg8QFKY3YFY92hm969TkILf9ClOBvkW1HqaFnIUvGeR0y5za4x5VtGx19uXftmBTHJHwNjnWQMpypZ+KIOP++vkF9ijDS6mCfLTTdJ+L/maRuRe/tG3Z6L6FSRo+tRXFs6zQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199015)(66556008)(8676002)(6916009)(66946007)(316002)(2906002)(66476007)(8936002)(36756003)(41300700001)(6506007)(6666004)(6486002)(38100700002)(1076003)(186003)(9686003)(6512007)(26005)(2616005)(83380400001)(86362001)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xlqcbPJILZQ8bCUcc0zTD+SKZgB+HO+ZJ1S7Hc4hFdkGD7ot1TpbfB5huwC6?=
 =?us-ascii?Q?S1kr1n7Kh05szg4aFyU39MjQrE9i5zPTOP3p8xcpIq9R7EiJHH1SH74sTafm?=
 =?us-ascii?Q?xCtH5MqxtUZsxnoE0ye1oWZwm8TPNDaIDQPyNax61ojnU7zsedQaAWFe3Zq1?=
 =?us-ascii?Q?B9gtui0ouFdB3atdWOQKHFJNeC93KmgjZcve7/mH9KSlm+7nJueHWWQ61Okk?=
 =?us-ascii?Q?vKHjRkkX3mCFnJz+d+FgwyJu+UGbWVv74RPzulbuea9KfJGILY4p1OVcvU7K?=
 =?us-ascii?Q?wKLsz2CLBKx5hcg95WW+iYdvVkIvaU8Y6fOYqP5wKTqgySC0tLl5cQk6Dph4?=
 =?us-ascii?Q?Prjj99FruOP0jbSU6zwFcCEL9SePNyc2uH6AfHvojAJref8uNQhMkjnZoVxN?=
 =?us-ascii?Q?7O7dPnAjLKhZH0QIV8+6DE4OjVDYKV3E3DhcREhjT9k33fpQI3F9GXEHsybw?=
 =?us-ascii?Q?eG+N0Ou913r9bJIQGWIQus40Uf9ce8Ebv3VZjWCjxP+Nco5r4FZABPc/WPUz?=
 =?us-ascii?Q?RE2d+pHKi14IgYobAOjaCR9O53E501szy3t3QJ8WvFsSN54nmbW5qSwm9qNq?=
 =?us-ascii?Q?uPwUxHCWQTjSpuYzgW9K3soGcyWO+XMNfcmuYWisKUxhxG1l18nFw0Ezk059?=
 =?us-ascii?Q?WV0wjb2dmasedwbhALKc4VLwcV3pe02P0RR95OUpOy9ShcFdHv+7q73VMyuS?=
 =?us-ascii?Q?7KpNgWUi1CBby81ApTDeK5fsu5IqHXMHEravDdZl5W+z1EFZqCvFFDp2SjJw?=
 =?us-ascii?Q?aINgJ37VneJlxBrM4Gp2agceNvr/jnX4+i7EobORGv6G9WsgEVvwi8WLnees?=
 =?us-ascii?Q?dAzg1smU5ZzDGiU0/+MUN1qPgcIu6o1Ovv+HuNXLTIovTXZgresDq5PMh57m?=
 =?us-ascii?Q?IL9L/GVhcBERPmC0ZLBrVIClgY7xOD7wzZ1Ack0LFhGbsEwh+EfHafdDLyHo?=
 =?us-ascii?Q?y8b3yDZvqAoqUpjGQ/AuZ4Nrnn0ql+R+v0oWXXG50tP8CqHBRraH4aKQI3mk?=
 =?us-ascii?Q?JGFKOGkdTDRM7KtklTmCrxB94l0PBX8Ztb0WA6/S9RWeM/xKozNsnPAZF8wv?=
 =?us-ascii?Q?k21YojMiZ5Yf7sbUFjBxLnTSezTcJMyoHXcVNxRwK53wLnccbztxl49Jk6Mu?=
 =?us-ascii?Q?VbwGEUzMXkb7t5UMA9LU3SEW0DliXRAsOA9xUMMfLOnI+/Mx/hLn9jbZVcbC?=
 =?us-ascii?Q?Mo3EqV1Ej3hDIDjEjQxryXtvOxc6SAdHN44/gn77qVyIZMhT6UB1wcsoaSI2?=
 =?us-ascii?Q?0ujb7M/ZOoS7gQ4Ua0Go9WpomRDtyHxUqS3a/qIjZgJDpn3nzpO9uJaMm65h?=
 =?us-ascii?Q?CK2w3OtBxNwkWPoepN4m3oMsp1eQlp02M4/bVFKb3TyIEKfah8U+pVO80cpu?=
 =?us-ascii?Q?b0fm2RN35XnFY+Tb9zNbLZBC/ebU8DY9xH6IUAqmSebpzu9MHLMuvq8GvuCy?=
 =?us-ascii?Q?RDZD0tV7+OhnuPkuRMjr461u7GyW0Ct7hrSDUnW/mQXevc9TCXDJjg0duWKY?=
 =?us-ascii?Q?owjXH4fbFXmLAyADK+HEX+jGaYbuD9/Td3vge2r9wTkMJ4kL3k3QQCdarj7J?=
 =?us-ascii?Q?k1x8LbNOjpHKyhce1GwwFerkZBr/HzZdxH7aa+3/3beANNi13v+4cCWiDTgu?=
 =?us-ascii?Q?LQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbd28f1f-99ba-42d0-5206-08dab3b3c6b5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 22:29:54.3291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a9FhdMa6Mglvl2XEPNnIz8YxrPBNnCtoS14xBTXo/0x9+WmmhkX0ukJKm/uet+NPcP2Fyj7iwcEDp5Bj8UiyNmV3eZrKL7PIgbWTppi/RQk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5213
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210131
X-Proofpoint-ORIG-GUID: Ge7FaBP-ZWtKdbnb5eM-5kJUdl_fFPP6
X-Proofpoint-GUID: Ge7FaBP-ZWtKdbnb5eM-5kJUdl_fFPP6
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

We need to define the parent pointer attribute format before we start
adding support for it into all the code that needs to use it. The EA
format we will use encodes the following information:

        name={parent inode #, parent inode generation, dirent offset}
        value={dirent filename}

The inode/gen gives all the information we need to reliably identify the
parent without requiring child->parent lock ordering, and allows
userspace to do pathname component level reconstruction without the
kernel ever needing to verify the parent itself as part of ioctl calls.

By using the dirent offset in the EA name, we have a method of knowing
the exact parent pointer EA we need to modify/remove in rename/unlink
without an unbound EA name search.

By keeping the dirent name in the value, we have enough information to
be able to validate and reconstruct damaged directory trees. While the
diroffset of a filename alone is not unique enough to identify the
child, the {diroffset,filename,child_inode} tuple is sufficient. That
is, if the diroffset gets reused and points to a different filename, we
can detect that from the contents of EA. If a link of the same name is
created, then we can check whether it points at the same inode as the
parent EA we current have.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_format.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 3dc03968bba6..b02b67f1999e 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -805,4 +805,29 @@ static inline unsigned int xfs_dir2_dirblock_bytes(struct xfs_sb *sbp)
 xfs_failaddr_t xfs_da3_blkinfo_verify(struct xfs_buf *bp,
 				      struct xfs_da3_blkinfo *hdr3);
 
+/*
+ * Parent pointer attribute format definition
+ *
+ * EA name encodes the parent inode number, generation and the offset of
+ * the dirent that points to the child inode. The EA value contains the
+ * same name as the dirent in the parent directory.
+ */
+struct xfs_parent_name_rec {
+	__be64  p_ino;
+	__be32  p_gen;
+	__be32  p_diroffset;
+};
+
+/*
+ * incore version of the above, also contains name pointers so callers
+ * can pass/obtain all the parent pointer information in a single structure
+ */
+struct xfs_parent_name_irec {
+	xfs_ino_t		p_ino;
+	uint32_t		p_gen;
+	xfs_dir2_dataptr_t	p_diroffset;
+	const char		*p_name;
+	uint8_t			p_namelen;
+};
+
 #endif /* __XFS_DA_FORMAT_H__ */
-- 
2.25.1

