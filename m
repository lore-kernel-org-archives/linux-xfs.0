Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08B81C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:02:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234527AbiBXNDO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:03:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbiBXNDN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:03:13 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668DF20A975
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:02:43 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYEZe007293;
        Thu, 24 Feb 2022 13:02:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=LNbi5Yh6ZLH9WdE7OeKLnm0Pecr0XTe7WfHMkgVn79I=;
 b=vSTbqrbV/t0YXjEwADOpAFkEqgYW7q/Gl4/Hx4hRDwq1FKmIRdAdxV7vEfnSrEJ7v36/
 C0gN+vrsVjkPaNjzS/BROjnrHV2CdYbDHMSxLpj+NFk1ACP/xSP+z7Y6hpAR0LwbpuQz
 k1pvPrJinM+SiuVHJEwX9r7W+Nf2LdGM6Ex37KflVPhQM9VRfGXnDDDkDMNITHnf3coG
 y8PoziH12gmoAoTbQiXUCHcNaKR+s9g0OMCoJ8kAf9Czfzh6jue+X5yI/Bej/g73EPTY
 LDoLYyGa/19+VnRQ92hx3TJ8wgeuxi+v+T8HWWPb8wsssnqRi8g6A5UUsNUXsCkwbTT/ NQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ectsx7b26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:02:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD0XBU120494;
        Thu, 24 Feb 2022 13:02:38 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by aserp3020.oracle.com with ESMTP id 3eb483k701-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:02:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YAgMrod2QS0AkPBumqjlwF+E/0QPg99WjS9zmKZx+WudPBZtJ/Tv7WvHGbemjouT5ns2Oveh/I5fCRhkfal31Xc7zwbHkJ0aoxCNMunT5YrOQhmUn7lSwSw2mFpH6qQIjlPvEXjRF9z5RkigORCafLkG76Xvk6S1ozl0UWOOTyVXebbRYM2OENCn79WlPbCV1AyLOKDNnoA27+AXrXtjcw16tIhdbC7yFMfWmyFI7eOIzNEARkRBc+wIkfSdtdj71/uekWFhyGbNdEAhUi3GH8mJcQWpPhjFbds37Xo3L7Su2ihhCF+Tgkn4SEFBKXm0ONedNaCApW7hhbOvKvYbEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LNbi5Yh6ZLH9WdE7OeKLnm0Pecr0XTe7WfHMkgVn79I=;
 b=Y9LZ7jkjSj4OhKIQOarj+ElbwI/tm6XYR9G27KdadGH0Lnpr0d6vHU9Md1Hg2uZAStpPcmUYa2k3EsL0getobWn0hM64cIzO/Avq7nwBMQRaCornlCPCWiA+8dcYyGogwm5f01wWviqr922ren45PTRMJYwoRiQy3pQjF3Iig4gEck9VHWK9k6jpjCyTyVjMkbvjSR4VFuXJfZRdIlDxBcEYHc/cc34ptgpDd652fRhuLY2/ns7PpuAaVlRKUvG0olcoaGMUqjhWX0uRAmh19In8BRm6TFMuEB2WZN79kkyimQfBhkqqzZTMaPkaJPtD/OOhSla/Qg24t7DUlcVdCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LNbi5Yh6ZLH9WdE7OeKLnm0Pecr0XTe7WfHMkgVn79I=;
 b=b3sHeRbDhNIHsYSOqwPynbyr/rvoBoxgVjqTwwlAwVJ2+EBlp3ujwESmFQCywQwrZKDvcbMNhkgWLVlRWhkhATKaFdXcth4rTNjn3fP3VtMdQUaZhQt6fUKGK9ZNHlLJoqzylHwYMwuIKk63v1ybmSI08K/xYlvL3GguMxQDRIU=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BN8PR10MB3665.namprd10.prod.outlook.com (2603:10b6:408:ba::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Thu, 24 Feb
 2022 13:02:36 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:02:36 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 01/17] xfs: Move extent count limits to xfs_format.h
Date:   Thu, 24 Feb 2022 18:31:55 +0530
Message-Id: <20220224130211.1346088-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220224130211.1346088-1-chandan.babu@oracle.com>
References: <20220224130211.1346088-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0009.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::18) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 866f9db2-0a06-4555-2347-08d9f795edd9
X-MS-TrafficTypeDiagnostic: BN8PR10MB3665:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3665CE54A3204FD605F8144EF63D9@BN8PR10MB3665.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q57DkxsQKzn0spPZJ6sefLG3FN/yIQ5hLwh9ARhDGEZV5Kqq4AfJ+ohugqYlMjch5xFTFsF4XJcpMvC5TVZZ32w+0LDSfyfbBELkb0O4WOXKAaQijpOImY1PcuBdBBR9dJl1OYxI9k4uh/WISa3WMGw5eolOsrkOteqUkH+E/3KMfm7rqZfqaiKGCkcpkDI7fDZ7XYiGRoaHU7Ej7QFLrbKd1JYtCNO8vFB9o5OSr+OQ59SpvkoSEzrubVj36XWpvDy/QH6BQxIHpXLX07fGcAYa9mRrSyp11eQWFGeLfy71WUV8SZXPfVen79BL3W7IsdsA5F8oH3kJa+uDmvvSo89ouDtqcYlhngkhPFgphKCtG7BuOhhMIbzLvUZL1QPjCCkG+1aOYpteLl8ZTLUE8cTY86rGoxuOcF/9noa9w2Rsc9VKG6x91WILr+U7eeBhiVQPW0YUfH1wm1WC43isTuxo31O9/7pd2L2OU1Sl19JMK5Y0tloH9lnAu03u9xhNWwNoEVviK79LyuxySsgoH4LXnV/1Keg2QBk8WoombqhIJiNTQr0Dogm7WE0SBx5DcJiiEyZDs22PWn2Hsm2RL+GqZaSdzK/k7DU17i4AdWWG0faN1dj31cj7bBSH3dDC/cQCZsWxJn4iabZxg+X3W3GXN9jKnorfk4/TOiOSXIRpNjYNr64mrNgF6XexLefwfhczTc5Bu9wa1eLRqhk1JQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(6512007)(8676002)(316002)(6486002)(52116002)(508600001)(6666004)(2906002)(8936002)(66946007)(66556008)(66476007)(6506007)(5660300002)(4326008)(83380400001)(1076003)(36756003)(38100700002)(38350700002)(186003)(86362001)(2616005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sO8BMRnoqmlOEhkBrE7Ej3p8Xk3mzvWZfGlp6f//M/GXUsy+jMh+iHL28Hp/?=
 =?us-ascii?Q?pZqhM2M2O7+Chxo8fDwKhA/1BzyZmEiIW0g+3gyKG1O+Ge/sOOrTz+r3XiXa?=
 =?us-ascii?Q?Zsa/ebPRr0JfKhebKFF4AAktvjyeW0sPWLj+mUxs/0w1KupKwFTG5fYVB7iZ?=
 =?us-ascii?Q?bpzEvT9ci8Rd3SAAV/6CsxGdpri6jxH9aHpuSeK7wB9R84kHDec7WKG/OGYd?=
 =?us-ascii?Q?obU+GhzJuVmIg5cYB5fOxY/adRlIrKkmntlUfeF+1El10tKCKw78Pulxmvws?=
 =?us-ascii?Q?2Sj1UDB6lQR0eruWkeQn+KMmEBCX+kgoe7fJN6kqHbYlFRSUE35Ov03I5gwA?=
 =?us-ascii?Q?uUW4LsW0tfOXwXVj5q1+8DeH8NG9493d4g0wRTEm7YZH23Tnx6Er0FnQBn8e?=
 =?us-ascii?Q?Q7W3vZbXGH+qDtNvOJQcjCRhfSt21HNsuT9aP6Yl8a9l3sK103y17wNPDLuL?=
 =?us-ascii?Q?8Vm9slCEtn1XYY6zMQumaCLyVqyIaJZIeciF77Xeu13HwpEIcaW+V2RH4T+u?=
 =?us-ascii?Q?VfMcSmXAhq+wwRH/+P+6TUHzDrjKgzcZ82xZNUL1M+AbeNHkAXXr8MfsVH4U?=
 =?us-ascii?Q?tqPqD4uc/YGNNB1zMkm8WQcLc9pa5su1zo5NabnMdP9tSLGW3vr3NdXqodgG?=
 =?us-ascii?Q?kaBgWLwWvbMx7s9v4VZ4WshcusaWQiFoC9CwMWB3yn3ie+nit92RJRIwRF6S?=
 =?us-ascii?Q?z5VlBH7dBA4yHsDuei/1KdSmvS8Aaq92bm0NYEh+Qxp3Jenuk7cMZMaEm3zT?=
 =?us-ascii?Q?EHiPlxwmEirV8OS4BrGHO2YLkmXRbbxpHZxXItC3z+9KQpZR/H7t2bgTDLi3?=
 =?us-ascii?Q?NzcBZ4UySLQtCKOXk/aQbyNOZDXDsdDF+nbu/oyr55/Yy/7ipvVfpsbPamdp?=
 =?us-ascii?Q?a4KyJ28DZ58eAHIZzSzAwwseo3vS6fB+9fuLTA2OXbgsBuUNBObcLyWFocZM?=
 =?us-ascii?Q?ISc98clzqjblmHFMrz3vUrGPXbXi7laYGR/UE8VR/gPzx8EslriKja1yokfj?=
 =?us-ascii?Q?0EJ4QcroovlQAkoRKkagrz3i4h270ZLbm1iOVxF7xK+wFJeVMETqC+5ny5lw?=
 =?us-ascii?Q?NN3PEp3/+XdsxkU19NF7/o7PcpeRQUz1xEFtMf8001Xo5sfjRlDvy8qTB7vw?=
 =?us-ascii?Q?7tOmIOJCifm9ICcKqgZKqtFQCdOg7AAYbCovdVaBLn85yNfhxMb5dummgUAv?=
 =?us-ascii?Q?b+TIR52Ngc0Z/4t2yy2OQ36+sxfdEGiQPMBTfCt+OIniQRzxmnDiKmrc93WT?=
 =?us-ascii?Q?CPwkAC83khec7DIqWRJ88298AlXglLrtOiJjdyVSZcZIom008A37EX/no0jK?=
 =?us-ascii?Q?lsC3Uf54Idgj4MCUgvzEeNumWGoIAFQw0plr9YoZByvuObQm2OBMQeKWIfRS?=
 =?us-ascii?Q?Z62JTgCEyKXbJpXbNAjVZWoj5hyYuAvOSdSyAX2M4FBtUczHELwI7xtECBwh?=
 =?us-ascii?Q?lqrpm9jmdfPU1++PEb0WuFYM+P+HEOfm5rQhEi8qd9o/QlGFFsKcsN7cVPhp?=
 =?us-ascii?Q?zpyDNZD2JDNhvnr09PODFNYNxTgadSKvfk1Y2YlPjmlYvD4tlW/s1EQYYlkz?=
 =?us-ascii?Q?JUjTRIcXoH8qL1QQgiRmd7Lqvcg+reVgg8xD95Yjd6pbgcC6bIVMOx52OKJr?=
 =?us-ascii?Q?l/Tg8hnNzH6E17rZC6lBWf0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 866f9db2-0a06-4555-2347-08d9f795edd9
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:02:36.5066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6fBB/y2tGxpc1exL5qJT6pYpamJNKXSfVQOr/EXL4RfBW+Fsme98A5J+jBoU3hLUO2spaxjI8+KaHlQcTMvPSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3665
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202240078
X-Proofpoint-ORIG-GUID: iJ2iXFFuEnLCN8t6XOidusUBEOL2BMyp
X-Proofpoint-GUID: iJ2iXFFuEnLCN8t6XOidusUBEOL2BMyp
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Maximum values associated with extent counters i.e. Maximum extent length,
Maximum data extents and Maximum xattr extents are dictated by the on-disk
format. Hence move these definitions over to xfs_format.h.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 7 +++++++
 fs/xfs/libxfs/xfs_types.h  | 7 -------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index d665c04e69dd..d75e5b16da7e 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -869,6 +869,13 @@ enum xfs_dinode_fmt {
 	{ XFS_DINODE_FMT_BTREE,		"btree" }, \
 	{ XFS_DINODE_FMT_UUID,		"uuid" }
 
+/*
+ * Max values for extlen, extnum, aextnum.
+ */
+#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
+#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
+#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
+
 /*
  * Inode minimum and maximum sizes.
  */
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index b6da06b40989..794a54cbd0de 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -56,13 +56,6 @@ typedef void *		xfs_failaddr_t;
 #define	NULLFSINO	((xfs_ino_t)-1)
 #define	NULLAGINO	((xfs_agino_t)-1)
 
-/*
- * Max values for extlen, extnum, aextnum.
- */
-#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
-#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
-#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
-
 /*
  * Minimum and maximum blocksize and sectorsize.
  * The blocksize upper limit is pretty much arbitrary.
-- 
2.30.2

