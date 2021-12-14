Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABD2FC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhLNIuS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:50:18 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:37846 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229577AbhLNIuR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:50:17 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE72VSq021596;
        Tue, 14 Dec 2021 08:50:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=NmN7m4isKvNgZ1B/HaPdizeUa3D5dWVMWHZm3NbKXOI=;
 b=CCYE5FXhhCBE5MBndZKv+KuH2LMghx2syDOO/Fr8GoE0BhrE/2aQydt/VNCFI62vNgsf
 /RcIeHJIlUh2Feztoc/0exc58R/FCspJAqOgGOQFPRMYosys2eCuVXN3sYUQUOiMDO+T
 YBBAQHcrMxUg/L8tbqdzctmXY8BxybYnWYbSUx4Q75spSLk28q9WZTXH+8LXvLcmXqNf
 xtsEC1/aHyji3+kRK64dMWroyfuQBsMlRLUu6MtOwIwjQTRurJ4mpawDmd0I4wEqH1b2
 ydMQ41qID/v/uCqHXPGVBlCzky6ehG8LABvQsuewxpE23gy+m1YXy/dfwb4uLQ75fhyR Dg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx3ukb30a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:50:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8fXkH156410;
        Tue, 14 Dec 2021 08:50:13 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by userp3030.oracle.com with ESMTP id 3cvh3wy85g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:50:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uxr1zZIUpx6Ab6WVM60XlOlxcAc/BvH/NA7hLCuZSSOmMbYHASbSPnypXejX9Y4pp4jWXv1MlKQ/l9Ua3unlHaVmhXjXi5vh7VXSY21Oc+Yj7LIZjVPrQ73boR681KzNiggDdlzhOHOkuZPQ9i4ea1OPQ1dP8TrDsM5i71zP/5oSM5qahtWEN/TKnQTIiVaopkV3h5PULlZbdyKZUg7gxHOe0lTOTJMQ3VFvqXhwozFjeXDZVnopb+q8ig9tL1pL3PV9DlzTAn0htetHFCsVuZKIgldp3n5qxDEgdkPi+FLgqdwPisJi55ldoBRGYyEQc0AOOLT/qSqCf80OBqiu1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NmN7m4isKvNgZ1B/HaPdizeUa3D5dWVMWHZm3NbKXOI=;
 b=eOL2etgc/PR12rhdm8e6hZPzBdyYvqojIObsuoWjzQWIAiz1rz0BcZDnVaFzpnrxkpd/tizpwZSCihUm6xFrNWNmu/sWFxl1nac1DwGAmavpgj2oiALG2t6DlBeOtaL0CbsDEbOwkw0k97T/nG4E9df4F05ZZdrKs6weieNrKt7SXcEVCyjPIC9i7zoZYS8WosAor0cGfapbwySh95pUPZ8HnSw5zDBunob2bygjz/HbiH+CkM40dZVraU9K89NS7IcVLv3AytjJYR1O6eEsCsS5eOnH+fzlD+i3WjbRJXViqDrWY06DjN4kUPXztzmwfQo+GfCICStxNh2RKROQHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmN7m4isKvNgZ1B/HaPdizeUa3D5dWVMWHZm3NbKXOI=;
 b=msQuwPEho5xgFroQfFZScqATTTVpPzzTWQ3mDroBslPq9io+bmQghGRg8Fmml9F720ICyZNJJ60dlCbVGdgLXMisFUbnGijgcG9ilvYlch5UAX7iPmu4YAw5zKrXNIOPLVRNJpe2x/MzpT6oq1mMcqhCgef9TS1YtBzz3PtOsls=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2656.namprd10.prod.outlook.com (2603:10b6:805:42::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Tue, 14 Dec
 2021 08:50:11 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:50:11 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 16/20] xfsprogs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to the list of supported flags
Date:   Tue, 14 Dec 2021 14:18:07 +0530
Message-Id: <20211214084811.764481-17-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: fc0e2bcb-a058-41bf-eabf-08d9bedebd2a
X-MS-TrafficTypeDiagnostic: SN6PR10MB2656:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2656FCEBF417FA07CB398E4CF6759@SN6PR10MB2656.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:151;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /udwgrQ+AknoP2dwnOLd1huzY5lo2swhYQ9G2Obx7wIbaHrI7UrgWy/wDav9CNaur6RXXeLJMh66jBF/tSK77BonyanTGMZpeYzGwbkoZl1ZRH57ufm8BD9qBJ8/u0oOTS5ABoodviK5nDyUnteyoSETSoX640LLtXjZXIW5jNCmbnGkWvOPQ81eZPv6DOeADzsxzYTxzE4Tk0K2EAPzsPMOUaCEfxRnSdRaTztgi6NEKqFrbaKECNSPn42o2k/+cFH4yi7rx74lM43ff3/1RkrjQZjpv2eSZAx0sIrmJCb3cL6cd2H99YJiiS4BSgVNi7lZ5huZpEpn90OXIvcIomHP+L3oBWylTEVXAMaWy9lzXH/pIJnhUqn5clphIafDJfpD3KYARtytIib+NrdUyGHu5ZN4LYbjj9/RI9ZiDjYOgFTXuRR62ukdyn+m9G9KrBqbMqJIQBoDMiudoyWss23j87Khx/1oojnAn5J7VC4R2rFMf7RiGRpcCTGfaBqfnl++u4r9i24wuNNkOyVHqT+BXPOVzTdH0MGCejJ2oNoV+MSkwlJPegpc3nngzDZGo0rApehelVGVhM/0ZPOFhwrcAFGGGFuOEqt08sC+NL+lrCj9An+rUpXXmmZ6Hb1GKEiTGofrPOhcYXYItfuFEJTWsAqvnP37oDlZ3Oec0wFn9eOz+6sNHJ4SUx/IJPO9tQFSIR7Knsl7jUuwGOryyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(508600001)(52116002)(86362001)(186003)(6512007)(8936002)(6916009)(66946007)(38100700002)(38350700002)(5660300002)(6486002)(316002)(8676002)(66556008)(66476007)(2906002)(1076003)(83380400001)(2616005)(36756003)(4326008)(26005)(4744005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z6N2KFT8E49fKvkWNog4FwZ9YwP84SBMU39YofY68eus6HIkIOJTN+EtgRk8?=
 =?us-ascii?Q?BPulD6tuHoIRutWMbogBeNkzZDb1peSdTeRt9aj3UOFTYzmh/OidMAXw7b4t?=
 =?us-ascii?Q?w+ASA+dD90kYL/JhKmIuqRkqyjQIXoc3pMiLDZXrx1vvY3+99G1gN4nkSQrs?=
 =?us-ascii?Q?X7h4DcUkhD2WYMwkMDSo4ETp6l3QfVn2/hbKT8AvGDMCnNahOCD7xEkR3fTq?=
 =?us-ascii?Q?W/mXDsrfJUztVEWUaQim7hn0vEq/KhysfQl8cZPvG0S0cYhL3o580nEnblWR?=
 =?us-ascii?Q?tcJWrFqLXtzSvoXF7SV+LXLvzMRteJBwHle0JnhwTMqbMyhjN7RpdehwNVFu?=
 =?us-ascii?Q?yDTy5vQAhPIWb+5tJ7oW9SasluKSTeLdpt28lR/AbZCtAmIJ+4Q8Gmb/tyNE?=
 =?us-ascii?Q?iIm7ss+oMx/CMcPb5xhadjW4qWW1fEfG13MPO2uvp96OPq3XZXr8QJdis78l?=
 =?us-ascii?Q?wtf15Ye7HaPDK4WwDFm88Kdos8pzxkw7i47DC2+GaoBPZhnU8B7+ZCW545eU?=
 =?us-ascii?Q?I5QivlaPsgsSXSSvJVxs394fGWWNcrC9C7RJgzIpWRcWhaWEMTFVP9OLumg3?=
 =?us-ascii?Q?a1XaxaUhAJGe1FfQHTTHB/KCflUM7rL+SU5/0nmubcYWFg1ZWDyrLpJwjaI7?=
 =?us-ascii?Q?wMC9WttGTQRAvTqpeYr/Svm4Sy8mhx4E99EPBsF1ikvX61z3pY19WzMQP9Rt?=
 =?us-ascii?Q?eDXzu195CnQKHE77c4XOEpz3R3Go/j8XnpAdE9GZljXHIvtEzaLNM0ClOM0t?=
 =?us-ascii?Q?7ocbR7RQtJi9KqKfT1g38Ibc6+bmocuXKGqqTaERakxizmwUuY3GmG89UFjV?=
 =?us-ascii?Q?KaULlFS2QuiERFgq4b+n0HKYSByzyzZ8u3Ikbqu0tpbEMBA7ra6e9QjjaUPM?=
 =?us-ascii?Q?Je5qgZex6rqKKU5OAgdTuwf+MDS2/8dPNoCs1nwSjN9HxqxJSKKAhgTJCLcJ?=
 =?us-ascii?Q?5CUNBp2znswxJzQzvzAqf4zeo4UtN7yyqZebX/VpJ7MukvK0QQDUu0K5MXVv?=
 =?us-ascii?Q?bICWImwMD0YCuJks0H2/DTJdwMgmM1uy1FqDV7W4P2egLw0eVlz0ZvdIiHXu?=
 =?us-ascii?Q?jzKotcQtk+1G/twPkho0M/+7ay/blJFJzjxrBLeQHQaf86M9ZxQyo+JQnA3v?=
 =?us-ascii?Q?ZCXXPU8bcGkZGlW2/W4L4u050lV+5RRA6Aq3p0MEF/xJ31lesiGoPmytTtQC?=
 =?us-ascii?Q?S5K9dFk2CU0Nz8TibPRG3QpzaF6zBHovJ7Ii8qlXHbHvLCcn3ykja8DMXlvF?=
 =?us-ascii?Q?tjSKRzkWxslvhVnX7AUEcnjV209YuHItzGeldmAkffpdDoMrkwQFTsMZ7kYt?=
 =?us-ascii?Q?UUCCYqkQuZ+UwDJOe5N+SyddBgRzNjCp60MDfOGjadXLqXFnMIZlgdRHdzol?=
 =?us-ascii?Q?S69j0fy7fhq3Xm76t1aCB0CGHo5o1nuPjVRKv2qwIVWrCMQKYmvrDk3TQOyL?=
 =?us-ascii?Q?Ddtgtt2oMeUdcNuXgTWCiQTiBSyWGETRwe+ZRLo5NzlGmJ9lg1OMTEfKXxZy?=
 =?us-ascii?Q?V1aPaMdbZ3XHbT6n2pqrgBxGFH7Ri9Mv2XQojLKNE5R1aZeToNV/u2uOMRQH?=
 =?us-ascii?Q?fBlXYF+GfWZ0V3lSN3YcK8fWBkA+vjgxWYyZWa9Pau1e9xgm+pFIbFE436KG?=
 =?us-ascii?Q?BxL90VWhaAlLF/wcKGPf2RA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc0e2bcb-a058-41bf-eabf-08d9bedebd2a
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:50:11.8933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9qlGGGnK4OyfRi7U38FdKGDkFDSUS2bOapRS76lfeMVb57+h2oEzWj+g+MxW3C/qytVLLh7J2l54Mw4Jyu/YHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2656
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112140049
X-Proofpoint-GUID: P-_tQJP5LmJgHzGRlU8dkeGTAdiZjoPj
X-Proofpoint-ORIG-GUID: P-_tQJP5LmJgHzGRlU8dkeGTAdiZjoPj
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit enables XFS module to work with fs instances having 64-bit
per-inode extent counters by adding XFS_SB_FEAT_INCOMPAT_NREXT64 flag to the
list of supported incompat feature flags.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_format.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index d4c962fc..0ed9d5ac 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -475,7 +475,8 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
 		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
 		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
-		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR)
+		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
+		 XFS_SB_FEAT_INCOMPAT_NREXT64)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
-- 
2.30.2

