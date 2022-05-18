Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C81CC4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 00:12:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbiERAMr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 20:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232323AbiERAMn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 20:12:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741E849CA1
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 17:12:41 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKSZdi023116
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=zo4h1a8Dmi3hrySNBjPGfgop+JYGOVWf3w8RAjoZryo=;
 b=XRyKtQKVF7FxhKPhNGFeINAeSBR6i5fVS6QK74KCmMlNpdpWuWOrLpiAJYzbj1AWbFH7
 Gtk1r3sevrbvo2v058+pJOIYxhlblRCtxQvnUc+ec9iszdt2gXM+ZPuEpz7flD7HIr8c
 0AgtnuEYdKX2AxuMUTM4GaJmvxFhv5qfdPq8CbXfnHzndAf6N/n/sg8pRLIih8Vl1pws
 2Zex2hUPfi/R2SYFAaGveW+fiNI5f8YFnybmoDVU/vChk64eHnaB5MKCJqUw03nfsLuy
 MrP6/LwqAsO2Lgn5vaq8Iy5cGdvV6Vo3wpZZUkJvNt/udZIR7i1l83U8CDhxCL1b+1Vz Ow== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g241s7sry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:40 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24I0A1O7021321
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:39 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v3nd6n-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DJEOOmw8l2t0u5P7fQxn3X71XtbhrArSP66IR5HaIWGMi4Z6OO6n/v00FsKEoNr39vAEdgy+/5C2vEldRCK7sAXVVagyfiRTlRabe2B26SzpqbmleybhYaeC+RJFX/xgoe1WHAkr6fSeIvdu3gwr76sm4w3EIfhHMEpVQcQIyNchLXJPXOXadItRW7COSj2y0SVB2HgC94yA5lCzfcIVpFCAcgn/ohKRiM3wWO0xANgeeLzyraF/MSoXc9XZrlw3DqBOgCReQtKzoj6dDG0GvKN9NWSl9jgSmPYtCEarZQ2AEkBZYv4/4oxXK7L8mUE5HSsQg8S5BQkLMqDKrNU4iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zo4h1a8Dmi3hrySNBjPGfgop+JYGOVWf3w8RAjoZryo=;
 b=fM9XrGup897ub/EwVwF4d+Fo3IJb4iBite0sEHRSh8hwN808shm4dF78gLPMeqFkWpBUDVTetxkiRIJsVvOLEzkeqhB8QA3OiF/UrzDnLXT1qVhx8r+8SQ1aP5pDKaVqrk/Su27nH/lBZ6C26AbNt/G2PDjCdACT4FcnebuoRtANQiaI+H5NQxzBZL4KFfI0Yyp9D7/cNrX3RSVD9WVtnyy48KaAsa3hwtULFKg/9PUQSqGyZV7OLJCTnH9OYDJsQjKy1YHz5C4gOb3NCLBiUGJwm1FCXceAKUTt3slipB1ZPHDSrvshJEMJmnCbfafRiW7GNS7i4bDFnDi8Br5Wog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zo4h1a8Dmi3hrySNBjPGfgop+JYGOVWf3w8RAjoZryo=;
 b=ybBCmdMVYeOR8Al6myATrOFJ85DVMTlT0nFJag6iw19E9mhlZnQpCZ0t4xxRggiWbRMwkSV6jldjrRFyeE8bSnfOg4FjltVIJkCcsJ7L2rFYCFdvjiFmh6+jUd6A/VDw7XWnkyJb5v6Xyda3HUnmVFmutn7t1I3qXhpSlIYm5yM=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CY4PR10MB1528.namprd10.prod.outlook.com (2603:10b6:903:2a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 00:12:34 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 00:12:34 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 02/18] xfsprogs: hide log iovec alignment constraints
Date:   Tue, 17 May 2022 17:12:11 -0700
Message-Id: <20220518001227.1779324-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220518001227.1779324-1-allison.henderson@oracle.com>
References: <20220518001227.1779324-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0028.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::17) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fee183c7-ea3e-4484-3b82-08da38631bd3
X-MS-TrafficTypeDiagnostic: CY4PR10MB1528:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1528A57A1A77F964B38CA72295D19@CY4PR10MB1528.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tHmIRlF3IWuZI/CNxIyj4ZauGRMjFEooiaPajordkiq4iUcr8q4dfys/vMw5i+axwwUZuN4B86g2xLs107gcc1UFl6sF3oOspJIeE5CmTjubmUURjFf09spKDFMVKf22XaIv9zCsuTzZKbyXNrKnlYgppqZ5F5Bb00L2u9orSr2zDOOMohh+vV5FB6fMkuvCZyYOsID1nYdkEPErU71Nyv4DOUi8gqd6lB4E5j30GJ8xkolM3VUFju6nO9akdR/D5/uBItBhizZfXCndywEnAAXiYhIZCWlqfmid8/eH8Z3kbw1Gh+TmbODij1EI1DEMXAC9xA+B+Xho8utsGvwH/fnG5vIvwK9NBEeopmU5m4T/xdLf/Oz0vPomIhfH8UE/jou923scUgPqrFbNwE4WmjOn/VLn2lhTEjnqXi3e+8j8yg4DOfn1Sy3pWaaVBqBsxa7Xc7Tpt0txAuunFZkskXy5//GBzDeAlsgSUsess2h8NK2ZFCEQHM01mt5rodDXifD5d0vbZwfumGmGuIP8EOfee5F7geJuracQW2PC0Blz3UX1HGCMMV1wTvIK6NQkbCWikLdusiE3mmf4NYpMmhlLZcyD3JTS2C06wbdWk0lYHWjmWtfies9UXFVjaQQzxex5jGUJSa4B2iX/6whYUYkYfiqTxy27swCd63OyL8rFseMi6GSm+lVNIFGV5tWadZEiVu+346/v04CQqJpSCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(508600001)(38350700002)(38100700002)(6506007)(26005)(6666004)(6916009)(66946007)(44832011)(2616005)(2906002)(5660300002)(52116002)(316002)(66556008)(8676002)(66476007)(6512007)(6486002)(186003)(86362001)(1076003)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wOm5XP0i/jwaU00puwUS4Vuv6Sz5/P9dWetfmkq6m01bb48A6ZrvD0qU1UIF?=
 =?us-ascii?Q?rMNAn7da5IfXn2gO4qDSmv5UDdBDbIAsUxv2yfkwvHgZFjSMfMysTf1W94Hn?=
 =?us-ascii?Q?zER49ZqGT1us+Pc+3Hbnjnmj88gHpQ6lqakB0pDCEY9JoENlz8e68WyxOg15?=
 =?us-ascii?Q?bFdGctOoeCmyhlHauHv0WfTkw8EHqz7NoIldeh8Tamdv9J9zTzbevpi0o1hf?=
 =?us-ascii?Q?LXXOeLAqZZSOugzVhHMIe9bDL6kNHUaFDr7qQX94GvKu7BYIdOuVhY6Yf89l?=
 =?us-ascii?Q?xCNN0wlOA+8t34MCagAVxKlH9WWrm0iO6xfXiRXLTgWHG2+mrUEoe9lCXW9e?=
 =?us-ascii?Q?ruRa5LPwfxD7REm/Q0snkF2gjUmjYuYVQ/of8IHJnh6Waw6EeqCjZ0DSXlQF?=
 =?us-ascii?Q?NQWMf4DmtkasTPndSS3zf/50v2/dN1aoR/qIBmM4C+po4Irhogcs3gvhGzcd?=
 =?us-ascii?Q?PuapCa7ej1SEzyAaECUryYyc0DZ4aqqgHEVX7y61SgwgsQNaAG7C1N8kX9iB?=
 =?us-ascii?Q?U4CWcvfrQWFytS5WsCkXepysJAj+RluwUEp1tOYspNkH4ZaSTt4o+iSrwyZf?=
 =?us-ascii?Q?i/ZOaQ5jPfRUdnP4g2BH/4l1Wg4S2DcWCYjIq55BzWUG3lbnYvnP6Kl6cigd?=
 =?us-ascii?Q?+srsCedhPQwGy7nNX4xWTvOzRT3XUJ4iqWfSXFBLdjgVjwsMdq9v9GDJB1Mf?=
 =?us-ascii?Q?/CRa2NNmFc+eII1KJv07Z+QzhjzfoTgXNCqeyh1+WNbJZXBBhx2y4WQlGTp7?=
 =?us-ascii?Q?Hks0b7QmyuJJLEIfSKdFFjbPvavf9nz2Bzgiv32Mx/shUgxxq3fPfkw6HmW4?=
 =?us-ascii?Q?B/YAcv8V+5SxQqKo2zJjn4Ov6YmXtseNPPx4MDsIRzXxdiEwlkgU2bXwZjNn?=
 =?us-ascii?Q?AokgJH0/Imu/mfQxdFcfLeBT3RNbM2gBitsb6QZVrh0eQ3FXPOcHrZ3+7rmz?=
 =?us-ascii?Q?vLj4hoWgzZC1ihFp+6RuGH90EpQMMfvrxCt2X9umriy7Vj24sjMuIM3+6N45?=
 =?us-ascii?Q?MAa92dd1SZJCbWKQC7eHbQ1IYKcbSxs6RW6avelwdL2CeVs1ltCftvm5DnuV?=
 =?us-ascii?Q?VEGNTNZ5moWBxBK1yarNYhXARrBnmv609SMvC4tJlHhjKjC/dpIlsUIEZV53?=
 =?us-ascii?Q?YGx8bj3i5tNpC8GtNvuPUBAMFCMvG6uoXUnVmv8PxTe/0SoSZc/JROWsF8UV?=
 =?us-ascii?Q?0+rbjodDiEM9ItAbY7j+tm5lI0N6I3jcjRwx2B2Hxu703Gkpiq8o1+ji7shp?=
 =?us-ascii?Q?lXWO2gd+wO/IDdoDz/+3pZY9CM3o76a0QIvytzuAwFHDCVU9iyhANhSOCsL9?=
 =?us-ascii?Q?N4bFvsue/SyU2i4i/xh1sKknOfLDgCQKxnJmzHoqN6sc22TLafBfxPhAg0fO?=
 =?us-ascii?Q?3R037GVR0Zg551Vk3ZiXhVRQN9o2UglJpT9ETSKPHdiJ0eSwiQiAkPpJLqwI?=
 =?us-ascii?Q?kWzow92VruUj/iyeLCjcWhySqIjB9I/Bjh745Za+o4vlWbLcwJt7uw7Kzwe1?=
 =?us-ascii?Q?3gb5aQt/6yyYsvUWrYxKrNx1Os+GYHJzyQnhZAySsoKhyLuWNdv9g1OpIutN?=
 =?us-ascii?Q?/bmBV/94+I8N0fa75QnkWqH94uVhRZ90UglRkSgSEc04NPXG8LImKLVtgPLE?=
 =?us-ascii?Q?zdqvxRTzlFgmgft5q+O/EsPIebSh2AE8XSmZljeOF85L2xt4qGXUG3lXEaiw?=
 =?us-ascii?Q?dRLZQbMmfFZwvwJ7l+/TPBndguYwtwC49JNWMfeeO8xrh7EFL+aqxP8lWOlf?=
 =?us-ascii?Q?4wsmIloRY2ajwnzbPSZ+m2bdMsdEWcI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fee183c7-ea3e-4484-3b82-08da38631bd3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 00:12:34.8123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A0nUcGsXcx+eZhE0zwfxFMXmEPRxh5dHGMOcT4gVbvVTyCNYa/QAHsu14VLztlcxbpdAtnFQFrx2UKYeNpXMe7H9U4cKC56OAzMWFPJDw6E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1528
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170143
X-Proofpoint-GUID: L5HkNOUwX8_AwSxsVBCGGj4y3OXEhWPJ
X-Proofpoint-ORIG-GUID: L5HkNOUwX8_AwSxsVBCGGj4y3OXEhWPJ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: b2c28035cea290edbcec697504e5b7a4b1e023e7

Callers currently have to round out the size of buffers to match the
aligment constraints of log iovecs and xlog_write(). They should not
need to know this detail, so introduce a new function to calculate
the iovec length (for use in ->iop_size implementations). Also
modify xlog_finish_iovec() to round up the length to the correct
alignment so the callers don't need to do this, either.

Convert the only user - inode forks - of this alignment rounding to
use the new interface.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_inode_fork.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index a2af6d71948e..a1b2b9029195 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -34,7 +34,7 @@ xfs_init_local_fork(
 	int64_t			size)
 {
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
-	int			mem_size = size, real_size = 0;
+	int			mem_size = size;
 	bool			zero_terminate;
 
 	/*
@@ -48,13 +48,7 @@ xfs_init_local_fork(
 		mem_size++;
 
 	if (size) {
-		/*
-		 * As we round up the allocation here, we need to ensure the
-		 * bytes we don't copy data into are zeroed because the log
-		 * vectors still copy them into the journal.
-		 */
-		real_size = roundup(mem_size, 4);
-		ifp->if_u1.if_data = kmem_zalloc(real_size, KM_NOFS);
+		ifp->if_u1.if_data = kmem_alloc(mem_size, KM_NOFS);
 		memcpy(ifp->if_u1.if_data, data, size);
 		if (zero_terminate)
 			ifp->if_u1.if_data[size] = '\0';
@@ -500,14 +494,8 @@ xfs_idata_realloc(
 		return;
 	}
 
-	/*
-	 * For inline data, the underlying buffer must be a multiple of 4 bytes
-	 * in size so that it can be logged and stay on word boundaries.
-	 * We enforce that here, and use __GFP_ZERO to ensure that size
-	 * extensions always zero the unused roundup area.
-	 */
-	ifp->if_u1.if_data = krealloc(ifp->if_u1.if_data, roundup(new_size, 4),
-				      GFP_NOFS | __GFP_NOFAIL | __GFP_ZERO);
+	ifp->if_u1.if_data = krealloc(ifp->if_u1.if_data, new_size,
+				      GFP_NOFS | __GFP_NOFAIL);
 	ifp->if_bytes = new_size;
 }
 
-- 
2.25.1

