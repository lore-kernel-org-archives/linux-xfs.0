Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1DC1C6FD19
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjCHWjJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:39:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjCHWjH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:39:07 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E3D6591F7
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:39:04 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328JwgMY007308
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:39:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=s92jZpqBPmoWVrbQZZ2+zXN/qbxJ9ptS5VSkb8O1/mg=;
 b=0gKpvy3nq8mvrNmg0BnuRJ0ZtxyTkYI/sUfA+KrLgjOojaF22KxDPsafBk2Kan6sqOHZ
 lf00PF4gJvzSjtlMRNI6NGhVVp9fUbLaFBjzdMh8pGy7TAwXW/NgDUgX3thm1zB2VHNn
 kEBKY3ltwQU80+YBtiGjoC8hrPj4d/XRZ9SfC1EyF6uGAchKqlJWnUv32mpodJatRjB3
 cCm0UJ2l9eWnGr4nqe2y4AWz6pjR33kF57zX8IkWV4s2pfSnEIFE7TmT3uIiPmkWyCAE
 JjIYt+4UVUfnFND6y62a0hE3+me/e8Ik3Rr+V3YgvUctJaMlUpd4dFqPWPW+yuyI5IFh 1w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p415j1fc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:39:03 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328MLOU0020875
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:54 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2043.outbound.protection.outlook.com [104.47.51.43])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6fu8my9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vhu7jMTvCLL9II4TTdwGp5L+Xq6/fDPzkcdUl5JmHaYLklmPujcv705ka9HBWe54LVdGeJ4izhd8N+yn0eMzilDfNCidzovrUSJf/6D47EB2SvR8RsNTl4oHDiMSkSUA5zs5q84TYSD6s5R7mskksyCR/Mj42z11zMjt3GS5Bt4Jpw45ClRRzHsXryULlZVC+Zw83uCI2sLNNf/k9cSg5HJwhAaxe7SmGHFsivJuwmySZRrYetdkUj1qrpTWS1m6MIG8n7PS+qSfmoX30Mj+WoX6hroOBeJr8aj1HLJOuhM3tAJeV0UZ9t93nc3y2yvWhH8dSH7wefbFMxYO9xDnyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s92jZpqBPmoWVrbQZZ2+zXN/qbxJ9ptS5VSkb8O1/mg=;
 b=OSm2iYCkDpNWUEOSQM1zqrRQcpl984TzIC/JOnsiaYDYWjez0fynAeBdmu3OAUvYf512XCSBBhpW7qufdmluc+9gqmcgbVh3a/zwPty+56dQZDwZVblK0guPZPxW4szwFR5TItQc30XKdpNRDRcfU8rDxvOq/NAtqOVo2cCB6/JKuzoXDA0kvKkp0sebUOwqNfkkO7X8cXTjnsW9DIxWRLsmwSAd9MsiuPs6Jen4OzYt3pgnVlrUSk0QnavxJy/kwvNLhmi38L8GG29KKmezWWonLEBmcBzoue27OUFGmslgh2ZKBii+znd90Csz9u5TqwuKZraArgTyKlxq8+yhkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s92jZpqBPmoWVrbQZZ2+zXN/qbxJ9ptS5VSkb8O1/mg=;
 b=h5/QP2UAzazBU7ooB4jTw24EPv2BLQqS9qe5AFIwXcs0IePVFrOdx63sDgusDxa/pKRAyfUKZDASjYU/8pXwEDRKhH9EeZ7btp5c+Js5tcAaOhJ6/qWkzDV6e3dJUwhvKb9T7K4o3q1pVWYWO5LW9C4rb9rbU2Ls7aCKF7pGG9c=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4162.namprd10.prod.outlook.com (2603:10b6:a03:20c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Wed, 8 Mar
 2023 22:38:52 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:38:52 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 30/32] xfs: move/add parent pointer validators to xfs_parent
Date:   Wed,  8 Mar 2023 15:37:52 -0700
Message-Id: <20230308223754.1455051-31-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308223754.1455051-1-allison.henderson@oracle.com>
References: <20230308223754.1455051-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0039.namprd07.prod.outlook.com
 (2603:10b6:510:e::14) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|BY5PR10MB4162:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f26f208-6979-4111-9414-08db2025e479
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Of1Bf7Tn+6pN+iIvz1zQjHd5uG5eEc4dzrcvvtpNsp8JzfF61XzuklbFYFANKNsE7OhQRMV+rXtwAaPJ0kgNcypZQdfysVUrQKT9n2oE3dWb4GTYkNO//l6w515xv2W5VBDtCoGLmzwS5iIzjADe9VhdAi9OXhtT/UdjwlfHO9zAc9fsGgv1Oey3S9pwgXYg1LjrF7fwhqckqYpX96DpPXQe6Mg8pGzCn44dnRPWHkNPTO1gVFRMQy43lE59J9Nj2A1XjulOuSnrdcGLYrSwRtOoDRA/topCVsomPmc++YcjaqLYx26bEUmPIFbk34RQcXpdhmuI8PLAYJQkULQMLepw1455RtjTaRW5bJ0AuaIyvZ/5sEkn3ROqoYyKXBA1aUl9+AuD5x+hUy6RudUNnWyQnk60TyCK0bT2gCi/+5fYDT4ivtSFLcM5ZJvqG5RLghbP5RNZFCtxuo/oB/dvfCuyckfQmdQ4U8+myMJVi/FMgOUZj8YtIIvYJdyB4TK6oPDfmmjlP5PGC0XS0kMV/Our+m3BIWZVN+EkejQw1S60ahCGkdsuha+hrKU1lAnvTwMSM1y73WVNdy74AcUA9mrqtWgUued/Hp8VrwUt+U8/cu9de+1UFSKd+nKYRVhfZHGiGq68s+Jrml6U7TzVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(346002)(136003)(39860400002)(366004)(451199018)(5660300002)(8936002)(8676002)(66946007)(66556008)(86362001)(66476007)(36756003)(478600001)(83380400001)(316002)(41300700001)(6486002)(6916009)(2906002)(186003)(38100700002)(6512007)(26005)(9686003)(6506007)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M9LtyHX+dO7bLryD9CYuhWVt9De4vzHl8d5jegGtiFLuJmTR72PlLL+yHIyv?=
 =?us-ascii?Q?/4r1BU88AqxP6dBYpfgQM6xI7RLT7XBDl/ZZEXnCiDaejLu394X2dZqrn1Wh?=
 =?us-ascii?Q?bPc3Tvq56PgtLv5x3dlPuGM6W5PyMNXzkWgy85suJRdScD/NDA6k3gucygwZ?=
 =?us-ascii?Q?PnwygfstSUAxgPaoyvP2giVhQbyjp2bsZqua/GGsgH1Qzhm9kWbGzPBDJFez?=
 =?us-ascii?Q?jqNWtWiMEKWwMUcI+boKAy+NBAXNGqcuFIafFJC2PIiuVHkuo2/LAUiIX5BU?=
 =?us-ascii?Q?wYGBivpPciYlU9McN6bYrJaRgkKskqRkKbdG4OKCKAMmRYpaDu+SFJDl9mdq?=
 =?us-ascii?Q?/hahrrzsn6TZcMnVsV4O+AWvrZ1R1hRsPC9g0oxvqY/dm5wCO6jKHMrnUP2v?=
 =?us-ascii?Q?4LLMcOx30yY+Nif13epcj+BuPpn4nz5ZAna5UNVtiAfxDQs6fTzUx9V9O+BN?=
 =?us-ascii?Q?Cz8qVb2pPetY5PFseePjbwMP+wL0HPlBSyJYMltfEtf6JDgIQjqPrebVEppY?=
 =?us-ascii?Q?58OadFdb6rmaQRqgAgToEJZQCOZhNPcHFXOK87ZiaKk1klhjerEP17Nm26/R?=
 =?us-ascii?Q?WR7FdqyCggBwowaS/JHdxBgUcsM06jFQkMr/1kWvLEGeEl8x++GuOCuWCfsY?=
 =?us-ascii?Q?6ZuZgcIb7mfdIVN3vBr1qf1OKfSEpA5d+l9RMaLNxxpSWQ6cYvRISLjZBnqK?=
 =?us-ascii?Q?MZM00xiBpsalVCDQS89QrvIn+omy2HEvdSszJ8kT1mJ0DdY7Km+JS/tbHlzr?=
 =?us-ascii?Q?W5C1xyPEVd3lMPa8tfcxkjs0JXKCw+vL6TS9M2+UZ1u9aLl7njCfctuhA3jr?=
 =?us-ascii?Q?kbKyJgYhjiNmwcRBpTG2SnQJE5UTLi+ApWC7F0vkyrIVx5qV7slTPUMalSNM?=
 =?us-ascii?Q?NCK8dxkN6UoTZYhue0bNZEzb92Tl9o1WEg2G3ZT3qD+nawcJu4NLsQAMBuLO?=
 =?us-ascii?Q?lgzUvZ9s4dIwk/WnihixEu9az9ZRqLKHmuBepQdZZTbJE3SJ8rXYJQJ6n6zI?=
 =?us-ascii?Q?Lv/T7RDtKbL9Qw5yjQoZzllO6FHtDnFVthkf/hppXaRr+2iqd5f+tkqeRO/x?=
 =?us-ascii?Q?Zw1F746rDSxhztX8JsXXzzqderA59f4zY7+rUNo5LyxM4rlyiOpqx4lMGWwG?=
 =?us-ascii?Q?IrWHEfAjbStOp0m6VJ4qkZprxy1ARmrV0y5vUemESuIGBcAtqATn0D4je1Qy?=
 =?us-ascii?Q?nFEJ4IoQ7Tgrz5jyhr5JI0t6NNNj90Bvu63UKNY5d4KXi28rQdLol7PfEYne?=
 =?us-ascii?Q?AWtdqzcvEKdSnHdn8o8qv00piMCi/ELaffFq4pEyL/K/81xPrL2Kl+5l9bMe?=
 =?us-ascii?Q?NBPLq2dSpoRJ4vW5NfiowCOQuwI9Jqf5PAW058RVitI6OFdVW/MUS7s/E9S6?=
 =?us-ascii?Q?kSFoBXjbuGnYh4xFMs/WcTDYiVHGSbj9YiVkyjIhR534JIqWVVrOHN1yYMA0?=
 =?us-ascii?Q?y90dSGQfAywaovvtIxK2pS6Yh+718ZvlS6GyCBBr+AejXn1s5mSXGIxZOSp6?=
 =?us-ascii?Q?oj75mFnyqTTMtZjKdRnRX7YQbbb5SBvFR1Hi8leOv5VGG3rvT83JQ8HVcKz1?=
 =?us-ascii?Q?I5TfVekAtGVSZfz81F2rr8iwpEI64FKSfi85K62csCQ23o1SKS93cFNJpVaQ?=
 =?us-ascii?Q?6w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 4beq7i8e1Zx4SiCQUxyQkB9fuxXUSHWKL/wd4ObxN6bUq9dYxnh8nruRii0WQmpAPu8KFsCuNACDE0M1D9Y3cklyb4QwIK3CnO32BjczdmD5ULGkMHTlGS+AWdn8JGQWwC0HMDOV6SwDOKVeMqk5c+a2rAz2aWUGKYGilC0tOAwevkWWHSyQPCuDeHkrT4+AfEX0CBz4caR+0uOCv4veM7NSotScwB33c3su8Cil1lr7lkpa8tl1pZ9Y2nHmlFAzShnUOXN7r6y5nNdJfz7N+BPkiP0IT1WCbRNPQ5qg2F6pcXA2ee608L6gre7P8iuRyO9xpi0OQQlpwIHHZoB4OdycUqMjf1GaLIY/MlkPloiU4LIZonkJMaJQCOoxC1iyH2lslZjs+2JOzm5CbA9wlysIfCcb6NVQxA3aDO6zvE3ChPJUzZGrkRji6hDgnXarzRo1T/Hdk3iBb6exk3CNbOh+N25EtRUN6rqzomK6q/EZjv30bQTKR3YIB+FtSuXMXLFNuake/NbCrQ9CnNZMFOvYIeFKlWLgzziXHdhCekSYBcQQOSYl/Oih2aHGdIShyLEBAM5jNp852hl2XkbBAzCQCM6Ir+mESoQxVfj54tbnCnxKBHy3MwMTW4NFh0ARIU4aFvtziFYvQgsfs7+C+XINol8n/L9JnD8k7Hof4JBlYtstSskT2c3AShO5t+4ydkGr9axx8W3mvnSIsOLTACSaK0jT2vSCWPlMgGsG4vyyaf7KssuwyOzrj7Ib+2DBy9wy+emRMZiqXT3naOUUkg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f26f208-6979-4111-9414-08db2025e479
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:38:52.3685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 08dEqhAbtE3Arsuk/MVaCTnUOOiYAyHF2ncQ6UrI0x+/Y0DQrPzf2OUndjGQFzAy2CZXjwDl8mxdObnlJNgNSOfRBh0zoUoK/oktgLlMSaQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4162
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303080190
X-Proofpoint-GUID: AM2YJGF4uLiWWNbD4L5-OAy39Q9MZGmM
X-Proofpoint-ORIG-GUID: AM2YJGF4uLiWWNbD4L5-OAy39Q9MZGmM
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch is part of the ofsck specific additions for pptrs

Move the parent pointer xattr name validator to xfs_parent.c
and add a helper function that is later used in ofsck

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c   | 55 +++++++-------------------------------
 fs/xfs/libxfs/xfs_attr.h   |  2 +-
 fs/xfs/libxfs/xfs_parent.c | 44 ++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h |  7 +++++
 4 files changed, 62 insertions(+), 46 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 57080ea4c869..3065dd622102 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -26,6 +26,7 @@
 #include "xfs_trace.h"
 #include "xfs_attr_item.h"
 #include "xfs_xattr.h"
+#include "xfs_parent.h"
 
 struct kmem_cache		*xfs_attr_intent_cache;
 
@@ -1577,36 +1578,17 @@ xfs_attr_node_get(
 	return error;
 }
 
-/*
- * Verify parent pointer attribute is valid.
- * Return true on success or false on failure
- */
-STATIC bool
-xfs_verify_pptr(
-	struct xfs_mount			*mp,
-	const struct xfs_parent_name_rec	*rec)
+/* Returns true if the attribute entry name is valid. */
+bool
+xfs_attr_namecheck(
+	struct xfs_mount	*mp,
+	const void		*name,
+	size_t			length,
+	unsigned int		flags)
 {
-	xfs_ino_t				p_ino;
-	xfs_dir2_dataptr_t			p_diroffset;
-
-	p_ino = be64_to_cpu(rec->p_ino);
-	p_diroffset = be32_to_cpu(rec->p_diroffset);
-
-	if (!xfs_verify_ino(mp, p_ino))
-		return false;
+	if (flags & XFS_ATTR_PARENT)
+		return xfs_parent_namecheck(mp, name, length, flags);
 
-	if (p_diroffset > XFS_DIR2_MAX_DATAPTR)
-		return false;
-
-	return true;
-}
-
-/* Returns true if the string attribute entry name is valid. */
-static bool
-xfs_str_attr_namecheck(
-	const void	*name,
-	size_t		length)
-{
 	/*
 	 * MAXNAMELEN includes the trailing null, but (name/length) leave it
 	 * out, so use >= for the length check.
@@ -1618,23 +1600,6 @@ xfs_str_attr_namecheck(
 	return !memchr(name, 0, length);
 }
 
-/* Returns true if the attribute entry name is valid. */
-bool
-xfs_attr_namecheck(
-	struct xfs_mount	*mp,
-	const void		*name,
-	size_t			length,
-	int			flags)
-{
-	if (flags & XFS_ATTR_PARENT) {
-		if (length != sizeof(struct xfs_parent_name_rec))
-			return false;
-		return xfs_verify_pptr(mp, (struct xfs_parent_name_rec *)name);
-	}
-
-	return xfs_str_attr_namecheck(name, length);
-}
-
 int __init
 xfs_attr_intent_init_cache(void)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index b034cc165274..02a20b948c8f 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -552,7 +552,7 @@ int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
 bool xfs_attr_namecheck(struct xfs_mount *mp, const void *name, size_t length,
-			int flags);
+		unsigned int flags);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index cc3640be15d9..179b9bebaf25 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -45,6 +45,50 @@ struct kmem_cache		*xfs_parent_intent_cache;
  * occurring.
  */
 
+/* Return true if parent pointer EA name is valid. */
+bool
+xfs_parent_namecheck(
+	struct xfs_mount			*mp,
+	const struct xfs_parent_name_rec	*rec,
+	size_t					reclen,
+	unsigned int				attr_flags)
+{
+	xfs_ino_t				p_ino;
+	xfs_dir2_dataptr_t			p_diroffset;
+
+	if (reclen != sizeof(struct xfs_parent_name_rec))
+		return false;
+
+	/* Only one namespace bit allowed. */
+	if (hweight32(attr_flags & XFS_ATTR_NSP_ONDISK_MASK) > 1)
+		return false;
+
+	p_ino = be64_to_cpu(rec->p_ino);
+	if (!xfs_verify_ino(mp, p_ino))
+		return false;
+
+	p_diroffset = be32_to_cpu(rec->p_diroffset);
+	if (p_diroffset > XFS_DIR2_MAX_DATAPTR)
+		return false;
+
+	return true;
+}
+
+/* Return true if parent pointer EA value is valid. */
+bool
+xfs_parent_valuecheck(
+	struct xfs_mount		*mp,
+	const void			*value,
+	size_t				valuelen)
+{
+	if (valuelen == 0 || valuelen >= MAXNAMELEN)
+		return false;
+
+	if (value == NULL)
+		return false;
+
+	return true;
+}
 
 /* Initializes a xfs_parent_name_rec to be stored as an attribute name */
 void
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index c14da6418e58..f4f5887d1133 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -8,6 +8,13 @@
 
 extern struct kmem_cache	*xfs_parent_intent_cache;
 
+/* Metadata validators */
+bool xfs_parent_namecheck(struct xfs_mount *mp,
+		const struct xfs_parent_name_rec *rec, size_t reclen,
+		unsigned int attr_flags);
+bool xfs_parent_valuecheck(struct xfs_mount *mp, const void *value,
+		size_t valuelen);
+
 /*
  * Incore version of a parent pointer, also contains dirent name so callers
  * can pass/obtain all the parent pointer information in a single structure
-- 
2.25.1

