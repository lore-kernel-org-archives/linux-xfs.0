Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 514C7C4320E
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:21:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36F9760F94
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235510AbhG0GVR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:21:17 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:3992 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234349AbhG0GVP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:21:15 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6G8QT024358
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=8KOwRpoKCNnwTdGcZ6kSuBkp3N8lQccmSUJMA/CIsYA=;
 b=EF5DdSHZpZwQDFhYZg6Qu8vshbT+kr9gDGD0T4MZZe2Kjp5VhiHIwyg+Lg7EgHdnpH6E
 id0xiMEui/rI/7ajiP3TrbKmndRB9M4WsUMgfQQgquYIBftgesBexDu0CX49Ebvf1lP2
 vFdhrvsif2jWA1qj8DJ2QHchBNV3k57Rl6gkSL7J4ZCL5khyrZfryooQhxJy2jcuNCwX
 z0GUpNS7VRsTVL0uOZ6zpM7vYQ/YwAMpqt/O1h3wxzkR8GlbQD5BY58gvVXl7PFzpuDf
 TwDEZA6ZjgDkvUTv2JBPW71Je0HnNxCbT7DY2JVmTBmU4PBBpey22Xyhdx7OuMw5wBlr /g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=8KOwRpoKCNnwTdGcZ6kSuBkp3N8lQccmSUJMA/CIsYA=;
 b=rCsD5sGOuBoxrdbkQs1BDTU24FgbDYg9s6vXrwQGJNbemaoS5Abb4ABAbEqP42uanX8O
 Ewzynpj0viFRUHhP7xbg83cI+bkV2Pilcxqlff0PxY+x26wGfMm2tfzqUif8JqLPsVU6
 BRSKqsGdLCjImjdsr904hJMLQv0CvWYuIdqnJ/RGXBdak94nfOVgV4wXrisMYISdFish
 X3sQg/LFj5AZxKuykSjO8IcHBeWMBjAnTfigLrVbRSNHPp79MQ2uZFjPvKAcBYqncRK1
 7mjGvJ88ety+ykyGagfh9LT5Z8pFlVGG/QSuOt3xjrDtPVytQCEyfe6nESyIG78BFPzV cQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a235drupw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6FT1q019894
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:13 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by aserp3020.oracle.com with ESMTP id 3a2347k0as-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ODIlvdAouRt0u0c89HmiXQI/hzunSVa4yVsI7gziJ8YcALZMDbg1eh3E7NsQ2gORwonG8tTQDCAUJh0WShg5uz75JR+cmGwFkiRyICp515vvqbexYO4qrEQxDIpi5g/j4MjseDY6gFyJJDnbKAPp5F9oy0K6LgXTsodxiI/chR7SL60q0hAl0lNpdD5wZJ6ieavEnUM+K7oZbIvXVE82WFB20BCvIGp9jOePMKtvr2uDaR9Z8EPLxf1OIlCJVRzbg+3GCVm63Mb93lfyI5PSNqxwp48J1KtR3gcPRm9XaR70lEFFythApu5NJvy8qsmROuLsvOBX0ybCOGsuUc8mWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8KOwRpoKCNnwTdGcZ6kSuBkp3N8lQccmSUJMA/CIsYA=;
 b=Hy2UqP9fu2pb806m44/3O4n0BJ+8KJNwuNA7X3NyQ3d2XfSgCiCFs5Y6DiLo/AOyFD30dVa9NacL523q9dZXrHwO67UqKWx93K7TtoT7/gsGjb8NFGV+uyeZwJoF2hpNrcPzm5R28aqoSGLZCnXivgvxjaWOZCrR3/b3uxSaOfiYMLYa7J+vmrhtbXQffm6UlXf0hVqiG8EWYfhHiEWpOqMgUOl6ckD8E7p0isaz+sH2n9wv6nvBkQZzVQpAGUWwPD/VQmgrYnMqb/0wgITcGRe05uMWVPMRYR5oACPH5BdjKb52ZZo31ghp9dh3VpfOp+mHAhl7Guve2/BMV15A+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8KOwRpoKCNnwTdGcZ6kSuBkp3N8lQccmSUJMA/CIsYA=;
 b=ZMRtIPrcHU5E2onBjUFwM+QyoH3vsE7ow3cy5H+6ac2dkptvEjilH1qqd9LIFfk7SLrGHcqiS4SnmBP0NcztvgMX5cNg5Sb0BoIeZdBDfO8ZHvVQTgf+R/XC9vHk8IBvOlpewe3CPVLtEZG/H+F7Vg8smkLSyNTO55/8ivG2usc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3383.namprd10.prod.outlook.com (2603:10b6:a03:15c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 06:21:11 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:21:10 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 07/16] xfs: Handle krealloc errors in xlog_recover_add_to_cont_trans
Date:   Mon, 26 Jul 2021 23:20:44 -0700
Message-Id: <20210727062053.11129-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727062053.11129-1-allison.henderson@oracle.com>
References: <20210727062053.11129-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0191.namprd05.prod.outlook.com
 (2603:10b6:a03:330::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0191.namprd05.prod.outlook.com (2603:10b6:a03:330::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:21:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f36304a1-16d7-4860-c296-08d950c6ba13
X-MS-TrafficTypeDiagnostic: BYAPR10MB3383:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3383408DEF873FD534DD10B195E99@BYAPR10MB3383.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w9/ZUts9VKfVxOcba1pMr5lMP8UFkr403VrCvo8uXRF/kp5GwkYDtvupAXS89sPk+LV2H5muUSSsXxYCXk+alJvxwVBSiVkMoIyOgI1oB2oAP0og4+kzuQ4nMQ8nvrG2ib7o/cj5DkOe7xX41UFP4ZoykdFRUtyLdNMYDrKMwZxSR2M77qW5T8ifqWaUNg82jZG72iTZEf+JjQOmQ/J893uD3ljgT/qgk915OnOiHszN14yXfB+y93+jliFHnqdoUxJpqJ4yuy3upQpt8lzroKMEcAAvf/KqBtJApcn/1rk9jjeyK3rB46u49i7BIKNF9BnGcKzG6tSr68L16rXijHxvI8tG3wSrIHmgIf03DEiz1r6PgMqmuhNzqcEq4RXvsZHuGVb7XJ635psP+1LyIrKgL6MB6n3mq55Ia43WznG/oqBzllgeYVUeSbSSDPlCRM4sa1E6Mv+Xz2DCnq2YTuL7/bjFt/pty4hwazuxQWZeU1okb2Lko1HmjdegafOh3bpaMeUyXT/esAx35cSVnAT2Jv1TUJPrehOJlJQymLC+j2f2X+3L5D0mkR1cyaTAU6o7kF3DBBYcQSIyw4eq9TP2G/ZvCLwLJrVak6LXtQIhkVzTitRsnmUJcWu/+Lkn/o/PO/LczEg3FWjicQq9gFJC6/HEfVVrI+etu9hA9dl3NXI/lU7arl0qLQ15dSnsDvea4y88w6OMQJBgsmq3ig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(39860400002)(136003)(346002)(44832011)(956004)(36756003)(26005)(2616005)(6512007)(6506007)(186003)(6486002)(86362001)(6666004)(2906002)(8936002)(1076003)(6916009)(66946007)(52116002)(83380400001)(66476007)(66556008)(38350700002)(38100700002)(8676002)(316002)(5660300002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K+B0sKxD6/Kz0BeMYyRKoGMLYoA+nRz1NXaQEldpRm7h03Pqby7xQuaN9n0h?=
 =?us-ascii?Q?N5isCbR/xOkIsnHws2lFkjKKepN1lJAr3aKGp+6/m2dQtyPpcT/T9cGhYIui?=
 =?us-ascii?Q?V+hO/jvf9I1zWZrnPTH08OE8tgFzxAmBfHvWaSsDUDcmWcIt7EppBaxSQsgk?=
 =?us-ascii?Q?HmJjS8CWnJ5niMdnMTDNL55yyDA/AOZaH7lroKUzhza2kIIbS5crfoDb4g/5?=
 =?us-ascii?Q?fW16hmj+U0F5dG5/+H0aiQBpiPjY92/LHKNwcioqQn7+qNQXKfdoyUi1QeMb?=
 =?us-ascii?Q?s3CEpUNnHW/Q+RnqcQCp731sEw6gICXNu83X49KPFEEyDAcuZLN9yEbi9acu?=
 =?us-ascii?Q?zqPYQop0dEkErLfO5ljsN3cEKKuvX99524jmdZaJ5PAlKQIbmIit9YP34+VU?=
 =?us-ascii?Q?+5mU41MmfH0yegqhJEundCTS00NQX+n2iYUVl3z2av+CWjusNLmBPFyu1rS5?=
 =?us-ascii?Q?C64+poecux4/qVnIYbdLFejLN2TGDnhPURBveHLAueUZdVfaS7ecZEqofaKf?=
 =?us-ascii?Q?N2DdIhSIeAYwcmeKjJp0Ofn24UNvtScUWW5wG7IzgVfP0w5/bv3tBuDUXIHI?=
 =?us-ascii?Q?eeD1YeVnLH44h7bOGTouEN4rhBs6Zy2S/5/va2QFpLIV5CEt8zZfkdmopAwN?=
 =?us-ascii?Q?956iYwlaiWH6pHNs4Q4qe9lghvwwThHaGCoRSYO1ETIdQo9ASM1ZDX/enEHC?=
 =?us-ascii?Q?OI9qN6Zb5k/Sj9hNFxSgPxHtPdXrc3S+jvrtMFSqOaH8g0WF3sk3u3x7Mnfn?=
 =?us-ascii?Q?slGRmF+yT43pa7EbkTdY+gQApEndS5IotYQXhLz4rFLdDgOTGMz1IsWozWa+?=
 =?us-ascii?Q?or3vlKa18S0Gz4W1h5dqoECLU5YSpOlX1Oc3TrU9aKpxFeWmlnkDsF+r1ERO?=
 =?us-ascii?Q?QEXH2UIeAYguyvEKr+aY1KnohET24+I4on0YWUciwgIe/f0vVi1UFb7S8Lus?=
 =?us-ascii?Q?pGtbcwXkU+OZBxqTPY8xIhQSlmrj+Yo06pdR42hJPIusaX5YvpOEeShJXfgp?=
 =?us-ascii?Q?rehOutQ2t5oXNWqOzVPBYKwbZ91RXTYV6K9M1JiUpXB9q4lWbX2UUGpxLR1S?=
 =?us-ascii?Q?Ha3zoLIWznpBu5WS5a5ZQ6HgOZj7jl2P0YZQb994RWwHciPG0a+lXk80MTA5?=
 =?us-ascii?Q?nMm/+XQylqsEKZG2Lji/jTq+S0Ium8J/H7qbUW2R4+yRuEE8dkiXqGPH3Gg6?=
 =?us-ascii?Q?A7W4KjxmzTROSDtu7CaKHV+pAS39yy13vbB2ZHwvWFfw5CW0n2ZByp7R0jBF?=
 =?us-ascii?Q?LHpZwRVpNdCJG0c5WoP+n92bxdVQ3LsT1bqvcDt2QRPUHz9RQ0nL8dqOtvb+?=
 =?us-ascii?Q?W7JEccN8YbRxQQdKPXVcZoGQ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f36304a1-16d7-4860-c296-08d950c6ba13
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:21:10.6683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vw5Wu6u+L/z1bCO3OnMHL0GoVAO6MjDW1NtWFm/KB2JEXaMS+/XcjsJrMaiKNTxYHJUbwhCcnieT09bWCtw718u1w9ONTChMFBMLBTmM2b0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3383
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107270037
X-Proofpoint-GUID: kzY0oFIwIBvJE46dPVv31O8PgvIZY8xJ
X-Proofpoint-ORIG-GUID: kzY0oFIwIBvJE46dPVv31O8PgvIZY8xJ
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log_recover.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 12118d5..1212fa1 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2088,7 +2088,15 @@ xlog_recover_add_to_cont_trans(
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

