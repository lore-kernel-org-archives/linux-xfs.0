Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9E1CC76196
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 03:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjDKDgM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Apr 2023 23:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbjDKDgK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2023 23:36:10 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00529172B
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 20:36:08 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33AJPedU012830;
        Tue, 11 Apr 2023 03:36:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=uy8cwkSapqeLG7O0T8KVNU8QMp0397fpnfZmGUMw9Vw=;
 b=20xILHks3avIr5hjNEoC1Tppn25okSiaswmTudWs65IWngqie8otPFw21qfgcLG7e5eN
 dC7EAC368aaHpiKsOooBow/CG4JFciR0XRSGOhZp9V+UDyzHmSEPplV+h1TZfI6mrL2v
 Q5a5JyRJjIcr7vPGkfYhypOeo6cvpFQriSTmRJ0d4rZAtygoeHElAUR4sI9BKdvi9fT7
 SdG6puRO92emK9Ps7ZqQZtwNFVZsgKy0DxtiUtoV1b+H9+2HBBvlULI2Qc2NW9PgSx6N
 MopFd+IZHIPGA4V2tFkDxNozs65ZSvf+YLuV9/yguAJQr3lnoMNCfa0xwrP/lCLBPipZ LQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0ttma5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:36:05 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33B3ATDP032604;
        Tue, 11 Apr 2023 03:36:05 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2046.outbound.protection.outlook.com [104.47.74.46])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puw909a93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:36:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PxPLV3ktDZjaPzUH20KNV9dCGe/ybxRJbiAEpRB4yuzExP4DxJG7nqd3F3RYGKBMbN3yaHSbEaZYpP5IeGPvn2l5Uj7dYFiRxcBHhlGLcErFN6LkU20J2HZ2Y92D2Ob/ZpiwvWiOSR3j++/cevpi81/7nabHr0bTdVVpJQhM4JIp9Pp6hSm4hZJFyTQrNEBzxp7jaAPJl8HFWMyfUqmFuGChtsIGxBM/ks3VpDDTx8pwTNmlv/wFIHNTNL4BqJWw3GvBDfW4zSoDY9GdLld8G1/iqLpLBY+oNB02YTpXviUftQsM6eGt8fJoMLoEvPu2uFCnB1xR7iDrTt5CchtJWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uy8cwkSapqeLG7O0T8KVNU8QMp0397fpnfZmGUMw9Vw=;
 b=H4P30DYKbit24e72C+DbyGU2By/nh50cJsUCi93GkX+kzjhew7zx76iDFupwTnj/NS1bQPKNJdgQD5QrB2eVYN8dLVK/9c37K56qnDEb7uWmqyQ7A4+VCvVi8/Ei0VCsjYNf+Ez5xIx6Nk1mpqjaJxLCntJ/HZtfYyO2rUcDfa/I09D8RHkiBOA92cdH3mRjp+8GYIfRm0O0lUsyiN6DDuyGegMdUb7LVbhnNJ8Z8i2Fh1LQNKMBhMrRbvleI9oly+A0H+mppz86QDQCs8aXbpJ0ozS52u/dy302XELTQhjhOapmCEnujkZysy4ID5wKopLAa2Ee1cQaV8sbk90oJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uy8cwkSapqeLG7O0T8KVNU8QMp0397fpnfZmGUMw9Vw=;
 b=KHzp2Ee/iNgxe4rK24Hm+HorGWt57jUHXkX4f74M3PvsXpG1tnfb8iysnWsUiCko9YsritAQ33tHc7bLTtApNCW+CvPrGdlVUnv9foxNIabbNM23dxLh44aD4AnRim71mK6lFelD5U4nE8a+ICBv2rcuqbar9f6CnP5m6wSvVhM=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by BY5PR10MB4338.namprd10.prod.outlook.com (2603:10b6:a03:207::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 03:36:02 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 03:36:02 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 05/17] xfs: remove the kuid/kgid conversion wrappers
Date:   Tue, 11 Apr 2023 09:05:02 +0530
Message-Id: <20230411033514.58024-6-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230411033514.58024-1-chandan.babu@oracle.com>
References: <20230411033514.58024-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0052.apcprd02.prod.outlook.com
 (2603:1096:4:196::18) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BY5PR10MB4338:EE_
X-MS-Office365-Filtering-Correlation-Id: 388685c9-86c6-463d-f879-08db3a3ddf60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TwgkVYGBrYzJLZ+5K74ojExp2Jn/K+n6Knu5s1fbSzSu7NVil/kCmwVs72zLzi2WGwrcSfRCYsjNPLiOZhwSPaXNlJt+upJewDrLaYyQ9zs3ftX6HVxHeZp7upw1qYWg77m/95NhvwaW1OtqvwYTM++7ZdeGQCzuUjFxkWF/vnMLYZdMI4yaDGODlkbs3q9k4PMfutQvOg5THmy22IexT+XCB3HpyfiJY/Q+7XMzxu2Kf+N9RyiD3/RVEX+OftW0SU+a+T6FeyS7LcwfGE4hPHPWp/xcsFx6ax+ivDWM5Xn7vkSDZ1xGD+m4QApAHoDmu4Tig3BhPtT3YoVogl+izTWRF3GwUneZexmBEHL9bJ2LCH2osPVU56ENqocDbIqmtRtIo642ItsI0r0ppwIJdaP76vf47ro1o++dkvjRg79q1haYp+lsoXfw6a/feJ5zPEn7i0y57ALbLnch2qsq+gfl6Bux8ILm1wO1eSXJBNRZmmVS8/Jn8mGuE8v7riUDvLX+RHBt5dvc2WrIkoN8Hy/2/7UlLsN/UfxtB0lfiAizvU2DIKdf2khh0JDLuE7w
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(376002)(366004)(39860400002)(136003)(451199021)(478600001)(1076003)(6512007)(316002)(26005)(6506007)(186003)(6486002)(2906002)(5660300002)(4326008)(66946007)(41300700001)(8676002)(6916009)(66476007)(8936002)(66556008)(38100700002)(86362001)(83380400001)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xicvr7+L8va9HiwvFQ5hwTJSSLSb9pmTp+S1y2UQEhWh153T1uWYiocvaMgh?=
 =?us-ascii?Q?7my4EeJ7kpqqx0eFyaEjfTsLkzQ5M7B26iT5G5TXUYk2HvR7rMfjOD6Adsfx?=
 =?us-ascii?Q?x9PHusE8dYclsc5qsVl/gLAJui2gIilRK8jE8WNB6cT/bnpjWn43+vKHCYRY?=
 =?us-ascii?Q?y41bUyMOv8bWnm40RmnjJAN8daHQZG/33VHVWL0uBBYyrKbHtLsz+ts+LR0r?=
 =?us-ascii?Q?jsthu8mXiULYxz4cWSh4CCm+EezTgwyWOtnPk+nksL4TJmnK4CPg7oNgExBh?=
 =?us-ascii?Q?Qt8ZgEA+WvNCPqEXUoPzXNXwdICGx7v+Rcj2cSRVYqAO/Ppb++Nxir3dcJ+U?=
 =?us-ascii?Q?djOByKNN3q6GYAN7bAHlzVQPh7Kk+rngn65iUOhF5l50IduXk807CSPaXeFk?=
 =?us-ascii?Q?pZmFM/pnny5UtTyrvFo78uvYBbSAlhKde09BYqXTB30KCNulGapTE3bCNHka?=
 =?us-ascii?Q?dSyO1o87CtdUd6aWmX5hCPYThbRIC2J5Sw2mZY7JUSScMBT4kmmD2iJBNwo3?=
 =?us-ascii?Q?c+pCCjBb1gG99Tko00NLKPJBj4JQsi3N5aL0LlJ9F9nlk9PEzPMa4lEzU8/C?=
 =?us-ascii?Q?m1w2Ll6FATZl3MXCCfnCBv/Z22vPc9ieg7sFmScqhQAspo9W1IZscbr3SOKv?=
 =?us-ascii?Q?Y3cYC/NKHu1Mf0ryVx/NF3S419+tXGWh6fsComJj8r5nQaVOnnp5fYRFCzrj?=
 =?us-ascii?Q?uWFkn1yMk2huR7y1qj1vNYtNgWUz/QfzuMIlrsaEZI9wPnOrg85J/Zkh3NcN?=
 =?us-ascii?Q?J5RmYQG1zjdlPWdW+lZWyDQsuYEPhxfTtc3NiaI6YYTQyHZCaT2p8euN9twM?=
 =?us-ascii?Q?al50HsDZgLet9FKu/qdFiDE59DMBjYq466aHET+PQombo/6jXtLTcz7xA37c?=
 =?us-ascii?Q?kEoKJIigjiQkoPAtlPQBI3K+OXKFHkF0yn7clcXxCwU2/eIltrE7+jExNoWb?=
 =?us-ascii?Q?sASYoteJs/WlvTsBvK9j6dj9Na8lX/EUBM6wjEGvuwHjt1Wj4Ad/rTUjz6AQ?=
 =?us-ascii?Q?kqKf6JjywonPd8J2d4aWMA5bfoUEzphEVBli5Sz0BeL9Wx6VHhXafz9rLZg9?=
 =?us-ascii?Q?KErqI2GGIOwYFaZr6L+xR4Se7eA2oXDSd06wIRD3kcTem9EX1bQawivjB1EV?=
 =?us-ascii?Q?5TTspazf2aUxPwlrUknU6/JIS/ZqcoaNt22S8OvaVs4Gb53/EVD78vDQ1B/J?=
 =?us-ascii?Q?cyqaArDw6q71yB333pFKeD8gyxYFuT7bABvGyIrF2jgRGHKLBIVioNvDenhX?=
 =?us-ascii?Q?zqxiuGsqnwmA0HzX1JTDr9aLRCbC38aeHcncH/Sdids3rxcbOOZ8PpZObHcD?=
 =?us-ascii?Q?3DptVr/0/VTEgqhIQOy3NQwCoEF6KGSvPmkTZhjne5i2cp9HpmGZaMjPSZJ+?=
 =?us-ascii?Q?h/vitsPaYfiElKCC9F6fHCGKDXvHD8l9F68AnVYHj0PRb6WJ6xqlICEnh1Am?=
 =?us-ascii?Q?IN7DpgcJ/rgsZSgCfsSbHX4OIeinlw8W7RxkCgAg5tDS4KFcUXDXy2/1DVKd?=
 =?us-ascii?Q?ckRqFv8F6964abz4YtbzjLRi1vkGb9xnw/wjgj90afMjhq9W8DPfogEY5Jbr?=
 =?us-ascii?Q?8qt1vstdoGW50ezkb7mTwvfvW1sh01/NfbiB6Eiu?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: rTPznEn97n2qBJsY5UmeDEbQUnipI8q/rkIY+/E4CI8qGPxKZyaP0GInB5Q5GbZBRguRgQc3iJFcLFOFrqK+Sw+eragSGNWBh3IelBi1xYRGjpznC7nQaCEze1TpegMbJDY6WQT/0zpMusYtz1XV+Er0oJO2rnNmndc37SzA1k7Rh9bY5m+QuR+aQVc/N1jz/maDDXuQ/kuKnl2tNZ1PyoKfGFDyw0D33zCfE/8wpzHdxT1Y8s2YGTUa4PBEUx6RDgO6raMt6GP6CYrjGTAWCKVFQxgnqnSUxOTKnT6HEyPrxLQ4J3NDWrYwDil8xDaDH2HU17YkrrftmSg55amgvAj1HnWW6YPBAZpfhEdMkfqYzIoSNWL/ZQ8B1mnnUWDwuZt41yF9zyLS+xblwC2NEKIRplRHcl7MhPD9+ATXWkunmal23vx93Xf0Sgr+4AhpjYU0dT0bAf/PRW3w5bes9zFEtCed21WVxiwXhDf69SL4ORcEhR+0JAZFMG0BedZoaUlDbnIArsmehllVCgUt1gQl3FLRQQcXuRguvJg+Ta0Eflsf317cHFdHaJqytj9ZZSOm3V+dIBpxY5Y8DhlOAuV7kB14xFzbndhehpj6XKPKjVKb+n8UkjAIYgR6oGuOOqN0XNH22XdAA9EoD0zLOozxAZahRSREWp6KWPhXWjrtrl5x7KRvwwJCsqEb6Ga4L7JUPvSUmONWmi3HGVnh8/X1DnQ8jiffmQc6vScdVF1Ve3VPh5gALrsUyfBb5IxlZ0GPbHMF66CMxmdp+pDFmzNTZVQvf3ucpigroDfXj7UIepFdjKuymSWM49N8wo5e
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 388685c9-86c6-463d-f879-08db3a3ddf60
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 03:36:02.0903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uqdNToEYHK52WUyj+Cm4orUmIJdCeFsBTQ2qBzEwEWdr9fwVBIdx98jzmNyv5YogYq9CTVXUgr6ZxWyPgsS62w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4338
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-10_18,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304110032
X-Proofpoint-ORIG-GUID: ejO9qldn37Oy2RdJlAw3j86l7Kyy-GEI
X-Proofpoint-GUID: ejO9qldn37Oy2RdJlAw3j86l7Kyy-GEI
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit ba8adad5d036733d240fa8a8f4d055f3d4490562 upstream.

Remove the XFS wrappers for converting from and to the kuid/kgid types.
Mostly this means switching to VFS i_{u,g}id_{read,write} helpers, but
in a few spots the calls to the conversion functions is open coded.
To match the use of sb->s_user_ns in the helpers and other file systems,
sb->s_user_ns is also used in the quota code.  The ACL code already does
the conversion in a grotty layering violation in the VFS xattr code,
so it keeps using init_user_ns for the identity mapping.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c |  8 ++++----
 fs/xfs/xfs_acl.c              | 12 ++++++++----
 fs/xfs/xfs_dquot.c            |  4 ++--
 fs/xfs/xfs_inode_item.c       |  4 ++--
 fs/xfs/xfs_itable.c           |  4 ++--
 fs/xfs/xfs_linux.h            | 26 --------------------------
 fs/xfs/xfs_qm.c               | 23 +++++++++--------------
 7 files changed, 27 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 94cd6ec666a2..947c2aac66bd 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -222,8 +222,8 @@ xfs_inode_from_disk(
 	}
 
 	to->di_format = from->di_format;
-	inode->i_uid = xfs_uid_to_kuid(be32_to_cpu(from->di_uid));
-	inode->i_gid = xfs_gid_to_kgid(be32_to_cpu(from->di_gid));
+	i_uid_write(inode, be32_to_cpu(from->di_uid));
+	i_gid_write(inode, be32_to_cpu(from->di_gid));
 	to->di_flushiter = be16_to_cpu(from->di_flushiter);
 
 	/*
@@ -276,8 +276,8 @@ xfs_inode_to_disk(
 
 	to->di_version = from->di_version;
 	to->di_format = from->di_format;
-	to->di_uid = cpu_to_be32(xfs_kuid_to_uid(inode->i_uid));
-	to->di_gid = cpu_to_be32(xfs_kgid_to_gid(inode->i_gid));
+	to->di_uid = cpu_to_be32(i_uid_read(inode));
+	to->di_gid = cpu_to_be32(i_gid_read(inode));
 	to->di_projid_lo = cpu_to_be16(from->di_projid & 0xffff);
 	to->di_projid_hi = cpu_to_be16(from->di_projid >> 16);
 
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 3f2292c7835c..6788b0ca85eb 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -66,10 +66,12 @@ xfs_acl_from_disk(
 
 		switch (acl_e->e_tag) {
 		case ACL_USER:
-			acl_e->e_uid = xfs_uid_to_kuid(be32_to_cpu(ace->ae_id));
+			acl_e->e_uid = make_kuid(&init_user_ns,
+						 be32_to_cpu(ace->ae_id));
 			break;
 		case ACL_GROUP:
-			acl_e->e_gid = xfs_gid_to_kgid(be32_to_cpu(ace->ae_id));
+			acl_e->e_gid = make_kgid(&init_user_ns,
+						 be32_to_cpu(ace->ae_id));
 			break;
 		case ACL_USER_OBJ:
 		case ACL_GROUP_OBJ:
@@ -102,10 +104,12 @@ xfs_acl_to_disk(struct xfs_acl *aclp, const struct posix_acl *acl)
 		ace->ae_tag = cpu_to_be32(acl_e->e_tag);
 		switch (acl_e->e_tag) {
 		case ACL_USER:
-			ace->ae_id = cpu_to_be32(xfs_kuid_to_uid(acl_e->e_uid));
+			ace->ae_id = cpu_to_be32(
+					from_kuid(&init_user_ns, acl_e->e_uid));
 			break;
 		case ACL_GROUP:
-			ace->ae_id = cpu_to_be32(xfs_kgid_to_gid(acl_e->e_gid));
+			ace->ae_id = cpu_to_be32(
+					from_kgid(&init_user_ns, acl_e->e_gid));
 			break;
 		default:
 			ace->ae_id = cpu_to_be32(ACL_UNDEFINED_ID);
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 14f4d2ed87db..672286f1762f 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -859,9 +859,9 @@ xfs_qm_id_for_quotatype(
 {
 	switch (type) {
 	case XFS_DQ_USER:
-		return xfs_kuid_to_uid(VFS_I(ip)->i_uid);
+		return i_uid_read(VFS_I(ip));
 	case XFS_DQ_GROUP:
-		return xfs_kgid_to_gid(VFS_I(ip)->i_gid);
+		return i_gid_read(VFS_I(ip));
 	case XFS_DQ_PROJ:
 		return ip->i_d.di_projid;
 	}
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 91f9f7a539ae..9d673bb1f995 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -308,8 +308,8 @@ xfs_inode_to_log_dinode(
 
 	to->di_version = from->di_version;
 	to->di_format = from->di_format;
-	to->di_uid = xfs_kuid_to_uid(inode->i_uid);
-	to->di_gid = xfs_kgid_to_gid(inode->i_gid);
+	to->di_uid = i_uid_read(inode);
+	to->di_gid = i_gid_read(inode);
 	to->di_projid_lo = from->di_projid & 0xffff;
 	to->di_projid_hi = from->di_projid >> 16;
 
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index a0ab1c382325..1c683a01e465 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -86,8 +86,8 @@ xfs_bulkstat_one_int(
 	 */
 	buf->bs_projectid = ip->i_d.di_projid;
 	buf->bs_ino = ino;
-	buf->bs_uid = xfs_kuid_to_uid(inode->i_uid);
-	buf->bs_gid = xfs_kgid_to_gid(inode->i_gid);
+	buf->bs_uid = i_uid_read(inode);
+	buf->bs_gid = i_gid_read(inode);
 	buf->bs_size = dic->di_size;
 
 	buf->bs_nlink = inode->i_nlink;
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index ca15105681ca..f4f52ac5628c 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -163,32 +163,6 @@ struct xstats {
 
 extern struct xstats xfsstats;
 
-/* Kernel uid/gid conversion. These are used to convert to/from the on disk
- * uid_t/gid_t types to the kuid_t/kgid_t types that the kernel uses internally.
- * The conversion here is type only, the value will remain the same since we
- * are converting to the init_user_ns. The uid is later mapped to a particular
- * user namespace value when crossing the kernel/user boundary.
- */
-static inline uint32_t xfs_kuid_to_uid(kuid_t uid)
-{
-	return from_kuid(&init_user_ns, uid);
-}
-
-static inline kuid_t xfs_uid_to_kuid(uint32_t uid)
-{
-	return make_kuid(&init_user_ns, uid);
-}
-
-static inline uint32_t xfs_kgid_to_gid(kgid_t gid)
-{
-	return from_kgid(&init_user_ns, gid);
-}
-
-static inline kgid_t xfs_gid_to_kgid(uint32_t gid)
-{
-	return make_kgid(&init_user_ns, gid);
-}
-
 static inline dev_t xfs_to_linux_dev_t(xfs_dev_t dev)
 {
 	return MKDEV(sysv_major(dev) & 0x1ff, sysv_minor(dev));
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index c036c55739d8..6b108a4de08f 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -331,8 +331,7 @@ xfs_qm_dqattach_locked(
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	if (XFS_IS_UQUOTA_ON(mp) && !ip->i_udquot) {
-		error = xfs_qm_dqattach_one(ip,
-				xfs_kuid_to_uid(VFS_I(ip)->i_uid),
+		error = xfs_qm_dqattach_one(ip, i_uid_read(VFS_I(ip)),
 				XFS_DQ_USER, doalloc, &ip->i_udquot);
 		if (error)
 			goto done;
@@ -340,8 +339,7 @@ xfs_qm_dqattach_locked(
 	}
 
 	if (XFS_IS_GQUOTA_ON(mp) && !ip->i_gdquot) {
-		error = xfs_qm_dqattach_one(ip,
-				xfs_kgid_to_gid(VFS_I(ip)->i_gid),
+		error = xfs_qm_dqattach_one(ip, i_gid_read(VFS_I(ip)),
 				XFS_DQ_GROUP, doalloc, &ip->i_gdquot);
 		if (error)
 			goto done;
@@ -1642,6 +1640,7 @@ xfs_qm_vop_dqalloc(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct inode		*inode = VFS_I(ip);
+	struct user_namespace	*user_ns = inode->i_sb->s_user_ns;
 	struct xfs_dquot	*uq = NULL;
 	struct xfs_dquot	*gq = NULL;
 	struct xfs_dquot	*pq = NULL;
@@ -1681,7 +1680,7 @@ xfs_qm_vop_dqalloc(
 			 * holding ilock.
 			 */
 			xfs_iunlock(ip, lockflags);
-			error = xfs_qm_dqget(mp, xfs_kuid_to_uid(uid),
+			error = xfs_qm_dqget(mp, from_kuid(user_ns, uid),
 					XFS_DQ_USER, true, &uq);
 			if (error) {
 				ASSERT(error != -ENOENT);
@@ -1705,7 +1704,7 @@ xfs_qm_vop_dqalloc(
 	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp)) {
 		if (!gid_eq(inode->i_gid, gid)) {
 			xfs_iunlock(ip, lockflags);
-			error = xfs_qm_dqget(mp, xfs_kgid_to_gid(gid),
+			error = xfs_qm_dqget(mp, from_kgid(user_ns, gid),
 					XFS_DQ_GROUP, true, &gq);
 			if (error) {
 				ASSERT(error != -ENOENT);
@@ -1832,8 +1831,7 @@ xfs_qm_vop_chown_reserve(
 			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
 
 	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
-	    xfs_kuid_to_uid(VFS_I(ip)->i_uid) !=
-			be32_to_cpu(udqp->q_core.d_id)) {
+	    i_uid_read(VFS_I(ip)) != be32_to_cpu(udqp->q_core.d_id)) {
 		udq_delblks = udqp;
 		/*
 		 * If there are delayed allocation blocks, then we have to
@@ -1846,8 +1844,7 @@ xfs_qm_vop_chown_reserve(
 		}
 	}
 	if (XFS_IS_GQUOTA_ON(ip->i_mount) && gdqp &&
-	    xfs_kgid_to_gid(VFS_I(ip)->i_gid) !=
-			be32_to_cpu(gdqp->q_core.d_id)) {
+	    i_gid_read(VFS_I(ip)) != be32_to_cpu(gdqp->q_core.d_id)) {
 		gdq_delblks = gdqp;
 		if (delblks) {
 			ASSERT(ip->i_gdquot);
@@ -1944,16 +1941,14 @@ xfs_qm_vop_create_dqattach(
 
 	if (udqp && XFS_IS_UQUOTA_ON(mp)) {
 		ASSERT(ip->i_udquot == NULL);
-		ASSERT(xfs_kuid_to_uid(VFS_I(ip)->i_uid) ==
-			be32_to_cpu(udqp->q_core.d_id));
+		ASSERT(i_uid_read(VFS_I(ip)) == be32_to_cpu(udqp->q_core.d_id));
 
 		ip->i_udquot = xfs_qm_dqhold(udqp);
 		xfs_trans_mod_dquot(tp, udqp, XFS_TRANS_DQ_ICOUNT, 1);
 	}
 	if (gdqp && XFS_IS_GQUOTA_ON(mp)) {
 		ASSERT(ip->i_gdquot == NULL);
-		ASSERT(xfs_kgid_to_gid(VFS_I(ip)->i_gid) ==
-			be32_to_cpu(gdqp->q_core.d_id));
+		ASSERT(i_gid_read(VFS_I(ip)) == be32_to_cpu(gdqp->q_core.d_id));
 
 		ip->i_gdquot = xfs_qm_dqhold(gdqp);
 		xfs_trans_mod_dquot(tp, gdqp, XFS_TRANS_DQ_ICOUNT, 1);
-- 
2.39.1

