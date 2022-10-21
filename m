Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAE11FA3742
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Oct 2022 22:30:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiJUWaR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Oct 2022 18:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiJUWaP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2022 18:30:15 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81EB924E424
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 15:30:14 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLDdhQ019107
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=eSC2HQxXbOxiU12g0fZsu10rz8/gWBsOCXSlBeFn4tk=;
 b=onnvgAurBkstEkUwoorPj2L8CCYqd5WHrz00s0TzxxTMpGxZG/sRVC0L+lFT0LXV+TsQ
 FDtAt7mPNwT9KXVTHrdHztwOzPrQpP8EtffXz/9hnxbZq9BU7+LqWhSMNj3HW5X/3hoL
 ardgh6HJM9sn1ePk/a6Q+H4vk215rXr74yZSvEmtlZZ0AlpXDxAYWrwSq0oFy8X6Lx+p
 8QOWQG1ETeCT+0gyhI6kZDPC03753ZZTEv8pjRdVoQr4KuX+FD7Y2N/g25AB81my6eih
 KSM8vg7HcQ5Vpo7SCMSgPDcydDfuUG/zvddmjkeALLUE+jaUitjOaCIEvVu+8NBa6G3C Iw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k9b7swa1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:13 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29LM7RSD038693
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:12 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hr3n28y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D/EWL/hQE+zvrYU79WFl03f9sKa3ioT2DaWsc3rO/Nt8fzL++azlqbXbcTh7zzN540JhYpdHMsEudSG51GN6JtEh6o2NgwxlrJ0xqcvVpo2wn3d7eLcfNaF0vWDONoGS2d74nrDWjq+5qdqEiwGeCZv4X0KcWt1qmtkNCe5uV2CWE9h9uEM6p+PdE/akWGom2SWk8XsrAYoT9Vzk+PgdRVhPoaJxvAK0JAofJ4pNKmS7829chFvHARMCRkzL6IezPNhFIfyB8zoCd7SwyMwf/8zLkNKRiJblEclv7rYNBRUYDqzOqQGm+AQGA52ISoLih4pWhPrVJiPANy9MWaeY6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eSC2HQxXbOxiU12g0fZsu10rz8/gWBsOCXSlBeFn4tk=;
 b=nGku7kgM+NUi0Soi+gD240Sj99FguS8BPwNnpp0l7cJSV2G+GYgw0mXjD9JaOpQExZCmZN546vIhPpWQ9m6nu8c3Dcke46ZoqQO7Oohvr4aoloAtn2ucHaNIfOwJWS+GD/gBDzcJzRchjD5FoiQMbcMt/iuWw3x6onBwcUFK1sawPoxFDpJt6EGs0ezRvsNhun74PgqKT+7K39z0vlQp/bJnOB/D4RMnPLKcUwvDxh860ZlVQmYAYCvTsw2d9leHNKxtH90jSG2o9XloeacwRDqI9xiGkoWjRvKpVP2g2tAU8+svMPynDlJycKvQ5dhX27Qv83Yl1/KGumwr3yW+Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eSC2HQxXbOxiU12g0fZsu10rz8/gWBsOCXSlBeFn4tk=;
 b=TsTJZyRQntisrm6Bx5gJptUrsAhU9BpxxdxcAFl20u0GgzN0aucTa7RPLYJvH3qBVn8bf4ncb3uVifPRXEtwrUI8QfsyArZ2h8f6ibQztLTod+DEBZ2cIey5tGEO4KToukkhRDNi3JP6T6AEUi0T3Qy5N9YguYerg9Q2R05MNJE=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5213.namprd10.prod.outlook.com (2603:10b6:5:3aa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Fri, 21 Oct
 2022 22:30:10 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 22:30:10 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 20/27] xfs: Indent xfs_rename
Date:   Fri, 21 Oct 2022 15:29:29 -0700
Message-Id: <20221021222936.934426-21-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021222936.934426-1-allison.henderson@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0057.namprd17.prod.outlook.com
 (2603:10b6:a03:167::34) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|DS7PR10MB5213:EE_
X-MS-Office365-Filtering-Correlation-Id: d0ddb8e4-f5e2-454b-57fc-08dab3b3d059
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HjjCRJoJZWHAEH1gOgHrZYNvNO8s2dw9/itYqGXnvVAu0rp1PC5HznZgQUFoQjgKmSjx9NR7bThSpj04g/9Gj4NKos1EnK2VWHVYuAFzz/ZpFi0Ig3z8NqPEUcdMPxZsYPgytLGK5yDcgR6DVcLfbBZGUdE4y7B09U10mmUJhPrCNN5jUBn92UXNOPBMBeBimPtDiwkil3iK0UtYst9npluF+1dXwInrbt4GZDF0VhJuIhZV42SmmZkgOZ/yXNkZBsgZF3Az9ba7Vj/KKYV5VAv3cnHqitOuhI3j3ClPik0ceNlEgviuTnq0Em7zdcv1H0RO/A/FGYmGLMNtpQgCly80PZmU6c5UQ0Fv3nNaiLXbULGncEl4AMnaNn54IHnQEtthVauWu7tr/tYTVgFW5Am0sPxITpamdJXsPGzKuEJ7DJAnCd+gYTopqKtztEiSLWBN3fpvWM2vBB5cLXp+JXRfKcNxgV6Mr7Yj+pJVynfvjCVXcdQNlmACAnzj0iM9PAjVRoXNrrZd2/c5+7q3HvzUkyK4uS3Px5W+vwFfXLj8SLLKyvQSu5JL+7QMlimmJK4Q99GUdKld/u3aabFhnMJ0ip0fOHDzKRvoyWY6gLDpls15rsFWOoaXNP22eohmb/Nl9GEVz9zbVK4tMoIlTabmugfRjpWgp1Yk7wbTcySlL3O3Jry8Shv2BzmEB/Q/Fwelwxu8T2n4G8iG1q8D0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199015)(66556008)(8676002)(6916009)(66946007)(316002)(2906002)(66476007)(8936002)(36756003)(41300700001)(6506007)(6666004)(6486002)(38100700002)(1076003)(186003)(9686003)(6512007)(26005)(2616005)(83380400001)(86362001)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?miqzBZHP4bq6i5it3g+7qB1NQRvmNUyFrhzNShLXvEenZjOF0YsC85jnEpSN?=
 =?us-ascii?Q?O9F9Tg+TO1nq/KYTTc07Z5ZRJGhbJBfO/icnX5rzpZ6KmWQWuuuUN8lThZP7?=
 =?us-ascii?Q?yPcxV0NEdX+y7X558eEAtkL4/Rq9bs7rvMtV+koFN8iPLaFBdyZ9KLMxFqMR?=
 =?us-ascii?Q?NoTacsSUY6CRNqMXWKCB3i0lt5sMcHP39IvvTZ4sxNT+pyH0ckjIds3B/oyv?=
 =?us-ascii?Q?Pitq6yL/Yb94G8kT1kQY7lU0BHhnS5eS1EyLWMVtHY2TuH2bqLtEkPJf7Ht+?=
 =?us-ascii?Q?FWehjJDfA6fatnAkdfY3EBp9pIR48WXmgiquny0vgBwN7fvPL5zc0F4rml22?=
 =?us-ascii?Q?4YPQktV0rE/LpIgNYk6WgGhBDw0f+Mge9aQfvrAwy+WWzwU4FyRlJFHTHm37?=
 =?us-ascii?Q?7WnvBSptZuztpHWbKy/CqDh3ZzYjqEd5uvW58sI4KXEvooGgFbIAJKFWLFNX?=
 =?us-ascii?Q?1lhpHvHn1JyRZAzkRU9+8elgWDVcTW3IF9ksNrbo+BJhHw4leAtqUVq0uQHu?=
 =?us-ascii?Q?XUqyEwZ5FwB4t/SJPm25Or9saTN4nzLPgWD8W6j3VzOSkWF1YP5Y5hKXYn3b?=
 =?us-ascii?Q?kFFobUJMHlwVQsR2nx8wABUECqyLEnFyO3WVDSmE5D2lZDup4Uu6IiAIaeo4?=
 =?us-ascii?Q?wsKh2dye9AufpRRRqSjFndFUlQ48WBuwKIsFz/2aCIEjcE3cCsxyc6Ig/QHs?=
 =?us-ascii?Q?kRbcQxB6MFPtMd4v8YVqn1mg8640z3zHUB4/zs6f58zmdngrmCI6wemBZyqh?=
 =?us-ascii?Q?GzWtmi8XE9TosMeKqCleUbuT/fQYVKnl/BGlslg7neroHMJLfRi+iRwn1Oo1?=
 =?us-ascii?Q?OWK3kxVHsZZu7P82/YABH5DHenabmdlLtjQyVbYtYfb45rON+kNOtlDhSSzE?=
 =?us-ascii?Q?mNa6todeXfH5X85b8NbynHTP60kaHKefTwepHOxc00QuSYtTQUdTeO1om3n7?=
 =?us-ascii?Q?yPBhQov+joGnIKeAsyN/UWXNhAjsE3vfKnTTr5pJS9U22Y5kTqmFfZG28Dzj?=
 =?us-ascii?Q?B0A7qyqZbm/mCXT9QyaorWRqXW2S/dNYKbJXvSJ8xhRv3u279wGkMlDneUZw?=
 =?us-ascii?Q?MME/2qc7mB5YP+c4f+e4p3APggGr2cvndskgStBqCaAy0jLcrpiYZaanD0VQ?=
 =?us-ascii?Q?Kolbm/QME7QdPhxBMSY7hyq+M75mMq3fWX6pCeBBUCcxld9JbsdNgZRRkFFL?=
 =?us-ascii?Q?UBq0t7DTjFFWDoyCeZNbW/bsY0ByqJX8iCtaNJ5ePrEMDFq1234XMJNidEu8?=
 =?us-ascii?Q?wA6QZLh6YBipy4q8vDPDIiI/DGyi0zZn2ySRAvwDKvLN6D7GTYaZRExaaPo4?=
 =?us-ascii?Q?wS1AWggUm0FuePiOBK1WNrzjn342+RjsxdUTI3z4V4Ce5yJAC/hWrUHx9SRs?=
 =?us-ascii?Q?7cnLy+v4gSqkzTetu3Z0R97eFnnp3m6Xx59smI7/vv+lzohpJmxZitHI8CBc?=
 =?us-ascii?Q?3dioKBOuEeqWhVjOYkiF9avgHw6H0ifLucKGbsGWpVdLAqa5arSbzxR0hjCs?=
 =?us-ascii?Q?gGeXk4501uZE9yZMA62YypPNL6mdZI4MPhVjG/4d5MWGFuiT+YB2bFo+14R2?=
 =?us-ascii?Q?DQh4MOSIUoXefj9kGCGAgJYVexOehXFeu2SiK97d0aQET0mImskV8N7OBNtr?=
 =?us-ascii?Q?Bw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0ddb8e4-f5e2-454b-57fc-08dab3b3d059
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 22:30:10.4411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iG6e7mOPB2odA5kZXWJtuOmF6t9hYkUWANLgGfJadgcTTQbMWKRixxsMo3u++GrsJ6bDXF6f5zMqtgG7Cs7+1mQ5VgGJTJDUIlhHHtYv4ak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5213
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210210131
X-Proofpoint-GUID: sUlHVjl9s51FpgZExrz2o66Nk7IUZmam
X-Proofpoint-ORIG-GUID: sUlHVjl9s51FpgZExrz2o66Nk7IUZmam
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Indent variables and parameters in xfs_rename in preparation for
parent pointer modifications.  White space only, no functional
changes.  This will make reviewing new code easier on reviewers.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c79d1047d118..b6b805ea30e5 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2946,26 +2946,27 @@ xfs_rename_alloc_whiteout(
  */
 int
 xfs_rename(
-	struct user_namespace	*mnt_userns,
-	struct xfs_inode	*src_dp,
-	struct xfs_name		*src_name,
-	struct xfs_inode	*src_ip,
-	struct xfs_inode	*target_dp,
-	struct xfs_name		*target_name,
-	struct xfs_inode	*target_ip,
-	unsigned int		flags)
-{
-	struct xfs_mount	*mp = src_dp->i_mount;
-	struct xfs_trans	*tp;
-	struct xfs_inode	*wip = NULL;		/* whiteout inode */
-	struct xfs_inode	*inodes[__XFS_SORT_INODES];
-	int			i;
-	int			num_inodes = __XFS_SORT_INODES;
-	bool			new_parent = (src_dp != target_dp);
-	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
-	int			spaceres;
-	bool			retried = false;
-	int			error, nospace_error = 0;
+	struct user_namespace		*mnt_userns,
+	struct xfs_inode		*src_dp,
+	struct xfs_name			*src_name,
+	struct xfs_inode		*src_ip,
+	struct xfs_inode		*target_dp,
+	struct xfs_name			*target_name,
+	struct xfs_inode		*target_ip,
+	unsigned int			flags)
+{
+	struct xfs_mount		*mp = src_dp->i_mount;
+	struct xfs_trans		*tp;
+	struct xfs_inode		*wip = NULL;	/* whiteout inode */
+	struct xfs_inode		*inodes[__XFS_SORT_INODES];
+	int				i;
+	int				num_inodes = __XFS_SORT_INODES;
+	bool				new_parent = (src_dp != target_dp);
+	bool				src_is_directory =
+						S_ISDIR(VFS_I(src_ip)->i_mode);
+	int				spaceres;
+	bool				retried = false;
+	int				error, nospace_error = 0;
 
 	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
-- 
2.25.1

