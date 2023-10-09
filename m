Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C14FCD612F
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Oct 2023 20:59:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378096AbjJIU7p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Oct 2023 16:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377082AbjJIU7o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2023 16:59:44 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F10BA6
        for <linux-xfs@vger.kernel.org>; Mon,  9 Oct 2023 13:59:42 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 399Ktprb012790
        for <linux-xfs@vger.kernel.org>; Mon, 9 Oct 2023 20:59:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=sIHpYSFB8jJkE8++JnHtKEU7I0BAGsNYr9lyIDMte6c=;
 b=bl9BSXnq+K1+nd/gFwJtGUrkkzUOAeu81RzFIcA/y1NznVuANJlGwk/Cjn7ydDWhZr2F
 /8GyKe/HN1aAeiBwEQSJ0cIJFCuCmlYVKCMqSS8X+o0kML2xRDpX4Ll7rfXLXPUf8+im
 qgdsm7i7+T16fUooDl1FbPnJ45nF3qwbAu1zknTeGyaBr/DSTRPssJDwY5CP6SOtl6QV
 F6fKK2KWo9ZW/6UQCb7JBlXgZdqlO72D/2SNumSP1PZLLP4SG4jHsR7EZOcDMG+iHv35
 FA8IGZZLUdDqFtcMaoFAUB6AQYybRQRb9kbAe8accxeAwzJ0dg4bU+3K1rHNdMnXsjZs /A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tjycdkp9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 09 Oct 2023 20:59:41 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 399KVr6M020729
        for <linux-xfs@vger.kernel.org>; Mon, 9 Oct 2023 20:59:40 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tjwsbdhj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 09 Oct 2023 20:59:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D+T6BtKlzzmM9u8cNmh1Z5Pe1NRGHZfLH9C0MbOCm4NoawwUP7gRmnktL5cZDfv6ZBJucdUySTdccYIrfnFK1Xdym0Y7WLHS/VbvfjTeMjqMSy5RHUkCdCaesLtKJPTAiW2b4ctDWmUZgKX6SzpufwanlQXeQxcT+gDtvx6BAVxrkHX7h/i9F0fPCZ1/GehQiJAEjw+hSZ6iJZoqEwZXn2PbEVGbJ+23tIfhatXCH52tY+OwZHc681I8R0lxEjrXOrS39r7XNuYZXHL3AiTpGvt4N5cFm/zT+t6m1eW80hUE5ZbxQtRz8sWHAOtPlD4VmwQK6urJGraeJ7ZLRkq8WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sIHpYSFB8jJkE8++JnHtKEU7I0BAGsNYr9lyIDMte6c=;
 b=D0u3zLUyt0+tL0Ie406j3J9JgCyPevJNE57T7lR5K6YSkwTZBR948wU3mdF+5ies4poObk26RjrorvezeUiePBjbTBcrR1cPsDdsGOqts5eQ9zppiZCVJg3rneFjwVCNhIGIr/U4hb4aIY1gLim+i6m5QCb3w7XtjNN/x5cA2yW0zxEy2flGsObsZY/YBk06YJUCSg7DxFRf5wiFaZabpN4Ej0JrXvoMLhGMM5r1WEshPKZdLwpWFz16dg4wNFQ/tAOr6O55qFGbt+UvFDAnR7OVa1sn1HNi5xj7dcVa8efv3Rsbd8iIlEuIn1H6UvGmxp/ayjPC39JTLefszZigsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sIHpYSFB8jJkE8++JnHtKEU7I0BAGsNYr9lyIDMte6c=;
 b=sSojcXAhVA2Lux/ej/pEf0TnAQ/Q2RkXJ+6EFyaGv3hn5gdSZz1fgj+mMmoqZ8UY06I86kEt1gtLjQGi1L3hi2HrKQKoL6XNyBkv+nh9m9mb9/MUH8HMn2c7/hmn1BNfc4lm4Phg2LhQHwPDBRNMbqsD/XXbI6OYKT88Ac+X9ow=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BY5PR10MB4273.namprd10.prod.outlook.com (2603:10b6:a03:205::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Mon, 9 Oct
 2023 20:59:38 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::9ee1:c4ac:fd61:60fe]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::9ee1:c4ac:fd61:60fe%3]) with mapi id 15.20.6863.032; Mon, 9 Oct 2023
 20:59:38 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs: allow read IO and FICLONE to run concurrently
Date:   Mon,  9 Oct 2023 13:59:36 -0700
Message-Id: <20231009205936.38644-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0016.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::29) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BY5PR10MB4273:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d6b3f62-d90e-46e7-201f-08dbc90aa6a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r2qqq5A0X2ql0dZ4xcXX/8dT1lYwIQ0Ll7fEKklmncRHIAUb0wlHxhOCnIR3qnzxF4melJipXL+r0vJTYy+JexG7b8mAXdwtBPnF54Dq9QlxPKQpna9jYsKe0ki/7lE3wPp+ltI/9KQXpQttxlK5+GLiW8+tLckL0dTEPOQIHMGVGvbyKPkjvF/u72YaASN2vbtgmtZHodVRzhl3QqSKnkfpcL9a+NxgMkGkYr9rzPhFjnlFc+XiH0203MQey/hWND0kp6oyyeMILfT75v1Z0ecDQZKDPL3OCc5DT9OaSNvz8thQnNzZP+HSZbwwO4rZTAnFro6LUPGylKVeprruJ2K2g4HPZtVA2NPKv0FhjgR0fPY8SH6s9BjLbIGE4VHJEUmAh6P5mpjlTUwtWVjIQFxzOIk77j9WFRck31oco1d2b0fYzmoGEoN5x2Lru8H165F+Aiz3IEzIvoGYGN49hBL591uvgEHrTinKcRCT2KJEqlO/z/QC2IpzHoMdyiGLiuN6AyoWGeQ1FaPk1vPl5AeLe77U9YKgW57AlKNJv/8CQ0LkGlnlqixDVll9CIUg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(39860400002)(396003)(136003)(376002)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(316002)(1076003)(38100700002)(8936002)(8676002)(83380400001)(41300700001)(66946007)(66556008)(66476007)(478600001)(6916009)(5660300002)(2906002)(6512007)(44832011)(6486002)(6506007)(2616005)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nNpCCxj1jaZTZ/PKd1ZaB9kUUeyLcomHwtyU6LblCTbdTzl4ui2pTqFFJTGl?=
 =?us-ascii?Q?1/UwXII+UXt7tAnWpPNpiYLwD1Sr9smGtqwDJZipCNkV5CMA+zB6p1w99qZh?=
 =?us-ascii?Q?83azIz9mWRWONOnbOOCfajBYHb8WD8mbi2Q3j7wylRLWvY7YS/Sbko9P/AIX?=
 =?us-ascii?Q?/wVHlrB47KILrrEBKXn3s+1Pz9C6+lSWE8yJQpr1fv01Hada28+s4C6r5sA2?=
 =?us-ascii?Q?jBgH6lWm0d57vDpEypnheNYd4GQOdWxf6oGVKxpyck5CnYpYGaL6bH4Zl/st?=
 =?us-ascii?Q?gS5/tlnHLWQ3fs2y9z3ytubg5g6uySG5Azbrme/9qh8cfs8YiV5oFQMxA0Vi?=
 =?us-ascii?Q?NJ9/UZQvxgR6u1htQO7iZyLXZkeMB75nyZEfyKhXumuOJFwYKvInc7gC3hId?=
 =?us-ascii?Q?IazHhYM45gXwABh5T3KT+lzLhAuvdVY2rpswdMW9Xn4/A8xZl43URHOqnjPE?=
 =?us-ascii?Q?1vKSfnlr5ifnGfUGgY4svG2T4Ps0ANUcAyxOJtZ0aWgvqbWwj65ut0Sx5Vxn?=
 =?us-ascii?Q?DaBi32AoKjlESYnEy5AU5k7jlabWP2SixLxEc8gd3+A+usyazM0ZA2toS2wC?=
 =?us-ascii?Q?Wj05z/AwdwJAPE5qU4VjrYe/JqiP4zcFl9as3uKZjw3otP1byM99Ws0LGfjp?=
 =?us-ascii?Q?Vn9ExaUbR9mm7BaM/VIyKdAvuy7Ia56OpNLWgvyiI3p3/+jj1YOL9hdK/NE0?=
 =?us-ascii?Q?VamrzkWKP7u8SKgH/DvG6CfRnOjaSdYS8Gf6M04X1WykF17qyAD1eLleXwN4?=
 =?us-ascii?Q?JSSgVAGGu2KZJaw/SLJ5xRhR3JaM1RolHdaSFb9h1av0jQ2t15rJuaanmpi3?=
 =?us-ascii?Q?Hw5J1h5McEoQxC0YF0KHz0OwHpJbPmkvG3LkvLBFGk/YVlC28Nsv/zHfdKbG?=
 =?us-ascii?Q?bnFg1hfPGBZ2Qrrx5ulHsExWJP+jm1V51vcsAt5fQE8kWyGj5+BT5GXJK9wK?=
 =?us-ascii?Q?tyBYPXTq8OB7sqe4Jguv6S7cE25PqL8CU9JalhFeh3Mkap2s9ABEcW+2ycch?=
 =?us-ascii?Q?A9wJVD6Rq7bmg84hn04uhE8Lxsp+kDbtAtiavCG7jviIWQI0sqC+hyVgctHb?=
 =?us-ascii?Q?7TLSiYkdszg3RWB0WbgJuTthJ/t5mZokHTa41bQ448lPneOg556vbzsLOaiD?=
 =?us-ascii?Q?oCkK0YVxoOVkvVqoCxojwQVgtWZjrgaptQMN4yHy2bgaaLZT7rYdyYimaezO?=
 =?us-ascii?Q?a+yc+nkXLnDmUMbgaXcvDysaQb43WHLajaY+jCsKFTUt2m4QIyzny/9ZkSj8?=
 =?us-ascii?Q?aQMu1r3euzSyfzHNYQkjR2ZV397XrKQndE2ECsNiE4CYbNam84ild9xcfXHR?=
 =?us-ascii?Q?LMG4YdOJE65C4ojHqETE2eEnBbaATFeT8s2UvCChRinw04wTY/vWjwemGba/?=
 =?us-ascii?Q?0LYaPpjyblMMJ7m4SMzsMC/EwrjtyXG2S8cOmnlPXtwtZQCTrYypgLNQ0eIl?=
 =?us-ascii?Q?YV8vnPGpqw8H+Y0SuLVsR4RdRUlBO2DJa36oCTXQyYfPXONaQ93rQgCbdoEL?=
 =?us-ascii?Q?0xoliDhaT0WpXWfoAztOjqy5xOAZH1YJ0ZuoQatYyVWAVscLt1nc0Gd2Q/9U?=
 =?us-ascii?Q?EZjXp32Zj5w/qVc9F7rWZ5zFoirijJ1yZICKR83ODj1si8jYgo+pADHOdI58?=
 =?us-ascii?Q?GI8XL+jgD35R/anR1JmH4kxZVj6KUvCjW4VmYJltzZZCeQqFzuESfXOTlFQq?=
 =?us-ascii?Q?Du/ZMg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Jw+CqwMEsSSuGt4MB1XLlvsTlq/c51rejnNcWKa/V++XvEYRB1y3k8uhAhDwvbQDlQvf7uuyDvHK2hOs19NXWmVdxH5u36Mm1uvfKybWq6E5wjYPiS7MRb3aHLlHjBDK1tZK7VeniOiHWwkBDYl9DeeErxVxrxD4DyWYXjeonpL2k4ERjOhsQI11TfWSYPfmUC32PVWlmvInuJBI7UoajKWKEN7iUE1houZCluzv+Fcv+DY6GFMOsZ6K4xwoC2Za2QBELfB0L4vzRcxLhCGIireI7l8AP0LAr4b/LVNBBO5WGhHt1r57QyOYbpKiPz/4XddpzozX+gqR0rNOx8FSZFD2jVQq+SnMY4zKuNokzpDndTNbMuD8bmtHzR4g6skAVht4ivN6UG2w2srC/6+Ad4jTkXpwaZrkAAX0wj8s2sKbqznjmk3VNZEjqdBHZ+LDoJS1+XLMWpDwO591ieXodTo1SsdhozaOdaRRmtUSR5aq3vQnEynCCMuuHHNmfsQAZzlDpGL/6dW7ENxlBi8XxWcMSWT4dkLTDDCo2yCJ208qF1nxCgmjET3tbMKzTYfl/u9Ec+Hg1xoIsbw2Kqzc05yLoE1BonVMBPiRICRmtLF8sLyLaFhkmRO2FEBs5yZGvphl3GKTdrq3YVHKetd42C2NbYN/bOvtAUo4U5BeM64ptF7geHL+Z7HKp5+LObx1mlVkqNbfs29kVejLRivL++XRlFlnnM7xxjcF2sTiVvzsJwtH4DDvFvoYosiqD2UTllDVImbgcvVbwzFO306CUQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d6b3f62-d90e-46e7-201f-08dbc90aa6a5
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2023 20:59:38.7306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Od0IZtsjG7hTwNIL1FrIoV9CKW7N0BX79vMIxSDtkFuqx0A++mrt+5avOmPySiCNZfNodtNfCSsbQ2Es/E/Rh7EbkELd75BIBScRNir8uV8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4273
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-09_19,2023-10-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310090168
X-Proofpoint-ORIG-GUID: ux1YjRz-Pbo9i8A1NeWWBI1ghe56AzEG
X-Proofpoint-GUID: ux1YjRz-Pbo9i8A1NeWWBI1ghe56AzEG
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
 fs/xfs/xfs_inode.h   |  8 ++++++++
 fs/xfs/xfs_reflink.c | 19 +++++++++++++++++++
 fs/xfs/xfs_reflink.h |  2 ++
 4 files changed, 64 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 203700278ddb..5bfb2013366f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -554,6 +554,15 @@ xfs_file_dio_write_aligned(
 	ret = xfs_ilock_iocb(iocb, iolock);
 	if (ret)
 		return ret;
+
+	if (xfs_iflags_test(ip, XFS_IREMAPPING)) {
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
+	if (iolock == XFS_IOLOCK_EXCL && !xfs_iflags_test(ip, XFS_IREMAPPING)) {
 		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
 		iolock = XFS_IOLOCK_SHARED;
 	}
@@ -622,6 +631,14 @@ xfs_file_dio_write_unaligned(
 	if (ret)
 		return ret;
 
+	if (iolock != XFS_IOLOCK_EXCL && xfs_iflags_test(ip, XFS_IREMAPPING)) {
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
+	xfs_iflags_clear(src, XFS_IREMAPPING);
+	xfs_reflink_unlock(src, dest);
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
+		if (xfs_iflags_test(ip, XFS_IREMAPPING)) {
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
+			if (xfs_iflags_test(ip, XFS_IREMAPPING)) {
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
index 0c5bdb91152e..3046ddfa2358 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -347,6 +347,14 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
 /* Quotacheck is running but inode has not been added to quota counts. */
 #define XFS_IQUOTAUNCHECKED	(1 << 14)
 
+/*
+ * Remap in progress. Callers that wish to update file data while
+ * holding a shared IOLOCK or MMAPLOCK must drop the lock and retake
+ * the lock in exclusive mode. Relocking the file will block until
+ * IREMAPPING is cleared.
+ */
+#define XFS_IREMAPPING		(1U << 15)
+
 /* All inode state flags related to inode reclaim. */
 #define XFS_ALL_IRECLAIM_FLAGS	(XFS_IRECLAIMABLE | \
 				 XFS_IRECLAIM | \
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index eb9102453aff..26cbf99061b0 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1540,6 +1540,10 @@ xfs_reflink_remap_prep(
 	if (ret)
 		goto out_unlock;
 
+	xfs_iflags_set(src, XFS_IREMAPPING);
+	if (inode_in != inode_out)
+		xfs_ilock_demote(src, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
+
 	return 0;
 out_unlock:
 	xfs_iunlock2_io_mmap(src, dest);
@@ -1718,3 +1722,18 @@ xfs_reflink_unshare(
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
+	if (ip1 != ip2)
+		xfs_iunlock(ip1, XFS_MMAPLOCK_SHARED);
+	xfs_iunlock(ip2, XFS_MMAPLOCK_EXCL);
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

