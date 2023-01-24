Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 040FDC25B50
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 01:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbjAXBgp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:36:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbjAXBgo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2023 20:36:44 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A861258F
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 17:36:43 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O04fTw022007
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=A7c/ag05lDcclOjw/wtyCnf4/2HW5521laIEYPVOD18=;
 b=XkpIZo/SexbWiRhKywTawJHeyMpox2VExJxn5iYH3GuL8BwcsujRePZKK1AOW6UQsKGj
 6gtsK5YyHyx3uWS15aKV+70/Yfhk45Peu8VsVxDttxe23w7aeRs1N3iDkUlloRM88bR3
 /F7Brs+rCIdXy/9Yv90pJSwmz5DNCZaeSzTYRzii4hVFBc54sVZPxt/5Gm1cufeKB1WK
 p9jjNxCvmSHWzRy3ZnPKiOjexgfavNmNVZjgYkt4mCEF51sEd2/vPF25TyNNo/a0/hEo
 KRiABw42Z22i6ErqO1QubAz6lc3bjCI+0hLYQ2Fp+sp/pkiD3yi9gzF54vdpeEUjkk9v cw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n88ktv8cu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:42 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NN7Vvi023238
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:41 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g4m62t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PiRk/H+wiJbSzsDL7CZjrjqgnxWHzWCIpSICajJ+tNVyEFF23RiWVfSm1do1m16blM4t4mo0Xt3tuj6dHXnQEmq3iMB3uObmCz4agUv2posTSFd6GIP6mb/GuJTFRgOxw+xPleX2mKrrrXjeqDATOHauAdT3Yrib0PSSQ3Dp5kAEi685nqtYa7CYD5D5ai+FPDiExTZg1X4DYdVl3fhnbgH2seEp9Kl8ou49pqxnp84iMZ+XMCN2u+Zu/BUdBUdKyen4UP+ydRfn30MldhwIFlLlz8n1c83egZH0Qh5E9mg+QpqNFJxp8s32CYiGmVpuyiRQvlsvpfmFHsMSgna18Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A7c/ag05lDcclOjw/wtyCnf4/2HW5521laIEYPVOD18=;
 b=Crjroehn/JgwLL/daEYe5HjKgdpYDAUNlg5p3MAZdI5qz1djMso6SBi4EW+K1ToBN+zvMnmKNBotSebhgd0tCv6mm1HCxhaMB/DFyVYGx3ELv6mrgoN8YXdXj8t9ced7eptGzmPezfA+hg53V6F+DeS32xh2LuijNLtxetgroVgFK9UzjU4Boey59JEp1fTlWP5ojOch9HJsOa4h/hSVdfnHX/jB1+IdveERvnqlPXAytYZaoTDPQMNmOn0vyb61/y0SpqPW97XKIodXf4xNX+TJjYv19WnNkzhRxhhQo2nFimn8rqkf5Sx4zwOFhSjC3NgLDJ9j8Es9w6HDJkc7pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7c/ag05lDcclOjw/wtyCnf4/2HW5521laIEYPVOD18=;
 b=OePi781dZKaiDDVLOi6k8gl5gFJSl4M7EEwUbc2WljGWl8OIha73LbkuRRV/nfWRQsfIuwmWVVzpdypVgm4bRDi3cABOt61UpwwvfUqyqhhgo5FKGMMwBR63jattm6Cemb4nfh8EDS687uT22aL8fFWYip0PpNwkVWO5kU+jD74=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BLAPR10MB5041.namprd10.prod.outlook.com (2603:10b6:208:30e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.17; Tue, 24 Jan
 2023 01:36:39 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 01:36:39 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 10/27] xfs: get directory offset when replacing a directory name
Date:   Mon, 23 Jan 2023 18:36:03 -0700
Message-Id: <20230124013620.1089319-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124013620.1089319-1-allison.henderson@oracle.com>
References: <20230124013620.1089319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0022.namprd21.prod.outlook.com
 (2603:10b6:a03:114::32) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|BLAPR10MB5041:EE_
X-MS-Office365-Filtering-Correlation-Id: b7bcd6c5-e395-408c-ff77-08dafdab7088
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GRaaFfdvvti6JMjm3+2iPFiCLmJ0S7Z/WZtA5jLSvJCjV4bGF4ryU9J4d/8y8HFtNQVkA5dZ0TZyjEwkpgtWJ8HZ+6QZHIUYLAB+tuiEQnUMpn/iQWgMGST8dgSjCNGtdzZOiHf+n2I8/5RBuwletW7etqX4mbIJi1ZQGM/w+cmO612f3LW2uG/b6zHYWpQlYXB3A/1nGuLgp0Oi/cZ/E26gLz7zlhQ3wcRMbhUSwe6unGY+ztYd5YIFbPiqgdqjoqb9wHKFdGBxVUnxTu4XMTyh0MVenAIT2pBLtUy+QSqIuxIWZWFrO0YjhHCG9pQVorsC2XOzDAltK0hKdnNsaOc/8sbPz0pqkNjOH++eYpcEXN0gBnojqxnkQhf2uX7LSibAU4S4P5/CyAv8wwgtMWIGVTCTDdRSuKHoWgYZoIqgN+X0aDdMFRnLVI/dgdoKq2TywkHnLMK6NlWp6DSgQYZJcKIk+O9S8FdHm8mYqQHxcKtA7BaVjBkLC+s4/WX4I1q7/7yFKMjPYJnx7oDaZogxiyn+tSMMNwVRQjzTcrCO9YUc4oLvwfREAqcdAIx0J587qKzUbj/Ax7Hem09FAQVPmWjMNIcfAT350Cjk5A9it9USC28jZ97bw63k9d97bBvHas9FoYTznUhUeCy5dg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(366004)(39860400002)(136003)(451199015)(6486002)(478600001)(6666004)(26005)(6506007)(9686003)(6512007)(186003)(2616005)(38100700002)(1076003)(316002)(86362001)(6916009)(41300700001)(83380400001)(8676002)(66946007)(66556008)(36756003)(66476007)(8936002)(5660300002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uiJQgY77oArrJXe5R1BbBvTRz8+rufikMax+y2YigF5A9X/fVztnhZksPCYG?=
 =?us-ascii?Q?pE7/noUzkFafuDXfLw3Ke8A1O6sdhLVqR/EXeC5NTi+i0YY7Ilf5ZEzwSrUN?=
 =?us-ascii?Q?A79E8r5ybA5eJLL9/hA/mTTBHYaj67g56v1U3vPg7SQNGTYqrpvbCLs9j68E?=
 =?us-ascii?Q?5zT4fZuzzTbPXUZbQ/6gWqxB07fYX88QQG3Jyp6SjqjmHAvRsRJ7LBR7kIqr?=
 =?us-ascii?Q?GlLp3yxiccRbngkivw/L0RqqQziovpGc8qPIoc8LEO6r5bmA/IKNuH6TinM6?=
 =?us-ascii?Q?f0JAjlDR/oFV4Tg5dBVv/flkfseXAPj6nggWHQCN+pA2VzzpcZO5ZxXxAlik?=
 =?us-ascii?Q?FcMrtK4fGiBSQvqvYYZj2IWz0ZEhRFFvYXxwnaTwrqaM/up/tWkd5jWu0VlB?=
 =?us-ascii?Q?U0L2PaVm6RSF01fZ1L48XZIv6dZmpKAoD25BviMWmJliqMdjManq9fP/g1xU?=
 =?us-ascii?Q?6WbtD+1VogAL7iGhnOEJ/39NbS6a5KfGxaS01aZRPXG8EBUlAqBfb77WmMZh?=
 =?us-ascii?Q?2aQt3RjPGyW9VXr4v91XZR4jQuOZtpX9nKfPsudlqKsSHstIRZd2p9eqQ2LW?=
 =?us-ascii?Q?u5Iny7PBd+wdPKZeViDLTUo4gzV4BdO5KZFLekfT2AtWsyxnX1Z19A80H2Bz?=
 =?us-ascii?Q?cVHWBxMXiysQ+yLJUv2lpqTJji+zrqwV8aBJUPOc6LiXPSKo4ISJdOjkAKJF?=
 =?us-ascii?Q?E27iiFvb0k3UJstoyeP1q3nitQLCniKEsnYlws5kOJx0xMP1x33YiVP1obIk?=
 =?us-ascii?Q?r53I8NEVTfJ6INMaJf7myDG6+2O9HunFPpkwPz6gBfAaoy9JkfTgRG6vBFiG?=
 =?us-ascii?Q?z7QZ0y5e7X61km0M87Tp/yJ/VI0EUUHo9QrOXCTdBMoJNK2oirqPwxL0PajY?=
 =?us-ascii?Q?WjxcmoYaRYZR7ri/4yz0jx5H5Uf43vZclpjhYwEw2h4opGxkxxFsWzZabnlm?=
 =?us-ascii?Q?05/gX0GskdWayXc4Spj2P5t0aWW/axAAmfz6K7LSPIdr7VUGNfbqceTm3W8u?=
 =?us-ascii?Q?RpSU5hFqmJvz7XejTaL/7YWRxElRtYAU9xq0DY/3BV1ziqf1GuHs4yDf2cZA?=
 =?us-ascii?Q?DvxusDu+hJaHK2CcVtDCCK6mVQNOjNxuMqY6bTNHjbBljanaElZs22Qqykt6?=
 =?us-ascii?Q?xKYy3c5zdtoKvY+OpmvufIjyRKBsN4HcH+WE0ZCONIv7BvyrdPhGM3gXstdr?=
 =?us-ascii?Q?VtsVGneN1KiCojUZqHQtzGNbzDtjkwLMajSeAwlT2nrnOyR1qnonpba3fGvG?=
 =?us-ascii?Q?HzAMrn2oyF4/8VL+w1ftNp4hVfUlZKK5IkkhQmY0BPC7wueIQEuq8VZr/vvt?=
 =?us-ascii?Q?jr1xLygAPglCRJoNk5kZLR3mkH6QXKeyS7OsNDFaVIXLu41vhBOphpEzPYzS?=
 =?us-ascii?Q?md1Ni4tNYaMA71/9evKND0gaGkDBgEjWEUBBO0IfFCGOTRRTmRw5XHyJoWm2?=
 =?us-ascii?Q?EkoyREYjNBeERK3jdypR1WONPLG0K4LbwqNg5xCC+YPbw+kFkk9eU7U9rpPT?=
 =?us-ascii?Q?K9NvbygxBVICVZlRO8xhVKCwWGoubJ15UYTLAhAUXGG53bzcpYUrv9wFfiqF?=
 =?us-ascii?Q?UyAvcU1p/JfoWA8tYGHcTBvc06e8vgoD9qYNz9ia7SohGRHt/tzPM4HC/3vJ?=
 =?us-ascii?Q?aA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: NH7ms6XOrFsxyKi43/cRt9he6V7woioy/JmlcqSxJWRqxyISGEILs7nHLia7wzGkkG8IIaoNesBRTLkPjMM9j5/0/O9PawaIhy3hvG+ivqA0pL1PhzuKpWkLAT5CkFGHrKbIsRYPUEkdCBRvXZDT624RlyuwLiZkSC4q/8/uX+jsWZiqQYVowv+yapQoDTEMZnCg9abaRd281JUsJxvlTD+gVQeK3uDQ6cuBZYwZ4fYbb06Um3uDXT0QULrFqBWGw01HkBojfA9brWay2joSW7iAdOk+DqCWKv7kNsz7Y1J6COrn/bVxrxrPsQ4ohBhcENQ9eKZfGrAY2OOd7DzwjDc6bYNBiVI2x1IPmR3hmGFiJPBF8uhUnCeiWZqBKhAiyoe6ZkoYFf5C2nXhVSGAEze78iBU+ugxtlpg4oLfSlI0rN9LwIaX7LNbjlgPRCQvse26Kg7+/Jh29cTkMkSiR3K77dwR4JKu40c94hqWbhZ+Ailgw9RA4113NDpQXFWLRPQyiaStoXKdt4H3favoW+qljwtwNbeTk4XoGu84e4plwxWDIsz3Wnq6/deEhZ4dN5pY4Ru8xGom9IHExLQEcsvUwueHPGcZEj1eTBYqSH3UsPX0ZmFtiPe15P/BQ9z9gpHt8Wt/dix41Dh8ICEszqiz2K8HF7gk87FbhuZoE6yA7b/jJVeidUVo7sTykDKPQ/iBpC5nEu1tTbNvqNWU4MCNvwjOWu4fFm9XQvF3DDQS3kUA0nNeauEXFnEPTp9ZpNxiM4TIbp0IQjqufQLw1g==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7bcd6c5-e395-408c-ff77-08dafdab7088
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:36:39.7013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tkYcwXs8JDgj5/An8Hinmj8r6LOmYsA9Xop2P2jDOiSfkGrC08amfa2/QMqTr8JBWCVE63A9jY+8OTkKe4/GKiqmgZQxbBUNyvWw2JOTz3A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5041
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=986 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301240010
X-Proofpoint-GUID: BA2siAKOzW9QS11aQHXUUuNHWdhqEfYA
X-Proofpoint-ORIG-GUID: BA2siAKOzW9QS11aQHXUUuNHWdhqEfYA
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Return the directory offset information when replacing an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_rename.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.c       |  8 ++++++--
 fs/xfs/libxfs/xfs_dir2.h       |  2 +-
 fs/xfs/libxfs/xfs_dir2_block.c |  4 ++--
 fs/xfs/libxfs/xfs_dir2_leaf.c  |  1 +
 fs/xfs/libxfs/xfs_dir2_node.c  |  1 +
 fs/xfs/libxfs/xfs_dir2_sf.c    |  2 ++
 fs/xfs/xfs_inode.c             | 16 ++++++++--------
 7 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 891c1f701f53..c1a9394d7478 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -482,7 +482,7 @@ xfs_dir_removename(
 	else
 		rval = xfs_dir2_node_removename(args);
 out_free:
-	if (offset)
+	if (!rval && offset)
 		*offset = args->offset;
 
 	kmem_free(args);
@@ -498,7 +498,8 @@ xfs_dir_replace(
 	struct xfs_inode	*dp,
 	const struct xfs_name	*name,		/* name of entry to replace */
 	xfs_ino_t		inum,		/* new inode number */
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -546,6 +547,9 @@ xfs_dir_replace(
 	else
 		rval = xfs_dir2_node_replace(args);
 out_free:
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 0c2d7c0af78f..ff59f009d1fd 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -50,7 +50,7 @@ extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot, xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name);
 
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index d36f3f1491da..0f3a03e87278 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -885,9 +885,9 @@ xfs_dir2_block_replace(
 	/*
 	 * Point to the data entry we need to change.
 	 */
+	args->offset = be32_to_cpu(blp[ent].address);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-			xfs_dir2_dataptr_to_off(args->geo,
-						be32_to_cpu(blp[ent].address)));
+			xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	ASSERT(be64_to_cpu(dep->inumber) != args->inumber);
 	/*
 	 * Change the inode number to the new value.
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index b4a066259d97..fe75ffadace9 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1523,6 +1523,7 @@ xfs_dir2_leaf_replace(
 	/*
 	 * Point to the data entry.
 	 */
+	args->offset = be32_to_cpu(lep->address);
 	dep = (xfs_dir2_data_entry_t *)
 	      ((char *)dbp->b_addr +
 	       xfs_dir2_dataptr_to_off(args->geo, be32_to_cpu(lep->address)));
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 39cbdeafa0f6..53cd0d5d94f7 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -2242,6 +2242,7 @@ xfs_dir2_node_replace(
 		hdr = state->extrablk.bp->b_addr;
 		ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 		       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
+		args->offset = be32_to_cpu(leafhdr.ents[blk->index].address);
 		dep = (xfs_dir2_data_entry_t *)
 		      ((char *)hdr +
 		       xfs_dir2_dataptr_to_off(args->geo,
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index b49578a547b3..032c65804610 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -1107,6 +1107,8 @@ xfs_dir2_sf_replace(
 				xfs_dir2_sf_put_ino(mp, sfp, sfep,
 						args->inumber);
 				xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+				args->offset = xfs_dir2_byte_to_dataptr(
+						  xfs_dir2_sf_get_offset(sfep));
 				break;
 			}
 		}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e5ed8bdef9fe..a896ee4c9680 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2489,7 +2489,7 @@ xfs_remove(
 		 */
 		if (dp->i_ino != tp->t_mountp->m_sb.sb_rootino) {
 			error = xfs_dir_replace(tp, ip, &xfs_name_dotdot,
-					tp->t_mountp->m_sb.sb_rootino, 0);
+					tp->t_mountp->m_sb.sb_rootino, 0, NULL);
 			if (error)
 				goto out_trans_cancel;
 		}
@@ -2644,12 +2644,12 @@ xfs_cross_rename(
 	int		dp2_flags = 0;
 
 	/* Swap inode number for dirent in first parent */
-	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres);
+	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres, NULL);
 	if (error)
 		goto out_trans_abort;
 
 	/* Swap inode number for dirent in second parent */
-	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres);
+	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres, NULL);
 	if (error)
 		goto out_trans_abort;
 
@@ -2663,7 +2663,7 @@ xfs_cross_rename(
 
 		if (S_ISDIR(VFS_I(ip2)->i_mode)) {
 			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
-						dp1->i_ino, spaceres);
+						dp1->i_ino, spaceres, NULL);
 			if (error)
 				goto out_trans_abort;
 
@@ -2687,7 +2687,7 @@ xfs_cross_rename(
 
 		if (S_ISDIR(VFS_I(ip1)->i_mode)) {
 			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
-						dp2->i_ino, spaceres);
+						dp2->i_ino, spaceres, NULL);
 			if (error)
 				goto out_trans_abort;
 
@@ -3022,7 +3022,7 @@ xfs_rename(
 		 * name at the destination directory, remove it first.
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino, spaceres);
+					src_ip->i_ino, spaceres, NULL);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3056,7 +3056,7 @@ xfs_rename(
 		 * directory.
 		 */
 		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
-					target_dp->i_ino, spaceres);
+					target_dp->i_ino, spaceres, NULL);
 		ASSERT(error != -EEXIST);
 		if (error)
 			goto out_trans_cancel;
@@ -3095,7 +3095,7 @@ xfs_rename(
 	 */
 	if (wip)
 		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
-					spaceres);
+					spaceres, NULL);
 	else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
 					   spaceres, NULL);
-- 
2.25.1

