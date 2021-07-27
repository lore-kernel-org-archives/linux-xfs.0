Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D7BBC43216
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:20:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 653B661108
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:20:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235041AbhG0GT6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:19:58 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:49474 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235656AbhG0GTu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:19:50 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6G8QM024358
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=+z9S5sFL1aw0KbnphArvHkpGRcbNGPfbO7xj96MaGqM=;
 b=DDPf/xhI8AcAJBr1zXLpEMtnUaUTchoeho31N05vDYBNy+za8uo0kabeZYDY+lPhLi9C
 BaBLPwZpqPikHP5cxcht4H/N531YZNuHBLQLWZxJwcxuhd21SOrzDPpUkWxAWWYRk46x
 /5yclXucFBhRSDa8K3+0xJQKEoe4JUOfL2l+rAzhtcrED3M3RBd3DklgjKqkmLA3upN7
 1sM1Ec/QZ0iWIHyjfLpWtaYFa8LlvTxSAHj4A+ZcF+HC9Gbshq/u6wLNFmkXA6xZSSHq
 BB6H4eHAte1iQTBvbmBONz8Sh8lYlQ4/nmH+bBNmAAUjw0/GQAHq7q/fx/xqs5BF+i4w Tw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=+z9S5sFL1aw0KbnphArvHkpGRcbNGPfbO7xj96MaGqM=;
 b=uLe3HEcwoPpPIRaaEp1Cn9EVd6qUKNvILoeuCYhx+hztIGIuPpzQBM2Tuuc8Pr0ptIja
 QMqhxqkDsc1qPmvIjzkNjYbsjqZ4cHk2edmiGkgSBbTk+bLn+as1wTvArBN6RNgMWd6Q
 ZdFDYWa4Gz+IWXTvSG4aIhD+U5WGwZuWrpeIIT8Itlwq3nnkEwTRxn27WU0ahIP/eHQs
 qJ2LWKJCMGonqVXglAzubVtM53iN2GobOkMRBUGlYeq8IDy5Gjdg0+ZyBfpgasf4JUBi
 OdieGFaxIw7XGD2WmELML2fXVV/gmDT/qpCtjaJ9rL14+ulGD3UvdrwAVnK/xjR1jLu/ pA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a235drun6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6FjJ7114851
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:48 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by aserp3030.oracle.com with ESMTP id 3a2349tqqb-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BUnbj7zPMAOTUVUo8XNfYJGQkdWIDvJOA4KhBLlGQGmEc8yeHtQmqZCl17hi6UxgmI1CEwcuynJSMqf4lHqkhwLGDCPeHWFX1fuXuZvexegABVI2UgutxUQodWxdarclr8MrZuoxZswZ2DdPU1KocgQ9vP0Ba0dDR6b5K3aN1+2GciriiCNCimEOJsbFYA8TOmISiOdjSJ1CBFVROlI/DiIlL9ZOTkdG3tmtnQukubXQCTXb19ouNCYEDg+Sr7dI3KTBV6F4GTd7L7uK8TkI0+pcCtqnVioQh8HHv82n9hYyMArRGyPR8LGdQrv5A6HokTK9TpnD+E6c1QZ/Quy4Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+z9S5sFL1aw0KbnphArvHkpGRcbNGPfbO7xj96MaGqM=;
 b=euchzLCMRhSldFgSPNVZXKepbduPpHUrd9tjnQ3L8QA+w1ZMScMIqWBvs0g0Xm+yo7/zjmvX4EosW17zRBHwPMDj/SJqdSx/ylBL9bEMG9BTueXt3xXXy25V1zsVBdi7gjonsAYr9VxrpJDgmt5WwVA7ajPNszdo86AEjWIYkgRixwpjZuZ/Y9k/IJG3JUhXWpCQ+/1nWIeEdj/iF+Foyh7eikEpn2MoZ/oqw4tBIw7rcgdeWOji4EwrrnQf5arM2d4uOAvqHJywJZ1YuYfSXm6LxUxumVGp8B7QWEA/rYAQ6LeyUVnaCW6OVHwH/6ovYCq/g5/K248B35ZjsOSjTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+z9S5sFL1aw0KbnphArvHkpGRcbNGPfbO7xj96MaGqM=;
 b=zvdQLXwIDuOEs7boTsHAfEmVxeh7XGJvMy7K7im2QgUEnQw0EMtGx3u20wSdvsNKHJWN8ow6GmLH+Dq7446qcaG8/y3fWaNck4kPHVODIB2e3cFViT8caMoHTdbRyBHUg/wt4tJghS6tjIBkyEatdV2G/ZIdgWNPADwWfVwklfQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2709.namprd10.prod.outlook.com (2603:10b6:a02:b7::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 06:19:46 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:19:46 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 19/27] xfsprogs: Set up infrastructure for deferred attribute operations
Date:   Mon, 26 Jul 2021 23:18:56 -0700
Message-Id: <20210727061904.11084-20-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727061904.11084-1-allison.henderson@oracle.com>
References: <20210727061904.11084-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:332::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0074.namprd05.prod.outlook.com (2603:10b6:a03:332::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:19:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ecd3b2b-fccb-4283-26eb-08d950c687f4
X-MS-TrafficTypeDiagnostic: BYAPR10MB2709:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2709F12C71BD759729999DA595E99@BYAPR10MB2709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TPVi3LBgvs2FS0zxlXkEEsN0sgRw9QRvd5QNIqi0r4LZs9WV4qlmDs6XyCUzHUAQKsEeFtm6qi9WCbz41GL3zn1zIY3z/PgghQDTNFe4ORf46Yewc00vlSuC1bRNIznhjM41FP5h1yfhqYxU7Pc2A+mDfT5mczTnEZK2TXvf/kFNQ3Zp9sxp7lrVaNKUaDt+fs25339k2I131DVd2P/ZWEWUDXadfAPVaOXItSjijC9MzVqGiDFyhjqFIQ8s0oJtKi/ZYBfF/AwLlJgEk+Z5vz7AYe0UlIx9XAhQSF9GLtD4lYywJe6MPmytM8ikq3/KFFRkArmwjF6cP1jIrHg5fQv3Zj3pqEXwB3ZnRxUwe1Rv8iPI/n4JzNiftr1+RcupFzZ1WO5t59MiBKJvaXYa/oZ1vZv7SSlpIq4PojzFDJ9fNFSHDHyIHb+pfTm0BGDwPhp6fgl5mbs/poDGfoCs7ZCkM+vWzS5zagIQoPBBFHuNgsGC8M3wysrpZosyCCjzHg65DgFtpEldnba+jqHsdDsYW7yA2HysNRzs3Y7fTUkNNlky1/DCu9p95bqpgNdudQVhnFsrphfkTEgbgbivieGdUdmETqmt/jVJXxgwKsA/gjtE3w04IyvuE60zcbGWjZNL5TGF0tTaimV3YFq24QT+rOSB4Qj/vMt65cNLk6HDhASw3/IKlgCghy2EiXM8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(346002)(366004)(136003)(83380400001)(6486002)(2906002)(44832011)(6666004)(86362001)(6916009)(956004)(38100700002)(2616005)(36756003)(52116002)(38350700002)(478600001)(8936002)(186003)(8676002)(6506007)(5660300002)(66946007)(316002)(6512007)(26005)(1076003)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rCu5QJI+7KUedh0wAXuhC2B6QpcbkTceJhy/EpD6WyuOJBzKr3FAlCOY6mzc?=
 =?us-ascii?Q?ysx0lUBDkUpR/Lr2s7B+ljrfj46AvJOaXZeT0s1uDYDYUyDoTKwKYaA2Wq3Z?=
 =?us-ascii?Q?EKyXS4fjyE45z6XCKsLffOi4r0wEoBgzd1HK1fYUhRtLY7ufsxpaQw1iK2/o?=
 =?us-ascii?Q?RESGiWxbtjxq0QyG212krwaSNdpZ4aEJrdCiZLvtrqVeozkB1U9Is0ysG2kF?=
 =?us-ascii?Q?s2G2jTGSd6OMZMUJNiRiaRCmrXNqVzBzRNgJi1ct/M0/iG7SbhlM9E4Shb3c?=
 =?us-ascii?Q?VLsu2j+mPbX7I4T6i9Ry2ST3oJXzpn9iRQYStVj8/gXhyWSt6P9HoXV2Ek8R?=
 =?us-ascii?Q?1b9CvICPIYTkRAc7ZKxRQwRzjZFGpj7d4FNDUJupUl6txhLsXs+BpHhydPM/?=
 =?us-ascii?Q?edENP+0pwSAT8cXJkSl1ySxf4KnN+xtXNyx/Omba3ie3vbiOXK8d2vgBMDxt?=
 =?us-ascii?Q?7xQWqKKix1ZddnmmoWmMp3Sa7jYoaq64LPk/wNe5Zo0f397sH4ESdymD9ILK?=
 =?us-ascii?Q?6HQpRMX+nm/ffJ6/ahAEDQR94xEj9gBEovU19RfJruvfJdzqunJukWCoWF/5?=
 =?us-ascii?Q?fIyRRGRO0TZ3lhBf7UIh7N1XYlmweYk8iaGEUauCw4KcSRdaFIAgvlaS0Ydf?=
 =?us-ascii?Q?ZW1znLlWfFVOq0GU7L0mJyC/N1tgRFJuR2dobDwuI/s4I+4WHOJkc1zFWnR9?=
 =?us-ascii?Q?P2nS0oHpxCAUCRbB+8ANJuCRWGvj4HW4TA5kfnp3jDRFbInjg2jEVWxd8qkd?=
 =?us-ascii?Q?ChNWXRn/byYrI9eBaujgXHwfk3+4gHI19hBC1RMuHdm3C41AGksIGj1HQGlF?=
 =?us-ascii?Q?7KIH5AOZkD1KAtNDHiEURHjJV05NWCyKX7Gog866pWj+JfgEgEZyYVkeNYJx?=
 =?us-ascii?Q?s2mVr2tRmZWn0hA/0Al3/HQkvaC7nrmsFYcEMOPkjgETiUhUAyeOfLjlK8Xm?=
 =?us-ascii?Q?YYs8lERyPVVPEcGL+BHOMBlLgB78rcLg8w+lY6/JdUHVfs55uD7Y00xwE59X?=
 =?us-ascii?Q?IjQHSKdA7YgMCbhUZdmUQ5xf2T37ReoKOi5X9pdk3FyZNscYws+lnm6Qh5jp?=
 =?us-ascii?Q?Y4fPLKo7ckR4Cxe8/lQrtDZSK6t18XqY1hI/s5iP0yW+uZl3RDlrqc5spVHN?=
 =?us-ascii?Q?hLK9g+1HLAT7ZIa7P5vcCB+0oF1vqHA4cq8OIqSFk9tBtwMb18lrH0tFYtlz?=
 =?us-ascii?Q?t4QJfrglrzD17aCCQ71vcvVyiaQYkXr9l84VHGIxDhN8UwsFrZ95rwUOFH7E?=
 =?us-ascii?Q?XknZfJnnp9SwsbuiT050NgGbxLZT3RwCUEW/JjiNP/AxRBrdPSqZIf06qjJ4?=
 =?us-ascii?Q?2AL8hNCYP/e7R2PSy9DK0Vih?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ecd3b2b-fccb-4283-26eb-08d950c687f4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:19:46.6019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MB7sg8sjjbM6MmUpRDpDuB1GOazEe20G/T7clJDdHSA+7fADcUvwNgnEPXy/zYFkaNdQWzKwBQs9Gdmqs2Dkk49w3SuXCPiBPWwRS+OSFKM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270037
X-Proofpoint-GUID: TN2a1mexl4oJrrbq3rVXOZOWW7wGlnco
X-Proofpoint-ORIG-GUID: TN2a1mexl4oJrrbq3rVXOZOWW7wGlnco
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Currently attributes are modified directly across one or more
transactions. But they are not logged or replayed in the event of an
error. The goal of delayed attributes is to enable logging and replaying
of attribute operations using the existing delayed operations
infrastructure.  This will later enable the attributes to become part of
larger multi part operations that also must first be recorded to the
log.  This is mostly of interest in the scheme of parent pointers which
would need to maintain an attribute containing parent inode information
any time an inode is moved, created, or removed.  Parent pointers would
then be of interest to any feature that would need to quickly derive an
inode path from the mount point. Online scrub, nfs lookups and fs grow
or shrink operations are all features that could take advantage of this.

This patch adds two new log item types for setting or removing
attributes as deferred operations.  The xfs_attri_log_item will log an
intent to set or remove an attribute.  The corresponding
xfs_attrd_log_item holds a reference to the xfs_attri_log_item and is
freed once the transaction is done.  Both log items use a generic
xfs_attr_log_format structure that contains the attribute name, value,
flags, inode, and an op_flag that indicates if the operations is a set
or remove.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/defer_item.c     |  3 +++
 libxfs/libxfs_priv.h    |  1 +
 libxfs/xfs_attr.c       |  4 +---
 libxfs/xfs_attr.h       | 31 +++++++++++++++++++++++++++++++
 libxfs/xfs_defer.h      |  1 +
 libxfs/xfs_log_format.h | 43 +++++++++++++++++++++++++++++++++++++++++--
 6 files changed, 78 insertions(+), 5 deletions(-)

diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index b18182e..a1f0d7e 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -20,6 +20,9 @@
 #include "xfs_refcount.h"
 #include "xfs_bmap.h"
 #include "xfs_inode.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
 
 /* Dummy defer item ops, since we don't do logging. */
 
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 7181a858..0272ef2 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -518,6 +518,7 @@ static inline int retzero(void) { return 0; }
 
 #define xfs_quota_reserve_blkres(i,b)		(0)
 #define xfs_qm_dqattach(i)			(0)
+#define xfs_qm_dqattach_locked(i,b)			(0)
 
 #define uuid_copy(s,d)		platform_uuid_copy((s),(d))
 #define uuid_equal(s,d)		(platform_uuid_compare((s),(d)) == 0)
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index f2db0d5..70665d9 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -61,8 +61,6 @@ STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
-STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
-			     struct xfs_buf **leaf_bp);
 STATIC int xfs_attr_node_removename(struct xfs_da_args *args,
 				    struct xfs_da_state *state);
 
@@ -166,7 +164,7 @@ xfs_attr_get(
 /*
  * Calculate how many blocks we need for the new attribute,
  */
-STATIC int
+int
 xfs_attr_calc_size(
 	struct xfs_da_args	*args,
 	int			*local)
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 8de5d1d..463b2be 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -28,6 +28,11 @@ struct xfs_attr_list_context;
  */
 #define	ATTR_MAX_VALUELEN	(64*1024)	/* max length of a value */
 
+static inline bool xfs_hasdelattr(struct xfs_mount *mp)
+{
+	return false;
+}
+
 /*
  * Kernel-internal version of the attrlist cursor.
  */
@@ -454,6 +459,7 @@ enum xfs_delattr_state {
  */
 #define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
 #define XFS_DAC_LEAF_ADDNAME_INIT	0x02 /* xfs_attr_leaf_addname init*/
+#define XFS_DAC_DELAYED_OP_INIT		0x04 /* delayed operations init*/
 
 /*
  * Context used for keeping track of delayed attribute operations
@@ -461,6 +467,11 @@ enum xfs_delattr_state {
 struct xfs_delattr_context {
 	struct xfs_da_args      *da_args;
 
+	/*
+	 * Used by xfs_attr_set to hold a leaf buffer across a transaction roll
+	 */
+	struct xfs_buf		*leaf_bp;
+
 	/* Used in xfs_attr_rmtval_set_blk to roll through allocating blocks */
 	struct xfs_bmbt_irec	map;
 	xfs_dablk_t		lblkno;
@@ -474,6 +485,23 @@ struct xfs_delattr_context {
 	enum xfs_delattr_state  dela_state;
 };
 
+/*
+ * List of attrs to commit later.
+ */
+struct xfs_attr_item {
+	struct xfs_delattr_context	xattri_dac;
+
+	/*
+	 * Indicates if the attr operation is a set or a remove
+	 * XFS_ATTR_OP_FLAGS_{SET,REMOVE}
+	 */
+	unsigned int			xattri_op_flags;
+
+	/* used to log this item to an intent */
+	struct list_head		xattri_list;
+};
+
+
 /*========================================================================
  * Function prototypes for the kernel.
  *========================================================================*/
@@ -490,11 +518,14 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_args(struct xfs_da_args *args);
+int xfs_attr_set_iter(struct xfs_delattr_context *dac,
+		      struct xfs_buf **leaf_bp);
 int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
 bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
 			      struct xfs_da_args *args);
+int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 
 #endif	/* __XFS_ATTR_H__ */
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 05472f7..7566f61 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -63,6 +63,7 @@ extern const struct xfs_defer_op_type xfs_refcount_update_defer_type;
 extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
 extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
+extern const struct xfs_defer_op_type xfs_attr_defer_type;
 
 /*
  * This structure enables a dfops user to detach the chain of deferred
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 3e15ea2..66ea559 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -117,7 +117,11 @@ struct xfs_unmount_log_format {
 #define XLOG_REG_TYPE_CUD_FORMAT	24
 #define XLOG_REG_TYPE_BUI_FORMAT	25
 #define XLOG_REG_TYPE_BUD_FORMAT	26
-#define XLOG_REG_TYPE_MAX		26
+#define XLOG_REG_TYPE_ATTRI_FORMAT	27
+#define XLOG_REG_TYPE_ATTRD_FORMAT	28
+#define XLOG_REG_TYPE_ATTR_NAME	29
+#define XLOG_REG_TYPE_ATTR_VALUE	30
+#define XLOG_REG_TYPE_MAX		30
 
 /*
  * Flags to log operation header
@@ -240,6 +244,8 @@ typedef struct xfs_trans_header {
 #define	XFS_LI_CUD		0x1243
 #define	XFS_LI_BUI		0x1244	/* bmbt update intent */
 #define	XFS_LI_BUD		0x1245
+#define	XFS_LI_ATTRI		0x1246	/* attr set/remove intent*/
+#define XFS_LI_ATTRD		0x1247	/* attr set/remove done */
 
 #define XFS_LI_TYPE_DESC \
 	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
@@ -255,7 +261,9 @@ typedef struct xfs_trans_header {
 	{ XFS_LI_CUI,		"XFS_LI_CUI" }, \
 	{ XFS_LI_CUD,		"XFS_LI_CUD" }, \
 	{ XFS_LI_BUI,		"XFS_LI_BUI" }, \
-	{ XFS_LI_BUD,		"XFS_LI_BUD" }
+	{ XFS_LI_BUD,		"XFS_LI_BUD" }, \
+	{ XFS_LI_ATTRI,		"XFS_LI_ATTRI" }, \
+	{ XFS_LI_ATTRD,		"XFS_LI_ATTRD" }
 
 /*
  * Inode Log Item Format definitions.
@@ -863,4 +871,35 @@ struct xfs_icreate_log {
 	__be32		icl_gen;	/* inode generation number to use */
 };
 
+/*
+ * Flags for deferred attribute operations.
+ * Upper bits are flags, lower byte is type code
+ */
+#define XFS_ATTR_OP_FLAGS_SET		1	/* Set the attribute */
+#define XFS_ATTR_OP_FLAGS_REMOVE	2	/* Remove the attribute */
+#define XFS_ATTR_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
+
+/*
+ * This is the structure used to lay out an attr log item in the
+ * log.
+ */
+struct xfs_attri_log_format {
+	uint16_t	alfi_type;	/* attri log item type */
+	uint16_t	alfi_size;	/* size of this item */
+	uint32_t	__pad;		/* pad to 64 bit aligned */
+	uint64_t	alfi_id;	/* attri identifier */
+	uint64_t	alfi_ino;	/* the inode for this attr operation */
+	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
+	uint32_t	alfi_name_len;	/* attr name length */
+	uint32_t	alfi_value_len;	/* attr value length */
+	uint32_t	alfi_attr_flags;/* attr flags */
+};
+
+struct xfs_attrd_log_format {
+	uint16_t	alfd_type;	/* attrd log item type */
+	uint16_t	alfd_size;	/* size of this item */
+	uint32_t	__pad;		/* pad to 64 bit aligned */
+	uint64_t	alfd_alf_id;	/* id of corresponding attri */
+};
+
 #endif /* __XFS_LOG_FORMAT_H__ */
-- 
2.7.4

