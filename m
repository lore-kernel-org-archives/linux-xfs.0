Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D229C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 10:40:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234275AbiCAKlW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Mar 2022 05:41:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbiCAKlV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Mar 2022 05:41:21 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FF990263
        for <linux-xfs@vger.kernel.org>; Tue,  1 Mar 2022 02:40:39 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2218Ukhe018833;
        Tue, 1 Mar 2022 10:40:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=OWuwhm0GxdbalPF4PWO3NTgfogiHZToeV4RN9N7GfiA=;
 b=gyjIepIERAfSKItGCT2aj3y+i37yeJcJwyinaiv2+vQ19Dj8ZyfmODZJYMq4zgdFhfGo
 JccgSUQ/bLWQ+9ghfVVKIs5M4itDH3QtWsXNHgZwCuIvDw4La2utzUjK/xYs6AxrZohX
 cM8jR5JgThX/WMF6yxiQZGjlYyr9POX0SSP4pqTdnnoq5QXpsKDbg60KYCmSuB7Gwiuh
 cqNRpdEf/KQpDpE2k/+77wbUTJWhEn8C8i8W3vwQEDzFVvGS8xFGvw2ENtb0WW920PSr
 luqKXS1YqhaoNSqHjwlCRA/2i2LMhIAAQKr+KPzlj/mCAs0VAo8N/TPBJ94T7b3MnkXv Aw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh15ajam9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 221AZLvn042970;
        Tue, 1 Mar 2022 10:40:33 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by aserp3030.oracle.com with ESMTP id 3efa8dp71p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X4cVb4PoQcfyW7H8vlB0Ss4chTq2k33mq2PM5EpzaE5UPd5OM1rePCFwhx4pbmv/au+T14/CbiGUmR/QwPMhFS0JtyCErVV0r0S4uUFkMKlskToHsbQxqVYgUdHV60LcyCYHMfEoWehO+tBzn+Q4498rExikJcpdEG8KPqyhGSEPqjTypVWSt1w3rMvnjU1nxgssH52883mYSO9Z2gTsmZDxyoolSpIRnx69tor0kQs9j0MBjbBXP1lQXKu5REYsndFW8M8JJuO6fe5n3X41cpG4klvxlLVIPTjYHtEMbSVB68VbauhU3SrFGzP1yzkvPOjB/5e0iaq2g0ZKJQsTiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OWuwhm0GxdbalPF4PWO3NTgfogiHZToeV4RN9N7GfiA=;
 b=EvlHWz1EFHxYkW0MoLvqgyyoKoDdp/bpFxuBg8WpmzUYN5wSxG7xjN3+MD4QX3+YFIM9MuvcVJGRKErjJo4nCvBYdcSBwih7ryOWVSMhv2HMNMyQTPhwHPKraAJWka/uNJP2jX+O+2nFX3ikFrj6iofoiVmX+SrkkLNf+xP3ELK6AlSpa7NAY+4Ih0x748okT730L8rdx8aJiyFUGArU4BNkLt3Ge4+UOrrpxUnKjMOX6C9O7b23jhCK2MBvGdWdyy0p2XB2TS6UxaLdSE452S/MA5Zl6G75KJ2nbBewy+GCt8Mpa3TwLSwX0s8P0T9aLfrR8IZb7teKJ3gvY1/f0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OWuwhm0GxdbalPF4PWO3NTgfogiHZToeV4RN9N7GfiA=;
 b=QIKW9mHlcVvPRSgQMGVdRDfyBZ9y/IhOpur/sBXf/DWCd4vAZt6QSjyEiBgXt7yz/puv+mqCwdcYvYtPZOhyw8AqJVzOCCDBe8ztiMo4jNYCikr9DVLGpqQPVzltJUqU9shho928kbYTLd+dvQF0p+dPgPojTlgXvOPMmPLhmvw=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by MN2PR10MB4160.namprd10.prod.outlook.com (2603:10b6:208:1df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Tue, 1 Mar
 2022 10:40:31 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 10:40:31 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH V7 12/17] xfs: Introduce per-inode 64-bit extent counters
Date:   Tue,  1 Mar 2022 16:09:33 +0530
Message-Id: <20220301103938.1106808-13-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220301103938.1106808-1-chandan.babu@oracle.com>
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:195::23) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 201c581c-2b35-4ca4-837a-08d9fb6fe7e3
X-MS-TrafficTypeDiagnostic: MN2PR10MB4160:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB4160CEAEDCF15C5785F02293F6029@MN2PR10MB4160.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rec26k/+LlcUEUQaRH2ANP354Mbx5yNCX6db+V7vFoNEvRL2v10DJbW9wuOzNIqldta07Bups14ckPzWO7GTGEzspoPLvewhdXaK2CqrO/1pOHOk4T6dmghDFj6a6Nrr77ddrpXECyHwGKHk77oYAznBCDlyuOntDpV6U51dmZcJJlOS/X1ZYcysmvzMcsG9h9KHjGjcSnNIADlNE2nw+46+650Lu4kLjhQ/RW9ieH1xIqkXTcoW9ynM796WiQwxqAInQ8u7apEpC9VIEHB0RjFk3AMivZqZhGd/jNGezo2Flg/je49ZVwbHj97dAkIlHpRWlq/eLVvKuQG+NXpMfwxmM7zqsiT9uYdTQRuK9BrP0bUJFLgnDTfF0uICMZvReNsgvYvY98lBfF8IruQo95tRjK3js3nJ1PnN26o5AQ7faM7G8NeSFeVLRsoj7Lqn9mFjj2dWeJWn6JOh8Eew1Z92pRF4ABfOa8QJlKnmcGioSfgHLoNOBWu9VUHky0LU4fWDHmNo6qsc0qKIpOwUfUHTqhmQEKIcztu2j9D3DbqGr8C5ZrHl3yLF4xagh0p1N0gDr4j8ls+j1G329Wm8AyyrAL9MXckZhPv7BM5bGqXR1HNICTrYLO7Xjkbuuucqvw/eShIRuB3zqL1aO8tRowrRZtfKkKHbllWvbkS/Vc8JUhHIJkeihXUIy25pwwWqcQFflu9vU6vKkkOVWtPYMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(38100700002)(38350700002)(186003)(83380400001)(1076003)(2616005)(8936002)(36756003)(2906002)(30864003)(5660300002)(66946007)(6512007)(6486002)(508600001)(6506007)(52116002)(54906003)(6916009)(316002)(8676002)(4326008)(66476007)(86362001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FGZR7ufzGed/CIzPO/MgIERE8k47dQ+8F51Hk1ZMqY23h8c56fZ4UMAytLFX?=
 =?us-ascii?Q?Vg5mdDsG3a8t+pQsuAzg7sEUvcMZA2j1sy0TDKQJV809QM0KOG9wG0dJHrh7?=
 =?us-ascii?Q?g4pdcujVPxHQDvQ7w9gOIQfHkXMdSMyLO05EWpRzp71EZdYB/1iKBsclcyoK?=
 =?us-ascii?Q?2Ab0xOS+EK6t3c895G92SolFNQphYbFQDoASP+d4aVOlJtpOogf+rAoWSoaJ?=
 =?us-ascii?Q?w7pHs5u5TLHwMxXvXIvGFAatsupnWW8dvI2od8+BfU4vRR/nfo4kTIvTyN6m?=
 =?us-ascii?Q?fld9QZ23XOlkN4YqPDtJ8VNW5YuOUAGVc9UDhWLKE8OrkAo6Mg8gjJfnSyme?=
 =?us-ascii?Q?Vi0B9lGNzroRMekudk6hCa3LAR9MdyEN7Gsf/J8uVcs6Sotiy/agWU5na4a1?=
 =?us-ascii?Q?H+ZeOdFD4PFFnRRBSJ/FnfAbAdEvrOnspGzg6u6p8Mu1QkV1ZmF5rIQWGefJ?=
 =?us-ascii?Q?/c4NdaQq/mFRcHci/MhY4ZN3jUhEqAS3/bBbDg9ubhPwjHcB+KZLvvQaTmy9?=
 =?us-ascii?Q?X+EijupIagieKHrKI83fuZSxoufEUh6dCH0idLcKgzNl6rlLsfFQBM5XgV44?=
 =?us-ascii?Q?dpPBqol9A/TYk2k5g9HsLY+5fLBqreHz0sqptkGmQ0LF3AuQ3NqoW0yXEAKj?=
 =?us-ascii?Q?8BYsGYe4LFtMfKTB6WiIuQoAIC+Lmxmj/49YDO5cgtAhblorlnEGwsjE2/bp?=
 =?us-ascii?Q?hRbEPKPnh0GVM6dMUajQSDYS1va3jLv6wqlFsuZBosNqx8L7gewFOGc2JNje?=
 =?us-ascii?Q?w/gl0GWJw7qTOII0qJbFccw98n3tHdPZox5i89CusG4XtyOIK3AwtfY0hokC?=
 =?us-ascii?Q?rqSgwfLyyriIC5eSsd6sRLHYSEwPGMpzjsSXaRotITboU5oJJB9DLRYeJFc3?=
 =?us-ascii?Q?siyacySsaBQNQl4JC7xmwLvA4PYliYY3VOe1fPIVLQvHGiGOhC1F/hox8CoS?=
 =?us-ascii?Q?vVq9Zbmw4gplX3e84p8CMtBHuK0b+Ihc5fV/CVBoIMiehqKgiMuXpxctObHs?=
 =?us-ascii?Q?+57WmmVmgT7xitQq2PUnrmd9rfWK7JWJ2QlNGm42fVoefx8RsJSouyI1JEjI?=
 =?us-ascii?Q?Zic+zNs5m4A6K4GICjS8Xuq97w8bWJPYEDPPiCeuhXfV4ftMfLHUMrvw4+lT?=
 =?us-ascii?Q?Dkh6dENrIsSGTBnXUseDMlfcAR9T8fhYOM3n+90NS794WQ0LAtXKlcOVJXtM?=
 =?us-ascii?Q?65KLhFTzNd+JL83WMzJRRr9bXC74Azk/szy5o5BKADPczUE8uPRBiuJ0yJ48?=
 =?us-ascii?Q?tmvx3jvhdbNDAUk0wPyDEZM9AAebTbUFd0W9DwOnsJRMOkTsguzeSYxWzIpq?=
 =?us-ascii?Q?mgwqBNCrMRSON94I0rFcd/hsX5S1VVDFh+ebKVvmM8YIkFiAumLlA8iO6ab8?=
 =?us-ascii?Q?faDs6adDryF1NFRSP3HY6EOZLeuDyribiif3m3Ecep/LdELJWJkMprouU4Vz?=
 =?us-ascii?Q?0I29CsiSO7H30DCRU0j8UL0P32Gk2o2gn8TxI4D11zG3Nc4M4O2M/iFeX8k+?=
 =?us-ascii?Q?Iruqunf+LtrzKsA/xDVPADDBMGNcQHpqOnKi/d3yQUg8MFwqgjbqcHAlequf?=
 =?us-ascii?Q?4hPuWXrLwmKQB+7U16z3yF0InUldsg4zvlQUBKzxa0r6dLq7iPh11xoAzpvh?=
 =?us-ascii?Q?sQXJVQ1pYWzm4iDw3gYjQws=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 201c581c-2b35-4ca4-837a-08d9fb6fe7e3
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 10:40:31.1585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NaRxUscXiXUnimzRQ+FXuOrmC2KepG2Xevs8hzWSdrseSNFBTyrAdII0OZk5Wl7RmwNaaB26wExXvUrx3wc9OQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4160
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203010056
X-Proofpoint-ORIG-GUID: XYRSg8miUfRbGFR1WavH9QzIcgmWkejq
X-Proofpoint-GUID: XYRSg8miUfRbGFR1WavH9QzIcgmWkejq
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit introduces new fields in the on-disk inode format to support
64-bit data fork extent counters and 32-bit attribute fork extent
counters. The new fields will be used only when an inode has
XFS_DIFLAG2_NREXT64 flag set. Otherwise we continue to use the regular 32-bit
data fork extent counters and 16-bit attribute fork extent counters.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Suggested-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h      | 33 ++++++++++++--
 fs/xfs/libxfs/xfs_inode_buf.c   | 49 ++++++++++++++++++--
 fs/xfs/libxfs/xfs_inode_fork.h  |  6 +++
 fs/xfs/libxfs/xfs_log_format.h  | 33 ++++++++++++--
 fs/xfs/xfs_inode_item.c         | 23 ++++++++--
 fs/xfs/xfs_inode_item_recover.c | 79 ++++++++++++++++++++++++++++-----
 6 files changed, 196 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index d3dfd45c39e0..1a5b194da191 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -792,16 +792,41 @@ struct xfs_dinode {
 	__be32		di_nlink;	/* number of links to file */
 	__be16		di_projid_lo;	/* lower part of owner's project id */
 	__be16		di_projid_hi;	/* higher part owner's project id */
-	__u8		di_pad[6];	/* unused, zeroed space */
-	__be16		di_flushiter;	/* incremented on flush */
+	union {
+		/* Number of data fork extents if NREXT64 is set */
+		__be64	di_big_nextents;
+
+		/* Padding for V3 inodes without NREXT64 set. */
+		__be64	di_v3_pad;
+
+		/* Padding and inode flush counter for V2 inodes. */
+		struct {
+			__u8	di_v2_pad[6];
+			__be16	di_flushiter;
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
+		/*
+		 * For V2 inodes and V3 inodes without NREXT64 set, this
+		 * is the number of data and attr fork extents.
+		 */
+		struct {
+			__be32	di_nextents;
+			__be16	di_anextents;
+		} __packed;
+
+		/* Number of attr fork extents if NREXT64 is set. */
+		struct {
+			__be32	di_big_anextents;
+			__be16	di_nrext64_pad;
+		} __packed;
+	} __packed;
 	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	__s8		di_aformat;	/* format of attr fork's data */
 	__be32		di_dmevmask;	/* DMIG event mask */
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 34f360a38603..a11d3ea5ebfe 100644
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
+		to->di_v3_pad = 0;
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
+xfs_dinode_verify_nrext64(
+	struct xfs_mount	*mp,
+	struct xfs_dinode	*dip)
+{
+	if (xfs_dinode_has_nrext64(dip)) {
+		if (!xfs_has_nrext64(mp))
+			return __this_address;
+		if (dip->di_nrext64_pad != 0)
+			return __this_address;
+	} else if (dip->di_version >= 3) {
+		if (dip->di_v3_pad != 0)
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
 
+	fa = xfs_dinode_verify_nrext64(mp, dip);
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
index fd66e70248f7..12234a880e94 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -388,16 +388,41 @@ struct xfs_log_dinode {
 	uint32_t	di_nlink;	/* number of links to file */
 	uint16_t	di_projid_lo;	/* lower part of owner's project id */
 	uint16_t	di_projid_hi;	/* higher part of owner's project id */
-	uint8_t		di_pad[6];	/* unused, zeroed space */
-	uint16_t	di_flushiter;	/* incremented on flush */
+	union {
+		/* Number of data fork extents if NREXT64 is set */
+		uint64_t	di_big_nextents;
+
+		/* Padding for V3 inodes without NREXT64 set. */
+		uint64_t	di_v3_pad;
+
+		/* Padding and inode flush counter for V2 inodes. */
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
+		/*
+		 * For V2 inodes and V3 inodes without NREXT64 set, this
+		 * is the number of data and attr fork extents.
+		 */
+		struct {
+			uint32_t  di_nextents;
+			uint16_t  di_anextents;
+		} __packed;
+
+		/* Number of attr fork extents if NREXT64 is set. */
+		struct {
+			uint32_t  di_big_anextents;
+			uint16_t  di_nrext64_pad;
+		} __packed;
+	} __packed;
 	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	int8_t		di_aformat;	/* format of attr fork's data */
 	uint32_t	di_dmevmask;	/* DMIG event mask */
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 90d8e591baf8..0d2fe38dc6e5 100644
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
+		to->di_v3_pad = 0;
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
index 767a551816a0..c35796a4e9c5 100644
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
+		to->di_v3_pad = from->di_v3_pad;
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

