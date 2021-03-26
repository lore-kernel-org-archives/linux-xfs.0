Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 014ECC433C1
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6D42619FC
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhCZAb7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:31:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33206 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbhCZAbp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:31:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0VjpX058702
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=TOOBB0sq3MTNlwRa7Cz/k3KxX2lVRPUBo0E0YE4Rq2A=;
 b=JFU5iHN3XPJMQ+V1WWu6DHHA02qlggpf2oMm7JovQ0IvC3OkMOfX4/UvjZoWqGZdMJ46
 v6foiJdisGJMeiiGDbQXx3ZBvhMs6JnOY2tY0dejCiNJNbf+Vb6nkZgcG3ZM3I091cik
 x2XVWKh5GQazmChtr7h8LAKrRzubSPfMame5hSGBevbj4yS94WsAhc7vgtski0JpHSZN
 VPDA0W0Dq5TwXGZJi8/mVyuKRwvZzAN5N1X+Uv1OQd61vspJI2GnfrWjq8TGFWzREevv
 v2LPi2/9ypfMYMmU5FjTPvoIpeBNSbbh1Z5Or0/9C4EhLi9sLzLD/9ABgtAdIFmYcQZN vw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 37h13rrh87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0PK6I155451
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:45 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3030.oracle.com with ESMTP id 37h13x0454-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kBLh0l4Ftrm4nQJzOdNfy9kj9eMXSwghBGr46+qTrkmjcbBK7pYpE/rC1aed/VJqgGHOH3rPzc9/IMrSwO2bUnNvnDXI49JMPo6NOdfTojFvyPlxQwtzfrfXSsyNPH/i3j7I2/xOb5BBg+X9vu1SOYvU1m8CTGuPeiBgRgGj8IubQUdohcDuNbR8FB8efdhDyM0igLYKmQG0XgIH3XDiJHG3En2MqMSVVSqeRvfH85kYVLW5GUek902vS85v3yLuYu+mEqF1u/43eT2Spy3n1Y3y2YgHdIoJpFj/9vmtA+zkZYSsULm6PPR+UqpR1zm/OMr2DQGwjbk6QDvZ1slHDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOOBB0sq3MTNlwRa7Cz/k3KxX2lVRPUBo0E0YE4Rq2A=;
 b=LHs/adzV5/2vR0UEl7HX0Pk/YDU+rm5CdbPNeLT+aOsJRx4wrj72Os0M02WmsikMjaDPWRJ1+6clhwYgFLgLcWAE4cX7mdDTLsG/+CTp636XDJoAv0N0ySRSGeSNaKTkzdLC55nq07GXK2EEB+HdYjq5+a9avW2Y+BENzcNIx2BTK5+z53eahChlENDzuQXYS/b0AAMng2Ojvygik7d71dVbvZ9+nLVK66Yx1KOl/IwW12LiOTMQf4q9NtIsGf8kNFxpoQTF15WEhNxSe8mRnDd7i9yzXiCtrGolUI5cqMVtL9LX38Mhb4RPNGjaCH0WM80Oniq0ig5+Z8bSIhARbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOOBB0sq3MTNlwRa7Cz/k3KxX2lVRPUBo0E0YE4Rq2A=;
 b=rD1hPbMt37NKI97pCqSP1n2hiuH7Mo0oHSj2rwAnSYt8NDWlq16ZqNgStugDB6B90w8QbZJUAhbt5CSslWIQRQlV1J6Rthtwx4xGj3BqdsPFx1xM2GMKZ1m4fg2KQQ1g/ZQPmYzR5/vOfTUesG4zw1UkyYAFItvC6T9ENJtN7TY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2758.namprd10.prod.outlook.com (2603:10b6:a02:ba::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Fri, 26 Mar
 2021 00:31:42 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:31:42 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 02/28] xfsprogs: Add helper for checking per-inode extent count overflow
Date:   Thu, 25 Mar 2021 17:31:05 -0700
Message-Id: <20210326003131.32642-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210326003131.32642-1-allison.henderson@oracle.com>
References: <20210326003131.32642-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR07CA0078.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR07CA0078.namprd07.prod.outlook.com (2603:10b6:a03:12b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 00:31:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08125fab-79f0-4321-9be8-08d8efee8745
X-MS-TrafficTypeDiagnostic: BYAPR10MB2758:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2758742DFD6517B62EAD539E95619@BYAPR10MB2758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:883;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PWEUafQs9ZK2d6xjlKyyPxheGjahLfvBtauQeEBoJG/ImcDfwOFmaN1CvyPDQZK9jxCvr8ClcdMtb9A3odXzLXyLMlU3Y6T6Fr6zoTzd6LobQbOWQEvfvO5E+P99/OKOQXTElN7KQr/oP1cPxVNEl8Ki9qtYotjHjiBgsVA+ezyBfGtxuQbflrk1+tdjsUuQymLPn3rhTtpVtaPcA4q4FEU6zVxKLBxfPl+FtBkALkWSoesE3+vyATdY4kjSWFJ90gBsaox1WQxceYapIddZDHc2Y6MkSitwv8hmR/PocKsMrntWF9d6zTBUFu+aiX+3uA2g5oT0pUfYHteSdXW97fidXAU1+5p1LQHkQ9QhDfS0C+UfkOQOLPQOdd8l6K+8tqfH9DeCi8dXco5Vlth7X3IrxBnVbHfHAQUJA+PZYX8wUCzMOLQcxcX8bidwC4Ij/q4yTuC+PQDJgrEi3ETNn51A+n0PIHXy5xC69OyOj6GPgGZYUx8qRT6MJI2492RG6nlcvImgIauqjIX8o753Rj+WWnuWX8Ac/JCQrdaF1rqnjSHmhczxTRViUyNxKOqdm04vJmR/bpPT8VMo8F4Uxj7FZ6dhTPrdF7K3dghjRQ2wyu6SoIEaMdyT9AUJLSrQGJlMfMuCUxXBtRdq//L/B1RRPQaxEuWBSaW4llseZGDnEINO8NMjzSC3BVLealrw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(396003)(366004)(136003)(316002)(6666004)(5660300002)(6486002)(16526019)(478600001)(52116002)(8676002)(186003)(44832011)(1076003)(8936002)(956004)(2616005)(66556008)(38100700001)(83380400001)(6506007)(2906002)(66476007)(86362001)(6916009)(66946007)(26005)(69590400012)(6512007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1uqHImDqKUxzH4tA60HP1ojWZ0JyVRrDsRqHtdd04UjujPjjuZMduJZ+NlwJ?=
 =?us-ascii?Q?ibnBBgMTgCtXilPPHjzd76TynP689X3qwOHgOF61dBxfUtmiZLty6YEQW1tI?=
 =?us-ascii?Q?oI1lRCNez2QMGDIOIkLAON+fxBGJ9xGp8CbCw6Cv7Ub3yryfRZIFq114M8g1?=
 =?us-ascii?Q?4ZlKRFUAmb/waYwd1tlSBEgXB7QD3VrxgQYJDop7gwfBbkrD8wC5Ge4W52Va?=
 =?us-ascii?Q?oiwZsY1saR8TQFSgcJF5anaQKJ5Ql+yNq8Zx7ZxMf7vN4GtPZkQseLod3+R4?=
 =?us-ascii?Q?mzsM4didk+avyleTjbJfZ6d5WomtCPxvJg9nkT4HuKvsmItDhnPJHPHqdlVK?=
 =?us-ascii?Q?7zLLMMy+qB5KhPFC9qF4BdIQvG3A7i7G8U99VR/036cHX3NT/pee+UnAEMCJ?=
 =?us-ascii?Q?yjInt89jxAqEYpj+yfTX+qVUs7L64WCrUEaK1vmIYbw3n+LS3ibQXIFG2/t0?=
 =?us-ascii?Q?LMNTmw+PS54uvt1e8tGdmXqBNIKr8JIoXVoWyhqdyhhFLYramchpTtRmu09G?=
 =?us-ascii?Q?lq+vs98i+JTJxFyBCeP9inhEGkxzd//5DD3sy4Fofqt/7XeQv3ToaSg+Xd2G?=
 =?us-ascii?Q?z+DeHU5+XMrPG5cp0zwV1SpnGtJXsJEYd6fMbPW1L1OIt3PrJmxQupIft+Le?=
 =?us-ascii?Q?ZvtTB32v/Wn4a6TTdiEOsFJ4WwyNl3IUiQv1QPZ9MJFbKHcA4bXgKXjFR0WD?=
 =?us-ascii?Q?KxwNyQb3u2TJQzF3gnFCfv4ry9tKq7QOd+JYUAMIUZgsYg1iE7W/sQkp7wxw?=
 =?us-ascii?Q?fKQoWmFtStyYZA0AYHOxBf3UIgsLpwaPzOWr4wb3Vqb7pu+EbJdBOtWjaeIp?=
 =?us-ascii?Q?SH9a0xtzzfVfvDIJhGPZ09iw8jsXFRCGNulyF/RL79IYzeDtp9npEY5i4UyJ?=
 =?us-ascii?Q?MxGNnDAqrQQ8SNiQsJNt3s+nsD+YmqwpMN286N4OeQasJskpm0hjgPvq29WR?=
 =?us-ascii?Q?daYfyWmVCzVBpI5GnJFg0VipzA9s2a00HU1+Ag47RTTqLYUjc/0t/Ah4XFbl?=
 =?us-ascii?Q?jCeg9wGFyqpvXxGQzjfwDtd/O3MJoaNJEDQx9oMLVTHVmPXEF9NU+KdIH1HE?=
 =?us-ascii?Q?EpHm8uC32bUSwfZzn3FpNOSspN/b+xEMepl6A/cw/NBKht/4C2c3OobBeilx?=
 =?us-ascii?Q?nD/QeNV5bgJEnJNco8+q+P+zGsSgGQtsURN1OteLJxHAqkPqs8Z0/TGwhGPb?=
 =?us-ascii?Q?eKlEb2/Ujd+sR4MF6FFG+GVcUkONIILSazvT6u/OV5JrUujz/pMnrBbtDPn6?=
 =?us-ascii?Q?DRAeOoHi/4/Qc/bpSzeXYr1+jcuVnDMeVSckBuWdO1V0z8qdgmB1Dw8SY0lX?=
 =?us-ascii?Q?Qv6LjCkq+4MXKJ9Tc8M+WZwT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08125fab-79f0-4321-9be8-08d8efee8745
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:31:42.5139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 42e5n9jsyWSib7tUOPto4A2QIdYsWVcdOtm4Crk57o1HT7PkyPuMiX5b8s2kWloBwsMXabPBCS0F/jASC51MMVQkWSfMb1FgPdO82mgHgNY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2758
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
X-Proofpoint-ORIG-GUID: 1b-0Ml2Qx5g1gwh-Z78woSFqX7KU135E
X-Proofpoint-GUID: 1b-0Ml2Qx5g1gwh-Z78woSFqX7KU135E
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Chandan Babu R <chandanrlinux@gmail.com>

Source kernel commit: b9b7e1dc56c5ca8d6fc37c410b054e9f26737d2e

XFS does not check for possible overflow of per-inode extent counter
fields when adding extents to either data or attr fork.

For e.g.
1. Insert 5 million xattrs (each having a value size of 255 bytes) and
then delete 50% of them in an alternating manner.

2. On a 4k block sized XFS filesystem instance, the above causes 98511
extents to be created in the attr fork of the inode.

xfsaild/loop0  2008 [003]  1475.127209: probe:xfs_inode_to_disk: (ffffffffa43fb6b0) if_nextents=98511 i_ino=131

3. The incore inode fork extent counter is a signed 32-bit
quantity. However the on-disk extent counter is an unsigned 16-bit
quantity and hence cannot hold 98511 extents.

4. The following incorrect value is stored in the attr extent counter,
core.naextents = -32561

This commit adds a new helper function (i.e.
xfs_iext_count_may_overflow()) to check for overflow of the per-inode
data and xattr extent counters. Future patches will use this function to
make sure that an FS operation won't cause the extent counter to
overflow.

Suggested-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_inode_fork.c | 23 +++++++++++++++++++++++
 libxfs/xfs_inode_fork.h |  2 ++
 2 files changed, 25 insertions(+)

diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 0b1af501..83866cd 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -21,6 +21,7 @@
 #include "xfs_da_btree.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_attr_leaf.h"
+#include "xfs_types.h"
 
 kmem_zone_t *xfs_ifork_zone;
 
@@ -726,3 +727,25 @@ xfs_ifork_verify_local_attr(
 
 	return 0;
 }
+
+int
+xfs_iext_count_may_overflow(
+	struct xfs_inode	*ip,
+	int			whichfork,
+	int			nr_to_add)
+{
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	uint64_t		max_exts;
+	uint64_t		nr_exts;
+
+	if (whichfork == XFS_COW_FORK)
+		return 0;
+
+	max_exts = (whichfork == XFS_ATTR_FORK) ? MAXAEXTNUM : MAXEXTNUM;
+
+	nr_exts = ifp->if_nextents + nr_to_add;
+	if (nr_exts < ifp->if_nextents || nr_exts > max_exts)
+		return -EFBIG;
+
+	return 0;
+}
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index a4953e9..0beb8e2 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -172,5 +172,7 @@ extern void xfs_ifork_init_cow(struct xfs_inode *ip);
 
 int xfs_ifork_verify_local_data(struct xfs_inode *ip);
 int xfs_ifork_verify_local_attr(struct xfs_inode *ip);
+int xfs_iext_count_may_overflow(struct xfs_inode *ip, int whichfork,
+		int nr_to_add);
 
 #endif	/* __XFS_INODE_FORK_H__ */
-- 
2.7.4

