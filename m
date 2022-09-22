Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 791D7C6FA8B
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Sep 2022 05:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiIVFpf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Sep 2022 01:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiIVFp1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2022 01:45:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B03686FD3
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2022 22:45:25 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28M3EUvS005821
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=/CYAxnOcdktyV5OMMzVsfksJA3/vfaYvlJkcmepyOns=;
 b=I/fuNihwjs/+SReRq/q+qn6xKD/mS3OXvBD7qSGPLEt1hBqkWTD/5CZOVoY3NqJ9PeB5
 X5jiwcXmhWam4gFQBpfZwLzlak53g9gUfVR9LPkldV9LgKclJfuRQz+OgMav5bz+iTwI
 l1jTZComtrJjwSUP6x3nlznic0xZvHdrO6Se0XzZxunv1/PhrSt5M753peLsVLR5HjPN
 hmZcK2sAHBqII62dSLg/f3D+2PqRx+FR4CmnqvAC/i2G3kEXEEUuGm2Z9MJklD7n7Hlb
 PO31OGB26Kgdvbng0NRNklu3wYoYBBncUzcogmde7TebC88gM8fQMpg1AlnrdvWOIkrN Fw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn68mccup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:24 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M1MKG9032575
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:24 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3d46ya4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OQ2t9hAEq7mVJoIFpRSdAcToTssbjjx7ku32mz7CRMM4wUE8hjtGy/9ychpOYSEzvChS/LbpKrLkNuKHqsXm98gucaretkvhlrpWUAjqiPdZBH+ZezNSnjLud/oPyVuw7Td8NdJTv8geW9wi7mU+XLBgDkh9Swb3tmidrD3Lxn/i1V/ec78QNJGUYyCCLbEQM9Kzp5O8ON8WHMHLilZrOJPZtZh02g1jxdueA3r1LnZOoKPK1xx5+P4oPymIgq2Ko8yKbrihrkT0809zuxP9qIMJQbPuebRrJwfOzt4YjiMORKXFGy4fKMEsW66A/PRYsWI9AqUj74wTGVJkQzWoDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/CYAxnOcdktyV5OMMzVsfksJA3/vfaYvlJkcmepyOns=;
 b=kxjY5U4f2qrMp6MdzulSijl4fFElpwz9E4qW71IZeaajPYK2tQo5S8wN6iRFPPpfs9ZvdPKA1WxqRX39sdxFhq+8cAb4DxSZJ2oAEz6lO1XE9o9yUo3zXyuCSEPp1x98Zo5wdJ+WjA2yHUfXEI5DrPE3DhW39x520J0mjPQfaVONaK/X9glW/eDsFXIHhErjYhioskBREbZaP9CxLzN5kw6WBr0TYCKChPhEJJeCEk86jPa3LmeOz545x4u3smZbi8oHGXjFEByauGComgOvow/7upitAOUG7Gh9ER1if6ReHU28klyvwEKEhF1PoTGbfzKVHyGcabOUaf0fJsbbBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/CYAxnOcdktyV5OMMzVsfksJA3/vfaYvlJkcmepyOns=;
 b=ma1Sn1p+tP+1vnPrk5d34yFgNDfW3xgKPXXQJRoP0/gkG/fTVzMFi6WTa81BFDW0YZTfsjEKqUjmy+AJCyHKw8mim6701qftWx/AbJO1lIzzKSzK8e68uAEOXufNrIbQFJ+dUKmdf8dm0PAFJ9JvQ09IJYo17sFzJObkszstppI=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4806.namprd10.prod.outlook.com (2603:10b6:510:3a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 05:45:22 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 05:45:22 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 15/26] xfs: add parent attributes to link
Date:   Wed, 21 Sep 2022 22:44:47 -0700
Message-Id: <20220922054458.40826-16-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922054458.40826-1-allison.henderson@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0052.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4806:EE_
X-MS-Office365-Filtering-Correlation-Id: 848206b4-1eaa-4359-c8d9-08da9c5da425
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xPOvKuC7U1WgZtsX0zL3N4FuBe2N9k/3R+Nsdkz5ZTGpiegEMdGY19G3nbGVxZhuA9cm8R8q3+BC8NWx2EJHnNRnbBOlrfYOqoaJBU0HVA5aoI5BvXDbzpq+IhOaUUyiFIgnN7872ZBuxheHazK0R+YG451JbwhgO4YREKbl7or/MBpH03GMLpiWctJw9OYVX+nVu272xngOoVFRgWVlKe5vybpQP2cW7Ot/Orx/H5Q4AHEWGkoKi+34tUS8cFWyfJNPhDGt6w2CGBPLJCeJqXBEpmtiGeal3D6oRzCdkHEjGcGIIoCV4WTE0ZrhMvbVTBrsZ8nEZp5iy/vTQQhAQEnlYX5dZ9bKMqzGEQJqt0rjS2QxtK5TTkV3RQy6adMcwYTHYl37libBA+MyE7rg3u9KPK2zGZAkGYOKcVtN76WNx2wDEbbbPHtnXTW9uM1dt2aLqdLk9MfRrtxNwniso+RcfQhYnecRMOjnj3VCvVRrFnJfNeC/P6f89VWJoPq+BN0j238FOSM/NDJgGT+1pDEikqFtUfHLM3zCAvmCt4jLZOHfVSjVUZIN5dOJzdCEjnHDhIgi8mmWtgsY9o60mNcBorWefStEaGd4dXPWUW6cI4pagVb/+6ltWoJxbCYAWYQyf2O/wPg8TtwUhaD3/96cBnmpeNN1TfPEuQESkSrq9e4BHmfwVRjYvAprCWVmxssTcESmWRpGRqPCaGRkqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199015)(38100700002)(86362001)(66556008)(6916009)(66476007)(8676002)(41300700001)(66946007)(2906002)(5660300002)(316002)(8936002)(186003)(83380400001)(1076003)(2616005)(6486002)(478600001)(6512007)(36756003)(26005)(6506007)(9686003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J+urhQaQtahPnh6HW3XRCsKTx8nf+pT/RXeqjFjzUg95PszFB2qzNIHKGKqX?=
 =?us-ascii?Q?Hm4fNAWYOO2TSuJoRuq2FJ1MJybBFbTUydz8PCTqn8DQJHXmZFLKeOOtaucK?=
 =?us-ascii?Q?MgHiGBbkt48gEHPpETrjoUsnCJhWd2XrjcCFDizLtYBYLdSco/cXs0+wIIvM?=
 =?us-ascii?Q?AePBxsMkmPJrL7F3pJn2Wvd/+R0B6lyTCWBPDdSlH65LiemdON67y+EKo//D?=
 =?us-ascii?Q?JvgPkPrig+7/hR1FV4rNou0QEjDEHa52xg+LhJYnbH7L3QO6s5Qv/qzZ3UD6?=
 =?us-ascii?Q?+cEVysmZw3GAs1Vj20cYenmCFK23NjVAm8HtMy67koWnoJgzY4lcgPWKvdfX?=
 =?us-ascii?Q?ZfJ0cQOUjxOTSLxkWQnCtMkLQSO9GGdo1hGk12m0lK+440/6MHV+6H8Z/L2F?=
 =?us-ascii?Q?KfFxlADFNphhU4Eu0Fy2gYdNnqhzPanm2qrI06F4FG3EYKUJJ95CsFeK33Af?=
 =?us-ascii?Q?nltOu98j15c1Nb+uQDM5LLFuzQUWxaApKGVDrXrOS1D0/4Y/sdzF+HGzglry?=
 =?us-ascii?Q?DNR6m+r4dmf2ZQJVjiJaq85w75yY+k7bhRbSxuOQhtzwoVjBcwM1ZUkHNGJN?=
 =?us-ascii?Q?U1uC1w2Dm+1Kjdi/GxEbpIvDVU6r7q2/IL1mVDluKvgt+TqH7ZeCqn2YClkV?=
 =?us-ascii?Q?gw8+eG2tL4EvVWP0R8AqS1FRz+Jg9FOcRP/DSMKA2ljsUTQEsYfHT3m0mhzl?=
 =?us-ascii?Q?5aWHbqIpUkO7ceR/ccY/cvruA0NuS2+HRkJujOG93UOIz+Kk0aDivI7eQikI?=
 =?us-ascii?Q?tBhwfg1FG2RN7elA/4rAvhPv9NfNJ2T+C2X+Xb3HSu3rRmvaqxh94Z8XgTBQ?=
 =?us-ascii?Q?t7kTr4AKCxVociNs7iCEhX6KV5eAflJoRZSDhrl24I+s1m/xWvIeSuq0eeCn?=
 =?us-ascii?Q?4627wCMzVMmprE9gkcYwV6xY2kqEO4whqwLFcmKCqpdFmzrh1bIETTNfbHDj?=
 =?us-ascii?Q?QPOiemCEkeC3LnaVIVVooOTojEDPFnIjzVf/YP74/SlgzYz0FETfWqzggzow?=
 =?us-ascii?Q?eCyVhYeH9imHoZ1Cq9L6X0rr+Raor0mRLgpPXM2ei5eiW5pgGazCmZXKxPaW?=
 =?us-ascii?Q?0s/T0i8jJq7k8BGvvxW7AuRcbGds/1ew2JztjsbWswMdHk130o8t89fKG13a?=
 =?us-ascii?Q?HpuAQzQd8x2+PJfj3RR+BhXRlH+f2aw5r5QutbCHyAw2KsCAD+rvg/vEomrp?=
 =?us-ascii?Q?fM5wWR0tz6Y2OMyTqAkEulYIBXn2Os19CJ1uNBdlgiX8BExHZv7wLk84EoxE?=
 =?us-ascii?Q?lBcVV9+PcJu8XjssFzfBGPYme9ttyLFd88VtVIaMP3BK9BAGYbFefJulkEy1?=
 =?us-ascii?Q?pt174ZW6W/P3vio4sI6rLKXCxjik67ptHR63F0OKQ1CZJVGjEBKi00dv+ukQ?=
 =?us-ascii?Q?mHMY1FPjnLg0JyisIcEol4+oNdvulYFRavlaIc/wBYLOjiZnkXGGoCYKtjZt?=
 =?us-ascii?Q?SJpRxZaIGGvJjB775xFDJGqUggquT3HQHIFH/QEaFcBBB32XICl/Sq/9nkNx?=
 =?us-ascii?Q?bE1i36O7tM155L//nKy8U6zajaYvEVXNlsyx1OOjwgpDcmQE3+brohuqhseu?=
 =?us-ascii?Q?qDO0qgyMmRjeazNEqHCUb9TEj27IC2J/GIMGDialiE/UUudxpCEBPO9h0F+K?=
 =?us-ascii?Q?Rg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 848206b4-1eaa-4359-c8d9-08da9c5da425
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 05:45:22.6645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GvLdQQG41ZVXYuFMAFvXeCRLdJaQ0onSs6xPCb4yg69/KWuAVUdL0ZhFDot6GJURCPW3WKhcs9mSJKjdAz+FdJQHHcJhT/+YxYJ6B/CdHLw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4806
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220037
X-Proofpoint-ORIG-GUID: 020eQnwA-hUka6ZyLWiIVJdOCyUEyUcB
X-Proofpoint-GUID: 020eQnwA-hUka6ZyLWiIVJdOCyUEyUcB
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch modifies xfs_link to add a parent pointer to the inode.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_inode.c | 44 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 181d6417412e..af3f5edb7319 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1228,14 +1228,16 @@ xfs_create_tmpfile(
 
 int
 xfs_link(
-	xfs_inode_t		*tdp,
-	xfs_inode_t		*sip,
+	struct xfs_inode	*tdp,
+	struct xfs_inode	*sip,
 	struct xfs_name		*target_name)
 {
-	xfs_mount_t		*mp = tdp->i_mount;
-	xfs_trans_t		*tp;
+	struct xfs_mount	*mp = tdp->i_mount;
+	struct xfs_trans	*tp;
 	int			error, nospace_error = 0;
 	int			resblks;
+	xfs_dir2_dataptr_t	diroffset;
+	struct xfs_parent_defer	*parent = NULL;
 
 	trace_xfs_link(tdp, target_name);
 
@@ -1252,11 +1254,17 @@ xfs_link(
 	if (error)
 		goto std_return;
 
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, &parent);
+		if (error)
+			goto std_return;
+	}
+
 	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
 	error = xfs_trans_alloc_dir(tdp, &M_RES(mp)->tr_link, sip, &resblks,
 			&tp, &nospace_error);
 	if (error)
-		goto std_return;
+		goto drop_incompat;
 
 	/*
 	 * If we are using project inheritance, we only allow hard link
@@ -1289,14 +1297,27 @@ xfs_link(
 	}
 
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-				   resblks, NULL);
+				   resblks, &diroffset);
 	if (error)
-		goto error_return;
+		goto out_defer_cancel;
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
 
 	xfs_bumplink(tp, sip);
 
+	/*
+	 * If we have parent pointers, we now need to add the parent record to
+	 * the attribute fork of the inode. If this is the initial parent
+	 * attribute, we need to create it correctly, otherwise we can just add
+	 * the parent to the inode.
+	 */
+	if (parent) {
+		error = xfs_parent_defer_add(tp, parent, tdp, target_name,
+					     diroffset, sip);
+		if (error)
+			goto out_defer_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * link transaction goes to disk before returning to
@@ -1310,11 +1331,16 @@ xfs_link(
 	xfs_iunlock(sip, XFS_ILOCK_EXCL);
 	return error;
 
- error_return:
+out_defer_cancel:
+	xfs_defer_cancel(tp);
+error_return:
 	xfs_trans_cancel(tp);
 	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
 	xfs_iunlock(sip, XFS_ILOCK_EXCL);
- std_return:
+drop_incompat:
+	if (parent)
+		xfs_parent_cancel(mp, parent);
+std_return:
 	if (error == -ENOSPC && nospace_error)
 		error = nospace_error;
 	return error;
-- 
2.25.1

