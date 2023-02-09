Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 557AFC636D4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 08:02:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjBIICI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 03:02:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjBIICG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 03:02:06 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB292DE75
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 00:02:04 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3197Pibn024484
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=6V8jvoFTXiqb5KGxOUdyTpyXBvusz0Drjv+6VgVQpKY=;
 b=dP1H9UUFhSCQjlZLyvFwzWsur8QJon2fjpD1N70+csyrFiDchSTVOJeTTSUqHpGOXdjQ
 zQm/F26e2mUDA3EBLNJGiLzP7+8TjQJw8zgfeeqsBOu00n6NRXUB4gZHColoBLMDbANp
 bsV30yygfYXjiI+opKlud9+Q84JIplmm91g1eOPq8DhDnvyxaPpp0UU1aPK+lAilnhfn
 czni70Qa+k03IP1rYUu9BIiZ76CiqNGgv2w4iDZgIGnl9CPrQkNF2gwWcj0M7e0Hvkul
 gp8RTToEkxw4oKGhLO7bGYNunOVPxvsX6WL3jgdGdN1pvZbkU4YSadTbbf0c9ktq1beT 5A== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhfwua2kq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:04 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3196MXbj036346
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:02 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtfg3t7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JCrDMw13j8OoKNxSvCL0A4W3EVmYs88jS/MAaRyPumpiao4v5Dw/hzWLy+sfPE95GBypQmZL0n4MDSNWJGnwT7GEIe7fvX2k3ZyOR7PO8tJAl5Xf+t0Noccr4xh/JUWiEYos569j9g2oBPmNUyFiY1ENqZ7hSgrcq291Z+BXvYFc3ZQ4JJzes4hMJq0kG9jBNhYDeKDXdm4y8BQbUIMDqwXVckHx/v0f9RwiaMLNFM8kZChhBLlV8rpS0opEcg8/zBluRspt2uJPHqwtYhgJIVO8ShatdbRe+bV0nzdXlStXchqgO4BWdHfd2ocQYHSc9SanvqLLjRGiAVyWbCcz2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6V8jvoFTXiqb5KGxOUdyTpyXBvusz0Drjv+6VgVQpKY=;
 b=Y6x+Jp9JwZmtV+EocTP/uliIYbtZPSkG3Yvi0lTjjWR/hYRIWJe+kgbfzloTemYQgm421OTCmsw7vBPBYLpvxeSr32+2nue0pjbHRgl+dSoP0jFL43RhQvBU5Fv1MzHDU5zeULqFVR6miAtfxNxI96wPUGkDp+fuMDO0TaQbYX+jXQgSVqjVEdJxT73ON/jmDk1A6sgXl12Ij6odlmxBI4qi/yuii1aZ/DGy2IfOyGA1ITI35pt7JIlKuosZmB28FVFofoihe4poZUHTh4F7j/xZqnEY8O9fbPyK/n9CPUKKzRynDYQd4KyjPL//wAcT8ozcpA9D7S1FWsCI6Ep3RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6V8jvoFTXiqb5KGxOUdyTpyXBvusz0Drjv+6VgVQpKY=;
 b=FFVGjw+7f5pZgHUvWy4MXhPlbcgRiabBC8Glt4DyHlJryVuanwCMbWH/o8Je3INOQti1gT5+lV/PbkvuTP6GW8YIWejWc94Ecz1DnYrEwiwyF4RwJZdUJx5j4I87+fnxGnngn6lxHJNiL8yeb5gd4QADGdEg9khDKE/GpQ++Yik=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA3PR10MB7070.namprd10.prod.outlook.com (2603:10b6:806:311::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.14; Thu, 9 Feb
 2023 08:02:01 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6086.011; Thu, 9 Feb 2023
 08:02:01 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 07/28] xfs: Expose init_xattrs in xfs_create_tmpfile
Date:   Thu,  9 Feb 2023 01:01:25 -0700
Message-Id: <20230209080146.378973-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209080146.378973-1-allison.henderson@oracle.com>
References: <20230209080146.378973-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0031.namprd07.prod.outlook.com
 (2603:10b6:510:e::6) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SA3PR10MB7070:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bbeeb98-5d4f-4063-2f7f-08db0a73ecbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f6wyH2O/81p3Qy9lshVKm1R9Jarf7jU8Zt2cov6HiQWRHrygiM1tYPHhYUks1UJ4wPE7rH+azrowZXe5F4heDI30TKpmhiA5xvdUtGWHFbJl+Ut+E6Sn3zbuIV++9EuvWTLEYByBCaPT6MaAN+59ALqqzJ3X/vbkqJ/Zh3kPzQcznbm/o3Lq8U0ETmE7ZZd8+FZyJOjA/vFQcgDe8iFNtIijFauwVJDJa2GZwnMOIWL0WBSz+QQowMEGP9SbP7Xw+ryXvxd0IUvnaN3iz3NgEuPy3QiJDWsf3gmTHqxMuK4xscokLWO47nMj0eqCSzzAqJPMsgYWlx3ijoWV4nA1bAQCtX54s7uGqXnx9OGm5lxAKzxQK682Q4Yw2RboHMZTh8496g9YkxsVnZDLPMlc0DRqINOqgA2KiPN0+IMGHzCQNtcQN3sbomZvNREwZi5uS3ATqXyYHCwythIfmOFyNQcc+Jtw3xBmDJztKh2McUgKeNSRzLfzTGnPg0z1wMbm5Qh08kGPyv2zjiuGmYve694H4/jgVyuWOzPH8bpKE3/8y00LGUw8WBORnDTebvNTJ2B1wBQaMYrmY3FNVDYoP8ExgH4avs0NDve10QtRyT0c5O7wcjseT1Dly02UHUBc1yXMnLvdtsSGh+kIcyatBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(346002)(39860400002)(396003)(136003)(451199018)(478600001)(6486002)(8676002)(83380400001)(6916009)(66476007)(66556008)(5660300002)(8936002)(6506007)(1076003)(66946007)(6666004)(2616005)(9686003)(186003)(6512007)(26005)(36756003)(316002)(41300700001)(38100700002)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dUgEbriIGWKMF3FccIUcncvfc7WP8gcuKCNaKxX8+dT7MHLYHGOLAsfvnhTs?=
 =?us-ascii?Q?MZ50YnkRhKlqY9dcu9IaCPLWZYhf0WMjgRoqzyFlfgAa6B0ucHJ+PS3Jj4gP?=
 =?us-ascii?Q?LvNHWE01zIwZX8ZNbQslWaNUsB1frzbDcHibJcQDJ/59NsGdYIL8Cv2ras7z?=
 =?us-ascii?Q?CIXfG7uuuFwsj2ANhVAZqiSLNSADS6Ozh7+t4fPdGSIWAGEmKTBiuG09N9aU?=
 =?us-ascii?Q?qJE6eFo/TDIvAn7zLPO/+3vfAF/AvDJXDFtGH/JB4UnGuKlmhpjw09SzeJfi?=
 =?us-ascii?Q?jBnJG3VJHmqQV2YtVQmGJSZNAG0RBiPSDsSjaITEE1QAzpnK8uldOBydTZHF?=
 =?us-ascii?Q?sUZJ0LxQX93ijFBYDtVxb7dW3iXPN04CMMhIy722h0XemK+asvg8A4ER/+MK?=
 =?us-ascii?Q?6VkxtV4nYl3PvPvGuFMiYXJoScELFiYWZOHXlz4wuXAHbCY+ZCaYrxa+cMX9?=
 =?us-ascii?Q?2jjIbIL+uPOdfJwpKneyt++mggAc96n8QwBSzoQ/799WQLKh1ViGO5OcfRoG?=
 =?us-ascii?Q?tu+uha+Y4M6BJk2RikHhaw+Iowj+wU1ZJz2nTfeY+Cb/NtHfwtjBgd6T9XEu?=
 =?us-ascii?Q?q474At4iwbZIq2uR+kfFmuYMvhT+y+A3FdvUvYXTiRcnejJvujFJUZmdbprV?=
 =?us-ascii?Q?fTrZUCApuD6aecRUcx5CtZAgUL8M8YJOlQrluh1xZaCwiV3pKrAZguUGkODd?=
 =?us-ascii?Q?0js6ZNwQAQp4wlH7WT2dCR5AlC3ett23a/5yzE6ERt3IbzuEO+fjOhqFG4kE?=
 =?us-ascii?Q?9RRHoP4t3Vl3Y20qOeQHhr2H22NirvIrDj1HfhVM9wM5F1p8XXeQ/ZzNJ0UW?=
 =?us-ascii?Q?0aXBa87UiGiGo7pRD4v+KBdIHSWyMttOt2rrv9F8XcggiFdwXPAIJ3eyVOl2?=
 =?us-ascii?Q?I2YtMOeLiwodjbkQHxy2C4z2yiLdCVyHNBptWRG1PK3/uuiTVfg8qy06M4n0?=
 =?us-ascii?Q?sUzVxsnZGK1zHIonFlq97Km12Dml2vE9qPDLsxpCultpxNC5kjIz/Y+fJT9O?=
 =?us-ascii?Q?5yErhaZ7YFmKSw/UoC/RmlXmFgJeDP+grka2RPyovBK73N5c4PnTD7t2DSgs?=
 =?us-ascii?Q?EKOVDSV9Usq9OlLj4wVRHDMtGrhgIfnoKkag6RiYaPbGyd3OAu8JMNe0JvW1?=
 =?us-ascii?Q?a+0fg1hKwIi25uZ3QWHmgvzPX6qer9hzgDuQleWAeKE3swdVINDypjzilPsX?=
 =?us-ascii?Q?gWphm97BqUnRHL87Nx5f84ot9c63FF2GdUHWs0g2ZtFCBe/IIIUuh3FTRytu?=
 =?us-ascii?Q?hqQ+WKKettv9uNJeWuevnAeloouxgbfKS8R4uMPQAvxorRUAZS+rNj3Sb5LI?=
 =?us-ascii?Q?nugkDOQI3JJJVPsC+RZkfMbYOtdTMhVQZphWBGE4bMn+5Wby3yu0A6beoFaj?=
 =?us-ascii?Q?wEJDfcrSii5FO9zlqLN7lXKh2yHxoXhu80UkRRwx71FAjwdi53j5XHtiwLRm?=
 =?us-ascii?Q?CIJPATy4sEQUPnyjX31yi4WyzT/qvyvEMNWMwIxDR/yKbHsnGZW5D6oow8Ct?=
 =?us-ascii?Q?o0MVY7ncSb6AgIFrzDbqlzCqy75xQP0fKQbg1CL+pK4VrC1slQ7B4uvB2u92?=
 =?us-ascii?Q?fbo3u21uwGkSjKXMLWk6xArHr05vWG1r2mfBVF9JvI2DVt/c/5gAgYPQWEbY?=
 =?us-ascii?Q?gg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: eMhRG+02in5OGtJDnRvu39flJtQRx3N+vH3u1gdusiWNXoqGZgCD9vQYIF4GJxxDL5YTAVJmEbvVwPkufU5khdMcEb53/Rbgtu7BZnkuPu+9Ln15ZaRBvbk4joThm85Fjgmcfr1fZ14fi0qPh1VF9sISzZ4ixT0l/v6u6kTmmAzdzDm9/T8zF5Ysnis35B9u8kmoJW1yNYLAYIWutC9JcXIQnyCWJIhix9Hp45PteHxIpIDiQepktZpxDwRitHnH1s2bQFUww4iPK+HQYFKgEkFz05fQO9XqcvVE0Tiy1WlwlDpr7xvKQCJSW6sgtaGGEo+Y/teV5itwuEwva98yHDimlO1Te3oikA3dXxIit9RMh4LbJdrqaMMe9rveM9N48F03wHEuLhE1GdyqIcRdnhT8+niVUKSWyAXQWGpMAHr1GsOpr7x1KrrL0e0VeiQzF55aQ8Ard2zqgKNBDu+eKSfVcQquyjMsKaNjWLrwuRKg5Y7Hr+Hvi3wAO7oUoM5pSBn1x0dhjxFVKzPj16oe8HbZn7gL0e399QFSOr99Gxr/hr5D6rfMb0b/5m+IQAcEfCtP6rMnUKkjZXnVlBSdbNeC3pO+uYO6Qq80hcW/NtJ5DlG6OulhPKyvj1ZhGsEowMfxHBsGJgDe77hzmmPX5KMtrtkf2h1SpdiAvFeAyAN3o3sJ2nyL+93V/6jbo7jublXKbs6STBvMb/L6MsHIRFiA1rLJXdDaH31AGbmYCrLgy+E0Q3r1t7oh+gugHNbt
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bbeeb98-5d4f-4063-2f7f-08db0a73ecbb
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 08:02:01.3982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f/1lGvlDLuCQdXZ0oLxKfr8OxnSozA/ySMsTHeKR23eQqjdfc9hkIjcbZuusdgI3Ewjd4e+dqc3Xb9uauCgQai9AFsRTsH7jafZ+LnapDTE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7070
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_05,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090075
X-Proofpoint-GUID: 8PhwIzMnD7Rc91gTVNcRXEvzPufKV84x
X-Proofpoint-ORIG-GUID: 8PhwIzMnD7Rc91gTVNcRXEvzPufKV84x
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Tmp files are used as part of rename operations and will need attr forks
initialized for parent pointers.  Expose the init_xattrs parameter to
the calling function to initialize the fork.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c | 5 +++--
 fs/xfs/xfs_inode.h | 2 +-
 fs/xfs/xfs_iops.c  | 3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 131abf84ea87..267d629a33d9 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1109,6 +1109,7 @@ xfs_create_tmpfile(
 	struct user_namespace	*mnt_userns,
 	struct xfs_inode	*dp,
 	umode_t			mode,
+	bool			init_xattrs,
 	struct xfs_inode	**ipp)
 {
 	struct xfs_mount	*mp = dp->i_mount;
@@ -1149,7 +1150,7 @@ xfs_create_tmpfile(
 	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
 	if (!error)
 		error = xfs_init_new_inode(mnt_userns, tp, dp, ino, mode,
-				0, 0, prid, false, &ip);
+				0, 0, prid, init_xattrs, &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -2750,7 +2751,7 @@ xfs_rename_alloc_whiteout(
 	int			error;
 
 	error = xfs_create_tmpfile(mnt_userns, dp, S_IFCHR | WHITEOUT_MODE,
-				   &tmpfile);
+				   false, &tmpfile);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 2eaed98af814..5735de32beeb 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -478,7 +478,7 @@ int		xfs_create(struct user_namespace *mnt_userns,
 			   umode_t mode, dev_t rdev, bool need_xattr,
 			   struct xfs_inode **ipp);
 int		xfs_create_tmpfile(struct user_namespace *mnt_userns,
-			   struct xfs_inode *dp, umode_t mode,
+			   struct xfs_inode *dp, umode_t mode, bool init_xattrs,
 			   struct xfs_inode **ipp);
 int		xfs_remove(struct xfs_inode *dp, struct xfs_name *name,
 			   struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 515318dfbc38..45e66c961829 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -200,7 +200,8 @@ xfs_generic_create(
 				xfs_create_need_xattr(dir, default_acl, acl),
 				&ip);
 	} else {
-		error = xfs_create_tmpfile(mnt_userns, XFS_I(dir), mode, &ip);
+		error = xfs_create_tmpfile(mnt_userns, XFS_I(dir), mode, true,
+					   &ip);
 	}
 	if (unlikely(error))
 		goto out_free_acl;
-- 
2.25.1

