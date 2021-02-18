Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C9A2C433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:47:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF8FC61606
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:47:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbhBRSr2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:47:28 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:36112 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233141AbhBRQrm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:42 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGU1dx040639
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:46:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=9Url4ta9tfuxit+eSD2Pa8w3hRRVBAcMc52wH5vavT4=;
 b=Xvnt3OMLGLZuP+ZTIWkqAEkf5eqNxAz82V6oX99/NgQwMKNjavkZX2A6hzsmFIFRZ9hb
 LJl5byFQM9PINMpG2ppUIhibowZjjQ7f9cP1Dju/v/AcF1ufeIZmQYhVpPoaSSTYNuI1
 y6jnZ9MYpQZ2R6bE+LsKMiqxboYo5NqwGWwarvdNIh5LMzRLPLbJ/QYE9UMkaqGRHKz9
 4SJ7hR7wi9CM2jvTboJ+lp3b+ATYxtuMbLi2JX4rm44yD/5j6lhtZp4botQRwNn07DwN
 FODsCzgjmOVy42Xhi902nrnCv87BaVLE3s14BULoifYCl4X396teVKGSwNdy/qhAFGQz zg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36pd9ae3m7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:46:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUHUI067709
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:46:21 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by aserp3020.oracle.com with ESMTP id 36prp1rkps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:46:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i+JOzDxozQP46qPtDDqVXj/fq2UZIfc1uJagp7daI7+3gisam9kNDSAybjJo2v3bjxskaOrGO8+RoDkAiCHKgPBerjTMM/o66mCUzIuX/S0cYamOghgFLKEyh54VhCNHOn7eAop/RBftLDRFfFkSaCbJhbv8LmJF35+sdDUgPXg2CklsV5k/XjPzbE2oo3AFaEbBkjkNn9z9Z98Ym2aqytU24lU47+sl3gUCRTmDnX9VfMSmdIORtM5hudQTc2TAJc9HC0EkP8yICnBVYHw1YzePdHwvFZHKsZLhTpzgxd9zN0BCLjljw8G1EljLiR7HmvXIFi7BFbt1ZMcCuGxSHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Url4ta9tfuxit+eSD2Pa8w3hRRVBAcMc52wH5vavT4=;
 b=L5onZFCI7DFfGzsyBxIHskoiJXTbJ2a2sgRs+u4B8gGSvd7rQov0CQRfQCJJHKsiQ//SRWTajERa2qXndJpLPIcODVQs27qTWl1REyO+Y4zx2dQwOMYeDhvzBHBTq793wEf66dIDMOmt6Stsdvhm/MWZTwcId52dQot2bCiaLLAB5GRPjcKhSZJOD3boDXoB2SQukaDJEw7qX/ePTUmmSAy8Odw8DD9Tx+Bu8gSMfozqfRV7FeKmLRSxS+SQ/w6bimPdyxuEf3H5MbJFSQuLnD9ewyS+Jhr9Uxg5yDB7Ou1/CQ/Kb1zi1Vw80VIQ77qirhcxXzP+Hn+2JMSfwx+Llw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Url4ta9tfuxit+eSD2Pa8w3hRRVBAcMc52wH5vavT4=;
 b=SIU6xcRthZ9ehqLhVFWWL7fkgLpJKjFcKhktQKh7OsGIgFdx8+6tYsb5BEr8NtCDTzIgYvBXFnDVpKbihxxZlMHT9CdSSEn5+PdQBeuIvTaWU+pSbhMX/3HvDrmzkhx6TKnfRR2/so1ManvwhvoipgK/LpCcN21ZFWdG6u7KTdg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2965.namprd10.prod.outlook.com (2603:10b6:a03:90::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 18 Feb
 2021 16:46:16 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:46:16 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 34/37] xfsprogs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
Date:   Thu, 18 Feb 2021 09:45:09 -0700
Message-Id: <20210218164512.4659-35-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218164512.4659-1-allison.henderson@oracle.com>
References: <20210218164512.4659-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR11CA0088.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32df4500-a3ee-4889-cf05-08d8d42ca3e4
X-MS-TrafficTypeDiagnostic: BYAPR10MB2965:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2965E388C05AC3347F100C4B95859@BYAPR10MB2965.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: csfolz3QI2+22M8lPiDK21Sp945PV1Xc53q1pBLNNVObhH+p2EkDN1PzfLkYYb/fc94+qiEnd4A/HztX0baeQGBhNIrku4VskZUe1l6WTCFYtv05YxsKQhE5hVvvOI1QZ6eVmhgXYN0OxN5LbkSWBqhQtnqCjEalSIHuOuBHoS+ptuOIXDqfwQFEsIpN+MfXXuThv3HXCoMP2COAKfY5l+jiVwBnu7zx42A4cGv5Bv6WHhDbYWuKVCqFZpDadSMKazHYjHSU2nK+5a5qRJmX1TH9ccGEXRkvSrowMih2IFJOTHXLC7x8/i+VsBo7a/rOHXFU1BlEyrtRseUzQj2cDbDlk+tCt4BvMnDyzIIACNwvC/ge30DTVzqAKsDwv4PHuMTff1jvSbw1gpLL8NYkwJ5J+jZLPsn4Uhf0f1od4pIISXK1dGSPy12UYi0hp09WFemHLj885fL1b7u4D0xaUIqTWa/URd9a10bFrOlCizj6v6vtSkvCW3d9Kczulp1U0aTL79vkEStYuiqlInqX6E1wJimleGm6THLEP343oHBX+DeaYNnz/4XZPLs6HzJ+JXjpBAEsbXqx33DezWI7RA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(136003)(39860400002)(366004)(6512007)(86362001)(69590400012)(36756003)(83380400001)(6916009)(66556008)(8936002)(66476007)(66946007)(478600001)(52116002)(6666004)(6506007)(316002)(44832011)(16526019)(6486002)(1076003)(5660300002)(26005)(2906002)(186003)(2616005)(956004)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zdKrQInsGvc3FbXtos63TtI3Bw8ZdDELYzZz28XTsX/TXjtDealkyr6pBhcF?=
 =?us-ascii?Q?cxEsArUt81BzrgYN4XnWPumKTBNuFEwRNd1911wqu6N7W4/zf1gRBUiPh5Pw?=
 =?us-ascii?Q?Er1zy2xyKmSFpMoSDQkwW+HHRM7z60AkEJD4fCJkvjAFbbIbH9b84hiNhTRE?=
 =?us-ascii?Q?Jy+M7hYWFJBnDA4XK/E3aQS/d9IbTP4DIXo4fB0gglThFyN58Ybi1ZgUwHHG?=
 =?us-ascii?Q?dj74UGZrY/n9QE9PJjEXFOTVfgzcobtyAxC5TZrWq/jh39u/okqNob7xkqwG?=
 =?us-ascii?Q?Mm+pxSiWAZCz2t4fgZr9r1O3oX3GYCz0TdfWfWZUZo5nArNlONsXJz3hKuhv?=
 =?us-ascii?Q?/Amh6pX8hCfL87xT+dQrKsaPYV4mL5yokxWr7dPW7uqddzE75otQMRORHNDB?=
 =?us-ascii?Q?3zmO5E2QqJnPuBMGG7T3fR1jLnwXuTD5/uLLG3pNshWfWmDCRPie7ZZDh79c?=
 =?us-ascii?Q?F8MKGEPbS/xASo8LGOpvS85ZpmHXdC1xNziaGbyuco0sXN7yK+/yuN2TRMn3?=
 =?us-ascii?Q?Xu7XWMpOW49IqNTknGnrXo4va2SDXxMVNTPRSKtUbMYXE4XyH4Lhyc/BGkZc?=
 =?us-ascii?Q?aqbWUImQ3KnGl/CxBDIysdJqmpZe75eKM5Q7F0lwOskM+1GZZ1C0mHc8//Fp?=
 =?us-ascii?Q?8SVJZcPRl/TY67BOHQRodSXDvR2AoQAks9r+CU6i60VyPVHbHaHR++gWn2IC?=
 =?us-ascii?Q?IeGAgpI5m+Wk++DheOjTpuOGR40iBwsoFSIi8Cn1lAeWbczvNNaQBiaPeWC8?=
 =?us-ascii?Q?3Nf0YIfdweEQD5dxLa4BoNEkQGB0/QnfYpUYG+vWwuJvcim/E7tJYqrhzXY3?=
 =?us-ascii?Q?8DGLvTjCyF6XG2ZlRufaPJUiOKskX1xeooagn+ha2fL+40KgDWq5Kkm3FSnE?=
 =?us-ascii?Q?30QFnImn3Y808czS6vsud1rglyjzLoi1CK8xwiOOFVLiTjuXLgDz0evvNy/+?=
 =?us-ascii?Q?dUR4lHjKAzOy4/tGuYltpN7Pom+ePad1fMVIGT7TLb0EnLw3HdB6txw4sYCh?=
 =?us-ascii?Q?RQz9J7Z4VSVW4RuCK0phU5BEpa3zTHy5vkgnsK1z1HAf+gnUcu33seTiHH7M?=
 =?us-ascii?Q?2TsDhfV0QexI63ZCM8uwp5elS1H21/OJAkN2+W4zy+go1Ia6qXKOWy0n+wov?=
 =?us-ascii?Q?++Meq/fvjJWRIgXp0v98uKphj9e4DDAxJ2irEzYrKdTVBewM85xSt7Ci/ssY?=
 =?us-ascii?Q?G147al8MPxY4aqdSmiaPwqgeILn9wKJQhKZy97dLVndM/n+y/WBUElB0BTN2?=
 =?us-ascii?Q?ff63dCz9t+eDFHRDJz7rim9IISNvrFvIvdAxXfwGxSQ+m6phSlghVT2QeO2Q?=
 =?us-ascii?Q?ddnXNdoxfoi4Q6vfFQJniu30?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32df4500-a3ee-4889-cf05-08d8d42ca3e4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:46.7450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8A1jPO9VAQn05YHLMMdbybVYxCJFFcwlPzJnec/e9RlDx3yktRYWD0NGX1ijMt3AvlsyX1ZYyjL2JQkds6pdOKq1p/pWD7xvn4h74TUW2HE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2965
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Collins <allison.henderson@oracle.com>

These routines to set up and start a new deferred attribute operations.
These functions are meant to be called by any routine needing to
initiate a deferred attribute operation as opposed to the existing
inline operations. New helper function xfs_attr_item_init also added.

Finally enable delayed attributes in xfs_attr_set and xfs_attr_remove.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 libxfs/xfs_attr.h |  2 ++
 2 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 3f81b3e..e01ed6f 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -851,9 +851,10 @@ xfs_attr_set(
 		if (error != -ENOATTR && error != -EEXIST)
 			goto out_trans_cancel;
 
-		error = xfs_attr_set_args(args);
+		error = xfs_attr_set_deferred(args);
 		if (error)
 			goto out_trans_cancel;
+
 		/* shortform attribute has already been committed */
 		if (!args->trans)
 			goto out_unlock;
@@ -862,7 +863,7 @@ xfs_attr_set(
 		if (error != -EEXIST)
 			goto out_trans_cancel;
 
-		error = xfs_attr_remove_args(args);
+		error = xfs_attr_remove_deferred(args);
 		if (error)
 			goto out_trans_cancel;
 	}
@@ -892,6 +893,58 @@ out_trans_cancel:
 	goto out_unlock;
 }
 
+STATIC int
+xfs_attr_item_init(
+	struct xfs_da_args	*args,
+	unsigned int		op_flags,	/* op flag (set or remove) */
+	struct xfs_attr_item	**attr)		/* new xfs_attr_item */
+{
+
+	struct xfs_attr_item	*new;
+
+	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
+	new->xattri_op_flags = op_flags;
+	new->xattri_dac.da_args = args;
+
+	*attr = new;
+	return 0;
+}
+
+/* Sets an attribute for an inode as a deferred operation */
+int
+xfs_attr_set_deferred(
+	struct xfs_da_args	*args)
+{
+	struct xfs_attr_item	*new;
+	int			error = 0;
+
+	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_SET, &new);
+	if (error)
+		return error;
+
+	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+
+	return 0;
+}
+
+/* Removes an attribute for an inode as a deferred operation */
+int
+xfs_attr_remove_deferred(
+	struct xfs_da_args	*args)
+{
+
+	struct xfs_attr_item	*new;
+	int			error;
+
+	error  = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REMOVE, &new);
+	if (error)
+		return error;
+
+	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+
+	return 0;
+}
+
 /*========================================================================
  * External routines when attribute list is inside the inode
  *========================================================================*/
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index ee79763..4abf02c 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -462,5 +462,7 @@ bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
 			      struct xfs_da_args *args);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
+int xfs_attr_set_deferred(struct xfs_da_args *args);
+int xfs_attr_remove_deferred(struct xfs_da_args *args);
 
 #endif	/* __XFS_ATTR_H__ */
-- 
2.7.4

