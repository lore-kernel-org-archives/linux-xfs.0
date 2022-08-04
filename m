Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 114BBC19F21
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 19:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239031AbiHDTkj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 15:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239142AbiHDTka (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 15:40:30 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC3960F7
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 12:40:29 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 274HbRX8015052
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=siMQJNZfSeWLQlzG5I8xst4ASguhdOApHe0+h3FuF0U=;
 b=LweqgGBgCmaBOSwyiPT+W+ggjJz837rfXjZMazp2wZXzShfufTBzllD3Jk+K2sM2U9Hd
 RGzsP/DjtpKxOToc25jBtmRYRDhVKHg5BmYS0Yfb9MPJvXchhAmRwXEIhyW1em6MbbHG
 ZWigLqKWrj+gOdX0+YkGcD850hq/tc4CaFSOWiXgFX2Na5Tci4aSf/z3XQy1b5j+IdRk
 xKVmUfxfjov38y4jN4O9zuTsuvBGEvv03wP4pJYuKZHuFrjWLRiq4b9/tJ1xqhV8BqHs
 Fb9QvnSGEoTvPOQc5z/bJXJaXVL1Zx03Ika1hzcOm6fBV0WSVQc2SJyxrlRgjIop+sOm Hg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmu2cdn46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:28 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 274JO4XC014188
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:27 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu34p7ev-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bc8Mxi0dmzADU/jpSPMVsoCe4eVwcp29zzqu8dXGDhUJeLBW1pVdAHzW/ucZErUhpmteqeAlVbcqHu4LTqOn5zgxxqCh1UWEzeyKkb9QjlsKMBJiGGogVoZNciZ/L1pLETFszGSPNx/Jqy9s/HCNJ0ru6yi5dyiXDQrgbQR68wLRWASPQ8WOz9Dv6ZU+BnIhIw8tTkpzSYbmYDHa0+gMVHP24fRBAk6ZEBNwzh38GGjPu4kiZnv1cojkLVslGHFuywjRLtPVsby0F76wvVl8dMRNHHb9s055YlXfnWJYCT5ydtu/wtTu8Y7PTKBhjzMNq72cytWM5OgTzYCWo5knNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=siMQJNZfSeWLQlzG5I8xst4ASguhdOApHe0+h3FuF0U=;
 b=kn2m/6wPx9SvVubYWbI/k/yH2FkI+oHs20JBv+/0OB3h+WixPe70lt78IHHV60hh2SCyeQMs9//CR2StCOEkrMFIKQ3V9W1G8x2LTTaCOKqWNbY+q0Hqco7pRZm2dVG3BQL54OTox5LpuBuf+I3jyrBVOXdoHHG8LkXJ+9Jr8rYXTy15TUZvgd9PKq44bbSO5NTIZbH9xqbrkSWmjacjoYQ/uVSyNGKj7BW6dKlEvtoS/3oVTUXDOa8mncFRgwOAh3TBm4bIU5E+gVTAKwEJyQE1IGjoIpnkboUERFeLcj75FNf1uGkiMBe9BbvQHjhWo18+of22loRzPUQcqx34Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=siMQJNZfSeWLQlzG5I8xst4ASguhdOApHe0+h3FuF0U=;
 b=wX52CgcG+Q6slANndCZQ1BMNh/V0RlPyQ9cvadO1KUOtlzlNXWiAIiHfd0EMWCxyxP8/IFqW+K9xr9afhG59yN+iz3bEAJ1N+0Wi3W+jA5/uQUth9x8iaLL6tVjxSP3PUsQ5U5lmHwCpWd1u3V+Z43cVVpRs7S70tlMdKwCjYW8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5136.namprd10.prod.outlook.com (2603:10b6:5:38d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 19:40:26 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5504.016; Thu, 4 Aug 2022
 19:40:26 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RESEND v2 10/18] xfs: Add xfs_verify_pptr
Date:   Thu,  4 Aug 2022 12:40:05 -0700
Message-Id: <20220804194013.99237-11-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 0a03e3d4-c908-46e4-9b37-08da76512cda
X-MS-TrafficTypeDiagnostic: DS7PR10MB5136:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zb4rhIKYIDKDiEtdLytb9JP4Hnkxoy3UYbP/tsvTZdbFmWoB7qTKzs0f5NZmbgwVsjS78cXuibfvS1JE2igZOxS4ndyrW0MSLgMhLgAzqZzxOo6yd0pCZ3YmRXk2F7D68rGd+u5OG+99L4ywLZF4ytQ7dauvjj1oC2ivssVmS+0QZlI8qvu5yY2YbIGYYpaUZtOEPnItnbdyrVI+D2crxnsCcbBf0xVLfVsqlFDgc9FugH42jUVoxQEBPjP+DE8PU50y8m2oPXj+OR2Qw/mt07ZXrOuU+TGNAbYzJ2SRjxPcm5LyTjg/OY4QIPgjXw9k7gMfnUhSLM5mHa6Kz/zQMK1fzdIlG6TcXSG/GvGJDyOXSmbLcG6iTtOzwQIjTABmXC0+GhLCPJBxN5oK+v4iKhyC9OH3iP0dvHl+pSLJEAO4Jx2f9k8yu2j0+bTroj5Lrp7W7Px92Nk4dk+h7UxKkJjlqI4jhwnlRcwbr4bJmk0AXbc5LWfXDETi+9fukgEmTdI3MMB2SkoryX1OLyl4j9blgpahE4+nZC3GAnrG/fdBEVQvIF/i5AUR7JfLOHHCjd3Ri1qA38xrke4zFhqU7dMjb2OO3b/ZXxsOHl7Ejl8c0A6C+3qLwoueNkILqoBVsKFvSrzRztZUgpW57cAyoKkfCYoT0jktqbGbP5e6eEXKwplD2EyQ4/aQ/2MYaWLalXbGXW7uDtxREnizPxJNRs4Q18RsOxH2F93UNFYOBUTi3eBAkywx8ReCfU0ARXSl+uNcYm1sr5yAwXI4iK61WdB+2wapd8kw4z6e7JWLRBQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(136003)(39860400002)(366004)(376002)(6486002)(66946007)(66556008)(316002)(8936002)(6916009)(478600001)(38100700002)(44832011)(66476007)(5660300002)(8676002)(36756003)(52116002)(6512007)(1076003)(6506007)(26005)(186003)(2906002)(2616005)(41300700001)(6666004)(83380400001)(38350700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Fh+CHGDPMna+QWAt3vhXY9ZZ+b3IyuAUNMRiUrGE0s9QVNnLy8m84rAioyYC?=
 =?us-ascii?Q?joZZwjCUQVcC5cnJYyEHSagEBBilJ2pzRAC/e/Gq4DDW4jkKBn7bRcOTgFOU?=
 =?us-ascii?Q?Cy0LTtKBlElak/hQ1I2tMvWzsrw/+31yr6zDvZxbBWyJbTBWciNcLiiZDX0H?=
 =?us-ascii?Q?p95MkR27H5WnV7nXIUlj63WjnI8YyJTL2kb90FfxZ3pCKgzBNkYZ9VErfUeY?=
 =?us-ascii?Q?doNild3BN65jFpXICUOkgkGwtNH/Skqp1jY57/AkmcI2cVk8iiTz/3cbL9LS?=
 =?us-ascii?Q?6qRCmsG9KSm65PGFnFZS6LVQDWoubRSq9CmSS77d77e6nD+kWLvdt0+TyYkd?=
 =?us-ascii?Q?dcZ/EMsvtwhIqRkl4nC5YzMyn9VnUdlVJhgfw2/VNB6C9QyEkE+nAbgW9y7d?=
 =?us-ascii?Q?SzPuVuno8IFpEm1cMDf311ZWd8/9T8ZbFFCVYsAI+GaI1dAKYojT3zFecn7r?=
 =?us-ascii?Q?G7HcsHXmk38MDazzXQrWZIqIQaHJHAUWew4SLRejKPo3Xss3G6SfxohW9cPi?=
 =?us-ascii?Q?sVdwcur55AHRHuhkH7rQ0+pZsyS6DSkCCoK+sjca8XXzWqbymg6xV4f1ir7p?=
 =?us-ascii?Q?xP6BuUN+iswOCi8zNrRhVVxjEMiDGxqdBo7oFi6vjo/J5NXCKSIb8exgCuqf?=
 =?us-ascii?Q?Z0XHWyBa1CNcVXVwL6txZyDLvnA4rGxP+OgSqig8fkQytrf7Ny/wljGQX7lR?=
 =?us-ascii?Q?8lnY6VuhJVRCVcR+MRedu8AHgRwEEMbsyTfZYf5Sidf+14flUdrXLFJgaVjH?=
 =?us-ascii?Q?P+hPiUc3p2yHkKBAncIDgc3Pv+KxTcxkkRBxx+eMJPWgIBV2ph4mshQIfqze?=
 =?us-ascii?Q?n8y83Ap+KXiR/ZludMEnffC/ev4GiAmbgwrVU3QD7tf4F3vtlaPOy+E52Bky?=
 =?us-ascii?Q?ZoI4utXZSxpYkTWjpWmuAYZzHuBA2x7QNyjm8LMdowvG7177m10f272LP+mv?=
 =?us-ascii?Q?Rs/+p9kB9kYcypwOXoNO+62Uv68j1pV0RtIUp9vFR1sSioOrXhBBG9/Kim9e?=
 =?us-ascii?Q?Eql39ldXOvOLFVPSm0Z6rgv3siwQQaVkgr/2krET3QROxeZ0z1kJ5PvmLsY7?=
 =?us-ascii?Q?7TdYbzHZsftYsNAS5DiNCCGWjEHbB8jgwMR94VwQTa29ltyGcPQVD3bbPmfo?=
 =?us-ascii?Q?WmYF12A4xOOsAQ1Av2wFHcc2uKkUPaV3x8sPKIHmJ1UwF2XAfF8gcXQAfruf?=
 =?us-ascii?Q?OZ6WwHMKeIrtVOuaeaV1tQiYwCGcLlvP070uk1w+rtMcW/DeQ55JQpYqv7/8?=
 =?us-ascii?Q?x1OV958jhw6sxrQ6RJ9JD2NXIQcL5Gw8akc9cqS6ipFJ5SZXj406eIr7WIJI?=
 =?us-ascii?Q?K9MEowo2ZhkNwfrrvUNP4/hRqhiLPjT5lknJQISNUq/8NOHy2HBdbfjz8OpT?=
 =?us-ascii?Q?HreGAjjI77Fv5JnhTAWh1/Ib1bvOmxCJj+u7VSrFai+0mygoVxjt1DYNkcTn?=
 =?us-ascii?Q?CJKusEjV3Sbu8UpGCJM19VJbYQpN/rJc32IR3h4pMk/FMUpkxmyAJQW6ZW7S?=
 =?us-ascii?Q?W+hBhyP43DVaVRShzrMBRXNZFN8ZJH1hdFzWXWWBEyPqR65xikuMp0OcdYwk?=
 =?us-ascii?Q?u8LdbJTTQQMGb6fQQ+6rVFjgL2TEiCh4B7p5C2t60uVVyU5MJOiqLbJocfOT?=
 =?us-ascii?Q?jg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a03e3d4-c908-46e4-9b37-08da76512cda
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 19:40:24.5488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 40dsvPdCLBQkJ7I0zf+yQVKk5MDQQfvDl/u/cgUN8elqWoS4HQ0iEt77mqDdoUKWpSdKlAvDV/E+etiQfJoYPExL71Qg4hSCLd47VIsy+0Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5136
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208040085
X-Proofpoint-GUID: 7lne15L7NDkLkFGWvSBDQHUXSz8_YB49
X-Proofpoint-ORIG-GUID: 7lne15L7NDkLkFGWvSBDQHUXSz8_YB49
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Attribute names of parent pointers are not strings.  So we need to modify
attr_namecheck to verify parent pointer records when the XFS_ATTR_PARENT flag is
set.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 43 +++++++++++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_attr.h |  3 ++-
 fs/xfs/scrub/attr.c      |  2 +-
 fs/xfs/xfs_attr_item.c   |  6 ++++--
 fs/xfs/xfs_attr_list.c   | 17 +++++++++++-----
 5 files changed, 59 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 8df80d91399b..2ef3262f21e8 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1567,9 +1567,29 @@ xfs_attr_node_get(
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
+xfs_verify_pptr(struct xfs_mount *mp, struct xfs_parent_name_rec *rec)
+{
+	xfs_ino_t p_ino = (xfs_ino_t)be64_to_cpu(rec->p_ino);
+	xfs_dir2_dataptr_t p_diroffset =
+		(xfs_dir2_dataptr_t)be32_to_cpu(rec->p_diroffset);
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
@@ -1584,6 +1604,23 @@ xfs_attr_namecheck(
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
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 81be9b3e4004..af92cc57e7d8 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
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
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index b6f0c9f3f124..d3e75c077fab 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -128,7 +128,7 @@ xchk_xattr_listent(
 	}
 
 	/* Does this name make sense? */
-	if (!xfs_attr_namecheck(name, namelen)) {
+	if (!xfs_attr_namecheck(sx->sc->mp, name, namelen, flags)) {
 		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK, args.blkno);
 		return;
 	}
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index c13d724a3e13..69856814c066 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -587,7 +587,8 @@ xfs_attri_item_recover(
 	 */
 	attrp = &attrip->attri_format;
 	if (!xfs_attri_validate(mp, attrp) ||
-	    !xfs_attr_namecheck(nv->name.i_addr, nv->name.i_len))
+	    !xfs_attr_namecheck(mp, nv->name.i_addr, nv->name.i_len,
+				attrp->alfi_attr_filter))
 		return -EFSCORRUPTED;
 
 	error = xlog_recover_iget(mp,  attrp->alfi_ino, &ip);
@@ -727,7 +728,8 @@ xlog_recover_attri_commit_pass2(
 		return -EFSCORRUPTED;
 	}
 
-	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
+	if (!xfs_attr_namecheck(mp, attr_name, attri_formatp->alfi_name_len,
+				attri_formatp->alfi_attr_filter)) {
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 		return -EFSCORRUPTED;
 	}
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 99bbbe1a0e44..a51f7f13a352 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -58,9 +58,13 @@ xfs_attr_shortform_list(
 	struct xfs_attr_sf_sort		*sbuf, *sbp;
 	struct xfs_attr_shortform	*sf;
 	struct xfs_attr_sf_entry	*sfe;
+	struct xfs_mount		*mp;
 	int				sbsize, nsbuf, count, i;
 	int				error = 0;
 
+	ASSERT(context != NULL);
+	ASSERT(dp != NULL);
+	mp = dp->i_mount;
 	sf = (struct xfs_attr_shortform *)dp->i_af.if_u1.if_data;
 	ASSERT(sf != NULL);
 	if (!sf->hdr.count)
@@ -82,8 +86,9 @@ xfs_attr_shortform_list(
 	     (dp->i_af.if_bytes + sf->hdr.count * 16) < context->bufsize)) {
 		for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
 			if (XFS_IS_CORRUPT(context->dp->i_mount,
-					   !xfs_attr_namecheck(sfe->nameval,
-							       sfe->namelen)))
+					   !xfs_attr_namecheck(mp, sfe->nameval,
+							       sfe->namelen,
+							       sfe->flags)))
 				return -EFSCORRUPTED;
 			context->put_listent(context,
 					     sfe->flags,
@@ -174,8 +179,9 @@ xfs_attr_shortform_list(
 			cursor->offset = 0;
 		}
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
-				   !xfs_attr_namecheck(sbp->name,
-						       sbp->namelen))) {
+				   !xfs_attr_namecheck(mp, sbp->name,
+						       sbp->namelen,
+						       sbp->flags))) {
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -465,7 +471,8 @@ xfs_attr3_leaf_list_int(
 		}
 
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
-				   !xfs_attr_namecheck(name, namelen)))
+				   !xfs_attr_namecheck(mp, name, namelen,
+						       entry->flags)))
 			return -EFSCORRUPTED;
 		context->put_listent(context, entry->flags,
 					      name, namelen, valuelen);
-- 
2.25.1

