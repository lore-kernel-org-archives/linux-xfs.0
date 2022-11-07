Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D391BC433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 09:03:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbiKGJDS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 04:03:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbiKGJDO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 04:03:14 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E21D165A7
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 01:03:13 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A75fMHO025318
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=18p/wFL7P2HHrU50Qg21bInT96l627BUEGohR8wqWyo=;
 b=izvRSHowgBVFyv1Q4QQca5dv0d9epd6IkN56nD/1SR/U23ISuKKgQcpFBv+trlHVt8X4
 UTT1DC+LZRXL15iv4bgUBQRa054lJ1jprgvTnjMH8eYk/wZ6S1ycSZ4a3PEtrkpoZpbP
 QDp76si2gq4uB/d6AbItuPWznsWxvS/Jf2v8u7lAaXyYJzJGP5NRZt9jubI9yY03L7my
 YtmMQ60My4jUPxUH/CNTH+YGzLpB3UmWHCFXDEm/ViGSNVtUVRzvhvv/v87DFBI0eKYd
 k7PmZtPojKOTgI30GYW2GM03E1B3NeiCDZroYqnXGoMCWvDhUbMzXk9H7rBvoJMwCgiI Og== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngmj30jk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:12 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A77YwuR023880
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:11 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2047.outbound.protection.outlook.com [104.47.57.47])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcsc2yqe-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vt7yjAO7abmQEfhyJFKFmwnbgxLfnH+Emd6a10AkGAkupoPcaYs3R1fhJTsTrGDqjoeAEswlm5As1I6lh40aGAxTKhBJFbIPQqukOqbFM4r7XsPSJSCjkfiHkR610jVG5yNEl6StE8vyidPgefCzu4lh0eCs0NIzcjNnKBQVWBKOwS8LIO4iWel4HISIhkhzehYQGQZag5lTUXWJdlc6YhX6BLVW0y45rryzYmS3yP5l1ybVPc7VyhVIth7KP89v2qfwV+fUlDYr6onjiF2cZ/rXTSQeSwfFl0b+g4WsvnQ6DOPF+CgEabLZRAg6okMN+WPHMWM0mAYX0Q3NdQ9bYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=18p/wFL7P2HHrU50Qg21bInT96l627BUEGohR8wqWyo=;
 b=GFaZhQ3ptogNdK2Xm5bj5XUlfCuZYD88boq2RphM+pSnMuR5NTbyOaGDSDYJFPBMOUSCfWl3rJf+zldU7btSzQ9jvRjXEEQVjTDXxWRjhpT6VOqn06Q/7v/hl0sIyyJnpLgy34L124aK+EhT1dbldlJuvhDxS6t0sBi4mga3RYkiek4DwzK/LYKuS8EUwXycd3Y1yl8vw6p/stbMktZI1oBfF9IiElHEOoL3J/EhrJMsSIZgyO1uF4MmfzmfHS7axn6ySvoPCa/hzXRf+3w9KdmEp5fjnyi0PHRwy9Z8LhBmSKNWfQ1FQ0y/GXo4JrT8KOPDF7mp5Q4fJPprIfNVPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18p/wFL7P2HHrU50Qg21bInT96l627BUEGohR8wqWyo=;
 b=vlp/WGKDvoFG/teEsh6Clsx8/ZjiiqPA/eiTGApGk+000PcuckZ8AN0orcQc6OMyUGmxZY9X86SOjvDwQc4EMmRMZcOUfD3l+XWe0TFVe8BP7lb+BY6Opm/98yzs7czc1SAAZm2oj1nylj3Dl2IOlzBAObrWU2i/2Gp6Whwe26I=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5848.namprd10.prod.outlook.com (2603:10b6:510:149::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Mon, 7 Nov
 2022 09:03:10 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 09:03:10 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 17/26] xfs: remove parent pointers in unlink
Date:   Mon,  7 Nov 2022 02:01:47 -0700
Message-Id: <20221107090156.299319-18-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107090156.299319-1-allison.henderson@oracle.com>
References: <20221107090156.299319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0073.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::14) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB5848:EE_
X-MS-Office365-Filtering-Correlation-Id: f1b51588-5863-4304-9681-08dac09ee502
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N52nXdjMvWyn5kNRHTR54MDf5VPt1mhAOW0JM+nc+2TNeP+EsFHyxLNSHpx7scmhArmL5oQ5NygF2ZjGonXIG+EirVqCFDsdZ5cksJQGHUzBhRQdyFTpcAJ62c6icGdiwO8KQL79cT7AQO7b/dq0twM06eJ5KB6pMJapA5+yNqTwPNESyE/GuKXFf40oAHCtv0T8SO8zDvkAsE0CDWRadpzIptlczGFBRkFX6YrQ1kD9M6itEegWoMaDjyWs6ipoPnNzWKxMMsKHxe4zzWmZbmgFo1+Xo9Svm9UdDc+yH/XTyV73f9AODDn6vf94GamiOnOGuyM8bXNn1YYrjU9QWDJYbGdXqNv3+j/nkfg7qJrjkr2rMvDbTmwPQGtR91TLe+XXzm3VOcadQsOtKDG/lqAMydO+Th8phY9r/NbtXqONc5hwFtyROnn5D2xgwFUbXsuXcdcYNt2QOBoEnE3UHsjmTz4hG26ViYdj30FFlhxkkPwg6rwy6YRL6q1KRl1inRR+/QXzjV/EIFMuvsuxQv3+Akdcyq9lUxYZf02cxTjw4nuEdVKEOUlowaDNYm5J1JNOEnAZcdE+fX7dYbTiVja7b8oHowJXOj3b5PjB6D/sHpnPk2Sq+r3O7PFb3jbw4cfzPMDqG2xK+3Wrz92DtAU+/I0ukUHoVzoWy9knECS3JyJQmT6kqEhdtUEjTrcJBb1vaKTXbxJJG3Rx4Qd3ow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(36756003)(8676002)(66946007)(6916009)(66556008)(66476007)(83380400001)(2906002)(6486002)(41300700001)(5660300002)(8936002)(478600001)(6512007)(2616005)(186003)(1076003)(26005)(316002)(38100700002)(6666004)(86362001)(9686003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eY9n3aOp8XPYUg4iqEgiHs9AAj4Gggaj9pma8nVZMu+ClWaYaOZMw+/Wgg6n?=
 =?us-ascii?Q?L+s0ciUpTf3lrO+WKsj02cUQb4VbvW9bei1R8+lgDESWRPE+k8Nr9D4ZSUEF?=
 =?us-ascii?Q?R5fpZEgeS5sws4XFCrf9xWFCZgMcpk5p5M0Xj1hIgVLkhVPEg+p9iz8E158C?=
 =?us-ascii?Q?3zBCFjQbAceCYKeQooM+/ZnBd+mMxlb52Cv9YrcwuFD7/urC77fsmqIjCEYB?=
 =?us-ascii?Q?jNtNkWa3WdEOjCth3pVJst0uUFM/k6fbxHxj1ekQ8ykQOdlxHfwrtNgjNu7i?=
 =?us-ascii?Q?KGTNv2vhXKKWuorMx7sKJiwogN8oM98W1GJ9OcUZ3sJJB72ujyY5U/COiMsH?=
 =?us-ascii?Q?gRBsDzoGL/U6VUrk2u2yBrie1YguRPlCIaaWjsieqBUKqSML8CWLL3rNxYbp?=
 =?us-ascii?Q?fdfvwX/Tl1Axrl6/2z6utWSD7DEOM21JU3TxqeX+HZzoI+onPc/E/Y5nCU3T?=
 =?us-ascii?Q?B3L3RQXrTabqBT6VLnPCO5zIDpDnssEf3yAVqBqllhAoaVaIg+YIMul//7V0?=
 =?us-ascii?Q?HbrfpAnAbI2OLatbvOMZ9kZl6OP1ldaIFkeViU8EtY0O97IWC0gIR8C/kdB8?=
 =?us-ascii?Q?fw8ZGPD+ilj8aHMO2VEm1d1k0rTr6bDwOpdCPJPuN/I0Kh8Vo2gJ0j9ELXHu?=
 =?us-ascii?Q?rasqJxoYHWFVsZVhsJFUKxT7Uv2xtgd/8SBjk6ZfSNOmmvIs1D43IFcnYzYQ?=
 =?us-ascii?Q?Lvp9XcBaRwefl/PiZHizqT+AzeaPDLQHTeBbF6KW1wAyW3rEQhDBMzHB5FIS?=
 =?us-ascii?Q?Z8gEJb8LKh1xHsOAUs7vDa6oFLFSPhC2PkcFTdxfR1UG9rXJcXkNrpmzqC1d?=
 =?us-ascii?Q?6Thfcs8CGjt6lULzsXEm/VaNHkbfk172aeR413sm/CXULfWNcQJif82SnaSl?=
 =?us-ascii?Q?V9zsPv2VsOXhb+ezRemscik+65/KFobFv6IoNFOkETEl5eL8xwSlS5Nf0sCi?=
 =?us-ascii?Q?rJy5VwGEZIqYDEjTONuFj0tnUIgEwoybAyTlRKif02J4kAiBZavfeqQGiN+l?=
 =?us-ascii?Q?XeNgZrwql0sWX4BVZjExi/lB+v7deZdtzXN+ZIFehiytLZ+E3HkC0QbZzxVf?=
 =?us-ascii?Q?wAY0juVJjxjGWlKwrHrUWC1l6BCnZSRepXdhf3sZOhMnFCK5TIowT6GfbZb9?=
 =?us-ascii?Q?h7oCrYvOn9aCKNT69tod4Dr81neSizYwOsVfxhYbraW3SZg/ChJTSJ1sarDJ?=
 =?us-ascii?Q?S2xTH6Jfy52Fu7wubltJ87Tgn9lw3fm37QEotAFuXnOdQO0SXpgKw/uLapJu?=
 =?us-ascii?Q?utEQw2PhnGnwNDzp/X8EhO9nlOpo8cDiFPFej58MxEkmN0CmSPkxZZc3m9kj?=
 =?us-ascii?Q?ZVwjd1TmxuebOiAZ8Vh301cj2Ei4VCJ3x1z6BGb95AsjnDgdCyNIn+a7qrvc?=
 =?us-ascii?Q?CbUl32ef3Xz5KW6I6B2PG3jMetb1OxmfDWgqq0F/1oZhzWiuI5HT1CgYFWRV?=
 =?us-ascii?Q?aYLYcpOHmJdQHtzt8DRGkP9V7EMHziU5uHIu+MN6rq+TLO18zUvm011weYRk?=
 =?us-ascii?Q?fa3+n6zMHNo39oM5WhhuCeprEWR9LGOprUnZnHglKYa1dIzXmRHwRpmUFwdu?=
 =?us-ascii?Q?m93Z5UvVmcdUvmuxRfSeyx8ogXDBLFy0CvrtsuP4H7NvvWtLLnUm8iDbtWyl?=
 =?us-ascii?Q?3g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1b51588-5863-4304-9681-08dac09ee502
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 09:03:10.6645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vPjx5AVnqEXoUPZ5W/wPDskk+ZOXUdOyf87Ht8zQcJmwr0GDWcRkJbRxPYQA/bJ++HZvlSqYwfWswXdwqXtJDndIdrXDXuox313JVk+FH4E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5848
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070076
X-Proofpoint-GUID: lpToxH-cc-V0XKkVytV4CnqB5UEhES5W
X-Proofpoint-ORIG-GUID: lpToxH-cc-V0XKkVytV4CnqB5UEhES5W
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch removes the parent pointer attribute during unlink

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c        |  2 +-
 fs/xfs/libxfs/xfs_attr.h        |  1 +
 fs/xfs/libxfs/xfs_parent.c      | 17 +++++++++++++
 fs/xfs/libxfs/xfs_parent.h      |  4 +++
 fs/xfs/libxfs/xfs_trans_space.h |  2 --
 fs/xfs/xfs_inode.c              | 44 +++++++++++++++++++++++++++------
 6 files changed, 60 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index f68d41f0f998..a8db44728b11 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -946,7 +946,7 @@ xfs_attr_defer_replace(
 }
 
 /* Removes an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_remove(
 	struct xfs_da_args	*args)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 0cf23f5117ad..033005542b9e 100644
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
index cf5ea8ce8bd3..c09f49b7c241 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -125,6 +125,23 @@ xfs_parent_defer_add(
 	return xfs_attr_defer_add(args);
 }
 
+int
+xfs_parent_defer_remove(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	struct xfs_parent_defer	*parent,
+	xfs_dir2_dataptr_t	diroffset,
+	struct xfs_inode	*child)
+{
+	struct xfs_da_args	*args = &parent->args;
+
+	xfs_init_parent_name_rec(&parent->rec, dp, diroffset);
+	args->trans = tp;
+	args->dp = child;
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	return xfs_attr_defer_remove(args);
+}
+
 void
 xfs_parent_cancel(
 	xfs_mount_t		*mp,
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 9b8d0764aad6..1c506532c624 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -27,6 +27,10 @@ int xfs_parent_init(xfs_mount_t *mp, struct xfs_parent_defer **parentp);
 int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
 			 struct xfs_inode *dp, struct xfs_name *parent_name,
 			 xfs_dir2_dataptr_t diroffset, struct xfs_inode *child);
+int xfs_parent_defer_remove(struct xfs_trans *tp, struct xfs_inode *dp,
+			    struct xfs_parent_defer *parent,
+			    xfs_dir2_dataptr_t diroffset,
+			    struct xfs_inode *child);
 void xfs_parent_cancel(xfs_mount_t *mp, struct xfs_parent_defer *parent);
 unsigned int xfs_pptr_calc_space_res(struct xfs_mount *mp,
 				     unsigned int namelen);
diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index 25a55650baf4..b5ab6701e7fb 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -91,8 +91,6 @@
 	 XFS_DQUOT_CLUSTER_SIZE_FSB)
 #define	XFS_QM_QINOCREATE_SPACE_RES(mp)	\
 	XFS_IALLOC_SPACE_RES(mp)
-#define	XFS_REMOVE_SPACE_RES(mp)	\
-	XFS_DIRREMOVE_SPACE_RES(mp)
 #define	XFS_RENAME_SPACE_RES(mp,nl)	\
 	(XFS_DIRREMOVE_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
 #define XFS_IFREE_SPACE_RES(mp)		\
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c780ab3a04d2..f6be7779c9bc 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2470,6 +2470,19 @@ xfs_iunpin_wait(
 		__xfs_iunpin_wait(ip);
 }
 
+unsigned int
+xfs_remove_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	unsigned int		ret = XFS_DIRREMOVE_SPACE_RES(mp);
+
+	if (xfs_has_parent(mp))
+		ret += xfs_pptr_calc_space_res(mp, namelen);
+
+	return ret;
+}
+
 /*
  * Removing an inode from the namespace involves removing the directory entry
  * and dropping the link count on the inode. Removing the directory entry can
@@ -2499,16 +2512,18 @@ xfs_iunpin_wait(
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
 
@@ -2523,6 +2538,12 @@ xfs_remove(
 	if (error)
 		goto std_return;
 
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, &parent);
+		if (error)
+			goto std_return;
+	}
+
 	/*
 	 * We try to get the real space reservation first, allowing for
 	 * directory btree deletion(s) implying possible bmap insert(s).  If we
@@ -2534,12 +2555,12 @@ xfs_remove(
 	 * the directory code can handle a reservationless update and we don't
 	 * want to prevent a user from trying to free space by deleting things.
 	 */
-	resblks = XFS_REMOVE_SPACE_RES(mp);
+	resblks = xfs_remove_space_res(mp, name->len);
 	error = xfs_trans_alloc_dir(dp, &M_RES(mp)->tr_remove, ip, &resblks,
 			&tp, &dontcare);
 	if (error) {
 		ASSERT(error != -ENOSPC);
-		goto std_return;
+		goto drop_incompat;
 	}
 
 	/*
@@ -2593,12 +2614,18 @@ xfs_remove(
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, NULL);
+	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, &dir_offset);
 	if (error) {
 		ASSERT(error != -ENOENT);
 		goto out_trans_cancel;
 	}
 
+	if (parent) {
+		error = xfs_parent_defer_remove(tp, dp, parent, dir_offset, ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * remove transaction goes to disk before returning to
@@ -2623,6 +2650,9 @@ xfs_remove(
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

