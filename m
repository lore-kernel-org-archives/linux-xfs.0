Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45FCEC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Mar 2022 21:07:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240953AbiCWVJG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 17:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245058AbiCWVI7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 17:08:59 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04DB8CCF4
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 14:07:26 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22NKY5Go001358
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=nPI9yaH4OGc+g9W0ZCpRY8Yi/inmc7wmPYCxIYPPVAg=;
 b=mP0ItyoxyvicsGSe/Xw2eyRH/sGt1oVSHx0egeSG6qPqn79gvQ5B936IXeLJfauRbgOT
 eE2+469O5GaHuy/kpbdLXAv+n47oBpgP1/k73OoacqIT1mDOvE/nXNnrQrqDZLAbojne
 xrvcE49EoBi0qAT9D1f8Ch2Ntk1Sp2GCh38ut0SnCFuvkJY7MgyXy4mueQMSqA3pY65l
 OHrapFlnRsNqSg81QCAgmgPyG21rrdlYx/P4QBT5HYhGVDWUrOH/q/u+hnxYxpJoFBsM
 AK+M9Q93Cnhlw+S5Tudf28w6gtR2BIRbOtpkMFp7Gb76aIged62CjAZvgEBNCETkSxIa Nw== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew6ssaqne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22NL6Ld9082870
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:25 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by aserp3030.oracle.com with ESMTP id 3ew578y1wr-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y5f16DrhTaecN0UClPa+AGiA4cYh7g1s54ld2FKtOb2Fyvff36lvAnqKzH+aYZTnIqfVdbTX3Pdb38qzv883IY6B3vK6nj7Qo45jxMzompA48KZlBcQLcrRwaUOcVNSk5TGhbXRtCoHBCvYRIYjQ/0xs4stonpf7r8MUBM7xU/kWypw8k6IKs4ypKXD11/TPs7WOiFCIgwy274b3GgCm/ECq7DIVE1wPtkg+5A/OVfRww9L9rg9Fr1lKdONlNDwxYajfdL/tEmAcnYpOH3GjESPSiXC+6vLkvKq5cuEniszF5G0YfZ/akN4iVEaTzL5fR+qB+sZAnxFQlwAeN3GmHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nPI9yaH4OGc+g9W0ZCpRY8Yi/inmc7wmPYCxIYPPVAg=;
 b=e4RLPmzUDnu0mXy/aDq7O+NkXdOQQSuE8iuLBbyhMnnv65AoH48940Zf0riiopWlCH2wy6A3IrdR5hqiiAMjaYvo7gPN23OyUpFAeA1gNHf3CSNgQ2ZOvNNigNBULvb3lbioeJ1nEjHS5YBXeVW7aLTqvPtjpAWq+Q05yZ1C5a7twcOdDTMTUwG0gI0+BrCjKM6SXwsUogGjObsNYy3au8z089uGqsNDhYCJ3yIMU8q48bNLu8f3nqNnmdqQvYWfnBK5AHPZtzCyPya2FaeNG89goa25ayJdFz8pUNTeht6iQdA0ImLnhpf336Hb9pmKONNJyp+3ZC4RgyxmfhyNkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nPI9yaH4OGc+g9W0ZCpRY8Yi/inmc7wmPYCxIYPPVAg=;
 b=j46StRcUEs0PBQh1mQs5/Pz4v3XEG7kJ1Ws0ZPtK8C6rjnaMbGJX3A9NpYqldP58/bQUb5x9lgQzvN1fGId9x7TK0y+P0VddJc0m9/1OQXl6AgRYNpzr+8D/xp8OvCzq2ByMz7VNenCvp3ZqSxUe/xbTvYH9Eaxvg7Pch9Fvh+E=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4744.namprd10.prod.outlook.com (2603:10b6:510:3c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Wed, 23 Mar
 2022 21:07:23 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c517:eb23:bb2f:4b23]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c517:eb23:bb2f:4b23%6]) with mapi id 15.20.5102.017; Wed, 23 Mar 2022
 21:07:23 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v29 02/15] xfs: don't commit the first deferred transaction without intents
Date:   Wed, 23 Mar 2022 14:07:02 -0700
Message-Id: <20220323210715.201009-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220323210715.201009-1-allison.henderson@oracle.com>
References: <20220323210715.201009-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0084.namprd07.prod.outlook.com
 (2603:10b6:510:f::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: afa402fb-a5aa-49d3-0fec-08da0d112027
X-MS-TrafficTypeDiagnostic: PH0PR10MB4744:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB47449BC757AD45E72DF13A5895189@PH0PR10MB4744.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FWSQo9IC9KzgyeOQcuqyMYsaz5Y5hzdiaGNwnkd5VO5A+68tVDW1P9izK3N92pGOUa5uyRSqGMqHqzNxtgk8bBEc9yThV9MkiXJeaWXf8kAJy6sERHnkkg/3/gUP6jJbEfN8PTk5CXXwS0xJNyQgWaUjsi90j1uuE21FzPidConNTGcrKYq+vaK+optsvKnksKP5qSFBsHY+dmGGI1/BOcYRhbJTgMBiW8nnTRbiB8jLJVxzekYw7o9t7vRtsidOWpPoY2glgpj8YSmSu3jdtBkV/vwlH8tpXunTyuuNPJTxGomHn7OsX3g/akDWM6bzYMih1PW5MixnE51cDnoVQYKz5vrMJ7zW6LPBeR40K4G7tY99Sb7jzdNLofsVnugmRsHVjAWPVz1JZVu2J5DP2AmWf1o8zge0S3gsFzfhVUXZrU2r7EbUrpBza2T74juz/ZpRfNW0R5IM2iZf1ZPM+Q28Ysq+XAk2/dM/zVAId4o+eFePHXP/rln1ta/0bkVgEFlQ8gmyoB8TJLRahYO3cky0OwA7cxkQpXv9JI2FG0cnl5hADn+huK7U6LQkDMm/U82bmF17abg94JrEG7fksb0jXOv4s66cKf3AQgGz72mseEvddp8Elgdl145xsiisyy5Zbn1RDgS/lh5uaISUBqnIeZhszNyaCPqO4sIyDtJlSgtk7dBr69lo4IZnzCpJynqZpi02WjrlOaOLKPhK2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(44832011)(2906002)(508600001)(26005)(186003)(36756003)(38100700002)(83380400001)(6506007)(38350700002)(6486002)(52116002)(86362001)(6512007)(5660300002)(66946007)(8676002)(66476007)(66556008)(8936002)(6916009)(316002)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vdu+F+CPmZ8Cctq3RknsvUmRIBAFXhwDxVp/oPLUIzB1U9+BPukbFhujFhIS?=
 =?us-ascii?Q?qlPL5PdNjLz0lvIOPlkPd6dQKREsX5g4DvzqKgs285berCS7STIPj9knCoXF?=
 =?us-ascii?Q?MnoGf6qiNtbaagopCWBpjU6YeePG6xFpz8yt/ilfLJ53axD3XJydOPYojOym?=
 =?us-ascii?Q?cr0uL9r3P678mCc4bvPvidD64IIaN0znvqfmsOfkWznk2D3CiF+pgvxJMjqK?=
 =?us-ascii?Q?sIu4XG9AJmLM5jwikFByXcIPt9YwNwmkvvG0g3CrF29zmHca6FN6bjb+OmVG?=
 =?us-ascii?Q?zNv+EYMq/iaB8CqgBD8UGoxB4OaHjIHrbWgsaOyUTuvlRUl6LOAwf5LxSVEg?=
 =?us-ascii?Q?lM5Ub96/xr19LebQNtBbMefy6Ds5mobkRbw426jai82cMkbdi7x17R6PXjwT?=
 =?us-ascii?Q?L1CtKNsrppyWILNAvWDrv97NeCTZzktkyzUeMwpViZDPzmGdwEYbwOakDCnu?=
 =?us-ascii?Q?OnS9lqWDZsA7H4o10bl1qsYsNNzlFi0oJFEici5jl8PWeG2K1LAZPpozh0ZH?=
 =?us-ascii?Q?Tx+puDZ1wDzuk0KBb9Qak1rciRSW7UTERB8N1R2vQWt3NJYZ4hKaGOMebIzY?=
 =?us-ascii?Q?6w/bGFb/Juzqy7vZjZ/B8m/Lifodbx1MrsC2T7SRRh3lZbE/FJSHHht2/Iyb?=
 =?us-ascii?Q?BLvyW52R9e6t7gD5yRnaXWKm/NV1hAD7fVLg5jG7evCECUhUGd9neHNy4llt?=
 =?us-ascii?Q?qhBJp20Nl0+5aEILN/lo9sbCo0NjzTri/Rc3HaW5CQPBMKdo7Az10ACRopWy?=
 =?us-ascii?Q?uB+ptT/lXHScpysZxeURrygbAJGSCaKnoSQTeLEfSwiATch3ma0UJJHgcCAz?=
 =?us-ascii?Q?PUCRe+AfVbgMsI6GvmiqyjGizU+HjpLomqJQAcXayhAmcO2h/U+uRIuPz2nI?=
 =?us-ascii?Q?ztvdBJHwp3SggyYaJnhSoZt+48YP7IDqS058i5DAY+IRGcWaz9Gyq9LqCJCZ?=
 =?us-ascii?Q?JoqhNXEPK+0Lqta/sCXQZSo6WPob4UhwyvDfeooJCPXsh3panMAH5kZcTRIK?=
 =?us-ascii?Q?07CST/io4UyoYILuypWnjAydD0TmmfdsxTzyIfuvK/mFoJnsOVCn3doEnWvH?=
 =?us-ascii?Q?Ok861p/SFyv68kiLQqCsFyOgeoSG5cUhLEXmjnkzN5cp+/wXHG81IgpshkIM?=
 =?us-ascii?Q?zWPMzTTIwyd8Wc6ZB7ML+ERQR4CtvUiIJk9BGgcjgIzIJG7MelT82EDgwGUo?=
 =?us-ascii?Q?ETIWr7nDg0DkJ1wAfmfct6qmK+7rMe0G8Abz/gqnft954rUrrOXhQAKLi5Nu?=
 =?us-ascii?Q?ZuZuyGZ1XmSy4wJosaSqvPIG0RJWs4ISs2JrDK2KhME4Q+TYEWPKDRncoLbt?=
 =?us-ascii?Q?OBUydEEZIItdgnjG/EqR1670Rznd6Pgx9RhRP6jme3rNSIUw8Xuqxr4arpRa?=
 =?us-ascii?Q?rRW6TnmEXLWSSniDjE3hjTil5TCN5NPiHKZ8MzlTjLWDsdF1TTOZELuIeHCW?=
 =?us-ascii?Q?IKCn0w7auVKBy2lAtbZQn98eXXF5FulUXMHN2ECdX49GIEB0GR4mwA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afa402fb-a5aa-49d3-0fec-08da0d112027
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2022 21:07:23.2632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dBdW9NnyCXKsRs8N9RxABBpE4fvjTN5Ri2cQtZbr+2T1s3BKl1Stjww8ijQBQ25jmeVPzCrabS5VIVxWSSx9bPp+NXQWo3XbIUu09JBwghg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4744
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10295 signatures=694973
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203230111
X-Proofpoint-ORIG-GUID: vWTm-8uHoN7JOOlgZ7l3Of9pDx71kg0H
X-Proofpoint-GUID: vWTm-8uHoN7JOOlgZ7l3Of9pDx71kg0H
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If the first operation in a string of defer ops has no intents,
then there is no reason to commit it before running the first call
to xfs_defer_finish_one(). This allows the defer ops to be used
effectively for non-intent based operations without requiring an
unnecessary extra transaction commit when first called.

This fixes a regression in per-attribute modification transaction
count when delayed attributes are not being used.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 6dac8d6b8c21..5b3f3a7f1f65 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -510,9 +510,16 @@ xfs_defer_finish_noroll(
 		xfs_defer_create_intents(*tp);
 		list_splice_init(&(*tp)->t_dfops, &dop_pending);
 
-		error = xfs_defer_trans_roll(tp);
-		if (error)
-			goto out_shutdown;
+		/*
+		 * We must ensure the transaction is clean before we try to
+		 * finish the next deferred item by committing logged intent
+		 * items and anything else that dirtied the transaction.
+		 */
+		if ((*tp)->t_flags & XFS_TRANS_DIRTY) {
+			error = xfs_defer_trans_roll(tp);
+			if (error)
+				goto out_shutdown;
+		}
 
 		/* Possibly relog intent items to keep the log moving. */
 		error = xfs_defer_relog(tp, &dop_pending);
-- 
2.25.1

