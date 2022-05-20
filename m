Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8D3FC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 20 May 2022 19:01:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353150AbiETTBA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 May 2022 15:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353102AbiETTAu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 May 2022 15:00:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D22364E6
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 12:00:48 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KFn7HB022615
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=wRXZzPTWZPEGz6h5nqB+c6sJHTwtHQF+lFnMdMmPqes=;
 b=s6eNO6Y5H0Tm5sz/USR5STsjQPiealEAHkQABIrYRdsTbQjUWVFTEoHl+4VJ1DarXE35
 K0uEt1JwPn9QmT/zgmZIoaJ04d8Wqe1sOtnXwgR67PBIOQEZFUa7vM2ddJh78vVLXTCN
 AG7yfa21FXx/KZH+UoSa0Yh1lUBrTcgW2HEfdOpvbyLAUe79US3KpSpjrYfB2ZwuzSor
 I9hz4mjxd7zmmSpJJ2m4jKQ+/NXMG1v16adwYie1yBF1ypp2OgoEHE7WtZiDxf+fy1xs
 FkcobCvr8P1s0ygBzFarosfQGkQtTB3a+oKspyuQni4lkALrWCooXcKXFC2RANsAXbe/ Ug== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g2310yw81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:48 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24KIppqW036742
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:46 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2044.outbound.protection.outlook.com [104.47.56.44])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v6jjcy-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NNC7gYEbkGaVka9a6w5cyGFfYFti+nDCyo3nDYQbhjYfnYcYdFi7uQQ/QQZ2uhbdANyVr5HFTH8748aTR3h3VSoCGy9p5O7lhU2fp6O3pNwiyU6YXXyyOK4jJqk7a4eAqbqDOun5lQpydCl9EUhRgrUZo7wI/axsy/xWuuPQJvbiEZ4utFL3+NtmX2wUJjexDxjq8WenR5ubIOE9uXeYbuvJB733NHX/+TTFyBxUjgzozKKN0LDmYMJ+PoYtzKBP1OAGhWtitWawwYjTvB0A9zQbuK0mPtkvduZMVwwg3leiMGU+rk34Jd0Y4mIaBZOYgsbFqkZeEk8fR6T4bkh7NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wRXZzPTWZPEGz6h5nqB+c6sJHTwtHQF+lFnMdMmPqes=;
 b=i0A9glqUEFmbKyGJZf1UDazMAGbT/7dMfrYJpLNqWb0nVrKKVpxrWuNoCY77YIQ1+EllarVVAZ1AP/MmsQj2eqOegxTpUhCdB6eUOcMbFiBgKirr2CjYynNCPtog85n4C4xVFgJCSnTS6f53sjFnkBUcqdg+bD+xbFLV0xwMspqDTj+6dvKzoXLLAIwjmohz5Z284GEC4jOOYLOWSd97xnuY8Hd5I4ciD24mQ9OWgpnPesq6GCsuyIGykLIQQ/+41iYB+0JLmly/vZSWMh+yHub7HiE4ckSNxuokNrn68EaRi0V5GNyfKQb37U49je9ybjhFB8j9B5qNulZzINy8OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wRXZzPTWZPEGz6h5nqB+c6sJHTwtHQF+lFnMdMmPqes=;
 b=VmMtcQlqnbudSZf7ur2f5qKR5i8eujETvphGO3CtrBO+bSlhO0F7PzzsRMAVLMd84Cjw+4fd2Tm6qdA6BSY7yKOHf2UwlazuU91Prl+7X7St4PVCMpCNYiL9UBYBbaqEiS5CJCd9Pt7pA1KASqvbAAOfA+VbW3ejms6ceopDVAI=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM6PR10MB3658.namprd10.prod.outlook.com (2603:10b6:5:152::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Fri, 20 May
 2022 19:00:44 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.018; Fri, 20 May 2022
 19:00:44 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 12/18] xfsprogs: Add log attribute error tag
Date:   Fri, 20 May 2022 12:00:25 -0700
Message-Id: <20220520190031.2198236-13-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220520190031.2198236-1-allison.henderson@oracle.com>
References: <20220520190031.2198236-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:a03:217::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43689048-df99-42f2-7428-08da3a9308c5
X-MS-TrafficTypeDiagnostic: DM6PR10MB3658:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3658E23038264EB1269A1C7B95D39@DM6PR10MB3658.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g0RkFaqblNkA++hBdKkoUr4VYs68rLfzqm4QTtZR54UOU6I3/YZ8hX0glQ1TfdUw9zbOk4si+PQWg3nsbK3tenrnAYcFmoU9phceJ1bEgxjacYN9iuXatH9hUa/T2W46gsXG7kTNbZD3wokj+C+YDIsOfjCddJ3LydS1JvqgbYB1b725oX02M5hMBzHIheolL7Biin9O/9J2g1oR72iR3zFRPwer9DZ9+CJSjYZQd+Z0mY9WdMOZSFiXl9KzSYdRG2ylUqoKR+DEqtElfQKyvzwTAAa53cV69x4tJ5yUyNyW6XXeJbw2/mpF+NVkjCykP+xLoXYzdS0f6gVRPlALl48pC2dA8gi9/Uwv/heAezCvTofAyayys7mNEDiJlJBDHaID002nFPdGTWVNWg2/tMxw8f9Zq4oGgsOd8pOjlsXkRbQqvpr6SsHXgqtD9d8rPXYMT+4S4PjoS4n/UGa01X1k9tCGPMHoX54RVKwnXF9zyJ/z5xYDXN5QlhGfnRkWgJz/QBu6W4KBeXVgWVxqh79YHeYCBQJWq0PzqjnJpGvsGjJIDhJdBMDH9xJhBPZXUU6XSu4astFgu1cPhnfQs8+kP15WojCog9FxYj6Ar/snsiSG4sfJaUxv/y8W67HBsGmHSsswBCTRBUZirf5aW/GR/hlAESIkGfclDOefZ2qqe/MX8qCcweiWzUEnXGNQWofGPVbDabq/+XKuVtuT1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38350700002)(86362001)(316002)(66946007)(2906002)(38100700002)(6916009)(8676002)(66556008)(66476007)(5660300002)(8936002)(44832011)(1076003)(508600001)(26005)(52116002)(6506007)(36756003)(83380400001)(6666004)(186003)(6486002)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TZNFtaJV4li9JEyBB1B8jtpBgWp/bsHai5vf0lA3NziVDM0uH71IoQoJmEpb?=
 =?us-ascii?Q?7CovnUDeP/35Hf5Fj3AxzFeJXFHoQKfsFRLJPLyXsiMsZoLqRg2PKaP5MDlH?=
 =?us-ascii?Q?IWphbfvALDKT8eAudpoVxE9ZdXiUqpAcFWJrYZoS03FO6o/LKbPMBJCAF+ze?=
 =?us-ascii?Q?JtTAkgu8G47w2sO8QE/YuHFoWFGylglqlNagDW3ybCbuMmdAd5Ua4yy+LOa+?=
 =?us-ascii?Q?lvbUlooNL1GsQZYXKDyUglqqrM6EEvhzQGZLcih3tQqtNt9fBBTjrmdmPYkh?=
 =?us-ascii?Q?IHRcUhVtCmSNrve4yZRkp79HhVYk8uLxjNxuku6gqadpFBuOCoqHpQu3aomF?=
 =?us-ascii?Q?d79duvDM1wvZV2yDs6+QSbcB+FYW+gPUc4dn/6J1GDCUNcMeyRfJy5suEgnV?=
 =?us-ascii?Q?4EOoE6rtOd637x+CaioCHFpdY4X4NFNJTmrEbvfUdmAb/aIxVzu/WbHn8F2F?=
 =?us-ascii?Q?GoxzUmtKKkLRr7VdyxP4NOFrlKsKvDO+eGiJFQMInZ+40e/+v8DwcIq1mYv5?=
 =?us-ascii?Q?Gs5svXglxvmuDFnoSY3gj+RObsXvLtVRxudj8NqMikf7+xNfFbWEZS0wlfi+?=
 =?us-ascii?Q?NNkeiVenrCGmKpuAr/vtWpX3RRwwgzTwdtKs9FjIymqcl9gI5zeWvNoJ3lpa?=
 =?us-ascii?Q?8wYdB6Hyxi4mSFgmBSwAvLbNGV2pFfm9mqxxCdxW/wfYCPHQc5odOgY5i4OX?=
 =?us-ascii?Q?VcWorbsGqW2QfVCBTF3WMwKBW9pbQJH9w263Bo07Tvl7jB9NAknR6fG8vzWw?=
 =?us-ascii?Q?mhdTNM3VClAAxL9mEe1sIfrG9P4opYEul1Jw1KiT+Zoptxd24tWe2fCNpTl4?=
 =?us-ascii?Q?c5Qe0lIiAzCkYMmmW21K0mb+eaI9hcGxqiAq11sj7wd0MBi+JqmOm2PyjHr+?=
 =?us-ascii?Q?R4yNKTm5bMSK3ifWCHFWj8i4kpcJnWCHQ7R/d1mFILZWNG6Brm771DL15c2H?=
 =?us-ascii?Q?gSf89xXenBL8c4rbSop9KVr7JhXceHKT14gXdLaZhPYe8Q0iDadj1hoV7Ty2?=
 =?us-ascii?Q?x0ejdSHKlQFK9TKlJ3CAOuQdJF1sire5xv/CvHlQ6YJ1nuiG3oOAFHyYAESF?=
 =?us-ascii?Q?zHSss0zEcdTrahproiMuP69rsuNB07MU2I8xIh7g/UdcPLCqLdQgGiU9GmAJ?=
 =?us-ascii?Q?YGAValhq36KPNbsnkdcsR6TiGgMbg+nM2UyNKLQNlbIj80zV4kyGxuB4ijXl?=
 =?us-ascii?Q?xOZ288NQOvimGjqGp4r+FaF6hbC7QEPVBSC12YSzqxVWD7GNT5QjC83PrBeM?=
 =?us-ascii?Q?L4vKfhXfdRcklr1ZB/St1JdMeTwGGO0RH18o8m/FDq4VPKKRNsagCcnmSksX?=
 =?us-ascii?Q?zbFp4FZ+RXsRU+BPo7+wBNoljHET3INA+OXoEc4EgFaGc0HktWR+o2NdNUHI?=
 =?us-ascii?Q?H0BtNw748GrbySMKAcgqivuFGePfQQxgceBVUUHmfYY3F5rinmTm8jARLVPY?=
 =?us-ascii?Q?pqCOiK8jCJu/l1Mp9au0VEo7IwhG6ngMDPr8moX7X8V3hnbTVlrJdi5pggXq?=
 =?us-ascii?Q?tLhzFSk+xM3h+7tZ4SQiH7QkG/YS/t8FOGbKFysMqDZUTIgER+CygAlEPzha?=
 =?us-ascii?Q?DJtsIhW5IFL4x8NRWAybgWDCcMHvtK3trqUGFyH8ZgDNUWiBZQu0Ae0zTt/5?=
 =?us-ascii?Q?iiex8ElXmgKN+VxsifIS5XOpT68Z+uiuNCNCa04G5Q4CawA4tJbqtFkC3uL1?=
 =?us-ascii?Q?slZ5FyWQ984QCiAIgQsoM1LYYk+aF5UXSBLNicVRMK40glG8WWOlz3iOjLKh?=
 =?us-ascii?Q?AkJlmbj4ys7juydil3AClPuEFQW/0j8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43689048-df99-42f2-7428-08da3a9308c5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 19:00:40.9357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8i6fJMrBS48yncou41Eiutp/OXget4GDrHimMnO8kROSyoHvVaosrlBsc+USoWoblrG8GxtLDAweVrI2xscGDzJdCgw+7kH7BlqPJophWzY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3658
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-20_06:2022-05-20,2022-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205200119
X-Proofpoint-ORIG-GUID: ftZalS_qPgJeju-i6mk7MQ6qibpuYU0D
X-Proofpoint-GUID: ftZalS_qPgJeju-i6mk7MQ6qibpuYU0D
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: abd61ca3c333506ffa4ee73b78659ab57e7efcf7

This patch adds an error tag that we can use to test log attribute
recovery and replay

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 io/inject.c           | 1 +
 libxfs/defer_item.c   | 7 ++++++-
 libxfs/xfs_errortag.h | 4 +++-
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/io/inject.c b/io/inject.c
index b8b0977e139e..43b51db5b9cc 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -58,6 +58,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_REDUCE_MAX_IEXTENTS,	"reduce_max_iextents" },
 		{ XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT,	"bmap_alloc_minlen_extent" },
 		{ XFS_ERRTAG_AG_RESV_FAIL,		"ag_resv_fail" },
+		{ XFS_ERRTAG_LARP,			"larp" },
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index eec2c6c27bee..17e635224fea 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -173,6 +173,11 @@ xfs_attr_finish_item(
 	 */
 	args->trans = tp;
 
+	if (XFS_TEST_ERROR(false, args->dp->i_mount, XFS_ERRTAG_LARP)) {
+		error = -EIO;
+		goto out;
+	}
+
 	switch (op) {
 	case XFS_ATTR_OP_FLAGS_SET:
 		error = xfs_attr_set_iter(dac);
@@ -185,7 +190,7 @@ xfs_attr_finish_item(
 		error = -EFSCORRUPTED;
 		break;
 	}
-
+out:
 	if (error != -EAGAIN)
 		kmem_free(attr);
 
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index a23a52e643ad..c15d2340220c 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -59,7 +59,8 @@
 #define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
 #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
 #define XFS_ERRTAG_AG_RESV_FAIL				38
-#define XFS_ERRTAG_MAX					39
+#define XFS_ERRTAG_LARP					39
+#define XFS_ERRTAG_MAX					40
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -103,5 +104,6 @@
 #define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
 #define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
 #define XFS_RANDOM_AG_RESV_FAIL				1
+#define XFS_RANDOM_LARP					1
 
 #endif /* __XFS_ERRORTAG_H_ */
-- 
2.25.1

