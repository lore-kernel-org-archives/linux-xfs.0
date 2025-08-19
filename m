Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012013.outbound.protection.outlook.com [40.107.75.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230B333A03A;
	Tue, 19 Aug 2025 13:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755609295; cv=fail; b=lkKNkjpLHYPzjvEtIgs4ABDn1eBdtVqevtg/5oDdPFHlL75MdnkYWoQ3T1fBXUuYECv1m9UGk1QOCjioQQ2pZVfXzQMIX8tnZjCuDRqnYY05FyxrX3zJFE6wfUAS+woaZyrJV7J7tsmVgk6XhQ4ZZi6fPtxw9B/8b4Js+FBnpB4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755609295; c=relaxed/simple;
	bh=tIyAmdzdmrXapp2g8m7e8cfsKIAsFRy0htBHo5dSQXU=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=h0KQMBEfVAee70ykj7RbhFKe/np7Au1MQR/BZ2uFSDDdUaU/RQBhbq2wGXoBEdG+11P829LijoZeuubAexHG1oYJdfz/HknhPaR7dWj4amg3nRcpWmpK7RyJgO1zD2Wae0ODCw67qh6fSoHf82lbHd2uFh0TtqK4JdHG90VXRio=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=Vlcrj9rM; arc=fail smtp.client-ip=40.107.75.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="Vlcrj9rM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hmOynyQsNvQfr5zOYC0K1R34Ll3EdyWv6zSWkh6+FuaB1bm1gZF1wJKKqWZbnAf48MkW6ZdqDqi4KT2krH4vHgBBdLqer1zkuIUVEZpe5ochOOR45w4isissAf9w3TGXa1rUjDjqUF+Gf87q7hUqf8bhTKND2IzKrY6zpAHhGsZqYV1xb8lz+2D2bmACrWOblNKW1Vpf3KWktf+49xoUsOeOPlrbFm95hBwQoSAWAFWSrAybwHRrwRaSOAXaWaOPTKp8/qT3GZgGuWEU8J/5ZTmetQuXOoDfK5eon+ggITY4JJbgRIeR0hfT7PccXmeSVM1NQaqH1A0QbTCaQHqf0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e5NqLWF26NyU87SNZSMEIGitcHvtw0LEs3zpyPl0hyk=;
 b=sJk9meUoK2lLPAei6kylyYdz1ibKGCQ5fNH1zs9JJ+zqP2Q2bubh6JBwDB6/SkdSDlx0gF9yxNuw+1NCv5u9o/V/DGLxOWGqlzlZr1IjeHVr1CXF4lrGSJIT42Lqix5HZ+DrW1nCypSz3AfbKp7EUf4vJXqjypEKMb47etFKdwq9g2y5FZiL58fluo/LjrGQX6MUOsnyMSlOuR0UC6LftjHpEwyAHklAnHonNmMu6UEle97qatiPPVSL9zZJy0FAJ2juG0Moq4gQXLba2a6U+rA8oWKboHuDwvMcnjMxgFsWverjvJeOR6fmW7uZ6ylocuD4Wp199tg5vqEN71Wp0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e5NqLWF26NyU87SNZSMEIGitcHvtw0LEs3zpyPl0hyk=;
 b=Vlcrj9rMrNG0HDko2qkXFEqDZDzm+r6gq7E0Dzta1/klHaKSTqHYikiMN9CSQjTQR6FNRIoHj6gziVV1gx1lZ5EGWqQA51bFy9gysuEpV3AQkT1c754hqTd6ubR1EaF/40reRWtkRPTfQ7ekP9EJAdWHz3RWbz5N+YuVlBOZEH63N4rw79Negk3Bqn7zd8tnfGSdmMUlEfp44e7hEdKGxPVqnYeupJF9Bm57xV+GahW8qfmXr2jkNt9MIccTa1lPh1FDyl7nNOGMygM+jEuzCEC5p3iJ6Hqwm11CBkEzG5Ww65/p59AGl1462hlmHh/pZnij/70RDKDGROEW8jmg8g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by KUZPR06MB8028.apcprd06.prod.outlook.com (2603:1096:d10:49::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 13:14:50 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6%5]) with mapi id 15.20.9031.023; Tue, 19 Aug 2025
 13:14:50 +0000
From: Liao Yuanhong <liaoyuanhong@vivo.com>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org (open list:XFS FILESYSTEM),
	linux-kernel@vger.kernel.org (open list)
Cc: Liao Yuanhong <liaoyuanhong@vivo.com>
Subject: [PATCH] xfs: Remove redundant header files
Date: Tue, 19 Aug 2025 21:14:38 +0800
Message-Id: <20250819131440.153791-1-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0214.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3c5::10) To SEZPR06MB5576.apcprd06.prod.outlook.com
 (2603:1096:101:c9::14)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5576:EE_|KUZPR06MB8028:EE_
X-MS-Office365-Filtering-Correlation-Id: bb26a671-7e5f-490d-487d-08dddf2260c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|52116014|366016|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Hs1ikG9Gemk6yafU5lqGfp37xo8Jc9LZU2xDkg2yOY8m14VZkrLIybt7JcCp?=
 =?us-ascii?Q?tAJvLsIgjdCetCJd7CjIrJ3jpcfaCAY1eFeb8f1JiiTUC5JS6gLNgHfWkaNz?=
 =?us-ascii?Q?76G160QqEA/5MWJ6cZFntyOAExmMkAIGAbdpxsxoOL2bY2tFHLrQ03YxeP41?=
 =?us-ascii?Q?xhOGYXK944q49g+tfyQwnMytf9HNEMS+TmieJk7j7M2LvmvrlAoLPGOhfHys?=
 =?us-ascii?Q?UmcY1qe9LVisKQf2WaoQq8s3b20p8ABgU3KwC9kzIQzdYKgg837JW5ZMn16H?=
 =?us-ascii?Q?zrIMEiNCVjPP/mFSqakIk5J59jG4AU2TmyFddENh6touYDr3RPwsIKBCXVo4?=
 =?us-ascii?Q?9IpRv9m+FoaELqdfGwq/wZLCi+zhSnVQ8wYpuslf+bspOiQo8QcSmR6q0ZxC?=
 =?us-ascii?Q?Ay/o3u3PBAxvTLY97iHyaBprYOU78DKs+4jaj0+6aH7FNX4FPdCetXreFI/E?=
 =?us-ascii?Q?Iv0/3rIUF5CkgrFZhtaQ+zmAiLA49rZOSQBUz0uDRCIpdVY6ZkMvh1kBk6nR?=
 =?us-ascii?Q?tg4kuFt8xa0Pjzcy4R1ymOMxb7CFPBcra4LzpHi31RoNreqJrwnMrQcrmpPR?=
 =?us-ascii?Q?TtRq1I1NJV96aoMwimXRNLq8tpTrCqhFFBtu8WA0wakRdm37KEm4svzBmDc/?=
 =?us-ascii?Q?oH3wEDvs2ZJ4etcgLtI803J16tMhYpwJsHLsazFEBdMuSSNz//PeEd7R/SBh?=
 =?us-ascii?Q?bQjPVFbhSzFnYJIpP7fib5sYRXS4rqumzjLdpztBgxM7u0q3ooEnTa3XQ4Fs?=
 =?us-ascii?Q?Ymw4SXK/WrSbD+URG0EuChzN4hK4/vFljXJ/cIpcqRPnPF6mXZMG0O/HvaA7?=
 =?us-ascii?Q?WX+P3XJnim4l17m5PSc9pimjSaUFmEEAC4W/jNY/JbVLmCAdXVe6Ta6KC7lv?=
 =?us-ascii?Q?QUk3XON5tRnn7AU1mgvgejJo6t/XCmYfkxwW8tY1f5p6MI5cUoWxyBfxn8t8?=
 =?us-ascii?Q?3Ps+mtEs9mntsYcGdfttnHm9erfkNcC24UVEtT0s+fE24PzsyTYhXvHGp6l4?=
 =?us-ascii?Q?iS4NtIyKCVHNJOeOVLFaJe+hdLk8KmBsgwZq3x1ioOeHJn2bYf6lzNRE+Tmy?=
 =?us-ascii?Q?MDCon6HiPxTjnx+MgcsuNvKJ6uQRhcrrMkFj7IH1Hi2VTxn5WbH8FO25cRyl?=
 =?us-ascii?Q?XWCU/9De2FjbIHr63PSZpEOM7ezcL/6VovY1g7oyf0RSHAFwPFbdROxqUYbf?=
 =?us-ascii?Q?o/eus6Ota04YGHqFyAo01ukCn8HZFIvIMO+8URwwW/QYpKrMbgvMQzJPYEzz?=
 =?us-ascii?Q?FqboAMCQPurXowGrk2+TJbGQV64Og60eSJDtBicQ2XQBe6nuCcxEsi22pizI?=
 =?us-ascii?Q?2h8b5g5rQaHQeNL7dvO5L0bgRCwlbbrGiS+uTKwhauMwvjQZPKxNsjo1WAgW?=
 =?us-ascii?Q?Uk7EdxMU/qz60k0MNo2PWkq+UxrkhdGWYQ5XWf3jm1bpHD9BPgLHbCbzoefH?=
 =?us-ascii?Q?ZdyVb4bfRzM258gpbCkvqc/ZGevLt474DBtjot21dBdlBjf1t/m8rg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(52116014)(366016)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?44VEQHiEcRYKQeEBvcf26tAuq91DwaA54+9+7f7GXUFvVfgugMcSqH4PCABG?=
 =?us-ascii?Q?16k2c0xxeSN9OvR3ZTw18Xy/Vjdj9aT6bCADQKT6+OWMkwZHd4TBgBxiyAHW?=
 =?us-ascii?Q?7vDes8f9uRjwKaNDtY/5m4sjfGBB99US46cGWlCB8/GMHmJMgqdQWldEhgqT?=
 =?us-ascii?Q?7qmt8F6Fecuio7GdlPVigGI7YkqCD+tj6ABj8eY+i10GBTqKFih2BNzOgyta?=
 =?us-ascii?Q?oUe8ifGTjmC34Dk4M2tnx9X1YOa1oJcMlhrQu7ZIVX43lx4Ang/7lxMezfmV?=
 =?us-ascii?Q?rPIYeDaOdSFUYD/LsMhoHzsz8dgR2p9TzJl8smrL/cAl0U0h+03t9E4lYPQ2?=
 =?us-ascii?Q?DEvZaYMwzuaZm2NUkPzsxFVPgQXaFYsCEvMiLfj70vi92RIwy3jnSEgeZwVl?=
 =?us-ascii?Q?KNsk2fR3vkwRXQCXrIm1umN/ahbTdalSpGut2qPOOebWGHpbbnghi3GxB9hm?=
 =?us-ascii?Q?LJOToKJeOlDRm5ONCDw+yuPCs1rjPxLMUcLQiItyWy5gVIsnj/nU4kkDEaQ+?=
 =?us-ascii?Q?TJUkSVwfe0GsD+0vEavvvlxcm26X9oT7r/SfVN/vgMH6K0DzI71lz/qltYae?=
 =?us-ascii?Q?3/n5baQCou4K7hjk6a5WwsxBor5Ab8ugrSgdf0M4TcWuDTE9I1KKCAzvsVPe?=
 =?us-ascii?Q?U2yB/QQm195LugfXbldFumqA23PWAM0vCzBYZCSROQVwHmzCFl3DIzOPe+Gi?=
 =?us-ascii?Q?cEQpUNoyBuZguVJsjzPew/hhm97UnFVJtBxx+pAlq1UypC58eeBoPv6/OnNq?=
 =?us-ascii?Q?QQdZwWY1Amu7ViO+Zu9Qt8FUx4WIiEndEaxN3GswvQrBw55jwrJm4299SEBl?=
 =?us-ascii?Q?gil7dIVd1SXmykVx61Gw6MAKwTKakVj4iH5BEDoRmZVx6l6YSLqt4EMsqT/5?=
 =?us-ascii?Q?G33QXPE7BV7AHxf3gacFhh7/QK8QMFi6rLiwE0N+U4MLvVemQrCVroRqg8hZ?=
 =?us-ascii?Q?V7kMshnFVMOnmyMQ5Qsg0huZufCQCL8xJI5qiABY3z9pt00QGZoA9DPfq+T+?=
 =?us-ascii?Q?PQfMh0DBrEh4wB8r00wXjW25HrQV/NiaVoaKwjd0//TRibGFma9+dBjlN7HV?=
 =?us-ascii?Q?8jrtu6fhSZvo8JHZa9Nh9FzfgBVmLDOFUaLmtsqM5uJH/0rXLI62gQmBzyf7?=
 =?us-ascii?Q?WbXlx3oedCmmYe3Ms4gSNBfVtgHNQsjY6mB2peostzctEgoO+6jatwjKtaw/?=
 =?us-ascii?Q?s/9YkE8HMFGoxOl1owXPXt+Dv4vmIqHT6kxzgRL+ucgT1gYcSgMTxIpL//35?=
 =?us-ascii?Q?JCM4CGPWKPnROVGfbEhonZ73apRLIj/G6spVqDvAGUcUO5KWDenZtoK9PLW9?=
 =?us-ascii?Q?iyhV5hdAjxb/EgGPs7v9RmGMpFsCND4oK/AWVC9rTtG5m1wHHuBmDd2rRdmh?=
 =?us-ascii?Q?e/hgI+nglxnaywRfzOIDoDtAopxteZ589c/CAvIaYe28J5JlZNtoeKKvWcH7?=
 =?us-ascii?Q?jBAwO6nF9k/I5xp5cdUTQNEqWOb0vnfVId9X/HgS/roTMiwnIUC+7Bc6XyS2?=
 =?us-ascii?Q?/Zh55o6+lrFQFKwH17mTZ0y9xvteP8u8vLJuucxYwbYSf2lvy7BiCiKDsJZJ?=
 =?us-ascii?Q?7JgcNIEye0dEYa/ZtR4t5CYV/8Zwkt9rlF+sED43?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb26a671-7e5f-490d-487d-08dddf2260c6
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 13:14:50.4358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FtvfcjM39elZvEoNnJByaGdUTlpCUVwQUjewz3qM4vxALcuGnzEJsKBthRstAfp8NDnpA4/Wver6lq2pTYieog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KUZPR06MB8028

The header file "xfs_rtbitmap.h" is already included on line 24. Remove the
redundant include.

Fixes: f1a6d9b4c3177 ("xfs: online repair of realtime file bmaps")
Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
---
 fs/xfs/scrub/repair.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index d00c18954a26..e35a1c56d706 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -38,7 +38,6 @@
 #include "xfs_attr.h"
 #include "xfs_dir2.h"
 #include "xfs_rtrmap_btree.h"
-#include "xfs_rtbitmap.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtalloc.h"
 #include "xfs_metafile.h"
-- 
2.34.1

