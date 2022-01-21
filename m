Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0DB3C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:20:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbiAUFUE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:20:04 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:2680 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233242AbiAUFUD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:20:03 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L045wO018299;
        Fri, 21 Jan 2022 05:19:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=yTqoNYUJRp3MWWVOWJQAoBZGef4ZwxEz5QWcDu4UXNo=;
 b=OIGUFe8QT3F0dCM34db9dSuFOY6/cgamHaRm/nqN87Wh+YL2uj+5eSAg/7X5S7spVa/I
 L4WZdkXsmrNAcb2CAbuzBJ02iYD6bVWI9o9iBgs6csWOTGJMIkwxDQ2WxjaPixOYaHMq
 tnDWc7TeitFa12rcyCKBmpwZHNhI47LjzqmtEAsA/Y+rC+QwSBtUrYSshxS5GEz5da5X
 GmiG/IlMxREAS55WyJ9GPta6rZpNQ0BtNoGMIUkpTcpKWbkrFxNb6rjDBjPLbFTlqfcI
 zvLXRe9ReUA7mqA7w61+96g3kz8deT6hZG1nZ/99AdycPMRXHckt5oYeruak/7anr7Pr 3Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhycgcqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:19:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5H26s018998;
        Fri, 21 Jan 2022 05:19:57 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by aserp3030.oracle.com with ESMTP id 3dqj05h2yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:19:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hntQeF8dNE11rezZEjuoFhRzRcuxfnucs3o0Mi+9KeC7c80qN9LvE8lXl4BnSd11WKtxYg0jiBC4D1vHVFmffosSsSswu1fr/717Vb2KsDTTm+REUkFGY2Bajd4Pom+sC3cQc2VosBy00AXx8usvlFeaZw0+hwmJcJ98GkEEnAJC3wYeVaB5VAChs2YxJkkO7DF6Ql1mjzSZ7lxtpRy+DC5dJ7MhCbrTESEId3zlBcjsqaC43LIyGmpohPy4G1mdoMcAaOqqvHn7NqPcVDq0Jxz0Vls2MaGEi+8KD7N5bkmYTfP+igviQzTglOd4ui5FrcRX3kyL6gk+JUGzX+PucQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yTqoNYUJRp3MWWVOWJQAoBZGef4ZwxEz5QWcDu4UXNo=;
 b=gPQjozcXyJjBSVEHtFb5nNK2BKTWq1kihcv15NuBvRF+b+NRNqWOYdpyEJUSNJ0v5/lBRo6f2sg0MrHIUyCpDwNJEBCoNCrrimFYlluhKj9Cqx5IDSbeQ3yfC6GHMkZFUyevxObTbvuTGiBfq1HoVsgBknGnGxaJ6It8BJjdagnEbCmXwEfuqMWqHQp0O/ECiu5HvzjG9n3EwwOW/+ry++nPQqMmT4d16NI7XF8UtqjQsrNC+pq54f2EXUwp9zSDg/VUNMmGJ40phOVNjeq1PtL5K4Y2oFZ65ho0D6bb0AjlfdoLV5vMs00hO/s/r/vxJjwB2x1TgAAoSO9I8heJTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yTqoNYUJRp3MWWVOWJQAoBZGef4ZwxEz5QWcDu4UXNo=;
 b=PTV3jM8jSWrWRR+y/BszHqHlIl2KuZ23QTZgAiM/0EQFm4s+yMs6siIgvGsJ6qb9x736ho/EN2xWOvpYxe9cQL+q1yKr0xxF6Lz0sBhQMSbVZNQStqy2vZ5Tko2dEE3YQXUD26xKtcaX7ArT2NbqqIj739ekuJ6g4PqLTNJuYSU=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by CY4PR10MB1287.namprd10.prod.outlook.com (2603:10b6:903:2b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Fri, 21 Jan
 2022 05:19:54 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:19:54 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH V5 12/16] xfs: Introduce per-inode 64-bit extent counters
Date:   Fri, 21 Jan 2022 10:48:53 +0530
Message-Id: <20220121051857.221105-13-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121051857.221105-1-chandan.babu@oracle.com>
References: <20220121051857.221105-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0027.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::22) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79fd5145-9cd1-4cbb-a373-08d9dc9da7b7
X-MS-TrafficTypeDiagnostic: CY4PR10MB1287:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB128785098BED6FDD4F28EBE8F65B9@CY4PR10MB1287.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dg3l5Fr3ynUQPfD6YoiyKVRuqBb+zUqXpE0htxKK1KCzMc1qyfxgS8zr28sqsK3BnrHDCjuRrqI5MSVdJduPLHqaXfRzP9v0Xmt0wx3y0o82uJBY6LWsLBkLl2aM4aj6GP9tOv49P3kdIjHuEh9FcR8zguOVREgmdVX3XC2sGy0RogqXbwFxT8OFNiX/yWCe/d7l6YFeG4KBrZMD0MvK0aa5qma1S67AVXNlbnHVk1rohLxXM8p43HhQQy1MknFsek9mWBy/uCx5+rjZC1BgEG09YbkrgSHdAtE0Nmn9W4QZ+0M3/H6UwFOwJbT1rK3N2EAnJWxsBDBnQ8xgWuB6ROO9lz4fQ0KuSCoEBg5NR+XL8NQH8OVOzAWc6ff1ecQAwK4YKY5liFsr9x0P6LH+H/BUKlqwz5dAuCKKgbHAPblBkXcRvoPD015uMZmu2JKfGnRmjslqDyFJAOX8zQCNa34JS+CxYe8wVBNTK4lwP179pilDM1YPdY61VCylqQKP5MbbU0sC0pRaHWO+K0M41z1nWcZ8BIk1dUlF4l4e+rg1W8Vc1NFaCoOP9JM7+Jh0SbXRn3r7a3g29PyOn7lzG6Uok5jlOC/3tqKt8x7eumNQsl/RRxItjuprjtzSQVtOdby6bfjbEGU1BDZhSige0V6V0oDJRTP/og8fb+xKZgrZ9cR7u9HjR1uxFGmYxIxb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(186003)(52116002)(66556008)(26005)(6916009)(2906002)(8676002)(5660300002)(66946007)(2616005)(54906003)(6512007)(1076003)(30864003)(4326008)(38100700002)(83380400001)(66476007)(86362001)(38350700002)(8936002)(6506007)(316002)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Lvyhh4RRO1cg3wnse2B268bPJ98pop+JyGLMKyy1mdmkRNgcq4tWm66RKdRp?=
 =?us-ascii?Q?UjB+zBeYKFZB5NrKwD/3k+sYdNpMryeY46ID0CE8Rh1/sLkyn+Lp5Entvz8M?=
 =?us-ascii?Q?YMR7tnkigy5Xs7LaSv2NG8rgYR2Ij3yWI8llUCfCMotLyXD3YkVQ3vHcIXE7?=
 =?us-ascii?Q?gQK1wS3VSgW6OuG68vCNsNTq0FOSd3gpwieCTJyrwOk9C6D808dm+Nv95asM?=
 =?us-ascii?Q?HYtwv3wJhi+zY9IKOg7jf/syDbcsPpWFTrcT/MyjHwDGbzKq2CrYbIuRyOeR?=
 =?us-ascii?Q?wxIpYGUepMV6NE8X3z3DvIFoxHckdqsMiEnrmh//GM89t8lyvI9Nw24GSCDN?=
 =?us-ascii?Q?kMosAu7r33xjL0Kslon0xkjfRei1/uKJ0U26eWi4PU/cXCvE9Dw7aFqSlfJi?=
 =?us-ascii?Q?vUt+t3+rWuKo91g+xExf3ckSpf+CvhDL/XbtjgshAiamB/HsKxesFzep7WTU?=
 =?us-ascii?Q?oNSVCGNCkr0WBioPojFri3cRubF2/65iD5yA/aTn0C+3zhOhMTeB6KiBbPKZ?=
 =?us-ascii?Q?J9yIXbzhySB7e6SmOErSx9vSAFy2q7/yPe7IP202Rx3DzMAvjqL7AGbP8F0P?=
 =?us-ascii?Q?kK0R2UQnROvI0VjIRXp79agQN+DUPVWgrMWXXdokqQMKxHu6mnsEYb6sbhgv?=
 =?us-ascii?Q?6wfU63gS1S2ovowA9QwJEsN0Njd37sC4cfrszvxAbUfkYKsc41uZoKZPQIAS?=
 =?us-ascii?Q?fi1PUfF8yswIzAFSk2pA5bgDcCPbQJ3CpbBroVLTguHwSaTqUr7stdQSDdgM?=
 =?us-ascii?Q?4dHNf77V68ktNt6pyBO1pst6Wpyj6KlcQECkLblS7cxo5k39YSu6cEg3rBM2?=
 =?us-ascii?Q?b0dceJfbcGIyHL6i8p2vVn7dzldS4XwKo+HWKE4XgOcLY9uoGosH0pyBZInd?=
 =?us-ascii?Q?bb1TuNKc2TG067YDj4FgLpsLCVaRCdz9uLRvd8LD4Kcn2vOgOnKc16w+zvhZ?=
 =?us-ascii?Q?6vGvP++iZ8I+3BTHuiyc0NZHhzGyv5CTqZkT8hiqiQbiKDzbZGNu0+uKqaOB?=
 =?us-ascii?Q?SWbASlU52P15WHrQ4b2l1Tc65vJn2tzaHa6hUk5KdAWKGRPv/+bTUkM6tCZt?=
 =?us-ascii?Q?uq+9a9uYj8vuEBcreUo4gLHxEifhxoTXnsRQLJnECOxcFO/sa511ushLcRK0?=
 =?us-ascii?Q?DB7IdcX1N4AEYj68jna4cN186lzSSO1ybeLU+XNERYtrAJBUbo+kXyXWKJ0k?=
 =?us-ascii?Q?NHnBEWtzQ9CepM0Ea+b3IxhrZWKY6+/jDEbaLKrCmp8DOFh8BNXR0+R57TVE?=
 =?us-ascii?Q?2mrkp2+kB+pRVnTAp4vgpNtxJ5tRiIb4p8mwJCnQ3DHhGXiZvW4StM8Mz4ot?=
 =?us-ascii?Q?h0Ezwc25UHOYieW9FW6GwVJZwghtin6/qj5F1QSWl0j29vK64xzFIidQ2yus?=
 =?us-ascii?Q?p0DN9wEF3PMRiqwOcS6cMsMcp5PZXImAZGvDF/+T6vblI87yyIYcWJHj8dxn?=
 =?us-ascii?Q?7LgztXLSz2CMYxm/OFLzV52YtOKp4RlnrvYceTeKZlCkCJOXTXuNWlcWhw+9?=
 =?us-ascii?Q?gne6D2qjGvEmz5dhtiXj0CLO3XNBQSWMSIC1c4lTHIIzdvdM/gKDSCJSjJLW?=
 =?us-ascii?Q?IbKYTfRbAFps99o53HszLHDllnXHKl2jIiI3b/6JwZc1TZYM+m0rukpEDkiG?=
 =?us-ascii?Q?No6C6fjPr4gcfB7JDmPU/Wk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79fd5145-9cd1-4cbb-a373-08d9dc9da7b7
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:19:54.6498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0dDuaU7WRYBSej3DQZMr5A3qA/dotdMZf4C3gg72V3c0+pH8Oy8015n0UFpEHZzbYktJgteBKQnem4xyNv+fIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1287
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210037
X-Proofpoint-ORIG-GUID: z6knVUF9TmXssIGvlnYcUSPfThI_Gnsu
X-Proofpoint-GUID: z6knVUF9TmXssIGvlnYcUSPfThI_Gnsu
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit introduces new fields in the on-disk inode format to support
64-bit data fork extent counters and 32-bit attribute fork extent
counters. The new fields will be used only when an inode has
XFS_DIFLAG2_NREXT64 flag set. Otherwise we continue to use the regular 32-bit
data fork extent counters and 16-bit attribute fork extent counters.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Suggested-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h      | 22 +++++++--
 fs/xfs/libxfs/xfs_inode_buf.c   | 49 ++++++++++++++++++--
 fs/xfs/libxfs/xfs_inode_fork.h  |  6 +++
 fs/xfs/libxfs/xfs_log_format.h  | 22 +++++++--
 fs/xfs/xfs_inode_item.c         | 23 ++++++++--
 fs/xfs/xfs_inode_item_recover.c | 79 ++++++++++++++++++++++++++++-----
 6 files changed, 174 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index d3dfd45c39e0..df1d6ec39c45 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -792,16 +792,30 @@ struct xfs_dinode {
 	__be32		di_nlink;	/* number of links to file */
 	__be16		di_projid_lo;	/* lower part of owner's project id */
 	__be16		di_projid_hi;	/* higher part owner's project id */
-	__u8		di_pad[6];	/* unused, zeroed space */
-	__be16		di_flushiter;	/* incremented on flush */
+	union {
+		__be64	di_big_nextents;/* NREXT64 data extents */
+		__u8	di_v3_pad[8];	/* !NREXT64 V3 inode zeroed space */
+		struct {
+			__u8	di_v2_pad[6];	/* V2 inode zeroed space */
+			__be16	di_flushiter;	/* V2 inode incremented on flush */
+		};
+	};
 	xfs_timestamp_t	di_atime;	/* time last accessed */
 	xfs_timestamp_t	di_mtime;	/* time last modified */
 	xfs_timestamp_t	di_ctime;	/* time created/inode modified */
 	__be64		di_size;	/* number of bytes in file */
 	__be64		di_nblocks;	/* # of direct & btree blocks used */
 	__be32		di_extsize;	/* basic/minimum extent size for file */
-	__be32		di_nextents;	/* number of extents in data fork */
-	__be16		di_anextents;	/* number of extents in attribute fork*/
+	union {
+		struct {
+			__be32	di_big_anextents; /* NREXT64 attr extents */
+			__be16	di_nrext64_pad; /* NREXT64 unused, zero */
+		} __packed;
+		struct {
+			__be32	di_nextents;	/* !NREXT64 data extents */
+			__be16	di_anextents;	/* !NREXT64 attr extents */
+		} __packed;
+	};
 	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	__s8		di_aformat;	/* format of attr fork's data */
 	__be32		di_dmevmask;	/* DMIG event mask */
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 34f360a38603..2200526bcee0 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -279,6 +279,25 @@ xfs_inode_to_disk_ts(
 	return ts;
 }
 
+static inline void
+xfs_inode_to_disk_iext_counters(
+	struct xfs_inode	*ip,
+	struct xfs_dinode	*to)
+{
+	if (xfs_inode_has_nrext64(ip)) {
+		to->di_big_nextents = cpu_to_be64(xfs_ifork_nextents(&ip->i_df));
+		to->di_big_anextents = cpu_to_be32(xfs_ifork_nextents(ip->i_afp));
+		/*
+		 * We might be upgrading the inode to use larger extent counters
+		 * than was previously used. Hence zero the unused field.
+		 */
+		to->di_nrext64_pad = cpu_to_be16(0);
+	} else {
+		to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
+		to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
+	}
+}
+
 void
 xfs_inode_to_disk(
 	struct xfs_inode	*ip,
@@ -296,7 +315,6 @@ xfs_inode_to_disk(
 	to->di_projid_lo = cpu_to_be16(ip->i_projid & 0xffff);
 	to->di_projid_hi = cpu_to_be16(ip->i_projid >> 16);
 
-	memset(to->di_pad, 0, sizeof(to->di_pad));
 	to->di_atime = xfs_inode_to_disk_ts(ip, inode->i_atime);
 	to->di_mtime = xfs_inode_to_disk_ts(ip, inode->i_mtime);
 	to->di_ctime = xfs_inode_to_disk_ts(ip, inode->i_ctime);
@@ -307,8 +325,6 @@ xfs_inode_to_disk(
 	to->di_size = cpu_to_be64(ip->i_disk_size);
 	to->di_nblocks = cpu_to_be64(ip->i_nblocks);
 	to->di_extsize = cpu_to_be32(ip->i_extsize);
-	to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
-	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
 	to->di_forkoff = ip->i_forkoff;
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
 	to->di_flags = cpu_to_be16(ip->i_diflags);
@@ -323,11 +339,14 @@ xfs_inode_to_disk(
 		to->di_lsn = cpu_to_be64(lsn);
 		memset(to->di_pad2, 0, sizeof(to->di_pad2));
 		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
-		to->di_flushiter = 0;
+		memset(to->di_v3_pad, 0, sizeof(to->di_v3_pad));
 	} else {
 		to->di_version = 2;
 		to->di_flushiter = cpu_to_be16(ip->i_flushiter);
+		memset(to->di_v2_pad, 0, sizeof(to->di_v2_pad));
 	}
+
+	xfs_inode_to_disk_iext_counters(ip, to);
 }
 
 static xfs_failaddr_t
@@ -397,6 +416,24 @@ xfs_dinode_verify_forkoff(
 	return NULL;
 }
 
+static xfs_failaddr_t
+xfs_dinode_verify_nextents(
+	struct xfs_mount	*mp,
+	struct xfs_dinode	*dip)
+{
+	if (xfs_dinode_has_nrext64(dip)) {
+		if (!xfs_has_nrext64(mp))
+			return __this_address;
+		if (dip->di_nrext64_pad != 0)
+			return __this_address;
+	} else {
+		if (dip->di_version == 3 && dip->di_big_nextents != 0)
+			return __this_address;
+	}
+
+	return NULL;
+}
+
 xfs_failaddr_t
 xfs_dinode_verify(
 	struct xfs_mount	*mp,
@@ -440,6 +477,10 @@ xfs_dinode_verify(
 	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
 		return __this_address;
 
+	fa = xfs_dinode_verify_nextents(mp, dip);
+	if (fa)
+		return fa;
+
 	nextents = xfs_dfork_data_extents(dip);
 	nextents += xfs_dfork_attr_extents(dip);
 	nblocks = be64_to_cpu(dip->di_nblocks);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index e56803436c61..8e6221e32660 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -156,6 +156,9 @@ static inline xfs_extnum_t
 xfs_dfork_data_extents(
 	struct xfs_dinode	*dip)
 {
+	if (xfs_dinode_has_nrext64(dip))
+		return be64_to_cpu(dip->di_big_nextents);
+
 	return be32_to_cpu(dip->di_nextents);
 }
 
@@ -163,6 +166,9 @@ static inline xfs_extnum_t
 xfs_dfork_attr_extents(
 	struct xfs_dinode	*dip)
 {
+	if (xfs_dinode_has_nrext64(dip))
+		return be32_to_cpu(dip->di_big_anextents);
+
 	return be16_to_cpu(dip->di_anextents);
 }
 
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index fd66e70248f7..7f4ebf112a3c 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -388,16 +388,30 @@ struct xfs_log_dinode {
 	uint32_t	di_nlink;	/* number of links to file */
 	uint16_t	di_projid_lo;	/* lower part of owner's project id */
 	uint16_t	di_projid_hi;	/* higher part of owner's project id */
-	uint8_t		di_pad[6];	/* unused, zeroed space */
-	uint16_t	di_flushiter;	/* incremented on flush */
+	union {
+		uint64_t	di_big_nextents;/* NREXT64 data extents */
+		uint8_t		di_v3_pad[8];	/* !NREXT64 V3 inode zeroed space */
+		struct {
+			uint8_t	di_v2_pad[6];	/* V2 inode zeroed space */
+			uint16_t di_flushiter;	/* V2 inode incremented on flush */
+		};
+	};
 	xfs_log_timestamp_t di_atime;	/* time last accessed */
 	xfs_log_timestamp_t di_mtime;	/* time last modified */
 	xfs_log_timestamp_t di_ctime;	/* time created/inode modified */
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
-	uint32_t	di_nextents;	/* number of extents in data fork */
-	uint16_t	di_anextents;	/* number of extents in attribute fork*/
+	union {
+		struct {
+			uint32_t  di_big_anextents; /* NREXT64 attr extents */
+			uint16_t  di_nrext64_pad; /* NREXT64 unused, zero */
+		} __packed;
+		struct {
+			uint32_t  di_nextents;	  /* !NREXT64 data extents */
+			uint16_t  di_anextents;	  /* !NREXT64 attr extents */
+		} __packed;
+	};
 	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	int8_t		di_aformat;	/* format of attr fork's data */
 	uint32_t	di_dmevmask;	/* DMIG event mask */
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 90d8e591baf8..8304ce062e43 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -358,6 +358,21 @@ xfs_copy_dm_fields_to_log_dinode(
 	}
 }
 
+static inline void
+xfs_inode_to_log_dinode_iext_counters(
+	struct xfs_inode	*ip,
+	struct xfs_log_dinode	*to)
+{
+	if (xfs_inode_has_nrext64(ip)) {
+		to->di_big_nextents = xfs_ifork_nextents(&ip->i_df);
+		to->di_big_anextents = xfs_ifork_nextents(ip->i_afp);
+		to->di_nrext64_pad = 0;
+	} else {
+		to->di_nextents = xfs_ifork_nextents(&ip->i_df);
+		to->di_anextents = xfs_ifork_nextents(ip->i_afp);
+	}
+}
+
 static void
 xfs_inode_to_log_dinode(
 	struct xfs_inode	*ip,
@@ -373,7 +388,6 @@ xfs_inode_to_log_dinode(
 	to->di_projid_lo = ip->i_projid & 0xffff;
 	to->di_projid_hi = ip->i_projid >> 16;
 
-	memset(to->di_pad, 0, sizeof(to->di_pad));
 	memset(to->di_pad3, 0, sizeof(to->di_pad3));
 	to->di_atime = xfs_inode_to_log_dinode_ts(ip, inode->i_atime);
 	to->di_mtime = xfs_inode_to_log_dinode_ts(ip, inode->i_mtime);
@@ -385,8 +399,6 @@ xfs_inode_to_log_dinode(
 	to->di_size = ip->i_disk_size;
 	to->di_nblocks = ip->i_nblocks;
 	to->di_extsize = ip->i_extsize;
-	to->di_nextents = xfs_ifork_nextents(&ip->i_df);
-	to->di_anextents = xfs_ifork_nextents(ip->i_afp);
 	to->di_forkoff = ip->i_forkoff;
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
 	to->di_flags = ip->i_diflags;
@@ -406,11 +418,14 @@ xfs_inode_to_log_dinode(
 		to->di_lsn = lsn;
 		memset(to->di_pad2, 0, sizeof(to->di_pad2));
 		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
-		to->di_flushiter = 0;
+		memset(to->di_v3_pad, 0, sizeof(to->di_v3_pad));
 	} else {
 		to->di_version = 2;
 		to->di_flushiter = ip->i_flushiter;
+		memset(to->di_v2_pad, 0, sizeof(to->di_v2_pad));
 	}
+
+	xfs_inode_to_log_dinode_iext_counters(ip, to);
 }
 
 /*
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 767a551816a0..fa3556633ca9 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -148,6 +148,22 @@ static inline bool xfs_log_dinode_has_nrext64(const struct xfs_log_dinode *ld)
 	       (ld->di_flags2 & XFS_DIFLAG2_NREXT64);
 }
 
+static inline void
+xfs_log_dinode_to_disk_iext_counters(
+	struct xfs_log_dinode	*from,
+	struct xfs_dinode	*to)
+{
+	if (xfs_log_dinode_has_nrext64(from)) {
+		to->di_big_nextents = cpu_to_be64(from->di_big_nextents);
+		to->di_big_anextents = cpu_to_be32(from->di_big_anextents);
+		to->di_nrext64_pad = cpu_to_be16(from->di_nrext64_pad);
+	} else {
+		to->di_nextents = cpu_to_be32(from->di_nextents);
+		to->di_anextents = cpu_to_be16(from->di_anextents);
+	}
+
+}
+
 STATIC void
 xfs_log_dinode_to_disk(
 	struct xfs_log_dinode	*from,
@@ -164,7 +180,6 @@ xfs_log_dinode_to_disk(
 	to->di_nlink = cpu_to_be32(from->di_nlink);
 	to->di_projid_lo = cpu_to_be16(from->di_projid_lo);
 	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
-	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
 
 	to->di_atime = xfs_log_dinode_to_disk_ts(from, from->di_atime);
 	to->di_mtime = xfs_log_dinode_to_disk_ts(from, from->di_mtime);
@@ -173,8 +188,6 @@ xfs_log_dinode_to_disk(
 	to->di_size = cpu_to_be64(from->di_size);
 	to->di_nblocks = cpu_to_be64(from->di_nblocks);
 	to->di_extsize = cpu_to_be32(from->di_extsize);
-	to->di_nextents = cpu_to_be32(from->di_nextents);
-	to->di_anextents = cpu_to_be16(from->di_anextents);
 	to->di_forkoff = from->di_forkoff;
 	to->di_aformat = from->di_aformat;
 	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
@@ -192,10 +205,13 @@ xfs_log_dinode_to_disk(
 		to->di_lsn = cpu_to_be64(lsn);
 		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
 		uuid_copy(&to->di_uuid, &from->di_uuid);
-		to->di_flushiter = 0;
+		memcpy(to->di_v3_pad, from->di_v3_pad, sizeof(to->di_v3_pad));
 	} else {
 		to->di_flushiter = cpu_to_be16(from->di_flushiter);
+		memcpy(to->di_v2_pad, from->di_v2_pad, sizeof(to->di_v2_pad));
 	}
+
+	xfs_log_dinode_to_disk_iext_counters(from, to);
 }
 
 STATIC int
@@ -209,6 +225,8 @@ xlog_recover_inode_commit_pass2(
 	struct xfs_mount		*mp = log->l_mp;
 	struct xfs_buf			*bp;
 	struct xfs_dinode		*dip;
+	xfs_extnum_t                    nextents;
+	xfs_aextnum_t                   anextents;
 	int				len;
 	char				*src;
 	char				*dest;
@@ -348,21 +366,60 @@ xlog_recover_inode_commit_pass2(
 			goto out_release;
 		}
 	}
-	if (unlikely(ldip->di_nextents + ldip->di_anextents > ldip->di_nblocks)){
-		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
+
+	if (xfs_log_dinode_has_nrext64(ldip)) {
+		if (!xfs_has_nrext64(mp) || (ldip->di_nrext64_pad != 0)) {
+			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
+				     XFS_ERRLEVEL_LOW, mp, ldip,
+				     sizeof(*ldip));
+			xfs_alert(mp,
+				"%s: Bad inode log record, rec ptr "PTR_FMT", "
+				"dino ptr "PTR_FMT", dino bp "PTR_FMT", "
+				"ino %Ld, xfs_has_nrext64(mp) = %d, "
+				"ldip->di_nrext64_pad = %u",
+				__func__, item, dip, bp, in_f->ilf_ino,
+				xfs_has_nrext64(mp), ldip->di_nrext64_pad);
+			error = -EFSCORRUPTED;
+			goto out_release;
+		}
+	} else {
+		if (ldip->di_version == 3 && ldip->di_big_nextents != 0) {
+			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(6)",
+				     XFS_ERRLEVEL_LOW, mp, ldip,
+				     sizeof(*ldip));
+			xfs_alert(mp,
+				"%s: Bad inode log record, rec ptr "PTR_FMT", "
+				"dino ptr "PTR_FMT", dino bp "PTR_FMT", "
+				"ino %Ld, ldip->di_big_dextcnt = %llu",
+				__func__, item, dip, bp, in_f->ilf_ino,
+				ldip->di_big_nextents);
+			error = -EFSCORRUPTED;
+			goto out_release;
+		}
+	}
+
+	if (xfs_log_dinode_has_nrext64(ldip)) {
+		nextents = ldip->di_big_nextents;
+		anextents = ldip->di_big_anextents;
+	} else {
+		nextents = ldip->di_nextents;
+		anextents = ldip->di_anextents;
+	}
+
+	if (unlikely(nextents + anextents > ldip->di_nblocks)) {
+		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(7)",
 				     XFS_ERRLEVEL_LOW, mp, ldip,
 				     sizeof(*ldip));
 		xfs_alert(mp,
 	"%s: Bad inode log record, rec ptr "PTR_FMT", dino ptr "PTR_FMT", "
-	"dino bp "PTR_FMT", ino %Ld, total extents = %d, nblocks = %Ld",
+	"dino bp "PTR_FMT", ino %Ld, total extents = %llu, nblocks = %Ld",
 			__func__, item, dip, bp, in_f->ilf_ino,
-			ldip->di_nextents + ldip->di_anextents,
-			ldip->di_nblocks);
+			nextents + anextents, ldip->di_nblocks);
 		error = -EFSCORRUPTED;
 		goto out_release;
 	}
 	if (unlikely(ldip->di_forkoff > mp->m_sb.sb_inodesize)) {
-		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(6)",
+		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(8)",
 				     XFS_ERRLEVEL_LOW, mp, ldip,
 				     sizeof(*ldip));
 		xfs_alert(mp,
@@ -374,7 +431,7 @@ xlog_recover_inode_commit_pass2(
 	}
 	isize = xfs_log_dinode_size(mp);
 	if (unlikely(item->ri_buf[1].i_len > isize)) {
-		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(7)",
+		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(9)",
 				     XFS_ERRLEVEL_LOW, mp, ldip,
 				     sizeof(*ldip));
 		xfs_alert(mp,
-- 
2.30.2

