Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14245C54E94
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 01:37:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbjAXBhG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:37:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232516AbjAXBhE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2023 20:37:04 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CB01A483
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 17:37:03 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O04h8f020122
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:37:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=vsMvGLx8okHtK0olwwc7WZqMVdIoOvrBE31gaFSs1aE=;
 b=Ua1v1hUVaXOyPf7OPBfb0y9O1FjJpmM4KN+Tptxmz6u5FQzhP+4YmuiOR/OkX1EH5teA
 Y6wtVi2VutBqHIRTeD8hxXXxtOT9nIyRir/PMq/vw14M1c8HxIYL/KCLHVTAI5H5rhTG
 gwxWbC52XcKWjvLtHYliEGbwtydwCrRec2lsPSv4LGcqnz066gQm2bMwsbLvPc87wMVt
 I2/m6oD4/H8t8zm1mOjVuznjqa7JD4/WvPiEcXNDRiDOkOmgpqvvDfNj/958Znq4ezPF
 b7MkT/vTrAkoX3Nc2yikCeMZTABlSJAwVpKDz/1mZLD1hPKs+zyCG5KCUslP0ByZDBoQ Qg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86ybcbj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:37:02 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NNTBcG039914
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:37:01 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2048.outbound.protection.outlook.com [104.47.57.48])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gb4b7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:37:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OCaIX5peg4oGE3/mXt8wrxE0rTdkJIthJKaIzDhsCbit7Qi/Oapf+PX7KpGSjmSgoIcarM1hHXjOi6twUfbGL3pjoN0IM8cspl2ceYToldiUvdv++IPBRQsIGXue/ynCYroLRja3+sx1sb/jHScatQjqd1Ew7fx/oVDOr+5iNDwEBKSLgZZ9gx9P8Ip0RDeoLcehCwcIpsxbOlWZDFzENrr8QWkN96WzO+luoG02DuaqvGjyxtztD7ixx0zNRORRIWtfEoWGw1wOAtczDgf69mWH19AJEIbjse3MAiLA9NXM+VyM5/1HqoCu+Djw6ks0qVzDpZ6bm/A6F/FlHvF3+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vsMvGLx8okHtK0olwwc7WZqMVdIoOvrBE31gaFSs1aE=;
 b=LSXedEyZuMfb+VC2ElCgRuR5CtZr0+2INNwKHiB1KCp23S9ijiZEYnAg/yqSIskW9Vtw42EuSPbPJn9A88ufx4lxJjCJDwTC+rGa436b4tbOVUn23k6RBgvnkmM/xv+PYHJwPAmrH6F7jHLAXC89AqSqd2Po1NOgBPtq47B/R/V2bsIrLub6kjOzpnrYAvWbssHQyeMW35H7/vnYJSAWBhpeG9wDSsVI8i3W+VixuXOWC1ZFb7UV3AExS/rJdtwMpnH7w/FNxo8qRfZdhgOeJyT4quajIyebyptHsXdGqCnA15Ugot045QoKVPsEd4MJ1UoLlObTWdq/k5F2pU994A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vsMvGLx8okHtK0olwwc7WZqMVdIoOvrBE31gaFSs1aE=;
 b=uHj2owC00FcLHGDRQIH0zmGhwgX42wwAX5dOoi7brUYZJiQu8NR7TVH44t6BbSPKqpfxCr8ZHTRldXT7jHvGbM/pvACz4H5WtJnV/Fexo9xZ/eliNR7/805AbqI/KxXvsnhAXV2fYCh1vejy1H2fhsBnmMJJS1M3amwp+JoGGEQ=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN7PR10MB7074.namprd10.prod.outlook.com (2603:10b6:806:34c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.8; Tue, 24 Jan
 2023 01:36:59 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 01:36:59 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 23/27] xfs: Add helper function xfs_attr_list_context_init
Date:   Mon, 23 Jan 2023 18:36:16 -0700
Message-Id: <20230124013620.1089319-24-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124013620.1089319-1-allison.henderson@oracle.com>
References: <20230124013620.1089319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0121.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::6) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SN7PR10MB7074:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c2dd9a8-76b0-4293-f7be-08dafdab7c5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pbUFdE4irPuuv8hjFCt3K3Yk41hz3tjaGG8/GYEnbLo0VMMqOvMLgIVSxV6lp8cndp3mS1/Cj7EqPyp9u3Y1se9YHzkJp/LkeYnQojtmSKUM3fC2uuYCJk/RK0Kckii9q2C/gkniOoAAyTh682ZzHrhehIDJ4S0abWWt9RcB4CLFBbCmDW8o5y4l8ZGzag9tfpMFFgQ9YAO3OdttyAig3iF3ccJ+clIP1t9Wrfp2w2zMCjwkvtnbKoilEPwxt1cJGo2xvwC20HiFl987NKp7L7Vz1i1WPmrcvGGSDgySEIPWGfKIxIedsfFRa7pubeRYLOw+WWcI+KdvJ54sq5f5KiIGk1Pdt/PS8De39LuhCp3Nlmpb/83xtFtJnWdXypMq1v+FhubnFOPeriyxmSxuE51rzPrhBeOpWyyTg+5fLQBUKKoMXIq9GxgTu3tCSKopDw2bQwsZruPsDHlt2bSdac7gYtGzLABoWoL6jMRLberndmxDOeVcmFHOkcrvEI4m9wrHmCUXdTXfX+lHQf0bJEVqes1CXNtKD64uFQA7ZhZpB+zb/cjukmcYIYOQR7+k3A8hlSSzZk096zFKk+1cWq6aYPe/XP39Vl+RyCFynjQuu0t/BSDFjLZz4FJrtr/CksSnvLx03gpmxOG0fl0W5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(346002)(366004)(39860400002)(451199015)(66556008)(66476007)(83380400001)(6916009)(8676002)(66946007)(41300700001)(86362001)(36756003)(1076003)(316002)(2616005)(2906002)(38100700002)(5660300002)(8936002)(6512007)(6486002)(26005)(9686003)(186003)(478600001)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?soIVwTFzbtevgjRdSmPhcb+gVtGrlmlpesZGRJN8W5EoWKYs61Q7lbvMquZ6?=
 =?us-ascii?Q?OwsHXeR443abQOlHUivD56sh8VKjGrok7nPgiOEq7+iQwPavQExLQoPKwc+N?=
 =?us-ascii?Q?vPHHKyXlJHq+wm2hqQFloV/+qmJhWzAYJJm/NG7QeJAEP7KdiPMa2pLQHcHn?=
 =?us-ascii?Q?jA6h/V0HjQbeKu2jVdfnr3l911h53iag6gNuT7YvgvOEuKoiFdi/DE+DEWwU?=
 =?us-ascii?Q?SqY2nceDW2Ebk0NroX/x0wST+WVGLAESB6UJszar0a+tgT2Db4UK5lD1eTeh?=
 =?us-ascii?Q?d2h2MXojrThve1hpAJ9eXOGcXZXuhmJqNYuEUelo3RxI13LCzBp3cENrhzmd?=
 =?us-ascii?Q?Lde0aG+dVzbL8tVXse+Ck+blQmCHDkNx2s2U2lX5s37hdEUqL5cJ7WB+And8?=
 =?us-ascii?Q?7y5iLSfjgguHQQTxkkouW05n1qnaSR/XHwTMyoi3YHcpUEwWc/UXYpRtjBWI?=
 =?us-ascii?Q?5lqVO1UI8PU+sORSf82iXOuwPckVmJKWz1xSl3vqkoGVedbb2KBu7QQJMeEJ?=
 =?us-ascii?Q?2QfIv5Edmtm8yGpaMuqqsgu6tgK66TyRAbZopHlO0vFIjl81jHZRFLHRja7I?=
 =?us-ascii?Q?93zZqhaFtFJyc5CAb2D/sqHKE3Mkjnqor2NJXDDh96tagpiBKjNUvx2FV7ap?=
 =?us-ascii?Q?vNWW5Fs/2sH4FT3VwzWDq0OdZWvHDXNXGaPqsVtnHtyB/AEMV7zS6Be0NqJh?=
 =?us-ascii?Q?6v1yqclbbJ9Zze6yLeup9zPtehq0ahH2qh709HF3zKc+msVXSi2x7UCVkGQK?=
 =?us-ascii?Q?flwAvxp3tJa9M/BeSWqkCyQvbTxGYUHYPJkkfG3bLThCeJGqCRtIsYiOIraT?=
 =?us-ascii?Q?DippnrWu/37pCu5lXAAPhZiAKvhnlW9RJhZ4nXtihrC1tIMmG+GGn2P08Tpd?=
 =?us-ascii?Q?kqwuvOFI+6mC8hmMLd2FYU3QgtqdLCVCgIV4EZmkTDHDO2H2Ewc24TO1ZD9V?=
 =?us-ascii?Q?khnX9pDSrA48iGMa3HtVfOjkj1MxAH71r8ElA4oM65Zt0MiSZHCC6XElBqeq?=
 =?us-ascii?Q?o56q1JgNf+jUeNsDGy105zAHJYuze0oflyxJWgKcK7H7AA0lT4vnjdymV2ho?=
 =?us-ascii?Q?nHaMhXdYM5JKFBCq5V9hQcEkFqY4db0iqdohxzyDFSBweraJEMVn6jW38cCg?=
 =?us-ascii?Q?0vgxlqcBFoya7THP47Y/RGShjCGdoZLkLiSEg5vM24+1LZoZQ6C1i/BeZ4+f?=
 =?us-ascii?Q?PMdaZgft+45VeTAyizRosRBIY6jKpzyk5TsrP9cbTl3ffDEBQkjyXbSrK/rX?=
 =?us-ascii?Q?7tScyBrqBmdDvysg0xb9cKTbr4AuIkqeEUA2leuLAZwkN+XQvdQrmdfNyQRz?=
 =?us-ascii?Q?FIlgu+7XWbq132H/NfT2Ucb6JRnYsGCvjHnysF0xyP2Jtx5JbmkCV+6Yajy3?=
 =?us-ascii?Q?eYdnfqjm05E4FOxG209Z/r9gnU9n7aBQ90tIgK4cKb8KyOg6CaR8QFSD0d4t?=
 =?us-ascii?Q?vmwLZl+tpGUs5ygXFMQs7M0xqoDGh5YLEgjxI+kd8eseVvOfSW8COq2olkMy?=
 =?us-ascii?Q?CFSIdHI4q5eXDEnFOHHA/lxqHnfZ5A1a1FoEHPYZUEWwwffo17rsMDeU0S/b?=
 =?us-ascii?Q?DfEXfn/XJxzk9rNAgftL0R2IEPkRvU4wMg0YoZt6lBsTpZzSLSO9s6Lxo9kl?=
 =?us-ascii?Q?gw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: zrUrp1HonnU9LEv9S0qv/Bi9VX2HS7eLfR415U/rklTe8/noOyjtY/X72ElmnQKISD1msnnSSCPTWP4HqfGCzNMBsU1uabbPzV0x+zvhQlvttp+Wz27ONOrKOvboyFtWDg6ymo5ohh/xrnEwu7DZhz1PDPc7FB9u7KLkuiXpUKLECxqU/6KAqiUYFoWQkxetmRKtmdRD9djgBZXNu+fIGZVwJT8CrDUNYcQnAawBItHGG1rCpTEcOJIGJg2kInCUjKPq5k2RAtXVyxqh6V++F7D9EiPDLikoy1+MhsD7YlzqwAhGMmHUt4Rid3mtbWmMMOMYzjyvDJaCvQQKoVw4wABL5CKKV6Au3EyY7cNTOdn5XtXmUV5Jym1196d+7YEzCHw/RQUP+FXeWNNXoD5N539b1A6bC37cpQ+H7kXUCqyk5RukFy0Pl3ojr1tKZCdXfE6T2xaEs+c3ZrGNvWkdfDGK3O4fZ33lSecSIoQGfdVXEtD2VRtn/0yCOouHyCvaMOXCtvXnvLRoFs2aPZs/wOSlWc+Kt+K9rqBfk/Q3Cr4riTnxg59NS5KuukeZVtZS82BnpOx2HTmfNExEpfwejW8HLpFyKGhVFwGJljI3hsRz1mry03bDWOkklGqKSkhEEwcks32m9ZIa4bdu1Ifjsc/kvYmDru6dRwNlOCRtNO4VyNDDdO/Uv4sroCiPx2QCNr37loSz8JtvveFUKLWB7n3xyLq9udiRnehGwn4QMJO++DchVgLn+izZUgLrTo/07W7feH4UMkxSFCa4qVhu6Q==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c2dd9a8-76b0-4293-f7be-08dafdab7c5a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:36:59.5167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bc/jAB4uwv2hE2+toDJSppK0HivZkK5e/OuNUQKTgwc+OVwKsT+Np3kSX+7MQNZ8wzoz5lp9WQQcrs5UV/DF9tgvBYk5NoYIYsE8Nde92lM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7074
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301240010
X-Proofpoint-GUID: -gx0LEQaGZMLNWcAc_dnFI2_Q_5HCyQO
X-Proofpoint-ORIG-GUID: -gx0LEQaGZMLNWcAc_dnFI2_Q_5HCyQO
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
index 595a5bcf46b9..9c09d32a6c9e 100644
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
index 736510bc241b..5cd5154d4d1e 100644
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

