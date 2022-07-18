Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58884CCA481
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 20:20:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235353AbiGRUUl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbiGRUUg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 16:20:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F1D27FC1
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:20:35 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IHcQ6i008091
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=N49A7sfQSuou44N8vGldnB1tZBot+KCgxOMxLzq5p00=;
 b=o3EUBSYWS/emqllQwjCc4YBO1e5n6mhyvnT1nZMUaidkRhmUAlC9tz7YAiXfhkDLN2Uw
 3c6iU717a+YmHNWQgVJWpkhdeZg2aL9/XPmdvkezQ0ltZK64LFnCzIytfOg9fmCePUk4
 UWItBt1ZOcTkH+wKN21VbBBmrjlDEMMEcQ/kI9s5CMpnG8FH3uKK6VGJ3HoQ0ndzpswU
 sV/ya6M9iaAtZkGvkIdTrsr9EtD10p/tV7x5A0Ob5d6xTUC7P1htL8IXcxdg52uvfjFT
 tfdwJ2l15j61mci7dcytJJmt2ejXjX9kOvFQsUA9/usmJf13Q7iglDaY6/wfYPUrlQHk HA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbkrc4cvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:35 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26IIp4tB001290
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:34 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1k2sfbn-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VUyVIS0wL9wkm9UwtgiCBRVJ3pjnjUVTLD7Ju4M3vPOAxIom4QJ9tPRrl9Kqn7pVaL0pRFxN2eEFHabQ3zjCUWVuaLf4KEAm9d0c11u+67Nl5HNELUi0h+2ylcl3+fmmfriR2HzTSo7wTUpx0qGavKxQf8pwkBwxWgYe+U2Sv7itK3cvXRwTcPKJserx2CiGJ0uiHCjnC8nRdYPhCNFfLHPivb4oBgmEJT4z37ZAvKqZZ2kWO6KFsYnazf2xrKAJww/7XmrQ+JziSnWVLkD5FUsOFCd4FPSRAcjIYTgKIeRAGNKnJEumwFwKfFW0A8ZaWoHalGb00Y4lFcId2HMdtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N49A7sfQSuou44N8vGldnB1tZBot+KCgxOMxLzq5p00=;
 b=FSs84YlYUFhuxQgBP1osizxrXED7MrfrgyxI1kbpYsJONDs/NpzST9w2+1FrsHuyLZns6y/o5IhbE4372VZCxNP7uAcDMQIRZn5MBurjNZWaKYzkJkXiB9UvTIhQgX0dywvnCQvDHafifLRGEFJK/DyQ/Jw+V8+sr5cYPreHgs39tbNJ4k0OwsQ26PaxFPOnkna3Pvuw8yINeF5irg5NrBoE0y0bf5WDUM7pEonWkOcNcUGF3vU3lw767Ou6dDR/+AgqO2pPk6v6HJVfUOeTL8XNiJ1ZNm42ht5oSiTFiXEtZ/ZNEJ9GxpKFIOkIK0yQX3Our+/mkod3MHtk9K3g4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N49A7sfQSuou44N8vGldnB1tZBot+KCgxOMxLzq5p00=;
 b=wQz2GoW26LNEImMPDOQzwpz7xlzvKg/qfwuA7842iGAFXFBKrGMwKjJoT2DCYzyOJg5EDv0Pn33Vhrc/AOd81a9l7GU6G+fOXS4dOw2heFHDG08A2DyaQ1sTwRH6z+6bQOrJkPaVi7HgOWdIyYbD5gWisbRvViTMkou14vM9abs=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS0PR10MB6128.namprd10.prod.outlook.com (2603:10b6:8:c4::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.23; Mon, 18 Jul 2022 20:20:32 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 20:20:32 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 08/18] xfs: add parent pointer support to attribute code
Date:   Mon, 18 Jul 2022 13:20:12 -0700
Message-Id: <20220718202022.6598-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220718202022.6598-1-allison.henderson@oracle.com>
References: <20220718202022.6598-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8dfe5fe-404c-4510-e1cb-08da68faf661
X-MS-TrafficTypeDiagnostic: DS0PR10MB6128:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mmlqKNH1GuotXDksn+s0HcMKE7XmnMcACTiF25B+V23opF3skgQ9KOS28xDfCE/Enp6++Hn6pgbgE9A3rkROWzZxi3vJIq/2SieLRKbkovx8X5Otue6bxZjsi7j1AXLWrk05ptAUvO9jzXdmG1WzhAL++bYngfwRRFeZkD/YXwZ3fz8H0eBoyFiPhQ3MuQQsd8dyp8c0Kl+5FhvU3BvdoQy2Rw9scnhJ8NvOgmO0Yd+tQaQWpTbMr9JacwdtW5RIiwyn5pxV6qU3zPLRAn2FWUKd9dyNQdtgVru2S4pZbWWiasdgkYuzFq1yVtpROWxlFCuTgo7xl1zSS8DCrJSbBqIFi2GPWbGTLKr3IIxpp6ymuioY9GnDc4lPlBp+ZxHh/vDMSEXsrS0+TnfWDQ7E/FSBzdmW7zJ3DIgbQCjQEmaQgWy/PJIBOqQK7MYNPd7BvLkFLxfHigx8T2VapnN0pHcVwCR73gvB/Pfva9+5VzH9Ph6PU+1j77ktsgOvsPXOybc3wc1SdyM6k0xwZLIHEEVXOseV2K/ZVgwQDyq7O0megxPVNxAx94WyL+qeGYx+groZBiZ2ApZ/3Ws/30SU1RQzCQzFX79naiJjexfWj4QLLr4lzlwm2bKe3UaI0t/I4xvy2+4Qm3e8/D/bRQKEEaWUJNY/OEvP4C7ywEXj75BXiw5KM7jKnWONPM5+Laejm6Bh/bro9xiNErB8tzxIElIt+55OFQxunTGvMT2uZwVwCqCyBypP6K/rZQuAF/+TYc/j0R5UsAM4SXUUHyujzVsf223Bb2m1BLSWfgUv/UA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(136003)(376002)(346002)(366004)(6506007)(52116002)(6666004)(41300700001)(6486002)(83380400001)(5660300002)(478600001)(26005)(1076003)(186003)(2906002)(2616005)(6512007)(44832011)(6916009)(316002)(66476007)(66556008)(8676002)(66946007)(8936002)(38350700002)(36756003)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Kog8cROq4HXWemoFOb5HWpgs7K1USvFLyqOkTt65OzbQK8V+aioAslJTGLw6?=
 =?us-ascii?Q?4ZxtYz6bFrApyIXm3mLb3Bbiu9MXdMddxHcoCXmSHBVnhBi+WtBPjiE32QyR?=
 =?us-ascii?Q?OkxAUUQuUK6wcRF7Pn+NRlhRzRvJCxLtN9sty3sN6GfyxAvdoiu+BGCo4cSZ?=
 =?us-ascii?Q?itLvLSe7uz5OhPX9IMsP9caOAZaX4tukYHYaXDUeD8jP6tsPzrUH61NaKUWq?=
 =?us-ascii?Q?09qjervfmYA1hMUt22vrvPxNCwZYPobOPkNjrcRd1Yeu0ZkjA9/BLPEskmT1?=
 =?us-ascii?Q?8W8ddowpvF1fSWmhbEaZ0ST6dxrX7SBQC7hPDe8J5XgRJ8U8OYhWjshhbWTP?=
 =?us-ascii?Q?DoPkfMkRJiBeiEu6N5fcq0cFnwcVFsECl0g0t41Jlc1LIAPic2ZSEnhmZkPP?=
 =?us-ascii?Q?nNEryrP0+I7B1a2cqfVsXsUbtFXAx/s3Oa1hEok9lfG9B3B+FqOGQqtuofpv?=
 =?us-ascii?Q?SvRgGvsp7/IoJkIyzyK/3lueXWmsGvigXm0Ta9F6stJiNaYbWQ1XtaZTTXbB?=
 =?us-ascii?Q?mRVR+AvYe86HhbXIfume7tkoTXgs3Hji9AVdHqrJUINby6JDUmJnwrIf4vhY?=
 =?us-ascii?Q?4d5Fo5fMh7x0R9OiR75oofmBvBdxow+/aWc0A/nxAsM/wWkOy6B5szMw1AGG?=
 =?us-ascii?Q?ZInwk1EyIRWThNy2MhC+ACjJv2q+EBTNhJefKuYZsYC2YoTxNCjTL1kgqweX?=
 =?us-ascii?Q?c5QZVAJi1AifYW7SCWoI8dtp+VsVo5mXOgaWTp8XrSqkvRIuX5f2uf+lSyny?=
 =?us-ascii?Q?VxeIImI1uCJpGfAMuo53E7zEOYlGG20Fkk/FQzfh2940yIGu6P56XRl7fu6K?=
 =?us-ascii?Q?XM/hpF7/U9CHf+AuQF3jxh2xOVGzHfiLW5cijQM7KXDN7KDZndKCVh1qIt8n?=
 =?us-ascii?Q?OexwhGmybFfMoWt12BwyDRgYPc95ZT2xfKhGdfirbhIU7Z4rYdKMm1Sdx0vr?=
 =?us-ascii?Q?qrOEVrAlFDuUCSwEcERurTRO4Au4HBSKjACbg58LD2WfUvM8Kyg/Q29up5c5?=
 =?us-ascii?Q?kokL/IrnQwyH3ZggmC4BSWq6JY/o/ms6v9lwLuPRWop0CJwxKfXqXm2ZT6wH?=
 =?us-ascii?Q?as6DvhZW423j9DeXnUNhZWMfZwBiO2w+zZN+iiBorB8dqZy4aTdiscJXVU+C?=
 =?us-ascii?Q?kXGlLmpudP65OotPElyZNgfKXLpipDRp6pnXe6sOC5i7Aul0AUBijVFmCUcY?=
 =?us-ascii?Q?/10DzP3fAgUYH9r05nhxDem6cqeQMISH6xGGFFIzTLX2yRZA7eY7qt+uJN0v?=
 =?us-ascii?Q?Ry7yWlhcrz/SodFjGipDtGIbJZSuz1957IPW/mh7d7OxQQqYodEQh5udIL9m?=
 =?us-ascii?Q?83YUQjgvgna9FpJ4f/dxO7qMJ6AjIHoyshjK+zv0vwOsbwBO4WGVXTiXhH+c?=
 =?us-ascii?Q?YIVm6VAuMj/BgsdTQGtSRRydF0PLMacGHHVkuQxdcbfqEDZe0gTKKk6NsJGr?=
 =?us-ascii?Q?OM+j1ux+AuPR7wI2BSgy9e9i7VHfpA8k8vbneJ6p/QinwQfGgK2p3esit6cr?=
 =?us-ascii?Q?QOuEVaHM4I4sXJBHaj3lIq86YtfQIqzA/dgz7gmRa59LKVgqb0UKUUdWs4+y?=
 =?us-ascii?Q?CVTzuNKxl7et5SLcVEwlFbmayUsTSbGzyxAYt4c9nKUBsSuQyicFgMZgkp4D?=
 =?us-ascii?Q?Hw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8dfe5fe-404c-4510-e1cb-08da68faf661
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 20:20:31.2475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZDRDumTENgX4UB0oJCtgLgUJeUf7K9lOGDWboCsjGR5ijZRzzKh0cVecT/PzvNQWPI3oAzifl59I4RMgXSN6pK9MgZ/FQUN7Q1VUEy0MO6Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6128
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_20,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207180086
X-Proofpoint-GUID: V4Nn3z1T_fAJd79IEC8LmSk9Z4ZYg8Cg
X-Proofpoint-ORIG-GUID: V4Nn3z1T_fAJd79IEC8LmSk9Z4ZYg8Cg
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add the new parent attribute type. XFS_ATTR_PARENT is used only for parent pointer
entries; it uses reserved blocks like XFS_ATTR_ROOT.

[dchinner: forward ported and cleaned up]
[achender: rebased]

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c       | 4 +++-
 fs/xfs/libxfs/xfs_da_format.h  | 5 ++++-
 fs/xfs/libxfs/xfs_log_format.h | 1 +
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e28d93d232de..8df80d91399b 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -966,11 +966,13 @@ xfs_attr_set(
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_trans_res	tres;
-	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
+	bool			rsvd;
 	int			error, local;
 	int			rmt_blks = 0;
 	unsigned int		total;
 
+	rsvd = (args->attr_filter & (XFS_ATTR_ROOT | XFS_ATTR_PARENT)) != 0;
+
 	if (xfs_is_shutdown(dp->i_mount))
 		return -EIO;
 
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 25e2841084e1..3dc03968bba6 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -688,12 +688,15 @@ struct xfs_attr3_leafblock {
 #define	XFS_ATTR_LOCAL_BIT	0	/* attr is stored locally */
 #define	XFS_ATTR_ROOT_BIT	1	/* limit access to trusted attrs */
 #define	XFS_ATTR_SECURE_BIT	2	/* limit access to secure attrs */
+#define	XFS_ATTR_PARENT_BIT	3	/* parent pointer attrs */
 #define	XFS_ATTR_INCOMPLETE_BIT	7	/* attr in middle of create/delete */
 #define XFS_ATTR_LOCAL		(1u << XFS_ATTR_LOCAL_BIT)
 #define XFS_ATTR_ROOT		(1u << XFS_ATTR_ROOT_BIT)
 #define XFS_ATTR_SECURE		(1u << XFS_ATTR_SECURE_BIT)
+#define XFS_ATTR_PARENT		(1u << XFS_ATTR_PARENT_BIT)
 #define XFS_ATTR_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
-#define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | XFS_ATTR_SECURE)
+#define XFS_ATTR_NSP_ONDISK_MASK \
+			(XFS_ATTR_ROOT | XFS_ATTR_SECURE | XFS_ATTR_PARENT)
 
 /*
  * Alignment for namelist and valuelist entries (since they are mixed
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index b351b9dc6561..eea53874fde8 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -917,6 +917,7 @@ struct xfs_icreate_log {
  */
 #define XFS_ATTRI_FILTER_MASK		(XFS_ATTR_ROOT | \
 					 XFS_ATTR_SECURE | \
+					 XFS_ATTR_PARENT | \
 					 XFS_ATTR_INCOMPLETE)
 
 /*
-- 
2.25.1

