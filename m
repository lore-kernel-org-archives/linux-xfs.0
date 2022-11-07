Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DDD2C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 09:03:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbiKGJDU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 04:03:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbiKGJDT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 04:03:19 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3321658C
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 01:03:17 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A75fMHP025318
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=HIAnIRA3UC739382SV1AB0MqFsBTLdzPYzCA8y8GH4g=;
 b=Z98lTHWdN1vF/wfAYlavnTO0xlbbTMIZJ3cvJGZS26USTIkwAlCq1UQznrV/S13VInd8
 grNNZ6NFjUvUPpPNcsexDvGah67DN7c+CCN3+ObQa/NyrtT3n48NsrG9oFIfJ5O7cMYy
 3IvheENibo1f4H8CxLZfYyBiDgkxs9KVwQRIMwQ2UAIzIoo6ERD59vCXfrX6I7cGMXsb
 K5eSQ9EtmrshLQxrwEbmiqUhZ7460VB8Hh48BqC6p42iQ7QcHEduKCAlOA/IzuAQVil9
 ivpERmcD0Cb1Y2sx3rtLqWszpG3rrOdn2qgeqliEMWsXPPNl98yCfqema+j3Sw+ocsj0 pw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngmj30jr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:16 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A77bM09015389
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:16 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpctatm1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J94rn1HTR5WqBdtY9qjnKSMQ5MMZWz+m7IceBlAZDki1gVN+TFFUTYV62xVECF1OD4XlFk8U4s6JAVApIgK1Envi/cPztXUDM/xl1AQG1frTYd+UQRN+b+OMlFMU9KMOwGH5MAEJSrBw/CV6/kJLxggEVsVX8oO01T7BXkv/FjbFgxhcQbD3xllQ5tP1yyQyBJyLt029iKToWI+zsRRARrMpg9A7hS06qlIkLLDVqkBqrUNXRNlA0D8UJ4hU8uT0Zllyyzxou54wxHvpIArDvlLfbZ+T16Oiy7I3vAFOmV0fN5yd1a5izZ/6cX4iXAp2wip4IC3VMC350C/xoLX6cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HIAnIRA3UC739382SV1AB0MqFsBTLdzPYzCA8y8GH4g=;
 b=c4nZRNyyU9UnsjtPihrWn+1sTDyI5biN/H5IHv+YwK14keP8DeH3c0AOgADgIAkLzp/MdLA/ab4q4o+H6/eRyUg1Wr40Ha23OE2nPGVXBxWSdUtYFEnxJaV+LmQHOJLYo/JgIh82h7ahkafD/m4Wb6NZbSP8MkkLzRZX9D/mjGphy04AttVCRveA6onjA5WgZb1JtcnourMqCsmTw1E3Zm23TLD2A9flO/DnWZ6krQgF6I5+uB1e4+2mh+xaiysx1bPv69rEYHS/fnbVlqGcbH48Oc2CuxJlGVtQMhapKx5ff2Plw50AI+Vo9tYQrvOEtfPdIXqj1H6YFQ3N2dXWcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HIAnIRA3UC739382SV1AB0MqFsBTLdzPYzCA8y8GH4g=;
 b=THgpn50o4+lQ7BOFC4czQMrarwnViy2lDRO1tV1oD33WWRZVyQAZZXcJC3bqf8CmozL7jz+bYmmxvPj3jNOfUS2GyXtWao+2H3O11puC0e79cpqV0n0fIou8ok8OzUIS8sKSxExrGqazzYsQ2pCS9jkaCD02ZsChg/WFxku17E0=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by MW4PR10MB6346.namprd10.prod.outlook.com (2603:10b6:303:1ec::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 7 Nov
 2022 09:03:13 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 09:03:13 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 19/26] xfs: Add parent pointers to rename
Date:   Mon,  7 Nov 2022 02:01:49 -0700
Message-Id: <20221107090156.299319-20-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107090156.299319-1-allison.henderson@oracle.com>
References: <20221107090156.299319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0361.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::6) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|MW4PR10MB6346:EE_
X-MS-Office365-Filtering-Correlation-Id: 327d800b-ec7f-42b2-3d98-08dac09ee67b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YJ2c4R/qQ8uK51JppaA2DMoVechXL99GMjNwiPr7cHr7LZoDA10HO9WLGWV0SA2jiEf0GTRNN25Ef0X23dNf5E3H92IEOG9AKRFD0Y56cp6LDJcgj2JGm0mDopBAJNdbXl9dTfTvKFwuhn6dqlDFGvOrkDHYpXiLcXWcCThypvcNA/5xt1AtGZKkoxruewAqWPwSp58HQ0RKYc+9yKj5umtKdfu+3jdhZGepslWTmn8TbfZ56rSpcgsYovZR5QdZCnAmNB1lPcnjHmafOvz06h4TRnaUPbxL8QP7mTv0ubkJkJMqMNPDtQf2UVN2VTMAVAP6FfQ6Mmem/hMbmmJEfzn3GczpT03F9I5XDnX5vuwJUtZkgjJh3AEi8fDRPlOvPQ4LTfyvX/XWSXvDTE5nwoj7lGrsi9sunFkbiOKz4THADnS5q+o9LHOZlUYJ/IVtxi9Bk2KE2INQPNj3yddbLyoETXvT5yh/vRtV4Hmcl/+OMlii0NwwPukzkQkJNdix2UzT3T1COcK48cfLKUevIwhnZRwVYmN63hRbb7DkrBDwvBCnlEBcpYySqh6PaFjkccF4TDm5aprUWqcnht2LWjpOQNmSTabmUGK8H9I/2KSFJspMbbtTWLPKHkFmWehPK4rjdUPrpQBgeNjYB/pRJVVcZF/o8lyWgPOyg45oo8WuVDjLt/TjQztAMaNWqrLwcRn1FZxOImSINrG5Hiz9yA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(396003)(376002)(39860400002)(346002)(451199015)(38100700002)(6506007)(36756003)(478600001)(316002)(66946007)(66556008)(8676002)(41300700001)(6916009)(8936002)(1076003)(5660300002)(6486002)(2906002)(86362001)(66476007)(83380400001)(2616005)(6666004)(9686003)(6512007)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mHygaq2OctHXVe+e85rqKprlYgSwL2iJwMR980bwQpVvn+n24ZZEW327/HmA?=
 =?us-ascii?Q?k2bH8WmvdgIw5bJF6PuMtwOZ4OVqnzW7RzERB1mPgdtBUU/pPDoJk+zHccgm?=
 =?us-ascii?Q?lBXfYYXmJU5ZL0mU39BCBhsCE9OlyKgp262j8Y2KrvCQqpvOaoCGk2X22r8q?=
 =?us-ascii?Q?k9qIg9X42VtMXgFV+eHP1iMiwIn54aOYliOGohA6S7cDrBvTUmAR9sPDzF5Z?=
 =?us-ascii?Q?TXXsH4Vie8XCQWf63i00KKFRSBwN3r94wQ4qP6EW7mvsEslwPfJAyQ6o8uxP?=
 =?us-ascii?Q?2nKzxPRb2HKKYvcoTYxTcbxCjWb+oMpkqXtX/J4RD8Zmx2y3uHidY7sNf8hm?=
 =?us-ascii?Q?CtX3BrKNISHJQEtTc5m6pUSgiTtxi/DvwBC6v0RUZbkgrrv/wTebFCXK7t49?=
 =?us-ascii?Q?aFyCDTzglliaXCNOOEL6bC7tgw8+PyD5PWTcN96rZQgXA+RsJknf2823Cosb?=
 =?us-ascii?Q?M3LN7w/McXMWDn1Je4GI5GLb99TfAj/fqZZxvWfQtOUnSk5mTVRhGOnWJG8a?=
 =?us-ascii?Q?avHETx3TWFMfo7lkTceWc4XrBhioG+IqCEL35lSh0a6XqIQVuT5OMnwmuxs2?=
 =?us-ascii?Q?ZdP7KOWY+GY5MpfhnMtDsw0BO1Rpne8rjGWLbU+CEW7GRGqhrg3bNaf6WHkl?=
 =?us-ascii?Q?vpB9bahk+3jtdeJpWigFh4HqxO8hm9gWcC+/k3QtULy+CE2S7IERy146Xxkm?=
 =?us-ascii?Q?0gqddT/ykS9im83W3gMsd9X9rr2wjqiLqLTrNA7ZTKnq2DEGplUmHZbQMvt1?=
 =?us-ascii?Q?akCrKyz8OV6fflGpSktWmhXgjRZagdv5kRtJfihgPfaaEkJs2exb39u/rh/q?=
 =?us-ascii?Q?+vFWfVdJT99wE7r6zjM9sVNaMfH8+Dzrg7Grs0UU9JiSgj3ItFtYR8/t+qVv?=
 =?us-ascii?Q?F3IgwAnES2gBOTJoLAQ20YW6M0fOZH8CjItJ8cCKRYPn1fbfC6+QJBOBoItW?=
 =?us-ascii?Q?fdoW5Va1KaWh2B2L9UbzsxCk9ByPP2MJULb5tTabgPr8ogtTK4OqgShe5SOs?=
 =?us-ascii?Q?YxQGxHXeEFHFo3cYZUv/5G1bFHbWthXox0BjIls7ZvMZWGDNT4WVa4JfHadf?=
 =?us-ascii?Q?bqzPV3EtvO36hgn5AJqSB7QVcgpyVgRWoxOXyU/ZRUE9YETlCdNelkq7myAh?=
 =?us-ascii?Q?dPU4lejArD6/we0zcbA7UsIscEMFlq4eBf25+49TklsX+UqpaQ+dk5deZsIi?=
 =?us-ascii?Q?2QAZNKEIh63HyCfmtSl87IqeAjgksgK/H/UgZMVK4DQdRBIpjaWkmztAWSvr?=
 =?us-ascii?Q?PRi3aPq8I6/VdmOSyxTeWvdfYsJdG8H3dPgVji1w9kop7Wz99kvbz07omvdL?=
 =?us-ascii?Q?6xtsjv/PJZnJDWcIciB1XzWR6P0KDOTh9OTszzroL7dGw57niNCZLk+jrTtk?=
 =?us-ascii?Q?RT+PcHm+Sh6MCCUCnfKl2l05+bxxdptabm5Wb8HwYN0Xv5mxLQJIoXnkpyJ6?=
 =?us-ascii?Q?jsauMMT/yy4tjlCrDtB115R245l81maYhDBFy309xg/iObZRBkmRqqECg5bL?=
 =?us-ascii?Q?44VUdqG3WynA3iRen8jt0cBDjCvHECXXPxzoddO0PmcbUWJMUOAEREFBZcjN?=
 =?us-ascii?Q?OQZXVEojTIg+flZSLnKvXWqkIQ1Owi/Hx7zmCTBRq2uNEmb5ADvi4TDptYHm?=
 =?us-ascii?Q?GA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 327d800b-ec7f-42b2-3d98-08dac09ee67b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 09:03:13.1485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7FbiHA7xPyaa+RW93BXxVzr4TmYG/LcXpjiVO+zAA/nzFNsZSLoUcU2TDqnRSxxBM/dC3TMmU87Hyn5PFEiNFuOUqLzsUZf/WBkr15TPA98=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6346
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070076
X-Proofpoint-GUID: QUsamdUzifvf2HftLs4FlaS5C_wL_Lcn
X-Proofpoint-ORIG-GUID: QUsamdUzifvf2HftLs4FlaS5C_wL_Lcn
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
index 22b1b25ad7f4..d0b7a93655bd 100644
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
 
+unsigned int
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

