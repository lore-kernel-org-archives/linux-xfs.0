Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B357C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 21:14:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237170AbiK2VOF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:14:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237096AbiK2VNq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 16:13:46 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A181D70DD3
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:13:19 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATIeNn3017341
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=W+yVskg13AorN131NKamX471n6FjxBgty+wbQSFjcp8=;
 b=pPpJGVg8yM8n3Jv2RMDzK4+eRvb2+EwDPmLNxnbyvdXvjBcOcpcZgKu9NwxjflwO8aLi
 TlynMNW38yTPh7MS1xbX6MeIgTRgpMEM5A5o6DbOm+k6qLpq1RU5QLQp6kUBe9zzFv6h
 MLI50OQ5J2f4rblQe2Ua7FF0T/yx42DYuOlA/j2eCejDLK352v/JgNvmNNLOn6HgINVW
 cjog2a2cV3jH3STIihoYeAgT4Qfh/mShEt/CiHtjbsVIXH7wc9Uqxa1+/TwAMFLSya7P
 xbuftubHqwSQ3Wy/t2E4yyqnvdU4m5SKQSNPhjy+GuiuymQG/M+CrAgPwZGNiQvYKK3z gg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m3xht7c7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:19 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ATKUnBa027897
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:18 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m4a2hj1g8-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JYtzh+qvJ7bUUeAKC92WyY8F3FLp+/b4NLxzobTOO+5KS8SXHURaQAr9YwM5OGPNKpZV65gCw22sinugNi5xVsKTjDpBJutrOXEzaOP0afjcbiln2SQsYpr6wZ4NaeCBxP5gc81EUtF1FA8ODlXo8Q99lK4APgrKpm6oo4QIued9re2ntI252gjfG3DUxmqNE1siFyoTTAq/HYTAjtErvu1XPVefejAuXi0Nw9dKmplP7tPfFUjwtlIO11wBI9qijBG2j0TD4NtkLBdqm4Ti5pedEWrw9HyJtI3wzws1wUo8YMCe1OJwbBdSGYrDASyB1AvdyS1iHv17LpbduFRoQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W+yVskg13AorN131NKamX471n6FjxBgty+wbQSFjcp8=;
 b=gw/UpxxGy1b3MwAxFojLKsYTmPQCRqVLjPicWnNJnD1afs1PfGwlLRGqgbdhRhHOSAg3DWwd5T9D2SBuobbdfHuektcpB8PE1d1Z7GYcISDG42tnU1oG3kHFbX6x6015DBHv7tjxxtNd6/rRgHBRhuHUj2p/7v5OJWNHhFmnzfrlJzmcocYQEgmezsjkAWYLTgQp/bJhLNTAEv/139QUHdqeqhzJZHqAWNCtSp3Fvtp4JmIwsIuDRpWPNUsqzKPNL329o41gO6+a8Obk6GsRssH+40sJtC8s8KdHTljAPDoYKl7ZH7vvTnZue2l5IX5bOOd5ec+0olsUKc4zlMfbOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W+yVskg13AorN131NKamX471n6FjxBgty+wbQSFjcp8=;
 b=fTADRqppXPuoXn13bFs5CnMGGFqihFVl+UDR0xxkeY4/6rRIKXgiiN0PaTPf/BfhjThl+6d/4TPp4JhVCja+bOOfYJixEjPA4ZPmwy5C5PyfBHqVIj9vGSKWHWtsSWCC9OQYoOYgKMCTLIdPBLI1pgOABmPS1iYaq+oU973BwQ0=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 21:13:11 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 21:13:11 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 17/27] xfs: add parent attributes to symlink
Date:   Tue, 29 Nov 2022 14:12:32 -0700
Message-Id: <20221129211242.2689855-18-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129211242.2689855-1-allison.henderson@oracle.com>
References: <20221129211242.2689855-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0244.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::9) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4456:EE_
X-MS-Office365-Filtering-Correlation-Id: 6840c20d-a284-4459-9092-08dad24e8578
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1O3fJRmtoiCinvqsJ9Q1BduIbhr5ArWWjuN6wt4Es8s94dTmcKwCY/Do7DyNjX2ZhzW2rWgBJp5DN1W4XAtzCAaQe6FIx08A4IGxnDWPWfhdEC3XHiWaeHYl4Uga5nrYtKa7Bq38Qn/QFcsleCb7uZsufHc0nQKBH1D5kpG5IPqiJcpPGvgx5cXxsxI2BfF3fvzQZ5Y1kDhCWInUgvlxGN6yRYWSR7jFVvUf+8Gw4D3/Acsi1C3n/tbPeiaVo/6whzJB/2LqRagr5iIERsEA/FYkqnZ1zW2JB/TAnigWvvr+5JIT3P3f4vkvhpCPe3TTwJv4xzQMt1nCj62dmmwkasiNIUzdg6aPksnonGZrbBVn+PLxmV7kQfaQFjmDO1XdDsjpxhmZIXxjXkKbZYeuasGVNZdbKu2cdwg/PmxH/GWZ0GMtapkRetHGgBkzlOG4dUBHUsiAL4lCVyaYVaWAx9SKJSZaohlLnhGDa3rmGEbF+nXpg5jNU+611xrC/I3b854hEsX5ch4YtpRNuYlAb4UFBnm31fO47iGBp7NsKuQAaWxJxRMXDK173fPf6DhEiP8Mwqkx81Zfa62hfw0Ix9gwIzS1H6MG167i0qOoc8a1upXcxxeeeV7Stql6r3Si
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(396003)(366004)(39860400002)(451199015)(8676002)(2906002)(36756003)(86362001)(66556008)(5660300002)(41300700001)(8936002)(6506007)(66476007)(6666004)(83380400001)(6512007)(26005)(1076003)(9686003)(186003)(2616005)(316002)(6916009)(66946007)(6486002)(38100700002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TH5seJmZWLEhf0Ks8qka00xk7S190WKsdz8BPdAFql8RuY4I1zX53OFqyPYi?=
 =?us-ascii?Q?iUGGyNUXLahLLdeTxOK2I6M8CJBXke4yDlpnBWMwBGFFP6Noc8mXlPu1Vjlm?=
 =?us-ascii?Q?iBdENywgthC+E3ylacH5CaJY6St1cmxA3OAl1Q2QK/vSGFID+jQViK5wH/wC?=
 =?us-ascii?Q?nK6mOdbOssBe7vsnEyKSOehOE0gegi5MT/WCPx3Y/dfVMBumqdrlBJHp4Q95?=
 =?us-ascii?Q?PPGTRHtmqj0eWQqWBO02TULxRWs8FUFeVzyZ4UZESvfwuszLUOQgY5q9nFqr?=
 =?us-ascii?Q?eiFIS+C39ou3zliyyWsgWf7UomOANWO9mS+0kmJD+fJD63h2om+YbsUD/bmN?=
 =?us-ascii?Q?xmRKRqO2MLJP9oMosSNKROtMNO16SosMsA+oLgh2LEubKOt94D6Bz0ssgFR8?=
 =?us-ascii?Q?YUQTmBnkPnMR9l0d14P7h1jE7OODzOQbYnfdhpAB7iI/fHEidVTYITF4ol8u?=
 =?us-ascii?Q?i2afDXg3FmAyMrtt3CscyMuKgxQ7NqYS5dl3d83XWq4XhY8VzvxoGWrMXJgq?=
 =?us-ascii?Q?ykAfpDPQMDOgFtjHxwJEIQAe1ktditsGg+nJllBXF6ybJ+DLaUfEMtqBQVYj?=
 =?us-ascii?Q?Sn2X+oGp67OOgjoFq9Al9NHeE80f66GuRJAu/dDGT39+Ff9FqvSD0s37I09A?=
 =?us-ascii?Q?ff1D5Vw36Tr7nyZnq21xHIfCzLKEhm5yMSkOLkoylatEXNQ4o8FMqfcHfoNc?=
 =?us-ascii?Q?jEROef97zqPCM5JzGXgSzsENsebqg836q6y5J8r70dDfdZUaMvVlM9s/oVe1?=
 =?us-ascii?Q?hp5gLKk89jurC1Z41nJyA4uwXvnB7xO9AgG2IciijDDlls7IfMRspMhM0Us7?=
 =?us-ascii?Q?gM6sFUdKqSkhYTxB02vLmahiHExzEtnUSZrZh+jYUt3XgXLzZiYmsl7F2Kfy?=
 =?us-ascii?Q?HsY/OIiHKt0MVM4hwJGbsna+jaM9sY9r4iWdslIdeleFDhzpavETAd4biU52?=
 =?us-ascii?Q?txp/PG3OcFqtqFbseIDgY+7CXapcbmVY72MroO0kei0LK7UpSjN79kGY3kPH?=
 =?us-ascii?Q?58au4wqSZBPFh9ciQu/bBSQBhhRbbCXkyyQVNA96jGjKHYSnECEG9dcGwayC?=
 =?us-ascii?Q?P6ydFPunp8UhaKPO9egIidG+pdlRFOz3qu0sOqVEu17KmoVu9kcBLPkRPp3m?=
 =?us-ascii?Q?pexuf72OFowa/UyrkcXWjzf4MSJLT2Yk4x3UDiTy1kIgJ/8YTp2oNIL+mLkm?=
 =?us-ascii?Q?viCtCoATbUnfE2UO1gygGUVu19CnDrwC3eqXq+yFvZIIM8oZHXsy+izPf3v9?=
 =?us-ascii?Q?yAeO/0P6JD6dwE8lo8AR+RcdEC7Ln1aFgPINxRqgMzlMNdolgjyHTW9yOMAk?=
 =?us-ascii?Q?ayY0vRoLzF9woMCAQnCQkiHYRcoKJw39vt1cFJ8shrN20Dn7YMJzfHyfQe0D?=
 =?us-ascii?Q?u/s1hhoW/7/6jrEOjPD2UN/c5WOmNQ79pGfABoQd+nMLIEqOQg6UL9Urwvpc?=
 =?us-ascii?Q?fpgKRb8xrsgdhyFfjp9EIE9JxIzzgwD78QQxbfDgGb1kf7I8I+l2Krn4Fe98?=
 =?us-ascii?Q?VxD3DfHEseNOBnbB0hYq+X2TKl6prbaCZeNgx9am8doOaAKnXwR0UqeJPVx3?=
 =?us-ascii?Q?/EIfXlA7Vh3VRZFshTIhELbCD0wE7vX2YtVRdEbZHrB7UP69kX46DRKQmZr+?=
 =?us-ascii?Q?pw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ZP8vzL8EhqhZFwvRFgWwUkyFZ0qZPOoNPac9HvpHgHpoPh3pMy9nMOvscTz2zFFjAmV4Rxv+8dEZE8+U74jmQq4neRQFA4LG0mP/2xOGrixr/1IOgVdlXF506Uh6FHEjLQ7O4wDKekUAeEUM428+8yK8/FnQyddOeV1VXDW8S5jnWWLMLe5cMopFTy8tFRbbWY+OnCUIS2YFaTI+ro8LfeLAjZhh5xrRhrrEJtJ53BpMox0k6K9ZTYqkslCibzFS1edovydnGXEG1b5p6MMYoGS1UEc81yw7V4EF9anRGKMQ69GT2TLMOQjpPqMN4JxypRe3NdeaiNdxmJitgAYFfz1rr2Sq/49yCJxb/BfUdh3+4Y8LuJpNdl0WMlufBzK5rsq1/M2qkGGFkFBpfFFbgvCwfU3P6D2q7AnstHTekX1h3rJ2crCJGpVOiqqT3WnlFbWX6YXIaL/716fQ/WauBnp6MBmA/WgfUKGby3nX5/LdMpES8pWsHtilnrr4UAyLKqTLBE1qYjpxeXRvUtCYGe76/rmHWjKGCuNMv8zltmwtU0j7VJ27spH/7ypS8V4CKbkJ0t49oE+8V32K5COGbSAafdJvxvtlmpBGxUlG1km++1IB21bQFgRlOHDDWliMbmdiMY+DCzZJ2Vv0QMt4B9UPJejOhyoJC661SYX9OreBsdBBbZmaLELz3NRz3v7dxbkL0XxCtl78RfSjWbunZikECpXg0qjYhTnoImjkDFwSEewC7kK6tkJiM7t70/Fol+pZ/Cy+okaNt5a23nrDPg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6840c20d-a284-4459-9092-08dad24e8578
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 21:13:11.6461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z+wdm0xL79HQqHfXgKZW8/8a5CTmJnRA8NJ+P+8d6sIZwKF41CMVGAF+0CFY5EI2OBetthGlk7XkJPnm51cXnDz4/PmD4fHIFO5mYsFMZuw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_12,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211290125
X-Proofpoint-GUID: cysWMBD_MyGU1v5zEDDArPNnA1rfGdiP
X-Proofpoint-ORIG-GUID: cysWMBD_MyGU1v5zEDDArPNnA1rfGdiP
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch modifies xfs_symlink to add a parent pointer to the inode.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_trans_space.h |  2 --
 fs/xfs/xfs_symlink.c            | 50 +++++++++++++++++++++++++++++----
 2 files changed, 45 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index f72207923ec2..25a55650baf4 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -95,8 +95,6 @@
 	XFS_DIRREMOVE_SPACE_RES(mp)
 #define	XFS_RENAME_SPACE_RES(mp,nl)	\
 	(XFS_DIRREMOVE_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
-#define	XFS_SYMLINK_SPACE_RES(mp,nl,b)	\
-	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl) + (b))
 #define XFS_IFREE_SPACE_RES(mp)		\
 	(xfs_has_finobt(mp) ? M_IGEO(mp)->inobt_maxlevels : 0)
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 27a7d7c57015..9e96f384cb03 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -23,6 +23,8 @@
 #include "xfs_trans.h"
 #include "xfs_ialloc.h"
 #include "xfs_error.h"
+#include "xfs_parent.h"
+#include "xfs_defer.h"
 
 /* ----- Kernel only functions below ----- */
 int
@@ -142,6 +144,23 @@ xfs_readlink(
 	return error;
 }
 
+static unsigned int
+xfs_symlink_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen,
+	unsigned int		fsblocks)
+{
+	unsigned int		ret;
+
+	ret = XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp, namelen) +
+			fsblocks;
+
+	if (xfs_has_parent(mp))
+		ret += xfs_pptr_calc_space_res(mp, namelen);
+
+	return ret;
+}
+
 int
 xfs_symlink(
 	struct user_namespace	*mnt_userns,
@@ -172,6 +191,8 @@ xfs_symlink(
 	struct xfs_dquot	*pdqp = NULL;
 	uint			resblks;
 	xfs_ino_t		ino;
+	xfs_dir2_dataptr_t      diroffset;
+	struct xfs_parent_defer *parent = NULL;
 
 	*ipp = NULL;
 
@@ -202,13 +223,21 @@ xfs_symlink(
 
 	/*
 	 * The symlink will fit into the inode data fork?
-	 * There can't be any attributes so we get the whole variable part.
+	 * If there are no parent pointers, then there wont't be any attributes.
+	 * So we get the whole variable part, and do not need to reserve extra
+	 * blocks.  Otherwise, we need to reserve the blocks.
 	 */
-	if (pathlen <= XFS_LITINO(mp))
+	if (pathlen <= XFS_LITINO(mp) && !xfs_has_parent(mp))
 		fs_blocks = 0;
 	else
 		fs_blocks = xfs_symlink_blocks(mp, pathlen);
-	resblks = XFS_SYMLINK_SPACE_RES(mp, link_name->len, fs_blocks);
+	resblks = xfs_symlink_space_res(mp, link_name->len, fs_blocks);
+
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, &parent);
+		if (error)
+			return error;
+	}
 
 	error = xfs_trans_alloc_icreate(mp, &M_RES(mp)->tr_symlink, udqp, gdqp,
 			pdqp, resblks, &tp);
@@ -233,7 +262,7 @@ xfs_symlink(
 	if (!error)
 		error = xfs_init_new_inode(mnt_userns, tp, dp, ino,
 				S_IFLNK | (mode & ~S_IFMT), 1, 0, prid,
-				false, &ip);
+				xfs_has_parent(mp), &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -315,12 +344,20 @@ xfs_symlink(
 	 * Create the directory entry for the symlink.
 	 */
 	error = xfs_dir_createname(tp, dp, link_name,
-			ip->i_ino, resblks, NULL);
+			ip->i_ino, resblks, &diroffset);
 	if (error)
 		goto out_trans_cancel;
 	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 
+	if (parent) {
+		error = xfs_parent_defer_add(tp, parent, dp, link_name,
+					     diroffset, ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * symlink transaction goes to disk before returning to
@@ -362,6 +399,9 @@ xfs_symlink(
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	if (ip)
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	if (parent)
+		xfs_parent_cancel(mp, parent);
+
 	return error;
 }
 
-- 
2.25.1

