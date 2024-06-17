Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0B0171B0;
	Mon, 17 Jun 2024 08:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718614161; cv=fail; b=W6biJwtE7HfgLzr/1CpXz66cleE2TX9t5tKiRb0HVDXWDkX/GEHgBFu0TR3ugPggFEeDnL4/0/HB8lxvKW6TVq13KhNXr9zbQzKeo/HvCN3UJk9RxXLogqHMfXVmj2oOLgTGTuC80WuFIe7gatVk6Bg4xS3j9OoH///GXi97JGI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718614161; c=relaxed/simple;
	bh=ZbZ1x7QdpqlO+2OcpqX47AD7s0QFbpRtamKZ1dKnhCk=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=qKMIiv2yuPFWrTvnkc00jQ3cOGxe+imv+S4nODirfTMlfUHRf6ZOacl+xV1dKgRB7THvp/k2fTUnmIGKE0qNWddbp1zofq+3mbkRethF81TX2gJoZuZlejbDNRhbzUxEj7MpPTyPnW0lDELfRAhqj5B5ZzjCrB/0dwYySKnKPxQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EHrrwdTs; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EHrrwdTs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718614160; x=1750150160;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=ZbZ1x7QdpqlO+2OcpqX47AD7s0QFbpRtamKZ1dKnhCk=;
  b=EHrrwdTskJG3is/XsKWcEPUhn84e213a5a3Cn5RI5k2ztF3JamRYyV1G
   1/jLrvoh3ZEeCTIB0SifVmC0Z0Utr/hza57D6WuNgjhL3kCIOUeUUqNMS
   oJMz6FK5S+w7xwKJ8ziffZE5iTdjyA39TTocA+zwOXDcOcNOX0aady8o5
   Rs+KhZ1sPW9aVXI8xgfFqmEI6Ej/ywxyH1+tsUTcrghlnHFoV1ATyMTnN
   +rbT9IQAEhpkZzJcoDdTxJ3EgvH0ejlnPX/n9UtOABqUnlyCRxUQDkpt0
   wTMQh6NE7hdTQXDBBmwhsh7GV71EKd4U8in6EeKJPFIPyJ+zuuEK5j2Wv
   Q==;
X-CSE-ConnectionGUID: X0o1gCNuTyu3HenisqP5IA==
X-CSE-MsgGUID: hZ4nAzWaQ/mC0cxkpzyscQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11105"; a="18349577"
X-IronPort-AV: E=Sophos;i="6.08,244,1712646000"; 
   d="scan'208";a="18349577"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2024 01:49:19 -0700
X-CSE-ConnectionGUID: hLxLHqyQSTKS21G+pyeyEw==
X-CSE-MsgGUID: 9M+AfM8QQ8GeDtAeL2wWgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,244,1712646000"; 
   d="scan'208";a="40984828"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Jun 2024 01:49:19 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 17 Jun 2024 01:49:18 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 17 Jun 2024 01:49:18 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 17 Jun 2024 01:49:18 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 17 Jun 2024 01:49:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iuVdhlbqH7OoKhR1q6QAPvl6ANgBbKnl+WlPT2dCa2zZD0Edb53n9gu0h145MiP1V1evE9nbeLKfYsjtQ5aE/1yHtqoA0cFa2cjN9h+XPTPo5BkjWoyUoO9nYL186K8C01X5P/nzJUgpFWoqPfDYbAfo/gtNisbPHoRsVMLf2M+8NVOjKw5HJbT1Xbla3Ppq0meMuwNtsUCNqGcYxbQLjowUEs7NBOwEcjPW+98OJUrQRMSgvXqA1YZnn8LmZzyM0oDpiujZz+8TATG4I6yef9W3WHSOv/4RsPgbDl4x2Sbbt5NevjduHcpAcxwew024oRpLQc7IHxT0TLqPZO6zVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i6h6SMEocVdpXGK81pKeoocmVo/dOyG3f099gZZZvmc=;
 b=naXOpAuVVHfgrSkii0+FctBndRGa96NSmF6iLVlB7XuSKVTorgxIasr63/LlnlbuDwgJQTpMsQo5jmnCkvK0UvNgm1DwCupr4RjJLr6YZ/gh2pNIcp3Fo4BOxHzldK5PSuLnCDCX8irVHsevIcSw+2Vgdw/PrUxYup9liNesuf0LOFeqoNR8iwYfbhlvW9uMvDodaSMqZKQljnsgQU+2gH9niDEGlDddyEw4LxT2oDn9kGmgcZsQLy4VarVIAOEMT7WUmKRh10Dt9jHfn2YNmHdAmuU3V3yYmNVt/CNq956vu9f10WanaUsft44RgVh2wm7GgV7+/OkWIhjw+kklcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by MN6PR11MB8104.namprd11.prod.outlook.com (2603:10b6:208:46c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Mon, 17 Jun
 2024 08:49:15 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%2]) with mapi id 15.20.7677.030; Mon, 17 Jun 2024
 08:49:15 +0000
Date: Mon, 17 Jun 2024 16:49:07 +0800
From: kernel test robot <oliver.sang@intel.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>, Christoph Hellwig <hch@lst.de>,
	<linux-xfs@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [linus:master] [xfs]  38de567906: xfstests.xfs.348.fail
Message-ID: <202406171629.fa23d1c3-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SI2PR02CA0048.apcprd02.prod.outlook.com
 (2603:1096:4:196::23) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|MN6PR11MB8104:EE_
X-MS-Office365-Filtering-Correlation-Id: a4e4a443-c702-4fb6-3d72-08dc8eaa5e42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|376011|1800799021|366013;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ifUwyCzeeFKJwNEWAqtKkgg2ZD2EB2IeZbvpWE/4eiOAf8bPuUrSgyQeA4UI?=
 =?us-ascii?Q?wfYyAZwA0gjNLVxW48nMTwh4swqSTnoMvm5nt73nbQRB5cO0W2pCt0eAzZV6?=
 =?us-ascii?Q?332qdvz5HtBFAb9F0yj9l21M64EMQLu+i+ocrTNbbhsjZDE9zTotbPP1zNM8?=
 =?us-ascii?Q?HK9fyYfgmZsihs+RWHBRJYXJlK6wAV5dRx5WdB9bp9NnEaZd61Z6/ABhQJlQ?=
 =?us-ascii?Q?SdiUBPqjaF3WnMJCQwwqrGEkX/5etzIU/bMnkchbLW3lzTZkBlw+Vc3+oSlA?=
 =?us-ascii?Q?jbDmMfUbLuSiP/sVTUceROBF85gr67RgApGdLDu8AO7S3PRi1v2g9iYoT4uL?=
 =?us-ascii?Q?pkDMGVns+tm35vu6CDhcybpKS+yDU6xivhVLlxD9HCmnSTL8FYp76Tkbvd/A?=
 =?us-ascii?Q?Gzc329j5CVhCWakQ7QI6gswh+R7CmuvCN2hq2fUuKnUugmI75+eAZXCOR4tO?=
 =?us-ascii?Q?0pHdwk3ss+/zIMxl8Brs4bMegGznEd5uyl//EndD59UJH2dGhSXOjy5ylRrW?=
 =?us-ascii?Q?5aj74ELvbGvzpZdyLlJS/nGUOM9663RpYGmvBiGMoYnCWu1NPVgahGFQwwUW?=
 =?us-ascii?Q?3lq2eo5ujo6kI1jcjfKI+l8ASCprDFDCVfXjWB/f+B+e/UJLNt/q9ANwZeB5?=
 =?us-ascii?Q?TWC0iIg1GFFCiai7Oqin/BOYtXhISvScb6XP1efDju5rjxhgju9XAGUsmM6l?=
 =?us-ascii?Q?pOHMzEeAh44C4Bm9MwoVlwKQrsSnsMcXnnI10lExgsmSGf5ddrHnXwKs76Fd?=
 =?us-ascii?Q?vMcTPP4sNsQnw5vMFMXDr4frhOzuQhMUSBQesQ0h6yAcXs+BgzBWgSl9lMaR?=
 =?us-ascii?Q?HA/iiP5vZVDXv0O0tSSRejg96HDGse9w1BK5Fb17WvHfRFxmJqTum4hUmH6M?=
 =?us-ascii?Q?uHf2fTLcrOMg117vvk2G3s6oGXiAy41mmOgWyKZwCTIBKVVK73ZeX5A2J640?=
 =?us-ascii?Q?xpDZDLLBSrsuxtxwluxlYYe0NXbfDVVnqqxefZxUHEngJa8h/Ilso5C6up2s?=
 =?us-ascii?Q?6PRFvDd7fhYAjdDj5t2KQ5exKgmEbGY/CYjnOBl2W+nF7mRQWZKhZ0IHVMKM?=
 =?us-ascii?Q?zSBG7X+KsFTZ0ToP/UyaF2BKdOvKHaLyBFMCBNrvugMjXQm28UbZC4NPhoCi?=
 =?us-ascii?Q?rihM7L8F7CPyyO3IMoAIuhFLjrJHD9kX6EbvKUA1sLzcs7opYIeTsYSpsKt7?=
 =?us-ascii?Q?XgnthPbP04UO6dt3dc2K2iTwnXY2zmM90PCk3IHEgHN+2DxiCwBba58jHsvw?=
 =?us-ascii?Q?fejEjX7Uw+qepHSFDWWaBuPLJjUNprgQ2uGQT3m8YA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(1800799021)(366013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LC0YlvOOSCSiWHLiiWpsLMp+w2+I+ENQmD045waiqdbJC3fNFF37ZlIcepbb?=
 =?us-ascii?Q?QTc5Xi8aLZkNcVDTTDyhJNSRNVAFp5pgWlOaw5mXURIjjhvuLLrQZhmdzBMq?=
 =?us-ascii?Q?T6BVZc5hLGSS91UV4BRUxgiBxQsJ5FCEEZiP8MDw7VMf/5r3wtTOQZI7lQAF?=
 =?us-ascii?Q?9hVxev2DLGTZnb99OPGBYsgKs203HYa109qL+GjLvqD9dsD7CnC/IrtbgXhu?=
 =?us-ascii?Q?t1h2sKwMcKojZoD615BR1ia6BFwj+fuJr549CeUp0HZMoVnibDa+V2DS+qM/?=
 =?us-ascii?Q?Gl2ksWNad6XQ8qVCuJDaTF4V1ncY5UmameaX1eVZ2jr05QHh5WWRzytJol8+?=
 =?us-ascii?Q?+PFPs/ymS1xTp0ur3RkZYVbsc3tB3CqFwiOQ13E0xwNtN7C16OGloJ8IGFL5?=
 =?us-ascii?Q?O6zx7s9g0Jh3wmEPlIDjmfOFhSkny73bpjzJx8m3H9H0b8hwRy3tyhhRp4RJ?=
 =?us-ascii?Q?59q/xowgFeS7+DJ0qw8NLpV8svZTFddgdH3QrBkI5LOP6WEATNojfNeZGOfh?=
 =?us-ascii?Q?GVSeFGAzVBBs4mFqQUKVl1kk49GeStjAULkbjH7fozpz5/QcroAlT82HmV4g?=
 =?us-ascii?Q?hohEJgCFSNoX/umH7IMQh+Aj+W30K9YfTxqxC6X6DXbq53RVmiHi8YpxESrY?=
 =?us-ascii?Q?o80gicVo0oDFgv1nGJ4izc5e9t879nVrHbufOJxhGmCidY4MfPp+yz2cELtN?=
 =?us-ascii?Q?0+kfGoo/TkRgiNVt88Fyl0tTfZ0PkGHu/ykTCe0HEg7TxEsb1177fMPyLYKD?=
 =?us-ascii?Q?ExLuMBd6dY08DWxbUCy8lD8HUh2oz+elz9SIQc0IKXrRDhYGPvXCRWZX9a59?=
 =?us-ascii?Q?JBm3c1lzwxud24BeYqoErpDiK4p/zOIXCn/FHcUWFhulN36bf55482zZNoxC?=
 =?us-ascii?Q?qsCKeIQrsJIlJZoYERSFYBM8syEfSty4BELcM6srhChL04mYohWVAsG3ZBJ4?=
 =?us-ascii?Q?SElJbr3ttcozYTWDup/o12/Hwf1MKE1hrka9zy6gXR7Q7JeGWWwPYtKXenTs?=
 =?us-ascii?Q?L7ND0J2hg31BUOstP0N2i40G932A4rcRI0q2mdF3WZxuPfDu1efvQLWpK+tZ?=
 =?us-ascii?Q?KLW3WbAeetsJRzVvI3mlpX1JNaNbS26jF8cV+DFOEc2HxZEVwd093yHP5Aq2?=
 =?us-ascii?Q?H50TbIcM1VcFjz6fPeYLzEU2J5PRsmd4Yk6McqUyR6K6Mb+YUl9PaB634Q7P?=
 =?us-ascii?Q?+oYk8efOnnYTjs7sRRjxO1s9TeKsc+2AO2VjyExBFzuc8PUI6GwbXa2MBNi8?=
 =?us-ascii?Q?YrYXqwSNO4n8PM0JqgNm5SmTvLuM+JVD/9OFtPwBXA021M0drrN06TOaZDKE?=
 =?us-ascii?Q?8MmT/0YHfg0B10o2kWl7Bndh/RKMrYaC2NczNm72jcQhdMjS2iWIdX7YO66e?=
 =?us-ascii?Q?+RXP/Rpm5bDF0lFe0+fApt3Yxqqnc+Kbc5U4irFrL6JtNQw7bJmHPlFX3HpB?=
 =?us-ascii?Q?jgs8bevTMyAHxet19g1BL37oXt1HDG7z88N5RWfJ2wagHq5Kv24zPJKN8xAr?=
 =?us-ascii?Q?FjHsQKOMRiaADJ1It8etqx5O7CgFMV5jcRYoLOYTU7hIz+mD9HWcB6zes7IT?=
 =?us-ascii?Q?w9kF0I2ceIcwE4sIAdyVzhR6TufUEV89iH3BSZQRmHjRrZD3m1NcbyNadYvM?=
 =?us-ascii?Q?jw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a4e4a443-c702-4fb6-3d72-08dc8eaa5e42
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2024 08:49:15.7473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OjTR0lWxsekdk4bTeHUrck8R8U/8wutGVhld8Ts0V9fKB+S3E4F6s64ZHHnSGJFv5YutywBFhvnjdiicnl23DQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8104
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "xfstests.xfs.348.fail" on:

commit: 38de567906d95c397d87f292b892686b7ec6fbc3 ("xfs: allow symlinks with short remote targets")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[test failed on linus/master      8a92980606e3585d72d510a03b59906e96755b8a]
[test failed on linux-next/master d35b2284e966c0bef3e2182a5c5ea02177dd32e4]

in testcase: xfstests
version: xfstests-x86_64-98379713-1_20240603
with following parameters:

	disk: 4HDD
	fs: xfs
	test: xfs-348



compiler: gcc-13
test machine: 4 threads Intel(R) Xeon(R) CPU E3-1225 v5 @ 3.30GHz (Skylake) with 16G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202406171629.fa23d1c3-oliver.sang@intel.com



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240617/202406171629.fa23d1c3-oliver.sang@intel.com


2024-06-07 08:32:34 export TEST_DIR=/fs/sda1
2024-06-07 08:32:34 export TEST_DEV=/dev/sda1
2024-06-07 08:32:34 export FSTYP=xfs
2024-06-07 08:32:34 export SCRATCH_MNT=/fs/scratch
2024-06-07 08:32:34 mkdir /fs/scratch -p
2024-06-07 08:32:34 export SCRATCH_DEV=/dev/sda4
2024-06-07 08:32:34 export SCRATCH_LOGDEV=/dev/sda2
2024-06-07 08:32:34 export SCRATCH_XFS_LIST_METADATA_FIELDS=u3.sfdir3.hdr.parent.i4
2024-06-07 08:32:34 export SCRATCH_XFS_LIST_FUZZ_VERBS=random
2024-06-07 08:32:34 echo xfs/348
2024-06-07 08:32:34 ./check xfs/348
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 lkp-skl-d06 6.10.0-rc1-00005-g38de567906d9 #1 SMP PREEMPT_DYNAMIC Fri Jun  7 04:48:02 CST 2024
MKFS_OPTIONS  -- -f /dev/sda4
MOUNT_OPTIONS -- /dev/sda4 /fs/scratch

xfs/348       - output mismatch (see /lkp/benchmarks/xfstests/results//xfs/348.out.bad)
    --- tests/xfs/348.out	2024-06-03 12:10:00.000000000 +0000
    +++ /lkp/benchmarks/xfstests/results//xfs/348.out.bad	2024-06-07 08:33:19.134137710 +0000
    @@ -240,7 +240,7 @@
     would have junked entry "EMPTY" in directory PARENT_INO
     would have junked entry "FIFO" in directory PARENT_INO
     stat: cannot statx 'SCRATCH_MNT/test/DIR': Structure needs cleaning
    -stat: cannot statx 'SCRATCH_MNT/test/DATA': Structure needs cleaning
    +stat: 'SCRATCH_MNT/test/DATA' is a symbolic link
     stat: cannot statx 'SCRATCH_MNT/test/EMPTY': Structure needs cleaning
     stat: 'SCRATCH_MNT/test/SYMLINK' is a symbolic link
    ...
    (Run 'diff -u /lkp/benchmarks/xfstests/tests/xfs/348.out /lkp/benchmarks/xfstests/results//xfs/348.out.bad'  to see the entire diff)
Ran: xfs/348
Failures: xfs/348
Failed 1 of 1 tests

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

