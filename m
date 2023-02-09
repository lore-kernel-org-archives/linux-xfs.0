Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C512C6379F
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 08:02:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjBIICg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 03:02:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjBIICe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 03:02:34 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759981351B
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 00:02:32 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3197PgdT024435
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=D8F7qpF6ITLlAtuTJlPsIwlwLTGP2m2hJVcuRUGzdOo=;
 b=QBQ/uX1tPjxoy2KLj2yupqcC5nxe3cWiYZnPsu2gR8UsBB/1cSMFzoIGzs74x02rxyLJ
 7cvCyoQKsUXz+/ozsfoFveC3jylWhdqd9CjkgyACffM9MfXQo10v4zl+w22PexPnCTxK
 7r5/0EJQxRvn5EcpUV5IvaUMDGzMhOBL9NRmoQatn70+T2QbfgiHZX5s1otlc2v6+yxQ
 qUkzK2DXGM4oMwgWVDzlm0nN/tOmscuvlS1mVnrLGCypBC6gP8Rv3YY1agQNLUQrMzv8
 EKBXKg3gGLpM4AMl1DQ6jVvxOTfq/P+Bb00xcycIcaUYrCwKry95yVOOkSSIhEuGp9uE EQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhfwua2mr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:32 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3196KLvn021320
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:31 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdt8dvja-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cVMYMv7GGeuQQz2s10cLYHy095+SXuqDDZByRiez9r892eb3+ZDl5QBAfmWRK1YVRTccCn7w4cBtOVmpF/qV4u/AVxV6AN9uEbID11lScGV03J4TSANIKL1qD7jLsJDSwxFPlrBFgRxvQDrjRQiusrEbYBD1LKksIw9m3sZ2ZP3OszNK6R6h9Emfe1NzckuNVJAaZhnVCyaIJ0bybq6r18Li/gWDtktZckhdHxJB463dh1BoJIybnCh24+gGVUkofMB5K3TJ4FP/48mDaR/dDu7Qf9b2fiCQZ+vsjcwNxQlxEJB395BX3YSW72YFnyuisvcLKgD/7HOqgXXRtGQKWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D8F7qpF6ITLlAtuTJlPsIwlwLTGP2m2hJVcuRUGzdOo=;
 b=RFE2s9/TK3YbBOT04vLa+9jM4/nrR7KY6QgwPJjUDE4QAqfT0qhQe/5xP9UIjsPrP2rPufLtAy3nmTQAC8AgS8uKwv64JqNmNw6KUrgBLcqt4NG4rhwWqu4NOE1yX7bRpkpDSvmpNTR9F5nrUeTpFkrwRga+ajoLe/ZSEQSMn36XwSdwKqZo1VDMOj0F2SLYxr+mQFZUkG7wSmFtO/VLaVsrsipJWt5hhYvRHa9sMMpq4HXRGTqOwCRj4RocAmWZuKzq/b2E8DZJ2p/0GapWxGY5K17w6eNLrjxzRYoZ70Bypa/MJ0rPg90KNl9NMvT6YR77r8Ubz3mD2iFz1DOTCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D8F7qpF6ITLlAtuTJlPsIwlwLTGP2m2hJVcuRUGzdOo=;
 b=tSjfZagaDdApNwtA4m8x+PgeKS5GEEGZnSatx2uQbFOJBiNnjW0ebPFRfPbDxR0N0WRSbCpFiop88uTJvWSdi9rT8KUe6iYIfWDttUPnpVZuv3kb3nG8ACjE0d2SxOpxUCwTfL8LEcLHzaXpr+vYB9Jsjb+mypGou/UvJvbklVg=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA3PR10MB7070.namprd10.prod.outlook.com (2603:10b6:806:311::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.14; Thu, 9 Feb
 2023 08:02:27 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6086.011; Thu, 9 Feb 2023
 08:02:27 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 21/28] xfs: Add parent pointers to xfs_cross_rename
Date:   Thu,  9 Feb 2023 01:01:39 -0700
Message-Id: <20230209080146.378973-22-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209080146.378973-1-allison.henderson@oracle.com>
References: <20230209080146.378973-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0017.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::30) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SA3PR10MB7070:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a580373-543f-40a3-ffd8-08db0a73fc63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: drSz31hqIFdznzNZFK9WcQs+INrOdiaBG0iec5ne3OBaMYWZLIGDvndeLr1TChA52Rv7WE/NNLBjc6TDXWGui/MAYIptMDyHCkKIXTNjFa6E+4DO0UaNofIPrrHx7JRi+7JMUhiKJX6W71/WGRhZu3wHnsEx+2yhAWgTbDPX22LN3g5RexJ5ViYZnXHQzn7Tv3T1VoFghmPx0hgXv5GIiAEQCiU6TMIH2DWHRpadz3iGzScA99/Hwk//A5Q5iCnFF+B07ioxeZggLC4sWEfn6ovNZI0o2Y0Ij02oiQeKN78b14Vm0ioQcFhyiGpaii803xJIEodd81k3zbq8g2FntqtdN6V9hPZfQYDRiZW3a3j+n55Cwc2HzcvLQor/HNBpQ3AqZrlN5nd3TJaDKr9u6EjDeEqM4+wiJ0Xc3331F3bWjTD7XPEFnVHos1Fz+wlR+naCHJ3GvcmmMKjbujWq5VSQOOUFHpdjP7uDM/h+BjpOp97MW6J3kwu5vdh5eL1ZncVd8SRwlu+Xm0PBQyz5S2EixtY2GhU4grRBytEq+r4Nl8bSHeFXH/dHBIytpnzpnu61rQug6ywXS56AkzFnulcIAwYxpSaAANfp5GinHdvgDCFuHxR+3+S6OrZhG4ZAC0WfdQ4s9hihiMXimNfL9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(346002)(39860400002)(396003)(136003)(451199018)(478600001)(6486002)(8676002)(83380400001)(6916009)(66476007)(66556008)(5660300002)(8936002)(6506007)(1076003)(66946007)(6666004)(2616005)(9686003)(186003)(6512007)(26005)(36756003)(316002)(41300700001)(38100700002)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N6HJaeZuEg8e2vKa4ImPZ86/oUQ88xo40Nye+vhJEcNPum6SQ6BIt9LBbTGN?=
 =?us-ascii?Q?BCKjfbYt+bZQSa+wP9Q8PsugYg7lJyRRlnZhUEMTMQTl5fG1eddrxqllQaVj?=
 =?us-ascii?Q?IldeK04vcX1qKcGxIbT9Ugak132ihIvPD0GwYXCOLabY+9w5YF+wGcqKZq7/?=
 =?us-ascii?Q?evpHicfzFmViXnW2Fq+7tDJ2Gg9Y2ip5U2769D23FkwBzc5h0rB1EZpOvrB1?=
 =?us-ascii?Q?p78DYhjoUjwuaOpeeWof3Tw9xUnu0HZ4OHODhqcVkqa8KsTl4Yp4l4OP3j5O?=
 =?us-ascii?Q?w2531V7WApHdps2KQ7EAFmYmljVLlHb1wyx5oaYisGvqGMz3CqrNN+KuvqzM?=
 =?us-ascii?Q?eq6Zk652zhAX4DsqTpN90yStpY+EBRZYPHhE8o3y42JDVuqNAkGTNtDcO1Uk?=
 =?us-ascii?Q?/lEPYBnegHAIjzMMzxI4y1JarE84ThLlOgA16Id02hGNblz00lps7qrSjf4Q?=
 =?us-ascii?Q?RgagIj3RbyTPc6VJQYyAcK1hPNsH4/U5qbnH3kpJwbhv3Rv4JIeUzUiBvMKD?=
 =?us-ascii?Q?Xo70XCr/KfrIJQrQ42hX87h4IUIjs8u2j9S4PFqNKp3h0N/QMjSq+0Emy3AO?=
 =?us-ascii?Q?I8e356tLOxUs/VjtXBdenwG96t+LZeZQCmpPW78ZsI/ugFlB76uNLXrXw163?=
 =?us-ascii?Q?VZOB6/fdXDEtRlEHuwNU3qZD9gSMw4GP1ALjbGeRbATWC3d+69C88rm3471C?=
 =?us-ascii?Q?pZapAq7DU41bRUvGcvC8/rAy9tEmIdNsSNbgi3lt8l9Yf47Olnfr1MA+DXMY?=
 =?us-ascii?Q?K5RywZ0T3ceWSCr/tFZqoW2lMWACdxpn9jmuPKqaK5tiUkzQwsXmwG5HS/Uy?=
 =?us-ascii?Q?EFANQlQYcIk+uTOz8f1iLaFdb+rNMYKHe/32QONv+icV8OPIu7VdeCRq+eQE?=
 =?us-ascii?Q?Zd88XbkKsIO4CWs+jICXJElB/IQvsJ/vIUM4V2TInLFhnTQTEYHVS6LMda8i?=
 =?us-ascii?Q?iF5iiB9I/GON1Wazt9o6sP7465seHVh19GAiZMLi0j5vOmNCRVSBpHuYxJgK?=
 =?us-ascii?Q?JF2VUKkcWR+tlihCuP/dlIV8hEfaUFYAXlN+gMvGIdN5WHBFdBpFZy+TT2dA?=
 =?us-ascii?Q?rQQ9K7sxw5OsuHxeJkWCfvMblAMrSFCU0IESII+hBL0FkO+zvmG41sVoF4nB?=
 =?us-ascii?Q?TcujB+vogW2Ozg54Z9p+mlmqFtay5xpu39JPSoDBviUbIudHk7CiG0TkR5Sf?=
 =?us-ascii?Q?FwssIu8whCG3jm7kXh6m8n5D1NHLBfNrUdArW6KdkMPXvs/qhPU6jMCLUOu7?=
 =?us-ascii?Q?P0XgGLHbPN5KrpBpX9x28J7p4ZrgXG77vh0LmOvh57x2yBMeH9kz3Y8WQjWW?=
 =?us-ascii?Q?KkMag9xIs2vij9tfnzR3V8v34ZruTzxR+sfAMSCUKCNyirxvUbYdTfifzO7M?=
 =?us-ascii?Q?kABDvqajooIoXu4uyssBr/UbG41/l6x1pPbA2ZSTv2WYVAhqj0vGXe+/Jol+?=
 =?us-ascii?Q?tXJ3mEUsAXSr+8txozyPhjf5SKoMnX2hGIoCNCKjDktx/6b/KqNKGwua/fVj?=
 =?us-ascii?Q?x6wTylPzN+K55fgcvl9+D0drn722Mn6ryiH0YuL2qURQkOyFFNZI1eVUHpgB?=
 =?us-ascii?Q?oM3ftD5FQWrVaHTeO1mH9cgHXO1uTjRWNu7V373ZFagKElklvq4K531uAeyz?=
 =?us-ascii?Q?UA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Ss4FZRWpXe+tJP0ljqqXXycnQkuAnua0pBROsIr4cwZPBdTF8QNh8/xPOlWmb99j9zeHWHbdjbhHPhrC+jI8adxVBy5sSTrgMKFu08rb/FmL9gybWusoV/SsDautVHXmPkqQVuYFNM1XeNMALMhz+aNFUfncUPpjQywCU7P10wDoawEIYb4+XmDJHguF+oXatTwwdeaKIjHXsA2QH9+LdEGI0VEaJUc8OUWQk6ohjN5x/Qq+9n6+MjQJ4SaJFDBrBRO5qQd/wI3sTayUYqj/wD+/kdZFZoK8EySSk6/5L1HFkwZS8bY3tirIP8KnPBNdd6XEOPQQuRGyGYIyrCk1kvflm5kQ6639anqQgmsTmbatD80K3fiHARIi962pRveFE43xGEOj08ahFBi6ISp+HySrmWRXkD4XO4HPG7fPiinIKA7dBbFR9VIEoA68c671N3eoL2TkrZXZvNTIRy0i1x9HqTqJMcQYOaekvbQVNIRyy5QeBxVQhNYUNKyLHDYQcFy73ccLhoyafMbx3WWWRXsUOE4FGT/Rqg4/8LgEgLP/7picBmrLVu3t8IouxW+baW4fa8jz+kyoCevupDLB7UUBzujmJA455tuwp6kt/3wnHYvJJe1qKokIv7IbdEw1WAYERG5nPc+ANxH1PSEI3pxaRxPNkguuU0supc+xdQ5Alz8mB45EsKaxDZ5nDUIN2gD/V87vpIXri7odvDdUVFP7n5QqezwEJVUC6neo+lGILBLDbbSmkavfjo/mveNR
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a580373-543f-40a3-ffd8-08db0a73fc63
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 08:02:27.6704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PPxpWX0i7FL4+9BgH/qh6GCXaWN6gvkCBKvIbhhaaaKGATDovmOMSBAjSxccpw8ChvCZ4xea3QI7frYLRs9M2x5T48bilBZQDEzDTrZa44w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7070
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_05,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090075
X-Proofpoint-GUID: RSiw6_fHwqZFKr7rR7lCi9m2jvXM6SUW
X-Proofpoint-ORIG-GUID: RSiw6_fHwqZFKr7rR7lCi9m2jvXM6SUW
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Cross renames are handled separately from standard renames, and
need different handling to update the parent attributes correctly.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_inode.c | 51 ++++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index cdbd7df64ff0..6626aa7486f1 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2749,27 +2749,31 @@ xfs_finish_rename(
  */
 STATIC int
 xfs_cross_rename(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*dp1,
-	struct xfs_name		*name1,
-	struct xfs_inode	*ip1,
-	struct xfs_inode	*dp2,
-	struct xfs_name		*name2,
-	struct xfs_inode	*ip2,
-	int			spaceres)
-{
-	int		error = 0;
-	int		ip1_flags = 0;
-	int		ip2_flags = 0;
-	int		dp2_flags = 0;
+	struct xfs_trans		*tp,
+	struct xfs_inode		*dp1,
+	struct xfs_name			*name1,
+	struct xfs_inode		*ip1,
+	struct xfs_parent_defer		*ip1_pptr,
+	struct xfs_inode		*dp2,
+	struct xfs_name			*name2,
+	struct xfs_inode		*ip2,
+	struct xfs_parent_defer		*ip2_pptr,
+	int				spaceres)
+{
+	struct xfs_mount		*mp = dp1->i_mount;
+	int				error = 0;
+	int				ip1_flags = 0;
+	int				ip2_flags = 0;
+	int				dp2_flags = 0;
+	int				new_diroffset, old_diroffset;
 
 	/* Swap inode number for dirent in first parent */
-	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres, NULL);
+	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres, &old_diroffset);
 	if (error)
 		goto out_trans_abort;
 
 	/* Swap inode number for dirent in second parent */
-	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres, NULL);
+	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres, &new_diroffset);
 	if (error)
 		goto out_trans_abort;
 
@@ -2830,6 +2834,18 @@ xfs_cross_rename(
 		}
 	}
 
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_defer_replace(tp, ip1_pptr, dp1,
+				old_diroffset, name2, dp2, new_diroffset, ip1);
+		if (error)
+			goto out_trans_abort;
+
+		error = xfs_parent_defer_replace(tp, ip2_pptr, dp2,
+				new_diroffset, name1, dp1, old_diroffset, ip2);
+		if (error)
+			goto out_trans_abort;
+	}
+
 	if (ip1_flags) {
 		xfs_trans_ichgtime(tp, ip1, ip1_flags);
 		xfs_trans_log_inode(tp, ip1, XFS_ILOG_CORE);
@@ -2844,6 +2860,7 @@ xfs_cross_rename(
 	}
 	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);
+
 	return xfs_finish_rename(tp);
 
 out_trans_abort:
@@ -3060,8 +3077,8 @@ xfs_rename(
 	/* RENAME_EXCHANGE is unique from here on. */
 	if (flags & RENAME_EXCHANGE) {
 		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
-					target_dp, target_name, target_ip,
-					spaceres);
+				src_ip_pptr, target_dp, target_name, target_ip,
+				tgt_ip_pptr, spaceres);
 		goto out_unlock;
 	}
 
-- 
2.25.1

