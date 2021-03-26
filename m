Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B53A4C433E8
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93CB461A46
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhCZAcB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:32:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56870 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbhCZAbt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:31:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0PMYO057917
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=JZ0gj0rJsZ+GxKmzl7PpaMqUcQWoH+366YTJeQKNCpY=;
 b=0eHtziw2knFVQBvlaVggCapQbitqVIDGaeH3F8i8PhmUB+VkwgkU4Sx9MM64z/DAJmaE
 FpMztl5zwpVkdod1xD5sxZJmRnZ6PiF3dauohy/C7eCTqqVMmRdaGXy6p0QFqWafavYa
 xALE4Bubrc9onx5zzi6kW4ef/G7u9sr8FIM4hrrjcx6xSdA9rVJRyYWE1ipjlxCgzkUV
 gV41jZ/ckPkaK5da0sBB5vf+61Rp7FpcW366pEFZ0D5TPVRhZpIMj3EPZUWtob3XKlyO
 CMffnavBHe0YTZK6NlBR94/DB1YeAkFV2XsnXRscPIWQPMhJXdoZuk7ffmhZEukLdflN Hg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37h13e8h43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0PK6P155451
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:48 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3030.oracle.com with ESMTP id 37h13x0454-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FEYEvbaNT71Pc7TD/yEfSF1+j7oHLkqTsmvYYrUiLr43qhkQJdYAdLYhcgkDRxf7liZeNgsT7xXu7aeYhkHckIj6gfhIjN0jzgKI1U1tRP+ffPP3Jj33wcPJcEwM8BsTwIvEA28nRofcBtERI2BrC2M6QeMVsqz60KLmDdVvvLiG0r2+SpOCfm3iqIQjwAJRlV3wXlUuPYUbpXfU4maQwVgdVfoGIymp7gqa8sE1/Gi8MPq3oKiH0xu2MUxIRQiZ9hBOocALywEgKBEDTKBQebH/4caCFZMTeG+ERVNF3Symz+OqZ+nrqy2abFaYHFPUPkqm+HP91FrbFIdBJeKx0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JZ0gj0rJsZ+GxKmzl7PpaMqUcQWoH+366YTJeQKNCpY=;
 b=MLwikpwe9/yUOvNR1LyaLSlGagP0ZzzXol+RUyixq0FylOk5F67hJa9l+OThhLFsUiWFDsXA267MYse8jzq/76MASxcPeRfbFLI/rZfjEZSIcQ8kboqwObOFuOnRgq6tOwe+vBFgNXnyzWt4H6xCi+ZNgvWuwzpQYEePxLyFQNvPL3juOP1pE/wKzlzcLJsxtRkf33zK1XUR6Ydh2fOshapLq9Gkr5Ikxeis/CeUVAg9TbdzJUTre9MX1aKgrfbDhTMDis4ndHbh/d72icf91ff4RrVnpDOnUlLOiEeDsPPX1d+AHDuPJD9o8GQMlqvxA7atcOxq8bjJNWBCb2MDMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JZ0gj0rJsZ+GxKmzl7PpaMqUcQWoH+366YTJeQKNCpY=;
 b=C0JZngpnqBaR1dgyBTyv5Z/LrFVdeII7MRXEE4IbYHk1EB7HyfxJ3ia9aqcDx+iiW+/m7lnVI5bfGMDFv1kJGpd+QIml83T/ONCpAHEpQ2DFXYEdmbf1Y11nd0Ln2zBNKMGAnevlYD3iLJZ+XCURVSILTcl6i5PA2kNpf7juMwk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2758.namprd10.prod.outlook.com (2603:10b6:a02:ba::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Fri, 26 Mar
 2021 00:31:44 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:31:44 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 08/28] xfsprogs: Check for extent overflow when adding/removing xattrs
Date:   Thu, 25 Mar 2021 17:31:11 -0700
Message-Id: <20210326003131.32642-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210326003131.32642-1-allison.henderson@oracle.com>
References: <20210326003131.32642-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR07CA0078.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR07CA0078.namprd07.prod.outlook.com (2603:10b6:a03:12b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 00:31:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38f32e40-c092-471a-e2d5-08d8efee888f
X-MS-TrafficTypeDiagnostic: BYAPR10MB2758:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2758F1A1E1D3DF848CC8B4A195619@BYAPR10MB2758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:549;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fIGLRxi63RwXtQC7/mVwVddiFQFWKscwEIwSv0I/kGXPrREHJHRtWjreuVN1120Yw4TodO2R4GvYFNL2jo4apsvk/OijugKSNYtMg8WVYqLoAYW6LI0AkZDkuBaodf7e+41NcpcSUfoweSOxdMAjIYRfGzxogZUg4/PpmmK3qCvJ7XMY+SrjIqlLHecRa1ELCSmqI1CA8B7vDyEVggSoqLv7knzgbk6wyEokuw7oE3ZiEcwg3gVCZ3eioIgKQV6OrU+aBtF/GWjiCq0eUfEJJOYI7VLNYKaMUcTo/Q68VezE44PPaEB3mSVmk/ieHEzKi28kCN/cYNkEc49MK/3LuV8IsI2d7/AXzuoIMAHL3r+VHn+HO28wv+RYJzAF3Y4TQGLOFG4gnaHw5xIHptEY6EalN/Y1jp62iBKcHaR58q0T/3vkLROJcqITAh+dUGRAHPalXTXHX7JLlbMg6FIVtvSmKP7JNUqs+zPJa3MZa3GVn3CmB6f4nsP7gjdRr09MfNzBDnjBrBE3EBeHA6oi+7Lz+zOVnx2l1t7aRhao20wDDxuFLRGuZY8VD25MxAbrY1csrpLeF5m3YPQXZ67v2qAMkospR2smZnpXCtPociakxibbIwNfOhG7ZiUsPfbULxRxCCRr+n5g3134CNeIJGN3SbsTUdsmXP3mcVWR2HncvqGIm8yNruDEcO2puJJ6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(396003)(366004)(136003)(316002)(6666004)(5660300002)(6486002)(16526019)(478600001)(52116002)(8676002)(186003)(44832011)(1076003)(8936002)(956004)(2616005)(66556008)(38100700001)(83380400001)(6506007)(2906002)(66476007)(86362001)(6916009)(66946007)(26005)(69590400012)(6512007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?j7vpYuwxt32ZHZGruISeM+4o0AddaMHCgdmji9tasIxMXfFwgxyH4fcCS51E?=
 =?us-ascii?Q?PT4ABXVa4X9mxUxm+h+qaqCvFL0cD1BFA0mEtMpMJ0T1Yj8hjuBPLn/7Q99S?=
 =?us-ascii?Q?vePRyXEx2wSxLXSUMToWGk8uUWg+KkFitIK/Ijp7QELc5HwODIuwGJcNr3FK?=
 =?us-ascii?Q?0IUZywuOhBPsSs8z3nTq1f1wavu9RoTzA78zt7YOYhVlHLoyddS9eFC4hh+w?=
 =?us-ascii?Q?YWEao/dr+mnKJNLQVoXAeFPKz+by2XW7V0eE+XZ6o5iIzSuWLcGiWT66wPvS?=
 =?us-ascii?Q?SU/dWhDLJpTLqUfGeYbjX6JU2mKN9SDBGA29/Kurl12VxiTyZBTBT1IxRgPL?=
 =?us-ascii?Q?s8JhVQ8ZD8SqV1epAPOH6kWXCHs0oLE0KbXa7W4IY86C5FmMPTBcbsRWgmpV?=
 =?us-ascii?Q?ISdfgMd1P7JT0rEukD6viVbGYBKk6Nz0lmuZXn5HIFTPGpOYBTJ9nYSA1OTM?=
 =?us-ascii?Q?bsPgYfGvROJaSWvODv4FWRG7V771Y23BZanMziVRxYUg0iSFfO8tjHBgF21g?=
 =?us-ascii?Q?C3EY8ZA5fEujnYz4XjEOROeFFQA3UTIkxlGIg5NTASTMNB7rpCJFxbxC0aUy?=
 =?us-ascii?Q?zWuSM6qmKkl187RMankYcRQ3sSBc3fxHsJ9I8R7gjUFgqD/c0wor+n8aBpPB?=
 =?us-ascii?Q?JqaiJz+Ivffp0e/8MNqN38RuNVRYkhKpPCkzLZ2g4og9Xw/AQ9Z7SpAyMJIl?=
 =?us-ascii?Q?udrRBGt+EUeMznyipg71TdrZ1iBvwfVjP5HI9xkWmQzMmkGvVP9b4hjRz0UT?=
 =?us-ascii?Q?jzab1xBzISgjonXJKFUqDaiufMgkdqlFi9cXU/a3HQyQYv6M4h29Wnvh6E0c?=
 =?us-ascii?Q?jbhVzba6En4sUZITE0G4ls/QwuxJijjPsa5+LaMGh3K+1YUrSKyhc0nlk0H0?=
 =?us-ascii?Q?u9t19NAEiB2kdudbMeq3EOvN7NAj4fjGR8Rg61j5EX9Ua0PUpqAllEHPcI78?=
 =?us-ascii?Q?/TTnm4VD+19qseBoMsCIxWGpnBZ3y0A5O2kMxdxES0SogyapwwNBg0tU3mdm?=
 =?us-ascii?Q?e6R1tqoBYSwDjT08vOdNnMt10VWS2WrHj62Wp4X139a1u5U0/wDCvRq8MLoQ?=
 =?us-ascii?Q?KmQJicgtUuCeK3fb7oOd180+QZfisUcNMonrrj1vQIy0ajb/JooGXad4QWW6?=
 =?us-ascii?Q?E05ub4TBqSHxzESvbcHnJ6cNS3bgxq4pI3pP0niVhPvmgr4h/sikP+U+5VaV?=
 =?us-ascii?Q?Jz0ETRpdIdSiRWl2zzIvta0mB34/4UCewg2AHZdGgtQN3cm5PhSVfo08oiqW?=
 =?us-ascii?Q?pu7KJCJZ6hliI6Qs9eINqSRKTi1TRyrgBT98HMtCoFX0JLerPkmxB01X5hN4?=
 =?us-ascii?Q?MuT7y3qLqgX+9jmDiM10iJuX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38f32e40-c092-471a-e2d5-08d8efee888f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:31:44.6645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mIHU1g0kIt0jDnSb+nZkk+GPmrnyPq/keZEx1cSRH5lJw/K8dB0+8xeYQD391AH9nGPLvg/MYQaVejrF+s/tcpsqHs1BtbVXp6abbSkVOJw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2758
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
X-Proofpoint-ORIG-GUID: wngiGdA6499B-N6sDTgZfUkWxH8vTUTF
X-Proofpoint-GUID: wngiGdA6499B-N6sDTgZfUkWxH8vTUTF
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 lowpriorityscore=0
 bulkscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Chandan Babu R <chandanrlinux@gmail.com>

Source kernel commit: 3a19bb147c72d2e9b77137bf5130b9cfb50a5eef

Adding/removing an xattr can cause XFS_DA_NODE_MAXDEPTH extents to be
added. One extra extent for dabtree in case a local attr is large enough
to cause a double split.  It can also cause extent count to increase
proportional to the size of a remote xattr's value.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c       | 13 +++++++++++++
 libxfs/xfs_inode_fork.h | 10 ++++++++++
 2 files changed, 23 insertions(+)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 0c75f46..237f36b 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -396,6 +396,7 @@ xfs_attr_set(
 	struct xfs_trans_res	tres;
 	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
 	int			error, local;
+	int			rmt_blks = 0;
 	unsigned int		total;
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
@@ -442,11 +443,15 @@ xfs_attr_set(
 		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
 		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
 		total = args->total;
+
+		if (!local)
+			rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
 	} else {
 		XFS_STATS_INC(mp, xs_attr_remove);
 
 		tres = M_RES(mp)->tr_attrrm;
 		total = XFS_ATTRRM_SPACE_RES(mp);
+		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
 	}
 
 	/*
@@ -460,6 +465,14 @@ xfs_attr_set(
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(args->trans, dp, 0);
+
+	if (args->value || xfs_inode_hasattr(dp)) {
+		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
+				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	if (args->value) {
 		unsigned int	quota_flags = XFS_QMOPT_RES_REGBLKS;
 
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index ea1a9dd..8d89838 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -61,6 +61,16 @@ struct xfs_ifork {
 	((XFS_DA_NODE_MAXDEPTH + 1 + 1) * (mp)->m_dir_geo->fsbcount)
 
 /*
+ * Adding/removing an xattr can cause XFS_DA_NODE_MAXDEPTH extents to
+ * be added. One extra extent for dabtree in case a local attr is
+ * large enough to cause a double split.  It can also cause extent
+ * count to increase proportional to the size of a remote xattr's
+ * value.
+ */
+#define XFS_IEXT_ATTR_MANIP_CNT(rmt_blks) \
+	(XFS_DA_NODE_MAXDEPTH + max(1, rmt_blks))
+
+/*
  * Fork handling.
  */
 
-- 
2.7.4

