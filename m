Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 426ADC4167B
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 21:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236875AbiK2VNp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:13:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237062AbiK2VNF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 16:13:05 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6A33F05D
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:13:02 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATInY7t013730
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=jgaeSVBpfLZ5tpE2EGcsPuiA7Eik8N9G0mV8zxjPoCs=;
 b=XHw7jF+ClEGtD1evx5r6DDmCBJlt6DAE5sIFcpuYfzEeM6RfQsY9JzAoEFa5BUwdvixF
 vrc303s3+rhvmlsmZTgaZnpxVar0yGbrXS2uEPOgX/bXNXv43B2cJ4oorJFZUCpjZzLc
 5AMnE9C3xgOt8ZiR/vfKFzjdGf4dM1WqG/VkTvIYPkd15yeM1wDz1zlVmqsxllggAJtO
 tzwzV2YyU1Q8B6dEghFPbzWz1o+1rMh5NkrBPt5BTZo41DHFs6OL2SO2BgEZkdbUVgpm
 zxCqV+tQc/E8y7wq4rRTdJRmUHCCE0FRyK4veLJkDdrVefV5IYwk8vNDkhAzh1nTxxRd Aw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m3adt88a8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:01 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ATKTJB1027964
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:00 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m3987w8nt-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MDkHZgi7KM1T8coc1aecWD9XhcD8T2mU9IljBYAh2iIRM24joK9iU7S2WwDr59bNPicQbC+FvD49nCz52qq5cb3QOYx7nMEWv69roUi90r4pGXAFIjKAwqGlr9YoaKK0610xS1LVha8NGNCpqsiQtiwPPVRPctfCyy7ywvq3RXg/AhQIeH2zJg4dZ8R5H7SV3OHkHT/HATTy5MRtSleT3S4g2xnIqKhkRLSnZ4lD7sk6Z+QWRcx/tp+n329tff77Mm+mdmJRLfK1wcZ/hOZgj26kWWLbQ8OkMHnlOsNryzR3BcvzbeULcM/BJfuUhj1qBmuJDE9kfNHohn99IxAPiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jgaeSVBpfLZ5tpE2EGcsPuiA7Eik8N9G0mV8zxjPoCs=;
 b=K42nd8ce6uLmhvl52pnjxQkCRhHBbU/KPBbONJ08bBgtbbibPb0TEaHuppkZnbDZyoIwM6uSuGgIfYM92c0CLWBj33FZd2ZOO2Jw/WW2yq/Q2g3LqKcBBA/B7+gMBXznoB4k+mUF2hIxfwPlwH15Yu0i+L+TL+EwwRZgFobB8Wo/kWOq682bUDfA1OHgQpOCowQeMC7Mn1dSl0VJG8PVE7Frx4mj5ThNTbrOSG+4RbQUIiANPhKwJTGb+Z1yUdklyXy5Ua3QX/fO6dYKdhgI0sjbGxwRqxLhai4bqqkiuETDP0X5z0GWmuHvVV4gaipsMCsKTIqEpeaRIkhhct2zkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jgaeSVBpfLZ5tpE2EGcsPuiA7Eik8N9G0mV8zxjPoCs=;
 b=F6n9fuAhAVfM4ba7U62A309GoJlnERFEIb/RV0YqMMgVDsu/QcbHnMwIIRAz0q2bHcwRlE7jIGDeMOy8QRzeZcO7XdSXm8ZNbfDFN+BrSBR9R6Io7QDGxm9Bu0Myo7joCPSiRM0jAlFI7DjInMYl+wnf/fFjFSxQ5CX0jWwEuRM=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM4PR10MB6205.namprd10.prod.outlook.com (2603:10b6:8:88::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Tue, 29 Nov 2022 21:12:55 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 21:12:55 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 07/27] xfs: Expose init_xattrs in xfs_create_tmpfile
Date:   Tue, 29 Nov 2022 14:12:22 -0700
Message-Id: <20221129211242.2689855-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129211242.2689855-1-allison.henderson@oracle.com>
References: <20221129211242.2689855-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0015.namprd04.prod.outlook.com
 (2603:10b6:a03:40::28) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|DM4PR10MB6205:EE_
X-MS-Office365-Filtering-Correlation-Id: b254f0f0-0685-444b-c2f1-08dad24e7be4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EQSyjmqJ1/RVFONz6R1ALYEqEa6imlNQqBkLGGzFWcNMWqNHVCNehLhfCVsdMzR7oi+2Md6B33JKUYu2hD1IHe5+t0VtCJJoeCYpLaYBmQQ2JHCXpCv7w04QqTNG+YtySN1LHQKvy1EWjU9HNHZ3vvOSQeM15v7LAIZq6/LZrwTPco6OFzcd0lURN8G9V7+x+ZcHR9VNCCppHwM30UOVDKmU08uBmBVqja2SjNyG5F/ulwyB+8dgYvHzBa98BErB6trv9crRgv6yjsM/rwSVMOzQ3AMhMEHJh+wD60hu8CFQ+AkdHdzXeEfm7w1teV6qNeYBSVlzpcSu3NSPg4Q+RzdZbGbmsUwGv1xnYnYaZIj9dP7M2KO65bRmD668A8sNx2mc+LZKp9PIKDTLkPPv5L3X8jdVhOcSfuvSIxJwhOznWx4br54BJ48YptlV5eyusJYC7cbz/WcJACyLWaYUs5cIzbtgnbd5wbKAh5zG+gvX2F1/GOkmSaWPqTbINFiTHlRwWEFbBXR0KGgq/e3R6sWIi4kWqYJKp2fNH330WQpMWVfLk4gR1Sly5JDVu4jkqZ6yf2HCBHy5Cls6eDj0mrIkBj6Nk2OR2rxW/6/rQySlmC+tgIVQiwIj2k4N3Mcb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(136003)(376002)(39860400002)(366004)(451199015)(316002)(36756003)(83380400001)(6486002)(6916009)(1076003)(2616005)(186003)(2906002)(41300700001)(66556008)(66946007)(8676002)(66476007)(86362001)(8936002)(38100700002)(6512007)(5660300002)(9686003)(26005)(6666004)(6506007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BIpJNtkt3jiCv/p4stnnQpQ+Q9jA2EzdBGfZw4z0W5xJEeO/mW0n3u0D1Vhs?=
 =?us-ascii?Q?HUALcum7A5siGtCHfy/WufZldBR8GGAXc8oF72oHu9PaMJPWJtOvptlOZTws?=
 =?us-ascii?Q?a/zvojaKuwnTKf9p4NXbFEogw5lo26IpOXG3t6i731PHm7ULscvaf+7dyI3P?=
 =?us-ascii?Q?uNM4SAW+2kaF1izxjAWNFvstcFeoTV/HavoHBQLYTkJvuafvUSvqO+i5N5Su?=
 =?us-ascii?Q?4k2TbJ9d2O5GwtwVRtBv+mDLBljAmCdTZ21OONXf9lc5A+7FAS1GAxAQttmO?=
 =?us-ascii?Q?JW4nrsHJLgbHzG6Vh3ke9fGJ7C/sU3CjTMVBuaHdSWTiXUes6I9AhGZhcT+B?=
 =?us-ascii?Q?gHIxFiadRNKD3xuExLEo1Y+hm024dZOISAZK+B6q3TH2uQJxXnFciBGItb93?=
 =?us-ascii?Q?amu4nMhlX2UzzKWwhPFhMjXAu+AUv/YJkDKAAnNVshiGmC7S9mtzFntn1ifF?=
 =?us-ascii?Q?64C2xIyWwb+IWyewT3MXwMjyvPhDZ76aBKLevo3NMA6YLTqyTc4NWmH5D1ew?=
 =?us-ascii?Q?TFORBLOOWecjCVIKHsbcWxGDcemOn2FmrLgz7yFOZ8wzVbVjOHWT3LLoDhvX?=
 =?us-ascii?Q?3csfsVHrED2NaodJeKjSb+NKpMXadIndEc6T4DZ3+qEhthrWRzp5UpRaoA6E?=
 =?us-ascii?Q?PimAAfXs+wy5YSC6HSlLXP5cZbwM+3k2WSZR+kCGH5NUVBVPmaZ14VT1P68s?=
 =?us-ascii?Q?p6VfISsdJ2YyTUJ1UeEpwaDPAhvbGv3QOEOGPTV1NjH4gTZc0FS8dbEAXYo6?=
 =?us-ascii?Q?QP/eQYl0rQQBz5VS0HmhqTY/vF14XHtnKVBJYhH9534ha20ZN6kCkJ3CQtNI?=
 =?us-ascii?Q?r5tFRMfvNAQznhlfqoeMDhpsdShzaDTWa2c4IlsdbkjqeQHlRpKDt+vFSp+p?=
 =?us-ascii?Q?iTP9G7OlAZrw0wZcieRIdHG7DgU02V4alJQF5d3d98H64S61iRQKbp1Gn2tl?=
 =?us-ascii?Q?siFT8YfpGSYzdzjRMnii79wZahpTG2q3UkBNQ2vKfDTm/AhmE6XerXO8CvyA?=
 =?us-ascii?Q?wuuzPUzOBE/wwm4RcDv7W3P0jWrMmYoJCiyzj/nQMVRfFsCJFUOmMmt/101F?=
 =?us-ascii?Q?vLYCZqdE/uQ3QaqPT7QN2n0Z/uovF3Rwci9MFQzgcHSbMYPpYVZU1muniILL?=
 =?us-ascii?Q?0MHi+KkbHc0gOCU/8DzqF2RVzTS3ZTGPw5xW/yN67Oz5ZYpgVkqlu8YpKM9X?=
 =?us-ascii?Q?C9HfYsIpVoAifeJbtTC3eZTj6SHoFFKJllm80O8gOELs5YpTYsss2y2Qhgls?=
 =?us-ascii?Q?skVUayFoc/7g2PwVukgvby7ql9wxX15DJO4OtJECPHxmbTQc8gkn2nwno+Ol?=
 =?us-ascii?Q?j8OslevOzqPvy2QhY5fYCgBh8D1cxXAd+cU3TvAwnd94kz+vVEihy+PtQ06I?=
 =?us-ascii?Q?j5TTEhY8Z8kmjVlESPImsltiHmv0MRRq42mYEI1bf+oWHVN/Y7yqDAYb+13s?=
 =?us-ascii?Q?KwQqwD1YRpX1xaN7wq6mrwE2CwtL7AVB+/i25SzFQ0uUIisSun6HHRrWe7Y4?=
 =?us-ascii?Q?j4PRNtfMgbUZzR8MwmBYKSPO3CUmHQqanSZi46COYBVDCMsCCkFfVCCwpVXZ?=
 =?us-ascii?Q?ldEYvKGMoggP/BMFQeCZBWYFekAvPDTYIajtYOglIOILp5sNz7BH1xT+WxYg?=
 =?us-ascii?Q?jg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: /K3mNKA2bKfbTh1HlGeKquHHeAbLe0DHiHoToroNkP4PuE6JV+CsgzHroCcpn1YBRDlBNwEF5qkQbIRrQdKnBcFwJAcsbr/ItVTawpIm3b3H/9Feo57oN8A297mG/GLvLZYKoU40KgVUBVLnTidfFGP8YhsBxIidlkdDM9EEq1v0SNdbSsQ6f2LpeP+ZVxiCgWfDf3kSCud4Z9kRFrZz3gkEjg0Bu6JkteibdLCTtI6UOAM/GGYZQZ3PiKap8bQoLjGhlA4Z5funXhK0ZC+zv+0GNAYVKed9+lE3hLPqHBvt5Wcjs6Xoy5cYMQy9U7z0L/tfitLyPfPgDn0iJusMvlgtSPEva9n4TwawAYrpSeS3gL4qR515iSJElu3q+CuVwnDpj6pHJpZ19dnq86AaNkvD8e3Dco7BmQGgdQNDRRSL4KPpQBlN2WgsZbpx8v8zgoKJc3RDQNrBU53PNCvMGGehOh1pT61D+xfq0N7InNRapBvoloIc9r9c/gwCC923N1cYlm4VSzqKFk6EzNrzsUsOVPF/GukWM3SUWV/E+6SpQTrGrM8lWePoaKNB+R6PaLBL2GYcqLZ7o2xZ1XYfOFQuCJbA/IjSU5wF9wgrJPvvz9TlrL+6O8hj8nhPEJ532l+4iggs17uG2EbXuZAIKqD2PVXSObagAUGeH6VYPzqtjx1KAJoFCQSzKbREfsZyP+brrQ1p3GxaLiZGmmg8kYkYBYN5Gx1wWp+b4dG1gSruENzFpmel70aG8ZOsKSATkKAfrDcJL3PkVXgoxqovYQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b254f0f0-0685-444b-c2f1-08dad24e7be4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 21:12:55.6405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WIJIcX06oMH7EwwdwpVeDj9AjolRNUB15BvYWbD9fJcpcUp+akir8q7oK0WoX6yjtzkuv1sC+8y/YtYusn6OGIvCr8V9Ad/YvreRIj4QZu4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6205
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_12,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxscore=0 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211290125
X-Proofpoint-ORIG-GUID: jw5BkAzIsyGNp1EZ6B4K95PA8hPV8X5i
X-Proofpoint-GUID: jw5BkAzIsyGNp1EZ6B4K95PA8hPV8X5i
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Tmp files are used as part of rename operations and will need attr forks
initialized for parent pointers.  Expose the init_xattrs parameter to
the calling function to initialize the fork.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c | 5 +++--
 fs/xfs/xfs_inode.h | 2 +-
 fs/xfs/xfs_iops.c  | 3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 63e5da5bf09b..2afbe0e15500 100644
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
 
@@ -2748,7 +2749,7 @@ xfs_rename_alloc_whiteout(
 	int			error;
 
 	error = xfs_create_tmpfile(mnt_userns, dp, S_IFCHR | WHITEOUT_MODE,
-				   &tmpfile);
+				   false, &tmpfile);
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
index 2e10e1c66ad6..10a5e85f2a70 100644
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

