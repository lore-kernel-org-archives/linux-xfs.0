Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C65C43334
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 09:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiFKJmU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Jun 2022 05:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232333AbiFKJmR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jun 2022 05:42:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B70ADF61
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 02:42:13 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25B3Bj2M022581
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=iCIavo70sMafFKiT1pCjGAsMcTbl1AaiMh24xvs23HI=;
 b=cSxNHfKY7RwLpSg5TGNPaM2hxREMG/s9U0razthfJj4yGAWwMU3oLpwI//mYRff9bByA
 lJsJ0XoJ5Ayj/YjU3RHNqul8p5AzbWVGVZSrtc1+bGetIt3pSXxzOXwM6ynA0pW+upyb
 tgyDSLYnbmehSkMbySnFbVOHNialD5EUXp257zO/3MgljQ36JTQq77MrKf9hqorqA9QY
 0dTrBxf1tanmn+YjVkShpjpGqLWeGWmKSwqsz1108UU2l9cwOyLZcTCgrf3fyrahzqGE
 x0un0S1j9IYt2FJ9ZTJPpaozsnHAEfYQishT0AESU9ezMZxEqalewqNzdKVFz+7SEi0C ig== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmjx98am0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:12 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25B9ZMQ8025527
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:11 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2046.outbound.protection.outlook.com [104.47.56.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gmhg6urjp-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EYLM40L0j+jO/bYmaSmBtGRyUt+8g+ir/AzaESOE+PcAMhK1yrJVulNi7Yhh9oYCMjNzPIbviVmfLzFY4yFxGBLRgcO5fKU20WkpQooAD5GilSRMYZyFwDa49Q7btVBimkrXiOAvoXtcoMMKeEmRFxlVK0yUgMpBJbaZzm3hA3ZDnjdR6mqEVBtBLpBM6EVuQ4u7h+bfzhSP4XjccclM3ngAwP3IQ3/3539iAqYp73XwjDbQJOcAlfUrj9hRxRmKEJ4PreTawm6WCNrKArO8/eGOhCsJjEfnje9Nm5YzSH4RKCPSo65Y838QjAzflbde7tU8rhohJxXWkgeH0rxQrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iCIavo70sMafFKiT1pCjGAsMcTbl1AaiMh24xvs23HI=;
 b=gwEmt6B7VEf/jy+UbfBW9vX/tJh5KKuq/O/Kje2mqaocYfTnwkmgHke6a89D46xp3wPPLwMUNbWGM5z/R2W+gerVb310g9h5/8fMUBmbz1ZrNC12AsfuFNeFvmXqGu4o5UupVlknQWC+FtNJDftPWqFZRUz+oeRxDcge1aTwCwiPB2Ks5+MNjIuW/TF7m5JQ96laPaah1EgIquHYK07uLCn7Asx6FutvPtVlKeETh0xGNKZ7Yb1uGalR+9ngdxHu2LJvLhAhOmnguicRCe1fXsdzkqswiemVCG/BLsDbHT2ytp8TCjgi2I2L6mEK4xhxwu2DbxEa49DMt1H0GDYh4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iCIavo70sMafFKiT1pCjGAsMcTbl1AaiMh24xvs23HI=;
 b=n8WNRuLc9NExrCtlVWvSgOHB94FVZYpi+KYtpAQ+H4Yp7HS5U3rdf8WQS9XZ3nQ7dP7fz3IdiDUb7O0YgPiMp99AnD5wXvO/xw9D/6s8Fc1eszx2cwFXeyr+21vEB8zh4PKUyDywjGH9j37v1sAuU/Jj5OIiBGi0I8UskoFh9W0=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4606.namprd10.prod.outlook.com (2603:10b6:a03:2da::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Sat, 11 Jun
 2022 09:42:07 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94%7]) with mapi id 15.20.5332.013; Sat, 11 Jun 2022
 09:42:07 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 03/17] xfs: get directory offset when adding directory name
Date:   Sat, 11 Jun 2022 02:41:46 -0700
Message-Id: <20220611094200.129502-4-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: da624411-3617-4931-ed14-08da4b8ea5fe
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4606:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4606DE7B2F52FE7EE9C55B9495A99@SJ0PR10MB4606.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m0+FM7wMJsQ88kviZ+mWqxWRN+sUlQcfkCBBfVjzjDToAvSQ/mSE4vwY0vEw8UxHd1Xr/ICIl+GEhEzjzdk7CoKTmAdbl0V8AokjY0K/+yoWjj28HltuUFIFK+eWV3zNHQrqbOEcOcV+RAzdtkq/wFJEAAHeC00AweJz/jyzOnDG+vTIhEp1uqPrzYSzp2rwqLXPYd8WT1wYdA4lAxyqxxbgK2psmWt8MvSp4gBLVrBKSGvJ17LW/Z/BYHGxYTteMBRN/55ywsYCHnYCKuuM4C3Wg252Tb3tP3K0tnZ/MDPNPuvAct0MW0mpbgq9Xibf1Q7Wpj39fxGKFcTA/h/XYtr2gmO+c9chaIVlNnluusYhoFifc1t9ZGnjxdZ8wLYLQq5rDNcEF1qCx4xYQL7EsN31VHPX7DXpqSswbjRrgwrMdOS705q8TSmMKkAixp5Aj3xBH+XLyZ40NsAdv8C5ZUDnAS0U0pDE0+Tsy5E9Z63N8rEC+zgwYgAm19o3GaxnYvwfTVAu5VlHz7fLuFcffzJz3pwUe7AclRoXeYWE77clcQeI/5lsZixHO9QmEt028OnM8VhMTgMp16uuAwdMIv9CgRvwF/BaszyJi2peERZRFmYrJJujmKrrVySSqs5Ycb5lJBCS6cukxqc+eSdrYSCJkEzZROSdudrbfC8Ox7o+FXNhB+MkR2qSnKsFJESOkNVgB0w11MHcTd3lwd7PVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(6486002)(44832011)(86362001)(2906002)(186003)(83380400001)(36756003)(66946007)(66556008)(66476007)(8676002)(5660300002)(508600001)(8936002)(6916009)(316002)(2616005)(6666004)(6506007)(52116002)(6512007)(26005)(1076003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3Kn+R7R7efHJASMFzWnCMHBCTX7oMXdsSDeSSqnt91pK5mU7m9EpZOg03kdm?=
 =?us-ascii?Q?ri5iXdijY0JJWR6V/BT5MTPDdZBZ+zcHAdRdbYhWOVWIUAe+3DvDlzaq0GQF?=
 =?us-ascii?Q?yTFgsk4FPu/4JjLFENe2iVfqzpiMxfkmSqGVNjGzVjq3dF4UbBtUULC7iUkb?=
 =?us-ascii?Q?aWYn4GNw78+VinA4000zc9dx2eLazmcb2ZhUMlsvWiOzCrJt6nZHHRZg2/ya?=
 =?us-ascii?Q?QMK5Y1QI/tVQugEV0W4/MpPQ+hxSlL1qsjKBu1nDD8RjwSgZt8ZH3voLfvHT?=
 =?us-ascii?Q?FDUxLcNKk2QRlqYNThHJaQ4f4/RYQQIGItuhFabAmJjE0NHgZ6dKAVSQp9bt?=
 =?us-ascii?Q?AEbiesTzsRgUPWI5bhppMwPpEv35bgugW1BGLX6a5IPmwkisefz0EfIQkBU8?=
 =?us-ascii?Q?qYEKi0kZVfWnaYa/obNqq2/IR95twH/vpneGE4nhd/xuMs3maD63rzukoM51?=
 =?us-ascii?Q?E25P0BzsuC4IxrtO3YwGSWBRZ0hMzn/cVmwTdPTi4soaAFH4Er4qv8gyAe9L?=
 =?us-ascii?Q?kMY+4VjgIq+TqdcNerADCCb7Yjr5bsLxypwt9mi+nsihgKgv53CTsxDSMIKo?=
 =?us-ascii?Q?djJ6dBRwP2s05yIrya7/mQx3mvZuCr5QE9WI+y+6iylY7xLKiKV8n1BvXbdd?=
 =?us-ascii?Q?ywJ6l9Ud+nnnvnRSy6jOSDKOPKwZVFgRH5kxt8SwXW7DAo9YhPMpH16hL5uR?=
 =?us-ascii?Q?iF+lDbeQFfh3Z8qLu4toysf2gIyy3nxlt/6oA2kxa32JcRLtx4Q1E46dMiXA?=
 =?us-ascii?Q?tFVlGuggyAuOsLU7oxA6KOoDMyy5CEpDYVr6J921gvWz0dLVReSiV0ip+Fkw?=
 =?us-ascii?Q?tTrMV8lN/VN7MONcEYPnUoIT4DZLLv/cdueIldumSJnQkep+FRhQKqE0QlFR?=
 =?us-ascii?Q?roPM4TXuN81RJKsiU9GhmDo1/El2auhoR1rQayzcysBDpYnkZW8d6aN5X95p?=
 =?us-ascii?Q?GC3oFRZl0JFEztMewRsRwfBtooobSXwath0JGoR9m+XDQcdZ4FXgDH0IJ+sw?=
 =?us-ascii?Q?xfnTRGnDuekF9BDrepkbfvas5VByyeXN1zgFINeXEO0mmJSzA8F+Xsr7qXrI?=
 =?us-ascii?Q?PjSvFRsn7RtJPyBr0Sut2240JEuCBfhwwLKltgbxiLSh7Q+nS9CQ+t7B8V/O?=
 =?us-ascii?Q?4T9VdAwrjaR/k7eRwSiIP0ySmlmkVNFntnVRgkOrsupbCsFsf8dHM19mY3tv?=
 =?us-ascii?Q?C1PddS5tWw5vvkYEjZZSJj3r1M+FJqAiZ3nyQS3Zn36arS5Ta4IYl18UwpSn?=
 =?us-ascii?Q?L5Ub5u31ueLOqOGPlsURaQ7Qp5KhFciQeMKPvLcY5pCL+7279abB5VaBfU3+?=
 =?us-ascii?Q?Y3x5YuKeeh1yfP1nARGzVHpJ+7LNun/+SSTiEpyz+l3ZIqbdePb4pBwcVN6z?=
 =?us-ascii?Q?hqOjNpthxbhMb7KLIjzmAQBYAHVn1M09VtyZKs9jPO1TCZ64GOBAPuDPfcSk?=
 =?us-ascii?Q?4X27B8Flvk+ZHePay7MG+LODAW2tZct60RW0BYvn5296UaAr9UOYG8ehyLV8?=
 =?us-ascii?Q?ZSxgfN2JPOfhVX690Mt8JzYYlAlU5k6zKUinbcfF96sI9HZjCrPVi8IPk/Iq?=
 =?us-ascii?Q?y3AtUh9/h+Ly1nofNCQRHtULYeSHeW/RzItJcy0yDnRDyvtmMqZKivFFVnNZ?=
 =?us-ascii?Q?YWO7JpNChQGMwVkUS3RYYRQyAQGmQZKvOs6XQGq67Tw/Jnev/wLmkJACcYyy?=
 =?us-ascii?Q?qshik0vega+TRnHCWNP6I8LkWd7MYDqvJGvLHR3j4wJFQAeh1lFlcNF+DQYP?=
 =?us-ascii?Q?qW8RVgbnKWwoFoOB9OAas3tcK2ciFcM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da624411-3617-4931-ed14-08da4b8ea5fe
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2022 09:42:06.9827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vEnHuZX94ZmQNJ2dXcxh17IjQfM0N+7Uc/id2JnCao8hvaVcwm7tgTduBIDMN1R82dsSNDoz6W+G75q5k210RppGWEREUPnTY3b+nN/0OD4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4606
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-11_04:2022-06-09,2022-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206110038
X-Proofpoint-ORIG-GUID: 5XJ1VX2WEMLol0luxWnrZzuddYLWiaPA
X-Proofpoint-GUID: 5XJ1VX2WEMLol0luxWnrZzuddYLWiaPA
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Return the directory offset information when adding an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_create,
xfs_symlink, xfs_link and xfs_rename.

[dchinner: forward ported and cleaned up]
[dchinner: no s-o-b from Mark]
[bfoster: rebased, use args->geo in dir code]
[achender: rebased, chaged __uint32_t to xfs_dir2_dataptr_t]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
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
index d33b7686a0b3..e07eeecbe8a9 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -79,6 +79,7 @@ typedef struct xfs_da_args {
 	int		rmtvaluelen2;	/* remote attr value length in bytes */
 	uint32_t	op_flags;	/* operation flags */
 	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
+	xfs_dir2_dataptr_t offset;	/* OUT: offset in directory */
 } xfs_da_args_t;
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 3cd51fa3837b..f7f7fa79593f 100644
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
index b6df3c34b26a..4d1c2570b833 100644
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
index df0869bba275..85869f604960 100644
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
index d9b66306a9a7..bd0c2f963545 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -865,6 +865,8 @@ xfs_dir2_leaf_addname(
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
index 5a97a87eaa20..c6c06e8ab54b 100644
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
index 23b93403a330..05be02f6f62b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1052,7 +1052,7 @@ xfs_create(
 	unlock_dp_on_error = false;
 
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
-					resblks - XFS_IALLOC_SPACE_RES(mp));
+				   resblks - XFS_IALLOC_SPACE_RES(mp), NULL);
 	if (error) {
 		ASSERT(error != -ENOSPC);
 		goto out_trans_cancel;
@@ -1275,7 +1275,7 @@ xfs_link(
 	}
 
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-				   resblks);
+				   resblks, NULL);
 	if (error)
 		goto error_return;
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
@@ -3294,7 +3294,7 @@ xfs_rename(
 		 * to account for the ".." reference from the new entry.
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
-					   src_ip->i_ino, spaceres);
+					   src_ip->i_ino, spaceres, NULL);
 		if (error)
 			goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 18f71fc90dd0..c8b252fa98ff 100644
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

