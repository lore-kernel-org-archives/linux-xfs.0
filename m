Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DF33FF1;
	Fri,  1 Nov 2024 03:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730432193; cv=fail; b=kPSNMPrZ0HGa6nfSbbN1nnzE/bpgxTXMOFxxyYegmDdvGAKPZHfZwpOPxdcF9wyo2+9s4dnRVBDIqCzmu5/X4qRCPJfEb0xKumKfiPXSMibjTlo5GD5MnrdDULDKYM3vs8WWNe6HKfISoazsxdnRKuyvYz39nJCLMZigfb238M8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730432193; c=relaxed/simple;
	bh=af24CVm7HfeuyDfjzEMKuBvBzEB8ZD8kOb9a584CT08=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KNbGKbFvB3V7jSOaKzVBGCpNLEDKntl3xrNhQLzcHIN1fR74T1jtkdomLBovPv8puugktgmQG3sQVdbi24XiRqc8r0pXVq+CIJF2KhaLaGqFPJSU928t7H8Hxorx+11GIIMjVs9uUpKmMGHqUtCpx+0cXXyQhUEhffeFsZTYud0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T5/QfEgq; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T5/QfEgq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730432191; x=1761968191;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=af24CVm7HfeuyDfjzEMKuBvBzEB8ZD8kOb9a584CT08=;
  b=T5/QfEgqXFbGcyXxQc/lRz3aN4Ki5vWxBmhGkvS47MHN7ZeLn1+YWawo
   kdw+b3b51qIm+JcH7fdRD2c/+8mO0DfTfQOMnoPaV+JLiKY8TQmoHSt4T
   tIPB9Zzs+9PiLGqTifEJfXbf8scrAVlP8JVngGQcEg7jqQ3z0m7e1Ov5W
   t6/p+RpeU5F5uJYK7dFOGvaBZSaBlpEQSw3zJ+5NUCZgeaxqEHgQWvJJO
   8keJEmEqqwsGt6aX8fcg5qynPzbcZI02Ky/seQPBJfgQyv2MkGPuuodN1
   TGn1Rn0tma0SAFk256P8UW+MHXdabxvql4WDFew5nFwR+P+Ig58yzuXvH
   Q==;
X-CSE-ConnectionGUID: +FmQ3MS6Tz+k1Gff2disjA==
X-CSE-MsgGUID: ZdGXgRjqSL2tg7qmHpu17g==
X-IronPort-AV: E=McAfee;i="6700,10204,11242"; a="29627892"
X-IronPort-AV: E=Sophos;i="6.11,248,1725346800"; 
   d="scan'208";a="29627892"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 20:36:30 -0700
X-CSE-ConnectionGUID: GOL1SUaxSg2doZYHmP0vlQ==
X-CSE-MsgGUID: hgydH+2aQEuFafsB5v4t9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,248,1725346800"; 
   d="scan'208";a="113632797"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Oct 2024 20:36:30 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 31 Oct 2024 20:36:30 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 31 Oct 2024 20:36:30 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 31 Oct 2024 20:36:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xLswFKhZNT2GIiLumuajVOpKB/oMzII2nyhbCRkEQylzQPevYDHVSkOV0oNvtlGDei9ToOmPFWIMOc/NVwkzXcEVh+USBPbjmWUKy1Ty0SjQWtp9xESLPjN2Q6mI+q325hwOfSuoMXvTaNRujfcAHgdtecPLgtxYzQM4GZizePmbzcL8RsQyef8zAA8q5N2w2wUk/sM5LqW8kRSOZHFzv0AoBBhqaajsRGL2CFrrlCZIe1AWJsZYLWd0fP2VxXSueUG6ZvI2sCOxMifhS9eAernO5f3+ttAye/aEMtHBcUhYXlBxxgfm3zQL9OU1MHsCr7w0n5h1h+G9BUgn7X+N4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5gmrycYUMatq66F2FIOKohILiuBINn7mN8EwBYfi/Wg=;
 b=kAFMx1VBwimlDMF2vWvovFnMKT78f8zY7YQipE0NiprY3T6vPbH+6xg0Rt56rJc0vHFYpc5cOLD3IV66FrKmw4aiKNtZyIaghNFWJDvNnQ7biGyPoY5ycPnp8R+i5tfKS7XCGxmWAT/+yW/tGrRtJpGLdVfmmVMeKqadnTrKcG94VZ3K5JLDFfcHjm8XPpN7uNbItG2H9JXkrdM/VZXVjT2srIPQ063miZUPcKq5RTpUrJeEYsrotthdi+WXRpkfQC1AQ0ue/AOOfOSJyngJuBVrLEe7zpI39ITOpeFUevsCSMAlE/5GnGzQqnuDIG5QndFGJM2Fk2D7pfuvbA+ZBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8587.namprd11.prod.outlook.com (2603:10b6:a03:568::21)
 by DM6PR11MB4596.namprd11.prod.outlook.com (2603:10b6:5:2a6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.25; Fri, 1 Nov
 2024 03:36:21 +0000
Received: from SJ2PR11MB8587.namprd11.prod.outlook.com
 ([fe80::4050:8bc7:b7c9:c125]) by SJ2PR11MB8587.namprd11.prod.outlook.com
 ([fe80::4050:8bc7:b7c9:c125%4]) with mapi id 15.20.8093.024; Fri, 1 Nov 2024
 03:36:21 +0000
Date: Fri, 1 Nov 2024 11:36:12 +0800
From: kernel test robot <oliver.sang@intel.com>
To: MottiKumar Babu <mottikumarbabu@gmail.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-xfs@vger.kernel.org>,
	<cem@kernel.org>, <djwong@kernel.org>, <chandanbabu@kernel.org>,
	<dchinner@redhat.com>, <zhangjiachen.jaycee@bytedance.com>,
	<linux-kernel@vger.kernel.org>, <linux-kernel-mentees@lists.linux.dev>,
	<anupnewsmail@gmail.com>, <skhan@linuxfoundation.org>,
	<oliver.sang@intel.com>
Subject: Re: [PATCH] Fix out-of-bounds access in xfs_bmapi_allocate by
 validating whichfork
Message-ID: <202411011120.8d4b756-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241027193541.14212-1-mottikumarbabu@gmail.com>
X-ClientProxiedBy: SI2P153CA0002.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::16) To SJ2PR11MB8587.namprd11.prod.outlook.com
 (2603:10b6:a03:568::21)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8587:EE_|DM6PR11MB4596:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b501408-faca-4de8-ade5-08dcfa265a7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?1bw4lh4HX0bufgwP3fuiFfJMTLw8BDOBXNAV6ZX57TRMPHTKaT3PNy2cFulL?=
 =?us-ascii?Q?1F6PkUHBW4uFVhdj9ge+nh0l2iKI4umE3lrQECIfKhO6KaCXU4heMrFVdz6d?=
 =?us-ascii?Q?nKMVSQSr7E9MIwgtx/fUIg7OYmLPfAXyqCIpFzq3DEBPkAnp9jY9icOkXV3P?=
 =?us-ascii?Q?SF9fwlQTySlI0oH5C0OiwJFIbGpp53ou/7NOmRsWBspUFNBbLGAlqn562Bgq?=
 =?us-ascii?Q?O1HRKQBDC5swzkkqRevvlkPaLBIs7LoiJoyxxOkaabXkJohJ+zz+1X5/0fGS?=
 =?us-ascii?Q?SFYUTwYS+3VduDyT1wuocSOZChRvquq3lb4+DD78/SYRGuTFRTxyNi8Qktyk?=
 =?us-ascii?Q?fTXrCHS0B55o5yR9BPmj05gbBh5vtgS87NUZSuaJj90gwNBipqvGi6KDx2li?=
 =?us-ascii?Q?85EJtH7EAKDAX9dKsHtRToTe97r8pQRkFaojqk/PVaB8w2b/SCgQAJL2gB3Y?=
 =?us-ascii?Q?aXTFQo3D0vY7x6AH1z7U7nhV5RGsRqJ2exdwWB242mISvL+4Q7lZzlPlZ1LH?=
 =?us-ascii?Q?ZS6TL9g0CWgsRsR4PEY1lwEHYRA3FAfc+eIFhO0It3Os+ZH2vAyw51ZKzFSZ?=
 =?us-ascii?Q?2/0AmAt/n9hHXEhwsUsBaDQNIdQcEbdSLEsBrcifDO2gYRhrX9GTT1P50xlB?=
 =?us-ascii?Q?XOw8NL+2JdXYhzrcKgibsXn1QJnPfBHvcUkVX7y0AEq9+bjdS/9S64X6pfxI?=
 =?us-ascii?Q?uzXPtbPH7iDdQLSf7G633VQPxi9eCW7c4rpWbiAyUePiqOSttLuBauPP7Sh/?=
 =?us-ascii?Q?/NhnORu/nH8+lEDynW9N+f9ekIdGYNlK1dQThR6izXe7Gz9IX9UjN6i1C3jx?=
 =?us-ascii?Q?7sIInulzW5A8jrIvbZuWB9ZYo3i07OsOMcou83WZjVk8VKelTgejx0jIXUkH?=
 =?us-ascii?Q?CemtVAsaR4vdkhOcNkJAq1F0Yx7mL5Q3HeG5FmUdB/UBwXQTVvpDP6Bn0WDP?=
 =?us-ascii?Q?3InJvJQzZ8jXVy0D/pkESIytuTq7P6kWBPLh6yhcDEzE7EvYWYURiFcYUPLL?=
 =?us-ascii?Q?Aw4bW/3VzezFbsXI0+0Cj+wNOTQXwDJmVPK6YHk7XUMS80MYmVmvybUuKEQK?=
 =?us-ascii?Q?0ZoRYxcsiGDp7VnanfYIWNaGDfxNV5eaGmvy95HnbfcgRJFSO831oZQAjDxg?=
 =?us-ascii?Q?ZytvcoMcC+ErsHxgBZOGC394eSvkW9jlMNfcMncZQIGmOdwovMhRbJB2r3I7?=
 =?us-ascii?Q?N3Zp7jhiwmM8+RS6sdK57v6dyzODxjUkXsBHVixCFCGBvvHLkUNndvepnXLa?=
 =?us-ascii?Q?D/1Dwaz4/NFbxFkgZXJGC6HH5ZG6H2S/ocEsjTszbA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8587.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PiMDW97A9EeE+upBh8BspLhpPtkDilshasQvQoLt8+NK7D8x24IfLgDMcMqe?=
 =?us-ascii?Q?AfW6H6KsH1B3J6cIPCAHKJ6C9BYZHortULWaXzzHPySN0o6b3IciG4eSfbRz?=
 =?us-ascii?Q?Lsi3i3Or3Yaza2jYQO/cdUvjiCLAzG03f9yvy0khvUu1TstQbVU9auLqWnCA?=
 =?us-ascii?Q?kBlEscXI27dmcY1JzexIe24T1cJAErB5p8fkQKu2g5dobU9wzyyTlfMbKTzx?=
 =?us-ascii?Q?TYyPPxkyWqDOWcMjfLWM7NCEzYvnpi/lIPjD91g7jVg7wCpaxesP2+/YMS3J?=
 =?us-ascii?Q?Dj/AmwF/reXJYdvfdh9z8UI42YFi3OUCrp8Q1+Hq9FXbN+5lYUGguSJsaTo6?=
 =?us-ascii?Q?urI+6ZYi8c4ZUu4XiPL79rOZrIoqtBZuyqqNqOZAOamAZjtvKr2/0A6I9cDK?=
 =?us-ascii?Q?Dn9DuAm6ty1e9Rp3O2IgEEBTsZUnTE7RTJ+hpBmLRGXae2S4e98yqAzk7g9f?=
 =?us-ascii?Q?JG5mE/+NML8V+Ow9wO3yFS4gDpjrnq8o4Xk2CTBD8OBshKZnsOvlZpvNNLf4?=
 =?us-ascii?Q?NUkMA6k04kgmCm5V3gwt/BCmNggXrnDCRn9XTTwQeFtvxdvkYWF4p/mycm/F?=
 =?us-ascii?Q?8jfoj4cUZu7WWg/RK9LRvxYKxPn7lvYYK3n1voBqSXuhYHsfgBUzgRLSzmxt?=
 =?us-ascii?Q?yFrD+nzGSEkuwzODwTXvlSuliJNry5EaR/Vaafhu/oiJm5KBEjrwUm8UrU01?=
 =?us-ascii?Q?t/ZN0P0y2E2qe0cSDTKcZKFtqCNRTqCspIRsMhmdJdKaGgOPW8EBZZBBgkFY?=
 =?us-ascii?Q?IfGpdVZrHzL/y8PRKXYk1M4Jno3M/PXNLRGZIok5sKAHNY1whK0WSofsv4Zv?=
 =?us-ascii?Q?upefO7t0//eB6hHzK9vpiuXokg9h5wzMrgsdJwuai81sC3ex1PJioAvEa2fH?=
 =?us-ascii?Q?wtVtzVitkrmHkQdugle7emVJyIRD2sLsclE7ba+6mHbDHM4hRvOBU+CUKEE2?=
 =?us-ascii?Q?d1ZOuHRM99MLI4YA2dPGUqxNsQmqhp7Lflhu4lkCkpuEI7HdZXDVAaSbVBk5?=
 =?us-ascii?Q?tiZJwb1Xc6a7IOBRBpQUxmg+beKp6ZIUPpCDUNKxoYW+MWfxRXqbVlzQ+gct?=
 =?us-ascii?Q?OE8TsCbWTMAzrVaQ6YrYuRz82HaUTBMIHPR9yj6BA3fKBPJ58Tlhf48aHnbw?=
 =?us-ascii?Q?qiC1WQYSG/Yxhe6z7XlphIqEuodnWGJH8obDP8a5Ll5RW6zlVStMWR4PktfL?=
 =?us-ascii?Q?QzuzwGObF1M+J7gx4q5MNn6IeJd8c0YJU1FWvu/mbt1qBZoz+U7WCdZPW4GK?=
 =?us-ascii?Q?wsvN6qnviUzL87MXUHzI/nGRgKli//F/75nnPtDefs0vURhuPMWcBO5oaz0E?=
 =?us-ascii?Q?GZPcv8J0FC9rCzKp3H7btWO6fbDKdlzIfHe+n66E36iRisbZHuddc9ONFBxi?=
 =?us-ascii?Q?BMgk/QQo5/cVoofrPBFIFSKAYOELbrXE13keMrquiG79152HcsZW+spcWNDA?=
 =?us-ascii?Q?5sWhAQa616Oqqyxn0kWPAjWI8OyphIco3HYFmdAP++gDxLBXs4umV5rcga3O?=
 =?us-ascii?Q?vfZje5qif99p1T9d28y96zaibwWwmyISuvr37nGk7Z8W8o7OlVQ/sAvCO/sW?=
 =?us-ascii?Q?kTc+KgMbVV7tupipEYBvU1BMRaKIRnOFpAxIPuMm1ND8tcRQhgU9jBLFpqeN?=
 =?us-ascii?Q?xQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b501408-faca-4de8-ade5-08dcfa265a7c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8587.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2024 03:36:21.6518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N7/M0gOrtPn1p888Q+e+fJBv8MzqLkJ/IJMHGQuTEptbQQ9Ap6CrIu5IP1t5OlbNabKygERn4gyz9qyEpyCnfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4596
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "xfstests.xfs.221.fail" on:

commit: fc3ce21bdce1661bf1b4af5579a7c72c483b0856 ("[PATCH] Fix out-of-bounds access in xfs_bmapi_allocate by validating whichfork")
url: https://github.com/intel-lab-lkp/linux/commits/MottiKumar-Babu/Fix-out-of-bounds-access-in-xfs_bmapi_allocate-by-validating-whichfork/20241028-033645
base: https://git.kernel.org/cgit/fs/xfs/xfs-linux.git for-next
patch link: https://lore.kernel.org/all/20241027193541.14212-1-mottikumarbabu@gmail.com/
patch subject: [PATCH] Fix out-of-bounds access in xfs_bmapi_allocate by validating whichfork

in testcase: xfstests
version: xfstests-x86_64-891f4995-1_20241028
with following parameters:

	disk: 4HDD
	fs: xfs
	test: xfs-221



config: x86_64-rhel-8.3-func
compiler: gcc-12
test machine: 4 threads Intel(R) Xeon(R) CPU E3-1225 v5 @ 3.30GHz (Skylake) with 16G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202411011120.8d4b756-oliver.sang@intel.com

2024-10-31 14:35:22 export TEST_DIR=/fs/sda1
2024-10-31 14:35:22 export TEST_DEV=/dev/sda1
2024-10-31 14:35:22 export FSTYP=xfs
2024-10-31 14:35:22 export SCRATCH_MNT=/fs/scratch
2024-10-31 14:35:22 mkdir /fs/scratch -p
2024-10-31 14:35:22 export SCRATCH_DEV=/dev/sda4
2024-10-31 14:35:22 export SCRATCH_LOGDEV=/dev/sda2
2024-10-31 14:35:22 export SCRATCH_XFS_LIST_METADATA_FIELDS=u3.sfdir3.hdr.parent.i4
2024-10-31 14:35:22 export SCRATCH_XFS_LIST_FUZZ_VERBS=random
2024-10-31 14:35:22 export MKFS_OPTIONS="-mreflink=1 "
2024-10-31 14:35:22 echo xfs/221
2024-10-31 14:35:22 ./check xfs/221
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 lkp-skl-d06 6.12.0-rc2-00034-gfc3ce21bdce1 #1 SMP PREEMPT_DYNAMIC Mon Oct 28 04:16:50 CST 2024
MKFS_OPTIONS  -- -f -mreflink=1 /dev/sda4
MOUNT_OPTIONS -- /dev/sda4 /fs/scratch

xfs/221       - output mismatch (see /lkp/benchmarks/xfstests/results//xfs/221.out.bad)
    --- tests/xfs/221.out	2024-10-28 16:28:46.000000000 +0000
    +++ /lkp/benchmarks/xfstests/results//xfs/221.out.bad	2024-10-31 14:35:30.136173763 +0000
    @@ -8,6 +8,6 @@
     CoW across the transition
     Compare files
     bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-221/file1
    -09101629908f9bdd5d178e7ce20bb1bb  SCRATCH_MNT/test-221/file3
    +fa50dba51826899c372464a153cb2117  SCRATCH_MNT/test-221/file3
     09101629908f9bdd5d178e7ce20bb1bb  SCRATCH_MNT/test-221/file3.chk
     Check extent counts
    ...
    (Run 'diff -u /lkp/benchmarks/xfstests/tests/xfs/221.out /lkp/benchmarks/xfstests/results//xfs/221.out.bad'  to see the entire diff)
Ran: xfs/221
Failures: xfs/221
Failed 1 of 1 tests




The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20241101/202411011120.8d4b756-oliver.sang@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

