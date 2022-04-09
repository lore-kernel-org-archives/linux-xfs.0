Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3FDFC433F5
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Apr 2022 13:53:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242252AbiDINzV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Apr 2022 09:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236446AbiDINzU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Apr 2022 09:55:20 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D4224F0E
        for <linux-xfs@vger.kernel.org>; Sat,  9 Apr 2022 06:53:12 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2394Lwrm008887;
        Sat, 9 Apr 2022 13:53:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=dlZu2X/N9Ww0bAFq+V6bfr7Ve0mYKCVXffVsFd+hpTk=;
 b=ASv/nmYn1WxyBYcwrWKQh+OJkHIiEl2tfv5L7HDWG3vRlhsGGZtz7JHdzTnElRsw1dRq
 KTUG1HZTHusPn33jvKCNE+mm8ICpqfrrw0zKeeyEEB3i/GMlgombyJhHcg5OuTXkve7j
 6sHBIq8U5DXMOtelHdeHTtpGVE11Ms5lELnU4La3XTtl1oHNWgB2r2phltJxRyBc/+d4
 gvayNbtBlnBco+7qf87XZm63kNRUgnu2PaeMlRf3TuPqaQSPhNDlM5vW374VAVf6WZbO
 EYWrc+j1MiNyh3rNI1RuMrHCWBwpWYQmh0MfZaZdZ1dkVhWXv41OCCZ8dMrMaAS4d4QO lQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0x28hqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 Apr 2022 13:53:07 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 239DppEM013539;
        Sat, 9 Apr 2022 13:53:07 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fb0k0mbw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 Apr 2022 13:53:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EqPAYNPhWujK35n1NIY9WK3Tq/GOV3Ox/m9R0mBMitamgnW0g87uGiPXvaimqGW1iE0IvfS8das3gxHHzYpd/mOwUKzA1bELHkLgkYm94+PVA1lt1YqD1CWfqfISGBSNkunSeFxVLzkBlNpuKbVnaHna1QcZPNlBInhXzBUJs7LH6K6/tLvDg1oIbd8DfyRufKjnoawSfS/br7ptFqzap8eI/RK6NyC68OBeBPUYJACka5N4tQw8vdvnrIt0tO6fPPmS1AE8HEaFyMuWw9MSz5CbAjG8rna3LYeYOOGtdpOMpSTuXCHewbSVhaCYnwkcnPBMy+81KywKAfXBk98HGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dlZu2X/N9Ww0bAFq+V6bfr7Ve0mYKCVXffVsFd+hpTk=;
 b=kj4q+u0YPKCJvi6D7gS4/M7dQ+aDnwm5/xRNnq3TGejunDxmbAYHW+V6NzN4NRt/pU5re0V5R5HrQzYLspx/FN7R8SrB97r7zMu/e1alG9iLedNK16V5X+GudaqZTWNeLv2TU8m+JrC9TJkfCI5gcI7XX1TUThVQOy9TvgHbwTEvMueN2b9JG1upxqEB/N+avcxKYple85DTYic2XelafB6udzZOdofh+Dbxo1WfunRAYuB+u+u0eeFSzlPGYrPT+GSY68iR1HnMz4Q+qvRO9Rr2QZy/7U4h6yqMPfZYCfCwpGD3eqjSV9+IOmj6wABjhJDAyTnXYP6xJpRKcrdiJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dlZu2X/N9Ww0bAFq+V6bfr7Ve0mYKCVXffVsFd+hpTk=;
 b=r2wi0k1CAAmMI8f1ovK8PIDtbqUx49PpPDYjba0iSwBY2jd8WGLO+3t4keD8SXqMU4uBHz2vXZ/fweXxqsKGxOZgSL7YWMrcnwSsGX8IFHu31BKteUeuL8GyT9T35bUBDI+HUeOrRFvHPLX8CfJliHhSRJERuAV711H5d82os2k=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BY5PR10MB4194.namprd10.prod.outlook.com (2603:10b6:a03:20f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.26; Sat, 9 Apr
 2022 13:53:04 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d%8]) with mapi id 15.20.5144.027; Sat, 9 Apr 2022
 13:53:04 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, david@fromorbit.com, chandan.babu@oracle.com
Subject: [PATCH V9.1] xfs: Conditionally upgrade existing inodes to use large extent counters
Date:   Sat,  9 Apr 2022 19:22:51 +0530
Message-Id: <20220409135251.484686-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406061904.595597-17-chandan.babu@oracle.com>
References: <20220406061904.595597-17-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0028.apcprd02.prod.outlook.com
 (2603:1096:4:195::8) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2febf78c-26a7-4cd5-39ae-08da1a3044f9
X-MS-TrafficTypeDiagnostic: BY5PR10MB4194:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB41940C78D42D2FDABEC3B0DEF6E89@BY5PR10MB4194.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uwfs7fOacgPD6AKMOqInEyA4C7QtjE0SPtEKvmJqPLixOHCKpAXOyGQyCtg7XcibwMInFI5RhvsY1HIcryLRK5VZPPTvEEHonrlIgMvJACDKTqpoQwjn0qDob1qS6PkT+jAz8piigZxoy1wSZ2L7qjsv8AfMbQ4ma0IPictFn+7V9N7BaenmsgO3tn1PloTb/+C1Rit5StxwqNe9pSU8U4m3WEP+hdPdzpE5NEUNlRgXmPQNMbxq61UBj4i8eSrlOo731Pa2M+tvB8CF5AKya6kt2MBLWPmPcFfQ0hZbVotCOnDexygDy2Z7kRT6ibbTmR6Wz/6W5yVVyVwj/j1BMGMgLqimyG+pbAusOFq8kXhkc3C0iF+RZDK70qhpjdJq1XOvR38Tzhve23soPvhvAPTuDle90J6nbtNIK4XK0jL0bc4iIkFnKrzy9jFu+kzFaa+zCBdkclS/xjrN2zPYOaJyDVEcANRHXjNG/bxlbfY+ytlPG3Kk2/KxqEIOOhQSoR8I575T/ZcEgFxLxR8/hReB0TvJLObsIUrvcHXsDxSJrIV31/bTeFPFXxF+8yiiULU0/OLaKYNhj9Py5YxWQF9lZIr2sskFNRVdxh4SSKXAKMxKPIv9IXry+mnbg20GVoamw9C0xqSGxUr+r3Wb+VQ/mCm6OV3Oyxl8q2R56uEVAdJczpbgnshBYq3M+wKYg7H1kq8dSuC5Ggbwulrxdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(52116002)(5660300002)(6666004)(2906002)(6512007)(36756003)(83380400001)(508600001)(6916009)(8936002)(86362001)(316002)(26005)(186003)(66556008)(38100700002)(66476007)(6486002)(107886003)(4326008)(66946007)(38350700002)(8676002)(2616005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6Yrz4mhTYNPyuJwH+dVs49SiYmtWzPav/g88IF73jPAiBNMqHBc6Sif5e+MK?=
 =?us-ascii?Q?WKMcrZbytQIWvBaLoyyAxiwRr7y/l0dJJ5Qp/1Liil0K/GZ4ty9F0D412+qs?=
 =?us-ascii?Q?J70v36fI8Cu5f8WB/hv/YCYhk0OJtp1xqSRX4T8Ux/UBrdVZ20fyUVQT+L0a?=
 =?us-ascii?Q?d2F4ryoXBVJL62yPLYfgtj4sEWrk5dGMUza+B8jWXLS8lrIhvgVezXAu0Wxj?=
 =?us-ascii?Q?9ccUrik8qgxx46opxztMGbDPBC+yNaEK18Ru7jG73ktONuqeDoNmcY92Gwp4?=
 =?us-ascii?Q?+VoR3QYwQhL/bFUAX71jkr6q1JAR/qbzuZ0aARPajbh/Vm/c5yYrRaOmn3hr?=
 =?us-ascii?Q?1KeFVi6qoIYtC87YZeBQcjgcOu76M8SnDXcClm4wApacFxFldurFXOXIBpS3?=
 =?us-ascii?Q?Nt/B5wlNyDa/lk9mc/xFFdD8sA1bChq2isCtccLlbZ3Xk/8T5gKGPU6Gx46B?=
 =?us-ascii?Q?pNWALVlS9iipp1NUyXTAVOetgtlYI7L02dzd9zczZ36+YWl5xG5IxamG5AFG?=
 =?us-ascii?Q?cJ8otf/+zSi+LVl8zAZC4q6Yvrt74KAvbaUBWfRsC2G05bm79+6nLzcPLCcB?=
 =?us-ascii?Q?E61vFGUD64157izBDcNXlYofnlBvtX84MCB84QSxoCdn+f48h2OPwa52vxCB?=
 =?us-ascii?Q?5eoDfLM8HIEl6eOps62JPC0rrJK5QnixlPiOoR5W2913tRBpLd7xgyamEmJA?=
 =?us-ascii?Q?C5/LgX3mLVsCxLhTV3dvXvE2rCaPSgZSCxjzS90ta3QTXqq88Rd4ZkNXgOyW?=
 =?us-ascii?Q?SDCSUbSC3ZytIVU52n1Oj9q3H27UlUdIcUO4T6kUz86eejd/gLqcSUsO4sAp?=
 =?us-ascii?Q?fhyA1+Xn6fTVq45XiGXufxwIxLox7m8aaVDwu2ThZYpGay5NoTkjqIsJzOT0?=
 =?us-ascii?Q?+QhrGYoQiQmvMsuSU5cSZSFUDkwcNHITO73jeWHpmrncEFJQBWggMJfvzUf/?=
 =?us-ascii?Q?i5x3LFnxRWquXNG2TAMM9+VFW0nCIQgfnj9NFSZis1v2YX+kZjXWQKmaaBTG?=
 =?us-ascii?Q?Q66JhYm4iiPXysR3RDL1PFJP8jKtHisAgFq9DWRXV5CO8o8ErNCDZ/AcicWX?=
 =?us-ascii?Q?Et+t/RrIrlEFUfEL6QsRCpCs6+LNgM6TA8rIuMMO6KqFJiXvJyDReFJuoina?=
 =?us-ascii?Q?2ZRQGniYZ47EzZY9mEx+I2L2O01YP46Ep4W4sSgvmi1pO1XW5x2ku/JigImA?=
 =?us-ascii?Q?wP59kLTAEK6Dsh0phSuMKajzPv2SC+bF/RA9NzRhZT/jFBGLVhvliHBwBRs9?=
 =?us-ascii?Q?9AlOILGoTJxFWZbj0U5Yob8mYH76UHKpw6Zw+Lbl6r3Jp+iF6KvxdU86Qafb?=
 =?us-ascii?Q?7mCEzSwYpCxuFr9d3+yBj3IO/1MlTtjW8iHumCQqFIM/YCVoSDKT4seQeoFu?=
 =?us-ascii?Q?3/rdFjJIrYO98acVLH+reY4YLwm1ki/kK4vJxXZnCJFuAWmdZqYv40e8pwVT?=
 =?us-ascii?Q?s3NFck7KQ75a81R0N+CMrsBQwVKxXqBALgVuyduYtUbdsZLUK6osSQV7iZ1o?=
 =?us-ascii?Q?05Ky3rdW47sDTRkg7Dnz66bf+vOQYCwf10BAeJuArsCXx38bdWt1hZHdC9OZ?=
 =?us-ascii?Q?JdNata/fznOcjSnC/PN35/GtBMiYkZWngXlYQ+etaTUjMiHYufx2htg6Owxo?=
 =?us-ascii?Q?ord/pJlbVKXEGds3wmbxeKutknTYeS1lk9MFs+insRGL5x0HIiRZnnMdwQpX?=
 =?us-ascii?Q?5eCQkZwoCDGOAthqCCgV/GYkjYw3GP8Witwse1eTf/Glq4icSNvLgR9GAX6g?=
 =?us-ascii?Q?0CdVfUXPYQ8e8gQxBH1jcGHnmnJ/eX8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2febf78c-26a7-4cd5-39ae-08da1a3044f9
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2022 13:53:04.7263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZU7pZhHfXYVQH9x8+jgVsrQPzrGWNWH0eVRxkjwI7m/x/tJR/o5ZsJyfzwevU8/sXBLovhHB/QsYjw74PiNGTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4194
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-08_09:2022-04-08,2022-04-08 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204090093
X-Proofpoint-ORIG-GUID: YLcV7RUoCjPrXY9-D7uNWw-T8v99NvT7
X-Proofpoint-GUID: YLcV7RUoCjPrXY9-D7uNWw-T8v99NvT7
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit enables upgrading existing inodes to use large extent counters
provided that underlying filesystem's superblock has large extent counter
feature enabled.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c       |  3 +++
 fs/xfs/libxfs/xfs_bmap.c       |  6 ++++--
 fs/xfs/libxfs/xfs_format.h     | 11 +++++++++++
 fs/xfs/libxfs/xfs_inode_fork.c | 24 ++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_fork.h |  2 ++
 fs/xfs/xfs_bmap_item.c         |  2 ++
 fs/xfs/xfs_bmap_util.c         | 13 +++++++++++++
 fs/xfs/xfs_dquot.c             |  3 +++
 fs/xfs/xfs_iomap.c             |  5 +++++
 fs/xfs/xfs_reflink.c           |  5 +++++
 fs/xfs/xfs_rtalloc.c           |  3 +++
 11 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 23523b802539..2815cfbbae70 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -776,6 +776,9 @@ xfs_attr_set(
 	if (args->value || xfs_inode_hasattr(dp)) {
 		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
 				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
+		if (error == -EFBIG)
+			error = xfs_iext_count_upgrade(args->trans, dp,
+					XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
 		if (error)
 			goto out_trans_cancel;
 	}
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 4fab0c92ab70..82d5467ddf2c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4524,14 +4524,16 @@ xfs_bmapi_convert_delalloc(
 		return error;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
 
 	error = xfs_iext_count_may_overflow(ip, whichfork,
 			XFS_IEXT_ADD_NOSPLIT_CNT);
+	if (error == -EFBIG)
+		error = xfs_iext_count_upgrade(tp, ip,
+				XFS_IEXT_ADD_NOSPLIT_CNT);
 	if (error)
 		goto out_trans_cancel;
 
-	xfs_trans_ijoin(tp, ip, 0);
-
 	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &bma.icur, &bma.got) ||
 	    bma.got.br_startoff > offset_fsb) {
 		/*
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 43de892d0305..3beaa819b790 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -934,6 +934,17 @@ enum xfs_dinode_fmt {
 #define XFS_MAX_EXTCNT_DATA_FORK_SMALL	((xfs_extnum_t)((1ULL << 31) - 1))
 #define XFS_MAX_EXTCNT_ATTR_FORK_SMALL	((xfs_extnum_t)((1ULL << 15) - 1))
 
+/*
+ * When we upgrade an inode to the large extent counts, the maximum value by
+ * which the extent count can increase is bound by the change in size of the
+ * on-disk field. No upgrade operation should ever be adding more than a few
+ * tens of extents, so if we get a really large value it is a sign of a code bug
+ * or corruption.
+ */
+#define XFS_MAX_EXTCNT_UPGRADE_NR	\
+	min(XFS_MAX_EXTCNT_ATTR_FORK_LARGE - XFS_MAX_EXTCNT_ATTR_FORK_SMALL,	\
+	    XFS_MAX_EXTCNT_DATA_FORK_LARGE - XFS_MAX_EXTCNT_DATA_FORK_SMALL)
+
 /*
  * Inode minimum and maximum sizes.
  */
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index bb5d841aac58..9aee4a1e2fe9 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -756,3 +756,27 @@ xfs_iext_count_may_overflow(
 
 	return 0;
 }
+
+/*
+ * Upgrade this inode's extent counter fields to be able to handle a potential
+ * increase in the extent count by nr_to_add.  Normally this is the same
+ * quantity that caused xfs_iext_count_may_overflow() to return -EFBIG.
+ */
+int
+xfs_iext_count_upgrade(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	uint			nr_to_add)
+{
+	ASSERT(nr_to_add <= XFS_MAX_EXTCNT_UPGRADE_NR);
+
+	if (!xfs_has_large_extent_counts(ip->i_mount) ||
+	    xfs_inode_has_large_extent_counts(ip) ||
+	    XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
+		return -EFBIG;
+
+	ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 6f9d69f8896e..4f68c1f20beb 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -275,6 +275,8 @@ int xfs_ifork_verify_local_data(struct xfs_inode *ip);
 int xfs_ifork_verify_local_attr(struct xfs_inode *ip);
 int xfs_iext_count_may_overflow(struct xfs_inode *ip, int whichfork,
 		int nr_to_add);
+int xfs_iext_count_upgrade(struct xfs_trans *tp, struct xfs_inode *ip,
+		uint nr_to_add);
 
 /* returns true if the fork has extents but they are not read in yet. */
 static inline bool xfs_need_iread_extents(struct xfs_ifork *ifp)
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 761dde155099..593ac29cffc7 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -506,6 +506,8 @@ xfs_bui_item_recover(
 		iext_delta = XFS_IEXT_PUNCH_HOLE_CNT;
 
 	error = xfs_iext_count_may_overflow(ip, whichfork, iext_delta);
+	if (error == -EFBIG)
+		error = xfs_iext_count_upgrade(tp, ip, iext_delta);
 	if (error)
 		goto err_cancel;
 
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 18c1b99311a8..52be58372c63 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -859,6 +859,9 @@ xfs_alloc_file_space(
 
 		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 				XFS_IEXT_ADD_NOSPLIT_CNT);
+		if (error == -EFBIG)
+			error = xfs_iext_count_upgrade(tp, ip,
+					XFS_IEXT_ADD_NOSPLIT_CNT);
 		if (error)
 			goto error;
 
@@ -914,6 +917,8 @@ xfs_unmap_extent(
 
 	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 			XFS_IEXT_PUNCH_HOLE_CNT);
+	if (error == -EFBIG)
+		error = xfs_iext_count_upgrade(tp, ip, XFS_IEXT_PUNCH_HOLE_CNT);
 	if (error)
 		goto out_trans_cancel;
 
@@ -1195,6 +1200,8 @@ xfs_insert_file_space(
 
 	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 			XFS_IEXT_PUNCH_HOLE_CNT);
+	if (error == -EFBIG)
+		error = xfs_iext_count_upgrade(tp, ip, XFS_IEXT_PUNCH_HOLE_CNT);
 	if (error)
 		goto out_trans_cancel;
 
@@ -1423,6 +1430,9 @@ xfs_swap_extent_rmap(
 				error = xfs_iext_count_may_overflow(ip,
 						XFS_DATA_FORK,
 						XFS_IEXT_SWAP_RMAP_CNT);
+				if (error == -EFBIG)
+					error = xfs_iext_count_upgrade(tp, ip,
+							XFS_IEXT_SWAP_RMAP_CNT);
 				if (error)
 					goto out;
 			}
@@ -1431,6 +1441,9 @@ xfs_swap_extent_rmap(
 				error = xfs_iext_count_may_overflow(tip,
 						XFS_DATA_FORK,
 						XFS_IEXT_SWAP_RMAP_CNT);
+				if (error == -EFBIG)
+					error = xfs_iext_count_upgrade(tp, ip,
+							XFS_IEXT_SWAP_RMAP_CNT);
 				if (error)
 					goto out;
 			}
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 5afedcbc78c7..eb211e0ede5d 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -322,6 +322,9 @@ xfs_dquot_disk_alloc(
 
 	error = xfs_iext_count_may_overflow(quotip, XFS_DATA_FORK,
 			XFS_IEXT_ADD_NOSPLIT_CNT);
+	if (error == -EFBIG)
+		error = xfs_iext_count_upgrade(tp, quotip,
+				XFS_IEXT_ADD_NOSPLIT_CNT);
 	if (error)
 		goto err_cancel;
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 87e1cf5060bd..5a393259a3a3 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -251,6 +251,8 @@ xfs_iomap_write_direct(
 		return error;
 
 	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK, nr_exts);
+	if (error == -EFBIG)
+		error = xfs_iext_count_upgrade(tp, ip, nr_exts);
 	if (error)
 		goto out_trans_cancel;
 
@@ -555,6 +557,9 @@ xfs_iomap_write_unwritten(
 
 		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 				XFS_IEXT_WRITE_UNWRITTEN_CNT);
+		if (error == -EFBIG)
+			error = xfs_iext_count_upgrade(tp, ip,
+					XFS_IEXT_WRITE_UNWRITTEN_CNT);
 		if (error)
 			goto error_on_bmapi_transaction;
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 54e68e5693fd..1ae6d3434ad2 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -620,6 +620,9 @@ xfs_reflink_end_cow_extent(
 
 	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 			XFS_IEXT_REFLINK_END_COW_CNT);
+	if (error == -EFBIG)
+		error = xfs_iext_count_upgrade(tp, ip,
+				XFS_IEXT_REFLINK_END_COW_CNT);
 	if (error)
 		goto out_cancel;
 
@@ -1121,6 +1124,8 @@ xfs_reflink_remap_extent(
 		++iext_delta;
 
 	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK, iext_delta);
+	if (error == -EFBIG)
+		error = xfs_iext_count_upgrade(tp, ip, iext_delta);
 	if (error)
 		goto out_cancel;
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index b8c79ee791af..3e587e85d5bf 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -806,6 +806,9 @@ xfs_growfs_rt_alloc(
 
 		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 				XFS_IEXT_ADD_NOSPLIT_CNT);
+		if (error == -EFBIG)
+			error = xfs_iext_count_upgrade(tp, ip,
+					XFS_IEXT_ADD_NOSPLIT_CNT);
 		if (error)
 			goto out_trans_cancel;
 
-- 
2.30.2

