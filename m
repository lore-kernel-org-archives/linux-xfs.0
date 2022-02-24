Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13434C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:03:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbiBXNDo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234742AbiBXNDn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:03:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E79253BCB
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:03:12 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYJj2000938;
        Thu, 24 Feb 2022 13:03:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=rI08DrmQKzJ3Vmx5q2tlO9EowYfZjTcnMbNUEhKpxPw=;
 b=hwKZ1NpJ70LGBVE0fBCwPqzuPjmT9dshKtXl0LoYrZeV4Q04n7F+mTLMvXgF8ypHToIT
 HSTo1jlsc+FrWL39vQsalbode8O2ie/GCYX2tcPgRXHbH3z66wNyovypPkjpumZzbKuG
 ErIGTjgk9LTGKYbcIY/5ahzzPHec4EwA3Hum9OE9RFgP1hk/te1HmTpcud493/N4ejtV
 2cGmkxxnT+gitPBbYc7aXiMYLtRlGfso/ugYV0fU8tRq8mpr1rZv/8lvINwB4TsqdCmV
 0i0ygKoTq5xoaP5WI+UNpj1//JnNi1w3+IrfOI704AiHd9eVN7MDuYlyrHRGi+Pvp3Ax 6A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ect7aqa81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:03:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD0XJt120486;
        Thu, 24 Feb 2022 13:03:05 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by aserp3020.oracle.com with ESMTP id 3eb483k7cq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:03:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=grAbnBqy9tlrI/2xJEOHxxsJfeu4TgLuAPLub4Xzj/UHLqzwhGCOUGQSbLd3RuUqP5vdjP52NwVHQoKdDW86TWA/SrUcpcr3zCUJWLqRsGZEaucozko+jrvHKBfFBxINOAXEO2H6ZH/ekYJuMvOATQtOvkAHow1tRVXoddd3zJoBzVssGM0jWOm3F8e3WMI863ZfUs95wSVWa995My3ombYRNG1jE3wxmEp930l9g58iPgMfPrfW/vu9eBFc83vvz7C8z0CPDXNYKcwS2GEIpkCI5cd5ZMafwVhpLGqMmSPT4Y4ihyD5bnrs+ve6lcI3Q/o0j32ZTpW0IeANKEu2qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rI08DrmQKzJ3Vmx5q2tlO9EowYfZjTcnMbNUEhKpxPw=;
 b=GpLt4o1lhVbqduCdnO9Z9k20R1kV8c8+hQfV3l/Jr88YpXP7zYJnrKQHDfJONPML17opKj24y7hqUEMLn4PmaycGvRQ7wgNrEcusEdLPPgFB0Gcs6X5uiLpsD7oDUQuEKvQqCnl+pM3wA+2QgQ8FeA3U9Xt5Ec9dKZo/hqL5E2Y9tAZIuOTKyv9XjVs0/+73JMLdlRmf4l+LdC6+12s7hdZr+kRxB2SCqgVXmcXOo8yC6JQPwm+Knxqzg4x8arQU7SsnW8lFSN1sU08Ll/Y1lYb56YQmjkqOoG2nD9bVKKvSkOrs7ace+oTzMsibv5jqTTWC+YhAPkWMyU/Rca6JBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rI08DrmQKzJ3Vmx5q2tlO9EowYfZjTcnMbNUEhKpxPw=;
 b=zDrmpYCzVuFq+mKfqBQyWVKeYfczdPvKWdJzIWenpRMFsBtdJby2Tni2FK52RMW+NYeeHJV4O0EsKPLNTcMI+82YFYWpFIWkVD/3Oh9dTehFA1GUN5zJdK2KQJVc8D0ZPjP2or3DZs0iafu6LcTOTZyh8DyXEi37k76WZ3naMS0=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM5PR1001MB2172.namprd10.prod.outlook.com (2603:10b6:4:30::36) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Thu, 24 Feb
 2022 13:03:03 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:03:03 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH V6 12/17] xfs: Introduce per-inode 64-bit extent counters
Date:   Thu, 24 Feb 2022 18:32:06 +0530
Message-Id: <20220224130211.1346088-13-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220224130211.1346088-1-chandan.babu@oracle.com>
References: <20220224130211.1346088-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0009.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::18) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f45b7282-828d-4972-9143-08d9f795fdb6
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2172:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB21724102E8EFCEEB8F54F83BF63D9@DM5PR1001MB2172.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MQsxjsdp1qGRZuZhrX+wy6U4hYiPHDwYZ7GzqtVIyITLQgZPWGJEjeDiTShYVlcH3o+DTgQNpAcnFRjPXn/H9C2igQ4CwZf9KVPRI434+d98vWsgU95DnEGIx98Ps/1JEbUF1Vn40/cbO8WdhmtFzVmyJwaY8OxvZe9Vd0i2mE6NtG98nDboYGf9aQxWKIqUk/r/QJA7w/e0fKSdYpOl02vDPGCupNjDBC4UmkfAjWFLeelz62E6HI2/ENqRZBgGlJzlSEOFQW8GheQzMNaU3CR5O0BrxwcppPQvxTSynLPNpcCPXV8gc8fbg02PxSMQdUc8gA9zzbGl9kB+pXpdeN2D8sYB0Er82q9Lj7l/dVy+n3ELTTlU9UgEV9JE/DkmbBSO0Ju+otyHWIHolhyu7OmdhCju+LeahaWEoQJwmTO6K5U0fVOF7dQggS5TXiTdxIMMz+M6zHxwLShI1MFQ+puUP+T2xhTvLEsdRsZhTo5I9MD91SuYWvQ23dodbmL4M1/m3ojMB4tRA5toFSmIuaqASwhb2gcGWxrggu+aLVonT0p263WSrupvBLvINrycBJlvqL7IY1z/fVX1O1SYVvh8wneSEMsJ3ovBuvALsaPCFtHOiJmkC5l8o6izWUoDf6gyP4EdqC0TnAucVeSI92DsDGpSIPpeqg4FkP1Ngsz9D2Rsy5e3jXHoGXZU11b7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(6916009)(4326008)(508600001)(54906003)(6512007)(316002)(66946007)(66556008)(38100700002)(8676002)(66476007)(5660300002)(38350700002)(30864003)(6506007)(52116002)(86362001)(36756003)(2616005)(1076003)(83380400001)(26005)(186003)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1SFdTOs/mJOO2geRIotw0DevDLJEN+4XcLexiM/eeneV3PbP4q7We11WCsyk?=
 =?us-ascii?Q?N4Mzla1mpXkxxA2/mCJwTUiG+maUZuxYmFxYKOk/GspYjDhHUwB4ScVi1teZ?=
 =?us-ascii?Q?0ftUezQuCnPe1MqbAsccyunYSMn9GFFKG/uKmA+3AkK1moobOHQGS1/qrp20?=
 =?us-ascii?Q?2F4fsulYm3EEqGiIfO8TIHj3Wekz3ZlHRTkAPCSbKcMnq/XCfuriSBBw38qW?=
 =?us-ascii?Q?2ve7Cyw+9KYq9ish3mN3CuV1OutV81HavXYmzYZU1k8/QVbQmQJNVRtN2AmU?=
 =?us-ascii?Q?sc2BOYOKAENGpFi31DD5vc9ejCF4HjxwB3a1lyIw227alaQPnUveFmk2tycI?=
 =?us-ascii?Q?IStJ7CVczk8srHLVemGt5oQTIgHcMF8iZwQkmIVsoimGJs98Xh7KQEyk+by7?=
 =?us-ascii?Q?xhNl6Hb0DfQfYlsZiUYHPL51dxEV08iifpS0SXkOH9b2RG58k9LkRcGuPHsT?=
 =?us-ascii?Q?cxOFT/RIA+0J59t7xCSKOSbOaSLqQYI2UQYndzqvsymnwmY9vJYxH4Kyw0jA?=
 =?us-ascii?Q?h+AfGJ/ylUfbk/8AJartvQX8OL4r2DpP4Uej0S2aSqlttFsSYL2ZmLaleKZ/?=
 =?us-ascii?Q?rPaVyyBilmIx70jpaQNVb9EjiPgqDSaWGcFdJLX9UQAhmDmSTlHS+sRG5EB2?=
 =?us-ascii?Q?ble8guw07hlt9hIaDJ6q2YeEPOnZ3oIk/QalA7WezKRm66lMakrJJnnfOS29?=
 =?us-ascii?Q?5eX6HR1klFvf+GsrjmEJRyo5RaG5ra7KhXOx65x2jjHX7RwidIWjbdcvBBnO?=
 =?us-ascii?Q?fg3vvY9WRVV+Dy8NiPyT3fM+37C11Dpal2t1eD0Bh4mfyD5OBIQpACZJ7Di+?=
 =?us-ascii?Q?HL76/nROBlL9MVRdw98jhHw2jM4EA9fEp8863adKeOolgYbMF7g5SmQd0Ppa?=
 =?us-ascii?Q?DGjknIyfAKrau2lcvzU1nzGqKMttLvMB6ziXW97sCEezPVxUHjIiX1O/bHa7?=
 =?us-ascii?Q?zzBjbTShTrgI7m4vnKpr8eJ0USip52HnJcBavmWbc9LlDiNxRUXI+zVKEyIH?=
 =?us-ascii?Q?almn940ZwAMs0XBTjH5M1E5h99OM9QAC9dIgHmkOsyEpFMz4GxMVq2FokBLl?=
 =?us-ascii?Q?g8KAFJcs9DAFyGqSJLT6WBXX3nlYECgQnrb6wYiYgefseuPzub9rtydVeOAw?=
 =?us-ascii?Q?YxuFAT2cd5RPsBYuoHq+qK7quVzHjrlb65DAO5qO8y3jNVds3qST13cMhXZ6?=
 =?us-ascii?Q?fpBovVXtErsgI+EOxLPSWGdXJXI96f79BJBfZXmQkuknhizjzBLp/AbTjikX?=
 =?us-ascii?Q?GG8oaru7Q1f3BzSkXLr/SICSXlyqFmpnMrosZEL4Q7v93rahEBHqg9EOzygU?=
 =?us-ascii?Q?kR4E7LQgERkDqBbVpoXrweYZt+M2xud/RmSWhc7BL9uQm/OObb61tLd9AktN?=
 =?us-ascii?Q?l6H2VpxXhQGqhSj3DC68u0jyDLSBIqE1RS6MWQANtZYe/GXY3yg3FSVPQtOZ?=
 =?us-ascii?Q?h9HH/KIxjAH2KVYLSANjaTvJFpeRMuVrlJwrgbT8XOcYSiyT/seeEX+hDxci?=
 =?us-ascii?Q?BcFnGU7ttluDNn3Cp1+SlgrZG16SPMaEAtFaByaADyikChO/I4acGK2w04y7?=
 =?us-ascii?Q?0OsWTxEZs9khDzSrsUwAGEKYFIw8d/PafzlDoAuFJidEYruJiYpWLhdIMwd6?=
 =?us-ascii?Q?D6FkvSfOFS7Uhgjn0Vamtvs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f45b7282-828d-4972-9143-08d9f795fdb6
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:03:03.1704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xYW47+Jmw0PBaCVKLpL3L5hz8WwvMyYHjtWZJsrArAvvTUc3bXgoMMqIsOGW7Rw0WuGj/Z2eCbzcdfGgO2GFEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2172
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202240078
X-Proofpoint-GUID: A4h_RfnBlOdL80QDqVHW31u4jHDXNkca
X-Proofpoint-ORIG-GUID: A4h_RfnBlOdL80QDqVHW31u4jHDXNkca
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

