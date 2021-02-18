Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E01FC4332B
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEF8C64EB8
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233076AbhBRSsA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:48:00 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:41274 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234037AbhBRQzU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:55:20 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGoiEE088991
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=nijqi6c/49iEyBMvZW31ntMapQNoFaEQIbre+GnRiPc=;
 b=ysqTD+fDsSNiRFlquVTE40YtQxzo25iStxNlsBJhAZdG7xFwBGJFzM5k2EYYGeR0HHHO
 fCwjzwZtmEGXw9SSVmUaeROT7/ksVlPF4QL1V4D4PUEa1H5XdWpM3ZeezXU5yN/qQPFh
 iWby7HSczZKKqVwLGwY9G554YFqeVyx2x4wICMvJbyY2RDF/jxEGDE0P8jM2ia3lAWnr
 IfIILs3tpi/mpLmsOD9jGJEosgcjbDzukTbUEog+Rd0GZWaY+AKWaEK2kmfaDccfTcmc
 Tabt4bGfqdJ4qLUKRFa3hW3OTCmuo85JcIy/3V3f7TMIcKesjhi8tEF2VvoZfKDt85gY 8A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 36p49besy5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGng2u162351
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:12 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by userp3020.oracle.com with ESMTP id 36prhufdmr-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gmwU3erEqv03TqxnPwgcqPeOPAoOKTmoXvQpRDNV8pnwKd0s0TxX8xfK3WNzLWtsd/oVvqd8WKz7iZejrZdhtotA9Xv71xDFgjcg7kp9tdGEQMemPhMKWwZ7ZoasEZ5vTUJFdJwmW8go5WsNo+yHHe9ig7MTP9O9d6shWQQzFwNKeHrKSTSPvLtwegOSYcPuzMfnNP4blYN3XPRMo72i6c3kwvNcyJ0+bOsj6Z7w+nBM4OIPnLrXemjGv+arwYQneJOQJbeq9RH49nGSAiilJGp1IaeI24JNTZWV5YjdHekIFnHpEwN0lysdY8LmgZRS7L8pE/7s7//bAZsdwaC86w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nijqi6c/49iEyBMvZW31ntMapQNoFaEQIbre+GnRiPc=;
 b=LdGE+aI7AGCq9cYGH6/t6dvrh4ECRfYnKNgBLLqrUBB4iJXPcr3cmx2wXZylOMEBZs72FZRS+zV1RkqVVTszFcqVsjQzPYRZjtZEpZ0BeIRN9UYSMcJMbY/Shdg3jaeMB52hFyC4Trfha6nXOkk2CDg2nWMon4SIzpRUtWl8gdHtpQWzxfGB1CkYCrFpL8PYJdiIhSZNs4Izp/cNqAzcKAKPTvUhpMYg68KiEtob84uurUXoANtp/0eUz5tanN+SNSTqzDZrdivD+GdvEmjsZIFZV9uwO/UYzT4dIP6Dm0Al3VqDCeDn3Ehxb2iVcgROXAQ/beRFfm1Q5Z8h/sONsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nijqi6c/49iEyBMvZW31ntMapQNoFaEQIbre+GnRiPc=;
 b=NH5/wuPp4WG5ccb31qqyhx+/hVSd/oBuFRH4N3MeMRiJm89gzTImZ1HZ/9glPKCXL5GCEsfaF+v8OHthj1yQsuLUGHWycZVOOtKCSkr9cYJ3BhWcvDRrRpxKT2qhYjEZHwtxjxwnzakDkFozbyLPQXuVtFZWi4b9g62xuHkBIWU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3381.namprd10.prod.outlook.com (2603:10b6:a03:15b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 16:54:11 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:54:10 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 15/22] xfs: Handle krealloc errors in xlog_recover_add_to_cont_trans
Date:   Thu, 18 Feb 2021 09:53:41 -0700
Message-Id: <20210218165348.4754-16-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218165348.4754-1-allison.henderson@oracle.com>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0352.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by SJ0PR03CA0352.namprd03.prod.outlook.com (2603:10b6:a03:39c::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:54:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c1c5475-c831-4cf0-e3e4-08d8d42dcfe4
X-MS-TrafficTypeDiagnostic: BYAPR10MB3381:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3381726A376128D5378F275C95859@BYAPR10MB3381.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c2Zx4pweYYElzh/eE0uWLK2DOP2CFs593t6yR8lmA1CRfwKysHDJE7udhWXbrXkrVV1BLTOnQb+g98dP48kNLf/L5EKyEI0FfQH8+8ytjPRb1voAXwHM66+/hGLrmsrjDkK54AZPqWgBPLkeTYyLYoPAvIuw2cJuTiYYxnwdHfNiBdy2j2oKc6iLMZXQiOnALAMZa8KmaCcrdjC+S4qrKzFvdsXkB5umz0hr+Xsp82mPvQWU9mWlPsqjE8pZNFHDWB+lk79Srsc35yNTxsoOia3sFar1zdlYZ5+JEVUmU8MPXBbLRmaTAwrP8QCLBWKcuTDjkVK8fJllGatJPC2xKuuE3GTNpN966kecYBUgU6CsrxEsosfkmH0+yvu0NaHvKDTvalvEJd+hqeEaXYyKYEzwICShCUx/3Fn5jX7CULS6jIWuyelv1wS+1asr4SXgLIVccLVUpkE/l6ZcFIlzEwJAH4HwSHzlYgbv5hW8RsCcV7S7+Sla0bCP5V9nJpNhXIshQgMnjTJvndjTP0mva3rbG3RyaA4AGmkvrmpQl3asWIZgUsUqGSS6B6NHddC4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(136003)(346002)(396003)(186003)(26005)(1076003)(16526019)(66556008)(8936002)(69590400012)(36756003)(6512007)(66946007)(6916009)(6666004)(86362001)(478600001)(52116002)(5660300002)(66476007)(8676002)(2616005)(2906002)(83380400001)(316002)(956004)(6506007)(44832011)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?CL+38KhYJmcph4nHhL8sfqp49YP8vB2KAVRsVrQ2PyG3VSZSERqcsClPd/os?=
 =?us-ascii?Q?YKX4Fby2TA0YbaLusVR2iFAkjKo/cI8FUPcFkEGepwPQkctrKgVWpiKOK5sC?=
 =?us-ascii?Q?GPtGiJojIc/5weOp63JnXlkbnun/XLjvkXA783cODT5j0ToztnbK/pI/X+j5?=
 =?us-ascii?Q?zQaeDPoopWCdOmb6ZGm6XWAMppg7en+VhDRrfM1gMFi1kbNid2r4G3Vz6OcV?=
 =?us-ascii?Q?lPWZTOphZuNrKZ5T2CrS1xSdl50c6RXueXNHyjBuCvM+XwZRvPjO5DdPKNda?=
 =?us-ascii?Q?pa1h+mbvMM83cNJSwWwTL4I8nh3MTl/OChZ/C5GkIMVYp951gt7grGL3VDCJ?=
 =?us-ascii?Q?BnayhkKQNAbp0fBstCGR/0DDgOcPtfqH3HkjW6xiweMqHCtG+2Z6MInG3rT5?=
 =?us-ascii?Q?kt56jGcSHEBxuEn/ddadYGUV8vS/gp9XkkgYq64u34xkz9GKvi1QWHSgY/zR?=
 =?us-ascii?Q?hXBTrEc32b8wtxK/a+VZJWeiiy0IwiYSC7bbmPxAz53ZAuQJ6I6MklkNwofk?=
 =?us-ascii?Q?vRTGLashVLuJjOok3DI+dduyZT1xU69wWxpmfiihkY2v9TaQ5p1hUMxNFP2e?=
 =?us-ascii?Q?MPRzwwQ3paoZM/6q73jBZIO8NaYHbkn3BszNUOs284B57vP0yyOxETQa7Gmx?=
 =?us-ascii?Q?uqQ4S87kjKYc7K9cb1V+Wdmfza7ntQOCkryjUrUv4Mv1EJX4M5lGnl6ZDQLc?=
 =?us-ascii?Q?5MP798KmJ/ypN1X4ly79EffTbJ0ifAJ5lIFJDGLF2vVPHXpJ1LsT8aL8eW4N?=
 =?us-ascii?Q?1O1zp8aa1jll7b2vsWU9B6YFnZAmKZ0Dw+BM7aDN4h4MPkYdvd700jgDolTt?=
 =?us-ascii?Q?kglKXht5vjusAw1GGqkaMycPplo6wrd20AtxXNGY/iIU2PH5QYL2HjgEhU9F?=
 =?us-ascii?Q?/WRpNjk+AtegUouXw/JYpaNRo1sxoiGsic7fiStXCS9OgnCyeEKwaVvfGTvq?=
 =?us-ascii?Q?I6jjpEuQ2h4LAFpXJOkfX9mAY0MBC+Plmc0cwek7a1aQEUvAWrpgk5S0gtR7?=
 =?us-ascii?Q?8TAcgj98UVq0vAbcbHcmtgDZDE4RMOD1F8BjT0ENYHwkC+7IycBzqApXGQc3?=
 =?us-ascii?Q?SAQNZBU4MqfZ6FQALqlTK6vNzKlF5jRJ7MHC4mfdGiypxknPkVnqvkBm+4Ln?=
 =?us-ascii?Q?jsIpkJEaYlOwhOfIVV2H9QDsQO19rSqcAinOTA+pHUjgcwtR7f4b/j7rW9/F?=
 =?us-ascii?Q?bNeBtNV+/et1xDQPbcx2eiIw6iCjWLAPxTb/kuVb20BxXPab3OA3ddY9hPyf?=
 =?us-ascii?Q?HTRPA8VkPB1lMk9InX15yoZhyrRi3dQDTZznAIgxCR8x5bmS8HQgL3Vcecgn?=
 =?us-ascii?Q?8jBgKQ4hzyiOsy3XJ09WjixW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c1c5475-c831-4cf0-e3e4-08d8d42dcfe4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:54:10.0830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AAyK9T1prhtYmKoi0/jvRX+Z05X7+IHpM7n2V3Rbm7SlijnNmLhnw/0U8V3+sGVGngv2z4yF8tjvEWP0md/n+Si3GK8n/UViCtj9nCnrPQ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3381
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180142
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180142
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Because xattrs can be over a page in size, we need to handle possible
krealloc errors to avoid warnings

The warning:
   WARNING: CPU: 1 PID: 20255 at mm/page_alloc.c:3446
                 get_page_from_freelist+0x100b/0x1690

is caused when sizes larger that a page are allocated with the
__GFP_NOFAIL flag option.  We encounter this error now because attr
values can be up to 64k in size.  So we cannot use __GFP_NOFAIL, and
we need to handle the error code if the allocation fails.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_log_recover.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 97f3130..295a5c6 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2061,7 +2061,10 @@ xlog_recover_add_to_cont_trans(
 	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
 	old_len = item->ri_buf[item->ri_cnt-1].i_len;
 
-	ptr = krealloc(old_ptr, len + old_len, GFP_KERNEL | __GFP_NOFAIL);
+	ptr = krealloc(old_ptr, len + old_len, GFP_KERNEL);
+	if (ptr == NULL)
+		return -ENOMEM;
+
 	memcpy(&ptr[old_len], dp, len);
 	item->ri_buf[item->ri_cnt-1].i_len += len;
 	item->ri_buf[item->ri_cnt-1].i_addr = ptr;
-- 
2.7.4

