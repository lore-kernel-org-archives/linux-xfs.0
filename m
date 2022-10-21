Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D8E1ECDFA1
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Oct 2022 22:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiJUWaI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Oct 2022 18:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiJUWaD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2022 18:30:03 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B14153E08
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 15:29:59 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLDnuM005590
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=nt2SDy5D1w+l5on7uK2ozPNnN/d7qo7A9A8jhBd97z8=;
 b=jQ2iV3DQrdGzKjq+0YP8lR+yJAhQVNa6/QXlg0gaIcECTBXnAwSz2ue0Bnvzy/tTX8gL
 0TRlPqHDDf7HQLnTRddjd4K7uB0LnFTY3JvwFmRkMS2f+KhMO6bGe4bKNoMuQNI6nMH/
 u/ShsWmFarGJAcCcjuW3oeU5pdvQxMXjuvlHaOZELZbpgeUMdw1rIWoQJWNERrDU8JXF
 JzyQoaqD3C1VFLPaXzWppq0F7cLzQTrZsKktXx3J+IzGnoG1ohSFKJ1aKfHMvDm8iT8L
 9HF98I2GmbWDB3GBP876aFMT8wZ2Mp3ISKu/nmktj/lcnxLJJOWcuUAJ+1k0TLvdtOXa tg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7ndtua7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:58 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLTkFI027359
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:57 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8htm00hn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FjpY51enXSRM5HcHGM8S8Rcl/QXmRIlF1IQ/ZqgNiCvVaNUmtw55jXvDwCYXWrMmCMohQOTQS/JMV5ozkVfRJbSbMGbP+oQ9ZlecxhBTRbr+rqiYr5LTWXUGPKjWMXQ2Wman+TI68ngpfFnzs4MzCfN0eZEIoM6HoC7+voM+hmPufzabyE9+vJ4/MqOmB+mOFXMrX4xX1dWWVxxp+yDBOClolyv8JsjxzdbSj6BFh5xeV2LUlsZxE89HjWKb6vNi/mzOh1Hk6KFB06bVtHncA2vhjHULNm5DudKbmA/Sj6V0S3n3FmjGtT7s9doRJyrxhH2VsRtQoPfmDdAGeivZtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nt2SDy5D1w+l5on7uK2ozPNnN/d7qo7A9A8jhBd97z8=;
 b=Ic8ePt2UzPdsRjn9qnw13gdCJCkMbg226ugIdvfSfpJfRxmBmel+VnNoBHHIkUAo0f3fEMJK4I4/nXhnKoXPzBDIE8015Bjs/77VVAMFtsyCtkS1qiNU2+LU9DqWM5YT7lT+nSNEqoqjISWRFCFKllqUKHbDQ9m6blxEinoseu0dfsM6UHNd6XIx6z5mGXugxiLTIUIrSZgu+zi4e7Yf4hMKzNQP+nNJVH9PVqbS/TsEE+nP7rrYOWSo8WTzYgA+joB9qJKkpyG6g/sfrk7kGSMMxgcVUMF23f6g8OJy2qGSDNiElXRreXBRU2kqHox3YnYKoPP+in3e6hLbaLn5Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nt2SDy5D1w+l5on7uK2ozPNnN/d7qo7A9A8jhBd97z8=;
 b=ISXJvJvolHSAeyA/1uefNCfBdHp+rIjJN2OKtYum0ZO9gLZi6Rm0b2aOO1Obqz3XAI9adbhz0tM4NIY0kwGq4xy8tBaYo19+CC+FHvNljUE8nzemsT31BZBbQ0o6mKJ1o8VQ3HuJvOAP/2XzisxIYaOUui9SplffBQd8JTXoHrI=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5213.namprd10.prod.outlook.com (2603:10b6:5:3aa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Fri, 21 Oct
 2022 22:29:56 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 22:29:55 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 12/27] xfs: Add xfs_verify_pptr
Date:   Fri, 21 Oct 2022 15:29:21 -0700
Message-Id: <20221021222936.934426-13-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021222936.934426-1-allison.henderson@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0292.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|DS7PR10MB5213:EE_
X-MS-Office365-Filtering-Correlation-Id: 2876adcc-77fa-45a8-dacb-08dab3b3c78e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pSXKD+pU2sMVDA68n8bw7M2/6SG6gVnhQFUgdmKBZpK0YIqj0X0h0uuLSx2q+N4bmCW3x4h1R4xno+A1BcVwW26Ajn4CL9ZjBYsBBrz47jBO756y0Nl983dhHgRzIOoybL7oiI1J5vni9xsQQAmdH8QncCnYHGvu3lKOdDUfGs3VZ5p41x6Pu0DBKZypx3TuPipcAdBsPQkEoiKuIR2nKSzqkpjZLe446gtWTJlk2/m5vy8NaQNo7aYSM/U5D4bWThyWtjy8UwjmYij84rzRuNZGZ31R8M4fvuSsNiy/5CUTtheb5DX0yy2RlSGsIcHRFGl61DPceAOEeR7nL+7kcDK8B2ebC+8ibxQNU6I0p6RdpExwu0YW0IEldQtDrbyC148NDTYec4hfyfRAWSNMK00Jg5i6AIOK0yt2cwds2KPLHPX9rdb55Kdn5Fb5UVHq7utQKZK4aGpwwqyfP4E/iXUZv9yLpuV7wrzpJUAxyxRjgzH2nkTwFsbaSoT3TpXCZyrk6gvnjKyUUTvgertLxqchT9PguhaCGzuSk4GViOCR1tccstEUVgyoInsv4irxgks+aZh+/icdeBXRgEdIfIDpfh2IEv8HsNOrcXOE63p4odh4qqCU9AJcwnEGT2IqlSMFmBqOEtQnEfX5H4s26TIyfOoceNZSBzYoBa7XTvLaxXQixfUFdl22+8XdUfmjMLXx6XxgWvE+KGF0OfpKmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199015)(66556008)(8676002)(6916009)(66946007)(316002)(2906002)(66476007)(8936002)(36756003)(41300700001)(6506007)(6666004)(6486002)(38100700002)(1076003)(186003)(9686003)(6512007)(26005)(2616005)(83380400001)(86362001)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DeSSFNdhqbm7mWjYA3ipjfGtivEbE4SsUTkRZttJvTikSD4phcw9lKCaw4oD?=
 =?us-ascii?Q?rNSY4C4lYeb/NrYgSRc8aJj2f1Fc5O4Me9U4Aap/WipI/NMYy9b8Kaxr5tGu?=
 =?us-ascii?Q?7OTuoLGOja/7z3zaLXmC2GdjA9UMS+eLd393cWyyhs6rHnUYNCFKP1iOD1Hz?=
 =?us-ascii?Q?tcMraNAwr9mT1nk+KYzcNRmcNX4umibKtfr8k0lgqd42cOdPNNjoDbo+8nmf?=
 =?us-ascii?Q?VGeZRnpZA3VOnS8HiDH7Ts0yp9jdgUVzbOty/k74HH8gaaxjc5Zd1haGRADf?=
 =?us-ascii?Q?J3QPjaaPwZjYIfI/jBxjzUHzwkZgBRVZMH/t/ZFCKptbVI85Vne6hIXC+tM5?=
 =?us-ascii?Q?2p3wXYBvBEofZfKZno9Hv70eCddlf+mvRPd2vxiHjuvM0saQtzitbW123/fP?=
 =?us-ascii?Q?kSbxkdm6EtDzxGIc6K+QfTP/3lVmkTjZPui/aI3XCxwGnjh2MxC/gOV960dJ?=
 =?us-ascii?Q?TKvHP2d+rNEXz0nRInzjUp6hR4UMbh8SY98KdB5XQvpon1ZzfuyYUgCyzy3D?=
 =?us-ascii?Q?1a9xHEgkn/SSOnQydAhsnoZ3wj5eKehkLPjCILhUhjxEb0uSjU+X3f1p806F?=
 =?us-ascii?Q?tOrfXV5V5u6kGdmFjRbiAqxV2V7wOVMvDxiQB0MQo6Y9xcL4NX9bh4MtVNi/?=
 =?us-ascii?Q?QGzpufJP8whFoEWgVatffy4MbBE/2Y29/BEMBg0CXIaU6HzRJ6KVv0TtscXd?=
 =?us-ascii?Q?H0BlyTmqsjoxhabKdX6xTjI5RX1QrtEuYlf2YpFhtbHLeXHat8leqRx8xQCY?=
 =?us-ascii?Q?SuN0tahM0C/32P+uIJj5HpbHrqMfbpPGw6AahApK2NDmrW5x6n8lQ2OIp1fR?=
 =?us-ascii?Q?Ho5l5IFGSVFgPQzuNETQNoHU0tBAwpjBn79o9JlnDVwo5enlvLwz58u5+hPl?=
 =?us-ascii?Q?LCCnDe0KssYhJLEQprnUsA3p9HRQxjPwg8PlSpeh6f8Liks9ogqB4U0MQCPz?=
 =?us-ascii?Q?YNZi8AuUTdn+9qlLysmbrBBB133VhK9WCdlBGLZm7h1wjw7VEAZSNQw+3twy?=
 =?us-ascii?Q?AUcuDc/T4lcK5OX8UQxdoUdl2QcKsJZYWdy8wWeMraEN1/DY+bIN7y/Q2cYA?=
 =?us-ascii?Q?iHQNl5qFNVuo3QcugR6dijCKa2PKfbyx1KB9EIeDlxsHPKutm2UoPikRnWqi?=
 =?us-ascii?Q?mcVX9y0sxrcGCjxJqIdZG2u1WzqMAWDfQGE43td50A+QnM1elPcK2SQuOCvv?=
 =?us-ascii?Q?Pr7mQixDqMT/lPeKKP/YCiJq13gU2bdx2ZBZRmkhf9yChvDDogc6wzOrJS9/?=
 =?us-ascii?Q?AvRKKEEFwl0wVZXlBvB+nDurwf7TWbJyvHY47XdCsnd619jRCkL3sWqPZf7e?=
 =?us-ascii?Q?hJcicKtgg5WIDg/I2sXybYpSymFwAp2CvqqF1CjJ5ntZOHf6rUmo3X96mIs9?=
 =?us-ascii?Q?FRRWQGn/7jmUSIDiFXc7aaa9kxP8s1NHjSKpCYRBorXM9YnnQbKUqYaHZuWf?=
 =?us-ascii?Q?hR8lGIwYrwtebq38su0Q1XlqrvD9cXHGqL6WESRgp0MMqSBT0Zk1oIcAHlxj?=
 =?us-ascii?Q?T7DytOATg9uNdT4MkJSDHT5KoXwsiv3cdZkliJhzNCmO1h2q23lCbpVmN3jz?=
 =?us-ascii?Q?vnRsuSk/vt4sBG8gDTh71+NZjHoXb0P3sWOT2DXLGD/1rQt/ILwadz6vIkpb?=
 =?us-ascii?Q?Wg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2876adcc-77fa-45a8-dacb-08dab3b3c78e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 22:29:55.7704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AAYQ7pc5ypHYuiHuy6GkoqLhB8mHziDYXzAubA73m3bUrHmjPgp7s9DFlsmX75doKBAj7GHT/Xs+ff4fopYKA6d05qhOt+X1q5R1LXQI6SY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5213
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210131
X-Proofpoint-ORIG-GUID: P5SZrgJJ3C7DiytAxtbGUlvTTD536f16
X-Proofpoint-GUID: P5SZrgJJ3C7DiytAxtbGUlvTTD536f16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Attribute names of parent pointers are not strings.  So we need to modify
attr_namecheck to verify parent pointer records when the XFS_ATTR_PARENT flag is
set.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 47 +++++++++++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_attr.h |  3 ++-
 fs/xfs/scrub/attr.c      |  2 +-
 fs/xfs/xfs_attr_item.c   | 11 ++++++----
 fs/xfs/xfs_attr_list.c   | 17 ++++++++++-----
 5 files changed, 66 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 101823772bf9..0c9589261990 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1577,9 +1577,33 @@ xfs_attr_node_get(
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
+	struct xfs_mount		*mp,
+	struct xfs_parent_name_rec	*rec)
+{
+	xfs_ino_t			p_ino;
+	xfs_dir2_dataptr_t		p_diroffset;
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
@@ -1594,6 +1618,23 @@ xfs_attr_namecheck(
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
index 3e81f3f48560..b79dae788cfb 100644
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
index 0c449fb606ed..67eac5cc63dd 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -615,7 +615,8 @@ xfs_attri_item_recover(
 	 */
 	attrp = &attrip->attri_format;
 	if (!xfs_attri_validate(mp, attrp) ||
-	    !xfs_attr_namecheck(nv->name.i_addr, nv->name.i_len))
+	    !xfs_attr_namecheck(mp, nv->name.i_addr, nv->name.i_len,
+				attrp->alfi_attr_filter))
 		return -EFSCORRUPTED;
 
 	error = xlog_recover_iget(mp,  attrp->alfi_ino, &ip);
@@ -812,7 +813,8 @@ xlog_recover_attri_commit_pass2(
 	attr_name = item->ri_buf[i].i_addr;
 	i++;
 
-	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
+	if (!xfs_attr_namecheck(mp, attr_name, attri_formatp->alfi_name_len,
+				attri_formatp->alfi_attr_filter)) {
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 		return -EFSCORRUPTED;
 	}
@@ -821,8 +823,9 @@ xlog_recover_attri_commit_pass2(
 		attr_nname = item->ri_buf[i].i_addr;
 		i++;
 
-		if (!xfs_attr_namecheck(attr_nname,
-				attri_formatp->alfi_nname_len)) {
+		if (!xfs_attr_namecheck(mp, attr_nname,
+				attri_formatp->alfi_nname_len,
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

