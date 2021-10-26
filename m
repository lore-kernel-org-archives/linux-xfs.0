Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37BA8C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Oct 2021 01:50:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24285603E9
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Oct 2021 01:50:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233488AbhJZBwc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Oct 2021 21:52:32 -0400
Received: from mail-eopbgr1310139.outbound.protection.outlook.com ([40.107.131.139]:65120
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233434AbhJZBwa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 Oct 2021 21:52:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aF2DA9Qx3vBojh67znIz4BvZi+ClLHj7Ni4nTniWOgsLJdk9u01/2md8JM19aD2Sh0ojpmN31CcNXhhvCEQz4qj8b/x584ZwC0jqTyizdwtrXaTiPaDA1wApKi6TgbxWlseX0UD5BD7sIwmDe/4xgKm5c2GeyIw3gamN3LdtAl3doCCZQQYEDzuFErfPKSkZq4MrpaRC4zGudjAb4fUFxDbmNjn5k/tlNjhGEtkPJ+7hDMN5R+SX2xFqLq+xPSOqn27guwOHNuV3vAG+YpZ3F/Tb4DZHZNFQCnADluWTWpCV0CmUjzjX+n7yRVsorgi31NrZANu7Cs4sCU5OrfWKYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eoRTKNY2MH3QBeQZ1ig/9VBk7UXXUZFfY9RA8oAc0L4=;
 b=Jfi2eSvQobi1UeGzaFoda2B1fTd27wF/7tbpQwn+5N3eOLXEVSyUJooHtPoGWTfB1H0KolE7t9ZILFVV0Ou26PACmKyldfYLrXpVuYEEo7NvAI6wAvx3dRySltX3KRa6CxLVeIzEzIwF/VnOXWnRX7lIoG+TZnt0pirNnVDrokqBZDvUzBN3GDY9SYwzFluhuRlpYZHWdTXSaKnBPS0KMkQogLl/u+WGhUuy5yB/ly6jNrc+YxZQ1HtAqNf70zWRvPn1KSKTWNFxLxGTkxnbMH28wf2TETFWpM0UQH/s/KXp+qhNA1yiZ63Wfb3vI9ld+qmCgiaIYSrKty64BJ7tVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eoRTKNY2MH3QBeQZ1ig/9VBk7UXXUZFfY9RA8oAc0L4=;
 b=I3p7tIeedf90Oqc49p51uMYxa0V9g0eFf7AwiiZI2N7Tj/GGrsDRgSZjkUu3zKmtt0vgv6B5rGi0JW2b1Gf20wtmcMFCXJW9jZOf2+XKGbuJipXWz8rYgtuBydpIDbGNY5rI+eCoMrOAFT0xw2UC/VqrFYnkhirknpKe/ZLVzXk=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 SG2PR06MB2457.apcprd06.prod.outlook.com (2603:1096:4:56::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.15; Tue, 26 Oct 2021 01:50:00 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::fc12:4e1b:cc77:6c0]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::fc12:4e1b:cc77:6c0%6]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 01:50:00 +0000
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] xfs: Remove duplicated include in xfs_super
Date:   Mon, 25 Oct 2021 21:48:07 -0400
Message-Id: <20211026014807.27554-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HKAPR03CA0015.apcprd03.prod.outlook.com
 (2603:1096:203:c8::20) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
Received: from localhost.localdomain (203.90.234.87) by HKAPR03CA0015.apcprd03.prod.outlook.com (2603:1096:203:c8::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.11 via Frontend Transport; Tue, 26 Oct 2021 01:49:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b286daf-7b4f-4d61-e927-08d99822eba3
X-MS-TrafficTypeDiagnostic: SG2PR06MB2457:
X-Microsoft-Antispam-PRVS: <SG2PR06MB2457E504B574C20EC42310A2AB849@SG2PR06MB2457.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pJZJQpNxAvhgjn3QeI2XDNf3RTo9U5Tt6bAvd3kt+xqHBEa8bkq85jwrSCjRQhhXFy+WCsEdQ2nyHy08Lb8Pue54ts2PnxwYSu0tK0iFGTiJ1gtdysVn2KlTCvJt3fwfNA1WOG4Jk+9B3YvN1frhpB+FYaU9AFpmfeaR3ATp8gbFeB01mjbqe5OZSv+l7bMal7vH87Uzo8NvLqVAngRgLDcAfqj00LAg8i1BxnFl8MTrE7n2Tf/vbgJ2N7eIwwZPgi7h3EOhauXDbFVdBiElyJMhef1JurSaIAH2F5B8vwEGRUHGCEozzf42L1WFL3F097oKgWSThmRTmW3kyHkmvdE9fARNJgnFx6w39/Dfz+HoToNFen3ExnYqFu2JQklN+Je6l7ympeHuf3HUxMuXgfm3dSKe2MpGjqoX/VPkmHKI1X3AiD7Zqzz4nQE1xfKpuzQy6iip/ZCXxKQIliIJPjh9D/InZqDiOzsauX8unNtmWVM8xdDLBfpTMJYa/YFFE7dxds2iyM3TrqJWV2iUVSp2EodBliXXonrfNJYLJpixRq95KATg/prDnEVaGEzTmLI9QwSz69VtrA9jfeiqfuVEvxvc7HKkab4V/xoS5/O2qxa4gMQZXjMySLIREQ/kVf66w+MNop277HapvIO6vfigmGp6zSqLeQhyAc2O4fmOI6QEKCtoDbM3fJL7rrOSYsYGZjlUncq60FcPp+sdjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38350700002)(6506007)(4744005)(6486002)(38100700002)(1076003)(26005)(6666004)(8936002)(107886003)(2906002)(6512007)(4326008)(52116002)(36756003)(956004)(186003)(316002)(2616005)(8676002)(5660300002)(508600001)(66556008)(83380400001)(66476007)(86362001)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dXkypFAuk8PUTuv+hMs1f2PPKJZ7fvYVK1Bgr67pch/+0q9okrfPOEawQokl?=
 =?us-ascii?Q?gbSvUOFG5Dxv6hupxtXxaLmhJKWmA3kVHS63B5FwqPBboPwAsqof++trOTld?=
 =?us-ascii?Q?Yv5PdhvtsiZmxyI00xO+nNRiJnmN3l0RrVVPbyuSlQwpNVpicHG/2NVGmal9?=
 =?us-ascii?Q?1GAJTQeRK/b098M/zPS69z619woKj0ZCFqsCLJogD1k40y6QJOdJ+c75vADO?=
 =?us-ascii?Q?F2cimXB0VTlZqnoEeELXbK7IU735xTUgc+sCfRJAL3Vt5xUDQYJd6m/vr03m?=
 =?us-ascii?Q?JnuXpsjuBIJIMlRYaMxsbeNeNd/ZPxiY4E4lHPZF3uuQq/YU9VDHOoqupXRP?=
 =?us-ascii?Q?kZJU3B8FA2WoUGCiRIOZRgSz26J4cfme7NJJOoqNF/J1RPVuBMyCrc6vvnKO?=
 =?us-ascii?Q?v+HBTejbLADg1Us6BxrqTBzTy+FDOJ2eDwq8aFhERbvc2oKinMu5koOfR25u?=
 =?us-ascii?Q?NycE0nQhpE73Vkv6GF1etb5WF4KuzK9nLxjTsOJHvej6OAFvLIcvl41tXCTO?=
 =?us-ascii?Q?mKRgwhDAAl1u4HuWrFJL5O8vRyY+u/v5OEz5DoyvwMRCp/e24txSIjTADVrT?=
 =?us-ascii?Q?zDKX31lAkgIb+c15HHYbxSgJFue6UFP4HJuEyh9FfwUFXfE9kftX9lMGhl8W?=
 =?us-ascii?Q?nRtBMUc7tWXvcghDax/uxA5C6/EPZWmCN8q6QzFSnbcFoEPjBdugYFPEDzp+?=
 =?us-ascii?Q?UFYTsLR9rxvmL6558UDClcQRMgqb4zWJZBf1+dN9sghGNwd0H7+/Unb9chwS?=
 =?us-ascii?Q?choat6n3/Z/0oHl5xFrYzKsneYjdfJheBCM+6c5udFkyVE7SGtHzsTM7SMjm?=
 =?us-ascii?Q?cMtwTtbN1lMMHe7mCb4E8/wV8+r/H0UfYOujzE05oOwTD3/8hHEhMj98Wpn5?=
 =?us-ascii?Q?bfD+cIUtCUwenyQuXCBeGEJN6mmK9j+osVpd+eMkFRPem/ZVjFtsnP+4nhxU?=
 =?us-ascii?Q?Dj1udhK1AgE2QpN5d85FtcYaNSv2pFT3p8UPI/okUcIckSZCrHGCqHMO1Rtx?=
 =?us-ascii?Q?65pYKYU3j3RDhonoGBWesXDmA2lxmd1Ud5t/JOn4n3JbMsWUzB1d60BTUM5r?=
 =?us-ascii?Q?QwXO2QgBq9fypwDWbqUs7L4vx9vNS+3QKRjgVOpDYLFgTw9Hz19LAk150tLk?=
 =?us-ascii?Q?8Tb3ZzKkNuk2m8lKqvG9y00I5RADs7o5SBN+CINtAZAsG9FyhlA7VTVlo9G9?=
 =?us-ascii?Q?7GWMnzXWzZHDu1Cnlc1R925GT/T/wQZNx5eZXuFQ2u6jrlXpR88Zp+ApJKhi?=
 =?us-ascii?Q?m6FaLCdsxlfWoJXV28+mhBpHiCRtvdLfk+5YSv384lD8VoHks09FcPy4uP23?=
 =?us-ascii?Q?7yusRy90tK56i/uNQdtvD5VWGV6L5OkXJEVf3fSxX1tsMMk53ZszUWLwlduh?=
 =?us-ascii?Q?2dFrXgdYtgV8Jgr2spASuHwwkb/tbxN4wQOUXSk0DbBWuqiyqdRCRNBi8t2Z?=
 =?us-ascii?Q?ijv/Z7vCoTK4Q+aPndlciGaNCAXslnuVfryVYGnIhbAZwJ+dafcwxZIYb2yW?=
 =?us-ascii?Q?oE7F1f4szW97h46YnhKQf6Di7G4lrlMFhkrLdUAoJguZTmQMwkr5h7XADAEo?=
 =?us-ascii?Q?8LCFl0U9DzLWxlAHr1oQvVyd51IOgsoj9JUjtvI9ksH4qeyxfEJj01XtR78U?=
 =?us-ascii?Q?TjLxMEL2vrcY6zQbrPtSSHc=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b286daf-7b4f-4d61-e927-08d99822eba3
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 01:50:00.2621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yR706ypiMFzYtiZvXZo4Ku4QwAeJEB6Vc+mMYoZnCGkwhc30u92EYz8n28A1DZGJH7atCjuAB0ln7tiuSTuVcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR06MB2457
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Fix following checkincludes.pl warning:
./fs/xfs/xfs_super.c: xfs_btree.h is included more than once.

The include is in line 15. Remove the duplicated here.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 fs/xfs/xfs_super.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f4c508428aad..e21459f9923a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -37,7 +37,6 @@
 #include "xfs_reflink.h"
 #include "xfs_pwork.h"
 #include "xfs_ag.h"
-#include "xfs_btree.h"
 #include "xfs_defer.h"
 
 #include <linux/magic.h>
-- 
2.20.1

