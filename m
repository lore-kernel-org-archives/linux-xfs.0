Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62529C432BE
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52C8661108
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:19:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235633AbhG0GT6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:19:58 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:48686 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235550AbhG0GTt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:19:49 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6GdIV007040
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=WrBmQ84BTK8+9eXRsNE2y3XBeZ/95ltE0eeKsHw6xZU=;
 b=mlBRHl7kDgt3SysukNw1pM/1AifFyWGB+spfEfN3/7VGQNQiJetEjDpp2oH7sV8ubxo1
 pX0/fYv3jqD9b75j1djMi5boI93HageyozCEMoVLJQE5YqKuagUw4pUvjPW0gMcgDQFs
 Amh2teEVrZ5qCMHRI1G0ArUIxF10IHQIX8QJGo3BHyN/6XBqIypzwjh2Y7IJD2DmgvVz
 FCWvQjVqJVLXpbiFRq5XzxCI3PBRR8aarB0mE41AYwC4jKnIrnyW/2MpWKj9oxQfZSVm
 xnM5jij2Sr8ku1a/2Y0RwyP/NiO62iQ7fy6IhcWqstaz1bqQzyXcZkS8VgMAPAqjs+Ha oA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=WrBmQ84BTK8+9eXRsNE2y3XBeZ/95ltE0eeKsHw6xZU=;
 b=lSUfWPHP13UgF8ajY9ctrO0oRRymE/tu7ncaeQnlHluXnYhHAqrS/4t6MLqC4BERQvRc
 cnmg4JV2ae6Uhjwjvw5ebIwnRmf8YFhn/lbEtqndPU4nJG6Jp3QFBx9akzSBnBvuaDOb
 vR6jY/Lg6VTisBpq51Th7zTSvtq19qMchN3emT77+DMH3DPpKGX36tW4RQJ6cGDrn2AW
 AmBCBol/nQSeuSDxWBNbomKlSrWfwq4duULt8pLBo80FyCWrf6XiomBpML45cMIg1w24
 jXKvOXJk+1aDDNu0k4JGx5pE+09pasuaZq7ap5+OfLojNF9VTWKdH6PPntJM/ekRfzym 9A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a234n0udt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6FjJ5114851
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:47 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by aserp3030.oracle.com with ESMTP id 3a2349tqqb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QIMHQRL48hY7x00pvcwcOmb4LmJO6/3/0dRIPzpRetsKyC/DqbgsORTMktkskTSJxYLuoi0oJMM49uVaS/IC01OOik/acfhad/iu8a4vVd+bBP0/ZkzqJc7DIUJrryoj5GgwFtQCYATANnM/5O5CCoxvZIZaKSnu2tD1ZX3rWWKqo3R8+VZKW5xOQ5PE9PZnoR9ivwaULYDoqvg6k4hXoydW7xAS1M/7LnvuUzRZUwOXAlwvTlO6oT/e2Tq+KVrz/U02RL2LicMAHKRC5zHkUVa3aFwndnZEJX4n+vqZccVhBPh049hBcWrkQ1W2tD6L4IxB3Rih/dB+eDFrRGFDyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WrBmQ84BTK8+9eXRsNE2y3XBeZ/95ltE0eeKsHw6xZU=;
 b=JbnaQf856XJdXecv/sWiApIv+Kd/nYf7DADw+lJ1wIept+O0WO4gQxdtoJ/s4vuW/OCO+N/X+vrnuZa5nrfXzBoWeS5yNqJN6zzKBgYNl1p5hRX0m7gXvS+Kg6MpPEGAdaGCI/5mNFtkIv/YzI+W9XJVQ2NT8i/0f64fdk1aQqdfgC5jSEamZ1TdayGsbJNCK1GIOdJhaHACprzSm6Wz5enZorE+prBG1ZJJudaWvyDo0gLOKtHRlIE7OYtImRy5SlnPSYiTlyazTndrr5Vq89mdiOgOju7QUEEKE9iJ/lavdXUA/J6949DUkjlY7ZQVZtX5ey6K+DOqSbRhEx4GSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WrBmQ84BTK8+9eXRsNE2y3XBeZ/95ltE0eeKsHw6xZU=;
 b=YIUMIn2kJWQUqXdjGP4EWnlqSPmShJJwJHaRTt0PQBWctb8tpHztG9IRfUa4QtqWYqOkmSkV4IaNrAOfu7P9Gt4Gl41wXH2FOD8vlhfpTKg6gqmIl4SNFPx7nEbBRjbqYEf5AL4YGHtyfq2vdbPaaTmCtflvFHVSoPR6aoSOZA0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2709.namprd10.prod.outlook.com (2603:10b6:a02:b7::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 06:19:45 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:19:45 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 17/27] xfsprogs: Add state machine tracepoints
Date:   Mon, 26 Jul 2021 23:18:54 -0700
Message-Id: <20210727061904.11084-18-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727061904.11084-1-allison.henderson@oracle.com>
References: <20210727061904.11084-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:332::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0074.namprd05.prod.outlook.com (2603:10b6:a03:332::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:19:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33779882-43f8-4c2d-3b77-08d950c68768
X-MS-TrafficTypeDiagnostic: BYAPR10MB2709:
X-Microsoft-Antispam-PRVS: <BYAPR10MB270966476A4FB16EFE65BBF095E99@BYAPR10MB2709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:199;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: igoOkkHIJrmpYdgWURIe8FkdjgEKrDa06HIt3wpi5DFDhiVHXO45Nvvvoqmvm6ZDoYb9MoVfahSd7QL1aQTbtXnhQn2VQzEaET1XuBW5D585tnDYJ4QadfcgGQJG3VIjj8HYiPOC7aKSiYxvwLRfmymlYlUVCJnX3yAhqWSQhrHP7polfiM4Mk2hpenALfpXbVJHbv4lwwMiccaz0Jy1I9BwsCTV0bnBtlvVaw6W7iwedFAiJXUSsGkFvNafZ8pmmVId8zfjklS96iakcbvw3YpTa2bjNP4a0TPaBt3nfRoQ/fJREnSqxBxVt40sbZPGuLNMwxH9cmAWMlOUBFyr0LR/SO1MWL1kuuVZGFPfoFyro1mdjLZ9qUnrqYEobDB5H79rU25cHXP+xDkhqvmP23DFIpXJJFDBOVFtvJGTDNU7xsVjLOkKZkL9agDjnIPu+HDA7TSYzLQ+5G3TC+L7Q4CxIAWXqeL6OnQSXyBAPHjser8JURJs5FfmNOWOeFrUNUdWM21Z9GEq8O9Xie+6E/l8nUgnbfQCs3eMU9CFSlod+mEOgIhOLnRX1OIiMZlZ2v7fLYXJkHTYTukeUIDdw1x0HrYJ0rCVlrA/o9b6ZSdOK8IC3OSQrm2Ws+ubyrGfoaiuJEOiClMm43WyVaJx9rSUxnPy7W8gSeuyiJ3fAaIYRLvVW4w+sS/y8WbzUKYfqSgOkF66HtxOtmfdI8NmBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(346002)(366004)(136003)(83380400001)(6486002)(2906002)(44832011)(6666004)(86362001)(6916009)(956004)(38100700002)(2616005)(36756003)(52116002)(38350700002)(478600001)(8936002)(186003)(8676002)(6506007)(5660300002)(66946007)(316002)(6512007)(26005)(1076003)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s8NY4oP8RJ1Rz2VqQJFx3IYHgbrhyst32HdI82cJ9ETTZ7RiopNq0ITBvGpQ?=
 =?us-ascii?Q?h1M6lRjJJN+k4JuOJcRflAw44grrkmsdHD9D0hMhYVuX0XILPoR7R4HEqhNo?=
 =?us-ascii?Q?OpTzImFqawAScWzuidCvapYm27iYzr4dLEVi15bhGcAXkxs6TpiCnqa9/x9A?=
 =?us-ascii?Q?L73TiYxOubWtRMwwl4MowS0qsjtJ8ViszhdINWaWcWSjLJmT4X4f4FHdp09N?=
 =?us-ascii?Q?lfL78yiUMdquuUxdwcQB1P+BWWB+ToHr8wneznxMct/EAbky+rvQ9iZJ0d7E?=
 =?us-ascii?Q?QEOWL0QHel391T7/Gbu2jNhLKCcmdB6i+qyAmDgzkDc392rpn98e05UQAkPK?=
 =?us-ascii?Q?5phOl6CSCRZShwIKz+NZIOSezbNn0/ip5vytpgzpfZZwGsqRWXppIgyxtt+F?=
 =?us-ascii?Q?++FtC1GdD062gp69be3//J/Roiz37NGaenrwO8kGtxKoeV+m7MbXbVD866Zt?=
 =?us-ascii?Q?LoJRIKIIJrnLRn9dYuRFgTmE1CEvbrUgfvVJLXPXUO1lXv5oJsiCOIgDuPh+?=
 =?us-ascii?Q?ldb4wzwXCtyiO4zIzaMmmSXjFgTlXTlt1GqNNJEeN/RwS597IuGbN7ItGHvl?=
 =?us-ascii?Q?p8cb6Yg2PQvMVYmJdwisvlTKEefZOpFvr63idZyjgIKNz6PiEURJwd/dk4G5?=
 =?us-ascii?Q?U9e8Qa0tjAHClN0cZzUUAn+/kyxmWkpOfknM4JVbiJtWonXKth5qyym0YA3e?=
 =?us-ascii?Q?wGJrWEKJGxkZshUg7egErN5P2uSQeQSIewGN9+8G/+aoSTLgBn8W8E3mjjMe?=
 =?us-ascii?Q?pe3NZ4tuXmCYKGjw2vGKtqN2Od3/7TO1Bji81qv9mOw0HCCccvA4LyhAJULy?=
 =?us-ascii?Q?HwK685/2Fu0VNQKzyFssC4RnunIq/Ig6pZZglNMw815sgfoqJyTTMB0rE7zQ?=
 =?us-ascii?Q?9dtPgRhKWnZibjCzDJZUdiaWAYlkxcSWAQRdx65hwVbcoFVLlXaBL18PB7kz?=
 =?us-ascii?Q?Qwcsf7djoRu7tzyuId6eEiD1dSQCzXkxiUnCitC7t+nhzKrrse9xg5xxuOMg?=
 =?us-ascii?Q?9ZDLR0oWjrLaSRt5xkOnXPoMJaLwKaZ0MWTTa6LJqOfEWuqk9iMrYLNVqYpr?=
 =?us-ascii?Q?WqTTqDnqHQouUmJ/SiLJeNj/zp7Kh4QgOF5ImQYehRZ4YziSMZmCujz9JE+b?=
 =?us-ascii?Q?HIgtkftsqbYRidoUvEGwIPDE6fO9Fg+Qm2p8eBCqjD4lTPHBlodZAGAgiYUg?=
 =?us-ascii?Q?sohiIZpk/FmxLxWUXMGUuJrFDRUcfZoekNWsGVXwRvKO4l3B1WYKSNIBHevp?=
 =?us-ascii?Q?6w/ZYkK8Kjh6MUBagFKNHzM/00SvPozk8apIA0zgZIe+Zq/GkBAJ/oUp/81+?=
 =?us-ascii?Q?SlMwnoVoQEkJxtHOq0/dufM5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33779882-43f8-4c2d-3b77-08d950c68768
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:19:45.6820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KrX48NJ8Usnls6ekAdm6LeUyppsgNgjmuCV2up78Ee+0olSmoGtMzSOy81tG3u5tUPBpzkbmU50Q7CRdfQtf/0PxEvpyqLj7SdXbMidRmso=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270037
X-Proofpoint-ORIG-GUID: iqmbCkJs3TZzyavGWNR-tKj6x04H0hzK
X-Proofpoint-GUID: iqmbCkJs3TZzyavGWNR-tKj6x04H0hzK
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: fbc8d6bb875915e0afd8ff6cd4364b368a6f894f

This is a quick patch to add a new tracepoint: xfs_das_state_return.  We
use this to track when ever a new state is set or -EAGAIN is returned

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_trace.h      |  6 ++++++
 libxfs/xfs_attr.c        | 28 ++++++++++++++++++++++++++--
 libxfs/xfs_attr_remote.c |  1 +
 3 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index a847b50..2169c27 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -312,4 +312,10 @@
 #define trace_xfs_perag_get_tag(a,b,c,d)	((c) = (c))
 #define trace_xfs_perag_put(a,b,c,d)		((c) = (c))
 
+#define trace_xfs_attr_sf_addname_return(a,b)	((void) 0)
+#define trace_xfs_attr_set_iter_return(a,b)	((void) 0)
+#define trace_xfs_attr_node_addname_return(a,b)	((void) 0)
+#define trace_xfs_attr_remove_iter_return(a,b)	((void) 0)
+#define trace_xfs_attr_rmtval_remove_return(a,b)	((void) 0)
+
 #endif /* __TRACE_H__ */
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 84b88f9..6380cae 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -335,6 +335,7 @@ xfs_attr_sf_addname(
 	 * the attr fork to leaf format and will restart with the leaf
 	 * add.
 	 */
+	trace_xfs_attr_sf_addname_return(XFS_DAS_UNINIT, args->dp);
 	dac->flags |= XFS_DAC_DEFER_FINISH;
 	return -EAGAIN;
 }
@@ -394,6 +395,8 @@ xfs_attr_set_iter(
 				 * handling code below
 				 */
 				dac->flags |= XFS_DAC_DEFER_FINISH;
+				trace_xfs_attr_set_iter_return(
+					dac->dela_state, args->dp);
 				return -EAGAIN;
 			} else if (error) {
 				return error;
@@ -418,6 +421,7 @@ xfs_attr_set_iter(
 
 			dac->dela_state = XFS_DAS_FOUND_NBLK;
 		}
+		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 	case XFS_DAS_FOUND_LBLK:
 		/*
@@ -445,6 +449,8 @@ xfs_attr_set_iter(
 			error = xfs_attr_rmtval_set_blk(dac);
 			if (error)
 				return error;
+			trace_xfs_attr_set_iter_return(dac->dela_state,
+						       args->dp);
 			return -EAGAIN;
 		}
 
@@ -479,6 +485,7 @@ xfs_attr_set_iter(
 		 * series.
 		 */
 		dac->dela_state = XFS_DAS_FLIP_LFLAG;
+		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 	case XFS_DAS_FLIP_LFLAG:
 		/*
@@ -496,6 +503,9 @@ xfs_attr_set_iter(
 		dac->dela_state = XFS_DAS_RM_LBLK;
 		if (args->rmtblkno) {
 			error = __xfs_attr_rmtval_remove(dac);
+			if (error == -EAGAIN)
+				trace_xfs_attr_set_iter_return(
+					dac->dela_state, args->dp);
 			if (error)
 				return error;
 
@@ -549,6 +559,8 @@ xfs_attr_set_iter(
 				error = xfs_attr_rmtval_set_blk(dac);
 				if (error)
 					return error;
+				trace_xfs_attr_set_iter_return(
+					dac->dela_state, args->dp);
 				return -EAGAIN;
 			}
 
@@ -584,6 +596,7 @@ xfs_attr_set_iter(
 		 * series
 		 */
 		dac->dela_state = XFS_DAS_FLIP_NFLAG;
+		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 
 	case XFS_DAS_FLIP_NFLAG:
@@ -603,6 +616,10 @@ xfs_attr_set_iter(
 		dac->dela_state = XFS_DAS_RM_NBLK;
 		if (args->rmtblkno) {
 			error = __xfs_attr_rmtval_remove(dac);
+			if (error == -EAGAIN)
+				trace_xfs_attr_set_iter_return(
+					dac->dela_state, args->dp);
+
 			if (error)
 				return error;
 
@@ -1183,6 +1200,8 @@ xfs_attr_node_addname(
 			 * this point.
 			 */
 			dac->flags |= XFS_DAC_DEFER_FINISH;
+			trace_xfs_attr_node_addname_return(
+					dac->dela_state, args->dp);
 			return -EAGAIN;
 		}
 
@@ -1429,10 +1448,13 @@ xfs_attr_remove_iter(
 			 * blocks are removed.
 			 */
 			error = __xfs_attr_rmtval_remove(dac);
-			if (error == -EAGAIN)
+			if (error == -EAGAIN) {
+				trace_xfs_attr_remove_iter_return(
+						dac->dela_state, args->dp);
 				return error;
-			else if (error)
+			} else if (error) {
 				goto out;
+			}
 
 			/*
 			 * Refill the state structure with buffers (the prior
@@ -1473,6 +1495,8 @@ xfs_attr_remove_iter(
 
 			dac->flags |= XFS_DAC_DEFER_FINISH;
 			dac->dela_state = XFS_DAS_RM_SHRINK;
+			trace_xfs_attr_remove_iter_return(
+					dac->dela_state, args->dp);
 			return -EAGAIN;
 		}
 
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index d474ad7..137e569 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -695,6 +695,7 @@ __xfs_attr_rmtval_remove(
 	 */
 	if (!done) {
 		dac->flags |= XFS_DAC_DEFER_FINISH;
+		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 	}
 
-- 
2.7.4

