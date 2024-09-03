Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3EE1CDFA0;
	Tue,  3 Sep 2024 05:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725340729; cv=fail; b=n/nSAtvWb3mbgz/hF9CgDQUtkh5BSAN+1E/R+4vHycPw3KIGLGWcydZcADDCJ9AhwDV+zAvQFBjbx6wQKyw9Jv+7fli2QjJjeNeyiA3jPsIYB8xNwfjUMJNTKCUvfGCxW6ZdoBWZu88tTKxG8L41k8wvA8fAxIEAB8t4PIuF2YY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725340729; c=relaxed/simple;
	bh=1nBdoHpNeaSAgnNCg7bR+LWozK6ioo+mpdyBU8Rd79g=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=j38RaBfMcDW/SPvDArbRh2/wBAk9APtZ7bF1dP4RUWeYyLSvQ6U+B4rU5E0KwHrqXKx6LMNBBh8ql4uDDOxb0T3htG1WHkeR/k1kTHvA/3x9esxA6138P0GHV50ombsfFek/ad4VQrOrwtLLLTkcxmYwHzp/4oyeJplS2JRH+5U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gFLb9QR/; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gFLb9QR/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725340728; x=1756876728;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=1nBdoHpNeaSAgnNCg7bR+LWozK6ioo+mpdyBU8Rd79g=;
  b=gFLb9QR/DaUvVgNbX4B9BpsULuo0XcyOOcHU9b/QyTEh4Cs1hJumV5Wy
   qxhDVaOEZMwiVfRAuKm5X6YrpaYVhpHktyKNgY/1NxA5k2oSTdTrse3Gl
   R12cgzdkKVfjj7aDidRWeXLqHHNzOXpdPp7QviIWUlRMGPrpNDx2+0KbK
   ahxvo4naQXL0A2wJq5eQQkGa76nphLLTr80KTdlKGd9rhOV1Rl+h6o0Zb
   AL7+Ou7713ItbG5BbLg0BbP8gSJKqjF0rsAOm/Gx3DC68lvvWMOGII2C8
   +kgnSBD9B4y873MUrvVyMSO/1VqxLNsxB+08QjCRkqKGPs66byX0xK4h4
   g==;
X-CSE-ConnectionGUID: u/5OIfxWQO+KaPybwrtG3Q==
X-CSE-MsgGUID: KsLDhqXnSPWjXSEFVNbLcQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11183"; a="27709108"
X-IronPort-AV: E=Sophos;i="6.10,197,1719903600"; 
   d="scan'208";a="27709108"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 22:18:48 -0700
X-CSE-ConnectionGUID: /Se7nZ7EQ7iDoRYsoNojsg==
X-CSE-MsgGUID: 26jRh62WRHiIAh/ReBElVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,197,1719903600"; 
   d="scan'208";a="69152397"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Sep 2024 22:18:47 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 2 Sep 2024 22:18:47 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 2 Sep 2024 22:18:47 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 2 Sep 2024 22:18:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nZOXpL0W+tSHKnM3O0Ruiq002cvCjoTkJARJhfQI5RRK19ayZIhPtEIyQ6uOG4pVc8gtEIp2pqiFrOlgFBl/XW5XEScpSyPJHgtLc0yi71ZC4cbnzlQQ3jRl+SePcXJZ5qBZY8ODT76QVExNfRhBkArZV3uXLd9UGNk/fc3c79cVwlgoCXixAtH5xQ26KBh+eqlhU0qp0L3dXTTyd5Q2OHPlNuQ53l691pjaHU/6ktwG/Gb2k+QBHPIOsXlcsOuTcWM6V85WY/EdAaX7iYGFfI/uNF5I/vYZ24M0u5VhwskThYO1tJ0gIOnxHBJs1MggnrTzNku4k6nqpAy0ZLm9xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BQDPJv3lximQT4TBzA2e31W4OXIevc9sk2908ierYHI=;
 b=TKC9xuX2F/icKAtWbdYpfa+qFbmVCqWfAwyMGv7r0sDl4Qb9REVogBziFNCrqDuPTphY2Jf3d2VOrPAM+GzD+yx1TT50+r+8TPfn6qP8z4s91HT/zmlxPOqGN2l92clE+CWGgbvr+q8pNcsiOE6MzZnPjbxXzfsM/fJglc/CSAYfgta+OZ6JKO7aAx4et13y3xeMHWd1G0Au60odD5vGQlysJuSSHFKg95qdqlQMr7kIj7dL4f9SkSPkvF/kzgeCRnC9ijy7cy+rmc11/sH17Xdzbg5i1mMb47hrQyODI6KF0cYHqjIXusqTRjim4cj+AMOgfebmuBkFUsTa0u7wnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by MW3PR11MB4700.namprd11.prod.outlook.com (2603:10b6:303:2d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Tue, 3 Sep
 2024 05:18:45 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.7918.020; Tue, 3 Sep 2024
 05:18:45 +0000
Date: Tue, 3 Sep 2024 13:18:35 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Zizhi Wo <wozizhi@huawei.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>, "Darrick J. Wong"
	<djwong@kernel.org>, <linux-xfs@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [linus:master] [xfs]  ca6448aed4: xfstests.xfs.556.fail
Message-ID: <202409031358.2c34ad37-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SI1PR02CA0028.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::6) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|MW3PR11MB4700:EE_
X-MS-Office365-Filtering-Correlation-Id: f7bb20a1-9623-4f63-9b62-08dccbd7e1f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?DN4y6Qna2rNtpHlM3QcvEIeuBIj2hEQKyZ+IL8l00/yYg24CwqZ2FGJoFI7E?=
 =?us-ascii?Q?rsm0DFoMHD+RtU1qT5sxJkiB9o+U3XT823+ixtJEpHzDe/LqBQ1LLpJlgfWZ?=
 =?us-ascii?Q?stxQb43B7orfWOb+XOr0RHicjzKg3k066tvqGv7Nkhn1HYGObO9zXz7pUG4r?=
 =?us-ascii?Q?TgVLP6zoQPqBxbjr9I9eAnQqoY3dbZZ/eXKQC0qEjJBTLVzL8aXtWbTqvY0H?=
 =?us-ascii?Q?/rP6Y3+Zvkdwd8lQRB8k7EA3Doq+m2B1e7aXtRARbc8kjJTJyrw4xQyjatTG?=
 =?us-ascii?Q?YTjK8lno0rR+/lrzWFrFS1S3bCKTCUNFLBjBgJKKb2V6jjaYk7685ppZxCqK?=
 =?us-ascii?Q?XxvNHqs2btmUKQr9F5NqH27ROH1s0mGS4p2X79zPcDGwhWCPeTNlWZKi5pOA?=
 =?us-ascii?Q?j4puvGI6sbjWSbval0Z7rJFDFa8UyZJInZzCN1XfmlAbI3g0m8SYqAcjjWdE?=
 =?us-ascii?Q?dWunf0CMl+HOC9nJ0AJbm7DTx17GrCM537ix3hepMp+V4vr1TMOYKvrmhBxB?=
 =?us-ascii?Q?SPSDwMDpXIQB1NkcuC6GJeKVRj5nKneHnVDc30xCub7fe1jzUh/2tRWTdBkm?=
 =?us-ascii?Q?vblq3S9UXNwsnTCZiNLp0y52TLSsB1W5tvphJnfjeeB3kk96rT06V1imh71r?=
 =?us-ascii?Q?HR4Z4hqVQCCzuTc7NVyufNY41nuutq/3CXeEt0DAE1fTMgD/AbGCaf4MoNK3?=
 =?us-ascii?Q?yYhYdAxSYDwvityNTz8c2RjeRyT9j30A64p2Q5oLaZi967Ug3n1gfCvyGRWj?=
 =?us-ascii?Q?vGpjKHXuTHstNoqGvYwEaVSOcUCQTTteTdnoy9oiizu2nCv2tKgWuu+KGBh1?=
 =?us-ascii?Q?vGEQSTswMW3hKQVgtdxKH3NsvHWFRyWlAlT0OYsUc94JyhZebo/UflxHIZ53?=
 =?us-ascii?Q?YaQJdUGdnak/xhOSb1FhjKb0UzI9Cop51DBEHC35/eTCXA4orCQ00b2u3Rwc?=
 =?us-ascii?Q?vnbVGiVN0833ZsgNg1/qMNcRa7HLQJ/BCHy/byYJLWu64Gs1UU1nRC+AwhiK?=
 =?us-ascii?Q?T8G1WO+mpaGCGR9LsOuS68iR/q3yXfoXY/m1YGMfVdI6v6rkAesXP5SbQyME?=
 =?us-ascii?Q?IlM/ZIQrAEjAUvZNsMgcxZWyYWD2DJiA62s+scx4R8M4yZM5N/GMt/rvodgj?=
 =?us-ascii?Q?6DMgQJuLTPntbN+Lh9LqP1i1NrXAP0oXr0pHrH/RjpF3ZVZXYMCJH/b4AExT?=
 =?us-ascii?Q?DRIWS8H9xcecrqI0Uwed1PwlcSlE3lUvrAXDdu/FF3duL67C+YDv0VAYME2S?=
 =?us-ascii?Q?jd79GrrwdZ8iJ1t7p29ABDS7Kab8EznkKLmwrMmSNo8ajtv7MTIbTkhyeXaf?=
 =?us-ascii?Q?tmEUrRXm2RjSLmJexE+YmWWo?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YgBq5shLTRkNiJmjwS/fUN6pb27f5tjRbtWh2N4CDZwk8O9xXXjMJKSkkskv?=
 =?us-ascii?Q?ax5L81zAtw6CpY4iRilxioRclOaRGQM5QWHzZdn9kZh/4zwA74RAZX4v/6RA?=
 =?us-ascii?Q?BYgGLMhvYCfZumaK0uBhoVxu43WKFUl6CQV4/GyMx3j976zmeSM1etIcPeU0?=
 =?us-ascii?Q?bEd77iBVZ5tXVjt15sz7zsJzjrhPA/IOC+2DWTyhyS+8Na8qWec1kAGFQR4Z?=
 =?us-ascii?Q?3iOhN8uhQtNxsvpD9F3iKjBpuzm/jU/gSBJPEVwV7KSP2oJy9JltEpZj6LFl?=
 =?us-ascii?Q?oIZtq7z0HdC0Ot1elnqMCHRxg7yajRkX/WGWlT9cvF2PQyYJvYKObBu8foli?=
 =?us-ascii?Q?QHwJ2Ysb4zbk/MeF3qOyrtGCQQ0kw4ThXdE0b+BvNGjXFS6iyvju5LBk41E2?=
 =?us-ascii?Q?hLi5ORPFILIwptPBvcYEJs8IUeiS+CuoSZfOvmMjElbzG6aT/50z0QbnUcIX?=
 =?us-ascii?Q?Vd/E5XmlngUJYjaw6R999ZysnSfZB666m+Yzyb4rAV10uvWgagDeGHb1NcjO?=
 =?us-ascii?Q?c+A7k3vfRhyxPGVzvTmZQomOT7G2DLpRJTyy4zreooq6tjvtotYlaRzlRees?=
 =?us-ascii?Q?mqE78Ps7LzepZ715c2+xBQw+rONCf9zGhUISXAaLaQIGh4qMLplW835jHKeO?=
 =?us-ascii?Q?FcE0FzlwY+eDPAjoXEeCkzG+kUlIdw5RQm9aUFTgH0u+ijsOWs53mYVHvSip?=
 =?us-ascii?Q?j9RIx69D405HbSQm6x4jseeB2/+X7JDGVKvA8Q8yZM5lDZTzRNy58TvUBBsi?=
 =?us-ascii?Q?Aa1QwGQh+BtqlCSQzWWzfqmg7vDPrGHu6GaOMDkHG8G3FBAr9a66mc0qfodr?=
 =?us-ascii?Q?SrisgBeF/6ln76g8ADYRWWEer4Nj9CNEB9Jc3jFQu1St4cZHbx2k4BE9Jfi+?=
 =?us-ascii?Q?mrtVSYBARdvMtvQgCh5G4OieHIVM7ipivreKqXHbMI+NNFiy4vLlOkS33bTV?=
 =?us-ascii?Q?MfDOStspbNIczsXmisroj/3VKcRXtUg5M3DcDZC8ChH8RExoaXNzJyIv4zR/?=
 =?us-ascii?Q?zcngnZeweT2k/jxRIin8aYHtSytpskIdvrJXn41xH6sASipiLtLuLxbJAAZM?=
 =?us-ascii?Q?GyjipSvg42gVS3od292rl3TVYC1/Qa60Z9zCAumh5VbH5sc7rDL8+gKoGeoW?=
 =?us-ascii?Q?ksh++yXW2SKMuwQ80QKxeBfJ9tu6VEh3I1wyKlrxlYz4eyMMQVKJWOQXS5Pk?=
 =?us-ascii?Q?LUraP8MdmOfIbd7MvG7vNHez3srgQdof4hLnx87F8ODqutBXPJzPotdmDZqe?=
 =?us-ascii?Q?Z6Kc0SgaJcv1aAGo/F8tDcM64b/HcqAisxym1Jc06T28CeqrCI+WipEcOVc3?=
 =?us-ascii?Q?P2AcNWEY5fsLKyPV4QpHlyg+79XU2CojwTcDTusEmktPFEnCY+4kkKpfPYcx?=
 =?us-ascii?Q?9ys63kUNbxm7VbiptOWo+nFUc/2NL3MwtrU2RHguOaDPoad4fCqqlzgNyzyR?=
 =?us-ascii?Q?9JLXba9iec+zR6fFKxQ2NwXjpWYChfKq0Mf+VffS04ReSJ6C59rFnC7yB/H8?=
 =?us-ascii?Q?cpxIqQuhkxr1yUyAyEEsYWqNRv7Oqw7f7vrK7jCvxG3d3vsw48tHZtwuXB7I?=
 =?us-ascii?Q?ckne0e1kRcPXsXVcvgdCO28aanqOS1UTAUw1It9DApI9pwn4x9jn1R7i+aVH?=
 =?us-ascii?Q?dw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f7bb20a1-9623-4f63-9b62-08dccbd7e1f2
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 05:18:45.0193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6/KlBGeQtIHQmCFzsAgKJeOPWXJVU4XWmJIlEzobyvG0O3j2Q3SnDKx9PmHOA6F5TNwRJEUSyUvQcx+GW3PoRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4700
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "xfstests.xfs.556.fail" on:

commit: ca6448aed4f10ad88eba79055f181eb9a589a7b3 ("xfs: Fix missing interval for missing_owner in xfs fsmap")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[test failed on linus/master      431c1646e1f86b949fa3685efc50b660a364c2b6]
[test failed on linux-next/master 985bf40edf4343dcb04c33f58b40b4a85c1776d4]

in testcase: xfstests
version: xfstests-x86_64-d9423fec-1_20240826
with following parameters:

	disk: 4HDD
	fs: xfs
	test: xfs-556



compiler: gcc-12
test machine: 4 threads Intel(R) Xeon(R) CPU E3-1225 v5 @ 3.30GHz (Skylake) with 16G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202409031358.2c34ad37-oliver.sang@intel.com

2024-09-01 09:27:55 export TEST_DIR=/fs/sda1
2024-09-01 09:27:55 export TEST_DEV=/dev/sda1
2024-09-01 09:27:55 export FSTYP=xfs
2024-09-01 09:27:55 export SCRATCH_MNT=/fs/scratch
2024-09-01 09:27:55 mkdir /fs/scratch -p
2024-09-01 09:27:55 export SCRATCH_DEV=/dev/sda4
2024-09-01 09:27:55 export SCRATCH_LOGDEV=/dev/sda2
2024-09-01 09:27:55 export SCRATCH_XFS_LIST_METADATA_FIELDS=u3.sfdir3.hdr.parent.i4
2024-09-01 09:27:55 export SCRATCH_XFS_LIST_FUZZ_VERBS=random
2024-09-01 09:27:55 echo xfs/556
2024-09-01 09:27:55 ./check xfs/556
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 lkp-skl-d06 6.11.0-rc5-00007-gca6448aed4f1 #1 SMP PREEMPT_DYNAMIC Sun Sep  1 16:52:26 CST 2024
MKFS_OPTIONS  -- -f /dev/sda4
MOUNT_OPTIONS -- /dev/sda4 /fs/scratch

xfs/556       - output mismatch (see /lkp/benchmarks/xfstests/results//xfs/556.out.bad)
    --- tests/xfs/556.out	2024-08-26 19:09:50.000000000 +0000
    +++ /lkp/benchmarks/xfstests/results//xfs/556.out.bad	2024-09-01 09:28:17.532120817 +0000
    @@ -1,12 +1,21 @@
     QA output created by 556
     Scrub for injected media error (single threaded)
    +Corruption: disk offset 106496: media error in unknown owner. (phase6.c line 400)
     Unfixable Error: SCRATCH_MNT/a: media error at data offset 2FSB length 1FSB.
     SCRATCH_MNT: unfixable errors found: 1
    +SCRATCH_MNT: corruptions found: 1
    +SCRATCH_MNT: Unmount and run xfs_repair.
    ...
    (Run 'diff -u /lkp/benchmarks/xfstests/tests/xfs/556.out /lkp/benchmarks/xfstests/results//xfs/556.out.bad'  to see the entire diff)
Ran: xfs/556
Failures: xfs/556
Failed 1 of 1 tests




The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240903/202409031358.2c34ad37-oliver.sang@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

