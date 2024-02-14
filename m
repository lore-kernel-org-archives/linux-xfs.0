Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7C6D30B
	for <linux-xfs@vger.kernel.org>; Wed, 14 Feb 2024 04:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707883268; cv=fail; b=f2N/6Is5ZY4Z7LHh5VMf2ILilShexoG8+BT4yJtR78LBzyLK+/t2tEC9izS+LRCiMTd6vNLYpzSHXFo1SVCTfi3MEstb/J8D8t0sinDDbUmvkydFPVNEQVwfcc2h/c5goP4YV3x2yxiUdi/eaSiuLfy2pDPNRLncRIercFAHCX8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707883268; c=relaxed/simple;
	bh=4D6aJtIrS90HjCVGXhcerWcTzV4AXIsVjgtbv20Sz3w=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Zs2UrjgT2wVi6Bw9a2M3+FnD8QVhclR+T0NtaV7J33R04sQTVRfHRBOBg49uv02BAtWpp+BRLLNDqZIVCrcr+HrvvYUO1F/MPH5x+pFpXIclUwN4cSZuKBYIZ3Rcapqml/CemZnYJkb2fHoJygMaU6szv8PElSLkBDFsqLeDWns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qr17+H7K; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qr17+H7K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707883267; x=1739419267;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=4D6aJtIrS90HjCVGXhcerWcTzV4AXIsVjgtbv20Sz3w=;
  b=Qr17+H7Kz2FAAy01ebfy5VzxC47zLQjk7yzvV2I91tu+qUHXrgb4mpAa
   etGGmCM7dWp3Nwwi9PmbxllY4AxlxgOxU1KvkJ8gQCkUlVVx3yH4SGCRm
   bf/nlCgg4cjVqg+Xlm3aq1upyiI2xSjygvpwpIN3QcO2H1rKuV0j/cJga
   3bTkSxBs6HBMH05mhwu3QKs4qB7aGwViq8duo1hOj9veABko8k23pBYoa
   ftPEGmVtZu+ojjeW/k5M5+Cj/5HgyDZrWIkW3xYilgp0mzu20ZiwxDwjY
   0o1uh7W9qQubl2F+CtvpTli+XnlcJRS98GK7NeTB2nopgMTZCTYdM9G7/
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10982"; a="1798411"
X-IronPort-AV: E=Sophos;i="6.06,158,1705392000"; 
   d="scan'208";a="1798411"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2024 20:01:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,158,1705392000"; 
   d="scan'208";a="40551073"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Feb 2024 20:01:05 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 13 Feb 2024 20:01:05 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 13 Feb 2024 20:01:04 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 13 Feb 2024 20:01:04 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 13 Feb 2024 20:01:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j8F3DyjFLQFwGBClFIuwFsRs98kHIOdNviYzOoptU8276Av2ee5S+l5m+3gPtg98g7FtEp1XagreLgF5P7El1Qe7HdN++3KWIEwzIuBQBS0oe2urwRwITvG9HTn1utC/J7PrxgxPjxB6l7YEhVs7wiE7BMrWbM5qjeKKfb2uUBumbkdThEYz/CbQYuoxAw5cehKy8jH2dhyMb2cQf2ToDERQ8IwNv3ZJvL9VWDVDHBDZX1QLabwmV24o9zYegB9SUPTQxx08gOHRrcmLUyQJLOmqZTGqkuDsZs4LYmTbMHIvx4vO8ua16S72Vj8VyV+llWYQsno3AetbGcVIJn8QtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=okU+jdwEpLWduo2Xt+IisJW5GOywcGpem/9EDWQLPL4=;
 b=UZ6vG9EyCa3QoRn5gbMCVr6rws3xJfac1Cd1n0jULhWMUtEe6GFd3uCga/jkd2w4lGA7qCMhPKlXfLaY010bfElykV6wqWftz6zlUnr9sj3e4LzQHiYwV7gPNthjaLFkT7VtFxMPbfpzeGez4vj5tv93Azy722O170VekBYxuv6YgiLnLaNvTjfnfCjFwImJyDlBhxDUNgOjqqIue9udJgMutUzDRjS34VMKzkyM46ROzDxcHl2jrUW8Fe5RKo00hwyHZlkCvbEFbTDKTGS+0m81p/6djiW/ibNFtKGhy64WrUgiBHY/W9LnmUarGCpRJLYz+Agcank9QeZ1m9OHxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by DM8PR11MB5687.namprd11.prod.outlook.com (2603:10b6:8:22::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7270.39; Wed, 14 Feb 2024 04:01:01 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::a026:574d:dab0:dc8e]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::a026:574d:dab0:dc8e%3]) with mapi id 15.20.7292.026; Wed, 14 Feb 2024
 04:01:01 +0000
Date: Wed, 14 Feb 2024 12:00:53 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Dave Chinner <david@fromorbit.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-xfs@vger.kernel.org>,
	<oliver.sang@intel.com>
Subject: Re: [PATCH 4/4] xfs: reactivate XFS_NEED_INACTIVE inodes from
 xfs_iget
Message-ID: <202402141107.4642a3e7-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240201005217.1011010-5-david@fromorbit.com>
X-ClientProxiedBy: SI2PR06CA0007.apcprd06.prod.outlook.com
 (2603:1096:4:186::9) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|DM8PR11MB5687:EE_
X-MS-Office365-Filtering-Correlation-Id: 29bb2d41-584e-48b8-99f5-08dc2d118ead
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N6jeWOskma+AYS7tLKAw3VZgL9/gXmqI3gWzaXe+wOhxV8BqGoAO+xl/m2Ar8d78TUjkxbUnikoMPV78Fz5jwSF6byIWT4P3DeRkQVNHPcKsbuY3nTVilHjqc06bHobSiwsoOKMrqmIMsfMrt2ypykVC+GEzafxquv6gJXlsmbyvIhOda7wiBry1uAiKs7JN2iI5jIk2NOqMGyGsfRIW2iAf1wmZzK/26FCVAnV4TYJXMsr9u+6IUfaoP4BuRD+d4dFAOPvXcWc/9SitRd8JLpvksTUyapBlPOQKH6t4+7F4luzCyoHlCq54/LcfbbnQ8sQ8pp9wTJkKzdi72CEO2kWjCV8zH4cTYM+hR9sFsC+KAXa+c3Lr8Me+8xELcey71lo62OyhrLdNTn8kUtz25Gzl2ns46tD2enMzxB9SeoptI2CTWzG2hf0GcirFsL16zm4d2ojdav265ETrb7FmQXSVwSTd7dvk7PxoNLbwM2TIO1ijzhsM3sAtG8UqtzIa+z/uKnPNyavufTLqJLbArike7sFy6sOGOYLsflTAh50=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(366004)(376002)(396003)(39860400002)(230922051799003)(1800799012)(451199024)(186009)(64100799003)(2906002)(82960400001)(38100700002)(26005)(478600001)(86362001)(966005)(36756003)(6486002)(83380400001)(6506007)(6666004)(2616005)(1076003)(6512007)(107886003)(5660300002)(6916009)(66946007)(66556008)(66476007)(316002)(8676002)(4326008)(8936002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iNFeop6+uvf8RgqQRBeifssbTPJXS5tNPSCM8e8Yefw6dDLHjnHs1xeBEBRf?=
 =?us-ascii?Q?AmBA/718VzYstT9NgU9xeE8Msl8VaB2yIN+ejJDG1NVc+34CO/ajD/Iggsk6?=
 =?us-ascii?Q?tuw8FwfrM5BTHf3q7VLGhLwTpzUfhCIx2d7sqcT22C/EDuIa04CfoOURSS8n?=
 =?us-ascii?Q?tFU/hjGPwg/RrYaBlqBy6kwXP6eKdnzWds6ueuwjHg2NWF6h0g8zASmu1dE1?=
 =?us-ascii?Q?JvDEsS0yCLJHxgPP0mPWdwxHL9ktXV0v7n5YytcuuhqwinmSTwzd7qgPSBCK?=
 =?us-ascii?Q?uphg6iv2aUYSACBhkoAibN0ELoX3YxbEcBpyhmGSUu2lzCpi0EolYv1C4PKn?=
 =?us-ascii?Q?CKf5Nw0VGqPXXQVSQSbsg8JlELCmzHd16Wz4PCatIPOX5bn80+3lkDsvyVUE?=
 =?us-ascii?Q?jYpwUhDa14wS2FPHXbtsqIMrbZk1iW7OoOL28j73JNqUBL90pzbZ1WbQbeKG?=
 =?us-ascii?Q?BnMd2EZdDwmJwNW40jHjul2DBZgo3vwPEKJ8O+uY8PRSR2rH7rRE1Pj00gjd?=
 =?us-ascii?Q?Onfk1M+zqxFp+vvzTBK+9ihFtsK/hVw/vF1kmpVmaixJatmuhl6Ry3J2Pn1Z?=
 =?us-ascii?Q?EtxJ22vifPmd4NiPqAWCvmXw83LVa/k6Z8yZ8OHrSBRUuwoiyQ+scuURiJpr?=
 =?us-ascii?Q?7OrcfmaO3YiT7DEH6cApLSMPdfVEY5mCPqk8QOuLpqbNARLKVeuJsJ/g4ap+?=
 =?us-ascii?Q?ZLgQcvJyuexvT1rB1ATFun2bYGt7Pa/kVzfVxwe3G63vMRMHkfpsZBQcWOkh?=
 =?us-ascii?Q?Uv0nBm7Wvv1X+Y8qqn5ZlGWd3tVykIjZM+nYGxCsVp463ruXnlAV+FZDvWUo?=
 =?us-ascii?Q?BxnOwOM3gOAb6vMEF8roT4wZoUTEotIR+ZDgrtXSpoaFRnAxkYJrvrTcOS6X?=
 =?us-ascii?Q?nXKGVP44e6xiSYhaF1DE6jPwIXpezH65C6MK4VT7NL3wuh7nF5awoL0Sq1K3?=
 =?us-ascii?Q?ymdVJMDDCVbdlXjkDAnGFF5XxBvwSn2DXfqejZEVLkjxzB1z/2OSuYEFYr7j?=
 =?us-ascii?Q?z9Hpd0TGf4MJzOjghM8Mtc3cgTwf4lae6T2EaqHONFT1eYXC6QgRUIS9UlIM?=
 =?us-ascii?Q?PVVeOkmf/5EuSMV9UdYbXhIce3Y1//aEBGJ/fUGx6dqZNxbfQSjFlqe+iNvI?=
 =?us-ascii?Q?hx+KZFDIb/JYS8pnGENH6w3lZ15KeNGgkfJtnUvMW3C9uFzupOjvhy68aDbr?=
 =?us-ascii?Q?jZoLrvesKt/Jr4a/IhYgZFmba2uYAh0mpMtVyX3Zopd1soXROc8umTg1153B?=
 =?us-ascii?Q?zS/0HfGVs0BNXxKPz+J5pbH/HB8PyFUm5iZdwH3b0X70JcgpRkw+x6oJ5i/L?=
 =?us-ascii?Q?e9ndfZ6+PMnQdhQGv6TwyPwlIb9iYLaGq5KJ7UvcwT+k62DA8qJosyJfx/g3?=
 =?us-ascii?Q?W8z3TzePwL52oJIR8iNgwUt+INX/JcfWRf7trFfaCNw9u4D4GO74eIbxwUz7?=
 =?us-ascii?Q?b4Olx87B8zRRQX1c6IrW8D2SPl3aN3QhS36aHj3TXuKiC6yvk9wWj7ZWSijO?=
 =?us-ascii?Q?ZEQIGjJAKVN5qhg8vT5WTwFzNjitCEqXBPN1+IpkRO2LawBjExJ1RXbnwdnP?=
 =?us-ascii?Q?uFJ0N9Mvb/GMfcl6caOwI8jZ0YadDw3urKOUrFyEkhsVhxsypW1sogzZAyea?=
 =?us-ascii?Q?lQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 29bb2d41-584e-48b8-99f5-08dc2d118ead
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2024 04:01:01.2406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /+J2SpQ0KhofjNig3AJjFyGuaoWt4lXUpQDVtfJfNxwtbJrYwjfszKxRj5mle1PA+Z4DUbut4bdJbQ3O+YFIgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5687
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "xfstests.xfs.183.fail" on:

commit: 98e62582b2cc1b05a1075ce816256e8f257a6881 ("[PATCH 4/4] xfs: reactivate XFS_NEED_INACTIVE inodes from xfs_iget")
url: https://github.com/intel-lab-lkp/linux/commits/Dave-Chinner/xfs-make-inode-inactivation-state-changes-atomic/20240201-085509
base: https://git.kernel.org/cgit/fs/xfs/xfs-linux.git for-next
patch link: https://lore.kernel.org/all/20240201005217.1011010-5-david@fromorbit.com/
patch subject: [PATCH 4/4] xfs: reactivate XFS_NEED_INACTIVE inodes from xfs_iget

in testcase: xfstests
version: xfstests-x86_64-c46ca4d1-1_20240205
with following parameters:

	disk: 4HDD
	fs: xfs
	test: xfs-183



compiler: gcc-12
test machine: 4 threads Intel(R) Xeon(R) CPU E3-1225 v5 @ 3.30GHz (Skylake) with 16G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202402141107.4642a3e7-oliver.sang@intel.com

2024-02-08 20:30:36 export TEST_DIR=/fs/sda1
2024-02-08 20:30:36 export TEST_DEV=/dev/sda1
2024-02-08 20:30:36 export FSTYP=xfs
2024-02-08 20:30:36 export SCRATCH_MNT=/fs/scratch
2024-02-08 20:30:36 mkdir /fs/scratch -p
2024-02-08 20:30:36 export SCRATCH_DEV=/dev/sda4
2024-02-08 20:30:36 export SCRATCH_LOGDEV=/dev/sda2
2024-02-08 20:30:36 export SCRATCH_XFS_LIST_METADATA_FIELDS=u3.sfdir3.hdr.parent.i4
2024-02-08 20:30:36 export SCRATCH_XFS_LIST_FUZZ_VERBS=random
2024-02-08 20:30:36 echo xfs/183
2024-02-08 20:30:36 ./check xfs/183
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 lkp-skl-d06 6.8.0-rc2-00006-g98e62582b2cc #1 SMP PREEMPT_DYNAMIC Thu Feb  8 18:32:20 CST 2024
MKFS_OPTIONS  -- -f /dev/sda4
MOUNT_OPTIONS -- /dev/sda4 /fs/scratch

xfs/183       - output mismatch (see /lkp/benchmarks/xfstests/results//xfs/183.out.bad)
    --- tests/xfs/183.out	2024-02-05 17:37:40.000000000 +0000
    +++ /lkp/benchmarks/xfstests/results//xfs/183.out.bad	2024-02-08 20:32:06.555798923 +0000
    @@ -1,4 +1,4 @@
     QA output created by 183
     Start original bulkstat_unlink_test with -r switch
     Runing extended checks.
    -Iteration 0 ... (100 files)passed
    +Iteration 0 ... (100 files)ERROR, count(100) != scount(2).
    ...
    (Run 'diff -u /lkp/benchmarks/xfstests/tests/xfs/183.out /lkp/benchmarks/xfstests/results//xfs/183.out.bad'  to see the entire diff)
Ran: xfs/183
Failures: xfs/183
Failed 1 of 1 tests




The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240214/202402141107.4642a3e7-oliver.sang@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

