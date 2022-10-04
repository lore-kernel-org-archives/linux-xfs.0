Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 880ADC433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Oct 2022 10:29:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiJDK3d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Oct 2022 06:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiJDK3a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Oct 2022 06:29:30 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0995F2CC9A
        for <linux-xfs@vger.kernel.org>; Tue,  4 Oct 2022 03:29:28 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2947UoHv001108;
        Tue, 4 Oct 2022 10:29:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=2mokfh3arWwydhT4w/g/V01JPln7Yp5DBEwFLu4f3UY=;
 b=TG1n6RduetoFjmAjyQq+nUsBU9QbBlXI2B0rrt8hKQkQ8Zou5yPTv15+KPtGM3x8SKct
 FjGc7LWr0wBg/Ictn2g4kXvPiEaluOO7xp9lz6PjadFnwA+C8fek2jMTS55F1IPYBNSR
 vbnwEwdPSCJV3l4z6smgzOR3942Dj0xdLWtV54uq0gyGIRamq9HQacZLXwvUP29wa+ap
 6/DdLbqBQBWiTuiDu5NF9Vd/h7LCn2T5NWQvYTC6Fm77LdSyhwhcjPpy+vOdI0OiXxdk
 i8pDNMwbhFLzo986KCoAH6WBsk0ui3EVNdE8P4v4GgBDZTwe6xojL5wcZfXPJXOilIo6 cA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxd5tdxfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Oct 2022 10:29:25 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2948B3Y0001132;
        Tue, 4 Oct 2022 10:29:24 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc049npv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Oct 2022 10:29:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iP/1zzMjrJt/9amE99BAiBj/Tt4jsGHP1XYtxcPpX/lT0dhOlsaG4WsQeyv0Nk7ZQFwDA4iw/c6IBqq9IHLX/8oIvRg2spzh5KpyaiPZR+wbiooeptECyfF7ZU3WciIA1CRuMT1c4+zyVt2CWIAd5SrYpdIakH4SHH7IbzovwWSx0vp72JfOo/51C7TXJ8x4fCLH9Zx1yCsvTF1pYH7JSdqdVQ08Nsi3BtStaHyu0+9DLAdy2+YeZW86bWZpk/H7Mp9v5d3G3AsGTG21hyFyceQ1vpegq2KnQvNjQdkMWdZ2oHfchX05oIxcOTlMcT3rygOM9JcgqH/RX3n7BSMUug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2mokfh3arWwydhT4w/g/V01JPln7Yp5DBEwFLu4f3UY=;
 b=dTDX2fWcknNq4pxmFvUjS69toH7HuvAmGy761yMdJXfM3avj8sOYCjiLzU3FwP3/Y0/7eFLcgv6Oz0Q8b1awDGKBSSYint1QJEBD6Cd4pI3DjQ2i1/QJVGKJKBaz5kyHJxLtz1yFt0hTBIBGNrC4H08e9vEKd1MLk0U511dI1Rz2ALdUvxphVESOLpx847UEzpf5MfGLsOrY/SsLTbTxfbIgJPzEuPhhfaHmT0vqRqvV4KawwCLV7DZiRorZ30Dk+k04REeeKOfG3iA1Fc+P9PAsvNpr/TGhbDr1/c43npt8KG4e26ZBReApkSFW0ehqvHWt3AFd9oJb8Thxk2LqIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2mokfh3arWwydhT4w/g/V01JPln7Yp5DBEwFLu4f3UY=;
 b=J2zUw9RknmTBcabsSxUxQA85r3Lcm2mScC0kjNYvli4k1jMSF7VaH74stPBWyv6ZxVY5loqAojfHGl13vpizZc+eH41+LhKU9jvnat+YN0brXIdsFtNFmlFGWEioIMkN/BePRpppk9F0HdVkm21yxSwP7g1lhwljmlJ6zSrXrCQ=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5184.namprd10.prod.outlook.com (2603:10b6:5:38e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Tue, 4 Oct
 2022 10:29:22 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%8]) with mapi id 15.20.5676.031; Tue, 4 Oct 2022
 10:29:22 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 08/11] xfs: move incore structures out of xfs_da_format.h
Date:   Tue,  4 Oct 2022 15:58:20 +0530
Message-Id: <20221004102823.1486946-9-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221004102823.1486946-1-chandan.babu@oracle.com>
References: <20221004102823.1486946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0127.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b6::9) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5184:EE_
X-MS-Office365-Filtering-Correlation-Id: 914d8622-054b-40fe-9dd2-08daa5f34da3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 85GSCzOVxoeXVL94zWVr0tUJqrOsEjugzNQ3ILQ/tBFnUN8cPQ4uSiQpVbfaDdmKLN4X3vPdzM3wAfXKEWmkCnedXmoVp1cVvi/raCHGDGLiy5qfONl7LuTjdBZ38en4eGr8kMVGrI0zCJNi/P9txkCBZppQBN/CS927P30aGHlExXd3yEa82VaQ7DgB1MCDWGUyad6S+rXz61A8verMMiD51UxZMh3QjLM8I4Ge5/G/a0fM2iDYBJj9Hg/SheDNAjY+duzy+IKQUWkRB1ThvSUU1RT5VbL9jqrLl2YuA+m/RsNWk8aq76bRSPGkV7M+8rUNGoPvNNZOs73aX3HR430Sv0+bRihTT9KWcx/HMIvWTfCtrE+d64da1ZHT+3yYKV3yMipi8wujvlKQcnxNnXjwni6ph8PYe2OWu52IbGYpRy3UPYa9ndQ6BCVOrcnuzOG+kd8q+qNBca7XYrKBJxPdan1JsQtfuNOphcWcs3FNMe8ir5sKjbx0wuzfCaKLWf9Viz1pZBKmqIiqtaAhy4HvD5/BQh0dwpr2flibYAJmH34eClEOXvo7ISw7vKVi8a+Be8Zsq7RnM2WUwSvS0/2meQk1FF9FT2jJTqMr6imhlnMkumC50M4cpTJev8kWYm8hhi6MlhSkIVyb5qMIsUABtWJk3HIktSoFVA6j99sYsGwpz9Q9F4XINITTgztl23U/HiUuVclNtK4p3S6jgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(39860400002)(346002)(136003)(451199015)(83380400001)(38100700002)(86362001)(186003)(41300700001)(8936002)(5660300002)(316002)(6916009)(8676002)(66946007)(66556008)(66476007)(4326008)(26005)(6512007)(6506007)(2616005)(1076003)(2906002)(6486002)(478600001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xv2xEK0EPiRjls8meJ8Eknyk5O4DgG0tA0lGjuUvkXpCZ6WlaSQ2uBv7KW5p?=
 =?us-ascii?Q?tvQQDb6T36riaqFTc8jPuATqsutX2yMxVJ8zIGkMqEXJWFy4XdPlt6KV6tI7?=
 =?us-ascii?Q?f1Ag1LTL+/kUuvoKpUxlJCvy53ncSII8HKQoyyoDo09yUI7eqjYFk/04MvHN?=
 =?us-ascii?Q?LYyh7DyTOzcNOJYQ4ERAQU9bD0xR9lao/UUPcfhVq0M4O+gWFBquMUdHiSSI?=
 =?us-ascii?Q?20uouAcjGz0eCSHzKZzToQZCbau+KKgZF8lrBQ3wXmHxFlQxo+Mm6UN3kZa2?=
 =?us-ascii?Q?nUre2XaLkzS4mlib36umzaphgO+Dad0VLS1o4ndOZCa5RufCLTF68F7dEXpC?=
 =?us-ascii?Q?sWehdbHMo+Ji2juZLyr3PnMkjrSthrnhnwaPx57UMyczR/Ur/l0SmxfhX6zj?=
 =?us-ascii?Q?Fc7P6os/jWENcN0Z4nlWuoQ5dbb221J02Iw+rgtBoyeohRDE8otaujr35O2l?=
 =?us-ascii?Q?4bw3sgO57zv//avQYPOCWxEby453gwH2ShogWM7UERMn3m9V59u+Mmh++mCV?=
 =?us-ascii?Q?l1KnB3/VvGvJnyWbcwrwf6dwKygn6Ng6HuRRLS7BCRYTEFyNB9lwFIEYX9RE?=
 =?us-ascii?Q?I2d7OlpOywk/WVJfwFFXLz6LUs5BT7QiVAaa2jUCKAOe/ffaDXOEUs8OcZOV?=
 =?us-ascii?Q?3i2lNrf9Hcr1KSGaF+buto+kmj2J59xsvmrh/P8uWRx6okRGulg8ly17C5Cy?=
 =?us-ascii?Q?rEiXbj9vWU8ED3Jp2USDzS6sJv0BHss7F0XfJWWCqX3D1KuPkcqv1GQgfhpO?=
 =?us-ascii?Q?heoN8bYeHAiBoqdu6UTpG8os/JiCqOTvAunCx4zHI/oyOckgDixyv/4/wvMQ?=
 =?us-ascii?Q?PaOq7OpOTVYN2LKagNJYFoBez34SXd85riMy9Y1pWf6+Mh1Uhgs6skoJYI24?=
 =?us-ascii?Q?XruGgfKzIcSXYXXGXDXnS8bm28u9nadXYMAHsJ+S7aCGIeDssuM28cbzB/qR?=
 =?us-ascii?Q?PwGQRTE7ZC9WdQ8O6ipbddV4syA69KrX9fwvsAv5My4g18SkbJVTYFWf3UDV?=
 =?us-ascii?Q?JpjkFWmfMxsd7Iw6mr2KP3BUsorkRQQq02cqfMn/Y3BUollkGtOhp8Dgcn4E?=
 =?us-ascii?Q?OaHJkD9j7BpCHiJ+X6ICZDEh56qcEq0y8ckpSCYYxHcv5M5+fPgKytxrbdS7?=
 =?us-ascii?Q?hWgItxjfqDuv4W2/BUR7oZArGJa8wMwLpjpOQzWYjZLEvjPtyFDCcbtILNdf?=
 =?us-ascii?Q?sjteStzLkZfNIPsINDdDPQm2oJfkzulOgLnDzD7+Iu0ML8apC6s12fSlayvd?=
 =?us-ascii?Q?sNXZ379EdqeENem7XUvfvYfhVzba/Mc3+bf7M/aYZiuktQoCOwOzYkHmQtx2?=
 =?us-ascii?Q?Q9WvJ8ffQKeJIQNhDc+lhicrA6VuE9HDGQfi6MxapINCNvzSNsAsE9esy05A?=
 =?us-ascii?Q?Fqo6jkz5JU3amiKkm8A8PZMnH7AGLKUWTa+fB+t0F4+aWp+M2SGepDdWEanR?=
 =?us-ascii?Q?Zu5PAoFj+v/veeDzYY++/33FNQBezRxxsBJLOovGB5fXHnGN9SHdGO3CpS8c?=
 =?us-ascii?Q?M6JQEs4Tj4p7AJP+fsLyndGTprt2lyxg5uvgIM8OJoyGCZa1y1NfbtzCtjBM?=
 =?us-ascii?Q?87uypP/OO50T/4fUeGX48pNC4w+gKMCDJMsl61u7l6Yg03vXRs/fBO7BEVZD?=
 =?us-ascii?Q?tA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 914d8622-054b-40fe-9dd2-08daa5f34da3
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 10:29:22.6269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kViSjZGABxqajqqllhEvwQ6JZjlLLCPSjoEtnUFT8kV2zHi4Js2+HdcIUPWh1mX2p1B05gcPSNekG+qX1XbN1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5184
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_03,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210040068
X-Proofpoint-ORIG-GUID: gTEDTAC_mlN5dy2FRh-Sf9WO7c0SZ0q5
X-Proofpoint-GUID: gTEDTAC_mlN5dy2FRh-Sf9WO7c0SZ0q5
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit a39f089a25e75c3d17b955d8eb8bc781f23364f3 upstream.

Move the abstract in-memory version of various btree block headers
out of xfs_da_format.h as they aren't on-disk formats.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.h | 23 ++++++++++++++
 fs/xfs/libxfs/xfs_da_btree.h  | 13 ++++++++
 fs/xfs/libxfs/xfs_da_format.c |  1 +
 fs/xfs/libxfs/xfs_da_format.h | 57 -----------------------------------
 fs/xfs/libxfs/xfs_dir2.h      |  2 ++
 fs/xfs/libxfs/xfs_dir2_priv.h | 19 ++++++++++++
 6 files changed, 58 insertions(+), 57 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index 7b74e18becff..23dd84200e09 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -16,6 +16,29 @@ struct xfs_da_state_blk;
 struct xfs_inode;
 struct xfs_trans;
 
+/*
+ * Incore version of the attribute leaf header.
+ */
+struct xfs_attr3_icleaf_hdr {
+	uint32_t	forw;
+	uint32_t	back;
+	uint16_t	magic;
+	uint16_t	count;
+	uint16_t	usedbytes;
+	/*
+	 * Firstused is 32-bit here instead of 16-bit like the on-disk variant
+	 * to support maximum fsb size of 64k without overflow issues throughout
+	 * the attr code. Instead, the overflow condition is handled on
+	 * conversion to/from disk.
+	 */
+	uint32_t	firstused;
+	__u8		holes;
+	struct {
+		uint16_t	base;
+		uint16_t	size;
+	} freemap[XFS_ATTR_LEAF_MAPSIZE];
+};
+
 /*
  * Used to keep a list of "remote value" extents when unlinking an inode.
  */
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index eebbc66f4c05..588e4674e931 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -126,6 +126,19 @@ typedef struct xfs_da_state {
 						/* for dirv2 extrablk is data */
 } xfs_da_state_t;
 
+/*
+ * In-core version of the node header to abstract the differences in the v2 and
+ * v3 disk format of the headers. Callers need to convert to/from disk format as
+ * appropriate.
+ */
+struct xfs_da3_icnode_hdr {
+	uint32_t		forw;
+	uint32_t		back;
+	uint16_t		magic;
+	uint16_t		count;
+	uint16_t		level;
+};
+
 /*
  * Utility macros to aid in logging changed structure fields.
  */
diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index b1ae572496b6..31bb250c1899 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -13,6 +13,7 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
 
 /*
  * Shortform directory ops
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index cda10902df1e..222ee48da5e8 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -93,19 +93,6 @@ struct xfs_da3_intnode {
 	struct xfs_da_node_entry __btree[];
 };
 
-/*
- * In-core version of the node header to abstract the differences in the v2 and
- * v3 disk format of the headers. Callers need to convert to/from disk format as
- * appropriate.
- */
-struct xfs_da3_icnode_hdr {
-	uint32_t	forw;
-	uint32_t	back;
-	uint16_t	magic;
-	uint16_t	count;
-	uint16_t	level;
-};
-
 /*
  * Directory version 2.
  *
@@ -434,14 +421,6 @@ struct xfs_dir3_leaf_hdr {
 	__be32			pad;		/* 64 bit alignment */
 };
 
-struct xfs_dir3_icleaf_hdr {
-	uint32_t		forw;
-	uint32_t		back;
-	uint16_t		magic;
-	uint16_t		count;
-	uint16_t		stale;
-};
-
 /*
  * Leaf block entry.
  */
@@ -520,19 +499,6 @@ struct xfs_dir3_free {
 
 #define XFS_DIR3_FREE_CRC_OFF  offsetof(struct xfs_dir3_free, hdr.hdr.crc)
 
-/*
- * In core version of the free block header, abstracted away from on-disk format
- * differences. Use this in the code, and convert to/from the disk version using
- * xfs_dir3_free_hdr_from_disk/xfs_dir3_free_hdr_to_disk.
- */
-struct xfs_dir3_icfree_hdr {
-	uint32_t	magic;
-	uint32_t	firstdb;
-	uint32_t	nvalid;
-	uint32_t	nused;
-
-};
-
 /*
  * Single block format.
  *
@@ -709,29 +675,6 @@ struct xfs_attr3_leafblock {
 	 */
 };
 
-/*
- * incore, neutral version of the attribute leaf header
- */
-struct xfs_attr3_icleaf_hdr {
-	uint32_t	forw;
-	uint32_t	back;
-	uint16_t	magic;
-	uint16_t	count;
-	uint16_t	usedbytes;
-	/*
-	 * firstused is 32-bit here instead of 16-bit like the on-disk variant
-	 * to support maximum fsb size of 64k without overflow issues throughout
-	 * the attr code. Instead, the overflow condition is handled on
-	 * conversion to/from disk.
-	 */
-	uint32_t	firstused;
-	__u8		holes;
-	struct {
-		uint16_t	base;
-		uint16_t	size;
-	} freemap[XFS_ATTR_LEAF_MAPSIZE];
-};
-
 /*
  * Special value to represent fs block size in the leaf header firstused field.
  * Only used when block size overflows the 2-bytes available on disk.
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index f54244779492..e170792c0acc 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -18,6 +18,8 @@ struct xfs_dir2_sf_entry;
 struct xfs_dir2_data_hdr;
 struct xfs_dir2_data_entry;
 struct xfs_dir2_data_unused;
+struct xfs_dir3_icfree_hdr;
+struct xfs_dir3_icleaf_hdr;
 
 extern struct xfs_name	xfs_name_dotdot;
 
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 59f9fb2241a5..d2eaea663e7f 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -8,6 +8,25 @@
 
 struct dir_context;
 
+/*
+ * In-core version of the leaf and free block headers to abstract the
+ * differences in the v2 and v3 disk format of the headers.
+ */
+struct xfs_dir3_icleaf_hdr {
+	uint32_t		forw;
+	uint32_t		back;
+	uint16_t		magic;
+	uint16_t		count;
+	uint16_t		stale;
+};
+
+struct xfs_dir3_icfree_hdr {
+	uint32_t		magic;
+	uint32_t		firstdb;
+	uint32_t		nvalid;
+	uint32_t		nused;
+};
+
 /* xfs_dir2.c */
 extern int xfs_dir2_grow_inode(struct xfs_da_args *args, int space,
 				xfs_dir2_db_t *dbp);
-- 
2.35.1

