Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3132C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Jan 2022 21:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344336AbiAJVZ3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Jan 2022 16:25:29 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:4616 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344267AbiAJVZK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jan 2022 16:25:10 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20AJlXfi026179
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jan 2022 21:25:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=JYaMeqwzhq2D/4Q9fcuvcxFxVadRxmdIwuW3Zo/iT+I=;
 b=DPcbO6y6SnNG5pKEszbMwAcKyt/nEp7XaeX6k4nqlHC1gm7tOPsI9ES5YvR9aQRn0W0+
 7C9gTuyE+nRrQ7JIMOkY/TCr9EVD4aHlGXmKm9jQgEJrIYII/WzetHhIM0opOq+wIK0/
 kIRyiUXyyl5YnTIPaZ35rmLMHKpUx/fHvcmE8EvzTa2l1daonjdDwMOamKb6Sef4NwIV
 whlNxNbw0yiYzSKBXEHpJLzJdO2Y9CPf4yFfkoXKQEc/aI3KMyLCJ+hILAZJZErm3xY8
 Y4bMX2hcNBkWozGcuNsqAIG1Xe1z/q3L3YbzcTnxvp2IQme8jvIaZBJqGtVKclR0ajLT eA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgjtg9q8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jan 2022 21:25:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20AL072U013591
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jan 2022 21:25:04 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by userp3030.oracle.com with ESMTP id 3deyqw1ndt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jan 2022 21:25:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ELruCVLQ8KdMAGEORtLwsPq4iZ6rzs5cU1xU8V1GOXuKBYhyxRgpdPXT9AAtYji92bm/XHmoTKD267aibg15/DDBeKpQCXAa1PKH5vTIVcDwEohBTOSETPDJQnmPdQThGFKjtKS1nLhmNrBHCaotXiVnw3DzgtE+jX+nw7TEsog4jkHZ8ObbGAtkkw7dma8/DBh+CH0SAGmRW1xdeIdYRw1QIVc8oCcb9geO0w1Pzy1X3u+Mw2NzCk1zcJ6AnkBBm5SMK6Cd2n8ghNE9Ok6mBDsYjig/RU0L5zEVAI6scdI7N1L+A/mpGuOi6pzYo1oD8UklV036r2sM1pqRM08OYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JYaMeqwzhq2D/4Q9fcuvcxFxVadRxmdIwuW3Zo/iT+I=;
 b=IemAw7W1ktbOd91Gx0Rqet0PUNpODrXCQqRse69dn4oTMdcip2PsqvI/zke1BYb1FYz7uBCQvhpN1T/M0EnhC5Yu8jzNTsKDEGuhxoYz1I71vWJecVlbmn+53RscIoej3sSFlXUVEZPD4ch6dzIqUyKT9WrmGMNwAd3+bmGRLnZM8TbyTtKBsi1Fbm2IuaGNWb15p4q/WvmX0TpKBYrWxLJyf2Yj7aTyPG1sxDGq4Rnwnfow+qI0Cwffvyzb41s41FgSIHQctjTZnvsUkb+4rXkZc0krDXKUnThLQPFBukZy9gPBiNdGIEUKJlXoCIVTDBRwHgXwJK8W62rGb7N6RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JYaMeqwzhq2D/4Q9fcuvcxFxVadRxmdIwuW3Zo/iT+I=;
 b=scXMK6ywW+f4EF/nChg5/Pie5h7S6kwJ16wf4rzXJZ7mQYaeNjGoxoaR3A63KSQk2HOfDN72vv3BgoKzU8hk4V8sHRlUFS8/TFsBdki45KjRyhk07on/1gpQcM1kaePsT87W1vViSuuxabZ1jTnDYmOsQ1X/Y8Bxla+7dkxarAI=
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DM6PR10MB2570.namprd10.prod.outlook.com (2603:10b6:5:ba::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.9; Mon, 10 Jan 2022 21:25:02 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97%5]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 21:25:02 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH v2 1/2] xfs: add leaf split error tag
Date:   Mon, 10 Jan 2022 21:24:53 +0000
Message-Id: <20220110212454.359752-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220110212454.359752-1-catherine.hoang@oracle.com>
References: <20220110212454.359752-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0136.namprd03.prod.outlook.com
 (2603:10b6:208:32e::21) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63aedcc5-4b07-479c-bad9-08d9d47fa8e7
X-MS-TrafficTypeDiagnostic: DM6PR10MB2570:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB257028C21C72B1CF251D88AA89509@DM6PR10MB2570.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 68D+vL4BBCRvDzK8s4Wr0AFLkRHiUb7L2TrotiKXUdhWiwVqaSDp3V4tFYaVyrpsik2JZG+BZbmyumhWw2liMexCFV5Vah5o+6l9ew9NffwhCBdNfoFE9m6OZbZ66v2qnOefH9iVHb8wVi4zydDl0FTi7W34l3mloYZqeb2fsN6fQJIj6RUEFXKQ77kvvwMyOs27rJ0hyA+OlJYz2yictzRjCuJq0+xMHrDa+GrwlHT2yODMT+G88GhD9RTsn3G2oVIeI3/AoEo/aL24gsb2RNjf7bRxTkcQD1ccRz2rw1+ZBGglFqK6wE2ueX4KjcfeLT+djXDXaaQUGFRZRd56XrNjDpqZy3ev6cXMrFg64WNhALgNJLYSyXBPsZHPduB6t7EQYC7nq/+Xlhgz2DzagAQYj+wqQBtHlgBply/DkanDofPUHEfnMiza0xjMx1/zNoeCwzWrHJ81GSwkG58gD/ZQ5Zv3dYziKT65j1ryeCtGn0/BUs0vuqFHJq8fwwOyoFzvLzQKM2K1afsHypWzxGCO5gmvopi2BD9U2J4zhNXfcno3WXiLclhJW3C35QGah3Z45dNWbVLfo3bvDAYFOYJHCi1rPBWvvyfj/s7z6qaPwrctbP5bll9kgOJgq57JSXGw/Esv8B92FtvUDoKYPmi1dKariqj082TD60sO5DNo3eIHm756qrjtPbF1Qw4wbrMUIZq3vGDfOfVRlcH9tw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(6506007)(86362001)(66476007)(5660300002)(6486002)(66946007)(44832011)(6916009)(26005)(316002)(2616005)(186003)(1076003)(83380400001)(6512007)(36756003)(8676002)(8936002)(52116002)(508600001)(38100700002)(2906002)(38350700002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YAV5kYBlZm0jt354ivTIQjco9iYFmc1QEQ+UdRCo5DxKC3F7/Jul6mzY93iN?=
 =?us-ascii?Q?ApcHdWhCj3thquHEknMnoIvzUFiHbdf++/OpL2LW+A5IYigszONgZXGxa2rx?=
 =?us-ascii?Q?s0gUJENHHIzWUpc6+akqWD110WZmeqccyNC3d47u+R8DnxYwYQOPA/Z3oSJm?=
 =?us-ascii?Q?Q8lSs1Qnba1TAPVw0vCKWVDfh1rjJcqEyInXlNP0cMxLQWYn0/Gn94LygYrw?=
 =?us-ascii?Q?9t1Jkx308tqiAQ3cQBk9GFWOK+igGI2azq6F8e9MvTR3zGmlsN3q4gooHTGU?=
 =?us-ascii?Q?Su611REWR+ttXtr8tWdkJCTZ7goJnP4qrxwECFu4Pc2WrPTzsUkOgrEl8PlS?=
 =?us-ascii?Q?6uFCgEDrcr6pFLDr5jj68W+u0UCFB+RGy7VM6ee+JSDFhcR6LALQ5WzjbF3V?=
 =?us-ascii?Q?1snDzPHEGfTb2mHwVqSoLDrd4o+JP+LkAV7RHSiRa08kVCCwHD8PqT8HecN2?=
 =?us-ascii?Q?Gmcc+ZD9KV/1MOMl/t4dA5GEhC++26dOYgpliOpCf2zcOUolHBiOJZINnib2?=
 =?us-ascii?Q?33aHxza2ZygNPrCnNM9meC+smoqsV9FA3/VKPjcAN2fJ7vknVijKU0btykw+?=
 =?us-ascii?Q?lOZPw+0BQjgUppxxfpRyzfFgLvaLRf9DMM5j3ieMRvsjUVvCcBxwqjAYKEcs?=
 =?us-ascii?Q?OmOn1loq3D3/VkOZ1GRGwuntSMWR6Eoo0e1BORy4ypec3BSlU0XNxx/YAffJ?=
 =?us-ascii?Q?mp7MQsHCoqlDBxIJqH+ShLJm9RGgCgGuUK02rRHYIH0DGuHPwdaXixqCoifp?=
 =?us-ascii?Q?w4h8YIytFMWxRGitDlp/VkYN4orIqD2JWPD7ZMm2nsRcC/+40dfWw8WSnh5Q?=
 =?us-ascii?Q?uGECi/i0YM9tax3rrc/8sruMUaKB4wfRJ9iquYIMnbPrp7r166mbIH+yQFKP?=
 =?us-ascii?Q?IZcieX3Sx6k3ORGgTRr7+s9C3sDfTWxZFF04djDHsSXR8VTjl/NBpioHO6ps?=
 =?us-ascii?Q?Y1wUb19cuipao2JDBr9P9a3p/JeZpTm7wHJmsYNriV4yCRVEAgKkC4sGg2ng?=
 =?us-ascii?Q?fj1rBoTwSUNRiwjYndJETOtgebIae4ZGeXgI9wRk98kOrtQhqMIdMJj6/8km?=
 =?us-ascii?Q?7Z/zoGaX6OtOENj1RfTN0c+ZWURCpeT24t+hJmhShcM0yjxvU20hL3yJ6mk8?=
 =?us-ascii?Q?d1ZuAgsxx6Hp4eNyqWkqmZCiGgAisYFkOciBq0lwyK8ZDBDmmK/C8OyNbzPa?=
 =?us-ascii?Q?16gUjXFHHe97+Qh743xlzoiRLNRtq3zG8KEtVDewedzUy2lTT1q6z8Y+Xjo3?=
 =?us-ascii?Q?+6l7Z09W/a6yEaM/GPi9cV09xc5jzN7WygkdwU2PQuP03TJ6zg9LyJ5P/5w8?=
 =?us-ascii?Q?kENl4zNMOM8024ANHGRzu35YZ7ogr7Dx0vYaysD2RKh/eRgNExmOqmkDg0WY?=
 =?us-ascii?Q?F8SDDRH9Dcbvv3wRjW5E7iS6x9OKdZgkltFFEfHDVHIWfsjoLxRpUfNeP4fT?=
 =?us-ascii?Q?iJN4iabgWFEQKGbzw1uZhu9GNRBAP1Ih3vH1AIlSnbGuwuxSMWb9TXTFA6/s?=
 =?us-ascii?Q?eC9kCaKCQNdIVVIcnoaVcMzSEfC8Hj8Nn6ul0PDrwa6gZIrn9auMcj9RP0U/?=
 =?us-ascii?Q?PBOL1IRqpSe04yy0cFwOcx7NIaXK5Ny53hByLOs8R940zu5pSMBSkFg0EwBR?=
 =?us-ascii?Q?Zkkf47V5/n0OnoIkUx5WRIWnY2wmP+Yboz5ud5jYIwI5wQcsDviJ6OH96FaX?=
 =?us-ascii?Q?xk7gvg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63aedcc5-4b07-479c-bad9-08d9d47fa8e7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2022 21:25:01.1188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZukO40XZ7aGi09C9/B9E2oHMDZ8t/x0Wl87iqWDq2ZWlrrihSBLj89efjWAFk7QMAi9GZe9RnjJKHvIQnodQ3vIUnBecwRkBmAhUI5F80gc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2570
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10223 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201100141
X-Proofpoint-GUID: Tn1s6_slouQhwVSjjseRbSGRbEWPw5y6
X-Proofpoint-ORIG-GUID: Tn1s6_slouQhwVSjjseRbSGRbEWPw5y6
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add an error tag on xfs_da3_split to test log attribute recovery
and replay.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.c | 5 +++++
 fs/xfs/libxfs/xfs_errortag.h | 4 +++-
 fs/xfs/xfs_error.c           | 3 +++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index dd7a2dbce1d1..258a5fef64b2 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -22,6 +22,7 @@
 #include "xfs_trace.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
+#include "xfs_errortag.h"
 
 /*
  * xfs_da_btree.c
@@ -482,6 +483,10 @@ xfs_da3_split(
 
 	trace_xfs_da_split(state->args);
 
+	if (XFS_TEST_ERROR(false, state->mp, XFS_ERRTAG_LARP_LEAF_SPLIT)) {
+		return -EIO;
+	}
+
 	/*
 	 * Walk back up the tree splitting/inserting/adjusting as necessary.
 	 * If we need to insert and there isn't room, split the node, then
diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index c15d2340220c..970f3a3f3750 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -60,7 +60,8 @@
 #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
 #define XFS_ERRTAG_AG_RESV_FAIL				38
 #define XFS_ERRTAG_LARP					39
-#define XFS_ERRTAG_MAX					40
+#define XFS_ERRTAG_LARP_LEAF_SPLIT			40
+#define XFS_ERRTAG_MAX					41
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -105,5 +106,6 @@
 #define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
 #define XFS_RANDOM_AG_RESV_FAIL				1
 #define XFS_RANDOM_LARP					1
+#define XFS_RANDOM_LARP_LEAF_SPLIT			1
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index d4b2256ba00b..9cb6743a5ae3 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -58,6 +58,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT,
 	XFS_RANDOM_AG_RESV_FAIL,
 	XFS_RANDOM_LARP,
+	XFS_RANDOM_LARP_LEAF_SPLIT,
 };
 
 struct xfs_errortag_attr {
@@ -172,6 +173,7 @@ XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
 XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
 XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
 XFS_ERRORTAG_ATTR_RW(larp,		XFS_ERRTAG_LARP);
+XFS_ERRORTAG_ATTR_RW(larp_leaf_split,	XFS_ERRTAG_LARP_LEAF_SPLIT);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -214,6 +216,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
 	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
 	XFS_ERRORTAG_ATTR_LIST(larp),
+	XFS_ERRORTAG_ATTR_LIST(larp_leaf_split),
 	NULL,
 };
 
-- 
2.25.1

