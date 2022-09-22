Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E260C6FA8B
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Sep 2022 05:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbiIVFpZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Sep 2022 01:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbiIVFpR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2022 01:45:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC46785A3
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2022 22:45:14 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28M3E6iS022056
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=75F0GBSCcsoBxEqRQy9ZBoY/EFflVzrrKZ7oaTHQfoI=;
 b=ahgxO7nA+LJ4DdqcKMMbUJW7fo9IKREl9Ba253GLv73FCs0hJuUOKJKKex2RK9VZmYSL
 e3kY+iRE3GfyNEx+L92krFKA4eeiIMZCxGLTb+SACgO3wXd4qNeJxNLP5w+gBw+upwcC
 N8Io6DKvc6is2MIhBs3F60DTv0BOhs7NCi5/z4De5Aot/lf9Qq7m2K1QUKQXW5EFpH85
 Qo8wpAExBq5LBl2pvc13QkZ07Uf7VskXpa09wCCHxEk5XAb21XV1YKmyqOFsqqhdKujA
 kVX+qBmVS8Ack7A+nPlkl/gzDHygwGJTHpvyCS6TnitQDIoxQD9N6BQtrevijKD9d9jm iw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn688kv4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:13 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M5alQ0017418
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:12 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2043.outbound.protection.outlook.com [104.47.51.43])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3cavk5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nllohHB4KEnZCaEF3IVBUkxfs+0VLXtAw0xTQzwV1eSGjdPNfVmxBuqhTpNboPhSAveOrw1Prdbj12Wzk9wNYoUDTINsnEzyvhCFCtf/WE565i1YVzlqbH9h/7nuTsZhg/umb4punOacTlAvsqVn/sk5VXZGD0SaIN4m48/sKkPMujDXpHVMCN+f97KASPpTWmyKDjsNs5Kh0P6D4l8BVbdFZQ86RsKnd00+ts1PmvfUxnFL4Ft0WAXVl2dZL1b8oYIdUKOZPeaXGh1wm2WNotU2pTX61F/UUWHtE0g1kcMRQsV71blGZQX0yjW/iODsSXNa+PotGfySwSqqhZS8Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=75F0GBSCcsoBxEqRQy9ZBoY/EFflVzrrKZ7oaTHQfoI=;
 b=N7UK+nQSLAWQrK6kgPtdiUsda7EeR8AMiOqG0U9gV/Jwgzo5BdwXniKIBwO3xmH/4S9e729fIZchm7owYSLJTRtyLwjfqLYpxiRHLDOIp3q4NM8Et2qF0VH0XKlVNajJdg/IEr7yH+5/BLmX1Gvofp88ZWe6iS/alX1F24tlQAewzL4N9ltAsGgkhTOkbFp2zNnnG9PYH0Bhf6Mx2q/lQJ9wk3XOgWZebYcem3NKR5wT4S7ERfMe+SEfMzfhekDTErt6IRDtt+tNrDkINVuLiEjWgrAoUAJ8EbYGsvb87RDghpDn5qcPOGq7EVw87mWMWbVTLVZy7OVIfpvGsJGFyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=75F0GBSCcsoBxEqRQy9ZBoY/EFflVzrrKZ7oaTHQfoI=;
 b=ZHV0NhlTXRq5aGCoSgi5K9J0TWVY4dN93eiU/XsjydW8HNqz3W/FCrlwLW0HFq/8yt1oPuyzHauiaywUKXlr9jO0XPYmHpL8A4sF+cnj7CtfEIRuTc+HU9MeDyMgA3OgNF1zfKVj8bt6nEVwRBPCM9crQN1NV134Po73DrSbVHA=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4806.namprd10.prod.outlook.com (2603:10b6:510:3a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 05:45:10 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 05:45:10 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 06/26] xfs: Expose init_xattrs in xfs_create_tmpfile
Date:   Wed, 21 Sep 2022 22:44:38 -0700
Message-Id: <20220922054458.40826-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922054458.40826-1-allison.henderson@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0166.namprd05.prod.outlook.com
 (2603:10b6:a03:339::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4806:EE_
X-MS-Office365-Filtering-Correlation-Id: 5885726a-ee8d-4413-59cd-08da9c5d9d0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jawBroxdxNqWwCU1vfFVWYezR7Xg3dczXlKg5PASFnp9xCqiK46HUY7v4HAkgmYCduioljyANbiPHgQHG51YLb7C5Pu9dUPEbIYli/sT9f+cA27HhFEqGE4gyS86TRDriQIeCVW9X91pighe4k9oECx59aXF7AKwY3g1IqoyJqN6GYH3SG0LG5JM3Oig7Wa5+tKB2b5YC/8lds/V2E+NXOcz352iU2pL5XWQ4i2mOoW05vYe41HSwwzCP5yRejrRE9VSJgV5T/nIvKkG8DGyH9mHIsZX0vuIfFZIC/CJsYGnSbqVP+L4lpmpsTvx6Xj0DJfl7OXNj7wdqqZ20UkEQvBliEIsCvGncR6QppmSeB8eEz63nZX1AkTVxQblLX+HPuNNzL3idZF6OfTIJYD2VhAPABE7Wsg9MBoJbzKE4wVLB9dJ2ch72h16wF9I32IYeUPTiMPckKdQGuwWqLqijw4O/JQiYLNnzdl2uiTXSyhwK4U1I5p5VpnKgbMZNk2Y92xQ8z5QOuq2yaT1DcEIm7/WDfeBalAuwQaXy6p9QZXkgvndt848RPhcYg3V9TYRMySE7w2UVOL9/HUi7xkmI6LEPH2M1+u0khfUMGXG0HDWb5Q6kYylcr7XwOy8CfTWESQo0cSVyNWnVNjNgWiIbkmrawL3PhQi9zi4Hql1LtGPhGeSDzpUc9NVkJ/2YV0WhaTXrQmA9QrOVXRfmjgxiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199015)(38100700002)(86362001)(66556008)(6916009)(66476007)(8676002)(41300700001)(66946007)(2906002)(5660300002)(316002)(8936002)(186003)(83380400001)(1076003)(2616005)(6486002)(478600001)(6512007)(36756003)(26005)(6506007)(9686003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dForJ3fN2thIBRqsThcvIdH6WYcNMscjAl9C7TGZTNxEft1JLFJys7kqDzir?=
 =?us-ascii?Q?b/Ho9T3sD8Q6Y33/mJp4mobyUxiSkWDKQ72b1ErdnSTUpeXCtupCqGRX+tJk?=
 =?us-ascii?Q?jPOMQ60wh6Xxj4XKe9toHYYFLs/Iie1kHQrSRWySYlWIV1D8ZaYzoSjjHycg?=
 =?us-ascii?Q?SlkgGXla8YwfP8zT35zuexsVtUmd9J8w4yI6Yc3Di9xm5kbzdHMIZIVr5bm9?=
 =?us-ascii?Q?NQjH09JNNEHZ0In69olVcV19yASexeiCEuaU9eSYcY2uJ1N8RDICjwRVEKmd?=
 =?us-ascii?Q?Y/L8N90/lLbwA00ToaXAmaPJLccepb+pPnTH0WNvWOjqoZ/CuYLq7OXFPITa?=
 =?us-ascii?Q?g0JXbzS6CK4nBBkKmsnCI95AIF2FmN12sWzVE0KU8V7b+iMqmQ1rBmAT8NIb?=
 =?us-ascii?Q?9gtnvg+xwOM49e7BUdPUo9ecpgIaesH1v7OUQar+q2ObBATSS/iXEww4SYec?=
 =?us-ascii?Q?Uo35glH2OsWlHgDEwtEsalEwFPrqOVX6XXd8HPnbUIIDMV79OUNMrLmVXlEi?=
 =?us-ascii?Q?7OXvj81nCgMoVk7BYzs1AtZHDhlA+ukPu+l2LQsluvuPieiu9Bu/KrwxVaTe?=
 =?us-ascii?Q?BIdijtNHgxVQZcEZYgBklBE1T1gqnocOkbXny3PFcNb5qfi3M7wmbLUh6GrX?=
 =?us-ascii?Q?I+Ya5HosmGAkg1tJdrxdKXZxvmzZVBdEOlLUqLd549zG47B29IDZpNWT5rGz?=
 =?us-ascii?Q?lLDe+tj/YuFaxvxRRxa9wGrVg7dbv+YVBIMU39GP+Iu91yWicBej3GRISXrx?=
 =?us-ascii?Q?eMbJx26u/f0elIXqduYyS1eF0GyshncLiPmyqlVKyhuke53A5YM/drVVgVgE?=
 =?us-ascii?Q?tQ1SB45cTP5kdpQPqNQjtoC+fdUd0dQIFqMD/ParoX2CVNLfxY1zJg74wlKq?=
 =?us-ascii?Q?YbKydGKff4siL2Up46bprHDTL6ksPSX0p/JdGtbwyjZM/fDNJW1/aNLNMw1s?=
 =?us-ascii?Q?gJj9VeL52EDwO3bNmIZaLXoMDY8sXnhvOzn3IEzlT3AB64SYbwmZMulv5ELI?=
 =?us-ascii?Q?0yE27wtJIkG1mazLRMzbANTGDi8NbN0MRv/7R4RHDTKLP0FF0FYXNWrL+fxY?=
 =?us-ascii?Q?gw1wGfdz1RjSZ3JrEoIqeB6w1RTEdagw1I4sdD/4HTkdXzWeO8OJezzqyGZS?=
 =?us-ascii?Q?ISw8ohsPRK1Kw8QA6OJ6IBz0PPHRu+P16iowBs4ZmJXynQSlQRWhp0tS2Cw+?=
 =?us-ascii?Q?uLze9Y+Y3pN3LtIWL4BehAVy2aO+8RQXj8QXbECuZyprxxKKTYn0mAoISWwG?=
 =?us-ascii?Q?vSxYvdleOKMXXbiwIWhyYwYUTgTPkN6TsNJpSL7Eiv7CggfCp0Gy0Ahw9t/+?=
 =?us-ascii?Q?RZVthYxUNRNT71uoYEnpJyolJynkoBKWjl9MTVk3zHrwAk6x2cQtiCBEFq5D?=
 =?us-ascii?Q?4fW+f5P69ecSO4ZSc1EnW98/gZ3FLt9yt8314i6+5oDi+AFAgrcgcvH0WdWO?=
 =?us-ascii?Q?bOwobxOKems7rHh7GW2Nnt8tWWeKgbMOtori6k8lzS15VmKGjZvnvL+wqg+7?=
 =?us-ascii?Q?laQAW9oReiKMXOexVzuWchjEtKvCH638rzMrnCehovZq29ZT0P+EK/KaCJpg?=
 =?us-ascii?Q?6xEn+dSLRnUVd6/ajiIrOihTuwql6D+4wQzcM+x8NqrVhNr9G1LtluViWdI8?=
 =?us-ascii?Q?yQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5885726a-ee8d-4413-59cd-08da9c5d9d0f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 05:45:10.8673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: faC82qbNqoKNCQyPjmw4Dd6DB4I4bG0uNX708xBZm/HLm0JM+r4+WA4Ye4QVhpgVnFcZRh2nWunNxikuz5FETfN+iKw7GkDe+sL8Za82Iuw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4806
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220037
X-Proofpoint-GUID: _1C6FYzIN-C_j0dAL-irbUpd4xsZjfq5
X-Proofpoint-ORIG-GUID: _1C6FYzIN-C_j0dAL-irbUpd4xsZjfq5
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Tmp files are used as part of rename operations and will need attr forks
initialized for parent pointers.  Expose the init_xattrs parameter to
the calling function to initialize the fork.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_inode.c | 8 +++++---
 fs/xfs/xfs_inode.h | 2 +-
 fs/xfs/xfs_iops.c  | 3 ++-
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4bfa4a1579f0..ff680de560d2 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1108,6 +1108,7 @@ xfs_create_tmpfile(
 	struct user_namespace	*mnt_userns,
 	struct xfs_inode	*dp,
 	umode_t			mode,
+	bool			init_xattrs,
 	struct xfs_inode	**ipp)
 {
 	struct xfs_mount	*mp = dp->i_mount;
@@ -1148,7 +1149,7 @@ xfs_create_tmpfile(
 	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
 	if (!error)
 		error = xfs_init_new_inode(mnt_userns, tp, dp, ino, mode,
-				0, 0, prid, false, &ip);
+				0, 0, prid, init_xattrs, &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -2726,6 +2727,7 @@ xfs_rename_alloc_whiteout(
 	struct user_namespace	*mnt_userns,
 	struct xfs_name		*src_name,
 	struct xfs_inode	*dp,
+	bool			init_xattrs,
 	struct xfs_inode	**wip)
 {
 	struct xfs_inode	*tmpfile;
@@ -2733,7 +2735,7 @@ xfs_rename_alloc_whiteout(
 	int			error;
 
 	error = xfs_create_tmpfile(mnt_userns, dp, S_IFCHR | WHITEOUT_MODE,
-				   &tmpfile);
+				   init_xattrs, &tmpfile);
 	if (error)
 		return error;
 
@@ -2797,7 +2799,7 @@ xfs_rename(
 	 */
 	if (flags & RENAME_WHITEOUT) {
 		error = xfs_rename_alloc_whiteout(mnt_userns, src_name,
-						  target_dp, &wip);
+						  target_dp, false, &wip);
 		if (error)
 			return error;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 2eaed98af814..5735de32beeb 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -478,7 +478,7 @@ int		xfs_create(struct user_namespace *mnt_userns,
 			   umode_t mode, dev_t rdev, bool need_xattr,
 			   struct xfs_inode **ipp);
 int		xfs_create_tmpfile(struct user_namespace *mnt_userns,
-			   struct xfs_inode *dp, umode_t mode,
+			   struct xfs_inode *dp, umode_t mode, bool init_xattrs,
 			   struct xfs_inode **ipp);
 int		xfs_remove(struct xfs_inode *dp, struct xfs_name *name,
 			   struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 5d670c85dcc2..07a26f4f6348 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -200,7 +200,8 @@ xfs_generic_create(
 				xfs_create_need_xattr(dir, default_acl, acl),
 				&ip);
 	} else {
-		error = xfs_create_tmpfile(mnt_userns, XFS_I(dir), mode, &ip);
+		error = xfs_create_tmpfile(mnt_userns, XFS_I(dir), mode, false,
+					   &ip);
 	}
 	if (unlikely(error))
 		goto out_free_acl;
-- 
2.25.1

