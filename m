Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC84433BB;
	Fri, 16 Aug 2024 04:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723781929; cv=fail; b=UWH3amITAzU4zgffG+b2QuYWfyHp3hymY5B+8+EDogktI/CvZu0ei9LnfL+Rdtie8eoGBmA4HB4f2oO9xppwacZ/Hhnj69LFszh++Gt44WpKVEUBn1+sRJD1LzO4YGviJbcYwvShkYdWOxiQUGUDA4qTkcR0kFOAZUcRxNxPObE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723781929; c=relaxed/simple;
	bh=oxtpqBfM0+mn68ZyJ2eyNUGnXQcYdB1N4wM5VNJMgVs=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=R0cX+W9fU/loHqf3GH8wu8M4JduZJmgfz3X2e94gDCsxg29BhjBidKj1ExQYn8wS3n5/saCmL9zxNtr2Drs6482hJjm0FkLJQb1mGrMN13KGchx80V1sP7BoqIKDnm+UG5f/YC+RJBJZ6lk1pqxRzz242CODBPiZke1PLR4L848=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lkEBOyAq; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lkEBOyAq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723781928; x=1755317928;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=oxtpqBfM0+mn68ZyJ2eyNUGnXQcYdB1N4wM5VNJMgVs=;
  b=lkEBOyAq1ZoC40rApQAH2IK+qVNdxMhBD7XFnHXQL5LjlrPA28V3y/G/
   tMbx+gMJcaaJR5satnYiKfPXsAR6VBqwhTZTW3eAQ8JzNcZVfiSG49U0M
   w8qBd7bzkgSdJTi4jf6SnevPK0rg9tb9Zq283LSqNst/G533gXf2PYf8w
   XVloiEkCz4JtRxA1ao6lntzD8gzWFo1t5eXQIlIM0vt5RL5g3Wjb59O2j
   gCCeIylCAfgtoJSYE+0n3mwgK9yFXh8B/AX5S5E4zQ/YoqRF6l2R1jKz0
   caUL1Bv8SBvWz7Td766Qx7+QUZ004n5AdI0ffrkSoTKLV30IcKYwK2KBR
   A==;
X-CSE-ConnectionGUID: MWCblsQpTWW39jvxOmwNTQ==
X-CSE-MsgGUID: SVV3GJwDTgeS1F2KL2TEow==
X-IronPort-AV: E=McAfee;i="6700,10204,11165"; a="22213106"
X-IronPort-AV: E=Sophos;i="6.10,150,1719903600"; 
   d="scan'208";a="22213106"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2024 21:18:47 -0700
X-CSE-ConnectionGUID: 8AcE+9xORJ6h3zG1qedH8w==
X-CSE-MsgGUID: T+0RNzHpSuaybkUvCEJNFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,150,1719903600"; 
   d="scan'208";a="63745683"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Aug 2024 21:18:46 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 15 Aug 2024 21:18:46 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 15 Aug 2024 21:18:46 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 15 Aug 2024 21:18:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PdI8nXAr0XR2IsAKsSxNRKfsVAt66tvmfOstuK5wb8YElGMsyw0fAQ6pMnPLXm7RnqqFpvAIHTsbIG8U5DDOQanVSHxdALvH34Q1XzuC6HumFxil3fIAL2o6aBD2vYRj8k0fvIZXPuABMdk+HMRQkyJ+KLC4sJaEH1dlDH05gi3SY6vr81GxcCEhB8ZhfRpzv6qNu1DPrPXKV1sw4MyiT8SjiXY2J/D3qFMhjw0C0XRVUuTmyuusFuEbgE55tI7tdYcrauapM0pbVOy31hIke2720cJbbi4/xiwJz2Z/UpN23qs94lR2A+719QDZ+llV1OaMujBzQeMuVKmmD7nUHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wsoAlaF0j2EQsNrNHDbW3haQD7mTbWYgHrOMYSEOzlw=;
 b=fXinJo5pmPEq0s6D0C4d+jQUcCgbGXZhKV4l7sNgnQm/Dxtvqv4zqQ6o4TrQsxsyXMZp2fHfxLBnt74hpOCW0xKtgIvEOJsB9H588+T2UXKjvp8w7PnYf4hk3+G83SrU21owgvnoaLxN+MewxUxKPfByeJbBzCnWhP60IBBrAcwrSmTFSPO7u8DBzdxkovHikzyLejegOx1ssRodr60DdGjDPEnEDzE6tD3+UWCbJToIz1s/L8PLsZQSYFhq2XNMHqOERDN708n4Q55HVsjCMFPnZ0y9bGHX6noeb0n2Rb24vC4vNEiLYrsyB1ZXzZwpevQSAlxV6x40sOszB6ev0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8587.namprd11.prod.outlook.com (2603:10b6:a03:568::21)
 by PH0PR11MB5191.namprd11.prod.outlook.com (2603:10b6:510:3e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.19; Fri, 16 Aug
 2024 04:18:42 +0000
Received: from SJ2PR11MB8587.namprd11.prod.outlook.com
 ([fe80::4050:8bc7:b7c9:c125]) by SJ2PR11MB8587.namprd11.prod.outlook.com
 ([fe80::4050:8bc7:b7c9:c125%3]) with mapi id 15.20.7875.016; Fri, 16 Aug 2024
 04:18:42 +0000
Date: Fri, 16 Aug 2024 12:18:33 +0800
From: kenel test robot <oliver.sang@intel.com>
To: Zizhi Wo <wozizhi@huawei.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-xfs@vger.kernel.org>,
	<chandan.babu@oracle.com>, <djwong@kernel.org>, <dchinner@redhat.com>,
	<osandov@fb.com>, <john.g.garry@oracle.com>, <linux-kernel@vger.kernel.org>,
	<wozizhi@huawei.com>, <yangerkun@huawei.com>, <oliver.sang@intel.com>
Subject: Re: [PATCH V2] xfs: Make the fsmap more precise
Message-ID: <202408161111.8e30613b-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240808144759.1330237-1-wozizhi@huawei.com>
X-ClientProxiedBy: SI2PR04CA0002.apcprd04.prod.outlook.com
 (2603:1096:4:197::17) To SJ2PR11MB8587.namprd11.prod.outlook.com
 (2603:10b6:a03:568::21)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8587:EE_|PH0PR11MB5191:EE_
X-MS-Office365-Filtering-Correlation-Id: 630a0e55-4953-4a0b-26f9-08dcbdaa835a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?iBY8oGgAnEykWP0aLaPI5TcBlpEsHQJHv8mxXJq8evIBLnHRItig/OtFhUex?=
 =?us-ascii?Q?+rhAqBoFBYAQDybLW1rhTMaX/vp0WutofQ8MNXXa6X1YrEyPAMHcrkveJNgL?=
 =?us-ascii?Q?sARsOIDgpAaM4tF0GsxBI8Y94I10Zut31lAl0KRLNzjqhgnmQuhNpwpFh29K?=
 =?us-ascii?Q?rZtTo8blamit+EI/n2qa8UevVypngia7p19Yku1q4BvLJICFhg5k0tWTPbO4?=
 =?us-ascii?Q?wPId6HbXRTi0fpWFi7ufnzo/Q9fwewATHDgk9WltcuJCx4092nRw3WaWWymH?=
 =?us-ascii?Q?C5Ta12kfMl8clvv1dfre1vKKCeJzSh+Lpwkkld6iWGwKDSS6ZreEVZ1RH0ZX?=
 =?us-ascii?Q?vqqREDBc51Lv39QcY1PFAuKRwrMyIZKsZFwur2mE0Qk75Isg1zw6WZp1I+Aa?=
 =?us-ascii?Q?Q0aEtxcHgxhRVrRgqDFvaxCCBy21Q19j+PwCPn9H38uiWjluEqPAgnPqo8TA?=
 =?us-ascii?Q?HC/4m5hrQjMC4E+pPtnJoV/gLvVcLYdt6Eki1wtQZgg6SOpxi7PB0VU6uQoJ?=
 =?us-ascii?Q?tkpNE2kcIv+ZXKa0vSh9JGGmRCMfnLsVtEGKp6U+Kj6TanAhsMMSjtPnUvoT?=
 =?us-ascii?Q?vVCmhW5/lQVl5dQYbzYutI3jwm6zyYSfcShkWD3hCGkUbeSoeB9Pk5PtyyrC?=
 =?us-ascii?Q?1H2Pja1kzJGFqAb19ZMa/xR0qfJr9uIaxVi+CHkyykwF75/L7TrH6aoPdcUb?=
 =?us-ascii?Q?aEYaUzrOQ6pG/3jKQlNC6/8rE7EnJzwSfu8K5pmVuJb0Y5UMHCLuyrv5qFOJ?=
 =?us-ascii?Q?yBl1y0dxJdwQ7SMVA8AZClWpDyTzL3RK5XvAHxeueZLa0s3J4PlMxfeYDp52?=
 =?us-ascii?Q?z9vYAEyvCS9CxdShULT2X/vp1XbEwR0IcRs7XXRSLTx8xp+SambG8iLNmS7A?=
 =?us-ascii?Q?ZqCUOLHHSDOMDgiU0CFfvnVpc9k2H5dyXIdlm4cN/Z7y64IOZrwIXLRtosjd?=
 =?us-ascii?Q?rspmZCVQ1UUaA1h2rBjpApBtLKe3+Mky04Jc8faI9iIHz07EysmlOYCJMEHq?=
 =?us-ascii?Q?H8fzv2YtofW96GKPHW4/trOgO2keNS31Jo0PgpfDyzg1SywQYuuVj/YkP2k7?=
 =?us-ascii?Q?BkuH3/kG4tCsxkShzZC6A0gVe7JnBmzr86ps0WHxeLCPPlMl8VerX6UhxUED?=
 =?us-ascii?Q?0eHTcAOXALfisDJoliufr0KXrpJfqIaviD9wXMC/8/3Kc4MSRoWfMjSGyAoI?=
 =?us-ascii?Q?Gs+gKmgcNJ/Y9CK+Cxy7zyVUOe5jcewA6EFBQpEhYZcPejaCsyrtloottndw?=
 =?us-ascii?Q?+thT6MlhsoOvn1I9EHYz1IKvuUiIeeb0qqpDf8GmFvmPxtFm0WMvR5tbSfIc?=
 =?us-ascii?Q?vdZZ4BJvYc18XlIVeYP4CI6r?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8587.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2TMiyPExHq6fXTzAWhVCxdZOWgJ1oVDAiJhpx0h4oYkTI6j3hNwEDPP4r+4f?=
 =?us-ascii?Q?J6ypTd0kQxoU0PX/HE9U/Qk4cMMQ5eF+xpYGY7T3a6JTVFVRf9sqyRNLaMNh?=
 =?us-ascii?Q?6A5XGm3MkeIXECkSSysjkvAiO05NeO7iR1u7fWCa5+3cp2NRIzP1zXZoI9KG?=
 =?us-ascii?Q?X3IvVq0abr7X8fAIhrJbAP2xygekHTHgHFlY/r4hxRc2tErES5ilglVnOMTA?=
 =?us-ascii?Q?rMnHfgZgXgyVZ1Thz6bjoy0n55108jK/JMHsOu9PKtELf5Ql5A7lDiefPHNz?=
 =?us-ascii?Q?cwo5gUQmR5JWeuXOcuA1/ench8m8GTUqDbS8bwa8on/be2PS+SA0ELcFzjwv?=
 =?us-ascii?Q?kisIJoBGjOR/FLp4FQrDjMElkFv0Q3h87T6kHlNRBQZtnWbtlZG0m11EMWAo?=
 =?us-ascii?Q?KxoFeYQNjI4MaVEa+MEuPyxnNKbeHueKp8XiJaiR7uxBwq7dczk8K1HzNS1A?=
 =?us-ascii?Q?/EEJw2InZkUQO6lW4jngJWqmDafaCdxNXSfd75wW99Jm/KU/yTsuKb+ukJdl?=
 =?us-ascii?Q?N9ifH0UHi+H0DffGUqSZjjhXda+ljGykYn8Sdk213eaQj612T2YebPKMaCme?=
 =?us-ascii?Q?wdwKYuFkoc3G8iEt25PhiUrlUwOGJcaVTFxyp0Xt3Xsr6y/1VMmonj7se19T?=
 =?us-ascii?Q?/YW9oQEIMm07RGljBZ/0aIIuS3YRZ9vNIOsPoK9S4why3GXeXv0n17IC1bak?=
 =?us-ascii?Q?20ZkJQFsh4djzKgAdtz3IGYFyan7jt6skav/ugdfvBUCzWvRi1Gg1L2hBcQD?=
 =?us-ascii?Q?KoJbSDif3v300qepuXHLqB09xq/oGmXRMhSX5hCBEB2/cG8H6JbVVO09TxmO?=
 =?us-ascii?Q?ubqsir9u1ID63U6nQ6iezKWxdBW/wKAq+/2l3q30nGq1ojZ+RPkb6YmR0DZm?=
 =?us-ascii?Q?fAjOcgXbiAa1ZqgIkfrmIxrSPffApbpQxfzbi+C6ykCsCsvkuOZnzJ08F+3S?=
 =?us-ascii?Q?Iq074+rqcNypEmP+Oo03rCkD58MYy778Vvq7l1wqqNvE7UadaCv3olpx0R+M?=
 =?us-ascii?Q?Wow1b5kZ6x/gqyHk8qQBEtUg0EDIISbMDcxuD6+Gc1n3x3XtQ6/Kp4bbn8UM?=
 =?us-ascii?Q?EZsEubijTtuCEc5pQD1uYff5faCqLeEEwcVuCxNmmV67qMnS2wM2hEsy06f8?=
 =?us-ascii?Q?qhQTQclXrLwwwBA4HAJIodocDGeBYWz7G3Zfp7XZRuRSRQRF+4NL7YpsJHXm?=
 =?us-ascii?Q?MBpLxlOI/5iTcw6HLV/8igN1tYGzwOaQemIFtFXoIShMecyz5zOXiyC6p+bH?=
 =?us-ascii?Q?yglSR1duOkr1WcHon/B8wz58vm+ZmOwNdUjaY+dw4k0VUo0BPToJ7y7d8RTs?=
 =?us-ascii?Q?tIaRmgkzm/PzJLlbFtd1mqtQucuQeYGhP/1dln9DC6G6vSUtLBX6k5KAJSyC?=
 =?us-ascii?Q?LhlphNZXs/Nn5voXQxpsX15xOe+gt/poP1Wibkz2lXrMMzeZdPxVy81CrXh6?=
 =?us-ascii?Q?tUgmIyEfRjKOmfBJEeKmNe4j+JIUbvfUokgAsYYd84EtDGm4vUn0EfjY2ETj?=
 =?us-ascii?Q?pIA51ZroU5duoBVfmlB6hFmo8g0URG/skUgzEbSB7DfXW+hRzMLAWghx9ia+?=
 =?us-ascii?Q?KZdB6oN2PPXU7y6Q3rIYJkBAAQ2B8NTAy12jbgVkUoE9NavmYODZFFHcn1L4?=
 =?us-ascii?Q?Sw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 630a0e55-4953-4a0b-26f9-08dcbdaa835a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8587.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 04:18:42.8086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +fbRu33lGv9t1nEZr3CL4A7Sfngq7NeN++23V/PG7UZv8QS/2+S0iOn6PynoRKR6Yh3LgZoPxgxthehhViycLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5191
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "xfstests.xfs.556.fail" on:

commit: afef0c6f182dcaa5858b95edb6df46b7e4a54824 ("[PATCH V2] xfs: Make the fsmap more precise")
url: https://github.com/intel-lab-lkp/linux/commits/Zizhi-Wo/xfs-Make-the-fsmap-more-precise/20240809-005729
base: https://git.kernel.org/cgit/fs/xfs/xfs-linux.git for-next
patch link: https://lore.kernel.org/all/20240808144759.1330237-1-wozizhi@huawei.com/
patch subject: [PATCH V2] xfs: Make the fsmap more precise

in testcase: xfstests
version: xfstests-x86_64-f5ada754-1_20240812
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
| Closes: https://lore.kernel.org/oe-lkp/202408161111.8e30613b-oliver.sang@intel.com

2024-08-16 01:01:52 export TEST_DIR=/fs/sda1
2024-08-16 01:01:52 export TEST_DEV=/dev/sda1
2024-08-16 01:01:52 export FSTYP=xfs
2024-08-16 01:01:52 export SCRATCH_MNT=/fs/scratch
2024-08-16 01:01:52 mkdir /fs/scratch -p
2024-08-16 01:01:52 export SCRATCH_DEV=/dev/sda4
2024-08-16 01:01:52 export SCRATCH_LOGDEV=/dev/sda2
2024-08-16 01:01:52 export SCRATCH_XFS_LIST_METADATA_FIELDS=u3.sfdir3.hdr.parent.i4
2024-08-16 01:01:52 export SCRATCH_XFS_LIST_FUZZ_VERBS=random
2024-08-16 01:01:52 echo xfs/556
2024-08-16 01:01:52 ./check xfs/556
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 lkp-skl-d06 6.11.0-rc1-00007-gafef0c6f182d #1 SMP PREEMPT_DYNAMIC Fri Aug 16 02:37:27 CST 2024
MKFS_OPTIONS  -- -f /dev/sda4
MOUNT_OPTIONS -- /dev/sda4 /fs/scratch

xfs/556       - output mismatch (see /lkp/benchmarks/xfstests/results//xfs/556.out.bad)
    --- tests/xfs/556.out	2024-08-12 20:11:27.000000000 +0000
    +++ /lkp/benchmarks/xfstests/results//xfs/556.out.bad	2024-08-16 01:02:14.357396417 +0000
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
https://download.01.org/0day-ci/archive/20240816/202408161111.8e30613b-oliver.sang@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

