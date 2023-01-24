Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC748C54E94
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 01:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbjAXBgh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232062AbjAXBgg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2023 20:36:36 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B598111EBD
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 17:36:33 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O053AT020438
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=qaNGI5HY7M26yc6xXQ6HQ5L8rSDjtUAzjw+adU2Iewk=;
 b=aIyaIFk/TPi4Lf5QzeuE1Yphbc2rjTHXQ9T/m/4O3hsf6ywAlazEQjx5RgwUfM96tbvq
 5XuHR6L111ZemdijdEsQ1lPcpH+BL5r3iwGc84jLWkwiIz3wiVCnFzbtAhAKVPNjNjt1
 RsDnLPoCMk93TnBD/oy21WczKmMrE6ZpREp0Q97uvdDk5WKFOEwLih4IGvFxj9Z/BzTR
 gthVhWI8NXMVGNcqx6eILBApVqvUQfSpfqLw5a/Nb8nKDLWU4yan57lZJqLXabd8R6+j
 zl2AmlnNXWXZ2aYVuI7iWP2HtDQMQph39jVO25CyFxh4vz+N8uQb/m91tkxysbXz7vY/ fw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86ybcbhq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:33 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30O1OHnf011678
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:32 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g3tmp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OG4ESDMHsSN65dp/V2C2mIG2eSRmE/OM1D9xJW49mkbTWGtAoVFed/ut7EVNs/t6UX0/DW+XsTIlEXKGYuLxHYv39Y18dFdmFr3dQoKL7u6VVDY089fEcElS23nJdY5Z4KrsOh6lN+zXGADpjRgWHQJ1VqSdVsOtWjdHyOdIFX0rTbATr6D0+lVfV7Xo9HkxB/qyy9njGC0zuGNkE0cTE+SVONSJMiXrhDtweofTkqaUlfIRGLlbnZs83OUjxqVsAHs6FjqRzBENWbffjHriZ6Ny7JZxi5OB5HlZwYc0TPDOZwG67toYfnROd6dx9BPmKeJYbs81HRPN+GSex+5qOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qaNGI5HY7M26yc6xXQ6HQ5L8rSDjtUAzjw+adU2Iewk=;
 b=kprl8F1JFNcBgNhPtaX/PMj1pr/ys1p6XNXhNCwNVb4LeMK1sxc6SIfn5a1wRGqcT7ZYP9GsbBRfkBYn6a7SLy3Eqlgcq4YkEFzv5cqMiPS7rIg+oKsg8F2RkNNp3zNrkXmtJA5hbibkX/Wsrjl6Kkx6EKKPi9HJkRAjnDIUjiXgO/1pjaiFQvE9/rgbVXpTmyEIpP4ooum3tym8Xy2+BarnrjDUcCswZzHSoMOOFiQDf4VZPs7avvxTIQPGVOi4GoKCG+Ob/uW/jGcxVe/GKkUVFAPrjUIAUB/Vy0XDfZaL38qrPMp8wL0Oiw/bGX715M08+VILfH6Sdt+T8b/KuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qaNGI5HY7M26yc6xXQ6HQ5L8rSDjtUAzjw+adU2Iewk=;
 b=bIFVuuKwaYlaJNV69SyamJR5vX1mfXs9jEFhpqnfbHiDdWntAp4EO6EYjdVlYskqMPweOqqj1ix5Di1ryd/1ZYgmJSx+NUbNU1YkP64pUi3eDecG13e/eTPtWjXidLKv1ScDJZnRX40EC2ZYjR0o7quSpMd5HvrwVNZYBEcJSLw=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CH0PR10MB5052.namprd10.prod.outlook.com (2603:10b6:610:de::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.16; Tue, 24 Jan
 2023 01:36:30 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 01:36:30 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 05/27] xfs: Hold inode locks in xfs_trans_alloc_dir
Date:   Mon, 23 Jan 2023 18:35:58 -0700
Message-Id: <20230124013620.1089319-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124013620.1089319-1-allison.henderson@oracle.com>
References: <20230124013620.1089319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0008.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|CH0PR10MB5052:EE_
X-MS-Office365-Filtering-Correlation-Id: e63f887c-dd38-461a-47f9-08dafdab6b2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ac5CecpJ3xQ99gBB2SBKWEbGJlDVvLmp2s+Gf7H+tb+6T/eo/GVAwWwNob0gatgcX0tI+vHcbOarVvX6+toERLEn6V6q6GcXRJZV70dDvtVOpPFIGqZ2LXJ/ZzMoThx0CFGX1BzXOOLg0FG58ybspcSv6Sa0jmhNsQpuG9JxnPBBAJrlWwqUpEbk+nacz4Ky/PSCLlnX0YXL85KP9mwwadtP06iherfgxkIWbVEiFKbw9aTLMGTKNtGr8hjRRQ10LJ9nlBAV26VhYKX5SEnMwajEaU5ke+EIToR3/wcDi2EepjGkTcnWrGG+9lxOYaYcMbm5XNcgogFqCTxCBR/W/Rhui5CTz/QIe3yMAKJBxTeHUXuALIH3E12yisDUopQ7DnlogmyrjDKAr3v43yUgIMnHwPyvuZCsIkZV9ODFnYgaCYlbXppuz7rjcu3tLSmvE9dJb/HbEY1SeDN89OQ4wEvF4iPX6ntlTJsgCEvJPZjvwchib2R0HsoGaJ86hWEigA6ZU08Rg6ZMX4xXBF3/blpiuMRRePS9gJlF7g6KUukvw+RzDM6Gq5qPtCE48jUYIIDWY7XOUO3pEc/Xt9XFsk895y332P4Mw+gcB6Qn9WYDWwI5Uc15TNrMy8GZB7Ge/3Q4Rc42Lc5AURR2Fa1gcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(136003)(376002)(346002)(396003)(451199015)(1076003)(83380400001)(2616005)(86362001)(38100700002)(36756003)(6916009)(8676002)(66476007)(66946007)(66556008)(9686003)(5660300002)(2906002)(41300700001)(8936002)(6666004)(6486002)(478600001)(186003)(6512007)(26005)(6506007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HyS9mtbwXYy4ugCVKG/3RGYp2/FvABQMcfqZVVKSPBt1ikXL530bjIahlKR3?=
 =?us-ascii?Q?utSnXFns3tY3zBzf6Msd7auKUhnYRFG4laFboB80xDc+W4Xolbv74tNYXY2O?=
 =?us-ascii?Q?R+lOFSvUb6Tku/hTbW98MrsPWfNt5tUA9uXxSBVEXp6dOplf6EtsKCceKmjl?=
 =?us-ascii?Q?kN5rMwkgs88o+hqO4IWKkIuJqQAjgWKTPE5CttqCvPUg8ar7T6Q8gISns9A6?=
 =?us-ascii?Q?nO81UCsN0IdtZ7zOkuDhUkv62s8Fj/joPRFU02XLlwYaGbgBxNKeC1qC5bvT?=
 =?us-ascii?Q?kdN05Z3G72/AdJVfs2bxzrCCAjHJidPBscvuGqp/25j8yhJKOPklWp9UY79Q?=
 =?us-ascii?Q?d2tJa7Y+gmd7BEYb/S2VdyaDGVCU75q+mIsFYAHpHk7vWrzyboptgvhF6SKb?=
 =?us-ascii?Q?Cf2/aWh8BqlONkf72sZlF5pbEFFVqynZxApoZrtJzGh6dPUieUTpcEXqupGR?=
 =?us-ascii?Q?VSVci3tcm+7klC3ObivZlIuOvdJ1q2I+5ZlH7TOsPwAuKWEM1qNUSCjIs/LV?=
 =?us-ascii?Q?g7kMO3QNLhBQ49xifsphU867PDHJfH0RZmmRT4pmf+nLLc+BtRiJbkzIZDqH?=
 =?us-ascii?Q?chkAQ+uTW/9OhoaowXHCSaJ3lYmE+KPpxvk1fDvsAg0sCHNbWPh3MKSVHY7f?=
 =?us-ascii?Q?xN0M4afJ5MzPCMuSni0TWeNu+nhhJ1IQ2xHCWasnD0OAJ70QHoYePUUu88Yv?=
 =?us-ascii?Q?jRKG57A8ukler4FMMMrFSXPYIbbD0mdpKRtcMLuTSbWtjMf0rDgrPIgFIYv6?=
 =?us-ascii?Q?deU90avFBK/O9UNeOLAdWlQY6yu54CPGGmFW5sem1Hf9Y7yvmdWAH4OD85g1?=
 =?us-ascii?Q?t7InNvYASmJH1MYjne2CtfsvyahrAVNaWv3Iurd6/MWbXcMBDbX5Bk3wSBoC?=
 =?us-ascii?Q?M6tZImKc3iVo/O8u5Y4rJ7C5pEAb00mKj8u/rcV3srJUO/ZxNzsj0X/0076r?=
 =?us-ascii?Q?+JBrC+3mSIXxy3mOJCuxFX2u86FxvkLEqPOhjnmDje6pa5TetXHsN42aeGmU?=
 =?us-ascii?Q?T93SBq1BVTmLeS4Heo5DqXzEMi45R0WMOAdKu3jNwn3AHzo/0WVBYcv8piim?=
 =?us-ascii?Q?sHRDklHfCT3pwux92VdjxzCt+/4wJeKTXWXZdJR7wqzp1QXxnUAMphNlKpT+?=
 =?us-ascii?Q?5l3UgQy6UAva4WDLBK8/tbLGq5/ce2G2W0yNzgFDU8NIxbXDdFvNOxRrZqcG?=
 =?us-ascii?Q?DwKai69VtKOsM2IQCG96+lT6aScKrVZWJNKgEUoS9Rr/bpqhQyXUXwhaNyGm?=
 =?us-ascii?Q?YWeIZTuqAGTdQqzmwEUqq/7+mHkg9qI8LWMp+wkUeJDdtNCBbbxzGMUSwZQk?=
 =?us-ascii?Q?bUQj4w6Ynzo1qyF8h0bU6K6o3+wtAUrwcarhaF3GabqQ8FwRZHpBXt/GfHI0?=
 =?us-ascii?Q?44M1coUf9DowMl6OrN6A7UAaWzQ1MsMosG8Q2PxmNvJuSeX2A2/uKObn95JO?=
 =?us-ascii?Q?rRilvdor1vXWQYf8eqVh3HvwMtJDIgFXNrYIUasJvqeUfb/LJ+l6J4yEBLVr?=
 =?us-ascii?Q?zvfZOAM6Zyc9TKsJOvD05+H+5efMA+D98v7zcUI4Hk4IIuABVIzh7i5srGXh?=
 =?us-ascii?Q?9dbatZvILViQxZ3eREZdRI++tzBzHR2zKNdFdWxDuFZc/MRgEsoZNsmY8SaB?=
 =?us-ascii?Q?DQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: MhIwlbWqQEcQJkQo87nSxaxBI4TKYKOPBjtRzWQIlER5kOM10WmagKGCp67VCupjAF+nWikoKs3RQTFUE6jAekLrHhsWIZKLEhw+DEbCy7sSNebnxY5WzYeTHpeL2Md1s+pYm+W5xJTPCOo0ySBCRKRRctbiaWuQF6vqR2Kwl3u4q+12SEXU+b+xPM7cIpTFbyq108W3wj5UHX38YAzh5oQwjfCBj5o14qlNk5Z5WfYPNDBr+Dd/kNzs8Z+cqAMSHwX2JKUwNCSvQvTMCCNaCd/ogj3TOQbbvN1OtkIqjGuYmRYv0RQ5QFAjlrMYT00uo7tfDIBqGpoJ9tnwCTHHqczWgp89PSXHPj3bEhEV9DsvUllSEPlHyUqgcDG67y8JH5HrmLlJHMn1C7lUPw1uz+b0TeJ9aLgAbDJFdICf6kxjRGC0y1cJtjt0ksQmaWISVYfJAUUVt+bNxPZ5B+IolpF7RYg9KsyxwAqAtYpaXEAutRINZDlbTkXkmM3OeT6sgGwmOv1EnlWxlnihrtUVZK7sighTxuU9STXi1Zko9BZnVBtuKRwp1DasYWK/Ab0Cnu6U0jba45Ge2GqLqa3lrDuEDqm57LZR1UjU7c8Mqv1BM6KfyUm4Dbechpy9eTFs2dAz/1aoIfN3U+7CwmZ7A0AMCaqj1s7x5FgqgOfOGvQD6iljN5MmeEbBa+oNbblRKVFmDTWi6iKyOMJ+Wm5wAmEE6fHZieY8eZmzmrJI8ub8Mpx1Bi8EdNGfXoKdrtehudh99T0ybX2PlAdOTl7EVA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e63f887c-dd38-461a-47f9-08dafdab6b2c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:36:30.7967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6UPLa+8pCH0NaoKykaeu4l4F3kL/FHXcZFiWvkaSfOY5/LL7yw9fQkA9othXKl3teUX9QHS+3bZp9QmMRzySTtFTclmpasWgrk66prn6kds=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5052
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240010
X-Proofpoint-GUID: QlTI_s3aa2SLA-83wTtItRo2Uakw2suG
X-Proofpoint-ORIG-GUID: QlTI_s3aa2SLA-83wTtItRo2Uakw2suG
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Modify xfs_trans_alloc_dir to hold locks after return.  Caller will be
responsible for manual unlock.  We will need this later to hold locks
across parent pointer operations

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_inode.c | 14 ++++++++++++--
 fs/xfs/xfs_trans.c |  9 +++++++--
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 772e3f105b7b..e292688ee608 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1279,10 +1279,15 @@ xfs_link(
 	if (xfs_has_wsync(mp) || xfs_has_dirsync(mp))
 		xfs_trans_set_sync(tp);
 
-	return xfs_trans_commit(tp);
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
+	xfs_iunlock(sip, XFS_ILOCK_EXCL);
+	return error;
 
  error_return:
 	xfs_trans_cancel(tp);
+	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
+	xfs_iunlock(sip, XFS_ILOCK_EXCL);
  std_return:
 	if (error == -ENOSPC && nospace_error)
 		error = nospace_error;
@@ -2518,15 +2523,20 @@ xfs_remove(
 
 	error = xfs_trans_commit(tp);
 	if (error)
-		goto std_return;
+		goto out_unlock;
 
 	if (is_dir && xfs_inode_is_filestream(ip))
 		xfs_filestream_deassociate(ip);
 
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
 	xfs_trans_cancel(tp);
+ out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
  std_return:
 	return error;
 }
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 7bd16fbff534..43f4b0943f49 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1356,6 +1356,8 @@ xfs_trans_alloc_ichange(
  * The caller must ensure that the on-disk dquots attached to this inode have
  * already been allocated and initialized.  The ILOCKs will be dropped when the
  * transaction is committed or cancelled.
+ *
+ * Caller is responsible for unlocking the inodes manually upon return
  */
 int
 xfs_trans_alloc_dir(
@@ -1386,8 +1388,8 @@ xfs_trans_alloc_dir(
 
 	xfs_lock_two_inodes(dp, XFS_ILOCK_EXCL, ip, XFS_ILOCK_EXCL);
 
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, dp, 0);
+	xfs_trans_ijoin(tp, ip, 0);
 
 	error = xfs_qm_dqattach_locked(dp, false);
 	if (error) {
@@ -1410,6 +1412,9 @@ xfs_trans_alloc_dir(
 	if (error == -EDQUOT || error == -ENOSPC) {
 		if (!retried) {
 			xfs_trans_cancel(tp);
+			xfs_iunlock(dp, XFS_ILOCK_EXCL);
+			if (dp != ip)
+				xfs_iunlock(ip, XFS_ILOCK_EXCL);
 			xfs_blockgc_free_quota(dp, 0);
 			retried = true;
 			goto retry;
-- 
2.25.1

