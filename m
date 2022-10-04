Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D37D7C433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Oct 2022 10:29:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiJDK3Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Oct 2022 06:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiJDK3K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Oct 2022 06:29:10 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CCC32067
        for <linux-xfs@vger.kernel.org>; Tue,  4 Oct 2022 03:29:10 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2949M1KC029346;
        Tue, 4 Oct 2022 10:29:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=mSVr22ot8pvaeQ4BzQWPvyEhbQnWA79Qw7kSzDmeu5s=;
 b=CgpqeiukUHBGABbmu+QBGY/sHzrS3D97E0vHaSbE904/iHOfJp9/xQ8yjjweHM4I9qrg
 6SmZENmHIrcwNw3b3pt1TfIc86LVjCmLAn9nq5upR3AHg3z0aBewtf/WiTRUqVxxu4zI
 4TjcuWcpnW7ndTe0wk1Je5wKyzC+mh3kaQ/0WHnE/Y9vZuIEcr3/uCC/cjw+3/zcNEmi
 9oi43drk2vZgwog16c+lp6k0HNzVEGuLFsIgD67/R+3CCcCsqv8m6WilcCGQPa6k5jS3
 bV06++FacQ/AGdYlyDGMLURau9bViheZhSL211HFhjfDVStZAE/4rZ1XiyOF43R8ickp 9g== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxc51xb3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Oct 2022 10:29:06 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2948B30w033831;
        Tue, 4 Oct 2022 10:29:05 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc0433w0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Oct 2022 10:29:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ce2+lLF//GB+5o3hQ44tdB6YTaDN/id9hDU++3H7jgYKJ10poKtVurKIY5EJ6SXT1s0ezPQqrwfvQi4dENZKgXMkRqG6rFRb89g+gpljwlR04Ne4PgcdXvxTWkHdU5IK8caDR7Sr/3KluUj9vRb2TsJUnx30A2MlZRF6cbu70nb3C3N7w/i1A/sgZ2b7f05xu67VAGRyVu073vVEN5LK5mgY/8ehJJzwM3y80FPEqKWnA2xAzQrZX/3GghBsAy39MFUzYvFpk/JGAlOmg8Lx/JCGhXBfFqxsjeF2vChDyrx5vKUYk4AvErzETa7LXe6Odj9KdNZ70Z1HOp8WpF1Qhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mSVr22ot8pvaeQ4BzQWPvyEhbQnWA79Qw7kSzDmeu5s=;
 b=LS0/+btPPmyrPQ8MzYfNhpDvnptjskMMMpWOqQ7nC3foI8WTtchIDHD9zk0gS3pirMuHxU+1PTlvH/uPfyUfttSjSOvyZzo1D5QceSOP2TgAruPoiSJcomdpjssLzjgvFT0LjQIzVmzV1CxlsqVVFzow4CYKRSrBo6k1IsXgHDVib0gs/ydfvpwR8i8jXvS1BvpKjBYRmagGZ94YcRhMFlEUkmgYE16GXypfxexz0hMPMOeRRSahEC/4BIcYHQH0026hoI38qZmPbsZJ+v++0rdFNWn7e39ZxNCXbeUVY3BDh7JA10Uk3gM9gzs0X7vWu8QUd8YiECTj2Ggu7p1kVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mSVr22ot8pvaeQ4BzQWPvyEhbQnWA79Qw7kSzDmeu5s=;
 b=pyP3qQS+KWYwH3QrLqCFEj+Fu+a8nfiHg+a4UvxFojKpSQfY+gPVH6WQxSdMWt6ge4TGq4ZBomvzc2ktuUazRZExt+OrsFf2FUUu/SC2ox83IjyGAQQBxKQzy9YzwWSDS9oPvDec6WY+MTpm0EUcigs/d/cgBD8CHtdQznH63+8=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5184.namprd10.prod.outlook.com (2603:10b6:5:38e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Tue, 4 Oct
 2022 10:29:03 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%8]) with mapi id 15.20.5676.031; Tue, 4 Oct 2022
 10:29:03 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 05/11] xfs: fix IOCB_NOWAIT handling in xfs_file_dio_aio_read
Date:   Tue,  4 Oct 2022 15:58:17 +0530
Message-Id: <20221004102823.1486946-6-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221004102823.1486946-1-chandan.babu@oracle.com>
References: <20221004102823.1486946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR0101CA0041.apcprd01.prod.exchangelabs.com
 (2603:1096:404:8000::27) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5184:EE_
X-MS-Office365-Filtering-Correlation-Id: 46688696-022b-4979-9c96-08daa5f34208
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: djfUJoQvRockI1R5db3AVm5EZbsv+TtBiHuSNkyNAKuAaBnMC8C3JpGq12VzE647tqXkuS909NnAhA/5eL0NWZeQpbJy1j7jjef9LRy+Up5rvDSbp7mkuK8TrNrJ1FZlVE4bwnVKPA/Hh7K7YXfaESDVab7LyAKyGxxh4wh0THciwiye8TRh7RPs9vYYMzLKnBmDB9j5mV9jTmX8t46BShcRNWNHS6rjr9Rp66ZzvkLLhvZaAoJRLrpJJ2FVYjFkuqkbgA7UwAJ3jXvcMQAYRnrnGbYBnF9iz8QI6dLNODxRUhrPvOFAFMLNLKIYUO2gri5qNsYHOJvCtB0TRmmLKYav2AlIqDeWItvcURkQyOdyCXMiQiVNW5MCbL94bMVEoI/RjJrjJ2jWOy6FVYv+VKzIgcavmH7aRgXr1AViSjCkhvsA6eRQP7clXL3wSInWn7kYJZGhAV1jmMNDJSlwDQ6Q6p4rzxNQrgDp0J+wR/Yf6Q6W3FbySBWDczenloOjw+cAZV/yQrwvLvIekHKZP308aZQIW2e2cv/lRiX507mqcTiITZ0oEhzWNRh4oAR/yi+dlmPxeSwhwoT4KdOrQNQvC0UHeH2j8iT8RU1eT35o4+5EpnFj9eowVg3YYVCMpT2b0DqC4SdcFFsIQVBgId+9nG+HnAPt0T6IIKLQVdy+QmF6P/dEZo64ThkXmNnSuM6uiqxcf4fWEukjkbl6JQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(39860400002)(346002)(136003)(451199015)(83380400001)(38100700002)(86362001)(186003)(41300700001)(8936002)(5660300002)(316002)(6916009)(8676002)(66946007)(66556008)(66476007)(4326008)(26005)(6512007)(6506007)(6666004)(2616005)(1076003)(2906002)(6486002)(478600001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sHd+wR2hwFgdaMKPTQEINzTKEqjq/phMwDWDvUdSGCnxqIvK8dY4/KCe3Sd8?=
 =?us-ascii?Q?hiO1BLuQRgf2Tr29EODGYphsSOWtQjWwITaiog00hUIbvfmevcJovaMxkhH8?=
 =?us-ascii?Q?kPE4D8RLHQE4ZNPl7jxgW6aR6b2o2cdObhEOOKM/fUXIt8Q1maNcPLTSUGPu?=
 =?us-ascii?Q?Zojjt39vO9Pij+IeVC20kUUyoNpKX2LaZAkKN0tMKGHUe70PPaN1zOuJzq+S?=
 =?us-ascii?Q?a6Qx3bkrax9LRb2NWOZTFyRT9rg/dJDIGrDdIPap972lEq4T2IAAFqpAcvPq?=
 =?us-ascii?Q?Xza6hXRXxXwicqM0ThHupIaGf0kkZNRsiekmxI4yuU45+hDrI7LMaUjv6DON?=
 =?us-ascii?Q?GKdpT/ftQXbThLNps8cftCKBNN1JorutHuM5eVGFiR4jrf0NzoYiqtDAxqwI?=
 =?us-ascii?Q?RsOrowYCX5gZPwKHdfLQkFmXY8usMlZwOD6JpcRvEjvaHrOJ4/7SwRBxxkJA?=
 =?us-ascii?Q?zznn1NkYOooOgkfHdlziSB0Y2nPLMNQW5T7k/8PLQKN+7nn7D+Vgn/29KzLL?=
 =?us-ascii?Q?GXbJkVjmvAyiTNI1pZWEQJHzpzOtnge8QcIjJh0XQdhfg1S1KkxN3B1ar3CB?=
 =?us-ascii?Q?NPRnAUDu8fRl6+VnA2dxaII4aAF5BFXicJlOKDP24lRFEwMr0DC1tftuKPqT?=
 =?us-ascii?Q?mHNCPCfwAg7rj715jrlMceEi8Nn8s7SKvm/4wCaUKZFUHJx/6FP8DzjWbVz6?=
 =?us-ascii?Q?N+mXHKRVk+DpojpzNMeT8bOtri/XEUGrJKC+d3GSizsrtz0yM3YmLIJB/Pqe?=
 =?us-ascii?Q?Grw+RNpfYS8R/vE71fqnLlgQDTO0Tv2z/U0KjHj/7D/+CRmWPAj6InMx3FnD?=
 =?us-ascii?Q?m/2rkFV0rWEr3oMDZYgYl3fVX0xiShxLJ0ucScmeR6+oVUrdYhOwjKJf2lg9?=
 =?us-ascii?Q?G3IEonojX5p3/J5mNIhaONim7TGGdo3SA/4yMVKFDEs77dfeWCK4vtbWZmrb?=
 =?us-ascii?Q?G4bF3y+VI4hTJ2gIhK77SGOnuBGDs88evvjsPt9WgsCWR5Y0ZYQmrjrNxoqN?=
 =?us-ascii?Q?N+ORmgOws6QckdsWUJ39/hv0kRT5a9Xg+jamCv7D9zm4gJWJ3S1pv7K/hsxU?=
 =?us-ascii?Q?JdWMswcxzvEni9QY8XT9xRuciSl0O5KDA7GU/WDFrX3pSCiPuS7Bp/90UBhq?=
 =?us-ascii?Q?cyhOMIOKuCMDSZ/uzCX2LrFtqfI56T2nl4M//zwEp1qDMUdpQojJUl11r+LJ?=
 =?us-ascii?Q?SbnH7D5PV2+TUb/oLA+uXyVNylZYwYmPsrLaSNAev7AwR/w2AkzUfqgeShuc?=
 =?us-ascii?Q?RDu7ndeyDhuEU2SY5dubCPbOuRAzoVlrAAIDKrFFa8gCIx19MgZj1lLQB1om?=
 =?us-ascii?Q?a5l2ZsJRmy/j68A1cpywlNIjzLVikw/zbKsmVYCIPJoYXZd7nV9f374FjYUN?=
 =?us-ascii?Q?4zThCPG7k/5COuWReKlTBqgBklKPD/3/Jt/NlAAjXdbKs6nIeXKT2HpElWoT?=
 =?us-ascii?Q?szDjcaG3UliIpoxxOC6Tp1tFNuGdIicyIaaCphDyOK158mi8OUolY2vYyCTh?=
 =?us-ascii?Q?7amuP0IyfJZbsKthDRlYGYT5hEf10y6cWj7hnYtVDNrq7ti2yChhg0Y6Ik7L?=
 =?us-ascii?Q?SPUl1MOucZNBuIsB3QEpOJVj7/HSl2x63UNNev1aba/JAWPogUwkVpHC9kJ5?=
 =?us-ascii?Q?/w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46688696-022b-4979-9c96-08daa5f34208
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 10:29:03.1729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CsXkHMrxgu4+ipz/eXTGSUL+KLeoO8Swp/YwnOd7YPUNWsSf5WodNySVqOI9cHduGVzkN9g4Xs/DKaaj1TsnyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5184
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_03,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210040068
X-Proofpoint-GUID: ClUgwRYMaq5bBqryqQi4RqJ2Osr7XBM1
X-Proofpoint-ORIG-GUID: ClUgwRYMaq5bBqryqQi4RqJ2Osr7XBM1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 7b53b868a1812a9a6ab5e69249394bd37f29ce2c upstream.

Direct I/O reads can also be used with RWF_NOWAIT & co.  Fix the inode
locking in xfs_file_dio_aio_read to take IOCB_NOWAIT into account.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_file.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 203065a64765..e41c13ffa5a4 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -187,7 +187,12 @@ xfs_file_dio_aio_read(
 
 	file_accessed(iocb->ki_filp);
 
-	xfs_ilock(ip, XFS_IOLOCK_SHARED);
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED))
+			return -EAGAIN;
+	} else {
+		xfs_ilock(ip, XFS_IOLOCK_SHARED);
+	}
 	ret = iomap_dio_rw(iocb, to, &xfs_iomap_ops, NULL);
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 
-- 
2.35.1

