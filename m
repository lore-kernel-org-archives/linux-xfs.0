Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 679E0C432C3
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3344064ECC
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbhBRSsQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:48:16 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:53556 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234039AbhBRQzV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:55:21 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGsFde016488
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ZnBZHNlspHmq8o5LaF7dfujX6JsYyOFJVSyqQr7EK2Q=;
 b=uI6W/RfHyfGvKmFJ7ZARZ6MhOkzhzq+b17Xg/8cFm8nl/uP1g3/PBOXThN8FMiDYvYKs
 j+sNkW6nXChLspUcYoOWycBIjBRdtxooW8oTTLHroeAag/AyyaezimfCgYVaDDBhOZ3g
 7loWvl6HHEoMnd89jpv0tuo8cBhTF3TcDuupYRptsD16DX4MRBldpHmHa5/71VbxKC0J
 9qom7h2qD6huL2duDFabwFTiC5jS94nS0KITSyRCpfVtEEoBXiUAWlJ8tsp60AlVHh/m
 NqvTnqTaCEkkClYnymKCDKyXKnxlm+584mP2EvZAXO804gwkasyaWEqib5tn5LQumkvr bg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 36p7dnpj6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGoALJ119728
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:15 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by userp3030.oracle.com with ESMTP id 36prq0qeh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gD4QkrdI8pW5Q/7KpXSAUWcGyCofMiKa6HOISHfRyePk9hvp6gifz5bIDCX+xJaRBkZ7zKYLsnxtIPBMnxy2WWyruole4EGjlmtYXeyP/93K1Lc+06eqmZZ9Zk9kqc4aiUNilhTfHl6BnwEgJdAEze5XKYSdpFKb4Y0TJvMjbtscEZyMlMMlPcQgiDCS6Er/ewZRf/XXs4MNB/0UNY936+GhpJVLMPIOxnLUv0aLwClO4aKzjr2XIq3zk0WtiSncaT4rKsA+F/u2oiihFwK+u8/B7Dd6whMZ3oyd3ZIdU2bTHzr9BPKh3dCxjgRDG/Eez1vHXaFTlK8EpJJIJ20x7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZnBZHNlspHmq8o5LaF7dfujX6JsYyOFJVSyqQr7EK2Q=;
 b=lFJVksRFSchgciSsjog2UOGyfYRMRTQpnEgmhBcbikpp1W5nv0bArEJxdGV0Z0dAyVnJIjZBS59R6k6SuWspuhP8f+4MExz+hxFQvfBakbof6C2VcgiCK7ppCYK2NAlIbLM4Wb6HrMqOUI+X2GYeaOrgGhHfgRxX6Zbc5KG+FlP+WFIBDrlBcpgtWDtm0Np99Bag+o6zkCrRyQBGaf6xK6uSeK/yQqZnbAXll0KkNfkcso9QGpDNieASAlKfzsqf6u9yW9DAFjqcrYZ1Z+pJKkBNO+QOPDVddldHcx4tK/Z4J2HUIqjdC2Gp27dHWsKImhDXL0g6jW3PUQMYaffElw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZnBZHNlspHmq8o5LaF7dfujX6JsYyOFJVSyqQr7EK2Q=;
 b=p/85Q+Z7BlLehO3Zhr6t3uPQVXxxCZYMHI82ww7BtDy2wWDg19h9c8R0C6aEoZ9w0BH6Y9zaWs5tRs/9NOyz/5+6gChMkUrAyN161ayQH1m4sBHUUQ/IQJmyvkk4UvFnRaIY2bgiU0cl89gGXpTvX6TlSZkRcvjwMs8eYNjjFAI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3605.namprd10.prod.outlook.com (2603:10b6:a03:129::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 18 Feb
 2021 16:54:12 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:54:12 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 18/22] xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
Date:   Thu, 18 Feb 2021 09:53:44 -0700
Message-Id: <20210218165348.4754-19-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.223.248) by SJ0PR03CA0352.namprd03.prod.outlook.com (2603:10b6:a03:39c::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:54:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8bb4a30-429f-4211-443e-08d8d42dd0cc
X-MS-TrafficTypeDiagnostic: BYAPR10MB3605:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3605A4852B545ADF5A7BBE6195859@BYAPR10MB3605.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w6ZOLGitbxiUx+z85x0AR9lj6BOzt6bReOzofGkcrstonopySfbXxBmUZCB7sNrXlak+sUOFr0yPKDv3BjXX/Mu+moZNKv/JdaUXmLDHI1EIGS82/mhdQ00i5S5JuUjtCv9zM+1lOt+UWWgZFWI05qd/wRJintbNhMfGxyELlNuwfGxnoLF3XuC8CS0twbSWAiCd2iM9oTQBG3V9B8XiB4pCD8jgcHGbCSLaAAvh40m1JtaxG091q+CcSN/NIGaOTTc32/u1np1SxCfhna/2AWvwQ3HuPxskPrzGqHy4yQ5puzIFZC+kFSWjZzawjyejYxQMQw891fVGINpQVXzNFNva9VEEmRxYww/q9z3tB9Rte5A/qhBLozuetlby3LUt7E5sI+T4GPTj0ybPA9z0PmD8ykvuiFpiFcx8F3qvum7KmrIBFPTbYjWgwDxOGR+AulfCmIPHN7URjCNt+coB5pKIGG+KyO/goekPleDZwkoXlzB67DCYgq0xT0QHG3eK8Tyvd99CMal9ko9DUiAym1gB2SAdCeZ5MBsSihgAtjW9Vhfwi3uKp/nnYV+V3QodzNM5n1v+kaGSiOMTc/xOww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(366004)(136003)(376002)(396003)(5660300002)(52116002)(8936002)(6916009)(69590400012)(1076003)(478600001)(956004)(6512007)(26005)(16526019)(6486002)(186003)(2906002)(6506007)(2616005)(36756003)(83380400001)(66946007)(86362001)(44832011)(6666004)(66476007)(66556008)(8676002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?BceLw4fz9EPsWSoMDyuPGGR8GHKz860ABujvsviEK56EC95fQ0Gt7gRLE2/Q?=
 =?us-ascii?Q?i074iN6rgDoBlCfoNet3rwlfi0PQmZxqoRBBlfa0e0SuUltP4hC+PZZ21xGK?=
 =?us-ascii?Q?7r0tdV6aKeECAEmFUyhBBAVkifQabwU2zQpKrmv0mKGvOC1ZePD4M18ls9Iw?=
 =?us-ascii?Q?W+FSPLhg1FKWlIXZfTpPB5wZ8j6kyHyBPYbh3KG8oGtbOoQ7RYtl1k59/W24?=
 =?us-ascii?Q?yXPJPoMxR8SPSSfi0GHUEpqLHn8omLIDC+BK9/URPUSWiWOQtQx8sxrcShqL?=
 =?us-ascii?Q?snzpBjn4BQ4SwNOEhUtixg29daRpGSwN74taiC94C0jNMO74/oXhlNDMFH+J?=
 =?us-ascii?Q?P46hDuYFEeK1a92G5Zljjsy7gPN1CrhyvFUhRPdjC/IBLjiI2+ezLxR5UR+A?=
 =?us-ascii?Q?JDue0VzWCCkA+R+ToxMpkzN9VArt2vPFqOuGu6ejURby+BBjeIBDD1AXKgc6?=
 =?us-ascii?Q?7auAoM6w6TZmIxGOhLC5wkrCWqku0K58CWkqwgzcdVkGFCWA+Z/YviCwgZy1?=
 =?us-ascii?Q?XfpEPZPHaC6Tfyk34OIY/CnyGnqKgpS1NxHzF7lbD2aQnsia6EXo4oF5cKo1?=
 =?us-ascii?Q?xT57TLxepqsTPtlw7Jvu3giznzD5VRuIaw0dj4BTpzWQ/oURdryv5xcnfLfe?=
 =?us-ascii?Q?jQun04IZJQDlVHSxCDRyhB6NwAwmlml+kR3eS0SHm9ZfwZ02jZhCTpHciMG0?=
 =?us-ascii?Q?9Du3bqEFR2VcWf1FACbgDD/wIuAkXqRnRRqT07bsS2RMGCxe0LawFIyOIOhj?=
 =?us-ascii?Q?zONC5Jbc5tUNtaQqvRujqcf4zTYYlBDoHeTH/BOzLEGWzYRst2CiHEhe2JHb?=
 =?us-ascii?Q?Ub6kPS3hZxaVEXzFTTOGaBb3kmpxpB5iXQoa5GNdiHldjeziAGvgojRDNx3c?=
 =?us-ascii?Q?098BSaQBQhEUb6FL6GnObzGUp3p4iTBeP0w0Q4FdHfrlVfRjudmCV56JuxZI?=
 =?us-ascii?Q?UEitGdwd629izVWdgGJD2OktCCICdUbJDEmSXMLdQJ1exChGEkxukLsTcpRp?=
 =?us-ascii?Q?1uy6Cdl/DudZqc7BGOBwOQ4EU9QquVbgCZQeb7XxnBx7NLkWsytmWktBuof5?=
 =?us-ascii?Q?tpsco4WIhIHlAHJcAs703+2vkBXvW0mRtWC85j4/clsgU0YAkai8Sk77x44m?=
 =?us-ascii?Q?EnAbLOC7/ZkxSliI/Y4ABtVV9eekPF9oivADU5scj1srSIP+DYrVB7XrljRT?=
 =?us-ascii?Q?rVxUVefs/t7I1+kFnfoVLmePORNXW/TktLB04IqZBqb3RkG1BSnS1WcEwQnA?=
 =?us-ascii?Q?rjILIqu6Q/9yDrsCacWUXvjxskjxiWBMIRg4mCaUvf9aIK0hT78g9T2Ib/05?=
 =?us-ascii?Q?U/4U8cU6q4dFuUWrc79CKysh?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8bb4a30-429f-4211-443e-08d8d42dd0cc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:54:11.5774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HIcb65EDL4QvU8LmyG7VlUTJY0hRW+isk80zra35o+zq8TabshMsug9JGRhKH2IslXELMcZGrii+mKLbQX9IdQbFe3NKPOT5m3zsGWl9OMU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3605
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180142
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180143
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Collins <allison.henderson@oracle.com>

These routines to set up and start a new deferred attribute operations.
These functions are meant to be called by any routine needing to
initiate a deferred attribute operation as opposed to the existing
inline operations. New helper function xfs_attr_item_init also added.

Finally enable delayed attributes in xfs_attr_set and xfs_attr_remove.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_attr.h |  2 ++
 2 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 666cc69..cec861e 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -25,6 +25,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
 #include "xfs_attr_item.h"
+#include "xfs_attr.h"
 
 /*
  * xfs_attr.c
@@ -838,9 +839,10 @@ xfs_attr_set(
 		if (error != -ENOATTR && error != -EEXIST)
 			goto out_trans_cancel;
 
-		error = xfs_attr_set_args(args);
+		error = xfs_attr_set_deferred(args);
 		if (error)
 			goto out_trans_cancel;
+
 		/* shortform attribute has already been committed */
 		if (!args->trans)
 			goto out_unlock;
@@ -849,7 +851,7 @@ xfs_attr_set(
 		if (error != -EEXIST)
 			goto out_trans_cancel;
 
-		error = xfs_attr_remove_args(args);
+		error = xfs_attr_remove_deferred(args);
 		if (error)
 			goto out_trans_cancel;
 	}
@@ -879,6 +881,58 @@ xfs_attr_set(
 	goto out_unlock;
 }
 
+STATIC int
+xfs_attr_item_init(
+	struct xfs_da_args	*args,
+	unsigned int		op_flags,	/* op flag (set or remove) */
+	struct xfs_attr_item	**attr)		/* new xfs_attr_item */
+{
+
+	struct xfs_attr_item	*new;
+
+	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
+	new->xattri_op_flags = op_flags;
+	new->xattri_dac.da_args = args;
+
+	*attr = new;
+	return 0;
+}
+
+/* Sets an attribute for an inode as a deferred operation */
+int
+xfs_attr_set_deferred(
+	struct xfs_da_args	*args)
+{
+	struct xfs_attr_item	*new;
+	int			error = 0;
+
+	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_SET, &new);
+	if (error)
+		return error;
+
+	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+
+	return 0;
+}
+
+/* Removes an attribute for an inode as a deferred operation */
+int
+xfs_attr_remove_deferred(
+	struct xfs_da_args	*args)
+{
+
+	struct xfs_attr_item	*new;
+	int			error;
+
+	error  = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REMOVE, &new);
+	if (error)
+		return error;
+
+	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+
+	return 0;
+}
+
 /*========================================================================
  * External routines when attribute list is inside the inode
  *========================================================================*/
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index ee79763..4abf02c 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -462,5 +462,7 @@ bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
 			      struct xfs_da_args *args);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
+int xfs_attr_set_deferred(struct xfs_da_args *args);
+int xfs_attr_remove_deferred(struct xfs_da_args *args);
 
 #endif	/* __XFS_ATTR_H__ */
-- 
2.7.4

