Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 494AEC7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 02:32:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjDFCc6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234807AbjDFCcz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2023 22:32:55 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17AF47ED3
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2023 19:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680748363; x=1712284363;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Uw2TqkiJQgesDd+LeKzCl2RiwWugKzMduNEmxyDJVag=;
  b=OtNOKyX5tnGY9Lee5IypfdOX94AtYZkSVYICgZvabpfge3+58It5AxW9
   +xi65RLYfmi+mqcXgrVO2q+YbBJjn6kgrvmHLu3ra9BSuMTvZnnzDrR+2
   zkSIyi3CTruqcuP+17G53racqO28SVZjwboGZ3UcC5TfdNe4KOcMbs52M
   IFPTh/U5xuRj0O5nOpt41cyKuPnT6He2rCgKv+HH5Psi268ICkKdPjK63
   coI2gRQFyBWCir8b1kbk7utFHiLTec59320Za9XhjtbsHtZJm5AGblBuV
   VPpyY8V/fOS3HAZ5s8s0Xd0a0Wi95mGRnQCA67bApJ82J3J3QFjeW5+cw
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="405404968"
X-IronPort-AV: E=Sophos;i="5.98,322,1673942400"; 
   d="scan'208";a="405404968"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 19:32:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="756204277"
X-IronPort-AV: E=Sophos;i="5.98,322,1673942400"; 
   d="scan'208";a="756204277"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 05 Apr 2023 19:32:41 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 19:32:41 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 5 Apr 2023 19:32:41 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 5 Apr 2023 19:32:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PGbwxjJFxTBlbWBtaFQoldBlB4E0XzmgYksypjlsMcaUQoTR+qUWy7TWVosB8Rt6nmSn6n1pZXgdgxm5CTha6dv3XMah8XLMREKx+lSRkJwuGciBlGYKGp1nonh/tZ2srChhM/mfRma7ETlQlBd1cfBZkm3eG1UyC21TPOp5Nfa4+FWw/sokNiqTO9u9uGmZ/2S7xa3xzN3xs1myIttRoqlCNcCMZhJAXVENMCrWIjeUYlcuA8WydqBDJtZcbPoyGNmj7fCVYIX0hSf6I4McONeP1rFe79b6flSLk9zp1q1haAnshT/lJQkPpzzBRF7NioRryLNECe5LtItuNbUdlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hUBwJ44ssHf5yWHA5Dg/S29xpO6aTbDCyI7ji8GNWOI=;
 b=Xnrx/t+rqLCk8KdyI/A6iT3uUjL6JsdDeeMm2HnPt/XqvXOaExkFuahBpE0Jm3cmQV5eM3gpxxge13ZIYBaYpOdKkSX3vzCSkcnj80ORpZQlMZaHrXoHxOKff1mnmMx7ji0kWhNsfj2tERUisdTgKGrfTd4zgbYGGJJ78JZ/XF57Uc5tjDP5NvRm1SDdQY9fDdoZvO/B6SjDjzaKeIMDjwWExCN9cBXEcBRi3EQKSUyOc4FxJXvQnnSdpjBR2vaXGefkh1vxZTiUqOe+xKIHiq8iYU54zm68SgcOyVHBad/cFF3r1Sb1RJ+PnIjGPM2yjumQ46tarJJsFOTBBJTfcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4839.namprd11.prod.outlook.com (2603:10b6:510:42::18)
 by MW3PR11MB4665.namprd11.prod.outlook.com (2603:10b6:303:5d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.30; Thu, 6 Apr
 2023 02:32:31 +0000
Received: from PH0PR11MB4839.namprd11.prod.outlook.com
 ([fe80::60e0:f0a8:dd17:88ab]) by PH0PR11MB4839.namprd11.prod.outlook.com
 ([fe80::60e0:f0a8:dd17:88ab%8]) with mapi id 15.20.6277.031; Thu, 6 Apr 2023
 02:32:31 +0000
Date:   Thu, 6 Apr 2023 10:34:02 +0800
From:   Pengfei Xu <pengfei.xu@intel.com>
To:     <dchinner@redhat.com>
CC:     <linux-xfs@vger.kernel.org>, <djwong@kernel.org>,
        <heng.su@intel.com>, <lkp@intel.com>
Subject: [Syzkaller & bisect] There is task hung in xlog_grant_head_check in
 v6.3-rc5
Message-ID: <ZC4vmjzuOEFQuD17@xpf.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SG2P153CA0012.APCP153.PROD.OUTLOOK.COM (2603:1096::22) To
 PH0PR11MB4839.namprd11.prod.outlook.com (2603:10b6:510:42::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4839:EE_|MW3PR11MB4665:EE_
X-MS-Office365-Filtering-Correlation-Id: a64efe1c-b144-4c78-82cc-08db36472c04
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2+R5UuB+gQVVixOT9M+0XVCGL/ilIQ7LfSjmjfAKnAkVk1xbHozfeo0bCzIIdTRixWxcgTuY0fVwrKhVAlK/z+XMdBsDqmeWBt/6FLxZiEZs/RLYL6B/U3+8CC0Z+WlJCfoPCC+PWcez9yIMQvS+MYQa2oTzfh3miSm8Ljtia2KCMJm6hrN646T0cPRhx97xTOXy9npBJa4+smae2R2DiKgfdCA7u519f/hIUNcpupX7tytRvIbVSOBmE4iFsrNlJBoMHiaU3BBl3p8wo9B7SNThLQodr2qQ9nfPvecOEhzW2HIqrVXpFqegG9uAY5SbXGCu8iayhcVXnRrAJFmlVLO8RIZWc27+vNNMgNynla/iS5Rb9Wpk+p+Are5RFj69GASaIBf9uHUYXjd7snWON1FcO8/9m6/BgsI21DOjBTEAQ+u2OEt+TSbkwchIhkkKEQ2Cl/DrWa9vvv0EIfD1OIyKX0CroeBtdgFthpQ8b1CuqNsJBYiZEqk3CJfAuNIyyNdAZs8KbPkqCZFlwVzeiEu60YGTvoE2vrp9B6M5/z+3whXvtlsj7M+l624PtXDgjiMreK1iCKO/MGa2JN2BLtXmZhBUYnQ0hMBVf/YixN0FXLB28SndyGtpFJPpUk+SddN/q8aCLjbC659kw3EGqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4839.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(346002)(39860400002)(396003)(376002)(451199021)(83380400001)(82960400001)(38100700002)(66946007)(66476007)(66556008)(6916009)(8676002)(5660300002)(4326008)(44832011)(8936002)(2906002)(41300700001)(478600001)(86362001)(186003)(316002)(6666004)(6506007)(6512007)(966005)(107886003)(26005)(6486002)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?caA+103JxHY047VIguH6XN5dIMOD8WoQfTx0pzsxAlgtZvy3xpnNebEGRdpx?=
 =?us-ascii?Q?QaIWaoNa82Extfhkur/PXZVi14YiYMuLBcXKmE83YSyS/zZwS4FI2UwLenjg?=
 =?us-ascii?Q?p7JDq4udnzYpiHw8EAnHd4DKkXPpYWTln47vQaUIoEGL/HeprIxgjT+kCER3?=
 =?us-ascii?Q?Hwqu7cmLrTfOXUKOyyrF8hjBz6IDTZDntYNHnIbl6J/i93wNr/QybKakVAZ1?=
 =?us-ascii?Q?w+NDiJLP08rAF9su8GEF1KGr9fisSsdwcjgzRO60aXGNOZvipk1BKi6Q37Ri?=
 =?us-ascii?Q?F4Br+8eSYATm3b9p5vnhrwCIvAJfpI6bXGI7gVAB2nkS2KuujYXdCJMGJN5N?=
 =?us-ascii?Q?/dnYvGAnjVt7wRiAsakZ3qx99LzHnysmmbqt5KjfpyAjy4A51IHigItqvC4S?=
 =?us-ascii?Q?+N34WY62FKFJermBDibD/K5LWqUNgzX6YsfqWUozCmVupyzeee9+qohUtNW/?=
 =?us-ascii?Q?JDZorAvcMWiJbsNnyO7SPS8z9FKtcavIg8FAqMnyys1Sig2QoY0w9k/pizH8?=
 =?us-ascii?Q?TDTeAsZj2EoTP9/8xcI/nem82RQ1a7LLS0z8kt12y4tMAlXjbMN7G6VvYhES?=
 =?us-ascii?Q?q63vdPqkF4OfT4uFzzalLyjGKGt7YK+cV04UJPB4JrpX/9xliOK6aQXCNLDd?=
 =?us-ascii?Q?lT9iXpwUtuUWAc6l/DWlOWUJ91MAfBxWic+Ko48ySWvzMs+u/3rT2nCyBYoC?=
 =?us-ascii?Q?ij/Hm2osPsM9ULtZXRdk7MseydN1wTZ8Iu2bsqLxBCiUWfPLOgAivKsBGIja?=
 =?us-ascii?Q?fLeiF7SvJVtoer4/yWvULxlciR0o632rRczPERUNV/ibcVne/c9+Z8tsayZB?=
 =?us-ascii?Q?NwWIbWeSLWjAtSgiKq82VrNKq9p8T7pDfCVhdPp5nyT4MK3/vXESvDIfiwE+?=
 =?us-ascii?Q?XgfftRPl0MrJw+iYnc48Z1C5C6geWX5vdhPZ16TMu7Qm3F8wDw/SwTL3r7U/?=
 =?us-ascii?Q?tS/M/0vPZjIRmq5BrTZATHDdxo0O22TKHFTjZi3Cbwx1EvWtIltJ2MzebvOM?=
 =?us-ascii?Q?vHrUBCO5FJRxxAKpseX3NYodXgKTk/skI4v4Km1dPtFpXMCINoKegTgp2p3i?=
 =?us-ascii?Q?rgGhvns/DKsprk8T/T0lsqBYaqc3beLImKhnChmcf3DgXIyoV2tpUrDbjRPk?=
 =?us-ascii?Q?jFo86wHAsHk58Kx/6axu/fpnLgkK7lHoeL3FJ2i+1Cnvtsd2TcZHoAmxd4XV?=
 =?us-ascii?Q?GCvFaqAefkPp37xk7xv2//nkXj4ikMoaBsZdpc57WRtW/27TwO5ijCRK8CiK?=
 =?us-ascii?Q?aYd15ebL8xxMLLwC+F0Wkn5R36FxQmQbyCI0pa3KxWNsLzCzUKMi85PS7qCy?=
 =?us-ascii?Q?zbuPLwEXeAmXvWr28/JvT9VO1fScrQuEbHLy/cuhtnUHuQ/pEOe8gXD4ZT0+?=
 =?us-ascii?Q?gEkrt6svNnrnZEl5TPwunCPwMQXv4KvHzOVR1DWiPZxUPuE781625Y6kAwa2?=
 =?us-ascii?Q?6f2cT0QTOiYza++j3T7brI/bg1W6nnPII+cWHD2O63WJWP/PybpGuj2PbI4w?=
 =?us-ascii?Q?fY6xJuvGMFnetyNeGrG6EqA9G1XeLOJ5H9vPjgMJbQKin8sil75E9qpk9EwB?=
 =?us-ascii?Q?XV+B2DahYaDBrR0+5OUGmOQvTPnRkj3Y5HUmiZXO?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a64efe1c-b144-4c78-82cc-08db36472c04
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4839.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 02:32:31.3738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kLsQH6AABouSLAzaa1KOLoW4wyjj9rLYbEpbAEFo9gnJiE9d7edPfBZ3qLDNgS1bY8IhWZA/yi39DQMeuQhFAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4665
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave Chinner and xfs experts,

Greeting!

There is task hung in xlog_grant_head_check in v6.3-rc5 kernel.

Platform: x86 platforms

All detailed info: https://github.com/xupengfe/syzkaller_logs/tree/main/230405_094839_xlog_grant_head_check
Syzkaller reproduced code: https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_grant_head_check/repro.c
Syzkaller analysis repro.report: https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_grant_head_check/repro.report
Syzkaller analysis repro.stats: https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_grant_head_check/repro.stats
Reproduced prog repro.prog: https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_grant_head_check/repro.prog
Kconfig: https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_grant_head_check/kconfig_origin
Bisect info: https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_grant_head_check/bisect_info.log

It could be reproduced in maximum 2100s.
Bisected and found bad commit was:
"
fe08cc5044486096bfb5ce9d3db4e915e53281ea
xfs: open code sb verifier feature checks
"
It's just the suspected commit, because reverted above commit on top of v6.3-rc5
kernel then made kernel failed, could not double confirm for the issue.

"
[   24.818100] memfd_create() without MFD_EXEC nor MFD_NOEXEC_SEAL, pid=339 'systemd'
[   28.230533] loop0: detected capacity change from 0 to 65536
[   28.232522] XFS (loop0): Deprecated V4 format (crc=0) will not be supported after September 2030.
[   28.233447] XFS (loop0): Mounting V10 Filesystem d28317a9-9e04-4f2a-be27-e55b4c413ff6
[   28.234235] XFS (loop0): Log size 66 blocks too small, minimum size is 1968 blocks
[   28.234856] XFS (loop0): Log size out of supported range.
[   28.235289] XFS (loop0): Continuing onwards, but if log hangs are experienced then please report this message in the bug report.
[   28.239290] XFS (loop0): Starting recovery (logdev: internal)
[   28.240979] XFS (loop0): Ending recovery (logdev: internal)
[  300.150944] INFO: task repro:541 blocked for more than 147 seconds.
[  300.151523]       Not tainted 6.3.0-rc5-7e364e56293b+ #1
[  300.152102] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  300.152716] task:repro           state:D stack:0     pid:541   ppid:540    flags:0x00004004
[  300.153373] Call Trace:
[  300.153580]  <TASK>
[  300.153765]  __schedule+0x40a/0xc30
[  300.154078]  schedule+0x5b/0xe0
[  300.154349]  xlog_grant_head_wait+0x53/0x3a0
[  300.154715]  xlog_grant_head_check+0x1a5/0x1c0
[  300.155113]  xfs_log_reserve+0x145/0x380
[  300.155442]  xfs_trans_reserve+0x226/0x270
[  300.155780]  xfs_trans_alloc+0x147/0x470
[  300.156112]  xfs_qm_qino_alloc+0xcf/0x510
[  300.156441]  ? write_comp_data+0x2f/0x90
[  300.156770]  xfs_qm_init_quotainos+0x30a/0x400
[  300.157139]  xfs_qm_init_quotainfo+0x9d/0x4b0
[  300.157499]  ? write_comp_data+0x2f/0x90
[  300.157827]  xfs_qm_mount_quotas+0x40/0x3c0
[  300.158167]  xfs_mountfs+0xc37/0xce0
[  300.158467]  xfs_fs_fill_super+0x7aa/0xdc0
[  300.158817]  get_tree_bdev+0x24b/0x350
[  300.159126]  ? __pfx_xfs_fs_fill_super+0x10/0x10
[  300.159503]  xfs_fs_get_tree+0x25/0x30
[  300.159815]  vfs_get_tree+0x3b/0x140
[  300.160118]  path_mount+0x769/0x10f0
[  300.160415]  ? write_comp_data+0x2f/0x90
[  300.160743]  do_mount+0xaf/0xd0
[  300.161009]  __x64_sys_mount+0x14b/0x160
[  300.161331]  do_syscall_64+0x3b/0x90
[  300.161632]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[  300.162041] RIP: 0033:0x7fece24223ae
[  300.162333] RSP: 002b:00007fff584561e8 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
[  300.162937] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fece24223ae
[  300.163494] RDX: 000000002000ad00 RSI: 000000002000ad40 RDI: 00007fff58456320
[  300.164051] RBP: 00007fff584563b0 R08: 00007fff58456220 R09: 0000000000000000
[  300.164612] R10: 0000000000000003 R11: 0000000000000206 R12: 0000000000401240
[  300.165168] R13: 00007fff584564f0 R14: 0000000000000000 R15: 0000000000000000
[  300.165732]  </TASK>
[  300.165919] 
[  300.165919] Showing all locks held in the system:
[  300.166402] 1 lock held by rcu_tasks_kthre/11:
[  300.166773]  #0: ffffffff83d63450 (rcu_tasks.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x31/0x420
[  300.167530] 1 lock held by rcu_tasks_rude_/12:
[  300.167886]  #0: ffffffff83d631d0 (rcu_tasks_rude.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x31/0x420
[  300.168683] 1 lock held by rcu_tasks_trace/13:
[  300.169039]  #0: ffffffff83d62f10 (rcu_tasks_trace.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x31/0x420
[  300.169839] 1 lock held by khungtaskd/29:
[  300.170160]  #0: ffffffff83d63e60 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x1b/0x1e0
[  300.170891] 2 locks held by repro/541:
[  300.171194]  #0: ffff88800de780e0 (&type->s_umount_key#47/1){+.+.}-{3:3}, at: alloc_super+0x12b/0x480
[  300.171926]  #1: ffff88800de78638 (sb_internal#2){.+.+}-{0:0}, at: xfs_qm_qino_alloc+0xcf/0x510
[  300.172634] 
[  300.172769] =============================================
"

I hope the info is helpful.

Thanks!

---

If you don't need the following environment to reproduce the problem or if you
already have one, please ignore the following information.

How to reproduce:
git clone https://gitlab.com/xupengfe/repro_vm_env.git
cd repro_vm_env
tar -xvf repro_vm_env.tar.gz
cd repro_vm_env; ./start3.sh  // it needs qemu-system-x86_64 and I used v7.1.0
   // start3.sh will load bzImage_2241ab53cbb5cdb08a6b2d4688feb13971058f65 v6.2-rc5 kernel
   // You could change the bzImage_xxx as you want
You could use below command to log in, there is no password for root.
ssh -p 10023 root@localhost

After login vm(virtual machine) successfully, you could transfer reproduced
binary to the vm by below way, and reproduce the problem in vm:
gcc -pthread -o repro repro.c
scp -P 10023 repro root@localhost:/root/

Get the bzImage for target kernel:
Please use target kconfig and copy it to kernel_src/.config
make olddefconfig
make -jx bzImage           //x should equal or less than cpu num your pc has

Fill the bzImage file into above start3.sh to load the target kernel in vm.


Tips:
If you already have qemu-system-x86_64, please ignore below info.
If you want to install qemu v7.1.0 version:
git clone https://github.com/qemu/qemu.git
cd qemu
git checkout -f v7.1.0
mkdir build
cd build
yum install -y ninja-build.x86_64
../configure --target-list=x86_64-softmmu --enable-kvm --enable-vnc --enable-gtk --enable-sdl
make
make install

Thanks!
BR.
