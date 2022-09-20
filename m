Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52993ECAAD8
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Sep 2022 12:49:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbiITMtS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Sep 2022 08:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbiITMtQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Sep 2022 08:49:16 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A596C74D
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2022 05:49:15 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KAQSXg006015;
        Tue, 20 Sep 2022 12:49:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=0KYi8I5UGHdiY/XDIZfVB7VyQYmGX1gVp+ej3oH0Ous=;
 b=ln6RpX9/aD4XTU0Ju+gEA77PTMV9oAIvavglXzCIf3YNtfDJscuuJ2Z/jtAIySusl4PY
 pkPgHnX3rgF6nsqHVjBPBoiTKlvZSBmVyOANkd4UxHo6J0+PKDoPZjjA4GTkM2fRe5ES
 GRHKBSbjwmpn49lYQwmvtR+ML1lCYhLvx8ibmJh7TxT3PX2iIZUHybA4euIlEymUD9tC
 ow08CBJpw2Ap5i/qzsf/5PZcWHbOYkG9COMIl7WFrBzF+GSwRmeiqYvh/KNR9CRZ9GoD
 sXb1flmmmYTmPUBzRGJ7lCWaxkl4N9DOHBI/QclUwhuwAUlIw4nAgJq8rzptYn6hsyx+ tA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn69kpt75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:49:11 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28KAroUa027878;
        Tue, 20 Sep 2022 12:49:10 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3cn9hh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:49:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FjAvNUITbe094Iy32DCdSMnZt47gqWY8zApGxHznC5QWAzW1wh7OOGf9jLoJAbeVEwyNd+28uwXTuG2xr5L2wuAvLZW3SZwgEvQKGKJ/DwnvKhPRNlUzdPDPW/rrjvxIuYgSdae6EVoj3TJ0z0xl9VGi7rEH5mqZhiMPR42l/UZGEsPuFICqiZJ+23ygTF2mgNP2rhgxX0gYDS0MYcDngC6yKtM/YTS2CqmYt+RBhYQcjFzPhtYJ58rAF9vPgB/4gfndQfEG9ejJXPCuxV3HK8LvZ+9FTtF5wOsGfJWObcimPFwVDnGVx+rz3N/7eSCqUBGl1WcWqFTqb/8lJAyLXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0KYi8I5UGHdiY/XDIZfVB7VyQYmGX1gVp+ej3oH0Ous=;
 b=cOjDiZV20NlkeroVV9Fcg3tbeQBqYm89TQ5PFcSsKZq/x4YJgFzRh5z0tcUwQrYg5Z0wyhTZKRKkepqP7OkYm8Py7/lY8Z8GMWAFr/vYWtOXHxP8eu+0nep5LCHas3EvcRAJyfLyY2h48RiWEVqdZtnRKI0ITm0O27OAkWCLgihgSJaIFrBkYMkj83UGlwg8TxD4/ET+p80+u6H+y5AAC8KHtJOC5LcgVEcCLbWjLg1J8iTIneG8Qbj41Of3LS+wqtihPnM2BTniya9lZYNT7GnUIaIE+bJfT8Tu44fImrb7ZBczpb+c/qbGzYEEiTN+zyrh8kzwoi8jnE120I5vAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0KYi8I5UGHdiY/XDIZfVB7VyQYmGX1gVp+ej3oH0Ous=;
 b=iYv12lyMuBsgxZc/eLoloN9gza/fS2LK8pLi73p00rIgnOUX756LotmKmBpNKuQ5HbnkECoFMfRExHJtekCzksbtxz5jr9Mw8hCOh0JyRlslwdCfZ+njfYBHuygcVU6DQ8KRnjaYsxDbp4hI/afFMNZmHI3AK3LAEDcnU19AjwA=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB4987.namprd10.prod.outlook.com (2603:10b6:610:c1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Tue, 20 Sep
 2022 12:49:08 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 12:49:08 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE V2 04/17] xfs: slightly tweak an assert in xfs_fs_map_blocks
Date:   Tue, 20 Sep 2022 18:18:23 +0530
Message-Id: <20220920124836.1914918-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220920124836.1914918-1-chandan.babu@oracle.com>
References: <20220920124836.1914918-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0153.jpnprd01.prod.outlook.com
 (2603:1096:400:2b1::12) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB4987:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ad7fc9c-6090-4c2e-5f20-08da9b068256
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u8G4grDYMHMuvmhrehEcfFpB4LFInOBgbu8vPkeJdItji58nDR+/322/n2WhoaVQe/BdhH7Y7dB9QORSSZyqiZ/TRaGB1Rd5nAp0UpbQbWmW3WQnfUH6jY/6ylca70IzebMYHBZc6xVAEJGp4P+TrTsw2QGkPMiPQ9Es3KNhYbQqJ5ks/fmjlakxddo+vr9YycH6AVmPCYz2vPEuN852uupGO0HxGXrFVsKlNgkKDqBSJ3LYV9do5YdpwpQoTBusrer3s+x54TgorE5OvTLJsVnhYvwusHGMAUynPX0KGL/qDp19RxpFHoqHL26rZK5Mi7evz+CohGkfW2vGlzLjmAdMay40cCxlGsAIcYS0/dkplkmsKfwDgBbc/0hw7x+xkCR2ZVVwA4SCEHC/VNqgXvtRZHao6myKPg/gIwTlS3KEJS4nqy7JKimpUkyn3rjvMtR+DxvPxJ6OD5p7OkEcXkqBka6qzUICimPEOJatekyvpw7BHx1tc42VRIawWZpAUgJskhN6l0F/LR4QPjil/PLcCYNtSVJpw7icpaQ0unA8pLVKN9zVNVwY9RhY4Zajh6gEBPFxAzSxYFVoFMtC8+08j7WGVSQWoUzxaZUOxsDkeeiNubGwQd7LnSfl8/X3t23m5IR9R/uKGoldwv5AEq9r1H9n4fyesk5lzwbmORWMucTfkdEjvGU5f8DxxwgEK4QCaCbh6P5lOOKqAR7YQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(136003)(376002)(366004)(396003)(451199015)(66476007)(66556008)(66946007)(5660300002)(4326008)(86362001)(8936002)(6916009)(316002)(38100700002)(8676002)(83380400001)(41300700001)(6666004)(6506007)(6486002)(2616005)(478600001)(186003)(1076003)(6512007)(26005)(36756003)(4744005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0lB9X74mRRyiC+q2W/lSZ5HsTGytVuzJe389FSkhfNhCw4vAg6S03yaRzVnt?=
 =?us-ascii?Q?BD35/OM87TFsn3VyPJesPwna1c4kHqvheFNy0MCjrsN0zOSmi8Pbyfr2hRSc?=
 =?us-ascii?Q?25clR1YB5fuTKwTs1H2gjsyEk7r8UTDK0PccbQmkFo8h4eXHNE7IzOGRO3+2?=
 =?us-ascii?Q?bm5b49e1Bc1Df7bPjrfiDyiVTxxbxyoQ+6F7kevhh7QmRTW1HgB/Ij4Bzsl2?=
 =?us-ascii?Q?ngrbD9lSrvkYTVjjd9mxusFbvQUSdzLKDBgTEDBcuFp78vhDKSicHOjoa/nc?=
 =?us-ascii?Q?TDU7RkugXpq2L5BVH8Z0MfPTAX/QPU3CB2UlvXnVeZHNx7NUoiWDwFLfCxhb?=
 =?us-ascii?Q?fQ+eYsBsfNQ5Xm1wHcdZM35Uu+cmW7RTJdzi38QQKKt443cADSXDTucQ3g+0?=
 =?us-ascii?Q?To8nrx46ebNiQ6nGKpRcq/scSkO1ghp8M3IgmuJblqtHRtPRSInmuTdThHuv?=
 =?us-ascii?Q?yYWr7zh8k9t6zIfRsyJ7G/3HGOmF+1reYzShEIGUKCt38NuD/QOMzZTJiJR3?=
 =?us-ascii?Q?9CW+Kr1MhMGhS1MVgd8UuqU8L6aR5rn25tW0m3HT2+A3HdMtTQgHLSzxfTk5?=
 =?us-ascii?Q?xEeiaSwGd2GiT0dKCDSVdoYc4MWs8KK0BBoYXK6s11FzDk71NLfFv+23N3r+?=
 =?us-ascii?Q?WbNPuq+G+Qwei/gcrcUbw4ceA3pb9vFkHZs6IFUpPn2rNCIzRdLDku4SmXZ+?=
 =?us-ascii?Q?2pyu5D5noRGyD/OuTFYynbcdLptSWmJZ1L/6R7SdgngVF2TFBipjxwQfTEt9?=
 =?us-ascii?Q?KqGNq2gB2mqH6zqppVncWXSglac002YhF6/I1c/x3c+ICJJ1ewEPvVptztWo?=
 =?us-ascii?Q?sy05IvzpExPq/RbAVJsYfvouDhG5KDwEPpAREyNwWQRvowZjHbupSQoZGtRH?=
 =?us-ascii?Q?c0huGN7LmdO8PpU2VcI731UKLjZZxYW/y44094mXCDnr0D+nRSj91eAmij39?=
 =?us-ascii?Q?8XLHTMjM5Ww44OE6bUecSA/TJIok7E+RfqodKD+Kqg9gOANyCbdNWVh3T6qV?=
 =?us-ascii?Q?JLdOwjHOJ7l5z/MCWaQueEVnb7TPB6Te2bk/G7rwRN2g3PYCMFqfwz+P+4Jc?=
 =?us-ascii?Q?FltSsYom4IPhiefRoKrZoZO4H/Qaq2WOGsikDBBE6Licq9yBtHWyXxIBMEL4?=
 =?us-ascii?Q?2YfgphTPoFeHlyEviFqS/pjyQzLK8zewA+r1Qx7c9VoEHKm6EEyHlIkJyQls?=
 =?us-ascii?Q?2dQCh5JIb32jHsE/WXv++4ueFFAPXtQB4A+LftIcc09bhWindS7BGXv/Pfve?=
 =?us-ascii?Q?oUMrPeq5tAmZwQiPIdjZTIml6KkL0uUjYai12ZX9qh2cdKIgRWwFhd5b4TyQ?=
 =?us-ascii?Q?tHmjRRUAtg7ymTxltka5AZp0aRMn9R4V4IwJi4QGCIYWnjX8JK/BI1tZlE0v?=
 =?us-ascii?Q?+mb0k9Ok6T83HpduMDx9dmn0CdMhXVZ3POGfjRnfpPdqG4DfUU3RCPvQFlQ/?=
 =?us-ascii?Q?Nbr50YbrIDO76C/vxDxbT6BYY9qhLyanwiymvCW6isxh4u22YolzdLULt88K?=
 =?us-ascii?Q?DMJGDlijZkI1qJA/2kD+ikFey6l3D08F07bMKMHc60Pq80EN3Kbf0Sx2/BF5?=
 =?us-ascii?Q?SdgIYxYZ6/aoXbMGbCKKVnd2kApQGH3xzUcPYIgT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ad7fc9c-6090-4c2e-5f20-08da9b068256
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 12:49:08.7497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9PcT5C1bedPrPs+H4fbP8IV953+J8A6va1o3tErasgYbNIH5LLgrOj9HZ1egUal5Ulw70LpO+oUMpS4hYEpesQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4987
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_04,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209200076
X-Proofpoint-ORIG-GUID: qOLMChn2LWynFOM0q32wTNdzPt8VFr-D
X-Proofpoint-GUID: qOLMChn2LWynFOM0q32wTNdzPt8VFr-D
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 88cdb7147b21b2d8b4bd3f3d95ce0bffd73e1ac3 upstream.

We should never see delalloc blocks for a pNFS layout, write or not.
Adjust the assert to check for that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_pnfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index f63fe8d924a3..058af699e046 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -147,11 +147,11 @@ xfs_fs_map_blocks(
 	if (error)
 		goto out_unlock;
 
+	ASSERT(!nimaps || imap.br_startblock != DELAYSTARTBLOCK);
+
 	if (write) {
 		enum xfs_prealloc_flags	flags = 0;
 
-		ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
-
 		if (!nimaps || imap.br_startblock == HOLESTARTBLOCK) {
 			/*
 			 * xfs_iomap_write_direct() expects to take ownership of
-- 
2.35.1

