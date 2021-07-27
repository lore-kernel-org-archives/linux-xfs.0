Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E13BFC4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:20:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB19061108
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:20:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235656AbhG0GT7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:19:59 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:25844 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235502AbhG0GTu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:19:50 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6G22C022403
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=OGa6uxGlhJRDPVN+aqgMjwlAk1ecAPHTmxHJLss/soE=;
 b=AF6GRoRcp+QMJYiqvIVzqXEmH+XP9GEQH3H6cBmEPo4kyp+H1S0f9r+j6SXxy0ifDlj2
 yvL8IF+jxrnlHaCt11OUP8D7//m+TuyP5vPeEEIb90tY2VckEaXxptix4djnntF8TbBQ
 8LPdnxwfqnh2fOyzjhIpji6xvq53Kudhl4jkWv8Nac5VTRejcMN92q7UskGPbMKbUPHO
 /rzKon6DBimuYsKKpYsFFHN3Utp0O3G3SR0PHB64Yo0xllvNm0txvb3pspDZzYq/h3mp
 5bfHvUUyn6JQmEGn44KSBHNsBQSj4w/ixJg+LMbHtQC88mzZGzLcv+qNUUrG+x4VjEKJ jQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=OGa6uxGlhJRDPVN+aqgMjwlAk1ecAPHTmxHJLss/soE=;
 b=p3oMMjow6qFTw6NCPj/ieDfaGwWZ//fDTDsDx3uH/qhZ8bAuzZB5CrEuiihcF8/Eer95
 EyKcDCUEzyhed4oRzGN2kuQDJDHB1ASjTa+dfAAIKuhgvrxnuSSNbRfyEDMch3rYxkky
 Ed+dHX1zYFD1WY4PNKhGXDCgLngYe7vzzanXYS9kOEXm6eEg9xteF6zSSzL9a1aoXR09
 VWiMyBdYgNK+jR3NEQjjlDxGXN3+vRByYWdCY9G4MhlPdQW8F2NWPiZDS/vqnuAhVjZE
 WSfkzCBAxDqzsWS6borOwWzrJz5us5S86SS5zK7mC04Cqi7i/2sWEGj6vVMTGnbhepvR fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a23588umw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6EiaF065026
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:49 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by userp3020.oracle.com with ESMTP id 3a234uvnq3-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aVkt+njBNMVGCW5KycbXP5huHFVwN14iaZq7ZUqlqxsu5qXxpsezqsozW/Q3bn50TNAz6eCfDsoIPnGJHTiwuTNA/4NHOk90cio0YIx3/vFf6bs7a5HGujwALlFfJeilQTemP/ATU5y1mrUhEt1Dcy4lCGdCxDDN9B3GfYSgXAIxLfQHOGU7p40ApRGcOLjMrI9e0smHKJCpgPYH7ylHXjI2xvOvvsbBvuHex+Uzl1DFSe8poa32JrKMzl8wYGaVsSFtdE/8ABxZjKzGWD4QxYZUkF+X40m9HSeF3hjY640dQhLo57Xv9AWWzOZ71NX43uQOaLgBmA0Swg0AYsOxug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OGa6uxGlhJRDPVN+aqgMjwlAk1ecAPHTmxHJLss/soE=;
 b=LrHDuZ+dtJ8EaAfw+ZuT2KCwDY+fCwzfeJ9E0WoEry6zkyirk3kf18aD9Vghd6e849ssDU4RuvkyhEt1sUKxQ1+JD6MfFB4RHngDTZBXpCPaVB9w3aLfSLGN2nu/4Wcy75foFZqVJi7/Dth9kFN2mE4reKIfbHoK7TFiqOnbZPwRosynlbK9Pd4wR7sv02YD0hDylHE2bz6CUorvvfaVUFik54qCjOH6S2IS3rn8Y1CLtuL/Oyxh2Cy3m0s6tnKLL+JFVcrR7C+cFmjGUkFiHkVbiNLylSjoGNK3zZB9c3A4eY582u/+jAW0GLBl9TubtUOWQzKT8u842wdudeKODA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OGa6uxGlhJRDPVN+aqgMjwlAk1ecAPHTmxHJLss/soE=;
 b=QVzXDl9069+PcE7OwWG3LgXFjutn2Z6Cvf8oj+GDrGD/G8O4iCzZlyxKRogYADHCvDu1ojiTNUB8HwwsAKN/Xh/mpicGympKp667n9hLYCouokva57b42mrqenqeExa4QRZKcuv+gMTkEDyDK2ikODAVdJpybOTt6FGh26vy4jY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3669.namprd10.prod.outlook.com (2603:10b6:a03:119::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Tue, 27 Jul
 2021 06:19:43 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:19:43 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 11/27] xfsprogs: Remove xfs_attr_rmtval_set
Date:   Mon, 26 Jul 2021 23:18:48 -0700
Message-Id: <20210727061904.11084-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727061904.11084-1-allison.henderson@oracle.com>
References: <20210727061904.11084-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:332::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0074.namprd05.prod.outlook.com (2603:10b6:a03:332::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:19:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 897e72e8-65a4-4c32-e3cc-08d950c68610
X-MS-TrafficTypeDiagnostic: BYAPR10MB3669:
X-Microsoft-Antispam-PRVS: <BYAPR10MB366957DF70EF5C04ACE6900495E99@BYAPR10MB3669.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5G8R5uMovoE+hVwg7xegOv0nGBfTqaev6Pr1HJotuZrMewbr+Hh6DD6Uh/XFx5tmf2eYOBKX8bWthX20Rcwd8YL5W9YYQYlXIhbQeBwuiqInCza6YDXNPhnbmXRdkPZfxkSoyBKRBLX4J53LIpu/8ybnOT02yWWvSBL9YEyBkNZnYvGJe2y2sl4mSTBsUtlH1cm0T9QEqq8wY2XA1fWC8qBubs5QUAxPCxw0mFV5thITIO3ib2IuMO3PlHJUYg/inwNZDArRPxsxw1tcWCF0YPMW7HXwDGVf1E+uIaW++L/9xL39odxmpPIU4HQhl/lZg4gyZaVHtPu7UWuD5bwEWugDeSbdkjeXTxJDWDlZsWAs4f5iSQbItKtZj3SKHVq6Qqktv1KCvg7zqecyp11Ak+8kmQ8y6at2k1P4FeZfFEZovP7rD5CF/itbDu82s0jDQE4jnMnqgiqTksuT0WLJA49H+szdHoYzjNsJbthhJggyAD8hB32gU973iSoYSCt/Jhhhn0zWda9Ff3AUdogXtQHEz9U6/Kg5AEH+vQz3Ew8WKqkK0ZPuxEUYhu1uQlOJw1Zg/fILPv5ZOmNlLMfAdLO365uGY/bfMVmXsHlVHf9P9rKoCwRsu7aNehA4gusqhY86cU4SiauV2ugLj7nwxbFVYZNzBPyTtsMiwAYVlnNfZJHFRrrnIMZTRTJLs7CtlNxtx+aaHacZsV+ZzgwLGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(136003)(39860400002)(366004)(44832011)(478600001)(38100700002)(38350700002)(52116002)(2906002)(6486002)(186003)(6512007)(26005)(1076003)(8936002)(8676002)(83380400001)(6506007)(5660300002)(36756003)(6916009)(86362001)(956004)(2616005)(316002)(66556008)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hkob5EgNrtqfUb1c6jRjSebyOSI42391qHncv3+4+EcuaeIbJiJt1safgBN4?=
 =?us-ascii?Q?Soa37/it0FBwTrCD80JNhGQphVK7uWHK7/r67+VijIeEuJFf94PPhjqsMS+n?=
 =?us-ascii?Q?F6mHx7oV7DVDL0h/AgKyRCVOz9N1uDYo6OPWs9QS1yQFP/jeTNmkUGqTiA1t?=
 =?us-ascii?Q?pWBb+qjhBc+aymMfMhfFh5jdq3eNjbKrVluEZUawkDRHoLvPxASAD0Cvx81Y?=
 =?us-ascii?Q?PnyzsYfXUZJ/1oai49swSsvDzI+zNi1hPwErmfvH5BnalHHNOOZYsnuIN0NL?=
 =?us-ascii?Q?prsxux14mhqCgawxtzHNLjJM8AXXtpkQCmOuXKQJJokaHtPW0SQc0x/79MTb?=
 =?us-ascii?Q?1NarBNwgSPr8qDYCEMxRpuNr/1PytitWbZZkM7RhCA637+Y6+EzCZ13X+W86?=
 =?us-ascii?Q?dYUDJhPsMpLWc00dZb6KxezACGAPUL1mTfVtjd8lMc2oChD5pYgKGCbDC5q3?=
 =?us-ascii?Q?PkTMD4RImO0rg68ikQ+3uN6awAqxahPaALiCWY2ZICItG6XNy+TkoyVNvnQO?=
 =?us-ascii?Q?nXoHLssp7jgxhLhCVrAIylEGI7jvHQtI/8dre17bTTGmFH7+mzCWhPgzkLFt?=
 =?us-ascii?Q?P5fPpGiGa+ufxeW0xZPxVIdSLdX1DIkJ+ZfMtjU33N4PWcGvxHBP0RNSE3ec?=
 =?us-ascii?Q?1E3x8ViwXpubEOU4lbGRrjABz6JUWTLamkK/jIayKH4czrh0xF91TH0eCDEJ?=
 =?us-ascii?Q?S/GqV0ngs+OSHjAcC807dcCAViMq0EZ4e9CMPehRwdz1gVdLswL1i+wgurlf?=
 =?us-ascii?Q?S+gQWx8cHuNkdIprmUal2sC2xJoUTukXZQ6/MLONRHjHT7fnLJ3he3FyrS+h?=
 =?us-ascii?Q?W2e7zqA3Vmy3iFQyI9mWQk2PaV9u9NN00aSu3m43F9CrqmCzanJnBxvdaEwr?=
 =?us-ascii?Q?God3xNS9i6ezlNte92gST90Ob7SoO5NoQnUH/TJkuxcLrHsis31HHnhnx+Ko?=
 =?us-ascii?Q?1s55Z1X6wAwIjJ5oqGtQJ+RvtA11dL3U/lAGejWH1Es8psefthXRP/zqNJml?=
 =?us-ascii?Q?+wOa16FwDTgxlviJPU91c5z1n0uyHEwco0D/wGoMT95brIJwz++g+Ax1mK7D?=
 =?us-ascii?Q?hUJ5Iqz18rDSDQ/9nOVh6cd1AwM6dLVD7qdSFEv62TukWTVs6B4IfVOibrDk?=
 =?us-ascii?Q?KpPQJFsYjtK5QqPd8SbRKPZHyH3tvWfdjMB0rBc2a0wTAWpPa8YKQS8DE/U/?=
 =?us-ascii?Q?++cdmYUuSGp/Tceaj+pL6ZAtDh4bIxueBxkxXuUTrKznwKZYMmWEpOGLe3VM?=
 =?us-ascii?Q?uWXzIvLVqGvO7Ig5onql5W+RJkttTkvYC1CdcuD8KmHUw0ASYVb+V0gI/rho?=
 =?us-ascii?Q?5VcOLvJqpud8nhvfXtNQlND9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 897e72e8-65a4-4c32-e3cc-08d950c68610
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:19:43.4239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: scJSKO46rN2wPw+zLR2CgGCJczSawfRy52cBW9GMDkb7umboV55dONSZk0I+0J4WQHogF9sBnJ4nJMBoUzpsZfn2RhpICUaXe6gbXz4GJhg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3669
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270037
X-Proofpoint-GUID: 6wOPJWSO1w7VunoTfR_LQss5zdwRQ7MR
X-Proofpoint-ORIG-GUID: 6wOPJWSO1w7VunoTfR_LQss5zdwRQ7MR
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This function is no longer used, so it is safe to remove

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 libxfs/xfs_attr_remote.c | 66 ------------------------------------------------
 libxfs/xfs_attr_remote.h |  1 -
 2 files changed, 67 deletions(-)

diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 5a0699e..d474ad7 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -561,72 +561,6 @@ xfs_attr_rmtval_stale(
 }
 
 /*
- * Write the value associated with an attribute into the out-of-line buffer
- * that we have defined for it.
- */
-int
-xfs_attr_rmtval_set(
-	struct xfs_da_args	*args)
-{
-	struct xfs_inode	*dp = args->dp;
-	struct xfs_bmbt_irec	map;
-	xfs_dablk_t		lblkno;
-	int			blkcnt;
-	int			nmap;
-	int			error;
-
-	trace_xfs_attr_rmtval_set(args);
-
-	error = xfs_attr_rmt_find_hole(args);
-	if (error)
-		return error;
-
-	blkcnt = args->rmtblkcnt;
-	lblkno = (xfs_dablk_t)args->rmtblkno;
-	/*
-	 * Roll through the "value", allocating blocks on disk as required.
-	 */
-	while (blkcnt > 0) {
-		/*
-		 * Allocate a single extent, up to the size of the value.
-		 *
-		 * Note that we have to consider this a data allocation as we
-		 * write the remote attribute without logging the contents.
-		 * Hence we must ensure that we aren't using blocks that are on
-		 * the busy list so that we don't overwrite blocks which have
-		 * recently been freed but their transactions are not yet
-		 * committed to disk. If we overwrite the contents of a busy
-		 * extent and then crash then the block may not contain the
-		 * correct metadata after log recovery occurs.
-		 */
-		nmap = 1;
-		error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)lblkno,
-				  blkcnt, XFS_BMAPI_ATTRFORK, args->total, &map,
-				  &nmap);
-		if (error)
-			return error;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
-
-		ASSERT(nmap == 1);
-		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
-		       (map.br_startblock != HOLESTARTBLOCK));
-		lblkno += map.br_blockcount;
-		blkcnt -= map.br_blockcount;
-
-		/*
-		 * Start the next trans in the chain.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			return error;
-	}
-
-	return xfs_attr_rmtval_set_value(args);
-}
-
-/*
  * Find a hole for the attr and store it in the delayed attr context.  This
  * initializes the context to roll through allocating an attr extent for a
  * delayed attr operation
diff --git a/libxfs/xfs_attr_remote.h b/libxfs/xfs_attr_remote.h
index 8ad68d5..61b85b9 100644
--- a/libxfs/xfs_attr_remote.h
+++ b/libxfs/xfs_attr_remote.h
@@ -9,7 +9,6 @@
 int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
 
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
-int xfs_attr_rmtval_set(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
-- 
2.7.4

