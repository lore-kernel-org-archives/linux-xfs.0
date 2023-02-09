Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C83F5C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 08:02:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjBIICG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 03:02:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjBIICF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 03:02:05 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13051351B
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 00:02:03 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3197QHS5023505
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=dQvLZOogNQQ17Eu9k8jhxLtyxVP8S0cseb4hxja3+38=;
 b=X2TLNMmcgHx3DktE4FpQ7SST08LDMCifKlmETxKasiDelg7T9aovjnjRZ5Q0dyr10zps
 M3Kb8tOjY0lqXY7Ryvy7XW1/gUca0euXapq2o8Ok2ewc1bbnKK8GltohEECPGuU7TSdE
 igmEtqW3if4QM5xkfDAPFk9z7Z2QyT+sxswZx6+FDucaTKuRiK8ZCy353OmHMGX0LQS2
 PhwWOQ3h19Z755RemAGJxbPCJ5Py9ZiHem8N8NhFarnMNfOYFFIfVo9EsdBAby9RkV3K
 +a8YMO291LQJxLwyZGdUx+3lE2FtkhP3cQInEsKQT18UtdpyACxC5KX/LI2fhTfGy7XF dQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhfdcj6ch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:02 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3196ZHTU021288
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:02 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdt8duya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EQpTPXShvAk5dU9WEI9d5+ZM0knFu7i8lMLHaceSLo6DxSkv75V7VgFqDFyYYkcMTON/hhJ083Y6goGhriIj/W5KhEb0HpkLwyARHPvxzyi/XTm+9b9FP37LwowVaWxCckTOT1EwAFRHQKltRLoL10+F2ggoxo6VRb7kHgc21OoXkD4Hs8Wzl6ss0t5a238Pudh7PgZXGXq/e6XIPicWhBQkiTP1MK1ENx+aPjtbDEJvUT2iMv4QqsRVj5HU8i4fURQQ6g1w72hLqTXZlQiYiuaOYFFHdsdnmOCwu3w7LC6UXRCpxOHZYQnxtp3tTPqCWdYYjytI68O/r6pVVXjuGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dQvLZOogNQQ17Eu9k8jhxLtyxVP8S0cseb4hxja3+38=;
 b=OJ3tNrOc+PIvI1qCYlUgKRsVofUtMiER9J1U2uWc1upJJOOrV8cGP93jhNUHgespOHbBbv64q+Q427E64ZRhO6EDr5IJDshzA/alJRWR6fQIGSaGQ0ZXDKAD/dBqUM48UBGTbguj+cAckuPEUCA3DN0Lnsm1N8vlseYQg1baBuOnHO5CdFmxlnIG5CHqArLpQIgmNvif4MZrgaECVTEWpgkhq8C9AxCV/ySsF/fYKDIdBXKIT3lhMmnaTS1UvxGUeVt5JU6yPQF6BSVrEx1StGGHtnBeF2/hHZod4mzJNDDec3zv/LqmmZbkfm7FkAtKTOUv+52IeXSQqlScxtc16A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dQvLZOogNQQ17Eu9k8jhxLtyxVP8S0cseb4hxja3+38=;
 b=ik579Bnse2ON+Ssma7DDmOJUU/g9fgOzvv/5XkyUaXPdHLYj28y9BYSiVnG5K2UH/GdER/YhNxH2Hvit1M2YRPowgQKF3K1Jn7pHCc18Fe51n5a4d/3ZuGIBcgBtHzFPe1T6/hDDcl6Kju2oAcHNG8bXOf+L4Q1c5VFMpQC/X6s=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA3PR10MB7070.namprd10.prod.outlook.com (2603:10b6:806:311::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.14; Thu, 9 Feb
 2023 08:01:59 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6086.011; Thu, 9 Feb 2023
 08:01:59 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 06/28] xfs: Hold inode locks in xfs_rename
Date:   Thu,  9 Feb 2023 01:01:24 -0700
Message-Id: <20230209080146.378973-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209080146.378973-1-allison.henderson@oracle.com>
References: <20230209080146.378973-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0375.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::20) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SA3PR10MB7070:EE_
X-MS-Office365-Filtering-Correlation-Id: fbc5be99-4770-4bf5-4cdc-08db0a73eb5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c2hgBxskdSnM/zAFW6Aq+o1HDyShhNOClH04ZKTJN+glOTfLQ+jYyKKTKOWQXUODE2DyeQiVJ8TRjwaorA2D4v3oo3gum5zCKp05H89LS98VzUOJHIpybmRvHAeYnt/fmnuTZtQjMpn7veFeCikqK8aBJCyvBRA6lxOjXqq2E/HDQeidx/X0lTpDYhHpq4iA+zgJcxt7ifJtcFTfYtioQodxDjJSuvjU6i1jZ4ePHjjxZNo3fqpSC8AMgQTizRHUlezIQ1XbNHVHnAo6Rv+UGovA/FyqGB5Fl2PHgsO0dpeiqRr7AnZiuyLmaEWjs/pquuAbLWQWoNopqPQYPkUqqs5GK90GwfmDO99r6YKn5JFol9+UxofuDkY7vLGRaTWUaMHPpb8iHY+J31eHhEyCJocmT9W4w8LDQDIPA1NSqmQvJuCZ+BCa6Pql5qRmLSWVHyiPPuJFtwJQ2f6PoWDykth1qWOcZW8O0nYQn6RK76FTqytaQJ3OmAukua4PiNfHU3TLXHI20+XzjS9WxJnHSQAfvQM+h88kRszSZQDcMEaLClBQaHV9MN+dgltQ3fDFUAu/LAsoTnMIqpdxcEHDkRNaAvlUqBrws0LIzdIyn4DgY68Fw3SEyZDCUUdr8H7PbEpEVg/SuAf+EAyKz8qSSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(346002)(39860400002)(396003)(136003)(451199018)(478600001)(6486002)(8676002)(83380400001)(6916009)(66476007)(66556008)(5660300002)(8936002)(6506007)(1076003)(66946007)(6666004)(2616005)(9686003)(186003)(6512007)(26005)(36756003)(316002)(41300700001)(38100700002)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RX1c8TIJmO06DzwB2laZG5tCV1SmBEJYLXGHFXzBdevjDfWTn+hbM4q4kggU?=
 =?us-ascii?Q?gMZp7oGRhTnETMquL0nYXrNk3Kh/0kyxCm+7j5w61LwM/S64+dBDdU6aZ+FP?=
 =?us-ascii?Q?zk22lLkrcsZf7ATvWzW6n3oIhAAO+x4klNZKnzPeZtuNp+JzSlyeCEaN+ylM?=
 =?us-ascii?Q?ZMeliYs9iavs45Dg+9lexyDh1t9+lpNHGEA+zp1Gga6+ZSVoGvzrwGXNIYZl?=
 =?us-ascii?Q?fMzPeurdVYMjW0ZJCM9D6LZVK3JiZOK7Ls5N0fOAKwbrUyGrMtH/dAFbUSQN?=
 =?us-ascii?Q?ZEQRV+Pt1U8aVTilmlhHniHKBqUv4hl0TbUUzXbG57nN12MFzhL5ghaJHiDU?=
 =?us-ascii?Q?zQwXlJ3jGt/vDhrnSZtCDq5FJ7Aq3fLoW94kKwQ7LH57C6tjZdfN4nrPXhEf?=
 =?us-ascii?Q?Fz1HDSHPYbFyEocCwpHAttvBIzTrQc6LFwt9fLrV2sTC3Ci7wAKbxg7bv7uB?=
 =?us-ascii?Q?/JSx7qpa61gXLzIaXB7V7HyGSL0hUzcsC7DsZdY7Rf1flUT7d/esZ1LSwYpX?=
 =?us-ascii?Q?2fw7a+g3rJ/t5QQGnYNkawaTYIP7KGQiDQ+t/vgtgbjwgtrT+1FUcC9T/FX1?=
 =?us-ascii?Q?9qMT3xFYlEq1o9krbeJc4qLQFn0s1SLYPDV19zbovWiYLt3FkLXS/cP6ylb6?=
 =?us-ascii?Q?GcYNS+ryVZwSUIQ+es8+34JzbVEJxtWknxtm2V+G9pij9Jj8vmxrZXY3O/Zy?=
 =?us-ascii?Q?ufPL4kzkIMkf2OjDCb124VvmOWzSsaNFR14IwZ+mBf0WQ7fCvID3BSflFZ6b?=
 =?us-ascii?Q?yY6UifTnj99OSF3VnI5dBXcHDU1SxsuJtnbsbz66yqms+2b0lsiKZR1zGHf8?=
 =?us-ascii?Q?QruHihK0u88/Q2Cpi3JtLf0KUGzy0e3/xJ2vrez9MDzl0fktDsz+Yn9Zh7zI?=
 =?us-ascii?Q?acBjhShP32ZsCfTLDFPWSvGo2QXOP1tL8TXANLZOmux0HXwKZc2vUbDU/TN2?=
 =?us-ascii?Q?z1cW7RadIHbnN7Fxs6kMnMObI6IrWUKXd1mU6BWpg0xBOK5NHBNI2WXtY5fl?=
 =?us-ascii?Q?ZmcmC+zd1lSLCqRPGi1960OJbHURjqMEAsCfCL86/NdBDIiJPWk4kTYo6ZTv?=
 =?us-ascii?Q?6RSwq505R+fousj1+vmwo4EexD62oK56EzesEuaxAgeatzjPPxxc9SFr5qjF?=
 =?us-ascii?Q?KPua9Bz62bvU8P5E0klViWb8E6M8tw9IeOThyJSqj+Cl8PyX0gZ8l/pX6Q9Q?=
 =?us-ascii?Q?W6c3SwrwGiu43qzmzl+bN3EOKAg0LbGZsWAYZ2zyCO+tVpHlIqwWyBKKM170?=
 =?us-ascii?Q?X4r46vJ+FK0PFLGJDtRgzLs0aQgRJc8JPh1CizRI7+b+DZNQBNaicyIYFLQa?=
 =?us-ascii?Q?l1D0ZvHwkGgkueBuEF1lrZ8JQkcCIFyNDTeZbM/BvKKD7Wu2IWTLdWYY8yaB?=
 =?us-ascii?Q?dyzPjjndRADCGaDfUhJsU4lS+mKDdysVROGttZvQikwJ9mK0QpxrZPjXG8sD?=
 =?us-ascii?Q?mQznZhH6sPHink/HHxrRcC5/QuD1gMUg4xySfCdy42/9r0Mh8LLTTKxiGRmo?=
 =?us-ascii?Q?riKrIcrYWw+5niIsrb7XFrXVekKh3Ii9z/CV+jkLfDxITkPqhZJfvkMUe4W+?=
 =?us-ascii?Q?Jne4chOLePPfcMyKQ0ZGrTiMGr7NV5hMkHtK1QH6KBKxxbDi4WEJi2cX2qXf?=
 =?us-ascii?Q?Og=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: um613xylkV9tFgej09J2Rpnh2z3XAwevkSGPD2E9a0Wy7r0cFm/Y6eHnrEsCY4nAowAYLKWqaDjdMqBaf6UttqmfG1T04ahnscFcGAgSy6eP1CQWcqOFYshXmiuhsPOelcuZ3K3qKTcBIU/mzPJpHwUV3SvoeppjnVfgn53GjFsIvEtSrXU3wCOJq9rDGYtPEr4zrLBxCagst7BC0c9mxh7dkcWAa+ssWRfOmLWzeRTDWD4zmnDfqtk8PWLXWyw2hM4ihEUkMGTpgsmiD8m+eYrzpnFYkcsbx0hBqJh2zu5OZ26YYaDrwgunCkIBScuyMnVQ8aHnIIUOXNDf5O5MuqDQGGuI3eJtAFET5qrUhRHRfdkzHVdpRkvS99C/WqfoKZO10DbQo4gJblj7zTKF92moU9nSgSDibl/NituaTp0CX9MVggWFckIjNdVz6HwUT7SEE0lGnEgcnRI2LhhHMHyFjLkVem1lY0bT3TAuI38UEL1uvB3iVfvLp/VQPvuV69vjQlYU7QrUiJ86o2l0MqEgh4AcdqDoaBtb6IsT7KCZjrpAOMfBKQKuO6+Hnu96d8pSkqg3YsUdOYvIfykaB8iyYFIy/4Ux5PlDyRdOdR6Vpf0FKCfQn2ASuBnm5rwK+a+6gItLrR4jZ3Kc7BDR5ocJiDBH9UvIBukHyew0KJtzr1B67i8WUiQRhFUUhdd/pnOcjCipJllkDu8PTP0D7Wa/6mPuKNbt5yB9ZwpN/fV+pMq6s5Jq+5tzGdj21MNo
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbc5be99-4770-4bf5-4cdc-08db0a73eb5f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 08:01:59.4776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 52yv6dRqTFeZ8fXYHmaHzYzMAhUN4nOPwOOfGLUWNFvz/g6+9u1W4R1IusAva2AQLNDUyuQlVzatnuh3Ip7+UGi65kqd2QehUQFZqidkQKM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7070
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_05,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090075
X-Proofpoint-GUID: lI8P0wDMh3iLCppzYdTPQMbbumjfAxp9
X-Proofpoint-ORIG-GUID: lI8P0wDMh3iLCppzYdTPQMbbumjfAxp9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Modify xfs_rename to hold all inode locks across a rename operation
We will need this later when we add parent pointers

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_inode.c | 43 ++++++++++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e292688ee608..131abf84ea87 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2541,6 +2541,21 @@ xfs_remove(
 	return error;
 }
 
+static inline void
+xfs_iunlock_rename(
+	struct xfs_inode	**i_tab,
+	int			num_inodes)
+{
+	int			i;
+
+	for (i = num_inodes - 1; i >= 0; i--) {
+		/* Skip duplicate inodes if src and target dps are the same */
+		if (!i_tab[i] || (i > 0 && i_tab[i] == i_tab[i - 1]))
+			continue;
+		xfs_iunlock(i_tab[i], XFS_ILOCK_EXCL);
+	}
+}
+
 /*
  * Enter all inodes for a rename transaction into a sorted array.
  */
@@ -2839,18 +2854,16 @@ xfs_rename(
 	xfs_lock_inodes(inodes, num_inodes, XFS_ILOCK_EXCL);
 
 	/*
-	 * Join all the inodes to the transaction. From this point on,
-	 * we can rely on either trans_commit or trans_cancel to unlock
-	 * them.
+	 * Join all the inodes to the transaction.
 	 */
-	xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, src_dp, 0);
 	if (new_parent)
-		xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, target_dp, 0);
+	xfs_trans_ijoin(tp, src_ip, 0);
 	if (target_ip)
-		xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, target_ip, 0);
 	if (wip)
-		xfs_trans_ijoin(tp, wip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, wip, 0);
 
 	/*
 	 * If we are using project inheritance, we only allow renames
@@ -2864,10 +2877,12 @@ xfs_rename(
 	}
 
 	/* RENAME_EXCHANGE is unique from here on. */
-	if (flags & RENAME_EXCHANGE)
-		return xfs_cross_rename(tp, src_dp, src_name, src_ip,
+	if (flags & RENAME_EXCHANGE) {
+		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
 					target_dp, target_name, target_ip,
 					spaceres);
+		goto out_unlock;
+	}
 
 	/*
 	 * Try to reserve quota to handle an expansion of the target directory.
@@ -2881,6 +2896,7 @@ xfs_rename(
 		if (error == -EDQUOT || error == -ENOSPC) {
 			if (!retried) {
 				xfs_trans_cancel(tp);
+				xfs_iunlock_rename(inodes, num_inodes);
 				xfs_blockgc_free_quota(target_dp, 0);
 				retried = true;
 				goto retry;
@@ -3092,12 +3108,13 @@ xfs_rename(
 		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
 
 	error = xfs_finish_rename(tp);
-	if (wip)
-		xfs_irele(wip);
-	return error;
+
+	goto out_unlock;
 
 out_trans_cancel:
 	xfs_trans_cancel(tp);
+out_unlock:
+	xfs_iunlock_rename(inodes, num_inodes);
 out_release_wip:
 	if (wip)
 		xfs_irele(wip);
-- 
2.25.1

