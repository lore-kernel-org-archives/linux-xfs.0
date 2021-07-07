Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CC09C11F67
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 22:21:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80DC561CD4
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 22:21:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhGGWYK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Jul 2021 18:24:10 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:38934 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229987AbhGGWYJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jul 2021 18:24:09 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167MKVcL014863
        for <linux-xfs@vger.kernel.org>; Wed, 7 Jul 2021 22:21:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Q45u8fClVJErHji69qYPmrb/D/xo8Dd6LC+H4A5a+3g=;
 b=CTZAQRhPQTLK25TR1y+GfxxhKybnBilRvsWkFHR0fQb89RGMrLPP5loQz2rVvfzy0wCo
 jB9pK/7BvJk4P8Gm7W6oW2WOdN0NDhMglXiap/v4juRM5FhoaCIBYYPhdn1VP+5vmwkc
 H4DFzoDA2r3okw2bzn9UmCdmLg9iC9TlW1YWC/8Qaewzwdr+D9oqG9mfhgj0sjGOVFnt
 eAfhFpr3CofwdysSXJVtMyOfDEWD5fRFsAbhjZVX8GNzKKG05f/KYRQgz7WoOmY6+fHd
 /NTCRgkovJcVpoGkvNJB2ix9uM6Imp/cUXz+Hh73ECPPkUL0ypUxxw1sKH0k+JvOfatk Tw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39m2aad5jq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 07 Jul 2021 22:21:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 167MKYSe092507
        for <linux-xfs@vger.kernel.org>; Wed, 7 Jul 2021 22:21:26 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by userp3020.oracle.com with ESMTP id 39k1ny0hp5-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 07 Jul 2021 22:21:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=glEqknSKUMWHVkxXJ8gcEAYi21v6W1HcptqAO1eDlJZklLTUgiWcZjaQ06xIzCV175+cm+5c/94jgOWRGZfu0D5hjG7kptOJvCEHOdsn11Cmr8lxRDHNSUj1EnLe9aCW0dvvphoSsursK1vLrbEHDo82fvblsv66Scq7RcbN28IxioR7AS7Q1WxpcR8IKPd+bZb+888jl2f96pjJgr0Wz+6xAQTnfv86tslanpXk24mP6trLrmxeE8qxkCt91bavxto0QEsT8y3fiUgFrNV5tVSEjsz+GvNMdBwbJjp+YE8VOCPF8poE/o1ogiFowEUedWczlps6UUMLLeCV7vLSFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q45u8fClVJErHji69qYPmrb/D/xo8Dd6LC+H4A5a+3g=;
 b=UvL0uRZzpXANWQ5GFRQO2waRRKRibaQp0lFcAiiz7uev8kePNnebz4L4HSk87M4OcewxbNYJWppte6+ki0j0eFyx1+OvZJT6MjgeTc8QeV/pc/BNGuH8gszEYxSWXJzIr2gBEURESKv+BA1tp8YjrH1oK1m1xmCqrsHovDombFxeoSyK1SAMqMmbJnPY+MNxhMzbo2ObS66P8FOOqr23dPUZbfegP/KN2ON4UvqGO0jsHfQgGNT2/f+AJyPR9aS9yZ+7f/hvk5/1dK/p3dNiOVNTAVmMLcwe0OaYO2JA0ME3eEYAHsr857QxBccWuHs3luLoQPD7BktCIk9pmudoCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q45u8fClVJErHji69qYPmrb/D/xo8Dd6LC+H4A5a+3g=;
 b=xH+mdZxGoTgLbFEfD314nB52Zt5DYpfDGQwpcpIdVR2FfZjFHP48rwztHdSIoDh5ughnOnSM4pC6+GBoXsoKTUxxjPjujQw4bHPl1Ey7/nmdZy5sOHnRQ7IPEe6V3hlAS/HUZPk53Zp9VNdxPQEu1Usp7EHygfaxc2nx5XmVaw4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2760.namprd10.prod.outlook.com (2603:10b6:a02:a9::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.32; Wed, 7 Jul
 2021 22:21:24 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4308.020; Wed, 7 Jul 2021
 22:21:24 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v21 04/13] xfs: Handle krealloc errors in xlog_recover_add_to_cont_trans
Date:   Wed,  7 Jul 2021 15:21:02 -0700
Message-Id: <20210707222111.16339-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210707222111.16339-1-allison.henderson@oracle.com>
References: <20210707222111.16339-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::31) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR13CA0026.namprd13.prod.outlook.com (2603:10b6:a03:2c0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.8 via Frontend Transport; Wed, 7 Jul 2021 22:21:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1400655-ed4f-4e29-05a6-08d941958e27
X-MS-TrafficTypeDiagnostic: BYAPR10MB2760:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2760496926E5CA7B59B70D5D951A9@BYAPR10MB2760.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zhPZFAaJGoWkVybg5B7H1p7Eoke5vxt8JceTcx4jsGOxp9Nxp3W6JLa4/3me1KY6T6t4d2gvn/A3eHmp13e0e/PAAyhBxUPteWe2eOoviy1c1RiHtWThwUZ4Pgv2sdbSAwVyIZpL4yn1eKNLiK4iuTX3k3pERpupYDYK+GYlYLdaiXCdClE9fSzKHsKtVYOlxE6nsWsg6PxzPPbz6MIG61DtCY8sjNk1WE3Zl65+5MH2CC3V3hNst/ZLYzUWfkggM17etwNuOmk1vcaj7JvaRf+b3jqV9+GUoVny3g6ogaYCUi8bP9fHv0hAvQ2MchiSZ32dz7wmuGAtL+vkQtsisQg5L4eBudqooXDvgLXp3IXMQDwKpD7H7sVNXqDz5PjWHGAUk651wQuGKAzo7goZrnfA4N8RzrHy2LVxmpsix+kOCSqF1xCY0bR5dXFW3hEhZ/XLxBsPpii2pvZ4TZHz2EXSmlhTxofNfhZ0bF7GYYTT120tHbUiXodZJAn5wun5WBdZaDfWi8jLx/oI6kSxg07ZU63GH2g4SME3wEP3Gvq/o0Ncz3br2yqjiUpt4hkXJ8d9FkSWKJBdKgvhobK/6k2ezHYnLvQ0cgvr0ucVcQ/x/IEpDrE4jPZdk9j9LYXUMZP/hfJNJmLk8IOClkQWZxY6eZVYR/+lMl70fQ0yKl+aAw8FtTrKcQeMC2vgyhZV+nEmYSNSQ76cea700IvmjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(366004)(136003)(376002)(478600001)(83380400001)(8676002)(2616005)(6512007)(956004)(5660300002)(44832011)(66476007)(66556008)(186003)(2906002)(8936002)(86362001)(6916009)(36756003)(38350700002)(26005)(316002)(1076003)(52116002)(6486002)(66946007)(38100700002)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pe8A6maWCsP7xxlQGs4GynsJzyqxJLxI/AFSkWWW13NtLgNVnnecoiBuyjch?=
 =?us-ascii?Q?+CqKhfD3aSEFx8a5kZmiPyJZQCDzBCeHLmVzTbrRS13cxr8re+rjTypIrs7e?=
 =?us-ascii?Q?J96/xP/G5UCTsANzfZKZZz/jr5j69v4CMQsIXilrONmCL1XMaQap9qNPOSfq?=
 =?us-ascii?Q?/hwUE70p/ibOqP5MQs9A56EyNCxty0XjwZBClsSfc4953wc5Jk4fQhGaojxa?=
 =?us-ascii?Q?wClxpqhNq2t9k1ihvgkHaNxWjAgMUZ1AkQmlphCzfkEqj5newN729vp3APFe?=
 =?us-ascii?Q?29yrwbdowUxMQAoIAOnplboWGZgIuwhIrDgdJUlrJ0BZL1q8OyJp1SoudNFk?=
 =?us-ascii?Q?G9k/8OuSvGXNv2o+Vspu2UOMGJWXpSZHJxc+wqoG2g873f1oXvSxAj0idlmH?=
 =?us-ascii?Q?gWn1gEseaO7CBwW+haIpXdA3MKWgbKpY2jKEL4k05wxHDBeQYzgk9QKRR8Fv?=
 =?us-ascii?Q?QzOLgF71vqkQ2zDSKOfrXKYctvLx1y4kq7uBRRkKnD6mtAISbwOEl7aJQwJi?=
 =?us-ascii?Q?VkNp6B5EwrqTuZ3ijpVjsLiu4LrPAsVBY5H02N8imsvSIOPIomZadzoATSM1?=
 =?us-ascii?Q?rrj76Hf5wTPsRg+DD1GznjbdlEQerLqIaQpB6/Yegj1YjYqTSAmlNVWD5BFO?=
 =?us-ascii?Q?HERqA1XFKfeSLpVsnQd1zlLrSRWtI6g0OllfMsn4X3Pucdn8X1nXviFcutjz?=
 =?us-ascii?Q?DJaenA4bwsmg4ov93r5RWLFSVqfr6ee56M7iMZ+T4dFvi5CRm/6vhbIw9Nhy?=
 =?us-ascii?Q?t4C76L8zGU4UyNwF9/mO92LkewjD83AB6R38+0+QWdwzfMIatBUEIgRghkc0?=
 =?us-ascii?Q?MriCjA52xLfWvxLi8jsGg4YhvykTd/YqxIyFUgL1Lbpj3SyItmpoF3iJI0CW?=
 =?us-ascii?Q?4kZM+zBqeKB3CXbGBhc8sj4bs/pwya3pmQpgwkdZCbqbzgFGMbEuXH8TGp1r?=
 =?us-ascii?Q?DjhceB9+rPpYidKDCtnbKF65fmM6NJFZupIbRFdNT3ESBWc5vrNSSzhbw2Mw?=
 =?us-ascii?Q?CMyrCuMK0ZRRhj87FNJObevFDPewieT+6NrlFg6yOkcQrYkFaZ1hoQ3mnNr5?=
 =?us-ascii?Q?KJXB4Fj/k5yKS1F2T8ewzthKcE89fNFkRieUbcSEi3t5vzLkSGOuY+cKZJxP?=
 =?us-ascii?Q?kxqMfo0EJBKdUPfuG9p3nufm6VcoPBFtTbfqmFRgb2DYcpdEyoQ5e8t8bAT5?=
 =?us-ascii?Q?ZXmrvsjVGMtNm0qtUPIRO6OxedFZJArg1nYd4gpnmZGW6taOVD+CTolIFanl?=
 =?us-ascii?Q?3T8ZNVcjrrJuW+mL6ascaRkqYrCOnpYxRf/cuJqk+TzL9TUyYnhQjSaha7KA?=
 =?us-ascii?Q?iiKG6+T8UNAJpGz3Y9LqDOZX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1400655-ed4f-4e29-05a6-08d941958e27
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2021 22:21:24.2103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RymvCgDlhpNLP6k+fJyUKXFChAsLSwSrISDWxVI3iNiITlNVhnXplnrwInPTuQ83pbU9x7AMckNKoa+6UbthFGbbK2xk4ysTkGLU2DaEwHE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2760
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10037 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107070128
X-Proofpoint-ORIG-GUID: WGlQYC224C_d9wkfzwb5jA2YaGSBwIgZ
X-Proofpoint-GUID: WGlQYC224C_d9wkfzwb5jA2YaGSBwIgZ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Because xattrs can be over a page in size, we need to handle possible
krealloc errors to avoid warnings.  If the allocation does fail, fall
back to kmem_alloc_large, with a memcpy.

The warning:
   WARNING: CPU: 1 PID: 20255 at mm/page_alloc.c:3446
                 get_page_from_freelist+0x100b/0x1690

is caused when sizes larger that a page are allocated with the
__GFP_NOFAIL flag option.  We encounter this error now because attr
values can be up to 64k in size.  So we cannot use __GFP_NOFAIL, and
we need to handle the error code if the allocation fails.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_log_recover.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index ec4ccae..6ab467b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2062,7 +2062,15 @@ xlog_recover_add_to_cont_trans(
 	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
 	old_len = item->ri_buf[item->ri_cnt-1].i_len;
 
-	ptr = krealloc(old_ptr, len + old_len, GFP_KERNEL | __GFP_NOFAIL);
+	ptr = krealloc(old_ptr, len + old_len, GFP_KERNEL);
+	if (ptr == NULL) {
+		ptr = kmem_alloc_large(len + old_len, KM_ZERO);
+		if (ptr == NULL)
+			return -ENOMEM;
+
+		memcpy(ptr, old_ptr, old_len);
+	}
+
 	memcpy(&ptr[old_len], dp, len);
 	item->ri_buf[item->ri_cnt-1].i_len += len;
 	item->ri_buf[item->ri_cnt-1].i_addr = ptr;
-- 
2.7.4

