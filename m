Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF7DEC76196
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 08:14:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbjDKIOS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 04:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjDKIOL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 04:14:11 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459AA3AB4
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 01:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681200829; x=1712736829;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=EmFbPlMmTDItvNDWQsEOytx9sCj9o5EbIDmEkIdAWFY=;
  b=i9TBKwRsyecmYFimwcbrzV310EHxSa5nMkswIt2NtbXJjiroSgIhQTV2
   ZGSCWv95cVVMan9dp7zDehE3CmQinG/EYfFO1ErrSycIqgzWUU7hts+SD
   Qahw/RClmEFt6tgAp4TOWl01qRbs4i8/w+Kz8KgzVxnBjm5t+D0OUHTYk
   bHTTorTIBelbkDj8CF+ok1gn9/mQZQLQ6V+ulcYLT5gwgWDI52C07vy0J
   Vz5RcDyROjPfldZxX5pJXttqRLk0w1saGT3XpaspfcUfTgTPomEfpVT3n
   PMXAlas1Zra3wIsYc46OiiDn33hc3saQhqKrQcq1YdWwfXAIUI15oHr6e
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="346226102"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="346226102"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 01:13:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="934632023"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="934632023"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 11 Apr 2023 01:13:48 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 01:13:47 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 01:13:47 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 01:13:47 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 11 Apr 2023 01:13:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jHp4sr6VIVyMB+O8xPEvBO36ZEdLInloVpy+ix5adOz1Yz8Ad+xcZY1AeM3A8cZ4VbCxYxs4MtYsNuAInIwQ8bBycKN+1YRMcF1hIY5HH0zz8BTg2r5vxvUtZRI+cVrcvAF1nx6h1wZCtFkCuotdwVdUvrGBqbPOXpS4c0jtCdANh+cn6uzTn/XWcXrO4Vp/hjJoCd8Z8ykNanr/8OC516DgLfubTiV/2u2BtA+rUSzuUyTf+Mbk1r3u31VgihPCax7jhIp1M5h9j/o0aV/ZNiLvec4sw5Em681Be1C7ZVSXCK0BgJfE+EeeFxCwdhDiWKD9qGWoJVKJVj6c6uAaLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ops7L0IBO98jEb/y4/O0GVvoKAWlTjlq4WL3oSZf7Hs=;
 b=Tc88xXy4i4qLsZcfY0f9mAVlDJC7kl2JDO82LHGXc5pFgMS9/DUnHpMauHXogyJsKOPzf7BmXuuUPDG9OUiGLEGWTt3omjAosQ4DK4bFIa4Tbfwwd8/jQ2CujYNUZkQVMxIyKfc83ZA4TSSp3LiNDjW86gfpSihrLZV16nnDUc/+O+0kQi8BGoXft17m0EX4CT8xPLcxoc2AtI9noRVZtJUVLKXEEZ2oCMHrJ42MiCFsuaZAMLlhGsBc+tSQQ7qz40O9KetXxdjV6J/DYcrU8SPI+2GBYk7nEQkBKlOVFT/o/z+kQiRG0iIGEAErBylHal9VP19Jd8vbb4cbYZ6uiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4839.namprd11.prod.outlook.com (2603:10b6:510:42::18)
 by CY8PR11MB7084.namprd11.prod.outlook.com (2603:10b6:930:50::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 08:13:45 +0000
Received: from PH0PR11MB4839.namprd11.prod.outlook.com
 ([fe80::60e0:f0a8:dd17:88ab]) by PH0PR11MB4839.namprd11.prod.outlook.com
 ([fe80::60e0:f0a8:dd17:88ab%8]) with mapi id 15.20.6277.035; Tue, 11 Apr 2023
 08:13:45 +0000
Date:   Tue, 11 Apr 2023 16:15:20 +0800
From:   Pengfei Xu <pengfei.xu@intel.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     <dchinner@redhat.com>, <linux-xfs@vger.kernel.org>,
        <djwong@kernel.org>, <heng.su@intel.com>, <lkp@intel.com>
Subject: Re: [Syzkaller & bisect] There is task hung in xlog_grant_head_check
 in v6.3-rc5
Message-ID: <ZDUXGKoMK6unNXYo@xpf.sh.intel.com>
References: <ZC4vmjzuOEFQuD17@xpf.sh.intel.com>
 <20230411003353.GW3223426@dread.disaster.area>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230411003353.GW3223426@dread.disaster.area>
X-ClientProxiedBy: SG2PR02CA0130.apcprd02.prod.outlook.com
 (2603:1096:4:188::8) To PH0PR11MB4839.namprd11.prod.outlook.com
 (2603:10b6:510:42::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4839:EE_|CY8PR11MB7084:EE_
X-MS-Office365-Filtering-Correlation-Id: c52b09a2-9934-4e54-5417-08db3a64ab35
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CqMOXmHVSjmYa0Oa52y2m+LlzMpldVANdINiYAazuTNRQzVR0SwId606QD7v+UXMw7fPjGKwn79WM6rBEfWyJwVZVx8lPyJbE8kez9yACau/Rz1ycU9bqthLRPd0Fhx1V//7GYKMTvHz+q/kjZFnqfrmnddkSh9oMRZY1DRFP7YjKKrNX4ah95OUhcxpG6RrvXoTfNwuFqJszg9YTzVLWae1LJts+KDGNiLDmx63EOASTBam61vHmAo80Ls7ATiB/yV99bLJcYUGrEWdaYPrlz0tELhfgnEn5uX9PA5wg/AqNco1pzw0MasPmI/igMZAJnWz6CDIovQ2faO6oCGWCTnz0f7SUv9fE+yo0VVBNwNOl3tiKXqyNMTd3TyBsRJQpv93zQX6eHXBFvgNxmlHQk5dAT4P+RgiDXKVcwL/nuj4xqA4OXB6stAOWTOiHFGYtGww1xF7anchOnICy0+KJ79VwvQ6MPuDvkhaz6tiliqM/AVVzyYUD0tMhW/12cQDrFOgEofK9FA2Q05FZz6aWxxekAnG+j4E9Wv+tohRX6qUErhEuVM/PIe0tcs+snu8Jfg7v64RbN/HWrEOr138AA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4839.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(376002)(136003)(39860400002)(346002)(451199021)(83380400001)(966005)(478600001)(6486002)(186003)(6666004)(316002)(26005)(6506007)(6512007)(53546011)(107886003)(2906002)(44832011)(5660300002)(38100700002)(4326008)(66476007)(6916009)(82960400001)(66556008)(8936002)(41300700001)(66946007)(8676002)(86362001)(66899021);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?skTwxhhs4yxvPEJflv/5DSEunUPugvnvmT+uuaoEoYShd1mj8gvp2jPYdWG2?=
 =?us-ascii?Q?X9MGTvMUECA1y/8C+G6UedtiFJzsizVlD997GHPNZeNlxNKWHpI7/S6VMGTL?=
 =?us-ascii?Q?py1N/5zFIZoux6MWOJExHy7w3aqRvurkxNsOQGu4qsOW4cy1dse6Hu1K5ePU?=
 =?us-ascii?Q?bTxpA6+I94ICPP8tLsxSydKKWEEJxWD9TCWK2Qr5ag9Vc2lZpZnns6QRD5Ac?=
 =?us-ascii?Q?TKlePiUzCMskm1nyPgwC+ics22T2XPk83Ie+qYCtAVMDda0d5Q8I0QGN8les?=
 =?us-ascii?Q?GNCQNN63qdgna8i5xFbzOkcyLDsbHUUQ17tGBsG+8dK7qoLuioaetlH6K3Jd?=
 =?us-ascii?Q?9YYHXd3MdkiyE1lZvnGOzAHh/zIElnGcKgrWQSk93a29CQF7BR1etvbWXXQA?=
 =?us-ascii?Q?Ix6D1VEgClWwvGexy/DN5XNqWM2P6nDSZX91b0BeGyol5PklhbJDPvUaVqB6?=
 =?us-ascii?Q?cedRREcy0twhsDBigtG4uKcL4bh6wQVXtRs2Sps5fNuN0zW0RRbWdNwRjFyl?=
 =?us-ascii?Q?j/bdrKsbd9U81A6dfyqxFyAkmRtWR0sYGTFzxQvqUORbWzVq3JSWUHiUw57Z?=
 =?us-ascii?Q?vmDQdz4Qg/A1ZYtNppUrYhSqui5cwBHu73L49W01c8RVAbd6nzNWUqTwHbNY?=
 =?us-ascii?Q?PwxfAw8aM2VRBGIj59aT8cGVnT1mZFcvEizU5KSJFzUvISH+E3ckEjlPWlU4?=
 =?us-ascii?Q?VuHOl/E7X5YLafxqqAr6IoX1EVygDUIesEJ+SP27XdlSygNLNZd/BCVTadBl?=
 =?us-ascii?Q?9FVerDk3kQQi5jiFttzjALs+sHD20QhHiOMARJLqF2CFv2yGQl0yFJKR7xO+?=
 =?us-ascii?Q?2XdT4RMqY+I7QZMuBFht9TRC/GVqT7tcSR1FQ93OW8ypq1whv+RHrDlEL1DY?=
 =?us-ascii?Q?XNjDuZYsLcm6TBXSDhAWiXfIgYKdrWsNyv2KUGnlenKtca68tw6Jyx9TJDA3?=
 =?us-ascii?Q?I7M95TVr+tkysxmhD0wNEVoksu10kffD6ttfFrF4hNjcrULjdxeOzkJPPLd3?=
 =?us-ascii?Q?ImTouKhrEWEpqTdHUIRWPPYE6GBdE25k9GCTznzvc97NPiXjQ/hdihe1kOGU?=
 =?us-ascii?Q?KyRYEGN6JGy9zFQtkK/ZY5NC6uYv5RSaf0DhHTmq6+PJ4FWTiqaHIpQM79CN?=
 =?us-ascii?Q?DAmerPw36p21LppBR7SHT8EqmuOVIyharqiS2wl2IYLVPdr+QOoq3l6HnAr5?=
 =?us-ascii?Q?EnToXJoGGBzx6X5yaFy5HOVGYEzqFuiQv9Tdy6tdnyeQaCXRBYQxAdsCn7o1?=
 =?us-ascii?Q?Cu8lkeZP6IYvEICSc2sdvyQQJELDFcrV+WPLW+8scmvBeVxs5I8Kmx1p23wK?=
 =?us-ascii?Q?4t/4cmBjVXqiJg4kAsPnqVRWSHuCMWcjfXB4bRN/qESi+tWgJ1B6A18/FhmP?=
 =?us-ascii?Q?L+Kq8Hm5vXE3IznuAhlgfQ4l3Lwdp7mgCFYSiYKJkZRf7iIyJfnC8v8dFL20?=
 =?us-ascii?Q?BC85/Sqjb5nD3KTOKxfckUtrZ8rb+UgThqCuEGbS4r6dH51RIt/s5iBpH37C?=
 =?us-ascii?Q?o7/7H0UESAMJb44WT+YjJqe2IJwDhOZ9KDQqormmRXyz8rUes9bSE7pJ2RW8?=
 =?us-ascii?Q?znYnoLE9VkSt61T1D2SN+CSsy2S3c/q9U/jTLkqC?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c52b09a2-9934-4e54-5417-08db3a64ab35
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4839.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 08:13:44.8664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NbJ3OrNs9EbqRZif1wd+EfwX06lKQf1aZzT9HDdjIAX3LR2tmFLnA0aGnHg6yPodhl7/gLXVccIOoAYTfWtDLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7084
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

On 2023-04-11 at 10:33:53 +1000, Dave Chinner wrote:
> On Thu, Apr 06, 2023 at 10:34:02AM +0800, Pengfei Xu wrote:
> > Hi Dave Chinner and xfs experts,
> > 
> > Greeting!
> > 
> > There is task hung in xlog_grant_head_check in v6.3-rc5 kernel.
> > 
> > Platform: x86 platforms
> > 
> > All detailed info: https://github.com/xupengfe/syzkaller_logs/tree/main/230405_094839_xlog_grant_head_check
> > Syzkaller reproduced code: https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_grant_head_check/repro.c
> > Syzkaller analysis repro.report: https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_grant_head_check/repro.report
> > Syzkaller analysis repro.stats: https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_grant_head_check/repro.stats
> > Reproduced prog repro.prog: https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_grant_head_check/repro.prog
> > Kconfig: https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_grant_head_check/kconfig_origin
> > Bisect info: https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_grant_head_check/bisect_info.log
> > 
> > It could be reproduced in maximum 2100s.
> > Bisected and found bad commit was:
> > "
> > fe08cc5044486096bfb5ce9d3db4e915e53281ea
> > xfs: open code sb verifier feature checks
> > "
> > It's just the suspected commit, because reverted above commit on top of v6.3-rc5
> > kernel then made kernel failed, could not double confirm for the issue.
> > 
> > "
> > [   24.818100] memfd_create() without MFD_EXEC nor MFD_NOEXEC_SEAL, pid=339 'systemd'
> > [   28.230533] loop0: detected capacity change from 0 to 65536
> > [   28.232522] XFS (loop0): Deprecated V4 format (crc=0) will not be supported after September 2030.
> > [   28.233447] XFS (loop0): Mounting V10 Filesystem d28317a9-9e04-4f2a-be27-e55b4c413ff6
> 
> Yeah, there's the issue that the bisect found - has nothing to do
> with the log hang. fe08cc5044486 allowed filesystem versions > 5 to
> be mounted, prior to that it wasn't allowed. I think this was just a
> simple oversight.
> 
> Not a bit deal, everything is based on feature support checks and
> not version numbers, so it's not a critical issue.
> 
> Low severity, low priority, but something we should fix and push
> back to stable kernels sooner rather than later.
> 
  Ah, this issue was found from somewhere else, not the target place, and
  bisect is rewarding instead of wasting your time.
  It's great and lucky this time!  :)


> > [   28.234235] XFS (loop0): Log size 66 blocks too small, minimum size is 1968 blocks
> > [   28.234856] XFS (loop0): Log size out of supported range.
> > [   28.235289] XFS (loop0): Continuing onwards, but if log hangs are experienced then please report this message in the bug report.
> > [   28.239290] XFS (loop0): Starting recovery (logdev: internal)
> > [   28.240979] XFS (loop0): Ending recovery (logdev: internal)
> > [  300.150944] INFO: task repro:541 blocked for more than 147 seconds.
> > [  300.151523]       Not tainted 6.3.0-rc5-7e364e56293b+ #1
> > [  300.152102] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  300.152716] task:repro           state:D stack:0     pid:541   ppid:540    flags:0x00004004
> > [  300.153373] Call Trace:
> > [  300.153580]  <TASK>
> > [  300.153765]  __schedule+0x40a/0xc30
> > [  300.154078]  schedule+0x5b/0xe0
> > [  300.154349]  xlog_grant_head_wait+0x53/0x3a0
> > [  300.154715]  xlog_grant_head_check+0x1a5/0x1c0
> > [  300.155113]  xfs_log_reserve+0x145/0x380
> > [  300.155442]  xfs_trans_reserve+0x226/0x270
> > [  300.155780]  xfs_trans_alloc+0x147/0x470
> > [  300.156112]  xfs_qm_qino_alloc+0xcf/0x510
> 
> This log hang is *not a bug*. It is -expected- given that syzbot is
> screwing around with fuzzed V4 filesystems. I almost just threw this
> report in the bin because I saw it was a V4 filesytsem being
> mounted.
> 
> That is, V5 filesystems will refuse to mount a filesystem with a log
> that is too small, completely avoiding this sort of hang caused by
> the log being way smaller than a transaction reservation (guaranteed
> hang). But we cannot do the same thing for V4 filesystems, because
> there were bugs in and inconsistencies between mkfs and the kernel
> over the minimum valid log size. Hence when we hit a V4 filesystem
> in that situation, we issue a warning and allow operation to
> continue because that's historical V4 filesystem behaviour.
> 
> This kernel issued the "log size too small" warning, and then there
> was a log space hang which is entirely predictable and not a kernel
> bug. syzbot is doing something stupid, syzbot needs to be taught not
> to do stupid things.
> 
 Thanks for pointing out this syzkaller issue, I will send the problem to
 syzkaller and related syzkaller author.

 Thanks again!
 BR.
 -Pengfei

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
