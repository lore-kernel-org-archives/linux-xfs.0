Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABE5FC432BE
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:20:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93BEC61107
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:20:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235366AbhG0GUF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:20:05 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:51588 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235713AbhG0GTw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:19:52 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6G8Pr024355
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=lQ7yHCXNduofmZkZBZEo3bUHHiE9icaOB+GfVpap6t8=;
 b=qKlnY/Ffh5e+13KzwydVBX4ZpY/vUD7z9RGh47ITm2VC5FIb0IS5q9QzUteRHRZntDXx
 Y8qsFi97i4N92OARtsS4pCxczTDLV51WCXIa3jhCVv5e7kieVf1hdAXWefRTH7sdslWY
 zE7RGQyDLkSs7i/WANmdhnQ0EmJxNrOeD8w3CRYoboXhMtn51a3FeJQKvjUeWrtnB28N
 jqxSsPr+tjgymonIa05k/Hg+lUR0ivdzD/Pocks+qn/9/mlu8ta8TlEUOv31LDtj4ml9
 Q7MY+uZ6M10kmKL0fY43NkNGy/APJyfvT052hWoroH7PgZYKXaTc6f53nSys0nc3FtAs 7Q== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=lQ7yHCXNduofmZkZBZEo3bUHHiE9icaOB+GfVpap6t8=;
 b=aBu8ctC1nFyw5PVQI/nsnYirl5OZuIOua7A6fCZjbZsW/mVN+0FprkuhpHBJ6+6HODSD
 KzhjzcjUgKisYUjxqpzIDAZKerw8Klgf+V1FvQKcNM2tYKYsxzidNqq0PJSx8AcTjomd
 VTbUzjijQuKJPtvYBG54FIuf0h0UYA3X5ufoEWK9A1XtaOt/yuU/mexg0PqzNT6yD0Jx
 Fx1nXsEK3INQAgrwHc99xhi8FAaqTBkzJOc53VLY2fdj6Nje545692/zXYSArA1arr8N
 4vr8VvUsqaOkGHSggVSamz6txx4cPdz6aPPdfUTsrTamYoxIxFg1KFefEx0s0cuw98af OQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a235drunc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6EiaH065026
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:50 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by userp3020.oracle.com with ESMTP id 3a234uvnq3-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eqUWS4EpVETsnJzbNSqmGmclh/rzfln2X1f87taWXEAw4DTnXmvQS2CsKAP4gAAMBEKlGM2fFQj814ja23JmDqaXyG3vxRUEGJ/5EnkNoGAAN95M5LL3FpybXsiSo5R2B+/YPp9gzG9zre16NaFM8vGlJL9E0u9x06BdBqTnYu0RodgeEPTJEvVe5GqQJ91PEtiVE3QA8+qZ5nZZObW0mx8qYickY8yMt1zZjUVJJDIvl1gsbV8TdyqOstx12h23NRD4OaDuaqHpDGQh4xvoBe+0ssIyr18T3iWcQDPbjCgZle2W3kan95WLgn2o+hj84jDehQzpIxyKhNzXD0Sv0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQ7yHCXNduofmZkZBZEo3bUHHiE9icaOB+GfVpap6t8=;
 b=l1PX9bUBCTTDEgR/sFBpuxaVZDkj6OgAXuWYcgjF/513CmVgwMVrGB8T9l7dNMs5jGzxumnw6WWiTuM4aAJLa9ig4ZPCc5e45M79JqjPm0zvxzG8un3ox5mhFvt4OOhy4j/iS1SEJQYbH6e0JQeANKvi9MzJ+hlhudTAMZ4/vfQjYEeKZ/9d7T4UYWv3QtgWwcV23tsp2P5nLgFb4FBD3eP+e4KpXr9OSdUVptsgEdU5VB83+oJJx381A1HDOIeWxv3YW/zLZ1Rc4oO9Py3mCppaPNJYLkkV9ROxTnl//ORENR1qCqDhV+e1hV6TltOY6i4ANnK51qE1V6Qr7R6D4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQ7yHCXNduofmZkZBZEo3bUHHiE9icaOB+GfVpap6t8=;
 b=nUx0qm28oaqzRXP7rYyJyG6r3EE8GDMTrn/Xn37pMnPumrfP0FypK/CBLFpYbEA+Dn3AZlQlkdpK79tZYiwFsX/k1GbxUgpnyMglE8o+jIaWaQ5DmmzXRUGhg6nsh2OLxGgvyUzdWy6POAhoc/bzraN5jIPsF9MoiUu8RgTARC8=
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
Subject: [PATCH v22 12/27] xfsprogs: Clean up xfs_attr_node_addname_clear_incomplete
Date:   Mon, 26 Jul 2021 23:18:49 -0700
Message-Id: <20210727061904.11084-13-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: e67d1cb7-6788-4df4-94e5-08d950c68647
X-MS-TrafficTypeDiagnostic: BYAPR10MB3669:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3669100C5979E7FEE64A9EF995E99@BYAPR10MB3669.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:854;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uS6ReqtMSeIlo8C6G5yddzmX+ShuU3Uaf4bJaT1xKH8K5/61RcIYA1lC9+4aQtC29fcHjG1bRxv6+ZM4uixPgwM9vN5xLMuKSr9yT6SMLQx8dVtbgbVlRupn9vW4pgmdCEgrKUxk/3fN75hydgtJb79sujJ9N/uxU9ksqSR1dN09LuCYDIzuWpNuDnGkFwtrlapHmgLQOyjOA6PrV2SKfuCjBjdridVbPMNj4oopYNO6ad+i7U4IMCSe+ADJXHRoZa2/tLwwHXmLGRhh4EHayXARgk+Q5YS6DmJETZanguIR3snEFlnU6PqSbnV9ddZYmt/VfHcRCUZBELAtH0iMzv4iFmYc8RrgGKGArd0CfvUA8dxq0U61HYvyjDIIoctNWIw7zcqhYml82BV0RjwEoKey0kEkGs1si6PSXskocerLq6v8zeKWYbXHXIWvrwIjJRWsgj0J2zUXhUpnkooU4mnRBuIBo49izMM0r8AgBhsd3BTcrxL/ZPDdjeiO/+M33UPDeE3ukyX6NF/1piWdInA8CkRtHM9uuYvkpzMHvAMbS8iF+Ij0NkFmGpp1VgfuIz+S6BD+8TzIQ8rAWV1QENEotSIRhvyyBxLvw5JZio5JfyJc7AJWxpryD38QGRM2zlcEykYodIAsSc5IGnmUD6psH3zi7tMEgP6XHWa4ja7Zdro+kcYnc2SBjZuChWoeygySpNnK9uKmDYXTx1wF7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(136003)(39860400002)(366004)(44832011)(478600001)(38100700002)(38350700002)(52116002)(2906002)(6486002)(186003)(6512007)(26005)(1076003)(8936002)(8676002)(83380400001)(6506007)(5660300002)(36756003)(6916009)(86362001)(956004)(2616005)(316002)(66556008)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9541wzzX+OZ8wrmMFFqwWb9jpFdVoxSKA2UXYXU7wG91c7ysKDwTdX6aaDBa?=
 =?us-ascii?Q?GWvE1O7Spu/CPGsZWk4fGphgYItdSJZKr55mjZ93JInVz3t7unz/t6NNJ3xI?=
 =?us-ascii?Q?cBjaT4lJp44RJCjkcvPJm0jixfQ6mDyQZ2C/4pClDtHnrIqTg1W6/h0V7Z7Z?=
 =?us-ascii?Q?MrfjoMFgf8orLIZCpv4gL1btlpQZgyqkGYoAvEtV7qV691FhqeR+KOOWIAoi?=
 =?us-ascii?Q?zLqsde8elEvejf3rXV9cN24xZhNeVgK5QXWxrL3Yu6weo/ANjebtN0l9r7j+?=
 =?us-ascii?Q?y7XUq+HupPNSwpdQbHdi0qCmCtD86XII9QfoCB7fuDnYJW4z82vWOHq1c/VA?=
 =?us-ascii?Q?iKCcQX+FjOIp0lv2s7RfzZY3Ee6Wz/Wkx70Bo+Re9BD0AynpVYsVlIRXKqaD?=
 =?us-ascii?Q?9Y03hQ3c9+D7AnkjPYHexYcqScZB5yQ42SB14JvlLcLOXDQ2u+yJSDAfgNHi?=
 =?us-ascii?Q?g+P9yp6HhkqN7sYtyDo2d0FK3IaU3TV04kYA4VsyTL6cqA/QpyOV615xl+IZ?=
 =?us-ascii?Q?9LIZICMptq/C5g3eaGiydP8kB7BVtk68IjaqbpJ+73bl5TWXvsWIRaGzhuFO?=
 =?us-ascii?Q?5YndIatGzyVdgj1/JQx5N+/Nr6AmCyQKhLteff5ljyNtwIQHB5f63LZ9RSb6?=
 =?us-ascii?Q?tjqmfW0A6ue0C1nxypbpELqZ8vahpaV/0F9IfXQYVC4e7xykJUjrGuLrJjLx?=
 =?us-ascii?Q?S1tYDTe93o5+QDMETHxH863QXdMFOY2pYIZiFJBw+qwTR7HtJLm+yTBBpD7C?=
 =?us-ascii?Q?aG6VxmPEb+VOIJWoTc/5ue9FsNh548NiHfeWpLKUmqxlYcFQ5Nqs54FsGbUi?=
 =?us-ascii?Q?rg9XnIs7eQWt7Jkc3fqt4Ug5gXkzbSUcYoH1/QvhBVb0zJjowqFqBxaphejJ?=
 =?us-ascii?Q?COu0yGB/J84SjmSNExhpTibwfsvt3rltaj52CiLrY9gVJG067i8jgDDKSvz+?=
 =?us-ascii?Q?xsqx13D/OzvNRFdQTCRZRKU9/cqsChz0fMqPui8RZGl8O/A3DL5Txe+IFsWO?=
 =?us-ascii?Q?RyaCrnz8JumMQdHPPfguBKWZYis+sEhouvSLg1sLkN1swBDrCdqHTb4alOZi?=
 =?us-ascii?Q?wL2gUfbADYoks6+ysKxdjpYsayfiKg+/SiuFLhOxd6iSuNqrzyok74hIAIQV?=
 =?us-ascii?Q?qdysqLt6SBTYrFQoNb5+l8bZUqwUAKU5e8Q51WRiqyURk5XciDCjusa94YhR?=
 =?us-ascii?Q?A5iOZmTt+mEcUCYo+9WBYw4eB/RDSLZF/8+h2vEd4KemFaUt97MNFkWYH1VM?=
 =?us-ascii?Q?YA8AHk9KzIKMi4dZjEyMiQ1aEcDICFyZoqNQIAIDNIL07bo9FukN+WpP/0Uo?=
 =?us-ascii?Q?UVq1dPhqxTEhjah1DXCOUzLj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e67d1cb7-6788-4df4-94e5-08d950c68647
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:19:43.7823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ldWM70QG8WYMj+/JWCVfJgVMJi1V9PD8rqnYIUzV0b0U+d8G3lQUN36dNUtm5jEeo5Dbc5zMxFHuEIGZ+QuivkPnAzbhz292+ImZWheFaAQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3669
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270037
X-Proofpoint-GUID: QqUVRrD5KJjB7nqgkLgjJ7qTVAL7Fu6b
X-Proofpoint-ORIG-GUID: QqUVRrD5KJjB7nqgkLgjJ7qTVAL7Fu6b
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 0c0dea93623d000994ee29f86abd836b258b5c80

We can use the helper function xfs_attr_node_remove_name to reduce
duplicate code in this function

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 347f854..edc19de 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -63,6 +63,8 @@ STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
 			     struct xfs_buf **leaf_bp);
+STATIC int xfs_attr_node_remove_name(struct xfs_da_args *args,
+				     struct xfs_da_state *state);
 
 int
 xfs_inode_hasattr(
@@ -1207,7 +1209,6 @@ xfs_attr_node_addname_clear_incomplete(
 {
 	struct xfs_da_args		*args = dac->da_args;
 	struct xfs_da_state		*state = NULL;
-	struct xfs_da_state_blk		*blk;
 	int				retval = 0;
 	int				error = 0;
 
@@ -1222,13 +1223,7 @@ xfs_attr_node_addname_clear_incomplete(
 	if (error)
 		goto out;
 
-	/*
-	 * Remove the name and update the hashvals in the tree.
-	 */
-	blk = &state->path.blk[state->path.active-1];
-	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
-	error = xfs_attr3_leaf_remove(blk->bp, args);
-	xfs_da3_fixhashpath(state, &state->path);
+	error = xfs_attr_node_remove_name(args, state);
 
 	/*
 	 * Check to see if the tree needs to be collapsed.
-- 
2.7.4

