Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D9F19A2A3;
	Mon, 30 Jun 2025 07:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751268289; cv=fail; b=YXIOqGxXjrbbiG1/K+bazQcyA8SeVOSqBm8DSnQ2ZG1SUut5L76eQ1wHH12ieRLlrH17EshrhZfAMVJjo5vpCGE+Edz6l3Tip5EG9iAC/LQTiIkQsu+EdiRniLc/iV/Tfk++Xsa9jf3LQXf2HUoo3wFZz3yY6sL1McLI2yb3zQ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751268289; c=relaxed/simple;
	bh=GRMUTX3ap9Jb6tiEvIdjBI6DnU544H+yiyPykKyA5Qc=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LMOI4Gsp9R59xUIs86yzrFwDdRgGrKzde1a4LL3AplHculFdXgozTrZazz6veMnznLeoS1RhnmD0e7+yLDunaVAgYD9yVvM9UbUbWEkC4FjLdOAquOlSwqOpI4LJFlqpHQ37OkB2Hxi80lczMkCtmha5A0BiSB5d3gRGnXu5dlg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OZrdU7cl; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OZrdU7cl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751268287; x=1782804287;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=GRMUTX3ap9Jb6tiEvIdjBI6DnU544H+yiyPykKyA5Qc=;
  b=OZrdU7clGMTyQzOkxga65wcJkCgekDti7W8CiwbxLkcFUWv4S/F0VIuk
   UrXzKoTRwEwBu56iNKMRBe4L2/yl7vaEfrD09OtGP/G5Qz0VLO7Vgqe1p
   32XYyPIIi1ZNCF3NDK/kwUghObIPuOrAe+b+ZpoSUsUjxfnFSJtyJO1GB
   K3GIXgSWlAkq3pZnJjCgSKN++SWrcXsWqRsq+rPgKDYlUWmeSgRgig/UI
   y1on0Sr3qFgpeJ3E8cXRj43k7UVEQLASgmqH+DmPw0ksgUzYIrH43+au6
   Y9/XkbMBdFOXafpusMZCdQ69o8aLZzSuhIXNgkY3FnB8Yzr5Wkrva7um0
   w==;
X-CSE-ConnectionGUID: EesKbGAjTs6/hR54I2Seag==
X-CSE-MsgGUID: 5IVFRsdbS2majbxS6BlK0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11479"; a="53347318"
X-IronPort-AV: E=Sophos;i="6.16,277,1744095600"; 
   d="scan'208";a="53347318"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 00:24:46 -0700
X-CSE-ConnectionGUID: lghwQxDiTfq+WAmEXL5r+A==
X-CSE-MsgGUID: 0DQ/l5y8Rh+Atx8Pl7bIaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,277,1744095600"; 
   d="scan'208";a="152765449"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 00:24:46 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 00:24:45 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 30 Jun 2025 00:24:45 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.69)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 00:24:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YvZh48hYbsTKlzJlYSQOrL19xqLyR3js6RWMgtc1Htbt6RooRqRNZCkdWLaKpLQVnCdTagzRONQrR3hgVBKTL20WMVyAWJQeD5BDKJJnBrxUjLOthSwe/IGzkXFcHJK2+Zbjb8kM87nabm4LD7tEvb+04WA2k7SWiCXzh3q4nEMeexwyKUSMFPrxwKQT0zcmHhRw33FENLuy1QGyG5NT2XBMg6fg+n1Lm2MAfHnBqCIx5B2nPKkA8NodSgxT0H0Eb9cyOAvBAMJsYkPl3let8IMxItNLgeCxR3Ba32xgdntKqNiWj+iQSL2/ZOwBIEPVQii+Hw0r5smY3sViC8VvgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y9LLjXrvTfa7N1A2/bLj8MwrKZo5dKabZ2yfSBDd5JE=;
 b=tq9lPneSBSsrRfFUT19cIZjz/3hFMQyWDq9WBVcCIDfS0VbeZTH9+qFul5SkPcyA8zXlS3EDl1xguutchhNRGMlxOo/T5Huas0GKeRsHZqTGSdoH+5NT6jFseMghpucn5zyvFcnuySBToCqqwdKV9Ix2Neg2+I7PThU4KVdSoD25/zRxXQMfKVmRC8shKUGj0uGiTO8kDytqbZ51xXAMKdkWoVmITs63Mbo8EQ3QHy2DWRs4k2KzV2nm1NMpAROo3rOf4/s+gGqxUrNVWtvJPE3KZMxCvUnFtonvu7HJTk3GN53TWTPOOSKhN30PeyBWQst02Z8gCPvpZtjG19WWCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by PH7PR11MB5794.namprd11.prod.outlook.com (2603:10b6:510:131::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Mon, 30 Jun
 2025 07:24:43 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%3]) with mapi id 15.20.8880.026; Mon, 30 Jun 2025
 07:24:42 +0000
Date: Mon, 30 Jun 2025 15:24:33 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Pranav Tyagi <pranav.tyagi03@gmail.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-xfs@vger.kernel.org>,
	Carlos Maiolino <cem@kernel.org>, <skhan@linuxfoundation.org>,
	<linux-kernel-mentees@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	Pranav Tyagi <pranav.tyagi03@gmail.com>, <oliver.sang@intel.com>
Subject: Re: [PATCH] fs/xfs: replace strncpy with strscpy
Message-ID: <202506300953.8b18c4e0-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250617124546.24102-1-pranav.tyagi03@gmail.com>
X-ClientProxiedBy: SG2P153CA0005.APCP153.PROD.OUTLOOK.COM (2603:1096::15) To
 LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|PH7PR11MB5794:EE_
X-MS-Office365-Filtering-Correlation-Id: 16c78c88-432b-414e-af19-08ddb7a72ead
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?hPSDBAa/CR97HINQhBOLSBZfHc5BEELVjwQBrUVroyIKA8UtonzS4Net9GZP?=
 =?us-ascii?Q?+AOXFgSOfe9lswX3qrczS7QPawT9r/2DJb1Oxz0NGAsShyPKT00mTgSgX6/q?=
 =?us-ascii?Q?H5qwZjYtcYR26/ujcuARxT/b6LqnXAgSdVLYZ+wyvVpfnUdYZGAGXTlWyTOO?=
 =?us-ascii?Q?4iGpo6YdIR4NzSV2dq7CHpF3k4/ARKaTBvjiEcX6GY7ZPsitOmSvif8A0i1/?=
 =?us-ascii?Q?hot5g5mgRx6quRxoOGv8I49e8RIAp9sp8b7yTssgabePEnMZhG5BGinCc4PA?=
 =?us-ascii?Q?aHoGLGZ8DqmNanRYe1oNUn0G1jLGVDLLjM0KnkWGJ73L5nmDq9Qjh4qNj70U?=
 =?us-ascii?Q?u7/uo3l+AsL7dQcPIdPtRQwjSRKqd2Mixz3lh3vDGFTSo+VjfIShIaox9TFB?=
 =?us-ascii?Q?Ipox00TPZ+5XRv0YKX4aPiDcDr60+be5iLNk+uHAPHcEaeYSdKk6k+ffqPFq?=
 =?us-ascii?Q?Qa7ndIbUCkmfGKaPRhqngD7MABz2okPrhTQ6ls8oz2rLmHVV00db3RSC0t31?=
 =?us-ascii?Q?uwV29FID++R5DtRInIkForHz8jc2hp97fpyMQJzYHZ0NWmwuAlCCokOITUAG?=
 =?us-ascii?Q?agYqzHUhBz1kt4auJc6+w9ybYw5eoNQbbl58VTMuwxAEieou50EZfdpDsUmY?=
 =?us-ascii?Q?mISfbpvPruebTut/29vbI3Y6HU5ojekJI2cZBSFuFUYCSRjeIln9s/VCIQ+k?=
 =?us-ascii?Q?7CF1InLOIUopOJiRiNGHYrk286C5O22vK6topl3fpr1O+eynEOyicdVv4D5F?=
 =?us-ascii?Q?YZSMDbynd/ARqaVa9O+1giE6+YlExFtt5OQhZltkre6HWf+Nc8NtDS+aXTyz?=
 =?us-ascii?Q?KLDns5D1JxN5pcJnRnWVl2jHk4ztNh7Vso/8pW/zBYxRwX/SXfN3hK07RACX?=
 =?us-ascii?Q?jN83k4bkFXjELjJ1IIjznXcnOjT5xtk1CC8Vs14AEG1GymS4uIpmTWA3DNo5?=
 =?us-ascii?Q?krlV34cVeMTuRS3u8jS6KUFqBwhuTfIhNIlAvfM0Oa92ti2Wc4Kt66crbyqJ?=
 =?us-ascii?Q?rET6fFltqfGzaANH8W5IBQEsTwu3qM954Js7eUQbTmxtEsqMnGzfXfMRrQqn?=
 =?us-ascii?Q?QwcL0paY4fpKbYpVX5H6vakWcDXBDCmQVXyFsHj6+yujnnxXCgL4La2lml6d?=
 =?us-ascii?Q?FgzvTOKuR3OV16cyu6dfFERyCvA1VDkCvhRyx/RqMidm+Jx1v0kmgVRk7rJ6?=
 =?us-ascii?Q?4ZCx18W4BEhBgJgRfx3TkI9d5KUSL5G/oPLOe7DLuVrNC9rYQUqnpXI66EHL?=
 =?us-ascii?Q?78gPrnkRCNEwHKQdIqOumlxI8/sZNTiR9IJT7VAeVYH/e+XLD3Yy55K4Uyl8?=
 =?us-ascii?Q?sPLSTO7PkLN0iIsovuyQaQBxUU2LJY2LGsFF6w7f/Ge2hMM5dnFNvu7nZXWZ?=
 =?us-ascii?Q?HWRxpj3lzN+q6Lu5PIAjVWhaGpwE?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B7EGlPRRP1/T6LXHUImwtR1ba41otrYBx3uBO1M61O8wBZtdEs6R8uYIe+Zy?=
 =?us-ascii?Q?50lhXcnlH+wXIackkxOxptUudx4J2fbZKDj0df0lU+xjWQY1A4hyk5DkG7XM?=
 =?us-ascii?Q?6ZZpgJmySDMiksBVfGBP+gX99WdGUFb6T+G4qYZrRJlyK9fSpIK4s5q81xat?=
 =?us-ascii?Q?RNbj3guqzTXoS6dd6Ws1iFzEBFe8hc+bg2wm5OqAlEsa8JOnrCailcKZi7e0?=
 =?us-ascii?Q?QeEBXSblIjjIMFs4JMJjn8tJqNAXC6Tgw3K8CSkXPzazyEaSA7ctbNQzTvm9?=
 =?us-ascii?Q?Jn3RI6VJ3KI0rT2kpWdcyR4ns+s+//C2HPXwSova0JA6KbLEbkZK4vXtjWZL?=
 =?us-ascii?Q?NeYX4tRRMPoJa61F+Hdx3y4kSZcu6L8bO/GHPyo0wu8uM4755qEQ9IWTnHU5?=
 =?us-ascii?Q?I7U7+K9Goj1COUIE6uNfZZMxkERO/JWJyw7P7e4B5+UWAD2flWhkkj2UNT2B?=
 =?us-ascii?Q?BYHVGh8bUTUH/Odf9AdMg3VX/3iw1V0xwjB0qko5pi1NPXO7hrL//zivZAl5?=
 =?us-ascii?Q?UcyIvugoa29SR/UhGYZaV+HxR+39mkEs7OMgG7Y6UlXA81UMX186zrm3Oq0H?=
 =?us-ascii?Q?mvrOYiNrlml19NQ7IY85TocyicJwOLxnsNVDHUT/2L2Cl9x6b49LgpdfLKBk?=
 =?us-ascii?Q?crB6PS4UVG6GXWUx9p7MErv5dG1vJIK27bcrOdA3xsOwWgMCjOfFe+gWvFtA?=
 =?us-ascii?Q?TYdeo4k2LznO1NMAQmunpUmqguHbZGdKHqJ0JMTbzyMxpLk1R44rj1d+juMJ?=
 =?us-ascii?Q?6wqyWBSvSghnAHHyxmAoR2QTHotuiwFQLWBpOmJShqzCBqDYQEgmQWT7lvqB?=
 =?us-ascii?Q?NLaYbbwPHVEMV3yJ96CGQnDIT3ClTr6QxISSJoOQQaet4GC/nz69fbfWWRzF?=
 =?us-ascii?Q?FLo3k7QaK6FdVPQCezAAQJ5/AloMGgthpVrq8LQT+sm/yMgMJRdf9DIY6NT7?=
 =?us-ascii?Q?CKrMBdmgWc3WHu4h2gH7+8EvZghqN2A+/4UEXPwqI/cSDvLceem5u/fHqQuL?=
 =?us-ascii?Q?qzVSl+csFamon2YsQTwrAfPYPPykN8Y67IkvmSkQfoMA+mFhoU9moynb0aec?=
 =?us-ascii?Q?DRuIkeXNGEpxWn6t9PWX9sjZ+AW+JW5YSzQcadUlmsbJkRiYxdiIEtHtZrzC?=
 =?us-ascii?Q?H8WQx5dDRq8V+Cttir2U1DLo6tYVgGg+UAHPnIDPAUnmpGiDQcCGt7urC4VF?=
 =?us-ascii?Q?FiljutxZbE1kJUyOqUNQpgqZtj17OtsvRB/g0Y/YLs0sPHjs5yc6G9tjayu4?=
 =?us-ascii?Q?8co9xST+pQcAavMvCy9z8SMdtet5mhvzgbSO5GwdfqRNL/aVjqm0OL7KIGsO?=
 =?us-ascii?Q?Ql+6iuNBw87Vu8dIhW4avWONOkP00CpYOtit2zYoHYAszdk7WL14M7SrYYQ+?=
 =?us-ascii?Q?F1gaUggk42W+xNZhbFCX7pYr4vKr/i1HTIEf5zPZspZUon9HGRlcT6m4G2Gb?=
 =?us-ascii?Q?p72AZHHrs+lzfvpJ8uCsd8YBO9d8vnzE6bC6Dz9An0HRJ75zrLfcrvnTaiAY?=
 =?us-ascii?Q?Ba4MMOSiqApoNY/aw64XOiiqOR7gJxmoNFZgk/q13p0Sn9oJ0o5iepjuX5LE?=
 =?us-ascii?Q?nPlhQvou9BMbYJQGEzdHB+BChBvf8tDumCmE/tXfyudX7VdBWINk8wkf+1Nv?=
 =?us-ascii?Q?Eg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 16c78c88-432b-414e-af19-08ddb7a72ead
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 07:24:42.8865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZQJQyawSN0/NOtHYeBlY07tQdnzAk/1rAil20saefveCbhcBBgFncN2PA4KrDOyvg8qQE0y/AmktzcOjk1IbJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5794
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "WARNING:at_lib/string_helpers.c:#__fortify_report" on:

commit: 977e0a4036f9aa8cbbe33973e1eb7a1924191a5a ("[PATCH] fs/xfs: replace strncpy with strscpy")
url: https://github.com/intel-lab-lkp/linux/commits/Pranav-Tyagi/fs-xfs-replace-strncpy-with-strscpy/20250617-204752
base: https://git.kernel.org/cgit/fs/xfs/xfs-linux.git for-next
patch link: https://lore.kernel.org/all/20250617124546.24102-1-pranav.tyagi03@gmail.com/
patch subject: [PATCH] fs/xfs: replace strncpy with strscpy

in testcase: xfstests
version: xfstests-x86_64-b3da4865-1_20250623
with following parameters:

	disk: 4HDD
	fs: xfs
	test: xfs-group-50



config: x86_64-rhel-9.4-func
compiler: gcc-12
test machine: 4 threads Intel(R) Xeon(R) CPU E3-1225 v5 @ 3.30GHz (Skylake) with 16G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202506300953.8b18c4e0-lkp@intel.com


[  167.002786][ T7295] ------------[ cut here ]------------
[  167.008126][ T7295] strnlen: detected buffer overflow: 13 byte read of buffer size 12
[ 167.016029][ T7295] WARNING: CPU: 3 PID: 7295 at lib/string_helpers.c:1035 __fortify_report (lib/string_helpers.c:1035) 
[  167.025263][ T7295] Modules linked in: xfs btrfs intel_rapl_msr blake2b_generic intel_rapl_common xor zstd_compress snd_hda_codec_hdmi raid6_pq x86_pkg_temp_thermal snd_soc_avs intel_powerclamp snd_soc_hda_codec snd_hda_codec_realtek coretemp snd_hda_codec_generic snd_hda_ext_core snd_hda_scodec_component sd_mod kvm_intel sg snd_soc_core ipmi_devintf ipmi_msghandler i915 snd_compress kvm snd_hda_intel snd_intel_dspcfg snd_intel_sdw_acpi snd_hda_codec intel_gtt cec snd_hda_core irqbypass ghash_clmulni_intel sha512_ssse3 snd_hwdep drm_buddy sha1_ssse3 snd_pcm mei_wdt ttm rapl ahci intel_cstate wmi_bmof snd_timer drm_display_helper libahci mei_me drm_client_lib snd mei intel_uncore drm_kms_helper ie31200_edac libata pcspkr soundcore serio_raw i2c_i801 video i2c_smbus intel_pch_thermal intel_pmc_core pmt_telemetry wmi pmt_class acpi_pad intel_pmc_ssram_telemetry intel_vsec binfmt_misc loop fuse drm dm_mod ip_tables
[  167.106191][ T7295] CPU: 3 UID: 0 PID: 7295 Comm: xfs_io Tainted: G S                  6.16.0-rc2-00007-g977e0a4036f9 #1 PREEMPT(voluntary)
[  167.118796][ T7295] Tainted: [S]=CPU_OUT_OF_SPEC
[  167.123437][ T7295] Hardware name: HP HP Z238 Microtower Workstation/8183, BIOS N51 Ver. 01.63 10/05/2017
[ 167.133014][ T7295] RIP: 0010:__fortify_report (lib/string_helpers.c:1035) 
[ 167.138351][ T7295] Code: 59 40 84 ed 48 c7 c0 00 77 54 84 48 c7 c1 40 77 54 84 48 8b 34 dd 00 84 54 84 48 0f 44 c8 48 c7 c7 80 77 54 84 e8 c1 57 c3 fe <0f> 0b 48 83 c4 10 5b 5d c3 cc cc cc cc 48 89 34 24 48 c7 c7 a0 75
All code
========
   0:	59                   	pop    %rcx
   1:	40 84 ed             	test   %bpl,%bpl
   4:	48 c7 c0 00 77 54 84 	mov    $0xffffffff84547700,%rax
   b:	48 c7 c1 40 77 54 84 	mov    $0xffffffff84547740,%rcx
  12:	48 8b 34 dd 00 84 54 	mov    -0x7bab7c00(,%rbx,8),%rsi
  19:	84 
  1a:	48 0f 44 c8          	cmove  %rax,%rcx
  1e:	48 c7 c7 80 77 54 84 	mov    $0xffffffff84547780,%rdi
  25:	e8 c1 57 c3 fe       	call   0xfffffffffec357eb
  2a:*	0f 0b                	ud2		<-- trapping instruction
  2c:	48 83 c4 10          	add    $0x10,%rsp
  30:	5b                   	pop    %rbx
  31:	5d                   	pop    %rbp
  32:	c3                   	ret
  33:	cc                   	int3
  34:	cc                   	int3
  35:	cc                   	int3
  36:	cc                   	int3
  37:	48 89 34 24          	mov    %rsi,(%rsp)
  3b:	48                   	rex.W
  3c:	c7                   	.byte 0xc7
  3d:	c7                   	(bad)
  3e:	a0                   	.byte 0xa0
  3f:	75                   	.byte 0x75

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2
   2:	48 83 c4 10          	add    $0x10,%rsp
   6:	5b                   	pop    %rbx
   7:	5d                   	pop    %rbp
   8:	c3                   	ret
   9:	cc                   	int3
   a:	cc                   	int3
   b:	cc                   	int3
   c:	cc                   	int3
   d:	48 89 34 24          	mov    %rsi,(%rsp)
  11:	48                   	rex.W
  12:	c7                   	.byte 0xc7
  13:	c7                   	(bad)
  14:	a0                   	.byte 0xa0
  15:	75                   	.byte 0x75
[  167.157828][ T7295] RSP: 0018:ffffc90009d6fa10 EFLAGS: 00010286
[  167.163765][ T7295] RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffffff81931ee5
[  167.171607][ T7295] RDX: 1ffff1106f236180 RSI: 0000000000000008 RDI: ffff8883791b0c00
[  167.179457][ T7295] RBP: 0000000000000000 R08: 0000000000000001 R09: fffff520013adefd
[  167.187300][ T7295] R10: ffffc90009d6f7ef R11: 0000000000000001 R12: ffff8881731be540
[  167.195139][ T7295] R13: 00007ffd1f891350 R14: ffff8881731be06c R15: ffff8881c6ef8138
[  167.202998][ T7295] FS:  00007f6019ba0840(0000) GS:ffff8883f1da6000(0000) knlGS:0000000000000000
[  167.211808][ T7295] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  167.218267][ T7295] CR2: 00007f6019b9fd58 CR3: 0000000248c0c004 CR4: 00000000003726f0
[  167.226104][ T7295] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  167.233955][ T7295] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  167.241801][ T7295] Call Trace:
[  167.244960][ T7295]  <TASK>
[ 167.247767][ T7295] ? __asan_memset (mm/kasan/shadow.c:84) 
[ 167.252239][ T7295] __fortify_panic (lib/string_helpers.c:1043) 
[ 167.256593][ T7295] xfs_file_ioctl (fs/xfs/xfs_ioctl.c:1420) xfs 
[ 167.262288][ T7295] ? __pfx_xfs_file_ioctl (fs/xfs/xfs_ioctl.c:1188) xfs 
[ 167.268213][ T7295] ? put_pid (kernel/pid.c:332 kernel/pid.c:459) 
[ 167.272850][ T7295] ? kernel_clone (kernel/fork.c:2559) 
[ 167.277398][ T7295] ? __pfx_kernel_clone (kernel/fork.c:2559) 
[ 167.282288][ T7295] ? recalc_sigpending (arch/x86/include/asm/bitops.h:206 arch/x86/include/asm/bitops.h:238 include/asm-generic/bitops/instrumented-non-atomic.h:142 include/linux/thread_info.h:126 kernel/signal.c:180) 
[ 167.287262][ T7295] ? __do_sys_clone3 (kernel/fork.c:2903) 
[ 167.292071][ T7295] ? __pfx_do_vfs_ioctl (fs/ioctl.c:804) 
[ 167.296962][ T7295] ? _raw_spin_lock_irq (arch/x86/include/asm/atomic.h:107 include/linux/atomic/atomic-arch-fallback.h:2170 include/linux/atomic/atomic-instrumented.h:1302 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:187 include/linux/spinlock_api_smp.h:120 kernel/locking/spinlock.c:170) 
[ 167.301866][ T7295] ? __pfx__raw_spin_lock_irq (kernel/locking/spinlock.c:169) 
[ 167.307276][ T7295] ? recalc_sigpending (arch/x86/include/asm/bitops.h:206 arch/x86/include/asm/bitops.h:238 include/asm-generic/bitops/instrumented-non-atomic.h:142 include/linux/thread_info.h:126 kernel/signal.c:180) 
[ 167.312252][ T7295] ? sigprocmask (kernel/signal.c:3259) 
[ 167.316712][ T7295] ? __pfx_sigprocmask (kernel/signal.c:3236) 
[ 167.321514][ T7295] ? fdget (include/linux/file.h:57 fs/file.c:1161 fs/file.c:1166) 
[ 167.325444][ T7295] __x64_sys_ioctl (fs/ioctl.c:52 fs/ioctl.c:907 fs/ioctl.c:893 fs/ioctl.c:893) 
[ 167.330078][ T7295] do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94) 
[ 167.334451][ T7295] ? do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94) 
[ 167.339007][ T7295] ? handle_mm_fault (mm/memory.c:6274 mm/memory.c:6427) 
[ 167.343810][ T7295] ? do_user_addr_fault (arch/x86/include/asm/atomic.h:93 include/linux/atomic/atomic-arch-fallback.h:949 include/linux/atomic/atomic-instrumented.h:401 include/linux/refcount.h:389 include/linux/refcount.h:432 include/linux/mmap_lock.h:142 include/linux/mmap_lock.h:237 arch/x86/mm/fault.c:1338) 
[ 167.348872][ T7295] ? exc_page_fault (arch/x86/include/asm/irqflags.h:37 arch/x86/include/asm/irqflags.h:114 arch/x86/mm/fault.c:1484 arch/x86/mm/fault.c:1532) 
[ 167.353412][ T7295] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130) 
[  167.359161][ T7295] RIP: 0033:0x7f6019ed0d1b
[ 167.363441][ T7295] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
All code
========
   0:	00 48 89             	add    %cl,-0x77(%rax)
   3:	44 24 18             	rex.R and $0x18,%al
   6:	31 c0                	xor    %eax,%eax
   8:	48 8d 44 24 60       	lea    0x60(%rsp),%rax
   d:	c7 04 24 10 00 00 00 	movl   $0x10,(%rsp)
  14:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  19:	48 8d 44 24 20       	lea    0x20(%rsp),%rax
  1e:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  23:	b8 10 00 00 00       	mov    $0x10,%eax
  28:	0f 05                	syscall
  2a:*	89 c2                	mov    %eax,%edx		<-- trapping instruction
  2c:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  31:	77 1c                	ja     0x4f
  33:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  38:	64                   	fs
  39:	48                   	rex.W
  3a:	2b                   	.byte 0x2b
  3b:	04 25                	add    $0x25,%al
  3d:	28 00                	sub    %al,(%rax)
	...

Code starting with the faulting instruction
===========================================
   0:	89 c2                	mov    %eax,%edx
   2:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
   7:	77 1c                	ja     0x25
   9:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
   e:	64                   	fs
   f:	48                   	rex.W
  10:	2b                   	.byte 0x2b
  11:	04 25                	add    $0x25,%al
  13:	28 00                	sub    %al,(%rax)


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250630/202506300953.8b18c4e0-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

