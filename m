Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9346EC433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 10:40:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbiCAKlG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Mar 2022 05:41:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234324AbiCAKlG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Mar 2022 05:41:06 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96DCD90CF2
        for <linux-xfs@vger.kernel.org>; Tue,  1 Mar 2022 02:40:25 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2218P1XY018829;
        Tue, 1 Mar 2022 10:40:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=8i80wuJdGZjCgjCDEl+rgyhwzqt6POuxXoXBttjUn6U=;
 b=omg+JpEJ8cvdXTAPGXrFgNGinBYVcOIfnBGY0vOCh7rT9QyEH5JnxQWM0KU5lPhR1xBt
 43esG8DkISOHKVPH1D/SstUg/rc+3d0ds7bgL+DrbhGu32i0SMvTR4E6DiKukSno8+SA
 A1Odx319E4Zzad0PmhmHMjVyTqfCVcQX/EBm4Y4uyDHKxA7GS8ov4IXgrceNxRPy14Bh
 lZGNGTZ/Z3j2YOkrcjUbKKhLTVxafvqSDluDsuXfH5sQb4m28me/lmOLBHg+/x8DfNlo
 fOPBXib5ZmQ1h7a9FlGEVzS7m8jmcxFOvoF8EnsG+k89cBY70A4KA24wM4McHyc6M748 nw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh15ajakp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 221Aanw4034080;
        Tue, 1 Mar 2022 10:40:21 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by aserp3020.oracle.com with ESMTP id 3efc14567f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=byT82g3xZrfvrhFAIhPyhw/sC5KwfhYla7+KcnLrmHvkJh+eM61QOuPSlxWNtx+TRkaBGNurV3C03TiOF2eC5XZ0fv2DvIxP8ySAMFdey/HOQKCDrPRr0HrXk6d9geOec/lEjqjLQIH/fjdVNtkCkniNmeRSb8Hx9c7podu8PYs14rbLdrbLSVXE+GF3gMdPbYHGlPoBvMlpBdt0d8gslb/H8qCX3hzHm5lSTIhpggQLPRbJ5r3fYVAB88oGJr5VkLbaeRYPPRaDklGxPm3CzEA4nQF0hkslPBiTRyHeQoEvKmk7nPZw5Vt55OwARSZgNDms80V7coP8fHrQP4Oouw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8i80wuJdGZjCgjCDEl+rgyhwzqt6POuxXoXBttjUn6U=;
 b=RFYxyalqHQi8hhgxB8T1QQhprgLpGMwr/AvW/b4A1uk+TS6Sf5z19ojFN5dwPFAOGuB5W7C6tvSqceraj8nTBH7nL9ZZSviKmUFJAFGIdf8rPiJb5oKWRN8NSACb60ugxgannaXEYN132HVQCFa3lKeKqkOUmIRFUN6LdlhWWFII1/6Flq3nR3JcSzFuXQI9J6YQOCTMnLg0W/Z8Yh4HF1ra1RIvgAW+fT7MZFSZ6JG+A86EP3ZkB+u133NA2AMthqU2JQo7FZ3hrLRxC3hqsA3UzgXyLLSWSqC3rGPIXatCWTDAgscdAWfLq9vw+sZLcidfDZoL3+wpE7uQ6n7y0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8i80wuJdGZjCgjCDEl+rgyhwzqt6POuxXoXBttjUn6U=;
 b=AB1Gx1NvqeM9ePI4Ibs1Im8mxenwZfhJA3NC5fZVhh0+iZJAKXjV230VnKWpJCbihay6DA+l5nN5m018kNEgryu/l+fXGEsFR4cfHQwnlpPSuhaZvF4QDkAakwCT53sONkHlD13ceghyRzjbU1Ji+cqTIuv39NXD1flwCCA4SxY=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by MN2PR10MB4160.namprd10.prod.outlook.com (2603:10b6:208:1df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Tue, 1 Mar
 2022 10:40:19 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 10:40:19 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 08/17] xfs: Introduce XFS_FSOP_GEOM_FLAGS_NREXT64
Date:   Tue,  1 Mar 2022 16:09:29 +0530
Message-Id: <20220301103938.1106808-9-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 72baf845-7b8d-44f7-45d7-08d9fb6fe178
X-MS-TrafficTypeDiagnostic: MN2PR10MB4160:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB41601306921B109759FE68A3F6029@MN2PR10MB4160.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5VPFAIvwwb+sbR2Kw2i0lKcM+WK5BqTkyoDyVuoPXLK6ClCMNVDQHJoZugFs9EZMlhXLo0xb7cfbJnUI5ooTwEeyE7wQkgCtMCpqrcVGsYcatTwoq4POREScGODIViBAHgwuUSc6erYHfHmHgp6Sj8WdPsk9RXF2DG4kprlWVkDAKbibZhLerdeINlG5SFqrYNeRgNfqoK3l8e+SU9x33jR3w3mF97YENekgSlopsFzaj6BKfQ20r8nk5RmQuJlc3Rv1RftlgAuYngN7kajnW/iSR2Nibs1edPk+LsmOA7xYhXwJU/90nkie9IOPjzFla6RKAb22g1aFUigqsgWl+3K392txLe06ZnPgN9MXIbOKtf2CS0eUMqI0G+zNw3fk7Cyk7743BkXPKenaV6Gx5oIfJ+3HUjyqlWjzlknModg6c8FHLjvaI5d0qY/hUHhJ+MnjKToiv2PxEvPZYBVoC89TdzWPii8RUASAz11CwDjC9k3aYtdfBL5VXS43+gXG/Ryt+CGGrHNDyJKqoMutErlXFJscW4HyR9UrAht5syvCzr3CEgPDHTQWmF5JM0ngpEwEJ3+kNmOwM7Xp9kW0yuyw/7Lc9DSLvZP9UlXIo7tszaUrzoWxOoMDpxGso0jTsBqxY+Y9agzm2kZ3GorNrn6udCOT3tRBkMy5Lkaxj75kIGu6PXUeZj+zQ4lGOflSisp860tANQC9g/U8ceNTNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(38100700002)(38350700002)(186003)(83380400001)(1076003)(2616005)(8936002)(36756003)(2906002)(5660300002)(66946007)(6512007)(6486002)(508600001)(6506007)(52116002)(6916009)(316002)(8676002)(4326008)(66476007)(86362001)(66556008)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?angNe0RrXIgdwAsusLkpAqzsqFXnQSU1Z1XW2+esp4ANGijT/NrYuSxDhcHj?=
 =?us-ascii?Q?8bDjLz2+3jTX+qB7XtOpn1SD4WQd3BZ57/IBFgfi/r1z6bXG9aysQuGuQRgW?=
 =?us-ascii?Q?F4dLMekc1yIt6R9UFuDxumVg/AG8RtMaDBYvBw7vDpOZkdKL+JCaBD1kcpuq?=
 =?us-ascii?Q?kkhsgX/ksIVr5ytotOhfef5174qKoVndA811gPdhUHZSzaG+eR1iE/U0XQsX?=
 =?us-ascii?Q?ME5gyKDEBfLDtCFglLjcMoBLLcFEE1In+vVZp0CD/iPsYzQV2+CBER98lRcb?=
 =?us-ascii?Q?C5xbqM+xz7PNOU0YTKzGG7kW4/knx2sURXjrbRvhLwCv1Ub29D82jXBMV/AA?=
 =?us-ascii?Q?379lIhF4VFGL7fHG0cZPG35EKWfK+U1r2I2maWWtDbakAFaUQPEFYhZzOGHW?=
 =?us-ascii?Q?mG7CZkUzXHTITU4aIoIElCRJdFIpiUqXqjnX2AtU3tI/kUxluF3jfbZK1hhW?=
 =?us-ascii?Q?AVOWkzg3CNmnZS2ddXf7MB+okNpzV/ojG5Wp/U4G7n/b1zYRZcs7JWS1J4vq?=
 =?us-ascii?Q?wju8M1eOuNfpOvPDuHkjNIMKsH+d8ah7PnOtOF1BCgivO18S5zYi3eq5Ze88?=
 =?us-ascii?Q?whuYLcbuGgBcMj+/knANmlgKwSzVjXAuqp9d4Wrn4S1ecGqXpQfm4CXW+8Rj?=
 =?us-ascii?Q?UMdj7+KSOneXS4cY4DrwxxTOWde3MJRGexdeH6Ej73Y3q1cBe2FJRUKeMiz9?=
 =?us-ascii?Q?2mN0zH8K5ifpMIU5cDjncz0D2i7P525145OnFQZnozrd93conkG2RpKkmovM?=
 =?us-ascii?Q?BHYWITJVGtgNU7Y9sFX0IJOOwVLMo4OQceMkvfppaqIbUMM+GIFhufmnxNRL?=
 =?us-ascii?Q?1XLlWLzApeYhpfthn7HWVQF9oy1m9IHrJEwvoz4jYSRhJkQbfg+SrXh7j6Np?=
 =?us-ascii?Q?Z8m5fsJrK1Wk2CrlhDwfLsATvADTU1m91HwafvQVDoUc3Hdm59vvEaSAm499?=
 =?us-ascii?Q?GfQVw0In2Gj0ezKzkTQ1N321bi4bSEWd0EyX4+w2cGrOREdHCzQpa7WYWgGT?=
 =?us-ascii?Q?Gnrlt/ALfzYP+obAWKQaiSlHTKc4MiXe+kmi8xdRlb2qGR/y6njkpOxDGU9J?=
 =?us-ascii?Q?pq1QmGvYEm5sT7wYEn8g8/0fjIPCnWzKPaejTui0gl7/5NANlzCGEeYh/45N?=
 =?us-ascii?Q?+cL7yyPbjbqL9BBbH4dyQsnDt+8EypNaw4ewRmV77M/NUsghXfS6LMkar/kp?=
 =?us-ascii?Q?mpOvI0OwMrbZWTw5X1plJi4EsfGZVrXRU39s/yc3ECbQ4CK54r6YCD7g71Kk?=
 =?us-ascii?Q?SPozEMnMZtd7PmVQVFPplNfFSxKL+XtuhsV6ivPi9GmdUxrKJNR+LO5bCEB3?=
 =?us-ascii?Q?btEMQWamPsrOJRV+3yDTmRGbLX0D/s97iHY4PIQJv9ZTvH6octocOZ4nyOL6?=
 =?us-ascii?Q?TM++DjjIq6YPs07QnIzwOmKfq3h/Z+QYtxWzv391b81up4HZUN/UZl20KQV+?=
 =?us-ascii?Q?m1NPeaWTgH1IgaHBXtGMAfHiLLN5lQaLctG+SY3jvr4pkLwcbVaNaVWR5Sfl?=
 =?us-ascii?Q?Cf/5LZpyt8ZTKxTbszSzemJ8N9nkbWQ40UNqphi8whVFRtKQlcFoIrUHRaNz?=
 =?us-ascii?Q?cXyh/nigGfArTynKvRLm6otFXK7Yzw9tY13hno9dXL3OnaSpTn6yFcK3+eZv?=
 =?us-ascii?Q?CsIxMjetrBWD1YpscREUrF0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72baf845-7b8d-44f7-45d7-08d9fb6fe178
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 10:40:19.3895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P5yDIoKMQwfvUWglw619qbNl6Vl+1Qc2xCuRHmpEMudnPMrokbLqu64XjsKMBE8ikmu857Xrq1/QS4z6auHJZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4160
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203010056
X-Proofpoint-ORIG-GUID: 1jVNHqtTxu8YSl0Szuht55DOr7VIHVDC
X-Proofpoint-GUID: 1jVNHqtTxu8YSl0Szuht55DOr7VIHVDC
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

