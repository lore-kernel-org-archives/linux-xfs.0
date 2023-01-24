Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BD01C25B50
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 01:36:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbjAXBg4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232437AbjAXBgz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2023 20:36:55 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9FCD1A4AE
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 17:36:49 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O05mb4022530
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=6tYSEWWb1wiKYWw2+XP6sFmWvJlNNBn4jDtZsPv6VNo=;
 b=kR1s780UEbHZuyGsEUEQgPxTXBvvk5HGS/bhflxe5J8uukfMBYr7D9YMbkFAtc27QKlD
 yZyat1x+zkA4/xCRbqgiul/ZR1k5o4gdgYmxjYu6tDjVdOerm5PgTPXmdGrcAq/blK58
 x1C4msJpKp7yGKvMV9WEF5gxKB9EPnDDuYGPF+7AnANT4CI3wLrJ+pW6MxiqX1xOpnDT
 +3Ldx3SFRghkqZ4rNhSToY2kTW3h87ExxUN4U9hayJBZ0oTqdDV5MkGXasd+XezC/9Qo
 wnc2LKXbyVsD1MEBetdOtHTMPJIh8E7T1L74sb4298SFwkaBE6Y1hKC0n3HHN386FSej 9g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87nt4a3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:48 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NNUu5q023145
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:47 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g4am2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gmGceSeBZaIRdD29tFgw5cjywlpqoOvyX0iPMAJIa/5r+A1BHLWnpc5fGVwIV13lCTqTlNYIx/a0nz5r84PLeNv1k/0BCQsrlVbF8vMc8XVxDZKp1roh29Oc3XrEadf/BcvtoIl9eFao1OiA2lEhJxR9jRSVZfG1hkEKBGaLB5FXjTZYHUNCgytAgdlLC41Lx4Lm1MffW2lmHJcbQhoxMariesxM2l86Ll0NjLmh+xOqRq+3LeKbjzyxWtSUJlgjB1sTVRzyfQON32qbH+LqabnRDc5wQG+tNOLebyH5MdWMHK8Y0vrKmfglcxJf1R0WXwnyl/hG3I8QOs/Eh7OFEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6tYSEWWb1wiKYWw2+XP6sFmWvJlNNBn4jDtZsPv6VNo=;
 b=ZJVi9aAd6F7+fOOL2eqem6EckW6CDSNfwxLluCsJwoEGdaOQfnIazX53K1vJ+W6GFASE5AKeSE50aJYwbzsM7+387awmwC3fEOezM2AGT8HShP809i5E+9G34e6Ka9VKyPxFvT8pSUxbABYF2x0ryzbD2ZAsejd2hATmD9J/xeNIyGKR0I8KsfyArQH9zJPPXJ2s4dYd2elkVWi3fTjxYKyzNlZd5+cHMjFAt7F9kPSJTy85vd9L4NzsN0L61yMqF573XYoau+q7E5bVfPXEvXruNpy6WVJluxQTZ2eC4sGMs1I4h7CZ5lXmaLsMAoAn34RA8z1kefgKtwFBqZTzEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6tYSEWWb1wiKYWw2+XP6sFmWvJlNNBn4jDtZsPv6VNo=;
 b=kIobkbqKgwSBS5dBuCxuHcBDIdv4SipIxlMftouKRKOS2oqE+pTrCS7ywA4Bfx4PxpfuRnoT+69OBLIeAjPMwMUY10holY9LpDiDLsjdLody2UBQOn1T7cBAcHAczekJF9Sush8Jl12Aatqd+MrHJxv6HienWlfWVMxLtdRodTM=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN7PR10MB7074.namprd10.prod.outlook.com (2603:10b6:806:34c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.8; Tue, 24 Jan
 2023 01:36:45 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 01:36:45 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 14/27] xfs: extend transaction reservations for parent attributes
Date:   Mon, 23 Jan 2023 18:36:07 -0700
Message-Id: <20230124013620.1089319-15-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124013620.1089319-1-allison.henderson@oracle.com>
References: <20230124013620.1089319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0018.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::28) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SN7PR10MB7074:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cbcd59a-2d83-43ba-da56-08dafdab741c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GGRpg48LMEFPXX1h/bV8pK3kUBBcfnULOx1Z8mAaGhz+QMOJd2z8re0xajpPzdBG1Mlp2W+FXiZ4PXGBHQVRfqZqxSvlau6T8/KAGc6cIf2TjhceltPEikqQTAZ6Jm5KPX1Z2b0jGOApeBQh4JS1FZap06WyEgaHqmEJ6UNHnOCQK0nG0O9w9rVlLZ1JsmIkl4ePvEKAxhhAWKCFuoP5R71GbNFCI9kGWkkpOezPq3H6pvJtDyUoxkqf0sP/nSpjhx6ZnxuBsM9WtUNLpmbMtWJ7ARsxsv6xanra5RN8VQYDdh0SPW8gylycmKHqmBbyr+hggQ+CsQY6WLG/0oFbdTqChU3YW5JA762m+ESeJnGOHHKu5imKyp9qc+ccJrbGjO6PJjmxndpglzFNOGa5PD4u29KpITMas9CsPGEDigktM2pepGi3GRZTk4XXC4srxsPffMu6WHCy3OB++53AIeZXahrjzzETOtyz7e3iP4LhyrVpfEa2fxapiEeX24kq+zB7t7zMDZ5qCOUL6cy8uzAtLPJrFjgzd7GQE2546ks6u4OclNH0gNcA/WbqpwOerXw58+YrNilkO8CUFzOjKyM2u5Gu8eppOF93G6jDqLmEjX6WcHElBliCCJtWRUDykiZbwLCOG2E5XeLvYGMVag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(346002)(366004)(39860400002)(451199015)(66556008)(66476007)(83380400001)(6916009)(8676002)(66946007)(41300700001)(86362001)(36756003)(1076003)(316002)(2616005)(2906002)(30864003)(38100700002)(5660300002)(8936002)(6512007)(6486002)(26005)(9686003)(186003)(478600001)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zSaolrN7wqWIo3rTJ4DXfEBd1Yx2KRBdNoTuq7QPQIOJfc+nqVgs/vIFoLNA?=
 =?us-ascii?Q?HMox23jGqItv0/HjTeyubUkXL9zDu4QPRMDOdHG0rtwcHDoa6ja0UzZyvXWm?=
 =?us-ascii?Q?ihY+afSclJe6vOF+AhJu5bmGzRw80LGt7tpMQ05LYVKxQvZItbkq/DZ8bSMf?=
 =?us-ascii?Q?54g6ElE7XRVQUgEHrmZ3pqEypF2kZewx9RtdgUJM2KiDIJC4LchVqAIfeR0w?=
 =?us-ascii?Q?naqZtp5CO0beBoxDOflHr6eHnDCNBL+aLb27JrWLV+493wjFfQtgntz96ctw?=
 =?us-ascii?Q?KtTynBeuPOqFgxHMVLbgrkXno9nPWKsahkcN0qAKUdIB80YuBrJtJ0TUADxU?=
 =?us-ascii?Q?LMaeKbytUCs3EMK16QbRK/HPeZt6zUIfnwT8V2qURUoUCPKlfZ/WV8E61Prx?=
 =?us-ascii?Q?r8VV7GjM8rgWb1uKjrDAXyw9yueJQ14qYwO8DfLXxzTQX7StZiRB5nfmxDIH?=
 =?us-ascii?Q?0O6B2rYLYIyxa82OM46xbvUKt+2IkjkkRBaSDEJfKcG+H8DetdATnnLyr+vJ?=
 =?us-ascii?Q?iu6jRcZO6tLxRW4SuONIyral7/8/lC16VsgY61CTshnwi1dpwqYeEs2b+/9F?=
 =?us-ascii?Q?CaPHmKGJd0gct2j5FXb6c8DO9x9rPk5NSZiQsBivnrbPmXWzzPlCLx+Rvf0u?=
 =?us-ascii?Q?YtWhsTl30fhSrO1AhdNUinSP1aJ5863LRsDCoAM7t/AfY9zL3Fy5jVqiuc5K?=
 =?us-ascii?Q?rWpzorTR7mn2U5PLSocadS/y0gcFNfgIaUcTDsnioc7/OSLY+C/Qv2gKSLpZ?=
 =?us-ascii?Q?7SPVbuHSw4FRXCO5O+AOLg1jodi6B8CqOFIzibMClmMmYU2NQ50q+dpsd0Qj?=
 =?us-ascii?Q?bL0JOXaPdUTa4kNgFa4TG81/NBQomTMz7gFmRYQU72ojScTxfvF+ygWitDEP?=
 =?us-ascii?Q?lgCbTA4CTnUNeOI5GmzbFpMtes2pc1VrlE9Yo9FI5i9nZ1CJhHAhryLzTen8?=
 =?us-ascii?Q?Xf0oGJGpa97vNa7JV8EyFvzBLJ/CItek4ZCXuLlhjPw0+AvJZzDB+APxsfKm?=
 =?us-ascii?Q?/qbKi/XiydDUH99jcD/zevpOsAJneHKW3D7tkWgJYzNfZ82ifZk+AVlZ4v8e?=
 =?us-ascii?Q?+T8ipPnuVAyQAycc8rXqPmc7i4LB3DQs9SoqUJ+wVRcSRzMs+Aks97SbzVPA?=
 =?us-ascii?Q?CIGrOOZaxmBZ1kC9xcQi7k91lNPsWg1ocViDldIAc0JcJ2YAllXELZu670Wz?=
 =?us-ascii?Q?M9o/RM1wbFfx2qd9C4PKWpUZJS5UFChDYvrUv+54FJOlQIKU/EGaAwQVE/vw?=
 =?us-ascii?Q?ta9m4rq/sqxSLzvhjpHcuLEQO6HGDiiIR0a8bH2yLDxo5K1tgn4cLMEX3n/n?=
 =?us-ascii?Q?5e2XGGH2elN2o2r7znRz5CNxsQW06UDxrzEn3VVbINFZM4v4xUEuzwim+LUj?=
 =?us-ascii?Q?AXa59FcBg3X9qqcnA4CvGw0OsptPs42kNgXcnJiyOFds6jgXdu6HvRVm7/jg?=
 =?us-ascii?Q?JHHpTsSnE2YJwyyecLYVSM893Eh+VXOJJy0E7bsencaMT1tDrbkL/RiefFEJ?=
 =?us-ascii?Q?zxuWQbR9/QE+Vl8UhgzIkaTWETJoO+E7MdGkX92MnYBFt5RLW80xoAR1/ms6?=
 =?us-ascii?Q?PN8poXJEnk+MNfoa73FuNfHrLKnBkCSx4qH7Hd39PBjBB3Jaabx5yehVSh42?=
 =?us-ascii?Q?MQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 1MEDVPvXSG3FySQBTy1Wm9EZKiFUjyJbSGCOoZp/6zlPBFb8TsfagAbWq1L0AZRlNOFoi5SvWwASXFx03N29Ubr4izZs7HtcOhW8XRHCre6lZt7hPBpY1mWbC+1c4T0litWnmuETGorrhKdHfHhGSKSra53tVBfGEzPVVqp5RXRjbP3i9ypz2fwJgnLAKNHl/hk+6deRXqDgvP9vSqoDqbkP4OGxDIGHC2SNctqQDErfp1EnV7zOyryIQFI8zAuH1JAHQhY/pT8MNkhdIdKz4t/ZVJwqYwCQhR5lWjUFTnFD4Q4I0CrEHRwbSFT5bEkTNeAyMnTtNIYF1kb+e6nGSzN3OXDYFN1ojjtJUFLnN+gOwGZ3ZYqVzsL7e/9TmVMOwEgx7+0MfLmabc+EWXXhQ6fjLhuIiquBLOIJccFu/CkFeThirqoDIZmg9m/yATqQVSeQ07TxIv/wu5vu4zr2IkhoERqy1EEW75bQSE36Lp+l7+3y5XEN/6Y7COgUolYhKt4OZFhOV9sK8q5FulEoffSR3DAoHIuCrlsHCIw9GsIqY7H9frg2iz4ehvO+aXr6iJ/kUQzpLR5BFbXARS2MgVoKU8qGoSoHqw30DtFdeZcfKuiKxX+LbkE2/ZVXDwSIC6EB+f6zbFdrX8PVqGHklJlru+RdMjK6zskO+QYkeo+2frOMtGfFT11MzP5OHKfev6keL/h080VNKnK0bvUBf89AMGzOd4l2163Zy/viu/F92A4Xz0iZtyPw4kQq11+iEpegNwAXX2aW5Gc+6UXqpg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cbcd59a-2d83-43ba-da56-08dafdab741c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:36:45.7016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pk4UD6EkwJQyQ3YhhcAnXMm7usBRrETrY5NadVQR1S29sFBaCd7w4RMuva3lARP8AN6CPgi0IR9mcZ0JmLvLKC8HmRjHyWsfdwviYzas1yM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7074
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240010
X-Proofpoint-ORIG-GUID: vBRTl0gPJOZhj4FnnQHBpac-oCgP746Y
X-Proofpoint-GUID: vBRTl0gPJOZhj4FnnQHBpac-oCgP746Y
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

We need to add, remove or modify parent pointer attributes during
create/link/unlink/rename operations atomically with the dirents in the
parent directories being modified. This means they need to be modified
in the same transaction as the parent directories, and so we need to add
the required space for the attribute modifications to the transaction
reservations.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c | 324 +++++++++++++++++++++++++++------
 1 file changed, 272 insertions(+), 52 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 5b2f27cbdb80..93419956b9e5 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -19,6 +19,9 @@
 #include "xfs_trans.h"
 #include "xfs_qm.h"
 #include "xfs_trans_space.h"
+#include "xfs_attr_item.h"
+#include "xfs_log.h"
+#include "xfs_da_format.h"
 
 #define _ALLOC	true
 #define _FREE	false
@@ -420,29 +423,108 @@ xfs_calc_itruncate_reservation_minlogsize(
 	return xfs_calc_itruncate_reservation(mp, true);
 }
 
+static inline unsigned int xfs_calc_pptr_link_overhead(void)
+{
+	return sizeof(struct xfs_attri_log_format) +
+			xlog_calc_iovec_len(XATTR_NAME_MAX) +
+			xlog_calc_iovec_len(sizeof(struct xfs_parent_name_rec));
+}
+static inline unsigned int xfs_calc_pptr_unlink_overhead(void)
+{
+	return sizeof(struct xfs_attri_log_format) +
+			xlog_calc_iovec_len(sizeof(struct xfs_parent_name_rec));
+}
+static inline unsigned int xfs_calc_pptr_replace_overhead(void)
+{
+	return sizeof(struct xfs_attri_log_format) +
+			xlog_calc_iovec_len(XATTR_NAME_MAX) +
+			xlog_calc_iovec_len(XATTR_NAME_MAX) +
+			xlog_calc_iovec_len(sizeof(struct xfs_parent_name_rec));
+}
+
 /*
  * In renaming a files we can modify:
  *    the five inodes involved: 5 * inode size
  *    the two directory btrees: 2 * (max depth + v2) * dir block size
  *    the two directory bmap btrees: 2 * max depth * block size
  * And the bmap_finish transaction can free dir and bmap blocks (two sets
- *	of bmap blocks) giving:
+ *	of bmap blocks) giving (t2):
  *    the agf for the ags in which the blocks live: 3 * sector size
  *    the agfl for the ags in which the blocks live: 3 * sector size
  *    the superblock for the free block count: sector size
  *    the allocation btrees: 3 exts * 2 trees * (2 * max depth - 1) * block size
+ * If parent pointers are enabled (t3), then each transaction in the chain
+ *    must be capable of setting or removing the extended attribute
+ *    containing the parent information.  It must also be able to handle
+ *    the three xattr intent items that track the progress of the parent
+ *    pointer update.
  */
 STATIC uint
 xfs_calc_rename_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
-		max((xfs_calc_inode_res(mp, 5) +
-		     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
-				      XFS_FSB_TO_B(mp, 1))),
-		    (xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 3),
-				      XFS_FSB_TO_B(mp, 1))));
+	unsigned int		overhead = XFS_DQUOT_LOGRES(mp);
+	struct xfs_trans_resv	*resp = M_RES(mp);
+	unsigned int		t1, t2, t3 = 0;
+
+	t1 = xfs_calc_inode_res(mp, 5) +
+	     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
+			XFS_FSB_TO_B(mp, 1));
+
+	t2 = xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +
+	     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 3),
+			XFS_FSB_TO_B(mp, 1));
+
+	if (xfs_has_parent(mp)) {
+		unsigned int	rename_overhead, exchange_overhead;
+
+		t3 = max(resp->tr_attrsetm.tr_logres,
+			 resp->tr_attrrm.tr_logres);
+
+		/*
+		 * For a standard rename, the three xattr intent log items
+		 * are (1) replacing the pptr for the source file; (2)
+		 * removing the pptr on the dest file; and (3) adding a
+		 * pptr for the whiteout file in the src dir.
+		 *
+		 * For an RENAME_EXCHANGE, there are two xattr intent
+		 * items to replace the pptr for both src and dest
+		 * files.  Link counts don't change and there is no
+		 * whiteout.
+		 *
+		 * In the worst case we can end up relogging all log
+		 * intent items to allow the log tail to move ahead, so
+		 * they become overhead added to each transaction in a
+		 * processing chain.
+		 */
+		rename_overhead = xfs_calc_pptr_replace_overhead() +
+				  xfs_calc_pptr_unlink_overhead() +
+				  xfs_calc_pptr_link_overhead();
+		exchange_overhead = 2 * xfs_calc_pptr_replace_overhead();
+
+		overhead += max(rename_overhead, exchange_overhead);
+	}
+
+	return overhead + max3(t1, t2, t3);
+}
+
+static inline unsigned int
+xfs_rename_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	/* One for the rename, one more for freeing blocks */
+	unsigned int		ret = XFS_RENAME_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to remove or add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += max(resp->tr_attrsetm.tr_logcount,
+			   resp->tr_attrrm.tr_logcount);
+
+	return ret;
 }
 
 /*
@@ -459,6 +541,23 @@ xfs_calc_iunlink_remove_reservation(
 	       2 * M_IGEO(mp)->inode_cluster_size;
 }
 
+static inline unsigned int
+xfs_link_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret = XFS_LINK_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += resp->tr_attrsetm.tr_logcount;
+
+	return ret;
+}
+
 /*
  * For creating a link to an inode:
  *    the parent directory inode: inode size
@@ -475,14 +574,23 @@ STATIC uint
 xfs_calc_link_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
-		xfs_calc_iunlink_remove_reservation(mp) +
-		max((xfs_calc_inode_res(mp, 2) +
-		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
-				      XFS_FSB_TO_B(mp, 1))),
-		    (xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 1),
-				      XFS_FSB_TO_B(mp, 1))));
+	unsigned int            overhead = XFS_DQUOT_LOGRES(mp);
+	struct xfs_trans_resv   *resp = M_RES(mp);
+	unsigned int            t1, t2, t3 = 0;
+
+	overhead += xfs_calc_iunlink_remove_reservation(mp);
+	t1 = xfs_calc_inode_res(mp, 2) +
+	       xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1));
+	t2 = xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
+	     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 1),
+			      XFS_FSB_TO_B(mp, 1));
+
+	if (xfs_has_parent(mp)) {
+		t3 = resp->tr_attrsetm.tr_logres;
+		overhead += xfs_calc_pptr_link_overhead();
+	}
+
+	return overhead + max3(t1, t2, t3);
 }
 
 /*
@@ -497,6 +605,23 @@ xfs_calc_iunlink_add_reservation(xfs_mount_t *mp)
 			M_IGEO(mp)->inode_cluster_size;
 }
 
+static inline unsigned int
+xfs_remove_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret = XFS_REMOVE_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += resp->tr_attrrm.tr_logcount;
+
+	return ret;
+}
+
 /*
  * For removing a directory entry we can modify:
  *    the parent directory inode: inode size
@@ -513,14 +638,24 @@ STATIC uint
 xfs_calc_remove_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
-		xfs_calc_iunlink_add_reservation(mp) +
-		max((xfs_calc_inode_res(mp, 2) +
-		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
-				      XFS_FSB_TO_B(mp, 1))),
-		    (xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 2),
-				      XFS_FSB_TO_B(mp, 1))));
+	unsigned int            overhead = XFS_DQUOT_LOGRES(mp);
+	struct xfs_trans_resv   *resp = M_RES(mp);
+	unsigned int            t1, t2, t3 = 0;
+
+	overhead += xfs_calc_iunlink_add_reservation(mp);
+
+	t1 = xfs_calc_inode_res(mp, 2) +
+	     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1));
+	t2 = xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
+	     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 2),
+			      XFS_FSB_TO_B(mp, 1));
+
+	if (xfs_has_parent(mp)) {
+		t3 = resp->tr_attrrm.tr_logres;
+		overhead += xfs_calc_pptr_unlink_overhead();
+	}
+
+	return overhead + max3(t1, t2, t3);
 }
 
 /*
@@ -569,12 +704,40 @@ xfs_calc_icreate_resv_alloc(
 		xfs_calc_finobt_res(mp);
 }
 
+static inline unsigned int
+xfs_icreate_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret = XFS_CREATE_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += resp->tr_attrsetm.tr_logcount;
+
+	return ret;
+}
+
 STATIC uint
-xfs_calc_icreate_reservation(xfs_mount_t *mp)
+xfs_calc_icreate_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
-		max(xfs_calc_icreate_resv_alloc(mp),
-		    xfs_calc_create_resv_modify(mp));
+	struct xfs_trans_resv   *resp = M_RES(mp);
+	unsigned int		overhead = XFS_DQUOT_LOGRES(mp);
+	unsigned int		t1, t2, t3 = 0;
+
+	t1 = xfs_calc_icreate_resv_alloc(mp);
+	t2 = xfs_calc_create_resv_modify(mp);
+
+	if (xfs_has_parent(mp)) {
+		t3 = resp->tr_attrsetm.tr_logres;
+		overhead += xfs_calc_pptr_link_overhead();
+	}
+
+	return overhead + max3(t1, t2, t3);
 }
 
 STATIC uint
@@ -587,6 +750,23 @@ xfs_calc_create_tmpfile_reservation(
 	return res + xfs_calc_iunlink_add_reservation(mp);
 }
 
+static inline unsigned int
+xfs_mkdir_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret = XFS_MKDIR_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += resp->tr_attrsetm.tr_logcount;
+
+	return ret;
+}
+
 /*
  * Making a new directory is the same as creating a new file.
  */
@@ -597,6 +777,22 @@ xfs_calc_mkdir_reservation(
 	return xfs_calc_icreate_reservation(mp);
 }
 
+static inline unsigned int
+xfs_symlink_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret = XFS_SYMLINK_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += resp->tr_attrsetm.tr_logcount;
+
+	return ret;
+}
 
 /*
  * Making a new symplink is the same as creating a new file, but
@@ -909,54 +1105,76 @@ xfs_calc_sb_reservation(
 	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
 }
 
-void
-xfs_trans_resv_calc(
+/*
+ * Namespace reservations.
+ *
+ * These get tricky when parent pointers are enabled as we have attribute
+ * modifications occurring from within these transactions. Rather than confuse
+ * each of these reservation calculations with the conditional attribute
+ * reservations, add them here in a clear and concise manner. This requires that
+ * the attribute reservations have already been calculated.
+ *
+ * Note that we only include the static attribute reservation here; the runtime
+ * reservation will have to be modified by the size of the attributes being
+ * added/removed/modified. See the comments on the attribute reservation
+ * calculations for more details.
+ */
+STATIC void
+xfs_calc_namespace_reservations(
 	struct xfs_mount	*mp,
 	struct xfs_trans_resv	*resp)
 {
-	int			logcount_adj = 0;
-
-	/*
-	 * The following transactions are logged in physical format and
-	 * require a permanent reservation on space.
-	 */
-	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp, false);
-	resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
-	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
-
-	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp, false);
-	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
-	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+	ASSERT(resp->tr_attrsetm.tr_logres > 0);
 
 	resp->tr_rename.tr_logres = xfs_calc_rename_reservation(mp);
-	resp->tr_rename.tr_logcount = XFS_RENAME_LOG_COUNT;
+	resp->tr_rename.tr_logcount = xfs_rename_log_count(mp, resp);
 	resp->tr_rename.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	resp->tr_link.tr_logres = xfs_calc_link_reservation(mp);
-	resp->tr_link.tr_logcount = XFS_LINK_LOG_COUNT;
+	resp->tr_link.tr_logcount = xfs_link_log_count(mp, resp);
 	resp->tr_link.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	resp->tr_remove.tr_logres = xfs_calc_remove_reservation(mp);
-	resp->tr_remove.tr_logcount = XFS_REMOVE_LOG_COUNT;
+	resp->tr_remove.tr_logcount = xfs_remove_log_count(mp, resp);
 	resp->tr_remove.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	resp->tr_symlink.tr_logres = xfs_calc_symlink_reservation(mp);
-	resp->tr_symlink.tr_logcount = XFS_SYMLINK_LOG_COUNT;
+	resp->tr_symlink.tr_logcount = xfs_symlink_log_count(mp, resp);
 	resp->tr_symlink.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	resp->tr_create.tr_logres = xfs_calc_icreate_reservation(mp);
-	resp->tr_create.tr_logcount = XFS_CREATE_LOG_COUNT;
+	resp->tr_create.tr_logcount = xfs_icreate_log_count(mp, resp);
 	resp->tr_create.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
+	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
+	resp->tr_mkdir.tr_logcount = xfs_mkdir_log_count(mp, resp);
+	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+}
+
+void
+xfs_trans_resv_calc(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	int			logcount_adj = 0;
+
+	/*
+	 * The following transactions are logged in physical format and
+	 * require a permanent reservation on space.
+	 */
+	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp, false);
+	resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
+	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp, false);
+	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
+	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
 	resp->tr_create_tmpfile.tr_logres =
 			xfs_calc_create_tmpfile_reservation(mp);
 	resp->tr_create_tmpfile.tr_logcount = XFS_CREATE_TMPFILE_LOG_COUNT;
 	resp->tr_create_tmpfile.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
-	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
-	resp->tr_mkdir.tr_logcount = XFS_MKDIR_LOG_COUNT;
-	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
-
 	resp->tr_ifree.tr_logres = xfs_calc_ifree_reservation(mp);
 	resp->tr_ifree.tr_logcount = XFS_INACTIVE_LOG_COUNT;
 	resp->tr_ifree.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
@@ -986,6 +1204,8 @@ xfs_trans_resv_calc(
 	resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
 	resp->tr_qm_dqalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
+	xfs_calc_namespace_reservations(mp, resp);
+
 	/*
 	 * The following transactions are logged in logical format with
 	 * a default log count.
-- 
2.25.1

