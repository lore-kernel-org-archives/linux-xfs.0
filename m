Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 105E1C433B4
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:18:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E259E6117A
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:18:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240975AbhDPJTL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 05:19:11 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:48386 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235231AbhDPJTB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Apr 2021 05:19:01 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G9A2FZ042760
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Lu/xJXQqK4Y4s2QPouqK+GV/fyLGcZACOwf4ZRKDonI=;
 b=qrEMrKXF7jAQGySmwWGnb7kPV2RQ9MmxPab/MgGueXd9fRfReu01P8batfSj+FolXxe1
 1HciNBmEw33dHtzVVqmKHcqIbtkzr1Ezh1FSh0V5j4lJW/rlI54q8BCyPZdFWCT2vV59
 8BUVDVKH6YygmMZRSI91FKkaGu+er79lH9UCgW8sWiJbzJhGPw7cfEVWjxi/5U31gwz2
 CRNwE7uXFe5s0y9CbVPqkVnzBTNd1ykvMJ/UxJADmSAZlwtH2okJnmoA9Xw0wtABh+BI
 kMbIOwQgCoioFS54eiPFGnilAVDx3EdU0J7Y7UsZkVJCFYXF0Ao0xdGAnT3zWAxlb3wa 7g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 37u1hbrpar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G9AXpV077087
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:36 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3030.oracle.com with ESMTP id 37uny2cbx1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HPcC+w8ZumrV+QbLGN6G5KbjDPUAaEJfD6BRc8ANd67alcdAZMFYNN9jUqJKCnVbQ/bGIoV0CytLUBjoMCzryJoF/nihpOj98UF2ODgWw0keRLRSfzlOxDUkZ+Tmo+1GncAjCCK/GjRwR5ylEt8rxjVFhYg2TcDi/fFzabgi9vSUa/4SEUdc3YqOeISTPkZAClbve5RG7fjVk3fosuLiRD9TBdKeD4sjCBzFqG7VbWMvHXZuMQo96DL0fqKxP1B3JsslZc3FrTnLbCjZgGuHCOzo7asm+yEhdKWHU1akVAo+FQKSDuQq6tMctevMQu7zjq5rpnol8plORSfH0c167w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lu/xJXQqK4Y4s2QPouqK+GV/fyLGcZACOwf4ZRKDonI=;
 b=gBzlayw8TegunIGUoOE0gPASXY8Fj5Ay1yEBEvWLy9q9uvI9OuFA1dTH4XmeTz6kivmOUuONo+qSzaYvUdzCE47UQRH7++4XCEgoFoxOY8cnSrGFy2rmYXyTIAOSlR+bvFlgx/7LfsY3niwB3/D/2R2GJXzmoYg0jDKkVLq7yra4SQU6G2AIe9he+oXKrK4UtfXpsq0A1PTaUEsL46dF2tfwFOToR6va55ZapBO3UFpQITp/GCmJjHA2XsPYuIF87CUT2QfKQkD9DUKbL/uq3SAwuCqlKewU/YNedUA6Tr+VszM/IQSyhwcfJu8Lf/PCrnqfS4qHGVVqdZ6oKXMAEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lu/xJXQqK4Y4s2QPouqK+GV/fyLGcZACOwf4ZRKDonI=;
 b=ESMzFw3NIENBcE2ePu2n/VkRrv02sMWbi9hnVZ8VOPdX3WJqi2qTFrhOEAjrsPxVAQHm2yKeP8frAWmCYuytd0t4WHOKd17yfQrshTI+xIXNikAgzXM1JhVbQICc3qt9nxfO6xxmlS+GDuvTJsNn1dot0t8ci+z8fY4tn1n/I/s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2486.namprd10.prod.outlook.com (2603:10b6:a02:b8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Fri, 16 Apr
 2021 09:18:33 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 09:18:33 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v17 06/12] xfsprogs: Separate xfs_attr_node_addname and xfs_attr_node_addname_clear_incomplete
Date:   Fri, 16 Apr 2021 02:18:08 -0700
Message-Id: <20210416091814.2041-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210416091814.2041-1-allison.henderson@oracle.com>
References: <20210416091814.2041-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BYAPR07CA0070.namprd07.prod.outlook.com
 (2603:10b6:a03:60::47) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.222.141) by BYAPR07CA0070.namprd07.prod.outlook.com (2603:10b6:a03:60::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 09:18:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18ca5dbb-03c1-4930-6b10-08d900b89b8b
X-MS-TrafficTypeDiagnostic: BYAPR10MB2486:
X-Microsoft-Antispam-PRVS: <BYAPR10MB24865C9C32679EBC636E5F3E954C9@BYAPR10MB2486.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:330;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E8+Fx9wVB52O3A9jyUCV41skC05vQdo48m+14+G6yH0kCrkq2adp28HvlwgTQhHvCyTbiqLbo3m+xTpD9klk3hBq612eCbtufSEamQBoCGFnyA6t1ue8ayeuO+A0qhjevR7UGVvfNjOWaCKXsphWqGC+TVhGPrWIyPZpTg3mRwAaQ8JRuWUh+978mOMrsMzCFYgXxlmkhrLGE+MLevvzvyM0LCml0vvpBQyi8S1MDK2/p4EoC62Y+gYpP/O9+/LoCkMzjJoV0dJ8xkHvEzglzjeGnfX5qRDk4vfMT+VDL04gGG8WUZU3vZUGp01PDFj/wKX6lLhQI0mar41xieUShbIc4i6/FZ1jYjiCKgTk4regp5Xx0qQVUl3JU2geLmKYoOHvZAd6yOd/XhroK9S/UYw2oHWgI+ONbImODkrSH8Ln5lNAKUCu86ukRm+ExkdSAY8fI6gnIvPP64Y3wcwt2f4EHNkCTy/q+5ra6lmxU2F0ByaudpVVYmzWsyyKeRaT086s1q9nmugGWc12gMW6H/YHnCgepD57yuE3TmAezvDKIl1L1zYgv7z5GBUYef4NQMfi1zX5CKheWLQSoHzalj/RNdY7oFxDLjqE6FI5kyoI9lpSNwHl0ja5YILkljrYvT5qEp+glD4nE9xX2nfgnKVfEs6Xa+Dz80PwR3Ga7Xjt+4Eu2vPjSHjbGw0xYkg2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(366004)(136003)(39860400002)(346002)(8676002)(36756003)(8936002)(38100700002)(508600001)(38350700002)(6486002)(66556008)(66946007)(66476007)(956004)(52116002)(6506007)(6512007)(316002)(86362001)(44832011)(1076003)(26005)(2906002)(6916009)(6666004)(16526019)(186003)(69590400012)(5660300002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2251lmaGQuZziN9lswg3YUwPnw8EjgJ7tBpRB6yH3COulonKzzEtT9y3ISnZ?=
 =?us-ascii?Q?/mENwNUx6WyG/PsOzGe49vwrULORIgUnNAxa5eIIVAkvJ4T5rZb+q0l8NWPf?=
 =?us-ascii?Q?+mHI0vUT+7haDxoGEQ5N12Hdxo9Hx/H3RZ8BLVdyyz64d/cO9Z7s+hcXrnqb?=
 =?us-ascii?Q?+5NfiAGXxCejAnIbM2tEE5tGyHRFZZ1+WRfQFywzkZ88agGq172X5Onjbzhk?=
 =?us-ascii?Q?XnE8OG9oFIK2GaZxvTthHj/guCE4/ulYmZ09dC8XN6GUsdnjTK0q5oK99fI3?=
 =?us-ascii?Q?PG+70N/TqqO9LCaFwNxyjLL5bAHaT4284C8jydtmZAdxwM00oP96ejhZr7Kp?=
 =?us-ascii?Q?ShWSY4K8pGHdXlq6NmQAXNKcdmZIN/bIhWzRGka9PC5sc8ewZjFXLV+2iU/I?=
 =?us-ascii?Q?XINQ5bG8DSPR7oJVpN6OJvYgbiPH6naGwBZImRZkfe1eL+kJLRV3zIRrC/V8?=
 =?us-ascii?Q?wb1ELnNMMGSaPhkEoP1HYbIW2KSwLJWig5WeyiaBl3AH069KOkCrrKd3aaHE?=
 =?us-ascii?Q?dkKkyfH8gbZEb9fZmtJvuox8weCZcBgmGjYrocDcE3QccNIer6zQwnLAOgL5?=
 =?us-ascii?Q?EIeZGHmcIh3blcS+1X829w6zjaRPP5yvY+PoKKpKQVdMIEcFd/jxHZ+lzPSH?=
 =?us-ascii?Q?aAcFSoyQqc5piNugrkUx09PQGP/mrhL6rHRBREkClz4aRaD5jBE1aSRTR9/q?=
 =?us-ascii?Q?UMD5GYjzGXpJiveI+ZGVYrmL7T2d7s79uIGRwGapM3juLn5XByikneHgB0KQ?=
 =?us-ascii?Q?cW7zRFcWNPz2A6Fmfis1/0pNtwgJnr+vrsvYvSnu9OiqniCFIGCYeH9BdGV6?=
 =?us-ascii?Q?ZyTTsHFQUp0y+oxsstLH4xixg2pfG1bXTshJVTLyrKwBt3u9GkFHJkHOCBNv?=
 =?us-ascii?Q?lZayJ0hDo/OUsTKnUTSNhqWBXvT3mxtqjHzvGmJs3kOx8/Y5jPjcBJMnvqcc?=
 =?us-ascii?Q?dFbNeXupFE4tGe9MNY+steVMoxiWTbczEktizBOEVyIsG1/csCziFb1Tfb+6?=
 =?us-ascii?Q?bc7cwwWdNsoOscuZJus5bZ1nP0PA/UvC6HOT4rUMABzkY06e7+ssKrBnAJHW?=
 =?us-ascii?Q?usKaEk1aV2IiaOKuQklO550MONWhAdewwH3XKx+Zplf/6VMYxYuOYt1jc3+N?=
 =?us-ascii?Q?mRaAk62XRjgOp63g2sUQv/BQIQX2ik8gPAW5WyYtMM642WxAxpVqThWD4eSv?=
 =?us-ascii?Q?ob7R2sz56rkkcVgKQCwOvDbWQ25+IapNqP5tV4Zm5KtWtPmHr8C/+mvRdtYV?=
 =?us-ascii?Q?0sv+eDdyZzUpNXqe+ONaQdMZuuwWg8ZDgbcN30G9PZAWhPOGicpTBpaImaF4?=
 =?us-ascii?Q?IUNvmz+7RHmgU+fJSgKSmtDt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18ca5dbb-03c1-4930-6b10-08d900b89b8b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 09:18:33.4438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AsiQ/F+HHGvf9vnJx850pvgYQhmP8Eo4OIM4pXt016wOdyyXNIvDGeU6mEnwcZV3zxeR3RbZ+aAaKoPnpLPQ4GIlWjZ4Wmeui+guKQAj3Ak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2486
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160070
X-Proofpoint-GUID: oAsKXBLTy9qCsv7UtpiHaGu-_0sYBq5-
X-Proofpoint-ORIG-GUID: oAsKXBLTy9qCsv7UtpiHaGu-_0sYBq5-
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160070
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 392a7ea8080e3753aa179d4daaa2ad413d0ff441

This patch separate xfs_attr_node_addname into two functions.  This will
help to make it easier to hoist parts of xfs_attr_node_addname that need
state management

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 libxfs/xfs_attr.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 40d1e6e..3666c6c 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -54,6 +54,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
+STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
@@ -1061,6 +1062,25 @@ restart:
 			return error;
 	}
 
+	error = xfs_attr_node_addname_clear_incomplete(args);
+out:
+	if (state)
+		xfs_da_state_free(state);
+	if (error)
+		return error;
+	return retval;
+}
+
+
+STATIC
+int xfs_attr_node_addname_clear_incomplete(
+	struct xfs_da_args		*args)
+{
+	struct xfs_da_state		*state = NULL;
+	struct xfs_da_state_blk		*blk;
+	int				retval = 0;
+	int				error = 0;
+
 	/*
 	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
 	 * flag means that we will find the "old" attr, not the "new" one.
-- 
2.7.4

