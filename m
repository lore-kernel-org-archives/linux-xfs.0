Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB3A1C433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 09:42:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbiFKJma (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Jun 2022 05:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232656AbiFKJmS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jun 2022 05:42:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9185CBF1
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 02:42:15 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25B3w5xg029706
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=fM4Relasplvefc/wwawkejBLr24x23nPqOvaIjKXkqo=;
 b=yoVjkvR14qm9jeM1dRjPoYav+9/IFq1S0tlH88ehOnGALFw211avznNtRwqnWIEA3fhd
 L+iPQH1WTRVSK8LBjnCeNChflMGGEeAEnJO90y1tWYCtCU27zzne0kB2cUChsHLUkvGs
 KmrQ/MwZ/5EcfLziQbBwy8I0Axyuau6+3NyoH6IbfDPztIvlOJuN1+QfBc9KYU6UylB9
 fpriySp03cCFoUOFGPHNbn04tdVVGSRS0ozv4ZaXFsF02nF3TG8Ta7EkoLrZgMZROXuZ
 m//WdEpK/dJAFRd5JeeJAdfqAeCcQA8zR4rIaWvcKOk3WQEuU4/ukNPAhjeJl97yfZyv FQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmkkt89wf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:15 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25B9ZMQF025527
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:13 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2046.outbound.protection.outlook.com [104.47.56.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gmhg6urjp-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qyd8kDvq8CO98k5EfrBYy6LU4LmRP0CqABIgQaaYtm5lB/fZlE+wdicYzkls0pRtrV/6tyXbQ8r/h16FG/pT2Oe1Fd5HL1AdCxDwt6NdAOh5boLV8POfqgztFoN3DuLBGPzqOjvpgRTxzJRxsh6LWmxjPr23K5Cw99nOr2xKv+vhQfeVBZ0lS2Nu3hbyr7C9ARXbY88QrVRyFkkneK1TaCKpe5lpbUwxkCMZhzsLZLQE3B/Qqr1EPa+wD+pLVMz6Aklf2dyZW2EZ15ZMyeOTzIQFn6hF0gzYlTP6+H4zG5J8s4YBAK+mKr3wH/5eOkZnhppGSCm5AbAAqsHCy0YjIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fM4Relasplvefc/wwawkejBLr24x23nPqOvaIjKXkqo=;
 b=SC9iZFmvG1czYU/o7FNlfdky0KsoztZltg5EtEp8P0qI63d55mdPBBcKQY3DW30kRZrqHEBMt3hqc7SFFToJ/v5SdLP2z9DbPf/KZWs40MpXkshkQ6M6RtuwMXROH43JKdqUh0M8+N9cShzKjoJ6RIsEar/FQ4Nu7VVECgMx2+r5OhJUZp+54P5S3x5m/8CpkagFuRASgqqnXvhxFKnaNgpk4NFrYbyJipKYsbOkILQTC0SHepfm3KAi4IPkAEUSr5owbFYA5tKSE/hVBRutWK7kste2cvxQ/isjsYu3/6Pxc9baKaQhAuRP36uKtIvFmBYcGlKACRLTJIEbwvomSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fM4Relasplvefc/wwawkejBLr24x23nPqOvaIjKXkqo=;
 b=CdYfhI1uc9xzt+nq7XEdI2Q+lI1wHgJM1oideh8YKN+h1+8iY8zzx1PVyBznwExtNT20SBhPRFEB6pwQM3Cvoh/4D4xnANKIBeg7vlJLZl41rIl2gtTjNPW1TFCAcBBnTMvGU0oecNhnPfF2dt1brMgv7fBHzezquB7G6XymwMo=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4606.namprd10.prod.outlook.com (2603:10b6:a03:2da::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Sat, 11 Jun
 2022 09:42:09 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94%7]) with mapi id 15.20.5332.013; Sat, 11 Jun 2022
 09:42:09 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 12/17] xfs: remove parent pointers in unlink
Date:   Sat, 11 Jun 2022 02:41:55 -0700
Message-Id: <20220611094200.129502-13-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220611094200.129502-1-allison.henderson@oracle.com>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:a03:180::15) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: faca4b69-08cc-40e3-6a77-08da4b8ea770
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4606:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4606078CF7D74D5238B722AA95A99@SJ0PR10MB4606.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2aUAu3ZJdAnNriGVETjZ24yjFB7e6vR22bYoiv7SDrHcWhYPsyXLGZ59sssGj8M6byOTxIZ6VE2hkI1i056UXclST9HbqfMn0ZKjWokW6OPhNVK++ncrVqIYw0Cy4KcT9Op9gOZRycu//ZDqS50fg49GZBCKRTnJh4MXmnTdkA2/E1SqbMqlF5RUiqahXVN4vEUC+EV0RO4yP3nIxruLVqdmmD39nX1b43jrtvtuSP/NKVFTNYn7XY8M4zz5VlPRz2UfTpSg79TI2oeApoELYJiZN+kSDtcxADDkIx+26qllo1iLB+8HNeNtgP6kniZQJFqhsDb11fsMMhv0s8TLibCW4+Qa/fk3dKrs5I0By3c7oLZM1XCCJ+thaVz2VE1tLw0Pk/oPkwixIJjRN1xoxbPydr4m+mohog6sVKnc2Ao2iuE1iQGRkvjO2GNa+9bwNn+XV7TzSu3GcKWQ7/9cJkpJJUP4SGow5NhVhOHsaXPDSkgWfBXTxO9ZWtvgl9xRWbkxi+4iu+17GrIKphVUI3ac/Ngz5FdwcrKFRpqIBj8dqY1qX57X+OcBpls8o5NPbVpJaguYrWuw+BWL0oYdBjgYwBTnaGQBhItL0vO1xXWhgz/LeC2uIWLPsSlIiEkPJMY9DGfCYEQvxOAZEmsz4YSCdyITgYcq2bYgO/2t2E3J+ENan4D1jJyRAbC8rtEunhCrda/ENIJCJRfrR5XerQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(6486002)(44832011)(86362001)(2906002)(186003)(83380400001)(36756003)(66946007)(66556008)(66476007)(8676002)(5660300002)(508600001)(8936002)(6916009)(316002)(2616005)(6666004)(6506007)(52116002)(6512007)(26005)(1076003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?54n9ny19cQSu9TWEiyHhc0hCUn+sE/TtmqZFE8rqBclRpOe2BKpF2uM9zC8y?=
 =?us-ascii?Q?SRu1fgfqHyHkBZ5jq/IBYCodjhJhedW5xai/NoUn3dUgHvXiZBcenbyKeY/A?=
 =?us-ascii?Q?Z0+ef1R+NzbZ0zZt/hI081NDXoBpd8VmhJ/TvzjwrkjTc57Sj6lRo4/B5E9D?=
 =?us-ascii?Q?s3IYADiqGgV/l3Io3MNFAa2fD6sK8YoX7KXxoxtWIOxPSgcPUuzcM65YkaOm?=
 =?us-ascii?Q?eiLIlAHD3OvweBAIN24rgmbKpMuRoRRGhAkTkE56YsYYZFHaEFWDoX3gN5G8?=
 =?us-ascii?Q?QOQIouO3z/FE5RlPrv9QbYswBB9wYjlQflt7gmxs+LsMGsKUrjNRx7ybBCaO?=
 =?us-ascii?Q?ye9FTrJ8MrA9iP2LOgmWghOohAILblSYvWvAumKXgFe7nE00yGD8cEd8v6Kc?=
 =?us-ascii?Q?1Mc7Wuk19jwNpG1q7IKtrkcAPvqfe+0isK1OzCn84WRq5/ENsigFjeF3CFDR?=
 =?us-ascii?Q?gXrGJcNvZ8hRYX89XnWxyPvmVr7j2t8Q998v06qN24nBMDpnBDegLgcV+YK3?=
 =?us-ascii?Q?3NNfwLDVmQjEfkaXH4Y9UygQvY6Ri0ipnH6sAclMc+GIxW6lFNyKQByBxbgS?=
 =?us-ascii?Q?QfddRYrBGtcFuGRQ/vdQIGVksx2CBf8bjDwAaicWM714bn6Cl9aqnaWk4Kh+?=
 =?us-ascii?Q?ZGk8lcg2nVeFeFmbs/53X3/yllNsdSICPGwWruqWZ1o/mFD/eZgapG0HEZB+?=
 =?us-ascii?Q?Adf0yPQAXVx163reKiVLCZzU5FcPKI9AiYWLTodLAKy/tnntVGrvkreMHfrJ?=
 =?us-ascii?Q?wIZb23EgMAYcJtegIM01Ej1AyANP0Oaat7hzTG+LgAJ/zlyNDrNDhZlCuarz?=
 =?us-ascii?Q?lWfTRTzOUapG38lAeP57j+MA8O3BV85aJO6ARPZuY6GZzpf7lpjo8cOrQQMm?=
 =?us-ascii?Q?JrjpK45r09+//lfV4fFLEj8hygU3sx9fidajGovWwM3/4NSOJJXz1Ne0lM+9?=
 =?us-ascii?Q?g+JO4FwJ/yBWN3w9eHpeftyipATc4rBy6/IG0Z6/bWtQp6VirXYIvDA/0p7P?=
 =?us-ascii?Q?mn4IncuEOZ5iKKh/YsuZIuyEUBfP3gwJ6vdk/aETJvEka4WeGkysrIQM+qUY?=
 =?us-ascii?Q?KsvPJfFQdXIvy72b4SnN2O3VS3UQaByuYGUcJsUdUxH/y/obRuwwTqR8QmH2?=
 =?us-ascii?Q?k9TIZ2kNTPicxT3HzDUsQ++TV5DIsvr9toiVvZ+9nSN+YFADwayno8QdAPAM?=
 =?us-ascii?Q?gigKmKtq+TJykwvZmGO2ZjCbHkcIDvvqUDC2v1FUGND0bghTT0Kj5cXfRIu2?=
 =?us-ascii?Q?lf41a+5Fg2xE5ZKNZECUlJlgnG3azbPkFtcHlffR2dDAE5Yv0kkI+ihuDyrI?=
 =?us-ascii?Q?mueUfDu/EArWM65ESGKNk0ZiKBTc0oMmMa6qO1gy3KJ88gfJ8tukOG9T0ay5?=
 =?us-ascii?Q?xAhHHN43h362y2arr1u0UeHZ3lH+hxp/z4k6wC/fU4/IOv1qULDtxigdYYGU?=
 =?us-ascii?Q?hrH833JCZwZ/xQJKOM77sDeNq8FebBhCCIH/eROQD9GKKFEAvybS+fFA/CQu?=
 =?us-ascii?Q?IjJWEFKLULVn2jRlzj3wTw6OW6WQlkLX7OmudiUd3np4OsqHF3ZGVL1qbyw9?=
 =?us-ascii?Q?4sZWWAS4gaEgfQJvDZheAG3KMyGMhI/zUGQ6Bqhfw92hTTwCZIND649zyvAU?=
 =?us-ascii?Q?foZlIV/BzgWjAk0u50vh3Iedr4giiAluNtD6s4lDYpj4JgChQO/dkfwcktZg?=
 =?us-ascii?Q?krlQq5E4F0zzEtR2vL+7QKdedxxVotxn+v1iG8A8V+uID0okP9i9MRK6OH52?=
 =?us-ascii?Q?FTdesVTooDZyYIFCvF8EcoAyPpjlodA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faca4b69-08cc-40e3-6a77-08da4b8ea770
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2022 09:42:09.4354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yFvwjp1VTPAnyyXMihjnNistV8X80fTZGjjujFnBxjQSNQxCkAxiS1dRbYa8wr1Vc89g0UZ5Yek4Fq1Db2VtABOIKAqNcMvxbjYs9t92DIE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4606
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-11_04:2022-06-09,2022-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206110038
X-Proofpoint-GUID: ga43GUBN7Az0Pus6otH5Qs-rIvu-FODU
X-Proofpoint-ORIG-GUID: ga43GUBN7Az0Pus6otH5Qs-rIvu-FODU
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch removes the parent pointer attribute during unlink

[bfoster: rebase, use VFS inode generation]
[achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t
           implemented xfs_attr_remove_parent]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c |  2 +-
 fs/xfs/libxfs/xfs_attr.h |  1 +
 fs/xfs/xfs_inode.c       | 63 +++++++++++++++++++++++++++++++---------
 3 files changed, 51 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index f814a9177237..b86188b63897 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -966,7 +966,7 @@ xfs_attr_defer_replace(
 }
 
 /* Removes an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_remove(
 	struct xfs_da_args	*args)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 576062e37d11..386dfc8d6053 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -560,6 +560,7 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_defer_add(struct xfs_da_args *args);
+int xfs_attr_defer_remove(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 41c58df8e568..160f57df6d58 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2828,16 +2828,27 @@ xfs_iunpin_wait(
  */
 int
 xfs_remove(
-	xfs_inode_t             *dp,
-	struct xfs_name		*name,
-	xfs_inode_t		*ip)
-{
-	xfs_mount_t		*mp = dp->i_mount;
-	xfs_trans_t             *tp = NULL;
-	int			is_dir = S_ISDIR(VFS_I(ip)->i_mode);
-	int			dontcare;
-	int                     error = 0;
-	uint			resblks;
+	xfs_inode_t             	*dp,
+	struct xfs_name			*name,
+	xfs_inode_t			*ip)
+{
+	xfs_mount_t			*mp = dp->i_mount;
+	xfs_trans_t             	*tp = NULL;
+	int				is_dir = S_ISDIR(VFS_I(ip)->i_mode);
+	int				dontcare;
+	int                     	error = 0;
+	uint				resblks;
+	xfs_dir2_dataptr_t		dir_offset;
+	struct xfs_parent_name_rec	rec;
+	struct xfs_da_args		args = {
+		.dp		= ip,
+		.geo		= mp->m_attr_geo,
+		.whichfork	= XFS_ATTR_FORK,
+		.attr_filter	= XFS_ATTR_PARENT,
+		.op_flags	= XFS_DA_OP_OKNOENT,
+		.name		= (const uint8_t *)&rec,
+		.namelen	= sizeof(rec),
+	};
 
 	trace_xfs_remove(dp, name);
 
@@ -2852,6 +2863,12 @@ xfs_remove(
 	if (error)
 		goto std_return;
 
+	if (xfs_has_larp(mp)) {
+		error = xfs_attr_grab_log_assist(mp);
+		if (error)
+			goto std_return;
+	}
+
 	/*
 	 * We try to get the real space reservation first, allowing for
 	 * directory btree deletion(s) implying possible bmap insert(s).  If we
@@ -2865,10 +2882,10 @@ xfs_remove(
 	 */
 	resblks = XFS_REMOVE_SPACE_RES(mp);
 	error = xfs_trans_alloc_dir(dp, &M_RES(mp)->tr_remove, ip, &resblks,
-			&tp, &dontcare, XFS_ILOCK_EXCL);
+			&tp, &dontcare, 0);
 	if (error) {
 		ASSERT(error != -ENOSPC);
-		goto std_return;
+		goto drop_incompat;
 	}
 
 	/*
@@ -2922,12 +2939,22 @@ xfs_remove(
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, NULL);
+	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, &dir_offset);
 	if (error) {
 		ASSERT(error != -ENOENT);
 		goto out_trans_cancel;
 	}
 
+	if (xfs_sb_version_hasparent(&mp->m_sb)) {
+		xfs_init_parent_name_rec(&rec, dp, dir_offset);
+		args.hashval = xfs_da_hashname(args.name, args.namelen);
+		args.trans = tp;
+
+		error = xfs_attr_defer_remove(&args);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * remove transaction goes to disk before returning to
@@ -2938,15 +2965,23 @@ xfs_remove(
 
 	error = xfs_trans_commit(tp);
 	if (error)
-		goto std_return;
+		goto out_unlock;
 
 	if (is_dir && xfs_inode_is_filestream(ip))
 		xfs_filestream_deassociate(ip);
 
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
 	xfs_trans_cancel(tp);
+ out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+ drop_incompat:
+	if (xfs_has_larp(mp))
+		xlog_drop_incompat_feat(mp->m_log);
  std_return:
 	return error;
 }
-- 
2.25.1

