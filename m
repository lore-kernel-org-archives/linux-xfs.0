Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71ABEC433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 21:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbiKJVG4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbiKJVGz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 16:06:55 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C572DC14
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 13:06:54 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAL0cej006976
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=xDf0f5pP6kvwq/eCO2W5L0ZQLetjUmbOMF5E14q1TK0=;
 b=lZBEoNH/kk4aYwmeXDF9nDCVG1vNJAr/i8GIazjwdELIXm2jdzeL6Lki9t1N1/kAHfGj
 eI3qaJrN3A9Tc6U+EE7S2lWB6xKrmR6uSbCwzTUIS/perbOvF8Jo31mALyNAhcNXnysp
 ycOTFtQegEgWkzMrhLmG8qYYq9ImMkOEf4ycRYs8dkEANFoxz6YA8YH4ufhgAYzCi1l8
 Q+tWYQaYfBKh1nNFVbBuUioX4YYwllYD2od3HnXkhVryzvBsLbetVgDLgmnY0xQjpEKa
 p+ThdM60nkXuqgNOSHbQtt4dnDoiUn2ktQdq6H8Mgi7yGXHmKU52RhMOMzc0oOhqvrBz tg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks8u5r1be-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:42 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAKWeUV038125
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:13 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcsh4g43-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IIPGgG/9fFm0i0l7ibckhJspKmlznKvUpuTBDSsHRkXc69P8EsiM8ySqK8sOQhI/6vjZiuqt3Fkv/jktF4OTH9rsuwYRPvfgnSa3s9DdtxZlc0LHseCGbWfaifHtBHmIGVZ6mPqr2MlTopnIMYzvKjUg4+ch3XRjVwB8Jp7u68Fpu8ZA6L4zIdWS77q+XYGiAVuHv4rDu/lLUJ0faIW8oJwOqZ/wfmr+qIJueZo2x7u4sATzBqt+iTIwHhVp2p8B2CRgZY5IjaWYuDYySaIRtZezMKa7KWJ1fBtFE4VHrNTG1ajHMjWxgFkYvGmtTETsRsr7UnbjbXyU7m6kOOuaEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xDf0f5pP6kvwq/eCO2W5L0ZQLetjUmbOMF5E14q1TK0=;
 b=Ifqb2+E0Y28+4Itb8VW5xIPy/dUOns3pRtW4o6pOzeyzS7kWk+rORoRt3cKWE+e7CB4jqqju88ggAsEiRiU6Mso/2B41nDj2LFhOXwX6LuB9AgrgoINadiP2pjje84tsQvvPWBE7lJXgU+oFJgGpwjlhCRcxo5wRSm0zr1EOkbI9Ur4MYBB6pgLsDzWLANMVZGC92F+TVmqhqF3oZbXPGcaq2mewO7B1fIXJAYWGmjg3FpPqL4zMW0yqBe+wQu4x6uD2oD+FSjyh0IABWBLYXA4Wf4mo5IZ1sFr6PXAks+qVjlt8NGMPae+48YZ0OoWyPjrR1uosI0aSlOOEmAT9iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xDf0f5pP6kvwq/eCO2W5L0ZQLetjUmbOMF5E14q1TK0=;
 b=cYS2Db3g/ArDtpYO4xE+zsdEGgaWUKj2rkhXt9PW+Q0+TnjuaFS2nth1n4ofWbKQftmLLotoc+rZi38+xEp+G42miDQAcmZsBWXvDH+kUmXhyGGKZOPDon45QGunNAmrFEGvROnWjxDRJ01wyv3jYfQdcVi8ubzY/k5zYNAEOnA=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH8PR10MB6527.namprd10.prod.outlook.com (2603:10b6:510:229::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 10 Nov
 2022 21:06:12 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 21:06:12 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 22/25] xfsprogs: Print pptrs in ATTRI items
Date:   Thu, 10 Nov 2022 14:05:24 -0700
Message-Id: <20221110210527.56628-23-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110210527.56628-1-allison.henderson@oracle.com>
References: <20221110210527.56628-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0027.prod.exchangelabs.com (2603:10b6:a02:80::40)
 To BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH8PR10MB6527:EE_
X-MS-Office365-Filtering-Correlation-Id: 929ffd8c-12d5-42be-2a10-08dac35f6592
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pfdv8VLRlt6U/Vdxs1GnKQ4pPHGDXQynd6BxacmxqnTc/jmBSkFvfzC/pSjXX6vdj0Kf+zc+SA9N9KMNQsBoenJSkkInR96nqIkRgfFsi36rQLM+mR5Bb8TS0hEZQ30JKnHliencEMi2uofW7sPXmQ7afWXelpP+K5a2fgjBZPabC2VXOoNWmIdXfuZtR+3unFn+OgUg2d6Pa2kHiQTZtQCqR5knSE6yOHypiahvWN7drBBSwIw3gqcuw784PcX9dEoLHo5YKM1si3tC+CBDF5q8Yfh4FQf27l+4RG0b0hGLHWyM78VI+Uu+UPtFsX70mjRJu4uKJV/dytxKm8qOGlAiB5b/ndDNf4c+/HLMCa2iX4+E2vNRdX4wgROtf+w0h1sNOR0v6lWvlznbLOM8RNpHe9DY7gzJ+MYpE8di9nkCofyxlSdzkPqMfq8xCA230l9e+pvEVTAz/9nAe/Ve74RQhY5gnuSjpCMnidFlxM/BxUJO0AjTVaP+EY31umiAUrDvBm9iGBGH3pHPrWeBify0VGfjIx1SqMKyA305vIxIloDon2ooaNQdbDKrgH21axzdYjgMfvZ53vdIFNY4348MfBy2oDQZ+D7SKQtS+LGUX+i3Tl6obUPaBF0iJKvgz1EvTOZEIKnfmg7hXpXtHLl7ccYmYbJl95NfnAF3+d/LwLgmwZer7Zt2o3dB8BQVYt2WhP5jXiYV8HIbILKHAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(136003)(39860400002)(451199015)(1076003)(186003)(83380400001)(2616005)(478600001)(6486002)(6506007)(9686003)(26005)(6512007)(6666004)(86362001)(38100700002)(2906002)(66946007)(66556008)(66476007)(8676002)(41300700001)(8936002)(6916009)(5660300002)(316002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gib9Dz8bXKndWycmsLAzCz3Kji5y8ltkCdPhVSrQltcuH7jkSBQd2/m+wdze?=
 =?us-ascii?Q?tC0UOy+Xh4nqebT7YDkQTG5nCZB/FhMBcBUb19sPKdCUG7nyws7eAUyukywl?=
 =?us-ascii?Q?BOhNDpfPs1oHKP1n2gr3Ob7ECxLiXUUeTheTzEURxdkBJXO61LV+2yQgd3k0?=
 =?us-ascii?Q?jYstHSlgwsvc1nwoHuCJGmMyIutETFOeLz5imCpMahxQE2bgcBs/CfBrf30E?=
 =?us-ascii?Q?YTxH7r13XiapGDhyofdloFAMgfAFm2GnnZEDMmoiZSUOlzNsjLgJmFGHI6gm?=
 =?us-ascii?Q?MlbsmXjYYtdjecMDXRgnKp7+w5zfW1sz/uzqyYx+xPm9m6Qaoe+x5FRAbBCN?=
 =?us-ascii?Q?ui38jBBsy+8bkaOtB/ZJnjzMsmbvSmjcC87uYrRYZl3vBwPlwYHJylfjS+XC?=
 =?us-ascii?Q?3rZXFbsHGfCr5Z4j9DzFfp/g2GzMAq3/FZVuBH4aebXWJVTKze21w5u2kuaE?=
 =?us-ascii?Q?YKzdzm1jzZPhuvJYJYn/NzbSFh9Ksb+nxj3Rlybysys2KKuaIt6v7RneL5sp?=
 =?us-ascii?Q?LGwoBaqYusbpuToQd7U2BX+EAr8DWqT9EPBspZ4WmG4oaW57GfCQinAxM+YS?=
 =?us-ascii?Q?pepbKV2dpoaZKSuEvUYMj1l9/YoMKYslbgBU8fk0HFCAOtsn+5zimh+vQkC1?=
 =?us-ascii?Q?OqNfY04HdiQ6qBw8TpIfSJyegpkt4j6wZU14GGZrPT4bAl/d/5LDihnPGH80?=
 =?us-ascii?Q?4DPD7CCqer0cfC9hsSNn9MAfOZq/hPtdr2awwA1HXzzEfUdoJID7rADMOlpq?=
 =?us-ascii?Q?C5REeV9fZbifawgDjIg8Hsqf+06Q3YEeteP9UqQ7ddc9jS4iJBivjhSxcy4e?=
 =?us-ascii?Q?Ypi7U+Qv43xB9c0NdBiuNtq7vuzoPFDzRT8gARbwulj4HYq2//CB2C5QG08w?=
 =?us-ascii?Q?ZWsp/EchppZLHh/pVJmjkzCIa8eVWtY5lVM3n9z386A1sXsERjGvTVWgshXm?=
 =?us-ascii?Q?77UOuAVXHu4t0m/Auq0bdlf6N2mmcXA2QXfdnr/bbgYCCABnmXSeTKDSBAMz?=
 =?us-ascii?Q?KtxwhT/jv0Bfr/icpDEnhmZVzzpTr60PHrwZZy6Cze1Ei9LfqI8DYz9Y22Ym?=
 =?us-ascii?Q?8Z7WYfqWEmX+POaOLTKF32jq6kuJpsqEWdRMfFT1bQ90WBMICm7y3wbCXVYw?=
 =?us-ascii?Q?zNKOvJcr5kI0puy4akfVE65DX2SCWUANlx0Ns4lZcYDcIr82uah8Iq9tZzjt?=
 =?us-ascii?Q?SNmMt8025ACkZlFkPrzExoaENtaSY+bzLf3QFFUbVbfEc2YPvFoBYNHTOOfQ?=
 =?us-ascii?Q?ddYRJJ2mWXhDDgfomgh9n0hkxLv8SauvWlMdDEgxtilchPWCA7lEjkXBxB6K?=
 =?us-ascii?Q?h6J4pNaFr0XrcfRbDKpowRFxun244ecSjyvRhJazvP51wi3cyQG/UjDNMXou?=
 =?us-ascii?Q?85rYPEq15AfqxzO5y7aIh97lxYu76MA0VQ2EoQAcBvZpJW83fQGLCmO1zlDW?=
 =?us-ascii?Q?kt0F4R0K916SjN2SLBhdzXM2giceTNXIkcKxID7L85jylqxU7MPtwdIi6xd6?=
 =?us-ascii?Q?SmMLD66VQJ7eZcHCOm1g2TyCQti/MwOw/IF3eZhuh4gaX5I7a3EyRyAIWiD3?=
 =?us-ascii?Q?xoU5/nV5W9nR8LbqwW1PWYswmpPgZVpKJUWZOYQHALi8/R0sYNqBeYe3SkY8?=
 =?us-ascii?Q?+Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 929ffd8c-12d5-42be-2a10-08dac35f6592
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 21:06:12.0514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uPwNoRJhLwf57+0cw0kvMcfCSaTTCpbh7e3yIjhNHxTa4qgLSQc0sR47LtpdOp1HrKCI7Dc2Nj51ZraNDeHiGA/m3ADqHPwzvsWn6XMeLw8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6527
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100148
X-Proofpoint-ORIG-GUID: BuKIWn5_lacYNhEXneD2ke_u_mrxXQBa
X-Proofpoint-GUID: BuKIWn5_lacYNhEXneD2ke_u_mrxXQBa
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch modifies the ATTRI print routines to look for the parent pointer flag,
and print the log entry name as a parent pointer name record.  Values are printed as
strings since they contain the file name.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 logprint/log_redo.c | 191 ++++++++++++++++++++++++++++++++++++++------
 logprint/logprint.h |   5 +-
 2 files changed, 171 insertions(+), 25 deletions(-)

diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index 65d365d8f02f..015df0bf02f2 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -674,6 +674,31 @@ xfs_attri_copy_log_format(
 	return 1;
 }
 
+/* iovec length must be 32-bit aligned */
+static inline size_t ATTR_NVEC_SIZE(size_t size)
+{
+	return round_up(size, sizeof(int32_t));
+}
+
+static int
+xfs_attri_copy_name_format(
+	char                            *buf,
+	uint                            len,
+	struct xfs_parent_name_rec     *dst_attri_fmt)
+{
+	uint dst_len = ATTR_NVEC_SIZE(sizeof(struct xfs_parent_name_rec));
+
+	if (len == dst_len) {
+		memcpy((char *)dst_attri_fmt, buf, len);
+		return 0;
+	}
+
+	fprintf(stderr, _("%s: bad size of attri name format: %u; expected %u\n"),
+		progname, len, dst_len);
+
+	return 1;
+}
+
 int
 xlog_print_trans_attri(
 	char				**ptr,
@@ -714,7 +739,8 @@ xlog_print_trans_attri(
 		(*i)++;
 		head = (xlog_op_header_t *)*ptr;
 		xlog_print_op_header(head, *i, ptr);
-		error = xlog_print_trans_attri_name(ptr, be32_to_cpu(head->oh_len));
+		error = xlog_print_trans_attri_name(ptr, be32_to_cpu(head->oh_len),
+						    src_f->alfi_attr_filter);
 		if (error)
 			goto error;
 	}
@@ -724,7 +750,8 @@ xlog_print_trans_attri(
 		(*i)++;
 		head = (xlog_op_header_t *)*ptr;
 		xlog_print_op_header(head, *i, ptr);
-		error = xlog_print_trans_attri_name(ptr, be32_to_cpu(head->oh_len));
+		error = xlog_print_trans_attri_name(ptr, be32_to_cpu(head->oh_len),
+						    src_f->alfi_attr_filter);
 		if (error)
 			goto error;
 	}
@@ -735,7 +762,7 @@ xlog_print_trans_attri(
 		head = (xlog_op_header_t *)*ptr;
 		xlog_print_op_header(head, *i, ptr);
 		error = xlog_print_trans_attri_value(ptr, be32_to_cpu(head->oh_len),
-				src_f->alfi_value_len);
+				src_f->alfi_value_len, src_f->alfi_attr_filter);
 	}
 error:
 	free(src_f);
@@ -746,13 +773,45 @@ error:
 int
 xlog_print_trans_attri_name(
 	char				**ptr,
-	uint				src_len)
+	uint				src_len,
+	uint				attr_flags)
 {
-	printf(_("ATTRI:  name len:%u\n"), src_len);
-	print_or_dump(*ptr, src_len);
+	struct xfs_parent_name_rec	*src_f = NULL;
+	uint				dst_len;
 
-	*ptr += src_len;
+	/*
+	 * If this is not a parent pointer, just do a bin dump
+	 */
+	if (!(attr_flags & XFS_ATTR_PARENT)) {
+		printf(_("ATTRI:  name len:%u\n"), src_len);
+		print_or_dump(*ptr, src_len);
+		goto out;
+	}
+
+	dst_len	= ATTR_NVEC_SIZE(sizeof(struct xfs_parent_name_rec));
+	if (dst_len != src_len) {
+		fprintf(stderr, _("%s: bad size of attri name format: %u; expected %u\n"),
+			progname, src_len, dst_len);
+		return 1;
+	}
+
+	/*
+	 * memmove to ensure 8-byte alignment for the long longs in
+	 * xfs_parent_name_rec structure
+	 */
+	if ((src_f = (struct xfs_parent_name_rec *)malloc(src_len)) == NULL) {
+		fprintf(stderr, _("%s: xlog_print_trans_attri_name: malloc failed\n"), progname);
+		exit(1);
+	}
+	memmove((char*)src_f, *ptr, src_len);
+
+	printf(_("ATTRI:  #p_ino: %llu	p_gen: %u, p_diroffset: %u\n"),
+		be64_to_cpu(src_f->p_ino), be32_to_cpu(src_f->p_gen),
+				be32_to_cpu(src_f->p_diroffset));
 
+	free(src_f);
+out:
+	*ptr += src_len;
 	return 0;
 }	/* xlog_print_trans_attri */
 
@@ -760,15 +819,32 @@ int
 xlog_print_trans_attri_value(
 	char				**ptr,
 	uint				src_len,
-	int				value_len)
+	int				value_len,
+	uint				attr_flags)
 {
 	int len = min(value_len, src_len);
+	char				*f = NULL;
 
-	printf(_("ATTRI:  value len:%u\n"), value_len);
-	print_or_dump(*ptr, len);
+	/*
+	 * If this is not a parent pointer, just do a bin dump
+	 */
+	if (!(attr_flags & XFS_ATTR_PARENT)) {
+		printf(_("ATTRI:  value len:%u\n"), value_len);
+		print_or_dump(*ptr, min(len, MAX_ATTR_VAL_PRINT));
+		goto out;
+	}
 
-	*ptr += src_len;
+	if ((f = (char *)malloc(src_len)) == NULL) {
+		fprintf(stderr, _("%s: xlog_print_trans_attri: malloc failed\n"), progname);
+		exit(1);
+	}
+
+	memcpy(f, *ptr, value_len);
+	printf(_("ATTRI:  value: %.*s\n"), value_len, f);
 
+	free(f);
+out:
+	*ptr += src_len;
 	return 0;
 }	/* xlog_print_trans_attri_value */
 
@@ -779,6 +855,9 @@ xlog_recover_print_attri(
 	struct xfs_attri_log_format	*f, *src_f = NULL;
 	uint				src_len, dst_len;
 
+	struct xfs_parent_name_rec 	*rec, *src_rec = NULL;
+	char				*value, *src_value = NULL;
+
 	int				region = 0;
 
 	src_f = (struct xfs_attri_log_format *)item->ri_buf[0].i_addr;
@@ -803,27 +882,93 @@ xlog_recover_print_attri(
 
 	if (f->alfi_name_len > 0) {
 		region++;
-		printf(_("ATTRI:  name len:%u\n"), f->alfi_name_len);
-		print_or_dump((char *)item->ri_buf[region].i_addr,
-			       f->alfi_name_len);
+
+		if (f->alfi_attr_filter & XFS_ATTR_PARENT) {
+			src_rec = (struct xfs_parent_name_rec *)item->ri_buf[region].i_addr;
+			src_len = item->ri_buf[region].i_len;
+
+			dst_len = ATTR_NVEC_SIZE(sizeof(struct xfs_parent_name_rec));
+
+			if ((rec = ((struct xfs_parent_name_rec *)malloc(dst_len))) == NULL) {
+				fprintf(stderr, _("%s: xlog_recover_print_attri: malloc failed\n"),
+					progname);
+				exit(1);
+			}
+			if (xfs_attri_copy_name_format((char *)src_rec, src_len, rec)) {
+				goto out;
+			}
+
+			printf(_("ATTRI:  #inode: %llu     gen: %u, offset: %u\n"),
+				be64_to_cpu(rec->p_ino), be32_to_cpu(rec->p_gen),
+				be32_to_cpu(rec->p_diroffset));
+
+			free(rec);
+		}
+		else {
+			printf(_("ATTRI:  name len:%u\n"), f->alfi_name_len);
+			print_or_dump((char *)item->ri_buf[region].i_addr,
+					f->alfi_name_len);
+		}
 	}
 
 	if (f->alfi_nname_len > 0) {
 		region++;
-		printf(_("ATTRI:  nname len:%u\n"), f->alfi_nname_len);
-		print_or_dump((char *)item->ri_buf[region].i_addr,
-			       f->alfi_nname_len);
+
+		if (f->alfi_attr_filter & XFS_ATTR_PARENT) {
+			src_rec = (struct xfs_parent_name_rec *)item->ri_buf[region].i_addr;
+			src_len = item->ri_buf[region].i_len;
+
+			dst_len = ATTR_NVEC_SIZE(sizeof(struct xfs_parent_name_rec));
+
+			if ((rec = ((struct xfs_parent_name_rec *)malloc(dst_len))) == NULL) {
+				fprintf(stderr, _("%s: xlog_recover_print_attri: malloc failed\n"),
+					progname);
+				exit(1);
+			}
+			if (xfs_attri_copy_name_format((char *)src_rec, src_len, rec)) {
+				goto out;
+			}
+
+			printf(_("ATTRI:  new #inode: %llu     gen: %u, offset: %u\n"),
+				be64_to_cpu(rec->p_ino), be32_to_cpu(rec->p_gen),
+				be32_to_cpu(rec->p_diroffset));
+
+			free(rec);
+		}
+		else {
+			printf(_("ATTRI:  nname len:%u\n"), f->alfi_nname_len);
+			print_or_dump((char *)item->ri_buf[region].i_addr,
+				       f->alfi_nname_len);
+		}
 	}
 
 	if (f->alfi_value_len > 0) {
-		int len = f->alfi_value_len;
+		region++;
 
-		if (len > MAX_ATTR_VAL_PRINT)
-			len = MAX_ATTR_VAL_PRINT;
+		if (f->alfi_attr_filter & XFS_ATTR_PARENT) {
+			src_value = (char *)item->ri_buf[region].i_addr;
 
-		region++;
-		printf(_("ATTRI:  value len:%u\n"), f->alfi_value_len);
-		print_or_dump((char *)item->ri_buf[region].i_addr, len);
+			if ((value = ((char *)malloc(f->alfi_value_len))) == NULL) {
+				fprintf(stderr, _("%s: xlog_recover_print_attri: malloc failed\n"),
+					progname);
+				exit(1);
+			}
+
+			memcpy((char *)value, (char *)src_value, f->alfi_value_len);
+			printf("ATTRI:  value: %.*s\n", f->alfi_value_len, value);
+
+			free(value);
+		}
+		else {
+			int len = f->alfi_value_len;
+
+			if (len > MAX_ATTR_VAL_PRINT)
+				len = MAX_ATTR_VAL_PRINT;
+
+			printf(_("ATTRI:  value len:%u\n"), f->alfi_value_len);
+			print_or_dump((char *)item->ri_buf[region].i_addr,
+					len);
+		}
 	}
 
 out:
diff --git a/logprint/logprint.h b/logprint/logprint.h
index b4479c240d94..b8e1c9328ce3 100644
--- a/logprint/logprint.h
+++ b/logprint/logprint.h
@@ -59,8 +59,9 @@ extern void xlog_recover_print_bud(struct xlog_recover_item *item);
 #define MAX_ATTR_VAL_PRINT	128
 
 extern int xlog_print_trans_attri(char **ptr, uint src_len, int *i);
-extern int xlog_print_trans_attri_name(char **ptr, uint src_len);
-extern int xlog_print_trans_attri_value(char **ptr, uint src_len, int value_len);
+extern int xlog_print_trans_attri_name(char **ptr, uint src_len, uint attr_flags);
+extern int xlog_print_trans_attri_value(char **ptr, uint src_len, int value_len,
+					uint attr_flags);
 extern void xlog_recover_print_attri(struct xlog_recover_item *item);
 extern int xlog_print_trans_attrd(char **ptr, uint len);
 extern void xlog_recover_print_attrd(struct xlog_recover_item *item);
-- 
2.25.1

