Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4FDDC05027
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 01:36:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbjAXBgh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbjAXBgf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2023 20:36:35 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E33C1258F
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 17:36:32 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O04YfK021740
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=1xoDYsuWG2SRerMtDZ+ug4VReqHwhjGAddR6C0EnDaI=;
 b=LTF0UaG+YBIRugp0XIQjasq+8+yG/FzY6b5dWsg56Fs7yBq7S8moq4kMEavDapVR2eIM
 CWXMgsxy30nIkPo/3AvZSebYmHqImOOMcyUZrA6W5AvVVTfou9icxP4eAYmPjuaFXIqV
 8Xcv7zflr+5kP2stB4SWmG5UuHb+gaiAwfvcxSbRN5xUUz4vZYBuUQuCDyaZUpQ9oNnN
 BVexPl1kbexZiCF2cV+VL5Nc+ZHBQbqC4vpnqN18aQ52KX+tAKuCgAe2f7AxEXGavIXu
 hQ5CDewZZDp9GneSMmcg+YmDKxd+ECVyj5YhvVUXZ0v8nUVXr4hdCONtlgrQ4GIhAgSy IA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n883c4afm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:31 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30O1UDZu039617
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:31 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gb4auf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FVp+i/xra4BplNck6AEB9dw/LIUrkS7QReb/4iF8u5bvVSpt0nb8Zjxo0SD4HU2Xs4pCiSOF8MmBZMZjrbAwwtM9JsSeQKqdtTPGT82IZqGsNiFBXuoSJ6s1SMb9YJUCmD4Gck8YEuYHT3lR0WI46y+xP2bD77Ql4wAQQyHIIPpQ28SZUBsPjopOSsT8tLSEMAAxYXutOIRdKvaWyh1Jxqqjv5H7KuBlcQVFWdIJriEOfL1bMzjMUN/c9Bplx7L6FZB17zZq1qkTk3+f8zIlH7wpXbUc65JUvtJZuTYn/uQqRzVOaRHox5sKQJzfDeWhl45eN+KrLClY5Ogq7ri+5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1xoDYsuWG2SRerMtDZ+ug4VReqHwhjGAddR6C0EnDaI=;
 b=AQyjDzmYzfbtTDaDP5KUr7aQnNjLhXNLzxi23eLqZH6CbSLCoMxumsB45usb14/z5zO2wO2YPS/MdULXVSmaNXBFnsyPLzfiozAfCvcjjpb8vxh0BBK/n7fQ//1zxbUD9H6XJ/Hjb2sbVfSdiWrGy1S9T81j2SUdzTpq2i0KicFrj7uzdJty64CVkqC1hXtgi7wGP7lFEPxMKr2kIIcVkXkqnu3l9vDXRIgeZDZNYYzbToHu6gLdxNgdAWn5eg3AFteG7lXa3eR7I/sy+Z2Rhh47IPktn7n3cqh+d4G4xHJqC029xKagqQcUxHCsp+p4MhSPyzwT1I9/K5W/APvdkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1xoDYsuWG2SRerMtDZ+ug4VReqHwhjGAddR6C0EnDaI=;
 b=can+xst1O4y++VQ3OZNAyOBOPyKFAzepex8byrDmru9HvtD8HPrvwEYX3IrkVtviCmXVSHQTLiPwNv+LmjK2isrA0VrHoVwq4cpWVzMwrme0bn5p1FYe1IjbIeB+mpd95HM9PgFgN2snLq7RKJfwQH9FZoo81KETK3/16+zGgsI=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CH0PR10MB5052.namprd10.prod.outlook.com (2603:10b6:610:de::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.16; Tue, 24 Jan
 2023 01:36:29 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 01:36:29 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 04/27] xfs: Hold inode locks in xfs_ialloc
Date:   Mon, 23 Jan 2023 18:35:57 -0700
Message-Id: <20230124013620.1089319-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124013620.1089319-1-allison.henderson@oracle.com>
References: <20230124013620.1089319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0022.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::35) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|CH0PR10MB5052:EE_
X-MS-Office365-Filtering-Correlation-Id: 885d1f36-169d-4021-19d5-08dafdab6a21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T7Eom+tuDGBa0a90esgmEorUd32BB/OclFTOqeN1dK55pTU8mzGEmNOPqp5ZhARXDJz6rDo+AKjvR45PIlHve64kGcn1c8QoBqlLxz+BYz59sAcbOKKo0NV+8bnDn0p5cNU/WFM5A4Ak2aC8iLs+g7JZdblA9COtYgVUl9AP4bXkwMVrb7CifIaHVCwA+WAiPqO/aogPIP04uLQ7afJLLmsNqhjuWeOJT+qGQzFNk0VrPEtpGpgcbX9wBOxZnvyYjjxy343PyAGX8488Mx2DC2zhyxbx3XHzjvWC1BhwSfZOsWH1BtbvvoIKLtwClzU0L+g4BbcqRWnv2Y0fMcNPg7tUphxpccaHJzsH1AhdS9pPq92qEPacNB8+dYmLrFSFQebOaP8RxrTvaKtCeaQK9asWMLzV1ZJS3l0+Eg49ZV85YnKgS5HoT5ZISKHOOeynCL+4WemTcN/NPTgOj0h6P+ex7wfmFEt1A5qhwNeMcDJ28dyUJsaP8mF+clwcMliVcb7z7x6NwqZeE0FWebEKUnI5GovQZu9/Tj6Smg3fqJMc3g1H/sqvSC6YlGOVzJiClGDkdV9qS2sRY8OfaM6lOX0Ys9TYQBFdzbbf+3Zz+gQ+K5CU1pahcgTdy9hsTFeMFAJeVts3wQBSyHxbUBmIhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(136003)(376002)(346002)(396003)(451199015)(1076003)(83380400001)(2616005)(86362001)(38100700002)(36756003)(6916009)(8676002)(66476007)(66946007)(66556008)(9686003)(5660300002)(2906002)(41300700001)(8936002)(6666004)(6486002)(478600001)(186003)(6512007)(26005)(6506007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?du2wkKOMGu8rajkKQlZwQvVK5B+X0zyeU5gX5IP1dlq19IaLWwyDuG6189Zb?=
 =?us-ascii?Q?O40FVa3AhjXeO47VMAGmfOY7aeUQNlMuTXPtUoEeWVvsvK3IIgLTS4SmmT2x?=
 =?us-ascii?Q?2yoEXN0vowIrRQsPKQ6oRmytekpIRYwIDj1jAfGMzY/NYTK0OTiOOs6dlzoJ?=
 =?us-ascii?Q?QlT/hcLYIV7gGijvSA7MOKjqWNqIdZbdxENEV9uYpbuGHSzxAOWSqastdWXN?=
 =?us-ascii?Q?YwJVlE1k9xLXwROh3sWi7DBMncItxlaggrXaPDnlQmCnlzFmJ6oCihwP2N8f?=
 =?us-ascii?Q?xDMMZxi9ipP+CMVnTvtdPdv71hMkBhnnrpJKbLdlkFqt4kpMEW0AcCJTSLzJ?=
 =?us-ascii?Q?y0JQyjlkzbKCJ/RAt/MDVNqZMNlimvdeTuo5Cn9PC2h/T+BMzApm9qyj8t4/?=
 =?us-ascii?Q?R4/KUb7HVfwb8k5KaE6Y2aPWSHAtP+PYz/mBiNLa3xoA2fEZ4yRhTjG03A8K?=
 =?us-ascii?Q?HFyFS0XgL66wP7DCVYNitPCnlUGweDDUwAkB+b5wxLKBQYPPn0pciXCZOKsc?=
 =?us-ascii?Q?q9tIz3HTKhWQqx7WCsM8EOmLY4gpbmD33djb9++Q2yFOE2KjMsOWCif2D4rH?=
 =?us-ascii?Q?+vq2A+I/82fih0KuZs+RXeXHJ7L/wj1yx5sjf7WGO7CwHEIHCgq3Nhb+WGQT?=
 =?us-ascii?Q?4w44nUqXXbW/8hT4uZRU3kfukgwYxAcRT6H1hEsFBALVIG/WlXCXPuGzFNxu?=
 =?us-ascii?Q?mPW49HuQcsyAOxcUIaghSS+ZcBuj+O7Rs4jFWWlh5N9ehfteoNfAT4tD23jZ?=
 =?us-ascii?Q?lKS/HnLOm9bRvKM5VaGm6TXpUiwpM4bv7+th2iN8OrovtRM4Hoj+KmqbEGtO?=
 =?us-ascii?Q?U+sTtynOcYgj8Cq6ccYyiGAKmJua+MWIHLRwE/QGEtIPB1iJ79VaUmfLY0tO?=
 =?us-ascii?Q?0ebIbvboC+9uQZ/Sje/CXp72CIupnjSNbpWhI6JqJm9ncvlU+ZnDL/jLIP/e?=
 =?us-ascii?Q?+rUuQuDFdfUopRf4jGI1uaHad6tjR9pJQY2zRS0/i3cxmqty3bUTw6W84T2S?=
 =?us-ascii?Q?7GMmu6kJcCaGpykfxMf8KfJUjU6NFfJs7WOua4aEVfGamVFkfJUe07PZANaC?=
 =?us-ascii?Q?lf0GVBHUY73DFpMd+l1j2xADoZpMydWFQTPKM5LCGlnZ8NxOF/BhAmvqxvmJ?=
 =?us-ascii?Q?8zwh3apa/WluKqe35jv6FPa9WbndCM5MHnhhNWBjbKjGw/mDJlFh2LLkgjRY?=
 =?us-ascii?Q?/NvoecToiz403VY2Kunv2dNO+AXoNgAr8ydll+4K5ZkfLUBMl45p5ACE19RY?=
 =?us-ascii?Q?isdIYj94ROmTfVsvFeSg8N0NdVoPKqk8rRONd8xRVbvca5R1q44hR81o2g4i?=
 =?us-ascii?Q?tglhM5fJclsvx91kW+tn/eU5XKZm2a109oMHJ8IkMdPkoS+pObsQr/HYDu78?=
 =?us-ascii?Q?qH2Dyd36e4yNRZaNENlZBIgBK81+cjaIupUMjsb3lWXbxkvGiOGXaW6n8f7f?=
 =?us-ascii?Q?e8p6SQnprrjNBPiBUc9J8uIdsCn8CYZ4BmPJYHD3ZjTnTBk+EE/5RikAV7yq?=
 =?us-ascii?Q?6Kw3bxECP7RerK4U3a8AgRD9m0RAcWXDw7lLNoBTZibQIk72IZVu53lqg4Ny?=
 =?us-ascii?Q?1gdLg4vf11iwVJlcgIZLu6tvc120L2yq4dieOjtZgxCkvd7gXvCugtXjRFdC?=
 =?us-ascii?Q?/Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: wjyCQ7A4yzZGESa/ZX6Rjoc+Gd2PZm4yK1t0F3Xm+oyjaBFZ5CL34akcOxH/s7z6tmGaIGY/5uXOCALj86rSSwxuwVpYodeserhLde4FXD9XZ4+5aakSWfCeYC8RcR5brEexWqMzsOtCBPnKWT90CqJO6CI674qvrODys6+eCfd8Jv5T8tMyiji3uObWu9q0GGJPkGYDu1KZuvcSehwTAidIqOLDo8uOkGXGL64ZWX15rEjdLPxb9absvPCdSAbaOCYlFWWjg6ns3t5Lyzr6L6CSDnZ0kmQzC5Djo+9Y3yO8je4d0sIy5nep2xiq0yxx8ngdn6ny5AumU62D4yzX2XYk5fn1pcbCt0J594d8O+bOCSOwVOSx3GEOhJHEhkHn5tlnzpGM3WSkgQwOBpOL1QgLb8drQln1+6rtHPAFan1v7rErCcBGxDWlaJRIbzsIT8lo3Cr3x45/YPsrq+2YaJtet+CjWNslzDE6Ubb6/bPljFnhdwpEJtKcoNEVHskJa6QicEsVnxZGGgW31srLzkfOrJgH4zq2oGO8qcIRJxHOCYXNqtM2fTFo0V9Ieb+tfAyY5d+4e0z/vAK0YksMnAgk41hyP3ROFaf4ZRP7elZvOEGjlwaZPIpTZd3pabwE9WmPlWF3CIpvOkVIts+cFZiLpiSV+3v1a3KbmXk7ZHHZeGEM8ltTzz90iXuwGGOZBTKh8q9I/QePgQDumsAHIDSya5iNiGkSBe32i7uBBkM6A+0RGR+b6+fzxxd1xpJUFvNATg74zIV7vnzJzD0N6A==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 885d1f36-169d-4021-19d5-08dafdab6a21
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:36:28.9854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: caNxjyAKipfe6S5KTdKonDyeR8wg8cGe+suyUA27syyABGomX3pr6bhukiUgt3cFDke/n0T5LJmT39bUwmwlrZ0wdigDJB+eqSETRTYR2ZQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5052
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301240010
X-Proofpoint-ORIG-GUID: WmTDwJA6bd0goAY9HO4RaAvAW9Qxw4V-
X-Proofpoint-GUID: WmTDwJA6bd0goAY9HO4RaAvAW9Qxw4V-
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Modify xfs_ialloc to hold locks after return.  Caller will be
responsible for manual unlock.  We will need this later to hold locks
across parent pointer operations

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_inode.c   | 8 +++++++-
 fs/xfs/xfs_qm.c      | 4 +++-
 fs/xfs/xfs_symlink.c | 3 +++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 27532053a67b..772e3f105b7b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -774,6 +774,8 @@ xfs_inode_inherit_flags2(
 /*
  * Initialise a newly allocated inode and return the in-core inode to the
  * caller locked exclusively.
+ *
+ * Caller is responsible for unlocking the inode manually upon return
  */
 int
 xfs_init_new_inode(
@@ -899,7 +901,7 @@ xfs_init_new_inode(
 	/*
 	 * Log the new values stuffed into the inode.
 	 */
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
 	xfs_trans_log_inode(tp, ip, flags);
 
 	/* now that we have an i_mode we can setup the inode structure */
@@ -1076,6 +1078,7 @@ xfs_create(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
@@ -1089,6 +1092,7 @@ xfs_create(
 	if (ip) {
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
  out_release_dquots:
 	xfs_qm_dqrele(udqp);
@@ -1172,6 +1176,7 @@ xfs_create_tmpfile(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
@@ -1185,6 +1190,7 @@ xfs_create_tmpfile(
 	if (ip) {
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
  out_release_dquots:
 	xfs_qm_dqrele(udqp);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index e2c542f6dcd4..fbecf54d3b44 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -826,8 +826,10 @@ xfs_qm_qino_alloc(
 		ASSERT(xfs_is_shutdown(mp));
 		xfs_alert(mp, "%s failed (error %d)!", __func__, error);
 	}
-	if (need_alloc)
+	if (need_alloc) {
 		xfs_finish_inode_setup(*ipp);
+		xfs_iunlock(*ipp, XFS_ILOCK_EXCL);
+	}
 	return error;
 }
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 8389f3ef88ef..d8e120913036 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -337,6 +337,7 @@ xfs_symlink(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 
 out_trans_cancel:
@@ -358,6 +359,8 @@ xfs_symlink(
 
 	if (unlock_dp_on_error)
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	if (ip)
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
 
-- 
2.25.1

