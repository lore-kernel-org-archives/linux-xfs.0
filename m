Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29003C678D5
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:38:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjCHWiY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:38:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbjCHWiV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:38:21 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923E262867
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:38:19 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328Jwg2C021992
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=NV1OPxdYF4wW+3kB/mlg51uZWPML14DAQgv/jsV3WQA=;
 b=pQ9GZ4aze+JeqALfskLu25H2Wf15nwkSoPYvzhIh78VkQlkBHJIsTB/DRsiYPDzhcwiF
 tbVXIHp/xeQFVyyw0WGfgc24NAd0QHc/byQ5Vs/bNH8KjpgRNXfuv2RigcfLL4+EwCs4
 k5Yvs1HAuEFhnynSaFt147/7Fz9/UtKo5XoqxipWovCS6qeCjb00whZlWtqiu7LD0Kbh
 D3GEh9NxE+8xXSKvtZ7RusZ+JAMZb/iyS7zVcebLiSzuK6Tmi/7TXSJcNxyKR1Uzctdk
 t3lGCorrgi7fudyRf3UXveOw6igaC+MuCFRX353UU5GnhJGW9MVZaWZBaS2r/ZhFb3PL Sw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p4168se05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:18 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328LVM0l015688
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:17 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6femx3av-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h5qkCwdhjgAAxnmb7tGJ68S7tTI/oZyPfyUPMUYJr7tws/ytQFwK2IJNYc0AqBc3ISvQt51dBjqeraZ4NbWon/CLfeToEAe4HbwByVeZXf9Y/oVcJs7c5PBPXuBDAAIJQzb4oalWS0wrO0G5AMOCh656WzxmbfD+7yiasY/BcjX1guKras0tC6uX5D15RAhDc0xhxm4bbD9l5vPR9hMP0PHVWQzrsTpwa0Qaxy8yVS7y91nA7sVk63YiQzctwiFKAC+Bu385T5j5oQubS4zJ4TWogVt7IOkXZ1/gwEToUR+8+OS+LQ73J5lLD9rOrhXwWn+vasjdnOphVVuKd0n9tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NV1OPxdYF4wW+3kB/mlg51uZWPML14DAQgv/jsV3WQA=;
 b=PXiJHmyS0kXD4gPsEovu1V9H9kT2tnozaG3TLc4p+ZoEUJa1Iu/jIRiyGfK+jS1ZHHLniL+UoOiJpsRRb6WIoXAFggwEhAQt9MwIf3jetqTAnA70GHj1TZIquzmXc/WnReqCfFRUs0yEGstCssSrcppfFUl5X8NdsBq+oTnV40hf/A/rzsMqTgc44B5xYN6uSPG5PTk/rBMlxUzBL2Pa/TXWAXjUmA7yYXKR12vuKo3VZrRYOisZEFsgHp9W1BKxveUbdJ81jZwDxzRBjtJQL4oovCnv9qNLUI6Kuw1SS52q5S33I4a6v8iXkBLvfOGVzVNDSTIRJWToyZM+NCRSUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NV1OPxdYF4wW+3kB/mlg51uZWPML14DAQgv/jsV3WQA=;
 b=TTfxwE1rG0DVpwL0E5LV1zS+yL/qmuSGPDwhyAyQzxL041+/sz080Oa3BVJ+4w1b8bcubuGv3VnktUwtkOaQn4/U87jI9FpoTL9d0W1mJzZ4BIm2sw7Z6xWLQN9t9dxjzExoZ8nU7uU1tSGuCGrkulJlHcKVksFnp+4YBd9gPOg=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5708.namprd10.prod.outlook.com (2603:10b6:510:146::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27; Wed, 8 Mar
 2023 22:38:11 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:38:11 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 08/32] xfs: get directory offset when adding directory name
Date:   Wed,  8 Mar 2023 15:37:30 -0700
Message-Id: <20230308223754.1455051-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308223754.1455051-1-allison.henderson@oracle.com>
References: <20230308223754.1455051-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0010.namprd04.prod.outlook.com
 (2603:10b6:a03:40::23) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB5708:EE_
X-MS-Office365-Filtering-Correlation-Id: 35e32524-b5cc-461e-2e04-08db2025cbec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NYFCMdKIkf8hDavl/rHEJWId+IE8ZjypfnU2cMSiul8vNMWl/j+1aVK9MWDBlqpzhOVGYD8tTsZRw4P486M3ySKsibVaWX+39E6xZ8h9J3L7tbKbnFNAvPg/10XqBTz+Vr+DWs1VeulSv13FzzIcb8VQpl5gMuZqx4Tm4LPavKXI9NBgODDFZ8foIlBJhppzPCdPkTrF5hwFbftK5Qz52svilM++whdtz0u6s2w34TKahylHN8b7j5gkEN7PtnPs5WtrUUXXH4M8xy9rcszYdGckzPsPbKLexqVaMYUecgoJUAxtykZ30g5mug3bwYOxCARYIfclrN8QhExXHWeAvRdhp+zeQXlV/bVwK3fItcSFzbkOfrSodTxSDlm3iJLW9RXzfu1zWg1R4glRrHEKfxeJBavlqz0Ss628UanjG60DPRYt/bSPEGJbDFpyx63vsJogIlIFcwWXcFvH4dRyrT+/fndGMQOgDCE22IssKw/57mfcfNsuHIRLafRoQObwukQn90n+pXEj6J6R/wPcqmeuWqP8gbwj8gWsIWlZWrCYqeGlOoN79mf78ACmfofFDJ2t8xB6lqoDcdnJbWQLq4CWWqY8Vv/g64AyujIcLRBCJCCbJCKjBZ9EBSPmU5k8nUk3O2T22tjiuKv4a+4hQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(136003)(39860400002)(376002)(451199018)(36756003)(6666004)(478600001)(83380400001)(6486002)(6506007)(186003)(9686003)(1076003)(2616005)(6916009)(6512007)(8936002)(66476007)(66946007)(2906002)(66556008)(41300700001)(8676002)(86362001)(5660300002)(26005)(316002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BrKpYuEk6mNuLnud/iKCvtHdkoTQvybTNEz8nz+yMm5JVRocRzEF4D0YSXZN?=
 =?us-ascii?Q?dVxO81HH6BG+zJmuazakd01BId6GtSQlCa2MszUWZWN27Edpy4AgweikTdiO?=
 =?us-ascii?Q?BhZ4bTxkkn1WJ1mnphch8T1JZYy76oJ+5CTISC41Wphup2RZx+NjS2IkZ215?=
 =?us-ascii?Q?JD+aP4uQOQ4g1L9q7EahQLtpgSxIWSJL320JvAFWJX+YjS+4OcVDdKB9sKY7?=
 =?us-ascii?Q?yjw+dhAPOqPRcLzfEdEC4AaOvUsET0V6EwWF+yUkokl6x7V+xG7a9LB3rcFp?=
 =?us-ascii?Q?wyuIUT+D/6Tx2+ngF5Qc41ShhGZiPeJHHZIj55ezseIWr2VnO+5eTVDAG5Wo?=
 =?us-ascii?Q?z3NeWO8g/qayzkU7rZL7yJ593VaD9GVVeG+Q83uSyY1im9Y6pQMVfLFss+ms?=
 =?us-ascii?Q?mXqlTZTS0VEYgbvjnhgPoCqu8zbez51NNeed/N867vInOcPZSAcgYY2UOX2/?=
 =?us-ascii?Q?da4rvP8nR/nimbkven1OCBzyEOGzwXL+8prsWJuCnDjRRDVvz+5ysqHQPfBn?=
 =?us-ascii?Q?SC+Dxr13b4s9J8SXB8kGyctYaRSCq6xfxk3Va7JOav9W1DJQ4ufQP7JR4pt+?=
 =?us-ascii?Q?8yF2zp+dj0kYOoI7tt6wnWwzAqhtztcitpH5TxTFmcSm/wG18Fnp8R4RMwVF?=
 =?us-ascii?Q?vaFmAmIkEjqS3mK+L+9sWbGRbICGWBsx3Yc938B+KDcLYEV0i+VdTucJ0SQi?=
 =?us-ascii?Q?ciDJKkHfwiDdI2I9wntF88DmrUbnaB/dLF4n+I9NqAlMtrMV8NLXE0TWDIWh?=
 =?us-ascii?Q?PH/S+FWRgpBbVFp0ltD4ZUYNd60+ww+KlQatbYmY3RbaKbEjDYDd3HtVee9u?=
 =?us-ascii?Q?N3y2jWJohlgKGFKjcWXRJxxHICC/0g1NeiCiesn83tUTSn1fZrCLBM7QnKle?=
 =?us-ascii?Q?kOgQlFokYR7KJchXet1SiObBmzeOm2oGA6EWxdnXAOChyvr2SFuPdbWQvQj1?=
 =?us-ascii?Q?PSt1kJLBn09ynCu9WNyAN6HipegGLc2IWGTD5IC5o2Q/OR+0xPjERUlkOYye?=
 =?us-ascii?Q?u2Fdqm56uqQ0vN/QZBXHIS7lhdbUHZSKozMWQuniKwM/RdjEs4SE/BtwEd0m?=
 =?us-ascii?Q?z/NmN706YmtYiZlrfJgR3EK1MxqJal9eRH7F2z1ik2keVJnUyDTFIOtXZdqq?=
 =?us-ascii?Q?6SRpfW5W6OpiKc2X+YRlBU28n/NUe6z2neZME29d2+ujVvjX3K/9vaqrAerc?=
 =?us-ascii?Q?cItvaQDKAC8Fyk1mty+c/xYEPGDLY60ryITxq12DDoj5T4VRv5yjX/zDQyG8?=
 =?us-ascii?Q?/SIvZWAQrbzLyJklWaJyLIAovPgOdZxqkxvMAflwgv2k72sEnyPuOPmfjTn9?=
 =?us-ascii?Q?YUUrrQ4RiY7wRuZo9Kg4aQgiWelGejDbCrENLLA3bMY3ALo147lPas9YWNAG?=
 =?us-ascii?Q?kV0uKU7DFjf8i5UxbhmWG5TE/vZTJcg7pxpxhaAaa9Xnf+AMWf9ZCLw0NqCW?=
 =?us-ascii?Q?6uyN6Z3Kedi/MdGByG6TbmdOwTkTdIkVtziGCxHzciab5lKZGjqeIP6+zJyx?=
 =?us-ascii?Q?vC8ZEZTA0iWBmCxg/DSLbXI+KdGgYjd+hBULoM5OhuY2uAmM1lhEwUh5qrp1?=
 =?us-ascii?Q?4PE5xhxyf3wRd6qzD8wQHAzX6svIhzNXpUbo8CvYEDri0zxpV4hpBBNBSiNP?=
 =?us-ascii?Q?8w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: eHR5/1gCHE8E5/hMIVk3u4K/uVvvSM1VyzGtycXx9i5lNPpLMkZI02ZOWQ7DUg/dnwQO7mj3CF3bW3J968BrjZJ85dJTefKkSRSyxdKoHyRgRXkZjxTaOqyUjGm7tpRGwQYQisSU/oe92zm6POGVzAqPS2xxFFjPqNQK7FqzA4I3+T5wg3ifi6gfYSWBO2q/fPAjv265qjF4zjFd72aOyhjvWde6+8PVzCmkoLV3ZOBVDmPHSPSOtEV+FEPFa8cRcY7suEMgzQakacmraJfllgsYJ/ql2mPeSLwGX8O5Q6Q6syI1UaY6cpwOXnwdTt7BJozMtMSYUIOCCQrBlyBkQRoi1TeizwGGa2OihE4XpNQf/nZa46X5uJMcPhc7O08lINCD77Lo+tNT17qqGIKfYPcliUAtBt+N4r98TCoU7e9gToCsNDolph9wXqxXrJciz8bicd8KztjOus3fb11jNO9wa1i3Cn11M/oIVabR3QnlxbNklolxMsrJz6OFj2PsFMgLxQAq+QSbZ5JVG2EUTXN2qMh5EJ4vA5qJMGP82W0gMp3pIlnq2ziuw4a4VGJUZT8re1uyOMpPk8yJuKUDP8cBbmO01zaOL6XKOnpS8tGnEzlk2uLiCAnNDVRK1lYsjsv9P9lYltsF7pGFd/6A80fU7hJXLHCIKQRLn7mtMAvkCUyyFbcpYPqVuWKI3M4rnjjOl26paz1TpUexPPSO3tPWkFNDt423p1b+cr78fWbzbvx5j17E3y+/hwvq4W9fQiXpWj9JoXcjW4tAlgOZ6w==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35e32524-b5cc-461e-2e04-08db2025cbec
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:38:11.2376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L2QRMNss/K6zQ6QPX5AZcM1hJ5g8R1xas5V6BTbRXq9Ym/64CfL9v5cnKmywmtZSBswV1xY4QbWUCqMDG0gvBWSE/64IfaG8aFycR9tiueI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5708
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303080190
X-Proofpoint-GUID: 5sXMTqYveWhomoIwqdGrXOV_hPMeLBtG
X-Proofpoint-ORIG-GUID: 5sXMTqYveWhomoIwqdGrXOV_hPMeLBtG
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Return the directory offset information when adding an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_create,
xfs_symlink, xfs_link and xfs_rename.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
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
index a4b29827603f..90b86d00258f 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -81,6 +81,7 @@ typedef struct xfs_da_args {
 	int		rmtvaluelen2;	/* remote attr value length in bytes */
 	uint32_t	op_flags;	/* operation flags */
 	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
+	xfs_dir2_dataptr_t offset;	/* OUT: offset in directory */
 } xfs_da_args_t;
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 92bac3373f1f..69a6561c22cc 100644
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
index dd39f17dd9a9..d96954478696 100644
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
index 00f960a703b2..70aeab9d2a12 100644
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
index cb9e950a911d..9ab520b66547 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -870,6 +870,8 @@ xfs_dir2_leaf_addname(
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
index 8cd37e6e9d38..44bc4ba3da8a 100644
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
index 166ad86ac938..f76e73db62da 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1038,7 +1038,7 @@ xfs_create(
 	unlock_dp_on_error = false;
 
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
-					resblks - XFS_IALLOC_SPACE_RES(mp));
+				   resblks - XFS_IALLOC_SPACE_RES(mp), NULL);
 	if (error) {
 		ASSERT(error != -ENOSPC);
 		goto out_trans_cancel;
@@ -1264,7 +1264,7 @@ xfs_link(
 	}
 
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-				   resblks);
+				   resblks, NULL);
 	if (error)
 		goto error_return;
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
@@ -3001,7 +3001,7 @@ xfs_rename(
 		 * to account for the ".." reference from the new entry.
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
-					   src_ip->i_ino, spaceres);
+					   src_ip->i_ino, spaceres, NULL);
 		if (error)
 			goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index b96d493b5903..4d5f38936a20 100644
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

