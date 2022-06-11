Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15BADC433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 09:42:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbiFKJmW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Jun 2022 05:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232548AbiFKJmR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jun 2022 05:42:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375DF11C26
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 02:42:14 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25B1hwNn021516
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=7bmUqUQhKFUy06InPoMGiQt0qMa2J/bjFNjbgcp8fcA=;
 b=MZx/MjxKKSZKbRx5aCNrL6C2hnJHSpigxw+slISgcnKHUjGLbrX3FcrNrinojTQuDliM
 epk21w3iMSJGXkycp2Lpl879ovZNqhcJl+vpa2GZF/wfQB1B4CbsxHAKN90U8/oljNNQ
 GLCW63oHBKYjBuPros1XTbc/rBgdmIK/NvRJlz4cG/dwGz7vrWv4EC9PKussnBAnEzte
 Ms0RgVjIzTVJ60+v6iXkG8/21gkLALLBacCchWhPvRYF2WSMlw63V9ZtYE+zUPsWbSvi
 e/sKVDfHAVPTu6y4HlOePhon6MzBhjIxFcB7l/Uc+1Bhj9DXcIyXCJus9373aLDmvI42 hQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhn08c6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:13 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25B9ZMQB025527
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:12 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2046.outbound.protection.outlook.com [104.47.56.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gmhg6urjp-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KPd2vA76hlRCUEIb1GlLhM5FDEPk3OFZ/iGBatdt6vPoJjny6thAH/Zd1ZdH8KyYB1ST8mbNT2vvE4AK5YOKqN709GTlnKHkXKQXwRl4Q6Wxm2BMp2tMR1jnSq0z0W+qtjE/Yxl6au6QIcmoMtwij/xf8vND3lMBmnfx9Qj5Qn2vaNbRgbPwHaT/ZGCenzwAK4dyLd2ZA13ATFpGPHic0AHNx7vrTDNXjqylAEDw3EX5I3scSgLwlhaMO03Snsch3XkBzuKLUUIehMnSlZFwFcf7lx8XiRnxUzaXgRaWUXoKLfgf/Y0A347TBzTAZTOuTmvHn0quya8w174P/4kPlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7bmUqUQhKFUy06InPoMGiQt0qMa2J/bjFNjbgcp8fcA=;
 b=VnmCmTWsabuii50lcrQ+GOndib3nqVHSSREyfxx4G6YEWw5HGNn0RmdwsuSy//7U+pOi/ij3gM3gatMqYxSsl21x3gQa64wpnSaEgQj0pzryX1hY1fQZzuJU8G9/OO/VQqd1uUWN4i/Fc7o6Ja5GSrOKMMcVoD5tqlhVoMHawpkIdUWmdKQei08PDS+3JgNpHs91arzwJHODZlGi1C8VA21uuz6ig6N1rta55fI0vBHOwWWr9436lB9QUnNIVdk82E+7iE4wjg6iQdYbi/V9201E/2u+4HKNq8biXHuES8aLbxBrV4lDLsBl7p20lIcKARu8fihCMK9+Fp0KhJEdSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7bmUqUQhKFUy06InPoMGiQt0qMa2J/bjFNjbgcp8fcA=;
 b=MUuRMPCVauk3SkknAyORODrrzzM8vwRjlmS+873trMytJpNnRnmRbR4DfSxTiZZ9MFUh5vXLEnQhJUZn3MzG4n894ltXfdtDRO4wX4BKwCsh/VMFh8LRepgmu3r+BkET8rMgcj/Zyy7Dv+y2Vi9VoBlaSH82v69Rw5UlXYNStUg=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4606.namprd10.prod.outlook.com (2603:10b6:a03:2da::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Sat, 11 Jun
 2022 09:42:07 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94%7]) with mapi id 15.20.5332.013; Sat, 11 Jun 2022
 09:42:07 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 06/17] xfs: add parent pointer support to attribute code
Date:   Sat, 11 Jun 2022 02:41:49 -0700
Message-Id: <20220611094200.129502-7-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 60faf14c-74ff-4f41-b38a-08da4b8ea67a
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4606:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4606581BAC23002CAA36AFC895A99@SJ0PR10MB4606.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TcxTj7TQmIM71IvBRPcePjDZDe9RZTsICJyNNw8IFMvyq+GPRFuogS2gNVRAZN9Ui2VeRkKgc2Ym63rCPTOTYKAdrrtUZJ4NbUO81ouqP94Oc7H9vc/POH51E04hWuEz/sjFZL5yWp7skZ4s3nU7mPwbEph/obf8DspHSO1Jsj5yrBnP0OM7oVYiLQ3f3CVhCFkQZPIxcnGnR1OD2ApGcSaMvoR0okNpNnd6I1fn8pbmZH1L9BW3ZemKoBHHtTrijkuKirCDRZqnypIVlhGCC5DnPsWdXdCX3XZURPz0XCn9i1nTGWgs6GY5Di59oWkeKviRGfY+r0RXgaIYQQxTtjdeoVMPClD3ViGKhJasNRrAbp6zKga2GGL3CGTqaqCfxfQtzA+vJw+BlczZcJZ0tIdsub0oAMXjUdjx0lldfL2WQbPAmPJwJyLoa+spwjqjmAB/skhIBaG6MnUTcWNqrKq7OsvK6/dy1ptMh7xmtCMiHlkLHYhntQ/jrqeRvOZI7jvktmPYiiBfp4OPGHmnaRflCVlnz/W+sDNc/gZaQ0GlrUKI5VRFmIqzD9zooHiO3JThQzl1Wjqm9J3X81W+5QMaIN+jXa/DjW4vlyIoS3grSUaWgiwJjU6biVkHDGvJ6X6oyruRAnp9oshhfH+Fx5c4WPnbGKfh5+OhBUTOTfNVA+9OQFrDi+vuAhOlShdbkTiYc7ZgK97VP3O0Px//2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(6486002)(44832011)(86362001)(2906002)(186003)(83380400001)(36756003)(66946007)(66556008)(66476007)(8676002)(5660300002)(508600001)(8936002)(6916009)(316002)(2616005)(6666004)(6506007)(52116002)(6512007)(26005)(1076003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qX1l+dhbr04XGJP5QJq+f3Ebcik6rq/WotsE4C7+PTJBOZPld8izfDX6PBEL?=
 =?us-ascii?Q?z2cTdjJwoTg0eWWp5y53uL5YIxEMt/DGxdBFLFxKfTobQvNrmmctsjb5ACHt?=
 =?us-ascii?Q?5QpTWb/iiqQu+iYhxHM+sWMTIkEYXpm1AtwA8+qlPQ4K/uyclm8j+dZxwKMY?=
 =?us-ascii?Q?56NJ/PJmzniOrCDIpkuJwXhmMFwFREKyLWxZZ9U1Oq9nQMMc0Cop0XDWVQb8?=
 =?us-ascii?Q?c05fsMjbrluOku65Z9H/AoC9foPdxDitR8xCyYfkMGxPQ3otSpBkRplq15Ee?=
 =?us-ascii?Q?/5io+9N1x9Gl+3JQHzdmY4639bx0dnA+Sd9kzwVLivPkZoOozJiAxmcjFN1g?=
 =?us-ascii?Q?QKSql2Krgu12kRUBjfUgvg/Sh3uc8nqtLLiknNggr04wQGnMBZ8dTOGVvpH9?=
 =?us-ascii?Q?l6O0itz4yjPVQUESxJfBhBZWlihlWGjev5bBUIZjbwAHxOZEC90DCBKkfUe1?=
 =?us-ascii?Q?MyneP3blH0fBNWil6+trEXElNCM+zCgaScoEm9N3+/V6/HCiNIGcSPB6PXgL?=
 =?us-ascii?Q?5S7kVfYYVndP5w+uwmQqaRnAsdll4uoLtBWZox3CT7ESlqF1FW5aO3f1FCrC?=
 =?us-ascii?Q?BdMjAeypw237yUJmSWamovh9UPmsdp4eTEpecmwp8dVFc5RTwmIR19Vxx6Ff?=
 =?us-ascii?Q?ACt0VueTwClmKXFevYE3gE68tIAiJxYhLf1L5KdVNHWJKzRnOD5jfirhHOxs?=
 =?us-ascii?Q?NmW1J3VRMWurbDrmz9/4yUgdtWmtMbcup9Da9l2yAfnvrDasJHl91ddO1DAQ?=
 =?us-ascii?Q?ydOOEt/aGv4tF00UwIMVANkPJwHNlWlifWSDXwc9gVxzzSz4SPmwya4qfaj5?=
 =?us-ascii?Q?EbuWq4W+/oQtALs7RKyDpott+GT+xqaKeTIhTPaVkOdtso/N722Oy93D7BJ2?=
 =?us-ascii?Q?pXkYIcIb6e2a6Cl6ZqzleeONGck2Y3DoNJEqymvfTyYPIVnXU2T0AxJVoIzb?=
 =?us-ascii?Q?inUskn61CfwCLH6cpwkrKduLff2bQJqcCnPDHlKFVPiXljoDxkC0m7ktidtI?=
 =?us-ascii?Q?lWqzIHJdL1WAD8Yw8Wx3AdJ/Xnb/OjOUpoHOaxDsACtnCCBmtp29jMZ1Chgh?=
 =?us-ascii?Q?rTcYOwKd+OqZCcSvBr2wdT6btYcNb2F7fzbUXZHZ5/gRrwR7pMhi+hR3Kwiu?=
 =?us-ascii?Q?bQ9L/i6pnxEGGMhKGU9B56i8ollVEwD1s9RWYqZ3jTMFzWQUSaLoVvFjWFgA?=
 =?us-ascii?Q?y9HGGD4LHFIBctYEJ7z3+ZkCVkRRkD3o7gmfW1BLOR9aOx8MXk8Zi0Hr0oEp?=
 =?us-ascii?Q?k0/TULEAzk+1KxKCvc6lAgUuGgqNiG7J+7gYe1iXtth9WNEs5AtulkFHALpF?=
 =?us-ascii?Q?7Xtan5HWpErrvhberBVvcY4fiAInlX9az/T7ygREFM9h3MRjAH9F+qtLl7qB?=
 =?us-ascii?Q?yzdkGyroRLCRoTnuqUSE21x/uQhMmmvB4RejjPBjg2zIFcYqYrhoWjPVZvO6?=
 =?us-ascii?Q?HNxZbZKtw/pDwYgfX1Gn9MlvIh5qtI50tLJKshtfP+B1HvxwqCokyCgFlJL/?=
 =?us-ascii?Q?lpNqqFVaVV1oY/7KitAD/gvXTc/Rt3ixWhRu4cbJoibKOZcx39qc/UhvYBrj?=
 =?us-ascii?Q?i+2qTHfrf69/XNNQYOLnFdK0Lf++fsDXKYeqp4UAVA9iKQIc6hqmR9iV8Ksi?=
 =?us-ascii?Q?aontIQo0qDRQvKuQZ9nAnsESLbRyWwCmVHwdGYPZWRLylfoSLKXB2okjNTKt?=
 =?us-ascii?Q?/TE/n0p7YK+UyXAnqfrxMo4HU9rRt74TSbldShr8gcb3jw9vArpdXaFB3ZBO?=
 =?us-ascii?Q?9/pVpA9R/yQe+XHsRBWjuts88sA2u9c=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60faf14c-74ff-4f41-b38a-08da4b8ea67a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2022 09:42:07.8106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UXAU6gPmIoLNpFhpR6hYVoJhL0empQzWzWhMB0JHas+OH+exDqEqnlfuMQpI+dNxPngSU7FhgG9jl0Ep1LjI40kyx0TUqgFBNBDXcZ+rl6o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4606
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-11_04:2022-06-09,2022-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206110038
X-Proofpoint-GUID: bcexKx5FSePEv2qMKVKjO0UF63rXijD0
X-Proofpoint-ORIG-GUID: bcexKx5FSePEv2qMKVKjO0UF63rXijD0
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
index a94850d9b8b1..ee5dfebcf163 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -996,11 +996,13 @@ xfs_attr_set(
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
index 25e2841084e1..2d771e6429f2 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -688,12 +688,15 @@ struct xfs_attr3_leafblock {
 #define	XFS_ATTR_LOCAL_BIT	0	/* attr is stored locally */
 #define	XFS_ATTR_ROOT_BIT	1	/* limit access to trusted attrs */
 #define	XFS_ATTR_SECURE_BIT	2	/* limit access to secure attrs */
+#define 	XFS_ATTR_PARENT_BIT	3	/* parent pointer secure attrs */
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

