Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DEF2C54EE9
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Sep 2022 12:49:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbiITMt5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Sep 2022 08:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbiITMt4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Sep 2022 08:49:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D800E6540
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2022 05:49:54 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KAUCI1017965;
        Tue, 20 Sep 2022 12:49:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=bFK4p2xZW2BRQU9pEJv0zBlHzxLGdFal4PTiCbm/zkU=;
 b=jXmEin4PCdf381KhCD7JZSXRScXjYLCQVTKhHL0Uqzz6I/F3KDYUlpW9kRY3AaSLHGR+
 TDqEq27KDP143Gc0EeHGVKoTXLxlqrTBSfYRhwHFh3J6mOEWAewn6eS7i+JM2HITx2Mc
 S/Lpx2WveW0ujGDySKFb01K+T1uHJ4vu8b6q2CR6xLr9sxdzl3Fj98cBTDVSKVl8efkb
 YQm9C9MzSBOR7qrdmQhgDXNKtlw36leeE/PryplACx6ncNEJBT9yNjLXmRLmW/CA3J2M
 aK8YOxpsgbZYeFsUFeMAtQnyvY9w/bgTyjMTAzan6s2XRUUOjxj3kk0MyEZto84m4Hyc lQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn688en33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:49:49 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28KArnWi009939;
        Tue, 20 Sep 2022 12:49:37 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3c90dqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:49:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bTIqRnjh75fMbOUefGFYcBQG3NkliTXOz1QvjiEa3LZKF9pIalTW4LQdQxFzIV7T27ZzhCUP3aobvHUVdsa7iCM+N1MLgEfzoY+vLosLlQFUgpgIqFQ351mkNWOMk3hVW6fWqGWZtlQv284jW3p9TfqLq1XtC5tCFA9wMBJTDVZNXoRytSlzLVCP+8rLz6KwqkyN7wmjnWbwY9bz+B3PMGDANE8Y7W89TE7P1f0yDAQ9hL4th8h5Rq9a4R6iSdVeGPZH1w5BcLQOfHQBDIGiEbSvZ5P5YpJ6A7ZvKGlh6zHxG7GLGcRsY90eoy7+gai65ETS9q2pr5JcB57fcCIP+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bFK4p2xZW2BRQU9pEJv0zBlHzxLGdFal4PTiCbm/zkU=;
 b=nvDbkE/BalW1K3klAr+WkPK6Wbd2F+bW9TbCRnHEU0k+ruW8YxtsiqWSgo/aKJzU8UzYMiyNQUJzrc/4sVDhVAjoxHKU2eWPvQnp772ZSoY1KTpzkMLFlGSSbapLDiT6kosXICG+YpvEvvabdM7KaIQKUd6+GvFL/uApW5/sYyhbs9aS5DCJwUxW8GuMYlOxpBjp/ycBdmdi9CLbwnbNSduM+XiwXUY7mGg1cXbWJAetf/o0ezwAkCDtPCZV33DE9VOWR/lfzJuZSlIqyQEPmUo357Kk+UnpOpjtbNYgnXYVx1sjb2bWNCkcIuX29ot61lubxSdH/EFtowm8ius5rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bFK4p2xZW2BRQU9pEJv0zBlHzxLGdFal4PTiCbm/zkU=;
 b=L98Qe6e1LjXsAlgDB1DHVjgwk/1mfM7EzWL2ZYdiWRPkZdPyO1IFuB5yV+JcK8lon3lvairioVbk8KGQKwd86S/zNiaiuLypQkjhl4G7HWt5IZ7CbeFCn4/AmDDOtOr3t0MmPvPn3wPQ9z7C1epPNWwmiN92U4wt3RfS3eHPnvg=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SA1PR10MB5784.namprd10.prod.outlook.com (2603:10b6:806:23f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Tue, 20 Sep
 2022 12:49:36 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 12:49:36 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE V2 08/17] xfs: Fix deadlock between AGI and AGF when target_ip exists in xfs_rename()
Date:   Tue, 20 Sep 2022 18:18:27 +0530
Message-Id: <20220920124836.1914918-9-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220920124836.1914918-1-chandan.babu@oracle.com>
References: <20220920124836.1914918-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0038.jpnprd01.prod.outlook.com
 (2603:1096:404:28::26) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA1PR10MB5784:EE_
X-MS-Office365-Filtering-Correlation-Id: d9e854bd-868c-4ad9-cc58-08da9b06928c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g0+6myF07PjiId544ShDw5vZg3bOP52gVYlmsfKSzbAr3NvQMyApVceHIpIOZr3Kis7ghfNdOHZIq8K85qqIvE4OqXf2BYMf6eQeGVx3ORddmJWmkHMtJyaI3fjXhJ1gW2QTIkiqkdCPl0r8qdd69prxRaBmaHYPaIce9VS6yUsBsdIBLv5t4tNbGyc7k6qEgle99YTKOYWQz6SG9jBrEQDVAKbWHg1x7EX1Yq1+c4FpEilIroV/fcEeJ67ON6AKS48RSN5ybyV/g21JWE7uK9kv7Mte2lZlR8cqFTjx3trkwptKWexX2i7o+oVEwQRYn9jhfHGXdizYBnP+P5Q3WK2sjuQly5+KumxapSlhIIT0dXwqm/BfbkKPnhH1XU0rvxYsFyy3V0Nb6uAAr8Fq/F1Z/PhKiVjX1HbXCphTL3viKb+C5lUI1Hth8+1pcDbuJR2Fq/x72SpoZzmT5F9ENNb2kmFwrzSMe60HDxouAhrC4jA5GuTLDEfWRl2MR+/hLuWFoLO1C4czjQWEjfuPc4i50xwi8+yQYcn6ctyK3z9pPb9p0oxvxhDj900a5Yyp2qO0CAkEmT8moyUcS2a5KEziTO3RRL2EKew4hJtjVVU9VcB+iYTI+cz8trRd2Dw8a1rFnVNFoII2fZ50xdN4OVSjByoJ8nvIaoYxQoiMQF+hq/KjdeGtQuZlNq4xYZn9F514mKOkNznsHOaz/3QeNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199015)(8676002)(36756003)(478600001)(66556008)(186003)(6486002)(66946007)(6916009)(6506007)(86362001)(26005)(66476007)(4326008)(41300700001)(8936002)(6666004)(83380400001)(38100700002)(5660300002)(6512007)(1076003)(316002)(2906002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UxW4cDM8YFctoEOdHe0y+rDOgHoPoI1cl7mysWhfw5SuIfpj6jvAObN/y4JP?=
 =?us-ascii?Q?fG10GPEYz/N14PIF2VOKEniyyXLQxwQM7zFD3vBXUyUI8Ul6yokCT2Ij0KQk?=
 =?us-ascii?Q?kl4M7nCM7xIjsv+UUAtHNpTPDAOHFiuBnHM8M8YyHYZN+VBX3Vm/zdmAXXDp?=
 =?us-ascii?Q?7E+KWT4vjlYvgOOISh3XETUPCZPd2bQ2BN7Gn/Z2PSw69dN4Q3NdOimzgP74?=
 =?us-ascii?Q?muY5RGkmEvLq2YBnXQ13uCHKHoDc7gSM6HnaB+Z6sYQm7tID4vGPt1Xmr9vH?=
 =?us-ascii?Q?4Is0pYS0be6rA/XNukv/c2hvynMwmfNA0DPqRE8W+N7qtAu74jszZwaqPgqZ?=
 =?us-ascii?Q?1Qr2nQfIUwQOP5iY6nHloSPpS9En94pZMZHyRFiVync4vj7lTlIP5uivWhMT?=
 =?us-ascii?Q?egp4QR0OogN6RZc4XoYCWGcOa9RIQxjA+zvqL4BW79xtkycYeJQL2qhVKlcd?=
 =?us-ascii?Q?/dLf5rEGu3frxr6NBz+aaLuti25v2t8TS8l+trmP1k29EuAhK+gADztgm93D?=
 =?us-ascii?Q?3678o67yhWLfuurDpgNu2OyFzXKerFyrtQEbCa2Yev6Fh7YJxwTuADIM85pZ?=
 =?us-ascii?Q?yxyovjzU6c6Nnpai+/l411R3IeL3kAnn4JVAcUmhfkbcHXUaz9R0xsspdtTL?=
 =?us-ascii?Q?9+CX5a3N6XCMgomoBarck0+To3aFNa2PE0smvEhHVfLah7daHyFREoSfPuVC?=
 =?us-ascii?Q?X1SCqifOCTqWm1y7udtjr0Wa2Z77RvdR3AeeEVaUvZ5gNgSTofhRweUCjuLm?=
 =?us-ascii?Q?qkbhUIuddTNWk5woL9O2GW6X2IoHh1EjgDC1xEQ7TQ6cErkxGONT7Akmu53d?=
 =?us-ascii?Q?XK4Khv0HXm5Oj8fo7C+KiPrvdqOGp2YxGEBBTPLl/q04VbpTIW7/gnAH0SDj?=
 =?us-ascii?Q?/7qliU8bFlXEmpuBqVmD1z+2dNwHlory5LPJU3uYYgKDLEvjcDmvZ/J383vI?=
 =?us-ascii?Q?0WUK4IXDfPxklsTQH9IDz4NeQ9+fZWgqFhiBOfnujPFo79OZrRd8opIez/4q?=
 =?us-ascii?Q?PlMZG5pDofyEUjst0+9x5j+mwlZdP1QN6IT6Hjdk3LTVgVTunto/3OzjoBh7?=
 =?us-ascii?Q?SOvkoPJNVGhB4AiKGnHGOZGiHkZPPeQwzF+xX5u3UuOuX8WXqcRvT6za9mkD?=
 =?us-ascii?Q?ry2CoM2UBGyFO/WBFAr8XjB1fmF8JicCnbG4EDISlxGHc3FyjYow5D4suJ2G?=
 =?us-ascii?Q?lR8G5I8hsxWMZRA57FAY7IhbI7y1nVTe9mSZrFUM1n3fVzGN7bCtJnNkGZ6K?=
 =?us-ascii?Q?R+75cRNJmtAL7rKELeQJxgub19HhJjV1JzznXFx7biuZWRYB4dbkGUehwndr?=
 =?us-ascii?Q?RU7aOrKS+vJMB3D6tBIZmSRs6wPSaYsCvngaF/cWofhXbCuHqn+I6b8/ljPr?=
 =?us-ascii?Q?QQfpXIBm/2FWmZIkchkr8wTd11DZopD2HiCQ0je7EMsbN/ibtug90Yiqyyb8?=
 =?us-ascii?Q?Cl0E/0ppaZquM4WbpbBkiz43RKCNW0SS3cX5k958nd37M0oMKmXVzUG42D/P?=
 =?us-ascii?Q?rHjYL7Lc2MN7eYN81dsQsQ2FKArZflAj3yufOKo9tSmtgB7e3+F8+KhYENjp?=
 =?us-ascii?Q?f+MTCEbUZRXDeoipYPD6s+IOIJN+pO4TMEvpQAwjUVVN2+SHaje2HLq3rOos?=
 =?us-ascii?Q?0g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9e854bd-868c-4ad9-cc58-08da9b06928c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 12:49:35.9499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sDTjVBjeHAGLm+HdfAU47xm+jBm4n8YQZ6i3mznqsQ/80ji8Cq9H3/TV/quul3IXbwmkt4HhMrZDCspskNoUfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5784
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_04,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 mlxlogscore=914
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209200076
X-Proofpoint-GUID: yuHJnfKikoE8V9ZVVxG_0Y2FgArJSBS6
X-Proofpoint-ORIG-GUID: yuHJnfKikoE8V9ZVVxG_0Y2FgArJSBS6
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: kaixuxia <xiakaixu1987@gmail.com>

commit 93597ae8dac0149b5c00b787cba6bf7ba213e666 upstream.

When target_ip exists in xfs_rename(), the xfs_dir_replace() call may
need to hold the AGF lock to allocate more blocks, and then invoking
the xfs_droplink() call to hold AGI lock to drop target_ip onto the
unlinked list, so we get the lock order AGF->AGI. This would break the
ordering constraint on AGI and AGF locking - inode allocation locks
the AGI, then can allocate a new extent for new inodes, locking the
AGF after the AGI.

In this patch we check whether the replace operation need more
blocks firstly. If so, acquire the agi lock firstly to preserve
locking order(AGI/AGF). Actually, the locking order problem only
occurs when we are locking the AGI/AGF of the same AG. For multiple
AGs the AGI lock will be released after the transaction committed.

Signed-off-by: kaixuxia <kaixuxia@tencent.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: reword the comment]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2.h    |  2 ++
 fs/xfs/libxfs/xfs_dir2_sf.c | 28 +++++++++++++++++++++++-----
 fs/xfs/xfs_inode.c          | 17 +++++++++++++++++
 3 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index f54244779492..01b1722333a9 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -124,6 +124,8 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
 				xfs_extlen_t tot);
+extern bool xfs_dir2_sf_replace_needblock(struct xfs_inode *dp,
+				xfs_ino_t inum);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
 				xfs_extlen_t tot);
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index ae16ca7c422a..90eff6c2de7e 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -944,6 +944,27 @@ xfs_dir2_sf_removename(
 	return 0;
 }
 
+/*
+ * Check whether the sf dir replace operation need more blocks.
+ */
+bool
+xfs_dir2_sf_replace_needblock(
+	struct xfs_inode	*dp,
+	xfs_ino_t		inum)
+{
+	int			newsize;
+	struct xfs_dir2_sf_hdr	*sfp;
+
+	if (dp->i_d.di_format != XFS_DINODE_FMT_LOCAL)
+		return false;
+
+	sfp = (struct xfs_dir2_sf_hdr *)dp->i_df.if_u1.if_data;
+	newsize = dp->i_df.if_bytes + (sfp->count + 1) * XFS_INO64_DIFF;
+
+	return inum > XFS_DIR2_MAX_SHORT_INUM &&
+	       sfp->i8count == 0 && newsize > XFS_IFORK_DSIZE(dp);
+}
+
 /*
  * Replace the inode number of an entry in a shortform directory.
  */
@@ -980,17 +1001,14 @@ xfs_dir2_sf_replace(
 	 */
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && sfp->i8count == 0) {
 		int	error;			/* error return value */
-		int	newsize;		/* new inode size */
 
-		newsize = dp->i_df.if_bytes + (sfp->count + 1) * XFS_INO64_DIFF;
 		/*
 		 * Won't fit as shortform, convert to block then do replace.
 		 */
-		if (newsize > XFS_IFORK_DSIZE(dp)) {
+		if (xfs_dir2_sf_replace_needblock(dp, args->inumber)) {
 			error = xfs_dir2_sf_to_block(args);
-			if (error) {
+			if (error)
 				return error;
-			}
 			return xfs_dir2_block_replace(args);
 		}
 		/*
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7a9048c4c2f9..8990be13a16c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3215,6 +3215,7 @@ xfs_rename(
 	struct xfs_trans	*tp;
 	struct xfs_inode	*wip = NULL;		/* whiteout inode */
 	struct xfs_inode	*inodes[__XFS_SORT_INODES];
+	struct xfs_buf		*agibp;
 	int			num_inodes = __XFS_SORT_INODES;
 	bool			new_parent = (src_dp != target_dp);
 	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
@@ -3379,6 +3380,22 @@ xfs_rename(
 		 * In case there is already an entry with the same
 		 * name at the destination directory, remove it first.
 		 */
+
+		/*
+		 * Check whether the replace operation will need to allocate
+		 * blocks.  This happens when the shortform directory lacks
+		 * space and we have to convert it to a block format directory.
+		 * When more blocks are necessary, we must lock the AGI first
+		 * to preserve locking order (AGI -> AGF).
+		 */
+		if (xfs_dir2_sf_replace_needblock(target_dp, src_ip->i_ino)) {
+			error = xfs_read_agi(mp, tp,
+					XFS_INO_TO_AGNO(mp, target_ip->i_ino),
+					&agibp);
+			if (error)
+				goto out_trans_cancel;
+		}
+
 		error = xfs_dir_replace(tp, target_dp, target_name,
 					src_ip->i_ino, spaceres);
 		if (error)
-- 
2.35.1

