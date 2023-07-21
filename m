Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8028CC0015E
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jul 2023 09:46:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjGUJqJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jul 2023 05:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbjGUJp4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2023 05:45:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3298B30CB
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 02:45:55 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36KLMalv025796;
        Fri, 21 Jul 2023 09:45:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=6ONOo55tdf3ee+BxrYEgkRmZAzZhTN+QPS0HdmE5hsw=;
 b=ulnyvbmNUqnYb8AuRMfi4H2f0vffc/olLsdnxrDBRoCz8/KXRP6HVwWVUN3Z33u5i0j7
 eIen5Ck16kf6+FH/lMlFo5+NvXsh3lnq+PwNoUIZY/5JnuOERXd/ZnfBk8eX8MpAwCnR
 tL7LHfy9R5b8w9G27lLJBOaxCmK3AVYLvdqaIOBvRUd1bniZ5tp+k7zc8GIhxb0elwUM
 KQJrOvSWEHf7cNeleQl6opFllbdYNSCwbMwEaFQVFzso4dEfSmxSe43p9ggt/2UqqQXE
 hwEhhpW74B9tOnDCBla7HSjz8D33lu6a07+mGR+Qav6WlsnjulYUaBaGsz43cDxXN0RT EA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run88upb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 09:45:51 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36L9DoxI000851;
        Fri, 21 Jul 2023 09:45:51 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2045.outbound.protection.outlook.com [104.47.51.45])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw9tpjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 09:45:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jK34bopjpjzObHmQtgGskgxUsLCccBGULPNikkzfxfyQCD7oF6apYAEJflgJo6/ecTq43ldqFM40pjU1FecZszfJKONxd1CoAIAMzTA8psp/aMBibSfCRiRGR7f5cgf93KIUasr9fq+hCdI92WlM/EojKk5pFzOON/vLFll2ARgZPZ4YGlv0Q75+wa1JMLDfKm751c4Ooi5/4g5Um7Z+eOk6q0MaNGnFaRI/La5X/6whLxxm6XjPQJPSl87fyvp02WydvTWx2kq3YJNpAgHPCqAIRTxU88eRl8ZoHAKGcuswizAtLhLVF0RpH/LPHZcgqz0mgSioJdos7/w0rtduvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ONOo55tdf3ee+BxrYEgkRmZAzZhTN+QPS0HdmE5hsw=;
 b=Pneh7/xaMYizy5VKuUqzZguyFnYyk7eriDqdLjWVCjciShq5ktcQoxNlxv5nRHtArfcrCk7VOhRMplzAG51gurjTjwzasJvLBiCK2a9r1zRw6U+GyxwoT6AQnvVqRH/GAXfgD+wq09IvGgbWaVb5sKK3EZJa9U2yhjCwoBYOwevCcvTW3MsDnZF5IQ3u0FfpsQhetpC1Z5q3B2MG2TfGDel5t3axXk9gqEsqw/ODFi1bwhbFm9DwO97UIIJYKWXKG4JDeOuRZZ1KA3Vkr1VgtUbZx2qhJvtiqS/GArmZgwD4kVkfYqts9/9uukvoC/p2hvkYTIiA5/Nrt1x9UcwDFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ONOo55tdf3ee+BxrYEgkRmZAzZhTN+QPS0HdmE5hsw=;
 b=p1wOeJVQTiBks9XzRf4bOg65bdp9fkcb0ZcFzqk5M6un5Lvr4LqBffeUs9Y3iKMy1YFHDJgQ76TqzhMgDatOZoG72AsJyVL+nZR8di2x4PRFaw6tqHz08j1zV2sLdr0t4uFvLwqH/mjFau430/r8I8hH3JslceaAZAHe2TNdUqI=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by SA2PR10MB4412.namprd10.prod.outlook.com (2603:10b6:806:117::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.28; Fri, 21 Jul
 2023 09:45:49 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.024; Fri, 21 Jul 2023
 09:45:49 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 01/23] metadump: Use boolean values true/false instead of 1/0
Date:   Fri, 21 Jul 2023 15:15:11 +0530
Message-Id: <20230721094533.1351868-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230721094533.1351868-1-chandan.babu@oracle.com>
References: <20230721094533.1351868-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0078.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b3::15) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA2PR10MB4412:EE_
X-MS-Office365-Filtering-Correlation-Id: 049a09b7-d0f2-4baa-7192-08db89cf4418
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vRLWkj6n0fWLogehxuEltzcytb/86A/D6j0JfcNcEqRuKbg06MCQy1Pj8HnLQvHCbtY3d20FI1rXH4kX+s3mXxKueLhBKdSuDZc8CTzeqUmRp1NCN5i3QeH8YR5+pCZP/KqxGa+Vao129gcsAOvtFLxUOmgg79Yte4rJcazRWUhN02s6KAm1PRLlxyg7c0BOHDM+EwbAdxLGzjJiX947DL56r2mL6Bf1BtCIRUndXk9PBKrttlfpDi162G5CcA83rfLTua06wTkyeO7CZs2PvMwBdKpNlPkiSvt+rDj75my4m/UitbkdcqkT9A1eaXJZin1S+/e09XQBR1Ijbmrf5vGAIqiflwMnIMZ8sSQiTjA59q/irSPAwVUypPYOYCm43XyW1OIWXECeiAUt2PdPEbATCxlD094WvGBMJlCwmezSB7sa2lRLp/AFj5dr0kRqo4PD60SoVnSaRHjbBVejnRMA2L3cbng0A4lPKP+MD3vAUzp0eAmu6cUkMFSN4u12n5eCn9zoqu94OpJ5FBELPIh/YXn9SMpplx2GBs+XhxpvcElvkRgf69/lHJrl8jX8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(346002)(136003)(396003)(366004)(451199021)(6486002)(6666004)(6512007)(83380400001)(36756003)(2616005)(86362001)(38100700002)(6506007)(186003)(26005)(1076003)(2906002)(8676002)(8936002)(316002)(66946007)(66476007)(66556008)(4326008)(6916009)(478600001)(5660300002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JxJ9Ybn/rxmUYhq3cYofKo9PktbmFy/d/ZAvRq6k25zrDKf47aif4pZKVEaX?=
 =?us-ascii?Q?YiLptFj6DgMEZx5zcGDpyqq0PJCL34SmvPVa09rHVrqUQNboCb3EF1ON/Bfi?=
 =?us-ascii?Q?xIX6hcrKybhiqZw0O1nI2H5blKO3h33+mP3Z4PZCM1NO0S6hiL3/L0sO4Ocg?=
 =?us-ascii?Q?/Lly5wCbA/IYyhjIrUuBUczkHukrXD0sfOENxyD9qMg7wAzGWk1tIohMKXhV?=
 =?us-ascii?Q?GsV0969ho8cGRXHJKAVxDr31j7lirSM4ZQrEr9mYUyW/aAp9EOwn4A6x/HcC?=
 =?us-ascii?Q?l23w8DM5Qz5lqlf1CPAunC0Uz+9a2DBfv2aPt8UiAi9psNsDylSFeWw0U+Mf?=
 =?us-ascii?Q?K9J/+ahjf1C4vzX1Si4V9il6bTacL6SCyPKOMhZN/roKt6vDSCp+AYx1yQXz?=
 =?us-ascii?Q?81OmRk3Mrs82EjYfp4tZoUZIdqgQ75koZA4lq1SZqPM6h5leMJuTkq2/JFMq?=
 =?us-ascii?Q?jtC1LqQ/BQSqxeGUKh0cN9WwFTFvLKQ72bMJk9BIxvhMUd+rszWxTvRPZNmK?=
 =?us-ascii?Q?iGGxehoxeQ2oqrFC344iPY7vyQrq7v0frKgNEGhHzHqyzCCvj9y1aL1ixG0l?=
 =?us-ascii?Q?WD7lrXxuU8CURHBPWxHSAUNdtEGtBD1EHWhVfccXd9ojl9x4ArN/F7RFIF2u?=
 =?us-ascii?Q?ZEaLvK5kqp8GnXWJZ1vD/JfDQKyO67GQzg6S65VRazbmaHDnv7Vuv2eAzUKl?=
 =?us-ascii?Q?ro9Ob3St6Vh3CLRGJrLSFn07PzTDw4p5eaJLeRxSlBwSaeilrRZWPllhu7cA?=
 =?us-ascii?Q?f6Zkkieuzym9eNzzRW7KxEGMOZMyvYIjs7IC8Ig6H3x7ZYk4l23XQo/9dUK8?=
 =?us-ascii?Q?i+DH9nDceO75Vu/UD38DYdrzpTL4mxa5ZnEjR+iiM5bm8OyUcx1EbC/mFtt/?=
 =?us-ascii?Q?oewESu7nFwVIJPZec0kh/mX18lzp/VfhcUeIZfH0xdqdPd92nYHu1+Z4G4SS?=
 =?us-ascii?Q?4esDJHItEws8obGtifcB2H08/ud4WXyn+qPk+Q8Vq8w6qC8M9QXvNTFip8u/?=
 =?us-ascii?Q?hcBz39uJMns+Kwo7VEhchO2qBQFbqHxmrHK5dENqxHotXmsP7Oo9OttrtHWD?=
 =?us-ascii?Q?5qMjh+3wbbOJkR0gSrPTWDpWBYOlRKv0AlWOhKAxRj4lOa7qExjhqwGt+low?=
 =?us-ascii?Q?kP/kzy9IvLxlkRBtYNzfjnj9THaZaTtGSI2stVr5GYlHOXs5Gp50/1IUVTXm?=
 =?us-ascii?Q?iyf5NzAFtEG8V/9vosBsm8muLx9zgbkhy74zIVaf3bSlPhwlIYb6MAa66Jc6?=
 =?us-ascii?Q?0yK8YjZ0tLq3NwbUBG9H5KXbTAIN5CObkq/K8x7p4NETBqli9ItVaBjFD2Y8?=
 =?us-ascii?Q?KIwPVrdWp/0TNl6nSYnsUhiVhnbB9RyKiDOM+ycyt6bZ2yxbSk+7MsYB+83r?=
 =?us-ascii?Q?rl6P/kxxmYE4WTlkG+oZmzxNDPjRBMkUTpd0I9dNu2ilOFNxM4fHV80TayJI?=
 =?us-ascii?Q?kaIHmBEN//SpRUWhuXgLZV/hvuDE6/fL2sHbPi8DkKn2XZX7sdduGg6rJioD?=
 =?us-ascii?Q?9v8yN259HAdrM6AL3Fy4+k5oiyMiUMuM7ystkJsEmJPfaVGY0wM2XJTIWSTU?=
 =?us-ascii?Q?rniwjDxh+SkmWUmSHim7idcJpbFAqfZOWHAykYhYOt6m/z5W33mNl9a9x6tn?=
 =?us-ascii?Q?KA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 4qcskpBxOIIHY/A2kb5SmfFvK8gpYgpWNdLihTCObnq87DPjy4Kgp225CzUv+mMaNCJYYasirH2MkPHP4GsN0JRclKVA10phT+0C3rLL/GnFZDj+SaPqE3V/6BWDdgIdOGUulUj6bBMy+UosoBOr56QLdSdqzQxovfynFAeHYf7H0ZTIupKelwVWyAJaYLrs8FPRArAqKVMgsmWbm14BIxdqLP8eGW/JlNq+/rJzMmPlTt/9HMx9rzO3PyW6LgRDtQsS77/VtkYM/IDuha4h2Xr6G2dk9Ygd1T1ZXJ4nOM0hPyXN6PUdX4/BaEfLwK+i6ZSBE3ouMGhMn9BavHh9CgQjVRxLqxReQ5nafl8kZoS2ExFfxftm4KOClJIa+nKLTPpqoLjqpGNK0ildVqn1OBDpAryRiD2X0PzXACeRYgHVdmsoaWmnuuYnyIoWZhNPcpnOZWJwXHZa+6vy/5ASzfjWyGxRaM2VOoBQOdDhdVr/hrSN7Wcf7j+0dqN6TIo2EiJgHH4ENfGXJEX/QRJ5jzSc090UiJomeDap5W/pRxes4sADxrGLMWw9SI7SJB15MbvXDJ85FCVgw6Juz+JAbIO/zzx52UdddoFofQ8Suq/v7FK7aDhAV3Jol8rAMc3VN8o1GfagT5/78GiUA1Q4ZOdIohfDF8Lp1XZ7l3gr06FQC73mY786fmsPVVbaSJ/1TbbZetFFc2UHmD8TNqEsM3sZc/qAzaaEnlGfT53hC4EqhvTtfxqY9r7Ae4LLIvStt+XL8VKstmbXtXwmdqpowyVaRukmi3Z/imLJApuhgRc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 049a09b7-d0f2-4baa-7192-08db89cf4418
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2023 09:45:49.7550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8D3eZoEwT1oYLquBNd8h54anVCTp+T9TrkkQfj/IGH2jnMPdq03jbWt+2IqJZVAkQWByeLslwa6zmmLTZ7NAig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4412
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-21_06,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307210087
X-Proofpoint-GUID: lg6zb-_mIZYMc0qCVbabFN_p8_hfteq0
X-Proofpoint-ORIG-GUID: lg6zb-_mIZYMc0qCVbabFN_p8_hfteq0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 27d1df43..6bcfd5bb 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2421,12 +2421,12 @@ process_inode(
 		case S_IFDIR:
 			rval = process_inode_data(dip, TYP_DIR2);
 			if (dip->di_format == XFS_DINODE_FMT_LOCAL)
-				need_new_crc = 1;
+				need_new_crc = true;
 			break;
 		case S_IFLNK:
 			rval = process_inode_data(dip, TYP_SYMLINK);
 			if (dip->di_format == XFS_DINODE_FMT_LOCAL)
-				need_new_crc = 1;
+				need_new_crc = true;
 			break;
 		case S_IFREG:
 			rval = process_inode_data(dip, TYP_DATA);
@@ -2436,7 +2436,7 @@ process_inode(
 		case S_IFBLK:
 		case S_IFSOCK:
 			process_dev_inode(dip);
-			need_new_crc = 1;
+			need_new_crc = true;
 			break;
 		default:
 			break;
@@ -2450,7 +2450,7 @@ process_inode(
 		attr_data.remote_val_count = 0;
 		switch (dip->di_aformat) {
 			case XFS_DINODE_FMT_LOCAL:
-				need_new_crc = 1;
+				need_new_crc = true;
 				if (obfuscate || zero_stale_data)
 					process_sf_attr(dip);
 				break;
@@ -2469,7 +2469,7 @@ process_inode(
 done:
 	/* Heavy handed but low cost; just do it as a catch-all. */
 	if (zero_stale_data)
-		need_new_crc = 1;
+		need_new_crc = true;
 
 	if (crc_was_ok && need_new_crc)
 		libxfs_dinode_calc_crc(mp, dip);
-- 
2.39.1

