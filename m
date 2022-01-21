Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C89DC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:19:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbiAUFTu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:19:50 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:49186 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232326AbiAUFTt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:19:49 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L04vTS017314;
        Fri, 21 Jan 2022 05:19:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=oTciLkGT+OS1ABSDJnEnRo/X+nnnwRKaO3IX2C1icU8=;
 b=Glnt7sgkNXCnQduz6PjpXcQZ3k11lsJE7ei7Aat2FFD1Lvh1dUyFyQHGrqRBJeOL1cc9
 jDBzpx02soc8W+YynCwK32PxqpALym4ucXf6mu/okyglqALc7ur70ZGMmnZqSMu8XT4p
 tN5UmFMNLKfFh4cmEvA8zbfP+wwhIxsif11dRz+U//M+B8OD6oQUE6mmfo75Uxi9N3OP
 XPSahynKzeciXA9CZ51hda9UQplt/gsdyeIgBqkVXigYPr8m/odurNs1h1PJltiYdQ34
 MfvPcYKy8av0xtkE+ef4ozC9Ozdg5kp0aCiJpf/4tKTdVbvPK/iVSAvBcGAXeIsO9LAh 0g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhydrc6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:19:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5H1Mm018897;
        Fri, 21 Jan 2022 05:19:46 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by aserp3030.oracle.com with ESMTP id 3dqj05h2vy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:19:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AC2SD9mVJyBDcA1JT8EPfkETeCasCTLuswu72AITy/hMaqrUys71dGbij5Sv9iD3kH4BGOsJ4s11DJdqJI40+MGFvicko4oSCJVbOfENWlci94PQNntGp6k9iQ4CMQdXI25OkEmPoKPI5uqhXBL6FbaeOQSQX0v65PR5WTT1RxKMgGMaTVfD1yrx7hzfo0qrIUu4gZQsTllIuUbW4+wkRF1yfPtok9BR5InARzetswlJdP4mPojZSjDDYSKxd9YEHyLad9UFhFL0P/xlVI/2ZtEBK1/Y97bOtBfnVL6mhAK/o4d/XWSqf84egabW0FVSK6Q+DCUZu4RfH3Ib7ESC8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oTciLkGT+OS1ABSDJnEnRo/X+nnnwRKaO3IX2C1icU8=;
 b=DxwFQ4wZkhj6S4e3OTkj/+tJyTF5K0JEw5uvJMBuhjLbAsPC0TQg2NJLyU7vjr620JzY6jm4GlIiSlcrQX04LMHnIXtEXRQzmlPRQDSp9/Y7t91ZeGCpmceBb0QEJqhwyp2AVpOW9zxYD3eZ1IJV7d0uoBmySnKUoSNCb0AemU07n1FedcWJl/kXHlfVJauGsj4RwDJyWGbMvLdpb56f3atR/RE0JlzcxOAWTX7fmPvoW/zGfCGh5KUrXxG4u4hbaJ9/a8APDtR9A0Q6SQkcxrye1sLGpDYXPJYDjivqAhzSsE0B52hx6PckwCQKEGDZWbIYVWak5QQcBIjUb0Hy9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oTciLkGT+OS1ABSDJnEnRo/X+nnnwRKaO3IX2C1icU8=;
 b=Kpn1qJoPKZxcuRKwfMAKz4RGJLWG9ZuijddLdRc4MFmp1RMYLJSSm5ybWeRJRZQ5mp6l4I4Cg3LF4EzDbs7Pg+/HHlSLWM82HPcbOl1cLesIS/9PCcdo/FgavejjhOGa9ssB6x49S3UlV+I5wPNUH4B6N2wQv77rKX2sMi9ZUI8=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by BN6PR10MB1236.namprd10.prod.outlook.com (2603:10b6:405:11::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Fri, 21 Jan
 2022 05:19:44 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:19:44 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 08/16] xfs: Introduce XFS_FSOP_GEOM_FLAGS_NREXT64
Date:   Fri, 21 Jan 2022 10:48:49 +0530
Message-Id: <20220121051857.221105-9-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 329ae906-c352-41d3-eb7a-08d9dc9da246
X-MS-TrafficTypeDiagnostic: BN6PR10MB1236:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB12367265D2C8748FF4040376F65B9@BN6PR10MB1236.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f5TnQJvNAQkJr0Mf06olVKDjRM029c9ejfHcwe0fM48MMH5xq2V1yK8VpPmZLag+2EJglMTtiE2/EjCKYfCN5s5TUdUArQ8dAVM2JlfqMBk7fFYiNc64V/m3nYDTDiZ1twtW9dwuLdwrlSUoSVlMMq6+NwQZHl0vPP7RwqFuTUcuzR42nudy97p7HT9pKJC864GbC4qsdAHMsq5ERTQK7Fie4WMoeWAU1cv4ZUiCbtdHoYw+Av6dtj5J0pvliI5oECQbdaCeH6kyoRIrah3jrXKXr8GmmTLrVdZHv8wcvzBF24K9643b0tlUGCHquGVWWiX3LnSeWgyJuiHoAs/BHKRbkNRzwpDH9Gath3mYuRguhh8Di9MAt6Ljswm4iooYCsVIPypNH+7miuhk0bM5JQt5zXwBuBB6tTUOzwz5D+tAM4gtX1V3r4fTpbqSnfBxiItHVA0Ft1C7tRuMlq4CBvOgnWWE0kPorLo1fhXkE3wgtNl5YafiwW3nAkzGMgVmQNGVvmppww1ZjoXxT6/YqnKJIIeZeKbzEXzPe10NP/zDxdiJ27Xd/zLch79S5JNyJFEpcM/hcju2fJFOYUmX/S5M5AKnOowL4m+A/cM3K224y32n5iRXEZiyNeRAkk/DLNTkMav//dwA0UmGtcWex0KWN0pI7VgYGUlE8JaTndfDfPkyz/sT9QgCcSS0yh0BDVBG3liAMJhLtgxwHti9Qw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(2616005)(6506007)(186003)(508600001)(36756003)(26005)(83380400001)(6486002)(52116002)(38350700002)(38100700002)(86362001)(2906002)(66946007)(66556008)(66476007)(8936002)(316002)(6512007)(1076003)(4326008)(5660300002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CdZHJf3TzXyenG1MtSzd4y1SDWd2pevhNEsYbqT8br3tMzNXZJM+jLMASZtI?=
 =?us-ascii?Q?6GCv4gsRkc3PFEwESc2YSFUXVPGkJN6xBRoU4r1xMaRGO6pAfJZUCCUODHrA?=
 =?us-ascii?Q?lTUrvd38FFTiSOcx7NYnL2yGHM90mcguB3IBx27FyK2vUEYu8GQ4T4+s2kRv?=
 =?us-ascii?Q?HWcJo9JXv3tG9ILvhfbdl6PXp8hplwPJiSMW3pxnvBZFKaOQ6t6qUmo2UKSN?=
 =?us-ascii?Q?/SVMjlIrsbhKpNFJ9w86v8T4Z6hCty//T+rH6Rf+p+urz7MdkjN5aUXZJ6wl?=
 =?us-ascii?Q?jVKpJEQ4sHJsWZFTU2qUbOfVv6AX5/YYDGiv0QIf0jmgSx2mVo0oH5+p3I22?=
 =?us-ascii?Q?bzmlKm5u/BR9MsC/cQb0Uj+F9YmSWorM7uCanwg8X6oHFzDc1KVH2u5tBEdG?=
 =?us-ascii?Q?mJYDHdEXINhxPHvZ49dpgXqM36m2dQH4daVS+ohEqoS66m3xVV/ahfippmjx?=
 =?us-ascii?Q?FrTPdZQgatf/ZH6fp6m5+9UFSXQDyvnuqqBX0REUaYUUp6YLhjE4uH15DQsA?=
 =?us-ascii?Q?xCJdJr8drWlhGP7beKB0klGy/kiUfZmBx3mCAzPWmd1rLx/2rJXeYZc+38AZ?=
 =?us-ascii?Q?jjAg8EWldVoxq0Eu5wTqdjxUhyFD/W0dCtHVT8dwy+qx1ziDEFUoUVk/0v5/?=
 =?us-ascii?Q?ur/ET7wCeUFQ8k8VcpFinVNipgnD0M63t1IoDwIkElVV4m4JGLlU6dvjQLQ2?=
 =?us-ascii?Q?02BzKDDaQxvaCiiaQMzCp5v2f+tfe6c9dPWdmlRn19Ayh0En3qCyHPN32ucs?=
 =?us-ascii?Q?7zc7womegUBax/OLUO5/yC8SqzE1ulSWn7Um+AH77X7KSZmkdWm1kuYTkoy5?=
 =?us-ascii?Q?HbB8OY01QrrZU/In3lQXvK4gmM12Uv99O8ItrR7TqZUzuaMq6aYSlqegpNQP?=
 =?us-ascii?Q?bmQX7sLZ2h+Fy1Yuba/aUfJ5mBJip2WAjBI1DxtUPaBWStJftFGA2fzYfV80?=
 =?us-ascii?Q?Qhh87UvXhR/X3WhvFdGXnhe3f38Jza4tM7dtBkRs6+hpR6wqlsNoDNOLLELm?=
 =?us-ascii?Q?dLzUplBNCO0pXV0PNBW7+/YQjzjEqERW7/ZnKMUUWBhVTG5wYqmY9FDC64Lk?=
 =?us-ascii?Q?YgfLNZMHEeyx9OIwpUc2U7ezPx7t7aJuZyE8GYafqRDDgACJ9y5nSg/8q0WC?=
 =?us-ascii?Q?PNLa+WNdwJiwPyZONIOcmOMm4qCCr5p1uGV6J9GWf5CoGApJBTId71m26Dvy?=
 =?us-ascii?Q?VxtK22Fmjjnh/DITM9j8YkE2YtED3oOxG7a3O2y/Du0rhRj3j2/Da2A4VtDE?=
 =?us-ascii?Q?VNHeheJlaqioxr9nSsHXxcKBkeDhizMOcBmfKkRk/Ncw907cjaW7J5gMuEa3?=
 =?us-ascii?Q?xQJqCp6R6y7dKVEKDvOm1ZeR1hJZc79qK7IFlV60IOiWCvFck9nkve+m4YyU?=
 =?us-ascii?Q?BmYcvDjV83I6rKJwnP6OlLm4NsCgcn32i3YPTajJlwNYrn522Vg1UkKXWFea?=
 =?us-ascii?Q?vMlRASl+B4+Vwy9UbBQlZBxfirBm0xmP+yr/lBlbw7szDFzX6YFjwRPhnHSc?=
 =?us-ascii?Q?MWbpngGAauET45x9VdjGQjYMhkuRRSpOE30p5q3nwEjiSd7K+Y0V1Hp6bScN?=
 =?us-ascii?Q?dXOps85f9tN/nqgMY1mRPBVbEjfUx7QLTRIC+4n/3acjxVAN/3ZrY6/zIQUt?=
 =?us-ascii?Q?uksDiTTwRxytuI8Atxg1i2A=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 329ae906-c352-41d3-eb7a-08d9dc9da246
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:19:44.3293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nBYLp5RSafoEEnwYdbAj2ALYJWB/APVE8f68OIAtr+gUO1ecmJr5DvnMeQrjLkfr809CERPLVr3qb6fG02a3YQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1236
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210037
X-Proofpoint-GUID: Nb8WOg8FITdZphidtzcAs71l3gC1G2D8
X-Proofpoint-ORIG-GUID: Nb8WOg8FITdZphidtzcAs71l3gC1G2D8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS_FSOP_GEOM_FLAGS_NREXT64 indicates that the current filesystem instance
supports 64-bit per-inode extent counters.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h | 1 +
 fs/xfs/libxfs/xfs_sb.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index c43877c8a279..42bc39501d81 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -251,6 +251,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_REFLINK	(1 << 20) /* files can share blocks */
 #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
 #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
+#define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* 64-bit extent counter */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index bd632389ae92..0c1add39177f 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1138,6 +1138,8 @@ xfs_fs_geometry(
 	} else {
 		geo->logsectsize = BBSIZE;
 	}
+	if (xfs_has_nrext64(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_NREXT64;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
-- 
2.30.2

