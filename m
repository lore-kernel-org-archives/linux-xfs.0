Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CFDECCA479
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 20:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234984AbiGRUUr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235027AbiGRUUk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 16:20:40 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26102CDD5
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:20:39 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IHWxPt024758
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=R7juVH4yEheSRsOowttYdHOX2VGophursraQlbr6BPY=;
 b=WW46dSJg4ilSehrP6hWl21/m09Rly+PWDen2uKPpZy/Aw6vMb/ERH7HQqMm2iqpnen17
 H8qwlVXAmNoYrjZJG5D2W188DnOUSxalRiIJg5+bhrmL+0pDdVDPi+mdHlyPZ8AXr5NT
 fgLG7bpQ33MUZo+7ZUePuOwo3hqvhjBXIKs+SFztiw/zWrxRwuS+H8rZ1TaHPjA2SQjg
 3yUj0YFIxv7pcTpBryw2rFZ+p7HxPYngGaIrdHbq1CwwvETNwAftCW98FxsvEmt2eI0T
 vMFPD7zfLYyoVdxmO2ksRvApNwbLji+6dk9nbL1dj23Qz+mEMcwxUGh0kdq7QV1pG47B nQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbm42cej6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:39 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26IHVRRx007937
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:38 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1ekx2da-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VFT9LEBny/2n730F12isT/PTIFnpfYTAjo1kOEIRJl8MX6vst++CBwb+aWADjJbpYJJzKVVugFxjY+D6dpBeLvvqVr3ieNpM3DcQWE2Abp/zh2+e/bMMs2HtUjYM7L0DLTq4udX/AIUASULYEFHV/wNtwQ5nkMUrI5kY+Vy/qYuxhAQA0GqZN9NSbUur5OZre/PNi5l5a3u2A4K6ETj1LnIAEJ55ao+RQ3DGV/d4+OJnoAjSGyzAvjm3McYA0JHhUGFQYzbNcSM8RyM5NCR+An6jNq5f0BAETV4zBDYyRzSs0Lt/IJLtXfcPgq4HEq5zQnz+8JWvQANDJrvMp7IpIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R7juVH4yEheSRsOowttYdHOX2VGophursraQlbr6BPY=;
 b=c3jU/gGTAd5fLIAc6KvfGUOIARauUC7h5/Ahhyp7Y8Va2Ldlg4z6lPOKLOMosYSGaLfwRRU2MFVEj/joDHJhGjR9HesppKM+DQyYGKBLP3+zM+dnGbZpIx9H45Vp3IUlsnR/+k3oZr+Dx8K2kwu7Mm2fRQnHu0qW3RTbW8iTWTXlNjmRSSxdst/DD8pl987/pf7fl1gJ4WyDOF7cmpT6L8WljBsQgM2hwuonmjUrmoVwaDGqPj9qzTD/4wh+GcqAsn7Ag/AJqyXpceOn2xvqFbZ2rwJWILGELy569Tysj0TgPCQFKlsx4Q5ogudffxhLf7P2Sm7hqiJA4sKPXwKwJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R7juVH4yEheSRsOowttYdHOX2VGophursraQlbr6BPY=;
 b=gvx+PK9YLfpzwow5FdVg/I/cs6RpIpuZAnpu5DKxsFNvYtPAjnETiKOkRDRHs6gl9o5Qc9KHX62fK+N6YFMMpBzfRvSnt9qVx+Stv1HUHYZQZnwRIGganST4xDChOFxpVcM1QjUqY7kU52RELcBgFIUnr3V42BZJ6r65MohUfoo=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN6PR10MB2717.namprd10.prod.outlook.com (2603:10b6:805:46::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.22; Mon, 18 Jul
 2022 20:20:35 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 20:20:35 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 14/18] xfs: remove parent pointers in unlink
Date:   Mon, 18 Jul 2022 13:20:18 -0700
Message-Id: <20220718202022.6598-15-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220718202022.6598-1-allison.henderson@oracle.com>
References: <20220718202022.6598-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9721bfa3-c622-4b48-a3d9-08da68faf76a
X-MS-TrafficTypeDiagnostic: SN6PR10MB2717:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wUA3Va8vvltX72DgsOE2ozdwR7dX18QocNpWVqKgwGnqNzfAOGrsPIdCjCEN+TYxUS298Bkih3lW8Bf91+d1H5puNojAiEYkfLcCtGSOGM3599yW45PdNElR5ADEKyf7SIU4waHAKnfvW6W306VKnb7mB1lFXTW09D7b/GjFoq/HIQwgFicwgZugNjAAbC9EdGni8OMY2O5mFkM8fvtb/4j7YNuHqceG4uMlNDnBuRkPdkih9tB2i9ivfzg9hU+i8kZ+2TvwehcVs4fYmjYZRcz2irPsPZbY8Tva+n+pzMF/cF08OmN8ItgEPf+SiNLIbv+TqCzAPVJ/ILmgHs8JomcBJ8FQAlUlztprM4BA5J/t9iQvAKNI6cMehyAfFMYhWPz6dSLY3kS9Aj6Xz3n5mYjssE3+Lm5wZFgMcnvYoNRfcgcTc4bcMu+xj9QFaPVn6rDD7kMHofRl2HroLZfJDD02NQpZbYe7PoTAC38OZmEWhuQ8wcRRrZGb336UTisdVu0LF3s/IHmms4pW6PC4ugzD508bPg377T1VbZp/qNWvKmyyKFiwSFGNFNPXqgstuVViVGOlEtOjZZjmCOFM+PtdvDHYSfCTAKTJApaS359//DHYwY6pkOEIdEZhHkPSt9p09aseZHfE0d0qvo54ngIJ7VYzu7TuGe1aMfO+WAo6q5RDAG5HlcVziOB+D1Vx7ZgKIdgLnKjr/pA8ZkfEG4DXvWUBuXalYH05k2d5fjtZhpm9vwlS/eWrAUziP1+HAvZuxWnF4APBa1awc+tK+QVZ/7fR7DWEw+TP396D7cM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(346002)(366004)(39860400002)(376002)(66476007)(2616005)(1076003)(83380400001)(66946007)(8936002)(186003)(5660300002)(2906002)(36756003)(6666004)(44832011)(316002)(6916009)(6506007)(26005)(6512007)(8676002)(86362001)(41300700001)(478600001)(52116002)(6486002)(38100700002)(66556008)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gubZaWVToJXJArYlYyqdzbJ73hP7ffZ5RrCSUInyohpu/ELZ+WxJZ3eOhTMo?=
 =?us-ascii?Q?ZdbbcHvxyaQKvqzHYLXS8uOPVsD7JhGuU6UEnnCflHxzCVFarNesziKrl1EY?=
 =?us-ascii?Q?8Y86DQ/kAYQWKve21zofczV+hag9HfRP202BsbGm1W/qx+gWQPKeR0EXFQaK?=
 =?us-ascii?Q?lrg8YILnqPlNWquf+pygJdB2TUHKs0A2JlZqH1QSGbRbF3+7huWb4eFLv92/?=
 =?us-ascii?Q?v8hDvqO2VIHcuu9IZtoksvbFHLb7817tIEqn1XBCImC79fUocTixLygq+A1Z?=
 =?us-ascii?Q?8OEwRq6MjGKlrnHXGVXzgtfwFYazXBm5Q9OPbpFKWPhLbvxcFny7ZwdUrxbx?=
 =?us-ascii?Q?W7xj/y0RcTL23BR5TqCph8O/vwBkfhDTjju8Mk6TSLjUw/yw8STKCtjzkAqr?=
 =?us-ascii?Q?8rg4tI7MguqpnhvfQCwRCoCPrJe0jk4EnfYG6o9zKiljog5VEkD2sXheQawM?=
 =?us-ascii?Q?QBMBLQg3aNLAsIb+ikjbiBF8BmB/1u9cStmE8OTntYBZL8Tz3egWQS9ZW1LK?=
 =?us-ascii?Q?yNe6k39oJ/g7Wsevgi3+5QU6/ecZK6Iu1H6RdGoAKTbundVBykVuysvyC6xj?=
 =?us-ascii?Q?llNNQtZ5nq1pXUa7VtjfFeWnIYtNzR3OMNf+l3UEQHNo0jH2G/0Ioael3ijt?=
 =?us-ascii?Q?34ITEy9grd33T5Xg4hbVnJSApV8NIxic0UusCm09qzs7htDwrbYJbmm/9zh9?=
 =?us-ascii?Q?bG0GpPxAFdUywOZkz5UnEnCyDAqlZW0eGV+dMdV3pdEkoCJRz7Mk/eB0VME/?=
 =?us-ascii?Q?2FiQ8N+z/+SPgRcZQ/6ULCqWbe5aIYb7pOOSvPBL/TN+HPJf7ungo3FZzVbj?=
 =?us-ascii?Q?tSnmG8cSQwGG5KMbP7kdbPXuEAn8lALxTmbHY504g9gLmf/oihvYVO58zY/V?=
 =?us-ascii?Q?amtXtrKAg++YdtGA/giUggZW4PG2FPJjIKjWgnMsdQuvnO+X8EFxI7YvDl97?=
 =?us-ascii?Q?9x15bS5UEDNoc5dCVNs5hVfbPA9bUmo4Gn3KUqwEfgMT7xEfpC5AY2vaQDJa?=
 =?us-ascii?Q?+iP8zgcmQn1BdCUBL9mMQN+6XJcqRo1X7uQtbrUHv6KEaSI+5Qz0MYZUCZy2?=
 =?us-ascii?Q?Wwi7pkhNzA+O4WFh9xjomWCsN66S9MfPNStgm3IwIbTMNAsIcBocRjGzg1sr?=
 =?us-ascii?Q?M04uOEAw/yG/gxt9uGovg3vBqqWLPt/YArMQ1qbKiT5ykTu2GobcUrx6oUnl?=
 =?us-ascii?Q?osJ6vp6Ms/jWdzGhiISZN9uxCM1UloMiAp/6SozaSEGG0PCxlMmGLlHo/zC3?=
 =?us-ascii?Q?Ed2zMv72jU2xFzit2r7fN2hTbtm9Mw17FBcp1TSVghJfqo9LjHKBQeo5oCHG?=
 =?us-ascii?Q?UEZxvrzIX5/McUzaigve5aQH+BHA1EChx9QkULaxsRDZS65300FAjkJxzibU?=
 =?us-ascii?Q?0oHCwS/NM1es8pD57noZtyuhI2WoFKMzHNTF2AeHh1YS74jOwI8VJOY2whL5?=
 =?us-ascii?Q?+uVM5ot/Yiap47h0rtuiSWSa2ynTRo2APVmEL+5mjQp6oxk2HZDXCC+9zEpp?=
 =?us-ascii?Q?5cUFsC8ap0FaaedPD7wC1R+L5GGiprbp8oYGgaQoY63reQ6tcuSVFijm+46G?=
 =?us-ascii?Q?i05GhFNwyrYnYkpP0giU8RlrTJjyU2okqmoJ/aiAlSPlVROf6s9zoodAUd03?=
 =?us-ascii?Q?yw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9721bfa3-c622-4b48-a3d9-08da68faf76a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 20:20:32.9670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JIxQjtERMoDGNyPZIM+IMjW34f4fSDnFqq/pNQLj7TGTCGesuTOmPRZrEHne3A2zKlDJO6rJipmuud8a0Er+8hkLR84JDRi2HQmMJZ5lFww=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2717
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_20,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207180086
X-Proofpoint-ORIG-GUID: F7amkuA5t4q6TdZSJZoAGtxYWzG_DXAt
X-Proofpoint-GUID: F7amkuA5t4q6TdZSJZoAGtxYWzG_DXAt
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch removes the parent pointer attribute during unlink

[bfoster: rebase, use VFS inode generation]
[achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t
           implemented xfs_attr_remove_parent]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c   |  2 +-
 fs/xfs/libxfs/xfs_attr.h   |  1 +
 fs/xfs/libxfs/xfs_parent.c | 15 +++++++++++++++
 fs/xfs/libxfs/xfs_parent.h |  3 +++
 fs/xfs/xfs_inode.c         | 29 +++++++++++++++++++++++------
 5 files changed, 43 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 0a458ea7051f..77513ff7e1ec 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -936,7 +936,7 @@ xfs_attr_defer_replace(
 }
 
 /* Removes an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_remove(
 	struct xfs_da_args	*args)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index b47417b5172f..2e11e5e83941 100644
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
index 4ab531c77d7d..03f03f731d02 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -123,6 +123,21 @@ xfs_parent_defer_add(
 	return xfs_attr_defer_add(args);
 }
 
+int
+xfs_parent_defer_remove(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct xfs_parent_defer	*parent,
+	xfs_dir2_dataptr_t	diroffset)
+{
+	struct xfs_da_args	*args = &parent->args;
+
+	xfs_init_parent_name_rec(&parent->rec, ip, diroffset);
+	args->trans = tp;
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	return xfs_attr_defer_remove(args);
+}
+
 void
 xfs_parent_cancel(
 	xfs_mount_t		*mp,
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 21a350b97ed5..67948f4b3834 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -29,6 +29,9 @@ int xfs_parent_init(xfs_mount_t *mp, xfs_inode_t *ip,
 int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_inode *ip,
 			 struct xfs_parent_defer *parent,
 			 xfs_dir2_dataptr_t diroffset);
+int xfs_parent_defer_remove(struct xfs_trans *tp, struct xfs_inode *ip,
+			    struct xfs_parent_defer *parent,
+			    xfs_dir2_dataptr_t diroffset);
 void xfs_parent_cancel(xfs_mount_t *mp, struct xfs_parent_defer *parent);
 
 #endif	/* __XFS_PARENT_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6e5deb0d42c4..69bb67f2a252 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2464,16 +2464,18 @@ xfs_iunpin_wait(
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
 
@@ -2488,6 +2490,12 @@ xfs_remove(
 	if (error)
 		goto std_return;
 
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, ip, NULL, &parent);
+		if (error)
+			goto std_return;
+	}
+
 	/*
 	 * We try to get the real space reservation first, allowing for
 	 * directory btree deletion(s) implying possible bmap insert(s).  If we
@@ -2504,7 +2512,7 @@ xfs_remove(
 			&tp, &dontcare);
 	if (error) {
 		ASSERT(error != -ENOSPC);
-		goto std_return;
+		goto drop_incompat;
 	}
 
 	/*
@@ -2558,12 +2566,18 @@ xfs_remove(
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, NULL);
+	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, &dir_offset);
 	if (error) {
 		ASSERT(error != -ENOENT);
 		goto out_trans_cancel;
 	}
 
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_defer_remove(tp, dp, parent, dir_offset);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * remove transaction goes to disk before returning to
@@ -2588,6 +2602,9 @@ xfs_remove(
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

