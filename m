Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D91DCC7619A
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 03:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbjDKDgp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Apr 2023 23:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjDKDgo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2023 23:36:44 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF75EB
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 20:36:42 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33AJikC2001612;
        Tue, 11 Apr 2023 03:36:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=6DfL7kz/4wgXXfWg8K0W+ffz971oCAL2vXI0knJqu1c=;
 b=ISM4wK170MYxDAPtA1B4IjmAO8mL+U91WWSA3h7epFuNVOxBBDyEs/Up5sTUjSRXpUFQ
 6ye8iAgm/xCA9FE33Ksz+VM98vlTd4bvJrW0pBxNJdefTWRi53VLgu/UhEgSvzQF5py3
 EjzPqfSjjIqTh0i2iKRN8+dkxWG6WrGnKRcysnrSAO7Tuh1qQJG4tjpsilDKOzlES6Ox
 AUKaysj4QGPH06mJQTLk4dFIqVNC1qopORrVYESULzMxuYuX18grLgOL2VIkYwZzRcip
 J+RexeSMpdIg3QSYz+OTcJUe81Z0Q2XynWvnR51F9QmTQJjKi72yDr5kPzT/vlOyvKf5 Ng== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0eq4acd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:36:39 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33B2rO2x032546;
        Tue, 11 Apr 2023 03:36:38 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puw909asp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:36:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nLUPN+kfm0TnoXgrshk1qfzOaYcAj+V/W9OmEI/VRdbYjWc7ElkimR3OUhgf4gAkkuuz/ytLriubIKvb4MIlQD4kIUSboK3WeRQv9ueqcj4LeC3F/zcwlFqRwE360496NRpHtinoM+Xa2CdEvfV6uruwiC4A8j/HuKyxCjUiSH6Es/7wc2FK0/6VWUC6CwP5J7L6qhCE+CpEsKdu+vM6spSLLKJYCyDs61WrhVdSuWyI05q/br0XTRLPPRvSLNudE/8xDXV0rTr4GColk5dRQiTATvQgzBd+ve7KhNCGuYmPv2MD2I10TRYqvJU+JD6iJLMCZQYV/cT48w97oAjpzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6DfL7kz/4wgXXfWg8K0W+ffz971oCAL2vXI0knJqu1c=;
 b=Zj3JtxLBVsGqNolPmjU2wPgTQ4cvyCiZfhdPwi81Zi+kre3KUIufuZ3LTDvEMM7YoLPJfyoFTY99pUYu/em7J5Y3lB/GVNSmcEgVZO9Kb6psHl6blHk9Ek62iRlt+0UG82JuiYhEV5S096XQNt9s1JrQnTSxn3Zc84FFu+0WgVDuvE0zLZifRVffprIy0sVtcOfbR7TH+GUCoYm0OABHKD07sUGOg2UyLPe1D6r0PQeBo8vJkF/38M++y86iBUZSz19H+/QV6vgFu3+5FnOZRZupfkEk2d5qSF5UYLVbf/3HLeRIMlsmrkxVqHY7wHCOCWPAfA7xDsjS0RcgKqo4fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6DfL7kz/4wgXXfWg8K0W+ffz971oCAL2vXI0knJqu1c=;
 b=dTkTiW7PbQz8h/kaj9aszBL41n72ktzlHov1xLZbPifeS25yUpSJijwn/hoVAvwY6LIuA42KLL2D+QN+e40cHIKgW+TkUhHx+EldksQ4zL+0PlLzBPzO2OL31FL05zL6r8Cmx7eNeSeFBhPwTobafMlqDijoRDKOYeoIRLqzPPE=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by BY5PR10MB4338.namprd10.prod.outlook.com (2603:10b6:a03:207::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 03:36:35 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 03:36:35 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 09/17] xfs: simplify a check in xfs_ioctl_setattr_check_cowextsize
Date:   Tue, 11 Apr 2023 09:05:06 +0530
Message-Id: <20230411033514.58024-10-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230411033514.58024-1-chandan.babu@oracle.com>
References: <20230411033514.58024-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0047.apcprd02.prod.outlook.com
 (2603:1096:4:196::14) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BY5PR10MB4338:EE_
X-MS-Office365-Filtering-Correlation-Id: e74ba995-0ac1-48df-30e0-08db3a3df37d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ezwf0tozChMA3bIiBvYKS6qLHXFmGd2+0nnt2lhUa/KOwKPOTARUQUZ8EVjQeqNMUn9fVII/An7moxg5Cplvrw//9/6O71u5I+zIHISOxH+G3+zPENGHnZtaLZWaIF3sPpmFbUdUtsSeaM0Yv8fCKJiVCKAT8ZHamf6LsMpqJ/BAoAvglEWqSpuRXsshyy9oEb6FgMdRU9BT3wd4ZUmjj7l3m0I45t9IBqXDCDwubecQ4+psscLQKRE0giAq/vdoX8Hw+X28hbs+tjZTnBLYm12l3drJM7dPOvj2bYRnag9IHfdsav8oQWuaomY0qU4xmw59HYRfZ2vLpJqerzCA/ogUZBGE8Va+Av+MxPS2MPwtw5VBWzsfmwMclEKz97ud7r3ouUciDX6I8oXWGr7SaTVP3GT6icqJpeLYsdhXawbhaLx156HwniI4eSar9ob5mYhK5RnbZ5lWeZ/AJVlTDvljzcAFpxjH/n7dhMW6D/2/7OijNY5FBGeaXRF3hoqTX/KKBpDTr9DoYP/OCY58cVbtezjYZzvlDExTEiO1j7hbifalM6pbrneGoNqzVHF6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(376002)(366004)(39860400002)(136003)(451199021)(478600001)(1076003)(6512007)(316002)(26005)(6506007)(186003)(6666004)(6486002)(2906002)(5660300002)(4326008)(66946007)(41300700001)(8676002)(6916009)(66476007)(8936002)(66556008)(38100700002)(86362001)(83380400001)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8t5/bPZnxj5QscOM2QmQfmT7t/jyFwZJ8Cmtv1gGt48deckuWt14aEjvLxjb?=
 =?us-ascii?Q?EIjFeLnwj82f4zYyO0duJp2k0crJPWG+Cn+10XDKRPoY8nSv3Ef0JSU4O/14?=
 =?us-ascii?Q?Zkq3lRlaAawxXfDxARPCtRare4FRCepOv3l2N0EorxGFOoYXnA2PLlMuDtCg?=
 =?us-ascii?Q?dsXpew99MByTyLbXhgpa5PRRlQSzxCGg4dR+msGCn1rZAmfykRKNp9eUzpNy?=
 =?us-ascii?Q?6SDr6uPBXuOdkrOZIzqIdGYj7zL3ttDoq1CG/zuktw19RiBXIlAHkDUBaiVS?=
 =?us-ascii?Q?ry4NQWm4aNCoSj1xoz79YOkAwFi4CzMMnvCVZ+vGUosPxZty3nvW3vZ2MOTD?=
 =?us-ascii?Q?+Nl3QhUuxsBpA87diT54CH67QONSsdphsthZPwLbBV0qLh4sx+Qn8ca587OB?=
 =?us-ascii?Q?FfmOP08SGcvFTWAnC6VGwexGOGZNN32g4l2iUCXhFJhGlmwg/Hy8K3vGfXcg?=
 =?us-ascii?Q?h1PF53nYSRSW3c5gNxo+TwkIkjCBCqBFzDIOZtUeXThAuDypEy0sOsYbi5eV?=
 =?us-ascii?Q?UfuszOCY5vqR1EPzdiXkgNTEVJxVEzicvkcbx0k2pRqFgEi/8zejt8bAswn/?=
 =?us-ascii?Q?F75yyG+YE9zKcFvMrvD/Mvhbu5VgzAvu0e3GEY/0mdHgHIZ+0Al3phgAH/9G?=
 =?us-ascii?Q?5ue01c3pEa/BEwCdIkxIWb/vIc5YnSin900diVJG6Pq3emwCKPMkNsgJGOp4?=
 =?us-ascii?Q?+Bcj40p6lj6w6fCK/VXwkN2lD2vom8Sj9vXjNvQbE8OqK8sWLWNa8hOq+VpH?=
 =?us-ascii?Q?TLR27YyD7fWIE7zE4n9t5lm02OyQz1Kf7fSMFfBrVM+QAlOcHnVVDYtwjxli?=
 =?us-ascii?Q?khqN6dDlS659YGxzj3ej8rdcXZ9jWA4nYmYtiIOkAzCaQhRVNgUS3T/bN2TV?=
 =?us-ascii?Q?WgCl/SrZ/uJ4z9pwFLLBjo2yixXPkHVeqEuDq89yfWG2vP8hBZ9sDnP+MT7T?=
 =?us-ascii?Q?IhA1ctR//omowbfGSIQjMj4SV6xmECjqfnCNf+j6ndPAxz4ym7npqEuDrRIY?=
 =?us-ascii?Q?IjNJTfyNxvMws8ueRTfXcx6XQXxyxIKA0JK2wqgg/AsHv0tYQw0a4KkIDxZS?=
 =?us-ascii?Q?wdr0nQRWY/EWuJMe06+7Gp9UJfpOC0IYqmsVDRZn+901V9d2d7PnpUZmIkyE?=
 =?us-ascii?Q?Eff2EGzVmk5YVymRtbGXXKhUAqmvr/5cKs7PTd9o0pROqoNZ0ktKWHNj0x0D?=
 =?us-ascii?Q?nXQPFOjb4YbqCyowdTm7hYExHhvI2gdCbWPbbzYafKnQcG6CGMomvFNd+ooy?=
 =?us-ascii?Q?mFwPqTsT877SweQmsFGD0TfP9EMY7J5pqPnivYfvE6QJvpEM/NWF3F60AO/O?=
 =?us-ascii?Q?eYziN4+Tmh8F67FtgXYTT/0Cl/4UKse2zYwo3K44dGvl06ZMaF37LC00Uwwz?=
 =?us-ascii?Q?t7NWtdyAzNNf4hMR58WWJy8uBhl0xV9WhCLGVLD5JO/vGWhsn4av74E5xl5P?=
 =?us-ascii?Q?zLHcARdBoRQF1pqGrLnsKw0vhqfRzDFdJVD2V8+a9SptOzepLQr8lnraUplP?=
 =?us-ascii?Q?k+j7Vn8Kf+Y18Ym9iyoufx+y1cuciVhiwdHzpNm0IxPwFP55FpmH7YF0v0TU?=
 =?us-ascii?Q?+mtVl4QnhRuYamLrLvNamAos80aV8Z+S8IYOYyl4?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: F4PVONTwL4JwjSo5aCGXn3jXCjBpFdf39ZOeH2ACSu4sOgVmKAMnR7OboE6sUTIrPHhz6eAMcUyKtUxdC4P6CBPGC+YCkCLEx9tz3/pxwAoSOneA6DnxNS2j0Z5EKwkQT4WedZY1XfWO5sbOF0puOUg9xKZkhY8B7q9yOuhVnfC/CK46JUGy6GMfChBC8gvIVZknHW+xPn6YclKTG8kfUU6Vln4i+oqM6TmnTF3uuO7Qyql5VTZqZ9zUvng0+FbvYAEB7p9JIZEZf44Ev/Zmx998cH+CPQKpRYjJCyn8NojnqCTSw13eToHC9iVzWpqJUWaFnqDWQhdv7TQbJS/jREtTYsQJziKt82ALNG+BajYfdCVs5Pnt+4P2jb2ljWcqRcqs1iE7z+gOKNCWC8f2q7SSpX1RwBkW7TkONFUcHbwd/dLcFpdrHzY2tnQymInpRXE0EMvrPTJEb5PgirJsbjz5kLGdw/fhF7g1lRVxN2fTCiDvjhlM6zw1YbDTfRq698WZx2zsco4Y+cVdp80+AVmaXDMK7HkdKtXRXuDcko8B1NZ9IIRH7NP/0/uOdJb0t7ir20ReRIOJF+Up7vFZt6WOTEfH1EdnYOZgr5Fb84d4RkugN76/otkCWOLrRcMF8XH8a0b4T9wZHBYIVkZQP8hXTl2/MMOVf6y13tZzfROu440UFPAcSyRWm6vklNIFM0eOd/Qrx8HkmVJ5jjBP+/8pdfSzH6IU96PLOdIDu2YGzOj7dwEtdszIoilJrz2GB92kUmnRjxlDfgV/2YwrQHxTC8BAvcnyJthrxo7MjZNYl0yau5fMDAGNPgCtQaTq
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e74ba995-0ac1-48df-30e0-08db3a3df37d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 03:36:35.6217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QEd4wf1SYwjiRDZk7KdaFFb3Zo06P9RZv+14rI139W1uUwPncgIpxpZ2nmUxtrHToH0Cy7fGeawQZjHmi8XpAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4338
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-10_18,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304110032
X-Proofpoint-GUID: 2bf20t8gfAnvqIqMTsZDGOYaBGcHVCap
X-Proofpoint-ORIG-GUID: 2bf20t8gfAnvqIqMTsZDGOYaBGcHVCap
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 5e28aafe708ba3e388f92a7148093319d3521c2f uptream.

Only v5 file systems can have the reflink feature, and those will
always use the large dinode format.  Remove the extra check for the
inode version.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_ioctl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6d3abb84451c..597190134aba 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1510,8 +1510,7 @@ xfs_ioctl_setattr_check_cowextsize(
 	if (!(fa->fsx_xflags & FS_XFLAG_COWEXTSIZE))
 		return 0;
 
-	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb) ||
-	    ip->i_d.di_version != 3)
+	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb))
 		return -EINVAL;
 
 	if (fa->fsx_cowextsize == 0)
-- 
2.39.1

