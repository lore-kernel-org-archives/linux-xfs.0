Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06EEBC38A2D
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Oct 2022 22:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiJUWa0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Oct 2022 18:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiJUWaZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2022 18:30:25 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABFD266433
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 15:30:23 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLDuOg010112
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=acbjfF5lLh4Gil/z1wg3K0sLLs9EzUUYHdbdaKRxaj0=;
 b=nQVJAON4DnIc+J+pOXQFiEn3HJQmEI1lh8djvfJysg1wJMpdcwmrt0LJOUMmvKPymAsQ
 qLtIadRtsNKc4ET4rlKftiJLTZdC+5cmS+DWICN+mScGai7MqBtbcmh4Fu44BBTOccJ6
 X0jLt3BvkDol2T1HpZcqcIw6NLYm8yjOHAJvO36TiqlW0gDnU84+TNWc3mGHWgAumICl
 erD+Bopgbz6M2UpeZLiFvZSELmkWCZdTlN2hhxXMq8qaDl6wtR/ieODzWnCALq6ZL1xb
 liivNDvCmxRCnp181cnr60zYBK72Lg+JSN/y5Y8Ky1U4xQbzV+QsNAgY+CLu/3LfWwX1 2A== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k99ntpm1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:22 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29LM6YbZ027393
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:21 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8htm00yu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V5Xcg9nYT45wmZQobqoavyy9oTwAbtwnIQsTItFOubYe2TQad8WdRkQHmegfJDYcm/dBUBVVD61Oiz7xUHTFPgpV2wESkmDOGTJUvxq4O6Q7Ek2AwYpu9WbXftd3cY1QpbKNNAtLyWsgyViOe1/4I5lSWWHGghet0pG4WC4TV8s5BNF0HdZwQMM+AroTZ2pA6X8aiZn2CFCGok9b4oxFaY21orQ2bM48/Dg3Nf/3ejhm/dWFXqorjeFEbO+QXYFrrJMSrI1GYUwB9Vl6l3YMP067Q2IlO9AsjuwQEA031ZJ/lctJ6S1FwK5i703WXFXLRQjhFjyjlRfaFvgoDyPNng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=acbjfF5lLh4Gil/z1wg3K0sLLs9EzUUYHdbdaKRxaj0=;
 b=CDPMcQ+Tnjv2MLESZaoEgTeFcvAl27S9Oqw4X6bFSdzjyX1jlER6sQgTLZgtr396WbWIHwsS/6tpF+Y13uG/1pviXTObtJ5EBMZYymSxKkB5f4p7tVscl8KsPYwkPkMLz5ufHvdWX+dgqhlhm0OV4ZW4OsxSi0wetb9UksiH3w09aC0pHKHAEhkvSbH9j+46xLaA6fEBkzdgLZC0KzmUV8TVyBTgE+13uE2D/OM4mSajWHiJnigGms/lvY9ffgJsoPTUu6zfVPgLAdtEbbdcd20us6GRrt2P5vGdBDhyYxV6vA85ewA+HFXPvUn9shiGAZ6QtfCsE1No5Qz28z7NFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=acbjfF5lLh4Gil/z1wg3K0sLLs9EzUUYHdbdaKRxaj0=;
 b=DinMp6ZgQfxoL+66NCzsW5d8vbpjNrrD+CdL2JBWWvBwmfBgoZuUP6EZ8Xnmr4Mw4jX8+/IS6x+eEK3LcQRgymhh8wcopRNhpYH1GYTm7oY4yhLvVsBPt3ezt5+2LrIB2vIsZuoZPg221D5WfSfws3mhuC+rUfNRbRgjt1vZoqs=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5213.namprd10.prod.outlook.com (2603:10b6:5:3aa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Fri, 21 Oct
 2022 22:30:19 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 22:30:19 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 24/27] xfs: Filter XFS_ATTR_PARENT for getfattr
Date:   Fri, 21 Oct 2022 15:29:33 -0700
Message-Id: <20221021222936.934426-25-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021222936.934426-1-allison.henderson@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0101.namprd05.prod.outlook.com
 (2603:10b6:a03:334::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|DS7PR10MB5213:EE_
X-MS-Office365-Filtering-Correlation-Id: a73ca6b0-9486-4f29-01c4-08dab3b3d5a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mpq/E5mE2G/ZOuowU55aEpB9++V7j5kQS1HZ0va2KmUu3fxzrGtp1QtCZTPCzRbGTY+YTIq2kQFiO+AVdIKv6+Wlcbm6DZF39EKc+J9FYZXu0PA4mjVeZ9cWCM1kIWN/fjjPuYJJfZHDzVDaO+J1wsLCjGWfcGrYVog5RrH5HCagnpBCKO2SIaoZkHtSBJr8CUecg2mS2ORIOwhv7tbrm2v4TnmV0M6rTpvJl20mqwXSMbXL2YCtQCNWIMqM37ZWHz+8EN+u06+ADupRf8eJzDfS9p9FOU5YP+bXH52iOUTIazRVl1BrzF1Nn4lnJpICtfLOHqUQY/w1K/hH89PJ+PRaICbkkwVzFHKa9rRTlaKFh3q4TjHJJWe2JB6PPVNTsKl9GBkHPVnjoETaSEoV6Y4kWU8L65TNlBoVhfe+0QqjzpfsvN8/YJZu12tZdFe6h8GnBIK84fL3Ic2+QFHG9hl29kAUQn/mCISyacQQIe5pIE8dv9ULeb9BA9E3c9bPAE1j18LdPhAP0KnVyTsWS533y49dlW22qHClIYOCipAb3WDHB1eihhso+y0ax96ScvDa0GzAZwXPJ0Lh3/oj+rQd9K+IXK5FAGKiWR+myXIJ+Jg60L1ewwSTFgIrJajBeXnQe7YZ2BBVqK3D3u+qZPDBn8PB1Bqp0i1K+p5loFf0XXu/RHMpySUza1nlKmmKGNTbSd5FmpomZ7zTPUiZSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199015)(66556008)(8676002)(6916009)(66946007)(316002)(2906002)(4744005)(66476007)(8936002)(36756003)(41300700001)(6506007)(6666004)(6486002)(38100700002)(1076003)(186003)(9686003)(6512007)(26005)(2616005)(86362001)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Zgshu8zhwFapXYwm3i7b1386T82xI3Jg7/F1ZUeHbPYOxOF+1pG73Qcch90x?=
 =?us-ascii?Q?XZvv1I6cq2Veol6MlAYIfMuj0WueF6DMH95GJYNoxRUjRGosjjGAk3XDnFMw?=
 =?us-ascii?Q?rBvw2/TDzNIfeuIWy6+WSzM4E8P5CFDsR210XnlzmodGRP8mVLzg+Q2jhwLt?=
 =?us-ascii?Q?SXmeFLtAbsriR5DB+4anjewlBf+xTiNtQuYTrSR8uRXZVKjaosxuhdgkUO6c?=
 =?us-ascii?Q?eK+7MtuHOnSSd1WYSiq3YVzL6d9Ojk/lV7FpCwulmY7b8PCjv7h9fJkHSd/Y?=
 =?us-ascii?Q?iTU7pFwfMzX+GIR+q8IPFol2jhNbOqV5hn4+jAgo5bszWlHYRjFpnPq7Gr9m?=
 =?us-ascii?Q?xPvjt6QjjPhZdCb0aAV0ylNmQuw0xbIiOdZKQKyChO76mWoyErU+R3RpockH?=
 =?us-ascii?Q?7X6coMTNAUQlzmhEYsilNcO3NZv8e9ZZmQm0SZ4sbpeTmB5X3NvyhUC/6XSP?=
 =?us-ascii?Q?sz0L2kmRAhoXwRPFzoPUkvEijM3SAcL6GC8LKTHiJ6p1C23kudNa1iDYheIN?=
 =?us-ascii?Q?aST8aQeSujY8agyZRpPgnOFk9sL9DlSFZszxi8n4re7Nsi+MnkClKnNKq/2S?=
 =?us-ascii?Q?+mG5Fmk7A4FWneRzY84bf+QjJGQObWpkhiSUZbeyjmPU9NBCDHhZq+KpoPQG?=
 =?us-ascii?Q?P4KNFcpL5fQfB68zOc4b4dzUVTwzAkmknhFocVcXqpytWfi8X+wClCIG7FVc?=
 =?us-ascii?Q?j50YkvWG9N8idD0Xuq03cTVVp077PI2bdAIgUQj1PFhK2I9QLtTWuUB1HB3E?=
 =?us-ascii?Q?ddVUtqd5VaD9YcFSK4pWZrxQQ7msMZC0M2VnxVVULW36b8IbnDN1T3KTlcAj?=
 =?us-ascii?Q?v8jTA5uUxXdJ1U/GIUK3DpFyYsPgJgacNOJTWy4dbLoJgZUO/Hu+wQRDK0Oo?=
 =?us-ascii?Q?mE7lAHBwP5n7ITI50FBnU54KjHc36VTmH6b3h5WxffnTK3pqyAtz3Wh+65kl?=
 =?us-ascii?Q?twV77IpXXwN9KDKhTvaO9ID81CGVrf8FnDmViF16n6qxSGEEL4loFknvg5Vq?=
 =?us-ascii?Q?Xto4CgKsucMoq0AKQ/iXauakg6PGZoAJvIRV1dmJZ7kj6BXFp+irXejYRdJv?=
 =?us-ascii?Q?O5/Pzo75nW/o93oMwSewFxFF11IewO0xhMcekwOA51PHc58bBx7Isak/rquK?=
 =?us-ascii?Q?O7OdCBVmRCrfzgA6ovLxXMcLx56v1iaTk0q7w+cDvRfIBmCTlF3o+iSz/Pri?=
 =?us-ascii?Q?Nit05Y+uRnDyOBPceycbFKibaAQlXK/KPn6vbJAsYBgpYUhOc16utvJJGvFK?=
 =?us-ascii?Q?B32IRxzxFsKXkeooIc9e4NlGLyX2+FdgxNTYHHJgNxR9uHM4PODgfm/RdKaY?=
 =?us-ascii?Q?mxo58QDkFuz50NaXQOfSIz6QJgDdUIEI5/qgNkI6BzhYLnnT5TT1Y+YZ2ME3?=
 =?us-ascii?Q?PzKFXLpJJgx9IKt+ELg29Mst961Pe5r3jINqmUokOHcEOfuWCdW5+L8Rfnct?=
 =?us-ascii?Q?KY0mdC5ORF49MQaRF0aZGTJeSlCfRe/V3ijfY6c6NZLLsC3ZtKOXbFVTjfuG?=
 =?us-ascii?Q?XYdERkngO+JWwV7NIC2CYMOZ2cQeQfigofOO51RQ6JZ2HfG/FYQNDQ9FfUb8?=
 =?us-ascii?Q?j+YClrDhTpFXG7ubwfb85y5PG1tjm33L2XXLtHGAc1UgcWnQ9I1IfxygRIwk?=
 =?us-ascii?Q?Jg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a73ca6b0-9486-4f29-01c4-08dab3b3d5a9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 22:30:19.4455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3rT3jWF5uvVCgqJT9mwskXKCk6ZY9kSBn/2AspFJ3mDQW3VarQvZsMW0F0djERSFQQF8xEhbVSZxNW0nlRsurU41y+xJQh2LhC0lp5sLwJs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5213
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210131
X-Proofpoint-ORIG-GUID: mI9z7BiOet7K-eHWSz3zwomqof_tKacL
X-Proofpoint-GUID: mI9z7BiOet7K-eHWSz3zwomqof_tKacL
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Parent pointers returned to the get_fattr tool cause errors since
the tool cannot parse parent pointers.  Fix this by filtering parent
parent pointers from xfs_xattr_put_listent.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_xattr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index d9067c5f6bd6..5b57f6348d63 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -234,6 +234,9 @@ xfs_xattr_put_listent(
 
 	ASSERT(context->count >= 0);
 
+	if (flags & XFS_ATTR_PARENT)
+		return;
+
 	if (flags & XFS_ATTR_ROOT) {
 #ifdef CONFIG_XFS_POSIX_ACL
 		if (namelen == SGI_ACL_FILE_SIZE &&
-- 
2.25.1

