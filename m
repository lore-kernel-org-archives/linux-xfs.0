Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE246C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 21:13:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237070AbiK2VNo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:13:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237061AbiK2VNF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 16:13:05 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E202BB3E
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:13:03 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATIiEpl013743
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=9UkMWpn8RoSyZpzPormyoSQRWiX5ZQZ+JZiMXjJnfYY=;
 b=AnCkew5l+wFoSWZtywLpwcoQqtPCYD4Bz1viRLaakXb9WhJJvLVuIa1cQuJ3lEcvkt5X
 waB0esjXk8QcZJoqvxIa8t3HDKdMzJeaT8IIejEyL8tSGStJm+vgqGmI+m+LxoMQJjt0
 wRw5pmUEA+zyTQVR4zYG43F2zovor2s1N4IxrZiugxncZbeRCfqdKgM+F7jyalLIgVc7
 Qr0HD7f52gCPquRpkmHDe4ABIwdZusPtpYPlc8BrbD47JfrEICKWAXOrlMgnyYr06dfA
 xcohHUViAuSRnkfNkiEHjUq2+dq1+pSB4gU0CkqsqDxOlPz7M4BqPWTmcsX9ldiXu0ek ew== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m3adt88ab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:02 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ATLC23B031443
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:01 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m3987nabv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ots3tPLABZogZGdjA7V8/M63QowiHfi+W/Zo/ysRSL6ctIp3hES4UXkR4YkC97EWvjwT3ApPamV7xH9stXqlLgEytc5dbaiJCKffmR3Ji+Tx0gbiN/v6nwQT2MlMg9hUeAAHJiGtUVX8fn3PtYlgKrUWiPHEhNMBad6o3e7trkaMQkyd1nQnkbvAugu4i33nc8xFR8OWLyhmS4oFLUhxrBQDFEQOF0jAvCHwvP+B8DUY9oylR0legUy3Ddhq0lUbPH88PMhiFwJWCeEw7ZjIO66EWhJmSY/d77hojoR69oz6pKbL8L3c4BnPD7CBMl5CjAgMjCHYp9P6EqHNcEr0dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9UkMWpn8RoSyZpzPormyoSQRWiX5ZQZ+JZiMXjJnfYY=;
 b=RWkh7TUWZjMuO85mHeKbACWzT3wgAfXfKL16KEfPqTgVYb10ZuFI1y5CjF/xBrFx0DqQ723FCk++wYiSXM8E48no5MBHvMiUXjH95da5wYOcfKUVht6sSneo5yQLRYu3b5mH8aZxqwfhERIdvpQ9J5Qs2lsMBUz3DvXCWrLhrKoR50dyHtJiu3CKK/vLYNGr+5Zfd8zl25rFvqklTyCymKTvHS9P6bAMqX9Phgd9hA2eXGFrDl5yWjRPzudNI9Mh96c5L2hzWo7Idut5GfU8CYKfYSOxe7QR2eQpXxkBUJOVZjhvedA3Dyy93UAchudhTmFelaIA+mUGm0PqfBbJ2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9UkMWpn8RoSyZpzPormyoSQRWiX5ZQZ+JZiMXjJnfYY=;
 b=eMpX4qI/+7NOptH9KsAlF0Kljvm4SnZUjMF05PWNlBQ82NCPQdSest/Z8CPEQjjh5Kp4JEx8UnXWE2ORfl35SujOX3W5arcozNLcmmC8cpqMO6egr9msRf227lrLMTSk2+0BCfVOdOGcfFxmB3aY0TkgvOoKsbwXzaOdEGXr0o4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 21:12:59 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 21:12:59 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 09/27] xfs: get directory offset when removing directory name
Date:   Tue, 29 Nov 2022 14:12:24 -0700
Message-Id: <20221129211242.2689855-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129211242.2689855-1-allison.henderson@oracle.com>
References: <20221129211242.2689855-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0136.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4456:EE_
X-MS-Office365-Filtering-Correlation-Id: e0459160-7f0c-4249-ead3-08dad24e7e01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wC/Zw0OX3Ev7cvpvrDyGqpxxDd7AAQ4neGwwYI36oSAddpBadniLMi9gQ4ZFyOmYSXxxrsdwVGt3qEE/adjoHsD+/ktZJrwMCiKXdZSb/2KnkVQNeWR2XjLc2/hkmj6/Tkze4/DQ5ihQ4PKwInA5oSIhlNF8BwfZc7M7cmybkqQxQzisXu/gTUqyOosZSpIjPUgMkK6LGHt7o9kmHzIky61uu/3wrvYUTPz9QCcsgu4ldvS2tVu5GHcd53OcLjQyDnf1lTFfuKSIgT+pt5VdEkAig04LUgb2QAQjRZ13vFGTESsc0e2dTAaBCglD4x0iEHEPL4PSoJ1ca0dSumFjQtjKzqcDK3WDF5t58Xtooaj+gkycVwxxtJjYJAW0G7zQDm3xbE74Qdp75563JW3p61atgvCXugl8vYaIuo4RnM3P/3uorlBiuqC2/ht/a18poF3U4IeRIKfdgWZytbHJ3NakAmXe0U/rFbm4ZpLiO8bIQjVUHAqEmw8JMCJiKzxRM7eES49vI7mHuK4TVu0fOlojUI14BwThbeUMOgtSw9jGJBjVEc0uJ2INOBQ5zKNF/QDyt9kG5ibk0N45x+bWTt79BNdRzDGLemOZt5ie21EjkHwgPd3Jquv5VLiXtGSl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(396003)(366004)(39860400002)(451199015)(8676002)(2906002)(36756003)(86362001)(66556008)(5660300002)(41300700001)(8936002)(6506007)(66476007)(6666004)(83380400001)(6512007)(26005)(1076003)(9686003)(186003)(2616005)(316002)(6916009)(66946007)(6486002)(38100700002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i1vQirhP/dBhBmdjA0MxbnvEU7Yfk+zahNb0d6JsftPkpLjnIJqOpVnZjD8W?=
 =?us-ascii?Q?4y6nr8cD95D73mxTk6xeB4GJaXoBeQBl1nZLGrDzrN3NERS+4v0c1mLe33Iw?=
 =?us-ascii?Q?2qZKmg/tVC5neGZxnzPH3ao7FWa9VLt78Ratv7M6Kse4qUGwTTe3TXNiN3ag?=
 =?us-ascii?Q?mMeFaL3clhrz5tgiXwgPvc5tHtLQfMtHvTLag4cSTFmd5wnfIbnM9AhVUYnF?=
 =?us-ascii?Q?0+goEic0NQvjxnc+754QW31BXAidTeSiWC52cAncg7LXWJ6dTPjf08Xqxvle?=
 =?us-ascii?Q?vpu6U6vFHzoDYgYOAIW7TlgEaHW5OU6HBlVi2LTsRq2pLMKgS3ocHK9BPSYw?=
 =?us-ascii?Q?ePUCj6jfHTRWP5+hFifz5H8skZ2/TmB78RYeBwf2mo9k3myBE9z/2ETP8TcV?=
 =?us-ascii?Q?gmnoA9CpGxbYwhfHA7NS4aSeB5JavaKhCHEtxDwnh1wX76QrK5fh3gh99R5D?=
 =?us-ascii?Q?nyb70uDfGxmRCD2FEayaySVmHEbFJFcKF/Bt5GRUoX1503XBWT5X8Ei9oufx?=
 =?us-ascii?Q?Fcg6oL1xcqzDS/r3B3NNOqdta1lvHEaWH3HVykbe7L01yUyzU+FspLJ1mD1w?=
 =?us-ascii?Q?QrP4bh72u761oJ/0T5We2mQJDV+1rwX0O7hYiJieaWrDSZb/sCt8lu31DSFV?=
 =?us-ascii?Q?xrkeM069NFVl1SkRpNQh1FTJegKPmibR9fsE6CVsPOd6R7GiWFtz0uTV1Vfk?=
 =?us-ascii?Q?BtZptPuTzHzpayyGthQS8RGarSR/7Odiwab/RLxLxg18XfkBcCH6/d69KP1e?=
 =?us-ascii?Q?mpnbvT5DqB7tYJhGzCgriSGFMpBC6z6Tkt6XN9zEm5i3D7RWXIyRjNFxZTyZ?=
 =?us-ascii?Q?FTWuSosJjU037o1QAQ/+z+GaBXV+hTxs28RPIyQ4PF11aIHJbiPy0U1CnejI?=
 =?us-ascii?Q?8UPgy49YffYSfZDNt+DaCkpIm4SPQ9/bPzRMPmKUhd0dT5jl3xYU8wPwFc1Q?=
 =?us-ascii?Q?sXOHUPsHmpjDK4gRLEe8bsbmNE4VdMQ8pNsAiRgK9lcilgS6xvibA8g3OIoC?=
 =?us-ascii?Q?Z+d6yZJIYJ5BQ6pxO+CYGGAgmqoZaedDjKdxbMAUn8ZZozOYNJ0IUHB4YvPL?=
 =?us-ascii?Q?4cJWWJXZ+KJfqe+F/2qmLiqxZf+Xm+j2yYch61JKyBqkHrUsqpTUn5cfIlKs?=
 =?us-ascii?Q?pwT5X2uEncv008A15QVvDQy43eABTibIfAj3Lp1tuAmIV9tdg0ofs4Injo65?=
 =?us-ascii?Q?WE024rx+u5HDS7HzyrEpz6veUcJOGHMpZORcwZ3lgvlauxdrRUuobfdFg2ms?=
 =?us-ascii?Q?Ai4hoLUwsSAg+C6OqdSKSlDeVLfCBhXpB8n+R/67NgKv6Z9GeSk9v9iEY8ei?=
 =?us-ascii?Q?S1GAQsIbp9vxFO9reOVPKxylp7WnGloTG29USZbjSfMvHW0TBVdLy7KxaEOG?=
 =?us-ascii?Q?OZJE2hh7PQTrYnCevkgKb6KFShdzhdHjbsd+c4wD/e0YxPAoJGL1aBiELwIL?=
 =?us-ascii?Q?3a8yzQw+I4zICa2WBDFjFwr/y4BJQeKwN+RYu1RJjU5bTlIxsJ0/nHLWwS4Z?=
 =?us-ascii?Q?1CtskhuknrerY2R9Dq+wAC08xH0LOQbv1tmNOjEvAYs9dn232gW/kxlaYXjM?=
 =?us-ascii?Q?E8ModacSaetsbtlEltlbpbGSO3V/CCo8g+j3xLKRmhfBXHrGhEjNw4EngLcu?=
 =?us-ascii?Q?Qg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: tfTXPIna35WDmCJv/gyZjbWHE84Z0szznhTu8AAgScOFpqzoXMeJdOwPme4RiXZ0Q5+SwDaVfQKTekfJ92/gIiF7LmUU+NWtbp+P0tQxfFvN+hwcaMTfnyBzDS+RpNK8qFI8wGA7Y121DXY4vaKhpm5p+svFYzS+lUQ+YBJqKbOBX4pnlzeDVMFmirtxUT3upho5T+7O8BY4mxDxN8Ys2cSRgwBxIHd4UoQf5jAeB7sLUIU2OlVmvGKL/4W409n8M7lhsUAAvk4GByQj6Uv6+y8FKwv9+IfXm+7L87xtQZj7XWUUwEt/2flNkduw4Zb73Fatavo4kGOQK4irsgZcdwLU2yedKImRz58f3OwX2RYqPkBZFc6xxGnHrzGU2jN0iq/56NUxHs+ciaYt81K1nQdiKYQpBUvrjNL6igvCMGiHPL8lzEvijM+iSWyPdHd21T83V7rixSEgU2BikQoKXzbklcOQdRFdEjnt2ukCKvK4nSl2OL0oqMUeRP24suFTdMqCl20lUqGeGKlUfg9tujBCdv3XiaiIr4bgTQVhEHHDuV3daZ/ksRQhJBhvJ1rLmDMbgAErwhChcbEpN3r8ibX6fU/TwuyiSJ69M1IQQ3i7Qh1NZ+k7ZKPFMKaA4rrj7hqdjWjqvIv0szi9LD5yUKdmB34YVaIspEsiaLD+lAWjgm52FN7lHiiO8LS6dOBANteGFl/rRg+0MHrKySHeZtQlT35r/hO4K/FHBjZm++m9LjaVgA2W/JjfVo1B6LcK4DsA5krcyFFLUcaT4qzs9Q==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0459160-7f0c-4249-ead3-08dad24e7e01
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 21:12:59.1245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kQFdsVTysdExaB0N/Kc9SwBfvHhG92nyIvdS/34RhwTGN0CME+5lq77MFkIJUdBmbx2RkUaVChHWyGfugeRlH83faT1iKb0+33qSsJOy4YI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_12,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211290125
X-Proofpoint-ORIG-GUID: 4aIGoKtjkSVfXTaWELtEkTBcyn4Ascad
X-Proofpoint-GUID: 4aIGoKtjkSVfXTaWELtEkTBcyn4Ascad
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Return the directory offset information when removing an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_remove.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2.c       | 6 +++++-
 fs/xfs/libxfs/xfs_dir2.h       | 3 ++-
 fs/xfs/libxfs/xfs_dir2_block.c | 4 ++--
 fs/xfs/libxfs/xfs_dir2_leaf.c  | 5 +++--
 fs/xfs/libxfs/xfs_dir2_node.c  | 5 +++--
 fs/xfs/libxfs/xfs_dir2_sf.c    | 2 ++
 fs/xfs/xfs_inode.c             | 4 ++--
 7 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 69a6561c22cc..891c1f701f53 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -436,7 +436,8 @@ xfs_dir_removename(
 	struct xfs_inode	*dp,
 	struct xfs_name		*name,
 	xfs_ino_t		ino,
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -481,6 +482,9 @@ xfs_dir_removename(
 	else
 		rval = xfs_dir2_node_removename(args);
 out_free:
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index d96954478696..0c2d7c0af78f 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -46,7 +46,8 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *ci_name);
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot,
+				xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
 				xfs_extlen_t tot);
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 70aeab9d2a12..d36f3f1491da 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -810,9 +810,9 @@ xfs_dir2_block_removename(
 	/*
 	 * Point to the data entry using the leaf entry.
 	 */
+	args->offset = be32_to_cpu(blp[ent].address);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-			xfs_dir2_dataptr_to_off(args->geo,
-						be32_to_cpu(blp[ent].address)));
+			xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	/*
 	 * Mark the data entry's space free.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 9ab520b66547..b4a066259d97 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1386,9 +1386,10 @@ xfs_dir2_leaf_removename(
 	 * Point to the leaf entry, use that to point to the data entry.
 	 */
 	lep = &leafhdr.ents[index];
-	db = xfs_dir2_dataptr_to_db(geo, be32_to_cpu(lep->address));
+	args->offset = be32_to_cpu(lep->address);
+	db = xfs_dir2_dataptr_to_db(args->geo, args->offset);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-		xfs_dir2_dataptr_to_off(geo, be32_to_cpu(lep->address)));
+		xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	needscan = needlog = 0;
 	oldbest = be16_to_cpu(bf[0].length);
 	ltp = xfs_dir2_leaf_tail_p(geo, leaf);
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 5a9513c036b8..39cbdeafa0f6 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1296,9 +1296,10 @@ xfs_dir2_leafn_remove(
 	/*
 	 * Extract the data block and offset from the entry.
 	 */
-	db = xfs_dir2_dataptr_to_db(geo, be32_to_cpu(lep->address));
+	args->offset = be32_to_cpu(lep->address);
+	db = xfs_dir2_dataptr_to_db(args->geo, args->offset);
 	ASSERT(dblk->blkno == db);
-	off = xfs_dir2_dataptr_to_off(geo, be32_to_cpu(lep->address));
+	off = xfs_dir2_dataptr_to_off(args->geo, args->offset);
 	ASSERT(dblk->index == off);
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 44bc4ba3da8a..b49578a547b3 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -969,6 +969,8 @@ xfs_dir2_sf_removename(
 								XFS_CMP_EXACT) {
 			ASSERT(xfs_dir2_sf_get_ino(mp, sfp, sfep) ==
 			       args->inumber);
+			args->offset = xfs_dir2_byte_to_dataptr(
+						xfs_dir2_sf_get_offset(sfep));
 			break;
 		}
 	}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ce7880e560d6..580eca532290 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2506,7 +2506,7 @@ xfs_remove(
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks);
+	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, NULL);
 	if (error) {
 		ASSERT(error != -ENOENT);
 		goto out_trans_cancel;
@@ -3095,7 +3095,7 @@ xfs_rename(
 					spaceres);
 	else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
-					   spaceres);
+					   spaceres, NULL);
 
 	if (error)
 		goto out_trans_cancel;
-- 
2.25.1

