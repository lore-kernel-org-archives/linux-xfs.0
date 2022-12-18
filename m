Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC17C4332F
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Dec 2022 10:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbiLRKDs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Dec 2022 05:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiLRKDp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 05:03:45 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C488555A8
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 02:03:41 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BI4oS7W013418
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=caHGey35nRfvCGaR7VD5GKq+MGhJCdpWWJh7rrbhUVg=;
 b=Na30nVJqvHNKuLCAp78fPKBCULWRZT8a2qhKiIY/vwBoyHq1aTD1PcPWobcrv1jeRI28
 TsdeYQtjJ9+6tJ6NMWr8Tfyd5PH9coEUHewPgslF+kd4Yo3cBANhOaDLrs+0YfKV3T7R
 1wTMgedbRoyDRGqS8LlRTMHxMQr1G3cKsKT0a1fpHQV49I7lISqNOgEon2P6hNX55hyw
 WuPgYr0aVXCpC41SibQOE9FSa3Hp1sTT/OVS4p2GvxDuOdiQp2cuYa8cayFi7uq4eKll
 ZTkrD93ZuZZ95RNg02AAxqs6nCGdVlT/rCZOfEeVL4YZAdE2nZfZps3wgTOV08D0qa7D jQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tms9b9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:40 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BI87lfN007145
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:40 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mh479cbr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YyMLoC0/IA9XZL3ZbVMfM9LQ1n2MhzR2esAWgSS2a8yfoq1vztZ1xUMgowXZ8/y26mVgRm8ZkC/as60LyIQKKY+/cj3JCDZ6q6X7z0dzv6QpLvvsoCC9x9mpMNCEe2ay2LdSkYaquj4lJ1xujmx562TaOs7y/lQey5VPLgFTizvOful9fKYdmfYdND3HAM5iweUnPCaIEQ7J5aHeXiNRIV7CBocrDz4ZN96REsKr3x17j+Wu8VZc1ZFzrLp6cDpWDfI401PjnNtmt99tVzf2nJcpuqrfHcpQzM+6lgVR/k7ujdgIeTnWQzgtT6X8ImqZcF+b8qwqwz/gnmUdXVSL5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=caHGey35nRfvCGaR7VD5GKq+MGhJCdpWWJh7rrbhUVg=;
 b=Eaewh1uUTCPImsqFAApKggM3oFS+DivCmSPaEOBxrys7dK0oHTAY3SX3QbntQovdP4XM967KVbxZz9dNqZVMaGXyb6zQcuUcGyLP81e7V2gKxug2otggmFx5omHBb5NsxfabrYuCldjSC4/HzXUdl9UeWC49loqHlO3n8pCoaKvkAYOJ/9eaOVQxN4E4rEQtJMdXlQzyYpfzG3+zrzIRsMR7+jTtLM1VqFaYm5sZdPP9MBfo7KfB/4dL++A3hOuvdKyTFEzstxU6+TNV0O/taZ+w/UJ3X9e3PW3ZDJ33FNTkj6QETRCVkZQtqXhLsZKqgKiegG9fIIueGswecmhMcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=caHGey35nRfvCGaR7VD5GKq+MGhJCdpWWJh7rrbhUVg=;
 b=ITXDhi3bx/UbpRBeJukWK6vepXsW+kjJgZPbsChTjvpdjzLDZSA0yw3XtpxT1SkAaH86KQxR9h8xjCjI+bEjNbK4hX/sNUsrb+Xavqlj5CedglFhNI/d+q0xCdfwOtdo1mYggUoDkrLeAwWMfWZDzGj48Ot5yJsCfrIWi8Ilbzo=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by IA0PR10MB7181.namprd10.prod.outlook.com (2603:10b6:208:400::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 18 Dec
 2022 10:03:38 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 10:03:37 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 19/27] xfs: Indent xfs_rename
Date:   Sun, 18 Dec 2022 03:02:58 -0700
Message-Id: <20221218100306.76408-20-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218100306.76408-1-allison.henderson@oracle.com>
References: <20221218100306.76408-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::38) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|IA0PR10MB7181:EE_
X-MS-Office365-Filtering-Correlation-Id: 909a0a82-fe80-4430-6058-08dae0df2179
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FB183crl+dzXgw9jDYcPS9kVzJaNh+8oGopMjqSCuho1Yq+GCsGq4mJTyc2BTOIC+7OBeOVi1gsSQWD2fWZ+zhHc4ea+RqLQxBY3JyTWBVRMM1z9JoLpWU1REG8eM+TjNFw6px1ZhLObmz9iTscvOu1BfpYNt0IOP7OWlW98otQKgm0pEV7YL38pPGiGH5JIR8P/O09YyxjdVFjvuWfaOt9gJLGCqE09pxl+ntyYI8BpUohCimCWLxRLHBLQvYFHy5+1VJRoUTHwg6NJaXIwm/nb1SmG2hDOE3FsohP3kj2opY1A1zbndWJS39DnyFJz48jCzepx0eEr2ag4h4Fq0DvLxbEuIK/Anx2OkApTXK59L6KFin1kT6qTp2QRrFL312LQdkcmLpcuLKs48KAB07CxQonQqMRWRN/ONhHSlNBG7+5082TwFw9+hkR7YzSUCx7sVxy6ziPURkD2wTtNP1V2VY5qvOjzWWbEomiY45+GgSocYswsGGAvWGiqRrfKrBxX1pmqRGWi5LR/cqUhWU/TyhTxPfp2vuez4mPu/qr+YDQJZBsDlxLWBLYCJzzhC3rX0sBIp26RgZ0o35HpqBV/4CNB2iorS2YsW7tVITu0SdAIkuaVR0symADtnMWv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(366004)(376002)(396003)(346002)(451199015)(83380400001)(2906002)(41300700001)(8936002)(5660300002)(86362001)(38100700002)(36756003)(316002)(6506007)(6916009)(478600001)(6486002)(186003)(26005)(6512007)(66946007)(9686003)(2616005)(66476007)(8676002)(6666004)(66556008)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hWJlyzA2o3ZJNfjowoYfqrcWuOi8E//TtTbaodZlihFe9e189gnmQ5tuhjOs?=
 =?us-ascii?Q?xqF2af+H6OGvDjQLG5OMJKLPQTZj13wNdIAag7eSB+FXDkBZb+2oIBTEvsiJ?=
 =?us-ascii?Q?BfAXYtJJit0x0SMItN2dKdFaOpjyjehgihDw4EP2dTrRtlQy/0v9tTi2RxWO?=
 =?us-ascii?Q?8JuD3NujGSt40HYJeMqCD169wjZjjm4duZUXasmSbHdA+CCOH3KtNU4ESacC?=
 =?us-ascii?Q?cPCbQir0+7D1OkRO0+ZWD2WpeoOfSyRVaBnfcmml/26gnQamkjG2m0a7SypP?=
 =?us-ascii?Q?li1HB9wXU6XKvO2PX3/GdQGCjvyQ9HGUrO/8JuQhml/aX2Y7Bhus5O8OiIQi?=
 =?us-ascii?Q?E1S3jvzpmtooaFh2Hdex03KSS8UnGu83mIshK294sMlvVOHfEbuvJA6go5N0?=
 =?us-ascii?Q?1xx8yXQlgUDiafHJB9/uKINFxXUG/JuLm+4YVTjUmwqRW3wx59GP8SlEB1PP?=
 =?us-ascii?Q?aseD6oBYqcclVV6IsgDD/riXUCO9dbnIY+l6vCz5jHXuNuhsDJOPUwcJ45ja?=
 =?us-ascii?Q?Cr6idTpdWTV16RCUoLD/l8wSmpQM2nzmlv03VWudDhDNOy8cxii5U3k+nZCd?=
 =?us-ascii?Q?RWOH1wr84XfMV8fqvAQgz4l1DavDMSAY4OuqW23iYgv6nFL4gDWKTZosy/V3?=
 =?us-ascii?Q?DcxLZ/Q42YHsvZslUk1FSM6qzjpW/b04eZTd6E56rxwYfGAfjlqdQ2fsomD8?=
 =?us-ascii?Q?k96qn0fVD/CfOJXAm2tFTQEiUuawNpW5FOKqAj/A0CseSfJmKpbgHRgmg1wd?=
 =?us-ascii?Q?Pad5cAIcIVaTQhtWVL7rpkb+UnNqqh9buTZDbE5IwyeVcxBFHMP4NZywtqML?=
 =?us-ascii?Q?WZUZSXP/+gBNPDSXYrROwDiqcz4jsj3sy8h2tlRYBqirYmEa7BxRajmiinyX?=
 =?us-ascii?Q?G2W47ZKX65WGWsLruZbm50BVwiZ5HqxpnPfuO027SFTHU5kzpoS/BJ4AYg8O?=
 =?us-ascii?Q?dUE5PLZqQEC2CsjLRfDjOoPldfrGFp1yfMxafKr4u2GxnTNqHGJh+uyAMBg8?=
 =?us-ascii?Q?gq7htBTkqpSWEhwANC+gNXcK1cdLhi+s+hTfUhAZxxs5pQEhfp1P++GN91OA?=
 =?us-ascii?Q?XtvH0XosczvSjublffkDqAAXfKHskiiINbipC4to8yKHbr/qgQDXVWkIh6ib?=
 =?us-ascii?Q?4Xswt9DB9Wk1XI1gzSTtTiI5t7Dv9g87T8YC86oUEbWAWWoCtbb2udQXRgPB?=
 =?us-ascii?Q?zgAEFNMzTzbrzmyewdxAqQ8WPqMZr7VBS9fZU28WlZCWrlQ6dOkMODrRRUW8?=
 =?us-ascii?Q?vPwsEpmlRTHfwq7FUfVvxIciyGMHBciE9X74+C8/Tlhcu/HylNqTiq6GnOvt?=
 =?us-ascii?Q?vHWJ8o9KkBhKFYEEuWKfTM3kUJpeyfWka8YHVEsOLmfUjaS8qnzqEo9H+Eeo?=
 =?us-ascii?Q?RNvy9+GWbPXCS5HEgBZfZTLoTQfnxsiXlCe1uXw1QhdFNtAR6NckaTnhGKFi?=
 =?us-ascii?Q?gJ0T3mXFTkgW1AIreqDyyBVmoTT2A4dn6FFJnb6WulOx1EYKU1+ngt9zncL4?=
 =?us-ascii?Q?/FTHDaUPaxVGjg7ayjIYNkIyMagT9DVZOjVYKACNL6qv4QL4GwoCkzj23rMd?=
 =?us-ascii?Q?yqbazH22Vi5jqDBV4/jxxlOxfED13I/JbwtzJB0MBx/yXH5W7xjQceqSRgUs?=
 =?us-ascii?Q?Xw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 909a0a82-fe80-4430-6058-08dae0df2179
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 10:03:37.0746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ug3rumNUWMJ5zmw640gnFl/Auwozt/OmBPyVvI3dZnng8ez87oXNEdUjPwBdVrb36zJBIe7SAwMQPMCzQIpziqbAfaj0wzZC9iYov4O/BYs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7181
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-18_02,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212180095
X-Proofpoint-ORIG-GUID: zohKegcfPMlch488zrYPa7rs4sFYmTPA
X-Proofpoint-GUID: zohKegcfPMlch488zrYPa7rs4sFYmTPA
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
index a53a000a7169..34bc6db0cfd7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2898,26 +2898,27 @@ xfs_rename_alloc_whiteout(
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

