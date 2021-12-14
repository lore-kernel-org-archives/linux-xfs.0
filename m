Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72202C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:50:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhLNIuF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:50:05 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:20544 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229577AbhLNIuE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:50:04 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7LE84022068;
        Tue, 14 Dec 2021 08:50:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=RzbmGf/SXfra7iSD+JVjYvN1fkKYhjCR/73WdObA5to=;
 b=AQiGKxkyOiCIIyR+KhBkYsfn7H5xOGs1T2gE6Bg/zGjvKI73664npKoAGATEuK/RTcc1
 YSUtaMQG7VJEMReBTv49F3hkEaFadlICgutQN7cxxjrMt4yC0x8NS8Gb0V/Fj/cGG05O
 6Voi7GerJieJTK/GQpTM/ySx8dW6Vy4JY//nvO5uKnzk2M5LU3PzN/OxoKuxgjT2JFDm
 BHi/7uKgyj+YOWQ/elKWomwofy7X+1Ba202CdZ2R6aFoUsv6w2hcOPEYnkiZWUaros+I
 nUNYbdTxQWnJl/jwsdKJc1doIrSb+b1Hzugz/0RpAIzMUF6EWhWWaoYd0yU6OKokPqO6 XQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx2nfb6k7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:50:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8fX3v156432;
        Tue, 14 Dec 2021 08:50:01 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by userp3030.oracle.com with ESMTP id 3cvh3wy7s3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:50:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DrhMkbE7rYYbpwWFquUmoxVaeufo7qeJhMbVlw8vx7e4rkFXqMYqaUaYSkTKsGRkXWlE2LPbqg6mNoVDleyyTQElHsfFITZH2cgP4YAzHyBrjAW/44UStXSZxa0PFK10x/yeWpBO/3RzLfA6y02qaJc9fV4h9YyJjJCxzjl2AzKThYMbJDj4wkXh60X1xXfSIKGWv0ZkA+/LS0395w75EMpmwdXTRtIAxXIHCuIxsyR8e4I/pq4gbMCbiVr8iJFqlIDjhKoRkO87/+69gDTGZtboqHRgZOYzPv5ILh9oWWPhVuVfoSewe4pz8EcJH4YWVJB7PSPFqb/sHCjnUPiM4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RzbmGf/SXfra7iSD+JVjYvN1fkKYhjCR/73WdObA5to=;
 b=Ih1qBfq+U85StKfL+ECofWT3ylRCJbwIzvMFnKDxCIhLrGb7E+u4oadbC15IbOFw/eyTEErrH6ps0Nntb89Io7mXAvSdChu+DzAxsAY+MH492sXxaRGbC46iCWpVcHt7vz1GLgHsb9wiy9EQkI13/Dq6Sig9WM8jamUjbvIr7Z0pCSP0UrzZlkw7iqv12JWxmEkZgCmdn3cn0a6E8SUC+0DlzVq5VpWYReswZkplwaqoqXpaB8tsV/ikkkzREjya1d7/JjK+N9KEoHt/RY90V4Kw5VOtuKXG3ZN45Mir6hls2RCxKMBH1yFEUDxYW9swz+M3MDJ9Ok8iv3tU5lFmgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RzbmGf/SXfra7iSD+JVjYvN1fkKYhjCR/73WdObA5to=;
 b=AnmtsTfkNIhixN3O208lXxmQ+OySQ/v9Uv8SJ3tOaEQClC0ks3Pon+DOtNGo1HQVni97qdHw22csQp4fkUIgApDJPtdS/WTI0zl7WtRbbL3AB/VdAMShBKOEVOr1YB+8IOSWHNH70ujxmX+SvCHGrgY1O5e9zxTE+jXIKF9Ug/w=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2656.namprd10.prod.outlook.com (2603:10b6:805:42::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Tue, 14 Dec
 2021 08:49:59 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:49:59 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 11/20] xfsprogs: Use xfs_rfsblock_t to count maximum blocks that can be used by BMBT
Date:   Tue, 14 Dec 2021 14:18:02 +0530
Message-Id: <20211214084811.764481-12-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 66d1aa4a-4680-4789-434b-08d9bedeb5a4
X-MS-TrafficTypeDiagnostic: SN6PR10MB2656:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB265617F49A821E3529C94464F6759@SN6PR10MB2656.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lzeAZstl0LPYq7c/6lURzoMVUXbuc4s4V5WxHU44f4L5KaMc3/WUPOcTR4ArDDuKD6MMxo6kldFkZKBUcfdVdcf5Jxf3OBw+XF1cHlsVQRWQi3X9N7uTUciGjbapIY4q9qo6AWKz7JGBnk6WTVplScWQ9/PtWfDU8ytuAdVIX47XwOaURKvMCn1Zlbb6C32DXyZW+MZiV9uGFfyjWmbdNBIYrBjcdYUzdsN1D/NeqfH1lB6M0JoFuU1UapmLRY/CLfFkwuFX68vn9PJD/IYrGpr8agulnNNre8MgBlVBIjbgv25+Ab+bG2pWMmjaTbSK7A3yRA6szY3IZRddAKbibuE3IhJYuTSBtIXY2O1QnsRH6sbesNXW8Gdx0+/1bRwlYo3PBE7bvVC2zQnpQpyBuwo5QUeCGLE73fflRTCtZg4M/cc7x/L6nngzH41Cx8bORBRfSKm5fGJRPrznpVpYJnmcF39XyU9Xm1f2Pfs/R2XoHAtjCAC0ETZSJFpy/zq/EIjNnXHlWU9kCXPifpbaV/w1LdUkfFLfKs4mCyZBOqUyWsfYbCwZZvuKQulqvzyLY+Vxw9Wyo5EuZ3m7vXebEG3uoWQ7ESR/wHt5zMCmDQT1am3rn5SgRDD9Ouwcws3K5bUOIdenlFwNU29C6LWzeEnciQTds6G0NAcoZCI5iIFWDNOqoDP+oSxCBz7sx7Xyuaaea1sOXvdy8VOoVCbB3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(508600001)(52116002)(86362001)(186003)(6512007)(8936002)(6916009)(66946007)(38100700002)(38350700002)(5660300002)(6486002)(316002)(8676002)(66556008)(66476007)(2906002)(1076003)(83380400001)(2616005)(36756003)(4326008)(26005)(4744005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4g3ExouD3nqfNuPeexkBRjeLHajNHm6rrUxwPy/VRFm5XdTKF0mdqZOd5xLV?=
 =?us-ascii?Q?1S3smMTlaBRTdX9XFmaQZcLAk6JFxkZhEUHNY2hdh1ldRR0dAG1WSNBb7hB3?=
 =?us-ascii?Q?2lHY+DEcLBfPG+NEJzqojtIni4sUiOX9mAPZl/ihiDbBM0LUzbxk5/fCYzmA?=
 =?us-ascii?Q?ebJnzIcBT0hfEk3d/dYSMOoC4HF9F7azztK8TYvNEYnfb5NDxtt0N5fLC7EH?=
 =?us-ascii?Q?tUvAEq9quYGzwEw8OBrmj+Q3dk0gFgAx9xRQS7rclAB3luS8vlckOe4adAH9?=
 =?us-ascii?Q?vEKImDMC49aPyOaEtdPWulpqOuIG8bvFFSAgOHHdMGEI4Wo1c32KD6gNTu2+?=
 =?us-ascii?Q?T8k1k4ESt7OOJzX74nlSJKZiC2z94nFrqQ7eoH4LABD43zhMIVwwHSRfJhio?=
 =?us-ascii?Q?5TjbYriUG8i0U1N4wMl6UKpaU9T0SRv9Xu/iIHcSwXdu1qd1zKRIbUvDlUKJ?=
 =?us-ascii?Q?2GigkZr8HhuTgxjkFJ9HMZQqncJkqNMFzrW/L6hDZRcbQw1GsgcqsvIxHtON?=
 =?us-ascii?Q?qlSvH5u11bCX6uBL37Pr4+dKbpRORcLUCJOv5cDpjvQJ6NF0G9jaC7LPB4yj?=
 =?us-ascii?Q?abFDzAC5zg/D3SYhNlqOdvhm5w38wczfOzqjr0zzjABZEF4hCXL50TBcxUZ0?=
 =?us-ascii?Q?INgAPZ8E1x8A5zDcDaAbqZzFFst/YM8gEGfN6fw5vobk7aO3YfjdL1axb2Jr?=
 =?us-ascii?Q?/1bTIjC9WUUkBj7GEFSvJpYQdv1ElFvVjxdpP5+PVcmlOIvxejvCWKLtk4Lr?=
 =?us-ascii?Q?FIHhD7jiflkUqZc7Iy5RAX4v3yQX4gMvAfV7jGhSkzBkdbXCRJkEaKSGcERM?=
 =?us-ascii?Q?NqivLiGeRp7tmkv+mBIg/Yo2nzbZs0zic/Va5J71KirPt82Mrs03i1blaxJ+?=
 =?us-ascii?Q?aW3Vy7QMZY6HlYVbhT3VPtKoTbSgNSauJE/xAx/j8oBDDMKXa+gmibVcOzmY?=
 =?us-ascii?Q?W1HqgnSQQLihw96HpMRe2XX+Iqjt/+FdR5Wpfxulism03wUz2AHcmVUdmFFm?=
 =?us-ascii?Q?TuMBvzRrG20lD/dixTvrLJJVsKKZYp6GwBjfJlr85Geio3vkju9hyMoC65Xe?=
 =?us-ascii?Q?0laBPgZNyDydB08x0TmV4xllAGJsl/+4tZmamG9HHek8xeUwMmefAY10nJu2?=
 =?us-ascii?Q?9AOyIr01y7YdhnDisSGuvQZb9YoQCRkNtR2f36xZ3DMkxpK95kQMF4Joa+HR?=
 =?us-ascii?Q?87NFPYoon2XSqvj4R79zBaXVuV4w8l9siwioIxsrK5WVh8SRPOSIZtqTC8jW?=
 =?us-ascii?Q?mpQebz+zn5ZCcAnTMv+DOG2aNBlP4pxDy/MRHhZKxxI8viHR2lkmODi4KIDY?=
 =?us-ascii?Q?xfjlo497uFK/w07axJELBnpLdQGmWB+kHHOpx6OJuTms5z6BaqTtyL+VmxeH?=
 =?us-ascii?Q?T5p5QVqCRbH24vx9+M3MnczukvhG/uJM3HeCRC6j51s9Hw/xCDi0JsC72pqA?=
 =?us-ascii?Q?PYDy7R0K2ok1R1oYDcZLGctf437vJOlImu8iR1spGGXRfRr0TLT+zUdiayK4?=
 =?us-ascii?Q?CBLVNuwyVGcyHnJM6JEB6vvF6f6NOZuhXmgJdQKdwdTijLrGqKwpIfKB/3qA?=
 =?us-ascii?Q?DZSqTV7xKsoT6RpzhWBnrbdVHp5dSW/GwNI6/7PzhT0y8hlTwuHS/GI+p4N+?=
 =?us-ascii?Q?cvJrw4G/MUi/fno8ibwDFQw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66d1aa4a-4680-4789-434b-08d9bedeb5a4
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:49:59.2648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vS+/6Cu7rQDKoFpLw81etbhnPqM3/HoUqfpFmAwctqGtCf/lUgBrgkfQVdYtuiw3UJClPnIkrm3kCsEtVQzhWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2656
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112140049
X-Proofpoint-ORIG-GUID: izFo4EM7Y4uedZl1YoDXAM5FuUrIennh
X-Proofpoint-GUID: izFo4EM7Y4uedZl1YoDXAM5FuUrIennh
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 04466348..37d9d47c 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -47,8 +47,8 @@ xfs_bmap_compute_maxlevels(
 	int		whichfork)	/* data or attr fork */
 {
 	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
+	xfs_rfsblock_t	maxblocks;	/* max blocks at this level */
 	int		level;		/* btree level */
-	uint		maxblocks;	/* max blocks at this level */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
-- 
2.30.2

