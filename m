Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41D2DC41513
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 04:38:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjGXEir (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 00:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjGXEiq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 00:38:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2831AE
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2023 21:38:43 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36O2jvwI026582;
        Mon, 24 Jul 2023 04:38:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=0CKwC2CoIEtNnO8MqxKFadtmJShtmE9M1RPyfQK3TOU=;
 b=tBWJnobMhsW+XAeL681XQOWskSd1PXBriLd8qhTLEdZQncXhgQaXJmFLewT2PXG2IKS2
 gFQgJKlLHIQ+E0EZD5L7p7uFfm9SG4XMWQvCcy1OR/g/hEU8pzLEnrP2vlpONskjqMhH
 tcQ9Tx8jG2N7SjQO6RwD0AXv7XoyVthov78d//MlOnDRhNAsl2lcu+h0Wsn/kMhfx5p+
 4SasdethQBGyCzu5u365C049XTHEx8jCb40Imj08xQSbDhEw28atlNhphDJwEJ+8IhAe
 KbauwZ7M4b2nrAkjdlkSwzmQEYWXKuJ6W/fEuoP/l0v7lMhryIouP6ca5E421jbTC+Ih BQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s05hdsv9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:38:37 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36O1vUJI028903;
        Mon, 24 Jul 2023 04:38:36 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j35ysb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:38:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YMHJG4Uf1KfVzh2kjdu7sKz2IoLRWlSDokd6SvSBiwKKd5YR2E+cfiJlML1Sof2pSPc+npvwaUk6V2TzfTIUfdxRvy73HTrOJezLB8e8rzmjc6iHDDVIfprz8X8tps0rZ3GemBVqthwPv6x6mP0B/Ky0X3mi5BPVj62NnXktlwRMxyvCZLv7/pTxI5M0Cf0W+PrgjZbsbOtqsswOOkVm2JZtRITpUWBeEusxDiLlm1O+w+/vmD15OpPCKG9dTsk8301JCEvjIhrMIou5s/DZLVRpllRYPnq3r+lZDN+v2MNeN1Zt5/6Anp83n1m6A4G730ErwatPcDIX8zNXXZQkBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0CKwC2CoIEtNnO8MqxKFadtmJShtmE9M1RPyfQK3TOU=;
 b=Eow5Zu0fn1wd58ZpuHlF941XYR7guApC02Eji3Jxx3daxk2Ml3UgS9ixinAo8TsZnkSsquIe+N3QbwXk4Vzk1l7cq/geFSnSZ5UgItYBU4YjoVnZ9udtsVX70gJdV8TvRzRlsthW0q34PfI6sjtxNeQ9KCpu/HCdCLySWkDX7Xp7QfNOPadXVxxg9Isr8KvJ75cyfnuWSNp0rAmq2v4kjtUNoxXhIXDbkRGLcNR0eLi2fH1TifbfryqJB8cnlRwSWVm9V4q3NLxE5bYejaBmXhDAwNaC3sFpY86lq6PruoI/RYFYWyuVaNUFKoeOo02d40fH/xb8tqpwjMNSo8EsKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0CKwC2CoIEtNnO8MqxKFadtmJShtmE9M1RPyfQK3TOU=;
 b=JO/F0H+RDmem6Pn2ZnuIgKLcdFPqC6oPStV4utKCku4qRACjZlGv7JadHIHeeb6TWMM6HQgIIJM6z+AXEHZfX+hRWTMRLu0e9DtoJRy0YFSw98ecbSOU3gGFzISx2dTDoRe2+I50sucpDpzCOwk6UQkdvJCD3/f7cxPSOOKobAw=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by BLAPR10MB4963.namprd10.prod.outlook.com (2603:10b6:208:326::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Mon, 24 Jul
 2023 04:38:29 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.031; Mon, 24 Jul 2023
 04:38:29 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 18/23] mdrestore: Introduce struct mdrestore_ops
Date:   Mon, 24 Jul 2023 10:05:22 +0530
Message-Id: <20230724043527.238600-19-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230724043527.238600-1-chandan.babu@oracle.com>
References: <20230724043527.238600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGAP274CA0004.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::16)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BLAPR10MB4963:EE_
X-MS-Office365-Filtering-Correlation-Id: 78b2d980-1c50-4c83-b9bf-08db8bffd3ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vGt5USDoNDfzCqAOI9Z6xW6jPvA2K25ghpnufEJW7ZV46R8KC9sGeG8MZqUhGLNhLJAF2gtQ0e+KaQyqOiQ5CN5yjqB+1kDCNamgjRGyQY1ciShooE3ap4l2iPLucGr5k4+b78etASsu3jkOp+bm4uihe6o9jRmSYvEbFaVtI3UKP6hVGsnS4JEBszR1k8qPj5WeYcR+QkcdzVep0OpdYFKflb1/P6lkT5rSVxgh/RBMwokdYpUIJ8edWlnajr+CM5R8AthizJpJEt9/NGkadigG8EkqHd6CTPY3hSutBMCnW0BAQD4KR2T1O9RmREszW8VE3RMFZ8nZ9kHfV/XbLf+q9qAdvqA48lefWeV8HwIBq1/pEJ4wgivxs1g9gCsPFaIH35zHJ+CTf+5P0Irk/+mHi9sZ3cYyqqfv3pkVi6IYn33xy4EJkQIYMwYGGn75YsQlNblDdIyj46k/h/myZe9PUom1Pjh/gdWwlAHf1PAToRnQpiJzLwdekomh1X6Myv1Kch1DjdhUa+M8L0qnqJz0Fza1yNvxv06ePdjeahWQ+uw2AQT0xhWb59s8nAqb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199021)(2906002)(66946007)(66556008)(66476007)(4326008)(6916009)(6486002)(6666004)(478600001)(86362001)(6512007)(83380400001)(36756003)(186003)(2616005)(26005)(1076003)(6506007)(38100700002)(41300700001)(8936002)(8676002)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9cBdoCI079euCmq2W8HNLSkiFUjYN0OF5+BgCXsVd5a4uWdEk75EDkVIJkLR?=
 =?us-ascii?Q?eAW5EtckKYEK2YbXR2S+Ju9YY664Dwm3+TBq6Hx7TcGtMTum0w+qrJ+9yk5T?=
 =?us-ascii?Q?qMpA/bYfY2inP/gWKVqTn7MgDc57cw3LB8pPQMhqwOo795fLpVayli0WtTYA?=
 =?us-ascii?Q?hWsn4bKznGxMZmJK8Cy2t5U1tTw9zJWBhaOsG8O/CDvHPc3QANj65pwqwaUz?=
 =?us-ascii?Q?5T0PjAPOpSGBIqqMGmKS1skKpNbb/+00ZfSFYaEeZtcmG9+W9y9tSekQMT0B?=
 =?us-ascii?Q?l3tsuRmRpX5u9STiMZxuMwALv1H5KloupP8OXc/rb4rxJX3RN2ninPdpFgKq?=
 =?us-ascii?Q?g+31lYDJXQoV2krpNW9lb/TEMdhLNZ43Oo4xZP14BU6jv2JmXarRhK9Q5xrN?=
 =?us-ascii?Q?8UnyhOzQP1AurKJzQrPnvyHq+H5DnURYpjbPnQHRq7R8NO4icf6CWmjuN/yT?=
 =?us-ascii?Q?AhHWG1D3mUyarhpww5CP8iqKR/RzGJ5vC8jkbBLpnEvKf/fX+vTEBs0WB8MR?=
 =?us-ascii?Q?XLzKF+FML9VwnxUjc4gvHV7UHDnwzNvYHkIm7EPxUjKcDAVEAjvbboDC4neB?=
 =?us-ascii?Q?aHPULeOSmaa9j1ahFrw68IxsXSt87pdvBjuGVP1P0zKSA21IuEZDnh51V0Zl?=
 =?us-ascii?Q?nWranj8Jt97gSgNmf2Hti8LkiUNNCfvWRLiX6wccoO+r6gfJ4Zp5dMPXcmRt?=
 =?us-ascii?Q?nBzpCcWiqd5yyCu4tOKoPg2AeS88pBA/XYs+sVJADh/ZIjIE2nnvBWjw9c72?=
 =?us-ascii?Q?Tr0DxNrQ5WKISuck0HQAmEdkZCzJAuO++KNON4F84j62kQg9IyhkrjlkS2B2?=
 =?us-ascii?Q?mpJ4fHSrHP6T6N3aBAbzdE22snMIzYcXcPkJlvnm+I+HElSSdMshaFuDnfNs?=
 =?us-ascii?Q?rD30DfPjg89syxSg/HRZ6T7qQMaJtRQ/i9FbcOIwbYRVdgVB+RSBvyYjyKkd?=
 =?us-ascii?Q?ErMKkw4xa2wyLhFwwAne9hETfI8kToGnnnA8EFP5JPySiKEJtZB6/haKQyUy?=
 =?us-ascii?Q?mv888bboMTn0qc2gnIHnMvXbDflIDAniuU53olR6NurGFOEQJ8F+RSfgVgKI?=
 =?us-ascii?Q?qDY7+jd52rMK6origRwG/0k1UMM2TpNG0HXcDfRlRS62D1UgBWOmclnUUTA6?=
 =?us-ascii?Q?hD4zLmXOXTx8eRM82btt0E2TVpZO1SselWp5Q34SHl6PIAUU5t5TU46/VdBy?=
 =?us-ascii?Q?lVHkhV222TNlzvgjY/YmS9RBPuClY+QYFRW3+wVsB+PoV75nPipR63WZJ7Kw?=
 =?us-ascii?Q?KuClMdzMk8mT9aUIfqhIHacvD1Blv4ys/C4YuZ2lhPqHzrROSjR7y4qNZiG/?=
 =?us-ascii?Q?g1+Dk3C49NRj0Ergyjp6Snn5s+AE4zldp65sKqz7MvZscXUHyXtIMDP5jlIM?=
 =?us-ascii?Q?Im5fzxtFOQwTYZevH2pUPq7mGanjcDIfrfhYrDuoHXn9FdPrA7ZfqBCUCkb0?=
 =?us-ascii?Q?RD7cBDqOxrGtBp9mms6S1uKEERhatWLPbrnwmk46hmO4V9baZw/YQy3lmxgi?=
 =?us-ascii?Q?caRAcWk0Tpk+lIWDJLJwAwHM8f0CAJJnVWATRbZ5WG+iPoV1mtCpSW9o6tfT?=
 =?us-ascii?Q?6gNU/o3blHkb8/yC/JvCkOcG0MWPjmNwnWwuVgSocRvQw0G4g/AA9YgC2Qzj?=
 =?us-ascii?Q?mw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ilPL1TSpJW71cgJrrSGTDZGKkSGr067o70cQu9f7S43Iw6gnm0s5lWG4ydPvjanqErVSLv+zP8dXofSfXW7VtanDN2FoU2Aj1ysbW4jhstbcbfcoo4MoxK7tB2YCNXPXw/1OMR13AsZRPZX3H6tAtavEz6tvgVnZyqc+VV8rq6+uHMZoB9hnTC5ChsS4hReQ4wDTSyh+/OPBh+cupRNugSnmZZ/tnF6Wc4i2DBFtKR75u3MhXk2gFCDVw9A2u+xQzvrzc+i1s7KWStp7ftqSArciLlWSfiJRat5F2237xq+lw4xFAtCsHXyDQBJqbOEsGIZiolBdUnkNZtv1Dlk6aTEPuw3zOuYrVJn/Rdx4K6Zzj5Cqyh4trc5WiaRE7YhCNxRcMi6k21zJQdL6wYGCN//48NZUAjOv5+cmlycTnu6AEm1kmx/VHjTLea1p/xCLRvWoWDU3szIBygif2GqFi0phcrkW2FOrzQtEcqaVX3m/3jqBnK3Swwti+GNrNPyWAi1Pb7b9Lg/7E8C/dyHQ9vtN5/8lCTu2LwbGKPIPCtcbsRXOTWdm892PjmDAVzKPoGJFq7Q6tLZr73Zh5N2zj5Hz/3yj0aL15/+B/lisD0jTmwmvLSXWBKBLbc+Wk4WEolV2NG1EutHeiH3YyvMwQe7RVe2q/YKbUlvEHs+GY8Xl3gNWVUw6Nf4RQJpZcjQ8TSfbVYdPjRWVgs+XPKQWZc1e+UtVVRx75/wEyDQWQo4n78YxEzVd1segm45e+/HtJlibuRJkErQwxfFNIAuz3GyHITxCzU/S131OL6hzFYQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78b2d980-1c50-4c83-b9bf-08db8bffd3ba
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 04:38:29.1241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: li8/1gogj6CmqLPEABy1G3MwaI+HB0rAmZinYMEUZ8smTye8bjQHMd4XBsWSbZvTc6RzQAp2hClUvdfZlJfJsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4963
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-24_03,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307240042
X-Proofpoint-ORIG-GUID: NU51y1Aol4m6EE24SWXhaNavxR7yNwf-
X-Proofpoint-GUID: NU51y1Aol4m6EE24SWXhaNavxR7yNwf-
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We will need two sets of functions to work with two versions of metadump
formats. This commit adds the definition for 'struct mdrestore_ops' to hold
pointers to version specific mdrestore functions.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index d67a0629..53c5f68e 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -8,10 +8,23 @@
 #include "xfs_metadump.h"
 #include <libfrog/platform.h>
 
+union mdrestore_headers {
+	__be32			magic;
+	struct xfs_metablock	v1;
+};
+
+struct mdrestore_ops {
+	void (*read_header)(union mdrestore_headers *header, FILE *md_fp);
+	void (*show_info)(union mdrestore_headers *header, const char *md_file);
+	void (*restore)(union mdrestore_headers *header, FILE *md_fp,
+			int ddev_fd, bool is_target_file);
+};
+
 static struct mdrestore {
-	bool	show_progress;
-	bool	show_info;
-	bool	progress_since_warning;
+	struct mdrestore_ops	*mdrops;
+	bool			show_progress;
+	bool			show_info;
+	bool			progress_since_warning;
 } mdrestore;
 
 static void
-- 
2.39.1

