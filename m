Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BA13C3F6B0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 19:40:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239142AbiHDTkl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 15:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239243AbiHDTkc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 15:40:32 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E95CE08
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 12:40:30 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 274HbYB1001460
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=R7juVH4yEheSRsOowttYdHOX2VGophursraQlbr6BPY=;
 b=ifWmM7o8gbIKB1mDq6sChGSPgIq8hWKWwR/jJTOP9hmgwyAb3JsX12rOlmexpuh1Pi6I
 31597JG8dZxRU2yD798SyIgULr45zBxtcO9PntR43IpEeNQWEXGy1UQe5VJsHq0TTOgw
 UAbsRyO5ZqJzG77zi0s2zmN2FS0W4CHs7qCyxQM0jpgDXurjekKnriBnVN89jYpNMcRb
 sAVrv85gHrL3vU88ndqnR7jXCHQYuYPNzoJZr3DU0gyoINh+uzOew6Amovr4ktbxRXeL
 7xxMPAeib5LE3OKxAjHsPqY+Icp3UYR+PSBYyYMrTnKJwlpyXvfL3SSjcExRpq6dD7H+ lA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmue2x31n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:29 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 274JO4XG014188
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:29 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu34p7ev-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CZXi2Cp14UaRQQLBA/R1k+GsCh77FHrMmVFVaHHj1GXaIuCUDqGoa79xHmZo9R9/LrsOqG1L140GK0WtLwHmqATLLTe8bQWfK8LyvWDTkxoB5EzKsm8UC0y6pKddPoWqzWUZ2I019ZomYbAN8fu+2XEcSsCVhcWQyHXpYYpH+kZzP+SEji7QPVsE8JbfEEoCcM96KFs5qyXpfp1r8T/HUEJc6H9A5KiMtNkgUFqvAdJLb9x+0XT0uAG4dVitMauprGFduAOn5XSAK/U1rPl6QTh5oSPlaLexoLU2DNmWzXR5i1+d6ymt/9IsMZWf0871k4o4MhQBMlC//ykOV/2umw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R7juVH4yEheSRsOowttYdHOX2VGophursraQlbr6BPY=;
 b=KnO7fjvhEXPvd811Yw9Wtkg+QGsCt3HZE08Rae6fvl/imt3kjv+CH27n5OTQ0Cqb6Vba60JqEFcsuqzFMwRDlzomyuTU/K3NKSrKaZLwTX++7X97w5cyumdm3YOjWwAPXSjnhgWXsPkeNVRZvJKM+nwc24a/mvUmYV3DVm28vESHuIMh4Zt31aKLQ3n+Ti3KNiKOVBLobNhKs1R5/Ud1DQTUVLplo4Qq0RsYbSB/nOHfXN52ofISvSZUmccRJ+LSIOw9l14d59WredUppALe9zx3pu8PsSPbFRxDMDaZqd+GdkDqPxOZYPnDktrxtU43rtnWZYBi6ZEaY7N60eieQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R7juVH4yEheSRsOowttYdHOX2VGophursraQlbr6BPY=;
 b=VxgWm/iD+X8REkf30+Pb0IYwtWVl9uByFQ7NEhv/sQMDufO2yQDNtnl7jgBfe0w+K+7C65iQhnTlUn6JtsSNP8RpHC6G3vi2F2BoDemWcFji8FbjJE5h9REJet11cMjPN+pbJn0uaWwjXhrxl3qSLwlmYxQe28r8ZM6zufORZqE=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5136.namprd10.prod.outlook.com (2603:10b6:5:38d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 19:40:28 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5504.016; Thu, 4 Aug 2022
 19:40:28 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RESEND v2 14/18] xfs: remove parent pointers in unlink
Date:   Thu,  4 Aug 2022 12:40:09 -0700
Message-Id: <20220804194013.99237-15-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 82caa139-9874-4800-698d-08da76512de3
X-MS-TrafficTypeDiagnostic: DS7PR10MB5136:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VS+A1dEzLWddQBbz/OnvnxBqksrRXuc9XdXHkcYNPKUzo3Sbmks2ai1G3+4V56XyJgD4wc4yJCrYgJmvIK6zsQL7d1zaSvz5C0fckLBE4JywqeGPZ/y78Egru3JgBtx93+pc6GpsbGD6wANsUXkF2vQNTgYcoGJAMebeF+D2TerZVtkpqFS+B2EcowhvkSVrY/6PB6E2+X0jyWP6/SilPduwNrPfLUtK2A1i3zEbGNIWsgQr3gAEe3HTt0mO75ld6Qsx7FPJgJM0RBTxLoxwbVLwn7+uBeFNcoBIkFWP09EWv7X0X5AQrv++2xNqbM/foyj+yr7hTa0aTOg/mqCnXuPTqJCZFuweJUDSdXZiHoONqhW3gNLaYxy9xWBHXMxvbTfopeg2BWT2wUmjkdi4CwJzHTn9rAYXKR8ZjLXCQkW/qpeSL7yuxqyoQ3zocblHTG7SMld3eDg30gJAI2oqABFLiH/+UCixVujO0SmCz6hPMLdGLGZMR5pjI8nAUsW3rXrT6xdN4ZM71RvBbJgPeB1+99hAONpzvNzSS7HGn4sSmObQuQaj+TUT10NwnlGzsb4+TtuRUUPx1DHRCrt25T59vQ2LqaCmzZDJdLxPObybdjgPN3Csk3arUnf6CnwR4YEnAMWGISExQeuif0K474QomjjZyB6wP1g276730AzEDUymm6kpXgEHc4PoPf/oawg4XvKzi+gC/UXUVPbHAXJ2p03MBipVd84HL+AHSXVRkQDKtQVipkBizPq+f6xKZX9ASy6o4TsK+KwhdeyQe0D52QHPVZoVzWeD2b8skzw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(136003)(39860400002)(366004)(376002)(6486002)(66946007)(66556008)(316002)(8936002)(6916009)(478600001)(38100700002)(44832011)(66476007)(5660300002)(8676002)(36756003)(52116002)(6512007)(1076003)(6506007)(26005)(186003)(2906002)(2616005)(41300700001)(6666004)(83380400001)(38350700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q7Di+ylSFurcsGDJAX9jgBrs9GXDDQWhD8UK4Jgk2KlV6ltWzoLvJeLWtYqX?=
 =?us-ascii?Q?9KEmiaMYmK1TkeJHYGLFTsiqKyv3J+Cc9SOLs2MBY3suPrqdZ2D2RqbVqslg?=
 =?us-ascii?Q?Tll/3E8gqUH+NpeOfLs6da/5jUg29pHWLas+84+47XcFGUAQ4TPdDvlFlGYn?=
 =?us-ascii?Q?wDMYfp3TzYXXJe3qznynSrDdyJvcDolV6EG/Xx7NwydwcWkgjkpU3mVlEImi?=
 =?us-ascii?Q?NlecxN61uOYpy0R9Ypn7O6zEU1EgZQYbh4kFCZbObLgZ1ec6Jede9IAlDtQC?=
 =?us-ascii?Q?OyHGhKhEpCPwefI/HLu8X0A8llUXdMo96L4AOjzv5PcQkjXXYn7oJPbed8a9?=
 =?us-ascii?Q?X2tAN05dHvf8DC3Yo1fdyfmnV812j79Hb1qlB7o8T+c+aF+ltl0ek5z8o4Ou?=
 =?us-ascii?Q?48PPQSzYNPfiwJwcAWMfBAK1ra733S5ggsi1QgJKKHm7hSHFu/KhaL705oVd?=
 =?us-ascii?Q?MKjToujYKBiLo6BDL0DETkCPXsdORWjoPhUtq4v5Bbv3ogtlErd9ClnvHb8y?=
 =?us-ascii?Q?xzEs++ZTpQm0zm8YBz1Nk5UB7FTIO08u/+sW7UmqRqlu7qVIjF9cV+kwt/0y?=
 =?us-ascii?Q?lbCVUnYIWiIBFiSmfk+WXDiJBd6tlPlsLmlDh04LtFy1YiNp4hq9fwq68s0P?=
 =?us-ascii?Q?MobLM+4cIRQrccFWPOuBXbqaEy2mH9jWAKsDQrECYP/a6kl3vruw8EcpPfXG?=
 =?us-ascii?Q?r1/YEiM8ycLkyP7CXdlF4ckL4pYCQDm2ciZKmwhm+gHt0da4Qs0PpBGL4FmL?=
 =?us-ascii?Q?6UtxNq5u341Ny3BNjI+d6q9oBJJ1LxYXbXHGm2VnxXHNS5rSsynNhLXPtQyi?=
 =?us-ascii?Q?Zq7exm/ITPWhrJoZLND3iw13Sqyg3sqHBiFPj1aYTlk5GrQ35FP5Qqs9Kls6?=
 =?us-ascii?Q?F6AS6YcuQGun8ezRLaAS8kPQ0h4M6An2X59Xdiwhzs7i1rTb+awfSNMfTGn5?=
 =?us-ascii?Q?WgdOKzglEK5imTLWSkNSkPNnjWkG9hRtNfz0X5QFOKFh74ytb1xI1kveMewI?=
 =?us-ascii?Q?xjBpg2K3J4lZVm2t6TcNlxpueL+W2PnX3sst1/5xNtxKKUn4zD+gYLdwCFd+?=
 =?us-ascii?Q?W4W4xU9bQjzVA65W07l/7pEBc4g4RIWCGbzzRhloXaF71NRQNJWw2pK+ysNh?=
 =?us-ascii?Q?/nOhV5tMQS4LrZzYoHbX0uaVtktj6BwxNCCP1qCn2ZDLHHFRxUd6AkiInQJL?=
 =?us-ascii?Q?EYDU1CXWC7e6jPufawcDkc60jQSsH5oXCNwZSZ8m1MbPpgM2CbONCHp6Tj0W?=
 =?us-ascii?Q?G1TEwLB1hqv6L8Ml70C42FQixuC/vrHDb+/QSlzIl5uXlk6Tc5O+VegQ9t7r?=
 =?us-ascii?Q?WRd6yQaOyVgRXDq4Ey1eqkvXtHeYZDcw5eLgLXSihiwG+3uWoad8SQf3EYd2?=
 =?us-ascii?Q?2utlADhhPRiuqbz9lIlkdvo7qEs/S7+t/UwWsyXA8pPdZumxa6LSjsMW3gp2?=
 =?us-ascii?Q?Hhb/MYA83LIh5X2xl5tsZZa+aqW5wXu6Dnlh2QEnNEZylMJY6WvnsXsjyJen?=
 =?us-ascii?Q?smabH+Hcoo7vujQnQKhjZqhRDJyHhSRG7Gp5pNdNCigklyyDS09WdrbQTss9?=
 =?us-ascii?Q?JkypHs7bgLddPSmPued+AGzak2ckQ1XEcKnYbj8dxc4MoYDTXRGkKKwI3BDK?=
 =?us-ascii?Q?Jw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82caa139-9874-4800-698d-08da76512de3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 19:40:26.2685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xf27BG0ZuQGcvUywZdKflgB2VIURz7kxJO2+whKvS6x1ig7QfwkULQmtLlebx1YqoV1IFwWfYs7pn7FvZhOLRdJ46smEB21LdgyF6PSgxvE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5136
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208040085
X-Proofpoint-ORIG-GUID: KdbrL7tzSPiSbuofQ4dwP4DVeFiL-0_i
X-Proofpoint-GUID: KdbrL7tzSPiSbuofQ4dwP4DVeFiL-0_i
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch removes the parent pointer attribute during unlink

[bfoster: rebase, use VFS inode generation]
[achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t
           implemented xfs_attr_remove_parent]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c   |  2 +-
 fs/xfs/libxfs/xfs_attr.h   |  1 +
 fs/xfs/libxfs/xfs_parent.c | 15 +++++++++++++++
 fs/xfs/libxfs/xfs_parent.h |  3 +++
 fs/xfs/xfs_inode.c         | 29 +++++++++++++++++++++++------
 5 files changed, 43 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 0a458ea7051f..77513ff7e1ec 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -936,7 +936,7 @@ xfs_attr_defer_replace(
 }
 
 /* Removes an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_remove(
 	struct xfs_da_args	*args)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index b47417b5172f..2e11e5e83941 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -545,6 +545,7 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_defer_add(struct xfs_da_args *args);
+int xfs_attr_defer_remove(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 4ab531c77d7d..03f03f731d02 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -123,6 +123,21 @@ xfs_parent_defer_add(
 	return xfs_attr_defer_add(args);
 }
 
+int
+xfs_parent_defer_remove(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct xfs_parent_defer	*parent,
+	xfs_dir2_dataptr_t	diroffset)
+{
+	struct xfs_da_args	*args = &parent->args;
+
+	xfs_init_parent_name_rec(&parent->rec, ip, diroffset);
+	args->trans = tp;
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	return xfs_attr_defer_remove(args);
+}
+
 void
 xfs_parent_cancel(
 	xfs_mount_t		*mp,
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 21a350b97ed5..67948f4b3834 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -29,6 +29,9 @@ int xfs_parent_init(xfs_mount_t *mp, xfs_inode_t *ip,
 int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_inode *ip,
 			 struct xfs_parent_defer *parent,
 			 xfs_dir2_dataptr_t diroffset);
+int xfs_parent_defer_remove(struct xfs_trans *tp, struct xfs_inode *ip,
+			    struct xfs_parent_defer *parent,
+			    xfs_dir2_dataptr_t diroffset);
 void xfs_parent_cancel(xfs_mount_t *mp, struct xfs_parent_defer *parent);
 
 #endif	/* __XFS_PARENT_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6e5deb0d42c4..69bb67f2a252 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2464,16 +2464,18 @@ xfs_iunpin_wait(
  */
 int
 xfs_remove(
-	xfs_inode_t             *dp,
+	struct xfs_inode	*dp,
 	struct xfs_name		*name,
-	xfs_inode_t		*ip)
+	struct xfs_inode	*ip)
 {
-	xfs_mount_t		*mp = dp->i_mount;
-	xfs_trans_t             *tp = NULL;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_trans	*tp = NULL;
 	int			is_dir = S_ISDIR(VFS_I(ip)->i_mode);
 	int			dontcare;
 	int                     error = 0;
 	uint			resblks;
+	xfs_dir2_dataptr_t	dir_offset;
+	struct xfs_parent_defer	*parent = NULL;
 
 	trace_xfs_remove(dp, name);
 
@@ -2488,6 +2490,12 @@ xfs_remove(
 	if (error)
 		goto std_return;
 
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, ip, NULL, &parent);
+		if (error)
+			goto std_return;
+	}
+
 	/*
 	 * We try to get the real space reservation first, allowing for
 	 * directory btree deletion(s) implying possible bmap insert(s).  If we
@@ -2504,7 +2512,7 @@ xfs_remove(
 			&tp, &dontcare);
 	if (error) {
 		ASSERT(error != -ENOSPC);
-		goto std_return;
+		goto drop_incompat;
 	}
 
 	/*
@@ -2558,12 +2566,18 @@ xfs_remove(
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, NULL);
+	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, &dir_offset);
 	if (error) {
 		ASSERT(error != -ENOENT);
 		goto out_trans_cancel;
 	}
 
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_defer_remove(tp, dp, parent, dir_offset);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * remove transaction goes to disk before returning to
@@ -2588,6 +2602,9 @@ xfs_remove(
  out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+ drop_incompat:
+	if (parent)
+		xfs_parent_cancel(mp, parent);
  std_return:
 	return error;
 }
-- 
2.25.1

