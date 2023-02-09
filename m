Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80E32C05027
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 08:02:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjBIICl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 03:02:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjBIICk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 03:02:40 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209CE1352E
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 00:02:39 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3197Qq3B012378
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=ZDhB7XDZUzOyYc8IM+WQlyLtpc28ct/PXUK+kHWloyc=;
 b=Pm/ujXYL5cq7xR0fdtotAPJLHxVZ9vNNEDGEmQ+shVbBbf+uqdGZqIMvRTWJhHFFVMgr
 nogBTGBvUVq3eYCeBlqyOsoohUNt3wSJiOEhR53kRoYhxSIcVBCo52sXahVfJ9j/Jh8W
 Zr5auAs+F3Ug8kbK7kHRXThEVRnhLP7kHQrX60xNTexrW1lu9xGCgaM1yM5RHPXlCWib
 14qbhc383HDuARKwQYg19EAv2SUFqHp+4PW076XrR4gPDJJLv6g6Rw+IxkHfydof4Qew
 H68LUI2gejrS9LKq+y223N3VRMFqsQuq8A6/URGF/LPSZuOCL2lOiY4C6B55ygASEELJ Qw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhe53j517-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:38 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31965ffW028432
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:37 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdteyge9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HwT//ZsGmeivNTr45y7xwlyjvS4mzFLFscka09SXU0sHR1YcZ180/XJHqgZIJTXngqTJ13ZVMKrOTQd427G/ZXKjOHRT9wZY/915cH0hcgshg5rU0prZDEOTWc/3CIvpHGHnkQVsnaOAZMhGk6WyGmN2AjTFhlQZuJbgxsbdR1cCeUHLefAin5ikJGuHH6ioqCbEG3MSCmd6MFn7HzBnTzbxvETfHkHyXZ/H9jL4zWtvFdUxHbFbZZWMQ+Z0aq2s6rUkeffiZVdZ3Dj/66QxJB+8FPB/M8Y9iV70oKbx2up4IxdycFU8V9LCnWuUSmXSdlQe9QzDzaOTTGQz/8scMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZDhB7XDZUzOyYc8IM+WQlyLtpc28ct/PXUK+kHWloyc=;
 b=nLVBQWEMXONX6H/YYgWulwUnEHri+AZ2Oxb9B8PJbFAejrYwH4uY5tLPp1XWkOPJdd9WX/EwI92IW/31BMrXwTvh3MGBpVhc2tCSp41SRPANeIsGbSxhsPYWCAqKLz7k4ScWAEIkyKOD9LLr06OEIrP7uGXNHeZunpGMe8lLIoz3AI3xo/UIafcEJa9xS6GhEM+9A0yQ4yDlM23SxasxI1get5N9EAxUCC4IQOC6h/hqtEUqLFf5rmOqhEzhBBmYLgR7hz+izYwYnY6y7Dic6LTGYISiQJNmVdoYPYbbAghkqOHko0GRe7EFA3zlq8b0JTar77vhg9hRkqAxuw5MJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZDhB7XDZUzOyYc8IM+WQlyLtpc28ct/PXUK+kHWloyc=;
 b=iFmWqRp8gWmpgxyqR0b/p8etNGryMHC/ptvagtbwyB1No8gI5nHh9KeC8dGqjteXJLSgWPgTrogUmI1um/Az8xFzRcJkKXVoW0wyLDQPxbb0pLobpuDcP0SVInvK6jLu/KwMl1HF0e+uidiMwmSjNZcxJcO072Wkzzo18HwZ8qU=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BN0PR10MB5095.namprd10.prod.outlook.com (2603:10b6:408:123::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Thu, 9 Feb
 2023 08:02:35 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6086.011; Thu, 9 Feb 2023
 08:02:34 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 25/28] xfs: Add parent pointer ioctl
Date:   Thu,  9 Feb 2023 01:01:43 -0700
Message-Id: <20230209080146.378973-26-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209080146.378973-1-allison.henderson@oracle.com>
References: <20230209080146.378973-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0080.namprd07.prod.outlook.com
 (2603:10b6:510:f::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|BN0PR10MB5095:EE_
X-MS-Office365-Filtering-Correlation-Id: 52c45a39-f038-4283-2d03-08db0a74006f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NOnBFijwgoZHD8hY4KkQ7Otee6FLUsTtwFoA2eOQq7iq9Q2zilpFToV26sZ3oKpHiLugADkA+7K10StqitI37gD3xLDrIAdicy+TgOxvhQLYzqkpzY5pR9Z8zK8gmLafMlRJsImyhIIWhGykuBhBgY/+rv0gMQp6fMQcVvOsU7lfNA2ERWKTamr2HggT4a1AmO7My5SSbm+/S9R7dOZJAlfPC19NY4Iehq7fM6rpBJv1JZi+zQJ5ze3BOEXhdBLLnL5ChR0n7JDziYsnOoRlNXtgINkKFk0Yn/jF96Rk2laQEJQ46ZNAfiCF9kDCElN538hxrnaQhOTe9MhfTW3Lev+FupRNSm66zPMtGxjnniuUyJ3S6kiQ6DyBtTDauW7Oa88A99oMEE5EY23IlShSGhS0LYK/Ao+TKzs9M02Nq4bG3x9q0tf0uHBay9iqvfgbZdV/0fQ1D/rQpGTEoSS2pNx/5jRNJMyzdvc84eQFyaRhC/Gvub2sAbryROohfznm4eGS8w+BeFmTJAk7u0N2Swqkt6FofyUvp8+zeUUSymavngjx2lAHCOk6108WqXRHKrswwPBFzDBIeJsSWen3CQtE6uWrB/IqHa6ts9OYJMDlwrAZcpTUVSZvZJSRPBUAPSoNpisXq7SmtzTnqZzxcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(366004)(136003)(376002)(39860400002)(451199018)(1076003)(6506007)(6512007)(26005)(186003)(6666004)(38100700002)(9686003)(2616005)(2906002)(6486002)(83380400001)(316002)(41300700001)(478600001)(30864003)(8936002)(6916009)(8676002)(66476007)(66556008)(86362001)(66946007)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YRI/cfAcogIelCfz7dAXqSepWvVHgbBzuD3Kmm9pVentCcqaGuQes4Q4xvU2?=
 =?us-ascii?Q?kxNkxHFEJakWJq8UrJIxCvoD+tVgJEKZONiX5jC0K6rNjCOipr8cxp0Jn7/p?=
 =?us-ascii?Q?tgu2t0WefoPCvZYAqFE0c5LGdK0ivCfs5MkXrKqqZ2qxyoebUIIlVuViASZH?=
 =?us-ascii?Q?unlOCo1HuOHFJXjsqBiqG/rrSleB1YFOtQFxOnY91ZiqFyP5fZegParWBTVv?=
 =?us-ascii?Q?AXnLHO+nd2tVuyEEmpXZoVC3BI1CbLBp6Zy0IMXcSue8Zv6WPhk6gi4Rnz1E?=
 =?us-ascii?Q?l79iXKD1An5cps8s1soyKmByHknf9aH7snGWVByA4P7vczb00oJ6wuwYaP6m?=
 =?us-ascii?Q?TYEyRnpBy+p/PM55kRgkyj2WJ+TJhwl8c4kBqUMzGmLDSpFC/haFdGY88Fh4?=
 =?us-ascii?Q?Ij6cuVsymB+++ZH6qYBVZ3z+oLZt8JuDRB+o2btGQk9RHNO9fau+bwPp4I0e?=
 =?us-ascii?Q?CutEn3W/3Mqwl8dmsI+8q/m5iAj0YCpVgLMZ0+4GJkLl2G5Is32ophS10EUC?=
 =?us-ascii?Q?Ti/gScJinYOU/fccs+e0fQFvMHnTW8f/J2O82JeoWT3YoGmt183zNKrb24M+?=
 =?us-ascii?Q?8Wu1e3KE1FB1GVHn7wzKm7NTtPqchmNw9jIgcpl6ah83ptSUQ8KrGdkaoG38?=
 =?us-ascii?Q?lR3fDU12xu1VOMV9obs9I+XE3+29n4HOZAiVqpVy31GSc07fVpimrV5GYqj4?=
 =?us-ascii?Q?htdZqCLF43mqb0MLGvWYSpF+xEJwHUui59hQx7WMFj4DRCOuIuZL/wtW0K5O?=
 =?us-ascii?Q?r4hRMMnKSTCCPHwn2LbOS8pU+uXG8p0Zl7hV3LA/MFTpG4DaJHZW7bS0OA4q?=
 =?us-ascii?Q?R9GbgWfEHi+g7bTROQkioeCckufYiyN75N+PwmjCjdpgAZpRROTG9G144axf?=
 =?us-ascii?Q?ygUAPsf/fG7LlLcxqmfOaNmTYAFD84ExOtJL0qaGp7zwEKQa8Q1RMOaaJMw5?=
 =?us-ascii?Q?h6yhVgrY3ZK/LCrY71oBG7jOvXK3XXONuPLEmWKBk+IuWGerVhAhc24UzcP5?=
 =?us-ascii?Q?GgCjAF7S98/ndUUx6Hp+WrWmMJx2w+fisIjfjDZw58wcLhHZdWJfUGR1xLbt?=
 =?us-ascii?Q?Gf24yemAOPiqMZWbdWGgVluw9urTNaU6g94BFpKxaEet1npQ6liNDlsfEWq2?=
 =?us-ascii?Q?das9CSYyroPrBS6YedrN0LNP0nIYHV/g2N/QNFab+8n3+JEguKmSB5oj9FCh?=
 =?us-ascii?Q?vDt18o2kaueXmnH/RbeF64eFniEoRcnZI3clW0L1bSPH+pX8wovmH2rZfR5l?=
 =?us-ascii?Q?kdtkDyzY3zkF6lB27Ydk19pzGivTOKpQKlLFrahID5BnYmC36gRZf+DncZ0B?=
 =?us-ascii?Q?WlV6ZqtkkNTVArhkYvIUdceZDBYihw9TwkuO35755UbQiCgyBWDj6v1wsFVN?=
 =?us-ascii?Q?55mciN+c68w87dzamCC6X3Ryibrp30Mau6l44IoUa2vsNuN7tx4R1/riZBfq?=
 =?us-ascii?Q?6PMeM47nbNIl4uW1IuweC4+P73PxkBqTsznNtLjHqkkZKaE8gpCaCSibPRiq?=
 =?us-ascii?Q?yKFHSHc0fX6Kh+nyLXstP8w6g/panLGdARvwgve2i19jmtKtO1xhIyumAxpU?=
 =?us-ascii?Q?/J2qYs7GkI/fUa0tWBz7+hs8cZFRDTVWm8skEMKVy1FXtKHs9xR5RDM4Wy9p?=
 =?us-ascii?Q?Ug=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ReSslySHGZK5OwDhuUqNzs1ERR1MIbq6Kch3q/FimFWfa/V/BYLgQqin2FP/pl7bOWp3UPCDfsS23cPbnj9AVnCXJhLYgt9uLqxtP3vFJ8w+n+GrLxhrG+7mcdu9xLN6hEr/NVg0nZNuMT3lO3N6aopa4B9SVJ9AKDO2ZNbOx5DItal6C6Tr/v5Fi3/OZm5dLh7EAMO+YKnJY1rAX2tTXDuA6Oj/HSls63fULA+0XqT6pjtN1/UwR5foG3AWpbjA7BG58tKNYhGnHp26J1/Vcvxip4Bhiwv51RmwbFnJhrE44scHz6/ToM12BM8lejlbuSUzG7Ab4elWUaVBpvcVY5Foj0LGcvv80NBgTsRVmAcsh8wolfz2xJXA2gpyiGTDtSq521j9xDTqNVtyDR4eTid0e7kXTY55O8Xz96MEUuAZroyE5OB2UDX29jiE6mVXLXVXcm4MKKVVahKkalWV34tdMIhOlGF6RcoY9UtlqeTM03Eue8rCKtJFFp5aHjzw+A8yC7UCA9p/7og9iWFW5IqpHQnzFCyBmDSpNdPfp1v87exTCawyxG49YSrvcAV240a3SV6u4eqjn9TZ4BmIA/zD4Tup5v0tcehcGHxuhOtpblkk3CobTHvQxpt/OfeqtjrRRS9zp5vRenLE1pWbLCdZMafAFIOlp+A/OVLG6+7JWRCfKZwH28IWNb3jZLOuqEMR71zRrh7goAuIMYDj4oFbe3GJRSAiDhMvpTBUt3BcKHeDp5cwQUrsd1wavnFk
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52c45a39-f038-4283-2d03-08db0a74006f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 08:02:34.5107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /uMySRo2IjAwrRibdFItJXXqNrR3tumku24lLGLd/OVa4Lzg0SZQ/4Z1ffM2DybuSKXm+SznbtoDno5VzK/hfVISmNtrK5fDxIynuoUBODc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5095
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_05,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302090075
X-Proofpoint-ORIG-GUID: RqE6pjk9vpon25M7a_-nUHCXNcaGbgup
X-Proofpoint-GUID: RqE6pjk9vpon25M7a_-nUHCXNcaGbgup
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds a new file ioctl to retrieve the parent pointer of a
given inode

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/Makefile            |   1 +
 fs/xfs/libxfs/xfs_fs.h     |  74 ++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.c |  10 +++
 fs/xfs/libxfs/xfs_parent.h |   2 +
 fs/xfs/xfs_ioctl.c         |  94 ++++++++++++++++++++++++++-
 fs/xfs/xfs_ondisk.h        |   4 ++
 fs/xfs/xfs_parent_utils.c  | 126 +++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_parent_utils.h  |  11 ++++
 8 files changed, 321 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index e2b2cf50ffcf..42d0496fdad7 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -86,6 +86,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_mount.o \
 				   xfs_mru_cache.o \
 				   xfs_pwork.o \
+				   xfs_parent_utils.o \
 				   xfs_reflink.o \
 				   xfs_stats.o \
 				   xfs_super.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index b0b4d7a3aa15..9e59a1fdfb0c 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -752,6 +752,79 @@ struct xfs_scrub_metadata {
 				 XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED)
 #define XFS_SCRUB_FLAGS_ALL	(XFS_SCRUB_FLAGS_IN | XFS_SCRUB_FLAGS_OUT)
 
+#define XFS_PPTR_MAXNAMELEN				256
+
+/* return parents of the handle, not the open fd */
+#define XFS_PPTR_IFLAG_HANDLE  (1U << 0)
+
+/* target was the root directory */
+#define XFS_PPTR_OFLAG_ROOT    (1U << 1)
+
+/* Cursor is done iterating pptrs */
+#define XFS_PPTR_OFLAG_DONE    (1U << 2)
+
+ #define XFS_PPTR_FLAG_ALL     (XFS_PPTR_IFLAG_HANDLE | XFS_PPTR_OFLAG_ROOT | \
+				XFS_PPTR_OFLAG_DONE)
+
+/* Get an inode parent pointer through ioctl */
+struct xfs_parent_ptr {
+	__u64		xpp_ino;			/* Inode */
+	__u32		xpp_gen;			/* Inode generation */
+	__u32		xpp_diroffset;			/* Directory offset */
+	__u64		xpp_rsvd;			/* Reserved */
+	__u8		xpp_name[XFS_PPTR_MAXNAMELEN];	/* File name */
+};
+
+/* Iterate through an inodes parent pointers */
+struct xfs_pptr_info {
+	/* File handle, if XFS_PPTR_IFLAG_HANDLE is set */
+	struct xfs_handle		pi_handle;
+
+	/*
+	 * Structure to track progress in iterating the parent pointers.
+	 * Must be initialized to zeroes before the first ioctl call, and
+	 * not touched by callers after that.
+	 */
+	struct xfs_attrlist_cursor	pi_cursor;
+
+	/* Operational flags: XFS_PPTR_*FLAG* */
+	__u32				pi_flags;
+
+	/* Must be set to zero */
+	__u32				pi_reserved;
+
+	/* # of entries in array */
+	__u32				pi_ptrs_size;
+
+	/* # of entries filled in (output) */
+	__u32				pi_ptrs_used;
+
+	/* Must be set to zero */
+	__u64				pi_reserved2[6];
+
+	/*
+	 * An array of struct xfs_parent_ptr follows the header
+	 * information. Use xfs_ppinfo_to_pp() to access the
+	 * parent pointer array entries.
+	 */
+	struct xfs_parent_ptr		pi_parents[];
+};
+
+static inline size_t
+xfs_pptr_info_sizeof(int nr_ptrs)
+{
+	return sizeof(struct xfs_pptr_info) +
+	       (nr_ptrs * sizeof(struct xfs_parent_ptr));
+}
+
+static inline struct xfs_parent_ptr*
+xfs_ppinfo_to_pp(
+	struct xfs_pptr_info	*info,
+	int			idx)
+{
+	return &info->pi_parents[idx];
+}
+
 /*
  * ioctl limits
  */
@@ -797,6 +870,7 @@ struct xfs_scrub_metadata {
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
 #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
 #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
+#define XFS_IOC_GETPARENTS	_IOWR('X', 62, struct xfs_parent_ptr)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 629762701952..9176adfaa9e8 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -29,6 +29,16 @@
 
 struct kmem_cache		*xfs_parent_intent_cache;
 
+/* Initializes a xfs_parent_ptr from an xfs_parent_name_rec */
+void
+xfs_init_parent_ptr(struct xfs_parent_ptr		*xpp,
+		    const struct xfs_parent_name_rec	*rec)
+{
+	xpp->xpp_ino = be64_to_cpu(rec->p_ino);
+	xpp->xpp_gen = be32_to_cpu(rec->p_gen);
+	xpp->xpp_diroffset = be32_to_cpu(rec->p_diroffset);
+}
+
 /*
  * Parent pointer attribute handling.
  *
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 039005883bb6..13040b9d8b08 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -25,6 +25,8 @@ struct xfs_parent_defer {
 void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
 			      struct xfs_inode *ip,
 			      uint32_t p_diroffset);
+void xfs_init_parent_ptr(struct xfs_parent_ptr *xpp,
+			 const struct xfs_parent_name_rec *rec);
 int __xfs_parent_init(struct xfs_mount *mp, bool grab_log,
 		struct xfs_parent_defer **parentp);
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 5cd5154d4d1e..df5a45b97f8f 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -37,6 +37,7 @@
 #include "xfs_health.h"
 #include "xfs_reflink.h"
 #include "xfs_ioctl.h"
+#include "xfs_parent_utils.h"
 #include "xfs_xattr.h"
 
 #include <linux/mount.h>
@@ -1675,6 +1676,96 @@ xfs_ioc_scrub_metadata(
 	return 0;
 }
 
+/*
+ * IOCTL routine to get the parent pointers of an inode and return it to user
+ * space.  Caller must pass a buffer space containing a struct xfs_pptr_info,
+ * followed by a region large enough to contain an array of struct
+ * xfs_parent_ptr of a size specified in pi_ptrs_size.  If the inode contains
+ * more parent pointers than can fit in the buffer space, caller may re-call
+ * the function using the returned pi_cursor to resume iteration.  The
+ * number of xfs_parent_ptr returned will be stored in pi_ptrs_used.
+ *
+ * Returns 0 on success or non-zero on failure
+ */
+STATIC int
+xfs_ioc_get_parent_pointer(
+	struct file			*filp,
+	void				__user *arg)
+{
+	struct xfs_pptr_info		*ppi = NULL;
+	int				error = 0;
+	struct xfs_inode		*ip = XFS_I(file_inode(filp));
+	struct xfs_mount		*mp = ip->i_mount;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* Allocate an xfs_pptr_info to put the user data */
+	ppi = kmalloc(sizeof(struct xfs_pptr_info), 0);
+	if (!ppi)
+		return -ENOMEM;
+
+	/* Copy the data from the user */
+	error = copy_from_user(ppi, arg, sizeof(struct xfs_pptr_info));
+	if (error) {
+		error = -EFAULT;
+		goto out;
+	}
+
+	/* Check size of buffer requested by user */
+	if (xfs_pptr_info_sizeof(ppi->pi_ptrs_size) > XFS_XATTR_LIST_MAX) {
+		error = -ENOMEM;
+		goto out;
+	}
+
+	if (ppi->pi_flags & ~XFS_PPTR_FLAG_ALL) {
+		error = -EINVAL;
+		goto out;
+	}
+	ppi->pi_flags &= ~(XFS_PPTR_OFLAG_ROOT | XFS_PPTR_OFLAG_DONE);
+
+	/*
+	 * Now that we know how big the trailing buffer is, expand
+	 * our kernel xfs_pptr_info to be the same size
+	 */
+	ppi = krealloc(ppi, xfs_pptr_info_sizeof(ppi->pi_ptrs_size), 0);
+	if (!ppi)
+		return -ENOMEM;
+
+	if (ppi->pi_flags & XFS_PPTR_IFLAG_HANDLE) {
+		error = xfs_iget(mp, NULL, ppi->pi_handle.ha_fid.fid_ino,
+				0, 0, &ip);
+		if (error)
+			goto out;
+
+		if (VFS_I(ip)->i_generation != ppi->pi_handle.ha_fid.fid_gen) {
+			error = -EINVAL;
+			goto out;
+		}
+	}
+
+	if (ip->i_ino == mp->m_sb.sb_rootino)
+		ppi->pi_flags |= XFS_PPTR_OFLAG_ROOT;
+
+	/* Get the parent pointers */
+	error = xfs_attr_get_parent_pointer(ip, ppi);
+
+	if (error)
+		goto out;
+
+	/* Copy the parent pointers back to the user */
+	error = copy_to_user(arg, ppi,
+			xfs_pptr_info_sizeof(ppi->pi_ptrs_size));
+	if (error) {
+		error = -EFAULT;
+		goto out;
+	}
+
+out:
+	kmem_free(ppi);
+	return error;
+}
+
 int
 xfs_ioc_swapext(
 	xfs_swapext_t	*sxp)
@@ -1964,7 +2055,8 @@ xfs_file_ioctl(
 
 	case XFS_IOC_FSGETXATTRA:
 		return xfs_ioc_fsgetxattra(ip, arg);
-
+	case XFS_IOC_GETPARENTS:
+		return xfs_ioc_get_parent_pointer(filp, arg);
 	case XFS_IOC_GETBMAP:
 	case XFS_IOC_GETBMAPA:
 	case XFS_IOC_GETBMAPX:
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 9737b5a9f405..6a6bd05c2a68 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -150,6 +150,10 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(struct xfs_efi_log_format_32, efi_extents,	16);
 	XFS_CHECK_OFFSET(struct xfs_efi_log_format_64, efi_extents,	16);
 
+	/* parent pointer ioctls */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_parent_ptr,            280);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_pptr_info,             104);
+
 	/*
 	 * The v5 superblock format extended several v4 header structures with
 	 * additional data. While new fields are only accessible on v5
diff --git a/fs/xfs/xfs_parent_utils.c b/fs/xfs/xfs_parent_utils.c
new file mode 100644
index 000000000000..771279731d42
--- /dev/null
+++ b/fs/xfs/xfs_parent_utils.c
@@ -0,0 +1,126 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle, Inc.
+ * All rights reserved.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_shared.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_error.h"
+#include "xfs_trace.h"
+#include "xfs_trans.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
+#include "xfs_ioctl.h"
+#include "xfs_parent.h"
+#include "xfs_da_btree.h"
+#include "xfs_parent_utils.h"
+
+/*
+ * Get the parent pointers for a given inode
+ *
+ * Returns 0 on success and non zero on error
+ */
+int
+xfs_attr_get_parent_pointer(
+	struct xfs_inode		*ip,
+	struct xfs_pptr_info		*ppi)
+{
+
+	struct xfs_attrlist		*alist;
+	struct xfs_attrlist_ent		*aent;
+	struct xfs_parent_ptr		*xpp;
+	struct xfs_parent_name_rec	*xpnr;
+	char				*namebuf;
+	unsigned int			namebuf_size;
+	int				name_len, i, error = 0;
+	unsigned int			lock_mode, flags = XFS_ATTR_PARENT;
+	struct xfs_attr_list_context	context;
+
+	/* Allocate a buffer to store the attribute names */
+	namebuf_size = sizeof(struct xfs_attrlist) +
+		       (ppi->pi_ptrs_size) * sizeof(struct xfs_attrlist_ent);
+	namebuf = kvzalloc(namebuf_size, GFP_KERNEL);
+	if (!namebuf)
+		return -ENOMEM;
+
+	memset(&context, 0, sizeof(struct xfs_attr_list_context));
+	error = xfs_ioc_attr_list_context_init(ip, namebuf, namebuf_size, 0,
+			&context);
+	if (error)
+		goto out_kfree;
+
+	/* Copy the cursor provided by caller */
+	memcpy(&context.cursor, &ppi->pi_cursor,
+		sizeof(struct xfs_attrlist_cursor));
+	context.attr_filter = XFS_ATTR_PARENT;
+
+	lock_mode = xfs_ilock_attr_map_shared(ip);
+
+	error = xfs_attr_list_ilocked(&context);
+	if (error)
+		goto out_unlock;
+
+	alist = (struct xfs_attrlist *)namebuf;
+	for (i = 0; i < alist->al_count; i++) {
+		struct xfs_da_args args = {
+			.geo = ip->i_mount->m_attr_geo,
+			.whichfork = XFS_ATTR_FORK,
+			.dp = ip,
+			.namelen = sizeof(struct xfs_parent_name_rec),
+			.attr_filter = flags,
+		};
+
+		xpp = xfs_ppinfo_to_pp(ppi, i);
+		memset(xpp, 0, sizeof(struct xfs_parent_ptr));
+		aent = (struct xfs_attrlist_ent *)
+			&namebuf[alist->al_offset[i]];
+		xpnr = (struct xfs_parent_name_rec *)(aent->a_name);
+
+		if (aent->a_valuelen > XFS_PPTR_MAXNAMELEN) {
+			error = -EFSCORRUPTED;
+			goto out_unlock;
+		}
+		name_len = aent->a_valuelen;
+
+		args.name = (char *)xpnr;
+		args.hashval = xfs_da_hashname(args.name, args.namelen),
+		args.value = (unsigned char *)(xpp->xpp_name);
+		args.valuelen = name_len;
+
+		error = xfs_attr_get_ilocked(&args);
+		error = (error == -EEXIST ? 0 : error);
+		if (error) {
+			error = -EFSCORRUPTED;
+			goto out_unlock;
+		}
+
+		xfs_init_parent_ptr(xpp, xpnr);
+		if (!xfs_verify_ino(args.dp->i_mount, xpp->xpp_ino)) {
+			error = -EFSCORRUPTED;
+			goto out_unlock;
+		}
+	}
+	ppi->pi_ptrs_used = alist->al_count;
+	if (!alist->al_more)
+		ppi->pi_flags |= XFS_PPTR_OFLAG_DONE;
+
+	/* Update the caller with the current cursor position */
+	memcpy(&ppi->pi_cursor, &context.cursor,
+			sizeof(struct xfs_attrlist_cursor));
+
+out_unlock:
+	xfs_iunlock(ip, lock_mode);
+out_kfree:
+	kvfree(namebuf);
+
+	return error;
+}
+
diff --git a/fs/xfs/xfs_parent_utils.h b/fs/xfs/xfs_parent_utils.h
new file mode 100644
index 000000000000..ad60baee8b2a
--- /dev/null
+++ b/fs/xfs/xfs_parent_utils.h
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle, Inc.
+ * All rights reserved.
+ */
+#ifndef	__XFS_PARENT_UTILS_H__
+#define	__XFS_PARENT_UTILS_H__
+
+int xfs_attr_get_parent_pointer(struct xfs_inode *ip,
+				struct xfs_pptr_info *ppi);
+#endif	/* __XFS_PARENT_UTILS_H__ */
-- 
2.25.1

