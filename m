Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDC25C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Nov 2021 12:29:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7C5A60F36
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Nov 2021 12:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbhKAMbu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Nov 2021 08:31:50 -0400
Received: from mail-eopbgr1320111.outbound.protection.outlook.com ([40.107.132.111]:55095
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232036AbhKAMbu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Nov 2021 08:31:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MfATocO76v01M15a3Fb4v+puJKE5moH1hq/XBMXe+D3LDtPBLWUqrMe2zpSwYn+LhcTkWkh6rx0zNDNsPzFQjvlpmQASHfUjmKIdhcC+ZS9SVumLDTrwoEcn1wISBr+KkdvJ/sPk08e//HA1/iLshYeyJSL+J4omehYEACW22T6eG/v9I6f+AKClYAMMt70DktlFCsmbSJLcu9R9q5fwt3iQ+ZNLwFJn94RfA3kx34gSBds3loVlWGyNeVozbEYFuiCw+WkiTjEzsyeNELSdL7I9tIv0yPYp27wZkDEUr/fotlhQ8LY8VAMYs1CVl4updrPoS7mudoNL+iOInLvuDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uel3JCFaBSU9u4Hpb/wqAU6pH52TAtqmrlP6A3UjV4k=;
 b=NkuyQZKiYdTLZaUeVAMrFE8eYCayYib84rG5BSorvXJ9VNvxtu95g1ltZ8AOkZkwlh7E790a2BMKZ4ZvoWiuyBrVJimDuESbHOCsfaoMwdibuNSU7jjOLLePgQDY28+EFG8Pjb/ooqfRZSah0vzMgur0FiIK1qUmxxWPnTfaSMVhyn1Qna5Htvht36wUxfD2VWEXVCnRFjCL8sJ32brzVuSpn2WEzmCJVVSbAuNkl5lmek5jNVLl24TL5L5ubuvllzwZUjC990SJtvHFdCVs79yveIVJW+mgII3LePziuMcVKxQH0Pg8IWkJfxOTSVjRys4ju9t2al8YUoIK/ks0hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uel3JCFaBSU9u4Hpb/wqAU6pH52TAtqmrlP6A3UjV4k=;
 b=deXeKHYMpR5QFZr6Qb7hCRtRka7ntcbyoPvObItu+Subb8Axnl7PwaoApY13F/qFhySE6R7GKnAWn3LKCKLdoUf0AyoU5JuKE9sWq+ZPmevSfM7ah+hZNOVCQ6a+OI9TKOxk/wkt6Y7UXv8k9IIg5JP0UqMawHmRGBTpvWNomq8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com (2603:1096:400:26::14)
 by TY2PR06MB2734.apcprd06.prod.outlook.com (2603:1096:404:2f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.17; Mon, 1 Nov
 2021 12:29:14 +0000
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::5e:78e1:eba3:7d0e]) by TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::5e:78e1:eba3:7d0e%7]) with mapi id 15.20.4649.018; Mon, 1 Nov 2021
 12:29:14 +0000
From:   Yihao Han <hanyihao@vivo.com>
To:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Yihao Han <hanyihao@vivo.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com
Subject: [PATCH] xfs:using swap() instead of tmp variable
Date:   Mon,  1 Nov 2021 05:28:47 -0700
Message-Id: <20211101122848.27029-1-hanyihao@vivo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: HK2P15301CA0004.APCP153.PROD.OUTLOOK.COM
 (2603:1096:202:1::14) To TYZPR06MB4173.apcprd06.prod.outlook.com
 (2603:1096:400:26::14)
MIME-Version: 1.0
Received: from ubuntu.localdomain (218.213.202.189) by HK2P15301CA0004.APCP153.PROD.OUTLOOK.COM (2603:1096:202:1::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.1 via Frontend Transport; Mon, 1 Nov 2021 12:29:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ede0abcb-f4c1-4e9c-068f-08d99d333755
X-MS-TrafficTypeDiagnostic: TY2PR06MB2734:
X-Microsoft-Antispam-PRVS: <TY2PR06MB2734E21023BA24CE3667BA50A28A9@TY2PR06MB2734.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1265;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dxl0Znfjo9u1ZYv+1vh+FhB+j2bq1sJZW6yhutUPbx31TQ87lAcQAlyvje1JD2+DXKkBdBx0p72GGOwST/rZgR3xn8rRYhJreshr1px/z5JLFe/1JFH7YD4hy6q7aCefLe7+JmgSnyF97pSjnM/SER8spP0ihzAihiT7RTUOK2VcR5DtAu763o3W7va/hnAbSUYU8SrG4bItjqNySOMujBaC1TjYHmoCIdB90LRypp2jk+d6E25VckW+sqY5jhr8pf+kYKL/CMbuSdoansrwB6O63YJwvWzY2TVRMEM+3xtWbN1wvh7lxTr9LLG5Le75e+dpO0WHPQndDLlYPrNGMhO7Mg4bN/njkCDe+ECmk4K7HhVK43q8G+j099Wnrl523OhB6M1APVfihCbkRhoAG5jYsT+DFDQo2egewcSEGUu/wUQMLbqh4Jgzz9DQ3DA0hPj9n+v6CxFC2qmRuZDf2FLzD2uU2a8P14SN5QKF2ODVLbMQd1pU71A5cvEODjYarRzLSvMBuMB/JaC/RX1//8CVV1nKMDbur8505xBhKbm7E9EonyjwcITiC4GoColt/tjiGfOK0E/IbO1HFom6jN/4S56vNxxy8y+Fs4xq8+qDwbi74dqCbSdkhf+DmxmSeKcOvedXdAmqW72WZE+TYZXrUf0CpAfsc5jqVNPWh67iNGa5mfKU7ukaROpgFTSdXl7Ju7mdWQpzb20KziRHnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB4173.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(66556008)(26005)(6506007)(316002)(66476007)(186003)(86362001)(36756003)(8676002)(66946007)(6486002)(8936002)(508600001)(5660300002)(1076003)(110136005)(83380400001)(2906002)(107886003)(6512007)(4326008)(38350700002)(38100700002)(2616005)(956004)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ks95R+Vx0oFpqlNxzTAu6vJq2bl4/9Cpf/lbFcXItdL86iWMqglbMkGS1+hV?=
 =?us-ascii?Q?ETXuACIPLuCd4bQz0OFKnseKtsV43+tL4MVh/6q90Nixc68xwMksvnLbiDKq?=
 =?us-ascii?Q?zi4ankzwEwU9o5NkJYifiPSBRGpvshrctv29BjuEPtNgQLbCvggfyfubZPYc?=
 =?us-ascii?Q?CcXKRXjYAsIDY0ED7O4KUSGqMKM8VBxDs8mmtwy913xSno3L8rVz6Q7hCq8L?=
 =?us-ascii?Q?JRrtfDvT/0VVc4SFu9Jj7spjj5mrTCWtNylKFhP/87zImAIabPUFKjm5ohWh?=
 =?us-ascii?Q?Lv/N9ezLiM313jHXbEkb99r/eUTScn9HUYnMYbCTUH72FQiivvTvRsGFcDQZ?=
 =?us-ascii?Q?hUtQ4LCOqZES30rQqF4bliJYdRV+riZXm6LKBI8DF23VDhpAzdWLmOKTr33Z?=
 =?us-ascii?Q?/gDHK5yAvxKnw/4ecrfjsfZnjtDqgHsKDTTPfpi3V/WH1TFn7zF5udEN57Rr?=
 =?us-ascii?Q?JqX60VsV9IK7nZqaOK+O+JqoopWp/Q07xPCfVx/yV+qQZZWw2YcG/BctKL3S?=
 =?us-ascii?Q?vGH9pnow60rWFLAPUBC8DhAmPjzKZb3JKGeRaehPAEupoUFraVpcz6pmNZV3?=
 =?us-ascii?Q?JS6jQGagmhsu6kwpxbPL9+0WSlOu+dYVE+yTy7+QyNc5k3YSo9aXKZjCy8yH?=
 =?us-ascii?Q?jSuLZQQQQtSH6t3LCXuei/mUUqkpFkPHds56mKKH3K2UHjMCyHd0tCrrfAAU?=
 =?us-ascii?Q?UCQQ++qY853is9Qet+gHvNDzrLrRfiJxKpsaC2kMchSsle4U20BJX4kctfxT?=
 =?us-ascii?Q?/A503CKS0OIWz2WSK0qYffjtHqFf/vmm4o+8v/cCEAOr47PdFdUNvijMrz89?=
 =?us-ascii?Q?ZTGV80f+rhD8DeXIoO7MxLi22zZy9dJq+KrK11p9dcHs/AxkXkrfEJrE8Zl0?=
 =?us-ascii?Q?wQxw0aGz7eLkPiviw0ie2bQAqv5P0KrA8eSjQJjvcEkMvr9+zgbp9W/jL9SU?=
 =?us-ascii?Q?228KcO8PnlZfiP/RjoQH+WnJq1+nJz0O7TJF8kDvWe5RIZ1QypIE1K2WVlfJ?=
 =?us-ascii?Q?BsQZVuWdjwFepOkxPIssfBj5WW6lLxnw5cuBDgmRL4E/Rl1vF22s4WYlcUZx?=
 =?us-ascii?Q?B1JkHSD1lQCFrhrCUlls9OoGr+E3ExEGgCbNjDbnszwYOk9UE48N6PqxXPaQ?=
 =?us-ascii?Q?lO1DnOh4RRU9z1Wd19pXhz8fVeZ2K9lvHUMFATt2wE3Ttmjbg+fPoP3SfEMz?=
 =?us-ascii?Q?130z8kueLwRb7iFRcORXVWqcOIMkfc0jeXh4KLcJuUkTGJbiq8jKEM/VKH5j?=
 =?us-ascii?Q?sgDQoNa7ssBM61/HI75DfI9VKQedU2nsrxffLivucV7dPNsiECjj6D7Oxeck?=
 =?us-ascii?Q?r7buVFsmZ9qiWIDWpyzTXnYf8bSJBYpdTBiVWfVOZ5MVIndKDcSgm2PZjAJK?=
 =?us-ascii?Q?fBdbulYv87DxHq5k+ieaAPYDDBrY3VI7t4HCDqfk+J3fljhBsIatvSRH8ave?=
 =?us-ascii?Q?GtqZzyDvG9q03sAhlKedwPOKTuTzuh25G7yVQXdwRxa+6yZWAW0gHAW6C93T?=
 =?us-ascii?Q?IDaiyKG+vw9U8DwCQDl03rsneYyKGYGuDWEgu2OhZaJf9bJjgSZCQCZye9F2?=
 =?us-ascii?Q?X1rs2vuZKQU9PIgqKNZBv84SsjONeTAzoRUtCp+0Z/xyh290ikbNxyzm9BOM?=
 =?us-ascii?Q?huvS8WEkSfwut85Vu5TSMRE=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ede0abcb-f4c1-4e9c-068f-08d99d333755
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB4173.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2021 12:29:14.7923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Shkp8mAE17oEMTi6+4fXlwEp5s5T+H95EsyZ3ok9GK/OSlKVT0I1twb9xBMzxPWaBWkcJhVrnLrHuOl/fRcHvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR06MB2734
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

swap() was used instead of the tmp variable to swap values

Signed-off-by: Yihao Han <hanyihao@vivo.com>
---
 fs/xfs/libxfs/xfs_da_btree.c |  5 +----
 fs/xfs/xfs_inode.c           | 10 ++--------
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index c062e2c85178..f3608884c076 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -864,7 +864,6 @@ xfs_da3_node_rebalance(
 {
 	struct xfs_da_intnode	*node1;
 	struct xfs_da_intnode	*node2;
-	struct xfs_da_intnode	*tmpnode;
 	struct xfs_da_node_entry *btree1;
 	struct xfs_da_node_entry *btree2;
 	struct xfs_da_node_entry *btree_s;
@@ -894,9 +893,7 @@ xfs_da3_node_rebalance(
 	    ((be32_to_cpu(btree2[0].hashval) < be32_to_cpu(btree1[0].hashval)) ||
 	     (be32_to_cpu(btree2[nodehdr2.count - 1].hashval) <
 			be32_to_cpu(btree1[nodehdr1.count - 1].hashval)))) {
-		tmpnode = node1;
-		node1 = node2;
-		node2 = tmpnode;
+		swap(node1, node2);
 		xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr1, node1);
 		xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr2, node2);
 		btree1 = nodehdr1.btree;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a4f6f034fb81..518c82bfc80d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -564,8 +564,6 @@ xfs_lock_two_inodes(
 	struct xfs_inode	*ip1,
 	uint			ip1_mode)
 {
-	struct xfs_inode	*temp;
-	uint			mode_temp;
 	int			attempts = 0;
 	struct xfs_log_item	*lp;
 
@@ -578,12 +576,8 @@ xfs_lock_two_inodes(
 	ASSERT(ip0->i_ino != ip1->i_ino);
 
 	if (ip0->i_ino > ip1->i_ino) {
-		temp = ip0;
-		ip0 = ip1;
-		ip1 = temp;
-		mode_temp = ip0_mode;
-		ip0_mode = ip1_mode;
-		ip1_mode = mode_temp;
+		swap(ip0, ip1);
+		swap(ip0_mode, ip1_mode);
 	}
 
  again:
-- 
2.17.1

