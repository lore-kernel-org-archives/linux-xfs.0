Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 338E9C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Feb 2022 01:37:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245529AbiBPBht (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Feb 2022 20:37:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245534AbiBPBhr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Feb 2022 20:37:47 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2687219C29
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 17:37:37 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FMYae3008658
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=sQZ5OGSkt4+b23rHasRTGScBZQs+sjsUTUO4NULhIXk=;
 b=s48cL+gPElkBjT3eWwqiIyNbnk7oI14IQZRwnmS+wWcEv9KByASUU1IGrT4vzyNJOzaS
 gsf2zisrRHKbNGjW2MesGgRNZeqmkZ3a70jhju+B9PqKKTS4uZTkL9xuIvMOzIZQWp63
 KmlcdBECJz4dijIuyby0cUllkibyWnh5ghHC/6jdg/uOd+KAAjgghgbzT7DufPRPK+t0
 6pvEQDYrzlc0oIf22a/1JuVHwFZyVtpPtDluZ4Yeged+dM0GoHOORFdJ8DOiip1eDwzU
 AuCZizEFBxWEKIdAvSaySqh+q3mAXjkS4T6EdMdilovOuEDyYFyBzP4ICcE34tdi62VZ XQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8n3dr8cw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21G1VQ5Z138923
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:35 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by userp3030.oracle.com with ESMTP id 3e8nkxj2tr-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UZhwvInonod/zVuEraR6wQ80JiCH2GjElJMMuL3rmkOFi8IhhmrjReIjwSfs6efTca6V+LzLHiAVw9bExobxm+len+6obJoqW+gXmmY6K/2J6DrWjwvMkkkkVWfkQoRORen7F5zGeRGQw6GAlnrGUga2ZvJa3lSfsTdwLLRdc39DFZ+OwdBzejTHkWBnd5s7ZgshMK0vMz5r2I5GRkFEODRdDN45ly0WW4i6j/J4SRzbhYnMwZzQ1kbKesLse6ECom/ANMzZkv0C3XaAzt9GYsAdYYBr2HKcvbTH6bbpJB3kYGO3Nku4pbtOIy2GIeBIaeI5uRQJ86hmHgIBfngOhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sQZ5OGSkt4+b23rHasRTGScBZQs+sjsUTUO4NULhIXk=;
 b=mXWpYcw4Of1QvLVQdRNwWzc16Vpx6PMpm393DyTLwW0zE5L9TnrnfP6m2BdxkYtn+oyjrjMlyGPEe9DHCuTP5IF5CWMIVkrDfgXwEr66rsVzzWR5w7aIXT5nmssXv2IdMe5jcHpY5HYlSDDzsKehW6hQR1dk/DuXZaVGrxD7ypow2970mNHTY2Sb0TYmiNvFqRj9/TtJBe84cFuSJeeggTxh/zfzgUSEgDi6uMj3gYgkXuPNQvUALeswuFZK4TqpgwEly7UzmUPPMR6DrUZpiV4/yht0HHF7fCCymoulK3gG4hNoeMBR91bg9GJwmBayEddoa06o9leWnOdIokMorg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sQZ5OGSkt4+b23rHasRTGScBZQs+sjsUTUO4NULhIXk=;
 b=KDf2yZzmFFvFDRd3+WSiw1yjyrfGPY+PvGD/UupCqRiaC1HG86ZT7k6W+Gd+dq5vWjP01dDS6vzuIex/lCvE15n5tIadUvV0E5esKvsWJnXt6y8A2zwuPhqeJVlQ2t5utG3Yr5DukvFi8PB3ev/L+xX30l7qhL7iixJqJTqmvQw=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BL0PR10MB2802.namprd10.prod.outlook.com (2603:10b6:208:33::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Wed, 16 Feb
 2022 01:37:33 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119%6]) with mapi id 15.20.4995.015; Wed, 16 Feb 2022
 01:37:33 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v27 15/15] xfs: add leaf to node error tag
Date:   Tue, 15 Feb 2022 18:37:13 -0700
Message-Id: <20220216013713.1191082-16-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216013713.1191082-1-allison.henderson@oracle.com>
References: <20220216013713.1191082-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0046.namprd07.prod.outlook.com
 (2603:10b6:510:e::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29832798-40b2-42be-46ba-08d9f0ece2ba
X-MS-TrafficTypeDiagnostic: BL0PR10MB2802:EE_
X-Microsoft-Antispam-PRVS: <BL0PR10MB2802C73CE8EF5F518E26B9EF95359@BL0PR10MB2802.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FXbytw/br/a3LaOQGhVsHR9k4jDgaMV541Af6iXM3pr/hfjAFcnZb18MwRLv+kxz/AbFnt8en/+Pd6bNHCbiwTBQ4YxzzD0LLDR/oAJT79kVp6/PNP6PwbJH6/m3qAXz17c7XTxxOd6OAqvyG9u+w+EbkB+eDtdatZq5TsZUKh88yYTvux2QrA5m7ktP02mMEbajSlAcJtH0JstDMfqhKvUPAAq8ZShx9pyTSLY9RviApmpJuzg1H4zJNlitXUxti7mmUr/ljftSEVrniDou4MdDCbOsH5D/po9qLOYDkvj69/gvXgEOiQlF6WLHCS/OY0txav2p6VQn/3f2mjGZtCYe5PKtXuGMl6XkMfpSBHeXMlxjvtZAyOfaVUgGqN6mZSOoMP7B7lq+0IUXBhxtYnFhdz2awdtdbHRNp5ba1nXOS+KwTJQ47yybuhzDRR/nRG1aR0WcqGRU/MMw8w7togXlseBq0AdpXbYs6xdoh+HHtsP7GSSljHgFxoHgCyOrGqbVhrRH6uWq2E/PTgtcDtkRuhVTjnwDk7R4/pA8t9KiYWLQ1/D1apIdXyws+U+4tThGmoBeRPGXol37IjehuAKeUAoP8XjDkMDPBMAiv/+U74/Bh//PQh6qz6RWFMsCtJ/ci3J+kmKnci1DpRzHkyS/aw7YsHxjRLefPHiOoVNF5qzqkM7MyX46Zdrs/5ITYOWieuvzUOSj0w714tcWCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(186003)(26005)(1076003)(6512007)(508600001)(2616005)(6666004)(66946007)(5660300002)(44832011)(38350700002)(38100700002)(6916009)(6486002)(66476007)(52116002)(36756003)(316002)(8936002)(86362001)(2906002)(8676002)(66556008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uxR3cU87yC3/9P05x3IzbM3/p41IrOzX4b9bDYgoFacAiYsIezapqYMl1K6p?=
 =?us-ascii?Q?nmAiQm5FRSUrdvW6niFg5aJYWTScNX/h1icwpSPkmV2fXDoYM+j7QpOdTY2c?=
 =?us-ascii?Q?KVZdA7fj1qJ4ZLvvYAYBWN9F93V5B4cAB+xNQwKqccws7D9I1cDomNkMp4ko?=
 =?us-ascii?Q?MLKwon9NmEr2mOtmuiYIU4cXfB8CV8j8QRr6M8TBiVeSSBCkPvKZ9lA3H/Pz?=
 =?us-ascii?Q?NaqhCb0pKruHea2g4oCovJWJcLd78dVAwn3YNhIrCHNYBNUblQvywooL8R/C?=
 =?us-ascii?Q?+neUnpRHtPT0Wow/dtnRA8y5F0xmKlOAZY3GZU4q3KvtEcIZHPGuWTxnTWVW?=
 =?us-ascii?Q?WM4UBIxlO2peiwI2aTn2QjoL+xW27GdmqH9cc7bNFNRHURr3Q8cKpC1UgnWl?=
 =?us-ascii?Q?lyrVyD77Df2XwPx8KmvtKee/IPv2cep2gvMMR9ds94HsPEkwy9VqBAwifqEp?=
 =?us-ascii?Q?4WgpSvw3JDN5KwXw9icLQ10eVUgDVgZuZBwoAQYr11jTVsXSb/05NKFDiys3?=
 =?us-ascii?Q?ms4i7SsrpQBfpKloOCKPGe9I/34z0Tf9GEYrX88G+2c7CzAKx5339VaaLG1E?=
 =?us-ascii?Q?NGS9E6TgkgTWxmKBrl35JNKHDp1VEsRsya5MdaoKU3RLf/ZclWAH0RCldQ1v?=
 =?us-ascii?Q?y+8qWNdjBHrG13f5g+W92HvcI6UAMaJo+1oQHrM6yVxCE69H2VUvsDbjrSwc?=
 =?us-ascii?Q?BopPVEKDaXL0zobmqkoRrL7ebkrFVoWiSorpup+uMN7Ghp6TDLqI81bYrMGj?=
 =?us-ascii?Q?+jov7nhbDRsroK1skCXPMCBmHaqe5UI+wUkJn/yq40+ZvIuYFWWsLpGqnyrY?=
 =?us-ascii?Q?7ve2oJOXIuXF3uTFQ0hpd7uI/JzkhTyanzV5OOHP5TMtPPc6MWVHlS4LeIov?=
 =?us-ascii?Q?Z9VLlc8X7qRCu4eFJA+Q2ENySrYUdYdYg9z82l0eLoTMxzzNJkQAJjHkyYfR?=
 =?us-ascii?Q?aR6lKJzdK6O9NG0Lyh+FHPCRCaamKukA/qo35fo1HjRNValQWyr22A2/YbIY?=
 =?us-ascii?Q?4jjStLlZihYI61jkbx8zZWdRmhYndO41yjGf9N4fp69K0VLSEZsE9c1vovYj?=
 =?us-ascii?Q?F7TnbRsX8Mx7It0q5Od2V5EslJcMxdZnwY9iYNRQ0r84SlxxWE4REvOzCOHa?=
 =?us-ascii?Q?IeKO8EjC64CCO1ryXG2EIj3x2yDi3Kti20gXoPdl4iD+nSStRZB89u59sb8f?=
 =?us-ascii?Q?t6i855Nq3kNuZ2050IHUuAZEKiKM4Of0tHE8SLhZp5QTWSak8JVbldw4XE5Y?=
 =?us-ascii?Q?+cAk1BPMMCaVIZFRTUub1jRMLvCelK9cgVUQMdUuF8qgZO7mUve9cuGBReKk?=
 =?us-ascii?Q?EqMrdNO+ZNH1rSeJRBQ1HZmx+vDnwiO7Lvv9ra3VrH/a3lU0Md7PnnBr4LMa?=
 =?us-ascii?Q?+YoIyEBePwaGRGNW9w+myrq6Y4Oa4ekYLrxzsJqsPUl662TF+fp24MgvmhBx?=
 =?us-ascii?Q?TBQ+26GG64CzsOdnoHmDZ33fnmYKvbjB4Kk2PSNNfeAKUu3nkyYpiF2SgM5y?=
 =?us-ascii?Q?64eywwMp2GqtZSVHIsYZBXjmcfGM3j3iaNMFdOiLFXo1ylUMX1iSyoQ5RfEZ?=
 =?us-ascii?Q?uJFrbBhDxuZ4WWCWhvucE/XJtzv+1IpbyMjJUTAkXLX8l/SFP8hLDXn4l/gY?=
 =?us-ascii?Q?/zYGzwnRKVnvg/s9K0IXOzXStFVy0ywLjVAE9Ta6MmoGHCLd9M32cG4jN/HI?=
 =?us-ascii?Q?Shjeyg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29832798-40b2-42be-46ba-08d9f0ece2ba
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 01:37:25.7067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7XYHpQKh4tOxbuptbVDvLg1mDQLPaFg9MZMG73CBZNep03Bkf4ZzKhnCTQS9m5cLxJdubNxiI7BQs5X5E3DhJ+1gp6LQoW/lcSKgYEO2Eo8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2802
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10259 signatures=675924
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202160007
X-Proofpoint-ORIG-GUID: XWLqv00p9F5bnVJrUwFjBVtiZC3_VfVR
X-Proofpoint-GUID: XWLqv00p9F5bnVJrUwFjBVtiZC3_VfVR
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add an error tag on xfs_attr3_leaf_to_node to test log attribute
recovery and replay.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 6 ++++++
 fs/xfs/libxfs/xfs_errortag.h  | 4 +++-
 fs/xfs/xfs_error.c            | 3 +++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 74b76b09509f..e90bfd9d7551 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -28,6 +28,7 @@
 #include "xfs_dir2.h"
 #include "xfs_log.h"
 #include "xfs_ag.h"
+#include "xfs_errortag.h"
 
 
 /*
@@ -1189,6 +1190,11 @@ xfs_attr3_leaf_to_node(
 
 	trace_xfs_attr_leaf_to_node(args);
 
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_ATTR_LEAF_TO_NODE)) {
+		error = -EIO;
+		goto out;
+	}
+
 	error = xfs_da_grow_inode(args, &blkno);
 	if (error)
 		goto out;
diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index 6d06a502bbdf..5362908164b0 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -61,7 +61,8 @@
 #define XFS_ERRTAG_AG_RESV_FAIL				38
 #define XFS_ERRTAG_LARP					39
 #define XFS_ERRTAG_DA_LEAF_SPLIT			40
-#define XFS_ERRTAG_MAX					41
+#define XFS_ERRTAG_ATTR_LEAF_TO_NODE			41
+#define XFS_ERRTAG_MAX					42
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -107,5 +108,6 @@
 #define XFS_RANDOM_AG_RESV_FAIL				1
 #define XFS_RANDOM_LARP					1
 #define XFS_RANDOM_DA_LEAF_SPLIT			1
+#define XFS_RANDOM_ATTR_LEAF_TO_NODE			1
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 2aa5d4d2b30a..296faa41d81d 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -59,6 +59,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_AG_RESV_FAIL,
 	XFS_RANDOM_LARP,
 	XFS_RANDOM_DA_LEAF_SPLIT,
+	XFS_RANDOM_ATTR_LEAF_TO_NODE,
 };
 
 struct xfs_errortag_attr {
@@ -174,6 +175,7 @@ XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTE
 XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
 XFS_ERRORTAG_ATTR_RW(larp,		XFS_ERRTAG_LARP);
 XFS_ERRORTAG_ATTR_RW(da_leaf_split,	XFS_ERRTAG_DA_LEAF_SPLIT);
+XFS_ERRORTAG_ATTR_RW(attr_leaf_to_node,	XFS_ERRTAG_ATTR_LEAF_TO_NODE);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -217,6 +219,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
 	XFS_ERRORTAG_ATTR_LIST(larp),
 	XFS_ERRORTAG_ATTR_LIST(da_leaf_split),
+	XFS_ERRORTAG_ATTR_LIST(attr_leaf_to_node),
 	NULL,
 };
 ATTRIBUTE_GROUPS(xfs_errortag);
-- 
2.25.1

