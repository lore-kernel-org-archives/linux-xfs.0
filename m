Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2032ECAAA1
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Aug 2022 18:06:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiH3SGI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Aug 2022 14:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbiH3SGH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Aug 2022 14:06:07 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F40BB1E
        for <linux-xfs@vger.kernel.org>; Tue, 30 Aug 2022 11:06:05 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27UHtM7L032435
        for <linux-xfs@vger.kernel.org>; Tue, 30 Aug 2022 18:06:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=ra9ivP7+Hzt9CLXdjQnTgZJbVcAY0ay1DvoudSG2rV0=;
 b=Gn/TUPXJmu/jR+8Ts0vbBr8HTH493zDWN9U52YrTlVzW5j/AUUzUA87ZdhwPDxOOBF7/
 Lf2CVmhJbv9sJQ7iFYjJretTMkUiD9+O/8i0n8McvAGUXLkMmoRn5Ru0kDac6RGIYc9z
 kfYFxwywshkCOzOLuzOzn/pSvvkzyEq41jYf4xapZaXSsBVc9U2fzd3suJHHbwjtAlsQ
 xsUJ/Py0jgzglTWakCUPa1Ojh7TyT/lc+Gl6pM+/m9qCils1f7Nip62o12vbWFK3In4v
 rE2d+QMGkBFOzPl590EV8clEkSpbqAxGG/qN5UaNLc9f0T10oMeMilNw/HZ69optqoxJ 9A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j7a2275fa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Aug 2022 18:06:04 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27UI5moJ035237
        for <linux-xfs@vger.kernel.org>; Tue, 30 Aug 2022 18:06:03 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3j79qagdnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Aug 2022 18:06:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DndsBYMvfbSY9Lri8Jl/hC5Wlh66PsghnARVv9vd4CREivdLusQzKG3GQ9/dAo+6Jd4/ZykOpxa/n1dvyoogKQTwu7aWoXOAMWqPk8vj8ri8J+cZxwnJ2Gy9MQvHRkdjVLAGXblcyGFiXi7Icvfnoy8J3piTrwtEAkiN/QoseWw7AKrZYJ5Pz+zG8k+IwUgXa2Wi1BoT6Rzq36ONloQYpBC7SGL2IO2vThSecKvhv1S1NROd57voqRk06Wo7EnilRtUCk9LjmDAF8LNBiFTOHjpK/eKOsTErHzwyXK/RN6Rle7tPgtbTsuH+NULDYayafvQwYNKRdmLgqj6+C7Ni6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ra9ivP7+Hzt9CLXdjQnTgZJbVcAY0ay1DvoudSG2rV0=;
 b=be4l9VDmTw6BLt5Ji5AlTk+D3AjV7PmH2Bd6najMnDmb1VlSJ8XNmbrrBpTpUTsrZO8RQiZSEfIy9O3LsGIrDAUsoCAc+cuvj9wFm+TuiwVjYD//pze3cdD9V6x4K2uOPew7h/Pc16aOksh8siC4VpIozoUw4tD5UAyCtrULo3yvxbHamCrbMF+qpHVpwB2Q1FzpYFJRiZYsEoavzEYE0GcxHDsTmN1sKCnJqauvSkP9dm+NLznI7C8l0WXBw1XQhAyZ6Ve6/SDa36h42+lwBM1VF2M1BzeYJm/UjntyH4VurL0pS4vlpt0QPiCeHOFBaqfu+JtBZxhj1AmYtSqw8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ra9ivP7+Hzt9CLXdjQnTgZJbVcAY0ay1DvoudSG2rV0=;
 b=VCqzoBOYjaq/XjWfq1Kxu4kSK6Ii+rqQBzUPIJAz3oY6WUtJ0bMZNpa/1uXyWZGX5w8FvZzMlDg6ls0p1SWOKnHPUExKOqcdeI010ji29IN/NM7GyOVHPC/t0skyAsQIkh6KG9NU9v7oC2qBE29M3nn9wnSZ8Nz5YsaG8bYqRvU=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BLAPR10MB4881.namprd10.prod.outlook.com (2603:10b6:208:327::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Tue, 30 Aug
 2022 18:06:00 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 18:06:00 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3] xfs: Add new name to attri/d
Date:   Tue, 30 Aug 2022 11:05:54 -0700
Message-Id: <20220830180554.1416087-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0184.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::9) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: caf8a71d-24bd-461c-02cd-08da8ab24b94
X-MS-TrafficTypeDiagnostic: BLAPR10MB4881:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LqIR6R7MG2OuQwGyXcem0G6126BhE3j6ke8OwElMaM4eGaTesv0PhNpdx1LndjLUIdcSTC8vyZZ4DwVKhNUpt4aWcTv5JmFdA01yvooZSrib6GBYOMoi/ppjNTb1q/tBN5tk7ab6Z2pHJNgOKR8HrpZkBbOiE+I+/0woxGLmKG6LCiKLpmUb1eKistugfPCScEY/qEv0OdnoveyG5X/lbxmnlPsLQlt4hu0nWlwfl+6/SJqJnjFbz6RLDxWpJLOr8osum4on9FdMNoTFJ90fnLwPHNtdG46Wpjdj0IfSw/3p/K+/FG0EOflMpk7ddLlHTXKTRrlrGrzBC8q5c3Ll+p9oF6oOS0lIEkjke8Z7/CsDwlrCtaALEuNSYlMUNYWerz2zR/bVzivmigbTZFQgc4k7UKupeHo4WAjkJaj5eUsM2rUeXK8XP46vVO9XVct8KGiycP8Buk9hcRPmB4JKq/9olLcFG6sUsP3XSCzHc/flsKBnPHvdZ5PGTtQ4hBW/045gmbhpVL5iatM6YClY7KddFofmJWTOjQVTORzZBLcNQl/CxPtUYNsAUhfkb0fIAGE5W3VbAxpFMw5oPvQLvKP5nk7VbdEgc23HhcIkysAtJfA+qNhB4i9dlYpEGa1Udl1949n1FN9pddtig30S/d0St83dmrC9OPbRZQC6zyfow6wSIFA5ssJhpEr/prefUTBHqg78x/PswvNBa8cdkhjlKUl6QqV4Rb4j3zt3x1HXxRn/KM3C83J1k8UM/Aq9UrXyEEhX6CvdGfds2z50KQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(136003)(366004)(39860400002)(346002)(186003)(8936002)(5660300002)(41300700001)(6486002)(86362001)(478600001)(1076003)(6666004)(2906002)(6506007)(52116002)(83380400001)(2616005)(26005)(66476007)(8676002)(38100700002)(6512007)(316002)(66556008)(36756003)(44832011)(30864003)(6916009)(38350700002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZzWGlX4DX/LCTwSvxcDUMek4H6H/k7489nMUxgswBq9530cm5LdYZWQqPt+H?=
 =?us-ascii?Q?Q7ZQ2sltBDiNmxjJKJWxbdF/rw0DTTDnmdAs/MbYsoGqU/reIrlK8C5m3Wcb?=
 =?us-ascii?Q?rz6xrBAjXiKFhaz+sf9wB8QoyawHWT71owGp3CESqGk2xMIUUUtPUUnTdjoZ?=
 =?us-ascii?Q?4IH8b1jv7YjQLAl3DDp3JylbhmRf+sszqR4iO2Q/6o+nm9el9GdLeuqhlVqs?=
 =?us-ascii?Q?Ur8FS0q+zXHPyA5IPoKwqovrt6iGFSLEOd2l9CgKZcIej0zzLQ//HlswhUUV?=
 =?us-ascii?Q?UOmveihsuOusL/b9VYdU11a0v9fc0Ipnfl9dhO5gJ9nwNbUmgegG5RPNxUrg?=
 =?us-ascii?Q?7c23hu+aR8OGG68mL4iyvSUJw/dh/VvjiqbgSgjfpSqip64IjB7vp1GWJcOB?=
 =?us-ascii?Q?3Je+UoqwphidtyYpeOdAS1FRV5vxnd64HhtY0FxFCSnLXG6IKXmPJRprazAG?=
 =?us-ascii?Q?vggMe9WuVDcfGrWbIBholMf+hQ7YIcVkhPXjwnjmz2t4lz5p2SVYgAULWhf/?=
 =?us-ascii?Q?WSGB7VSxHh9Ngu10v2V62SsJEEilGWDBS11UVpM/UOBEF7zEsQR/ndM7x1KO?=
 =?us-ascii?Q?22d6hTeFfrvZlfLeEQltIHCOY/BAQNa2YjCvGbKyxIx2cbtIMUyQwZJ2ff0L?=
 =?us-ascii?Q?GPSE3u3hP9ESqJj0xNysjMBpFq5T6Hlplq9AzlyFXGBR4ouhx8I3d5n7qZtR?=
 =?us-ascii?Q?4yyu6nzL5jcw4RucFMLh6FSTw+NUXv5rqKy6tdNUyPV43znlKzRCk6Ov0LLM?=
 =?us-ascii?Q?7kjXhNqXHbV8nRQ7vfQ3UVnck+nYvmiYNikmVCLOPAYKYfSKc27N8Q/RAvrR?=
 =?us-ascii?Q?kqYLVGgfn30p4x9StWGk0xckcmIbwddobu98/vcWANv4Odg3w9Z/EJeumBLX?=
 =?us-ascii?Q?2RGeW8MrVIUJHt0hjGqpVC5negil7HmiBnhzpDrVCSKHK7qEJ8p6W0uLo+6L?=
 =?us-ascii?Q?/Df+B2KrG0G+LEIgF2fxHUmYMWNJwhaTcrTjPedocXWghV2PYq00O8m+O49g?=
 =?us-ascii?Q?GNt0dEa+gUKkPnXdvnKpgK9yl1o7jRbHf9eZxAo1s727l2LQhmaD87W/3Djy?=
 =?us-ascii?Q?T1XUBd3F2WOK5iPiagoImPTBaKBlvhsNDZpKN9rSDMZsn86WR/klZbtBLo7v?=
 =?us-ascii?Q?+WgDNvDOxTyuhEHSHnlPLZ8025jpFNrcR9Sl6HkP4h7xAI2f2kYWA3vS7gRp?=
 =?us-ascii?Q?iwOZjBnfCfUk2AdpU8aZZc5bJQku2OsnrH1aqR4LFdpgQXHJ6fsy9RGaoKT+?=
 =?us-ascii?Q?0Qjepno1mC4lY5F+nxFJXEXHJzEe6rtaDzkv1Y8eFxAuykvIjOpmhZngIfM/?=
 =?us-ascii?Q?h5EgmLaeOpdFPjzMn2j+crqHSHxUuhuCcc1csF8/p19kC6odV0jTW7CtRPCG?=
 =?us-ascii?Q?Pm01wPgVXUjhidEfpEJLeL+Pgd1XPnqeEzPHMesBGtQ2/zC/DAwSIKqNuGvF?=
 =?us-ascii?Q?Xi5Hm6M0dsaeZZ4m4dH0JWcb8W/QX2qu7MYroehT6BZeI1KwG6Bn91pHUgEi?=
 =?us-ascii?Q?/XQ49qirl3eN6auXX+HomlRkm0WNFiKOO6UfCAHdKx2yhnifx/dt5YwmcOqK?=
 =?us-ascii?Q?ak+Tk3Lompxj18FBgwPWOBU5jRoR9WA2rfo1n0y9t9sXA6D5VcKXw3rjmvYy?=
 =?us-ascii?Q?2Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caf8a71d-24bd-461c-02cd-08da8ab24b94
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 18:06:00.4555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mz15hb0yDnJHHcvb6YZSkdunq4Pgve9Q0T70l4po00S2v28TmHqo2e/3pYii/EsFoYNMxTuz3LUD3tMvBQ73tQ7WCeEo10D46rhv7jqwh5E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4881
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-30_10,2022-08-30_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208300083
X-Proofpoint-GUID: Kq4OGYVEuujYyGDedVHisUejR_IMjphw
X-Proofpoint-ORIG-GUID: Kq4OGYVEuujYyGDedVHisUejR_IMjphw
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds two new fields to the atti/d.  They are nname and
nnamelen.  This will be used for parent pointer updates since a
rename operation may cause the parent pointer to update both the
name and value.  So we need to carry both the new name as well as
the target name in the attri/d.

updates since v1:
Renamed XFS_ATTRI_OP_FLAGS_NREPLACE to XFS_ATTRI_OP_FLAGS_NVREPLACE
Rearranged new xfs_da_args fields to group same sized fields together
New alfi_nname_len field now displaces the __pad field
Added extra validation checks to xfs_attri_validate
  and xlog_recover_attri_commit_pass2
Moved namecheck updates to parent pointer set

Feedback appreciated.  Thanks all!

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c       |  12 +++-
 fs/xfs/libxfs/xfs_attr.h       |   4 +-
 fs/xfs/libxfs/xfs_da_btree.h   |   2 +
 fs/xfs/libxfs/xfs_log_format.h |   6 +-
 fs/xfs/xfs_attr_item.c         | 108 ++++++++++++++++++++++++++++-----
 fs/xfs/xfs_attr_item.h         |   1 +
 6 files changed, 113 insertions(+), 20 deletions(-)

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
index b351b9dc6561..62f40e6353c2 100644
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
@@ -909,6 +910,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_SET		1	/* Set the attribute */
 #define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
+#define XFS_ATTRI_OP_FLAGS_NVREPLACE	4	/* Replace attr name and val */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*
@@ -926,7 +928,7 @@ struct xfs_icreate_log {
 struct xfs_attri_log_format {
 	uint16_t	alfi_type;	/* attri log item type */
 	uint16_t	alfi_size;	/* size of this item */
-	uint32_t	__pad;		/* pad to 64 bit aligned */
+	uint32_t	alfi_nname_len;	/* attr new name length */
 	uint64_t	alfi_id;	/* attri identifier */
 	uint64_t	alfi_ino;	/* the inode for this attr operation */
 	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 5077a7ad5646..b1a0ca9f9d17 100644
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
@@ -85,7 +87,7 @@ xfs_attri_log_nameval_alloc(
 	 * this. But kvmalloc() utterly sucks, so we use our own version.
 	 */
 	nv = xlog_kvmalloc(sizeof(struct xfs_attri_log_nameval) +
-					name_len + value_len);
+					name_len + nname_len + value_len);
 	if (!nv)
 		return nv;
 
@@ -94,8 +96,18 @@ xfs_attri_log_nameval_alloc(
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
@@ -149,11 +161,15 @@ xfs_attri_item_size(
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
@@ -183,6 +199,9 @@ xfs_attri_item_format(
 	ASSERT(nv->name.i_len > 0);
 	attrip->attri_format.alfi_size++;
 
+	if (nv->nname.i_len > 0)
+		attrip->attri_format.alfi_size++;
+
 	if (nv->value.i_len > 0)
 		attrip->attri_format.alfi_size++;
 
@@ -190,6 +209,10 @@ xfs_attri_item_format(
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
@@ -398,6 +421,7 @@ xfs_attr_log_item(
 	attrp->alfi_op_flags = attr->xattri_op_flags;
 	attrp->alfi_value_len = attr->xattri_nameval->value.i_len;
 	attrp->alfi_name_len = attr->xattri_nameval->name.i_len;
+	attrp->alfi_nname_len = attr->xattri_nameval->nname.i_len;
 	ASSERT(!(attr->xattri_da_args->attr_filter & ~XFS_ATTRI_FILTER_MASK));
 	attrp->alfi_attr_filter = attr->xattri_da_args->attr_filter;
 }
@@ -439,7 +463,8 @@ xfs_attr_create_intent(
 		 * deferred work state structure.
 		 */
 		attr->xattri_nameval = xfs_attri_log_nameval_alloc(args->name,
-				args->namelen, args->value, args->valuelen);
+				args->namelen, args->new_name,
+				args->new_namelen, args->value, args->valuelen);
 	}
 	if (!attr->xattri_nameval)
 		return ERR_PTR(-ENOMEM);
@@ -529,9 +554,6 @@ xfs_attri_validate(
 	unsigned int			op = attrp->alfi_op_flags &
 					     XFS_ATTRI_OP_FLAGS_TYPE_MASK;
 
-	if (attrp->__pad != 0)
-		return false;
-
 	if (attrp->alfi_op_flags & ~XFS_ATTRI_OP_FLAGS_TYPE_MASK)
 		return false;
 
@@ -543,6 +565,7 @@ xfs_attri_validate(
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 		break;
 	default:
 		return false;
@@ -552,9 +575,14 @@ xfs_attri_validate(
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
 
@@ -615,6 +643,8 @@ xfs_attri_item_recover(
 	args->whichfork = XFS_ATTR_FORK;
 	args->name = nv->name.i_addr;
 	args->namelen = nv->name.i_len;
+	args->new_name = nv->nname.i_addr;
+	args->new_namelen = nv->nname.i_len;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
 	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
@@ -625,6 +655,7 @@ xfs_attri_item_recover(
 	switch (attr->xattri_op_flags) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 		args->value = nv->value.i_addr;
 		args->valuelen = nv->value.i_len;
 		args->total = xfs_attr_calc_size(args, &local);
@@ -714,6 +745,7 @@ xfs_attri_item_relog(
 	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
 	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
 	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
+	new_attrp->alfi_nname_len = old_attrp->alfi_nname_len;
 	new_attrp->alfi_attr_filter = old_attrp->alfi_attr_filter;
 
 	xfs_trans_add_item(tp, &new_attrip->attri_item);
@@ -735,10 +767,41 @@ xlog_recover_attri_commit_pass2(
 	struct xfs_attri_log_nameval	*nv;
 	const void			*attr_value = NULL;
 	const void			*attr_name;
-	int                             error;
+	const void			*attr_nname = NULL;
+	int				i = 0;
+	int                             op, error = 0;
 
-	attri_formatp = item->ri_buf[0].i_addr;
-	attr_name = item->ri_buf[1].i_addr;
+	if (item->ri_total == 0) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+		return -EFSCORRUPTED;
+	}
+
+	attri_formatp = item->ri_buf[i].i_addr;
+	i++;
+
+	op = attri_formatp->alfi_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_SET:
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		if (item->ri_total != 3)
+			error = -EFSCORRUPTED;
+		break;
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		if (item->ri_total != 2)
+			error = -EFSCORRUPTED;
+		break;
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
+		if (item->ri_total != 4)
+			error = -EFSCORRUPTED;
+		break;
+	default:
+		error = -EFSCORRUPTED;
+	}
+
+	if (error) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+		return error;
+	}
 
 	/* Validate xfs_attri_log_format before the large memory allocation */
 	if (!xfs_attri_validate(mp, attri_formatp)) {
@@ -746,13 +809,27 @@ xlog_recover_attri_commit_pass2(
 		return -EFSCORRUPTED;
 	}
 
+	attr_name = item->ri_buf[i].i_addr;
+	i++;
+
 	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 		return -EFSCORRUPTED;
 	}
 
+	if (attri_formatp->alfi_nname_len) {
+		attr_nname = item->ri_buf[i].i_addr;
+		i++;
+
+		if (!xfs_attr_namecheck(attr_nname,
+				attri_formatp->alfi_nname_len)) {
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+			return -EFSCORRUPTED;
+		}
+	}
+
 	if (attri_formatp->alfi_value_len)
-		attr_value = item->ri_buf[2].i_addr;
+		attr_value = item->ri_buf[i].i_addr;
 
 	/*
 	 * Memory alloc failure will cause replay to abort.  We attach the
@@ -760,7 +837,8 @@ xlog_recover_attri_commit_pass2(
 	 * reference.
 	 */
 	nv = xfs_attri_log_nameval_alloc(attr_name,
-			attri_formatp->alfi_name_len, attr_value,
+			attri_formatp->alfi_name_len, attr_nname,
+			attri_formatp->alfi_nname_len, attr_value,
 			attri_formatp->alfi_value_len);
 	if (!nv)
 		return -ENOMEM;
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

