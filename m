Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65C5DC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhLNIrg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:47:36 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:19646 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229577AbhLNIrf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:47:35 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7mv6U005512;
        Tue, 14 Dec 2021 08:47:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=HtpMYarhVfP6uRC1XYVjpprJ9b4tkyyHUsS2KawHsDE=;
 b=L1SwBPaKL6Aniwvl9B1pEFVDvB1TGuaT9xBmPF+6J4EIB1N0/BbGv96hTbA0FU0qAL7O
 ueX0/vmiSyHgwceKGOIs9y63sGLixo9KyzfXyevj1hP8F539bmIHc92umw3uTwV0qtXa
 nTVhzoFK57GzUDevaxIhIT7JZ6p4Yoj8Unh5TrKiiSFkZHEEStBPGx7vi3yjMxQbFTMm
 FT/rYYvPeTuyY5yR1gVoOZ1vdy9UsKTL4KshceXsoPMcuEcTbPdFdQrmI9ovopYPPrXo
 i0s1C8y1Q3Zhf5sIdkysC22mbzmd+c3eiXWd62X9Mhw0WMyBQGyZE283Dkz+1X2g3WCp Pw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx56u2ssb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:47:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8f5Xv107696;
        Tue, 14 Dec 2021 08:47:32 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by userp3020.oracle.com with ESMTP id 3cvnepm0nj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:47:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n42XWO9nSXpYNq+cnnrvdXMQ+V3BK8DXscGDo7d8G6I5Rt91oMS42YIYzIkH9OwlTczH0/5I8JhXOoR9EObHcYoqmPqisG/PBgQ3Ff1n2PQR7DhycA/p/su4nkXfbJhAmGE7VmxRGLSyJkAVijARH/XfGdTDYhtOIfHMvXvwnDTUZQtRBMbLnlAwvlAZyjHZhvU8u+eOkHXOtAcNjvZCslq1tkRsHcJ5hBxmV0ppdVgm3QaG+Pq/nZqsYKoBVn4HDjGE/gCJlPul/Us7JDerg8PZRUgqajA6xj7ZpKiqEWJ1/W+xdjBlGmc0Jv0B9sCIv0e46kOH2ZQuKtQo0IyF+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HtpMYarhVfP6uRC1XYVjpprJ9b4tkyyHUsS2KawHsDE=;
 b=n7Tqy0cgv7KiBdXe9DnmNVNfrXyJhZk3lZphie98aLy46DjUOymSHqZbhJi4GbrGm8eGvqs7dU3OEf/RiOT2kyvTzT0ZQP7O++ayHnbOQnjW9OKYMmAtV/GgbLwc3yYd05M48VdRG0kFK9ttRyQ3M4Vh9XvOBVnTpWrh3RY6zGglKQshyXbnFxh/5PFx982l4xW5eAtNoJICgC48I/yqMpJl5BRHEgfHd8mBl236Y5nF1fTkA7qwy8NNsOox9hBt3Q18nPDwP8wemBd/enC/9flETrNaZ7t78ZXn73mjijZfS34/gC3gWynPWSR0ZWYln2wFKM0EcoTwbXOHmFf3Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HtpMYarhVfP6uRC1XYVjpprJ9b4tkyyHUsS2KawHsDE=;
 b=d7A0UFLKLCjiDSO1bUn63CC4R396FuSe/zGt1VG+6j/OM8+uVDcOfW3Frb8eI50dgkGtOLGT2WIn7K402NhrXe/yPX/WqH8QuuYmCXu6YOk9s0lhH77/FP0plOIdJMKe8UNNJMo3csl9MmE2U7B8RON/XC5sLDXQjI0bkRCj8mQ=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB3054.namprd10.prod.outlook.com (2603:10b6:805:d1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 08:47:30 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:47:30 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 15/16] xfs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to the list of supported flags
Date:   Tue, 14 Dec 2021 14:15:18 +0530
Message-Id: <20211214084519.759272-16-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 934db452-7a5a-40cb-8520-08d9bede5ce8
X-MS-TrafficTypeDiagnostic: SN6PR10MB3054:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB3054450443181D48D2EDC2A3F6759@SN6PR10MB3054.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:151;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nd1aP0rZNjFClzT2+Pm3XS7AaTJZq2y8+jxwirTArwkB4XHBJMz3yBKDcoa2fyb6N3aJu2nQITCA4p3MiYLlA1KD8xf5C/uOCEI+g7p0Xm/0IWQzHsioyY5nE3zVG3BK89ni1xwSvl/Zfpys+RUFnhFFhd4P927/o4BjbmyHPgZzLBhYkSQ2wBCb1Y/+lL4pSlQc33feVbGI9C5HHBEwCahi7kLz7DuszJu9K12QGBOVnh0OWHeMAN0VMKwg0WQagm6mN6CMIeuowu0wg8WohO7Pk/j/MfFVPlrNd1foxAac7LaFvGezj+aJjKKvs5FlljXUHqVisMN65JXCvoNlQKOmtIW+LffrnTmtLYaFvsvJOxyW/COGyIT2p6jK+sJ4J3DZhDRDFcosYzSJpRC3MDjkIC6yZobJUuA0uOzMANt4D8G1iEgKxwb/ciSO+tpylXWY1MWsSWOH4Xf/4Hdu/NSoH/SGjll0/b8LAG1DAQba3f5vBZy2OH8GowJIFzq/moNlw6CRHL8Nz5cV23YpYyhxiwssc5eiot5nDGo9VUceVAAy52r7hBWq+ePopVAYXJUxKGmxl3Mh1aomsnVy0VO/dQxFCRpbXMJAMXTxzi97G6pIXM/MYcgxrDarBpXskuS3KcpnXhHZmhXDA4B30TcXxzMTrZqbc+t1eLVmP31M7P8KrjFYaUJZ86q4OCE/+KFfM8XaIDn5m+LrsFrqwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(8676002)(66556008)(66476007)(6486002)(316002)(4744005)(6916009)(6512007)(186003)(5660300002)(2906002)(36756003)(83380400001)(26005)(66946007)(2616005)(6666004)(1076003)(4326008)(6506007)(508600001)(52116002)(38350700002)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aC/y+G/ZqKCLYx/JtglHgSUVQ2X0tCFkJBNWavumbv/wyQvV4gnJEo8ZPnWa?=
 =?us-ascii?Q?FUVleQoJd3HcxLkd0DDsePPFIoSc5s69DFvfVL12it4+m6Zhp4y7c/jZixTq?=
 =?us-ascii?Q?fXp/nFnfq0YGKEwje1Yk/miYZrqokOJ9ZegVuNVupREknypjef4bjtkwN0+w?=
 =?us-ascii?Q?fAwk/CoDDz+lZ4p4u9hrYwSSROax+iSKLFTQMBGDlT6N0GWWvWkAyXQAHyyU?=
 =?us-ascii?Q?JMcIpg2Yu9V23twHBP+wpPZ3/DPSMT/oxmnRyWhA+dV7nwYdiC89ZTDYjuYG?=
 =?us-ascii?Q?D2sNKJ/kvqKPXo4piGD3KxG96c3zMHZbsTWqisXexJ+MVI/t9RaSnADsVCfT?=
 =?us-ascii?Q?RtlmFIgEzbvsdi//Mppje7/3cnieAUgWIqL9lQ7RnMa1bTZrCw5W3mzXOE+A?=
 =?us-ascii?Q?ZXS+58GgoFbs2WRcrxhc6EQScxZm5fKNNxxl25P9y7KDZOVMQeHldSm7aHPH?=
 =?us-ascii?Q?FNkgD4fwKtbRKGhmMvJQ8ypkkFqR+3Da/26j91gOgh8xOgp8gwFiR4/ZxnuL?=
 =?us-ascii?Q?NERa0PbTA5+pn7vQGiKGeiyOKWZvhzywNOutEdrecLGm22Znt4wi5LWReyT2?=
 =?us-ascii?Q?R/AmYB5ycuvkiz9D9PoPhNhEEcU7c48rau0AFWPZ08YvMM1vMMBRNGvygdqS?=
 =?us-ascii?Q?he0JetdBblqfyqM3UbbJc1hCRCvRV+iNNHo8Gk0JwR8qbysOT1VMKQiWDSJY?=
 =?us-ascii?Q?hc/kmlJe3pVbj7FsAMHqXL1K1uJ3dGaMZbdm2ib4FHXWJ5tdU2r3hGJvhUnS?=
 =?us-ascii?Q?IylHWJD8lM3fvWH7GIBzsQaxY3NqJB3txoYkQ68+0bHwRiE0pFiB0NKb+xyf?=
 =?us-ascii?Q?KGvz18ankNEWbbaCgbVF4bijMMYq3M1rQAwofmnn465x9dd6xyfvhoTTO/ma?=
 =?us-ascii?Q?mtMcc+93wyJ7MqfMWg4uX5IJavKQIUH7VX/xOUE6l/YIfAnBP+Mrb7g13KNc?=
 =?us-ascii?Q?OS1HzdoUba5mSKtJrYXvVqj5az6AGnRPjSVrq1julsYzoct08pFRe5Myn26N?=
 =?us-ascii?Q?69+/Z1JAOX4S3h1gewNf90vsvw7QZlqNBWsCf8td55o07pWeWGtZ06yg1ca0?=
 =?us-ascii?Q?+XNxPQYcXaMHRFw4x4BRADn4nXegigjAVyc0zLtsOxssJdJ1PoC721Dw7H90?=
 =?us-ascii?Q?6IUi5BWWD1ZZjT+SxZkjuh2Ljo4A+5/c8zzGI0IrsYkiMADg9SYoea5oigDe?=
 =?us-ascii?Q?fpwOUvEDq+xy9FIive7OiJuIWlv0q/z5c53+6wuyeyRNG2VTgKZHd7pBNaWe?=
 =?us-ascii?Q?OTFFTv8qPuc7w3/OXfa115TC3R+jQBbI5EMOGgWVT5QC6bOEON/Id+D/07ap?=
 =?us-ascii?Q?trs2H2gmNVaq5Q1zWt1QzNzlbH02rjWmjH+OnwzmhgzqBgfmeV3O+t1P3sHs?=
 =?us-ascii?Q?0M2LuaasmhDgQe8i6SVnajXiq/JJbF+VbckeeBrU32uKwe/tYyBvXRYZdpTf?=
 =?us-ascii?Q?f7D43rWmqB10IlrydbyFCSNHS52lBN3HTxigpILipF6KfGEnLcC/CgUrJY4F?=
 =?us-ascii?Q?anaxHllDl+Ewv15unztAqmA4QPPOJ+7NdjhYwVNFg1Ln2AwPzdnS2sDRo+LN?=
 =?us-ascii?Q?aO4f5z3SWyhvmviWCYhEEcN5iDN43Tdo7MkXudPOtZLJCYL//fIMtiMJu9Jj?=
 =?us-ascii?Q?Zj/vhwVaALl//x4ZWjEDWJw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 934db452-7a5a-40cb-8520-08d9bede5ce8
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:47:30.4049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RD3uKcMfC1Qyu56AvzWm8ep6hHa9WhxWecLo0fzO8sjcSNTPyMX5ToPkEfe1pBxTAW1VflnW6k1WuycLAnG9IA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3054
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140049
X-Proofpoint-ORIG-GUID: 3YkUPJmpp8AGBxCW5azNcySKdyc0dm87
X-Proofpoint-GUID: 3YkUPJmpp8AGBxCW5azNcySKdyc0dm87
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit enables XFS module to work with fs instances having 64-bit
per-inode extent counters by adding XFS_SB_FEAT_INCOMPAT_NREXT64 flag to the
list of supported incompat feature flags.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 2868cec1154d..3183f78fe7a3 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -378,7 +378,8 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
 		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
 		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
-		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR)
+		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
+		 XFS_SB_FEAT_INCOMPAT_NREXT64)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
-- 
2.30.2

