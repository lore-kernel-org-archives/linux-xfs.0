Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B2D5C4332F
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Dec 2022 10:03:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbiLRKDn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Dec 2022 05:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiLRKDk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 05:03:40 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4E955B2
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 02:03:38 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BI507FY007702
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=j1uF1962JupdkqwTaiZqcYccXWKqKx+j/ONP8CHpYy0=;
 b=0J4gNOtsghQG5gf3yyu/cR0F/agv1pobeRQZqI6EjCvpJAA1KK5KFN8u8BGtgqPYSpux
 /4LzSsUSJ95HEN0rXSRaOW1vJMOxAqPEmfG0KLFnIzT9+hkB6lUf1A2/eID1n27LBjrt
 WSMZJ/Wy92AWainkacC8UrAyc9Oa0RtEyJ24Pv79y7YIlSKCJbSGJbv4YDdu+kVvcIxQ
 d3MkLfIj20QBlLMxJzEnpk0HDBs/1pQovIft+sdycn8CzDcUpXomafQuaOlBXDlJHdc/
 HHnRw1OmHGcJzZXZzSozHRnNXoNwK8IWpP/lytDmzOxi+0SEC3gDyoiBN9+YdfqssMKt 2w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tqs960-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:38 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BI909Wq012804
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:37 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mh472cfwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XZqP2FDIuqRbDicmJm8SuL5bto3xoAl+29YHSG2PtQRxaXsiIQU7658vi6cs5HxYb7VSkcmZqf0eX425zpCss1FAoLfWhioxK7Iao084u7zP+Nwkyy3ySxuqvXInEU+J9fVQjmmGnpdDdxRs85z7I1mLhyKffbuH14WoHqycEUS3TXjPvxe1G9munT+cLtWGBqmnA6ImRM26dkljWdmCSnu3N3xpgxML2ACVIA8st+GWAwMBp2DOuKymoep6CgsSEkdo4M1ywxaSOiQY/QyBzLEhswmc+svftEFa5JDYlVMwL0j7XDdouWFLbZLddbY24fkrcnmNwFLX4FOhObMTwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j1uF1962JupdkqwTaiZqcYccXWKqKx+j/ONP8CHpYy0=;
 b=cwZbEXMvzv8QR1Xbc7hfYjU30un048iWn6gh81hlSp3EH/9CV5fdGXedlt8gTobH3wHewegh65MsBU0bZl6ZWeSj4t/wUhBzLu2ACpi8PFHGzbxXW79ngoX3Mpvuvpc5CSbT6KMwZl/Y1/lS+XMPz3CPQC1Lpuz6hITGP9I9l61Jr9aT6eG75jrowoCpH077reiXF4BHwQapCeCsdTc2G5OvC0r076fEZvWVdf5mgpMUMAcfCtvgV5xrZiPWKdgUto3wD7rH4S4aFKCrggFBZaqetJGqvzfo8it+raOI9O+WtuglqPuJsaqONjQY7UQmCJOfsCX4vyv/ks6CWg37gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1uF1962JupdkqwTaiZqcYccXWKqKx+j/ONP8CHpYy0=;
 b=a1O0qEGxYa35HJYepgkjJ7hlY+GFgEGHfGhW0PYuXN9ZXuyboNAbHjjVQQf3pK3cUlEUVWM5UloOKQKTgd/VKO7lgWi/MVXK+tGio2Ar5DSyB8Z5/QF0dHAgZXUzdbCus4tr9Y6gydlLEXDR9HK5WJl92smNHthFQ01i3OpFS/c=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4536.namprd10.prod.outlook.com (2603:10b6:510:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 18 Dec
 2022 10:03:35 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 10:03:35 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 18/27] xfs: remove parent pointers in unlink
Date:   Sun, 18 Dec 2022 03:02:57 -0700
Message-Id: <20221218100306.76408-19-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218100306.76408-1-allison.henderson@oracle.com>
References: <20221218100306.76408-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0235.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::30) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4536:EE_
X-MS-Office365-Filtering-Correlation-Id: b720471c-5ece-4831-d183-08dae0df208a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LUAk7mlssa2KxYOsSZVWZ1fFnpZSYp18NoljhhBylVaVLYAdkC9oLGXRtiDJ6Nij7+yGPG8ug0kLXMDl1E4LPxZL4oKebRqfl0H/oCLiqZOuGTrajjvP9NCEHB2Xv5G84yD/2KDARmJ+u6uQlgj80Z0WBWtXtkA4y24x/G6rNtssY+3XYbuis206MdWtQWHoD9H6mdPV4DXVj/pqT4MoSX2xswioT+C3UPWQFriYCYAbKUjMLPGxrq03rH/nwtt7e1A5iUSHJQD0qsUlO1O5zTitztHRpP+Tq2FTXI9Y5f3+niOqOthCqTOGBXQ4Qbj+1BJcor4WMFDdqR+Ha/UhNzMCccr4htZ98DKBW3baNWvlTQJa2HFRsYB8+fjEln5NZa9bmLe3cWS8wf7o5Ix1SjIlL3TqYq4FFWIghVEuXw9Lkh+jhB9IIOusQqTAU0yTIf6Naw/+oq+9pR3s8lLOvPXkyX7Fz3XKfJ1W+KcpF0MRhHA2IuOCbsTecJK6AXcPsU/yT1nB2W/WmbFc3JDdMgUOQ70k6VVmEknFIYgAPf4QZybmbH6GepGoo6fQ9TvIy/SaCl2XRoZlkqfnm+px4Lkzk/Y51eSZ0ipw/v/Atx/LTqWaaqZzia+MGd3Kro5QuaZB7Hd+B6NJBBSjfwdb5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(66476007)(2906002)(8676002)(66556008)(5660300002)(66946007)(8936002)(41300700001)(1076003)(9686003)(26005)(186003)(6512007)(6506007)(6666004)(2616005)(6916009)(316002)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZVrz+bTfopumINWY3DQIIWuWkJoWrKFSlZ3BiYa/wzP0FDEvAgm5uO2b6SkL?=
 =?us-ascii?Q?RvfuSy9RAZGEgHI+xahpNKR1IftvvtM+10ZDliMnX+sD3lW0wQGNs++JlVUv?=
 =?us-ascii?Q?kyKyMJVfeHa9alCdHz5cecVhVAOkjKZViNTbCAJ6wKLVDj9E1I2bF6vj3/uE?=
 =?us-ascii?Q?9kGn84ywVWDGpMQyemiVw1i18vUHT8KoTxJNylefWSOVEPYD9LGZtq4ltCkx?=
 =?us-ascii?Q?0/CDg+/N+gcEA9tMHhV6pJFK+rMD+Fvy3ArK9Yt/ZuQTDsa2eLn0u5eRrTdY?=
 =?us-ascii?Q?nWe7Jl/HW90wGVyJaPVh0TAc0KhRbBZfsf0qLVv6RHCG43f3lZ8nlzVYOOke?=
 =?us-ascii?Q?VFmmpUnrRiYhF/PS/NMU8bZvmwctxioiSsCMVBrT6eN4gg/rlqlFwfWB6KRb?=
 =?us-ascii?Q?zQXLVqpbjT2cVyMwY6TwggXBiLANeoCcTjrHAXGTISKz3NeU2n90pWKqY9wr?=
 =?us-ascii?Q?1pE3KbvpHsBv4T0mQWDdgN7L2ptSM42KnjL19enJDatb+7vitpzdM8Avo/gt?=
 =?us-ascii?Q?dgep/uf+xYNo0KBc6se+RWQ7njN6/bH77iPbZoiguBNKEkOpqPEGQS/5zWzv?=
 =?us-ascii?Q?5Nr2vRK2HbgbbBKYaz0OvrBthtxMVMynQ32KH+DKdRVwCSPtV2l1ulLHS2EK?=
 =?us-ascii?Q?WAZIdFKgMFFF8cXsAhdxTURmnjPbjJmQU9Nu+CusV1CbRIkvbBq6YWb7lNV5?=
 =?us-ascii?Q?YMVGpgbDv6NhkWTeTN/HW2m30e9gzV59dW06jQwbBCZKmDMn4nD2YGCh9Szt?=
 =?us-ascii?Q?7luorRoOzA3VS7BdNHyk0RPo+7c3PZu0ET0ueW/v3I7Z5G/Jp1Lyjtya5e44?=
 =?us-ascii?Q?TUceGMurZtc3StOgRc44Z1mJBcRAGPdM+mJ7aCPfI/5YQbJVmJazP+6U3Bd9?=
 =?us-ascii?Q?IoeerAGXOv5ITqphukOhxGN/Hjg4UFF0/lvV+sRaSsfY3CYyuxJzlz++0YJj?=
 =?us-ascii?Q?2cirieFGr8VTRMypQvYSpEn7j0oB4PjIkg8lLaXqe4B9CcvTgs3j7i2KTwji?=
 =?us-ascii?Q?WHkeV1qrEmj3hFxRnxU9RoxSjn5BJk2SvFlcbuRN87ivKwgQamO/2XUr5Wnq?=
 =?us-ascii?Q?ZAEuRTbVAyp1MagH0S2Q619dCb06kU1gKOo5+IiAO8o+bV09+MsxXIahCGw8?=
 =?us-ascii?Q?Ws6mojpLWgRbXoKztasJPRIoF9Up5cs/37EEfGKWS2zaURlD4cnXIfI/0e/f?=
 =?us-ascii?Q?rqvyNlyO0K93vTUMkbRxut/tfDcyISn0HBCDhfBH9N2D9Ibta/gOuRj7ph9Q?=
 =?us-ascii?Q?MPJTDUP4fnZIf25arUQQtpOxXzaEO1eCjW8pAuE43ESc4osvP5toaXbA/ml3?=
 =?us-ascii?Q?UTupfT6nhdduuZYAxS38odtU+ATs7JADq3lG92o1LQXyUF1v/5aE83ptc5su?=
 =?us-ascii?Q?TkoFAp/g/isiyYtbt/XLdsWMlpjXfgq4Q6cNZGoHghJoyw8uwEV1+6CV5Mgk?=
 =?us-ascii?Q?Tg6/5hR/fCpgl10JdxGkgKOLfLQoaCK9yKIor/xbkyX3YtDTpkNP2KxxYJCL?=
 =?us-ascii?Q?XhvUN6U8Rn8GT4VRxlGYvQ4vE8wAOn9HC0VgpFTDngHxGxvhm++RVLHauiDm?=
 =?us-ascii?Q?OOH5GGC9KbB/ptotIeABdzKiHZn7IM1Ahfjnssd6E1vZReKLU7WJ3LyRA2ua?=
 =?us-ascii?Q?Dw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b720471c-5ece-4831-d183-08dae0df208a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 10:03:35.6050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jp+thdSAIDyxTsUfnMa59QOgUB/6I295UBpuYWVP7/vYBU+H06Ye1NsqW2KCxB6IRWpaHbvBSza5MxKh5hznEb+NqAlbmVAofmicfA2hLjc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4536
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-18_02,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212180095
X-Proofpoint-GUID: z9GgbwJ32pcAoIfEfMR8sogDSKOlNmg-
X-Proofpoint-ORIG-GUID: z9GgbwJ32pcAoIfEfMR8sogDSKOlNmg-
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
index fbeba9cbf85d..a53a000a7169 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2471,6 +2471,19 @@ xfs_iunpin_wait(
 		__xfs_iunpin_wait(ip);
 }
 
+static unsigned int
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
@@ -2500,16 +2513,18 @@ xfs_iunpin_wait(
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
 
@@ -2524,6 +2539,12 @@ xfs_remove(
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
@@ -2535,12 +2556,12 @@ xfs_remove(
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
@@ -2594,12 +2615,18 @@ xfs_remove(
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
@@ -2624,6 +2651,9 @@ xfs_remove(
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

