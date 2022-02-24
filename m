Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8343C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:03:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234739AbiBXNDa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:03:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234723AbiBXND3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:03:29 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2ED20DB21
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:02:59 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYaoL016939;
        Thu, 24 Feb 2022 13:02:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=8i80wuJdGZjCgjCDEl+rgyhwzqt6POuxXoXBttjUn6U=;
 b=yePxo+k1dCmJb/wz6ImA5sUNy0jd8+IhKc2tDrsX9//IrEeTOQ+OzPS5TWlar9xLdeoK
 0hhCF88RTwPfsvP1asXkc5/+LAe0Do7aaAeWd49e7nBEMvt7xn/UvGOrt3OkPD0fo40Z
 rXBm6+mmxEFGqzW8dH8GLJ0gI4cTuLffrLq6e3Co/KwZgU1cLhopOpeASqW7fyavldeu
 fltOFVueCF2x6gmPYrEXi/iILQyJudNg3d8BNyjF7PD0549S1iBcUX5LqZcGCIlUFj6D
 ew20W3btHMZkHKWRHPo02rYimoh6kuwZCXx2b6X/6k698o3gNiRP+0zc4tVBlGrx5nTr Hw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ect3cq4ce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:02:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD0wOr002426;
        Thu, 24 Feb 2022 13:02:55 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by aserp3030.oracle.com with ESMTP id 3eapkk41nd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:02:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n2LRO6vF0zaE2xGCU7zESHY2KINj5fLt5/qxMzb+ASyh/6+MnvjEGpSdOLT2EDO/9hRL4tImPXiGoiQS9Wk5pPxqU1SWmzGUpXFVAizvNEJGBLD0iXZTX9TdkiGzPYkYmD6Wfrb4E+Q0ZK2vt01EAUWsoagdL/923DjlK7gCQY3oq/SecOYA2JgSv1QS/bMSLAkR3XPpBXnZEOIMrVeqh8be8hBqfSOVQU0TGFSIa3CidcXd2UMWtNiDTKe8tCDE8vo35h5B3ZK6opBJqxTQtClhwukovcJU3T07YV+7BgRLG96l031dHitRy9aLKGifgv4/EWOZKJK9g69nLhiYEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8i80wuJdGZjCgjCDEl+rgyhwzqt6POuxXoXBttjUn6U=;
 b=F5HFqM8RCD/xTILtI4WY8gW3xnUrNpcMAh7BCraVqqjI/PHhUQE/k+87w7XHQL3nBQb+71xTGfMjJD+IBX4gJQKuk2B7uWO98e5IHaA+NOMkeiK6IjRH9PBHag9un/pqOvGzxA9LYQe22YFTwTXaGLbzSDCPYss36Vm0PTODlrnFCIizziK3MzlzXBTu8FSNXNGKOa1ZHtXS+IXwMucQHH1aemXnzJs+KybjZB+Ipcu2IZ1Byith3QZ8He4LNpaaFQmrHvU0J+qcS3DbE7RqK/FhpZj/AVJ7DPwJx7ia1r0WqmIFH+/7TMCP/A0tF50Dk6X9eKJLtd9lvRk5NXv0Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8i80wuJdGZjCgjCDEl+rgyhwzqt6POuxXoXBttjUn6U=;
 b=aVCpZg2CXefOPY7TO1+PB9IJ+TRu/bWYs5m7e7cvOyVcYdD0H0mWHdiQpDP3YBPc8ocIeQ/csTM0utgwGvSTkqB5XN3QPj8OS/4GPJPPHSatM9lciZefyQafUaUW0/NCS7NNTSFhJjLL/yXtykiHg+5biYj2qyxnu6U2aryXXhg=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BN8PR10MB3665.namprd10.prod.outlook.com (2603:10b6:408:ba::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Thu, 24 Feb
 2022 13:02:53 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:02:53 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 08/17] xfs: Introduce XFS_FSOP_GEOM_FLAGS_NREXT64
Date:   Thu, 24 Feb 2022 18:32:02 +0530
Message-Id: <20220224130211.1346088-9-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9310b65f-a224-4c63-e643-08d9f795f7e3
X-MS-TrafficTypeDiagnostic: BN8PR10MB3665:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3665CAA52BC6B2B70074A4A8F63D9@BN8PR10MB3665.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mu29b6IHo0GXMSS/LCEZw2U1/SPRxHe78baX8tUo2QIvEmQjPqnbbrtJdpHEH92ww+Gt2sKpARGfm/TvKk5gh/qa+a1RFha7+aJlp9XPcs8bYVAisG0bjWXzLxFc4nFWnGCUAw8HVrTLvIo9tykfTlY5SmecDG6C5HbuGek3sNc9M+XEd5pIyU6lAy7yThNCADnyge2WChCBNX+KC+aKeeh9tfMM0UKB3f2By6UXBs/n6jZLRZaL89/s5RFfMS3UJ/s3tDwbTMjlWdIeB3664irY7ppjSO24h4T8OXdWCKkxkzIQZhsbreC/BFkLPRCKaUBjCb5qCS2eJiYUb53E7XM8IIwsyaYiAKhrmGMvs2x4TRVdEBrvCHVuLwKyAbuU+3REHKkG87QxBKvc9ETDB1W3bGapgfB1ZHLSqusxU3sRYnMMbE5hWaW1ulLmvDWgRHXyngtzoo7oh3YYKheXQXEH9+n5o8Bmwe+WjMDmuSdT35DCYga9ET9ZDA6cVG3GTIqdwvd5487S3uP3MUvalY1rjajo3PlxsdwvMH6ElwcADzqAahshVrZ808LBdeuGmafgSatDGwH4+PVsST5vKKQlzDgXBxGq/qLqUexChAicmJqEv7YJDaik0cRqAv9o0GXGj31y5LwHFZk9PB6mY8z888gJd4Rtu+0ffDnsag7sOV2NesuXU6UR7OnFVXazm/xUXFKlv//GgpzXw1/cgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(6512007)(8676002)(316002)(6486002)(52116002)(508600001)(6666004)(2906002)(8936002)(66946007)(66556008)(66476007)(6506007)(5660300002)(4326008)(83380400001)(1076003)(36756003)(38100700002)(38350700002)(186003)(86362001)(2616005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?APNbhYzrXgTf9Y/i9055aTo+cxEuEk6VciQ0+rCGYH7//C5i8SkLHBuiqacf?=
 =?us-ascii?Q?fs6HBxiD0iIsMwV7I7t9ldlZ02/FqPdeuXj7RFM0RXeW14PilBYHNEfbyqVY?=
 =?us-ascii?Q?H5uDtSXCaGU9Bj0UgQjqFbok6uCQ8jFvfrNaHxfZIsR4fXCYr/OhWK2AuNtN?=
 =?us-ascii?Q?6rAI1sf4qZxUkLytPBxy4ju3oNSKFv5f3U7y1b9vEN+QMwz39x6FnsaxjbFF?=
 =?us-ascii?Q?Ky7JsEOXQ4XazAPLtONfP6moSonSltFlEFh7sUd74gXv6wLcgiqoQNzKK+Py?=
 =?us-ascii?Q?2X94oeqWfD9YUM+JFUXiuYUPTJTKAiIj6ckCAkOUCkU2YmXVC/Ww7kMIq5No?=
 =?us-ascii?Q?3iEdOpxxkkeqdPyhKbKhtLpChPY0rku42fqkM6W2rV9D4s+o/4ird066dnwO?=
 =?us-ascii?Q?vpGiG1ClY5oRETD0oiQlITZMuxYBWiWVEHxMhGig8WoXNPAiOccU6QMW4c08?=
 =?us-ascii?Q?Kzfo6n++Ver8BoqhPH0MXobNSKSasjtWRUHpoqH5Xx4BLN1n/RqwhY5GYzdX?=
 =?us-ascii?Q?Iil3j+DzpvnI/VECJGxKULAhpdqgMH5ivqrLEjr1MnYb/m3dSM9gwGeHLBJl?=
 =?us-ascii?Q?PeeTxDT4fOgGrrjh3hMbuRUutjlLBXdvaFI8o8iIl+JAODuiMZa3ZpSuJ7kb?=
 =?us-ascii?Q?+acxFfGD95fhBxSafkQKrEtUF7qgusDlqQ47FGU9M7AuTQZ1mJ0WTtv+nXfp?=
 =?us-ascii?Q?6CS2Tx9DpJRXtDsSj6nrRT3g1R2SCJGih+GY+/Gg3r/ICCe1NOHGgW7MBq0c?=
 =?us-ascii?Q?cB42Im3vcFFS1gnePH5oDPCblyMTJnnEiJrGjdGnWSUGVs2VZoiCyVesToVS?=
 =?us-ascii?Q?M/WzZklUjNqvx1HWewSQbzcrKgaWbfSoLzgo3LBA15+YF/fGnNAqnqCxbXKW?=
 =?us-ascii?Q?PuQv87HprMtJqsv8n1gyzP+OEM+AEv2OHWaBZI3nlqWwr8eV0lSXqvT3wN2M?=
 =?us-ascii?Q?QYnqCiK9vdWNHFLDrg2+Wa/zRfw4jW5VLRTSCnstBkINKUplu4TypMKTTnX/?=
 =?us-ascii?Q?hhbpwB+dJQyly/t0PkSoo43AkvYVkob70MPztI7EYDLJHnNhTB87tMQtwR7x?=
 =?us-ascii?Q?/pnFoJhmH7QN7vdQFJf2lPAbRXQpPIN4WTUvMsHW1J8il1b4M9xfKeHn7WMj?=
 =?us-ascii?Q?M9eWGsy77neTKMGqztQUzBm3TSmT318BlNYQhlVWMfeHiF00ml5ozZbnoUHf?=
 =?us-ascii?Q?JkogL2mbDoNeXjMW0izFqkZm+1WuS8H8UodHO99MyS80MuxmHUThO3Bwkq8s?=
 =?us-ascii?Q?eEr9huZlu9/YYlMNs5ldde8CK4YqAIPwiq2m3HxX5/Dp2kURfBpRRuDFuHPV?=
 =?us-ascii?Q?5VFQ+8JJRoDUZut+qf2AwjubNa18D23ckCOjANMwRv3Cl1NOc9zmop/kD1C1?=
 =?us-ascii?Q?8yyWdGKnDo3VmBgIwyiU6Tc+0x8uD0j5GXkWbSvXWfUqGdpebirkKaqDKRpb?=
 =?us-ascii?Q?Zy0ZI6f8flTLHOgTOcIe6dDcWxEMkunisoDxUFx7QLSIZ4I/CTnPXLgd2eb9?=
 =?us-ascii?Q?El0zGQwEw+4ofYfV1iGFDuzG0yGxrVNG2HJmeCg2FhsP5UDwP5JZ7u+fspSb?=
 =?us-ascii?Q?L3cJPcpXYi6hqXS+ZKPGS8Q7CzbruI9ZdV9S6wyIt+DGWc1SlihvpVry0KWc?=
 =?us-ascii?Q?kghigOncLarSBI2XYZeN0X4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9310b65f-a224-4c63-e643-08d9f795f7e3
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:02:53.1512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lOwjkj5COnLc1+2PXrLYlCTyTk6A5bjsupiFUKD5g2UUaUpPpn1RKg9A74jXueZLnbMJa2wgk+E5Hv+VvtYfaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3665
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202240078
X-Proofpoint-ORIG-GUID: gQLU2PmvWqsfFo6xUF78LVpmBr0jkRmt
X-Proofpoint-GUID: gQLU2PmvWqsfFo6xUF78LVpmBr0jkRmt
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
index 505533c43a92..2204d49d0c3a 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -236,6 +236,7 @@ typedef struct xfs_fsop_resblks {
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

