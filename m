Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62BE2C25B06
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 19:40:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239405AbiHDTkn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 15:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239263AbiHDTkd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 15:40:33 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA17ED12C
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 12:40:31 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 274HbaaV013546
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=s/pR0C/jiCpALnJA1EEzWUFgLfLKq77vi/3k1uKv564=;
 b=Zo0B5LScXdSN1kfCy3e4m0KwvOgjErlLzPcjVMmLMUwZLIgoMuwDziMqMyG0TvKjLip5
 plT4WT5hYrGfHK8+pwvnuglkNo5SU3Lnezzae4KNCZRpPUJLLLJGsVtWDS1PFn23tpNu
 E6hj4axd7O5xiy4w5n/yiL+Qd7Fz6djVn8TaGnmn1Vc9kggrVMAyGTaBMIN+nRlPlNB4
 x0qfQWUwRUyRJsba3jMFROG7BVOYmyBRJUgfojT5VhqpZfybDKvXWW86DvSb2XtuqZ6S
 W3aonnohOOiA5pgwqL1G/tJfXQZ7Afc28tQPZQf8Lllkz439ekdzAFAa3XfDR+tBSVeG aQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmw6tnyd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:31 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 274HjGDW007532
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:30 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu34b95d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LcsNT+YTmd2Hd4vS1Mr1MH67ZtVABkqY7GPAESJhC6LmjMDVqGnY6jNXs2RsaNf+VL0KgWcgtxacsyINanXNx6t8xWSj3doZyWODnIc7ZvEASkLYenGLcsfx4HFtV2YdX//+lMm/9uOszBkWEzo9fnW2fyCI1npJA7yP2In+ah8fxVFm3J1tq8LwJM6HTQpNsQzN4ZtFcPxbjAJQRWEZX2KozHOVrE870GoHnW+7SYxY5IodjKkMHD+TMLqqDbtOMPMm7CemOmD+hi/yL+owekvjBx27YxBlXrBxkJuPgS4nhrnzbY0wnLspSrAGtnPN6/jnALkZ5h4gDWN8h37Ypw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s/pR0C/jiCpALnJA1EEzWUFgLfLKq77vi/3k1uKv564=;
 b=FxVm2+jzilCKgcATl1K9d576j98x7UfDEZvbi9Wms2ubQfnm9BA3OQjwvMfeHb8kpKkG2g4ma+2Vjj5t40MgJdCelizC+z+93D9LvNYe63zcZvy5ms+jdyI6Fz2NwPoNRs3vfb28XHh1dlf20iOJzG0nVHTGzFOJU/yQ3eTuTJ7Nj1RR/OR9oZStnVtVf7zINvHf71MYS1As5ahsF2qH55Vc/hPgAsYOMb7bnryqOCBGBLnY40QwnyFvLGKPn1KpaGcEwIgkTYxsE/mRwZkpv6JjYVHvhpXIhnq2Ko4gE4sAZshhzSrVt1xv6itk1ZG+205tZcC5ssWmswTfBOnrgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s/pR0C/jiCpALnJA1EEzWUFgLfLKq77vi/3k1uKv564=;
 b=Lt1EJkLvI4Hmf69aWgnIROz8yZw2sNw1CCrP1e71rxBNNB66X+QeoD9BmnKS9F+CZm0Yqtc+gufkWXKt4IGklZTWzY8JIxvxdMD5DcokSNSc+HEfugYQA7+02LZ5WhXwfNUBv0gLoJxl92Ur7FvMmWMnifEewCsCDGFdY4RD8Mo=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5136.namprd10.prod.outlook.com (2603:10b6:5:38d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 19:40:28 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5504.016; Thu, 4 Aug 2022
 19:40:28 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RESEND v2 15/18] xfs: Add parent pointers to rename
Date:   Thu,  4 Aug 2022 12:40:10 -0700
Message-Id: <20220804194013.99237-16-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7c94f657-40d3-4c41-8a87-08da76512e28
X-MS-TrafficTypeDiagnostic: DS7PR10MB5136:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qzJMSZGRQERsLLlZMzB3CjGnwL5pORXUVocenwv0ASI9M0XmHjEfDumfrZIHcPuZ9ztX6s5BPnWXEkHCXe31Ti4VfuNab6D/OhwXcSa+Csh1jpb22hcLnED1TC+U9+n5ZMS4HZfwVL5iBdC24RVnqVbul4h0PD9iL83Dxbd1HXwKEbytP6GRci0ZFJCsEvRKumtZ+N3W0p+XZ4HIdusDkbZqEdMz8UYlgbqUPoxvVwSg+KzuOBz2HnMoG7Vy5xcFv9HGWXYCWew1lGYvIxIEsuekiRx6YWz9qdG0dVMb1NvU4FPphfkRGKE2gLEWQr2WQnYsjVfx5nQ/PoLRcYvFX746FSxvenPwqbp4iK2J7peSMjJWd/jqKGEeBOEXn2np8WgsCZjOyI8mHSpbxYVbfvcnweqh633SHXkduoy46vDu8SIwNmNdGMHY0+4UEAf50Q9HkJelgu22wFjcOY3jdAfi64u59HUmG1O0zK0k91EZypAzArQHS4OGUct5ll2TF8hWU47jI5l0+7GALWH9siLILuZ9GTCsFVeCVST2Vg/hT2LtJDcvIA5mmuTMDoBqQe4gn6riYsY8VXt82Zn7ldn1iY4/JnSU+xCMkWrJb9do3SV1Y8ur0nTqQSfovvlLq3OL+9eBVUMkfsC/fWoWJX+qHgJSD0HovE/KXsTkNDOvm/pC3FyqsiELz+NxF2FbKR17jD1rMSwWomLsn/uySJJSZTjWMJNgB6UCo/zDwVJjOPwvKRscjHKhF5J/Go+xnrw+rAQhS8kz7zfduzoZZwsZ370NxcBRNv1C6ySJB+I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(136003)(39860400002)(366004)(376002)(6486002)(66946007)(66556008)(316002)(8936002)(6916009)(478600001)(38100700002)(44832011)(66476007)(5660300002)(8676002)(36756003)(52116002)(6512007)(1076003)(6506007)(26005)(186003)(2906002)(2616005)(41300700001)(6666004)(83380400001)(38350700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/o1ZAqXDVZ567JqJIUlgUxIXYmRiLSqvGdMMdEc/WgyIHKCsJ3/y7+ucLtI0?=
 =?us-ascii?Q?4QFlpLIyV7yLy5HNJ89k6uloHI701lyAcW+yYCOzgDGrq2iuHg+XNYgbcNLr?=
 =?us-ascii?Q?aBn4jy1DQkNLkMKr1sC8CKnhaQMZBLBhHwk4BePmCAbCHTRlt7lti7+wUK+6?=
 =?us-ascii?Q?kJa2AwKi2OenAWYmEpag7iklN1dU6Dw7Nds6L+QyI5+jjPX5ImM8C+/Tp2SW?=
 =?us-ascii?Q?jyrOYqFOKmnCWCnU+WmVVC5IOUNYZ2CFAW1g+uO9wxJDhD/ozUY+XaMhQoeJ?=
 =?us-ascii?Q?7M7Z5EcPYW8/ypXLMNunzMkd7bRnjjhdfsvzgigBVj6CE8GHHODsmkNKJV++?=
 =?us-ascii?Q?yUL/dNk2/BmZw5D3ORBEG5fhnizwWc1PGmYx7vzKiHrf1Pm4QQERa2J78SGp?=
 =?us-ascii?Q?odl3G7+hXUJREoM6PGW/ZPHaYn6TU2SCTHym5m93xqDAMuOWaNK9eCoX+X/N?=
 =?us-ascii?Q?XicoWZ5h6tZaHnjqCtQT7PZzgeZs8PjB605BpTLjUA2sQJshXVkVTbdfaE8k?=
 =?us-ascii?Q?al4PV2191jWWUnEFf+u80XlGD22EEqPGMDMjMEYzYkGdS5G42J/2OX+lkU7K?=
 =?us-ascii?Q?MZ879FYl7ESTIsLyNhtuG3IOmwEPTgs086O4YTq21ckGTolj8wkarETFEKqr?=
 =?us-ascii?Q?XHFKgPBK+xMKX6Iv9EXLXCrWXZrWaXxcO+IXVs+J+7qj06LtfbTnwvNiKKY9?=
 =?us-ascii?Q?i3fakTB7seNc6jjs/7J60Qi9SIhrgAj8rvJfknd+zRGB9i62R7LLgkeIhKBP?=
 =?us-ascii?Q?3RIMGWtDstHsPkQ4wCXLkzVwT+Q9O9SN776iS54UogK6CUA/yVgAuMUhDsUe?=
 =?us-ascii?Q?CFvdRn5HCBmjvwVU6/O488ccEd5ej9PuuXLobw1GxQ2Lv1pRdhzoNgrPB9oz?=
 =?us-ascii?Q?ZtaANhCcaYqBa29quDDbyTues3TrQj0XIrowxmaJ5Z/oqo/0W8SxeT8vo4JW?=
 =?us-ascii?Q?HMYRUnTUiW36ijadRISin+cvPapa/4sMxoLWSeTIVDB4n06lCe4MZSI9zpS+?=
 =?us-ascii?Q?6rSLTMczhDHnhSYn1+dPW+/GETIkzlFq/+6iRHNE5hJa4ZDIga6g1pD9wuvq?=
 =?us-ascii?Q?kiP+Jon7NbeVk1GDiZGWn61e0hfcitaAcHiNSjAHdMzS9YxecWv9xUuJk+MX?=
 =?us-ascii?Q?kwFqJRvWqcHp/Z0wFOgyiQkUOun1AAHaezyMiAFI2rkRzecCnpEqA+An6uRp?=
 =?us-ascii?Q?slX+xi0AsuiFlC3ivj/bXLYOFIos3nAkefz4dQ+PQ5JH7WHEqWFEaltvqtyV?=
 =?us-ascii?Q?PnvvVdYCOEzrTxhqEVhwS9W1ShQAnsjncOwuL9uaJBIiE7/L87QoONHG0cih?=
 =?us-ascii?Q?anLbbi3MS+L+EK3X8e+B5IhtxmXYAVA6Y7lXxSl9vm/WsDEOOkEnP1tqeh1Y?=
 =?us-ascii?Q?sQYIZRIdXu4InXatxHdpdDvMvKte9e8z6qNC5MBAN2YJVOalo1Prczrd/zKe?=
 =?us-ascii?Q?BDRQh2Ur7/eSjUKp3JCZMvxEGT0+VZWR+jhol3jIrw3unPP/oXVbwO8hJanP?=
 =?us-ascii?Q?f10QQymollEBzvoWbTY7zaoAtMOmcxP7baSdTNeNFlb6lx7Eq4gKqPy8SdlF?=
 =?us-ascii?Q?0VtNXyQt0c98K+UNGKNVkm7m/IuaXmSS5HkyAqqj3HAG2/tOy2g+0wQ225JC?=
 =?us-ascii?Q?qw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c94f657-40d3-4c41-8a87-08da76512e28
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 19:40:26.6433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ihW8F359ieJGY+5xcqZlc6inqkG3MDmKFaz5ujpjWXlcyn3lfiQWSpkTZR5J8Knr5NCmVzAx58O7I+PDEJLtWq5/R0URp85mvMojap/66zo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5136
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208040085
X-Proofpoint-GUID: QUysEYisgkc08CQlyI_03In_T8Kbo-XD
X-Proofpoint-ORIG-GUID: QUysEYisgkc08CQlyI_03In_T8Kbo-XD
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch removes the old parent pointer attribute during the rename
operation, and re-adds the updated parent pointer.  In the case of
xfs_cross_rename, we modify the routine not to roll the transaction just
yet.  We will do this after the parent pointer is added in the calling
xfs_rename function.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_inode.c | 128 +++++++++++++++++++++++++++++++++------------
 1 file changed, 94 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 69bb67f2a252..8a81b78b6dd7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2776,7 +2776,7 @@ xfs_cross_rename(
 	}
 	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);
-	return xfs_finish_rename(tp);
+	return 0;
 
 out_trans_abort:
 	xfs_trans_cancel(tp);
@@ -2834,26 +2834,31 @@ xfs_rename_alloc_whiteout(
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
+	struct user_namespace		*mnt_userns,
+	struct xfs_inode		*src_dp,
+	struct xfs_name			*src_name,
+	struct xfs_inode		*src_ip,
+	struct xfs_inode		*target_dp,
+	struct xfs_name			*target_name,
+	struct xfs_inode		*target_ip,
+	unsigned int			flags)
 {
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
+	struct xfs_mount		*mp = src_dp->i_mount;
+	struct xfs_trans		*tp;
+	struct xfs_inode		*wip = NULL;		/* whiteout inode */
+	struct xfs_inode		*inodes[__XFS_SORT_INODES];
+	int				i;
+	int				num_inodes = __XFS_SORT_INODES;
+	bool				new_parent = (src_dp != target_dp);
+	bool				src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
+	int				spaceres;
+	bool				retried = false;
+	int				error, nospace_error = 0;
+	xfs_dir2_dataptr_t		new_diroffset;
+	xfs_dir2_dataptr_t		old_diroffset;
+	struct xfs_parent_defer		*old_parent_ptr = NULL;
+	struct xfs_parent_defer		*new_parent_ptr = NULL;
+	struct xfs_parent_defer		*target_parent_ptr = NULL;
 
 	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
@@ -2877,6 +2882,15 @@ xfs_rename(
 
 	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip, wip,
 				inodes, &num_inodes);
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, src_ip, NULL, &old_parent_ptr);
+		if (error)
+			goto out_release_wip;
+		error = xfs_parent_init(mp, src_ip, target_name,
+					&new_parent_ptr);
+		if (error)
+			goto out_release_wip;
+	}
 
 retry:
 	nospace_error = 0;
@@ -2889,7 +2903,7 @@ xfs_rename(
 				&tp);
 	}
 	if (error)
-		goto out_release_wip;
+		goto drop_incompat;
 
 	/*
 	 * Attach the dquots to the inodes
@@ -2911,14 +2925,14 @@ xfs_rename(
 	 * we can rely on either trans_commit or trans_cancel to unlock
 	 * them.
 	 */
-	xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, src_dp, 0);
 	if (new_parent)
-		xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, target_dp, 0);
+	xfs_trans_ijoin(tp, src_ip, 0);
 	if (target_ip)
-		xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, target_ip, 0);
 	if (wip)
-		xfs_trans_ijoin(tp, wip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, wip, 0);
 
 	/*
 	 * If we are using project inheritance, we only allow renames
@@ -2928,15 +2942,16 @@ xfs_rename(
 	if (unlikely((target_dp->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
 		     target_dp->i_projid != src_ip->i_projid)) {
 		error = -EXDEV;
-		goto out_trans_cancel;
+		goto out_unlock;
 	}
 
 	/* RENAME_EXCHANGE is unique from here on. */
-	if (flags & RENAME_EXCHANGE)
-		return xfs_cross_rename(tp, src_dp, src_name, src_ip,
+	if (flags & RENAME_EXCHANGE) {
+		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
 					target_dp, target_name, target_ip,
 					spaceres);
-
+		goto out_pptr;
+	}
 	/*
 	 * Try to reserve quota to handle an expansion of the target directory.
 	 * We'll allow the rename to continue in reservationless mode if we hit
@@ -3052,7 +3067,7 @@ xfs_rename(
 		 * to account for the ".." reference from the new entry.
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
-					   src_ip->i_ino, spaceres, NULL);
+					   src_ip->i_ino, spaceres, &new_diroffset);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3073,10 +3088,14 @@ xfs_rename(
 		 * name at the destination directory, remove it first.
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino, spaceres, NULL);
+					src_ip->i_ino, spaceres, &new_diroffset);
 		if (error)
 			goto out_trans_cancel;
 
+		if (xfs_has_parent(mp))
+			error = xfs_parent_init(mp, target_ip, NULL,
+						&target_parent_ptr);
+
 		xfs_trans_ichgtime(tp, target_dp,
 					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 
@@ -3146,26 +3165,67 @@ xfs_rename(
 	 */
 	if (wip)
 		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
-					spaceres, NULL);
+					spaceres, &old_diroffset);
 	else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
-					   spaceres, NULL);
+					   spaceres, &old_diroffset);
 
 	if (error)
 		goto out_trans_cancel;
 
+out_pptr:
+	if (new_parent_ptr) {
+		error = xfs_parent_defer_add(tp, target_dp, new_parent_ptr,
+					     new_diroffset);
+		if (error)
+			goto out_trans_cancel;
+	}
+
+	if (old_parent_ptr) {
+		error = xfs_parent_defer_remove(tp, src_dp, old_parent_ptr,
+						old_diroffset);
+		if (error)
+			goto out_trans_cancel;
+	}
+
+	if (target_parent_ptr) {
+		error = xfs_parent_defer_remove(tp, target_dp,
+						target_parent_ptr,
+						new_diroffset);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
 	if (new_parent)
 		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
 
 	error = xfs_finish_rename(tp);
+
+out_unlock:
 	if (wip)
 		xfs_irele(wip);
+	if (wip)
+		xfs_iunlock(wip, XFS_ILOCK_EXCL);
+	if (target_ip)
+		xfs_iunlock(target_ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(src_ip, XFS_ILOCK_EXCL);
+	if (new_parent)
+		xfs_iunlock(target_dp, XFS_ILOCK_EXCL);
+	xfs_iunlock(src_dp, XFS_ILOCK_EXCL);
+
 	return error;
 
 out_trans_cancel:
 	xfs_trans_cancel(tp);
+drop_incompat:
+	if (new_parent_ptr)
+		xfs_parent_cancel(mp, new_parent_ptr);
+	if (old_parent_ptr)
+		xfs_parent_cancel(mp, old_parent_ptr);
+	if (target_parent_ptr)
+		xfs_parent_cancel(mp, target_parent_ptr);
 out_release_wip:
 	if (wip)
 		xfs_irele(wip);
-- 
2.25.1

