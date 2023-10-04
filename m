Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1DD2E936E7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Oct 2023 20:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbjJDU6R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233286AbjJDU6Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Oct 2023 16:58:16 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1CC98
        for <linux-xfs@vger.kernel.org>; Wed,  4 Oct 2023 13:58:13 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 394FIvNZ014834
        for <linux-xfs@vger.kernel.org>; Wed, 4 Oct 2023 20:58:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=g7P4Y+THHP4WwsKZvtThh4rr9436WGsikfhqabVdTvU=;
 b=yAYRMzmm2+9S9C51YKNOpr1TyBfxnDH08idIKzmVRvkP4j2oGeBY+FxcJ+2Vuz6BGmG1
 lHu6U5XxL1G5KCBiDYz2ccZeoRxlCp1lnhSdpydMf8Qnd58ZgThqtHQSUhhilfe4aVHI
 YXx8ySTJfKf0oX8sXBC26ROgm9rCFdUojdGAiX1lPBXwfZjBLtSDtFNdksnnf1rqQxHx
 BdOS8smNbKgyE+JVw3iNmXvVqcFXAO+HMTolq3nSqZXDWp8sK6goi7g0KSFpMdepvIwp
 HejH1ap0LV32xO3ljQ/lvVStlhJJp3F/B7ypPL9+sfAHoRhEWmyUCrvBZwj6lNRTNAV+ lg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tec7vg07m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 04 Oct 2023 20:58:12 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 394KJvNX005975
        for <linux-xfs@vger.kernel.org>; Wed, 4 Oct 2023 20:58:12 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2041.outbound.protection.outlook.com [104.47.57.41])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tea4866td-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 04 Oct 2023 20:58:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MdGhKwq04AzjOvgQDU4LshSgyNxENC78rKt6Dj9NjmbtqS2Al4ybkUz4mISKXvkNl44azYy1on4wf22G+jRzqOhAlhvh0Yfu8OJi4dgME85J+fGCWb3JEJJDyPqkG80FeIDoAvyISrDS0Xw07LXfVQLV/AYNKI3rkUhEVJGsZ9wTp/7JA+ioki3ULwMtRHbd/Dtijyoq3w+NVvvJm3UHpBqVUdA6ezYiO2j6GfQYHX1X199gYCEp2oNpEh8UY/3MuEo5GsfWOP5xZ2xVsIhpT/Anm3YSS8MvaywzzxYGdpXawxfjsjqibhcPbNZqqUeO6cr3/ErEwhDZigcIdrldtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g7P4Y+THHP4WwsKZvtThh4rr9436WGsikfhqabVdTvU=;
 b=g1i12jLrAFKjbuC/etWWQAl5CO4T5HWSM9J0XvjgxNN85r/kX9cwsFZHsjTsLMulJt+GOVHXXAUVUz3nKSVIoIizYPki1lUv/TmZBsJc3r+QBxMqbgue7r+P+Ha5Fiqujj83uPYFcam6CnKF5MjE09rw453fgWrSoJSlNArReUsgctfJttvEtPk/ZrwPUXGCMnTawnqWk52Ru2jqu69PxZ7eSgbbdH68s5556CwGeKt3Wbcl3NDbrTKane5FQsM6AIZC06jXXuVV/jDsd3NUDhnwozqzA6xWWqccQUhlNCvypBdJsD7m+exHuU2eItFcyc3IzEXXpRIoJri8CwQ1jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g7P4Y+THHP4WwsKZvtThh4rr9436WGsikfhqabVdTvU=;
 b=iN0+uGNWCfOcCEFE4qAj9oY5tdJwpZwF+ydOzuf6PIbest+0RyJzrYa550L5UfJFZTScAwpOv6VK0rZa/8psSNN2+UWxzK4tFB9CYVWAIAY9BXICDXnx9Ut5DgmfkHyWpOL5j9UFfk8O5lNjyq27WUWH8LpvsNcz9xsj3/sIzNg=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by SA1PR10MB5887.namprd10.prod.outlook.com (2603:10b6:806:23e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.28; Wed, 4 Oct
 2023 20:58:09 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::9ee1:c4ac:fd61:60fe]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::9ee1:c4ac:fd61:60fe%3]) with mapi id 15.20.6838.033; Wed, 4 Oct 2023
 20:58:09 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1] xfs: allow read IO and FICLONE to run concurrently
Date:   Wed,  4 Oct 2023 13:58:07 -0700
Message-Id: <20231004205807.85450-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0044.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::19) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|SA1PR10MB5887:EE_
X-MS-Office365-Filtering-Correlation-Id: c756d3a5-8e5c-4fdc-c1a9-08dbc51c9d87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ESP5SBTnautgVsJ6ctcTLkmLrLJwoJy0/1l/8VBc9ut7jMg+Y1rcg5MMQzfnEKcvEs2ODtLzs5AhGEOUUfFyvD6sRiG7K4u107xYVJQxq2DGKLVZx8fSOWye7o3Xz/UlxxEttqGKEZzWzUyjrjzqust17ppgT5eWg0zIeGXku1gG551BcRJKQGui3lemBnujqxsOrjM+/RPYqbnOU1PzVoMSZSqXk5UiSd319IJUn/z8f9yKhYLmiVvSeHnqkdLssjamFy9gMe5BHwFdKvSas3bOmdoNUbiQqYrTrWe1XXDG95LnTdDcOdlOx1a+Nq9GBqJiGOsirs/dL7kF2M1LakJL7ba4LiMcHxnpZDdVGlJao16uyeUkzPou/LCNY0vbm4u+Ta4ahY6Aq0Ncl5gtD3JH6kyTOatClJv8vfAb/iGkLnNuHnQY0KNT5Hj1SXf+rayQQTRJA/W0NOFaoZz50Ft5pF0EHtzUIqtUcG5zl4EBKGDdfKLU4MVDxHpgP/nt1nSvHrRkUwuBLb0YLrZ7QSKHbZBWo9Ol3W2k5Rg4sRvbU7kFOOcV23VYfpLZ25N2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(396003)(366004)(230922051799003)(451199024)(1800799009)(186009)(64100799003)(2906002)(44832011)(5660300002)(66946007)(8676002)(6916009)(41300700001)(66476007)(66556008)(8936002)(6486002)(478600001)(6506007)(6512007)(316002)(1076003)(2616005)(83380400001)(38100700002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B57ZbA4lh3Dv6XLSWtoiFbOFHa9sJxro/W2gmmDlEQeoy62bVmd8aJJU+tJd?=
 =?us-ascii?Q?gvNQ3RJJWYF/bLzmns9kl6n1Lho2SBuKVm+EmvWKKTfDK5MPwt+sVM1DBt0k?=
 =?us-ascii?Q?m2gBverCspwqLqOriiY1r9PfjkilRuvY3M/lx4pze5wB7uJdojylty4UTYNx?=
 =?us-ascii?Q?5EJIR4OsfggTH1qFFhAoadMuslodrU7Yio3UvZV65Xu2l0h8X7fVvJaWSvDc?=
 =?us-ascii?Q?xgcfR9Uto/el5AwVNewo/9iUaktOKYk59FKnPRDmYv7BfUwrASfpy0hU5pEc?=
 =?us-ascii?Q?X5KvPjXALLWz8mTmzwWNaoqum1P8tMpP/Q9gcw8LJr7jAjA/IAu9kqAD8NIt?=
 =?us-ascii?Q?3THnvnUvwn1BxctLg0l1eWvKCYurUFxb2dDQv3xQ3RHYS3DnIjvgs1waLX5K?=
 =?us-ascii?Q?eO0Ge1oA5K1mv1hC2SfZ11XkB/+tI782o/cauhac2padh2E5PxmOVAzomyF1?=
 =?us-ascii?Q?kCqynaM5dW1h016evXrXF9Gf6GEbHxosEBZde1MA8kdkHup4+EbmnOaIYd+s?=
 =?us-ascii?Q?3D+rgkithKB2I7SYPGCE7QPbn9DghVA2PpZH2SCeknMJrTleau8eNvODNQoz?=
 =?us-ascii?Q?BPCNz1+Q+jB0jN7B/LtupFvdXzzBzyGXk1/+WH0JFJ2WZ83+PSwbohr32Sz0?=
 =?us-ascii?Q?mBawUoObo/43EuR2gOavmKUYa+hrPWa84wzyfGWF+y4fq2XyLMixXMhknaxB?=
 =?us-ascii?Q?3iPTSMdOfcfI+EsG6e4HcBUfZvb9DVUmi4iAYlh2ZSOu9uBtUCJoVYrvTmZ5?=
 =?us-ascii?Q?v6b9u4czwTIulBlBdE3RoTP2q0MeS2C+9E4KTbzWaAZw/j+GjciBqZ1sAV6l?=
 =?us-ascii?Q?Vh9IWthRVcCFmscY/nqRczQb2dXQQZW6mHmL3Qra0zQMyzNepLA4NetVjgen?=
 =?us-ascii?Q?jFQVxSM+JdJ94cTKSIrWIjSYX/GNOOm7ICzC3bzJVzTtA5TYo+PFbb2Q2Nci?=
 =?us-ascii?Q?VM099YzllmQva2d4YoXUyoWRF/Us7tBUjb8djJEwWYHko84WNiUYFt+ysim1?=
 =?us-ascii?Q?zA5EIvGfi7GXAPMEN7ZRxYd3CuhhtaXxfA+gK0dIDV/HCzFHfsXNmufvm2h5?=
 =?us-ascii?Q?LBcXG4h3E96uedBm9aSFQykI9lfuPou3dWbOjEnCaPdXzaOBcMDNE0XtJ1E7?=
 =?us-ascii?Q?c5+XCw2k3KjDUv9H62akeI4VPwP9N+ECPfozDmc5moXqyKzBgdb4Rr4iGn83?=
 =?us-ascii?Q?JSCwX+ZxTBS1BU5yGTssB3ctqsNT2/mY3pGFFftZkG12Nl3NKa1Ty3RZm0VN?=
 =?us-ascii?Q?SlwJyjUNJ8rKgXBnhpY6SdVbSH4MHFLWI2XSR5HqhuZD6odxdufOSJ6GWyyN?=
 =?us-ascii?Q?lL4G5QAre5hZ4q3pygwK4K5f9gvkElSfeDQhQt1Grsb7Qde/epKUe1NKDFgH?=
 =?us-ascii?Q?uAFNI7MouD9uM/99wnwOYzvJHdRkq8tkAprqHTPSz171QWBcYC+DT/g/ioC6?=
 =?us-ascii?Q?+eyj60F2ENJm88Stu/ipaJkF+YmUDixnuSkSEUUY8DmlxiOSfhJ5Z2h4jt58?=
 =?us-ascii?Q?g3B2XeCmbYhVSnmYrPVWqkOIYZtfye45XFKnrdsX1aNBVSd5q5kOWbo4m52E?=
 =?us-ascii?Q?chgrgL+zCYIh5J25cZPhsuINrVyo96tn8HQQ03YwKPPQaK9Mgss0QAmO5Rdp?=
 =?us-ascii?Q?xBjRYWIid7qS8aciwheQjPh/DbrRb43Dteqa9M3yXp4sIjCf3B2z8Bngu5mb?=
 =?us-ascii?Q?xDd72g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 6F7ES5O2zKFBVwlfNW2hB4nXupG3Dx7dPvS8T45umFIeB+USU8n6R+OuvGaQhoOANHP/h496eTxK4wBpN3GtFKOJfr7iraEYwdkjK843A0oeF6iHULThu1e5D5ZSSRpYVngZI3Ln4emalZ6hnKybn7tdo/lROjClSICedCtY+FMmFxSul1Q5+Ab2sqsCcUA/2jJtenVvPPMoP3K8kjkCxrVKi7C/BZk+rggMV4DQVE8E2w8z4zxbGOze3a1dlKnLLe2pAwJU60nqjPfl/4dF2QnP2vuFLv7HohiLxRbnL5n/yTPwh+9XCmHiZmFhZzAO8uvCef5pqaIqqtTtVJUTQL6U8/7bGadiHwQR5/u57CS3kA7YJOKFcFSfVfPiRxKG7+2c7/AYZNCcM+Tk962ENXFdTG6pVBCTmik9XCcyNcXRthmQHeawlFeENxUYI4lFIBZDmZkztSKf485hEEqxanTvNQSco1FB3O15Ofu3Zuobzm9Kknp6zDPV2hDkUv5maJTSBk6LzIeXLSTEz+ok+Kbn2H8of+WuNRuyFteqZHLDXGio7BSTSy/DuCLjyHkpwYqZneg0JFh6gz0JEN9wnzNk1/K45gPP+fua6tO2UK36fMthvxiQBGv7LQrD5GRAUU2Zx/hfvUtIvj7guw+dT5P6veO1lT/lFisVmO2VmloKEige01weIcjM20FiShioVimyuxBDa3EOpvf3CRHOQOjLPXpKTItQjr3t4jtjfyU69kQa6yeeN/uhAEiTm3YiZwEDgsVGNY0nZAENwN+F1A==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c756d3a5-8e5c-4fdc-c1a9-08dbc51c9d87
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2023 20:58:09.7526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ahwH/xer+/LDEWxhTZVt43hAVhqs/rlZPhdqq+Bp7Sn50khSJwJZQzkGmW+7raDTDq1BEYuoAHzs+Z2zU/P1QEjrUmKKYFZE1CKHhT+2W+A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5887
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-04_11,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310040155
X-Proofpoint-ORIG-GUID: hXeeu1w3CvD3kUTMuq6ZE8w94g3CeXhh
X-Proofpoint-GUID: hXeeu1w3CvD3kUTMuq6ZE8w94g3CeXhh
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Clone operations and read IO do not change any data in the source file, so they
should be able to run concurrently. Demote the exclusive locks taken by FICLONE
to shared locks to allow reads while cloning. While a clone is in progress,
writes will take the IOLOCK_EXCL, so they block until the clone completes.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_file.c    | 41 +++++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_inode.h   |  3 +++
 fs/xfs/xfs_reflink.c | 31 +++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h |  2 ++
 4 files changed, 71 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 203700278ddb..1ec987fcabb9 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -554,6 +554,15 @@ xfs_file_dio_write_aligned(
 	ret = xfs_ilock_iocb(iocb, iolock);
 	if (ret)
 		return ret;
+
+	if (xfs_iflags_test(ip, XFS_ICLONING)) {
+		xfs_iunlock(ip, iolock);
+		iolock = XFS_IOLOCK_EXCL;
+		ret = xfs_ilock_iocb(iocb, iolock);
+		if (ret)
+			return ret;
+	}
+
 	ret = xfs_file_write_checks(iocb, from, &iolock);
 	if (ret)
 		goto out_unlock;
@@ -563,7 +572,7 @@ xfs_file_dio_write_aligned(
 	 * the iolock back to shared if we had to take the exclusive lock in
 	 * xfs_file_write_checks() for other reasons.
 	 */
-	if (iolock == XFS_IOLOCK_EXCL) {
+	if (iolock == XFS_IOLOCK_EXCL && !xfs_iflags_test(ip, XFS_ICLONING)) {
 		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
 		iolock = XFS_IOLOCK_SHARED;
 	}
@@ -622,6 +631,14 @@ xfs_file_dio_write_unaligned(
 	if (ret)
 		return ret;
 
+	if (xfs_iflags_test(ip, XFS_ICLONING) && iolock != XFS_IOLOCK_EXCL) {
+		xfs_iunlock(ip, iolock);
+		iolock = XFS_IOLOCK_EXCL;
+		ret = xfs_ilock_iocb(iocb, iolock);
+		if (ret)
+			return ret;
+	}
+
 	/*
 	 * We can't properly handle unaligned direct I/O to reflink files yet,
 	 * as we can't unshare a partial block.
@@ -1180,7 +1197,8 @@ xfs_file_remap_range(
 	if (xfs_file_sync_writes(file_in) || xfs_file_sync_writes(file_out))
 		xfs_log_force_inode(dest);
 out_unlock:
-	xfs_iunlock2_io_mmap(src, dest);
+	xfs_reflink_unlock(src, dest);
+	xfs_iflags_clear(src, XFS_ICLONING);
 	if (ret)
 		trace_xfs_reflink_remap_range_error(dest, ret, _RET_IP_);
 	return remapped > 0 ? remapped : ret;
@@ -1328,6 +1346,7 @@ __xfs_filemap_fault(
 	struct inode		*inode = file_inode(vmf->vma->vm_file);
 	struct xfs_inode	*ip = XFS_I(inode);
 	vm_fault_t		ret;
+	uint                    mmaplock = XFS_MMAPLOCK_SHARED;
 
 	trace_xfs_filemap_fault(ip, order, write_fault);
 
@@ -1339,17 +1358,27 @@ __xfs_filemap_fault(
 	if (IS_DAX(inode)) {
 		pfn_t pfn;
 
-		xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
+		xfs_ilock(XFS_I(inode), mmaplock);
+		if (xfs_iflags_test(ip, XFS_ICLONING)) {
+			xfs_iunlock(ip, mmaplock);
+			mmaplock = XFS_MMAPLOCK_EXCL;
+			xfs_ilock(XFS_I(inode), mmaplock);
+		}
 		ret = xfs_dax_fault(vmf, order, write_fault, &pfn);
 		if (ret & VM_FAULT_NEEDDSYNC)
 			ret = dax_finish_sync_fault(vmf, order, pfn);
-		xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
+		xfs_iunlock(XFS_I(inode), mmaplock);
 	} else {
 		if (write_fault) {
-			xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
+			xfs_ilock(XFS_I(inode), mmaplock);
+			if (xfs_iflags_test(ip, XFS_ICLONING)) {
+				xfs_iunlock(ip, mmaplock);
+				mmaplock = XFS_MMAPLOCK_EXCL;
+				xfs_ilock(XFS_I(inode), mmaplock);
+			}
 			ret = iomap_page_mkwrite(vmf,
 					&xfs_page_mkwrite_iomap_ops);
-			xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
+			xfs_iunlock(XFS_I(inode), mmaplock);
 		} else {
 			ret = filemap_fault(vmf);
 		}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 0c5bdb91152e..e3ff059c69f7 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -347,6 +347,9 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
 /* Quotacheck is running but inode has not been added to quota counts. */
 #define XFS_IQUOTAUNCHECKED	(1 << 14)
 
+/* Clone in progress, do not allow modifications. */
+#define XFS_ICLONING (1 << 15)
+
 /* All inode state flags related to inode reclaim. */
 #define XFS_ALL_IRECLAIM_FLAGS	(XFS_IRECLAIMABLE | \
 				 XFS_IRECLAIM | \
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index eb9102453aff..645cc196ee13 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1540,6 +1540,10 @@ xfs_reflink_remap_prep(
 	if (ret)
 		goto out_unlock;
 
+	xfs_iflags_set(src, XFS_ICLONING);
+	if (inode_in != inode_out)
+		xfs_ilock_demote(src, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
+
 	return 0;
 out_unlock:
 	xfs_iunlock2_io_mmap(src, dest);
@@ -1718,3 +1722,30 @@ xfs_reflink_unshare(
 	trace_xfs_reflink_unshare_error(ip, error, _RET_IP_);
 	return error;
 }
+
+/* Unlock both inodes after the reflink completes. */
+void
+xfs_reflink_unlock(
+	struct xfs_inode	*ip1,
+	struct xfs_inode	*ip2)
+{
+	struct address_space	*mapping1;
+	struct address_space	*mapping2;
+
+	if (IS_DAX(VFS_I(ip1)) && IS_DAX(VFS_I(ip2))) {
+		if (ip1 != ip2)
+			xfs_iunlock(ip1, XFS_MMAPLOCK_SHARED);
+		xfs_iunlock(ip2, XFS_MMAPLOCK_EXCL);
+	} else {
+		mapping1 = VFS_I(ip1)->i_mapping;
+		mapping2 = VFS_I(ip2)->i_mapping;
+		if (mapping1 && mapping1 != mapping2)
+			up_read(&mapping1->invalidate_lock);
+		if (mapping2)
+			up_write(&mapping2->invalidate_lock);
+	}
+
+	if (ip1 != ip2)
+		inode_unlock_shared(VFS_I(ip1));
+	inode_unlock(VFS_I(ip2));
+}
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 65c5dfe17ecf..89f4d2a2f52e 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -53,4 +53,6 @@ extern int xfs_reflink_remap_blocks(struct xfs_inode *src, loff_t pos_in,
 extern int xfs_reflink_update_dest(struct xfs_inode *dest, xfs_off_t newlen,
 		xfs_extlen_t cowextsize, unsigned int remap_flags);
 
+void xfs_reflink_unlock(struct xfs_inode *ip1, struct xfs_inode *ip2);
+
 #endif /* __XFS_REFLINK_H */
-- 
2.34.1

