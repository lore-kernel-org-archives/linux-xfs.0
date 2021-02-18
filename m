Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFEA2C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:46:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F35A64EB4
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbhBRSq0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:46:26 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40784 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232292AbhBRQrB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:01 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGTAqW155830
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=LTxh0Leuv5LYESHWFdjj/Jd8KVPTaqxdnNTe2z2c4OQ=;
 b=x8JC1U+kPvrUZEqEd/ecmdF6MNBBq9adZ0mYfL9fdvb20Hgs7cbM4vnBHwl4BFFihzQA
 ZF5KKuZnbrxpZtYZhazJ3kCgsIoPduO8m7py62LBqb/lwdS5AvXz41obe53NTSPwUGyT
 8/te6UHZz7FpwVs3AQzHvBDej6UpHVVg7L3rgyonjSTIhjrlIlbPUSI65uPGO32RRw+Y
 B3g2PMWJp63QS2IlEk+WPVrvYN2GqokMtMENpxOZdOreuRTUemA3AyXO58q6/25Xrd70
 lhkBCM3UcxTlvSFFFL+308TvVCMDpKHpe/3oXscQtlLpxIBRl/0LwZQ8RfnWN/b7kMAO 7w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36p66r6m4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUCa7032333
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:37 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by userp3030.oracle.com with ESMTP id 36prq0q51j-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XRKKhNdv9e1mIZ0O9afHJ+LhZaTJruOLPfEXRSJ/c0CmV81ZhVOTWOpKVehf7NTsNy8Cr99BARzaqZK62amDkfKZxj3dsWsuS1TaESdMd8XXUYm0XzVoS3bDe8h2zJahloJCKz5xEIOjwWuvpae7tuAi6hdJU4ulFg6xFwCmWYvCvQDmEB51XRiTbqNNdLiUrPfrNa5KONJGosCfrfuBf/3aRFsTLTnlQdsK2ZPzNf17zwZOkz4SeO2L9/NJM+yVwcntc6Onk2YKPQuDZ3FYHU9v61aPpcacoHN1gI83xOU6pEeUF2B6YX0bl4cvAXpoeWwkC7405cP9+SxIV1b8Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LTxh0Leuv5LYESHWFdjj/Jd8KVPTaqxdnNTe2z2c4OQ=;
 b=dv4em7wGH60TOeS3o6D7/pt6eJ10M1d9K/MWvNOgdz9YlLvSe0ll2sHUqql5QxeTFEUz9JkFyEH0eTYx8XERz7DS/9Z39vAxrVrEfK99bLfBChNdn8Kg203N8ojdC+BzfAQdmgSTXaEEfs4/uHeEDSIjUm29xL+IUyJxZsqtaqHh3o86LnFVR0bFMLr/T8FGistcLiYobdz6uWsG1eXIftl1WesaicEwc0kEEearWq8k9i01Z+d7wPq0YO1WfP1F9+mk0Nj2Y+vW6AKwfjN3PDMY5nGYj2iZoJrq4gBiVAVB75nnQWjTHtbvA8BuvJMbCF/yuh1dUYm6oxZPSN9ZFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LTxh0Leuv5LYESHWFdjj/Jd8KVPTaqxdnNTe2z2c4OQ=;
 b=k9OLd/UNf/PeMBRL9650GkMbfaxkA5uG5hc8850LUfEQLOKr+toHKtSfgYY3xWjwSRh8c/w2Xlw6CvdKaC3zwEeX4H6S9+4+n2ahRsN+/HH+y2O6iF1e5XvABbt3eqAGDufhFGNDaSN8M2XeQz41zCs5qgtuuNRjcQrN4C0WzII=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4290.namprd10.prod.outlook.com (2603:10b6:a03:203::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Thu, 18 Feb
 2021 16:45:35 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:45:35 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 09/37] xfsprogs: Check for extent overflow when writing to unwritten extent
Date:   Thu, 18 Feb 2021 09:44:44 -0700
Message-Id: <20210218164512.4659-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218164512.4659-1-allison.henderson@oracle.com>
References: <20210218164512.4659-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR11CA0088.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2704af1-5f7e-4d1d-5d02-08d8d42c9cde
X-MS-TrafficTypeDiagnostic: BY5PR10MB4290:
X-Microsoft-Antispam-PRVS: <BY5PR10MB42909B8B5809733B5F36C36C95859@BY5PR10MB4290.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:220;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lNjqRo8xz+Gj+vRtpXNl0ovooPT2jhpTVVKrtuQDFq9tyzfJVKMFEpIclcoOW8FDIagYHBi1zXBcyh4YgHBlSoSYYKsmZjRQaR836zEYsgdontNrDB6HQZ0A+IISXFfzh9ZFDLGjbt40xIXahZ1rjQAS52uQyfoiAQaVViPxzgIsa+2HCN2iggUGcP2NCsQ4MnHDOnmD/K4GCDGnXDki26Ub1ImLXRDejMQV2IYgl51wZba4kyFBTkPbSkNwvcvpFBrMRMja6n2htg4yez0x8d5olwicj7FocPhWmOATXo3Fk9kcSAwoyOW9ubGG49pf3U9ev4qAeP2lCJreCZVGPYczxNTFjMUWe/8Qxvf94uFbSFp4nI7bTCE8hkoBOHuJ0Vnu+gwxlODR0KVB8nWH+37Bej/aAYVQMt7fC5RoUa7cXenkJH0VsjfjA/imPbx/AJH28dSpGs4CVBAbJAKrIlNtLYIiYY2w5/dsPjio8pX1ZUHuryuLVdLfKhaX+AysR/5BHjqHIqtRcExfEvGB/iUaSaXaHWuL2EwGV6IkJZ/j8MQ2o/oBZkLDV/2iQs2zHVo2vv+ZeJqoBXN//QjG3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(39860400002)(366004)(6512007)(52116002)(6916009)(1076003)(2906002)(316002)(26005)(6666004)(86362001)(8936002)(478600001)(8676002)(44832011)(6506007)(36756003)(66946007)(66476007)(186003)(66556008)(69590400012)(2616005)(5660300002)(956004)(16526019)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?rT/FNfQPBRye9fnye4eC2mwkm5PcbX/mi26a5mNhShUIQmJFdIkhGUWEbFy/?=
 =?us-ascii?Q?hE61tQhGhk8YwJxB3d8DSR1PU/6HTBhXlCfyDarcMMPvXmeQx4HuHeJU3gl8?=
 =?us-ascii?Q?+dYilKIZqhKXQQjbSGWlIpV28DHQ4z3IFdAbthGUBrWMeYb2txhJJHknntN/?=
 =?us-ascii?Q?wmZJk1lmOZv+BgD4ihEV3v+pRcGo3G1NsYJvUI9VDsF+6JS1t18luRaH+GXN?=
 =?us-ascii?Q?cPqGKG4XCSsQDoutM2R0LMLr56vEt8aKCLrizBB7/JLAN/HvwAwgBx7qtGCw?=
 =?us-ascii?Q?OivJI2WK4gmQ6JK6bSbpPSzRS5VWFugsop/wx0/UuuFSLjLYh9P3B2jBSa+q?=
 =?us-ascii?Q?yAXJQH99OShCiSwV7qdrYlK7UV92mVWgulASDJiM+CMwQN0bdOz0M92R4F85?=
 =?us-ascii?Q?jxWp+uybvnJZfeJdHDnabTmHCfnqjR1S4LAmO4kgKQyS5IXqkzzkWDXW1qwo?=
 =?us-ascii?Q?PLjA5A71L6DK3RY0MuYfxDibHCaAcQyIBudwsv7SOMDVt05RNwi0cwLaIJfQ?=
 =?us-ascii?Q?sQka+P9QrF7CJRIOvEiQmVn06EIPypV8CLSpMxexvVgZfjzWx7784M4jGR5N?=
 =?us-ascii?Q?5sSUjHRuaL32cr+A6ejcEA8eiUYRZayOqWTbNUdLbCLNq2Udvx44m0OKcGmh?=
 =?us-ascii?Q?Xft9ifRxYPzsQR9MrinRCrZ9uE680IuNVat9iuu4OfIE/VJrjrYMhj+6WPTu?=
 =?us-ascii?Q?XXvHgpUOpCqpvRi+2cf8og7wGp6Y0qFzo1R3C8wrMw6SGbAj2hIYzzIiT/OQ?=
 =?us-ascii?Q?uRqC23x5BtmaDm/Kxxd0UMiWYoOQNOKtJRslRy6/722/0PvCSG+f0ygaop3u?=
 =?us-ascii?Q?8IS1fxYJfEzsRD4jN6Nn5gLXuMbniyzJpSLNT+LzSCn3jnyRXdixmQNhJv3m?=
 =?us-ascii?Q?AZrxZYtE/+HYptWQ4aWBURDPHks+DhIdqbICXoIveIYAr0p+N+06Awax39cB?=
 =?us-ascii?Q?+ATY8KUDEcbmBWKSsr2X33+tB0f+BNAJGwAxACW4a3MKpFeQremjUwBhU5lv?=
 =?us-ascii?Q?RKtBD42ianlFheq/cIDbM8HywijEwMM1CFDIGvA8+7+yFG5ySmvUWapB9ToM?=
 =?us-ascii?Q?PNcCdVzo6THVunktpis4okLDEboieab0xR77Ad6RvFKUPUk+UBmFdjWC29Jh?=
 =?us-ascii?Q?hSD/nz6g9VNUwQy8VK6QovjEaB00aH2xL2FvRrspjzDLT628G4/THs5jn7fb?=
 =?us-ascii?Q?6q9DqHRfTm5DaqPe6GQy5j8O/hw/wYialy/RnhESvFYhyPZ0ObXwJH/x9Fmg?=
 =?us-ascii?Q?LVObVwNdWYBNnD51wD5UoNwXCs4uonvpsxWYSzAtGoQxcChRkkDsiFzjgSqr?=
 =?us-ascii?Q?Wiz+a3KSY1Wqme9BXiK9CdZ+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2704af1-5f7e-4d1d-5d02-08d8d42c9cde
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:35.0115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eAz7WjINrTYriM7waz/T0a2Tf6BMo/3Jgf4uMp12a38+uncnSHFC6GWFXsXyFUDPtAj46pqqfPD+lBZVQBLfau4A1J4DE4hsSbESij4WvHA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4290
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Chandan Babu R <chandanrlinux@gmail.com>

Source kernel commit: c442f3086d5a108b7ff086c8ade1923a8f389db5

A write to a sub-interval of an existing unwritten extent causes
the original extent to be split into 3 extents
i.e. | Unwritten | Real | Unwritten |
Hence extent count can increase by 2.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_inode_fork.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 8d89838..917e289 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -71,6 +71,15 @@ struct xfs_ifork {
 	(XFS_DA_NODE_MAXDEPTH + max(1, rmt_blks))
 
 /*
+ * A write to a sub-interval of an existing unwritten extent causes the original
+ * extent to be split into 3 extents
+ * i.e. | Unwritten | Real | Unwritten |
+ * Hence extent count can increase by 2.
+ */
+#define XFS_IEXT_WRITE_UNWRITTEN_CNT	(2)
+
+
+/*
  * Fork handling.
  */
 
-- 
2.7.4

