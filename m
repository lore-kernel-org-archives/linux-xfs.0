Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF807C433E9
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:47:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88EF864ED2
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbhBRSrZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:47:25 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:36054 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233355AbhBRQrm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:42 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGU5H8040952
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:46:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=7U9lInub3rHv2j79ris2E9htjChPcfas/rDl+FXYeSw=;
 b=ypNFwvyAeZVPy9YRhr9mqKt6GAVzsqy748DJ41CcR/kIMWiWnYF345LlQGoBECrOxxLm
 eiPbdco0LFOEFIYymmyTZ9B1mZNqNI1j83M5sYoA+X5R9KVWvlwFsFbYJjx78q2av5lx
 GPScwq+Fox5x0GGzvI8gD4LidQLeDjIj9Ak9bgdRdn/LG09CFL+noxWALdrZOp/PrV1v
 KOQWwqHEMjYBac1VQymQo/US5qBpR51cQppZ+bGXclQyqgRKlCbqArOYXcKqbqK+/yj+
 6VWgyOQ8Cgz8OWy4RbBCN+pKi1vmwCVDE3I7ugKyJwFkRdFm0ThgVE9+M6SZfWa3Wm0A Ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36pd9ae3kv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:46:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUJtF067880
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:46:17 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by aserp3020.oracle.com with ESMTP id 36prp1rkmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:46:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kU49W6v2qpUYNPZgXj0Xf1lJQI/r+vc+BOB5Mdiac31xS+o4PpUWax98H2FUZ77VvQ9qtKEEp0nFT4M6+O1iUDZfPZ/+cFimJzuREJljMlm3cqGP6R89GpXatDi7DpqUZYcnQ4J1FtSfJuratBdyah4BEAxtHagscc5yGEShDne4dEkrhejlaXBHEpnc0S04RD3f50+wXE9WI+xzyDBmRnWnZSdjLqKT4Gg3l0YTdBkrRdDkiXRmFy8t8pTqBeStqE7t9y0fY+d3KC5Gx71F3R1SUgiEkfyGYPNS0P1UwfaHjPVprl4AGdL5Gxm/ofiHFaiPy+2CqoMUalEN2DZlkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7U9lInub3rHv2j79ris2E9htjChPcfas/rDl+FXYeSw=;
 b=M2nPk/BKR+1ufMZYMeXBkIcQvBsKdFlIhnuvUL4ShGEndPED9x/fn39xsQxs/LvfqmYGTy7WB4eEfA6FgIGlitrENUn+hi4e5PIf+VKYdXB+snVX5WWYwt6bkpBOBgyxUkPX2GE1vzRzS4Paj1UCBRs7kG7s8WL/QcexWW2yhVGpdeHC7keUZtA81gqtfgVbO5qwQKH4dGFJmQw4sUkhvwfNV5fYgHypBssHZgA4utN6axs8IiTbLHxqI439TbnC2adFXYb+8VJwH8fZKqB2g4HvM79HSkdrkiQpxSvybXLil8IM9YuSF1cHps+uQbbkvHoVSsywBAYXHOCiNSe5Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7U9lInub3rHv2j79ris2E9htjChPcfas/rDl+FXYeSw=;
 b=dL6KhlSdMabNDgd91rgvodH+DyPfjN8wTym4p0U6psfBKxqDILdhCUswaHUvwGnbMfSLtJS1gxqAt0T4KFOW4A1ZPhwPs9A+dlyuJoml7Df+kcejIFPD11R/H6CyHjLFNDyawGHImb+W4gYclclKn8AFD+m2Jl1rM56bpkXuVFc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2965.namprd10.prod.outlook.com (2603:10b6:a03:90::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 18 Feb
 2021 16:46:15 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:46:15 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 30/37] xfsprogs: Add state machine tracepoints
Date:   Thu, 18 Feb 2021 09:45:05 -0700
Message-Id: <20210218164512.4659-31-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218164512.4659-1-allison.henderson@oracle.com>
References: <20210218164512.4659-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR11CA0088.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c7b93d0-cc9b-4154-05e5-08d8d42ca2e1
X-MS-TrafficTypeDiagnostic: BYAPR10MB2965:
X-Microsoft-Antispam-PRVS: <BYAPR10MB29650A84E60A3F9C9CE17D6195859@BYAPR10MB2965.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:221;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ut2lv5mJ28ZRLgyXigcaYROjnGmblqYWU603UGNQ/xDmwRoVjztCHu7r2La093ixib9oW8ZwQmqynZ64nWsnb6LzwjKj64cb7sSx6HhYZ/7TI6mAf8PUhoD5dShEce5R/p/tZXASr5EBjvVxPq3Ex/Psm70WAxgOE3dH8c1Uuvtpfr04ekB8Okql9fVw8ItNcVPDYnv6FAWuSfEFSufexHNeE84ZVt1+YTTXos7WvOx6XpxzBHIN4QhN5XkebOEF2JojgXIMgh9m2wV522ZaTab3hxoD9Xdq1g0VBYBqL67cr+x4fx4Jo4pkghbhkJVTlL4Znkacvda0U//yrYxNB1Y6PUB7s1s2neBHWd4lsXxLd6dHJyiSb/K1Q3FrPzeGYqjBIByJx3hEWfB2XhqpHRXLAtvNuJJJVusKDjOBSz55ZaRoJdB/NA2PvupmVKf/0wNd99/uEmOgQZaez5lB0mTYhdlnzSVQKlhFOXNegrvbPiLdwz3P9tUQPB5C6b06Q5a/+qD+RMLUcHyajbdrdxfpVbYtZ8hRX6KjlKOoAsQ29vQfCCVskTVenvrida6lF8+qw+53/kgpXrigLMOkCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(136003)(39860400002)(366004)(6512007)(86362001)(69590400012)(36756003)(83380400001)(6916009)(66556008)(8936002)(66476007)(66946007)(478600001)(52116002)(6666004)(6506007)(316002)(44832011)(16526019)(6486002)(1076003)(5660300002)(26005)(2906002)(186003)(2616005)(956004)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?OIK/7Fw0i65Q31s/QF1vQKm7J3Z+FcPU7/pMKTwhMt7ZL3MuW2tVj1NijhrF?=
 =?us-ascii?Q?7NkhZksf9M8KY43dMjuewK3sCtTew01wmzfMTcd7ZovV6v4mx1eyTotLNVSN?=
 =?us-ascii?Q?Ly7DTx6kc7k8gZal/oTTpUcGTygLZYqD+7dbyaOPlF7t9VCdI1aMUlEom64z?=
 =?us-ascii?Q?5YHfihy13wGijg9VqrO0lKGNoht2zfrWo4/4Sk2ccyRd4u8eawNxZ3HHxB2v?=
 =?us-ascii?Q?BbCf9ogc9Twz319TAzmB/C3yoxXiTF3Bbe53Ch0faynPVJq8UG5pg5ZAF3Pv?=
 =?us-ascii?Q?7C5RnKtARBTal8eT1J9FysPy3NVuStON4gl15FPeSU3wxAmNpL9Czcf7cBYe?=
 =?us-ascii?Q?ktlcjWHbX1fpDeI4M8cwoEKo3WDondu6r8EprQcQYoJ9c2UBjMlKzDdA1rj1?=
 =?us-ascii?Q?LZawaIf0aG91Hg5f8XYZAueTwAJtYOfZwaRVMH3RFrCwtEvF8Pq5yn00caZ6?=
 =?us-ascii?Q?y5TLKPCGIjki3EtD4+boOaI4HulgOCOHBxmBS7X3ntxGrNEtvu59P00PXItk?=
 =?us-ascii?Q?VtW2CjznRGFmxU+5WE7ZUvxRrTMPqlFMiT8+51yEw2Y96zVglAqN70kDHRi2?=
 =?us-ascii?Q?k1ptxoPF8pmDl5HB4VUqWiaipOvrf+r7LtkrODdvqqRZkrupmEU/l1jk5iq+?=
 =?us-ascii?Q?4HVAWq1jfx8bg4iqAQViMaLyGT6FkumgsfpDRMt3+Nf8G27I1skCq8U88cYm?=
 =?us-ascii?Q?yOKdgr14PCO6lN6tXHZu0FggQyKcHDu4UkdLTJgJFxhTWAunFw0RFo+/eJb7?=
 =?us-ascii?Q?fvpQR5c6fe0hDjcl69CnuneOeGqPYg54t/X0rVsGUxtqOk+VRk1x5fjgC3C1?=
 =?us-ascii?Q?lM6ENyN8XIaso1ayGrt6UkrS9sVd579tyml/tNo17+a2TrjasPW0YuZ6qOUV?=
 =?us-ascii?Q?gANmGcr5JBfQbNd8a/T4GbUYJzsLPYZovpw1K0Poi+EPjyXMZoIZPvyEzdfU?=
 =?us-ascii?Q?fY0nPcdWREzId4Sutgb9NaOH23+HXEbpDlQaSQ7y67cZsjEeoxW3VGq7gywS?=
 =?us-ascii?Q?bkijBNmI90xt/5L+L27nTwbr1H2gNFE9hgpjI6oFNcXzViUmRLTPOck7o2s1?=
 =?us-ascii?Q?P+prw6fnpCqkDjP16GDQ7ru7GLfhzV5bRtOgeS3HvwwEIFQ+f2BJp0rWffrc?=
 =?us-ascii?Q?r9lshQ57UsvB5jeHsGXI7H5udz+lFUATmdgRqAkFYhgy8UKltmU9oogPvY6x?=
 =?us-ascii?Q?kVvXway2Sh7iK7fiYWIt/0Jp2gp/1yeNUqtVS0FJqmwKX728JIbdM9DWyvaU?=
 =?us-ascii?Q?FfJ0MDkidjp+VuMZfWmNFS5fqPKz6KPYRq1Y8lgxA+U5tUFQihinzpI5bVq2?=
 =?us-ascii?Q?FVf/YUIz7DHnzqYRl6cThsyq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c7b93d0-cc9b-4154-05e5-08d8d42ca2e1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:45.0535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DPjRH3itCBwtnMvRtyoSKmc2AU7oVcvvvp0uJZGE9S9OsOFv03kEQaW8/uFIDu+TwkdClVhSm1zkUJVRB73s98g9tIogZv94gUXuzvydAYg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2965
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: fbc8d6bb875915e0afd8ff6cd4364b368a6f894f

This is a quick patch to add a new tracepoint: xfs_das_state_return.  We
use this to track when ever a new state is set or -EAGAIN is returned

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 include/xfs_trace.h      |  7 +++++++
 libxfs/xfs_attr.c        | 31 ++++++++++++++++++++++++++++++-
 libxfs/xfs_attr_remote.c |  1 +
 3 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index a100263..cc3e8b3 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -314,4 +314,11 @@
 #define trace_xfs_perag_get_tag(a,b,c,d)	((c) = (c))
 #define trace_xfs_perag_put(a,b,c,d)		((c) = (c))
 
+#define trace_xfs_attr_set_fmt_return(a,b)	((void) 0)
+#define trace_xfs_attr_set_iter_return(a,b)	((void) 0)
+#define trace_xfs_attr_node_addname_return(a,b)	((void) 0)
+#define trace_xfs_attr_node_remove_rmt_return(a,b)	((void) 0)
+#define trace_xfs_attr_node_removename_iter_return(a,b)	((void) 0)
+#define trace_xfs_attr_rmtval_remove_return(a,b)	((void) 0)
+
 #endif /* __TRACE_H__ */
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index e4c6268..4aad38d 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -313,6 +313,7 @@ xfs_attr_set_fmt(
 	 * the attr fork to leaf format and will restart with the leaf
 	 * add.
 	 */
+	trace_xfs_attr_set_fmt_return(XFS_DAS_UNINIT, args->dp);
 	dac->flags |= XFS_DAC_DEFER_FINISH;
 	return -EAGAIN;
 }
@@ -378,6 +379,8 @@ xfs_attr_set_iter(
 				 * handling code below
 				 */
 				dac->flags |= XFS_DAC_DEFER_FINISH;
+				trace_xfs_attr_set_iter_return(
+					dac->dela_state, args->dp);
 				return -EAGAIN;
 			}
 			else if (error)
@@ -400,10 +403,13 @@ xfs_attr_set_iter(
 				return error;
 
 			dac->dela_state = XFS_DAS_FOUND_NBLK;
+			trace_xfs_attr_set_iter_return(dac->dela_state,
+						       args->dp);
 			return -EAGAIN;
 		}
 
 		dac->dela_state = XFS_DAS_FOUND_LBLK;
+		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 
         case XFS_DAS_FOUND_LBLK:
@@ -433,6 +439,8 @@ xfs_attr_set_iter(
 			if (error)
 				return error;
 
+			trace_xfs_attr_set_iter_return(dac->dela_state,
+						       args->dp);
 			return -EAGAIN;
 		}
 
@@ -469,6 +477,7 @@ xfs_attr_set_iter(
 		 * series.
 		 */
 		dac->dela_state = XFS_DAS_FLIP_LFLAG;
+		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 	case XFS_DAS_FLIP_LFLAG:
 		/*
@@ -488,6 +497,9 @@ xfs_attr_set_iter(
 	case XFS_DAS_RM_LBLK:
 		if (args->rmtblkno) {
 			error = __xfs_attr_rmtval_remove(dac);
+			if (error == -EAGAIN)
+				trace_xfs_attr_set_iter_return(
+					dac->dela_state, args->dp);
 			if (error)
 				return error;
 		}
@@ -545,6 +557,8 @@ xfs_attr_set_iter(
 				if (error)
 					return error;
 
+				trace_xfs_attr_set_iter_return(
+					dac->dela_state, args->dp);
 				return -EAGAIN;
 			}
 
@@ -581,6 +595,7 @@ xfs_attr_set_iter(
 		 * series
 		 */
 		dac->dela_state = XFS_DAS_FLIP_NFLAG;
+		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 
 	case XFS_DAS_FLIP_NFLAG:
@@ -601,6 +616,10 @@ xfs_attr_set_iter(
 	case XFS_DAS_RM_NBLK:
 		if (args->rmtblkno) {
 			error = __xfs_attr_rmtval_remove(dac);
+			if (error == -EAGAIN)
+				trace_xfs_attr_set_iter_return(
+					dac->dela_state, args->dp);
+
 			if (error)
 				return error;
 		}
@@ -1227,6 +1246,8 @@ xfs_attr_node_addname(
 			 * this point.
 			 */
 			dac->flags |= XFS_DAC_DEFER_FINISH;
+			trace_xfs_attr_node_addname_return(
+					dac->dela_state, args->dp);
 			return -EAGAIN;
 		}
 
@@ -1407,6 +1428,9 @@ xfs_attr_node_remove_rmt (
 	 * May return -EAGAIN to request that the caller recall this function
 	 */
 	error = __xfs_attr_rmtval_remove(dac);
+	if (error == -EAGAIN)
+		trace_xfs_attr_node_remove_rmt_return(dac->dela_state,
+						      dac->da_args->dp);
 	if (error)
 		return error;
 
@@ -1526,6 +1550,8 @@ xfs_attr_node_removename_iter(
 
 			dac->flags |= XFS_DAC_DEFER_FINISH;
 			dac->dela_state = XFS_DAS_RM_SHRINK;
+			trace_xfs_attr_node_removename_iter_return(
+					dac->dela_state, args->dp);
 			return -EAGAIN;
 		}
 
@@ -1544,8 +1570,11 @@ xfs_attr_node_removename_iter(
 		goto out;
 	}
 
-	if (error == -EAGAIN)
+	if (error == -EAGAIN) {
+		trace_xfs_attr_node_removename_iter_return(
+					dac->dela_state, args->dp);
 		return error;
+	}
 out:
 	if (state)
 		xfs_da_state_free(state);
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 628ab42..a1c9864e 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -762,6 +762,7 @@ __xfs_attr_rmtval_remove(
 	 */
 	if (!done) {
 		dac->flags |= XFS_DAC_DEFER_FINISH;
+		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 	}
 
-- 
2.7.4

