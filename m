Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03B04C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234759AbiBXNFI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234769AbiBXNFH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:05:07 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21AAC37B59C
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:04:38 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYb9K016953;
        Thu, 24 Feb 2022 13:04:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=zdGyEC5/oPROdA3TXjcy4dnwdbJFaJX8vhp2pJR2CUs=;
 b=moR7g/ahzAQVeMhr+BXkcd+RAlu+3DwTDbGoL2beafKQSkV+MB04YV4cpb18H4p0HtDX
 o5qSftZv4I3P1dyFELMzo6wS5vd0akPNilNzn+OZk7a6/CS+b1gXzbNvjQWxtn7BHjkp
 Nc8W4lg6y3WBw/NqZykOOiJqaAvXQivU2SJHEyY5u5LHIO1tgckBSe/Hr9O5Pb3Zs9aO
 XD/xXAjcDTgDQE6WG554S4XIiteOgSQVGN5L1vpQd5/W7bn9uPFTJyODfHgX8H+bTs9q
 llzWrcPVrHspYQr3jGxlJw/oJUbd4M7Jk1n/xV+MqGCOQ3ZOS1opYtFSJGk4s4ZsjGBT 0w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ect3cq4gp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD1upQ040492;
        Thu, 24 Feb 2022 13:04:33 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by userp3030.oracle.com with ESMTP id 3eannxdfc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ksVMniPo4CPKw9ZBL8Q2sqgmDLuOg9mTA3TKiJBEUEAeA7gWFVz5ITLIzDkToGGXQgsz5sgM6LI0UzTkqppB6WoprSjYg+IVgCHrzA1Nr4w7xJU/ba5cj5iOAR86Yx7uDhZF2WxBQeilt6N5a+Ugj0TCI9Nz8MjZn5VjySCP9r0RYLBXAuLsZw3RZEKpvpBlwD4hXjm3xwbt439R0Myaeuy2+JVso9oTiGWFvvghbXy8XQq3EqvmnJxDF6cZwU80gjPlukN2i47oyGobneOWyAoh34hfPmNwoTB7TlxRCJGqmRCMUdvSiJv+jpmoxawD8gkwoG7eXeUuLw10zhjLFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zdGyEC5/oPROdA3TXjcy4dnwdbJFaJX8vhp2pJR2CUs=;
 b=Z6kh1KDuMYRESujpovSztXraOiBsLsA6Aua/fy3ee0kyqqPaVrB0S/LqYg41BoBPSnmE4UZK5eSXR+YUx623yOKwuV36zSVmRN5HdkMwDTJw7KmcgDUUyACWxkypF/L/GEy2tEQS6wfzTggotf5AplFeH7azLy4juP1TxsW4h9h4R1hp0KjL5CzHcvsXpBNBrpGwB6Q7Px7Qu7zLy06ELUGmXYOgt1WxSyMTRUkHtY66f7gNMUm2qdJ9/Hm4TwFJQ9GD7Kzuvdk7hziPlOoIMQFxEpn2iqpPeBRUn/jvMUwMhFiBxIzj1zwUmd3E7mYHjyWUthRYIL8xlZdiBw+dXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zdGyEC5/oPROdA3TXjcy4dnwdbJFaJX8vhp2pJR2CUs=;
 b=aWoJ7P3OthZVS/AnzJjOA8AzrULn/Vc4l6zyr/thEzh4XOgvKi/SCPM64lyeYOwKOvZ/Urv61BMDY3dqvOqqLE5yh3NgqubVNtfYaUU51OTdsUz/RnDwJuOdRxqcWiCI9yIU9yuy1/v1cTomJoJo/01sIul5x9ZDjHLU3PStQDY=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM5PR1001MB2172.namprd10.prod.outlook.com (2603:10b6:4:30::36) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Thu, 24 Feb
 2022 13:04:31 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:04:31 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 14/19] xfsprogs: Enable bulkstat ioctl to support 64-bit extent counters
Date:   Thu, 24 Feb 2022 18:33:35 +0530
Message-Id: <20220224130340.1349556-15-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220224130340.1349556-1-chandan.babu@oracle.com>
References: <20220224130340.1349556-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0013.apcprd04.prod.outlook.com
 (2603:1096:4:197::6) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa3f8e6b-45e2-4770-918a-08d9f796324f
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2172:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2172C828C1056E0C8B28548FF63D9@DM5PR1001MB2172.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EI8VyjO95Pp07eorO9mLyTK6VsrpVljBFBIsVcH4EMcQUUUeO6PA4wHACfAS8Rh2cXBVGTd+tUM17coynLjfRi4xtaVGQNPcUmFSRTSbZbbiV/7OF/tloTFZUAKLnSGRKqVtPiT2QalEx/Vm38fG5CSVZ2VSKf78s8OGPPtC9vmgr7m7fs89bJyX/yReX5bYD8tR3g/n5ECaXbL8xt/vPOHutBC6/uAzniE2pqmZtd2jO5MsINEh1lJGWmAsHHjGtbIdSoX8ad0IY9A+6H3yhzLEnBG05bM80gnSNgGDHuWuZ+kUVJSHKwhaiyUQ3glp5Sklt8CBI0Do4FmfyJYvunIWAO7JIRjQvpnBh15T6q/f/nhHAUW2WApFQdPhi9RMvvl+/nJRW7vi/HZK2AAWdnK4kL5Yc8N+f21QsSx+fkVopx93S+LG812YbsTeoy9sfduvuQiKpaVV/IicBQaKAMJVg/8FF97HU2dz1105sbHgkoUTUQ09mpeDz6pSCzBr+ujqsvvvcn98mONNu5dJhv3komCUGOS1MTaS0FVGkss0YjDHoNjsG8D/xNkM1RQXtUCHIuNh2QhjkSO/FPCruk47/t4ZUPjbgbhVmiX9N4ki916Ow6egyYxRc97xfZn/Tv8Yo4i2pRnlB7Vnou5+pRrLhdUchl7ShKq8DEepTyHA/r6L+9j8RfxQWHA9g9qkBeHCCIC0v683ZAjRiYCi6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(6916009)(4326008)(508600001)(6512007)(316002)(66946007)(66556008)(38100700002)(8676002)(66476007)(5660300002)(38350700002)(6506007)(52116002)(86362001)(36756003)(2616005)(1076003)(83380400001)(26005)(186003)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8b+KCmEPx/0aVIydMhZtXeTeZ44gxOCtls2pjp8RVFaLk9UIwcyDAoRpWtEh?=
 =?us-ascii?Q?kUZzdAyaYIb7n//IzmbnfZTTIjpaPSI3CnXgXQ2ZQnXnOZ4LqAEVxl3QNq9e?=
 =?us-ascii?Q?oa0ObxJLhHqlBUQu3ApO7pxqEP4BB64FwNXq09vhK+MZ3ykYbOqJaFqAZ6Tf?=
 =?us-ascii?Q?6GaEaletMXd3qIOZTUWbgVoeU336x/Ozk5qBln6CHOk2fyWX1GcPsWgh6RH+?=
 =?us-ascii?Q?raeBlDewHhdgGl0LbQ6rv1w2C1p/BcWJr0mVryAf0LZmG95gNZytpFAQ3gNj?=
 =?us-ascii?Q?Bt19Xpen0pPANvq3ogmF7hOC5tALCG6zY/1+8PQqgdzjAWDHym2pvAAUIl4T?=
 =?us-ascii?Q?7Y2G7M9Qva4NAc441E9cw7yn9e80l4K+maP4fdMRT28lvQcrvVyUkcO3plae?=
 =?us-ascii?Q?vR+gvuLhe4kQVFY3m7QY2yGE4yjz93HTmp0e9uQYTsUG8Xpx1X/2RuxsxNer?=
 =?us-ascii?Q?1eZICOtT4G4RFtXb/k446mjL0tLKBEGYg5O0LfvEzHn9+k+UdiDKy3+LH3nr?=
 =?us-ascii?Q?EBlOfD7alj6ICc+gT4m8bJeDewODOQiM+0VRK0vpJLYpPVwvxw2lRUaiPQRs?=
 =?us-ascii?Q?+gr6yhe6eR22AO58mLpX8JBORGFXmydaQHoMnyJS6UCovlKydT/TtJviEkfO?=
 =?us-ascii?Q?GMKZRPFGedTneaj503apiqpevXeLUfqvPAtGxNR9l7j2M8n1Bsc+wzUlRC+N?=
 =?us-ascii?Q?lqWcI+zqRSoc3dPZRDXeGMtGyXYBqU11fSTHmOJ0dJ9B42qoZ23N1MkgkPmH?=
 =?us-ascii?Q?6HWnePP1RxdbuPHokhxHjZKlgrvZ0GCLALB6OKtO/IMwira8TGRm12gs3auY?=
 =?us-ascii?Q?h48o+YacLAklfarJ3Rtcs3s54gJva/uQG/lMNJKoZ1UyvJqQImJIWK6jwyR7?=
 =?us-ascii?Q?3l46eskU0CB+EEFGoj33+U+9EDf0YxkMXt+UQKxhQlYYgqYt7DXuQq75rm1g?=
 =?us-ascii?Q?9R1cW2lEz2Yu9bfgUUvR/xt6+XWF5dK+KIiAv1WNAdgiPojc4aAy3dWtOeO0?=
 =?us-ascii?Q?5VF/zxoj7LKHpCeNXUO8tUumFT2nJOJUSDq9p1akuQTshsFvSrxFKL5BoZSc?=
 =?us-ascii?Q?dd4ntlaH8SrF2loUf4QxQDo0sFD91+OzVCvboTm5Ux5TLifK4M1yOSY40rka?=
 =?us-ascii?Q?TN3i6yaR4M927llldAophVpTjBtqfAsDQXBCTmdT2BYySBRefevnfUbkG1Gu?=
 =?us-ascii?Q?+5Ps+ISL9bb6olqdDvSStvkQD7VnSskbVi45ZK4Co3u3x3VDTrORsUKv7xsa?=
 =?us-ascii?Q?oB5ehOElNodS6GsPsjtgB8RkFuN55p5LDZgHPNLFu3NY1f51Tqq0HTH4Xx89?=
 =?us-ascii?Q?dkAGc7aDCEa7kD6IFWgvYjmiHFLZSsCrMFenrnJjD11R6Njg/6I2+fPgB7Vy?=
 =?us-ascii?Q?AE0vNgZnrgu2rAjx9cRdLbY0A16ot2jqorAB2eNjSpXMWLw8WBB2xdKXAd4K?=
 =?us-ascii?Q?31NhmS8vzWsXIfN2U/CRDBIr1DZsa01F8jMW2SHNaP5gHT4ISg/CGlk8Xelc?=
 =?us-ascii?Q?XeejeI5SrKq11t0psJw0ry3U26fFwGOvopBdNHyqTHrc9lAiC6HIfjjGK3fL?=
 =?us-ascii?Q?xsKm46ffO+pFtgrW8G79Z634lmgXt1Aqcn7TmhWWE98YppaQ6pXzyD7PpAxO?=
 =?us-ascii?Q?Xq5fLh/E1okWafQzojNNfno=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa3f8e6b-45e2-4770-918a-08d9f796324f
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:04:31.3365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7iSGnG4M4WBhhp7jOEQ3dGC+kQLFu1BH95xALu4ZxZfwjNEoc9dk4p1ePLiF+fudSqdaQMjMOwYeHlsFP1KnnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2172
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202240078
X-Proofpoint-ORIG-GUID: O2oi9n03CLk2XvWPde-SWSP0sVGfTooy
X-Proofpoint-GUID: O2oi9n03CLk2XvWPde-SWSP0sVGfTooy
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds support to libfrog to enable reporting 64-bit extent counters
to its users. In order to do so, bulkstat ioctl is now invoked with the newly
introduced XFS_BULK_IREQ_NREXT64 flag if the underlying filesystem's geometry
supports 64-bit extent counters.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fsr/xfs_fsr.c                 |  4 ++--
 io/bulkstat.c                 |  1 +
 libfrog/bulkstat.c            | 29 +++++++++++++++++++++++++++--
 libxfs/xfs_fs.h               | 20 ++++++++++++++++----
 man/man2/ioctl_xfs_bulkstat.2 | 11 ++++++++++-
 5 files changed, 56 insertions(+), 9 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 6cf8bfb7..ba02506d 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -590,7 +590,7 @@ cmp(const void *s1, const void *s2)
 		(bs1->bs_version == XFS_BULKSTAT_VERSION_V5 &&
 		bs2->bs_version == XFS_BULKSTAT_VERSION_V5));
 
-	return (bs2->bs_extents - bs1->bs_extents);
+	return (bs2->bs_extents64 - bs1->bs_extents64);
 }
 
 /*
@@ -655,7 +655,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 		for (p = buf, endp = (buf + buflenout); p < endp ; p++) {
 			/* Do some obvious checks now */
 			if (((p->bs_mode & S_IFMT) != S_IFREG) ||
-			     (p->bs_extents < 2))
+			     (p->bs_extents64 < 2))
 				continue;
 
 			ret = -xfrog_bulkstat_v5_to_v1(&fsxfd, &bs1, p);
diff --git a/io/bulkstat.c b/io/bulkstat.c
index 201470b2..0c9a2b02 100644
--- a/io/bulkstat.c
+++ b/io/bulkstat.c
@@ -57,6 +57,7 @@ dump_bulkstat(
 	printf("\tbs_sick = 0x%"PRIx16"\n", bstat->bs_sick);
 	printf("\tbs_checked = 0x%"PRIx16"\n", bstat->bs_checked);
 	printf("\tbs_mode = 0%"PRIo16"\n", bstat->bs_mode);
+	printf("\tbs_extents64 = %"PRIu64"\n", bstat->bs_extents64);
 };
 
 static void
diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
index 195f6ea0..0a90947f 100644
--- a/libfrog/bulkstat.c
+++ b/libfrog/bulkstat.c
@@ -56,6 +56,9 @@ xfrog_bulkstat_single5(
 	if (flags & ~(XFS_BULK_IREQ_SPECIAL))
 		return -EINVAL;
 
+	if (xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)
+		flags |= XFS_BULK_IREQ_NREXT64;
+
 	ret = xfrog_bulkstat_alloc_req(1, ino, &req);
 	if (ret)
 		return ret;
@@ -73,6 +76,12 @@ xfrog_bulkstat_single5(
 	}
 
 	memcpy(bulkstat, req->bulkstat, sizeof(struct xfs_bulkstat));
+
+	if (!(xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)) {
+		bulkstat->bs_extents64 = bulkstat->bs_extents;
+		bulkstat->bs_extents = 0;
+	}
+
 free:
 	free(req);
 	return ret;
@@ -129,6 +138,7 @@ xfrog_bulkstat_single(
 	switch (error) {
 	case -EOPNOTSUPP:
 	case -ENOTTY:
+		assert(!(xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64));
 		xfd->flags |= XFROG_FLAG_BULKSTAT_FORCE_V1;
 		break;
 	}
@@ -259,10 +269,23 @@ xfrog_bulkstat5(
 	struct xfs_bulkstat_req	*req)
 {
 	int			ret;
+	int			i;
+
+	if (xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)
+		req->hdr.flags |= XFS_BULK_IREQ_NREXT64;
 
 	ret = ioctl(xfd->fd, XFS_IOC_BULKSTAT, req);
 	if (ret)
 		return -errno;
+
+	if (!(xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)) {
+		for (i = 0; i < req->hdr.ocount; i++) {
+			req->bulkstat[i].bs_extents64 =
+				req->bulkstat[i].bs_extents;
+			req->bulkstat[i].bs_extents = 0;
+		}
+	}
+
 	return 0;
 }
 
@@ -316,6 +339,7 @@ xfrog_bulkstat(
 	switch (error) {
 	case -EOPNOTSUPP:
 	case -ENOTTY:
+		assert(!(xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64));
 		xfd->flags |= XFROG_FLAG_BULKSTAT_FORCE_V1;
 		break;
 	}
@@ -342,6 +366,7 @@ xfrog_bulkstat_v5_to_v1(
 	const struct xfs_bulkstat	*bs5)
 {
 	if (bs5->bs_aextents > UINT16_MAX ||
+	    bs5->bs_extents64 > INT32_MAX ||
 	    cvt_off_fsb_to_b(xfd, bs5->bs_extsize_blks) > UINT32_MAX ||
 	    cvt_off_fsb_to_b(xfd, bs5->bs_cowextsize_blks) > UINT32_MAX ||
 	    time_too_big(bs5->bs_atime) ||
@@ -366,7 +391,7 @@ xfrog_bulkstat_v5_to_v1(
 	bs1->bs_blocks = bs5->bs_blocks;
 	bs1->bs_xflags = bs5->bs_xflags;
 	bs1->bs_extsize = cvt_off_fsb_to_b(xfd, bs5->bs_extsize_blks);
-	bs1->bs_extents = bs5->bs_extents;
+	bs1->bs_extents = bs5->bs_extents64;
 	bs1->bs_gen = bs5->bs_gen;
 	bs1->bs_projid_lo = bs5->bs_projectid & 0xFFFF;
 	bs1->bs_forkoff = bs5->bs_forkoff;
@@ -407,7 +432,6 @@ xfrog_bulkstat_v1_to_v5(
 	bs5->bs_blocks = bs1->bs_blocks;
 	bs5->bs_xflags = bs1->bs_xflags;
 	bs5->bs_extsize_blks = cvt_b_to_off_fsbt(xfd, bs1->bs_extsize);
-	bs5->bs_extents = bs1->bs_extents;
 	bs5->bs_gen = bs1->bs_gen;
 	bs5->bs_projectid = bstat_get_projid(bs1);
 	bs5->bs_forkoff = bs1->bs_forkoff;
@@ -415,6 +439,7 @@ xfrog_bulkstat_v1_to_v5(
 	bs5->bs_checked = bs1->bs_checked;
 	bs5->bs_cowextsize_blks = cvt_b_to_off_fsbt(xfd, bs1->bs_cowextsize);
 	bs5->bs_aextents = bs1->bs_aextents;
+	bs5->bs_extents64 = bs1->bs_extents;
 }
 
 /* Allocate a bulkstat request.  Returns zero or a negative error code. */
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 42bc3950..369c336c 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -393,7 +393,7 @@ struct xfs_bulkstat {
 	uint32_t	bs_extsize_blks; /* extent size hint, blocks	*/
 
 	uint32_t	bs_nlink;	/* number of links		*/
-	uint32_t	bs_extents;	/* number of extents		*/
+	uint32_t	bs_extents;	/* 32-bit data fork extent counter */
 	uint32_t	bs_aextents;	/* attribute number of extents	*/
 	uint16_t	bs_version;	/* structure version		*/
 	uint16_t	bs_forkoff;	/* inode fork offset in bytes	*/
@@ -402,8 +402,9 @@ struct xfs_bulkstat {
 	uint16_t	bs_checked;	/* checked inode metadata	*/
 	uint16_t	bs_mode;	/* type and mode		*/
 	uint16_t	bs_pad2;	/* zeroed			*/
+	uint64_t	bs_extents64;	/* 64-bit data fork extent counter */
 
-	uint64_t	bs_pad[7];	/* zeroed			*/
+	uint64_t	bs_pad[6];	/* zeroed			*/
 };
 
 #define XFS_BULKSTAT_VERSION_V1	(1)
@@ -484,8 +485,19 @@ struct xfs_bulk_ireq {
  */
 #define XFS_BULK_IREQ_SPECIAL	(1 << 1)
 
-#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO | \
-				 XFS_BULK_IREQ_SPECIAL)
+/*
+ * Return data fork extent count via xfs_bulkstat->bs_extents64 field and assign
+ * 0 to xfs_bulkstat->bs_extents when the flag is set.  Otherwise, use
+ * xfs_bulkstat->bs_extents for returning data fork extent count and set
+ * xfs_bulkstat->bs_extents64 to 0. In the second case, return -EOVERFLOW and
+ * assign 0 to xfs_bulkstat->bs_extents if data fork extent count is larger than
+ * XFS_MAX_EXTCNT_DATA_FORK_OLD.
+ */
+#define XFS_BULK_IREQ_NREXT64	(1 << 3)
+
+#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO |	 \
+				 XFS_BULK_IREQ_SPECIAL | \
+				 XFS_BULK_IREQ_NREXT64)
 
 /* Operate on the root directory inode. */
 #define XFS_BULK_IREQ_SPECIAL_ROOT	(1)
diff --git a/man/man2/ioctl_xfs_bulkstat.2 b/man/man2/ioctl_xfs_bulkstat.2
index cd0a9b06..59e94fc4 100644
--- a/man/man2/ioctl_xfs_bulkstat.2
+++ b/man/man2/ioctl_xfs_bulkstat.2
@@ -94,6 +94,14 @@ field.
 This flag may not be set at the same time as the
 .B XFS_BULK_IREQ_AGNO
 flag.
+.TP
+.B XFS_BULK_IREQ_NREXT64
+If this is set, data fork extent count is returned via bs_extents64 field and
+0 is assigned to bs_extents.  Otherwise, return data fork extent count via
+bs_extents field and assign 0 to bs_extents64. In the second case, -EOVERFLOW
+is returned and 0 is assigned to bs_extents if data fork extent count is
+larger than 2^31. This flag may be set independently of whether other flags
+have been set.
 .RE
 .PP
 .I hdr.icount
@@ -161,8 +169,9 @@ struct xfs_bulkstat {
 	uint16_t                bs_checked;
 	uint16_t                bs_mode;
 	uint16_t                bs_pad2;
+	uint64_t                bs_extents64;
 
-	uint64_t                bs_pad[7];
+	uint64_t                bs_pad[6];
 };
 .fi
 .in
-- 
2.30.2

