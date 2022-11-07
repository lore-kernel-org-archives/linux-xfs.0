Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1540C43217
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 09:03:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbiKGJDD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 04:03:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbiKGJDC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 04:03:02 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E25E12AFA
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 01:03:01 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A77gl5O017547
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=45ArkmVQ5fgylHr1YnqCqKpINy3ZxnT1bq3Y1/bLqvM=;
 b=ZO71W8g4oKAv5X+9htv5NQUhQgzrnWl+FxAuiRF6wZrMckW0dTRh9r6FsrxJbq57+KUk
 fcvMI7suaISZwsXixPkjlGQ6fkrcyOi5SkN9OGG3UqmN3Z7G7u72UBu68m7zviBDTMPH
 KQfvVN5Fcbsoq0FdFyTvIcUPzsrlC9EauYecqu1t7tMQsGRMTHf/cdIkQy4m/3Fjcxfh
 VmH8ubWEjM9MTH3ssmQe8GYKoqquq/I8DXP2V2j1ICCKPofdk0KMX8fEWJr55Qm9oyMT
 htzWaMk4e8+5VRVoadtf6k4xts+Rshoon2YzADXng2wzDkk5zYHFNHIpGZtvU+J6sdvX 1w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngnuu33f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:00 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A77011u014538
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:02:59 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2040.outbound.protection.outlook.com [104.47.57.40])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpctatksy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:02:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FI1hCwIuZ8w2peWiWOdgKf/S3qTnkpIDzNV+wZDxziY7GogbJddo4RDcDTqmIxukCoA8Iw6C8bYtuSLyknYWaaxj0MQMlzJDdZsA3AijgC9OsDThxb19bC8+ax5mwtjcL9+Y8P/PDjuChoJ4/NJQ/lSzo7E+iNs9qKMbZsEg+uTkOIv+jH9pU7tNTGJOegBhlsMNUtF47mG4HMJ3AU0Hq44aQGNGKiR1oEWvkTE5X9H7+qqLpOj9l/d6kNZTAJJsYqGhLGOdZgbFzYQexTF1SC/lI6aHM8rF9Jw7GMF7VPGcT9slJ+gTwMP/SbqPhNuoc8Ag1znPDPk8qve9Orb2kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=45ArkmVQ5fgylHr1YnqCqKpINy3ZxnT1bq3Y1/bLqvM=;
 b=TY2qOg0/D9WFLtTVjCjjKEO1QXdlmKMXJEGkAAzYRuJjuoTnzjEG5gslcDn+b+eDr/FoBBjlMO4g9t0b6535Aodcl9EnFNRGLbQF6CMrfL9Fvn/jV+KE46gtlXWVQDwT8Y1fLxWxvoa6xwP5pdVe+U+3DfJ30zT5GoIRYSg9a2ggQtlCitLsoGwDPE20ZzzcSXMUV1H7fCpVQS5nqDdetRxKCfF52r9BXToF+hk0bOQrGxPU0n76qReU9E53/0CnfU/XhGAfmSw0WQcLCpm3vwELSi/O25TAuQCs8K5DNSmnpNRlJOgporE7CMfDvS0OYSywYlF5td40V8jpGFDblQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45ArkmVQ5fgylHr1YnqCqKpINy3ZxnT1bq3Y1/bLqvM=;
 b=XMUHH8D00dotsjxmTEqC993oTXQxDfZVdT3tqnoThUTlJ6tso2jWcvR1HU04H3AliI/i2IMf/OTPJ/DncV+RWHDV5e3LG7sg0Vav+IcEn+Bdb+5LhGjLpmIz34W2cVgvneJmEPCH/SSq9tjleEd1rWV49YynB5pRE3LG7rkERGw=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5848.namprd10.prod.outlook.com (2603:10b6:510:149::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Mon, 7 Nov
 2022 09:02:57 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 09:02:57 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 06/26] xfs: Expose init_xattrs in xfs_create_tmpfile
Date:   Mon,  7 Nov 2022 02:01:36 -0700
Message-Id: <20221107090156.299319-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107090156.299319-1-allison.henderson@oracle.com>
References: <20221107090156.299319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::18) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB5848:EE_
X-MS-Office365-Filtering-Correlation-Id: 577378d2-e659-4fd2-0a88-08dac09edd57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8VymHs9Xa1CwLas11GgCzyjaL0QDY7q5vXzZsE8OuVeX0Rd8C5SZSxvIuOXMWVuiugnQ0pelBzNVE4izisg2DewnQrpyzVdNTYxSrDhyScwvvb1SVlniSdvzQOUrcJUMvpybweMZPiehnKmFXCCv+wEm0WMcXAwlUnwUdeRxPk7b95gPn0EEbp9I14vzZ1ifUI/bEabf4JybMNBJgE1vHCkdCTjn+nhvtxHKg6DoTorwc7J9v8SoJqDRVXbFIm2yQ9sdRsFULbsDoSLdiyrlnqPHy505MSokLRG9rkkipm0krw978ONCIU6D0iYA++65OZ/2Kgic6UJJTOx+wXks1kDrE1PRr+J10VW4TdYA6PshPQf6MNbdSGQZvjo74g6laB7YWA7w3mVPC8CzRCSjQmIgukmXRjr7gutfCcSlQRri+Gc/5FIfC9R8DZr1vR2jZ6LTYKnRXHWklZTuQDcNh/WLenMLXk8ffOji4DGq73jVmkGThMzvSu2Nt1rdHEgma3y1dIziWkyq7lUTgZNPS2jphXIaNqUOqWoo5HgMlYTGnXYFCrleb9PI1xMJEWYYBBM61NDtxi4/i5ucAURQuIuM9HujLU/jmB9jRO7/b0wdipCXe7yUhR9aq3bd/34XzPd9wCXOmMVqXaKCm9k2QT9XOzaIdGPT1iFWZKN3v73w3AGkVoD02zIYsEUGWzy+PJfc2pOrsr/U549CAKZmPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(36756003)(8676002)(66946007)(6916009)(66556008)(66476007)(83380400001)(2906002)(6486002)(41300700001)(5660300002)(8936002)(478600001)(6512007)(2616005)(186003)(1076003)(26005)(316002)(38100700002)(6666004)(86362001)(9686003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GHZ2oDbV1cljbZOD7afJP2j/vowRpL6Yqf8mmCYTlgrMvqzHH0fOnRn7YcGB?=
 =?us-ascii?Q?BtsG2iJcFhjChi9UexkVG4EbLavxukEeMSy3ttxQav10iCZkXYaJ/sjdgnzG?=
 =?us-ascii?Q?jKcSYxdXzjYnqEAu9wWk5V1M2lMbo8SxAsPe1rmL+ecpynW4y70JOmnFPKeg?=
 =?us-ascii?Q?UZT2sWK85+kI0xlQAgGLoo8qzSv6wlzpAFhdJndTHA6Jgx13aBKPDgIo7Cpo?=
 =?us-ascii?Q?7jGMmd6XNmrnYHTo4X/vUdkz9Vp8bVf7g65nsXT8zef6ntvEtiRmqJhLd2ks?=
 =?us-ascii?Q?hf2BCVa+p5/s4avqpWL25SXZZ/yXty0sP3iJEP/K34TE/Gb7IQG56eIFK9pN?=
 =?us-ascii?Q?vWW6g/Fz//W/+/TRf+4EkTD1UFVIS21pSWJ8IgrT0Q9RTveyVoYTP889Mqm3?=
 =?us-ascii?Q?M8dYuX5C4p7c/5TuRpmh7lqPZHERobXNwMQ9ogXnSgBTCi961MGXGmff638f?=
 =?us-ascii?Q?vTNpGFyJyd3xBnY/EZSk3DYyb5c9KIrUApc0gqu1m+6ZjzJ2fmWJOkdGkzn2?=
 =?us-ascii?Q?uMw26HDvPD8Yvno/CNptttVZjDWSx22EGx+/kNU5rM2PGQAXga4PJdEx5w72?=
 =?us-ascii?Q?Q/cP2kjgHvSYkQcTO+3QKZ4kw6y8KT8Gdb1Rq+fO7J9/X7FtwJgviTShgQ76?=
 =?us-ascii?Q?YLFtm9d6l1XyZ5kom5KuO2ZxrIMWOxjCM0UJqpfthNiIE7TjK3VQSfuL6LDA?=
 =?us-ascii?Q?Fqr3NHx18JiWeOzZStm7ZUAnkrJEauezQZVK1Yj4QibIPk6JwWXaRbTpOaur?=
 =?us-ascii?Q?Vc1S6HVdp3R5pHxUOgXpyod1oJCr7JKbIL7SYSvmMHgLkRtm/Nwbd52YmM3w?=
 =?us-ascii?Q?3FnRPDbaERa/9Zupw/DsKut9A6+hprEH7vEvv3QH6Y0dFomAripvulz60PCM?=
 =?us-ascii?Q?rU8+mEYK0vzA7EFaTopGOU22i0Ps1BAjtSvhYCFZxSX8qB4LrZkwDNWV7fpv?=
 =?us-ascii?Q?6KiG6l2E/d2z8Ala8tlth5rEjieO5+33IF5Scx4rpjdkcwmdrcP7+68nYxZS?=
 =?us-ascii?Q?ZY/I5hzkTwCHGJdEySSd6oy20SFIlMJRkgYhdfQprfu6hWLn9TxAdgoTECOC?=
 =?us-ascii?Q?3HvDnDxn/sfyvmX8/flioiaSNmo65/bwRl0nltLRDGvX5y4LNMoasvp7xpSu?=
 =?us-ascii?Q?D0mhCKno7J54NnPEnnuUNCds4uC/Y+mhqYIJQI1OuL5TeMHKQrC+uVLEe15M?=
 =?us-ascii?Q?+td6m7FUigFv1LxTyvJlH49Lse0nlODLP8Mw7k/8t/vmJ6V7TjOrbOF/wC4U?=
 =?us-ascii?Q?O6ZDTsJw3ZjP60c/IkqBk/3jPcJ4+UEBp9mYT4sEfm0GxCBTqGGHC6KRNEBM?=
 =?us-ascii?Q?XAfzu959fCTHWBTqdpqHYkQFIwfwKlJOIycZWl2VniMH8HdESylvG3M1t+jr?=
 =?us-ascii?Q?aAX7qn5g7nw412r1QUJ8GZEgPPMbfNpcJyYPk/EaJpdTVkyP9TtTOU5osf2T?=
 =?us-ascii?Q?DmJXYrJZLiahyEDaKldHd2ptg1qM9woLaqdfPfUVczxsn52ZTETdyTdJGhIj?=
 =?us-ascii?Q?npb02yXNxoaFrkIppb4TWG8Ivxi4RzH1dRJnHsYbGiCcALfTC/1ZLTWmLsAS?=
 =?us-ascii?Q?HJP/SWCrvsVCt677ylSrVgDIsy9CHlo65fhii0uBFTjaVgoVRjuzve9IpjT0?=
 =?us-ascii?Q?qA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 577378d2-e659-4fd2-0a88-08dac09edd57
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 09:02:57.7650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aQNnzHXCNf5QhVkD6EI2f77L1stIYjSMD0b61T3LDXSqA+P9Lb6/pEbvryXzCSG3ZDgLTa+CuwMDN5u8JE/XwCaK8M/rlfspDCQaa7vdT5I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5848
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070076
X-Proofpoint-GUID: MAsMf_yD_kuYXu4yuhGBcBWgJbN0xzNt
X-Proofpoint-ORIG-GUID: MAsMf_yD_kuYXu4yuhGBcBWgJbN0xzNt
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Tmp files are used as part of rename operations and will need attr forks
initialized for parent pointers.  Expose the init_xattrs parameter to
the calling function to initialize the fork.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c | 5 +++--
 fs/xfs/xfs_inode.h | 2 +-
 fs/xfs/xfs_iops.c  | 3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7c91a4507a65..7eb65bccd8e4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1108,6 +1108,7 @@ xfs_create_tmpfile(
 	struct user_namespace	*mnt_userns,
 	struct xfs_inode	*dp,
 	umode_t			mode,
+	bool			init_xattrs,
 	struct xfs_inode	**ipp)
 {
 	struct xfs_mount	*mp = dp->i_mount;
@@ -1148,7 +1149,7 @@ xfs_create_tmpfile(
 	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
 	if (!error)
 		error = xfs_init_new_inode(mnt_userns, tp, dp, ino, mode,
-				0, 0, prid, false, &ip);
+				0, 0, prid, init_xattrs, &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -2748,7 +2749,7 @@ xfs_rename_alloc_whiteout(
 	int			error;
 
 	error = xfs_create_tmpfile(mnt_userns, dp, S_IFCHR | WHITEOUT_MODE,
-				   &tmpfile);
+				   false, &tmpfile);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 2eaed98af814..5735de32beeb 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -478,7 +478,7 @@ int		xfs_create(struct user_namespace *mnt_userns,
 			   umode_t mode, dev_t rdev, bool need_xattr,
 			   struct xfs_inode **ipp);
 int		xfs_create_tmpfile(struct user_namespace *mnt_userns,
-			   struct xfs_inode *dp, umode_t mode,
+			   struct xfs_inode *dp, umode_t mode, bool init_xattrs,
 			   struct xfs_inode **ipp);
 int		xfs_remove(struct xfs_inode *dp, struct xfs_name *name,
 			   struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 2e10e1c66ad6..10a5e85f2a70 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -200,7 +200,8 @@ xfs_generic_create(
 				xfs_create_need_xattr(dir, default_acl, acl),
 				&ip);
 	} else {
-		error = xfs_create_tmpfile(mnt_userns, XFS_I(dir), mode, &ip);
+		error = xfs_create_tmpfile(mnt_userns, XFS_I(dir), mode, false,
+					   &ip);
 	}
 	if (unlikely(error))
 		goto out_free_acl;
-- 
2.25.1

