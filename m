Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4106C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:47:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbhLNIrG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:47:06 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:55468 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231845AbhLNIrF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:47:05 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7eLpG022078;
        Tue, 14 Dec 2021 08:47:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=VNnHe6NugifXWm3wg3uF2jO3cS8Yls1+VRTu/POpAwM=;
 b=H4MERqtVLtcMcIfzM7a3YXf3vjaM9lT0yqYfhqMbKwY2B2ftXLv/H3o/v6rnhtLW+kxF
 LuEXWShj+jHvYyPDq2JZMjHD3nE4zjmrFlyp9o5HJEks/DT6QzWZjNO81aYZ70ouVVm2
 fFgpIMo2ll0vlMYADvS24TP9B4ecQkCC05t5sevwm/vNGY2ZwosbLh94Atn/u7KYM8eZ
 KJe3jFvM0ly6wUsY7NhZV+zBHOKGyPSur9VXDk49QJvd5T0xipzJhl1V7JGbU0mpYpql
 sofzxo+gDRwXTB0Y26Ac8tbhVDRoWyWHEes/F0qiB/0+7edG+xLRPdPVoXfldb4t/pca wg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx2nfb6cm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:47:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8f6Im107818;
        Tue, 14 Dec 2021 08:47:00 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3020.oracle.com with ESMTP id 3cvnepkymp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:47:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wnx70eGcYBvMZRR1a7XOOv+RHSSc3PtJx9K74cZmyYyZJZHtNfadP/GeHPxWfd5jYhnGIkhRxaK1ph39+kFqOKvKo0ltW4L1EMfC0DyjnW1pAfFDN9gqgY0hrHFXWqTnV5255jD0QQkeV5RBedQloU0N1pCIfFjZUMuVTmhSuPxvY91aPDMASEBNmn0wwm7meXgSsJpMurefkFCZflL5PPf74LoatofSPrydFGuehL9Yyyc4bvdb1U0fQ5Vqc2CdwKgKhQnYgExRC2WBhFMjdKJlPbG0zaOpII94XvXwj7ed14+T1K28r1qbdMd1hXsjDGsvb0ysClxA3OAqPl69TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VNnHe6NugifXWm3wg3uF2jO3cS8Yls1+VRTu/POpAwM=;
 b=bLT2VjVlJPtmxakqOo7SL7oQov00lk6Z1+lhNeWiqcLnci4lkBBWA9uU+aNQZezggBSI1ZYl4Lozkfg5nQgDULEZUQUbF5E56md2mY+OncsPPjIN8sOMKEXqPgqhONssA0qrBwNBlay7S5+NJcbkyzXZTB5krjUqwZc4ANEsKqccXeVLQ2vrW7Rr4qQFF1jSYX7C+LthEQylAmYIatPH8jA3fJNCJNMChA//5kRJ4Hlod0x5oP1d8fnXQ+SGOANRCrsF3brNfocpmT9QP3SXozRH0pggGdO0dt3hq4Q2kMV6PJrTBiLb9fOaga7R7LPxbj4dRQT41gSsaukVWjpzfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VNnHe6NugifXWm3wg3uF2jO3cS8Yls1+VRTu/POpAwM=;
 b=yPGmnMz3MAM9yAeYQ3IaKAUNrB+u0qHXkkPVPSFIfKdMORxpTKbkraWF8zAakSTVQhKxU7Rkw5YSvzqRMnXS5HytxSBZtxpnmtx1M7DQlYejfCw8GeIBOuzZ1t9ssLoS49gc3Pdu8tWQbTVLkKi4e82D5lalKe3ScLgjZL0S/t4=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB3054.namprd10.prod.outlook.com (2603:10b6:805:d1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 08:46:57 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:46:57 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 01/16] xfs: Move extent count limits to xfs_format.h
Date:   Tue, 14 Dec 2021 14:15:04 +0530
Message-Id: <20211214084519.759272-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211214084519.759272-1-chandan.babu@oracle.com>
References: <20211214084519.759272-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0052.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::14) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1b6a36e-9f48-4a60-4e47-08d9bede4928
X-MS-TrafficTypeDiagnostic: SN6PR10MB3054:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB3054FB07E216D820F18B4C3AF6759@SN6PR10MB3054.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ExAGl6GEbfd3dA2M7+1+kf51QDXj17gdfUjbkRa/sa+sBpwvrmIS7OvdlaoTGVGtdfRkbzeSXyDeYCjvP2GWk4Jd4Db6+UXp1EBVsCPg3qnC84QK3TUg5csjPkmdNUr1SK83CfWZpzpluYm1ttYlISlxxS/9ExwFa/6p6rLBQwptWnyNrZ1CGo+IYjiA/GtldkTnoVBTveAAhBMVvETV7edQiGfskKQTZGrDqg6cUb5lbrakLr8y1V+17fZW+SNuvLGU/kM7F+IawW9yap03O24/0oR1HNzi4t7k80saUslpaSG9/7+V8pGw+IwS3j/GUR3Bk8Y5wWrUS1hQImpRlfegjygAOKehu2DIwnN76Hg4qUMA90M2yjhsAX/jV9e0gSFjpa5QbsmGtiUB5nO/WPa/zGknaHHuU8LGta+nUY5nU5aoxYIFsQF14RdHnv91S7kUeHbehBcUKRR19yDBYbYohgiNsu7egWfx/NYVKr50C5eJvWi+Kb6YoX4pxVNFkCDkA59ZV10J/qJMikr5snmgff3zf+GKKfYYQKthMTI9XkIkFfF6+h7ABUwD8FXfkQgFuxeTSDoaamLhQKCmkuEZHth9D1pKmXwfjAhcofzwUFZefc1MSFZN3p+zAXRe3MGwyLJ06UyxeV6TXBUcpvWcThOtOaMRyw/yXocjFn23p2SiDnXelrd26FGXczOD7CEIJ46l9HVFCFJeEUzIgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(8676002)(66556008)(66476007)(6486002)(316002)(6916009)(6512007)(186003)(5660300002)(2906002)(36756003)(83380400001)(26005)(66946007)(2616005)(6666004)(1076003)(4326008)(6506007)(508600001)(52116002)(38350700002)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IwVDvYJ4JDwTycyecWXNAwVyIDXPm7xd94fTTvcbWbO1FD01/cLd7zkoOXrF?=
 =?us-ascii?Q?sW15RntXDDScHgrUEwmebWrLqo6rXduzBvv6JPNyHbzVWhbNzCd+za9TvvrK?=
 =?us-ascii?Q?yV3qEuNxHXC32rjjS8Xh0TdpTlUl3xMNgu0agUywSncBaCwcL0wWLC4frgtZ?=
 =?us-ascii?Q?mLesW0X8HKomlFsVJobixoo5YlDha241vbnVmVUS1b5O/HiPtSoHfr1o5P6P?=
 =?us-ascii?Q?K2KiZN14DQs/K70aj/8ZhKcnE8njTz4aKB+whX62x6oIaelVFahGSmDYgXxk?=
 =?us-ascii?Q?Y8Yd7Imuy51VbRbHoVsg6HbQ4TkQHbu16CzncPrZhZ4Ejs3LOYx0ttyJalAQ?=
 =?us-ascii?Q?GhVrgIb6SPLHH+AEVPnV8rap7PVZtTPnubfaJoBAkJ77qGESF0lgFcDqSuaR?=
 =?us-ascii?Q?DiKDJsFgnfQFVqQDf8XXDOpqGxq0cYjfa1rCpt4gdh7ev2yQ0TN1gnpl7isi?=
 =?us-ascii?Q?/Ghh6x998jtwnKYl/WfDJmsuKJSnBPCJ4L5/q4BJiwbbNp1JmV85DhEGJuzB?=
 =?us-ascii?Q?wr6mbFped4FDOFTuR3xjAC4fRXpha9IMDSE5IUIuc12JyP8JyBtXpnNz0jhF?=
 =?us-ascii?Q?aeVZeOWWfGEdrhCtWcmgciT+FovJRd3dBgNt6nEtFF/NLar6cZZJ7kGe1y4r?=
 =?us-ascii?Q?8GxK2Ipa7QI2LpOeCx3xw9Tds5BjbiilNWMJ9UmKx2r70l2GhB2NNvikwqPy?=
 =?us-ascii?Q?ek+HJFMnN8nIvMfl/fINM/oBFX97DGTJqWCqT7pMsMfti6nLGj3XosiEP+EQ?=
 =?us-ascii?Q?2lYz+wdnUAtfNhN1GyLzxkcYEJex4HUz2iVy4QUsSoiWfs2uMOBkKEUK0WLa?=
 =?us-ascii?Q?b3UH8UkdFet1VX/kymaB7yglHCdMTc00s1XxJiUfDGjaBOx+MTy82gdbhIRW?=
 =?us-ascii?Q?6ZSo4/8f/NOScMnWpzz3zG6hfu/uK/l1CygHuwjiK5ehbcIKVUI+Nn99tcSk?=
 =?us-ascii?Q?y2nMncnkxLBxAy96VmAymikHwjKoUKCQO6bXKpO1HLQcAZ/sY63WQ+tZxjtg?=
 =?us-ascii?Q?ZMaT6LLwrcGRxy9aAAO7ip03KuZeXPAeacWfKHrOQLQOZTJN9ct3HVPR5nmN?=
 =?us-ascii?Q?h2s+gVFKfrrD7alAFZjWeCbyyB3tWMnWLoGV3Ca3g3qVbfBfxDPKOmth9xsT?=
 =?us-ascii?Q?t5qnp2G+8VypRm1nS+eOqmyhAENdei+aycNn1+SdsZTy/XZ+UrqhdG0Fy3Ag?=
 =?us-ascii?Q?D4rKgXhsaCgxica3rkKSXj1vZT1/o6v8kpISoEblG6F5r14F3+HhsTIEN62F?=
 =?us-ascii?Q?wp/sIXv6xo+8CD2cu1n8mIZ2ECGz8uHFkxmKoTY8UXxE3qLLOUfi6JXBwW/O?=
 =?us-ascii?Q?KWVck8D6xtEPx2rF5+3ZKNYanOs49jc18gCujU/bEJvtWfJyylUkfPZ+GnvT?=
 =?us-ascii?Q?YF+3c+Y/kjYI7w5UtZQ1EZoqMyw5zZCuQs0vi2ouL9bK844dPYAVtoUmJ/zr?=
 =?us-ascii?Q?bSv51OHocqlz5V8IEO99uVuLrjd2TNnjAuSENOLbF7y6s5HnadD5/qJiExS8?=
 =?us-ascii?Q?Vc7A2a6CK5PmmDbFZlZe/kAFQWShST9/FDuPsM+2DS59HJqXh3g33egQWz7T?=
 =?us-ascii?Q?bLgpdzKkhi0fXZ9b1zdrBhSvzoO/g2thfgqAvVEyTHwi8Lx2zlJOEzz/mDgi?=
 =?us-ascii?Q?PLakYYZmgggmlM/+gS9+1Ts=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1b6a36e-9f48-4a60-4e47-08d9bede4928
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:46:57.2466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jcl0Gg2C7v9HmAfvZgF6w5/W4cyGxBdx+2QEHyNZHoNXTFjrgbxgl0yWe+TR6eQ/9pkgAmWTHlL7dWbWH9czzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3054
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140049
X-Proofpoint-ORIG-GUID: vo7sPgBdkl01L6w9FIlS2uUWy_wWlZg8
X-Proofpoint-GUID: vo7sPgBdkl01L6w9FIlS2uUWy_wWlZg8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Maximum values associated with extent counters i.e. Maximum extent length,
Maximum data extents and Maximum xattr extents are dictated by the on-disk
format. Hence move these definitions over to xfs_format.h.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 7 +++++++
 fs/xfs/libxfs/xfs_types.h  | 7 -------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index d665c04e69dd..d75e5b16da7e 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -869,6 +869,13 @@ enum xfs_dinode_fmt {
 	{ XFS_DINODE_FMT_BTREE,		"btree" }, \
 	{ XFS_DINODE_FMT_UUID,		"uuid" }
 
+/*
+ * Max values for extlen, extnum, aextnum.
+ */
+#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
+#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
+#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
+
 /*
  * Inode minimum and maximum sizes.
  */
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index b6da06b40989..794a54cbd0de 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -56,13 +56,6 @@ typedef void *		xfs_failaddr_t;
 #define	NULLFSINO	((xfs_ino_t)-1)
 #define	NULLAGINO	((xfs_agino_t)-1)
 
-/*
- * Max values for extlen, extnum, aextnum.
- */
-#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
-#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
-#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
-
 /*
  * Minimum and maximum blocksize and sectorsize.
  * The blocksize upper limit is pretty much arbitrary.
-- 
2.30.2

