Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECE84C64EC4
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjCHWiT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:38:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbjCHWiO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:38:14 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 879A92C66A
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:38:11 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328JwoiY020849
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=x8OwePzbBza8gqf5sZTqSvIWBTl+sSleeliCQwQ2aW4=;
 b=sIkyCz+8s6boBLqMjLonPzZqVk9RVLZpBTQ2QE8UJnEwh4BStv5PbvJ/LjCJuhpt67hA
 oQcN9UMQFdawC7vAgbynFf+srFJvfCuqhrKufE5dq5DWw/LvhvbwNj4MLx9qeS/rG9+2
 g0luwtT7kMg3YVhZ9SQvgmtS1ZK5pTOwGf3mEEWObjL8IaaZS75eA3KinwAgwtMcMMGO
 zdDPTm3k7vajUKZ5HJR0uNr6IGC4eNPJ1x9iYaJqXieFU5CZ+ALSVr6ryC6M2jPGxDaL
 cHxSEs10j+nalqOZ7ydFn6dLDW+YnEwNwt2gC8ojrgAUyxgTURuytSj7QjwJkZLnU+80 QA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p41811a29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:10 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328MAF4l036499
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:09 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g464w1m-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FtURCQuomKSm8Pe2kf11DVx21C0GcHGRDdJNxujZswzuaisSQysvwsKfvc3dWRv0aQb/rV7kBgGX1T0+E//0sZ5r3Lr6ieB8faMObUpqV2qcHfk3Ae1PCzvCtGhUfYhy2IuZKWvUGVp4+b+PyjSYChatG5VAlOoOrTAa+AGkObtJ9tYApvVCPERUx/GZJEg2AGH423wxAAE3htkQM25pHdAJaxnJQ0TRV0OPPpggA9B+goW4+T9zLR0OH1JZpGMoT//H37pwTs/fYYVkjObVhnPQn70eqIjeGNKaPIm4wX3DKdBpGjMY0rmqqW1EcUlhK6oBeFGwz/dhAP8JAFW+jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x8OwePzbBza8gqf5sZTqSvIWBTl+sSleeliCQwQ2aW4=;
 b=SSoxvoXnAZP+5XKuTP4aqvogSHJInR15po6eAgT/RlAqyAAygYXWFEuCHOkgbjHjO0A4oS2yzxLFuV2tEW4ynLowrBvzD1uzpuZL6cUvVOaDRfUfm1RgrX6waLLKgG/0bLJ/iz6PDhVLS8UPbWEdTBOf7tqVWTI4TEVC3fTruMDgsjLPq5/ro9+vtkc6TyORohIv1sxSHimLrYX1JvOqK0+7FY4xnrfVZyLdx4rNq6pLYNdJRJu17Lvif//fTZsGfB3BHZT2AqF05t75YauxoeZCwRyMCBbiNLUBtP7MS9wvqLyKoaSkBohcoCha/GisdQbMJmPFhwEm9Of7gh9dJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x8OwePzbBza8gqf5sZTqSvIWBTl+sSleeliCQwQ2aW4=;
 b=N90ncFYLDXE7epVLXaX7EihAs548Ho/tebBwIgZCBq6RMjQKH2LJd/32SZEtKrH3giSyktxCAO8Nc8fAKKE3BpgMd8J/8rzwqmhEioZJ3my9TwsHY0R17WN70jLOXs+3v5UEof10RyNmSDkV+WbL51/Qxg+U0eu0qlpbDhA+yUk=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN7PR10MB7102.namprd10.prod.outlook.com (2603:10b6:806:348::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Wed, 8 Mar
 2023 22:37:58 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:37:58 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 01/32] xfs: Add new name to attri/d
Date:   Wed,  8 Mar 2023 15:37:23 -0700
Message-Id: <20230308223754.1455051-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308223754.1455051-1-allison.henderson@oracle.com>
References: <20230308223754.1455051-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::33) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SN7PR10MB7102:EE_
X-MS-Office365-Filtering-Correlation-Id: f8b7f25c-3e67-4b6d-9dbe-08db2025c47a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TeSYGZjiifn6ChC7CNLbm5QeV42uxG8qex5RtbehCZYqkxAL+gMi3vpdzEIssrg9I6Sa6Udl1v72JYUdUSpQtM7GG/uQ0nkxNY+O6/TjIBcRZRJa0Kwu3uffkE16ie/GyuczE0P0PFQRAk6JWOqUPYdZsUXrd7xEf5ErEv7wp9VrQI5sGficSCOoqqjfHGBW8st+5XXr4OCOk9oEb6cjjjRN/LlNhSqIXMLUXSGr40A6kgW76mOprT19OVf2aNoB3rbvoIKaUlbMF5Xi+V7xPxfKHj41RPpdt7eJW7d3/pTkDujGH8WHFVBkW8MZxmEtw2jYuVOVeoH+NSQgBNNadtzs/X5oYxTVrxwysBC2VORIcd/6G4e+ItCAqx9jiGyfBAUlNwl9QXsKaQh8Di2RoBSJrYxzew8n3ssAF8a+Swq+jMK98WBIgk60V6bgTSNgV6X/ksP6BzyzEGImb171f23eWtwCptnJkpjda2YR+tzQN/fKbrrB1ki3uvto6t7RZs/ie7D0Z/DWk+voVVa98lNi7f9JEPMiE+es7ajqfhU7j2HScSwRraw+8kH4K1Y0jjLLfVSAUm8oowo5ga6gaUAxuVkWXKhh2KNVduvlZJ65xa6Ok5kbJVvGxsYOHa91Q9LIEvIg/bESriyxr74BPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(366004)(346002)(136003)(396003)(451199018)(36756003)(6666004)(8936002)(6916009)(41300700001)(8676002)(66476007)(66946007)(5660300002)(66556008)(30864003)(6506007)(2906002)(38100700002)(86362001)(6486002)(1076003)(6512007)(316002)(478600001)(83380400001)(9686003)(186003)(26005)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DxaosgYfI3jJokcOu3FS/xED4ntoHc/NmEMrQ5KS9Kcja7zud2niQ+52cdS9?=
 =?us-ascii?Q?D8yOgVCAQ08kMl9c1m6PMeTkXshIKeUlDfECVr1Ug8yM9OSfET0SzYqmE8+v?=
 =?us-ascii?Q?hr2TuXe4syonFVpMM5plOS9L9CMcNhIk09VSs2okmVcHqewYWQjXpZWtptsL?=
 =?us-ascii?Q?N8CifGKZXtngV29M99ms5FTPjzhxOAdpYiKxMX1iVjfpFQe09bQcruyKQ0vc?=
 =?us-ascii?Q?Pcm3wnpljBHaodO2jcbzbZpG4aumHT7NjGFh+yr1qmW3taV3YXn3gC0dCERp?=
 =?us-ascii?Q?JURFB312/yHQG8azdArn4Z8hlbEofILSaIuhJthoMYGM1+2AG6JINtuOuiF8?=
 =?us-ascii?Q?zgUVMhak/HxLAWMlP1rFGS8c0JGIVuOEamwuMLHxNmwjomSLBmbbh5dSUC51?=
 =?us-ascii?Q?dEQD0LFScm2ZqViuqUygC4i84UfRh9exx5rTbUPinRgOjGfzzE/0F4scPqFp?=
 =?us-ascii?Q?rij2OJktg4iglaLU4+oRsxFCodHL1tl9V3/OPectjk41WO0iURXhIV4CTe1F?=
 =?us-ascii?Q?I2/hITVGYNcpcZ4QLo2u5gW9kXQqkfNgC/UOQSr/myghrx4nsLhzH1cH1Cir?=
 =?us-ascii?Q?GfqCpHoEeS90KhaG4Hsr3EXDmV7xIznucWVQEBQ0/pDdJYwGL6HfqphAlBIm?=
 =?us-ascii?Q?Eus5A2GdV2RiHqW/re4tQshMexvlXHBa4FZGSsAOerMVxR67JrtVI896kss0?=
 =?us-ascii?Q?Skp7D052h8PhiWn4pHbxNGZ7QDCiJyl8ZMQ2b3lTLQV3F1YkOP5c7xz4sVSj?=
 =?us-ascii?Q?pyx5kXI8R8V4tjXPnYMFc/RwCCNC3C+E1RRkzUzBuoJM9xE6FxzVU1BY//yB?=
 =?us-ascii?Q?N37x5dZSsRNHLTwitDSrUm8rGxzrAenxkbUbRRdlGiQBFbIqjBlzS4MK423D?=
 =?us-ascii?Q?0yIl5yF+abTcUfBMoll+/dOR9jy1qk3REPqUhtQ7lOeyyPJYsAeRwCT/iYpp?=
 =?us-ascii?Q?V+l62zC4/d0S/G+j9ikS9UOirfQ2T+XjIP6mFzcVpTWmv7NRFIVLySCqozmb?=
 =?us-ascii?Q?DCaYhwOGwp6Ok3GL9Y0PdfVE8NGzLDYzg1ISttZwYJOIpywK3UbZ+lAIEOxY?=
 =?us-ascii?Q?KQyct1+LyB3ECt7MycdrNJaxAupUCVve7h+eBObT3E/r6yzmwtN9poyhjFM9?=
 =?us-ascii?Q?KQt17NK/jwlPqZlbu/W10Aak5hje/NkQKLjwcT49g4cpJXpvT2oWLLhPlNJQ?=
 =?us-ascii?Q?bvRWw8bdjWpYn7Ax0JYSCZ++xaxtsjPV6UP5PLGBOAMFKn9LjduZ3QppXm7a?=
 =?us-ascii?Q?ob49zm750l9v4iRUPkmKH2pSFaHy6KUcF+ccPziruEfqQhFbtA9qVYLk5SfX?=
 =?us-ascii?Q?SQDEwmIaQStRUvczhWDHJV+98S3ZTGQyPAzrMsDJdvAaRxcuYL7viUfQnR4R?=
 =?us-ascii?Q?cd3A/63+ga+rLgU2VmheYaqXa6pZ/feIIGaNlFiI39swjbyAgc9SxyiiX/mt?=
 =?us-ascii?Q?WJPym1dgaLbTnUtY7kwFsnQKQm8u6kKNM1h43zIwlxVHgvCkOfTo88UBMF/Q?=
 =?us-ascii?Q?J/wFoyTHMMw0NJDf6/+PIdm4hju9P3tDFjLlA39QsQu866YLy6wiZduR1XNt?=
 =?us-ascii?Q?jZX3gTq+ovoI35ZXRlyprxs9LKglv9VgR2ejrPvQmxBMOsTHXKY6SkSGHeL6?=
 =?us-ascii?Q?cg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: nzCt95OTCnla0OAvYKCHEAeuswe0sGTAZ7cHk+selrbHE/cqsMfl/R4wIsj/DB5C7fMHOEXNY2mTOtFO4VjuAK1qtLLpCdtR467Db/CCHq5TjydNB1NCjjpVhZDaCbxP3SVce38XMMummgJZnQ2GyBNa7okhRmRTFASoprsfiYmIJ9TOuUFyYsNpJJxt/Mh0jBs9pg5v1HTD6Ish9z887S5b3BSLSeu06dCaw3vN8xfGxg9fumAnul6n3/o0CQWPvGJhxPjCTqXefzXBFgSLQSJ+dhgY0usSVirnAn630rFJujPIeMVhnKVeD7CxoTQTsXHsQAIf8RnbBFV210iQI7qhzqfWUDSXfT+OuO9vBYD6NeUtrbOypFTefdDeJFY/3r+KKMjRRfAo/2IwQr2ohr1mnKfj3nRb6v7PqkBA1itHbbiAK5mjKMcyz/oHtKYlmmDbmwFADyuLXdj+Z73bBwcDazsyi0Obpa29W3qpOHtuhreSu8v01oWYqMQDJGThzfe1iQKCVDfqtC/vPrZ/7JdOrFddZN7gz/zFdNCGw4SSGiY4IdHvukkckXde/rQF8de0bKU9oOpYk0QYUab94bXmTbFu34+yjt0s3e1GO9ZuJ7xTUCgeSI79m31Wa81VsUt6yglr2GQWeAjNcuSiK1zgVOE8d5VCGOLlqgeXS2TyKUC+PaEGKgT7TTU8GyNlsRFEcDZPpRTRvvq92s9A2/l/H0ePPvG24fKCaH2KrQ8ZzWTMfmbWyQTtBzse174HFi+UFyp6bFOmOX+md7bEOw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8b7f25c-3e67-4b6d-9dbe-08db2025c47a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:37:58.8118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 567DItcb35y/U2Vm566EcjaHUP/GYv7Jj9F4eYnn6HtuX1VqXW7ApOacse7Gd+XU2ik8TE3tS6T9rIWAl8hq3JFsUbaXrY0K/sZreHrB6ZI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7102
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303080190
X-Proofpoint-ORIG-GUID: sIPoX0P7KpSVYek-MNvgu7e4ng5-cw16
X-Proofpoint-GUID: sIPoX0P7KpSVYek-MNvgu7e4ng5-cw16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds two new fields to the atti/d.  They are nname and
nnamelen.  This will be used for parent pointer updates since a
rename operation may cause the parent pointer to update both the
name and value.  So we need to carry both the new name as well as
the target name in the attri/d.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c       |  12 ++-
 fs/xfs/libxfs/xfs_attr.h       |   4 +-
 fs/xfs/libxfs/xfs_da_btree.h   |   2 +
 fs/xfs/libxfs/xfs_log_format.h |   6 +-
 fs/xfs/xfs_attr_item.c         | 135 +++++++++++++++++++++++++++------
 fs/xfs/xfs_attr_item.h         |   1 +
 6 files changed, 133 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e28d93d232de..b1dbed7655e8 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -423,6 +423,12 @@ xfs_attr_complete_op(
 	args->op_flags &= ~XFS_DA_OP_REPLACE;
 	if (do_replace) {
 		args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+		if (args->new_namelen > 0) {
+			args->name = args->new_name;
+			args->namelen = args->new_namelen;
+			args->hashval = xfs_da_hashname(args->name,
+							args->namelen);
+		}
 		return replace_state;
 	}
 	return XFS_DAS_DONE;
@@ -922,9 +928,13 @@ xfs_attr_defer_replace(
 	struct xfs_da_args	*args)
 {
 	struct xfs_attr_intent	*new;
+	int			op_flag;
 	int			error = 0;
 
-	error = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_REPLACE, &new);
+	op_flag = args->new_namelen == 0 ? XFS_ATTRI_OP_FLAGS_REPLACE :
+		  XFS_ATTRI_OP_FLAGS_NVREPLACE;
+
+	error = xfs_attr_intent_init(args, op_flag, &new);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 81be9b3e4004..3e81f3f48560 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -510,8 +510,8 @@ struct xfs_attr_intent {
 	struct xfs_da_args		*xattri_da_args;
 
 	/*
-	 * Shared buffer containing the attr name and value so that the logging
-	 * code can share large memory buffers between log items.
+	 * Shared buffer containing the attr name, new name, and value so that
+	 * the logging code can share large memory buffers between log items.
 	 */
 	struct xfs_attri_log_nameval	*xattri_nameval;
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index ffa3df5b2893..a4b29827603f 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -55,7 +55,9 @@ enum xfs_dacmp {
 typedef struct xfs_da_args {
 	struct xfs_da_geometry *geo;	/* da block geometry */
 	const uint8_t		*name;		/* string (maybe not NULL terminated) */
+	const uint8_t	*new_name;	/* new attr name */
 	int		namelen;	/* length of string (maybe no NULL) */
+	int		new_namelen;	/* new attr name len */
 	uint8_t		filetype;	/* filetype of inode for directories */
 	void		*value;		/* set of bytes (maybe contain NULLs) */
 	int		valuelen;	/* length of value */
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index f13e0809dc63..ae9c99762a24 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -117,7 +117,8 @@ struct xfs_unmount_log_format {
 #define XLOG_REG_TYPE_ATTRD_FORMAT	28
 #define XLOG_REG_TYPE_ATTR_NAME	29
 #define XLOG_REG_TYPE_ATTR_VALUE	30
-#define XLOG_REG_TYPE_MAX		30
+#define XLOG_REG_TYPE_ATTR_NNAME	31
+#define XLOG_REG_TYPE_MAX		31
 
 
 /*
@@ -957,6 +958,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_SET		1	/* Set the attribute */
 #define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
+#define XFS_ATTRI_OP_FLAGS_NVREPLACE	4	/* Replace attr name and val */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*
@@ -974,7 +976,7 @@ struct xfs_icreate_log {
 struct xfs_attri_log_format {
 	uint16_t	alfi_type;	/* attri log item type */
 	uint16_t	alfi_size;	/* size of this item */
-	uint32_t	__pad;		/* pad to 64 bit aligned */
+	uint32_t	alfi_nname_len;	/* attr new name length */
 	uint64_t	alfi_id;	/* attri identifier */
 	uint64_t	alfi_ino;	/* the inode for this attr operation */
 	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 2788a6f2edcd..95e9ecbb4a67 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -75,6 +75,8 @@ static inline struct xfs_attri_log_nameval *
 xfs_attri_log_nameval_alloc(
 	const void			*name,
 	unsigned int			name_len,
+	const void			*nname,
+	unsigned int			nname_len,
 	const void			*value,
 	unsigned int			value_len)
 {
@@ -85,15 +87,25 @@ xfs_attri_log_nameval_alloc(
 	 * this. But kvmalloc() utterly sucks, so we use our own version.
 	 */
 	nv = xlog_kvmalloc(sizeof(struct xfs_attri_log_nameval) +
-					name_len + value_len);
+					name_len + nname_len + value_len);
 
 	nv->name.i_addr = nv + 1;
 	nv->name.i_len = name_len;
 	nv->name.i_type = XLOG_REG_TYPE_ATTR_NAME;
 	memcpy(nv->name.i_addr, name, name_len);
 
+	if (nname_len) {
+		nv->nname.i_addr = nv->name.i_addr + name_len;
+		nv->nname.i_len = nname_len;
+		memcpy(nv->nname.i_addr, nname, nname_len);
+	} else {
+		nv->nname.i_addr = NULL;
+		nv->nname.i_len = 0;
+	}
+	nv->nname.i_type = XLOG_REG_TYPE_ATTR_NNAME;
+
 	if (value_len) {
-		nv->value.i_addr = nv->name.i_addr + name_len;
+		nv->value.i_addr = nv->name.i_addr + nname_len + name_len;
 		nv->value.i_len = value_len;
 		memcpy(nv->value.i_addr, value, value_len);
 	} else {
@@ -147,11 +159,15 @@ xfs_attri_item_size(
 	*nbytes += sizeof(struct xfs_attri_log_format) +
 			xlog_calc_iovec_len(nv->name.i_len);
 
-	if (!nv->value.i_len)
-		return;
+	if (nv->nname.i_len) {
+		*nvecs += 1;
+		*nbytes += xlog_calc_iovec_len(nv->nname.i_len);
+	}
 
-	*nvecs += 1;
-	*nbytes += xlog_calc_iovec_len(nv->value.i_len);
+	if (nv->value.i_len) {
+		*nvecs += 1;
+		*nbytes += xlog_calc_iovec_len(nv->value.i_len);
+	}
 }
 
 /*
@@ -181,6 +197,9 @@ xfs_attri_item_format(
 	ASSERT(nv->name.i_len > 0);
 	attrip->attri_format.alfi_size++;
 
+	if (nv->nname.i_len > 0)
+		attrip->attri_format.alfi_size++;
+
 	if (nv->value.i_len > 0)
 		attrip->attri_format.alfi_size++;
 
@@ -188,6 +207,10 @@ xfs_attri_item_format(
 			&attrip->attri_format,
 			sizeof(struct xfs_attri_log_format));
 	xlog_copy_from_iovec(lv, &vecp, &nv->name);
+
+	if (nv->nname.i_len > 0)
+		xlog_copy_from_iovec(lv, &vecp, &nv->nname);
+
 	if (nv->value.i_len > 0)
 		xlog_copy_from_iovec(lv, &vecp, &nv->value);
 }
@@ -374,6 +397,7 @@ xfs_attr_log_item(
 	attrp->alfi_op_flags = attr->xattri_op_flags;
 	attrp->alfi_value_len = attr->xattri_nameval->value.i_len;
 	attrp->alfi_name_len = attr->xattri_nameval->name.i_len;
+	attrp->alfi_nname_len = attr->xattri_nameval->nname.i_len;
 	ASSERT(!(attr->xattri_da_args->attr_filter & ~XFS_ATTRI_FILTER_MASK));
 	attrp->alfi_attr_filter = attr->xattri_da_args->attr_filter;
 }
@@ -415,7 +439,8 @@ xfs_attr_create_intent(
 		 * deferred work state structure.
 		 */
 		attr->xattri_nameval = xfs_attri_log_nameval_alloc(args->name,
-				args->namelen, args->value, args->valuelen);
+				args->namelen, args->new_name,
+				args->new_namelen, args->value, args->valuelen);
 	}
 
 	attrip = xfs_attri_init(mp, attr->xattri_nameval);
@@ -503,7 +528,8 @@ xfs_attri_validate(
 	unsigned int			op = attrp->alfi_op_flags &
 					     XFS_ATTRI_OP_FLAGS_TYPE_MASK;
 
-	if (attrp->__pad != 0)
+	if (attrp->alfi_op_flags != XFS_ATTRI_OP_FLAGS_NVREPLACE &&
+	    attrp->alfi_nname_len != 0)
 		return false;
 
 	if (attrp->alfi_op_flags & ~XFS_ATTRI_OP_FLAGS_TYPE_MASK)
@@ -517,6 +543,7 @@ xfs_attri_validate(
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 		break;
 	default:
 		return false;
@@ -526,9 +553,14 @@ xfs_attri_validate(
 		return false;
 
 	if ((attrp->alfi_name_len > XATTR_NAME_MAX) ||
+	    (attrp->alfi_nname_len > XATTR_NAME_MAX) ||
 	    (attrp->alfi_name_len == 0))
 		return false;
 
+	if (op == XFS_ATTRI_OP_FLAGS_REMOVE &&
+	    attrp->alfi_value_len != 0)
+		return false;
+
 	return xfs_verify_ino(mp, attrp->alfi_ino);
 }
 
@@ -589,6 +621,8 @@ xfs_attri_item_recover(
 	args->whichfork = XFS_ATTR_FORK;
 	args->name = nv->name.i_addr;
 	args->namelen = nv->name.i_len;
+	args->new_name = nv->nname.i_addr;
+	args->new_namelen = nv->nname.i_len;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
 	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
@@ -599,6 +633,7 @@ xfs_attri_item_recover(
 	switch (attr->xattri_op_flags) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 		args->value = nv->value.i_addr;
 		args->valuelen = nv->value.i_len;
 		args->total = xfs_attr_calc_size(args, &local);
@@ -688,6 +723,7 @@ xfs_attri_item_relog(
 	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
 	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
 	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
+	new_attrp->alfi_nname_len = old_attrp->alfi_nname_len;
 	new_attrp->alfi_attr_filter = old_attrp->alfi_attr_filter;
 
 	xfs_trans_add_item(tp, &new_attrip->attri_item);
@@ -710,48 +746,102 @@ xlog_recover_attri_commit_pass2(
 	const void			*attr_value = NULL;
 	const void			*attr_name;
 	size_t				len;
-
-	attri_formatp = item->ri_buf[0].i_addr;
-	attr_name = item->ri_buf[1].i_addr;
+	const void			*attr_nname = NULL;
+	int				op, i = 0;
 
 	/* Validate xfs_attri_log_format before the large memory allocation */
 	len = sizeof(struct xfs_attri_log_format);
-	if (item->ri_buf[0].i_len != len) {
+	if (item->ri_buf[i].i_len != len) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				item->ri_buf[i].i_addr, item->ri_buf[i].i_len);
 		return -EFSCORRUPTED;
 	}
 
+	attri_formatp = item->ri_buf[i].i_addr;
 	if (!xfs_attri_validate(mp, attri_formatp)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				item->ri_buf[i].i_addr, item->ri_buf[i].i_len);
+		return -EFSCORRUPTED;
+	}
+
+	op = attri_formatp->alfi_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_SET:
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		if (item->ri_total != 3) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		if (item->ri_total != 2) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
+		if (item->ri_total != 4) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
+	default:
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				     attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
 
+	i++;
 	/* Validate the attr name */
-	if (item->ri_buf[1].i_len !=
+	if (item->ri_buf[i].i_len !=
 			xlog_calc_iovec_len(attri_formatp->alfi_name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
 
+	attr_name = item->ri_buf[i].i_addr;
 	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[1].i_addr, item->ri_buf[1].i_len);
+				item->ri_buf[i].i_addr, item->ri_buf[i].i_len);
 		return -EFSCORRUPTED;
 	}
 
+	i++;
+	if (attri_formatp->alfi_nname_len) {
+		/* Validate the attr nname */
+		if (item->ri_buf[i].i_len !=
+		    xlog_calc_iovec_len(attri_formatp->alfi_nname_len)) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					item->ri_buf[i].i_addr,
+					item->ri_buf[i].i_len);
+			return -EFSCORRUPTED;
+		}
+
+		attr_nname = item->ri_buf[i].i_addr;
+		if (!xfs_attr_namecheck(attr_nname,
+				attri_formatp->alfi_nname_len)) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					item->ri_buf[i].i_addr,
+					item->ri_buf[i].i_len);
+			return -EFSCORRUPTED;
+		}
+		i++;
+	}
+
+
 	/* Validate the attr value, if present */
 	if (attri_formatp->alfi_value_len != 0) {
-		if (item->ri_buf[2].i_len != xlog_calc_iovec_len(attri_formatp->alfi_value_len)) {
+		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(attri_formatp->alfi_value_len)) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-					item->ri_buf[0].i_addr,
-					item->ri_buf[0].i_len);
+					attri_formatp, len);
 			return -EFSCORRUPTED;
 		}
 
-		attr_value = item->ri_buf[2].i_addr;
+		attr_value = item->ri_buf[i].i_addr;
 	}
 
 	/*
@@ -760,7 +850,8 @@ xlog_recover_attri_commit_pass2(
 	 * reference.
 	 */
 	nv = xfs_attri_log_nameval_alloc(attr_name,
-			attri_formatp->alfi_name_len, attr_value,
+			attri_formatp->alfi_name_len, attr_nname,
+			attri_formatp->alfi_nname_len, attr_value,
 			attri_formatp->alfi_value_len);
 
 	attrip = xfs_attri_init(mp, nv);
diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
index 3280a7930287..24d4968dd6cc 100644
--- a/fs/xfs/xfs_attr_item.h
+++ b/fs/xfs/xfs_attr_item.h
@@ -13,6 +13,7 @@ struct kmem_zone;
 
 struct xfs_attri_log_nameval {
 	struct xfs_log_iovec	name;
+	struct xfs_log_iovec	nname;
 	struct xfs_log_iovec	value;
 	refcount_t		refcount;
 
-- 
2.25.1

