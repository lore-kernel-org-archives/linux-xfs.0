Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD0E4C61D97
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 01:37:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbjAXBhA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:37:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232446AbjAXBg7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2023 20:36:59 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A9B1A483
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 17:36:58 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O04KGd013028
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=ZvAa1vpgiHUG/GPI0BrfiHFa2bGfSqyKqQb6WkHQ6+U=;
 b=N75BtUcuX8GwqsWh+Jj0e7XNunqsyuN5P0oa1mNq5B6W241Oj1M9d4AYgKl+Qw109NF5
 1NtDESuTXD/jbIhDxtJxHeg7gYtk1Ks9QpgSoWN8O4lpciFUxFLbl6UQPltDL/v/wBPX
 0v2LFu1LnNA4rdMXDe/3rHsgFl7WptnPrwMo0iarrV8zmw49wKppIULFlockNdIu2BZE
 pJEW4nGdfM1n5oHKQmO0XC/3HvEuJBb5hzIJ4LbPEROB03fFNLKg7vBV6K8BQLapnPwG
 Ib928NpM20tqxYF+Ob46anQ2focZFTKqKeudwKy1IGOz9rvZlqVWt+BtnfSjf0hs2t4N VA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86fccby5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:57 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NN5GwS040221
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:56 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g4a87u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lpBEtHnRdJSLalcwsReQ6hWHWkx9fK4TOxllIeaEcW2kWoziInUCfSjPENBL4S7AGNGg1zqvyzoM3ZavdVR5EWyIIki0gPoiZ2mm/HEVIBSkKb3dq/HoEJbwNNGr1Zu4vJlSxei1Lw9e/pyfxSYsRTdA54ZUpM1N66y4dza4qUsw1heZ9d0djkgo2Gxg2qW57+gmCqNVmj8Cq5SGw/ihP9ZkOrKQOe3y1NDSO33P1HqJ9/Hj8NdFZb8ydP4TpJOcXTKaMWK5GCXcwl7gG0DqvUa3lA8Rmb6ZIGjjMCVqpzLPJ65Y3DMuL8isaCXxpYAbtAqgU4Yv3i+XJ0TEwuNGuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZvAa1vpgiHUG/GPI0BrfiHFa2bGfSqyKqQb6WkHQ6+U=;
 b=L83I2HJEG4W4WTH0ZPzl2ao+NRkFe81CO4Rb37zuTc7eU0JutfVi5Lw1uh1+BBUVhj7QGF0/hFS/SWemerVoL4/posGj6NwvjrYVUJu6m/0ISdj+gRVb92473iy75ll2tozBwo/UySV7YL6NDQ/brJoEcNZSz4IwN5hLzjp4tiAa4gBfYZCJbjNPOtuZGB0gyF39JBboQVIZutaF1ErUyNDOX//nQy7sToV8QrzDMW0kN2VYFhk67WfJ4NwX6T2yVwLgQrSe9i6GrAx30QkjXbcu1y0JuYFq4VHigVWuRrIc9w2+ZYTBX5lhM3gq+ffdDeuqlExLNq7xBQhprQ1gOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZvAa1vpgiHUG/GPI0BrfiHFa2bGfSqyKqQb6WkHQ6+U=;
 b=rJf29JHr0ZR6l1nooAjYFiyJSi1L/0240T41dVCXlUr0Ki+XVjt6PIL0VjLuEVfSV3sMErYL9gx4ALitUyc/PuN6WW1DEsHvop5dG9lot+ObE3LI48XPaleURXsGj/IFHoYKKiDyWckvzAGzItvj5bXHyvpudmIaW/bQnhPI8B4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN7PR10MB7074.namprd10.prod.outlook.com (2603:10b6:806:34c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.8; Tue, 24 Jan
 2023 01:36:54 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 01:36:54 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 20/27] xfs: Add parent pointers to rename
Date:   Mon, 23 Jan 2023 18:36:13 -0700
Message-Id: <20230124013620.1089319-21-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124013620.1089319-1-allison.henderson@oracle.com>
References: <20230124013620.1089319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0150.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::35) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SN7PR10MB7074:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ec70d14-8599-4342-f2bd-08dafdab7970
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n9l8svYI4MJe3hDXyngPVRSHXBsD0+82DJXaFifcWp0wcgLcAEx8iBNuzBfglelBBKXJP3ydMxHbWbFPjK7YLUD0noNu/UhFwwk97RKtICifiWuBGzltUnKtR5W/DHwf3jW0gSs62yhkZWoE2FsP2us4NABCP2010jnLvQy6b6cXMZRiTHAGYrlpf7nukuXgqo8R6NX4G/D162VBIfZQRzFc6DIW42EPKCocHb9kf07DCcbBUc8llXdx6yaxFpPaxo/t+Xlg35S6xFyGxSSSNtFAmGvsYd6WroDz3iey2trR/PMqM/b+Aly+wEV/jLTNJmyqCirsW7QtVmd/xA/QW/8vzrumnj1kRRkgNTV6oyNfAbxBSYfQ9LUuBw8H2V+CmyLA032ytdn3WUg1ermhkTIfOX4JVQelA3UVYHTN60retJH9UVtvreJXU5Uzp8gZfl8TPOvoJYqpGfmko564dJaIIdp93xy4HwhGPrP/Y6zDMFh+5+j7FpbYzDkKG17Rl37upeybat9uw/+Wfs33cjeryzJYgHC10uj6qLRdrJeHNf96HZ0huWMwgosW6JqGSlNC4TCpsY4QSbIWWSjj25TVjLfj2aK6fGiNdBk93e9yMdNjhCZBcnLAxcqn7fQRya5XEmIzlVl/+OJbTkM8kQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(346002)(366004)(39860400002)(451199015)(66556008)(66476007)(83380400001)(6916009)(8676002)(66946007)(41300700001)(86362001)(36756003)(1076003)(316002)(2616005)(2906002)(38100700002)(5660300002)(8936002)(6512007)(6486002)(26005)(9686003)(186003)(478600001)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xCV9WcsuSIe2vI7M0yLXjO7a9LbVUrRsB82J8W6DEAafGSaD2ugeUe580/2v?=
 =?us-ascii?Q?N30ymctzuQZH/LFVkibwzdYJI9t8OOnC4dgleMa5gU1PQ3bSAx7tpUqEnVlI?=
 =?us-ascii?Q?cpXKXWRPB7St+7djJp34vQ3oyiTs4XijD/ehgd7t4Z252gW+emeQ22nCU8wk?=
 =?us-ascii?Q?njGtHG/l/4S0VSpltxsWJNjwlrk2srA4v1OJxVJbOXOxs/wbKgQBGxqalZti?=
 =?us-ascii?Q?Do8QncMaE1d4dFxNQZ5jrpjO9M4kmrIrEWQrNUa03QpPMGIuvp0iN9Z8dzaI?=
 =?us-ascii?Q?XOP+1CZALXbeEgv2STkwutIWQuWabmQDNbWRrp437qnZTh++RB7jIis9XdUS?=
 =?us-ascii?Q?70xAidX+TXXqAt0vGeQfA9kOWqVWh9YmQpH00S2pepP1cz2ZjOhCEKyOekKZ?=
 =?us-ascii?Q?HZzjqTJZZOfIhC8to52ZsPRKeZMg5TZgISLtb8VI8LeZhFn0hyZCqdhbFlaZ?=
 =?us-ascii?Q?mezpiNKaRRyOREn7dfH31ZFy2Ba0OQq/m+6gtAzKyidOQEiCFwKE8k4eoxcm?=
 =?us-ascii?Q?05+dRI183jXquEPnr/zDOcuirqKzxQ9epD2xJ+LgiFc0QDkujoeIe+e2yuJ0?=
 =?us-ascii?Q?f/UdP1DdBKzzZJnrwu+3p5LpGhZdYbm1inZbJalchQcGZc+RasTVTaBkYnPX?=
 =?us-ascii?Q?/FgexRnJIshRskqMpFPOQeRbRMMfpeDWdctk5+6sBsPLL2kINgCaZx0u4IYj?=
 =?us-ascii?Q?uhrBjedtVQLmQ3FqwnDh6mUax5kjssmxe3tjoZ5UpfpncG+zOAFdhbGkd0Y6?=
 =?us-ascii?Q?ZtzQqf/OV2BztEKzijd4S7xndI1iSBOK8A7yDF5LWc4zohQkx4Q1k5HPPUVQ?=
 =?us-ascii?Q?ys3cioN9XHoYEBhtUx6LfvjO/1xnzMLxC5R6fLxAefgCWg/EDidzvT+RaTGl?=
 =?us-ascii?Q?0Q0hQXzEY8pOQ2tQ65ZgM9MZCM83vZhtL00t5Of90Ee5CWjgrd5F/hQ1BN2A?=
 =?us-ascii?Q?GBKgNazEqHjoCV+deLImtX0MW2gbr0kWwjb9WkofBOPQL6aF6qxI9vn7rB1w?=
 =?us-ascii?Q?VHvAOzjoPj37FZfC1ITVgoNbXono+zaw/8k00VYLIaAD0OW7hTd+iFicGwKp?=
 =?us-ascii?Q?I7SKvvwB19SRkzNNvLgxPdV+BN5GTRXFwmjtxdWbAEGq54Lm3nqhKecDfVil?=
 =?us-ascii?Q?E/hXRRzicRtKuzYulqEmWpszBrogJwzW+0wDNRO3EGKymCc/0//l1UabneZK?=
 =?us-ascii?Q?/EcygTY/8OzSiWi4TqZWDo2maS5DizBDcQMAHD2h9WcYjgx0vsHySkoOWOdP?=
 =?us-ascii?Q?lQh5CMizQzVHRjDH21I/IxcaGksz2Z18G59abaffam5rxzPgCpZAvCkSPDmz?=
 =?us-ascii?Q?qzXkNp7bAGnJYg/Q+ZKg5H5xaK9SYm57mGVhN0G3gyCgys2gI4IsZoicy7Fv?=
 =?us-ascii?Q?cc7FNhcuSz1hqR64ElXCctsH/fNo2vtFf17WjcnAJb+TfGZN3RLyJsLrz6ON?=
 =?us-ascii?Q?q+T0sRmIi0X3ajku48bnDuEBPO1LyD9ask5BFZwJqcmH7EE1WpsMv82/Xezd?=
 =?us-ascii?Q?UbMNMY9t+mqAiKWe9tZmxI3U+vjQX9gKtk/vv0QmweFGpS6OVvk33+6S3QS4?=
 =?us-ascii?Q?sMzg1Gi6/Hm6zxwp1w7zrDjw7CKGSK7JDN9Jacy83D58DNVYYE/1SfefTOiV?=
 =?us-ascii?Q?FA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 8bkS8PdQuzgw3/nLngqOajUhx+DaeTEDBakKCbjhvqCNLomjndsUvFsTiCjGiKh2PNMWnoYzc85mq8w6db38c6gyM16r+9kcd3NtZ0AMW3ZWsxAC47A2e6zz0zeKy1DRd+ZaJYDP8P3F4KPim7jRCFWSIbAQGsUU5aiFC+4VQwc2STVXhRKtF8gKU7nu5TgRyH9cBQjQkw0IkehalNaNu1iTG/pWKOIpRrWbhmblnKUIKODYI5dT0+tnYA6rDWDMV6tqaW2skMmTqyDU7hENryKkyDpeqr8VFsxjmIH4qWYkgbotrEiK/XMHPTnj+MATQSYzS+Ucq0jb+dYYH/2s+85Ag8EQqzniv/4PMlzDyoih5DJ007B854cSHiMNwj7kcE3eZnfZxlsmz8PCGaGakAt7CG6LD+/hG5AbgHsXa3uxUP9GxRf3XANTTJ16kLGGd29X3iO+4RV/Y8lN0IwmacqzU5ZC0sZtWPNgp/6nbI8BAGETO2k82eZjyBgkT1OmeZbOglL4ZAv0LrqqwJOqaeWgE0ZQm/YkPg2oKou5oz4dwqIkky57IhqdSKJcXWswVJadUBDgunEbrMjDhcxjyWLnSUdsuz2CLBI9Ei/tmj/tAkg+Sj4yzlFJ7cbB7ilzIXrBxjMcxgKKmXU5BtOjqDVvHPNl+cFalKmytmi2vg8J3cZL4G9ISI34pWXX6YOX9BM1ASVRLghGW3/vs85MMalID0oPLi++fYNkID8T6XPRnqHKlURseErmJVdicS4g/7voidBpE2xlZ6DnxMOCRg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ec70d14-8599-4342-f2bd-08dafdab7970
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:36:54.6588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6xYkzbT25TGFFqTg82ojBYKFJNgQ4OYUk4GPzoVjvDUlLPDE0qgcQwKTqrYbNLAm9jvXoBxmWe78/cNIXIvCj5ZYq5p8bE8Toq7OWM4SFQM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7074
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240010
X-Proofpoint-GUID: MPoP9XXx5tcnoxGf5TE96KKKszuP8iTG
X-Proofpoint-ORIG-GUID: MPoP9XXx5tcnoxGf5TE96KKKszuP8iTG
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
index f07720ffe977..a24043804c33 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2867,7 +2867,7 @@ xfs_rename_alloc_whiteout(
 	int			error;
 
 	error = xfs_create_tmpfile(mnt_userns, dp, S_IFCHR | WHITEOUT_MODE,
-				   false, &tmpfile);
+				   xfs_has_parent(dp->i_mount), &tmpfile);
 	if (error)
 		return error;
 
@@ -2893,6 +2893,31 @@ xfs_rename_alloc_whiteout(
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
@@ -2919,6 +2944,11 @@ xfs_rename(
 	int				spaceres;
 	bool				retried = false;
 	int				error, nospace_error = 0;
+	xfs_dir2_dataptr_t		new_diroffset;
+	xfs_dir2_dataptr_t		old_diroffset;
+	struct xfs_parent_defer		*new_parent_ptr = NULL;
+	struct xfs_parent_defer		*target_parent_ptr = NULL;
+	struct xfs_parent_defer		*wip_parent_ptr = NULL;
 
 	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
@@ -2942,10 +2972,26 @@ xfs_rename(
 
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
@@ -3118,7 +3164,7 @@ xfs_rename(
 		 * to account for the ".." reference from the new entry.
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
-					   src_ip->i_ino, spaceres, NULL);
+					   src_ip->i_ino, spaceres, &new_diroffset);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3139,7 +3185,7 @@ xfs_rename(
 		 * name at the destination directory, remove it first.
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino, spaceres, NULL);
+					src_ip->i_ino, spaceres, &new_diroffset);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3212,14 +3258,38 @@ xfs_rename(
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
@@ -3234,6 +3304,13 @@ xfs_rename(
 out_unlock:
 	xfs_iunlock_rename(inodes, num_inodes);
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

