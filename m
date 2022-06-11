Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45B3FCCA47A
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 09:42:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbiFKJmc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Jun 2022 05:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232533AbiFKJmS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jun 2022 05:42:18 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6B6C6F
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 02:42:15 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25B2rQSU017081
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=ShLwHKhjJrgKbso2ld4Us/JABrJzn8ghZTLe/u2o5O0=;
 b=sgsb5P29msSwBiFWY0zlP7yxXMXkIAwBxRiDka6lAqdpW6Hm2iYOkUCLjj6s+JXK+3+5
 YW6pX1ZP+PeIlYgn4e3q5tSqNTWiKJ7c37dJ/vuR1xkqPTnhNs1XeiTgWdgQ5lst/5Sn
 HVA7Kk35vCm02GcOJuNl76io5WNv3mG8jaiWiHF7/kInNSMT3JpEAAzWSoh6BirfQQ36
 8QXkShWa2MwnXnjMX1qlCUezUkFbKnS8WSSCmfuo3vbeUAZvoxqDSj5HvVAVc/QEjroV
 Yhxw8gp6P1MFAbOmAXAjBFkzLEcX4OvWJBoKKOAwhF5GV4/2mnzeQebRq1Y4W+ij4TpR qQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmjns0asp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:14 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25B9allH001303
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:13 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gmhg0m9ta-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V1L4qO7hZpNPq06Zm2H11cCRwCzSRunSjbyYzol89vvv+vCyERGQ5k53E+IJFESuVOV193QY/N3x++ubkQudG06jEPTC+tZU5p9VHEhXsCznz2KlmQubozUL5mY+jF5UyFsOIDcG9NkEpxyiYNkxQcufXIWbtqok3ccGdPX8PWujJbiN78q039vxsiltFwsJs2HWcbvcb5Tdded1e/tzdJDV7Tl2a6t+9ZQDHWGRUFXNZUFp6UvxIuPUOD2IfVx+ziOJ78uwFPI/83qxrWVfOu1elKVdWAoVI48n8R7Dotf1lmlUgBjcMakryZe355WCvQzXFfIRrCsJj/br3qyd2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ShLwHKhjJrgKbso2ld4Us/JABrJzn8ghZTLe/u2o5O0=;
 b=H0opoOVnsnhBUgagbygoLaNHWMYvZOtoUHP/zGm/Lq21nvBC8/C6Njc+aqXcmBmZW6mQsp2vKtRsIeZ+ia3lXmBdGuh2sqYbEocaBNajOgwLaoALYUG4QBAAMvlfehE4FGYSMaqfEYBjXcZmwvVu/AtGggxzmM2PJMMVJcHkhWltO/yN/Rn3lqeOwo7y5A29uRabWrALWh/HjFU4PIs8oH5rkSz/XSJTmCqYVz/7Qrid+HcW2ldWRLppeRIC8KpaEfZN7SCVD7/2WEWDmgdPc2HKCYpUqlj7ToETIi8VnJ2ZJC4MSF45Uywwn/fpsiSdjqpSMuWvJTLDK3mw5gmoRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ShLwHKhjJrgKbso2ld4Us/JABrJzn8ghZTLe/u2o5O0=;
 b=D4Gdd37BhE4jLiMB9JSkeq1sYWBryD/dX6vgZUGv7XWcxmnPbsu6A4Er9vzFpu8zBSpmxE7GlGLbIExakPhXtqKrvv3u/fp2N52a7xpcjj3Yz9xoLBXJ0mooYtxSRSIdAPgYCeTSUbAhNZDfDdN0MQtOk/9O9DNjIcyLeyQ16eo=
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
Subject: [PATCH v1 11/17] xfs: add parent attributes to link
Date:   Sat, 11 Jun 2022 02:41:54 -0700
Message-Id: <20220611094200.129502-12-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 962cee53-95c8-48ab-e454-08da4b8ea747
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4606:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4606E4B79F3E9A3C78CD315D95A99@SJ0PR10MB4606.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ksLiCRYDbaatWIJ2fto3vBzZmHj1d/W2witgBOK6aJnDCig6OMqufNavoy5L0stwKtgUfTS6wBnuCi7p5EmdZh8vvgiIF/SMvbj1ltNbwXam4OkK3g28c083iwd/rvPRcUe7Q6QD1dnNCVY4paRqnOghTzi4eQ3Ml0pvKyCB6g/CQy9UuwC39Q+gO7SC4k95yMCsIWlIij0rtFyIP7L4ArL6qWmOSMUiIRw3Z0Rb3wp1vmI59HCAaIezv0qpPXYpYS05LAhJELTxyiWZx4VxXrmsYhhkgN7YyDuWDyEg4ytE7JVkrBYMayShexYtN8x4b+evEkDmqlF1tBnk4SCF4lymeEvNYuGqANxtvklZj5d3Qn/9bfOI8sBqVoVESoeHdCcPmL4bhIVUjfn2KR/Be9lCw9N4UCuXdCKjZWchBvLvRd8HY5zs/Z1KIgIjyoj6spQrQ4WIh5lshDrrDB07Wfd1R1P0rNcm48gLbB30V0zr/FrMN+8mI7eaJiO5IBR/U/r4EaJpgcY4aHtFLIhGMXjg0F6AmoQTofn3+32BGi98OCqd+sSgibsneUJ2pixfDIZwfyht7XKYSZt2cZyHTYf/+eSfTRCN4BjZ2oER0rH93w8BQcCkB2VIroG7TUBMQtyaDuEXeHXY48jdh96VYqnSHsKtVFmnCd/oLKnFwujz6Qgciyj/sBky00WT0Sy9nTrisyNGb+F1yd0+Ndo+4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(6486002)(44832011)(86362001)(2906002)(186003)(83380400001)(36756003)(66946007)(66556008)(66476007)(8676002)(5660300002)(508600001)(8936002)(6916009)(316002)(2616005)(6666004)(6506007)(52116002)(6512007)(26005)(1076003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cKkr1c0SROewfqPLtcRl6XdD2omlhircxK2fSYf3UAYv0YYKr34uZBxMcCBf?=
 =?us-ascii?Q?zS4z+aDWOMr/y3YHziRJH8A7ODaxpAQDO5Gqe/364086UmvqF8VsO6nDjy9B?=
 =?us-ascii?Q?fEURltLXYajKylFIDgslbVL+F80kR6nUwfCjeAgthyqg9KQjnCOy+AErZfHP?=
 =?us-ascii?Q?jj/nAhA8m20o13yIkgW6L7yhfpE6m5FhRcgNAiYg1thUiJy1u0HUsimqetbJ?=
 =?us-ascii?Q?nP3lrcZjzHanYPHXd7oBzohIDEFPt6kX3R8Ss0YqV3wFMJ4IJVqC9e6wtwp/?=
 =?us-ascii?Q?pGqbvnLFUUR/49QLxqejIqlwWyLmjmbWOYEV9C2Qp6YYD/D9kYG3mMAIzC5N?=
 =?us-ascii?Q?emnk96WjUyyzoWMr9F2Z00nolWILO2ty+0nJLgIvrk/fhn9li7kiHf3LbJvx?=
 =?us-ascii?Q?upQk+r3jrXZ+EDS9eZNBi8Js1VitDVTJoQqO6+y+EMhIAsT8EPvE72CrTnwb?=
 =?us-ascii?Q?0a8u0y6l1KzujSGr3wum6w08s7Gn9tnaoJ7eNpp47D8XPwooizJx+PGvI+8K?=
 =?us-ascii?Q?LwWso45iDR8j0TRYhTz1Bq5+NcjeTB5dQJ1stQQdiLq0H6tB9KCidNqyEKaO?=
 =?us-ascii?Q?mor5ut6BEKrZfVFo2q9PVunES0oZGoLyK7pRu9SOxlp2zYFL7PvjwP/2k/zb?=
 =?us-ascii?Q?vXfisQpCEo9V7AP5gbvD9B1lTZhCqa2yGIN8x5zEibfF7k8NKBZiZCTBQH5U?=
 =?us-ascii?Q?gJUqWGHHzZqC0mwRL6tiF06AqoLJKl9TKr1sQDz8BRikRmvglBEWaDeFLgmt?=
 =?us-ascii?Q?xkDmA0NjeIR8YofzfHG+XVs5sgueguhCgGFXPWUROi/bvjR2MK14/iLYlDa/?=
 =?us-ascii?Q?zzpCDJOy4basg+p6bl1XKSlwjEf9G1wqWydCRWSh1HRt/38obyhQ6J7aCl77?=
 =?us-ascii?Q?xCuynuOqEsM+0mWZBcFTg5vVcgTGJaHoW6LwrQuOUMElGLn44B/OO0XNWcWc?=
 =?us-ascii?Q?8BS7oQBtkNj+JhZVCaNfBVnfoCnW7J1OoHmaelVls0kTOLTgeW39+K/oTlIg?=
 =?us-ascii?Q?CWwxtO/4DcXu68aw3F6MvQ6SLYuEcSiBH58bQtO5rM0RBr3Sj/4OgxuyhjjA?=
 =?us-ascii?Q?jMYzRDzG47O+bORR0nPj8nPf/9amu0DvzPVh/+yjF8MGWHFGg1iJMCCxGBZ8?=
 =?us-ascii?Q?0Uzcq5dxekecbSb23bmlhdRYvVtu/NalF/ve76KY/okQaAjqckXkAVNcPfkZ?=
 =?us-ascii?Q?8G7UJqWIb0MyIcoX2wFhNtkmpd6Utg6czTaVuXkMSKo9VU2J6t00wkcDmx8z?=
 =?us-ascii?Q?3xnShvIvXuoalVo+wiXVpz5f2+74WK1w8a6oHENfaXPKE0PdbUxmIkNH4SpK?=
 =?us-ascii?Q?SvkZjravqtWDay9046Y98m7YNKJLM4/1/ZPph2s/7jMHeeRcJbjVFhZeKPwr?=
 =?us-ascii?Q?rt82H0cqqZywiq3WwZYi76PT51iI+DKPvHFnOkkqnv912El+mBWG8nCm37l2?=
 =?us-ascii?Q?ptrVbACoH8KiOlvtgr6DE0nbXz4Z/iP+e+gwOsP3JIacq2wnnukuBTh5F+uZ?=
 =?us-ascii?Q?hnlqCR7cl0JxUwHhomSo4FwGam9tUqHFsq4dqU5TA+/X9wRTsm0chs3WBmCY?=
 =?us-ascii?Q?1xXLGaYVRkgXFcUHsQDiW5gcYGdSP3XBhpMDtHsk1/6fDB8W88ddM49v6eTM?=
 =?us-ascii?Q?H3r/r9m5kjltjtzlreyOlghgjzYdQUmGT/ubMVD3mAbMjm56WI9fuFh07utB?=
 =?us-ascii?Q?m4aKIAbAbpoowMv5fbS3VRNSOBB6qPNYrothWWJEDW5u7W1lgYjvlFopUVK4?=
 =?us-ascii?Q?pIxL9UkvHlWTP13TvbeMqHFTjjzaRZw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 962cee53-95c8-48ab-e454-08da4b8ea747
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2022 09:42:09.1542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V2PPHCxG5F3sbfELYxMYQtPgmwZRPhN2gLhisV9Qi3QypkMzb7f9LVT+U8E/EPgqDItvp5oPFdca1oCQQUv7p6lpwIyHIvR3IvhOLEM89vI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4606
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-11_04:2022-06-09,2022-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206110038
X-Proofpoint-GUID: d4S9aN6cxYBixoOPDwNdzqmFYYtJAply
X-Proofpoint-ORIG-GUID: d4S9aN6cxYBixoOPDwNdzqmFYYtJAply
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
 fs/xfs/xfs_inode.c | 78 ++++++++++++++++++++++++++++++++++++----------
 fs/xfs/xfs_trans.c |  7 +++--
 fs/xfs/xfs_trans.h |  2 +-
 3 files changed, 67 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6b1e4cb11b5c..41c58df8e568 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1254,14 +1254,28 @@ xfs_create_tmpfile(
 
 int
 xfs_link(
-	xfs_inode_t		*tdp,
-	xfs_inode_t		*sip,
-	struct xfs_name		*target_name)
-{
-	xfs_mount_t		*mp = tdp->i_mount;
-	xfs_trans_t		*tp;
-	int			error, nospace_error = 0;
-	int			resblks;
+	xfs_inode_t			*tdp,
+	xfs_inode_t			*sip,
+	struct xfs_name			*target_name)
+{
+	xfs_mount_t			*mp = tdp->i_mount;
+	xfs_trans_t			*tp;
+	int				error, nospace_error = 0;
+	int				resblks;
+	struct xfs_parent_name_rec	rec;
+	xfs_dir2_dataptr_t		diroffset;
+
+	struct xfs_da_args		args = {
+		.dp		= sip,
+		.geo		= mp->m_attr_geo,
+		.whichfork	= XFS_ATTR_FORK,
+		.attr_filter	= XFS_ATTR_PARENT,
+		.op_flags	= XFS_DA_OP_OKNOENT,
+		.name		= (const uint8_t *)&rec,
+		.namelen	= sizeof(rec),
+		.value		= (void *)target_name->name,
+		.valuelen	= target_name->len,
+	};
 
 	trace_xfs_link(tdp, target_name);
 
@@ -1278,11 +1292,17 @@ xfs_link(
 	if (error)
 		goto std_return;
 
+	if (xfs_has_larp(mp)) {
+		error = xfs_attr_grab_log_assist(mp);
+		if (error)
+			goto std_return;
+	}
+
 	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
 	error = xfs_trans_alloc_dir(tdp, &M_RES(mp)->tr_link, sip, &resblks,
-			&tp, &nospace_error);
+			&tp, &nospace_error, 0);
 	if (error)
-		goto std_return;
+		goto drop_incompat;
 
 	/*
 	 * If we are using project inheritance, we only allow hard link
@@ -1315,14 +1335,30 @@ xfs_link(
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
+	if (xfs_sb_version_hasparent(&mp->m_sb)) {
+		args.trans = tp;
+		xfs_init_parent_name_rec(&rec, tdp, diroffset);
+		args.hashval = xfs_da_hashname(args.name,
+					       args.namelen);
+		error = xfs_attr_defer_add(&args);
+		if (error)
+			goto out_defer_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * link transaction goes to disk before returning to
@@ -1331,11 +1367,21 @@ xfs_link(
 	if (xfs_has_wsync(mp) || xfs_has_dirsync(mp))
 		xfs_trans_set_sync(tp);
 
-	return xfs_trans_commit(tp);
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
+	xfs_iunlock(sip, XFS_ILOCK_EXCL);
+	return error;
 
- error_return:
+out_defer_cancel:
+	xfs_defer_cancel(tp);
+error_return:
 	xfs_trans_cancel(tp);
- std_return:
+	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
+	xfs_iunlock(sip, XFS_ILOCK_EXCL);
+drop_incompat:
+	if (xfs_has_larp(mp))
+		xlog_drop_incompat_feat(mp->m_log);
+std_return:
 	if (error == -ENOSPC && nospace_error)
 		error = nospace_error;
 	return error;
@@ -2819,7 +2865,7 @@ xfs_remove(
 	 */
 	resblks = XFS_REMOVE_SPACE_RES(mp);
 	error = xfs_trans_alloc_dir(dp, &M_RES(mp)->tr_remove, ip, &resblks,
-			&tp, &dontcare);
+			&tp, &dontcare, XFS_ILOCK_EXCL);
 	if (error) {
 		ASSERT(error != -ENOSPC);
 		goto std_return;
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 82cf0189c0db..544097004b06 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1273,7 +1273,8 @@ xfs_trans_alloc_dir(
 	struct xfs_inode	*ip,
 	unsigned int		*dblocks,
 	struct xfs_trans	**tpp,
-	int			*nospace_error)
+	int			*nospace_error,
+	int			join_flags)
 {
 	struct xfs_trans	*tp;
 	struct xfs_mount	*mp = ip->i_mount;
@@ -1295,8 +1296,8 @@ xfs_trans_alloc_dir(
 
 	xfs_lock_two_inodes(dp, XFS_ILOCK_EXCL, ip, XFS_ILOCK_EXCL);
 
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, dp, join_flags);
+	xfs_trans_ijoin(tp, ip, join_flags);
 
 	error = xfs_qm_dqattach_locked(dp, false);
 	if (error) {
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 9561f193e7e1..4ac175f7ee69 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -266,7 +266,7 @@ int xfs_trans_alloc_ichange(struct xfs_inode *ip, struct xfs_dquot *udqp,
 		struct xfs_trans **tpp);
 int xfs_trans_alloc_dir(struct xfs_inode *dp, struct xfs_trans_res *resv,
 		struct xfs_inode *ip, unsigned int *dblocks,
-		struct xfs_trans **tpp, int *nospace_error);
+		struct xfs_trans **tpp, int *nospace_error, int join_flags);
 
 static inline void
 xfs_trans_set_context(
-- 
2.25.1

