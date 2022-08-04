Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7317FC25B07
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 19:40:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239321AbiHDTkm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 15:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237363AbiHDTkc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 15:40:32 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F986407
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 12:40:30 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 274HbYXD024412
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=D1GxUB38aZ6TiBtpDDGVLHcYXZizU6NwdeFGI63+jRM=;
 b=Ym72SEt/8wvSq7Xru2CGUf8/uHy0SNDtuoEWN1AB8VPGqxcThFhi0B6CeKGA2kJYlRvK
 UpfXp4naORv8qztOYvGtALdFFwb89lFaF8SvEFW9cQ9hkWzD6eet0npxfc/b1ADeG1DQ
 uE3JKinAHsvqU7hqP5JO1AbnemfQ+o80XBJBJrgFlD3TFe7yyMQqLFDSmVJ9/Rgk+Cbx
 8II2RlYbEPRbI2ItwZqUaHs+ESbF4ruR40bySy2LCSfawJ6hNqXLcL7c/uUAAuw9myt1
 8KRj2cbLzgYdsjbS+9YdS4p//vms+/59pYC7TPD0fcE+r6J4iPNhOfXEO/fqlXRPxgPJ tw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmv8sdyqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:29 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 274JO4XE014188
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:28 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu34p7ev-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U2gHDvy0D04WHJ5++DlCQ0+8ZhMsGvnQxQlhLFeW10pVWqKf5CSihbFsojDtbSOnpZAEOUWUujyl3q7vxTRJZK3Vj/mGaLzxCJD2OJOaQ5sAAyyZqIAUMGsSp+56+SO7FatNvq9oY1bZIg9hAELFteigRyeTcanyQTGnyEtCPgpe4J+zfvi0sgieJ20/9HnL+NV2vuTPEntxjGtK3tb11M7rJhxm4ZE+OnmrFlGc1L/DzD0RDpU+P/n8Y2jHb0vLoqSpu5+XK6coWlSrJJsO8BxxgptK7OQkVrgEODPYUCRB3Ei6N+sxaA9DFvZZuKjXd+PU6FnkZjzClg+JxX+efQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D1GxUB38aZ6TiBtpDDGVLHcYXZizU6NwdeFGI63+jRM=;
 b=cM23Uny8QZzrRsNvvQ1klDivWuKiSMU3fFzcUaT2tnax4tUYQN6M8QM2cm3yFiJAV2I9z0TRvBn77V1lx8GkanZDfLuZQsLrJh/KieZAR17qdYng4dUDvjqYZQsWFsV9xFw/qCNQhGEITrpxAxfax7MIw/ZTv9HnTX7clSAKymaqDhC1MWe9GqDcyzFdZ3W67tRo9JPrBZEoU1ltq4xF2zMlPyMvGrx8ejOT/6HvpqC0oZSC5vizxJL+9BTqk5Q8j5dj3c0dlTlyrmf6ZeB5oUT7Ue0M8eOnNjjk/YJGqqPrLyLbaV/z10/QdcDT7xYEjdD0Ebm/H12RrH5Z0fJsBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D1GxUB38aZ6TiBtpDDGVLHcYXZizU6NwdeFGI63+jRM=;
 b=WMnQ8K3Cnj3AFbH+cYkwHa8EV9Gr76L2LNxwvdkb4buhG0R5B7kqIWFJlKMkIiYkmxf13iu5kjTq/i58/4PDBZgecEZ7pqJPhzJUF96wsiaXXaqcoIRd00Cj+FlAjs3ow3gc/CwPnrCt1NeIa0qn+Otn6MrUFLgpTWr50hPmowM=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5136.namprd10.prod.outlook.com (2603:10b6:5:38d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 19:40:27 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5504.016; Thu, 4 Aug 2022
 19:40:27 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RESEND v2 12/18] xfs: parent pointer attribute creation
Date:   Thu,  4 Aug 2022 12:40:07 -0700
Message-Id: <20220804194013.99237-13-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220804194013.99237-1-allison.henderson@oracle.com>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0198.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::23) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68ddbd31-50e2-42c1-0f9b-08da76512d4d
X-MS-TrafficTypeDiagnostic: DS7PR10MB5136:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bVzde34pqN/u7AQor9VYEvtsd4HHXUNwkxZNhDqmC79ZYm5KSdVdtZV1PNPApY9/OTuceTUbjsM5eIoJ161oEMyPhZPnCGY6NCYW/hVfnrkUmkxrg0ELYCLAH3CTFdDyGbwWE/7STW8SHsSIlh6RUofEasUjZFmt6rYB2DO5KHGIyYQ4kee4vZPDVrFjNPv+JheZT1SAc1p9G+DGZsoHvyZIwg0dK9zo0bCWdxZaw38Rz0ptdu44ZB3TDhSOBeCs9PO3frRsvXHVW0nz9UMBKhizXcEEtaa+k202/vpC+0XssIOuCHhz1+tUj3XQqrCo2PTJ7LpteyFWgFpIDMhOLi6I90/zLAwQIKHkLKOzf1KTp8LG4ARNYwbcu35ZIfzVyLJLX3tnrHtf+6LQvxD4ZySiFIShKYq0HSziitD92uR6zb+48TGCMAVDCp/rgUe+UJvhY3L/n+DBuk6/OlEsCUejDDd4Kv836MXqlt0O67cMZfE17GhnKKJFxOVQMuRTAg8MwC6V8+Ss17Udgtfrd7fYJBXr+6gfrcmSwwTp2UE/lBI+kxkpRLsgw6kC83a1XDGjOAGDw5PlRkp9IuL06/cIOiDgmnLF4rfaPc3hvgTCbCKuMsvaYrMw45sGPy66f7F6sOtl1D4WcoMBi7ua8Ev57GVv6zKSfniGuWlJHm9Q7Lqm4kKDDvx0+Bq4v1FiLd169n6qQCFtYbzsj1owH2fFXGinFqKBkhJCC2z2Szwx4FdqQFLp8X4NhfeNuEz2GBOm2WgVC+9Ob9UDV2UQKw/Gl6H3ddj99/wjqvY0KN8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(136003)(39860400002)(366004)(376002)(6486002)(30864003)(66946007)(66556008)(316002)(8936002)(6916009)(478600001)(38100700002)(44832011)(66476007)(5660300002)(8676002)(36756003)(52116002)(6512007)(1076003)(6506007)(26005)(186003)(2906002)(2616005)(41300700001)(6666004)(83380400001)(38350700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QikzhP0DSPlyUnI4SnthV/sB3o9rRBUsDnUTlBrAEd9K9eIxtE91I6p1GJEh?=
 =?us-ascii?Q?rFqL0PFjNYDdHJn/BRB4BK6XGru6cZvsJHcdD9MZzF+K4EoTyNLuis+lAGAn?=
 =?us-ascii?Q?IV18xQ+QuERmmvWGrBkoPb5V16FeVsYUEcF6oj1O4JDi+9L46lS1cKO+nrNW?=
 =?us-ascii?Q?nzM1T1Fh/7YOyJe0HV6sk/ybnoanyuwlESBUJkbj6s3UkPPLaGdLj486iygQ?=
 =?us-ascii?Q?GbuRLLEGNIL/roqVVvQ0G5Fv0Gf7q34XBJhzfiJmr8KgJfyPVaJ/+uqeuucE?=
 =?us-ascii?Q?ROx8xzzCOIfwY8W7eNPJKvOLKYpN6G9NH6WCWDakKZvdWhZ2CO0I6DM7J+BC?=
 =?us-ascii?Q?TkSRymzmTTp4GYh8gg25rzlVsjD5wmc7cgplSEgthhBZLNKxOeoqj6Hwhqb8?=
 =?us-ascii?Q?2CKkZ6vSV/JRA9X2zCQCYFvppmVOzeCft5YO/opA7GHx++xdqsHdW4BvWcsY?=
 =?us-ascii?Q?XkKPtm0R3D1ZfCBCpXy+rhPSpGCFFpDhK7tKms+8Ko+xnVN0ts4iKmhprPb2?=
 =?us-ascii?Q?sJyLteqWb9ldVOcrzqbjQU88mbYbJpnmF0v7G6ZL/rpyXQgGTW+lcjR8EaP9?=
 =?us-ascii?Q?4bFQkvUOy71tLXs1um7sQF0vRjXPTAPy0NnrDPCw6vT5DzoGQMp/RFHBgw5V?=
 =?us-ascii?Q?leoro8v6XhCeHt3Gu4gxoaRcParnEiqN/z2gbXQq3HgQskplFAA1Tl82gcv2?=
 =?us-ascii?Q?FGjEs13Hy5lVHS5Cwv8RkNf0TNUvJTWQ8HagB3abPnkC03bmzRKXdRWA6lgA?=
 =?us-ascii?Q?TqkE0mPv4t5btpr00C8q/MteOzpiC5Kgtz9NNWhV1V3mw1i9UhaBj/rsJiIB?=
 =?us-ascii?Q?F4Chbo2HFQPZed7MtysgcbCkq9xddsuCXjff3kEGrg0p5QBQkgmHnOkEUCZm?=
 =?us-ascii?Q?Nh2amutL9mL1q2V5gysHFFKrQbjWt6vyH2rz2OHImzmHJT3dgx3tj/4CC+Hc?=
 =?us-ascii?Q?l2bgsztgu/D6I/NZEL8bttTghhDAdvsa29pr4VmKgA9dqJGbn9TzXTEKVl+b?=
 =?us-ascii?Q?uNS+NkLFGlgOFbMMUFrxzPWFKom/+Duo0yaXSbIo81JgaL5uhQq1gbPWoFRt?=
 =?us-ascii?Q?ExFGa/jn3Eg6rvRBEDpxSboP+k2L9SvUpg/5ePrGHY9snj9yEP0tV3e0G8tj?=
 =?us-ascii?Q?U4bvkMQy2M2Bzwmk8sLtJ6qK9FptpDIAu/gipfKbvCj3WTqoQ8KaAfaD4TUa?=
 =?us-ascii?Q?N3+yOwhgyjB22DF+WfYazr6p3uDcQ/sdRLqSnB84AUzJqV9p1U6xPpCGfMTA?=
 =?us-ascii?Q?TeTemRDIPTpLg9dkrqR7X9vOIhYbT+2bINRTGVpwpFOrsgWweeN5UbEpTC2P?=
 =?us-ascii?Q?uPtIXSiuFtrgBWZAWiBNkIi+JRZj2ILwM7e+taNmXYqU2Qzdr6qU4x3dvQpE?=
 =?us-ascii?Q?MPo6tZPIFyVb2VoL487XHNxISSE38j7hr6S1QpuSoUlHgw46C75DuYQC2gCo?=
 =?us-ascii?Q?nmJv8swH/P0d6L0JkkRMphZWmSpZvBzk7AfP/iUoI3aHQ7JUkF4R6nEj860D?=
 =?us-ascii?Q?K9k4uy/P5+eHQBaKa3aGJmteyuoxqQltWNztAJMQTAbGAZuRwQddyW+SANxT?=
 =?us-ascii?Q?T1yP/B4qa3YU9tfKTRAVSGnaVEDZXb/riBoT5vsBASlkSmviB3m6Lkhj2GSq?=
 =?us-ascii?Q?ug=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68ddbd31-50e2-42c1-0f9b-08da76512d4d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 19:40:25.2362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zTfEO6skAmn/5W61yyEAvzWQN9mIuj6g28BbVxOkKCtiw5EHzcLV/hMVYEL7LbZhARbsa3tkPkaleS01lpEuSh1lIw3Ll3/xzk0fYUzNgqs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5136
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208040085
X-Proofpoint-GUID: sSeNeRJGSCsvcG7cAtLTjSW6jnyzCnsd
X-Proofpoint-ORIG-GUID: sSeNeRJGSCsvcG7cAtLTjSW6jnyzCnsd
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add parent pointer attribute during xfs_create, and subroutines to
initialize attributes

[bfoster: rebase, use VFS inode generation]
[achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
           fixed some null pointer bugs,
           merged error handling patch,
           remove unnecessary ENOSPC handling in xfs_attr_set_first_parent]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/Makefile            |   1 +
 fs/xfs/libxfs/xfs_attr.c   |   4 +-
 fs/xfs/libxfs/xfs_attr.h   |   4 +-
 fs/xfs/libxfs/xfs_parent.c | 134 +++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h |  34 ++++++++++
 fs/xfs/xfs_inode.c         |  37 ++++++++--
 fs/xfs/xfs_xattr.c         |   2 +-
 fs/xfs/xfs_xattr.h         |   1 +
 8 files changed, 208 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 1131dd01e4fe..caeea8d968ba 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -40,6 +40,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_inode_fork.o \
 				   xfs_inode_buf.o \
 				   xfs_log_rlimit.o \
+				   xfs_parent.o \
 				   xfs_ag_resv.o \
 				   xfs_rmap.o \
 				   xfs_rmap_btree.o \
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 2ef3262f21e8..0a458ea7051f 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -880,7 +880,7 @@ xfs_attr_lookup(
 	return error;
 }
 
-static int
+int
 xfs_attr_intent_init(
 	struct xfs_da_args	*args,
 	unsigned int		op_flags,	/* op flag (set or remove) */
@@ -898,7 +898,7 @@ xfs_attr_intent_init(
 }
 
 /* Sets an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_add(
 	struct xfs_da_args	*args)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index af92cc57e7d8..b47417b5172f 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -544,6 +544,7 @@ int xfs_inode_hasattr(struct xfs_inode *ip);
 bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
+int xfs_attr_defer_add(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
@@ -552,7 +553,8 @@ bool xfs_attr_namecheck(struct xfs_mount *mp, const void *name, size_t length,
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
-
+int xfs_attr_intent_init(struct xfs_da_args *args, unsigned int op_flags,
+			 struct xfs_attr_intent  **attr);
 /*
  * Check to see if the attr should be upgraded from non-existent or shortform to
  * single-leaf-block attribute list.
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
new file mode 100644
index 000000000000..4ab531c77d7d
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -0,0 +1,134 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle, Inc.
+ * All rights reserved.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_da_format.h"
+#include "xfs_log_format.h"
+#include "xfs_shared.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_error.h"
+#include "xfs_trace.h"
+#include "xfs_trans.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr_sf.h"
+#include "xfs_bmap.h"
+#include "xfs_defer.h"
+#include "xfs_log.h"
+#include "xfs_xattr.h"
+#include "xfs_parent.h"
+
+/*
+ * Parent pointer attribute handling.
+ *
+ * Because the attribute value is a filename component, it will never be longer
+ * than 255 bytes. This means the attribute will always be a local format
+ * attribute as it is xfs_attr_leaf_entsize_local_max() for v5 filesystems will
+ * always be larger than this (max is 75% of block size).
+ *
+ * Creating a new parent attribute will always create a new attribute - there
+ * should never, ever be an existing attribute in the tree for a new inode.
+ * ENOSPC behavior is problematic - creating the inode without the parent
+ * pointer is effectively a corruption, so we allow parent attribute creation
+ * to dip into the reserve block pool to avoid unexpected ENOSPC errors from
+ * occurring.
+ */
+
+
+/* Initializes a xfs_parent_name_rec to be stored as an attribute name */
+void
+xfs_init_parent_name_rec(
+	struct xfs_parent_name_rec	*rec,
+	struct xfs_inode		*ip,
+	uint32_t			p_diroffset)
+{
+	xfs_ino_t			p_ino = ip->i_ino;
+	uint32_t			p_gen = VFS_I(ip)->i_generation;
+
+	rec->p_ino = cpu_to_be64(p_ino);
+	rec->p_gen = cpu_to_be32(p_gen);
+	rec->p_diroffset = cpu_to_be32(p_diroffset);
+}
+
+/* Initializes a xfs_parent_name_irec from an xfs_parent_name_rec */
+void
+xfs_init_parent_name_irec(
+	struct xfs_parent_name_irec	*irec,
+	struct xfs_parent_name_rec	*rec)
+{
+	irec->p_ino = be64_to_cpu(rec->p_ino);
+	irec->p_gen = be32_to_cpu(rec->p_gen);
+	irec->p_diroffset = be32_to_cpu(rec->p_diroffset);
+}
+
+int
+xfs_parent_init(
+	xfs_mount_t                     *mp,
+	xfs_inode_t			*ip,
+	struct xfs_name			*target_name,
+	struct xfs_parent_defer		**parentp)
+{
+	struct xfs_parent_defer		*parent;
+	int				error;
+
+	if (!xfs_has_parent(mp))
+		return 0;
+
+	error = xfs_attr_grab_log_assist(mp);
+	if (error)
+		return error;
+
+	parent = kzalloc(sizeof(*parent), GFP_KERNEL);
+	if (!parent)
+		return -ENOMEM;
+
+	/* init parent da_args */
+	parent->args.dp = ip;
+	parent->args.geo = mp->m_attr_geo;
+	parent->args.whichfork = XFS_ATTR_FORK;
+	parent->args.attr_filter = XFS_ATTR_PARENT;
+	parent->args.op_flags = XFS_DA_OP_OKNOENT | XFS_DA_OP_LOGGED;
+	parent->args.name = (const uint8_t *)&parent->rec;
+	parent->args.namelen = sizeof(struct xfs_parent_name_rec);
+
+	if (target_name) {
+		parent->args.value = (void *)target_name->name;
+		parent->args.valuelen = target_name->len;
+	}
+
+	*parentp = parent;
+	return 0;
+}
+
+int
+xfs_parent_defer_add(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct xfs_parent_defer	*parent,
+	xfs_dir2_dataptr_t	diroffset)
+{
+	struct xfs_da_args	*args = &parent->args;
+
+	xfs_init_parent_name_rec(&parent->rec, ip, diroffset);
+	args->trans = tp;
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	return xfs_attr_defer_add(args);
+}
+
+void
+xfs_parent_cancel(
+	xfs_mount_t		*mp,
+	struct xfs_parent_defer *parent)
+{
+	xlog_drop_incompat_feat(mp->m_log);
+	kfree(parent);
+}
+
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
new file mode 100644
index 000000000000..21a350b97ed5
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle, Inc.
+ * All Rights Reserved.
+ */
+#ifndef	__XFS_PARENT_H__
+#define	__XFS_PARENT_H__
+
+/*
+ * Dynamically allocd structure used to wrap the needed data to pass around
+ * the defer ops machinery
+ */
+struct xfs_parent_defer {
+	struct xfs_parent_name_rec	rec;
+	struct xfs_da_args		args;
+};
+
+/*
+ * Parent pointer attribute prototypes
+ */
+void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
+			      struct xfs_inode *ip,
+			      uint32_t p_diroffset);
+void xfs_init_parent_name_irec(struct xfs_parent_name_irec *irec,
+			       struct xfs_parent_name_rec *rec);
+int xfs_parent_init(xfs_mount_t *mp, xfs_inode_t *ip,
+		    struct xfs_name *target_name,
+		    struct xfs_parent_defer **parentp);
+int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_inode *ip,
+			 struct xfs_parent_defer *parent,
+			 xfs_dir2_dataptr_t diroffset);
+void xfs_parent_cancel(xfs_mount_t *mp, struct xfs_parent_defer *parent);
+
+#endif	/* __XFS_PARENT_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 09876ba10a42..ef993c3a8963 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -37,6 +37,8 @@
 #include "xfs_reflink.h"
 #include "xfs_ag.h"
 #include "xfs_log_priv.h"
+#include "xfs_parent.h"
+#include "xfs_xattr.h"
 
 struct kmem_cache *xfs_inode_cache;
 
@@ -950,7 +952,7 @@ xfs_bumplink(
 int
 xfs_create(
 	struct user_namespace	*mnt_userns,
-	xfs_inode_t		*dp,
+	struct xfs_inode	*dp,
 	struct xfs_name		*name,
 	umode_t			mode,
 	dev_t			rdev,
@@ -962,7 +964,7 @@ xfs_create(
 	struct xfs_inode	*ip = NULL;
 	struct xfs_trans	*tp = NULL;
 	int			error;
-	bool                    unlock_dp_on_error = false;
+	bool			unlock_dp_on_error = false;
 	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
@@ -970,6 +972,8 @@ xfs_create(
 	struct xfs_trans_res	*tres;
 	uint			resblks;
 	xfs_ino_t		ino;
+	xfs_dir2_dataptr_t	diroffset;
+	struct xfs_parent_defer	*parent = NULL;
 
 	trace_xfs_create(dp, name);
 
@@ -996,6 +1000,12 @@ xfs_create(
 		tres = &M_RES(mp)->tr_create;
 	}
 
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, dp, name, &parent);
+		if (error)
+			goto out_release_dquots;
+	}
+
 	/*
 	 * Initially assume that the file does not exist and
 	 * reserve the resources for that case.  If that is not
@@ -1011,7 +1021,7 @@ xfs_create(
 				resblks, &tp);
 	}
 	if (error)
-		goto out_release_dquots;
+		goto drop_incompat;
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
@@ -1021,6 +1031,7 @@ xfs_create(
 	 * entry pointing to them, but a directory also the "." entry
 	 * pointing to itself.
 	 */
+	init_xattrs |= xfs_has_parent(mp);
 	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
 	if (!error)
 		error = xfs_init_new_inode(mnt_userns, tp, dp, ino, mode,
@@ -1035,11 +1046,12 @@ xfs_create(
 	 * the transaction cancel unlocking dp so don't do it explicitly in the
 	 * error path.
 	 */
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, dp, 0);
 	unlock_dp_on_error = false;
 
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
-				   resblks - XFS_IALLOC_SPACE_RES(mp), NULL);
+				   resblks - XFS_IALLOC_SPACE_RES(mp),
+				   &diroffset);
 	if (error) {
 		ASSERT(error != -ENOSPC);
 		goto out_trans_cancel;
@@ -1055,6 +1067,17 @@ xfs_create(
 		xfs_bumplink(tp, dp);
 	}
 
+	/*
+	 * If we have parent pointers, we need to add the attribute containing
+	 * the parent information now.
+	 */
+	if (parent) {
+		parent->args.dp	= ip;
+		error = xfs_parent_defer_add(tp, dp, parent, diroffset);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * create transaction goes to disk before returning to
@@ -1080,6 +1103,7 @@ xfs_create(
 
 	*ipp = ip;
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	return 0;
 
  out_trans_cancel:
@@ -1094,6 +1118,9 @@ xfs_create(
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
 	}
+ drop_incompat:
+	if (parent)
+		xfs_parent_cancel(mp, parent);
  out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index c325a28b89a8..d9067c5f6bd6 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -27,7 +27,7 @@
  * they must release the permission by calling xlog_drop_incompat_feat
  * when they're done.
  */
-static inline int
+int
 xfs_attr_grab_log_assist(
 	struct xfs_mount	*mp)
 {
diff --git a/fs/xfs/xfs_xattr.h b/fs/xfs/xfs_xattr.h
index 2b09133b1b9b..3fd6520a4d69 100644
--- a/fs/xfs/xfs_xattr.h
+++ b/fs/xfs/xfs_xattr.h
@@ -7,6 +7,7 @@
 #define __XFS_XATTR_H__
 
 int xfs_attr_change(struct xfs_da_args *args);
+int xfs_attr_grab_log_assist(struct xfs_mount *mp);
 
 extern const struct xattr_handler *xfs_xattr_handlers[];
 
-- 
2.25.1

