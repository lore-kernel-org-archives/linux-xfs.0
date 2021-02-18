Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 144B0C4332E
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D623064ED7
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbhBRSsP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:48:15 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:53528 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234042AbhBRQzV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:55:21 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGsCvt016465
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=0HL3fM2BkIp4sskfMBKSs4aUSA3rU1fVRiphof0SDrU=;
 b=qJvAjceZbdMp6QmQeSmJLSRHJaSJOaVPyzfg1LFLoO7BlH+SKtH3PDukM7orUxzuh5aj
 57HQirO2lvZEme32LBOEsBdJGH5YLoqefMo8zLABwlwt5yimg6KviSofeJ8hBuq5lsiJ
 hJYbUEn5AYnTZwugunEX8Ta1NKoR6Vm0Pda7au/UsAub0tO4SytW75r41LqmQKhYnmcZ
 UR0jFUAxSGwKx1s/1KeamgtF6PVjsxWjKNrbp7WQQFye3LdoKUQaa4i3jpkAJK9mLW0h
 8YsOsseDeGn3Ff0ylSNSdVhq3jP0sREbbUv3/ukRTJd3S1PcE4gwN3v+yaGTgk9VMR8J Xw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 36p7dnpj6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGngH1162448
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:13 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3020.oracle.com with ESMTP id 36prhufdpk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fHbk9Z03J3GRXXEQ39DfSG6OK/H2ISP61hKGGIv2ByRMS4ZHJ3ONE3aysBEaa8dcQCpq/KuDsfcHdaxhGlTSC3mXLMgAVcqc+lqueax0qslkp3CTy1j7RbAPu08sZ5bNE3Ms1u0AAqc0ct+QOxcYDkBa9Pf4sPZ1qL9a6ceXpqRsCwcO/3ovnSLiOA+C4YG3/ryS+LSkEZnaNc1VMW4tWURlbi1tbZILptfpuz886dgwFB/UluZSVuSY0B+Utl/YdcURWmhKhYIPz7ywwxowCAfo4JBRpuH4pC6I616dGQoSWrQH934aYbhYAJu/0z3u1X9EWAiIicNw5vy3x+oa9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0HL3fM2BkIp4sskfMBKSs4aUSA3rU1fVRiphof0SDrU=;
 b=I8kF30pv/qgoyr5bFD5e0qogel+6jhPl/UxAJwAGrDO6aolC/mZK+bpp4PfNGCN+9v5GQxwWg0XQZhqUEp1hC/boTV1PGU9Hml0A4quF2DpXBpDaPYJfp8SNLThlhYGkCKHubJzYH7B/YP2z7TgGNyzTJxSqfOxkk2KMoAORh6hyRKM1lKc7FnIZy8u9230xQvSJz7D8B/fkmNJD2UAVKgVlnfjQwe5jsYsSqe8/ssVl7WUsX8WQG/6EowQvPRahyPWV5Sk7JvpGsJv8ngO3skeASk2SC3+fH5MxbeP5myL0tvuvjXG+XDLXuIlA6sy4FmmDXcKLytf/EJ1HVr7A7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0HL3fM2BkIp4sskfMBKSs4aUSA3rU1fVRiphof0SDrU=;
 b=QX0y9AARijlJFWc/lVLW696y8XAFgJoMji33rfhpL240kY7SglIK4tgBE/r+rRwfercbi32SVe10ulqulPxaslikh5MrObpx84t4uYFW8cDN9VRO+qoDL2EK1kLhLJpeo9vF0xwIF8RR/YG0ltd52lqdHQxS2jBmvBBaDI1Eljk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4161.namprd10.prod.outlook.com (2603:10b6:a03:213::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Thu, 18 Feb
 2021 16:54:11 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:54:11 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 17/22] xfs: Skip flip flags for delayed attrs
Date:   Thu, 18 Feb 2021 09:53:43 -0700
Message-Id: <20210218165348.4754-18-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218165348.4754-1-allison.henderson@oracle.com>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0352.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by SJ0PR03CA0352.namprd03.prod.outlook.com (2603:10b6:a03:39c::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:54:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82f2782b-d43d-42bc-cfca-08d8d42dd07c
X-MS-TrafficTypeDiagnostic: BY5PR10MB4161:
X-Microsoft-Antispam-PRVS: <BY5PR10MB41615376AF8D13ABA7C8640095859@BY5PR10MB4161.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w74pyKnRyYDSB3g2FwJyMy1ytjCst6kzb6FpVQreyXUkEmH+Gk0xu7ycG3Vx9hf4dmKg4Z8JSVUQDuK94Zn/FhOyssdH8RVuxlN23LoyjU5JJso4uzjIf31BoXwDLtGPHkWIqbxoZLNHcczIPbxF637SmGP2EhBCD0T+W+EfIF2SWZo1MO4GUxxFyjKtCeAFuzTK/1moLIwfkolcYSH7+FYVhuTcgn+YYCUOu16mwzEC6vp7EmqbaYAvvRSp5w/R9SsNwZth1ZAQ/QONpRqnOW16fvkWlDt8eUvfERMhSHN7g3Rkce44O0fpSMZNk8DRpCOn5r5YOFlisgunHH7ixJumt23kPfk9eWZSpsfE3xIHo2RgTRDKfb8OrrZ92hPbH3cS+iYovrU0dciKQgCmQvsQEazIfY0xWpFeCrnhEWs/pjaLMDHNzrBWvcVTL0XoSw4fh5UWSGaKtYvKF6Tm7bG7fsFr9XyLdEsbj5h3PwYIB9ASkl0ZVopN4laKmAc7NAhTSiBYxN+HSV1s6yQ9tdVgQoKQTxxpLXeNVciVRFB5i69NCre5LMcLPfPWjlhEtcQ2MRcs+J4RykNxjpI4Hg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(396003)(366004)(136003)(346002)(16526019)(66556008)(6506007)(478600001)(5660300002)(956004)(69590400012)(26005)(6486002)(83380400001)(66476007)(186003)(66946007)(2616005)(52116002)(6512007)(1076003)(6666004)(316002)(8676002)(8936002)(6916009)(36756003)(2906002)(86362001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1HDrnPKbn+z8KWd9gMqlFnn4DDs3LKr27Me7LoSpHCLoU/N8gU38D/TJf+8o?=
 =?us-ascii?Q?ZyAdCvzq9VInATXeV+eUUz3FMSh1rqTUuikuIyBx+h4VnwvB7B/anwmcb0XO?=
 =?us-ascii?Q?f1aagsHOjdmbK876L5Tf694rJoG90QTE9Qyqk+TADc+WQBlAg1Nau3jOWuf9?=
 =?us-ascii?Q?ljDVVIGhTmcq64pM9Q/5xYeujCl0RhTDfWeyr4NkBdVOgIwINv4GjNg0mnOO?=
 =?us-ascii?Q?1kG0Tn0p+O9JXX6oOrCDHeWzEI7hZgWda2j52/rLEZT23g2Hmxm0sy8AzdtY?=
 =?us-ascii?Q?Xp+Z5OgdaVA/3huGM7I4pGe4wdKKMmok+3pxnCYKoWd2LfuInGYSu9eDF5lX?=
 =?us-ascii?Q?KwuYKRlj3LziSilox+PdKaUCgiUxnwfsUrHWT71Aj0CRC5mD7ghECLRsdSYA?=
 =?us-ascii?Q?ZH2KqaAa74dI76eWx45f3EXi9skJhYFaPBlX8zjoqrXdQc98MqvUISUm7ALL?=
 =?us-ascii?Q?1g8hTntih/LFlZbPIqUwR9osad01e88ywB7UOVABnbM/xdmk/0OnCZDx1vhA?=
 =?us-ascii?Q?FRxGxPKWuXd2BEkKP8YZZUk0uON2ooDTEgbPp8Sf9Iw2QzqTMYaNA3zV6i3G?=
 =?us-ascii?Q?cqTd0hSHKPgTQg1kYz3H5eGDd3ZaqJsMlyJoIZ2s5+OeGuqY+gOR6QdDjt3q?=
 =?us-ascii?Q?Gt9n6ievo0NGh6EoXGRRnWEY0Vw6WY1U6ausYSet57SQk1al8w3oaIOXSxwg?=
 =?us-ascii?Q?/OLPz7oJpv/2NOoJth9SlLL2hVSG5doKp+LjKgOGhIdbfEexEqsc/KCGYAsk?=
 =?us-ascii?Q?p1Asl2Tw/twvgfRPQrWe2bL/paGowEZHdSr4tBzcc+qv57LJw+lunV96y7sz?=
 =?us-ascii?Q?3GXCs1pJEcvZ5dcM1s/CrxoSYN+FD3dtIu5Xu9vYMHxLHmU+DPhPkOXQ0LsR?=
 =?us-ascii?Q?/2L0Vh9JXKtHoiROgOUEN/jXX/TBaUlOldlyvZW+/LqHBQwmqxQOr6CSq7eq?=
 =?us-ascii?Q?Sq5Ea4i2XLlHkwoqvxyk8RwB+xyjcpLeretykHCnLUI9i4kPMht/icOJA3Do?=
 =?us-ascii?Q?Oop/TcybMOIw8uKmv9hcJ68zfx+kreFNjkxbXfJCc29qDN4ULQArQJlqVZCD?=
 =?us-ascii?Q?fWjZcxl6Fl8Mep+H4UfaEhYG1aUnofxjcaoTtOT29ocWJI7ZmMJwjxtF7W8x?=
 =?us-ascii?Q?6U+4jAKyAWoo0gyPpr4Rr/7ntKuT9M364sfuYYQSdQdHFVMs+RN1pSl0Xg3z?=
 =?us-ascii?Q?/IHXsg8gr3czsuHd09pkwjVRT2mAPTa8KARt5pKwR6/urpZpSqLoTRMqTiPp?=
 =?us-ascii?Q?PDQP52t6G4CUZJwmBASYd6VkJnKi+Io0OjBXMoHMb1zhLjEaCt6J4I0gDwj0?=
 =?us-ascii?Q?EJ19xRmsdMsLZ1Zn2WYfGqoi?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82f2782b-d43d-42bc-cfca-08d8d42dd07c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:54:11.0786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nBaj8/+uKstSnDX43OD8p2MzUy/R1HW+yQeWcZUxhJ6DUlAd649UCnGiVp6pqJdjyFsBY2qpgfgtX+UriG6ZHivIwhj8hmjFMim7GZJRkvE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4161
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180142
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180143
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a clean up patch that skips the flip flag logic for delayed attr
renames.  Since the log replay keeps the inode locked, we do not need to
worry about race windows with attr lookups.  So we can skip over
flipping the flag and the extra transaction roll for it

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c      | 51 +++++++++++++++++++++++++------------------
 fs/xfs/libxfs/xfs_attr_leaf.c |  3 ++-
 2 files changed, 32 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e4c1b4b..666cc69 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -337,6 +337,7 @@ xfs_attr_set_iter(
 	struct xfs_da_state		*state = NULL;
 	int				forkoff, error = 0;
 	int				retval = 0;
+	struct xfs_mount		*mp = args->dp->i_mount;
 
 	/* State machine switch */
 	switch (dac->dela_state) {
@@ -470,16 +471,21 @@ xfs_attr_set_iter(
 		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
 
-		error = xfs_attr3_leaf_flipflags(args);
-		if (error)
-			return error;
-		/*
-		 * Commit the flag value change and start the next trans in
-		 * series.
-		 */
-		dac->dela_state = XFS_DAS_FLIP_LFLAG;
-		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
-		return -EAGAIN;
+		if (!xfs_hasdelattr(mp)) {
+			error = xfs_attr3_leaf_flipflags(args);
+			if (error)
+				return error;
+			/*
+			 * Commit the flag value change and start the next trans
+			 * in series.
+			 */
+			dac->dela_state = XFS_DAS_FLIP_LFLAG;
+			trace_xfs_attr_set_iter_return(dac->dela_state,
+						       args->dp);
+			return -EAGAIN;
+		}
+
+		/* fallthrough */
 	case XFS_DAS_FLIP_LFLAG:
 		/*
 		 * Dismantle the "old" attribute/value pair by removing a
@@ -588,17 +594,21 @@ xfs_attr_set_iter(
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-		error = xfs_attr3_leaf_flipflags(args);
-		if (error)
-			goto out;
-		/*
-		 * Commit the flag value change and start the next trans in
-		 * series
-		 */
-		dac->dela_state = XFS_DAS_FLIP_NFLAG;
-		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
-		return -EAGAIN;
+		if (!xfs_hasdelattr(mp)) {
+			error = xfs_attr3_leaf_flipflags(args);
+			if (error)
+				goto out;
+			/*
+			 * Commit the flag value change and start the next trans
+			 * in series
+			 */
+			dac->dela_state = XFS_DAS_FLIP_NFLAG;
+			trace_xfs_attr_set_iter_return(dac->dela_state,
+						       args->dp);
+			return -EAGAIN;
+		}
 
+		/* fallthrough */
 	case XFS_DAS_FLIP_NFLAG:
 		/*
 		 * Dismantle the "old" attribute/value pair by removing a
@@ -1277,7 +1287,6 @@ int xfs_attr_node_addname_work(
 	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
 	 * flag means that we will find the "old" attr, not the "new" one.
 	 */
-	args->attr_filter |= XFS_ATTR_INCOMPLETE;
 	state = xfs_da_state_alloc(args);
 	state->inleaf = 0;
 	error = xfs_da3_node_lookup_int(state, &retval);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 3780141..ec707bd 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1486,7 +1486,8 @@ xfs_attr3_leaf_add_work(
 	if (tmp)
 		entry->flags |= XFS_ATTR_LOCAL;
 	if (args->op_flags & XFS_DA_OP_RENAME) {
-		entry->flags |= XFS_ATTR_INCOMPLETE;
+		if (!xfs_hasdelattr(mp))
+			entry->flags |= XFS_ATTR_INCOMPLETE;
 		if ((args->blkno2 == args->blkno) &&
 		    (args->index2 <= args->index)) {
 			args->index2++;
-- 
2.7.4

