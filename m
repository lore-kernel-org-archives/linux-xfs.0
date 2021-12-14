Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F679C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:49:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbhLNIt6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:49:58 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:44854 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231697AbhLNIt5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:49:57 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7tcRB005519;
        Tue, 14 Dec 2021 08:49:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=IE3XjpZ6Kz0xPPRyKHk/2qL+AgJ19Q8xQ/j8VtUD194=;
 b=V4hQGHfNcDoHuDVIn+9XfRxPjhTuMx6VYjkZOlxRF9r/1KY/DupyqCs7kgFXOZRR8lrl
 BJAz+JKELS6zQ4NRmwx59qJAS6aPwUEGLI7goYmn1hTMCTRXEJQ1cRzovJflG2Tk6xLD
 P9+SvQQEgR1fmEBPOimKJ6V+jyzcwdMIVVTI5RJ9onWQjVRT5eJZBPQAW7NfptD7+UF8
 ZHpCZztNnjisg/FS5X3BaWJc4rScxa7CVTCO3GR84Y4t+MfXyCgJ3tpIZD5dWBXMbn8O
 XEWbCGD46tKajSuTzkBWs9B/0CJY1THBIi6421QBTQrCO0ojLnkE6mi1dTMSm0BOjQ2F pw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx56u2sww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:49:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8foBT104439;
        Tue, 14 Dec 2021 08:49:54 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by aserp3030.oracle.com with ESMTP id 3cvj1djsxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:49:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YptQMyEA4H+XhwQFpM+Q6NeBmfzFzGMnZhgZKIOqh2MrKZy7Udk9H//W256ookRyZAifW/Ib6v6r8qRuKW/jvRuKoOWVrkI7mGYjBRv5GPGtQUvXXjpWC4LIGfwbCL1LjObp2HU+g85rLd4v5bpzFrebRH3wOI+PT5nUVBnnl9dtkcj540sZUjnOW3iQZ5FMuTTZVHpZmt3Odnc5dTL0xvjkyf9R6088C6pLck/G2oixffIyGMQT7PUJY2K5mK6WCnz8SX7pIaD3S2U2E9IHnwovTv1sO2P0oWPSssu8lHRcLnboryZx2Wbhr6BIK+Y5gTVw8VNmUzqw+7QbgRX7aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IE3XjpZ6Kz0xPPRyKHk/2qL+AgJ19Q8xQ/j8VtUD194=;
 b=T59DKMStwyDZbAZUBRSSCYN5gFLCjAMWHXWkrAEYwUaTMU3rviOeDhAfJX3+WhuCbQCGXa4TnlplCyV9nLBQ5TfvoczxkOKvE0QVUlCBUnpyChapS21R9x94o0vne2aX/Jx8+9jQtl/4euvGiT1NVWi2fuSlztrQnvv6YXZcvrLdcQ93HwrMWNsXmDEe2Nztov2BoFtsKPzYKXnIWmURxnGkQrvIymxpJnH7BbgwhDCyf4Zn8bow0JCBH8/S3Chjgs+mmXKks6JmeuLxlnbypohtI6hmsvIWwN7b1yMOGPbZelg3AmsxuWXf1IL+YQdP/CO7TLLx0hZGDikxUio2pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IE3XjpZ6Kz0xPPRyKHk/2qL+AgJ19Q8xQ/j8VtUD194=;
 b=J3vL19UFCGgNfpktpg7RR54We2k6DY2zEp/pukOiBWRfJew7uiDChn15Io1gilFLwm1Xne1ExagGAN8fmvDzO2sF2p7FRTP8emJBv1zm4FuzHqPd5zjCKh3BuE2JKi/MlLgcHeJv0lA5S5tdvEU7ySmoGIogbmL2rRCTp40Bkvo=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2656.namprd10.prod.outlook.com (2603:10b6:805:42::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Tue, 14 Dec
 2021 08:49:52 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:49:52 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 08/20] xfsprogs: Introduce XFS_SB_FEAT_INCOMPAT_NREXT64 and associated per-fs feature bit
Date:   Tue, 14 Dec 2021 14:17:59 +0530
Message-Id: <20211214084811.764481-9-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211214084811.764481-1-chandan.babu@oracle.com>
References: <20211214084811.764481-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0069.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::31) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55541395-cbea-43ef-4860-08d9bedeb1ad
X-MS-TrafficTypeDiagnostic: SN6PR10MB2656:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2656DE3BFB0A4FDA0001D147F6759@SN6PR10MB2656.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f47xuSFhuT14Vl6xibWvv6BZiuxDgqpEp7uRNAqFGdy2M2nAdKgoMncwoDCdyMiTdbHsJeJGGh05Osx/ilRgEaJ2YTm8a7vuNkgx4WgLGLv6Hbaz7BmziqAQskbN2OH/70Dzvw77WI9N7UzNCeNqWNFrAfVFRK/Ak8Tt4tkThFkWY/L+RWeB694gi0EfXdrFuB54wiDvDuulkU4YIbKUqxosCILDCOQi8/wpR13nBtg+KFtu3SIThgpNPKrZJRFlJepp+XIXtZfwyXA9snZtdmdKXh3QCGMD4oBWN/duLc4iAuaEgMju8XAsFe+NaWW03x5glrW2tyoBJFVMzuYLuldxFlOV4WR/KHMgxTgReR0YBw5nZUDE2+ma8M3GvJAIAq5T+Q+xTvt0BxOgdhQrlK5xxFKzOxiEVMnt0ITVGuDzQ2tk4MGQgu0Tc1fgGj7UgF9yzLkxgVvsAoICEn/gGUK5d5KDmvHqb+I8cNM4BrnhKabTilBsIpBp9Ra3l40/uwBvAi6wTz5sinThOMmsTw2nsXFUJH3+Ha0EFkQXzmK4fteI0M0L8beX0acAQaeo6bPzGGCAX6m7YlpH0UzGt2MvdXek97ZC8JmB3E2jKqwpeRjJ7OqUqr3b/Va+rZ++qQYP76o9eIBkXwVIoD8j4SuAmFZkAdakiXKehOVXB6W79MU9VwWtEujuK+xNr6cx26iBHJNaZWPbYceoyxgqpQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(508600001)(52116002)(86362001)(186003)(6512007)(8936002)(6916009)(66946007)(38100700002)(38350700002)(5660300002)(6486002)(316002)(8676002)(66556008)(66476007)(2906002)(1076003)(83380400001)(2616005)(36756003)(4326008)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d/2HpCVa/7ab/nYvAv81qYcJ6LPBQyLIdYb5OI2chuFheQEkFL6NHdnFxtQS?=
 =?us-ascii?Q?cU0KijXu4EqaJaZJ3LmtrDxqKze5YYk0N6OYnAE+FSyOGvg5X510vxzKk7cx?=
 =?us-ascii?Q?IOk014jOCoQJx08OTaJBI0Vh7X7cQYFoS9m0JU8/6lIe3/uI5ACrmEiaXq1q?=
 =?us-ascii?Q?D5uG104RpVKpgpcZ1h1/sipu2g6nG+ykhkuwx/cEGnOU3hy9LeKkS8DWpNN+?=
 =?us-ascii?Q?qEToGHMPy43UyQSP8lX1njUGwpoLiUpS7bWzJU9eyJem5MBRLMLxBd32qGX9?=
 =?us-ascii?Q?OO8PTCdpAOxbZtrEJsfMBZBpmnAKBpdbzBsFqgiudlpFmLRoF3aU9fx+2aCt?=
 =?us-ascii?Q?v4uB37eSknBnUd1YOWaNuphPmf/2rvK2URdhvsdSVA+AV++FRKoolHVTZrZ2?=
 =?us-ascii?Q?LN8U/kWwZlRRV1j0R8cJtRo7ehVJN5UDYgcBwiBL/2cVRjS4TGEs5qY65Z9s?=
 =?us-ascii?Q?EzHt2YjGWXhchCxtAusB9aYUh6ri/6/DKf9eGlL/1SdsIAHOdRyoIuC/1PEl?=
 =?us-ascii?Q?8U4zEbotM66JYPIe8l5YSXlEagwoIN1MhwYAnmOW4Dc/4e5fcjplo6edkXOY?=
 =?us-ascii?Q?zrL6YY0E5ZxlF32vPYzQ3Yx2yYs+Hw+gcDeXF+DuuG9dwah5PvC4KEFKDWtf?=
 =?us-ascii?Q?xiwXfl6aQS2oAFIPPlqumUIgYKom73ubl++q3omlhoR9jLaEhKC71Wc9mw5u?=
 =?us-ascii?Q?gkOdoKpj0PVXxUKtlJn8H1j8phoS2u/SJj0IpTIQH8Df7qNqU4DyhGw3n+Ed?=
 =?us-ascii?Q?NA3BKTpIpfjdy22fH5mShaRr4Q7vKdnL9Bc/k+yyawksxDxkDXWClz5gu3DG?=
 =?us-ascii?Q?OtdJdQu42Q2I/DvAY52edUa1dbtkybJq/h1CUSDIAHu8I0mMmGeoJBXjH5Cg?=
 =?us-ascii?Q?5HRX1Y7x8PHV5dQfmCLJOy33itOTdXYeIlCfghNFouMaCdB98tn+DMPzm7IN?=
 =?us-ascii?Q?x0/S+C4CbgdBCRJvUNP3q1QbVE40tDct0V/aZupE6R7aoFwM3Y8TMJ/HWsTt?=
 =?us-ascii?Q?Y7FkGSNHwFV+4PyWIUa4aRidzUc2mU/XdbodA0ROXiLFhomV+emjL636V9Kz?=
 =?us-ascii?Q?vLnBmgSy85HYmlqE+x1B3kWlGr1pMHjvDJRuXRUU+BAk1MyeFZbf8Gqp0PHx?=
 =?us-ascii?Q?yXV31kK5M+tCDf9KMczxKKYG+Z7bn3EyhsA99vugIfe1zduFvctDzDTtjc2Z?=
 =?us-ascii?Q?Hooa7+jIgYoxw05OQUYe+Z6aXEc+J0a4hQASiTnxFz6CelO3FKcU/RXq/O5f?=
 =?us-ascii?Q?lA9uRfKo7FdORIc9mnPxOdU2gxF+zcwTMjV4oJlSM1TBIYDQF/NUdH9Pl7Xv?=
 =?us-ascii?Q?LTa3OdH62zq1Xyc+Y1/HtnNXQoNa4vP4n7Ou35BcmPZ2NQJ12A0rZaM6L4y+?=
 =?us-ascii?Q?Lhw605vGHOl4G4F1EjIKyyqKxNeoCD94H1nN0eQce+pMkXiTZLkwbrjqh89r?=
 =?us-ascii?Q?MHTsWP0Hj44IJndoMJyJ2FttsHiWi4t/otL2aUU6ewELLrf3vHUWXyrbqaGE?=
 =?us-ascii?Q?BCvX4HZRWlHlte6UPYW3BBurVOsXm11L3Vz2ijRqNGQIaKxezBjfIBiW5rEB?=
 =?us-ascii?Q?h+vINdDdjaL3Dx6+vncBO3bGIzFLOfKQ2QREhtV3eNQAbFJa68mLFJNiF6hL?=
 =?us-ascii?Q?MA1TF/SUpD4fguhsS6M9khk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55541395-cbea-43ef-4860-08d9bedeb1ad
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:49:52.5951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aB0qm08vox6Hs2KdupUiB8eswYFJrGljiD56llv4XGi4V59mRCdFVex3bKqihe8MTa20DVyKO5BLpU/yrsC2wQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2656
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140049
X-Proofpoint-ORIG-GUID: GYqcm-cKOsTmn3R7spf2inL9t5tYZU6y
X-Proofpoint-GUID: GYqcm-cKOsTmn3R7spf2inL9t5tYZU6y
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS_SB_FEAT_INCOMPAT_NREXT64 incompat feature bit will be set on filesystems
which support large per-inode extent counters. This commit defines the new
incompat feature bit and the corresponding per-fs feature bit (along with
inline functions to work on it).

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_format.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 68f42fca..23ecbc7d 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -469,6 +469,7 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
 #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
 #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
+#define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)	/* 64-bit data fork extent counter */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
@@ -575,6 +576,12 @@ static inline bool xfs_sb_version_hasbigtime(struct xfs_sb *sbp)
 		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_BIGTIME);
 }
 
+static inline bool xfs_sb_version_hasnrext64(struct xfs_sb *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NREXT64);
+}
+
 /*
  * Inode btree block counter.  We record the number of inobt and finobt blocks
  * in the AGI header so that we can skip the finobt walk at mount time when
-- 
2.30.2

