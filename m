Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77CAEC25B08
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 19:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239066AbiHDTkh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 15:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239031AbiHDTk3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 15:40:29 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA851BC25
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 12:40:27 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 274HbVdG001427
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=LUZkL35OSOOKzsUX1V7Tkl0+WtsSIHmQwtm1icpP/n0=;
 b=bIstuFmUO+hL7TUax8Kh6XmMKuXl4OE5pKQs5OYqCXhzXAt+dx0N0ij5SySC6K4hy6pR
 CCloXUh7w/xdPqrn5ONdOidzwpA/9+DGamHVIW5BMJSkzMIpnJ820n3uoj5zbjvmQnpi
 oRpU8CbOeyFYw7YXXHjcD7Oy1dnscEjbsZ5eKHQosSxxrnFeDxYden3ll4pWKOfyqXIi
 RB0xIZ46RslK2JVY3iIH0hAW0Nd+A9axe3PjeeRoEtcLK7tlypYlUBWO3cwbASHh2/QE
 vYnBxXkifT1A3sYigjYBNjlzZkf5b26IifoiDOVg7PXl7KgzO3A/JET84ZtdtycVaCJX 5w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmue2x31c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:27 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 274IH90g007562
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:26 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu34b93d-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V013/rGXIGnzGhMrgNqlZkyZ+QhNq1YNbGTAllJXOK3KnvTcgJP23A1gc9ZB4vXj6fj0BWao8i+TcwXYM6JIEb9GLBXk/pxctDZUlgPpkF7884giGCeM167tpMjzXENSaf9+b60bDK57CaB0jUjFFXkyPSKkXo0lJi6LBVeFrt4awKbkyKqhpnoWPiSyX6ElQHLqI/uL2EEdpuWu1gMSj4VBl/5fWytYGtzC+e1FxmovZvxrnjV8KX4J4jVv5dIW7CjkihYgCAHCwjDn36UDhGeTesCt64YlfsIloDM8b5koSj4Je5+0NwzzhTCXDfWEjxlkEJ3wIJNZ7rwli5m0mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LUZkL35OSOOKzsUX1V7Tkl0+WtsSIHmQwtm1icpP/n0=;
 b=ewRJbhPrfHA+uibjCs64Bm5c7swE25StWx6F4zoOmPiX5GTvMzxoP3nY4ngeCvTIuJaqav8D/Zn2RyC0cXNgoXPiHsyr4L6J/zpLPxDoGmZK75dqAm6mXCS+O9A3kA7yyXNtk7R8McRciiGxZ8b7JAzPeuM8IFfDKHAGw0GK+dQHWAlb/OVbYKM3NV+oXumHUYe7sdOV7uqOM7TZt8ugJF3p6pzGwf3WHsTkJxLufrkl0eklsq0PaML0wuB6I4KC0o4EnTtbwZnKMqSqsvz1KYc1rfyqMMrVwEHhwSuyukFueCWIGutVTQ9Hn5R0jpg+LAClgrMaQvIlzNxn6w2h2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LUZkL35OSOOKzsUX1V7Tkl0+WtsSIHmQwtm1icpP/n0=;
 b=pUlmW04kgGam+/I2b5EIcM6GAO2MHBEQwINe9HHQNbBA+TGjWI14dfHvsb61+XTxfD7swGcOLXTrbMCK+pvbf4IwPQwM7ToYkO8Q2unol71WBMlSxHYECjSnYmDB3l8X6lU285hiis/JgyAoPihR7YDLFg57zACasCs3I/9REFM=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5040.namprd10.prod.outlook.com (2603:10b6:5:3b0::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 19:40:24 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5504.016; Thu, 4 Aug 2022
 19:40:24 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RESEND v2 06/18] xfs: get directory offset when removing directory name
Date:   Thu,  4 Aug 2022 12:40:01 -0700
Message-Id: <20220804194013.99237-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220804194013.99237-1-allison.henderson@oracle.com>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0198.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::23) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 343a44ac-b5d3-4968-2e4f-08da76512bf3
X-MS-TrafficTypeDiagnostic: DS7PR10MB5040:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KJRwasI/tKq3iJ7LFSkLjAYzLRp3qfWsPy6V/Ac10U1xEJKPho6YNVS7deHGLLu85gBtemATA7AT4vCBUbxqrQki2ucMk5x9s0ytLz8WkyF3BWZQW/wyT1jCmKAGi9IkiYVeci2hvOXdZiBITal/WWdHP2VYqNG+hCptKgft+mQpeLjb6Y5q415atTc3UDMeSMRHlMziPgGWmRbv9vESAv25/MPTJyIHRjCIId3WBHsnA0fs3tcQzIOBSvNHhNJxCCF1KKKY4ZpIm6hJDrwN1D52oLZxevbeXB72aTtq7+1+IqT/1vBdeaBAfrODeSNqqwZer/H1z+Q7sCyQukar6rt+8amB3T7Apf5NoujjdPv7sGqmoYH6rTNQHarL/Z+hr3Nv+w7NKIZ9m1BO7cfR4yxfwkXqZZbxuWOqngBXy6uIa22lzYVErduOlLHyqcZR8l43YFIGXOqQZxbHswZ0f5+G7116I/eQ/ymnirUPDANv2tDVKrHAbdrVE0MaOHazjXmXJHt7hEZjRI+KXc7Wu3hwTZjHCq8k4iMoR0RtbLfi0bgCZ/p6RezK/kLdFWAhl/2Qp2BnNSgqxr++KSG1klD5jTCK6ruJPXGc7Argi7btcPZR6jQE30cF8O5UQ3Y/qFBgcF6pGyzXpJq3R/W+RSpnC/o8D1r019YhED8hdoli1im3pcVFL/bNhJ67CsXwEtHkilYYU1riFh5iDCBFCWJdM8p4kcxTwPcnlzANxiJNGe+I5Du/ly52iUhhNEbbmNhXFg1a4IJOFfDRbw5Z7osSUAZD7YSQbedTZ11Ufbg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(376002)(136003)(39860400002)(346002)(396003)(41300700001)(6486002)(36756003)(2616005)(6666004)(2906002)(83380400001)(478600001)(316002)(1076003)(52116002)(66556008)(66946007)(26005)(6916009)(6512007)(66476007)(6506007)(8676002)(86362001)(8936002)(186003)(38350700002)(38100700002)(5660300002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j2zLo6iXzJdJEUpYFVB6JaV9ff1XviRR5pm8Bly24+tixM7Jqp6Q04nQXbEd?=
 =?us-ascii?Q?Jxgi20ncwY/yoToQzBuSvQiALd9IFACtAVAqzy9eEhkJZQByC1ZiEu3Zqbkn?=
 =?us-ascii?Q?Fuv/iT+3JKROXH1AVKyGaLl3QhMmnx1wwpAJaUgyxWln/Ly3uEX9borxyyxL?=
 =?us-ascii?Q?wYKDgSr6BFy9iKJ/YUB8MWgo0wKDvP081KEHW7wvo4wFwfPuTr39RI0+kaE4?=
 =?us-ascii?Q?zSAjnHPO5jkbKbJ4iQOFRi6sV/Mr+NSn5+jp28OwFOvXz7vExCTEOxX0ic5c?=
 =?us-ascii?Q?26XTFKbMFpRTNtwtR0XRxuLkJVK3SoIpMnodva2fCXb2ImijjgWGobIvYQQq?=
 =?us-ascii?Q?60HZMb2Xz8c7ObHDw+WuNJeBYRGtEilCPhUzRCIPJSvVfWT/q+ZnTZKdUC8h?=
 =?us-ascii?Q?Py73RO19UROEpq9knkS0IsVZ95eLpZkGwN0XV004EhxyGb7tuOdso7BM6IyB?=
 =?us-ascii?Q?XGmJTWDZHmbLMO7iyfZw9m1BzJhnPvt10YIUD62+biEVgqL5ZORjWPNr++8d?=
 =?us-ascii?Q?p5CTBC1Dhi0C9DgGHWH35iYegQkgpHvvvcp6iNpzQpIFHlRYILNdN7SuiGii?=
 =?us-ascii?Q?HgmwqRLv1rhFiGBwHZeXSOhfYZtE3xLJ4d03QxZAYOwLor1ZyfO384ikwQvf?=
 =?us-ascii?Q?6iqdxAyNHAu3+dplZ1lZjzgk1Cjje9X/q8OdjOr83A1OrzIDQQAEEGNLQ8HM?=
 =?us-ascii?Q?xQ1DGbcPGXXkS2ZRso37dCBTBG5YjjxOJWW6evsHBbXuTYv4EfHMPtIxhXoH?=
 =?us-ascii?Q?XsAv89U9cMElfS/lEaXBt03MLEqEbPUq/Bd+gtH/NjH+bL9x3lSszG/SSnzV?=
 =?us-ascii?Q?A48+GGp+KcbwzpdNStsbcSOnTAO4D3YRuFfi4qLboKCf+Gp71x5eac9SCIKs?=
 =?us-ascii?Q?290DeTKIqSm0to0f0tc4rhHK9B9bAW7ZNmDHTQDDFSGZkyiivG6PB6etHXZd?=
 =?us-ascii?Q?cnaFsdi8Upc/Supp6QTgJNh2P6/K/6Z/Jb53GwhDbj6l3Kuctvm71pHMS0Je?=
 =?us-ascii?Q?1VTT1jLpH4p46Z/NGj9Ge0GL/kH13hzN9okijvRhQWR3jq5mnQVOjsywBpwr?=
 =?us-ascii?Q?iLosq75aQD0Xg0L23yK0tcgs3LqBWALuGGL9AUVdQnXpBVpEUiGV70wtLTjH?=
 =?us-ascii?Q?ln9SVFLDEsMYlJNII3Hd+32ym2LrkAD1tUtuo9/iTYw/Exkk63m9y2i2Xou5?=
 =?us-ascii?Q?SxQ6s7ZXxwTFptlTl7V95b+JG1taCPqXFtT4l0YxtwIJsOL318CmxBg0jT7G?=
 =?us-ascii?Q?8s87kDmbD+/Yjwvon7kc7Z3G+1NlHh45SyHH3E2lfLe0WlanzqnBjZw9OPpD?=
 =?us-ascii?Q?2MiHOcSp3DO/BlXZD4lb9p7sEnRNERk3v17ENIZh7eBux+LgNc97v+s/p4mN?=
 =?us-ascii?Q?cmRMgiSeorP8lHUZQ7CfUkiUbckoGgIerBzh9qL69xTKn/1ZIheO+zh+OE8r?=
 =?us-ascii?Q?fpu6Jc15gaR+P3zeQM8Y/Fht/pIdTJX00ZukbzXLnW9utxE4QEM9p1qlv2lG?=
 =?us-ascii?Q?gqnZMxtzOjr9D6HRi3Y8S8lMgzqJvF9K7OoBhd3eP0BnMsU8tALGpa8MjHfU?=
 =?us-ascii?Q?cRBco/C3xwYMu1w8Yb3Su0qzJZZ2BH7E+TjaCMrloDklYt7tRJl4Z2Nyi6go?=
 =?us-ascii?Q?rg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 343a44ac-b5d3-4968-2e4f-08da76512bf3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 19:40:22.9538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7W9hVoCweG4O1hN5zHXEHzLAmJXP10cC2zDHdiHuEIw+wMsVJmQ9B6D1M1CGoJMyVoHu6X5ajGOuWvGG6SLIBRBcBMHRj/wTUk/bJ5GrNw4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5040
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208040085
X-Proofpoint-ORIG-GUID: k13yMUTTdtVan6RSu8b9wYdi042eDl-f
X-Proofpoint-GUID: k13yMUTTdtVan6RSu8b9wYdi042eDl-f
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Return the directory offset information when removing an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_remove.

[dchinner: forward ported and cleaned up]
[achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
           Changed typedefs to raw struct types]

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.c       | 6 +++++-
 fs/xfs/libxfs/xfs_dir2.h       | 3 ++-
 fs/xfs/libxfs/xfs_dir2_block.c | 4 ++--
 fs/xfs/libxfs/xfs_dir2_leaf.c  | 5 +++--
 fs/xfs/libxfs/xfs_dir2_node.c  | 5 +++--
 fs/xfs/libxfs/xfs_dir2_sf.c    | 2 ++
 fs/xfs/xfs_inode.c             | 4 ++--
 7 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index c0629c2cdecc..e62ec568f42d 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -436,7 +436,8 @@ xfs_dir_removename(
 	struct xfs_inode	*dp,
 	struct xfs_name		*name,
 	xfs_ino_t		ino,
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -481,6 +482,9 @@ xfs_dir_removename(
 	else
 		rval = xfs_dir2_node_removename(args);
 out_free:
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 4d1c2570b833..c581d3b19bc6 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -46,7 +46,8 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *ci_name);
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot,
+				xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
 				xfs_extlen_t tot);
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 70aeab9d2a12..d36f3f1491da 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -810,9 +810,9 @@ xfs_dir2_block_removename(
 	/*
 	 * Point to the data entry using the leaf entry.
 	 */
+	args->offset = be32_to_cpu(blp[ent].address);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-			xfs_dir2_dataptr_to_off(args->geo,
-						be32_to_cpu(blp[ent].address)));
+			xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	/*
 	 * Mark the data entry's space free.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index bd0c2f963545..c13763c16095 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1381,9 +1381,10 @@ xfs_dir2_leaf_removename(
 	 * Point to the leaf entry, use that to point to the data entry.
 	 */
 	lep = &leafhdr.ents[index];
-	db = xfs_dir2_dataptr_to_db(geo, be32_to_cpu(lep->address));
+	args->offset = be32_to_cpu(lep->address);
+	db = xfs_dir2_dataptr_to_db(args->geo, args->offset);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-		xfs_dir2_dataptr_to_off(geo, be32_to_cpu(lep->address)));
+		xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	needscan = needlog = 0;
 	oldbest = be16_to_cpu(bf[0].length);
 	ltp = xfs_dir2_leaf_tail_p(geo, leaf);
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 5a9513c036b8..39cbdeafa0f6 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1296,9 +1296,10 @@ xfs_dir2_leafn_remove(
 	/*
 	 * Extract the data block and offset from the entry.
 	 */
-	db = xfs_dir2_dataptr_to_db(geo, be32_to_cpu(lep->address));
+	args->offset = be32_to_cpu(lep->address);
+	db = xfs_dir2_dataptr_to_db(args->geo, args->offset);
 	ASSERT(dblk->blkno == db);
-	off = xfs_dir2_dataptr_to_off(geo, be32_to_cpu(lep->address));
+	off = xfs_dir2_dataptr_to_off(args->geo, args->offset);
 	ASSERT(dblk->index == off);
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 541235b37d69..2dc1d8d52228 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -971,6 +971,8 @@ xfs_dir2_sf_removename(
 								XFS_CMP_EXACT) {
 			ASSERT(xfs_dir2_sf_get_ino(mp, sfp, sfep) ==
 			       args->inumber);
+			args->offset = xfs_dir2_byte_to_dataptr(
+						xfs_dir2_sf_get_offset(sfep));
 			break;
 		}
 	}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 08550f579551..ce888f844053 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2506,7 +2506,7 @@ xfs_remove(
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks);
+	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, NULL);
 	if (error) {
 		ASSERT(error != -ENOENT);
 		goto out_trans_cancel;
@@ -3080,7 +3080,7 @@ xfs_rename(
 					spaceres);
 	else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
-					   spaceres);
+					   spaceres, NULL);
 
 	if (error)
 		goto out_trans_cancel;
-- 
2.25.1

