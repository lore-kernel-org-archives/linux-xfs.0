Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F3AC4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 21:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbiKJVFv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbiKJVFu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 16:05:50 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39103DD9
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 13:05:49 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAL32JP013905
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=dPEzCE01wkNI6LhgGC0QCc4fud3untwFl0IL/SP5Xas=;
 b=OP92+MVxrDb4x0pC/dxu8UFPdSSmv1hKbkGhTVWqosfceNFWhAVvsDvYelmeJyP/SKzW
 ox+vU3dqEJvaiAZ+cHQSpVaykR9ia9bo6DanoUSc285o6NLha5Ge03qf7ljSnOd3OSRw
 3NLuHcfzF5KEzmPGSfHdzjGqeWyRtmk6kHie6nkLKWfvM3fZ16/tDEt3HTJ+JpqFxi/K
 XhYN6/+dg963yMjphYoYq70KvXEQmTSFBbTYW1pHTp+Kd8/GS6c0MppD/ENC/ImgYX1Z
 cSuQ2D+WqLLdOPtfp2JN1C162svKn2YWK5jP9jspLrf4VzY498ZPd4tyg0GJDueW42XG WQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks8vbg083-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:48 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAKeTiW038169
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:47 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcsh4fjb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HKeWFNGMq9+UGvUg4EyrSkcP/AuAwKLLV4ZM4Y7Zna7zahtshUOaqkohpnOd4d9sBaivCnRrX0KPHWSuffar5QzVcsLBGLUPDagkXfOMnkxv++fSflUbMwTrejoL6ijM5+b1vAG8E67t4aE2Y3HTKXSNvbjCAvb5h937fzANOSHgWKpfVbA6bMCR88vghX3V2YLvPOvnux3idL+DBUUTUIuRhAMmKb1NZ///R92xdKPrzo2v7ShRKtiCiNBH4FPHOBgxcwjJkjXqr2vUD9nUlnjKQXrHNCRkdnuh+vVij0836mXrA7u5lTtwOGRl+CHdzyqqS6C+T8n++Qh15TKchg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dPEzCE01wkNI6LhgGC0QCc4fud3untwFl0IL/SP5Xas=;
 b=mTy0mcn9tSQ5TcGBL1fekxWjttPowPUZCtDpd56YK87XVs0NWFG4P6037MaaSNSaO4wzmJKgDBQC9YiTT4tP60N9X4Sw9gK+Kc1CmTtBZTrh9TAJzIzRvrzKpidL6f+w2PEdfRRAz/uvCePl/aet2/H1eM+M3QFj2D7yKgrpFDkVJSX1RvwZH3Hqb8FB+8YdjlgQGSB5qlgtM7sGnadMxyJJJ2Z5EyjYRlHz7YJ/IIWSTDCnlUOMZU9S1UEya0+HVvUVgehVhDNyfeptbb+giPgB1Xpza22EjKJ3leyaMXiXSJ+dsCIYUkfLFUkcCjjNnVIFM1yDw0VEFD80aiwVcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dPEzCE01wkNI6LhgGC0QCc4fud3untwFl0IL/SP5Xas=;
 b=tVK5oU2I0C5ILzcqG+EOvImJjrHVO1X/NByNhEBwRS/9X+LEoXN3IjKUhJadWzV7+Tsf2fdLl3ZOwUY6yhf4m+fx5M+MocFUk+y6w4YWMrAX8ebn4/C9KF2VkYaQfictUgPdQsD7gW9cAJ6Uw5YO/9fLoDHZloesD0Ba65cqm6U=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO6PR10MB5553.namprd10.prod.outlook.com (2603:10b6:303:140::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 21:05:42 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 21:05:42 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 09/25] xfsprogs: Add xfs_verify_pptr
Date:   Thu, 10 Nov 2022 14:05:11 -0700
Message-Id: <20221110210527.56628-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110210527.56628-1-allison.henderson@oracle.com>
References: <20221110210527.56628-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0014.namprd10.prod.outlook.com
 (2603:10b6:a03:255::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|CO6PR10MB5553:EE_
X-MS-Office365-Filtering-Correlation-Id: de970e43-48e8-4590-e72f-08dac35f53bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bKNelsHBcogL5ZNbJxdDR7Y3iLffLernJBU7LSpFp9lnJJDGR0Iw1OwN1b08MptUwv+pIAbwPUCHHa8K9ws8C1MP2gHokxkNgimxPNI90+5jKx/P/8zR76dB6OT567G09tTa0QoOFZSL2Ajn1NZe5xnIkYAP8FQQQlFPw/H5+twcnalfQ15n4pGlnnwQCmc0iVcfIr3y1gjZMm+e1VMaCU+vxeHWYWMNMBn+aaG0IPkwHGYz7wm5+fnL1M221e32y0ji+7ZhWcBYSgzoQ02o8D9V47U+vC9Fg84+hsU4KKfKDXTVD4P+snSVKwcRHwIaSZr24tbuwLga2PFD+efZZxITt/DgAo48KO++6pQzkLG7XbCT0OZ/OAUXnhB78UrmFs88JHm2UCpArAFvci1Gi44kz00oM0ze6vu/FSYKzg48UsbTsTT8FNm6Fp2jUoGTuKTbX20/vkn7umcgejDalVIui0/6vJW5kzYG6k08LL5dkazW0McaonU+lK5hsKu6qcAdnlSTdSKZO7AYTGhWVgNXiEhdFuiPghp91yLxzkrD5Il/DCWGXGUbtKhF5UEi7wCikFx/dBC4c4nfsPmZfa1wxGPb1XT7289y7jkPPFwJSeCIGAKNVqX8T8f4Ebk0+AbyVjaL58b9dSMaakCSbWV9/ZmX+YCdP9m8lJkMEDWNoCgYNR8wbvrchHSthOvG4d7PQxUBaRU0gRFCderhlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(366004)(39860400002)(346002)(376002)(451199015)(8676002)(6506007)(66556008)(66476007)(316002)(66946007)(2616005)(186003)(1076003)(6916009)(5660300002)(2906002)(478600001)(86362001)(36756003)(6486002)(41300700001)(26005)(6512007)(9686003)(8936002)(83380400001)(38100700002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PhJ2Ymmiig1M6bSMwCqzWfzWqZiyGs6HnbD06kHTETz634fxBsT2f2ODPvql?=
 =?us-ascii?Q?/1fLcd/BouZxlWuyhKMkJKWaGj2kID8pDpTttlFGCksHBt+4fE2H7jZjYlsH?=
 =?us-ascii?Q?P3wM8jLSAYo06EflDKOJEiIl1XYYDUZ/kJjgkCwTxhUz2AzIf3eN0FWEGfng?=
 =?us-ascii?Q?3x24h05HnBcvMhNQpbMcQEBMhRWeIIU93Lxdhbzjr0uwpa5oBrkquF3c3UHY?=
 =?us-ascii?Q?JtCm04tscsJ1nhsjJikCDZmlXOxuaEr44dUzkT94Wcz+HzJT7lktKLgfbOpH?=
 =?us-ascii?Q?nJX+AtRDrnkMTe1oYxdwnOaFP2AQQtpbca+4h8eYN8YsbwI9gkYEXseu6+u+?=
 =?us-ascii?Q?CDcfmWxhOFBBiZ75TINWp3TSuUEl8Sus+HeCWBZxJ4fjNF1/SW4cViVAaUQR?=
 =?us-ascii?Q?8aPRYElVECYJRWxdnHlypt/hxuBpIwVCnV4gG0Ai7OhzpJ44CeqoMNM4Nufs?=
 =?us-ascii?Q?kQ7SrFTalW4U+oS1EpjffP+9gY1wBN+ZPYSJrVsgil4rx+A2d/zLVcfXGdQ/?=
 =?us-ascii?Q?PvPI3tWQA/eQ8biRHnWdh9kI17f+UtQptC/luU7LtQ/FtHllkGxJp0UlasB3?=
 =?us-ascii?Q?uApcQnp6WfX4OjV0IAri/dAxLwjALgkKHG3XJlWl88P9x4gaSpC0MmEyZm2R?=
 =?us-ascii?Q?bUwC0IujUHCi+0vygvtY5LSfjay2rc55qMaSlR/k+3cJW4UjB0FXio8ZlMdf?=
 =?us-ascii?Q?pMbQDmvRclkl/VOKAsd9vppaR8TjCp1WaYXfYb1xwitukqv9NHdO6ERLKtna?=
 =?us-ascii?Q?/4h6RjwrYXD44BqT2ITL4GP+E5ogfzMm0FA3S1D7Xu/I9S9bqZViqvoIKVcV?=
 =?us-ascii?Q?cICpbAiytVWNPIA0xx2RK3nzxvKDjzE5G4hgSAO7EB3YLYYP4z5CM81zHVgp?=
 =?us-ascii?Q?BiRLiGYfcJ/jAb4N4acUDMyY71TglkjA3YqeDdQ0/FUyVzgjqS1hyPjVGKV5?=
 =?us-ascii?Q?umnZPGMxeWcsCKKlXP/p14FqdXpGriKcmAWFACVkHbE6Ng5GakrErxDfzCOe?=
 =?us-ascii?Q?dpeGg+JuMX5CJyIuWI6WDpITuJg9cYEOo/4UknX4IyFUJJncEqaCJOrXfFnv?=
 =?us-ascii?Q?55NNScwfptuxH0F7SpC3TaS4WRDdwAV+wbpezySBd6BAOLtsUtgHhieddIm3?=
 =?us-ascii?Q?LXxLxQzDISLqZU7IhsVIo9uBAZdMS+R3KtkSlFYSII/2x/YqZ+XtF3lSC5a5?=
 =?us-ascii?Q?0Dg5DHIzn+WwhGLTp/ObDSWwKWNanNpcicO9w1SKFEBFC9vUgoB4lsAmjPqN?=
 =?us-ascii?Q?g24vWGlRzxCK6RZCX8XhUVqLnnYYLZQMtam1S+83L775tnjmOKYEjQIzcG7x?=
 =?us-ascii?Q?uuP+EMlIolaPed2M4MdVA9OQ0cfs3hQMXWpyp+FYa4Bb4OW7GR7BzfIDsRV9?=
 =?us-ascii?Q?MoJWb+vAokcyTGGA3TUGqx6UzGtKAofPgrOViQhwyq3xR6X6dKdecwvr86nC?=
 =?us-ascii?Q?fP6nxqmCudUzK1V1+mIujCJY7Rg21Qv2SQT3uQzP9QFDloIz80LSXlhsVW8j?=
 =?us-ascii?Q?pd2epRgoPXCE0wWE+QXFxQ+Zqt8Tkx7aN/0EV2cawm4Af+8brpTyiEf8lWWm?=
 =?us-ascii?Q?isaOo4IErAQLOErxARPuRJBUD1Gobz2IbbKEXm1pLXBgjYq9zJpFeymR20fU?=
 =?us-ascii?Q?3w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de970e43-48e8-4590-e72f-08dac35f53bb
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 21:05:42.2353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VnANKCkItAow3npJ+RqIUC3ge+i1gAHSK6o4XgB37bipdmDGmo4GjovZL3v0qjt53OuZYfEE3G9zTuA+6ft98Ul7UpAjjgKCyt33C0PIgog=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5553
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100148
X-Proofpoint-GUID: cxY1S0sp2898uhLQKVG1g5HoPhgZMWHf
X-Proofpoint-ORIG-GUID: cxY1S0sp2898uhLQKVG1g5HoPhgZMWHf
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: b328f630fcee8dc96e0e3942355fd211f8e15a5d

Attribute names of parent pointers are not strings.  So we need to modify
attr_namecheck to verify parent pointer records when the XFS_ATTR_PARENT flag is
set.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c      | 47 +++++++++++++++++++++++++++++++++++++++---
 libxfs/xfs_attr.h      |  3 ++-
 libxfs/xfs_da_format.h |  8 +++++++
 repair/attr_repair.c   | 19 ++++++++++-------
 4 files changed, 66 insertions(+), 11 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 04f8e349bcbc..d5f1f488b4ff 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1575,9 +1575,33 @@ out_release:
 	return error;
 }
 
-/* Returns true if the attribute entry name is valid. */
-bool
-xfs_attr_namecheck(
+/*
+ * Verify parent pointer attribute is valid.
+ * Return true on success or false on failure
+ */
+STATIC bool
+xfs_verify_pptr(
+	struct xfs_mount			*mp,
+	const struct xfs_parent_name_rec	*rec)
+{
+	xfs_ino_t				p_ino;
+	xfs_dir2_dataptr_t			p_diroffset;
+
+	p_ino = be64_to_cpu(rec->p_ino);
+	p_diroffset = be32_to_cpu(rec->p_diroffset);
+
+	if (!xfs_verify_ino(mp, p_ino))
+		return false;
+
+	if (p_diroffset > XFS_DIR2_MAX_DATAPTR)
+		return false;
+
+	return true;
+}
+
+/* Returns true if the string attribute entry name is valid. */
+static bool
+xfs_str_attr_namecheck(
 	const void	*name,
 	size_t		length)
 {
@@ -1592,6 +1616,23 @@ xfs_attr_namecheck(
 	return !memchr(name, 0, length);
 }
 
+/* Returns true if the attribute entry name is valid. */
+bool
+xfs_attr_namecheck(
+	struct xfs_mount	*mp,
+	const void		*name,
+	size_t			length,
+	int			flags)
+{
+	if (flags & XFS_ATTR_PARENT) {
+		if (length != sizeof(struct xfs_parent_name_rec))
+			return false;
+		return xfs_verify_pptr(mp, (struct xfs_parent_name_rec *)name);
+	}
+
+	return xfs_str_attr_namecheck(name, length);
+}
+
 int __init
 xfs_attr_intent_init_cache(void)
 {
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 3e81f3f48560..b79dae788cfb 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -547,7 +547,8 @@ int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
-bool xfs_attr_namecheck(const void *name, size_t length);
+bool xfs_attr_namecheck(struct xfs_mount *mp, const void *name, size_t length,
+			int flags);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index fbebb55b1621..786b942db9a5 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -731,6 +731,14 @@ xfs_attr3_leaf_name(xfs_attr_leafblock_t *leafp, int idx)
 	return &((char *)leafp)[be16_to_cpu(entries[idx].nameidx)];
 }
 
+static inline int
+xfs_attr3_leaf_flags(xfs_attr_leafblock_t *leafp, int idx)
+{
+	struct xfs_attr_leaf_entry *entries = xfs_attr3_leaf_entryp(leafp);
+
+	return entries[idx].flags;
+}
+
 static inline xfs_attr_leaf_name_remote_t *
 xfs_attr3_leaf_name_remote(xfs_attr_leafblock_t *leafp, int idx)
 {
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index c3a6d50267e2..afe8073ca8e2 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -293,8 +293,9 @@ process_shortform_attr(
 		}
 
 		/* namecheck checks for null chars in attr names. */
-		if (!libxfs_attr_namecheck(currententry->nameval,
-					   currententry->namelen)) {
+		if (!libxfs_attr_namecheck(mp, currententry->nameval,
+					   currententry->namelen,
+					   currententry->flags)) {
 			do_warn(
 	_("entry contains illegal character in shortform attribute name\n"));
 			junkit = 1;
@@ -454,12 +455,14 @@ process_leaf_attr_local(
 	xfs_dablk_t		da_bno,
 	xfs_ino_t		ino)
 {
-	xfs_attr_leaf_name_local_t *local;
+	xfs_attr_leaf_name_local_t	*local;
+	int				flags;
 
 	local = xfs_attr3_leaf_name_local(leaf, i);
+	flags = xfs_attr3_leaf_flags(leaf, i);
 	if (local->namelen == 0 ||
-	    !libxfs_attr_namecheck(local->nameval,
-				   local->namelen)) {
+	    !libxfs_attr_namecheck(mp, local->nameval,
+				   local->namelen, flags)) {
 		do_warn(
 	_("attribute entry %d in attr block %u, inode %" PRIu64 " has bad name (namelen = %d)\n"),
 			i, da_bno, ino, local->namelen);
@@ -510,12 +513,14 @@ process_leaf_attr_remote(
 {
 	xfs_attr_leaf_name_remote_t *remotep;
 	char*			value;
+	int			flags;
 
 	remotep = xfs_attr3_leaf_name_remote(leaf, i);
+	flags = xfs_attr3_leaf_flags(leaf, i);
 
 	if (remotep->namelen == 0 ||
-	    !libxfs_attr_namecheck(remotep->name,
-				   remotep->namelen) ||
+	    !libxfs_attr_namecheck(mp, remotep->name,
+				   remotep->namelen, flags) ||
 	    be32_to_cpu(entry->hashval) !=
 			libxfs_da_hashname((unsigned char *)&remotep->name[0],
 					   remotep->namelen) ||
-- 
2.25.1

