Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4685C77B6E
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 07:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjDLHRI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 03:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjDLHRH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2023 03:17:07 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C874D2708
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 00:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681283825; x=1712819825;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=d66Tff/vvtEn8+q1rX93RF/qu6NZ6zVcyZUsVIjCuKg=;
  b=kHwYBSY1hH6rf/v3CExykslPGX9/O9LHndyaK1Tp8n2wMcrseEFQjNDy
   yX+F/2K+OpNzkR5WQWa4OEfIUEa7tuAnTNMSMZHEnmEnxIOjOB0N+nudw
   zDfrnS3fTipjiyHt3jFAyHS2gz5rpTuf1XT+8CmrGtOqSee13O8n30P31
   1I7unDwZ183mf8Bvj9Y7qJAyfWrMM+ri3hiwasRgm2zYQG3RdlDx+9JTN
   JtwhHs2vNHyvW67lePXXOXJ9hXpuhEhWDTErRhkXSkr7S3WNlsS1uShXU
   tApaCVgycTwPXlZ3sZx6pCPIOO8wyDs4pr75WaCMUqdteteAE0/Y2UXrK
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="342578586"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="342578586"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 00:17:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="935023963"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="935023963"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 12 Apr 2023 00:17:05 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 00:17:05 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 00:17:04 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 00:17:04 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 00:17:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lQ05a7qWG46lQCUviJavJaO8yP2DwTZTuZqjnef1IMsN2MtzvmgD6r2XhzeezCXLUOvt8QC0p9mtu1lCU3yMxm2dFBsbf4/CT0JNbAlVLmYFLEJbF3UQ6ihdT4ZOJrViEHctZdrrPZwy0dPPuV3J+t1TA9QhkFiWfZ5zXVfjwwFdniIatcF/Fu+Cf2/dl+D2EY5Pv6faRm1r6iYOLyO7L2lYsuUhv53BpC14jHnn03S2bPXoC7TnmBQhc7QG/PSgK9dWPQ99TGQVMbaKhjrARYwvgtEEI1UtoJSMPr0AwAsgfVnmnR3k6U8nwx+EuoNMW4SraJ6YQ1o8Ma4XlNDBVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A4FNRpbkAvZn8jph8VpbGtq5dOJB07TjlXZlWMKAPLU=;
 b=XEwGpQLNsi1gniTMjYkJvnK677pq8IjIsDdmJttRlQhSTdbKE8hUzbrSoi1FkDcQz+PhaZ/ztn2YK/FuD0SIBw3GFtg+Hc2/DfYVr+kFTlWl/nnCCyDSerEX4ZFplZYjKl5GSzE/GephR5ZgGwuX81OmlHnsTUynrQAqrhtGezjVOJb1dQ2QPCr7Os17yP90Ug0q5fD0J6cFXGoPI2xuiSl9yNTwhes+ehSl9v8Ou3bFstNRg2Io4+myJ+Y2yn1mojOSPTeYdh0X6J7APXLXT+0Jvu6dF198t0Qx+qFUznCQaBcC1F/ogbTe2DkHSpnpfL5sxAwytl1zY8CKpWsb4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA2PR11MB4844.namprd11.prod.outlook.com (2603:10b6:806:f9::6)
 by PH0PR11MB5174.namprd11.prod.outlook.com (2603:10b6:510:3b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 07:17:02 +0000
Received: from SA2PR11MB4844.namprd11.prod.outlook.com
 ([fe80::9bec:338e:49fb:54cf]) by SA2PR11MB4844.namprd11.prod.outlook.com
 ([fe80::9bec:338e:49fb:54cf%6]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 07:16:59 +0000
Date:   Wed, 12 Apr 2023 15:18:38 +0800
From:   Pengfei Xu <pengfei.xu@intel.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     Dave Chinner <david@fromorbit.com>, <dchinner@redhat.com>,
        <linux-xfs@vger.kernel.org>, <heng.su@intel.com>, <lkp@intel.com>
Subject: Re: [Syzkaller & bisect] There is task hung in xlog_grant_head_check
 in v6.3-rc5
Message-ID: <ZDZbTjmO3WWPLRyd@xpf.sh.intel.com>
References: <ZC4vmjzuOEFQuD17@xpf.sh.intel.com>
 <20230411003353.GW3223426@dread.disaster.area>
 <ZDUXGKoMK6unNXYo@xpf.sh.intel.com>
 <20230411150336.GG360889@frogsfrogsfrogs>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230411150336.GG360889@frogsfrogsfrogs>
X-ClientProxiedBy: SG2PR02CA0123.apcprd02.prod.outlook.com
 (2603:1096:4:188::22) To SA2PR11MB4844.namprd11.prod.outlook.com
 (2603:10b6:806:f9::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR11MB4844:EE_|PH0PR11MB5174:EE_
X-MS-Office365-Filtering-Correlation-Id: c061c0e5-c5d7-4992-0973-08db3b25e771
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XtxYe4cmsg21GlIkM/X9t1mG7IHKe6FqYxhUwlelvb/wJhi7jSqK1OTCAIeLgFzuuFuXZ+Bb9jv5ji+cicCcr6dtTx4cGmURgHFbqugfeL40KehU2h2y38o0fL1lvk6XX0T+v+ajrG9pIr3rVw9ox7kFIA2wUel38//fYvKbPsKbuGwLJ1RLiNlWEXZMJfsk9k7WkVk7dkj5fVTbVXGRoOmy06B6/w/U3TkYfhwHTe7/LwWx6qczYeDEMLJL9bCyd0TpUd56mtQ6pSH9BOtHqJkt1RJmTTsYEI/p/Imit45s3XJCSqZAG9UTzkiKZ9NKxYDJ9CiC7XgKkrFWlrw/ZnNI4477vzLl9YRc8VBwlmLnAeDhxAXpS1bjm1YvlZgYHMI3IJ1j2/QcDpMtwMUAtw0iKuEjFR2OWEFPCQ2e6yEM2y6zRIW/vkD9ToLNtTQpYijJtMscUFoXbsOr+mHidYa8F1TuZUyYpt/YjU6P5gtAbqAZjU8c2FjdgVp0JuiWYfP6mlHsrI8y8zfQ/2wEQf2TlZz6fIg+EudIvFbR7j1/orGtHA0k6MLE1C4y/lwLK44yCICX5eq4gpnJv7XNfA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB4844.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(366004)(136003)(396003)(376002)(451199021)(6486002)(966005)(6506007)(26005)(6512007)(53546011)(316002)(2906002)(83380400001)(38100700002)(86362001)(186003)(6666004)(107886003)(41300700001)(66899021)(478600001)(66946007)(4326008)(66476007)(66556008)(6916009)(44832011)(8936002)(8676002)(5660300002)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s4DFIpAPsvj3R0brQgc/OyFQSm6mx6mHwnv4fTTwTYLVtHGplvJoo3AgIgKS?=
 =?us-ascii?Q?cbSCOlOaSitzH325pNpOmPSFwf9vtIOpLBaUI3BPzOCabMReIseNcDXRoU+3?=
 =?us-ascii?Q?2b/whOkERiUMqaRtrGI1tTsfzVqm4nf1MgHPgq/Wi2zj4a59ureMgjU4NQJd?=
 =?us-ascii?Q?JEAi8Q/89jpW37WRVC2iGbsqNE0VNyG0Z1K7v8JmI8cEJL1TJ/+uAK7+qtQO?=
 =?us-ascii?Q?AByykFvU+6clM31OiDoAufuhBR0kEURdP1iqjat59AitXryuApXMCKAvXgOT?=
 =?us-ascii?Q?DL4Zu4rTuQ8nko39B8ppAZzci5jnbOhGJ0ITCnGgASAvV54uZNLql/AusBKx?=
 =?us-ascii?Q?9+ecFtJXdWkrPkxnO8DSZakGMwWoK9pzqBeVW1XQkR6u9fPQ8m0ay5GPY8ov?=
 =?us-ascii?Q?zJ/ed6SeSTT9Us5m8mDpuqcwb1g7h5cVe8nxUP2SjqoVPWAKtt/IZfcmv/+i?=
 =?us-ascii?Q?Aj6Lne7jjsznUVUS+0Qre0BjrmR/B/LbJP6vbQCXLi3vgMJxbJUe4fMNIauY?=
 =?us-ascii?Q?2nDgpffq367kfL97zY7fYqgxpBtBnjo+NW1xCeImbMQxPddIjerS5LiZBo0f?=
 =?us-ascii?Q?3z22eUXI9M8zV1BmdcEWjdvqW4P4RUIiXdFal++H66VuKbUgRj6FnnnSFE/f?=
 =?us-ascii?Q?R9nWs7gIRPwmQe1oY+/5SFWscayigypMTuuRUXiCohkvKe7UypCcwH6XRwkZ?=
 =?us-ascii?Q?0IFGY/MDKTb5VYu75Cud2YU5nTNWlpQXJMlVLn6hbeJX2YMIamxoZzSxSjs3?=
 =?us-ascii?Q?bzOTvusY+HST1KhDiGFgkF7jmyEtgwMnrFMqpVJVoYYNMRBV/UdsL6r8Q8MI?=
 =?us-ascii?Q?B1EGQZJ5PN3X+RA4+ApkQszlCrfjRiskSMelfk71GskyX3xKbh+3zOJM1x1d?=
 =?us-ascii?Q?Emu9me/hrrG5LnNiE7PsxVfKeBCq2xpM3pQZzyfUrzcKowCoCpvqu6yUjR9i?=
 =?us-ascii?Q?SXHluFEw1BACCOfGwv2GzhwTot9H8Mz51zZ36SIUY3Z/p/Vro8SfS14F+rZk?=
 =?us-ascii?Q?6LWU1WhsTnQAyQ9vXMZrZg7FPXYT2AWlAIlGFOVDMvwT6wSAXbYJwrvJaEjb?=
 =?us-ascii?Q?QtZKrqz6YFSdJYlV5O5DFJNSIQSgYKLs5DEoRxQMKY65nNQ0YZ+ry4uFXMF1?=
 =?us-ascii?Q?PsMd2Iat64OLCVHMMKKwuMcwvG6Bm9Z2w0rYfUfOVOEDhZL/LdTrlWfbEpNt?=
 =?us-ascii?Q?0mHZVdFXci/+oBm5yR8K4NIPnGGhXGIlpidZdimBnNd+oZmGVwGfmUPCSJ52?=
 =?us-ascii?Q?qMyqzukGzT+BKuyCYv4goiNgdvpZ6kArVc9Uqlu4oRwfFGSMYw2No0qbeZiP?=
 =?us-ascii?Q?eRA+wRF1uwnDiO81JskjrS0cmPMLF/YHY7kvS3elreWm5KW03py4+D4mDItL?=
 =?us-ascii?Q?dAAf775h1xH06+XCFVzO/VCGaGmtgtHFloTKSKYxBoP9m/Oj9/G0erhP0PaY?=
 =?us-ascii?Q?LH0NR8id91KQpYeEH+dJp7+J7IbQ6ZN/9s6QiPjbQT/6KMIQZB2/9VTWYepg?=
 =?us-ascii?Q?t/Cqkdd7fNFor+8BYHLEHW11AjkluZorrU0tcG9O1JxNNa5v6JxwBz/BB9Pz?=
 =?us-ascii?Q?roYwba0GWYPnst2FugHmGimEobT3pixWk12ysBhZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c061c0e5-c5d7-4992-0973-08db3b25e771
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB4844.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 07:16:58.7768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iRbzdfUNTMfTEg5k5sykq/o4Jv+8u9jefe00KBKJ8842OGuRxrqQWhHBhcTBUVIdxyt7+0oGx8jqd6VcEq7UMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5174
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

On 2023-04-11 at 08:03:36 -0700, Darrick J. Wong wrote:
> On Tue, Apr 11, 2023 at 04:15:20PM +0800, Pengfei Xu wrote:
> > Hi Dave,
> > 
> > On 2023-04-11 at 10:33:53 +1000, Dave Chinner wrote:
> > > On Thu, Apr 06, 2023 at 10:34:02AM +0800, Pengfei Xu wrote:
> > > > Hi Dave Chinner and xfs experts,
> > > > 
> > > > Greeting!
> > > > 
> > > > There is task hung in xlog_grant_head_check in v6.3-rc5 kernel.
> > > > 
> > > > Platform: x86 platforms
> > > > 
> > > > All detailed info: https://github.com/xupengfe/syzkaller_logs/tree/main/230405_094839_xlog_grant_head_check
> > > > Syzkaller reproduced code: https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_grant_head_check/repro.c
> > > > Syzkaller analysis repro.report: https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_grant_head_check/repro.report
> > > > Syzkaller analysis repro.stats: https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_grant_head_check/repro.stats
> > > > Reproduced prog repro.prog: https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_grant_head_check/repro.prog
> > > > Kconfig: https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_grant_head_check/kconfig_origin
> > > > Bisect info: https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_grant_head_check/bisect_info.log
> > > > 
> > > > It could be reproduced in maximum 2100s.
> > > > Bisected and found bad commit was:
> > > > "
> > > > fe08cc5044486096bfb5ce9d3db4e915e53281ea
> > > > xfs: open code sb verifier feature checks
> > > > "
> > > > It's just the suspected commit, because reverted above commit on top of v6.3-rc5
> > > > kernel then made kernel failed, could not double confirm for the issue.
> > > > 
> > > > "
> > > > [   24.818100] memfd_create() without MFD_EXEC nor MFD_NOEXEC_SEAL, pid=339 'systemd'
> > > > [   28.230533] loop0: detected capacity change from 0 to 65536
> > > > [   28.232522] XFS (loop0): Deprecated V4 format (crc=0) will not be supported after September 2030.
> > > > [   28.233447] XFS (loop0): Mounting V10 Filesystem d28317a9-9e04-4f2a-be27-e55b4c413ff6
> > > 
> > > Yeah, there's the issue that the bisect found - has nothing to do
> > > with the log hang. fe08cc5044486 allowed filesystem versions > 5 to
> > > be mounted, prior to that it wasn't allowed. I think this was just a
> > > simple oversight.
> > > 
> > > Not a bit deal, everything is based on feature support checks and
> > > not version numbers, so it's not a critical issue.
> > > 
> > > Low severity, low priority, but something we should fix and push
> > > back to stable kernels sooner rather than later.
> > > 
> >   Ah, this issue was found from somewhere else, not the target place, and
> >   bisect is rewarding instead of wasting your time.
> >   It's great and lucky this time!  :)
> > 
> > 
> > > > [   28.234235] XFS (loop0): Log size 66 blocks too small, minimum size is 1968 blocks
> > > > [   28.234856] XFS (loop0): Log size out of supported range.
> > > > [   28.235289] XFS (loop0): Continuing onwards, but if log hangs are experienced then please report this message in the bug report.
> > > > [   28.239290] XFS (loop0): Starting recovery (logdev: internal)
> > > > [   28.240979] XFS (loop0): Ending recovery (logdev: internal)
> > > > [  300.150944] INFO: task repro:541 blocked for more than 147 seconds.
> > > > [  300.151523]       Not tainted 6.3.0-rc5-7e364e56293b+ #1
> > > > [  300.152102] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > > [  300.152716] task:repro           state:D stack:0     pid:541   ppid:540    flags:0x00004004
> > > > [  300.153373] Call Trace:
> > > > [  300.153580]  <TASK>
> > > > [  300.153765]  __schedule+0x40a/0xc30
> > > > [  300.154078]  schedule+0x5b/0xe0
> > > > [  300.154349]  xlog_grant_head_wait+0x53/0x3a0
> > > > [  300.154715]  xlog_grant_head_check+0x1a5/0x1c0
> > > > [  300.155113]  xfs_log_reserve+0x145/0x380
> > > > [  300.155442]  xfs_trans_reserve+0x226/0x270
> > > > [  300.155780]  xfs_trans_alloc+0x147/0x470
> > > > [  300.156112]  xfs_qm_qino_alloc+0xcf/0x510
> > > 
> > > This log hang is *not a bug*. It is -expected- given that syzbot is
> > > screwing around with fuzzed V4 filesystems. I almost just threw this
> > > report in the bin because I saw it was a V4 filesytsem being
> > > mounted.
> > > 
> > > That is, V5 filesystems will refuse to mount a filesystem with a log
> > > that is too small, completely avoiding this sort of hang caused by
> > > the log being way smaller than a transaction reservation (guaranteed
> > > hang). But we cannot do the same thing for V4 filesystems, because
> > > there were bugs in and inconsistencies between mkfs and the kernel
> > > over the minimum valid log size. Hence when we hit a V4 filesystem
> > > in that situation, we issue a warning and allow operation to
> > > continue because that's historical V4 filesystem behaviour.
> > > 
> > > This kernel issued the "log size too small" warning, and then there
> > > was a log space hang which is entirely predictable and not a kernel
> > > bug. syzbot is doing something stupid, syzbot needs to be taught not
> > > to do stupid things.
> > > 
> >  Thanks for pointing out this syzkaller issue, I will send the problem to
> >  syzkaller and related syzkaller author.
> 
> Don't bother, we already had this discussion *five years ago*:
> 
> https://lore.kernel.org/linux-xfs/20180523044742.GZ23861@dastard/
> 
> The same points there still apply -- we cannot break existing V4 users,
> the format is scheduled for removal, and it's *really unfair* for
> megacorporations like Intel and Google to dump zeroday reproducers onto
> public mailing lists expecting the maintainers will just magically come
> up with engineering resources to go fix all these corner cases.
> 
> Silicon Valley tech companies just laid off what, like 295,000
> programmers in the last 9 months?  Just think about what we could do if
> 1% of that went back to work fixing all the broken crap.
> 
> Hire a team to triage and fix the damn bugs or stop sending them.
> 
  Thanks for your info sharing for the issue history!
  I have sent one issue report to syzkaller before I received your email.
  Yes, we should not report useless report to Linux community.
  Thanks for suggestion!
  Anyway, we will carefully review reports of V4 filesystem issues before
  sending them to reduce useless report.

  Thanks!
  BR.
  -Pengfei(Intel)

> --D
> 
> >  Thanks again!
> >  BR.
> >  -Pengfei
> > 
> > > -Dave.
> > > -- 
> > > Dave Chinner
> > > david@fromorbit.com
