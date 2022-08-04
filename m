Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4A4DC19F21
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 19:40:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234628AbiHDTkk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 15:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239229AbiHDTkc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 15:40:32 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E1BBC00
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 12:40:30 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 274HbVdI001427
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=ZOMCi0kif4HgweEAl9oe4JTtLWQrwgjrJVBb62jZI/8=;
 b=0RGouTU9BlIdQDtUVF79rhU2cuGJ5cosM2AAEKjOgE6OcnzrduVBmKpw8+NSJHJ4/Kxh
 2UCVwIYjrtcKYxT0lFHI7QxIMzgl/e9iHFClVSuZ+cfmForOCvGkLzfZIBsw0Zti6lcV
 i7x/7AR87I3HWOJEo3etMwuu9YXTHkn8UB/FMhBmJW5/ge8Q8Qw+Mp9pQ0lM1K/uBONp
 eap1JOHcdMIMomoDUxPvgGfiN+GrGVj9V3vLR5KkNpC5siNF7+bjPsQDpET7IHU9cixb
 jxyo1mg8bqqRWgHvLskpqOSfrOrtX7MI9drk40aN3AAcGWkofSF8Y6wCgq5bwNYiBKmp 2w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmue2x31m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:29 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 274JO4XF014188
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:28 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu34p7ev-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SOgXpxllsF+ZnVceCJP42wpzwsQwlkb9kEC0dwWLsmacyB0RHb7KzV93+3JBGWyvZqcJRXueFNopi3956A5roPHOWZR6u7ZrdIDMoN7x0JNWvIJryZqwlXXuSWDzzmZsPkzcaXTWwLZ/O2Sb6SqvSlHe1m4Y1OYHuZ7xur/7j939BLAlP4oMkyj89OKk6ZB1BCwR15/qlSyQiupNoRMkkIbGS+ieH9ovx8+l+iyYAIeK50LemGZN3WmSEcHphNAdfrWFJHjXZFk/bZ1CoICZ/5979NMzhBTL3XOO5PawO+xhiwX+FCrDmY4gdGhYuuxLa8gIu/zaIlsoIz66PovuhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZOMCi0kif4HgweEAl9oe4JTtLWQrwgjrJVBb62jZI/8=;
 b=N/KP8WtRgKYF/ZVfiusRyGW7EAW+Tkhz7QTkT+rIdnRxxKIXjIbf4h1jzR/Iyr4f/2mqmQctOMFWijEdPr76M3KMfyQDFs30n4DQwxZhrd1R+RvCUKyWwkgb7hFkrT2a/IOCp7ZFSSIZ93x0P7S1apLsmkIHJINWn3qHPh9W3YvnZwH+QHkruRJse/fXIEKiQb5pFq1ZbmTqnvRjpHnWc+oe4jQDhjQCMzKVf8+sSMfmnItPWUClqHbNbbhWOdsFA+w4y9mONkKM5UkRFGmXf+9LCcB6Nhls2FxqR/q6Q/YRwn1/qwiUqljmUiZHIFyBGr3Fy8jjj3jF3hARiCofAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZOMCi0kif4HgweEAl9oe4JTtLWQrwgjrJVBb62jZI/8=;
 b=XZY1ZNdmsMjaamiKxqJPh527f7YQNguoXmlZkLYiib9+c2Zzpbs3dtWQ+EzKVHwmK+pXBXpr76jDlOR1lgH5gvdbNMnxThxxQyKFQ4qvBjGft4tAb6Va+XfGl2srshoH4D/wjqAsVexzVMc4dCBAJ9VL2OPHEiy+xvUERCHJkFs=
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
Subject: [PATCH RESEND v2 13/18] xfs: add parent attributes to link
Date:   Thu,  4 Aug 2022 12:40:08 -0700
Message-Id: <20220804194013.99237-14-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: b09e1a8f-6cde-4003-8126-08da76512db8
X-MS-TrafficTypeDiagnostic: DS7PR10MB5136:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wx8uKTlk9jrLBMLf6kyVod9g3ha17Xp84L4zKX50JXh9YFFuu4fLEFZUoIgl0vAeK3VJJoAsg/unqU/t4v42yobXvT3gXlUpIRl5lulrhoQ79lyikoER4NL56astkWT+GolhaMyXsTJtXSAaDe+xfi5v8qYUw/hXR42Iib6zke8LraJtmvc4vbTQhBMzDV2wB3oJEdUEbtCNQ5Nq4/i71bO9ENIvVvJjFsJotQDlWqIz//Cbxii2t5D9iaqMy4YYe7rOCiB7+QPmmTPgAJHwmlG7iP8PKH+16cpGEhQHcJcr5/xnLvMi+5dMuFJkbU56QiaAqVENaVxl+FvtuO+7fciMr4DZ+o72/BfUkkN9Z8BiinUGNfdtG5YBR1AwmEbV9JsBuD0xrFjZbh5xRuuZYiNBCzGAk2wLPWqe81Le8Vs8KwxKhq/bSb/tfVdT0vZITvFEIl0wk/APZ5fL5PRi3D/eZWsMi15+AjNM9t4gHZ+Q9hmHkSSiHOfu9xYtDLgLbXDHZ+v2HQ2phpw6NNmWwLJZTW3iqBruMjZb1vLeqTKiV9yOt9PuyWETdiYiQkX3EJs0ON6/o5osmiDB51SEQhgoCkIjl6Nq/cOhE2vDvKv3QLain3bWCA77NIEr3UT8Xl5TfkhLe1VugBO6lhK/epkgYijQNTST1gD+JlQVhAwHIvDqsMT8aErRsFGWaP0zlKo/UnGYwA/LrS2jsAM3vHlB5eVlJPPwnchfORPfavRTyU5dINvaxX1mU7ujzDVftdvz9ZsR430TrMJxOpuoE/l9qwTXSHMzGGlbBLqSWUw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(136003)(39860400002)(366004)(376002)(6486002)(66946007)(66556008)(316002)(8936002)(6916009)(478600001)(38100700002)(44832011)(66476007)(5660300002)(8676002)(36756003)(52116002)(6512007)(1076003)(6506007)(26005)(186003)(2906002)(2616005)(41300700001)(6666004)(83380400001)(38350700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UOaqRibiUz8VRjY+ARyf59TnAWWYueowy/2q7vMgeMp2IKQ2jN4xUvzVxQOw?=
 =?us-ascii?Q?HMG4WxNHZg7Ft76pktD99/uRw0rnKVJK9WiN8DJbpwl+KT9iZ7pz8IY3CHpD?=
 =?us-ascii?Q?y9zEXdGLDPQLOhcuqCvswxPSScaLWzZLjIacMQO7QlLNQcKEGghrM0VVsvno?=
 =?us-ascii?Q?G68z/zhJv7+idGtGa+EkW8jQ2bkRkriO3eXdFzVfb3b2NYxDr9vCz1uEcQyB?=
 =?us-ascii?Q?pkShza3M84Tk+OQTif1wED/isrS6w4kA0wZUmTNp9weFUQ5gjqP8vrDsmIsl?=
 =?us-ascii?Q?j1BBYXQ1nQAFE7Ixo5xSgrHaTZTOQ69J28q47fBZgjvu4f3e4DS+2uGghmQn?=
 =?us-ascii?Q?BB1p4zzja+81M/kWbLgQDwXE2Dcq+51NEz8G5kW/pzSCGlSKlXSkR1FG+Drm?=
 =?us-ascii?Q?gM004/CKBBIyWohiRhIg17v+ahGF8sqju6z/FGc+9l5IBr8XNq8MhqFAVvOs?=
 =?us-ascii?Q?L311HE6eQYq+4iPT0nHIPGG1xU4p2o3+BdlKSLNIL01egg3JipJclXPQJxDT?=
 =?us-ascii?Q?wh5B6OogA19yhbfEehoYyTFGZEqwbpErMOONTprqFSn8paT6hQRDS5X2VunU?=
 =?us-ascii?Q?DIAOS66CB41TzJxNEq8JAlyOUqGfjOk+F5VyCuWYpMNa+YeWR0pz82AFYRCM?=
 =?us-ascii?Q?/QLhtBfh2Hz9wEt+EW3LJ95uTm17VfzlxZp7oRqHJp3lA73yW29iqLjbkeW1?=
 =?us-ascii?Q?8lY8HPkrN+JIwqD4ex+gvxyj6KkqPlVv/BrVwoLZ3kdHBTV0x2VUQ+TWg5VL?=
 =?us-ascii?Q?hpQikmMITTrQOM+c8MEYiOCKZGKdM4XIazMuq0sLPHXHMPnVFdYQmnbg53kO?=
 =?us-ascii?Q?M3F/BDVlZkPxy7EzGxHJmSIZu+TYc15NOnMK1IcniznyXrQSWgp5MEI/fTMh?=
 =?us-ascii?Q?jcQGPXKqntQRiQ342qje+T3WJ8e1+G3tsfolwZFwLFjzEpjAa9W630DMAag9?=
 =?us-ascii?Q?xCoIQNf3DZFOyNu8RlduWvvaC3YSI3lTO1fRX7c+ATlMC85iO3pKP8yPfQOy?=
 =?us-ascii?Q?mbwaRS/jCJzDUXNcdm55k3+tclQm92mo4t1mwwryFN3VKo3x1QM43Ag1FJW7?=
 =?us-ascii?Q?NlVGjKq8xS3JWz1MhfyKCU+G0RlelMTnjjdMgs5xxOuoKzWg9m59eQDkA4yH?=
 =?us-ascii?Q?x0NceTYNV4Fqiz/74ptcIgOgmca9YvnnBT+FvmtwW01ZIIb8eXk8FosjY4hx?=
 =?us-ascii?Q?NsM/QwmGC6mKVXPAj7uXCqyFP0zNSjuEg6FhSieJoTwuffijFnGFD4a6g6tL?=
 =?us-ascii?Q?wIDBEMsw38qrPvWic45JWkumztjXG+pmkspFRwHeOQo3Tmvj+0SXxpxPjZHy?=
 =?us-ascii?Q?V0f+K4FC0g7vZgoFfYDeeRG+zN6vU8YNy+5GhvZy40Zk6+xlfe6VRSE7etlu?=
 =?us-ascii?Q?lpiM+Vd43QBHAX0yA5O9Gb3Ds+W+nmvHiIj3WuxMnZf53YA4uHOo/9GQD+3k?=
 =?us-ascii?Q?ukxjE2mDeIf8AmwM7C67tj0/ECZhHM45MAmqEMKM4z+66Acy4vuj8SCO6iqB?=
 =?us-ascii?Q?VbuPOt1mzOZTlX9qBHNpPnR6ym/IBsDflRwWu1HNJrxwXiLCviQSQRrWQ6iv?=
 =?us-ascii?Q?ooMNW9twuwG2ifL70sEeTf4CuFYam0Y+5YASxFYzmu/ZFbt9BSPe/3kddAwt?=
 =?us-ascii?Q?/g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b09e1a8f-6cde-4003-8126-08da76512db8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 19:40:25.9091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6/g/5gP0Jal+kKTPnijHO4ywAFA5hAHR1FERCB46KweqCeZAeE+fWrF/gcywjPsRCSt6p+8bbSZFXIG6Fv2aBpRTCI3AWTKisTePZZT6nGU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5136
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208040085
X-Proofpoint-ORIG-GUID: ffs2uQCEQtiuGXxtes5ypqUPXnkkUlKM
X-Proofpoint-GUID: ffs2uQCEQtiuGXxtes5ypqUPXnkkUlKM
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch modifies xfs_link to add a parent pointer to the inode.

[bfoster: rebase, use VFS inode fields, fix xfs_bmap_finish() usage]
[achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
           fixed null pointer bugs]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_inode.c | 43 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ef993c3a8963..6e5deb0d42c4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1228,14 +1228,16 @@ xfs_create_tmpfile(
 
 int
 xfs_link(
-	xfs_inode_t		*tdp,
-	xfs_inode_t		*sip,
+	struct xfs_inode	*tdp,
+	struct xfs_inode	*sip,
 	struct xfs_name		*target_name)
 {
-	xfs_mount_t		*mp = tdp->i_mount;
-	xfs_trans_t		*tp;
+	struct xfs_mount	*mp = tdp->i_mount;
+	struct xfs_trans	*tp;
 	int			error, nospace_error = 0;
 	int			resblks;
+	xfs_dir2_dataptr_t	diroffset;
+	struct xfs_parent_defer	*parent = NULL;
 
 	trace_xfs_link(tdp, target_name);
 
@@ -1252,11 +1254,17 @@ xfs_link(
 	if (error)
 		goto std_return;
 
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, sip, target_name, &parent);
+		if (error)
+			goto std_return;
+	}
+
 	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
 	error = xfs_trans_alloc_dir(tdp, &M_RES(mp)->tr_link, sip, &resblks,
 			&tp, &nospace_error);
 	if (error)
-		goto std_return;
+		goto drop_incompat;
 
 	/*
 	 * If we are using project inheritance, we only allow hard link
@@ -1289,14 +1297,26 @@ xfs_link(
 	}
 
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-				   resblks, NULL);
+				   resblks, &diroffset);
 	if (error)
-		goto error_return;
+		goto out_defer_cancel;
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
 
 	xfs_bumplink(tp, sip);
 
+	/*
+	 * If we have parent pointers, we now need to add the parent record to
+	 * the attribute fork of the inode. If this is the initial parent
+	 * attribute, we need to create it correctly, otherwise we can just add
+	 * the parent to the inode.
+	 */
+	if (parent) {
+		error = xfs_parent_defer_add(tp, tdp, parent, diroffset);
+		if (error)
+			goto out_defer_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * link transaction goes to disk before returning to
@@ -1310,11 +1330,16 @@ xfs_link(
 	xfs_iunlock(sip, XFS_ILOCK_EXCL);
 	return error;
 
- error_return:
+out_defer_cancel:
+	xfs_defer_cancel(tp);
+error_return:
 	xfs_trans_cancel(tp);
 	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
 	xfs_iunlock(sip, XFS_ILOCK_EXCL);
- std_return:
+drop_incompat:
+	if (parent)
+		xfs_parent_cancel(mp, parent);
+std_return:
 	if (error == -ENOSPC && nospace_error)
 		error = nospace_error;
 	return error;
-- 
2.25.1

