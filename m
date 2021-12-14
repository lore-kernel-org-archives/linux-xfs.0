Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8755EC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbhLNIuA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:50:00 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:13568 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229577AbhLNIt7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:49:59 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE71GEL017905;
        Tue, 14 Dec 2021 08:49:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=xyjhRtFNiNt854KoDuHsGzLtKTUO3ZUKT20dhrkzL/w=;
 b=fw+8mh2jlbx9iUJzfBvFdUuxpRwsSUjO2Xvo/TFKg997JSaLwriFKlDiiCo4k+4I0NNn
 fcHAc51d3Iz9tlL7NRVucGHikC1buDqdlyG8TRmyRl8jeUX6DaB2XTJVdJZJr69S5OmO
 7ZAgyWToI7jOAIUTnKl448UBm8JioapgL4V7CITEHcm0cQPcS0KsC9yu4R5rhpR5R7jX
 3t8hIlGSBfiW1jzym/+rloXvxYANY3MuPXlSlXNPqj+o2+28xlGuYqZPvm1Pd8KE2hkm
 9sDfBfrqABDSgfHAaF9Ie3n7defESq+tXKNBT8xnkKAG7pl+fB5F0eexGFrsIJDxPaaJ JQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx5akau0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:49:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8eREe074100;
        Tue, 14 Dec 2021 08:49:56 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by aserp3020.oracle.com with ESMTP id 3cxmr9yjj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:49:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FBNFg2gRi4GzATqM4ovXXXilTmHsX4Hv52E4v510T3A9HmdeCh1pzKspdYkTi1IlI5A7VA0uhodAiCAlbb/3d10XG9Ud6Z4s7posIZpvTPotYtKmmz3dwcLF7hKvINEZ+UeD0sQyqlbjEsqQH0eMgFKW07DLe8xtt29mqtdvbeC8ewQGTnJhhEBStmCFUBBE4GuQFUQmTQDarWDRUNf8hZPtWylsYEfx03jiXy4w2AHEsmH2KgvQqwwueyrz3nBv0jl5cKUztaxGsYVuyHVCMwLbQH6KL6VROrW0VedB/X7XBz4Q+xNdK0g0foNdptUORgkUtxDhHwcXerDHwk/qFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xyjhRtFNiNt854KoDuHsGzLtKTUO3ZUKT20dhrkzL/w=;
 b=g2KtKiQ5bZgA7Q+nuENnbo7esX9/1E+8IkN7TAYn1UPJhjQrJjIHS9aaEt1SshmcJV1Ay2eATl3t9ZepzfEi/J9XqScn4JVShzHHuEpbbGPfL2bEDL5GRCgIR4h6hmBAhzkAmmz4BuJ0gPLHtCIp57u/h4fTIRd9tRENDvetN6MgTPtuzMM1bOkRTKcMcP5c9gIHFuKPZvZQu6XU260wtKEFIO2qnn+oP0qjKYXyuEdDA38w6CmW1VIiTwdh8XarUZn0GBgYuCFN8AQ6Lu6ESkMCjtIw4jY2Snf+uA6ZbZK2+APwI9lwsJ77+k3c676Ba8PFm/Or3tqceD4lQAZE5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xyjhRtFNiNt854KoDuHsGzLtKTUO3ZUKT20dhrkzL/w=;
 b=dXH7nGlECrTwtqptsWvlJ17kOU+ouw5FgxNN+nc9i7zCdrRLsZXRkQBFal0xhAQDKjFmPjG1cvqNiihII6lRRHvYtzvjn/O6KauKFKdW6gyYaZGwSCU1RxxQtlljrVsb0IMXt3KNEP4TrgxD4c7XH0c6uZAW+JXOszCkfENBJ5o=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2656.namprd10.prod.outlook.com (2603:10b6:805:42::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Tue, 14 Dec
 2021 08:49:54 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:49:54 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 09/20] xfsprogs: Introduce XFS_FSOP_GEOM_FLAGS_NREXT64
Date:   Tue, 14 Dec 2021 14:18:00 +0530
Message-Id: <20211214084811.764481-10-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211214084811.764481-1-chandan.babu@oracle.com>
References: <20211214084811.764481-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0069.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::31) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d74b136a-9857-4a87-2dbe-08d9bedeb2fd
X-MS-TrafficTypeDiagnostic: SN6PR10MB2656:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2656A30C4E268CD0BCF2E65EF6759@SN6PR10MB2656.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p3qnWddY5A4YrB5lbNEZy3JuJjaMtIAtpPoSM/bOgOneZlUYEfLZmDQxJlEAz+TZNnNcRBOtJz/FXQFjnk7tSaSn7eFuyTCdDEe4dMqyXfDj3O/UCEwtxcuyEGcDAikS5qlNkkIby7lKJ7eqFiESHVOfQy6XSzxfPEWBhoF/KiDztEtjKU/3rr4+3qX+tzoQ4FB8hxa8rliji9YtCOussf95STVGin/a814w3FtLHTdf4NswmdzOMdMNbYgIyEzQTFKxj6O8z6aQHgbl40KPUoKSx4D/mj6LNtsgC5f5FGIB3Q2rOniYaUS9Rqjp8p7pxoKTuLWQbP0e1IyUutLuZJPfaFQSS+OM6ERW+95/R2NWCw3Ud0qkwkwowKROW/o6+RvOz9bV3VyHDawPchjnW7wRFEHLCMmTVAc1etxEhEMnl3+uA9OPzcstIJYsP86fWjNl97pk0kev7oFchnSkUM3woA8Y9yuQpxrttqZ0cCseVvqDEcxzPOvB0UpwDW7s5IK/i5MzCHf9+GiP6VMBHRPFbfrDl8TYR1fdcGZ5r6m77CY1iVYQB18aVzmSdQLFeSy+4icnnyDGX6chzDivtk/KT76DXPXcgaVKVBl1qMgbqZRxb8kCpGkkEI8JsVgnL/tZsTjKz+C3i4y72BmGMnEh5MNNFzyyx3AhTMCi/Lbrkhi7t+YqAHBOE6Vxb6WfJ0uaL6eJ/qX0Y7uYK7d44w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(508600001)(52116002)(86362001)(186003)(6512007)(8936002)(6916009)(66946007)(38100700002)(38350700002)(5660300002)(6486002)(316002)(8676002)(66556008)(66476007)(2906002)(1076003)(83380400001)(2616005)(36756003)(4326008)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f30HRWfzcK9lpyAcYfOcz3y10Ya9SkgBO0cL4nYUKweR72Mjs0KLjfe1XCPO?=
 =?us-ascii?Q?wT6+ELZ3NM28bh2keNcuJMJ9IOGDsbcwi8gvbbgrI9wAYkLEPEMOXRSYOyAq?=
 =?us-ascii?Q?GuZqLjnP150GmXj6QWNpnNqsdfo2U31H8/dqtkD1TUz29ffQWaKzhucS35Ty?=
 =?us-ascii?Q?OWxHXL1KWLOC03ZvfsvyW88GTU0C+90EO9egKzOkU+q73WGrl5fu1DkNIOHR?=
 =?us-ascii?Q?8CyywMwrdmIkYTuJKANM9GKb1gDfldbkFc98cIgWl/n240cYd6uIv4NHzZPG?=
 =?us-ascii?Q?POxW80IGJ59HhmDg6w1Wc1Hnda3eBwwPgK1fKk1J8adulKg9bbDvkBZeKQcD?=
 =?us-ascii?Q?rogbBg91VQdJ6B1volBOgZZwB9BdAtXB+Jnr3odyo5neqc3aEYyEvgXTPYEV?=
 =?us-ascii?Q?6wOrXXWn0hvbLmqzoGfoDrN+uzN+QzG7DqaWdHQbMvZkk5koCbiIrmdfEWMX?=
 =?us-ascii?Q?KgEnDFyV1t9ijtS+rByijwsTqFh4xeH8Isr1aBwETR/UFlTk1SgqR4a74wMc?=
 =?us-ascii?Q?qk7yKphQntGjze+ZPuB7jDSJbPUdF41ul1UoIwMv5VonZ43qRx6L13jPqHtn?=
 =?us-ascii?Q?i58WGOqKcvKvL6llUD3extsbaQgasXEjMftMOJBC9sSJsSoSINDaSl2W+X/u?=
 =?us-ascii?Q?gsEVEWcJr8BqiGZ+1C2KJr9TmVcCmParrjMkqLCrWXEkkivAjrQ70YuO7Jei?=
 =?us-ascii?Q?QSGHtjCtluC9EZ7Sov0S4KYby/zqGFXXuvFdxx0ZIfffWnFbDcBds/11YPPC?=
 =?us-ascii?Q?5Eu1x5bCPGRW9CJIBIB8/XdnTBgy2pHeamwbCSFXXvoRV3NBwPm6eg0qluFT?=
 =?us-ascii?Q?a46cIRn4Y6b5uJxZid/zZU7MtS3LDuhv6eeDemDuCUE93FJkRUjsyToMkz2J?=
 =?us-ascii?Q?IxyGCibD5E+BGrG/BhXV/a2VPYlMuZEgBCTQ7s2AOZa58n/dCJZz2hdvgoRm?=
 =?us-ascii?Q?0A8Vq6M0rbuQUix46jiQonZrHxTN3/eNF68pSXhnPsftuWgBkeKySinYxykw?=
 =?us-ascii?Q?1kcadg5kSPPFbaZl9QpSxltei7//oJZ/rpq4D4FjgOgMvqrk7jNLMvTyLRxY?=
 =?us-ascii?Q?xJttUvRhwE/JjbKuWhdnTE3qL2VNQd7NG3waxCAKROI+xEMDhuKZPTovwBRC?=
 =?us-ascii?Q?sc7Es4zqZcTXo6EqpzcsQhA97XE6mlFHNyUmWf2wLQ+AX95lfLZoZfV63ys4?=
 =?us-ascii?Q?xUnRQZRx4Sfvp3vCaaRgtpyNvwsD9a3J8TdDVQDCPuvVNVnk+aqY8YC2aiBE?=
 =?us-ascii?Q?lEDF7IUoQk5B/yaDfYhxZgTWvGPyNSDO/mDPOjMCcM0b4ugpGBeaPnIx7dVw?=
 =?us-ascii?Q?D82A6FCQoeNEMISQHgpKlI8nQfqOsR+OJYjFriNquOT2rvdzZG8xR/155IYJ?=
 =?us-ascii?Q?m5CDfwFg2s1r+SX67VaFB7ZvbOCGAe8JqRB7gSiEwzNeWz9TzFrYJeSYM0Qs?=
 =?us-ascii?Q?pqR9twTFdsxiIfTLb+NlHFnthnSr3iSyXnhJenAMQokUhZazIA1w8Ndux619?=
 =?us-ascii?Q?Iv//8wJ/KbuWJTTiJxHIRfai8pyGAC0yj1H685dEeQMElnLpsF/FGj4haxaQ?=
 =?us-ascii?Q?DltCESLaRuUbZ2zcYiYpfcGRBI5kDdI897CpsKgAEsOH0h+IjJnPIdnm9cY9?=
 =?us-ascii?Q?v/60dUPd2/kjv4sfYBgMs0Y=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d74b136a-9857-4a87-2dbe-08d9bedeb2fd
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:49:54.8203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cBWvsque/j3oP236bVMPEudHY0txY1TQYwo4N12ZLXeLzb3cJFwTveQTcVhuHzXkujAGgcPaFO6entFk/EEM1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2656
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112140049
X-Proofpoint-GUID: w6I0z0SRpK-R4UAImBrqW6n3jylWkE06
X-Proofpoint-ORIG-GUID: w6I0z0SRpK-R4UAImBrqW6n3jylWkE06
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS_FSOP_GEOM_FLAGS_NREXT64 indicates that the current filesystem instance
supports 64-bit per-inode extent counters.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_fs.h | 1 +
 libxfs/xfs_sb.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index bde2b4c6..7260b140 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -251,6 +251,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_REFLINK	(1 << 20) /* files can share blocks */
 #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
 #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
+#define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* 64-bit extent counter */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index b2e214ee..7bea660a 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1020,6 +1020,9 @@ xfs_fs_geometry(
 		geo->logsectsize = sbp->sb_logsectsize;
 	else
 		geo->logsectsize = BBSIZE;
+	if (xfs_sb_version_hasnrext64(sbp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_NREXT64;
+
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
-- 
2.30.2

