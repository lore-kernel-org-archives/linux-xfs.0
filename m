Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DCC5CCA481
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 11:21:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbiGRLVs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 07:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbiGRLVr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 07:21:47 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC337E0C2;
        Mon, 18 Jul 2022 04:21:46 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IB4cU8029646;
        Mon, 18 Jul 2022 11:21:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=T1gLfVOZGb3ygpi3UnR9L5Ms2ccjJGIiQCHUoEso6UA=;
 b=jixGqpwcr7t3oAn0x81q1kF4IVt2oAiVL7DCYNpMsGYO1MaCfBwa30GAhOjlP2temwXQ
 c7680s0mWS7GsZGTm9iX/WwNElFa3SXkNoDM/oZxegiZE8NI25whrbia0iEZ9mjonwZ3
 pV1Ts3tFAUgPLYJm9slNFCnSkIXGWWjRr9HjU+wk+1yq3XbKjU7zqRjBwdGQumQc4mlm
 XhEVbBjPJU+Jagy2tHkloXBo6aWpi3FOXhgN7WtscG0DT45UuOtYILjLMlsGRDrJsyVT
 ++JQliMB9igQbTp8lrWQAvgZsQrwwOQMH3+fb9CaULVefNaSJXfUsAhYSbKWqk/0ma2j JQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbkx0u1em-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jul 2022 11:21:42 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26I8jLUx004038;
        Mon, 18 Jul 2022 11:21:41 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1k3qq5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jul 2022 11:21:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SJV1V1o4zu86nITvHpi7ubyQdDLSTCHjNXDrDSYHsVYR8UGJNvigmaSAgqwaPbXaybcipaTHXGGcVSoO5xcZ3DCXSF0YI9/uPfLE3fWjRfL5UFiAHRN4omno52cj9oKwUeu6f+ZklW/uAhl+BE6bRjdhioW43pVw1b9TVevXCTRLQisABRUOZbcm3URUFU5Au/MVFHFvXM2XjU1+NQGhjuonZZ/Nyc3/oD7T5pEG49FmUDRVGv6Qs6kwP+fpYnQL3uaa6IEzz92DmHy6SV9ZbAh1ahhnwqXWsvkXspInFB4u6Xfo/bEYMaIPAq/TCP0eGN57HH8K+LJoz1xTe9MlWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T1gLfVOZGb3ygpi3UnR9L5Ms2ccjJGIiQCHUoEso6UA=;
 b=YVB8LOKjNyh9TbKKbmIlhKr31RysLj92e92FfhoFfL6SG8R7+bfUIEcgCgWNzH84yh+oLMkzVZrOF4f6Gi1R61bIVDZMCH8B+uaNYxz043DPCxkeUZ1fStV0JEPWNC7rJWtcjMWAE5Rylzg6qY5rXduf3BPlXCC6Cyxe8xPi97HmBKnR1/afBcRhHZtZ3DOzsgJeWHhv/lLYMYbr6ccdiLZ6DjEgAI4muSJKhaL9+7Ho5fzflgn116rInozNZ5HnNt5aHeCzXJ3eosdM4kDR5lqv8OleLCP823QZxRmhl13R8W6Ul6EngZBACCuOVTjxsEkU+CpCwDHms5DadVOMfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T1gLfVOZGb3ygpi3UnR9L5Ms2ccjJGIiQCHUoEso6UA=;
 b=Weffz9gkgkaDdOU684i60sc3kev1Qk0WYxUkKCe5pkWXKR6+DoJ3KsSOmUgjMAxEm9i5bhj294jVa3QhakyIZ3thr2OMrlzYqAieaxfdefBLhpSDIC/ZevPVfSxKyqKMpH2e2Fq+93io0L54+WbsB/DpvpaIGS0LJP6XjqWQcvg=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN6PR10MB1521.namprd10.prod.outlook.com
 (2603:10b6:404:3f::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.13; Mon, 18 Jul
 2022 11:21:39 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 11:21:39 +0000
Date:   Mon, 18 Jul 2022 14:21:30 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] xfs: delete unnecessary NULL checks
Message-ID: <YtVCOtQ7PCRfjXY6@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0107.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::22) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc31f568-81fa-40c6-2e7f-08da68afaf3b
X-MS-TrafficTypeDiagnostic: BN6PR10MB1521:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G6RMmk5YQlMbSkWK77UCVkIZYCSmUzYO9Nqnv4pAWLC/ZjpcXCBNzP/96rkqnnXLJXsvQaxfpl/yl5joMYtF6A35ZwDjj6Fres6Ag1kfafPrfUMeQN3lp5dLcVHhOd0M3EodyWp2SFPysmSp7bYsTyuVnYicDC/IrJ9x0pf+3nMax8B+FrascpyBgk65t/FdZ4Wm5Q7SPGZj+QkFlwXEWS3AjlD3MTfgl4C0aNq8UMQFbrKTJ81iABs6+A1KiM3aL+XA8pioaKFGuduF/dvvDgwXRjeAf6qbzX/8aww4jnkTsWIzhNXhXVLpE/PUS2r9ftXSGgdlgbqZNxu7PyfASgu28Oeh6XQOYbIHr4kaeMnfhkvJCQFjZFD6mZXtEevUZWZJlfZOj95QDZMxoETVElSN8HlD0/4kdPP5KyqshTHc6J9n3oeIPEcxoSVklGcU8aIn0rAa4kK+AxZnLT+DjZGPw0pz30JQ8ubz0HgIXIL8qwdIShPclezK2yCZWa0jwF/N6Wrlz0Uo5lX+uP6A4G4EMVidRUFsrvjNuB7WOtrw7o+ksoy5dPBb8+xpnOs4uVegstjfcgBMBHzo2kgt9Gt7tpZZGuQ8aepLpCUbwRhi0vUq65CDMd9zslo12Av4eC+Hz3ov4PbKtwsYT9c4vUELmFGUnFVwIUtXGDzU91wZm9lACJVY26SBI9u15FLsj94xo4rahjvJEGHv+lyE2FTOMP9l2zVm6Lsw10A3o28p2vjiT4YbPwS94ap0COx6+OO8vE2UzKGW/raQ3rykMdmOizQ/0AcJjtHxGe6bgfAJFyTnIwb2PD1RpW4OIgUg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(396003)(346002)(376002)(39860400002)(136003)(366004)(4326008)(8936002)(5660300002)(66556008)(4744005)(66946007)(44832011)(66476007)(8676002)(9686003)(33716001)(26005)(54906003)(86362001)(2906002)(38350700002)(83380400001)(6486002)(478600001)(316002)(186003)(52116002)(6916009)(41300700001)(6666004)(6506007)(38100700002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DlFOCXzTXfqDRWTJRKLj9oT27v1xii2P/hEY+dqKpxYTqnTeHhIkvkUTIO87?=
 =?us-ascii?Q?eVvEWI2RxRVWg4vqJ+vXY5PcMmT5q/+BK89TtuEdW3EoUjBd7leTZLiZwoIW?=
 =?us-ascii?Q?ZgW7HVA2aKYcp13cKBFY9sZbLplGwdDGrvZ2mjIGhBuQ6SQLeTnYM3GmLej1?=
 =?us-ascii?Q?Fud4TKa7zNyqnjy9gLPN11ULDOcMMAri9xiwYvJIcHZtMaF/DCQZbV15gb+H?=
 =?us-ascii?Q?NMq8Q4jMa2zEBgY0KbuXcMlhjlhjrTfgAHeGXKgpVicCiS5Ycnxs7MmSImXg?=
 =?us-ascii?Q?8s+/+mlWqt8hhbU0ckzRT0pkcwR2iuasXgNiMbGMO5L8BMs4T9a93A5oOiTR?=
 =?us-ascii?Q?ZnAX2mgN4cJfA5AOSSSJstQ4Il/W00zF7KHLElQUA7hDCZ3aCjTaUiGzbimz?=
 =?us-ascii?Q?QrNgZcXbZKeNuaf0XfRgPlOdN4x9m+x+YPahLXivl8sDc+h5bScLA7BUd5A7?=
 =?us-ascii?Q?Iyes42TQ8FPHsw+b9mQCL6F9tNAoNADeM6u1y+0VhQD589PQYuJlMg5ZZqjU?=
 =?us-ascii?Q?N1ZMFCj0GWnub6jiiExFJe7HmDmOBe/sW6mtantPM9bVRnh344MAFa+Cw6Ed?=
 =?us-ascii?Q?HL8AoUeGEJsXAAeB59s/GVxIjT0RyCbkHEo6skF5kIu6ZuuKKSHP4j/VmW35?=
 =?us-ascii?Q?ADq8qIBSft/jxMsnEqA9IYcrblNS7UHHVR5PeVj9kBQHO2Cpb+JeB6CKj2Ze?=
 =?us-ascii?Q?APIkD9ynfHyYnKZ+W16XXu71LziawchdUmXw10Lyn+2FOKBpCD7j100bEtDF?=
 =?us-ascii?Q?4sdZC38T+dgA3byogvTIGP2iy9NObLTxXVJANnFW+oN2/MF5x0v28h3bWPmW?=
 =?us-ascii?Q?WITBS/FgH+sYlqXqUwoWnv3tVRHDBpZ7uEfJQQyZRkz3ATsCfEs/jsyCy451?=
 =?us-ascii?Q?xpoXlWq0XQy1AmSFNQgigacDkiZ1K2mw1akVBPVHQGJmItXaFztzvhen9pUD?=
 =?us-ascii?Q?bmgiMJ5ARyWWQUxKDLF31ny2UI3JbFYYbDcr08K0i0XDTcRuqwMNF4ovksR1?=
 =?us-ascii?Q?S+aSWn21Gto/oJqYZ+yEpIHMsu51cGrU7uyUSVf27+lYrrQZDVC60s+3oKbA?=
 =?us-ascii?Q?He3D+d7oiH5m9o1ivUU9Nxo8S9QQ6u4KonIaU0Yc7Uuk9O6l4WFUsr7QlWmD?=
 =?us-ascii?Q?KfZ07wFRhXaIolicrX7E1PctY3AVwj7wKpCaPJm0nzlHos8uUFDGefkM/LAy?=
 =?us-ascii?Q?fiBo22aD0t3shGJe+Qeb7P7v2FHnHEULi50z0tVCHPfO27xvr1J6yppzZqbN?=
 =?us-ascii?Q?pyXYa9TQH1k1W5KdVzCdFJ3plMHCSiX0DpLVpqON0bVO7SO+QfPEjsfCpwED?=
 =?us-ascii?Q?0yieyb9fXMOeBbU0kVpz1EfsB7hJntMh1nmNW4oOjJqu5WEtltpi+CVHHADQ?=
 =?us-ascii?Q?DfOKTurC7fG2iWNRMSZ7t1W1FKs6eMRK56xO2w8MlK40dFNMlZm/eI+BNdrQ?=
 =?us-ascii?Q?kh0CNextDdhr1RAiO98v3nEunrnDPIxs4L2qg1BTMhaPIVs8y/vfttJi/oT+?=
 =?us-ascii?Q?STtTtZiVhfTAp0u40LTjR7KhEw2yFh4rLvwLCJtUCy87L4MGsBO6z9r1UpKJ?=
 =?us-ascii?Q?F/LzfOA5QjBru0EdeplgQtFBPkw4rzGG9C3ceo8lyMRJA+GnyedMa45A3ojC?=
 =?us-ascii?Q?Yw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc31f568-81fa-40c6-2e7f-08da68afaf3b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 11:21:39.6209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NPcqnuj0hx5muqUdYUzC22hOiAqoVIxZ88wQ2vYF/ve7olSzUu52tleBSBKrLwlw+Xer9OmEd4jfYLcqmvtaW3CINCwQL2HdgrtQ269oB0c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1521
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_10,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207180049
X-Proofpoint-GUID: rAvH4-PSHpHZlNVYNcl3O8BLZHb7Tzvv
X-Proofpoint-ORIG-GUID: rAvH4-PSHpHZlNVYNcl3O8BLZHb7Tzvv
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

These NULL check are no long needed after commit 2ed5b09b3e8f ("xfs:
make inode attribute forks a permanent part of struct xfs_inode").

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_fork.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 7c34184448e6..fa699f3792bf 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -724,8 +724,7 @@ xfs_ifork_verify_local_attr(
 
 	if (fa) {
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "attr fork",
-				ifp ? ifp->if_u1.if_data : NULL,
-				ifp ? ifp->if_bytes : 0, fa);
+				ifp->if_u1.if_data, ifp->if_bytes, fa);
 		return -EFSCORRUPTED;
 	}
 
-- 
2.35.1

