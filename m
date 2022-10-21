Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A32FA3743
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Oct 2022 22:30:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiJUWaD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Oct 2022 18:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiJUW34 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2022 18:29:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7950850703
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 15:29:51 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLDjaa030003
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=0IGnxB5lMnsuacpBsJdGBAKf7/XnPJf444IF0qci5v0=;
 b=UcEUr/CXj6fDi/fHd9/a/6kR3v1UovE1KcqRlbSUOjWXeMOPoWcAfNNp3kfHGjIwkzXN
 Wuxfq1+MqlQ+p3ZafPmoxQyJwg4jaHIkoBHXHAncs1i0pHMbCmh2acPcHyysoLjG3BRQ
 KqxjSHAFCGelHvpC1ayhsQXc3sZou22qeie9iSNpBvkxn26Ssq4hx8tpS4rhcNR+LxHk
 xmd6PCuH5fy32NBsBiAIyf9aMwXiKOHkkeNnS15c5DSOHUmjNmUcJRoqDxK388zJYKhv
 WOjePRlMQRvbtf1o7hn/ae0ruTPBMJqhT4WYhcOQ68QGzQgWeUaoGTtkIvjnOUzJKCqn Ww== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7mw3tc20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:50 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29LKRHpJ018169
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:50 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2045.outbound.protection.outlook.com [104.47.57.45])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8j0uc7js-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UoupG3ytuiM85pM25y9RJ2fB97MxQaYjaXOTWBgVuaI2UqIr130vLxSqTdKf82jPEEibbL1AR+ymJLsdmasduXgjkNyKze+VUieP92EWFKdu74jEzRWNDKef2+0bgczmZV3ktqlsEUvvHazSmQ07luHHfbmSRxdwThXoE5KkMVZOokJcBhc22vMsPMIO9MSeWkIEKroptyq7u+si/rUO9BXWbknzCBViRjyLq5VJrpbRNnpKjl0vjJqIGe7xAzLkH5bEJd8SM7ptam9/wSra52jRiR5Rqagc79wMtwOCVqVu96DljQrGQAf96wz3LjOwRK0etu41wm5x8O3qdKpKgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0IGnxB5lMnsuacpBsJdGBAKf7/XnPJf444IF0qci5v0=;
 b=AV+Z9GcQnninyQbl/EDWYT6dy/R4/cJsmWME9lVVMwDdE1iTXCoNhKGBCFbCnVSeoIMsHDLbV14i4HeNm1gJUasduvDYExtBxgFxiR0uQ8O4vM8vHU0+wHbFTEpE/NcWFOPsHJzka+tPsOorleg50nXBYAJEp7S9R+BOD//WRboWclNOmjpUaK280DbbkXtmx/7ylyvrzru5DmKPsGRSXfai5auEKpMNooygvAhwEXngeBpSpS5W+0pvBfmnpM0Hs+GxJ+ha3NSI7HXs0HiPdO4sYpquGUdwIRdkzxda13DsvGOkoy6jtE3jX9XjQo24Oef/mDdKnJtn94PDWMHRVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0IGnxB5lMnsuacpBsJdGBAKf7/XnPJf444IF0qci5v0=;
 b=lkoxVQxanaGdnNOoSEriBrT7EK0v2iMmCHEuvU0/76chmUkabijeI//brFp5zov0t0BoeHwnUVwI9nFb2nSkHNQ3fF6JItyzNkXuLy537y9FDMlp0tS/i+8UvdMOyEBAcRBSbyDuvNtwZRv+wWGs+b0ErCOEpP8Q14MGPckGuko=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO1PR10MB4433.namprd10.prod.outlook.com (2603:10b6:303:6e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Fri, 21 Oct
 2022 22:29:48 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 22:29:48 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 07/27] xfs: get directory offset when adding directory name
Date:   Fri, 21 Oct 2022 15:29:16 -0700
Message-Id: <20221021222936.934426-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021222936.934426-1-allison.henderson@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0005.namprd10.prod.outlook.com
 (2603:10b6:a03:255::10) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|CO1PR10MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: 3552b0cf-9f4e-480d-4eb3-08dab3b3c326
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TAHY92XMoMCoBzd+4YBowqiVqWfNjUPiHQmVedKtZRyg/RcbnafNu4EHbrPx0H94vP5vYH3VleJodNV7ZCSPIoMO40/rKiAcpqV1TG2QRWZt2qyRDsptDDKCodoupZmnfu/SPl8+ht1GCPSuc/IiDNHM2+yMdZG+zNdBBOybi26oAc3iJFDLfPjQJkuYfHwdgpSt+OlJLMQKG/cjslSy6A7+LjPYFjuE/eH2obkslZZ7sNaU/ap4ATsCQ4c/RRifJGFapE/Q31Lfq2MGsT4h0Tnf6fb2iS5z03Mjhx3sUhmxM7+l42OfJFztEUXzOp0gSf7pBX3sswuzGIM7GuijuCYLaxsh5W97uflLhsoODitq3VxIew6aw6DeEcJyeIsbS+UsFwr6llldf8EOHb98czKKnb2bkt6KXx6fkvFVbjqP/Wl97NhrhsZh2WEPqB2Jq/51bN7ZnGuSb1yw2UpaSl/HlUAeX7c2/j+dm5jwQdgVEeEfSzGz8Hb56WERqGB3uoUUDQXd7XLij92Y8CIZhoHlFRyqyTwfLd5l/Ak3SUk6O28KXEsWUszoCNZuOgLsXzpCvqnXM2cGkaXv2FIMMjoRKNbFRZRBVEefPvH2nJAYK2z57TlkgXMqBO1bafAX99P8zeLvZORGS0+mSSSoQxWrp/2FVeunmQo9gZhRzrZogkDnz8e/dFqe9U8TgUrwyESUEnChpvio4UkDdiyeiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199015)(36756003)(38100700002)(5660300002)(86362001)(6666004)(8936002)(83380400001)(6916009)(2616005)(6512007)(316002)(8676002)(6506007)(66946007)(478600001)(6486002)(66556008)(2906002)(1076003)(9686003)(41300700001)(66476007)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PhUy9Ht64nbHA4y436SzqxyzL9OP9PoffOMsER4VWs1NaPAc4AGrhkDkRD8T?=
 =?us-ascii?Q?UViQ1XznNw0rl8qmou9UAenwMpymGNpM/NbBj5uglv+5njLNGeLB3q948AhM?=
 =?us-ascii?Q?9yaNhyCveVNVVSTtYpOM7Xw6Y46NjtUjdjOi52uL8TUJW43/usA2EGt/3lgo?=
 =?us-ascii?Q?DvHQeNVTefPoyrsxGXQXF7NBEDkiiipwquStGaNt9GZQxrcWH11tPWDA5JAd?=
 =?us-ascii?Q?5yFE0FXmkqziD0PyKxEpf8GtacOJVXJaJC07NZwubOuceXqeIcVP6/CaCUhZ?=
 =?us-ascii?Q?FJ2QeM0EvR2h0WOLuaZNvSkfWKk2b/yKB2DrIeGWmdHTXMEkqX/MOSiJQnmQ?=
 =?us-ascii?Q?2yZh2s/mWS7ZV0kPGgGEMGOUHPEa6spBt6HG6RfL5ejfSfBxLOVL00SNdSKD?=
 =?us-ascii?Q?dZPS4VW/5gmac2HLLKUAPH1OpKhcD8STqnrhUfzHT0nuMVfKqNhR8W9peb5K?=
 =?us-ascii?Q?RyDOfduVl4Qz+SNS6w3V/OkHx0bZSsf9+SuE30UX3JgOnB/AQdNP9lCuTOfv?=
 =?us-ascii?Q?WhiIRVqBDJNSPYw1kc8yxMxRlSkuCgCp0uOAO3HrfAjQnTgQHiFNVDazfgo9?=
 =?us-ascii?Q?agTcwmSxRqGalZXCyplFXcZdeROLS5eIChSRuCZLnGtb9VbVZ1LKC25FQq3r?=
 =?us-ascii?Q?E8mrM04BknAICqbG5zkxmacUwKbQQclhWOV5SUAeaCk571A6tMfU5i8JI2i1?=
 =?us-ascii?Q?6triAUeujaFhHS01p7hjctbfmB0pCLDGmBh1TmhbVLp4spBZU+1h7T66ysIC?=
 =?us-ascii?Q?wyg+NmsiXm00Wwl5Cf2unKOSZIUacxZ/pTwmokNwT51AG1XPRqQfWW07t2bq?=
 =?us-ascii?Q?lKcGFv0WzoL7hY8wu4zD+J3uBxF0bsuKiueYg138htaqgHjekWg+TqYUGhIt?=
 =?us-ascii?Q?Sd9w1IYNjye5oohpnXFLUQARc/Dk6LrFeXs83uQ7+s/c7+bCWRpU3FDLXKZZ?=
 =?us-ascii?Q?3PLtPLTjzuOSLuoQ8YyMVci/mpx8uyq1CqkfFFl9i/6oGnJdU7YfUbU9UQNK?=
 =?us-ascii?Q?KICyZjHNYeaWjUWd0WA84QhHDzlAsIItquYQ9ilD19E419xFJCD5ifNlX1H6?=
 =?us-ascii?Q?RLv8JYOUQZ4Q9aL5CO2cFOEObn5fmRUgISJIaFUZxXD/SbOJcQ0oMxO2F6+I?=
 =?us-ascii?Q?diI39jdSDdqf3XNFDhyLphk+53F8DQ+O/mV3VxUbyAAoCEXY/l5q9AupehT7?=
 =?us-ascii?Q?KTs0kWELe/xaLPGtAfZzkYnFexdoci8Wjh9QMSYuH1f5z3yZyzTR29Mc5X75?=
 =?us-ascii?Q?HHrW9U0E7k9zLgXuu3HsqofdaV3H2hTpIxjtMEBLZdcmsYa9+4h9Imhtf3jk?=
 =?us-ascii?Q?hxipHlekfvD1qQ4JA3nazdLLdU+vGZLzqxexS0JWQ1quHlOTXKa7G61z+L70?=
 =?us-ascii?Q?rmxufhRTugAtTGLiBGvWilSncOk7gwGX2U/YmGmjTpd7Hj1jdiRloisM9q6R?=
 =?us-ascii?Q?45xeIDn1ajGx/AGtvo6dYbFPFgLr8hWdug7f7x38SSmZFk3jRkHTb3wZHWKR?=
 =?us-ascii?Q?LB8n5/xHCMPTsZxsP1MetjiSmk0zklgwQBO2z0BKTt69n/DOh0uI64w8MIhc?=
 =?us-ascii?Q?JS28OP/0NGMZmMHZVtbL/RcJUd5dXcfd/v2dspsKaRIcI0Qnr0PLGQX4a6f+?=
 =?us-ascii?Q?IA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3552b0cf-9f4e-480d-4eb3-08dab3b3c326
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 22:29:48.2806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7XkFmWI8+XKifTqB1TFwFZ3xG7nXqFnkvumZXZcaAKbY6XBzUqcbCQ0hTYQnqhJvI+Mn6IZ3Zpqx+BeWwq5FC0g3KKNuNL2BEsu585i9g64=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4433
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210210131
X-Proofpoint-ORIG-GUID: OlOukJKp1bRBk7k9rR4JlsWG5PMlo4Pi
X-Proofpoint-GUID: OlOukJKp1bRBk7k9rR4JlsWG5PMlo4Pi
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Return the directory offset information when adding an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_create,
xfs_symlink, xfs_link and xfs_rename.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_btree.h   | 1 +
 fs/xfs/libxfs/xfs_dir2.c       | 9 +++++++--
 fs/xfs/libxfs/xfs_dir2.h       | 2 +-
 fs/xfs/libxfs/xfs_dir2_block.c | 1 +
 fs/xfs/libxfs/xfs_dir2_leaf.c  | 2 ++
 fs/xfs/libxfs/xfs_dir2_node.c  | 2 ++
 fs/xfs/libxfs/xfs_dir2_sf.c    | 2 ++
 fs/xfs/xfs_inode.c             | 6 +++---
 fs/xfs/xfs_symlink.c           | 3 ++-
 9 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index a4b29827603f..90b86d00258f 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -81,6 +81,7 @@ typedef struct xfs_da_args {
 	int		rmtvaluelen2;	/* remote attr value length in bytes */
 	uint32_t	op_flags;	/* operation flags */
 	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
+	xfs_dir2_dataptr_t offset;	/* OUT: offset in directory */
 } xfs_da_args_t;
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 92bac3373f1f..69a6561c22cc 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -257,7 +257,8 @@ xfs_dir_createname(
 	struct xfs_inode	*dp,
 	const struct xfs_name	*name,
 	xfs_ino_t		inum,		/* new entry inode number */
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT entry's dir offset */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -312,6 +313,10 @@ xfs_dir_createname(
 		rval = xfs_dir2_node_addname(args);
 
 out_free:
+	/* return the location that this entry was place in the parent inode */
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
@@ -550,7 +555,7 @@ xfs_dir_canenter(
 	xfs_inode_t	*dp,
 	struct xfs_name	*name)		/* name of entry to add */
 {
-	return xfs_dir_createname(tp, dp, name, 0, 0);
+	return xfs_dir_createname(tp, dp, name, 0, 0, NULL);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index dd39f17dd9a9..d96954478696 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -40,7 +40,7 @@ extern int xfs_dir_init(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_inode *pdp);
 extern int xfs_dir_createname(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot, xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t *inum,
 				struct xfs_name *ci_name);
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 00f960a703b2..70aeab9d2a12 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -573,6 +573,7 @@ xfs_dir2_block_addname(
 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_byte_to_dataptr((char *)dep - (char *)hdr);
 	/*
 	 * Clean up the bestfree array and log the header, tail, and entry.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index cb9e950a911d..9ab520b66547 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -870,6 +870,8 @@ xfs_dir2_leaf_addname(
 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_db_off_to_dataptr(args->geo, use_block,
+						(char *)dep - (char *)hdr);
 	/*
 	 * Need to scan fix up the bestfree table.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 7a03aeb9f4c9..5a9513c036b8 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1974,6 +1974,8 @@ xfs_dir2_node_addname_int(
 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_db_off_to_dataptr(args->geo, dbno,
+						  (char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(args, dbp, dep);
 
 	/* Rescan the freespace and log the data block if needed. */
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 8cd37e6e9d38..44bc4ba3da8a 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -485,6 +485,7 @@ xfs_dir2_sf_addname_easy(
 	memcpy(sfep->name, args->name, sfep->namelen);
 	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
 	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+	args->offset = xfs_dir2_byte_to_dataptr(offset);
 
 	/*
 	 * Update the header and inode.
@@ -575,6 +576,7 @@ xfs_dir2_sf_addname_hard(
 	memcpy(sfep->name, args->name, sfep->namelen);
 	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
 	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+	args->offset = xfs_dir2_byte_to_dataptr(offset);
 	sfp->count++;
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
 		sfp->i8count++;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8b3aefd146a2..229bc126b7c8 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1038,7 +1038,7 @@ xfs_create(
 	unlock_dp_on_error = false;
 
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
-					resblks - XFS_IALLOC_SPACE_RES(mp));
+				   resblks - XFS_IALLOC_SPACE_RES(mp), NULL);
 	if (error) {
 		ASSERT(error != -ENOSPC);
 		goto out_trans_cancel;
@@ -1262,7 +1262,7 @@ xfs_link(
 	}
 
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-				   resblks);
+				   resblks, NULL);
 	if (error)
 		goto error_return;
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
@@ -2998,7 +2998,7 @@ xfs_rename(
 		 * to account for the ".." reference from the new entry.
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
-					   src_ip->i_ino, spaceres);
+					   src_ip->i_ino, spaceres, NULL);
 		if (error)
 			goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index d8e120913036..27a7d7c57015 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -314,7 +314,8 @@ xfs_symlink(
 	/*
 	 * Create the directory entry for the symlink.
 	 */
-	error = xfs_dir_createname(tp, dp, link_name, ip->i_ino, resblks);
+	error = xfs_dir_createname(tp, dp, link_name,
+			ip->i_ino, resblks, NULL);
 	if (error)
 		goto out_trans_cancel;
 	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-- 
2.25.1

