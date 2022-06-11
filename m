Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 681C4CCA47A
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 09:42:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbiFKJmS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Jun 2022 05:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbiFKJmQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jun 2022 05:42:16 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B652AE6F
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 02:42:12 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25B3vwxc029669
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=LLSFn/qhyYnhFTN0rnJR8gD2cjGnPL4Uj2opv8r2ZqE=;
 b=wcDW1TvXoIFM2v5scwncqs33MvWseuC+iJBpVx8NnM6bxoUjToOlCpAhzlj/KKPIsJh3
 IJAUj41S+/rQGzZP/KU0452WGduBxfTOLurQBV11x1BieX+xEd96nXdA+lPaaG6OT96o
 pFbYhj/MCPgNXi/X33U05yiWBhXmFNgKcorkTiUxkAfN5WvQkrDKJdb7qmZ9PvlLKjkY
 OLbcb5AvtxE3ttxsdxW23S8WQ9wgQg48EF/n08lRT5McqrYTgrzN16KC+cNQ3n10HUnq
 yLTVgEJoDsoSMpSOf0lFqNdrYXVPrF0Tl36RaueJhHstn1Mg2nrYqWoTWE6BuQgwsQn3 PA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmkkt89wa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:11 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25B9ZMQ6025527
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:10 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2046.outbound.protection.outlook.com [104.47.56.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gmhg6urjp-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nM/+6Qh1AhqR0YUF1bgtvNCCZW8Dt2OkvFBagyeQDnSv9pm5QWERpc6aUD/4tZkC8PgFqibHAUHsuNhNXLLWx3tnY8jeIm6L224TknNFNY7evmsQ8DtGJ3E0OWdnwtHlPNFKX9DSc1vUPaZ1aga3D+E5aM9tNhEo/QFa/BxNEF9rIXoKO1UrUPYtlBPA+Ke2sframouT/7ElvQj+XlLpoZeWqYQfr2KVWL1rMe6wUmKs3vzzCuvTIFKTttjC7MZRDt3pKoEMwyU9pZGrqXdP55VgITCv1KzHKrq1++rTaJNMfuBX+00IrdmBHsSTeX4Cs4/T20YbkaCiANlPxvPnaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LLSFn/qhyYnhFTN0rnJR8gD2cjGnPL4Uj2opv8r2ZqE=;
 b=eNt63BjQD7AdJTKhkiECAVtj8kkGsJ0BA9S8f0qLCZRWxVDK0TFABZApIsTQN8gYd38Y6IYuzwD/bI9QrMJDPjJV0xj5AEXrWe1CA/Rw/fNbv+UwWr9jzQl1O+7d0w8qc7FvRrjKeyvrR6nJ8ge/9IaTRcm7Vom1MtLs/P4/4xG7B1lmXiufDdEXno0u4Kdv+xMe4Ap2Ba7ZRBmx0NzcuAfW4J4nPThv2oZ5aFCXadIui2ttcsondRQTYDiEs+mPONYaRLrt/V2eTwvR6Fxx780PZDQqQPvBUtc/k2DmRsAHEaWfJMuXBA1VuJOXeW+dia7GxAraZWJeSrZPQZIxVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LLSFn/qhyYnhFTN0rnJR8gD2cjGnPL4Uj2opv8r2ZqE=;
 b=fcxNIj3Li0ylWwur99O4IWFzkzvsFhUiBRFNjOvGPmW3s2RZELl95wMalBdptOyeH+cDF8i8XVdziOtngsTLhGei8wtHkMwDEAirhEUfd50cOXN7yqY3eAZmOGnvVnH/ej12JwTRnXSyajXbupQvJrOW1k2gkT9qPXBqYO3yHsY=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4606.namprd10.prod.outlook.com (2603:10b6:a03:2da::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Sat, 11 Jun
 2022 09:42:06 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94%7]) with mapi id 15.20.5332.013; Sat, 11 Jun 2022
 09:42:06 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 01/17] xfs: Add larp state XFS_DAS_CREATE_FORK
Date:   Sat, 11 Jun 2022 02:41:44 -0700
Message-Id: <20220611094200.129502-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220611094200.129502-1-allison.henderson@oracle.com>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:a03:180::15) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b536670c-653d-49fc-8047-08da4b8ea5ab
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4606:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB46063427927F22A78C4B325D95A99@SJ0PR10MB4606.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z+vu0M2b4KdOs+Z98JvIjfCLHfhhoBLLPQd+4Hwad/JEFeH8lyGvsp2eF3XBj+FK3ZDZ5X2HPnpNNhRePmt6V6K6tYMOnP5400iwUMoRMmMzxFR87wS4t/HGE7IXYvnRf2LDAVoM2TBlfBJuDwP5TscTW9XPyKPXBZA2qXRPVMD4+aA88QGVKEiZKRmK9TFAO5rcQ8U473E8NySyo9B0yqVLv3Innq/1vi9awM9KBtBX5poMhzy/62M4lXVAnFHvcGZiYxfRv4ZIjRgVHSuM+6VEnqQLJAfZnY6xMsLSpxb53eTpDINjLZVSWtz/8bfdg+PtbNCiEGxmG52zotrKGi9lOUFMgAkfLBho+3W2PI4p3Qij/iRXcUEvPSKzw2joKy7Uq68I4ZiFvG0ZYbM+7DdGp+MuS9lxH+QAn7aUGvk0nHy2A0wV5rWLi4FAaKYnY2n4/b0XO/rGSMg4xzQBnqIElQke8gmX03E+uQK4SPoqonZU9pNaEnh31byUBuv2Bu3Hnfhr5E3X98alkRSp7yqkWURF/dZBVyclFPBoO8qv9IAQOx2RyvOs0DyBja0kIok47VCnD0zDSyYNSDSuHqdel3B4awcurhOFL608aJ57EcoOs8iIrNIHSlwrCK4f/8DPXPKh6rX1nqGYUWu/+K7FKHJ9LmvybPouC/D1uktsza0cQokQZMn/xBh/vuif0fv4/2RCmYLSIjmorhfKsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(6486002)(44832011)(86362001)(2906002)(186003)(83380400001)(36756003)(66946007)(66556008)(66476007)(8676002)(5660300002)(508600001)(8936002)(6916009)(316002)(2616005)(6666004)(6506007)(52116002)(6512007)(26005)(1076003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x4/MSu8kQOyyyZ1DXyOIRlL1gnD3fFtdIHsPEkYZbm9I2/DVe5njMf0vxFdQ?=
 =?us-ascii?Q?AoDNnK0ujzH6oqgPF8q8HzrcpYTC0lIjiFsGpay//BxHvVX1bP22E8JXtfQB?=
 =?us-ascii?Q?CtjQVbPAWNnvWE2plRsI8ecSC/kVAm7xrZWSd2aU30KISChJG5DhhJJVKj5u?=
 =?us-ascii?Q?S5NEQXeSFORtBAU7DJfqhsmCAsSz7NmvF5GiVHPZc9HhM+KHikUQdLGqwY9F?=
 =?us-ascii?Q?UXm5f/ilM4fh2aCmtOX4nXWvffcv4NCzXqBKayEJfN1hZIpbEYctR13o77lV?=
 =?us-ascii?Q?zbe3pxjkcNAu9xhTOEOuJVMAYyxt6DDd7JffPrBIUQk3bfjVgmZQfuRcndYE?=
 =?us-ascii?Q?InfK2Tx8/TEYSJtL+KRYZNAQhuQWTHWXguLEEHqpg5xqzw2GZfQBvd+7GWra?=
 =?us-ascii?Q?pV/+/5lu47Q+X3ZweOKXRQ7Fp8SyjHUB1ioSfVQs8qdw0JZNU9LG4w7V21bN?=
 =?us-ascii?Q?0d2BnCyyHcUXqjAVhx+chTwnaExacHth/UR2VV27nOHT9WIZfyaYC43QdNFn?=
 =?us-ascii?Q?cOKKsooDWuvFuAIp8Dho+QiDxJGAwgSWM/zCv67Jy+1T7vIQ12voOyNDQDct?=
 =?us-ascii?Q?BnPDsge2pqFXcamTiODhpY42UeM/iq2KcrCkPXnqWDNn4gVR83bxWU6UckBv?=
 =?us-ascii?Q?fWmnDi6CewHFwxg3iAcacY1EpyQuRgUgsonn6HhHUrKWQZkiBOWmlqdkYN0j?=
 =?us-ascii?Q?SxXEUJ/WzLNTCBVIKQP0DcFtptYXMyom66FrrZ4FDdlmhF7iq6AP1B0+utLs?=
 =?us-ascii?Q?aB2RaimJGNx7RYouLrF3fqdsm4aZ7fOpmtcYmcNVwaoQcLFQIJxIP5eRH6Kl?=
 =?us-ascii?Q?pbSGWRx5jldVHkhlnbI5QKDI6H3enGDYjyDhRjX2IInq2f6tHdb4W51YxNX3?=
 =?us-ascii?Q?zoISXdcsXA+6j4DOVFJWM05yfXQC5I//zAXk+Vz2toGw6DKqqWy3ZfG3TJok?=
 =?us-ascii?Q?cDHE7LIBXlnTelfiJpiuNUv7Ty3A5u36L+yAXqIEyyCydB778DaEU/hXOrSj?=
 =?us-ascii?Q?ytSYHkNWnGbiaZpj71VtULRkabr+ijjWPNWQxxwlqyxv5r4BjUmNe3io5Voc?=
 =?us-ascii?Q?eMvm/YhVAtEwEVYYGdMnQjQu8dwwi2d2VCi7JMvjJah1PczytVspXc17yCka?=
 =?us-ascii?Q?6zKHMlSRL3qQtFPbTdmwYYlphbD7/SxTtOtaCjkRKUIXc/ivo+QBexrQbZip?=
 =?us-ascii?Q?kTG1UA9fdot7vDZysPlpdnDONBAtUe4xcnHoS3G6v8pXiarZ3eOhCKPwOmts?=
 =?us-ascii?Q?cS7Zag51wMtXPtwVkFrb+0S0QZ8eRDWWlnkGeZEKKSpMyrGm5kdGpKISPr3c?=
 =?us-ascii?Q?4vTkyhGEPOigh5J5z8ocpTV7uXjFtRKDRR3TjD4n/UVEoHUayMd75qWG8uwG?=
 =?us-ascii?Q?8XJZOCnG+MBrxhSA1pTfy2oIezsY7x6c453DeCfWaM9CBoqpMxa+Kz0t6dBA?=
 =?us-ascii?Q?Pd2QJDIii6c87XH06IuNWRi2AUNHb05njH60NV78dzWzFjwzTEQ8sUBGj6KG?=
 =?us-ascii?Q?6D1bf5t+hOlfpH9MplilnXIzGl3NQDrVI1GTj06Q6f7UC9Y0cNJ3hq/ZESVj?=
 =?us-ascii?Q?gwfMnU6VsL6TCRwTb7aj4EHBJlAaLMeBUTB7qftAhupxDwpBNN+oLQj56i6L?=
 =?us-ascii?Q?rukyoca6jWzNtm7m6dpkZjaw+DmW9zxyqF2KcPz1SmfSkXEbnXcWX1VtF7oj?=
 =?us-ascii?Q?YTowKHYuaRswSIEoDzSFIIeJ+qYF34u/nkaN+UQzPcxWmi6AG3qxsc2xZbMR?=
 =?us-ascii?Q?FlsaZdQSEpm1ujjGWqIAm/+5uu7Ggz0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b536670c-653d-49fc-8047-08da4b8ea5ab
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2022 09:42:06.4358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pEShAfIr7NeG5cAmADLCQZISKox/ZMNqtR0PRO26pCmPSyiJfIbfWqOXwm6alzLZOOqtwn59xWxTEM2Tz6Niee3IxfACy9J6RGFlTPQ8Hdw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4606
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-11_04:2022-06-09,2022-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206110038
X-Proofpoint-GUID: p0_R4u9stwwKtuQwdZiMl4Ta9iQRSrfr
X-Proofpoint-ORIG-GUID: p0_R4u9stwwKtuQwdZiMl4Ta9iQRSrfr
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Recent parent pointer testing has exposed a bug in the underlying
larp state machine.  A replace operation may remove an old attr
before adding the new one, but if it is the only attr in the fork,
then the fork is removed.  This later causes a null pointer in
xfs_attr_try_sf_addname which expects the fork present.  This
patch adds an extra state to create the fork.

Additionally the new state will be used by parent pointers which
need to add attributes to newly created inodes that do not yet
have a fork.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 22 ++++++++++++++++++++--
 fs/xfs/libxfs/xfs_attr.h |  2 +-
 fs/xfs/libxfs/xfs_bmap.c |  2 +-
 fs/xfs/libxfs/xfs_bmap.h |  1 +
 fs/xfs/xfs_attr_item.c   |  4 +++-
 5 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 836ab1b8ed7b..a94850d9b8b1 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -719,15 +719,31 @@ xfs_attr_set_iter(
 	struct xfs_attr_intent		*attr)
 {
 	struct xfs_da_args              *args = attr->xattri_da_args;
+	int				sf_size;
 	int				error = 0;
 
 	/* State machine switch */
+
 next_state:
 	switch (attr->xattri_dela_state) {
 	case XFS_DAS_UNINIT:
 		ASSERT(0);
 		return -EFSCORRUPTED;
+	case XFS_DAS_CREATE_FORK:
+		sf_size = sizeof(struct xfs_attr_sf_hdr) +
+			  xfs_attr_sf_entsize_byname(args->namelen,
+						     args->valuelen);
+		error = xfs_bmap_set_attrforkoff(args->dp, sf_size, NULL);
+		if (error)
+			return error;
+		args->dp->i_afp = kmem_cache_zalloc(xfs_ifork_cache, 0);
+		args->dp->i_afp->if_format = XFS_DINODE_FMT_EXTENTS;
+		fallthrough;
 	case XFS_DAS_SF_ADD:
+		if (!args->dp->i_afp) {
+			attr->xattri_dela_state = XFS_DAS_CREATE_FORK;
+			goto next_state;
+		}
 		return xfs_attr_sf_addname(attr);
 	case XFS_DAS_LEAF_ADD:
 		return xfs_attr_leaf_addname(attr);
@@ -920,8 +936,10 @@ xfs_attr_defer_add(
 	error = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_SET, &new);
 	if (error)
 		return error;
-
-	new->xattri_dela_state = xfs_attr_init_add_state(args);
+	if (!args->dp->i_afp)
+		new->xattri_dela_state = XFS_DAS_CREATE_FORK;
+	else
+		new->xattri_dela_state = xfs_attr_init_add_state(args);
 	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
 	trace_xfs_attr_defer_add(new->xattri_dela_state, args->dp);
 
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index e329da3e7afa..7600eac74db7 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -445,7 +445,7 @@ struct xfs_attr_list_context {
  */
 enum xfs_delattr_state {
 	XFS_DAS_UNINIT		= 0,	/* No state has been set yet */
-
+	XFS_DAS_CREATE_FORK,		/* Create the attr fork */
 	/*
 	 * Initial sequence states. The replace setup code relies on the
 	 * ADD and REMOVE states for a specific format to be sequential so
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6833110d1bd4..edafb6b1bfd6 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -977,7 +977,7 @@ xfs_bmap_add_attrfork_local(
 /*
  * Set an inode attr fork offset based on the format of the data fork.
  */
-static int
+int
 xfs_bmap_set_attrforkoff(
 	struct xfs_inode	*ip,
 	int			size,
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 16db95b11589..a35945d44b80 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -172,6 +172,7 @@ void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
 		xfs_filblks_t len);
 unsigned int xfs_bmap_compute_attr_offset(struct xfs_mount *mp);
 int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
+int	xfs_bmap_set_attrforkoff(struct xfs_inode *ip, int size, int *version);
 void	xfs_bmap_local_to_extents_empty(struct xfs_trans *tp,
 		struct xfs_inode *ip, int whichfork);
 void	xfs_bmap_compute_maxlevels(struct xfs_mount *mp, int whichfork);
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 4a28c2d77070..f524dbbb42d3 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -625,7 +625,9 @@ xfs_attri_item_recover(
 		args->value = nv->value.i_addr;
 		args->valuelen = nv->value.i_len;
 		args->total = xfs_attr_calc_size(args, &local);
-		if (xfs_inode_hasattr(args->dp))
+		if (!args->dp->i_afp)
+			attr->xattri_dela_state = XFS_DAS_CREATE_FORK;
+		else if (xfs_inode_hasattr(args->dp))
 			attr->xattri_dela_state = xfs_attr_init_replace_state(args);
 		else
 			attr->xattri_dela_state = xfs_attr_init_add_state(args);
-- 
2.25.1

