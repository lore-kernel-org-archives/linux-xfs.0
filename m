Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E44E9C6FA91
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Sep 2022 05:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiIVFpp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Sep 2022 01:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiIVFph (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2022 01:45:37 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B703C7AC33
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2022 22:45:35 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28M3Dw1w019736
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=q7IY9TJb67x9DpeUO/yaNdJiidpbzeMN7GhQkS4p9N8=;
 b=jg4QvTqdNL0h2b6hZSmW4hVo2zWgSDpdGecIXSK2T1J91Ovv6En7AZuFYAflesAMx46H
 /wJJZPmkZIlf9HQqcZ8o32QgRggMNaOfMNlKr6ieArcrZbJJfcLhTwggyA1LuwLBavnd
 cZystJrWA3bxN10EuxNH6ENT22fnm/EXctlvpO7joW6EJGIfLQkSHIBMwzQgtW6iAKGb
 69OLeJwNsfy94b1hgo/qZAkr/joIBWxc5OJ9u+NvFI/O2BJVl5VjjA7kWWEophETt1lY
 DKRx/I8nm6oxeiRw/s9srR0QvRWTqELGecf3sDeQtFikoMusA5ffd/ffTkj2l7kEfkRr tQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn69kvchs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:34 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M4edF3032444
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:34 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3d46ycy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N9gY3BTab4bedjA7+uGS1gUOuVjI+pE3bG+n5gFdxtWj/nPKR+4PsVmNlGKxV/kVQRGs82Z6Bu4TEorVWhYnS8seZdCBEAGHWywhp/HAUHw/KMEAhhbqTnUpj/9/RZQ4T+iOjY2kLLHSqovQCVduQjTOrv5oRxv207AruU1rlO2SkuP5Z2ViI99NE5ZGScWofgHB3p+8Xi0Iklgwk4shFi6RcY39baluKAchQuQmt7UdjKelOtkC7RHWLOfya2DbdbRVTLMNSnscLsr2C8GhDOfSgdXXQzzt2mzwZlJ75RNmYPqg7n3KQ4mzX4Cr7oK5Y3EbO6Sn3lF8lUa8WUBsxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q7IY9TJb67x9DpeUO/yaNdJiidpbzeMN7GhQkS4p9N8=;
 b=kAMhkgA2vg/+/1yVyaybU8BQ1L7I9oQI6UVdDZ0gg2GCsKmECbY8XdSvbHcsn+uVnPHATUvP2J9NwNjZJx1j04LFwNuXnKhAjN/GAplPweQK08/uLpr/ealUEaZ4w0JzQbrNOEXRU0r8cEHS1FlA46JMzTt6DGEhkwT45ih7jZ9Fx7EXH4wVYlHcXvXQYAi+b6cfOJPEBN/40vdEHCTDFz0e+NZiqNoDtFcXQe06Um90ByyhSbezDh890wz6pIbbL/s8+3pLirGLboPeLwqjgTjBK4QWXih/bfq9Qe2C3jjBSEv3ArBjimFWGlsMCkGfCVRee14lVjaVM1t9+aftPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q7IY9TJb67x9DpeUO/yaNdJiidpbzeMN7GhQkS4p9N8=;
 b=g72ZBKUFjQX2vGpiPZ7D738MdknO6NNcD4EF6ko0ZhslFuLbm+Yr5sLvYDPfyyej8BUibfa5FXCxM+mjhHrzDcmKmgF7tNGowtGohu1P/GsvpOo90sFKktthm9YZ0bcjT25ygpvfqdEINkJnV9LmzwYUzd3aiM0h46iH++Upro4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4806.namprd10.prod.outlook.com (2603:10b6:510:3a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 05:45:32 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 05:45:31 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 22/26] xfs: Add helper function xfs_attr_list_context_init
Date:   Wed, 21 Sep 2022 22:44:54 -0700
Message-Id: <20220922054458.40826-23-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922054458.40826-1-allison.henderson@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0027.namprd04.prod.outlook.com
 (2603:10b6:a03:40::40) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4806:EE_
X-MS-Office365-Filtering-Correlation-Id: e51cad7b-ce4a-436d-59a2-08da9c5da9a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j2GOrz4v/RVY+4MJS7glj5R6Bpg3cCRZn43CPZk7lZny8VSB6PdmzRMqEZGsQw30XcbM0asqiufhBImpSb/pfZqqKCwTYFxJRQiz+zptdclVEuO1bVnrcUsmuj1J8s7PVqeLmYHSS+WVpT9K/ELn8HOzQ1AX0Q2vjKGiKQf49yPALm3a6r/eKp6XvLf9CQ4wVSMQd1imMmjZrLx8TAjWO7av9LLMBgnoeMyJCPlWTrSkzECl1IdIhGHMgFzegFCrag9u/JhUfPGZ4v5K0qLyOmmrzsniSpDZ0IZelyuvtcZCwUzxHgk2HPz9Gr2Ckew2sCkxV0ySb6UYS0KSnh6N+K+cnOzZxFktoiXEPYkxvCTA9AAKlprz2/tHnZ10yyMDhBt2eYhBBtXjvvwM6glTCN+sY7W+TMj74xxWh6nPRFMsWY5i1C8/Z/gnoKqUyEmXcvMlR/BrbGYcxDVx3sIL9pogiJ5uFd1X03bWarV1jZVOOQti5A096tni9Qnv6DtbeWisAiHSOt2AOWCI36rSdI/HB9Q/HCBzAWaIIGlf3Yg/88n939f1ygDNh6INcBNzsN1Ws+MasKBQlRGd8mfxm+S2DOyUza+Td0qSUtddeNOZFvwhpyKmaOUcNVdm5Tj/6Bh51ZFerhs45w4Y6oJRj4HhjU8U08GFh3+KnpngKOw3nJUDL1ZPrkZi+/GwExBxyFnbb8N9aTx96GrFHdSJUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199015)(38100700002)(86362001)(66556008)(6916009)(66476007)(8676002)(41300700001)(66946007)(2906002)(5660300002)(316002)(8936002)(186003)(83380400001)(1076003)(2616005)(6486002)(478600001)(6512007)(36756003)(26005)(6506007)(9686003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RUNRcY/RLcAI+j5HluvEzlrmlSTprKbUsw6z1+wg+4LZwlAZSUPDI0O0irtw?=
 =?us-ascii?Q?cXk7JLtxmigU8RwNwiKtchEsdmDftbp9YJUnzwZ409aGozR9n5FTo4aO2Gr8?=
 =?us-ascii?Q?ZZgUuZVj8Xgt2HK4+YVFoeaXDgCHJFO25XS3sgj8VeVAC4R/Jxg/jYUQYEoG?=
 =?us-ascii?Q?6ETJjXHObT/YyDibij1KB9uBCyvlmUkNXXQsrl3/IG5CXy0489yps0HT/ou3?=
 =?us-ascii?Q?ssKq9UlW9c7QXQZrUaU89fXH1BHz/QdJPcP8lFbg2xghotAJBAxUSqpJb+eP?=
 =?us-ascii?Q?tqFV5nNxtaTs4L6RDR4BH8TDRKouSln6ixQyVJTJZhbOOB/NytP0zirr8s7p?=
 =?us-ascii?Q?8+b2XuOhWNzI0nl+5nRNl4gssb+FDBpNXVUV1QxLRGehnDGm759qO/6SHtou?=
 =?us-ascii?Q?+5tWNee+1OQkAuQpi9J3dVQF/dSb2MfYpFGrsBUug/aL38GA+CdeFzcXlNhy?=
 =?us-ascii?Q?5NkR9JPvcyBbiagWxraa+vxqgTnJn4uZkZLwShqz8XhC8a9EydHD6cAFjRvv?=
 =?us-ascii?Q?/fywddK9jKpiOASbxlP28E+QPHFbNbNLWmYTyW24rPtZs2aUhKXbb/wISAyE?=
 =?us-ascii?Q?EB14bQNxPKgM60Bar6hfd3FHzIWlPDxZoyXN2UKeoUiAhEOUb+LCEE8S51fg?=
 =?us-ascii?Q?/eJb4NQ9SPzRiaCmkE9ifoF1HEoy+00ZZZzU+g5nifrXPolRi4ivEfo4BJvk?=
 =?us-ascii?Q?zYd7Vn22hfqbwKP5ELGYdnaWiytpDvRg4XLqJUREh90kyqYqPNqp3SNdAGc6?=
 =?us-ascii?Q?d6ynd9qSkbeN+f2wbVUpSE79IwPtlc/h5JqlpOz1c/eCxqKKO5b2F5xdw5vS?=
 =?us-ascii?Q?MNK80XFiKvTSCz68RFQ7I+QW/wbmqug9f4NgM2zolUGcIfI+iY64IARs9yvA?=
 =?us-ascii?Q?Fikhs3MCUJ/rcEHJlSIB1kb7EZWZ2YJiHjv7uesLCl01uYghUwgGrz6vcQII?=
 =?us-ascii?Q?JeMZAWDtU3BLZu1gcMeFyYtm+p4ed0oQ8W9MCqcAf8oja8q2pvM8I/+KJMq4?=
 =?us-ascii?Q?v/MpvhDnoREuWDC/MbQEz9wVrZsqJniDPl4RlsoFnImoSfbMx8ZPuux1W68Y?=
 =?us-ascii?Q?Lyf/oRmcVlPIMGxLdbfHXdsVBtqGMbsqjU+FSzPZeWHqOJS9ebEmG3+AiNdj?=
 =?us-ascii?Q?FeJqOd97KVRPDVhCChixZ5mpdOXxDr0/9jrpoudlmIYsSkMfPcBqkfM/Z7BR?=
 =?us-ascii?Q?O2LQL3cpYNaso/2PvZxZTALn9M5Eq3gF31FVHtoWeERCFxKeHQkY+EImnntR?=
 =?us-ascii?Q?3fDXxYQ6EBmyDQraVuPLWaMJY6fL0ZZ2RUjFwDV0JB4X1tRK82sVnz9998kp?=
 =?us-ascii?Q?dQrxZs1ZLapaazRl9kKlTyLnJWfUIHOPXGQlhu1LplD/QprKBtp3SWz8xLjP?=
 =?us-ascii?Q?yYjxMDAPceXwLBssboe/UtrtmDLPfBJETB+lMM3msWvzXoYbAv3gBzsfP2+a?=
 =?us-ascii?Q?q4wfh9CipEnsmotk7mNWsCSDaLR/3FrqiL6osG1/NeSGFcI/iSeVZfSji8BE?=
 =?us-ascii?Q?5OxNwy8o7LGCNR2Ic1U3dJ/8tqW0HyUIgb6hJCJZcuC6sJt+bAKzMK6/zDus?=
 =?us-ascii?Q?+Rqk+IBglKBYl9q+N9y4twcCMhkPweBwaHBk4TxAgpN9CYUPQyofzq7jAUG7?=
 =?us-ascii?Q?aw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e51cad7b-ce4a-436d-59a2-08da9c5da9a2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 05:45:31.8851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9rF/zgOyZWZ5d0vZG3nUm61lno+ohsIEM9x0AUWAvd+zHrOPHU1F5PexCXE0HZD7hHOoNGfvQO+knNIRCjcJvLHZg5pRS1EoKvPHtku2c8M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4806
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220037
X-Proofpoint-ORIG-GUID: He72htMjNDdAkGjY0kVgQFavuOzXVjAG
X-Proofpoint-GUID: He72htMjNDdAkGjY0kVgQFavuOzXVjAG
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds a helper function xfs_attr_list_context_init used by
xfs_attr_list. This function initializes the xfs_attr_list_context
structure passed to xfs_attr_list_int. We will need this later to call
xfs_attr_list_int_ilocked when the node is already locked.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c  |  1 +
 fs/xfs/xfs_ioctl.c | 54 ++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_ioctl.h |  2 ++
 3 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index c6c80265c0b2..cb456fd92b72 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -17,6 +17,7 @@
 #include "xfs_bmap_util.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
+#include "xfs_attr.h"
 #include "xfs_ioctl.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 1f783e979629..5b600d3f7981 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -369,6 +369,40 @@ xfs_attr_flags(
 	return 0;
 }
 
+/*
+ * Initializes an xfs_attr_list_context suitable for
+ * use by xfs_attr_list
+ */
+int
+xfs_ioc_attr_list_context_init(
+	struct xfs_inode		*dp,
+	char				*buffer,
+	int				bufsize,
+	int				flags,
+	struct xfs_attr_list_context	*context)
+{
+	struct xfs_attrlist		*alist;
+
+	/*
+	 * Initialize the output buffer.
+	 */
+	context->dp = dp;
+	context->resynch = 1;
+	context->attr_filter = xfs_attr_filter(flags);
+	context->buffer = buffer;
+	context->bufsize = round_down(bufsize, sizeof(uint32_t));
+	context->firstu = context->bufsize;
+	context->put_listent = xfs_ioc_attr_put_listent;
+
+	alist = context->buffer;
+	alist->al_count = 0;
+	alist->al_more = 0;
+	alist->al_offset[0] = context->bufsize;
+
+	return 0;
+}
+
+
 int
 xfs_ioc_attr_list(
 	struct xfs_inode		*dp,
@@ -378,7 +412,6 @@ xfs_ioc_attr_list(
 	struct xfs_attrlist_cursor __user *ucursor)
 {
 	struct xfs_attr_list_context	context = { };
-	struct xfs_attrlist		*alist;
 	void				*buffer;
 	int				error;
 
@@ -410,21 +443,10 @@ xfs_ioc_attr_list(
 	if (!buffer)
 		return -ENOMEM;
 
-	/*
-	 * Initialize the output buffer.
-	 */
-	context.dp = dp;
-	context.resynch = 1;
-	context.attr_filter = xfs_attr_filter(flags);
-	context.buffer = buffer;
-	context.bufsize = round_down(bufsize, sizeof(uint32_t));
-	context.firstu = context.bufsize;
-	context.put_listent = xfs_ioc_attr_put_listent;
-
-	alist = context.buffer;
-	alist->al_count = 0;
-	alist->al_more = 0;
-	alist->al_offset[0] = context.bufsize;
+	error = xfs_ioc_attr_list_context_init(dp, buffer, bufsize, flags,
+			&context);
+	if (error)
+		return error;
 
 	error = xfs_attr_list(&context);
 	if (error)
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index d4abba2c13c1..ca60e1c427a3 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -35,6 +35,8 @@ int xfs_ioc_attrmulti_one(struct file *parfilp, struct inode *inode,
 int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf,
 		      size_t bufsize, int flags,
 		      struct xfs_attrlist_cursor __user *ucursor);
+int xfs_ioc_attr_list_context_init(struct xfs_inode *dp, char *buffer,
+		int bufsize, int flags, struct xfs_attr_list_context *context);
 
 extern struct dentry *
 xfs_handle_to_dentry(
-- 
2.25.1

