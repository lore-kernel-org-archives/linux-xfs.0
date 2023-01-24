Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87880C54E94
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 01:36:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbjAXBgq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbjAXBgp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2023 20:36:45 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 251E31ABCC
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 17:36:45 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O04fTx022007
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=hVjRnCfspL4P7YZo4v7somjYUjK7m/v7/aZdoU4F3ps=;
 b=vO3eBIywM1oIe03wMMaUwejUpyKBO4TaniArZTGOtN3cobfmZfbFfnjea1CwB1DG8vXa
 WQPFH8Mw6V4On5Pn9SAgtZhGcPrxf1GTxnJBMkbvY5qjoa3Iamd423lt03yWz0Qc4wnD
 JZn/3qNC0l8w1rHAoFHadQavcx6qqfZxtuCfIdvnIX6+5axVyRjB4tdy89oyeEb2tyUY
 Il6sb72xjYFfzu9b1LWWNcMe4140fKRbGfSM94j4BGOFQJqKqa/fvFexILKzByQPS7xk
 ReBMkxndcfddFPjBPQ8gjiVvBzdC2CnA4R/ciRbCqR58ewiQRNRm84adDOW5U3VtdVfj Cw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n88ktv8cv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:44 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30O1XqUf040224
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:43 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g4a82q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bgF6FShOWeaoiFVnj12gClODQWffl9ErU0yBcWLDLOlF+5vmW1+9QDUMwsEOskBGK1gFp+622CZJD9wlEDry2R8yq/oyIsXxsbym/WHKSSKPcEOTyGAXcW+CtPWDdqQFmp6EynWJmBe95X+Rl4ChR7Dw4+lv+uHsUvj46IQDG1T4JQvwooQygzKhGzlkO0nj9QLhBHbBjrkK7sUx8OdEue+7HfhzbcUT2t3o3c2Vmdlgz9A5L/d2gEnVw4yZ5fj15M78isUHosuXzMcd8RAdP58jm1PZ5O6G00Fu6MxfSJsumXX4hlDNfsg7i5h6ZtYtkOEGjcX8VAUI8mTKvlRh9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hVjRnCfspL4P7YZo4v7somjYUjK7m/v7/aZdoU4F3ps=;
 b=MYqVOk4OQyURlX54Y2nOyO//0SRt4vlqjFtJeoV6HrILUjUrjiFW/Ez3p9w/yBJy2qJJVdehxOdfiWCsKED4QUhcXW7xbopzS5xjU7K7vDjeXrW5VfF1TVcgsXDyzNx+3sQ/bw/YN8i+ofl2fZg2fCeo0nTTGKa/0n0+ATUzUlcj5x1GdaMHsD0xc50JlN0AXftL60T3gT2XdEjWIL+CseOumko+k6+/EMTKuMDTESRB6UIRgc2F+k9ImPMPSQB1+Lc8kIPgwx3COZg2x0QWPuiXpGPq1x0JesbXQHg6qHeqRaDFbd3+lcqA4zaBORtx86WLTp/4daltduxDKyjsEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hVjRnCfspL4P7YZo4v7somjYUjK7m/v7/aZdoU4F3ps=;
 b=aHECNxwOX4tF7s1T3wo9YpB/E0rOCI4chROFifaFtVAtitti9lGcq6r4cBEREHJD+WocFwpFvWVnZykfD/w8LJ6B+FILJuKOHzjmR5HyaLCi4Ojq0tSsxjzrOitzPi+Vj7Hrff4rtuBcJ6NVeN/gdVZ2rQSD7hlNCosDRUghlbM=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN7PR10MB7074.namprd10.prod.outlook.com (2603:10b6:806:34c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.8; Tue, 24 Jan
 2023 01:36:42 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 01:36:41 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 11/27] xfs: add parent pointer support to attribute code
Date:   Mon, 23 Jan 2023 18:36:04 -0700
Message-Id: <20230124013620.1089319-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124013620.1089319-1-allison.henderson@oracle.com>
References: <20230124013620.1089319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0013.namprd04.prod.outlook.com
 (2603:10b6:a03:40::26) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SN7PR10MB7074:EE_
X-MS-Office365-Filtering-Correlation-Id: 011794bf-6f5e-4983-2ee9-08dafdab71a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bb7inHkjudLKsadOALf47RXsk28G+LfF2FV/qumX3ZgjNPWveKl50EvSD505rNeoQPixyiTgAy01wxfLgV506AP5JWft6rcdlH2y/mwYXjbyu1xZ56fuVIRG+3Fwr6RJ1WsiSbXaEWXgTFqShCg8KyDQrHcP62IHmrATbtQeziyUm88b+8EbuIfFf1OcqCer8+VnoGq4M3gXZeq9+sP7/o1NTsDiKEjhSuWgQUS4Tg5frXBg4OUI5eBCOuj07E+5a0Gxawiq30zvyGlrCIopRXSm2XQYSEIQfs0jucIgmkL1aZ/nirXUGxFvbIDYVsWSx31X+4rCu+6h6Bp7b7OtbAyv8QNlsj9dEDPgADd74/IdYXIKKKlB4NCzO22Cy54dEWxBegGEsxNQnFsveG2ADqr5BHLc6+b2TszulJ8VO8XKLVD674i/q/InMBGVuJ7VCQmOwjJCOQp7/V6ixfao9TYdPWEutdJ0yCP53LWGtE/f4ezbtVMx0YeEX0lkb8uXS2PMftwqI/zzZrLK9XgeezbDIGkYZGzWPxxsZsPgAZZD2vJOMn/h2BeXMIfZ3FQYqHI58b5w8tsbEX9dwxEF3diPNjf4fWtt5dOjBHUhxZOgYJddfSQB9Uv3tiTbFGBRmhs0UEh+vzgDRQsRcoCMgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(346002)(366004)(39860400002)(451199015)(66556008)(66476007)(83380400001)(6916009)(8676002)(66946007)(41300700001)(86362001)(36756003)(1076003)(316002)(2616005)(2906002)(38100700002)(5660300002)(8936002)(6512007)(6486002)(26005)(9686003)(186003)(478600001)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xbnl3ojEhQr8eeEylpeK+aolSTxJIL3J3kaRhx8RcLJrauJDFboBkhlMjVyE?=
 =?us-ascii?Q?NkDqo01p1CGvjjbwUWmUmDxhduq6rCDN+/EL7OkZFViJMEKCbTUU+dV865EO?=
 =?us-ascii?Q?B+zTU5h6P2Z0KLQtn4PcBhIEoZDRZpqSu3vLREdLAsoMmwpfubGtMW+XjRXO?=
 =?us-ascii?Q?uydIJNCbf6JZVJ01XRuEv0zdsKB+4LYhQvEVkXvZse2oqnpb3k6jTF8dretJ?=
 =?us-ascii?Q?I6S6vnVksdiftBAD0q4ANQ8Of/J6Ea8aD5hUEUBMvifCk14UAOCpUjA/X4HC?=
 =?us-ascii?Q?qt9GFaVe1mQCmkrAQ+WyclFC0CHGNiD6Jm/Cae62tgdVI6xplB732ldp9XxK?=
 =?us-ascii?Q?0MLkjnMK7/yl1h3JTxG4AHyFJEwNNHc1honcEW7+Th17V++/XtUcg8DH+7Lq?=
 =?us-ascii?Q?5HZa1uIRx5y3gnIoC2BjSwrNMcEH9vgc3VK+XBUiP9hKdrF1ZOjPcl1N2Whx?=
 =?us-ascii?Q?r1bgYWhE3odO+4zFK+2pPXdUnd8yF5A4PrkimhFggeQ4nPtrgfLPIG/8wLdv?=
 =?us-ascii?Q?5AX6Axo+HUi/AO1ZOSBB6u/eC51/pGmQfgcDs5ssFMu0AbpqZ3PQHzkYtI0z?=
 =?us-ascii?Q?/5fli21bTyBJwRTe0VyrO1OuaQxETDIoRH4nCWTXBviSHkwq729+Gw7zCBR6?=
 =?us-ascii?Q?ll9yEAPOZ8UYNnfBVa8pbTDy6AHRlNyPB2G35kHJjUbJPo3xUP1j9ZgasSrD?=
 =?us-ascii?Q?uWryili08hKquYak2p14HcPQ9AuCNn/+JL0ub+B3/tw/uYyrudrv+O5DSH9g?=
 =?us-ascii?Q?AF1+XzBT925FtgbjEQHiXfUj9LlBGeoh/FbbeDLboCZlDespfhBDjBS4FteB?=
 =?us-ascii?Q?o6Ao1W3KUj7oiAPd+9L0cf/k+tz0HbGDmwTLW4W30Z1KkGvBTiqCyi7/yoqQ?=
 =?us-ascii?Q?gDuoVJmp90UHwGqbPEc65pseUJBEfqO2QSAG+xIx1JnrgPUlf3T56w7lSvwN?=
 =?us-ascii?Q?ihw3h4fNA5cysvsXoN8JNfEWW5fK05ZGZ5vDOuPNGbKc1IuREgIkoDCjQHq1?=
 =?us-ascii?Q?Qvw6+pNb7ExSSKMxxvQdEH/Yp5YvFcRJaEGbYkV802Gop+5NjI0sCuhW3hrW?=
 =?us-ascii?Q?zbk/zNKt5B7CNnCKjwNJu7/AsDK4x10js2q2V1Q/fepvNkrrpgEff/yKj06q?=
 =?us-ascii?Q?e0xC74yZGKY1rWKu2UOCYDe6ZGk20YmyQ/rga9ehVJHWCDLVnxnt0B2i7yH/?=
 =?us-ascii?Q?v4VJgDNTvyA7LyNET/BVkUnj773TmarVc8gAWDQ7hgCxsBCv81LreZ6SJUCl?=
 =?us-ascii?Q?vO1XfCASiT6PAq8ltOevnROwVeK/0UT+tuiqT2B1C/qMke2MEMysQVkZTThM?=
 =?us-ascii?Q?ciq2ptoqqlnzWh3Xsg1P2kEj4K+wbXQ6Fp3XEbGVQfPLp/V7J41di1+0cO6x?=
 =?us-ascii?Q?LApF2brhOQKRj1QnATj+smqqjKRg3faxpTCaVmDspCOSBjMWp37SmIT9sY/N?=
 =?us-ascii?Q?wmbrmt7kzVynSDukbDQ1WitLr9FAIAkdNpAXQc9jMwAxVhHD+wjmXP2oOpy8?=
 =?us-ascii?Q?XVYOLlY7vY+sBxg3P5himev6B8+O9k6p52N6LjlCnxOh7H5f5Run3H+BsBJX?=
 =?us-ascii?Q?GV3ChdkXDUH+yLEVxsQ9N/MQbOw4l5YaGztf6j0Gqsq0QcKLgWwEZxmW9Hwh?=
 =?us-ascii?Q?Pg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: jGj3czvH4p7V7uqv00TzS9HxIxoII48j/FthXakrCAOxfhrz1VJm035qt4v00vAuu9cfHs2u4qY+nzCnJZs9ejChyxnA/cULB+hNiQqYCnZa5S5A1dbTHoqZqs+BfC9Wwns4uQtFGzmE5reTvGVLPYLCGx2EVBWb9a2Hj6ohhr8JLWuz9zSNNXrvJ10/JNhqBrgmsjwKbsuptuRpmfDGthV3v5u5TzJbmgLDp+zCR7eLddG2Ax2GvXRnVknC5DJbslymRw8DQeHsC4U6oZNyI3iTz5jCS7oWE0rK2fsO+gNAxbht9x01YelC5844aWZZXGLpav3vjbbwRoevbPz2qlDCoOFlMo5ohin37bRmUApaguXjfTXuzFjRGWM7AJi+CNo9xdDwfFh5AfHlLbXnSlSBn+2+bjjulph6G4qhNOhGEQtc4Q9hwgoiAHznkvm1u92yP0RClQzlyLTw3Y1HePuXgYpK+ej+5y0jqVsWjKJuVjPsGN0K0OYPSKlOeILBlmUu4xpuMalppCzjFIH9A/7yAwWuoxXFgBcRoGZ2BzWF/dH/8tACpb7m+0sX3RNpAZ37vFFIRNaYGeA5kxdLqkN0fXCR/uP/9fu3O02wm18oZpiFcU+u7cinMNa89AupfDgxkB2qnPbWQsxnVs4oERbZgE8oeO5ISZ44vu6boJ8tOFWGg6bBfsm4fj1ZD0pqeMR+rYMXW8ozYrEcCYYdWAS9aQbEpJbeynyfy2q3xYsaEQtzgz3fSBi2jQkdDIlTA63f+ZPMepo+gJysrsT0rg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 011794bf-6f5e-4983-2ee9-08dafdab71a2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:36:41.5441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GNhFcpR6y2fsnP1+NMuAd6FGekkc0lmv3IvXMK1g10AFMzee239YZAnxFMCzDbEx0d7twG+O4Tb35NNJKBHVkJ088IyXW6GjdxYjrwif7Pk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7074
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240010
X-Proofpoint-GUID: 3I0i_4Q2l3EacaPmO1HX9xHlUWE7em19
X-Proofpoint-ORIG-GUID: 3I0i_4Q2l3EacaPmO1HX9xHlUWE7em19
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Add the new parent attribute type. XFS_ATTR_PARENT is used only for parent pointer
entries; it uses reserved blocks like XFS_ATTR_ROOT.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c       | 4 +++-
 fs/xfs/libxfs/xfs_da_format.h  | 5 ++++-
 fs/xfs/libxfs/xfs_log_format.h | 1 +
 fs/xfs/scrub/attr.c            | 2 +-
 4 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index b1dbed7655e8..101823772bf9 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -976,11 +976,13 @@ xfs_attr_set(
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_trans_res	tres;
-	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
+	bool			rsvd;
 	int			error, local;
 	int			rmt_blks = 0;
 	unsigned int		total;
 
+	rsvd = (args->attr_filter & (XFS_ATTR_ROOT | XFS_ATTR_PARENT)) != 0;
+
 	if (xfs_is_shutdown(dp->i_mount))
 		return -EIO;
 
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 25e2841084e1..3dc03968bba6 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -688,12 +688,15 @@ struct xfs_attr3_leafblock {
 #define	XFS_ATTR_LOCAL_BIT	0	/* attr is stored locally */
 #define	XFS_ATTR_ROOT_BIT	1	/* limit access to trusted attrs */
 #define	XFS_ATTR_SECURE_BIT	2	/* limit access to secure attrs */
+#define	XFS_ATTR_PARENT_BIT	3	/* parent pointer attrs */
 #define	XFS_ATTR_INCOMPLETE_BIT	7	/* attr in middle of create/delete */
 #define XFS_ATTR_LOCAL		(1u << XFS_ATTR_LOCAL_BIT)
 #define XFS_ATTR_ROOT		(1u << XFS_ATTR_ROOT_BIT)
 #define XFS_ATTR_SECURE		(1u << XFS_ATTR_SECURE_BIT)
+#define XFS_ATTR_PARENT		(1u << XFS_ATTR_PARENT_BIT)
 #define XFS_ATTR_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
-#define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | XFS_ATTR_SECURE)
+#define XFS_ATTR_NSP_ONDISK_MASK \
+			(XFS_ATTR_ROOT | XFS_ATTR_SECURE | XFS_ATTR_PARENT)
 
 /*
  * Alignment for namelist and valuelist entries (since they are mixed
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index ae9c99762a24..727b5a858028 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -967,6 +967,7 @@ struct xfs_icreate_log {
  */
 #define XFS_ATTRI_FILTER_MASK		(XFS_ATTR_ROOT | \
 					 XFS_ATTR_SECURE | \
+					 XFS_ATTR_PARENT | \
 					 XFS_ATTR_INCOMPLETE)
 
 /*
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 31529b9bf389..9d2e33743ecd 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -441,7 +441,7 @@ xchk_xattr_rec(
 	/* Retrieve the entry and check it. */
 	hash = be32_to_cpu(ent->hashval);
 	badflags = ~(XFS_ATTR_LOCAL | XFS_ATTR_ROOT | XFS_ATTR_SECURE |
-			XFS_ATTR_INCOMPLETE);
+			XFS_ATTR_INCOMPLETE | XFS_ATTR_PARENT);
 	if ((ent->flags & badflags) != 0)
 		xchk_da_set_corrupt(ds, level);
 	if (ent->flags & XFS_ATTR_LOCAL) {
-- 
2.25.1

