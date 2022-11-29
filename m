Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 732CFC4167B
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 21:14:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236845AbiK2VOI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:14:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237103AbiK2VNr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 16:13:47 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C6B70DE6
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:13:20 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATIjZ78012398
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=0IdD172VF5gW61TAMeisRHpAz+L/8eTCapn8wklT4OM=;
 b=FvgB8f9qQSGQwcMaEl8NEqUIXzO/+hottXyZWTFYc+BgNNnXd81Umm9GHQLPWyNqLvLD
 CAemgKHcUqiOzuSkByFSoEZvKjXhlGlfzH7+nS4A39IJSYz8UwsfSmqWoqoQ4Cz9PlmA
 ZHMPYqr2iE0U/3AEmYBlJUOiImwDc3KAMzBd/GgDDCUUegjMLZ1gtJ14oFOfXkT2nW7C
 6d1mobEylYnLRlI39rkHWdXpMrLhPRzwq6rLuVR7BcFKoaEN5LhKGhL+J0kO5lMGGbJu
 E0h3IieJaZZaisv5DaBt1/iXAFBp0ebVg2Y3B9Su3CYsCkI9OgxdRFOFwwqY/aV3dS1u Mw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m4aemeewv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:20 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ATKUnBc027897
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:19 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m4a2hj1g8-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nG8Qidtj1sZUk7pOt9akNG6Y/XUkYQ/Fjugl5o+coffbEWEuTa0hfoSotM5vO6fn+LA3FQlOm83xJTcmqI1UoXKj17FsCVwtajTAD/eGOOhgdlhAmdfPS1ctaaN+EkkNrbxlX087qq4MWWpZHAGy4H2Leo2kah+GUtIq2KirW78dYnxdwEBgWJbzOhk8j51eb60/KYBf57z6W780sdYRPymL1p7xGD7nhYKf5HTyXmEuyME9R0pllLy0MTOguNiZGg13z2Npec0UCz3e242m+fBZTLW+jdlyD/XPjv1umJ3J77vAVg+C+XwnwWNcbyeRYkYKlDj6Ee0pzQ2thZhu1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0IdD172VF5gW61TAMeisRHpAz+L/8eTCapn8wklT4OM=;
 b=K+I8fJbuxzsFDVSDIk4dtJ7tbWSlN788U+F1TubtbtDEg6qUKePU0UqMosKsXA4QulRAnKhSGqpaswy3JLhIaTaeskAZKAhNxU58VGSvyJoka0YsdcWSOuYH2jV4AtGaci5Nr3MlrVEoM1Mn99PuRE40tLojF5BhaSFxM+yIo1CpfkDWEV9pN+dM9ZtTg3tPunPp9IpRqMIjKmEXjDFSmgPnJZJjuHe9WYsb9izRI6xn5yG64kHCtHcOe4LWPHaT7obeY65ViXp2+q9zmXbduHGh/lUII0JDTmcGzeietkcbaHIFqjqM1bHr+YEJcWvv8bPuPnVKoBmnfd6EkigGOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0IdD172VF5gW61TAMeisRHpAz+L/8eTCapn8wklT4OM=;
 b=NP7vaB4r9wNtDecB8tmo6DaiCLMI1BfJ9bchq9+9GQ7LGIUsQhybF3anO4hLqHBZVyo05AKgMZfFYcFRW5LPO/8Zl/ekRgxAcgHNY9b9BBtx4LXIhILlwLXTaCHAHNZ3R9I7PDbn9d75IDhHz4pUbWnoUtO1yjWoTcnNPg5bbyQ=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 21:13:16 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 21:13:16 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 20/27] xfs: Add parent pointers to rename
Date:   Tue, 29 Nov 2022 14:12:35 -0700
Message-Id: <20221129211242.2689855-21-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129211242.2689855-1-allison.henderson@oracle.com>
References: <20221129211242.2689855-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0006.namprd04.prod.outlook.com
 (2603:10b6:a03:217::11) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4456:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ea3a8d0-3aff-4c0e-f48c-08dad24e8835
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e1EMJJ1Swj/8zLhjGhP2/zCA/7F2b6UQNm5FH2YFXOmtfr7LjdyaKznLZVlQsAo9HJeMD4bxVG3KK2xaE9rEApUpTaYklRYkTlN5J/4v7z8P9UHVi9iqUGOe0Q94zTCxysXK3p5pX2A4tgNhMZrjv61LrdJg2/D4SNpPurMj6apeThgW8CRcwjL/yR5uDVeCmcXkhh6yQO6I7oZkrDEJ2GthQvt1wiiY6XwrZsrrPN1mydk6o3SCtvwlbj564IC0qFVvu4mmCwx8UTjfAA25xZWYRdXeRZGHL4Sy9U5MlL75o2vDr1r23ExG5qwfmHPQjpXv1wIar1lNp1JtHXGD4rxxHeJUeTal4rH/n8lx+tJ8sbkDi9nkLTLH/KcUZWTv9++2VqdP56MdS80x3m6LFZ6FR5yGAKEd6LVfzZkZVPWtitXbY6anzl7dgKl7X1LAwU+FyznjeLz4dKZC607aybEV4VqqGmxJxKS6CmHSirZ8PUpDwcxwknuNWTO3I9ifWIcqCL/75ICzmj7CWeffzpmyqurYgQSXYOl87cY38BTkCxPJ+ovs33vPkrcawRGrkVdM2TOxyP1mwGoZuMmnAdr+T7pBnU7SBw6AXTekTaZLWEQTwmRolffPF5F/0MKR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(396003)(366004)(39860400002)(451199015)(8676002)(2906002)(36756003)(86362001)(66556008)(5660300002)(41300700001)(8936002)(6506007)(66476007)(6666004)(83380400001)(6512007)(26005)(1076003)(9686003)(186003)(2616005)(316002)(6916009)(66946007)(6486002)(38100700002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RpwDh5WDF6yN5PBn/oKXXvcv81LYDxdV9ZwAQiCZAdfciqbLz8J6hdV+mehO?=
 =?us-ascii?Q?0mji6v4eBmzX/Kn8X3u1F/cYQ1e8ohlDwLYAoaCQuObuDj1+5hTtdJQETv97?=
 =?us-ascii?Q?r97aqQIl4z38Q/UQoof1ILOatNBBljZfsVDe1bKhyDXWTq5+NEnIkxKpNxfJ?=
 =?us-ascii?Q?3RrxuT2/YkgxCiFjbxFbqOuFjsgjvkrAZMUksji/eBA06xbDegTXKgRp5aAV?=
 =?us-ascii?Q?Qvdp/ah69xJshMjkexETGw2VMhXbV7HzRvaYnTttjj0XPNAeM38p8epOysC9?=
 =?us-ascii?Q?knR4XFKXoYXlOa0xcYvyQLroAQBjPmzw3Jnj5WhomGJOdjFJrt92jM96mYHi?=
 =?us-ascii?Q?NEssicgzssY0LfeX2+mLb4g/AvjTQDzoim5kjbIFNg4TDKWcWL5lnaLkyWak?=
 =?us-ascii?Q?Xp9CGT56XB5GtHKTiZ5GYxaYqoyYarNRkBpzIWDrK81WshbsOK6FiIMhfzXP?=
 =?us-ascii?Q?m5yT7sfn5p41ejApTgmnKpsrbLOiPDd4OPPQGbhKA9nvXHx3Pg2f0UFeUKWb?=
 =?us-ascii?Q?pay22tVb8kx+WDMKfPlJa1peGsiJwTGNx2Rw4JnpgYnaTOa/kR3JMmpqh9Ib?=
 =?us-ascii?Q?c6KVUJ+CLmCw52NnleZYO96UoIuXRpSAys4twaWtH5Cbtxy2cwzM79K8Eo2b?=
 =?us-ascii?Q?NXIx25x1SE439xopo2hQCLeWdkGvQao1ztvaJvBEFGRm1aNooaBO7Fq9tUYB?=
 =?us-ascii?Q?dNNwyzZbmEhpbK7bj34KLsf1BNT0SFV9n9iLZMn5UYMDxjizdfXUSaqmpVDI?=
 =?us-ascii?Q?fCK4YyiHXY7oIvF6XHpO5eLfiyvS1ePpVkUSvqVtwH8WHWLgwneZnGsgOzFo?=
 =?us-ascii?Q?eQgVpqXafxv/UDIg8kxkG/7IEFfrcK9xiN4RYh/RW2DYkWDTwIfjD0kI+npk?=
 =?us-ascii?Q?w4O9l2mjKk/al4EiWTU2bx9G70Zgzng5S8b78Q1t7vl3Kl27DKvutEjEGOec?=
 =?us-ascii?Q?R+LluEkt2MRmqzGV8bdQ1kxVy5Fy4sov2BXoKdPvfog49iFyVbxWQ+N3TCOA?=
 =?us-ascii?Q?6d5INkQDbAdmHaxiFBLCqS8xXAFiOX6OeIZf37nlgWsR5u22p33DuNRnlBiK?=
 =?us-ascii?Q?5Q2kkLD8g/aVijCsbPcNedPXcs4SA/i0HxJ6FsqnvFQEAo4UJF8zhn9j8Kcz?=
 =?us-ascii?Q?2jUYNU9ArYHVe/a9zap7ualbt+fAkiSvhOlSHi5P3LuhYvHdbN8AtEtYAl4q?=
 =?us-ascii?Q?iakRdvXZpzlLD1n3+j/JvunKWLN6kZTQ/78CGllalDBXSREIMS/0LuWLDqEx?=
 =?us-ascii?Q?DvBe9GcupWnMyCOmTgw2eKkDgvHZf9YrgRMevKVMjWrbMspsPLxVmXxyiVO/?=
 =?us-ascii?Q?ucJzpDhK7RXYNzGgbVRUo8M4n19evZ3fxebcHeOv+WGb73v/kGHXxHaFyTIn?=
 =?us-ascii?Q?j/UarpJb+jIJPjvHHpJKA4hi8PcxBtpq4f63D8HhXJUIVTOBCFaadQFePtQN?=
 =?us-ascii?Q?vIXCooGjnzV6f5JsOdtCawhLjhkwWZJPbVopw7YZuTWwonVRjO+BLV+no81Z?=
 =?us-ascii?Q?bNgXMZrBykaNT/K2xQjb0DTCPB3giwhMvibydCIv8t1J/7xldA3S9eJUuSb4?=
 =?us-ascii?Q?25J8vVZKs0rsajleNtDXJG5IOl3u3SqmAIPoaEnhifBXjXxaOYwjcXpgmEBt?=
 =?us-ascii?Q?hA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: e9zyAVDfCsIdQnApcK370kF6j8SgBi1eQybKPno3NY5qUOiu4nfk5+dl2xuZWCuZb7devjgMVravp8BbuBvqkDwQFaZVIPnF/5A7VnaU9mFEzfQr5lcnCAhrawaxVGZlNz93pNQTgMpCaUufSHauogu8Bti4p08ndIfIoN6alwuB9gDH+Nf/1Q8peLdTWZNXuzNuS7Mph3UfbLHDG6JmAdgg3bJ9Wes9IbnKJGpLWYeNzoZnznQMBSF9dr1IHNn2Nc6zMZYtAR2s1lcv0jEjM5EkU6XME1slKOUb4MqH/KA9S8cmQMvXzab83cfghsU+hspPMTu8Ls06hp1DXv4g4HZeQ9esImSweVurVmh+l8Uqcjml/g5xQusEKQ3/g0sU0kMViBhHlqJf7kn/yC9El9Y7NzPJAIfEj5NHhI8zaBCvMyWWDRQACxvIdSRQy8SkL1kA9bgPYs2bV7Qp/wtzRQtSoXM3nt7cFoopHj5v1Wc0xbQitJEvjRXD6SA6t5TplkTIco9D4NZZbCCrgO/rcg/SExRpYDY4LT1VC1S6rX26Y214CPgdGlcQOHXc7L0we5jaCpAMf/SLxsp0CLWJpJi9XDJCzOaXvtHD3puMh9ROWC2lGTeecWezX4SfonPkURE55/pQOx3RaFfm5Ga3ZuE0OtrgatVMZ8nqjbzQhQrZXHE5sQK6DU1JZtm/JQLEcBUvwS5nDQDS1tZVhKT4ruKEJU0jDe4R0KAjMue7Ka1BFwbvpVuOcENIw9nQCtk3zjZSPvHp94umFp9/NWZy2Q==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ea3a8d0-3aff-4c0e-f48c-08dad24e8835
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 21:13:16.2416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tSKb8otpJHUgt5g3ukJ4mfy9CfETXr8XAjE6sYyKGQWTPt6RkNyfC3bNc98ohpzz9UF+ufTqfyiDqw4ZE9siAXP/kfTxPRUnMQL150DqChs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_12,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211290125
X-Proofpoint-ORIG-GUID: AGJ45nskWaXdH6Aer_ugLFXqvH2BFieL
X-Proofpoint-GUID: AGJ45nskWaXdH6Aer_ugLFXqvH2BFieL
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch removes the old parent pointer attribute during the rename
operation, and re-adds the updated parent pointer.  In the case of
xfs_cross_rename, we modify the routine not to roll the transaction just
yet.  We will do this after the parent pointer is added in the calling
xfs_rename function.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c        |  2 +-
 fs/xfs/libxfs/xfs_attr.h        |  1 +
 fs/xfs/libxfs/xfs_parent.c      | 31 ++++++++++++
 fs/xfs/libxfs/xfs_parent.h      |  6 +++
 fs/xfs/libxfs/xfs_trans_space.h |  2 -
 fs/xfs/xfs_inode.c              | 89 ++++++++++++++++++++++++++++++---
 6 files changed, 122 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index a8db44728b11..57080ea4c869 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -923,7 +923,7 @@ xfs_attr_defer_add(
 }
 
 /* Sets an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_replace(
 	struct xfs_da_args	*args)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 033005542b9e..985761264d1f 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -546,6 +546,7 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_defer_add(struct xfs_da_args *args);
 int xfs_attr_defer_remove(struct xfs_da_args *args);
+int xfs_attr_defer_replace(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index c09f49b7c241..954a52d6be00 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -142,6 +142,37 @@ xfs_parent_defer_remove(
 	return xfs_attr_defer_remove(args);
 }
 
+
+int
+xfs_parent_defer_replace(
+	struct xfs_trans	*tp,
+	struct xfs_parent_defer	*new_parent,
+	struct xfs_inode	*old_dp,
+	xfs_dir2_dataptr_t	old_diroffset,
+	struct xfs_name		*parent_name,
+	struct xfs_inode	*new_dp,
+	xfs_dir2_dataptr_t	new_diroffset,
+	struct xfs_inode	*child)
+{
+	struct xfs_da_args	*args = &new_parent->args;
+
+	xfs_init_parent_name_rec(&new_parent->old_rec, old_dp, old_diroffset);
+	xfs_init_parent_name_rec(&new_parent->rec, new_dp, new_diroffset);
+	new_parent->args.name = (const uint8_t *)&new_parent->old_rec;
+	new_parent->args.namelen = sizeof(struct xfs_parent_name_rec);
+	new_parent->args.new_name = (const uint8_t *)&new_parent->rec;
+	new_parent->args.new_namelen = sizeof(struct xfs_parent_name_rec);
+	args->trans = tp;
+	args->dp = child;
+
+	ASSERT(parent_name != NULL);
+	new_parent->args.value = (void *)parent_name->name;
+	new_parent->args.valuelen = parent_name->len;
+
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	return xfs_attr_defer_replace(args);
+}
+
 void
 xfs_parent_cancel(
 	xfs_mount_t		*mp,
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 1c506532c624..9021241ad65b 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -12,6 +12,7 @@
  */
 struct xfs_parent_defer {
 	struct xfs_parent_name_rec	rec;
+	struct xfs_parent_name_rec	old_rec;
 	struct xfs_da_args		args;
 };
 
@@ -27,6 +28,11 @@ int xfs_parent_init(xfs_mount_t *mp, struct xfs_parent_defer **parentp);
 int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
 			 struct xfs_inode *dp, struct xfs_name *parent_name,
 			 xfs_dir2_dataptr_t diroffset, struct xfs_inode *child);
+int xfs_parent_defer_replace(struct xfs_trans *tp,
+		struct xfs_parent_defer *new_parent, struct xfs_inode *old_dp,
+		xfs_dir2_dataptr_t old_diroffset, struct xfs_name *parent_name,
+		struct xfs_inode *new_ip, xfs_dir2_dataptr_t new_diroffset,
+		struct xfs_inode *child);
 int xfs_parent_defer_remove(struct xfs_trans *tp, struct xfs_inode *dp,
 			    struct xfs_parent_defer *parent,
 			    xfs_dir2_dataptr_t diroffset,
diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index b5ab6701e7fb..810610a14c4d 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -91,8 +91,6 @@
 	 XFS_DQUOT_CLUSTER_SIZE_FSB)
 #define	XFS_QM_QINOCREATE_SPACE_RES(mp)	\
 	XFS_IALLOC_SPACE_RES(mp)
-#define	XFS_RENAME_SPACE_RES(mp,nl)	\
-	(XFS_DIRREMOVE_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
 #define XFS_IFREE_SPACE_RES(mp)		\
 	(xfs_has_finobt(mp) ? M_IGEO(mp)->inobt_maxlevels : 0)
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 069ce3b3b712..256404fb2468 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2866,7 +2866,7 @@ xfs_rename_alloc_whiteout(
 	int			error;
 
 	error = xfs_create_tmpfile(mnt_userns, dp, S_IFCHR | WHITEOUT_MODE,
-				   false, &tmpfile);
+				   xfs_has_parent(dp->i_mount), &tmpfile);
 	if (error)
 		return error;
 
@@ -2892,6 +2892,31 @@ xfs_rename_alloc_whiteout(
 	return 0;
 }
 
+static unsigned int
+xfs_rename_space_res(
+	struct xfs_mount	*mp,
+	struct xfs_name		*src_name,
+	struct xfs_parent_defer	*target_parent_ptr,
+	struct xfs_name		*target_name,
+	struct xfs_parent_defer	*new_parent_ptr,
+	struct xfs_inode	*wip)
+{
+	unsigned int		ret;
+
+	ret = XFS_DIRREMOVE_SPACE_RES(mp) +
+			XFS_DIRENTER_SPACE_RES(mp, target_name->len);
+
+	if (new_parent_ptr) {
+		if (wip)
+			ret += xfs_pptr_calc_space_res(mp, src_name->len);
+		ret += 2 * xfs_pptr_calc_space_res(mp, target_name->len);
+	}
+	if (target_parent_ptr)
+		ret += xfs_pptr_calc_space_res(mp, target_name->len);
+
+	return ret;
+}
+
 /*
  * xfs_rename
  */
@@ -2918,6 +2943,11 @@ xfs_rename(
 	int				spaceres;
 	bool				retried = false;
 	int				error, nospace_error = 0;
+	xfs_dir2_dataptr_t		new_diroffset;
+	xfs_dir2_dataptr_t		old_diroffset;
+	struct xfs_parent_defer		*new_parent_ptr = NULL;
+	struct xfs_parent_defer		*target_parent_ptr = NULL;
+	struct xfs_parent_defer		*wip_parent_ptr = NULL;
 
 	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
@@ -2941,10 +2971,26 @@ xfs_rename(
 
 	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip, wip,
 				inodes, &num_inodes);
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, &new_parent_ptr);
+		if (error)
+			goto out_release_wip;
+		if (wip) {
+			error = xfs_parent_init(mp, &wip_parent_ptr);
+			if (error)
+				goto out_release_wip;
+		}
+		if (target_ip != NULL) {
+			error = xfs_parent_init(mp, &target_parent_ptr);
+			if (error)
+				goto out_release_wip;
+		}
+	}
 
 retry:
 	nospace_error = 0;
-	spaceres = XFS_RENAME_SPACE_RES(mp, target_name->len);
+	spaceres = xfs_rename_space_res(mp, src_name, target_parent_ptr,
+			target_name, new_parent_ptr, wip);
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_rename, spaceres, 0, 0, &tp);
 	if (error == -ENOSPC) {
 		nospace_error = error;
@@ -3116,7 +3162,7 @@ xfs_rename(
 		 * to account for the ".." reference from the new entry.
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
-					   src_ip->i_ino, spaceres, NULL);
+					   src_ip->i_ino, spaceres, &new_diroffset);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3137,7 +3183,7 @@ xfs_rename(
 		 * name at the destination directory, remove it first.
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino, spaceres, NULL);
+					src_ip->i_ino, spaceres, &new_diroffset);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3210,14 +3256,38 @@ xfs_rename(
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
 
+	if (new_parent_ptr) {
+		if (wip) {
+			error = xfs_parent_defer_add(tp, wip_parent_ptr,
+						     src_dp, src_name,
+						     old_diroffset, wip);
+			if (error)
+				goto out_trans_cancel;
+		}
+
+		error = xfs_parent_defer_replace(tp, new_parent_ptr, src_dp,
+				old_diroffset, target_name, target_dp,
+				new_diroffset, src_ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
+	if (target_parent_ptr) {
+		error = xfs_parent_defer_remove(tp, target_dp,
+						target_parent_ptr,
+						new_diroffset, target_ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
 	if (new_parent)
@@ -3232,6 +3302,13 @@ xfs_rename(
 out_unlock:
 	xfs_iunlock_after_rename(inodes, num_inodes);
 out_release_wip:
+	if (new_parent_ptr)
+		xfs_parent_cancel(mp, new_parent_ptr);
+	if (target_parent_ptr)
+		xfs_parent_cancel(mp, target_parent_ptr);
+	if (wip_parent_ptr)
+		xfs_parent_cancel(mp, wip_parent_ptr);
+
 	if (wip)
 		xfs_irele(wip);
 	if (error == -ENOSPC && nospace_error)
-- 
2.25.1

