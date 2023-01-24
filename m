Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF143C54EB4
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 01:36:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbjAXBgi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232132AbjAXBgi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2023 20:36:38 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE0D1A941
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 17:36:37 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O04TrE027000
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=dQvLZOogNQQ17Eu9k8jhxLtyxVP8S0cseb4hxja3+38=;
 b=phIeSkDR9mYzI1b7xB5zal4lq1Wr1smE5GnsJZgCQfbJ41Po6gbGDv2yV88szKCMx8JE
 eVTBxU+5Adz+arQCbiRaJ8mNYosJxzGerfR3tV9cuHfwBsUeX7/1hmMJV2+jXNUYW64N
 qh6J0/4ByRsxY/dQpIKA5rI0jL6Z1XgwY4LOj4145j0w91odPszodHQbiPw9W8WuV0KA
 kdoypTZ1yzLx0VExjTdU3ssGclM9gP30BO+QezxXgS6IBfQt99JpbUOPoUTn2ZyQB1ai
 PWMyJ+fYFGGofoWALoJArT+F0wUlIS3oh+Z0PC+88HVW9RQzwYtRCkWfYdHtr3C3d3JY WA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86n0vcg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:36 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NN6eeQ001121
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:35 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gakvhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eKYQT0KnYTduVuKCURMgvGpZO6i4FonVa80KZjS4wesqpbDOdIX3HO5fLO1zwKodOwRrtPu0Ci4P3ljnCi2hcny+X3CyrTABz0/r2Qp8p2tIE+x4LOXCwg0crNh4V7Ser474GlmMe2GHgXYOEwuQjaN3l9DqoabOLStOEm+It83izDg7VefSahFuWnlMpy3R/I4AieATo2pQlCaibP4jGVaRMnhoV3etDmPH7KXit2SF6pvKyjx0wuLOXkisvDCOoSSfUxLtEvNX2e/zR4KOlnU6BAALT+NdER+cpgVd26yrmG5tHZMJHuScGE0HgkBIMToxNtt5tpWmNV/17A4wiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dQvLZOogNQQ17Eu9k8jhxLtyxVP8S0cseb4hxja3+38=;
 b=f7st9y/mj2T5ssIDk0CYNOwEzBFbgRl3+SzLo6ri+gNa1tcmpynV5L/GIEvqohE9IT/MdVp06PWA0K9aFuVdGpQQvoZvuTXAuFMKKxZ2BM13JT9IiRFk/2L6+GYRzzBT54TuOazOueDLjGhxiI2M4+XhOK722znt6wCjEKh5DhbVCSC/7sKTSTG0rjTsJ9jWPUbWJKH5yHEX8U4nu3n0vbYQQT33kTZLZh/AXzqTwmCHKSiYqTE/26P1RgG+1zDfe/kvgDkMxo/1pvzWXI8x70IId0hTS+XT4oDrtMGE9ENVeCcoOluKyc0aIUs6vkOQhL8//NHiceTWX8JzZsxggA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dQvLZOogNQQ17Eu9k8jhxLtyxVP8S0cseb4hxja3+38=;
 b=EcLSyxbhmpA2TNZ7RvzQIgL5Ys+NEOxaW11D/jgqhqGBI3kwWcOOvJuY82U9kJYaQ1KaFKnFJmPxCiVYb24R/xKiHPij05kceO04iuQ1qDqRa2Sq5pHwrJnRNhz/Na9O7Zgxbsne4uWYMOnJN5bQNXxb6xqbzQHK6HXNtwB3UQk=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BLAPR10MB5041.namprd10.prod.outlook.com (2603:10b6:208:30e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.17; Tue, 24 Jan
 2023 01:36:33 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 01:36:32 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 06/27] xfs: Hold inode locks in xfs_rename
Date:   Mon, 23 Jan 2023 18:35:59 -0700
Message-Id: <20230124013620.1089319-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124013620.1089319-1-allison.henderson@oracle.com>
References: <20230124013620.1089319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0112.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|BLAPR10MB5041:EE_
X-MS-Office365-Filtering-Correlation-Id: 673778a7-978e-49c9-d2a5-08dafdab6c66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 53zPmaSFehEPrwb425b+g9BUJDTQ7oU5zEGXK5u0OPJBX25e4X6A35NgpeoNj7Rk54FyUvALIFklQRTqMmkbnew6AlyHudxXxZN/8p/6JTQ2m4qNrcaAQpFZ4As4nzT6FlL47tV2Jvd3L20/EmYxiJd8/WgEVue0zDaiFin/xoF1SUSfPFM2z3T4P22X/jWk0zdyzrqb9JWATqa4SfEeuLoQ9Z8GGEkMFjWIGd7J0i1HriOj5OgrbqX97qOkUYG1Q7xh+5v+QmWULwDGKsrs7MCPMu+Xir2EsCanmUoFy50pkxNQkQzz+Ia7pqLWmfPBP4LHH+RIjoMFG4okfqxvsar94odmJ3Ju3bnHxgkIJinmadMybYzdECZVPBSs9h0D/Q/WJiHWBpUg7YXJSplDSX0h0rRTDQxgMuGOdkDnXLrIaII+jnfczKh8rhuyZVvNvIkDUnEmPBxkqwv/4AMZsYG3AtVmCizMRRa8+njOvBeyy8cZgqwmmg1EbEkIUgEMqbOlid/eYFUbsceghFPjrml0LKASHBfl0L9Tzlg2rWyZMAbuxnR7231bn8dJ5I9XIv3k6lLlNxGV1vWR46+asyWpsDH61KIAIrSr2sZwX4QfK5NbhSVeqYJnTnbNq/tkzlLEekakbJtn/bJbkQ1XYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(366004)(39860400002)(136003)(451199015)(6486002)(478600001)(6666004)(26005)(6506007)(9686003)(6512007)(186003)(2616005)(38100700002)(1076003)(316002)(86362001)(6916009)(41300700001)(83380400001)(8676002)(66946007)(66556008)(36756003)(66476007)(8936002)(5660300002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?napEbjXn1e/I94x9W4QfRJmqOyeis75yp6ZnBFXxicADEom3g81J4Yz0hm/M?=
 =?us-ascii?Q?hvySAplZAuVHstSS2ahgZFgeKfa3SOQrLgn+cZxvjv0G1mvZLJpVkNokUz1A?=
 =?us-ascii?Q?gJ3jFVnZ187LZnLj51tAJgRrU/k3+79AAeHqseC+JfkXYxA8IK5q1Jw7WBS/?=
 =?us-ascii?Q?5yeLr8aHQdHbhd5OXZdHM/lcC2WYwb9SblpoJP91sazE8/LrODrkZTAZu0Gx?=
 =?us-ascii?Q?Nlled3+FjzGC1yDgwvr0LpBMPhH2aM23yk2xt3J2gqFJbkEC1QsQcyIfjAof?=
 =?us-ascii?Q?D1kIu5NOqJOIst+AevWIYnjNJj3/66XVWTz5NoR6nEn+twyEUHaiC6npJ+ft?=
 =?us-ascii?Q?eFHwzPreTvYjnfjts0SF9CBcVSSCszCwtZzAO4MGklP6QIICOL4WYFDKqBvo?=
 =?us-ascii?Q?1NG2lWvc/h6yx7iS+qWpZNQuCRrpmY5XZEMG6jpBhyivi+sCdn3yX/jKYU6w?=
 =?us-ascii?Q?aG/TR1/mz+1QW7vIx8rJkC28avgvv3jJzIlxCQrv5t7XvwNvojlF9OI9HABx?=
 =?us-ascii?Q?TIlM6SH6eFTdsK3Oi1Hp+AZ2FwTs/DxEpEoiDxrXE1aqRO8g7QXm7AFvv5ie?=
 =?us-ascii?Q?prDGUusWT1fi3I1zgbXdf4ACdy3o9EayWlmaUEMRQo0ZzW2ik4d4+I/qF88o?=
 =?us-ascii?Q?lFhN3vdghxvGa71+AJa8DtGtBLl1VhCW0tpjeljRBSE51uN58FE5kJHGtoWb?=
 =?us-ascii?Q?pl6mlrgKTQ6OyHqHRkNpxx4P5zq5qr3MqRBLKDlcPBOFrNYxr8WbgFHdd/A+?=
 =?us-ascii?Q?N/+mKhF9bAF5YmwvU5XI86NdBAZn0mcR2liZlZ29GJdMByUswI7cFlQ0EZqi?=
 =?us-ascii?Q?JOjth8e6/SrZavMvyZOXY0U9Kk2Pr4S6oX0F0VbsK2GVXkg+Fy9XZQ48Kr7c?=
 =?us-ascii?Q?Ps1JUAlFWU0Q3HzOvXpXK7/82VbOm5SN+jsiuAFy4AVCNjkIRGULvPEYHVt/?=
 =?us-ascii?Q?E9KnP8mdwpea0gDo2tLNZd2V7dfdHF62SZ9FMc6QlOys+Th3/zq1xS9ABcYW?=
 =?us-ascii?Q?Ll2VBu+iuW1u5hfGVPLqFYQrCrf2RlTfVwSHEqcEpkj5g9EpC9JufbeoT1PE?=
 =?us-ascii?Q?l98SBVnxgzk9SOoiq4x+2egE+yz6bTr7pryhWeJ28dH6qHMfXhapE3y4ZmBh?=
 =?us-ascii?Q?QtOGcG/Cmo0Mq4I26yJrr+jWlqEFD8pgrGnA87lylAcvVXwJDO/FCZmWicFB?=
 =?us-ascii?Q?+m23Gcg1AyxiJEScymb7pFVcWGhGxLkwb84dZlutLuLwo+P3+a3F/HAWLo9K?=
 =?us-ascii?Q?WsEIBlhWfpli5AQfTvyjdxVmvi20CPkTmGeLBYB1oL3kHUm/RrbwHT9dKxdy?=
 =?us-ascii?Q?fQqLaJf76SzTfCTLguEkomesFIS8OBqf/cmkDy9OSOEnrNnFfIYl/o5psDmD?=
 =?us-ascii?Q?f2YzstMQcb/OFt3AhQxKhro6aPsp040EJBjZBA2g1cn3/7Jr4hp+8oaST7JH?=
 =?us-ascii?Q?rRjwWPki2MN+KEu5h9dj0vCfG0MV3ja2+kaJDY+IZ53Pv7IF3sj7kqJT2dKJ?=
 =?us-ascii?Q?jZQAMA60ARHKt36vsL8spDYe9Ibc8abi0fpa2yXGDg4PAdKlXRYqDjKq0NAW?=
 =?us-ascii?Q?LjVHJa0NYlGUHwKdQZwlKaZh3tDRwuFasXKYJMUIT8C7HhY7qWvC9ADKF+5e?=
 =?us-ascii?Q?1Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: yodpqJa5XJAbHjcl3IaJtLRNhiVLLmafbvPIS8WcFe2nb+LbRylAKnt76pUwvVwteQRXNIw5Y5aBOx1VJrRXoIS9jYPS32J6U2Wo1hohQEb39qMn35qejEa2XZoNV3i+PN1IvMWqh758BupjrlhIs51LfmnJAtTxCuyanCosgqBF9ePqcqZjNfv70C0Hr+UJb7EshT5SkqPWW0jfwxTEU4diu74pqY/DofEMUOYuaedMmqjw/YbErrWO2cp+ctcko9Hnze6JxlRU4BpkTfRA5rIHafHypQXRnHtzqJ7ETn0P3c68UB9Okg9dcbpN3fOXUP2NfCd38yN6QpQByZNWf8s0B0lUEezeI8n6lgPyQsOpBPPFJBOoM05yKpckGCuMYxAFeOaj96HuiGPN6F4tbKoJvUhT42cXITDH1bcLygB2ApnlU+zEcGagpLAaMAOpcC0iOgAAqAJAw5IlYbzHjN3DZyC3gXWmrrXl6uxN/vDz2XcgY7Hf0lef0xvohm1s7zRRXjKdzNZU1GECRX5bHVqzj3petb8+aLZ7kkxnzlpVE2n5HexwF6fc/BgttZcFSYSxPgrT+6fWNSghwBIVYEaK6zB6Uf/+4jDqfCHib75Nas7P2tJH+olLOBckOm/Dy5XtT3eleHK+l5d0iYVP1kNMYVBsqFIkXwUb89O983cOyJK+fnIU/mwneqLZym0DqyWH/EaUA/FauA9gyt/oBa7DwCKZzxOgTEAWlVKg79oOngfqxT0IyCWQ84CBjqr+KVKw2kHcA6W2GcYBaSaIOQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 673778a7-978e-49c9-d2a5-08dafdab6c66
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:36:32.7508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2tM8XUCM1Q9iKFpt+V9nF+CPNV/c+2pJPS2NgmAqmh2lBQrEJZb/UiF3zuUBX7elkTeUlHItSpZbQbEkCAv5WnsFfdFtwHEEM22CoMxF+i8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5041
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240010
X-Proofpoint-GUID: 1sPVE43Gg9z6wWyIPYAgIslXrHHrwLwI
X-Proofpoint-ORIG-GUID: 1sPVE43Gg9z6wWyIPYAgIslXrHHrwLwI
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Modify xfs_rename to hold all inode locks across a rename operation
We will need this later when we add parent pointers

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_inode.c | 43 ++++++++++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e292688ee608..131abf84ea87 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2541,6 +2541,21 @@ xfs_remove(
 	return error;
 }
 
+static inline void
+xfs_iunlock_rename(
+	struct xfs_inode	**i_tab,
+	int			num_inodes)
+{
+	int			i;
+
+	for (i = num_inodes - 1; i >= 0; i--) {
+		/* Skip duplicate inodes if src and target dps are the same */
+		if (!i_tab[i] || (i > 0 && i_tab[i] == i_tab[i - 1]))
+			continue;
+		xfs_iunlock(i_tab[i], XFS_ILOCK_EXCL);
+	}
+}
+
 /*
  * Enter all inodes for a rename transaction into a sorted array.
  */
@@ -2839,18 +2854,16 @@ xfs_rename(
 	xfs_lock_inodes(inodes, num_inodes, XFS_ILOCK_EXCL);
 
 	/*
-	 * Join all the inodes to the transaction. From this point on,
-	 * we can rely on either trans_commit or trans_cancel to unlock
-	 * them.
+	 * Join all the inodes to the transaction.
 	 */
-	xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, src_dp, 0);
 	if (new_parent)
-		xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, target_dp, 0);
+	xfs_trans_ijoin(tp, src_ip, 0);
 	if (target_ip)
-		xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, target_ip, 0);
 	if (wip)
-		xfs_trans_ijoin(tp, wip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, wip, 0);
 
 	/*
 	 * If we are using project inheritance, we only allow renames
@@ -2864,10 +2877,12 @@ xfs_rename(
 	}
 
 	/* RENAME_EXCHANGE is unique from here on. */
-	if (flags & RENAME_EXCHANGE)
-		return xfs_cross_rename(tp, src_dp, src_name, src_ip,
+	if (flags & RENAME_EXCHANGE) {
+		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
 					target_dp, target_name, target_ip,
 					spaceres);
+		goto out_unlock;
+	}
 
 	/*
 	 * Try to reserve quota to handle an expansion of the target directory.
@@ -2881,6 +2896,7 @@ xfs_rename(
 		if (error == -EDQUOT || error == -ENOSPC) {
 			if (!retried) {
 				xfs_trans_cancel(tp);
+				xfs_iunlock_rename(inodes, num_inodes);
 				xfs_blockgc_free_quota(target_dp, 0);
 				retried = true;
 				goto retry;
@@ -3092,12 +3108,13 @@ xfs_rename(
 		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
 
 	error = xfs_finish_rename(tp);
-	if (wip)
-		xfs_irele(wip);
-	return error;
+
+	goto out_unlock;
 
 out_trans_cancel:
 	xfs_trans_cancel(tp);
+out_unlock:
+	xfs_iunlock_rename(inodes, num_inodes);
 out_release_wip:
 	if (wip)
 		xfs_irele(wip);
-- 
2.25.1

