Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9967B63A8
	for <linux-xfs@vger.kernel.org>; Wed, 27 Dec 2023 07:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ncs5P7ve"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703661007; x=1735197007;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=i22wec+Q6yDr2GwlJkJFYILTT0L0JlGq9PREs0wq3zw=;
  b=Ncs5P7ve2EldJEH/ZmHTH2o/49vkgDdxWrc+9NpZE1r6nNLfxE2AbK3k
   xO3PYzdZXhOK8EEhcMEWJy4MgBV8Qjd8KpRx6dJOfkwE2JKfxiazXNBGC
   eGGdhnQf0r62cWSXUmYLCrTB1Evl34vPsL/XXPgLupAdQtQhPF6GDa7VX
   kXIXTLpFPbmy4EQ+v7ds1Q21qaBFQlygXmmvf890cH7zdyfdVP0Q2nUh1
   HRRfvA2syBgLmWSrEIafzzrCzLeejmsfTNiA6N/98QAXZzNrnljmGfJmD
   7p6ittWjFN41otiTNN4K59/f2ivBmNWPkkuEjx5g8xjbaDXu1CJ7nbOke
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10935"; a="3507525"
X-IronPort-AV: E=Sophos;i="6.04,308,1695711600"; 
   d="scan'208";a="3507525"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Dec 2023 23:10:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10935"; a="844076556"
X-IronPort-AV: E=Sophos;i="6.04,308,1695711600"; 
   d="scan'208";a="844076556"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Dec 2023 23:09:11 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 26 Dec 2023 23:09:10 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 26 Dec 2023 23:09:10 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 26 Dec 2023 23:09:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cz81tTzmbNmrbjpf3Dyh89jbQLKrPhMO3kOMe+PqMaVhWdO1SKUMFhTA8n4c69RUAhPxk2Zpto9iU96hzrK1/2MuVm+hDd7LeAGWKRMgBbAP3QqgF2FvXipIqAd1qj/BmOk9RQ+cXEQXLy36WQ3DMNn7TlJ8FEAPJBQK5g7H0/9VBEI5EGJVeee4hcRz2XITDWSA2jAJPu9oN65A6Iw8J+vK4n1e89Q/a8auPfNkCusUZdo9izvulmbmYwBRiI57dS9jBxKSo/jhEkAltjsD9UCIS2AYwlRHGbNxV0Fc6Y7qB9vOZsmiPGGwfPoy1H5Y3a+fnU9XqjrufUj4ioS4KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=322D2LOaMVVZenqJaqunAkr3srt2hhABKLObdHD/1x4=;
 b=SY+rFUtFh9TVKK2JUqORi3YC6/8Fsx4sRP54N9Uw5EuYaIkgUzeGPzF1eZm2h7Ocnsex+TLM4nGOHMvpl06AffLFjZOM/y6bOV/4tKnq8a00zZ8OvypMbsSBcaoqjsTvWmp/yRv7yXSp1BcixDxNs3sslgDuWZFIzudQhhWP4ijDjm+IDu1T7AOpYI9KU1wIzd/qequjyjTYcXZ5Vk4Sz/ycd4vihRQPSLCAkWEuwSfUojMpztMUHbOVv3L4rB48oAiQOOtyrGLCgJG6wL+07688yCj9ZqumV7CL/szNifCKCYJgl4ya3/XsJYIeEzA8o09KB9Xe8xPKYQpUq+/UYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by IA0PR11MB7378.namprd11.prod.outlook.com (2603:10b6:208:432::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.28; Wed, 27 Dec
 2023 07:09:05 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::1236:9a2e:5acd:a7f]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::1236:9a2e:5acd:a7f%3]) with mapi id 15.20.7113.027; Wed, 27 Dec 2023
 07:09:05 +0000
Date: Wed, 27 Dec 2023 15:08:57 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Christoph Hellwig <hch@lst.de>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Linux Memory Management List
	<linux-mm@kvack.org>, Chandan Babu R <chandanbabu@kernel.org>, "Darrick J.
 Wong" <djwong@kernel.org>, <linux-xfs@vger.kernel.org>,
	<oliver.sang@intel.com>
Subject: [linux-next:master] [xfs]  7f2f7531e0:
 BUG:KASAN:slab-use-after-free_in_xfs_defer_finish_recovery
Message-ID: <202312271458.851834a0-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SI1PR02CA0017.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::10) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|IA0PR11MB7378:EE_
X-MS-Office365-Filtering-Correlation-Id: aafe0aef-ff6d-43f6-3ac9-08dc06aab61f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HYBRG8AWmwCcQ9iqo70+2HPPdtLgz3pgXK8aFGRGHgvBBxOFKvjEo9BNxJdkoOx5dHuHmj2AJg/V5H5FVw6XAmsGksL16hunQ8BUG7PI1moMmmgOP0i0LoCPqwW4GfMBX+C9CEr89Zyb+PoSF9GABk8tWbfx36/vaqB+xUMuPZwkdfz5UvYXXUu+rmbGKpZQXjv6DOrM5y0dm3LnvLMWBUBnyQ00T9dcmYqxs6hXswn5fM1L2xVgT02mNadNxXaJE66GW/IwiJdE9OaWcQi1rB6+QpJ83SQax5qI4FHO4o0iZblcNbw6mEi5hiDrsVtO17q2zv0JddwBAcUnwQsIIBXvTPC0NgDlOOwHX4H+5QtqpFgg2qhfNEW91xoqhHiX9QTpjY8EK2nzWeqeevxXkXfqX8LumTKRQoX3J57z/T42yQeVF7Yg2tbkG7VS+UAUFJKTrFCMvmW63RzD5nwvT5QjBkN8cZXM50Adp8cAGK3DSDpdH07qNJvIIAyy3Bq5Qx+vpwR0EjaCaCdJ7xOU6nqHFqyLMvXNQjHkNzHA8sgdOMogZXH/wH1B0WO+nQ6hE8sXe7GX6d9v26xVNuXhgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(39860400002)(346002)(396003)(366004)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(2906002)(4326008)(8676002)(8936002)(38100700002)(83380400001)(1076003)(26005)(5660300002)(107886003)(2616005)(82960400001)(966005)(478600001)(6666004)(6486002)(36756003)(86362001)(6506007)(6512007)(54906003)(316002)(41300700001)(6916009)(66946007)(66476007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I67JxRBGLaDpkOXoqziVaahXur4zRPToWJj4qe3M8EMQMJYPgSBYxHWlltFV?=
 =?us-ascii?Q?AdDyCWUwYQy5+usyjolgVhhVuxebLq/B22pziwfkrVOV+G0rMPaOaswxq7MM?=
 =?us-ascii?Q?ISCkDWY7YVb+o2Ra/OsmtgX0hczGdnVLTC+UXE49k3GDQt3I9iBl0yDHDU2V?=
 =?us-ascii?Q?qmXAG6cZExV2YidQ1bYC37R7M+zEFhLrffeAmjEn6SpmTMUDEP5daBjOwE/G?=
 =?us-ascii?Q?/H/M/h+icl686W4NvDjl6v18mFVtcmVM0J83PXte75fpLlLWhuo9ZyLU5t9/?=
 =?us-ascii?Q?Mkp4q6+M1L17aj/Da36jHk7wCIKPV3FRmmY2FIDq5cSfHslrIYpFr+eEkbpz?=
 =?us-ascii?Q?dkcKznLJrdlKVU3JcZ4uQfMzo/tWE/VQtMKIq091wErqQmNgUJcw7W2Zw3Ql?=
 =?us-ascii?Q?Ztm6/7SV4svAaMFUXlrRdGwof/r1jz0BFbAMFMLXgREEU+QQGg8B/Vdgzxpk?=
 =?us-ascii?Q?EjVXhw/5Bczpak2FU4HqCiZ9Hx38Qpuk73ajdcQaRkhugm138MpTZ1FG+nBO?=
 =?us-ascii?Q?jWe5gB+5gzwcQNQBKoLLllAhY0imirrD6ilEgNJz2CqlW9rpLUcjm2JQYXBj?=
 =?us-ascii?Q?ZRaSHf6OYTjWX/cKoOUhU4cfIbAMPn+WmPVJjzC2iFmvMY+7qsmMZZj55wu4?=
 =?us-ascii?Q?1cZTzti2GTygMj8Cohx+nwsZJjP2P8kB1KEr+W19KscPxDs8EzC76qJPRP+C?=
 =?us-ascii?Q?dDwlYL/LfJWpNHMuTNVQ79MhljeoFjPYoBWjOsaO6o0scMPNmKeI1HtrKsIY?=
 =?us-ascii?Q?5JqgneWnow1BFZa5CsPTDJXRjRydI+TKU6VOutyvF2h1M4h8cahhYKZHX+6L?=
 =?us-ascii?Q?VZ354OQ/09bSMnyxNZlGVvNiBdn/vxvrXJlde5NqaN245LvP2lE1npFPUB6P?=
 =?us-ascii?Q?HmOTbuF/mM+TZMkfM13GWQF8ee1/FMYEQYG3KBdi5HZ26hJlHAI1o/Y3gQFx?=
 =?us-ascii?Q?4dWJUhjdAxj+5ovd96TQRla+bb2Apc3Rlas6xCicV0m3etPcvev3gg+N89Io?=
 =?us-ascii?Q?0inZusSSIXQ9ER3KWNV3pGgokfNHiD42A1kNn8Vtu7LQCj0PqC/deiNy70lz?=
 =?us-ascii?Q?LSLzbj+YqLCvmXULU5OXg3Ld4yzfKmli8GObcH+cgRSCtlA9zPj6fe2Q5qLd?=
 =?us-ascii?Q?IwIKuZ/YJVzBPSkfefOI9+gamlg+0iw/3jO8jemHaaBLFy0OMParZv8cHRl0?=
 =?us-ascii?Q?9G8R+JWJjD6XCKDT+4O2Olyjlel0BAHtvWORN68FozoClhZ8HvnSyj2XM8s+?=
 =?us-ascii?Q?bbp9SZSO1tBahGncrkCANZoXVKXI7K9MYZX40FL8MPEiV0Dnddze6Ce3LDXS?=
 =?us-ascii?Q?aHAbI1UJC6rY85UggjoutjhXqWnuhWKKZmXUCfMZ36910bfSITaEophAQnJw?=
 =?us-ascii?Q?b4GQuV0GB6OkCfyJyWu4xrVwdbraiRwDq3S1RPP1DuEzjG3G2SatyqWzTy4V?=
 =?us-ascii?Q?+RGICg+HCEa8wI9BHXbO/6+1s86GZKlFcBcG7y1LZDPkApdC8VSsJd+qlIap?=
 =?us-ascii?Q?B4uOSE897Ir7hFqIWDA52b/PikYIb1Z/EtwNhU0sz8gMTRREbvKCpdVa8ure?=
 =?us-ascii?Q?g3PcSF4UkDW1XYEfzVnivg/NyyN+/XjwHZP9ivcj2vL8BuXYa02aKqIuqWbe?=
 =?us-ascii?Q?2w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aafe0aef-ff6d-43f6-3ac9-08dc06aab61f
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2023 07:09:05.0988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pdq/Y6MUx4u4l5f0jYcwoGGVOdJWOOT5pNjCWEHlNQJsrzrQ9k1PnesEnNtVx9vCQu8HxOYUB0Ls6XswbDADOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7378
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "BUG:KASAN:slab-use-after-free_in_xfs_defer_finish_recovery" on:

commit: 7f2f7531e0d455f1abb9f48fbbe17c37e8742590 ("xfs: store an ops pointer in struct xfs_defer_pending")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[test failed on linux-next/master 39676dfe52331dba909c617f213fdb21015c8d10]

in testcase: xfstests
version: xfstests-x86_64-f814a0d8-1_20231225
with following parameters:

	disk: 4HDD
	fs: xfs
	test: xfs-rmapbt



compiler: gcc-12
test machine: 4 threads Intel(R) Xeon(R) CPU E3-1225 v5 @ 3.30GHz (Skylake) with 16G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202312271458.851834a0-oliver.sang@intel.com



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20231227/202312271458.851834a0-oliver.sang@intel.com


[  172.112523][ T4713] XFS (sda4): Corruption detected. Unmount and run xfs_repair
[  172.119897][ T4713] ==================================================================
[  172.127821][ T4713] BUG: KASAN: slab-use-after-free in xfs_defer_finish_recovery+0x19c/0x1d0 [xfs]
[  172.136916][ T4713] Read of size 8 at addr ffff8881257529f0 by task mount/4713
[  172.144139][ T4713] 
[  172.146328][ T4713] CPU: 1 PID: 4713 Comm: mount Not tainted 6.7.0-rc4-00053-g7f2f7531e0d4 #1
[  172.154856][ T4713] Hardware name: HP HP Z238 Microtower Workstation/8183, BIOS N51 Ver. 01.63 10/05/2017
[  172.164424][ T4713] Call Trace:
[  172.167570][ T4713]  <TASK>
[  172.170368][ T4713]  dump_stack_lvl+0x36/0x50
[  172.174730][ T4713]  print_address_description+0x2c/0x3a0
[  172.181173][ T4713]  ? xfs_defer_finish_recovery+0x19c/0x1d0 [xfs]
[  172.187555][ T4713]  print_report+0xba/0x2b0
[  172.191830][ T4713]  ? kasan_addr_to_slab+0xd/0x90
[  172.196623][ T4713]  ? xfs_defer_finish_recovery+0x19c/0x1d0 [xfs]
[  172.202954][ T4713]  kasan_report+0xc7/0x100
[  172.207228][ T4713]  ? xfs_defer_finish_recovery+0x19c/0x1d0 [xfs]
[  172.213601][ T4713]  xfs_defer_finish_recovery+0x19c/0x1d0 [xfs]
[  172.219747][ T4713]  xlog_recover_process_intents+0x26d/0xb10 [xfs]
[  172.226169][ T4713]  ? _raw_read_unlock_irqrestore+0x50/0x50
[  172.231823][ T4713]  ? xlog_recover_free_trans+0x3d0/0x3d0 [xfs]
[  172.237987][ T4713]  ? xfs_buf_rele+0x31d/0x8f0 [xfs]
[  172.243185][ T4713]  ? __mod_timer+0x666/0xb30
[  172.247628][ T4713]  ? round_jiffies_up_relative+0x110/0x110
[  172.253283][ T4713]  xlog_recover_finish+0x72/0x430 [xfs]
[  172.258858][ T4713]  ? xfs_ag_resv_free+0x40/0x40 [xfs]
[  172.264221][ T4713]  ? xlog_recover+0x470/0x470 [xfs]
[  172.269476][ T4713]  ? xfs_check_summary_counts+0x23f/0x3c0 [xfs]
[  172.275720][ T4713]  xfs_log_mount_finish+0x2a6/0x590 [xfs]
[  172.281452][ T4713]  xfs_mountfs+0x117d/0x1c60 [xfs]
[  172.286569][ T4713]  ? xfs_mount_reset_sbqflags+0x100/0x100 [xfs]
[  172.292820][ T4713]  ? xfs_filestream_pick_ag+0x760/0x760 [xfs]
[  172.298890][ T4713]  ? xfs_mru_cache_create+0x38a/0x580 [xfs]
[  172.304789][ T4713]  xfs_fs_fill_super+0xf13/0x1740 [xfs]
[  172.310345][ T4713]  ? setup_bdev_super+0x2fe/0x640
[  172.315221][ T4713]  get_tree_bdev+0x32b/0x580
[  172.319666][ T4713]  ? xfs_finish_flags+0x290/0x290 [xfs]
[  172.325216][ T4713]  ? sget_dev+0xd0/0xd0
[  172.329227][ T4713]  ? vfs_parse_fs_string+0xd8/0x120
[  172.334284][ T4713]  vfs_get_tree+0x81/0x320
[  172.338574][ T4713]  do_new_mount+0x218/0x540
[  172.342934][ T4713]  ? do_add_mount+0x370/0x370
[  172.347466][ T4713]  ? security_capable+0x6e/0xa0
[  172.352171][ T4713]  path_mount+0x2af/0x1350
[  172.356440][ T4713]  ? kasan_save_free_info+0x2b/0x40
[  172.361496][ T4713]  ? finish_automount+0x6e0/0x6e0
[  172.366375][ T4713]  ? user_path_at_empty+0x44/0x50
[  172.371279][ T4713]  ? kmem_cache_free+0x18b/0x490
[  172.376078][ T4713]  ? getname_flags+0xb7/0x440
[  172.381224][ T4713]  __x64_sys_mount+0x210/0x280
[  172.385846][ T4713]  ? path_mount+0x1350/0x1350
[  172.390375][ T4713]  ? from_kgid+0xc0/0xc0
[  172.394480][ T4713]  ? getname_flags+0xb7/0x440
[  172.399622][ T4713]  do_syscall_64+0x3f/0xe0
[  172.403899][ T4713]  entry_SYSCALL_64_after_hwframe+0x63/0x6b
[  172.409649][ T4713] RIP: 0033:0x7f977d8cc62a
[  172.413922][ T4713] Code: 48 8b 0d 69 18 0d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 36 18 0d 00 f7 d8 64 89 01 48
[  172.433374][ T4713] RSP: 002b:00007fffc4e3ea38 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
[  172.441637][ T4713] RAX: ffffffffffffffda RBX: 00007f977da00264 RCX: 00007f977d8cc62a
[  172.449466][ T4713] RDX: 000055a677172b90 RSI: 000055a677172bd0 RDI: 000055a677172bb0
[  172.457305][ T4713] RBP: 000055a677172960 R08: 0000000000000000 R09: 00007f977d99ebe0
[  172.465150][ T4713] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[  172.472981][ T4713] R13: 000055a677172bb0 R14: 000055a677172b90 R15: 000055a677172960
[  172.480810][ T4713]m_cache_alloc+0x158/0x340
[  172.508483][ T4713]  xfs_defer_start_recovery+0x2b/0x230 [xfs]
[  172.514503][ T4713]  xlog_recover_intent_item+0x7f/0x150 [xfs]
[  172.520494][ T4713]  xlog_recover_rui_commit_pass2+0x18e/0x240 [xfs]
[  172.527009][ T4713]  xlog_recover_items_pass2+0xe7/0x220 [xfs]
[  172.533000][ T4713]  xlog_recover_commit_trans+0x70f/0xa10 [xfs]
[  172.539160][ T4713]  xlog_recovery_process_trans+0x10f/0x140 [xfs]
[  172.545546][ T4713]  xlog_recover_process_data+0x11b/0x2a0 [xfs]
[  172.551710][ T4713]  xlog_do_recovery_pass+0x57f/0xc90 [xfs]
[  172.557531][ T4713]  xlog_do_log_recovery+0x62/0xb0 [xfs]
[  172.563088][ T4713]  xlog_do_recover+0x74/0x420 [xfs]
[  172.568307][ T4713]  xlog_recover+0x23f/0x470 [xfs]
[  172.573357][ T4713]  xfs_log_mount+0x1c1/0x490 [xfs]
[  172.578477][ T4713]  xfs_mountfs+0xf66/0x1c60 [xfs]
[  172.583503][ T4713]  xfs_fs_fill_super+0xf13/0x1740 [xfs]
[  172.589050][ T4713]  get_tree_bdev+0x32b/0x580
[  172.593493][ T4713]  vfs_get_tree+0x81/0x320
[  172.597766][ T4713]  do_new_mount+0x218/0x540
[  172.602127][ T4713]  path_mount+0x2af/0x1350
[  172.606400][ T4713]  __x64_sys_mount+0x210/0x280
[  172.611021][ T4713]  do_syscall_64+0x3f/0xe0
[  172.615298][ T4713]  entry_SYSCALL_64_after_hwframe+0x63/0x6b
[  172.621065][ T4713] 
[  172.623275][ T4713] Freed by task 4713:
[  172.627115][ T4713]  kasan_save_stack+0x33/0x50
[  172.631651][ T4713]  kasan_set_track+0x25/0x30
[  172.636099][ T4713]  kasan_save_free_info+0x2b/0x40
[  172.640977][ T4713]  __kasan_slab_free+0x10a/0x180
[  172.645769][ T4713]  kmem_cache_free+0x18b/0x490
[  172.650391][ T4713]  xfs_defer_cancel+0xb1/0x1d0 [xfs]
[  172.655683][ T4713]  xfs_trans_cancel+0x117/0x540 [xfs]
[  172.661064][ T4713]  xfs_rmap_recover_work+0x94c/0xd20 [xfs]
[  172.666883][ T4713]  xfs_defer_finish_recovery+0x64/0x1d0 [xfs]
[  172.672950][ T4713]  xlog_recover_process_intents+0x26d/0xb10 [xfs]
[  172.679374][ T4713]  xlog_recover_finish+0x72/0x430 [xfs]
[  172.684933][ T4713]  xfs_log_mount_finish+0x2a6/0x590 [xfs]
[  172.690665][ T4713]  xfs_mountfs+0x117d/0x1c60 [xfs]
[  172.695780][ T4713]  xfs_fs_fill_super+0xf13/0x1740 [xfs]
[  172.701329][ T4713]  get_tree_bdev+0x32b/0x580
[  172.705771][ T4713]  vfs_get_tree+0x81/0x320
[  172.710046][ T4713]  do_new_mount+0x218/0x540
[  172.714407][ T4713]  path_mount+0x2af/0x1350
[  172.718678][ T4713]  __x64_sys_mount+0x210/0x280
[  172.723308][ T4713]  do_syscall_64+0x3f/0xe0
[  172.727595][ T4713]  entry_SYSCALL_64_after_hwframe+0x63/0x6b
[  172.733347][ T4713] 
[  172.735541][ T4713] The buggy address belongs to the object at ffff8881257529c0
[  172.735541][ T4713]  which belongs to the cache xfs_defer_pending of size 64
[  172.749877][ T4713] The buggy address is located 48 bytes inside of
[  172.749877][ T4713]  freed 64-byte region [ffff8881257529c0, ffff888125752a00)
[  172.763358][ T4713] 
[  172.765549][ T4713] The buggy address belongs to the physical page:
[  172.771821][ T4713] page:00000000bdec89a5 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888125752b40 pfn:0x125752
[  172.783203][ T4713] anon flags: 0x17ffffc0000800(slab|node=0|zone=2|lastcpupid=0x1fffff)
[  172.791303][ T4713] page_type: 0xffffffff()
[  172.795508][ T4713] raw: 0017ffffc0000800 ffff88811417db80 0000000000000000 0000000000000001
[  172.803937][ T4713] raw: ffff888125752b40 00000000802a001c 00000001ffffffff 0000000000000000
[  172.812378][ T4713] page dumped because: kasan: bad access detected
[  172.818643][ T4713] 
[  172.820839][ T4713] Memory state around the buggy address:
[  172.826331][ T4713]  ffff888125752880: fc fc fc fc fb fb fb fb fb fb fb fb fc fc fc fc
[  172.834241][ T4713]  ffff888125752900: fb fb fb fb fb fb fb fb fc fc fc fc fb fb fb fb
[  172.842159][ T4713] >ffff888125752980: fb fb fb fb fc fc fc fc fa fb fb fb fb fb fb fb
[  172.850076][ T4713]                                                              ^
[  172.857645][ T4713]  ffff888125752a00: fc fc fc fc fb fb fb fb fb fb fb fb fc fc fc fc
[  172.865564][ T4713]  ffff888125752a80: fb fb fb fb fb fb fb fb fc fc fc fc fb fb fb fb
[  172.873482][ T4713] ==================================================================

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

