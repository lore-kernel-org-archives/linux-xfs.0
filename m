Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 330B1C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 21:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbiKJVFq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbiKJVFo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 16:05:44 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E864AF25
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 13:05:43 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAL0bX3006962
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=h/CLQBEMXu6DjOvpEu73/qh0MAXZ/7YUg42BgGuDNm0=;
 b=3G6y0Lzzo+6WBDI6BU6WSlb16d3c/Q+4Zmpw4nX2rqftpYhLTqoy2yNvlwg4r2D6gdrt
 QYrO7N6gnq2Il+4YtZXmLT6KfjIZPdH/v+5Mp5hQyXcMmrZcpy0p54LNn8WqcvMnIVZQ
 y1sClRIvNmxnC6L+4MvY5ZHluAnLGK2uk0s/19Yjbp6Nc4pp/KQrF3OFkW8fkjgQaS8M
 YEp7azupXjR26tDAs2fzRt9WU7sMkB+uxC0iWxIMwWjF9N+YpCLjv9TFjNivcEpNnGn2
 Zsju7LWOjeaXhqeUoTN3p1bHq3NPsjiqRuo0Ei9jRf22Jn26fWTQtqBs5UQcqcitVwHq hw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks8u5r139-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:41 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAKZ6DW009811
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:39 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcq5hatw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CPNJO6+p/JuXzYzZaUO4efgi9vIHjpXUqS/kSKuUQ3PaGnBGDq0V8p+MN9J3nbANcJBw1edTUVsxR+T/PL/QcFNbp8WNbKgj8tyMKj/GTSmxA27VUHT7vCaM9h/cz5eGQ6MmvOShUmFqNI7elJnZcidSiU63r3gIPBhEzIcfUCa4XVheqDWtOXl9LFdUuGVBuuKcyFzfgf5Cb05xtWgLnXNSJyPIfAsaRTdkDcvlHvbONiHpz5MxU7PsLkMluIzRP6rPYrERWcNmCYmSTIxmEwhKWEl4h9mnYIq66X+siRoZEWsSclzIwJyF51xDd9AG1pgnC4SXp2DvRhE2Jif02Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h/CLQBEMXu6DjOvpEu73/qh0MAXZ/7YUg42BgGuDNm0=;
 b=CfUtu+y1nYO/9kmkLyaG7zyHBj5uZSovQfvNj2i7gIS3zUNIQRvzwq27CcHZ80ZsUieLDboCOFHmVu188kDgRTO8iP4t8O+q9Sxj+LYLUA+/30py4KkjLslv4SyPTza0Oaew7Z7VRXY0ugPDrEpYpzgQeZS5gl+QdBCOGHzK1SGZQcNJMf9VPBWeZb6VJzbuytTWe/obGZJs9NnjCqrTHqD/eig8XWAtb2TxWjpq0NK2NJoEdsnSM1Pf79MWE+PRewWDZfa4zkConsCyQP210kGhUjGMf5Ce52HKg/ghZ2NmJbfhCD6gNvwtOkrm0xTUrYqWBn2p6+gvXjIsqB1cxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h/CLQBEMXu6DjOvpEu73/qh0MAXZ/7YUg42BgGuDNm0=;
 b=sRgf8+vRsMrtDAoIGxVDhZOc4RVMn6eZSWoWtf7Vph778Jagxoey93qmuiRZOk8WUkEv10lPuAwn3dkrS0obknlwDFLT2yBGPoS8XZItZYu2OFMfq0oTc1umHwegCD/o6HwTQYgtYWShvzevI4/KX4uHViQT4Z7aL0wuHPk8QEs=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO6PR10MB5553.namprd10.prod.outlook.com (2603:10b6:303:140::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 21:05:37 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 21:05:36 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 05/25] xfsprogs: get directory offset when removing directory name
Date:   Thu, 10 Nov 2022 14:05:07 -0700
Message-Id: <20221110210527.56628-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110210527.56628-1-allison.henderson@oracle.com>
References: <20221110210527.56628-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0031.namprd08.prod.outlook.com
 (2603:10b6:a03:100::44) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|CO6PR10MB5553:EE_
X-MS-Office365-Filtering-Correlation-Id: a67d0379-7461-40d5-3464-08dac35f5098
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6ACjK9g0iDn3R8WBwWArR3sV3VS+jb3hww86M3325K1+o2aKzqOKpelpb6Uvo3JutsAJXu3x2PZRElCo1glbG90EvAMsRGsYJCy6E0kPJcEf42AGEQGM8vGY2kjwENFVyC89af/rZmk4s6wM7HqTGX0q/4KGs3/KwqkR+isK07H48otTuaHIPcohSCNW0twQ2T4Afegm7Qr4VnxqoF1wYT9zJ7JCZUq3/2AqzbI94y44PlZTe7NZngkEU5a3igs0o0H0oxcj4GOWBqturfYw0PGdJOd6D3lH4Q0Wosj0+/sDGk7su0Jr3x9TM/v/hbLa+riDLV0IqGJYRuoywVZVWP85IQTVDLgjo+7CXWUOKC4oMZ8PJVrVdRxy4N1tUcFBBVT1iRZqmh6nHKCJ8qIuU4JEq1EKp/qMGSwv2mOzg567LUoUvJ9eAjq1KV7glp6h223SNOmxZ9YTqzwVeT4ZxEOhWq+3bz3t06d/bFTchgZQMxfJmZW2AJBFhKMTN8LtFvnQNUntHx3XfMenfo+xS7mDk6Nyf8+II1vBOvAQ5d+l7ZVLltd9I3CzGqljWm/Uvf58MnIi7q2aR4gZx/u3jIRrphxutTTkxnKhcrFbIz+iORa211ME9ZP4458zUzflCRTBrpsbaJzNUwYARaBGYvaPND0pKLXCO1PiB1rzDSL7jC5jvxUkVVX969i9YDDEcW8d/SObLg/r77J5fyJ4gQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(366004)(39860400002)(346002)(376002)(451199015)(8676002)(6506007)(66556008)(66476007)(316002)(66946007)(2616005)(186003)(1076003)(6916009)(5660300002)(2906002)(478600001)(86362001)(36756003)(6486002)(41300700001)(26005)(6512007)(9686003)(8936002)(83380400001)(38100700002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lEbtphV76nmA3pGy+gS5Npf6cmrrTc3el7YcUdUFCdheJkPgZQXyJ9g2C3Mk?=
 =?us-ascii?Q?yGCYesYR5RNpHl9fbsug5FbXTa3jC8LLlw96FXMMQ8m2nmoXBoqNnW3eZJkM?=
 =?us-ascii?Q?s7gFyFHOs/tLkWPItbVTqDb2zqtiu3e8z632G/gTxPGeOGSJQklexs8lRt5T?=
 =?us-ascii?Q?KWok6zZQP3fj8PfACkb8UFCtKXbFTl1FoP0jACzFKqGokVKeClMn0ZEidtiA?=
 =?us-ascii?Q?Fhv6NoSW1/LhsvsCJ4bs+AYycLFeeWnZrFi+MxCoApYRW+2DYdl8yH3NuIHC?=
 =?us-ascii?Q?55TjzyIzSoGamxYa1A06gOkswTiTWOiHcw+A4A9W1RiQDjhT7g5bEnCIxWQ9?=
 =?us-ascii?Q?dDhWYPTRwiqEX1itvO6x4G/SFzsDiFKbIGIMYlvzfXYIgrPVqxKDHcOog+kG?=
 =?us-ascii?Q?WbbIbYXpKwWSROgyJLM8b01ujEffF06GSF3zxKRzvvBMNvYZ5aD4Ph2Wttvk?=
 =?us-ascii?Q?NI6bIG8J9kZDom4O6Fn8AB7zCtqDaA96WR8rfxc5lCAdRbpViLHkL5aNYwmK?=
 =?us-ascii?Q?PqN9hlSBXIItQJnZKG3Nv52lgy3EW3gQO+HQk0r9P2HbqetUoat5s+p0s3tX?=
 =?us-ascii?Q?xnAxTNnqZnw3r3Vb5hPyf3qYNLE5qwaxuLo4ChH1ZNBPFYTHva8bryGbWQOd?=
 =?us-ascii?Q?hpQkWzhPCUyYA/BUwMnd0u5oBc35//w1LLtu4eEXmTlLBsEG7dek1F8GgRbc?=
 =?us-ascii?Q?nhh6sq8AIwP2VBxH9DGxnOKr3BKjLHrxKtsWkcxaYoQe/uf9FxUkxQUg/aZG?=
 =?us-ascii?Q?KAOOCWGtdK4kmmAZzX+EnTuGkg1QLhqTssnChAfK3YH+oFDuL2kYyywz5AwY?=
 =?us-ascii?Q?GjbxuONhfDVT5SVXjt2qQU5bAZFwp/onpnVy23nXKseIpmoVl5VB7a2Dhi2k?=
 =?us-ascii?Q?zbfkAKBA/CACfWGKvxWHC7oFyLQixNP2n50MTC9RZ2T7LQVwFPAEKapjvORX?=
 =?us-ascii?Q?74ACHnBOYkAEckmPnoKhJvjfBaG4gbi4NswTIUk2nlxClmpzbWqXF8Ji6sXh?=
 =?us-ascii?Q?8YI+MSBe32hbjiyTUT5RZBq1oCOmYsBbXPHVGy5vFkx9rZD7ukUKpQrbSSE4?=
 =?us-ascii?Q?PwWaybntKGYAgTRHyht3Bg79ybSMuNePmrpKua/diJZEP4SIdw1+GABcAal9?=
 =?us-ascii?Q?sHT1k6ZCOf33oR0J+m41i/nrA/4LP+Y/+slXZfaltk1u2qAMLWP6svCBZcdp?=
 =?us-ascii?Q?Mi3YnBBOwoFaMDlit4/g/HR+mJMqTG2Xj7oLmlSvjNc871Lsy9TirUcuAhj2?=
 =?us-ascii?Q?ulhdCoQz4Wkcu17P68o5TDT5Sipom824FX7TaDtziMySnNICZXEME5BNvTCg?=
 =?us-ascii?Q?ufzypeEfoKRl1wzSAY1/6gSwM4367U1nvwrAU2EekLVgXpaivpB95UKpEkjE?=
 =?us-ascii?Q?t99mUcq2I4lpZv04sedmd92G5tN3f744bC9ScSe7gQ7PuamIPEQu3bH/tGzf?=
 =?us-ascii?Q?kbo0eP9SVOmK1TksizkjB7U0y25REr8YsXMdKhbuLZFRdVqJmfMQcWP57EDX?=
 =?us-ascii?Q?fzoYtY8yN6Mn0Qp25EfOMjMrSDROK2OhA9keztCei1KsNqYwxBmClvbKqnUs?=
 =?us-ascii?Q?mcD/yEZrLGBBlgGmmG+4U4N5+QIsCFg4N+4Nr/D1zEXb3Q9ZnhRW2R7N0Ae4?=
 =?us-ascii?Q?WA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a67d0379-7461-40d5-3464-08dac35f5098
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 21:05:36.8745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nWMMbTZeE6SQ+2RxqXe57JPep02k9bC+h4maulMyCp+yF9ycGbwgEbE/m/49u8ZuzhZgYdMd0lRTgVk9qc2uV7Zm2m6blAG8SOnCF2wcXm0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5553
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100148
X-Proofpoint-ORIG-GUID: 08qw6tg9i7N52btnI_wwfMZcCnAB2xNk
X-Proofpoint-GUID: 08qw6tg9i7N52btnI_wwfMZcCnAB2xNk
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Return the directory offset information when removing an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_remove.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 libxfs/xfs_dir2.c       | 6 +++++-
 libxfs/xfs_dir2.h       | 3 ++-
 libxfs/xfs_dir2_block.c | 4 ++--
 libxfs/xfs_dir2_leaf.c  | 5 +++--
 libxfs/xfs_dir2_node.c  | 5 +++--
 libxfs/xfs_dir2_sf.c    | 2 ++
 6 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 93347cf24660..01cc157e33b7 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -435,7 +435,8 @@ xfs_dir_removename(
 	struct xfs_inode	*dp,
 	struct xfs_name		*name,
 	xfs_ino_t		ino,
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -480,6 +481,9 @@ xfs_dir_removename(
 	else
 		rval = xfs_dir2_node_removename(args);
 out_free:
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index 4d1c2570b833..c581d3b19bc6 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -46,7 +46,8 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *ci_name);
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot,
+				xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
 				xfs_extlen_t tot);
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index fb5b41792498..43b9c18ff6be 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -807,9 +807,9 @@ xfs_dir2_block_removename(
 	/*
 	 * Point to the data entry using the leaf entry.
 	 */
+	args->offset = be32_to_cpu(blp[ent].address);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-			xfs_dir2_dataptr_to_off(args->geo,
-						be32_to_cpu(blp[ent].address)));
+			xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	/*
 	 * Mark the data entry's space free.
 	 */
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index fd9c48d0879e..3a7e09756dde 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -1379,9 +1379,10 @@ xfs_dir2_leaf_removename(
 	 * Point to the leaf entry, use that to point to the data entry.
 	 */
 	lep = &leafhdr.ents[index];
-	db = xfs_dir2_dataptr_to_db(geo, be32_to_cpu(lep->address));
+	args->offset = be32_to_cpu(lep->address);
+	db = xfs_dir2_dataptr_to_db(args->geo, args->offset);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-		xfs_dir2_dataptr_to_off(geo, be32_to_cpu(lep->address)));
+		xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	needscan = needlog = 0;
 	oldbest = be16_to_cpu(bf[0].length);
 	ltp = xfs_dir2_leaf_tail_p(geo, leaf);
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index 45fb218f0571..ac6a70896adb 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -1293,9 +1293,10 @@ xfs_dir2_leafn_remove(
 	/*
 	 * Extract the data block and offset from the entry.
 	 */
-	db = xfs_dir2_dataptr_to_db(geo, be32_to_cpu(lep->address));
+	args->offset = be32_to_cpu(lep->address);
+	db = xfs_dir2_dataptr_to_db(args->geo, args->offset);
 	ASSERT(dblk->blkno == db);
-	off = xfs_dir2_dataptr_to_off(geo, be32_to_cpu(lep->address));
+	off = xfs_dir2_dataptr_to_off(args->geo, args->offset);
 	ASSERT(dblk->index == off);
 
 	/*
diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c
index 56ee4ff4ebe3..b2b37821492f 100644
--- a/libxfs/xfs_dir2_sf.c
+++ b/libxfs/xfs_dir2_sf.c
@@ -971,6 +971,8 @@ xfs_dir2_sf_removename(
 								XFS_CMP_EXACT) {
 			ASSERT(xfs_dir2_sf_get_ino(mp, sfp, sfep) ==
 			       args->inumber);
+			args->offset = xfs_dir2_byte_to_dataptr(
+						xfs_dir2_sf_get_offset(sfep));
 			break;
 		}
 	}
-- 
2.25.1

