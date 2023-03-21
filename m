Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 170CEC6FD1D
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Mar 2023 06:15:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjCUGPQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Mar 2023 02:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbjCUGPP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Mar 2023 02:15:15 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D982D5D
        for <linux-xfs@vger.kernel.org>; Mon, 20 Mar 2023 23:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679379313; x=1710915313;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Xe4xfU0hxstTdtyo4Vy4aV9EI95eabxO68fEXxJHrJE=;
  b=inRJxgkRStc7Mrw9KYcHdLRqqFT0H3sRIdRO3hSFC+IKY1b8N1VuxD31
   yQ1JhgwSZX+ndRoX6V0FY3pOkeLpwuCN+BETrUs+BXp12VKMpleUJ0xa2
   hB9m9/u7tQIEjURRgJ7CKMQ0Ya8H17DS+Q3785/0tRZjZD71thkp3X9EY
   W9nF7x7rfGhgeX66RSKrQHW5mJqI16lb1P03ESz0vlSqoxo330N4pU1MK
   vAVVVHwHTgqIHk68yyTFAkvByRXGBYvoA4Me4uoqotpnJpUcpRWamZvn/
   NyqVbUw22aUsl8bSGaRdgpac9TWoCWtRTwbn3Cf64wIYrgSVtQTjEI0cw
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="322699108"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="322699108"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 23:15:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="674699405"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="674699405"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 20 Mar 2023 23:15:07 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 23:15:07 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 23:15:06 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 20 Mar 2023 23:15:06 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 20 Mar 2023 23:15:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eH5lNpAGTmHgbrr8ZCqjNP7kWSsot0Jo03J8VVlJbQYhlpvLyd3N0O+JzijrIH1cnB18X52RE9MzcWwu8+rr2T4uwNY8VLjeraTjRUJCNtOryLQezsBXXhDF6K52xQKgxrjU5V1dTL+kx8KJ6whOepI3/MI4ApQfAyWne7lBG5LsG8D98Rul4szIJFVRrqz6k42IzNb60YuTkHYuDQuAv6K/fLlOlRs/uJBu5Bd533acxYutYyPc7C/OW/5vpjcSiKLNPSBDyhuwyFeLLsq/rO4u2L550+s7EzK0sTXXGSuVRXzVM3TcMvdQKVFFOR4yBeW8k2YQhyLV7oVv8YWf/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pLJZx6VTPSQrzHo7A/Mpyfx3B0Ow54+gcPrS4TKlkvU=;
 b=CwAlwc8ntl14UpU6o/H3Q1XlkYv94bM0s02Ca4koj32gDWychXPSASySILoydRqDot1PrZ8CeuJtboOxuyNYZQy4l5TTFPVDXuajbnvuDG36hhDJ0y1qaDT4gqa91p1RVabqoJkVIxWOS/JswannJ4YeUSEv7DAChzxmPYK/Is2UgOgY4njbjOdZG9WB3EjFc066JnBV3ja29RJ7v/gqB78rffVV8XRvWQd8H/bAOfYUO6648HXl485lageLGbn8Z64jHl0GwVmvnB51sYyIaGKz1Aa0+KTOjXBXDRFeqSVQoNPQWrI0Fdecy3YvfR1N6v5c2pDX9+pXO7w8vhXxsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4839.namprd11.prod.outlook.com (2603:10b6:510:42::18)
 by SJ0PR11MB5646.namprd11.prod.outlook.com (2603:10b6:a03:303::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 06:15:05 +0000
Received: from PH0PR11MB4839.namprd11.prod.outlook.com
 ([fe80::7369:ca71:6d2e:b239]) by PH0PR11MB4839.namprd11.prod.outlook.com
 ([fe80::7369:ca71:6d2e:b239%8]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 06:15:04 +0000
Date:   Tue, 21 Mar 2023 14:16:29 +0800
From:   Pengfei Xu <pengfei.xu@intel.com>
To:     <djwong@kernel.org>
CC:     <chandan.babu@oracle.com>, <dchinner@redhat.com>,
        <heng.su@intel.com>, <linux-xfs@vger.kernel.org>, <lkp@intel.com>
Subject: [Syzkaller & bisect] There is "xfs_btree_lookup_get_block" general
 protection BUG in v6.3-rc3 kernel
Message-ID: <ZBlLvZlKauGmNUOW@xpf.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SG2P153CA0040.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::9)
 To PH0PR11MB4839.namprd11.prod.outlook.com (2603:10b6:510:42::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4839:EE_|SJ0PR11MB5646:EE_
X-MS-Office365-Filtering-Correlation-Id: d4bd9036-3eac-43e2-95ba-08db29d39c9c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 15DjELJasyQksaIR+lQO+BLBEbe7tYQkEQPZqIGC8+JbxtazHyHSvtdPhXlvnhMRoPZrfQGdwIzFvx9dX/Kw4wIfOYoFESIn9oCXAWi3BQU/pfUptz2NMMpuPN6igD9gLYKpWOxZgEzW5a3FtmYsyl1jK2Uo2lApaZzQyjUg48gVijrji44QmrDN04AdtcGHsaoPu1ceWyIKk80We7Gl/b9hYk03sIjELQKA1kaGfTtGXNWtlgZN1jVkS13SWa1bEtVUZLQpXeyefcHt7dvbrJ4JheV2ECeJizw5oTbAJsGuQLfytiJd++Nv55R/eH5s9u4/BHQ+wDK7gVrnuLZ4vOKQOEua+6NsD+M09uJS2zniyLI/xMd9BUySj+KCIWyD4hxLUC7qnKbP5LY9ec/0Jm8MDXUXx0VI3wL9VzcaStgcawFKrjwei7maU0yxZYSYbKusVjQJpAJKCK6K1h9Tab7vVFjLjATpS8dSxJaZjgoLsEZAfAVNcYyi+FEtmZvVyzV5prKAndICpVgvVKfSgvm+pcY6te3THlvI+9R5ivabx4jA61xPx7ow+ZLzTIqF75d1nw9L3gWdwEd2F/KqT6T5j3Ixp88dKwokUD93gXsCHf50r12sDOMjT0HlCFvdIu5Yd//GwOhMJEM6GLWTwkHEBvayVX7rSfxQQH/dBc4KtRZFxaskDYjXnDbTeKHtNwgb3Heh6wWP/jWUeeg0nVbjPXtoJd0Tb2yTUjs8Uof2Nb3/bbVOE/cmp7GAxgja
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4839.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(136003)(366004)(396003)(346002)(451199018)(38100700002)(86362001)(316002)(30864003)(44832011)(8676002)(66476007)(66946007)(66556008)(5660300002)(6916009)(8936002)(4326008)(41300700001)(83380400001)(478600001)(2906002)(45080400002)(82960400001)(6666004)(107886003)(6506007)(186003)(26005)(6512007)(966005)(6486002)(99710200001)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6ISLaYuDHpnSJ/XcQNVdaVzZ7i4RC5m4OCU2Qp7wNNGe/VJx/US1zluzHwFA?=
 =?us-ascii?Q?r0267pOhoiSRtpT2mbPmwlXy2N7WHPZxD/VhjuG+deFYuDGcM38LfthAceu3?=
 =?us-ascii?Q?4u5csJN+N1f3bQlrSzFvpoyXESORa0Fienn0kp4YRHkJu2Jn0pZRCXc/RrW0?=
 =?us-ascii?Q?9F/P1egwp64Ynv4GV9L1/lWoZc7GjoFDleSBPpZvpOuS/MOOx/XnXDp18ihS?=
 =?us-ascii?Q?dimqqfiGil+0AEk3XX86yZ5dfsvK95tZ3CpjuENRrBedwmneFomW26haJ0Kb?=
 =?us-ascii?Q?zK7DqMb0FM9RRZ2SSolwKMMEok4EkKwJoAglxhcevTgaEDQkoN+Pf8ztYTt4?=
 =?us-ascii?Q?FB3W2OnfmrBHtYi9+8BP1zU3TBt+czEVf60CLNmnTC9Q5JXM58lKOcIlUwgo?=
 =?us-ascii?Q?n4uljrJ7aCo6kfQH2eZ/0c96OQXeRHJn8q6x7DpN4XEa3sK55XIJZ3/MWaCw?=
 =?us-ascii?Q?jh4wRU/UZxrhKs/WFNlyy//XVToajYVlauQapZAIv6CjzQMwRfTOIolQNacs?=
 =?us-ascii?Q?4L/KvOdACdtlixJEjord62ZsO9aG+6UiZzFcVJJx3DpG/CtKik4+InMpZAB2?=
 =?us-ascii?Q?Tia36gOtkBswMWS9NUFuORq6gBP9DZm2uCiHwYMR81XMtDFk5qZ9V0yeY0YH?=
 =?us-ascii?Q?h/UrQz5HucjiFQd8Ayf77kEoD7CPxOuO/BVe9o6vEZePD8xY7Vv1wHAmH07J?=
 =?us-ascii?Q?SPfYgWJEDTmDGMh2Vc+Zl2xMmJeLIoU6kDeBzruuUTz14TxAXpUu7k2b3wWJ?=
 =?us-ascii?Q?Z7/S3s8AwHV0L409jPg+Tnu5S360ZT6vGs7yy/5XUXyzxHgO0tA8dqnT71mp?=
 =?us-ascii?Q?wUhbgNWm9sTD59i+AG0eVyv9HwUGGFTorLX79z1mPMolYuZbdlOJ11/6XxUG?=
 =?us-ascii?Q?9E2FsFU1i0p5cQ1brLcVwMcNFh79VYvAdobz2ycEaGvy0ykVNiDo/GScxXDH?=
 =?us-ascii?Q?t9CaXaxJT3YfNSGVztXAZH5zVbbNWwiC5/EQVheLWn4Lb3b4QBBO94cRZ86e?=
 =?us-ascii?Q?BW8DeEWHUnUAfSU+aPXHsubvUHwBu+Ng6K7an97mTF5QmbwECI/TwgjnYO5j?=
 =?us-ascii?Q?BiixGKJgEvIDFXm+f78FbBBQifrLhvZwQBKN+gqyAMwe26DjAN1BfoVWPeW0?=
 =?us-ascii?Q?monYdmOJPDl19HJe3O0XCbYxVARFTTufrqXOXP1p/D9nA2FtQm5+Rjvi8b9q?=
 =?us-ascii?Q?RxhuNTpkcy9JNRbVw/ocBNl9kj/+bzXLku8fmdO0Vh+RkZ+ez3gjK6QmjV7b?=
 =?us-ascii?Q?La0kxSeIGAl2T+XbVYvmkjQA2cwzZ3/f1KMNZepuJAmTUCnWnJQe4BQlxKAp?=
 =?us-ascii?Q?4JFLd0xH9ETdKG1A+/Siiq5FKMvme7AlLcGanrw79yNTg6piMYRdhJ4p/KHr?=
 =?us-ascii?Q?CjWG5TAVVyRVHU37tnRD0S6GRqvCENIy0AleAX2CHC7oEDtTFvMt0yseERFO?=
 =?us-ascii?Q?FevYZgVZDZcX/JJiuxWGNZFx9Xg0itelOE17qlpRvXDj4NxuhvJWIqRBZDre?=
 =?us-ascii?Q?Ra8THzCzds6WGVg2Biw04+AzsE0iRV3P6+v5k4KpZ8pDwdcl6dGu7ZX2smjb?=
 =?us-ascii?Q?AkHecEvZB0ag/VNSofRAku41iQdJIqfAWJbJ0f9CuVwEAptcMFRs9hKmltPw?=
 =?us-ascii?Q?7A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d4bd9036-3eac-43e2-95ba-08db29d39c9c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4839.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 06:15:04.7121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +pqvJksSKKVpwFii/RB0Pf1HKSrdMI+61p9YIQtiFaeVuRcA2dM672/18PzoOJ7SDIBYG/8j+kbEDX34vTcrUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5646
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick J. Wong and xfs experts,

Greeting!

Platform: x86 platforms
There is "xfs_btree_lookup_get_block" general protection BUG in v6.3-rc3 kernel.

All detailed info: https://github.com/xupengfe/syzkaller_logs/tree/main/230321_082343_xfs_btree_lookup_get_block
Reproduced code: https://github.com/xupengfe/syzkaller_logs/blob/main/230321_082343_xfs_btree_lookup_get_block/repro.c
Kconfig: https://github.com/xupengfe/syzkaller_logs/blob/main/230321_082343_xfs_btree_lookup_get_block/kconfig_origin
v6.3-rc3 issue log: https://github.com/xupengfe/syzkaller_logs/blob/main/230321_082343_xfs_btree_lookup_get_block/e8d018dd0257f744ca50a729e3d042cf2ec9da65_dmesg.log
Bisect info: https://github.com/xupengfe/syzkaller_logs/blob/main/230321_082343_xfs_btree_lookup_get_block/bisect_info.log

Bisected and found the bad commit:
"
7993f1a431bc5271369d359941485a9340658ac3
xfs: only run COW extent recovery when there are no live extents
"
It's just suspected commit, because reverted the above commit on top of
v6.3-rc3 and made kernel failed, could not double confirm for this issue's
verification with reverted kernel.

"
[   29.020016] XFS (loop3): Error -5 reserving per-AG metadata reserve pool.
[   29.022919] BUG: kernel NULL pointer dereference, address: 000000000000022b
[   29.023777] #PF: supervisor read access in kernel mode
[   29.024413] #PF: error_code(0x0000) - not-present page
[   29.025081] PGD 12947067 P4D 12947067 PUD 12976067 PMD 0
[   29.025825] Oops: 0000 [#1] PREEMPT SMP NOPTI
[   29.026465] CPU: 0 PID: 544 Comm: repro Not tainted 6.3.0-rc3-e8d018dd0257+ #1
[   29.026826] XFS (loop5): Starting recovery (logdev: internal)
[   29.027468] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
[   29.029009] XFS (loop5): Metadata corruption detected at xfs_btree_lookup_get_block+0x27a/0x300, xfs_refcountbt block 0x28
[   29.029843] RIP: 0010:xfs_btree_lookup_get_block+0xc4/0x300
[   29.031365] XFS (loop5): Unmount and run xfs_repair
[   29.032089] Code: ff ff 31 ff 41 89 c7 89 c6 e8 48 3d 8a ff 45 85 ff 0f 85 1d 01 00 00 e8 5a 3b 8a ff 4c 8b 75 c0 4d 85 f6 74 37 e8 4c 3b 8a ff <49> 8b 96 28 02 00 00 48 8b 4d c8 48 8b 12 48 89 cf 48 89 4d b0 48
[   29.032779] XFS (loop5): Failed to recover leftover CoW staging extents, err -117.
[   29.035256] RSP: 0018:ffffc9000108b910 EFLAGS: 00010246
[   29.035267] RAX: 0000000000000000 RBX: ffff888013f10000 RCX: ffffffff81a32768
[   29.036298] XFS (loop5): Filesystem has been shut down due to log error (0x2).
[   29.037030] RDX: 0000000000000000 RSI: ffff888013eba340 RDI: 0000000000000002
[   29.037994] XFS (loop5): Please unmount the filesystem and rectify the problem(s).
[   29.038973] RBP: ffffc9000108b968 R08: ffffc9000108bb88 R09: ffff888013f10000
[   29.038982] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000007
[   29.038989] R13: ffffc9000108b9a8 R14: 0000000000000003 R15: 0000000000000000
[   29.038997] FS:  00007f44ba73a740(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
[   29.041082] XFS (loop7): Starting recovery (logdev: internal)
[   29.041985] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   29.043907] XFS (loop7): Metadata corruption detected at xfs_btree_lookup_get_block+0x27a/0x300, xfs_refcountbt block 0x28
[   29.043955] CR2: 000000000000022b CR3: 000000000e56e003 CR4: 0000000000770ef0
[   29.045085] XFS (loop7): Unmount and run xfs_repair
[   29.045870] PKRU: 55555554
[   29.046689] XFS (loop7): Failed to recover leftover CoW staging extents, err -117.
[   29.048110] Call Trace:
[   29.049079] XFS (loop7): Filesystem has been shut down due to log error (0x2).
[   29.049753]  <TASK>
[   29.050160] XFS (loop7): Please unmount the filesystem and rectify the problem(s).
[   29.051195]  xfs_btree_lookup+0xfe/0x800
[   29.053556] XFS (loop1): Metadata corruption detected at xfs_btree_lookup_get_block+0x27a/0x300, xfs_refcountbt block 0x28
[   29.053882]  ? __this_cpu_preempt_check+0x20/0x30
[   29.054487] XFS (loop1): Unmount and run xfs_repair
[   29.055921]  ? __pfx_xfs_refcount_recover_extent+0x10/0x10
[   29.056575] XFS (loop1): Failed to recover leftover CoW staging extents, err -117.
[   29.057249]  ? __pfx_xfs_refcount_recover_extent+0x10/0x10
[   29.057993] XFS (loop1): Filesystem has been shut down due to log error (0x2).
[   29.059020]  xfs_btree_simple_query_range+0x54/0x280
[   29.059038]  ? write_comp_data+0x2f/0x90
[   29.059784] XFS (loop1): Please unmount the filesystem and rectify the problem(s).
[   29.060778]  ? __pfx_xfs_refcount_recover_extent+0x10/0x10
[   29.062080] XFS (loop4): Metadata corruption detected at xfs_btree_lookup_get_block+0x27a/0x300, xfs_refcountbt block 0x28
[   29.063021]  xfs_btree_query_range+0x18a/0x1a0
[   29.063773] XFS (loop4): Unmount and run xfs_repair
[   29.065266]  ? xfs_refcountbt_init_common+0x3b/0x90
[   29.065891] XFS (loop4): Failed to recover leftover CoW staging extents, err -117.
[   29.066560]  xfs_refcount_recover_cow_leftovers+0x18c/0x4a0
[   29.066583]  ? xfs_perag_grab+0x143/0x340
[   29.067266] XFS (loop4): Filesystem has been shut down due to log error (0x2).
[   29.068299]  xfs_reflink_recover_cow+0x79/0xf0
[   29.069063] XFS (loop4): Please unmount the filesystem and rectify the problem(s).
[   29.069623]  xlog_recover_finish+0x136/0x420
[   29.071179] XFS (loop7): Ending recovery (logdev: internal)
[   29.071227]  ? queue_delayed_work_on+0x9f/0xf0
[   29.072328] XFS (loop7): Error -5 reserving per-AG metadata reserve pool.
[   29.072876]  xfs_log_mount_finish+0x187/0x1d0
[   29.073692] XFS (loop1): Ending recovery (logdev: internal)
[   29.074252]  xfs_mountfs+0x76e/0xce0
[   29.074271]  xfs_fs_fill_super+0x7aa/0xdc0
[   29.075574] XFS (loop1): Error -5 reserving per-AG metadata reserve pool.
[   29.075809]  get_tree_bdev+0x24b/0x350
[   29.076634] XFS (loop5): Ending recovery (logdev: internal)
[   29.077084]  ? __pfx_xfs_fs_fill_super+0x10/0x10
[   29.077676] XFS (loop5): Error -5 reserving per-AG metadata reserve pool.
[   29.078560]  xfs_fs_get_tree+0x25/0x30
[   29.078581]  vfs_get_tree+0x3b/0x140
[   29.079464] XFS (loop4): Ending recovery (logdev: internal)
[   29.079871]  path_mount+0x769/0x10f0
[   29.080533] XFS (loop4): Error -5 reserving per-AG metadata reserve pool.
[   29.081442]  ? write_comp_data+0x2f/0x90
[   29.085330]  do_mount+0xaf/0xd0
[   29.085811] XFS (loop2): Starting recovery (logdev: internal)
[   29.085825]  __x64_sys_mount+0x14b/0x160
[   29.087213]  do_syscall_64+0x3b/0x90
[   29.087534] XFS (loop2): Metadata corruption detected at xfs_btree_lookup_get_block+0x27a/0x300, xfs_refcountbt block 0x28
[   29.087758]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[   29.089249] XFS (loop2): Unmount and run xfs_repair
[   29.089936] RIP: 0033:0x7f44ba8673ae
[   29.090639] XFS (loop2): Failed to recover leftover CoW staging extents, err -117.
[   29.091112] Code: 48 8b 0d f5 8a 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c2 8a 0c 00 f7 d8 64 89 01 48
[   29.092123] XFS (loop2): Filesystem has been shut down due to log error (0x2).
[   29.094617] RSP: 002b:00007fffeaff1b78 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
[   29.094632] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f44ba8673ae
[   29.094640] RDX: 0000000020009580 RSI: 00000000200095c0 RDI: 00007fffeaff1cb0
[   29.095630] XFS (loop2): Please unmount the filesystem and rectify the problem(s).
[   29.096664] RBP: 00007fffeaff1d40 R08: 00007fffeaff1bb0 R09: 0000000000000000
[   29.099193] XFS (loop2): Ending recovery (logdev: internal)
[   29.099660] R10: 0000000000000800 R11: 0000000000000206 R12: 0000000000401260
[   29.100702] XFS (loop2): Error -5 reserving per-AG metadata reserve pool.
[   29.101426] R13: 00007fffeaff1e80 R14: 0000000000000000 R15: 0000000000000000
[   29.104290]  </TASK>
[   29.104623] Modules linked in:
[   29.105081] CR2: 000000000000022b
[   29.105560] ---[ end trace 0000000000000000 ]---
[   29.106207] RIP: 0010:xfs_btree_lookup_get_block+0xc4/0x300
[   29.106985] Code: ff ff 31 ff 41 89 c7 89 c6 e8 48 3d 8a ff 45 85 ff 0f 85 1d 01 00 00 e8 5a 3b 8a ff 4c 8b 75 c0 4d 85 f6 74 37 e8 4c 3b 8a ff <49> 8b 96 28 02 00 00 48 8b 4d c8 48 8b 12 48 89 cf 48 89 4d b0 48
[   29.109472] RSP: 0018:ffffc9000108b910 EFLAGS: 00010246
[   29.110190] RAX: 0000000000000000 RBX: ffff888013f10000 RCX: ffffffff81a32768
[   29.111153] RDX: 0000000000000000 RSI: ffff888013eba340 RDI: 0000000000000002
[   29.112114] RBP: ffffc9000108b968 R08: ffffc9000108bb88 R09: ffff888013f10000
[   29.113072] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000007
[   29.114030] R13: ffffc9000108b9a8 R14: 0000000000000003 R15: 0000000000000000
[   29.114989] FS:  00007f44ba73a740(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
[   29.116069] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   29.116860] CR2: 000000000000022b CR3: 000000000e56e003 CR4: 0000000000770ef0
[   29.117831] PKRU: 55555554
[   29.118220] note: repro[544] exited with irqs disabled
[   29.452491] loop0: detected capacity change from 0 to 32768
"

I see this similar issue in syzbot link:
https://syzkaller.appspot.com/bug?id=e2907149c69cbccae0842eb502b8af4f6fac52a0
But it didn't provide the bisect commit info due to bisect failure.

I hope above info is helpful.

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
