Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92BC0C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344386AbiCUFUa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344381AbiCUFUX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:20:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E71834B97
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:18:58 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22L3WgxL031204;
        Mon, 21 Mar 2022 05:18:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=Mf0V+WNwsLvjP5l+lSCNou9WCdgN2IiWVlno9uL470E=;
 b=l3Bvd6R6l262qEozIllHJRKIKU3/pdg16Djqm9AHJUlfpKVFvuQrEMkAQEV+DPvJeJsQ
 7znKfR1MeGaewfJ1mxiqXGhKwVpqoQ+Q6usKMEvLeIw12aLPgKUxCIKJdr2+mR5MP6LU
 4SyOaEChNp52MtMBc5bzoLDc1XFz+9yvnuoh+iodTgCYIPQjHHFMkE0FDj6LfB+reJms
 Jne5SnMQl4LXNKM5qEkhkshiGtjXgh2SpDZ4bmHv44T9gx2Xg6RcJ/W4JGLbQ7OuW2L0
 VhxBg63+3oa2tlDItl4YQv6/+Vs3+PZd6ZiKWd6KUlHZw3MiSOUGaqygI7bCb+c1SdDq WQ== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5s0j50x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5Iil0123696;
        Mon, 21 Mar 2022 05:18:44 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2040.outbound.protection.outlook.com [104.47.56.40])
        by aserp3030.oracle.com with ESMTP id 3ew578rnt7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bO5z0mJSfn8OjmJYTKzCu/DfNSH9erkp28UHKimgkAxqdQIjDk103rsBFYNdfBprHyXLhu5/VRT5h7/HnXb9HZ7HZtZXzx2DvBFZrP9oPuBZxGe2Q2Smqfb4PKCrYOvoBLD/1FYfHsQ1MrS46ZKuK+3fEKv086zt2Rg8KyyklZ/GC3D7NqArD/nLdPthIrLYPqwloP10AhCUvwZCW3i55Ncl2AFEQ0FD4/bMDnKSwIS11qUIdzWz7yPMnt5uYjBM464jCo0Jo2m1W36+bQgCnixK0gWN8h87yM2g3PH2m6W4jLhKyYN2y2aMDUqCn1U/hnMTx6huxu1WDrr8ExlbkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mf0V+WNwsLvjP5l+lSCNou9WCdgN2IiWVlno9uL470E=;
 b=EHpFtPxsEGds6R5n/SPPm7QTmw9pH1irNjjLSu/ZgjUEgZ1kl+WOFPA+15P8ZnaZ/PS8jPYMUZPDltcncTZ+uwZC1dcR9PyibNGd5lYzDpCuRlq2U2nvN75lbfhZbDBByzVSW7d6i5KiaxSr/+3GGU0s2ejYagrUuuddKyEk51/JFa23yzcoX/JYf4+gpSKv+qxHn6ppFGc896FCjDZGwkv588mCZR5B2sitJUjmmcbJll2Olvdtfjs9iQpQst71q6g3YcQ6AtonVI1GuVlOvSdp8aVuCDVmRmeP0ulwbqBKBZ6w5bOX3LcxSqvRuG//5TkVP31hUYjDTI2pMZuGAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mf0V+WNwsLvjP5l+lSCNou9WCdgN2IiWVlno9uL470E=;
 b=GrI1aNtxyi+1YPOHiL1FpSY+hXah8UY2J2Cl6I4Iofv/FrbpNCbdr9z7UN4ImUHtPEptJ7rMmjYbZ6YUnmjN5xlf11H8k+h61RyqvRLP6ChWmXZTVnqvs4PCEx8m5yer4CZ03EOk/qKxyFbrZEJufqzS9mYkSpx0TIM2fDrfFxE=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CO6PR10MB5537.namprd10.prod.outlook.com (2603:10b6:303:134::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.22; Mon, 21 Mar
 2022 05:18:42 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:18:42 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH V8 14/19] xfs: Introduce per-inode 64-bit extent counters
Date:   Mon, 21 Mar 2022 10:47:45 +0530
Message-Id: <20220321051750.400056-15-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321051750.400056-1-chandan.babu@oracle.com>
References: <20220321051750.400056-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0120.jpnprd01.prod.outlook.com
 (2603:1096:405:4::36) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f31eb74-b53c-49a7-857c-08da0afa43b0
X-MS-TrafficTypeDiagnostic: CO6PR10MB5537:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB5537BE1792E2F3557A93ADBBF6169@CO6PR10MB5537.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fOWwNXfa78RToWxTfbVitySa9FSHaaKklq/Pc06fcvnWgPn/WQSX7np1GxyPXKPGDrE01xJq+sE1CaBiYDT8vQihOj3zzQIXQutMPW8Bu73kdw3SaeYlcJq0onfm/Tm9Ig0YalEUkbT6DZ9jK9fupIHE+4rRja5Mxf6eOYRLhO2p2cjfOrCtUuXHriUuJEVUPo/KU7TLmd+dpXXxaB1WD/SzTDA+miYcxeATFkvulGdoe+BB2Zx0nYH+U2Xp4InILikMGykFd3cov4dJO2L/d602Rznaqggngv9IXJBY44Tw0fzqK4mkqZ0YV7ycKtVrfn0Q5nDZzHImKX4ux0SODUdDT3UkP0GGbaiCGc2oixRrzbuUrxTijVhc1KttNb5WDzhmqJd8G0HLx5gxo2fYUWc1g1wRLgD/qE2Jmzq8T2/VGjb8HV6c/yRWWj6yGYa269ArywsDCND71afkT3E9eTTJbZ06+yKashSgPjdB7Zn65dTlo1Pmgy8W9XEeRaK9vfNiRTQR+XKJrj7PDfo2mqiSrdWEbpiIejzuFdyBwOR+mOnAovmqneQxvg52tK3Eoee4FMQJXySM947MkZAbpQJ4ImpVHOWRNPjDVg5UJs7BCCedp/tgOiXv2GgMpR46Buy9qQ0tYcniMvlIQbDXUYaiY1Wl1fw1fXNXTpJ5YLTLDBQOysfqCeEG27l+6F0sFq1BO+lg4N36AtV9g7tlqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(38350700002)(2616005)(4326008)(66476007)(66556008)(66946007)(6512007)(6486002)(54906003)(86362001)(6916009)(8676002)(508600001)(316002)(26005)(36756003)(52116002)(30864003)(5660300002)(8936002)(186003)(6506007)(83380400001)(2906002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?piKHmvfOnlVQnujXRO5K8BeQHEwpkNUa/mYB5FCgezUKX+f7cJM+Ku//Pxcu?=
 =?us-ascii?Q?mlmCK2J0FPSCKW7wJP1jCWvKOwFpJmHE8klRgjV5+JG6eSXcPDeQHbMM8FpB?=
 =?us-ascii?Q?6abMVV0p4tbx4qjLQWLjAdLQ/sadOh01j1ZsWH8c6ZUWO0fY+HOj1kQkYnr5?=
 =?us-ascii?Q?wk5Fgxwnq/1SOkpG8lyvYVUWZfDlM3mXccsYOgCQp4qnc5NEqTd66jfAWK/D?=
 =?us-ascii?Q?aGDpwrd+2Ttpkd2FQZhdY4ZS+nfIsTLpavsPtaV+syVmCHSmPAp60zUUfTMP?=
 =?us-ascii?Q?KFNX3KPE5fc1Crolea8HxM6iYji0JvtBr0T1oYKIa6i6P77V9zZ7sKlRjIho?=
 =?us-ascii?Q?x9slX/asGfn0l3zdr6wf4exbnHrxwdx6iXcnxz02Q2C7H+Uj6xHiPG1+pPoN?=
 =?us-ascii?Q?ezi4Xe0wtqEzGuEHS6HZGHUeM/D9o9xdQzKYCmPuO9+HqEG1Em2nZ54z7jNB?=
 =?us-ascii?Q?966syi6RB7LtruYNftGoUHHOtrESX5L/SQa0ZSLBzHwpGelH34tRTB7HyRpd?=
 =?us-ascii?Q?QFZhqJ815sX+j18QMKZzI4THNrcG99zaopVKH6u+vvTpS0YQY16LHfShTWf9?=
 =?us-ascii?Q?jVYVQTwKDTgKoguNcouBfzYJaVWiSeY90I6d3nEFKPPd0/gDWltiTpP2GmlN?=
 =?us-ascii?Q?zd+c8iQGP6YFepwm2O42EL+qqmWoaNkbHdwV9VjAe/gi5ip8jabPnaSDb0Dz?=
 =?us-ascii?Q?Qj4ijZLT7xJ5vtFJLaKwc0bwwmhzAwkH6PmU13JL9dmB3iwuCWvnqaltR/3H?=
 =?us-ascii?Q?eCtWr5HQ4OTfxCLJmPLuIBwikphcijGEtnTMJkLf42knNGh+Iwiu77tO4mui?=
 =?us-ascii?Q?gXOrX6Lp8x3DP4+NU1c+lR/0KaSXV6l2bnIRRn+YwSu8rU88ksJi/IRprTr6?=
 =?us-ascii?Q?Q2Tq5utTxXncgxhyHkzOAgpAHIN7nRJK3xCSUveBHKjsSJ/B8l6r0oIgBZaF?=
 =?us-ascii?Q?hc30+d7gnR2o7KP8B6egSK2iGCeWtiXcqjKATB5Uzg25UOYAEOClXouioRxH?=
 =?us-ascii?Q?KS23GqBdxbRABzwweL3GJkDfaCK52ixqtoo5GMVodCx1f1yN22VF263r/YFx?=
 =?us-ascii?Q?UjueCSqugFZoWVAPbhbSQeMwtYuTWRTvJkkFC4L6Zf2BYY6AcgKd/hgOEBcQ?=
 =?us-ascii?Q?ACsSEuUjZ8axtcQ3Ah5m+Dp7Pw+C4xnqDLyxvg9PjYM9xr9WfI/rPFoL4SaD?=
 =?us-ascii?Q?AispXLz2x+VjBdzvRPQ6kcW2Fd5CsZ7R9/aSYXKSrU+dDl6UIVywTP6BJlir?=
 =?us-ascii?Q?+Mw/mmq1paJ7m6wrJacTIiS6Ow5+jWPV/J8Qd1pY8G48KSEbEF8jRVjG9h/r?=
 =?us-ascii?Q?BJqnMuc1aPxOuhq5qU7PJAsk7EpWMmz3UPxdB0E6V7spEy321G7ZsFWAuhx/?=
 =?us-ascii?Q?pDZ6txkZqnwDQARkadLCjXZ0M36DOgDJTkhDx3dlDMbGPjSKzLXfYIGnAgU6?=
 =?us-ascii?Q?QSb17BB7dCTAQ2lNgdDzNY4McqFuTeDKDmB+0Dz+KrGPiC9gXHsw5g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f31eb74-b53c-49a7-857c-08da0afa43b0
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:18:42.1964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fol8ktrwmuoyoR9uYZrLzgJ3s+olClmsEl4IJwEBgLWvcwCxhJDvhzk8/jUsh2wP10ykS5twDZDzKj0rH90jCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5537
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203210033
X-Proofpoint-GUID: sDuCjVe_lutU-dA3gZDiAMsJOEAsx6DC
X-Proofpoint-ORIG-GUID: sDuCjVe_lutU-dA3gZDiAMsJOEAsx6DC
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
 fs/xfs/libxfs/xfs_format.h      | 33 +++++++++++--
 fs/xfs/libxfs/xfs_inode_buf.c   | 49 +++++++++++++++++--
 fs/xfs/libxfs/xfs_inode_fork.h  |  6 +++
 fs/xfs/libxfs/xfs_log_format.h  | 33 +++++++++++--
 fs/xfs/xfs_inode_item.c         | 23 +++++++--
 fs/xfs/xfs_inode_item_recover.c | 87 ++++++++++++++++++++++++++++-----
 6 files changed, 202 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index eb85bc9b229b..82b404c99b80 100644
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
index e0d3140c3622..ee8d4eb7d048 100644
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
+	if (xfs_inode_has_large_extent_counts(ip)) {
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
@@ -398,6 +417,24 @@ xfs_dinode_verify_forkoff(
 	return NULL;
 }
 
+static xfs_failaddr_t
+xfs_dinode_verify_nrext64(
+	struct xfs_mount	*mp,
+	struct xfs_dinode	*dip)
+{
+	if (xfs_dinode_has_large_extent_counts(dip)) {
+		if (!xfs_has_large_extent_counts(mp))
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
@@ -442,6 +479,10 @@ xfs_dinode_verify(
 	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
 		return __this_address;
 
+	fa = xfs_dinode_verify_nrext64(mp, dip);
+	if (fa)
+		return fa;
+
 	nextents = xfs_dfork_data_extents(dip);
 	naextents = xfs_dfork_attr_extents(dip);
 	nblocks = be64_to_cpu(dip->di_nblocks);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 967837a88860..fd5c3c2d77e0 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -158,6 +158,9 @@ static inline xfs_extnum_t
 xfs_dfork_data_extents(
 	struct xfs_dinode	*dip)
 {
+	if (xfs_dinode_has_large_extent_counts(dip))
+		return be64_to_cpu(dip->di_big_nextents);
+
 	return be32_to_cpu(dip->di_nextents);
 }
 
@@ -165,6 +168,9 @@ static inline xfs_extnum_t
 xfs_dfork_attr_extents(
 	struct xfs_dinode	*dip)
 {
+	if (xfs_dinode_has_large_extent_counts(dip))
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
index 90d8e591baf8..5a513eb4a631 100644
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
+	if (xfs_inode_has_large_extent_counts(ip)) {
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
index 96b222e18b0f..d6f536cd8d4b 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -149,6 +149,22 @@ static inline bool xfs_log_dinode_has_large_extent_counts(
 	       (ld->di_flags2 & XFS_DIFLAG2_NREXT64);
 }
 
+static inline void
+xfs_log_dinode_to_disk_iext_counters(
+	struct xfs_log_dinode	*from,
+	struct xfs_dinode	*to)
+{
+	if (xfs_log_dinode_has_large_extent_counts(from)) {
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
@@ -165,7 +181,6 @@ xfs_log_dinode_to_disk(
 	to->di_nlink = cpu_to_be32(from->di_nlink);
 	to->di_projid_lo = cpu_to_be16(from->di_projid_lo);
 	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
-	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
 
 	to->di_atime = xfs_log_dinode_to_disk_ts(from, from->di_atime);
 	to->di_mtime = xfs_log_dinode_to_disk_ts(from, from->di_mtime);
@@ -174,8 +189,6 @@ xfs_log_dinode_to_disk(
 	to->di_size = cpu_to_be64(from->di_size);
 	to->di_nblocks = cpu_to_be64(from->di_nblocks);
 	to->di_extsize = cpu_to_be32(from->di_extsize);
-	to->di_nextents = cpu_to_be32(from->di_nextents);
-	to->di_anextents = cpu_to_be16(from->di_anextents);
 	to->di_forkoff = from->di_forkoff;
 	to->di_aformat = from->di_aformat;
 	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
@@ -193,10 +206,63 @@ xfs_log_dinode_to_disk(
 		to->di_lsn = cpu_to_be64(lsn);
 		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
 		uuid_copy(&to->di_uuid, &from->di_uuid);
-		to->di_flushiter = 0;
+		to->di_v3_pad = from->di_v3_pad;
 	} else {
 		to->di_flushiter = cpu_to_be16(from->di_flushiter);
+		memcpy(to->di_v2_pad, from->di_v2_pad, sizeof(to->di_v2_pad));
+	}
+
+	xfs_log_dinode_to_disk_iext_counters(from, to);
+}
+
+STATIC int
+xlog_dinode_verify_extent_counts(
+	struct xfs_mount	*mp,
+	struct xfs_log_dinode	*ldip)
+{
+	xfs_extnum_t		nextents;
+	xfs_aextnum_t		anextents;
+
+	if (xfs_log_dinode_has_large_extent_counts(ldip)) {
+		if (!xfs_has_large_extent_counts(mp) ||
+		    (ldip->di_nrext64_pad != 0)) {
+			XFS_CORRUPTION_ERROR(
+				"Bad log dinode large extent count format",
+				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
+			xfs_alert(mp,
+				"Bad inode 0x%llx, nrext64 %d, padding 0x%x",
+				ldip->di_ino, xfs_has_large_extent_counts(mp),
+				ldip->di_nrext64_pad);
+			return -EFSCORRUPTED;
+		}
+
+		nextents = ldip->di_big_nextents;
+		anextents = ldip->di_big_anextents;
+	} else {
+		if (ldip->di_version == 3 && ldip->di_v3_pad != 0) {
+			XFS_CORRUPTION_ERROR(
+				"Bad log dinode di_v3_pad",
+				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
+			xfs_alert(mp,
+				"Bad inode 0x%llx, di_v3_pad %llu",
+				ldip->di_ino, ldip->di_v3_pad);
+			return -EFSCORRUPTED;
+		}
+
+		nextents = ldip->di_nextents;
+		anextents = ldip->di_anextents;
+	}
+
+	if (unlikely(nextents + anextents > ldip->di_nblocks)) {
+		XFS_CORRUPTION_ERROR("Bad log dinode extent counts",
+				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
+		xfs_alert(mp,
+			"Bad inode 0x%llx, nextents 0x%llx, anextents 0x%x, nblocks 0x%llx",
+			ldip->di_ino, nextents, anextents, ldip->di_nblocks);
+		return -EFSCORRUPTED;
 	}
+
+	return 0;
 }
 
 STATIC int
@@ -347,16 +413,11 @@ xlog_recover_inode_commit_pass2(
 			goto out_release;
 		}
 	}
-	if (unlikely(ldip->di_nextents + ldip->di_anextents > ldip->di_nblocks)){
-		XFS_CORRUPTION_ERROR("Bad log dinode extent counts",
-				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
-		xfs_alert(mp,
-			"Bad inode 0x%llx, nextents 0x%x, anextents 0x%x, nblocks 0x%llx",
-			in_f->ilf_ino, ldip->di_nextents, ldip->di_anextents,
-			ldip->di_nblocks);
-		error = -EFSCORRUPTED;
+
+	error = xlog_dinode_verify_extent_counts(mp, ldip);
+	if (error)
 		goto out_release;
-	}
+
 	if (unlikely(ldip->di_forkoff > mp->m_sb.sb_inodesize)) {
 		XFS_CORRUPTION_ERROR("Bad log dinode fork offset",
 				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
-- 
2.30.2

