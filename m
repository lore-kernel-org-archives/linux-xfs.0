Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7203F135A71
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 08:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719994060; cv=fail; b=VCODNAcbJeRv8VxLRF2u/G0Oc8qODGsewZ6SqR6y0pWTYYjmbhgrtLPGZRfm9s5xC6TfyIWzJMjqOqq7e5Jz6NGgIpyBSst6bHWze7aj3Mf2j9SRkJGv6A+baLA24gsU0fZjNrBEJrGtqVvFAzJtvtkcvnMK8DtZMa18pIWW+24=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719994060; c=relaxed/simple;
	bh=H0G4/ifYDH0AndECeeq75Xh7E5L0Tq0gZ+YDrjz7HZQ=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nLXsjQsLXuIp2lpzNO8oAMAXiX1x8CuAbxvGBf+Zw/ZQYOkY6hSkNBT4+O9Bd9/e36RHydOTXVaypZzHMdhmCL9gQEPV6CBIwtcnqHaUkDZ84zwgg2TbK+1N9Np6Kqw/gJWR0y/b5ZzjtGuqupjDwWxXiq/QEq5OHrW5MecrdSo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eDjxvYfK; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eDjxvYfK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719994057; x=1751530057;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=H0G4/ifYDH0AndECeeq75Xh7E5L0Tq0gZ+YDrjz7HZQ=;
  b=eDjxvYfKg0WoUptJxDwxFIJnHPKGNNJfisfWrRhfk95iN8dridQBGj+R
   Cg1haehBMFIOBo4wVsMLKAtEkp8sCo/8B144ztyq2OPOK5/FeUuql3+nX
   H0aHvMLt0LH1Jf8h8V10hePPuFDSmuEk34Zs1oNWsnpT4q4wP31JwdXHY
   lHWE7mDACvqKYS8Vsle9CiEw+TVBR0XSKcvoAR5At+jxf8BUwNDm+j1/d
   zi8seoj1ZCPbQ38cdP7lkf/lmtrgnzvbSbIgsyEPgY3gIrX0Cffq4nrt5
   wgneNslL8kAm6aDruV5E3D2fqY+B0o+eesp/ytwiRQ/MfBTChoNGxRkRs
   Q==;
X-CSE-ConnectionGUID: MB72eDb4RvmlKIuNAMJn1g==
X-CSE-MsgGUID: r3lAjckpTYKwuLPfXc+RcQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="21081935"
X-IronPort-AV: E=Sophos;i="6.09,181,1716274800"; 
   d="scan'208";a="21081935"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2024 01:07:32 -0700
X-CSE-ConnectionGUID: 3UkJhbmbRrWsqITctM+VOA==
X-CSE-MsgGUID: 91UDRAvKRqyQlMo6Bfz1KA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,181,1716274800"; 
   d="scan'208";a="46921640"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Jul 2024 01:07:31 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 3 Jul 2024 01:07:31 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 3 Jul 2024 01:07:31 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 3 Jul 2024 01:07:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OAxEmt3bWum6/V5HX5b+kbqYedcQySFnc8IMM/9qonDZhEqdRyHzm5Er6+pIo46ZYN4pkrAfUZT20GrEJBdphLJNkDkxaUteOOZLFVnWFEwgDV9wFilSTpKDtxZinANyl6TOVrZ9dkAQB4sAgtblEh/znU5kQCzGgEpANZc0L+PrRZ9C1Rt9mSxxoYDSH1umJNHd57dMm/28uGoVKAtphk6LNWChPehaFbPQWJbH5DkAcF9/GsJA/Eg86yDtxQuYo+3mpWpIZApm8ypfM0FVpUR2nsbwNYEyc/yg2/jJ6bqBMyWngzSGGcKe1ZqbXSpBf02YYDwzey8gL+S6Y2vRUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MWzLF2w0rtlZyOJDgVR+8H2J7Tk5vINMM78pfAhEEn4=;
 b=ifToAPkTX1KNCxnBQDhyVwx3OYHU7ByP7L7FwFGrjnl3IXDBOZN9dCtv3RYF2wJCWvOACd18O6HZRZqMGEdibpmglnjo0P82idU9bUjFDfdP3Ixddf2fJZkWdolUA957k07bj4Xm+HaaYF9iDXY9HUllGcPu1PBVIkCFasKf8NsQVkMVkyumXu/aBtm+ltoUlZoMze6QcC/yDIoMSySQdkDAgYo51GUnicAGZOwua+HfO1hwchQJFOnNYGFQ7fITUd8q2L7d8iuiXWkoYw234rt2ECfYW3o8EcojpugcySGV0EuFFb2wLI4sqwyGhvb63Wj5/5NVmhKQS9n8z/tGLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8587.namprd11.prod.outlook.com (2603:10b6:a03:568::21)
 by IA1PR11MB7823.namprd11.prod.outlook.com (2603:10b6:208:3f3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.23; Wed, 3 Jul
 2024 08:07:21 +0000
Received: from SJ2PR11MB8587.namprd11.prod.outlook.com
 ([fe80::4050:8bc7:b7c9:c125]) by SJ2PR11MB8587.namprd11.prod.outlook.com
 ([fe80::4050:8bc7:b7c9:c125%4]) with mapi id 15.20.7741.017; Wed, 3 Jul 2024
 08:07:21 +0000
Date: Wed, 3 Jul 2024 16:07:12 +0800
From: kernel test robot <oliver.sang@intel.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, "Darrick J. Wong"
	<djwong@kernel.org>, <linux-xfs@vger.kernel.org>, Christoph Hellwig
	<hch@lst.de>, <oliver.sang@intel.com>
Subject: Re: [PATCH 8/9] xfs: remove xfs_defer_agfl_block
Message-ID: <202407031556.d271bd4c-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <171892418834.3183906.376857417040987772.stgit@frogsfrogsfrogs>
X-ClientProxiedBy: SI2P153CA0017.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::10) To SJ2PR11MB8587.namprd11.prod.outlook.com
 (2603:10b6:a03:568::21)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8587:EE_|IA1PR11MB7823:EE_
X-MS-Office365-Filtering-Correlation-Id: db756bef-9e58-4d8a-5711-08dc9b372a18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?OuSuz3p/Imua5YZJ8wZkwvzK8OhZbiQZqd0YDPd6u6Nb8sSnsu6qaMs/NGq+?=
 =?us-ascii?Q?mhnIFxUq8MwdcMYasp6q0i0kmGTxgQ8OXpuM2h8vCL1dp1vctw/IFFcr3oNw?=
 =?us-ascii?Q?WXGWzs/ntyux/3AQdA6zOU5Z6b/PpKeaLGCGK6Gw2joeAKINGR56HPFUwOHG?=
 =?us-ascii?Q?7JKqB8wcSq8WBL2NGwxjkPkaJeNodqIti1m3AA4MsuplzDUzMCzV7EMi9PvY?=
 =?us-ascii?Q?dxzhQNyC3Nbh9WwfYAAj8Nly/7VM3n/60QvWi+kxmFDKY/oyOfpRmYDb9sK8?=
 =?us-ascii?Q?jwHxiubHvZFwx16k1cTqLx0GekL1gt4+sFTjI5g+z3d3GbyOxCUoTz8T++Sp?=
 =?us-ascii?Q?MP1YspxhqbwHOOORTDTIU9qGB6yil8BEUOlzPd5DOl4L8Lfg7gR07gTKoDN3?=
 =?us-ascii?Q?ZLxqCq/+XqAGQOlx9FEETDK6mFO8USwe4oSUJm9htVNchJeP43xPBSnxl5kn?=
 =?us-ascii?Q?6hWHa5WJt0qJQ23TY4X2OUNQZANrzpY7oYJS61tri+TDtpMlkeI+JwNydQop?=
 =?us-ascii?Q?elgcS7M09DkT7HSNq+4TUMV8tcFAEu6tevlZLO+tS1Bttalk/fjhz21//NCO?=
 =?us-ascii?Q?1FEiDUOy6qzl6B4/aafqS8VsXi2xU0PLfyaf5Cvmeho5+l2GfOn8SJq7LncN?=
 =?us-ascii?Q?wxTMAhPFeYQwhMvYfwzqyinWHlggWRMkP4bloPHcXP8NNx91gK4cMGpP6iMB?=
 =?us-ascii?Q?yeLm8QJDtz2JZMK/1F+PrHVNh3Iveo0eacMAuYXqrEtD/lqLCrW6YiPXiTX2?=
 =?us-ascii?Q?BUyUzPNGNRqtOrHXBx139Z8B8XgrWy3+lKx1I++UCe0FF9thnTB1A07+cXjo?=
 =?us-ascii?Q?SN3w4lwBN62s3BpxCnwtaCbRVAvRVcFeYcE9klynerYCcretTlMOGKqt0WEg?=
 =?us-ascii?Q?s9TG6Op5cfDUhxBk3iMsq94+jRViLCxe2RKVIWQ3e4j2ndUNqLgsFmQQgDqQ?=
 =?us-ascii?Q?fydvVgdzcRqBiVrzoQwK0U4LEU8uzNg/BgJFLiKFlb+mVENGg7dr7CU9sf8J?=
 =?us-ascii?Q?XiY0ZWqglssIBpfpZ2z5wLIsgG9OWVvE+be6t9bDXqu0MUaS7H1ZiMluWupR?=
 =?us-ascii?Q?oRYigednwkhiWHoEZNeGUmNhsqp0JDc1zT6cJg5hdfEJrkOIZ3G8owGkYmZ+?=
 =?us-ascii?Q?bX8ipuxA4f2sLOH34gyzPFTZcrEj33bs4BKywi79D+W4bp1Zm6snQ00Zr1ss?=
 =?us-ascii?Q?MIQBiUiHRnulnlomWEXDrMzUq9qQWqDCeID3ZGRoQUIokT7/B+JnQNUAKhwh?=
 =?us-ascii?Q?zl2CKaAgK4IWEmm9Wt5Q4khATk2m5j4mi9QU5GiHVk9a47FdDn06TatyxapP?=
 =?us-ascii?Q?MJQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8587.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nBNnIHw/tlGDBHC4zDW1/rs4HpibZDGsRWNTib6Geb+IP4H/2bIEUhkZWC96?=
 =?us-ascii?Q?ScZTxeekRME7N3fl68ZhAw+VfKQD1oIE12uAQHvT5VGL/EYsI3Bpbz8KOr7M?=
 =?us-ascii?Q?pfzwygU2KvXf9YqNVO6cYRTNtrpgYIgkym2HFcPxZjXBVu6HACUwiiwGX7F4?=
 =?us-ascii?Q?9fjLz1ta7vx6mlOmbnximi7WJQyid+qaPQyv0W99CbxgO8aaKzBMpxrgVzMP?=
 =?us-ascii?Q?wW9GjCzw1mfHD4a0cdN/MM46WaC+IC3qBCEAW25Rk2BsQh7wlKmbxTG3fcBf?=
 =?us-ascii?Q?HoVRg8nZuNQNpak32tY1TIczo/iqSHoI/SgKHRsqdIVpjQ1MbOUpLWBSWuxa?=
 =?us-ascii?Q?3aIRO88+qwOIdyQIZHYY92m+nlo+BtrcvOV2RRblWe5XuHq8UWpQf/E3siGU?=
 =?us-ascii?Q?/JvHoLxetusTv7vQI5fiPGDSN2IGUNORGNKIm+mYHTUmZ06KDEy05+sDd3Ya?=
 =?us-ascii?Q?iEh5oTTuGik09T0/E+bH8H+9hJw1AWO+aJBs7gYaj+qjeMSGOcrcDEHtY5kx?=
 =?us-ascii?Q?1T7HZt2ORfXLef/QrdSm569m8cX6vAuiXJqbIvTTe8alVhmq4H/9wRh+V3HB?=
 =?us-ascii?Q?ELSjYLhYspwEBd59N6/pFXnQzQK6m7qFVzBKpmdW5jO9kxN40E4Ym0j20qm/?=
 =?us-ascii?Q?r1hX2PLeLBnSIRuQ9j5MC4gnVMsLx2yq67acu6qXRHPO+6xSZnJz+czyupaV?=
 =?us-ascii?Q?mko5MQKFV5Q5t52h3HOAR30eN+jzd30qY2GEPCdsDhXw1GXI/nXrSavmab9E?=
 =?us-ascii?Q?Z034Nrwm/DYNwxzDFixh+od0f9Uybb70G9ViEaZ5ZLxWAWROm3Rtt8PLeCOP?=
 =?us-ascii?Q?tAGLdZauzoLAROzubmUIx+AOGbLZHRWYCsOx3meRzN18kYtEBrIcqjhDes5v?=
 =?us-ascii?Q?lugd2MWPudtkts61m2uGSQ3ekQMVCXOQYiF9SCFo4V69fm7u4Y0mGVkNf+6R?=
 =?us-ascii?Q?/oaENMmRmpvFBHOW8RFcPj/Io9fKbwLs7+G6LLEfXPe8E9N/7XuK+r3tOQW8?=
 =?us-ascii?Q?hGahhitQ1XcbW505EU7r0tycK2VNyBz/q8qVRMu29XBjk5zJioxvKKGIxqMc?=
 =?us-ascii?Q?rfQ1sLXz8LE2133ERQ635Soyiqh7eihZqudmLirhRvJStGTiOZOCKyoN7vKO?=
 =?us-ascii?Q?hsgV/MGKKtnmD5QlrQSE6Sxy5zW9w/uIAuGP3WBm9wVzHU5fFPsM6yyzHLAp?=
 =?us-ascii?Q?KK3bmxOF01KcCa7vDkvbAqF9EEOzn0zIS+t21kWVmE5jTASd40PRzyKl3PFd?=
 =?us-ascii?Q?OWXyuFTamssO35a2Kqt+WTl/HG6EZ5tqbW8IJT9SqbbD9R48p6igIL9c2ewR?=
 =?us-ascii?Q?snf7BfA/v/E3MAyIJC+4G5sTsyDUW4XCXoM0119mE6DIUiLcQNkUoOsFCScP?=
 =?us-ascii?Q?z5N7zGRUsPqaQtYndmCwh0+nuLflO8iUpmP7jQbvxuwm5/GhB3ccS7G+EFvA?=
 =?us-ascii?Q?eMDyh28ysHpIICx8ALHYXu8FTTLQi6qY3N7E0LjvoWQQIXGmeoooYMIqEhWO?=
 =?us-ascii?Q?8oiNSp0l6DgrsPWoyee6ydMEm0Q0syAINtSsZ382O/9hzZ/7EO0mR6UYz/Bo?=
 =?us-ascii?Q?lRGDesvZR4/AS2LUHQUkTTcZJ528UKMQxAPVhoSldfrPfEfQLYMv06o5qVX1?=
 =?us-ascii?Q?ig=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: db756bef-9e58-4d8a-5711-08dc9b372a18
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8587.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2024 08:07:21.2494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dl9mGQRXiwoKaWTFlBlUZ35TpU1jfqwYte5vlitm9CeHIX3sOy7U8D7UrxH3vCbzVhYjuCuV15h0nqqWVr9dAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7823
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "Assertion_failed" on:

commit: f53305b8c490815f244c0d44b096abd4f2a63aeb ("[PATCH 8/9] xfs: remove xfs_defer_agfl_block")
url: https://github.com/intel-lab-lkp/linux/commits/Darrick-J-Wong/xfs-convert-skip_discard-to-a-proper-flags-bitset/20240625-204930
base: https://git.kernel.org/cgit/fs/xfs/xfs-linux.git for-next
patch link: https://lore.kernel.org/all/171892418834.3183906.376857417040987772.stgit@frogsfrogsfrogs/
patch subject: [PATCH 8/9] xfs: remove xfs_defer_agfl_block

in testcase: stress-ng
version: stress-ng-x86_64-ecd3fe291-1_20240612
with following parameters:

	nr_threads: 100%
	disk: 1HDD
	testtime: 60s
	fs: xfs
	test: copy-file
	cpufreq_governor: performance



compiler: gcc-13
test machine: 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202407031556.d271bd4c-oliver.sang@intel.com



user  :err   : [   88.899876] [ perf record: Woken up 5 times to write data ]

user  :err   : [   88.979592] [ perf record: Captured and wrote 9.304 MB /tmp/lkp/perf_c2c.data (5470 samples) ]

kern  :warn  : [  101.832173] XFS: Assertion failed: type != XFS_AG_RESV_AGFL, file: fs/xfs/libxfs/xfs_alloc.c, line: 2558
kern  :warn  : [  101.842834] ------------[ cut here ]------------
kern :warn : [  101.848538] WARNING: CPU: 22 PID: 536 at fs/xfs/xfs_message.c:89 asswarn (kbuild/src/consumer/fs/xfs/xfs_message.c:89 (discriminator 1)) xfs
kern  :warn  : [  101.857842] Modules linked in: xfs intel_rapl_msr intel_rapl_common x86_pkg_temp_thermal coretemp btrfs blake2b_generic kvm_intel ipmi_ssif xor raid6_pq libcrc32c kvm crct10dif_pclmul crc32_pclmul crc32c_intel sd_mod ghash_clmulni_intel sg sha512_ssse3 nvme ahci rapl libahci ast nvme_core binfmt_misc t10_pi intel_cstate mei_me drm_shmem_helper acpi_power_meter intel_th_gth crc64_rocksoft_generic i2c_i801 crc64_rocksoft ioatdma intel_th_pci libata intel_uncore drm_kms_helper megaraid_sas i2c_smbus ipmi_si mei intel_pch_thermal acpi_ipmi dax_hmem crc64 intel_th dca wmi ipmi_devintf ipmi_msghandler joydev drm fuse loop dm_mod ip_tables
user  :notice: [  101.860115] stress-ng: metrc: [2914] stressor       bogo ops real time  usr time  sys time   bogo ops/s     bogo ops/s CPU used per       RSS Max
kern  :warn  : [  101.914497] CPU: 22 PID: 536 Comm: kworker/22:1 Not tainted 6.10.0-rc4-00009-gf53305b8c490 #1

kern  :warn  : [  101.929361] Hardware name: Inspur NF5180M6/NF5180M6, BIOS 06.00.04 04/12/2022
user  :notice: [  101.940509] stress-ng: metrc: [2914]                           (secs)    (secs)    (secs)   (real time) (usr+sys time) instance (%)          (KB)
kern  :warn  : [  101.940764] Workqueue: xfs-inodegc/sdb1 xfs_inodegc_worker [xfs]


kern :warn : [  101.962311] RIP: 0010:asswarn (kbuild/src/consumer/fs/xfs/xfs_message.c:89 (discriminator 1)) xfs
user  :notice: [  101.970762] stress-ng: metrc: [2914] copy-file         10938     60.17      0.14      4.61       181.79        2300.90         0.12          3244
kern :warn : [ 101.971200] Code: 90 90 66 0f 1f 00 0f 1f 44 00 00 49 89 d0 41 89 c9 48 c7 c2 90 ed 01 c1 48 89 f1 48 89 fe 48 c7 c7 20 07 01 c1 e8 18 fd ff ff <0f> 0b c3 cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
All code
========
   0:	90                   	nop
   1:	90                   	nop
   2:	66 0f 1f 00          	nopw   (%rax)
   6:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   b:	49 89 d0             	mov    %rdx,%r8
   e:	41 89 c9             	mov    %ecx,%r9d
  11:	48 c7 c2 90 ed 01 c1 	mov    $0xffffffffc101ed90,%rdx
  18:	48 89 f1             	mov    %rsi,%rcx
  1b:	48 89 fe             	mov    %rdi,%rsi
  1e:	48 c7 c7 20 07 01 c1 	mov    $0xffffffffc1010720,%rdi
  25:	e8 18 fd ff ff       	callq  0xfffffffffffffd42
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	c3                   	retq   
  2d:	cc                   	int3   
  2e:	cc                   	int3   
  2f:	cc                   	int3   
  30:	cc                   	int3   
  31:	90                   	nop
  32:	90                   	nop
  33:	90                   	nop
  34:	90                   	nop
  35:	90                   	nop
  36:	90                   	nop
  37:	90                   	nop
  38:	90                   	nop
  39:	90                   	nop
  3a:	90                   	nop
  3b:	90                   	nop
  3c:	90                   	nop
  3d:	90                   	nop
  3e:	90                   	nop
  3f:	90                   	nop

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	c3                   	retq   
   3:	cc                   	int3   
   4:	cc                   	int3   
   5:	cc                   	int3   
   6:	cc                   	int3   
   7:	90                   	nop
   8:	90                   	nop
   9:	90                   	nop
   a:	90                   	nop
   b:	90                   	nop
   c:	90                   	nop
   d:	90                   	nop
   e:	90                   	nop
   f:	90                   	nop
  10:	90                   	nop
  11:	90                   	nop
  12:	90                   	nop
  13:	90                   	nop
  14:	90                   	nop
  15:	90                   	nop

user  :notice: [  101.974008] stress-ng: metrc: [2914] miscellaneous metrics:
kern  :warn  : [  101.978448] RSP: 0018:ffa000000db6f9b8 EFLAGS: 00010246

user  :notice: [  101.993576] stress-ng: metrc: [2914] copy-file           2629.63 MB per sec copy rate (harmonic mean of 64 instances)


kern  :warn  : [  102.020066] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 000000007fffffff
kern  :warn  : [  102.020067] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffc1010720
user  :notice: [  102.026590] stress-ng: info:  [2914] for a 60.26s run time:
kern  :warn  : [  102.028177] RBP: ffa000000db6f9f8 R08: 0000000000000000 R09: 000000000000000a
kern  :warn  : [  102.028178] R10: 000000000000000a R11: 0fffffffffffffff R12: ffa000000db6faa0
kern  :warn  : [  102.028179] R13: ff11004060da7790 R14: 0000000000000000 R15: 0000000000000001

user  :notice: [  102.040178] stress-ng: info:  [2914]    3856.62s available CPU time
kern  :warn  : [  102.041662] FS:  0000000000000000(0000) GS:ff11003fc0900000(0000) knlGS:0000000000000000

user  :notice: [  102.044574] stress-ng: info:  [2914]       0.14s user time   (  0.00%)
kern  :warn  : [  102.051679] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kern  :warn  : [  102.051681] CR2: 000056061f02f700 CR3: 000000407de1c002 CR4: 0000000000771ef0

user  :notice: [  102.060248] stress-ng: info:  [2914]       4.63s system time (  0.12%)
kern  :warn  : [  102.065773] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000

kern  :warn  : [  102.081424] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
kern  :warn  : [  102.081426] PKRU: 55555554
user  :notice: [  102.089981] stress-ng: info:  [2914]       4.77s total time  (  0.12%)
kern  :warn  : [  102.091444] Call Trace:
kern  :warn  : [  102.091446]  <TASK>

user  :notice: [  102.099108] stress-ng: info:  [2914] load average: 42.09 12.22 4.21
kern :warn : [  102.107184] ? __warn (kbuild/src/consumer/kernel/panic.c:693) 



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240703/202407031556.d271bd4c-oliver.sang@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

