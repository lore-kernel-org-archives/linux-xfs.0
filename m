Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED977C4320A
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:19:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5E1861108
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:19:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235518AbhG0GTz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:19:55 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:48454 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234905AbhG0GTs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:19:48 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6G8QL024358
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=L8+EUA5xLKHXKe5fsJI6RCdbvOoCYQ5a/PYwvMf19ew=;
 b=qD87eoWf5FZcUbshmXWg6w/BBFxKV0XX4Q1ETBQCDLGt1v0/pDvkinFaZOFOQNgwjUwl
 2AvsUJUgukxohhDDhZVBT75akgtwnps55rSxdRNCTiDoBrUevV+a6s1G1FM5GTgm2YYl
 SIeb4c1++Tkw/lUVrGtkGbEPVOQLJP9hy8IkQXXO1AEfFy26AQc8hfGtztwfa4nQjjak
 ETh315/kiS+uklOJn1ABQG/XMwo61XxOCCBg2wnZ89YLzcm/u5rseJm75TS/BoPy/KY6
 Ki6rhao16gp6ZBT64QSExySkYHNfXiYNzhK6Sg/3eXSA2blbO5N0hCs/UY4DOGiXGfxD RQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=L8+EUA5xLKHXKe5fsJI6RCdbvOoCYQ5a/PYwvMf19ew=;
 b=fmWIdqaGLElsrDe77fgPTqy4a/XA4JSPwl1qNdGA6DEywzawgw/m7jTBjjM9LwO2xMON
 pS4yZpbg8xNtBsheTLWGxud1WaaTR4yt643LDi4BSuF6VmpnmxI+Q7/KZ/QBQoBMwNnL
 Nul/eVk4p4MUXfCDret++GvS+Y0wyMjWNWyWn0h4WljNVvWsdhUH+j7KSKVLVfenzetH
 R8aaBDYc1ki5nU/YBK2D2z2ujsNHK5TEnvT5yPbYQ/WicO5XvoKxaHBZu4OwkgDESHgB
 t9GkPT2NBaslRnXhR/0SH1IuZQiRcrh1SBo4ZhGm/l4mnJBZ9BWh6vIMLONkkB0sFrJg xg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a235drun4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6Eia9065026
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:47 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by userp3020.oracle.com with ESMTP id 3a234uvnq3-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GzDWMJwUUzYi4YIAgNytnaogD3m2yt0QCuRUOGiZ/BayuPTIauLK51E5ADwPqLv1okRzELVhaSvayJ5exSFElJ7oFDBTIVlM+B3gj94PiTPkNnecX2Ah28DIqbeWZGG5+CFSnnvZA9TF30/Ix66khhsiZbdbpwTiSms9jEbx7xgDNyG+cCPJu0arIZmVgaTZjPbs/Z0IdzAaDMdWPyaZoZ8OzZd8q07HOkdM9FXGzpsJCwfbVazeujT6GkVu+ngKbA3go62AjebxvmC7fNgWqGcnE2MmKOTSD86BYDddm42L8GyKfNNmfD8XkRKjnI7t0KU0bnN7m9qY3CfCWLVfQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L8+EUA5xLKHXKe5fsJI6RCdbvOoCYQ5a/PYwvMf19ew=;
 b=kWe7KLjneZYGk7oy9J2htGGfFU5yvos/a54GFgoxBs9+17Wopaj95Jbuum7Gqc05U0wFfaDN1uDY0nNhwZqFcsUsTDYOb7Rt0I/k3oAAnONnxMDR+w95Ago91rV0tbxn9tefyNz5NG1u3rPxFdZoHmf0CVW238X6PEwFiNEd1qMej+uXql49xbBiYT4kadYqF2x4MS2ZZZcEGRpfWZ4XtsG146DYQUudL1OslqCwtV0hz4n4XFAj15KpdqmTYa2cSKcbaRTdsf4/GdnDiFhvnDoSrEoDbvCjZQp067fnxgttdDO2vMq041uimp/YEpTZsz9dM2KfBZTdwFIiYXU+Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L8+EUA5xLKHXKe5fsJI6RCdbvOoCYQ5a/PYwvMf19ew=;
 b=IPZetPn7mLU3igY1eKMrEajeYaxkDeMd4Ott+1kgkZGWol2NeoMQ+slwiW6GjAR5VBthc3/DqJ7pHSIwRw+1mqyTQ0isU8r4uDkW9bkviJkua9GepmEiD6OXclD2hS47D+dgnAGc7y9J8hO1+cLRSHzQX3Wg9zIp8A3f2q/vKr4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3669.namprd10.prod.outlook.com (2603:10b6:a03:119::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Tue, 27 Jul
 2021 06:19:40 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:19:40 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 03/27] xfsprogs: Refactor xfs_attr_set_shortform
Date:   Mon, 26 Jul 2021 23:18:40 -0700
Message-Id: <20210727061904.11084-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727061904.11084-1-allison.henderson@oracle.com>
References: <20210727061904.11084-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:332::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0074.namprd05.prod.outlook.com (2603:10b6:a03:332::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:19:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4cb27b4f-50d0-49fc-c11e-08d950c6842f
X-MS-TrafficTypeDiagnostic: BYAPR10MB3669:
X-Microsoft-Antispam-PRVS: <BYAPR10MB366953A73EABF5FD9AA5B0ED95E99@BYAPR10MB3669.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qqWYlU97yLsjKjo4rWXHVk2QXYSPAXMuL1pJSvPzMA9SKLgISnKavckA0DhPflxd1RrS8va3TwomjiWds4S+LPYaMJsvdCISlc5MaAqYz75oBgo1BZoY9x9tg95nszLkSHLzCfyX325zeY6PObxPAUwC7+i4UEl0+J3Yq+jur+ijvZETn+xKEoqMnYBFk7AKZ9i4bFZuEUK8usrNqzyIk5x1jEn1Hiu/rFb3TiYVUbtgrsf2d/taTJCXWzQlmyGrxRwQSY8f6/MaOWemGJUjg8OwTMYeuZqQzFkB0OQDxeGgf+By8zI2iw5XKZ4xxYGVk7BmEfhvOBS9I8KqcwgrqRHCT8LgO+4XKX8Is3lSh0PbdiuL8ZBKkoYblXRORTwA8ApDk3NNrdxylqTi3KZGL4v7CnIOwGXClU/YskIQt3C1ZeMSmX88CyjLWzUvGlvlFobBZz6dKAJ2vZPbfMrIc86Q63CW+1x+6FVgUvG0ANcVOZgmm/Pba3FRYjyEqOPeW8ul6ItNk0uguoXO1ibyIjMekL8y/RQCLVdcNVqZMYePHHV9XRlxLBGrXp2QoglVSLT6dux9CfvX506NpRUntgSo3TpIWIt9K6ljm2inODpPTAHWyw9QTPgbjnvB6XMf99ByBygYCp2uYaHxVkDYBjVAVLj1DMjYljC1yTC0zGFnVZfwH8HHhmwqGtXni8jxiuKblF3ujLMEX5SOhILVeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(136003)(39860400002)(366004)(44832011)(478600001)(38100700002)(38350700002)(52116002)(2906002)(6486002)(186003)(6512007)(26005)(1076003)(8936002)(8676002)(83380400001)(6506007)(5660300002)(36756003)(6916009)(86362001)(956004)(2616005)(316002)(66556008)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BnevooII6JjX8vYsQVlfdgbkR7VXCTFHDGU8ExUmvM16qS2e3635yuemCSVT?=
 =?us-ascii?Q?+XbNXmAL/FhZsAux8hc2bfZ3x8r29HnIcQ/+TIDXfdlUclt0wq7uG4VPwqRV?=
 =?us-ascii?Q?J7kI2mq6aFaSh4ln7XHOvi/QU7DnMZjY93bfAxHcJRlMbFTZbpdmWEjGx9bF?=
 =?us-ascii?Q?kT0yvlTbo8gdYJamENYpyJmQ87BKCl2HPy2E8X0+Ms+DgVHcNnf3VXZ47Ada?=
 =?us-ascii?Q?Td6WGpv17Idm5gYy8dv0iJ6JyrPzXn/PGXZTv8oSvjDdvsLd6UOhbpzNcO4v?=
 =?us-ascii?Q?mmFYVppkQFktyBo5WEwNhgf86YxeQxpa7OwmQSbJvA7hSrqwq4CvedXyqmru?=
 =?us-ascii?Q?XhhdgyT0qC41h67yfxvbZPlsR/chy4RBiA2cayBR8TsdYPq7+7rANVbcTHBs?=
 =?us-ascii?Q?OWi1TtrZFzd/iS2aKiTuwgHCEPXFXg3xAsyEAPc7rC0EEFo7eAk4hqCMPud4?=
 =?us-ascii?Q?ZghPrBrsKNEOLXGDhekkhaVplGsLdqWiBVq5zibJyxDySSUO7GQS45H7c39F?=
 =?us-ascii?Q?G59stFuOUGK7/VJABf8hiOEwLoKKFbgspqR9JhuclSj72kkmeGt1abUrEJLq?=
 =?us-ascii?Q?KcEDHn2VTYUul2bu125cDUoPKR1p+HhcRButQFy6XfT6CXSNrct3OPvbzaYS?=
 =?us-ascii?Q?ku/3xGhVsx5Si0HB8dZfHOMGk3OoCuEcnJxxKpuXfu23gw+oRGahGo8krnpT?=
 =?us-ascii?Q?4SoOswrjg7wc1tvpKKkAIy4K7MaqqmC2DO5Pn+kHF1Grx1v9JcDgW6t1v0xy?=
 =?us-ascii?Q?2CtpbZob9TNqM48VfU7IoawKCqY00BclfsFW6b5NIyxfgb9gDsyteDUSatIN?=
 =?us-ascii?Q?9VO/gD6Z5czTB6sy5sowX04/gF9ZTU1gf9yRk5wfMQkECzi72jaAOy/6xR3t?=
 =?us-ascii?Q?lSg8Zd6F0ka+q9lGbdgTTOSjjQYVGJ+zCq+yczsaZ2j9MsKmZCXu9NzCQuNr?=
 =?us-ascii?Q?ZKaVx/Mb3izP4M0qBnsz1VR9AjdXUXYvGcjRoTor2aAIFnIyOIlQQz8+FsFN?=
 =?us-ascii?Q?4hXBANNiKdbjHUnUOTdhoEtFaz/vJBYcqGbdQdM3mSSQXmEXfBOQ2ne2YB20?=
 =?us-ascii?Q?ENg49WOPmKLyDe4AaRt8jklJcv877WUmfwDCRMtNUC6zuaOZa4OyfkNtUNPg?=
 =?us-ascii?Q?R3KgPkulFF1G1JY2VPOom8hy35ng3ZlJcMrrHG/CcuIqrNWthH38aTZhCGVJ?=
 =?us-ascii?Q?yndHu+qOo4c1NlvGjPwy93/4ADr+bJ52hCotP1ju5e6XR782DtErX9izyVLh?=
 =?us-ascii?Q?y9y3MACOsQxd1t6AFbhNtAN0YaezJL+JZoec6vo+ZH5+Pj0CsC/76vU+FBfr?=
 =?us-ascii?Q?FIzG08vRfnSo1G03bT4nPusA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cb27b4f-50d0-49fc-c11e-08d950c6842f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:19:40.2817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S/mKRIq5UQdZN8XvHTASFa9qGuhf8iAobNoNugMa/OUEFXFlhs28cQUZ0OQzT5maqlDADvKsM9aJSAFp2rC0CJ3VtG9flQtREctMpIaJfhY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3669
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270037
X-Proofpoint-GUID: 6zXBGzI5S5vRZtM3baqWH6ByMsmLcb-d
X-Proofpoint-ORIG-GUID: 6zXBGzI5S5vRZtM3baqWH6ByMsmLcb-d
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch is actually the combination of patches from the previous
version (v18).  Initially patch 3 hoisted xfs_attr_set_shortform, and
the next added the helper xfs_attr_set_fmt. xfs_attr_set_fmt is similar
the old xfs_attr_set_shortform. It returns 0 when the attr has been set
and no further action is needed. It returns -EAGAIN when shortform has
been transformed to leaf, and the calling function should proceed the
set the attr in leaf form.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 libxfs/xfs_attr.c | 42 ++++++++++++++----------------------------
 1 file changed, 14 insertions(+), 28 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 5da3ec3..b181777 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -236,16 +236,11 @@ xfs_attr_is_shortform(
 		ip->i_afp->if_nextents == 0);
 }
 
-/*
- * Attempts to set an attr in shortform, or converts short form to leaf form if
- * there is not enough room.  If the attr is set, the transaction is committed
- * and set to NULL.
- */
 STATIC int
-xfs_attr_set_shortform(
-	struct xfs_da_args	*args,
-	struct xfs_buf		**leaf_bp)
+xfs_attr_set_fmt(
+	struct xfs_da_args	*args)
 {
+	struct xfs_buf          *leaf_bp = NULL;
 	struct xfs_inode	*dp = args->dp;
 	int			error, error2 = 0;
 
@@ -258,29 +253,29 @@ xfs_attr_set_shortform(
 		args->trans = NULL;
 		return error ? error : error2;
 	}
+
 	/*
 	 * It won't fit in the shortform, transform to a leaf block.  GROT:
 	 * another possible req'mt for a double-split btree op.
 	 */
-	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
+	error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
 	if (error)
 		return error;
 
 	/*
 	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
 	 * push cannot grab the half-baked leaf buffer and run into problems
-	 * with the write verifier. Once we're done rolling the transaction we
-	 * can release the hold and add the attr to the leaf.
+	 * with the write verifier.
 	 */
-	xfs_trans_bhold(args->trans, *leaf_bp);
+	xfs_trans_bhold(args->trans, leaf_bp);
 	error = xfs_defer_finish(&args->trans);
-	xfs_trans_bhold_release(args->trans, *leaf_bp);
+	xfs_trans_bhold_release(args->trans, leaf_bp);
 	if (error) {
-		xfs_trans_brelse(args->trans, *leaf_bp);
+		xfs_trans_brelse(args->trans, leaf_bp);
 		return error;
 	}
 
-	return 0;
+	return -EAGAIN;
 }
 
 /*
@@ -291,8 +286,7 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
-	struct xfs_buf          *leaf_bp = NULL;
-	int			error = 0;
+	int			error;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -301,15 +295,8 @@ xfs_attr_set_args(
 	 * again.
 	 */
 	if (xfs_attr_is_shortform(dp)) {
-
-		/*
-		 * If the attr was successfully set in shortform, the
-		 * transaction is committed and set to NULL.  Otherwise, is it
-		 * converted from shortform to leaf, and the transaction is
-		 * retained.
-		 */
-		error = xfs_attr_set_shortform(args, &leaf_bp);
-		if (error || !args->trans)
+		error = xfs_attr_set_fmt(args);
+		if (error != -EAGAIN)
 			return error;
 	}
 
@@ -344,8 +331,7 @@ xfs_attr_set_args(
 			return error;
 	}
 
-	error = xfs_attr_node_addname(args);
-	return error;
+	return xfs_attr_node_addname(args);
 }
 
 /*
-- 
2.7.4

