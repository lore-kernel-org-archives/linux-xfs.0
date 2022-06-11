Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13C3CCCA47D
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 09:42:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiFKJm0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Jun 2022 05:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232613AbiFKJmR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jun 2022 05:42:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA25389A
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 02:42:15 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25B3Bj2O022581
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=ByYBarEdVxmG0EbkMSLWajehJlkS9QSMuSlucA8pqEc=;
 b=wF1dIl2Ff/WbgFgxCqTHOKiAN0jfUYY7B23KG0g/R5vgHCBokl4xjN/a782+YknYr3jb
 KyT89acH+VdxkYjsHqIqno8oNn9R1Is4HaC1FDxaeFVCE1bbg7fHDn65vJgjl78xTUPG
 sl0cNKJLY4ld/e8KGoIGJYCl0k3vVgsh9egarl5nG9fgf8n5VpqEflCGE0VhJtcelQLx
 PkjevFiM2zJ1L7T5XfoZUCzR/0/QAtCMyPgXaCQsaD5ubaMsCanye7Vqb5RLWunt0tzZ
 JlsSPELQGPP1btYFQtpxr/3qO7awRJ6ruPNrxI8uWw9Gazq4axLImzAnmzAjoBi1Q8n6 xQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmjx98am5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:14 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25B9allI001303
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:13 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gmhg0m9ta-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IGV96FjkRvicJzRQQTrR4VDcvXMJzuHKfExkbW1JnlM7Sq86UlJaYGUlZgIDi4pX+ZUuSOf2rr8xIIHnW1VKyK5xTalvu9ch8M6QgFYYUeMzoITapxESrv1IKcuhEbfkio54pLBvV2TdsEJ4ma3zEPk+ps+ZgIVmuJlpZg6HVze2YwuNQCmWxo4wYOd3mAuUswbtGBrxJUGOekjuLUM8vhRzvZ25mzaKSnchu6Y5EQjv+5CPEm5tgsELumGx6fvpGEWU2IipbacO20D5q7KEaPpxK8QvhbI0Ig7j7TMfxAdY14oSmikMr2tBlHWvfbiY359tlAO1i56tRDsmnXD5dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ByYBarEdVxmG0EbkMSLWajehJlkS9QSMuSlucA8pqEc=;
 b=hAhJSfrPxHEKZr4JQglzBxRuolK/iA1tytEUVVNxwfbafkQ8e14+qcwOjd9YyhTYKT/Ldrjrdsm6GST7Ci9Bx00HmHAOlMytKedcp3h6wEWwQzu9XINCDbjSQimjoWE3KaGYpuM5mX3BFbU8i1+rtCykR9v3eAY4XW8dPniVMyE6x5CBfPRwJYu3vXTeoYkJIv+Hu6LyXvkydNpp1FvmPo7+Qm/9puctG4d5TWW4jHd+SXu52JyDaQDdTAE1vEX/tBoGLHA5eHWlQMwI8Hki+6ZfK0DaI/9nd47ABYWvuEb+nwCP5nHuXnNq6qmYXZCPDYDnlut0PYilwtM8U4whiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ByYBarEdVxmG0EbkMSLWajehJlkS9QSMuSlucA8pqEc=;
 b=jx1GDFDF8DBZA3Otsqh9wi4etbyMim/LKNckDOZxY4ZeB9AJeMA1DPggPzPHwqf8ZKXgX/spXzA24hYrTJcLueLufLASiWewEluHSar+SyssKlSIC398V4TANAzm53OcsxI2D1QYD+HjVCHNrPO3X52LE+hZ1sDz8lA02ALrk2s=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4606.namprd10.prod.outlook.com (2603:10b6:a03:2da::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Sat, 11 Jun
 2022 09:42:09 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94%7]) with mapi id 15.20.5332.013; Sat, 11 Jun 2022
 09:42:09 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 13/17] xfs: Add parent pointers to rename
Date:   Sat, 11 Jun 2022 02:41:56 -0700
Message-Id: <20220611094200.129502-14-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220611094200.129502-1-allison.henderson@oracle.com>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:a03:180::15) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48e0ffb1-8535-4b96-7b51-08da4b8ea7a2
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4606:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB46061443765ECF0C00B49E6C95A99@SJ0PR10MB4606.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BGjWGIjvKVEaWeVcVAsYZ4oODQq0638qngbY4p0nE6T3l0LcyfVHlA0Iv/5jCLArcWH706AnwVABF/fYGQ9X0kCJPAPlm000YvieOi87WrXAxrJO/pWJkZpTmfSEAbHgZ3gcyK+5TZHs3VlivHnvErjbJSGR9IET904U7mIQrpDh+XHu5tDAx9RbUIbJ7sN8dtHfIOtMtp9B3KDTs/lAnin83LgOdSbPWEdzmmsdp77+NvmFydeI4QHk9IRiktPCaYBKp987vizeJdWtvp6erEfWo3vCVVqUuZ9A90bnVfWk6dp1HEZ1N1wogI1S1VWUrNaPYPd/+QKwh5Mjwi0vygQoxFy692VCfBqUWT9qZ7JxvmWKM+JEpcV1QGxTNtqP6X8tiM4sD8HsGp1t79E7D+Z+91584yTA3qqFFptet234d5logG18tX0y8z07cUjzldVKYnYWiLwXRNgAVFQOVEH7ZkYCX/lzxSzz4gzcO+Pvz4p+qXD+i4S1acdugsHWOR/jD6SClu0sV4KXfceMpPkHAuaWCy/mvLnVi3vx2EvNRBkN3aYfYEm/YHS7zWu9ldeYXDRhc7nnDCXatsK+p0MRVwGcq3jeLu+1NnAlPRu7J76DdMqYFZHjYH+Jq2xOK2m1mKUmdPp75k55kXfPK/SzZhOb5gq+i3NIhyDl8rmJvt+8QvSxhMsuVrEKgAoBGTL/p64WAH89U65oVAyTdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(6486002)(44832011)(86362001)(2906002)(186003)(83380400001)(36756003)(66946007)(66556008)(66476007)(8676002)(5660300002)(508600001)(8936002)(6916009)(316002)(2616005)(6666004)(6506007)(52116002)(6512007)(26005)(1076003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VBM9l48WRDuA7QXmd/TNUFykVZMZ3xd62erQIgQ+XmlVGzffqGygqUf0JXSD?=
 =?us-ascii?Q?76za7IZ2NRopAKh+BKnMgKn8i0uML3cITsdb/51MQWkBMj3r+n1q5e5ZWzMt?=
 =?us-ascii?Q?6ExKW7UEEvbp+Ec1RuoN6Hd+84M+DfAgt2Jrut+G3JKSU8+owak/XOjswT+A?=
 =?us-ascii?Q?GTy31g0NJI1C+Z7iPnUstVueFacyDStigPIbfDKI5mhsWlsqcNnzNHxa+Gw3?=
 =?us-ascii?Q?3Cl+8TS/zI5ZfO7O7wpaPkFBlBLkfWDNAbo8uPtOYRqWP4HmRAcIb82ywuaF?=
 =?us-ascii?Q?fm5cGBM9Gtm/yYO+hM/FWNKfiFnetYTqHNmQipoOUiT/aAFiyWIECs7P6zkh?=
 =?us-ascii?Q?JbyBXgHTiPaAcworSPRPjgTmjy2aodAVI2tt+uRZw6h8yA0VSn0KbjkjzXW4?=
 =?us-ascii?Q?QcmMIkJrKZX2DUwEVu1gHoviMw8laz5y9JpV+9Tzov+eXxQJgZuLzbSuqo9J?=
 =?us-ascii?Q?R8ypBL2Jd5nV7GHwCpmYIbRDEe30qKYaNGJZWRuUrSIz2KOsYWldxguFfJDd?=
 =?us-ascii?Q?sumEjI0QJZ/mHeDcWQEhFKailIMdv0GrD+kl1Q2YWD/kul7ZeW4svbW4/VKs?=
 =?us-ascii?Q?G70LHOfKAqGO91ggLMpXsVywS8xhzLMfoIZ0z3wOi+9RXaklNeZW/AmM8fzh?=
 =?us-ascii?Q?PqCePIL7gWqKki/kGcnkddxa2/vTy+f9Ig1iawSHCD7IuZ/Xf4tvxkqGLJED?=
 =?us-ascii?Q?p9myIz+aF7Lww86DHr82Jor0S7MQntMyGzt6NGik7sUqzD8ozsapdjH1Kjm2?=
 =?us-ascii?Q?KBZ9W3gJEHfgr5D5spKLKjI/w4QnSZTkqRJeyNfYDBFbsKJYlGvfU/GOEv1G?=
 =?us-ascii?Q?8Q4npjyNDdj9J8fX2pbSRPX897HM28SoPSVz91Al1oI7yOjvhfxWPm0NnSo+?=
 =?us-ascii?Q?EWECDGPL0Mkfn803aS7WYA9zuX3Zj0gDFdHRwEN6FR0lmMdSFJX0bHgUgp2E?=
 =?us-ascii?Q?Jgo+nKhMNXLUTU2xlpEAwVW8V6OUeJcM/tiuRFH5F6ywGLFAoEDZNfq+CR85?=
 =?us-ascii?Q?Z8Khdr09my+lljooAoXzk1fD1dJQszUX+pE5M6vyP0bAKQmPCaqyYlLH26cS?=
 =?us-ascii?Q?S3TZIpPc4ELeFUBbo4FOuqraBEb1lsiMBvv9aKe1PrUt0ICRekhzFN5lixRR?=
 =?us-ascii?Q?ebRttyKYt6ftEFy6BifX/XjH7Wt5+gd6c8JMhvv3fFpt0tElL0cAPcl0mCSS?=
 =?us-ascii?Q?SZ438oKb3dhdJkbk+B+Xe8p2F/m7ld1752cxoC6IhSHMhARMdYaeAJYcyzVF?=
 =?us-ascii?Q?dLHZi6++/jTC0cV+wRaP8H0HXlQRgrFD9mIoly02i902ZvHIyZgs16xL76o6?=
 =?us-ascii?Q?oUZWzVF8K37f0CPEH9OE7EtUVy5YLO38Z6Z+OBnA8HkLalpWvV6QBas1PbyK?=
 =?us-ascii?Q?WhmVYz8nlEnDMRkDLGou5gQUQ/hfZ0c4eynrcx9QQjEt4Co5yRycf+wXiS5S?=
 =?us-ascii?Q?s+yYGVU66BCzR2PwhYDBxZq9/R/xT5KV6oUy2mVK0FC3d07uBediHcgDltEw?=
 =?us-ascii?Q?Ko8QAC+/LjZ9RSFZSXYUiTmhdt+Vxz9aoDuPTMZtuxXGZv2/d00uNM58Xwpn?=
 =?us-ascii?Q?tIohrGSikl0Y9rsTKOEZAUbBq2woSW23CHuSJ2Tf2sOJQ8fWvTjsVPxBsLet?=
 =?us-ascii?Q?zYyNLNsnwpa5UmaoZrmoOcA0+vCDezR3QKIWKP0tz3U/eGs8iBmWogdIMv42?=
 =?us-ascii?Q?9zy9LkHGqtx5ioOaMND/eL4Rl/lFG/yHFubE2pYiiR26FmDixKBHgiPP6vbJ?=
 =?us-ascii?Q?HwU9wdO7k+vkKqSZE8p3GKBNWULlmdY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48e0ffb1-8535-4b96-7b51-08da4b8ea7a2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2022 09:42:09.7646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H895PlT7jZwh+1+/eYk1hsTRTPskMLxSoei368+sU7zH6EZ9Llp6A6/teCqzHA91Fk8FW6EDWY8XadY7AE08g3IzyYclmwyt0IrBnJrOMmQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4606
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-11_04:2022-06-09,2022-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206110038
X-Proofpoint-ORIG-GUID: 6UuweMrwD7lJucGejOre5mwAnOURFWeF
X-Proofpoint-GUID: 6UuweMrwD7lJucGejOre5mwAnOURFWeF
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch removes the old parent pointer attribute during the rename
operation, and re-adds the updated parent pointer.  In the case of
xfs_cross_rename, we modify the routine not to roll the transaction just
yet.  We will do this after the parent pointer is added in the calling
xfs_rename function.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_inode.c | 137 +++++++++++++++++++++++++++++++++------------
 1 file changed, 101 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 160f57df6d58..4566613c6a71 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3153,7 +3153,7 @@ xfs_cross_rename(
 	}
 	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);
-	return xfs_finish_rename(tp);
+	return 0;
 
 out_trans_abort:
 	xfs_trans_cancel(tp);
@@ -3200,26 +3200,52 @@ xfs_rename_alloc_whiteout(
  */
 int
 xfs_rename(
-	struct user_namespace	*mnt_userns,
-	struct xfs_inode	*src_dp,
-	struct xfs_name		*src_name,
-	struct xfs_inode	*src_ip,
-	struct xfs_inode	*target_dp,
-	struct xfs_name		*target_name,
-	struct xfs_inode	*target_ip,
-	unsigned int		flags)
-{
-	struct xfs_mount	*mp = src_dp->i_mount;
-	struct xfs_trans	*tp;
-	struct xfs_inode	*wip = NULL;		/* whiteout inode */
-	struct xfs_inode	*inodes[__XFS_SORT_INODES];
-	int			i;
-	int			num_inodes = __XFS_SORT_INODES;
-	bool			new_parent = (src_dp != target_dp);
-	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
-	int			spaceres;
-	bool			retried = false;
-	int			error, nospace_error = 0;
+	struct user_namespace		*mnt_userns,
+	struct xfs_inode		*src_dp,
+	struct xfs_name			*src_name,
+	struct xfs_inode		*src_ip,
+	struct xfs_inode		*target_dp,
+	struct xfs_name			*target_name,
+	struct xfs_inode		*target_ip,
+	unsigned int			flags)
+{
+	struct xfs_mount		*mp = src_dp->i_mount;
+	struct xfs_trans		*tp;
+	struct xfs_inode		*wip = NULL;		/* whiteout inode */
+	struct xfs_inode		*inodes[__XFS_SORT_INODES];
+	int				i;
+	int				num_inodes = __XFS_SORT_INODES;
+	bool				new_parent = (src_dp != target_dp);
+	bool				src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
+	int				spaceres;
+	bool				retried = false;
+	int				error, nospace_error = 0;
+	struct xfs_parent_name_rec	new_rec;
+	struct xfs_parent_name_rec	old_rec;
+	xfs_dir2_dataptr_t		new_diroffset;
+	xfs_dir2_dataptr_t		old_diroffset;
+	struct xfs_da_args		new_args = {
+		.dp		= src_ip,
+		.geo		= mp->m_attr_geo,
+		.whichfork	= XFS_ATTR_FORK,
+		.attr_filter	= XFS_ATTR_PARENT,
+		.op_flags	= XFS_DA_OP_OKNOENT,
+		.name		= (const uint8_t *)&new_rec,
+		.namelen	= sizeof(new_rec),
+		.value		= (void *)target_name->name,
+		.valuelen	= target_name->len,
+	};
+	struct xfs_da_args		old_args = {
+		.dp		= src_ip,
+		.geo		= mp->m_attr_geo,
+		.whichfork	= XFS_ATTR_FORK,
+		.attr_filter	= XFS_ATTR_PARENT,
+		.op_flags	= XFS_DA_OP_OKNOENT,
+		.name		= (const uint8_t *)&old_rec,
+		.namelen	= sizeof(old_rec),
+		.value		= NULL,
+		.valuelen	= 0,
+	};
 
 	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
@@ -3242,6 +3268,11 @@ xfs_rename(
 
 	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip, wip,
 				inodes, &num_inodes);
+	if (xfs_has_larp(mp)) {
+		error = xfs_attr_grab_log_assist(mp);
+		if (error)
+			goto out_release_wip;
+	}
 
 retry:
 	nospace_error = 0;
@@ -3254,7 +3285,7 @@ xfs_rename(
 				&tp);
 	}
 	if (error)
-		goto out_release_wip;
+		goto drop_incompat;
 
 	/*
 	 * Attach the dquots to the inodes
@@ -3276,14 +3307,14 @@ xfs_rename(
 	 * we can rely on either trans_commit or trans_cancel to unlock
 	 * them.
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
@@ -3293,15 +3324,16 @@ xfs_rename(
 	if (unlikely((target_dp->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
 		     target_dp->i_projid != src_ip->i_projid)) {
 		error = -EXDEV;
-		goto out_trans_cancel;
+		goto out_unlock;
 	}
 
 	/* RENAME_EXCHANGE is unique from here on. */
-	if (flags & RENAME_EXCHANGE)
-		return xfs_cross_rename(tp, src_dp, src_name, src_ip,
+	if (flags & RENAME_EXCHANGE) {
+		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
 					target_dp, target_name, target_ip,
 					spaceres);
-
+		goto out_pptr;
+	}
 	/*
 	 * Try to reserve quota to handle an expansion of the target directory.
 	 * We'll allow the rename to continue in reservationless mode if we hit
@@ -3415,7 +3447,7 @@ xfs_rename(
 		 * to account for the ".." reference from the new entry.
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
-					   src_ip->i_ino, spaceres, NULL);
+					   src_ip->i_ino, spaceres, &new_diroffset);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3436,7 +3468,7 @@ xfs_rename(
 		 * name at the destination directory, remove it first.
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino, spaceres, NULL);
+					src_ip->i_ino, spaceres, &new_diroffset);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3470,7 +3502,7 @@ xfs_rename(
 		 * directory.
 		 */
 		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
-					target_dp->i_ino, spaceres, NULL);
+					target_dp->i_ino, spaceres, &new_diroffset);
 		ASSERT(error != -EEXIST);
 		if (error)
 			goto out_trans_cancel;
@@ -3509,26 +3541,59 @@ xfs_rename(
 	 */
 	if (wip)
 		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
-					spaceres, NULL);
+					spaceres, &old_diroffset);
 	else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
-					   spaceres, NULL);
+					   spaceres, &old_diroffset);
 
 	if (error)
 		goto out_trans_cancel;
 
+out_pptr:
+	if (xfs_sb_version_hasparent(&mp->m_sb)) {
+		new_args.trans	= tp;
+		xfs_init_parent_name_rec(&new_rec, target_dp, new_diroffset);
+		new_args.hashval = xfs_da_hashname(new_args.name,
+						   new_args.namelen);
+		error =  xfs_attr_defer_add(&new_args);
+		if (error)
+			goto out_trans_cancel;
+
+		old_args.trans	= tp;
+		xfs_init_parent_name_rec(&old_rec, src_dp, old_diroffset);
+		old_args.hashval = xfs_da_hashname(old_args.name,
+						   old_args.namelen);
+		error = xfs_attr_defer_remove(&old_args);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
 	if (new_parent)
 		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
 
 	error = xfs_finish_rename(tp);
+
+out_unlock:
 	if (wip)
 		xfs_irele(wip);
+	if (wip)
+		xfs_iunlock(wip, XFS_ILOCK_EXCL);
+	if (target_ip)
+		xfs_iunlock(target_ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(src_ip, XFS_ILOCK_EXCL);
+	if (new_parent)
+		xfs_iunlock(target_dp, XFS_ILOCK_EXCL);
+	xfs_iunlock(src_dp, XFS_ILOCK_EXCL);
+
 	return error;
 
 out_trans_cancel:
 	xfs_trans_cancel(tp);
+drop_incompat:
+	if (xfs_has_larp(mp))
+		xlog_drop_incompat_feat(mp->m_log);
 out_release_wip:
 	if (wip)
 		xfs_irele(wip);
-- 
2.25.1

