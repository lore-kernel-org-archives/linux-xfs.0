Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01olkn2017.outbound.protection.outlook.com [40.92.52.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D9418732E;
	Thu, 27 Jun 2024 13:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.52.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719493984; cv=fail; b=TsMGZ8Z/+5TPtm92PL15MAyZeSPBzVhiFQQkgrCM2f/9loSBPKOJQ9guA+z57FapBhisgcwpMTbWNu5IZa46eKsL2z9EU8LSFXLLvDNx3Liznvd9W9vRVcvMtKqjaUSVKcaF8+UMGKHv6syrOit+auKyAyEmCBRoEL5djJbzDhY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719493984; c=relaxed/simple;
	bh=k3m3QXaXSBhwANZeDyLrJIeSjkXCLZFIBl8f0FpodEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=aogEQLKfr+7oJs+IL02CqhUcM8GckM4T9yf5G2T7FWeq/Mlbc8IM4FvCq6qg+FdQ8ZE3FgNl2aKSD9Ds5epZ0RG8VDx107qHZmbnE+goEbKh6dS/jo3IogpL0sCUdp1PN4mduru1BrxMlI9XgbuP99TjSMfWb2//DM7Vs0QRu1Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=BckfsBgg; arc=fail smtp.client-ip=40.92.52.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="BckfsBgg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gRZ4VKaPR35ycILQ06rZxzqIMAY7ZSvgEP9oRx+Ti8qVdGZH3lBX1xC5IlTBZGQgetKBUnX+B2Ls2o2GxJKhvxbHJN4IWR8Oo39gLOOXyl/RNX7J3uJAsaIxrHJdSmu+xQ9JNY9eoUo0xON8CxLyMo1vPpsHeGjK5t2H+pFmq4w0EfAfWzmFElrhX0DQs9nzAFERXSAbjAGpmtmV8kXOGmvnitLLNS7Zi4QJo+CbRyINDyjjgrGIQF+2miarDwy6Rh/aVQb9IbPR/4DrQYGj651sRd9gAFe1ExFuU7CJu0UwpOge0gXi9N1OAPWB8wmrC2/oWmo+Aj/POMaBuPHMwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8J4FSctWAAr0U0SeioLR2RqdkRneW9Hy3GT3hfzwksk=;
 b=Ox6jSJLSNGSXU5/NBnx2BpiZwOKXDMaZtD33TrqzWNcZVZ8phJvtUJmOEDkmb89QaQHMiRaWTXyMzV4ds6+xQ6F7zeMuRGLXO0gaOuf41AkJvjjx8TXp4wqFa9PnuUD7nt19GTHft+7vDtVZmUr3X6YQogehD7wVJhUt6tix0lE26U7HXJRoLcqV3/g12WMxyGt11BOObwF1Wyb4WW3g23UjNpVsxzsgTOVx9Vub5A2FdYV8L9jrGgDYTY94Wby3/tXWnPF4KVS8hI8PGlzVlPpO4QZiRzEgrR5z/GSLR0xk+ZDcBIlAJWn5cy6gGxqLr+sWBNa3tCyIPau7O3T0Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8J4FSctWAAr0U0SeioLR2RqdkRneW9Hy3GT3hfzwksk=;
 b=BckfsBggBS6QepT1sFG7I4OGFzrS4rL4/c3VCqQ4mtKJZO1QVIfNozsrjuLPINJIJ8smVzMhKZxa9hbwAy8Iz30CtjJ+xCHkH2EYE8u5uLwfJ9J04AYKDB+VMtC+JxKoGgZfEKMVKN75opN0ujRTYfAp/o/H9pnA3c8uMbD2aRy7XkpHV9FEqFw6F1mvUoM+OiPcNDJL+ADV9H6AHJmFO31WErBRpDbHhmuBGdyqqYWgQmzc/zU6IKSbCBTM1GiwQK2LvRSQRp+fkL7rBtB8IRdwtkpjMH6Wq4fM7rqnKFBp84HuMwdKOCABMsmOdvpsXJ6c2G5RXWsbmdvD3xjt6g==
Received: from SEZPR01MB4527.apcprd01.prod.exchangelabs.com
 (2603:1096:101:76::5) by SEYPR01MB4127.apcprd01.prod.exchangelabs.com
 (2603:1096:101:53::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.32; Thu, 27 Jun
 2024 13:12:59 +0000
Received: from SEZPR01MB4527.apcprd01.prod.exchangelabs.com
 ([fe80::653b:3492:9140:d2bf]) by SEZPR01MB4527.apcprd01.prod.exchangelabs.com
 ([fe80::653b:3492:9140:d2bf%5]) with mapi id 15.20.7698.025; Thu, 27 Jun 2024
 13:12:59 +0000
From: Jiwei Sun <sunjw10@outlook.com>
To: chandan.babu@oracle.com,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sunjw10@lenovo.com,
	ahuang12@lenovo.com,
	sunjw10@outlook.com
Subject: [PATCH] xfs: add __GFP_NOLOCKDEP when allocating memory in xfs_attr_shortform_list()
Date: Thu, 27 Jun 2024 21:12:43 +0800
Message-ID:
 <SEZPR01MB45270BCD2BC28813FCB39AEDA8D72@SEZPR01MB4527.apcprd01.prod.exchangelabs.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [8ZQkJ5M+9k38emuQehRRgWfrcGN6BYN2]
X-ClientProxiedBy: SI2P153CA0016.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::17) To SEZPR01MB4527.apcprd01.prod.exchangelabs.com
 (2603:1096:101:76::5)
X-Microsoft-Original-Message-ID: <20240627131243.3388-1-sunjw10@outlook.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR01MB4527:EE_|SEYPR01MB4127:EE_
X-MS-Office365-Filtering-Correlation-Id: 9318a6af-4fcf-4e3c-48db-08dc96aadb57
X-MS-Exchange-SLBlob-MailProps:
	ZILSnhm0P3kCfS/wDx1XBPWRyocQNckBeJ6wAn71A4mWqYziwyKT5y2Tb17zQfhJMD3L29TtOLsDdujyaCruREAgTqLiHrCOYk8sZ+oI+vs+tpwAah/VXH0+RaqTzxNtSJKOMD62HNL4d+hh8SDOKVTgcDsMFi4UNdyZN0/EG/NFjVDkWbkeCIdFxPDUuifmjGjBWG59o5aN92jgQ0NCcuIC7npwyLa9JNkV7QiCRJXp08vLYOZ70Ira3Y0UkCj/ZYD4e9gdWbZBc1GDm4HQ0Iej5h5yaVldo7enoJJfI/7ImRKgpHlsLDWzpkfKiUJ8MsiXIoMrQ2HjrEYF7zjEGz2rjJ6mZIpL8PEEThjkBwWBpmdeBKn3twqpXuSrIp1YxNo2A86yPxAYLIQdmh+KKS7x6hmdzDXJhaVCzffAHEdttDz2dLdZ4dPsEhI/f0ipCJoyG6L6K7HAg+I15LYRcPrAihqr1Qqqn9koXxqnDoyIlIQXWXRnMXATeG+G2nT/5GxN0QN7kvl8oHad3WbLic9RREquMvS+VQAon500ddhiSaVkPW3BhMD2SGY9ujqggANpXN2HvvPSy4qDl5w4tmRSuXt/UzzBcXR/khh+o6dXwyRg9YP3HuyHvTol8Oqz3+/DscUtG+vf8JrqE4n2Z98vBnd212o+IVyagV7vvFZH5cpaka86qGaDJhmZyKPkLQiVgn8PxbyyBmRmrDKJuGAjnP6iXTXu5KBxUaS1gOVYEck2qgVcrCKIK8l4phIxyIHiKssYv9lc03ALlxztXcM7Um2BuwnG
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|461199028|3412199025|3420499032|440099028|1710799026;
X-Microsoft-Antispam-Message-Info:
	cTBEHcoDt9t+dY61lH4FtHI5CBj99UYnsRc+9+EoOKHCrmi2Lfmulr7crL1MAebc83XFNSY0mUKE9WH2qvfYz5d9uyMy3jOeN40Gp51+YkfDWpsFoizUvagS5xmuUVUQxmuSe7VodDGEIxUMoSuOXSSdVINoe1Mm/ljj6pKOFgjfT1y80IGBPDY+usgHAZQp1S0SO5KdR2fgiVHl+DR2cHAgEH30kLDpjYLzU/j/ZPCiKUfommyf2wX/nGjxhRcOsNSRMhvaq4bD87uo+dFSgKRbILnlHv6FdebnMb0ePbquImN3xcdnGNPGVDlLsdXugbVvr9EMiDjvWwSo3++9m6skS59O482HHbIsjcbb+eUG6uTUVwmctC1Hy6sWoe0ZMWLXlYuUELrZ73hYn+nCPwoZyeztSAEXeX/0B6F1P92yCyVa+sdUuwb/2CqDjsFXH63QorqkVzBOmRQUzkBFYpMs3bjRG8mTAopsmA/HPySYV26bOoawWEDBPxs6cSYrEwxahBWAmJ1OgskunXZwEnaecoPygYD3N3j3mrgOQPg8dc9IqmHFvJHafu1NzSJXoaci33SJsuY84kwxDG7DLA+AHKICkCxRtUKWnxnh1ik=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/Z9SiGI5cuIzwczpHJN8sKCECMAg+Udno5RU1Rvj1H4twaXksiKkoSCyDpB8?=
 =?us-ascii?Q?uo5FFt3Ov4yvC4WC0siKHUJvWsY+oyUgLDvqsF+N0eEinut3OT3wyBi2e8Tn?=
 =?us-ascii?Q?0wnirx6fHOctheEwAyCyQly+nYCwVYgiXQGhMOyl7EKYFYuw9Z+qyMzrJBEM?=
 =?us-ascii?Q?zmGJWoiaDNkgVZ3ToSQ5EYqljoX/FV6Ftlt9BsNGls9BbPnsIgw8nOKJVhbO?=
 =?us-ascii?Q?NDdC+LeqaEdUhrW0CC+FSZoyb0Z5mPKEyg4m3wAo8o6tVgVS5hr6+pjXL3eT?=
 =?us-ascii?Q?hLx2Wonw+lOcKFYvWtGwB6FjQAnASsy/1k0FNwC41C8SfN5RTGC1HuVaL3D+?=
 =?us-ascii?Q?XTV2b4twU+KWHW4Ul4G3SE8Qv0FwS3t0A9Rb6Po0Zr1hjiuN486kXtjUWvaR?=
 =?us-ascii?Q?4Ou7taoiLjxV371hq5o0R86jOV74isPAXnEte3Zy6+hmHgcSpPqjtuJSVLpW?=
 =?us-ascii?Q?WaXb/YRIAC3Mc2Ox0dnd3o44eLAyjnxMUyMtt51G+wCe55KjWkB97RA5fYmq?=
 =?us-ascii?Q?joRXltgmrX7EIbQu8Xgqf3bhHVxCjPFZAQb3b7GaLIqxEuPI1HXLpsQfh6Qc?=
 =?us-ascii?Q?4TieLCPDa1rO+yVk7LtWIh4wC9itlZKINpikoBUR/mwQagaPRVygsg/QOn9I?=
 =?us-ascii?Q?5dzVxPUW7vXs+WVnu2RazQgA7psf+fLI3BAm1T7LUZAc0PzOBZ7dofbvKaK2?=
 =?us-ascii?Q?ubPZiYC7eXRxFCKlZayA4XUEWFqkL7xwC1IiIUOGtTsiNmCpY43nddyV3Qol?=
 =?us-ascii?Q?S82OVT48bXE+x6rWmhzuL1dDJzpTYm2J7Lq5ffFM5IownVJOvkuIk7PPPcaj?=
 =?us-ascii?Q?cZeibVTCFDCvpw6E25Jbdrqloi+Uu0mmrrUjOEl7vcA7yClRfJy9G11+UvTH?=
 =?us-ascii?Q?HaGx5FA1gXSS4rql4D3wxNfMGYKjj/Mo3dAWWFZI1owkG9RK8Pqsid5ljbFk?=
 =?us-ascii?Q?5k+83450UvgZQdizgl76PfL74iYQcRIITbFzgeVnnmHhVytJL66uXlIQiJrY?=
 =?us-ascii?Q?jpl2MV+7fju/wJmcW4VVHyh9No/FOFvhYUg6kZ1QoL7+1bghZbZ6O3iuv9z+?=
 =?us-ascii?Q?q4ubbmV+Q5H9y7t+FSPay5moomI4XLgCHVy8JQOLSEr0ZfIzAH9FV5Lam3/N?=
 =?us-ascii?Q?9fc8rvte0pZpY2UeszGanHfFAmlsKtXgxHTFSpuWrE3dF09yr/GBs1dRADNv?=
 =?us-ascii?Q?7ft3USKin2viVUN4aQSEle3SMXYqjYV+MIcIy2DP/uzJFUVrBm0TcDoYbxs?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9318a6af-4fcf-4e3c-48db-08dc96aadb57
X-MS-Exchange-CrossTenant-AuthSource: SEZPR01MB4527.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2024 13:12:58.9914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR01MB4127

From: Jiwei Sun <sunjw10@lenovo.com>

If the following configuration is set
CONFIG_LOCKDEP=y

The following warning log appears,

======================================================
WARNING: possible circular locking dependency detected
6.10.0-rc4-dirty #81 Not tainted
------------------------------------------------------
kswapd1/1465 is trying to acquire lock:
ff11000928da0160 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_icwalk_ag+0x7cd/0x14c0 [xfs]

but task is already holding lock:
ffffffff9fd44100 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0x856/0x11a0

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (fs_reclaim){+.+.}-{0:0}:
       lock_acquire+0x194/0x490
       fs_reclaim_acquire+0x103/0x160
       __kmalloc_noprof+0x9b/0x430
       xfs_attr_shortform_list+0x56a/0x15d0 [xfs]
       xfs_attr_list+0x1cb/0x250 [xfs]
       xfs_vn_listxattr+0xee/0x170 [xfs]
       listxattr+0x5b/0xf0
       __x64_sys_flistxattr+0x126/0x1b0
       do_syscall_64+0x8a/0x170
       entry_SYSCALL_64_after_hwframe+0x76/0x7e

-> #0 (&xfs_nondir_ilock_class){++++}-{4:4}:
       validate_chain+0x171c/0x3270
       __lock_acquire+0xecd/0x1ed0
       lock_acquire+0x194/0x490
       down_write_nested+0xa2/0x510
       xfs_icwalk_ag+0x7cd/0x14c0 [xfs]
       xfs_icwalk+0x4f/0xd0 [xfs]
       xfs_reclaim_inodes_nr+0x144/0x1f0 [xfs]
       super_cache_scan+0x305/0x430
       do_shrink_slab+0x2f3/0xce0
       shrink_slab+0x507/0xcb0
       shrink_one+0x400/0x6d0
       shrink_many+0x2d5/0xc10
       shrink_node+0x1a0b/0x2110
       balance_pgdat+0x7a2/0x11a0
       kswapd+0x518/0x9c0
       kthread+0x2e9/0x3d0
       ret_from_fork+0x2d/0x60
       ret_from_fork_asm+0x1a/0x30

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(fs_reclaim);
                               lock(&xfs_nondir_ilock_class);
                               lock(fs_reclaim);
  lock(&xfs_nondir_ilock_class);

 *** DEADLOCK ***

2 locks held by kswapd1/1465:
 #0: ffffffff9fd44100 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0x856/0x11a0
 #1: ff110001d1dec0e8 (&type->s_umount_key#62){++++}-{4:4}, at: super_trylock_shared+0x18/0xa0

stack backtrace:
CPU: 182 PID: 1465 Comm: kswapd1 Kdump: loaded Not tainted 6.10.0-rc4-dirty #81 d8f3b21024b789e635a9c2daea46fdb7762f1b50
Hardware name: Lenovo ThinkServer SR660 V3/SR660 V3, BIOS T8E166X-2.54 05/30/2024
Call Trace:
 <TASK>
 dump_stack_lvl+0x7c/0xc0
 check_noncircular+0x31f/0x3f0
 validate_chain+0x171c/0x3270
 __lock_acquire+0xecd/0x1ed0
 lock_acquire+0x194/0x490
 down_write_nested+0xa2/0x510
 xfs_icwalk_ag+0x7cd/0x14c0 [xfs 681f3433bed0d714083e513d149a819b095e6e51]
 xfs_icwalk+0x4f/0xd0 [xfs 681f3433bed0d714083e513d149a819b095e6e51]
 xfs_reclaim_inodes_nr+0x144/0x1f0 [xfs 681f3433bed0d714083e513d149a819b095e6e51]
 super_cache_scan+0x305/0x430
 do_shrink_slab+0x2f3/0xce0
 shrink_slab+0x507/0xcb0
 shrink_one+0x400/0x6d0
 shrink_many+0x2d5/0xc10
 shrink_node+0x1a0b/0x2110
 balance_pgdat+0x7a2/0x11a0
 kswapd+0x518/0x9c0
 kthread+0x2e9/0x3d0
 ret_from_fork+0x2d/0x60
 ret_from_fork_asm+0x1a/0x30
 </TASK>

This is a false positive. If a node is getting reclaimed, it cannot be
the target of a flistxattr operation. Commit 6dcde60efd94 ("xfs: more
lockdep whackamole with kmem_alloc*") has the similar root cause.

Fix the issue by adding __GFP_NOLOCKDEP in order to shut up lockdep.

Signed-off-by: Jiwei Sun <sunjw10@lenovo.com>
Suggested-by: Adrian Huang <ahuang12@lenovo.com>
---
 fs/xfs/xfs_attr_list.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 5c947e5ce8b8..506ade0befa4 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -114,7 +114,8 @@ xfs_attr_shortform_list(
 	 * It didn't all fit, so we have to sort everything on hashval.
 	 */
 	sbsize = sf->count * sizeof(*sbuf);
-	sbp = sbuf = kmalloc(sbsize, GFP_KERNEL | __GFP_NOFAIL);
+	sbp = sbuf = kmalloc(sbsize, GFP_KERNEL | __GFP_NOFAIL |
+			     __GFP_NOLOCKDEP);
 
 	/*
 	 * Scan the attribute list for the rest of the entries, storing
-- 
2.27.0

