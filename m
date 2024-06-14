Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8E2145A05
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 06:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718346259; cv=fail; b=um8RBUymGMlZqdNBh7PLI4d6dp4tuYdPlzf+pmgR+qAdjX8yvdmvxCQy0vqGX5lLHjKBvVy9rVD9H18dYY0ctS2glQp1spwK16xNOTiOKjxTVDbKjSKA5aNvEHpc3ABhOVQkFY9JZQMB+e4ZAQvtU61LA0kdc95ASfVxP1BXE7k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718346259; c=relaxed/simple;
	bh=cePnlbSKm+KUc/aeqc6KxXfpJqvdWRCDxd6pIMKxZqw=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=hnJv50hTyR3WtJ4q7OXL6iPgFexubzFZY+cmM3ZKlTK59N9NJWKP+ghVseVBMJ6jpdks8a/UNjBqcWXcYpVRiMh0Gq0/ePLQ0sPBvN09iIC8VZhQ61um72tiJQNS00UI1t3etf+/FI12St0t5e6sZ435UGy7MBz4f01L6d/Evs8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OvURfDBL; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OvURfDBL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718346259; x=1749882259;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=cePnlbSKm+KUc/aeqc6KxXfpJqvdWRCDxd6pIMKxZqw=;
  b=OvURfDBLuZd4CseVNiO5eSoAGqpaKWNzjjdh2HI2gUejXvTvwboH0z14
   ujMB9XnrLsSGjrRF5Ve3k2aOpP8HXR8CHwNCqYWlSAbJLd3Kh+qZC4uek
   KBapz3L1ZP4cBNN+0joDb4Lqr5Xe3p/j3gil0ni545oLrXvYHYzgqvIf3
   i4rGKtJyCBa/xuzd4qTFwzijOS5js9vOqf0JZqBgRSsVAHxX2MLbqO1w/
   aFFEA81eDXUO9FuukBhWEeoKzQoT9yx5f3sfWmkpYDDoJIjF6NRTUb5rE
   mIrvNjBloHtApTQlyDjRrJrVJ9Fg2+nibuia+NwYbRtxRG6J3PHy4m1xU
   A==;
X-CSE-ConnectionGUID: Km9uXD2KQBWctGQR2OWl8g==
X-CSE-MsgGUID: IaONAnD8QzSRf7WDhHFv4w==
X-IronPort-AV: E=McAfee;i="6700,10204,11102"; a="32695187"
X-IronPort-AV: E=Sophos;i="6.08,236,1712646000"; 
   d="scan'208";a="32695187"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2024 23:24:18 -0700
X-CSE-ConnectionGUID: RiDOUSrCQU69gmZorlg4eg==
X-CSE-MsgGUID: I3y/jrpRRtSHKXQEJ0bOWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,236,1712646000"; 
   d="scan'208";a="77876010"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Jun 2024 23:24:18 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 13 Jun 2024 23:24:17 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 13 Jun 2024 23:24:17 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 13 Jun 2024 23:24:17 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 13 Jun 2024 23:24:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KAzdI0RbApQc1iTNElZZph08dOjpVG6hQ6NXhOaBdBiI43JzltWHKTW0H8+Leb6fHTZXR0oByFnyKfKp9sFoQkE2hoYcLaItXW+6thhRRN/w8ypPAmOKWD7Iz/dOp7RHk/cx8LZF02CbtpCb/P2xR3sGgSZndJFu6r4cOKZiMv3v13DnvFrtZdM9MDWLzd8TutGaieASPvnD8q9CpCHeE06ZC1KI+tUBCrBUTCRZ1JYaLqB+jjFIScUHkseYej0nDDsiXdUZigG0qSPDU4PMa/z9Koy12MS8AHSkPg9xuc3NP5iLwpM9s30fUUcqql1aUTY4d0zFnOMr3sw+zez/Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gS0wsYgsnf8qnpGTFsz8FzKQGB07cl2SLNIZ49jHuZw=;
 b=YAs9LHsogdMcje0jKcH0QmrA/7aqqfz9hNKQ3IZNcUsWqwlTuYTfZ4h4XHryBbfkWpnvC6ZEg68tADmjKyunv8FZuXvT7VSAeXpKoKnyop18mhnlrk3KVllSqT5xevDju84WYiIjDvZOZs6r3kPH3M3jlS5P6alPkyH8WEK6pw/5likmnOLhciAzg4w9fS5jRLURleI7KKH2duzjT8iAWw7x23WygUr9RG4zk6xJiurFdd1KF4yMnWkRHJlSJTkeCbd7m+tcuZ/2cjJ7O/Q0/m00UjUBodUz/iMSjb2HhWtSiUoqvTwdHg6ptU1M+sHouYSKOLSNd+au3z88IjytAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by SJ0PR11MB6671.namprd11.prod.outlook.com (2603:10b6:a03:44b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.21; Fri, 14 Jun
 2024 06:24:13 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%2]) with mapi id 15.20.7633.037; Fri, 14 Jun 2024
 06:24:13 +0000
Date: Fri, 14 Jun 2024 14:24:05 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Jeff Layton <jlayton@kernel.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-xfs@vger.kernel.org>,
	<ying.huang@intel.com>, <feng.tang@intel.com>, <fengwei.yin@intel.com>,
	<oliver.sang@intel.com>
Subject: [jlayton:mgtime] [xfs]  4edee232ed:  fio.write_iops -34.9% regression
Message-ID: <202406141453.7a44f956-oliver.sang@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0044.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::6) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|SJ0PR11MB6671:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b3b161d-ab5b-459e-9b29-08dc8c3a9c05
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230035|376009|1800799019|366011;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?rh8+UBLLdI2cuVPqkjFVnHHdFttlxZ2yzfkd7LDAnfBVaCP80suC7afBT1?=
 =?iso-8859-1?Q?zgQPcGZoG6IWhnxSRHBsH8T48V9kFAcdBjDW+SbpfWD9En0SDYlmcLT8LP?=
 =?iso-8859-1?Q?qK8pobwQwMBkkNTqkedWUEHyxN7bZJzYSESwVgmd3CoVBEaH6gXoOtg91c?=
 =?iso-8859-1?Q?r54a6Jr3tqQkrPO6iJotUboglcikB1xDiuuB5KBWtypiLfFi/gya9bzslo?=
 =?iso-8859-1?Q?APoaTuJZOGb1mN10Zp1LJtqzlMxEZ3yrnontiO6DJfWanjDaGglPgBprB7?=
 =?iso-8859-1?Q?+7l9IgXeben+8ijouPoPce6AM9Di4rdeZ5tmTSBWml31kZYvqzc5MceVfy?=
 =?iso-8859-1?Q?PNDORIG9lMie6HpAW4LQd91BYypLUUx7Ka5o+yr7mM6dSbJ6MewUDHb7F4?=
 =?iso-8859-1?Q?Fpx1IcLHSef87+ksgBnFGtM6F3ZAvXDOnASCddFbLrDtAzxq/i1uBMBsvP?=
 =?iso-8859-1?Q?02w3boqnckDDrl1bHiGWppl2+SsCllZySxMfXfHMBSMmReBMk9AI3aJxXJ?=
 =?iso-8859-1?Q?b5ttg/O488EaEPTUlTL1N2Zg8duLZ4GQiYrXbbDHUwl5wUVR/N7afBYZ+e?=
 =?iso-8859-1?Q?lvWjZ5/qMFrNtVg+Tg0kgiS0FJ0QgoPh+cqj93EnxbqVUQfQ1tiK9PFD6L?=
 =?iso-8859-1?Q?cVRIL4Rehp6NwitIKgF9HCqVlJYq9v40mTGhvE4CSxGEUF4y4yNyqu+GR4?=
 =?iso-8859-1?Q?aJpFiGe2C3RTEI4C3O4uNuPHGkEUEzVRrOXcpQkq1R3Gzqpe2XsysS+7t4?=
 =?iso-8859-1?Q?IdR0OUCiJEI9+PEn2RVXOzLVMazfMhQtvkdOLFX65z8+t49J+ZWgHJZtzU?=
 =?iso-8859-1?Q?PMy8/4W9MHC6UaQ/klbKpToqd0DFqaZM5UCYtiWn9j2oGWZRgHvE695FCi?=
 =?iso-8859-1?Q?y6wzwQ1EpHVeJcXyW70MYJFYXUbWsjwOkveYlO9NxYCfGTEz4pxf3u+R0Z?=
 =?iso-8859-1?Q?BBsHbACOXlkNzE4zlf+1zH2nKwZ3kvWgI6Ek9xWJI/kReGmfeEA5S7j+A0?=
 =?iso-8859-1?Q?wdqMZqIIr1dgiaemueoip4v1Iq2nKqkMbgeyJ1eigVKY+pvsv9lS3vD3IQ?=
 =?iso-8859-1?Q?6rmtExl90cEc8gLCAg5mBq7V5QFpJG2q7L1/MQXSEaFD7rlL+CD9uWZkAa?=
 =?iso-8859-1?Q?VuR8ah4K4wJvVS979wfjgcdYxOtP6GaTD8I6ChjcQ7B1fCusce8gQRxbtn?=
 =?iso-8859-1?Q?Uka8ghMCOB5qdftYzeymKwVrjd5CEn5jeVUmPdE9nnCdF5ZezjQLjAwhKc?=
 =?iso-8859-1?Q?71bn4LTe6pXRevlui0N526hcPkeRDXKB8h1p8g/g7JWQJt9W3ey93DJvlp?=
 =?iso-8859-1?Q?PMcbC5WklxGmLCMsUZHR/K0GZg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(376009)(1800799019)(366011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?f/Pz1cH1vlY5ieYLMTAMyOgnDKIF9VhAovkxWIOiOFPom6NbvPLY9gz2si?=
 =?iso-8859-1?Q?Lkxv5IcN0ftesgs0rUpkmbc0bdDiw+/Oe7lg40obNbKi3VXg9hhdovpI9C?=
 =?iso-8859-1?Q?dTqLVtbI92R8xLk7kRxRQqPSSk1pMgUyiEtRUg9V7CFQVzFHo0SvFP2ek5?=
 =?iso-8859-1?Q?lRYoT2dPiGxBMpfrm7mqJaTBtHaKngZ0w93N8txqE+t1ypa0n27NLdhrck?=
 =?iso-8859-1?Q?jbQWomk4i1AOlGBaHwrRAqx/8H6Bk/xyVxy9NXSlb3GklHlZPE56oC1r+Y?=
 =?iso-8859-1?Q?xZTwuVCtYg8rtc2k8XNm/myTMkpAO+kBBoyBgVYaLL2RPBWMiL4ieb0RK+?=
 =?iso-8859-1?Q?AP/x03Kp+zT0Oz6Xj2igPZwGBeJFJlfrhzdtpUlaOHFCYxjN3T5ShikrKU?=
 =?iso-8859-1?Q?SvZyPHTNde2EYtaSWQn8AheVxD4vhtD/9bWVTv8nQbEI2J/6lM92AJL/v7?=
 =?iso-8859-1?Q?DlFBpekhXD3G6mZ3iRf8HX0I9iJZeklcaEUTDAILMVA/6QLxSZalKBqeZd?=
 =?iso-8859-1?Q?WwT4XV7H+ewc6og9qtHuZEykOcDuaO2iPSWYxHscmmOYB6I2aX5E2jeLQt?=
 =?iso-8859-1?Q?sePqZExLf6tOz5I2f9bgLmcRK4RqQpsrG2xwPxCrF+Faek70wxfCISpFNs?=
 =?iso-8859-1?Q?s6QMYbzJeOoN3J2uqLzhINq6OmzqebDGDHQmnbsatyCfawDHHYb72RWHmW?=
 =?iso-8859-1?Q?hjhnlEe7RDEdgFGzdIebXxZ86tGzK6M17PDQFcqr6CFYrrbH0G7o0PS6PO?=
 =?iso-8859-1?Q?WYinli+ZS6vs71ouk/SnHwo2nvTQ9glRHEWHyXMPD5ObJW8ir+imKR0Sq2?=
 =?iso-8859-1?Q?wIfGdRQlMXM7y3VaEACGnbZT/6HQjN9QWGdT31AvrcNtbSeRlIji4Jgr9v?=
 =?iso-8859-1?Q?KNsvyBD3E90NSC9e+fl0t2fVIM4X9+tpF+6jRIhfIMJIicQAyMhKeJg+fs?=
 =?iso-8859-1?Q?A6ygM6kN+0Dli38cdavoxTJ2LRqWDD82WM6UhEshB56Fn1xxodYB1oBfBQ?=
 =?iso-8859-1?Q?Blw+gXKQGCKkA8dmU7gDac+3EzufXeVubwREsB9hE72KXKylqdjUWw6Nj7?=
 =?iso-8859-1?Q?TnkEf/mYBzwvS2FE+2C4mlJo9TNVKeH9871/NhptIs57AJQj4nTW7v/Ndk?=
 =?iso-8859-1?Q?rzXDQadbuygp6JnWilmcfdbfIScXf/+P22YsK/42GkxA0hFclgbHOY8Nxu?=
 =?iso-8859-1?Q?aH3PoTzs6UivQ/Hn40Q2hr+U7Mw5vZPvoWDGaxlU32vHKxNExrNnM+UQo8?=
 =?iso-8859-1?Q?GpwqFZFE6lQEDKQUdJzZ2BqyGHjmQT8ed1g7c8/8RLFllN95LY7VMU8fkm?=
 =?iso-8859-1?Q?MdavEvIJBUglPzDyfB/DCRaSAU/S5K9udrxf2TPGYDzZAfvp1qwo4DToKX?=
 =?iso-8859-1?Q?xztC4/hh10Wk2bkIr3d33hiIsdpGWByvO3g7cB1wJSdpke/iqkFqZiiKb+?=
 =?iso-8859-1?Q?xNl3f9UXTZqQHGinlkfPCBvizhXNrCaKeIkyVFsxADcsWGb6cqtaJf7EqN?=
 =?iso-8859-1?Q?SQmhHlOMftaBQJe68VVrSHqb8OkfyII0ZmWAhGvQGF2Bjt7ZIm6u7oPqjl?=
 =?iso-8859-1?Q?66R1U3QDswaQBfvmtnAZvuSEtZw5ejIoLjITVfImcn0cVAYWffdmC8whyr?=
 =?iso-8859-1?Q?PIMulorNHx6nGoStqWxDRVnvB6oB8Flgl/01QjuDOrGOpSPoEeCzF78g?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b3b161d-ab5b-459e-9b29-08dc8c3a9c05
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 06:24:13.4842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AKUc4KM6UbVImwm6Coib0G26WD/8R0IzFuHGk8v67Mld9eSkCS/1uiLy88Wjb234Cehd0mP0vbbyOOTFcWU9yQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6671
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed a -34.9% regression of fio.write_iops on:


commit: 4edee232ed5d0abb9f24af7af55e3a9aa271f993 ("xfs: switch to multigrain timestamps")
https://git.kernel.org/cgit/linux/kernel/git/jlayton/linux.git mgtime

testcase: fio-basic
test machine: 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory
parameters:

	runtime: 300s
	disk: 1HDD
	fs: xfs
	nr_task: 1
	test_size: 128G
	rw: write
	bs: 4k
	ioengine: falloc
	cpufreq_governor: performance




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202406141453.7a44f956-oliver.sang@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240614/202406141453.7a44f956-oliver.sang@intel.com

=========================================================================================
bs/compiler/cpufreq_governor/disk/fs/ioengine/kconfig/nr_task/rootfs/runtime/rw/tbox_group/test_size/testcase:
  4k/gcc-13/performance/1HDD/xfs/falloc/x86_64-rhel-8.3/1/debian-12-x86_64-20240206.cgz/300s/write/lkp-icl-2sp9/128G/fio-basic

commit: 
  61651220e0 ("fs: have setattr_copy handle multigrain timestamps appropriately")
  4edee232ed ("xfs: switch to multigrain timestamps")

61651220e0b91087 4edee232ed5d0abb9f24af7af55 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      0.97 ±  3%     -30.7%       0.67 ±  2%  iostat.cpu.user
 2.996e+09           +51.5%   4.54e+09        cpuidle..time
    222280 ±  4%     +44.7%     321595 ±  4%  cpuidle..usage
      0.01 ±  5%      -0.0        0.01 ±  6%  mpstat.cpu.all.irq%
      0.97 ±  3%      -0.3        0.66 ±  2%  mpstat.cpu.all.usr%
     88.86           +27.3%     113.13        uptime.boot
      5387           +28.4%       6916        uptime.idle
      2.98 ±  3%     -10.9%       2.65 ±  2%  vmstat.procs.r
      3475 ± 10%     -18.6%       2830 ±  6%  vmstat.system.cs
      4.65 ± 43%      -2.7        1.97 ±143%  perf-profile.calltrace.cycles-pp._free_event.perf_event_release_kernel.perf_release.__fput.task_work_run
      4.65 ± 43%      -2.7        1.97 ±143%  perf-profile.children.cycles-pp._free_event
      3.33 ± 76%      -2.4        0.90 ±141%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      3.33 ± 76%      -2.4        0.90 ±141%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
    769.93            +9.4%     842.10        proc-vmstat.nr_active_anon
      3936            +2.1%       4020        proc-vmstat.nr_shmem
    769.93            +9.4%     842.10        proc-vmstat.nr_zone_active_anon
    269328           +20.8%     325325 ± 11%  proc-vmstat.numa_hit
    203054 ±  2%     +27.6%     259008 ± 14%  proc-vmstat.numa_local
    297923           +16.3%     346459        proc-vmstat.pgalloc_normal
    181868 ±  2%     +30.2%     236868        proc-vmstat.pgfault
    173268 ±  3%     +27.2%     220312        proc-vmstat.pgfree
      9141 ±  7%     +23.5%      11288 ±  4%  proc-vmstat.pgreuse
      0.02 ± 26%      +0.1        0.10 ±  6%  fio.latency_10us%
     99.87            -8.4       91.43        fio.latency_2us%
      0.11 ± 20%      +8.4        8.47        fio.latency_4us%
     46.16           +53.3%      70.78        fio.time.elapsed_time
     46.16           +53.3%      70.78        fio.time.elapsed_time.max
     35.68           +66.7%      59.50        fio.time.system_time
      4940           +52.6%       7538        fio.time.voluntary_context_switches
      2857           -34.9%       1859        fio.write_bw_MBps
      1176           +64.4%       1933        fio.write_clat_90%_ns
      1200           +83.1%       2197        fio.write_clat_95%_ns
      1528           +46.6%       2240        fio.write_clat_99%_ns
      1167           +62.2%       1893        fio.write_clat_mean_ns
    731537           -34.9%     476002        fio.write_iops
      0.06 ±  6%     -25.5%       0.04 ±  5%  perf-stat.i.MPKI
      0.91 ±  3%      -0.2        0.67 ±  3%  perf-stat.i.branch-miss-rate%
  27659069 ±  3%     -28.0%   19920836 ±  4%  perf-stat.i.branch-misses
    822504 ±  5%     -25.2%     615111 ±  6%  perf-stat.i.cache-misses
   7527159 ±  6%     -26.9%    5499750 ±  3%  perf-stat.i.cache-references
      3394 ± 11%     -18.8%       2756 ±  7%  perf-stat.i.context-switches
      0.46 ±  2%     -13.0%       0.40        perf-stat.i.cpi
 5.727e+09 ±  2%     -12.3%   5.02e+09        perf-stat.i.cpu-cycles
     74.31            -3.0%      72.05        perf-stat.i.cpu-migrations
      2.31           +13.1%       2.61        perf-stat.i.ipc
      2905 ±  2%      -7.2%       2695 ±  2%  perf-stat.i.minor-faults
      2905 ±  2%      -7.2%       2695 ±  2%  perf-stat.i.page-faults
      0.07 ±  6%     -25.7%       0.05 ±  5%  perf-stat.overall.MPKI
      1.18 ±  3%      -0.3        0.87 ±  2%  perf-stat.overall.branch-miss-rate%
      0.48 ±  2%     -12.9%       0.42        perf-stat.overall.cpi
      6992 ±  6%     +17.1%       8190 ±  5%  perf-stat.overall.cycles-between-cache-misses
      2.09 ±  2%     +14.7%       2.40        perf-stat.overall.ipc
     16640           +53.3%      25504        perf-stat.overall.path-length
  27090197 ±  3%     -27.4%   19666246 ±  4%  perf-stat.ps.branch-misses
    805963 ±  5%     -24.6%     607413 ±  6%  perf-stat.ps.cache-misses
   7402971 ±  6%     -26.4%    5446622 ±  3%  perf-stat.ps.cache-references
      3329 ± 11%     -18.2%       2723 ±  7%  perf-stat.ps.context-switches
 5.616e+09 ±  2%     -11.7%  4.956e+09        perf-stat.ps.cpu-cycles
      2843 ±  2%      -6.5%       2657 ±  2%  perf-stat.ps.minor-faults
      2843 ±  2%      -6.5%       2657 ±  2%  perf-stat.ps.page-faults
 5.584e+11           +53.3%  8.558e+11        perf-stat.total.instructions




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

