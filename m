Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EAEBC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:07:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 120A261185
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236422AbhIPKJN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 06:09:13 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:43276 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236359AbhIPKI6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 06:08:58 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18G908AX028347;
        Thu, 16 Sep 2021 10:07:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=TGFdbE0iB5be+JyTGVL2Fz+EL/p8e3OZDSZr4VQEriQ=;
 b=h0Dst8Pn6MxtjGW2JJ+zNlGzOgc44ZiBG3hvroHptskdEU1Nvw3YhpN+xlE664D4j1+f
 5VAlO3mgtXm4bcORtLt1y/VbHNbap3tm9XqprztH9CNGbeE2R+t8JkdFp3+wm0YASmG/
 ehLn/DK7b1d8qn4Lr0YiG6BSCCI5jeDpgZokBA304Wfjx9m1Wbb8thmnl5MB/+Rleb0L
 YP58A75N19qgtcQFGEVp0O8kJL12trPqzWCCepCo2Fo58rmV1fgss3fhmQG+6180KWzm
 5vt2brLEBM+b9z2vnmobNMz9ukqILZo7Aoy4Fayr5/5bKXkT0tlJEbSNI8f1+7F1mFUG ig== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=TGFdbE0iB5be+JyTGVL2Fz+EL/p8e3OZDSZr4VQEriQ=;
 b=zSauQlNheP7JkDd1LLPbs6SOrecxnFTvvkZY/5EyVTUSqZ6TIRcsfVEJSNkB847mHCuB
 XUIXAlmRVGG2gedx4sDo/OKlOhD0IgtzGSN9HBeQFy5wKRY6MRac1RN7G5Xgm58+AbaN
 i6fCGwwkUgo5Ztk5E5kbF4XteMSHsgqcoyXOO3ausNE7+YIlvm/4JQQlV+V2ohgu7f0d
 SXv8uGVjzrrad4lhg0Ml4bjh5DzhqysTezYIgY3Gdg95sfbqgr57Qy2dOuKTis3ZanJI
 sDjF6mvSNktczuAXUOf+2/iQHrCOtnMSZYZUTK6AT8Bh/hZbP4CiGACSkwCwlU3PxNjQ 3g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3t92hd3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:07:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GA5HWO030808;
        Thu, 16 Sep 2021 10:07:35 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by userp3030.oracle.com with ESMTP id 3b0hjxybw1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:07:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MjnYEKyiDCFVod0rRkbeN1MJ4sHDEUCXhL2GpGUxzDtvxEjXAom+4dgldOFPjUf4GeNmMfKMijHeEQxLbXJU9+YVwiI+yPseWKl3pQA8ROPAvakz/d9fvEG3V6gJVaPWprw8spHIlNyviiz3GJ/gtxLeWZjvfwkprkRF9yvcf0/7uvSjulZodRqBtPG5pTDk79JVFYQUfj+kvRqACIPky+T/neopX9hxNOwtoZDC8mGIIAU79etmU+icVoCRTWb07edY5ZeEYNAhtPkBlWkMhQnz/DM7Ji3v3a8rlm2CFaRfw+xM22wDHsI0G02uf/GfRkOXZvkFj675Qyi1Vrtjng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=TGFdbE0iB5be+JyTGVL2Fz+EL/p8e3OZDSZr4VQEriQ=;
 b=gyJY6xQj2nx0/FrtweEV8ISglRi0ENGknSnbbfOaP+8/Fk+HIu+6ZwGvX/7AhhNnb9rulEpYZfGCgmfBIg7C37W1cdqNRrlv6V/K5xegeusPj+DKPYAvnk33gR7F+dJmpA3LhZB3ux5DlnwFzmRv4mpofY2mUCLuMAy1++trGhHsOAVlXTodC1jOUDUoSpzpJ197UdQh8/9jRUIhGcPTjKmOnFNaYOeNcQrArjxI3k4sO7Ig2Wmgy6ACFNeANtghRh6a4Do9YdAGnaG8klTuZJHAC188beoVrZNrWsGDy00mdIqMrCJ6URYuvG3mBSWyTT/97LXBkPIbMKR22a32MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TGFdbE0iB5be+JyTGVL2Fz+EL/p8e3OZDSZr4VQEriQ=;
 b=hOffpJ2OFyI2w7rLna3Oar8Hmmt0B496O6wE5KMUMgsTSfCwHnWdGtys51l8qJVPdmonu231ZZJsEDo+cGNOjn5G99YFh9JybDJc5VjvqR6EG3dGCh19vDsU9nYJilZLczWKAiQVnF9xrDGGJlWjaCvptI/EOmeemLAf5ZUOC7k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2878.namprd10.prod.outlook.com (2603:10b6:805:d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Thu, 16 Sep
 2021 10:07:33 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 10:07:33 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org
Subject: [PATCH V3 09/12] xfs: Enable bulkstat ioctl to support 64-bit per-inode extent counters
Date:   Thu, 16 Sep 2021 15:36:44 +0530
Message-Id: <20210916100647.176018-10-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210916100647.176018-1-chandan.babu@oracle.com>
References: <20210916100647.176018-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0025.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:d::11) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.171.167.196) by MAXPR0101CA0025.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:d::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 10:07:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52ea15fe-faf6-403a-1913-08d978f9cd12
X-MS-TrafficTypeDiagnostic: SN6PR10MB2878:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB2878F15F16BEA8E974D94E23F6DC9@SN6PR10MB2878.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TSHSrE6ZVYHEVwQB0a2O5eOFfxq+viLuJJJ69mKhKVFTMctFla+Tj1XORAsJQE3cF3wA9BX9JXLu+SoMt+8bAPWCgsy3AtCnyAevdZXO9UR4ndj8eauE1RqHOdLACuF3J6820Ce+K2tbIMcATysbY6g+FXrAe+BvKfF5DxfhWaVrsFHWW80FkA8+Kx/exeYS8OiuTfEeJ8Kmqs21nNzAnM5O5o6JujauHaamrEs6+Unf1Dc3zjGfVUC8GrPs1ZwLwJs8x+HkLXkuH8R0soopDPdsE6S25NluhK2kyYuTrKy4lepRwZ++ewFjh+TIoZSbdIjwlV0UzcrWuF6w+l+1XqCwD1P28wAB2jmjBVxkv0aC0RY1Up6tS9UebHhVxyNc/BiM4YdiB1VpQVCREXeG+8+z8jFxt4eNOhxJhp6kHmNI5TibDOQzIzRdblMP7KActKy0xuoxR1wSKulPFwHr8J4jPp7J/w77fXPuQuNZ57CWlCxFPekVL1B7zvwKEPqIGaMa3sKyvSuj6b7i+nsgRLeki4kKVzxlZRr7RaQn52XKkSX5tTWmYQj9+MPBbez7xZf5urxYA5pPi6LShqFest2DVP1y5ghkT0MqIoritNDCysISimhXWWfUZR2ZxlN3AGbcjCIjkiTgxZPYF+y2OoeledXrYtx29XFoi4jRzORPTglPjr2Iif8GiFXXl/GPJ5EUt3pqE7sQMzOoI6VA2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(136003)(346002)(478600001)(5660300002)(186003)(66946007)(86362001)(66476007)(66556008)(38100700002)(2616005)(83380400001)(6512007)(8676002)(956004)(4326008)(26005)(6916009)(52116002)(38350700002)(6666004)(6506007)(1076003)(36756003)(8936002)(6486002)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g12eZU9vOlK8JvOQMzX/rLU/OMlsRwZqCMpe+OhS8mBwseuprevc8g1VZlBy?=
 =?us-ascii?Q?M2D7cP11FLYoPatyC7X4Nux3dXDoCx9pI8RIYA069KObTVTBW9mkLOfucB7m?=
 =?us-ascii?Q?MoCD1R9yLofFLvsglnNN10tfeQV9ipu05LEp04baKXDgIt1U9aTQrjrr01fN?=
 =?us-ascii?Q?3eZNK+YWWZy4QYDWvZPxUSBRnY5XDeNIkpWQR0kgFT44x48Azne3sxdRtyDH?=
 =?us-ascii?Q?a9ydm5hRSCIQqi2+1TE0KMJLE/IQ4uaD/CFac3SlILVw0tfKqavwCa/NMpxn?=
 =?us-ascii?Q?ZPhepTi+SwlnP6DBVsXzBN5ffa/b2TDQirWsxtyb4ZM+xY/r8uNQZWGx8qiv?=
 =?us-ascii?Q?asuylPvBHWROkY6/RVhkbobiF6IexqVt8Ul/HoF997hIUoQKCYVz4GR9R0We?=
 =?us-ascii?Q?8vRdonBFaRnh/c7MLpJjAYA9irHnj7+OA7OmVhHni9ilHdiE2i7ovpnGZ5i1?=
 =?us-ascii?Q?NbKIJuQxTW1a9SPGTc1/G50P5G/XzFhRPnixeilrqUa8ko9ngw8+6cYj5eOE?=
 =?us-ascii?Q?G6J+NRN/yzmQLBKbPKTs1Zthq1lMTmyz5qgq5x+ncGGdE6F46Rr2J28U2vZK?=
 =?us-ascii?Q?uaN0O5WsXAGKEyhMoeL63/0K0aM01KEz1lCqlkL8yB3cJZFnVScwS4tn+6qN?=
 =?us-ascii?Q?Hkj5Jc2AebWTdkPsNqsZs8lp6usak/CkCIxOV9SdWYlKd1XCpkNDbiCC8OnT?=
 =?us-ascii?Q?I6qf/dvd8I2QmhmkSOb/Cfc2NR9bS7QW/Q6p2+lqq1DF4ikNfH94dys46Bq6?=
 =?us-ascii?Q?HlUq01Kj3EpEzRzPT+vd3jPvVa4IXITKOblTF1gFH61isFRT/baXC51merSy?=
 =?us-ascii?Q?xBMqa34efHgl1oiA2uTFrJoM2K6vqJewuRI7kaD+eCw5ZwTDMpi0fq0QOFPY?=
 =?us-ascii?Q?cYlvuDsK3WFevxg99R679KSCSXazWSYfSx6SNR+1Z8mzWC1KNRIQI0RulF+d?=
 =?us-ascii?Q?EeZd8WPGJvsYo25WuF1x5lu0de96TFzLr/3Z618yoWnaDDCLzeEB3G1vNBvf?=
 =?us-ascii?Q?6mCmkRcurcI+P/nzBbtNed+El0Hzasz0v0g0P+xCC19qKaxINiI1fWEAvLuE?=
 =?us-ascii?Q?t6JtsZoeZt123aX32BT80vhcTlILbhhWXFzRZexVMCtZzowmg5G4vK+asuhk?=
 =?us-ascii?Q?TvHQRlv1y3kEi5hRvkDyKo+UofGiqfReHy/K1pYywmLSO5RA6OMUlG7kACjK?=
 =?us-ascii?Q?tdk7jrNbv+vK/9tQJxjj0GcYupXw5M/af+W/heqRKchGS0i7uBtSvns+fV93?=
 =?us-ascii?Q?GgLNl8x74HjYCXH9p15bKLnQP0LR58FV9XEuUanpz+0eEh5/qjNZXGEE/GYD?=
 =?us-ascii?Q?6lRjfzIZn26leAoHB9vzZVB+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52ea15fe-faf6-403a-1913-08d978f9cd12
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 10:07:33.5945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hu0YCRtuon3kKVHKwGtOEGHaXI1nYBr4uli8PQBU4Zd68PvJn67mk3qJhMsRvy+FmGg7JjLd61Ax/UsMv5k04A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2878
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109160064
X-Proofpoint-ORIG-GUID: ngys05vogRKFcH5zJgd16LwElwC2_Qmp
X-Proofpoint-GUID: ngys05vogRKFcH5zJgd16LwElwC2_Qmp
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The following changes are made to enable userspace to obtain 64-bit extent
counters,
1. To hold 64-bit extent counters, carve out the new 64-bit field
   xfs_bulkstat->bs_extents64 from xfs_bulkstat->bs_pad[].
2. Carve out a new 64-bit field xfs_bulk_ireq->bulkstat_flags from
   xfs_bulk_ireq->reserved[] to hold bulkstat specific operational flags.  As of
   this commit, XFS_IBULK_NREXT64 is the only valid flag that this field can
   hold. It indicates that userspace has the necessary infrastructure to
   receive 64-bit extent counters.
3. Define the new flag XFS_BULK_IREQ_BULKSTAT for userspace to indicate that
   xfs_bulk_ireq->bulkstat_flags has valid flags set.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h | 19 ++++++++++++++-----
 fs/xfs/xfs_ioctl.c     |  7 +++++++
 fs/xfs/xfs_itable.c    | 25 +++++++++++++++++++++++--
 fs/xfs/xfs_itable.h    |  2 ++
 fs/xfs/xfs_iwalk.h     |  7 +++++--
 5 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 2594fb647384..b76906914d89 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -394,7 +394,7 @@ struct xfs_bulkstat {
 	uint32_t	bs_extsize_blks; /* extent size hint, blocks	*/
 
 	uint32_t	bs_nlink;	/* number of links		*/
-	uint32_t	bs_extents;	/* number of extents		*/
+	uint32_t	bs_extents32;	/* 32-bit data fork extent counter */
 	uint32_t	bs_aextents;	/* attribute number of extents	*/
 	uint16_t	bs_version;	/* structure version		*/
 	uint16_t	bs_forkoff;	/* inode fork offset in bytes	*/
@@ -403,8 +403,9 @@ struct xfs_bulkstat {
 	uint16_t	bs_checked;	/* checked inode metadata	*/
 	uint16_t	bs_mode;	/* type and mode		*/
 	uint16_t	bs_pad2;	/* zeroed			*/
+	uint64_t	bs_extents64;	/* 64-bit data fork extent counter */
 
-	uint64_t	bs_pad[7];	/* zeroed			*/
+	uint64_t	bs_pad[6];	/* zeroed			*/
 };
 
 #define XFS_BULKSTAT_VERSION_V1	(1)
@@ -469,7 +470,8 @@ struct xfs_bulk_ireq {
 	uint32_t	icount;		/* I: count of entries in buffer */
 	uint32_t	ocount;		/* O: count of entries filled out */
 	uint32_t	agno;		/* I: see comment for IREQ_AGNO	*/
-	uint64_t	reserved[5];	/* must be zero			*/
+	uint64_t	bulkstat_flags; /* I: Bulkstat operation flags */
+	uint64_t	reserved[4];	/* must be zero			*/
 };
 
 /*
@@ -492,9 +494,16 @@ struct xfs_bulk_ireq {
  */
 #define XFS_BULK_IREQ_METADIR	(1 << 2)
 
-#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO | \
+#define XFS_BULK_IREQ_BULKSTAT	(1 << 3)
+
+#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO |	 \
 				 XFS_BULK_IREQ_SPECIAL | \
-				 XFS_BULK_IREQ_METADIR)
+				 XFS_BULK_IREQ_METADIR | \
+				 XFS_BULK_IREQ_BULKSTAT)
+
+#define XFS_BULK_IREQ_BULKSTAT_NREXT64 (1 << 0)
+
+#define XFS_BULK_IREQ_BULKSTAT_FLAGS_ALL (XFS_BULK_IREQ_BULKSTAT_NREXT64)
 
 /* Operate on the root directory inode. */
 #define XFS_BULK_IREQ_SPECIAL_ROOT	(1)
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 4077862fa806..207c96bbc729 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -839,6 +839,10 @@ xfs_bulk_ireq_setup(
 {
 	if (hdr->icount == 0 ||
 	    (hdr->flags & ~XFS_BULK_IREQ_FLAGS_ALL) ||
+	    ((hdr->flags & XFS_BULK_IREQ_BULKSTAT) &&
+	     (hdr->bulkstat_flags & ~XFS_BULK_IREQ_BULKSTAT_FLAGS_ALL)) ||
+	    (!(hdr->flags & XFS_BULK_IREQ_BULKSTAT) &&
+	     (hdr->bulkstat_flags != 0)) ||
 	    memchr_inv(hdr->reserved, 0, sizeof(hdr->reserved)))
 		return -EINVAL;
 
@@ -897,6 +901,9 @@ xfs_bulk_ireq_setup(
 	if (hdr->flags & XFS_BULK_IREQ_METADIR)
 		breq->flags |= XFS_IWALK_METADIR;
 
+	if (hdr->flags & XFS_BULK_IREQ_BULKSTAT)
+		if (hdr->bulkstat_flags & XFS_BULK_IREQ_BULKSTAT_NREXT64)
+			breq->flags |= XFS_IBULK_NREXT64;
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index f92057ad686b..5dce090f8f65 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -20,6 +20,7 @@
 #include "xfs_icache.h"
 #include "xfs_health.h"
 #include "xfs_trans.h"
+#include "xfs_errortag.h"
 
 /*
  * Bulk Stat
@@ -74,6 +75,7 @@ xfs_bulkstat_one_int(
 	struct xfs_inode	*ip;		/* incore inode pointer */
 	struct inode		*inode;
 	struct xfs_bulkstat	*buf = bc->buf;
+	xfs_extnum_t		nextents;
 	int			error = -EINVAL;
 
 	error = xfs_iget(mp, tp, ino,
@@ -134,7 +136,26 @@ xfs_bulkstat_one_int(
 
 	buf->bs_xflags = xfs_ip2xflags(ip);
 	buf->bs_extsize_blks = ip->i_extsize;
-	buf->bs_extents = xfs_ifork_nextents(&ip->i_df);
+
+	nextents = xfs_ifork_nextents(&ip->i_df);
+	if (!(bc->breq->flags & XFS_IBULK_NREXT64)) {
+		xfs_extnum_t max_nextents = XFS_IFORK_EXTCNT_MAXS32;
+
+		if (unlikely(XFS_TEST_ERROR(false, mp,
+				XFS_ERRTAG_REDUCE_MAX_IEXTENTS)))
+			max_nextents = 10;
+
+		if (nextents > max_nextents) {
+			xfs_iunlock(ip, XFS_ILOCK_SHARED);
+			xfs_irele(ip);
+			error = -EINVAL;
+			goto out_advance;
+		}
+		buf->bs_extents32 = nextents;
+	} else {
+		buf->bs_extents64 = nextents;
+	}
+
 	xfs_bulkstat_health(ip, buf);
 	buf->bs_aextents = xfs_ifork_nextents(ip->i_afp);
 	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
@@ -356,7 +377,7 @@ xfs_bulkstat_to_bstat(
 	bs1->bs_blocks = bstat->bs_blocks;
 	bs1->bs_xflags = bstat->bs_xflags;
 	bs1->bs_extsize = XFS_FSB_TO_B(mp, bstat->bs_extsize_blks);
-	bs1->bs_extents = bstat->bs_extents;
+	bs1->bs_extents = bstat->bs_extents32;
 	bs1->bs_gen = bstat->bs_gen;
 	bs1->bs_projid_lo = bstat->bs_projectid & 0xFFFF;
 	bs1->bs_forkoff = bstat->bs_forkoff;
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index f5a13f69883a..f61685da3837 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -22,6 +22,8 @@ struct xfs_ibulk {
 /* Signal that we can return metadata directories. */
 #define XFS_IBULK_METADIR	(XFS_IWALK_METADIR)
 
+#define XFS_IBULK_NREXT64	(XFS_IWALK_NREXT64)
+
 /*
  * Advance the user buffer pointer by one record of the given size.  If the
  * buffer is now full, return the appropriate error code.
diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
index d7a082e45cbf..27a6842a1bb5 100644
--- a/fs/xfs/xfs_iwalk.h
+++ b/fs/xfs/xfs_iwalk.h
@@ -31,8 +31,11 @@ int xfs_iwalk_threaded(struct xfs_mount *mp, xfs_ino_t startino,
 /* Signal that we can return metadata directories. */
 #define XFS_IWALK_METADIR	(0x2)
 
-#define XFS_IWALK_FLAGS_ALL	(XFS_IWALK_SAME_AG | \
-				 XFS_IWALK_METADIR)
+#define XFS_IWALK_NREXT64	(0x4)
+
+#define XFS_IWALK_FLAGS_ALL	(XFS_IWALK_SAME_AG |	\
+				 XFS_IWALK_METADIR |	\
+				 XFS_IWALK_NREXT64)
 
 /* Walk all inode btree records in the filesystem starting from @startino. */
 typedef int (*xfs_inobt_walk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
-- 
2.30.2

