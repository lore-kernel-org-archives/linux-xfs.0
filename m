Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28ED74411
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 02:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718938095; cv=fail; b=q4c7HvYXTw+x0lQMmx09rDUL5t8lughFWd9gCPJbx0ndYNzxCRzFbZoSuxVd4OMekWRon3tf95uqI+4BYH83qUNQ6rZIFyjkpQGV+o+YcMdo7Glo9zQK3cexO3zFSYLgnBkASYX5Hbuz/8s0NI9k0tPyLgcmOGkBY3hQk5Fv3uo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718938095; c=relaxed/simple;
	bh=m/bod6LGYSBSv4BukILnVKK1jlaEpPfGnKQB6aWuhoo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=B6lPALGFKkonz6taexl0jlpVqDn7p5mdot+fzM1Dj+Me8I+GmeCPCobj/JwcjU/gNiNzonJHDeEmOFu332gxgNa22SeaBGOGXTh4qQncuYkbDSKQLMt19y6wclsJWb+7U5+Vl8bLY53Eq++6FJao4CkNr1rNQokQX9X3Mv8BXA4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZIRIM0m9; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZIRIM0m9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718938093; x=1750474093;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=m/bod6LGYSBSv4BukILnVKK1jlaEpPfGnKQB6aWuhoo=;
  b=ZIRIM0m9akElOKee7c8KpQX493ynyMQ3l5hI9hV3ax0e4aoFPnBsF0ei
   KX7NJ6Czpo4mOhJ2QG/iP+xDqrcS8FuUi2Lfh2sEuXTYbPBydhs88I1j7
   k2+1G3Md7JIery5WtVKn7VFGrVJuMMLoSVglGL8TiGYGUl0Fe6czB1pMf
   NWiEj2L79v/h2i3w5fG1X7qjpes+s+Yop7IcAvwjj4n7SIZPxqFGar8vU
   CPRB4PJhIorgXBKzqVogxPkp3BXO1+end6IUIsbhe2RkEE1Hsw8ehY3eM
   ARd0k4njlaxAPAdgiLGUEuq685aJeX0myLsOtyqBDzWCR79jnit2KMIJf
   w==;
X-CSE-ConnectionGUID: mJwzBK0nRBuj7H+rkf+3Ww==
X-CSE-MsgGUID: DmPN5uYnR4K6b01ql8/QcQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="16102981"
X-IronPort-AV: E=Sophos;i="6.08,253,1712646000"; 
   d="scan'208";a="16102981"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 19:48:09 -0700
X-CSE-ConnectionGUID: 8fxiOVM2SPi7dIOUeUbi5A==
X-CSE-MsgGUID: 9OlwW3JERjWS5OrnDrQO9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,253,1712646000"; 
   d="scan'208";a="42527843"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 19:48:09 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 19:48:08 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 19:48:08 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 19:48:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zkhrwe4Cf25FPsRlMLY+/GvDGvCxcR6wHkqdiQt7lKGDGaPwF23EiQtpWGNTgPsuLPyadkNDIP3xU2JhF9V7emOF6TKq9mUWrkbzU49E6kd/LkpXh4aqoWxPoYyumjilRWpTFYRmozJ/mlEUzi25t76vuKACWGTqbvtWXkRQCqck+Lkc9qmf5jmsrcI3i/8ZUbOGemmuRsiUkF9Ms5Jr/GjAw7vWXl2QCn3DeTqAaVctI+MfkeUEuKtOOksXEX6sqGn4s9QCbwEimsAPl0tXOIG+SvZ0M2HuBUx6fYqDOuHFWnYhxoH9gQZYzVBBh63MFSWRCMdsAp9byC2Q/B3wDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tk83Gel1nbZi4CDsQwbvtZguV2tUev3w4FRlHHxgHBE=;
 b=A/4rz8rXO2OXVXlbAuxorvWrK0ephr+65sUPhlpUsGB2orsGXpTPYIQIqJjwYihUoSdrRwHNOmLcHWdYVcfBEyADrqhOmfjEKJDKO77zK98GgvT5YCtzZp2nWt8CZ6aWe08MWo7NrYffNZQkHbDjVTq0TzkvPzuUPp/RhLpZlK9gs02eetdLHGg0MZPbXaZEmh6zkgARgJQh4PzJmKDVb5ukCESAxlNVOg4amR5xqr+ipMJ73rNCKb5qMfPWznTatiPrlaOicXUAQTsio7RPmV10G+cXsOv8SrbknRw6uUVXLiyLqDmgpFSRRFmADNfahlMl50g2kPUEvXWy6lN8XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by CH3PR11MB7795.namprd11.prod.outlook.com (2603:10b6:610:120::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.33; Fri, 21 Jun
 2024 02:47:59 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%2]) with mapi id 15.20.7698.017; Fri, 21 Jun 2024
 02:47:59 +0000
Date: Fri, 21 Jun 2024 10:47:49 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: Jeff Layton <jlayton@kernel.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-xfs@vger.kernel.org>,
	<ying.huang@intel.com>, <feng.tang@intel.com>, <fengwei.yin@intel.com>,
	<oliver.sang@intel.com>
Subject: Re: [jlayton:mgtime] [xfs]  4edee232ed:  fio.write_iops -34.9%
 regression
Message-ID: <ZnTp1aNmPjjZ8bGl@xsang-OptiPlex-9020>
References: <202406141453.7a44f956-oliver.sang@intel.com>
 <44cb23219682cf29b1a8b33b886738389eee7557.camel@kernel.org>
Content-Type: multipart/mixed; boundary="lPnmPEBUal380ZL+"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <44cb23219682cf29b1a8b33b886738389eee7557.camel@kernel.org>
X-ClientProxiedBy: SI2P153CA0030.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::15) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|CH3PR11MB7795:EE_
X-MS-Office365-Filtering-Correlation-Id: db9d7e60-2d47-4ec1-7d69-08dc919c8fa9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|1800799021|366013|376011;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?E6B2RlU4MvZjcKYmQ0uHP7XddUBtkv+Vs6wldH0Jrur2YXYekxxuAGOq+z?=
 =?iso-8859-1?Q?EFoWf8N8oD5hm54zedE7GH5t9bDXNOFdKap0vGMk56QuTlpCfgu23aSl3W?=
 =?iso-8859-1?Q?cjHzqYwp5aj7KHp7hvfvcVnUn8M/k/luaAhFj4wj3eHsyI1gkTT0Bw1BLK?=
 =?iso-8859-1?Q?zhYnuH1hAL3vYPcBHFgwcgwLm20bKpDh+qYWD0NIsaKzu66zD6ZduNQ8Qc?=
 =?iso-8859-1?Q?gZt6ufd2MctHmIDZh5YSRnMnuTDAbCHUTNDIVGzrm2gWeUto8OWB0/Zgmf?=
 =?iso-8859-1?Q?ALXBKG3+TZWNWFu9LdPo/3fjZLtMBJyEx2C8GJpJWwgr5KeBdP/TJYP066?=
 =?iso-8859-1?Q?ROkNdnIbMxtv1tT/M/HjNEIAr/rxyhGP6uL76QwIL0UxzXWToKR0lW93fY?=
 =?iso-8859-1?Q?urQ9d2NrhaVsGh0xpUqw558lntStgYYjcRiyE4+LoLieFhPzRz5PSXKCxB?=
 =?iso-8859-1?Q?QA6N+fqMDVzeKaAP3EQAJ9NW5NecvH123RphqGwSPZ6gHJZRTs9NJSH3vs?=
 =?iso-8859-1?Q?pR2a8ihda6+NgGl/DPI80Bc8StREQzPLmBT3fxjKRa/Jr0epI89zYtGQvE?=
 =?iso-8859-1?Q?zOQ7oMGffPYuOkzXyaVj+0i0MBkcUz97Sc87HpXQY7+TZLedOAexsbCHap?=
 =?iso-8859-1?Q?b2/DQzn3OOoK3iQJ+HAiGeVIprlAk9lzuG2EjIekJDWn7wJ/pK/O+cN9jG?=
 =?iso-8859-1?Q?Kh0mk3XTg9d+KGEskzakCTS90QWYUbMr3AKYIlSbA5Op5KLlKwtEatTGvI?=
 =?iso-8859-1?Q?QljHXl94Dz5DEWxRKS3C+OMZt6PW5Yv3mf00oxWZL5W42nZec7S6mIrwnf?=
 =?iso-8859-1?Q?Zr7bgB5u69D0fX1XfmXf9mvjuA3/jL9fobwSKrzlulLCCn36JyMhKPwMiC?=
 =?iso-8859-1?Q?ktVHXpfw2sVouC4OArKTlgRSbf3BUPhYeSS6aAjA9ibNWHf3q0qP5b5wVI?=
 =?iso-8859-1?Q?G+VEHog8Yn3k5YKpLaxGg86Gr3rLjGh+N5MHoO2rpkqTbB7zKHkjaPu7dy?=
 =?iso-8859-1?Q?TgIqsn4lX11ig2f2b8DLb0UPuFCujRD0vPzj0RP6Uat8CUhMLvpwLWFb7b?=
 =?iso-8859-1?Q?4ElBqHgZ0RA/tTLnsCRbNdo19f8NVMdvTlQ9Z5HRIfFXdvrFPrvnfrvNgM?=
 =?iso-8859-1?Q?QWipii63D7h/yWYSjCmaFQZ/ZF6h/fGEjTPItqGuGVN3nxWrpnxh6Ey0u4?=
 =?iso-8859-1?Q?zm+uoMu03oFgoFlSml0sEpm0XUlAQnsKuTavBH7zQqe4RFCOaXJpajdIZG?=
 =?iso-8859-1?Q?bz6H4EfoJMKXVz87Pe/56klH29fJGBpO3Sdpzu6Rk6NUPu2Lko9JBeWpCF?=
 =?iso-8859-1?Q?//iEK+/k3V9SD8OW3muf09uTwg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(366013)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?OVZumiSyR/lFem1bUJHvSbgCv3XfkVuO+ytdb7aUKte7BKMoyNLO8SHSqX?=
 =?iso-8859-1?Q?saJzxN276pjYC5AWTGbZd+7MFRSEqb8eOPmAsHqcsr3MWGH8fViVZfC1P9?=
 =?iso-8859-1?Q?cruKUyRWO+xLLYJIp5+Pu6SoNvekFNQP1Y3oYlspZdzeNuWknW5xzf8MDs?=
 =?iso-8859-1?Q?wIvySvfh5bAnPZAHu41kQbUSajVC4dl/mxmB4RG8jI4K2JxSPPJhrEUkpt?=
 =?iso-8859-1?Q?h8q0ZG1QsDtQW8e9imqabJfY2f450/rRohWEfidMh9ra2H3Au4mywE9eoo?=
 =?iso-8859-1?Q?gHTvAJzd7q+woPNqaaY1RS/QODg+VgxNLRLLnaIMIDosyaje9px0ZCW8Xt?=
 =?iso-8859-1?Q?XWU2W+Gqh7KPrDiN5V2Kz/jgnIF+HIPyfhdsAdHup3OwvRaoWQSamIJFGu?=
 =?iso-8859-1?Q?hQyRLq1aQpzEPwfoFtrVvJ34TWb+VrJEl3XlO4TKImGMwerFiopjD0s4sD?=
 =?iso-8859-1?Q?vm2CLyTCh5dnSxonICgzs0Y0HlyHgaQXwGuF2gChurofjhPssBxJU6PuMY?=
 =?iso-8859-1?Q?+AkttEJofZX3Buk6UPufkWojbQ1jygX7GYMQaRZA6HMiq+pEWnC6HW7GTH?=
 =?iso-8859-1?Q?iyzmSivPAzcroHx7ferwuWODYvIe30dsI4mtaxLsS9v5aX48V59hZ4O5L9?=
 =?iso-8859-1?Q?D3ra4cRdOEeLYPPghh+2QJHsEIcA3YOfZ/RhlFtpwRAjbl5/OiB12puVEH?=
 =?iso-8859-1?Q?b+nBcA9itjPliRaCvhpKgpABhDdpB9ddz4QW5TG3LJFRq+DrS9NAMmQFFN?=
 =?iso-8859-1?Q?5w05K0igmKDtLp/x68mvQ1OgVRpMn9oUhYLsD3yaL+YeB0hA6SbtZdmgxj?=
 =?iso-8859-1?Q?T5bIHKrP1S1Gn/MVjRLvb003O2HH/b5PMFCgY0NYScEFU0fgUfqYHNEvon?=
 =?iso-8859-1?Q?nlH8fifuBCwcv18nWFoZ06zn4dFqZ2USItx/MfzEmo2Gu1guH631QBxjKZ?=
 =?iso-8859-1?Q?nIrnAJBmUfju7OUejNXaoTVO/KWJInoL6asc6Mj+LJTdDDvpCH/GpGWmn2?=
 =?iso-8859-1?Q?ZOtfKUzpwlEkyN5MTGk1XGbiZAizQ3nmsx5U4Jtk0QuyQV4vDN7PA8jE38?=
 =?iso-8859-1?Q?1N6wG5lK7IJlGOvpAQu8MP+mAvwTBpfXAkB+d9/Aqi1VxHTAsqCLxcJI5x?=
 =?iso-8859-1?Q?yhHfl0PmB6HmFLxpfDzI2/NCmRb2ILWiq71/Ddu9LKPX5phocsZWDNGaY9?=
 =?iso-8859-1?Q?Job55ceMgMymNiaa4yKyBMQbW+EgvEt99Vy0gD+FyAhXsML+Gfppnn9WeK?=
 =?iso-8859-1?Q?tququ92nyRfSkOTpdUpliahr8YNzdO7Ayy63nY0j1Bpqjb3xdTqNngcTh0?=
 =?iso-8859-1?Q?RXVpLeGa4WDzvd9qjEsbcqjuwBQDsCBwfAC8a2RC82V0IG0F92z+4cePHL?=
 =?iso-8859-1?Q?7dWriesIKv7zpj70qIrKQUWOf/3Bkuxe46hPAhq95UOMTvvR8J8Pf7KQ90?=
 =?iso-8859-1?Q?1ffSjMGGrfBInwZdRP71nmG7qIk38Qv8lVwjMhBbM5CazoVI9q9yPwiN91?=
 =?iso-8859-1?Q?UZhIO5Hocxa3DpqmIMbsBGUXMS3EqdbXv16YOjfRg67oqpTSLAVb3hZETy?=
 =?iso-8859-1?Q?YPRzs7E16r8XscFPL51Oh9rbCvbljNakSCl5TCOOjm0ZwHv39BpQU1vaGH?=
 =?iso-8859-1?Q?1/nx+J0Z+lztt0UZPtDIi6bgOp8+amTp7Pk6B+D4q652f6us9kod9Xmg?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: db9d7e60-2d47-4ec1-7d69-08dc919c8fa9
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 02:47:59.2630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r9faKz55UGiWVtJ6TVc8QynfEhsc3+IzpmuNmP+fDsOZ6CklUAymtU2xWi/PoN/AdU6tN4mPa2Caw0sQr5PIPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7795
X-OriginatorOrg: intel.com

--lPnmPEBUal380ZL+
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

hi, Jeff Layton,

On Thu, Jun 20, 2024 at 04:16:30PM -0400, Jeff Layton wrote:
> On Fri, 2024-06-14 at 14:24 +0800, kernel test robot wrote:
> > 
> > 
> > Hello,
> > 
> > kernel test robot noticed a -34.9% regression of fio.write_iops on:
> > 
> > 
> > commit: 4edee232ed5d0abb9f24af7af55e3a9aa271f993 ("xfs: switch to multigrain timestamps")
> > https://git.kernel.org/cgit/linux/kernel/git/jlayton/linux.git mgtime
> > 
> > testcase: fio-basic
> > test machine: 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory
> > parameters:
> > 
> > 	runtime: 300s
> > 	disk: 1HDD
> > 	fs: xfs
> > 	nr_task: 1
> > 	test_size: 128G
> > 	rw: write
> > 	bs: 4k
> > 	ioengine: falloc
> > 	cpufreq_governor: performance
> > 
> > 
> > 
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > > Reported-by: kernel test robot <oliver.sang@intel.com>
> > > Closes: https://lore.kernel.org/oe-lkp/202406141453.7a44f956-oliver.sang@intel.com
> > 
> > 
> > Details are as below:
> > -------------------------------------------------------------------------------------------------->
> > 
> > 
> > The kernel config and materials to reproduce are available at:
> > https://download.01.org/0day-ci/archive/20240614/202406141453.7a44f956-oliver.sang@intel.com
> > 
> > =========================================================================================
> > bs/compiler/cpufreq_governor/disk/fs/ioengine/kconfig/nr_task/rootfs/runtime/rw/tbox_group/test_size/testcase:
> >   4k/gcc-13/performance/1HDD/xfs/falloc/x86_64-rhel-8.3/1/debian-12-x86_64-20240206.cgz/300s/write/lkp-icl-2sp9/128G/fio-basic
> > 
> > commit: 
> >   61651220e0 ("fs: have setattr_copy handle multigrain timestamps appropriately")
> >   4edee232ed ("xfs: switch to multigrain timestamps")
> > 
> > 61651220e0b91087 4edee232ed5d0abb9f24af7af55 
> > ---------------- --------------------------- 
> >          %stddev     %change         %stddev
> >              \          |                \  
> >       0.97 ±  3%     -30.7%       0.67 ±  2%  iostat.cpu.user
> >  2.996e+09           +51.5%   4.54e+09        cpuidle..time
> >     222280 ±  4%     +44.7%     321595 ±  4%  cpuidle..usage
> >       0.01 ±  5%      -0.0        0.01 ±  6%  mpstat.cpu.all.irq%
> >       0.97 ±  3%      -0.3        0.66 ±  2%  mpstat.cpu.all.usr%
> >      88.86           +27.3%     113.13        uptime.boot
> >       5387           +28.4%       6916        uptime.idle
> >       2.98 ±  3%     -10.9%       2.65 ±  2%  vmstat.procs.r
> >       3475 ± 10%     -18.6%       2830 ±  6%  vmstat.system.cs
> >       4.65 ± 43%      -2.7        1.97 ±143%  perf-profile.calltrace.cycles-pp._free_event.perf_event_release_kernel.perf_release.__fput.task_work_run
> >       4.65 ± 43%      -2.7        1.97 ±143%  perf-profile.children.cycles-pp._free_event
> >       3.33 ± 76%      -2.4        0.90 ±141%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
> >       3.33 ± 76%      -2.4        0.90 ±141%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
> >     769.93            +9.4%     842.10        proc-vmstat.nr_active_anon
> >       3936            +2.1%       4020        proc-vmstat.nr_shmem
> >     769.93            +9.4%     842.10        proc-vmstat.nr_zone_active_anon
> >     269328           +20.8%     325325 ± 11%  proc-vmstat.numa_hit
> >     203054 ±  2%     +27.6%     259008 ± 14%  proc-vmstat.numa_local
> >     297923           +16.3%     346459        proc-vmstat.pgalloc_normal
> >     181868 ±  2%     +30.2%     236868        proc-vmstat.pgfault
> >     173268 ±  3%     +27.2%     220312        proc-vmstat.pgfree
> >       9141 ±  7%     +23.5%      11288 ±  4%  proc-vmstat.pgreuse
> >       0.02 ± 26%      +0.1        0.10 ±  6%  fio.latency_10us%
> >      99.87            -8.4       91.43        fio.latency_2us%
> >       0.11 ± 20%      +8.4        8.47        fio.latency_4us%
> >      46.16           +53.3%      70.78        fio.time.elapsed_time
> >      46.16           +53.3%      70.78        fio.time.elapsed_time.max
> >      35.68           +66.7%      59.50        fio.time.system_time
> >       4940           +52.6%       7538        fio.time.voluntary_context_switches
> >       2857           -34.9%       1859        fio.write_bw_MBps
> >       1176           +64.4%       1933        fio.write_clat_90%_ns
> >       1200           +83.1%       2197        fio.write_clat_95%_ns
> >       1528           +46.6%       2240        fio.write_clat_99%_ns
> >       1167           +62.2%       1893        fio.write_clat_mean_ns
> >     731537           -34.9%     476002        fio.write_iops
> 
> I've been trying for several days to reproduce this, and have been
> unable so far. Is this the same value as "write.iops" in the json
> output? That's been my assumption, but I wanted to check that first.

right. then we calculate the average from 6 runs.

I attached fio.output from one run for 4edee232ed as example, witin it:

      "write" : {
        "io_bytes" : 137438953472,
        "io_kbytes" : 134217728,
        "bw_bytes" : 1950180255,
        "bw" : 1904472,
        "iops" : 476118.226321,     <-----
        "runtime" : 70475,
        "total_ios" : 33554432,
        "short_ios" : 0,
        "drop_ios" : 0,
...


> 
> That said, I'm only getting ~500k iops at best in this test with the
> rig I have, so it's possible I need something faster to show it.
> 
> 
> >       0.06 ±  6%     -25.5%       0.04 ±  5%  perf-stat.i.MPKI
> >       0.91 ±  3%      -0.2        0.67 ±  3%  perf-stat.i.branch-miss-rate%
> >   27659069 ±  3%     -28.0%   19920836 ±  4%  perf-stat.i.branch-misses
> >     822504 ±  5%     -25.2%     615111 ±  6%  perf-stat.i.cache-misses
> >    7527159 ±  6%     -26.9%    5499750 ±  3%  perf-stat.i.cache-references
> >       3394 ± 11%     -18.8%       2756 ±  7%  perf-stat.i.context-switches
> >       0.46 ±  2%     -13.0%       0.40        perf-stat.i.cpi
> >  5.727e+09 ±  2%     -12.3%   5.02e+09        perf-stat.i.cpu-cycles
> >      74.31            -3.0%      72.05        perf-stat.i.cpu-migrations
> >       2.31           +13.1%       2.61        perf-stat.i.ipc
> >       2905 ±  2%      -7.2%       2695 ±  2%  perf-stat.i.minor-faults
> >       2905 ±  2%      -7.2%       2695 ±  2%  perf-stat.i.page-faults
> >       0.07 ±  6%     -25.7%       0.05 ±  5%  perf-stat.overall.MPKI
> >       1.18 ±  3%      -0.3        0.87 ±  2%  perf-stat.overall.branch-miss-rate%
> >       0.48 ±  2%     -12.9%       0.42        perf-stat.overall.cpi
> >       6992 ±  6%     +17.1%       8190 ±  5%  perf-stat.overall.cycles-between-cache-misses
> >       2.09 ±  2%     +14.7%       2.40        perf-stat.overall.ipc
> >      16640           +53.3%      25504        perf-stat.overall.path-length
> >   27090197 ±  3%     -27.4%   19666246 ±  4%  perf-stat.ps.branch-misses
> >     805963 ±  5%     -24.6%     607413 ±  6%  perf-stat.ps.cache-misses
> >    7402971 ±  6%     -26.4%    5446622 ±  3%  perf-stat.ps.cache-references
> >       3329 ± 11%     -18.2%       2723 ±  7%  perf-stat.ps.context-switches
> >  5.616e+09 ±  2%     -11.7%  4.956e+09        perf-stat.ps.cpu-cycles
> >       2843 ±  2%      -6.5%       2657 ±  2%  perf-stat.ps.minor-faults
> >       2843 ±  2%      -6.5%       2657 ±  2%  perf-stat.ps.page-faults
> >  5.584e+11           +53.3%  8.558e+11        perf-stat.total.instructions
> > 
> > 
> > 
> > 
> > Disclaimer:
> > Results have been estimated based on internal Intel analysis and are provided
> > for informational purposes only. Any difference in system hardware or software
> > design or configuration may affect actual performance.
> > 
> > 
> 
> Thanks!
> -- 
> Jeff Layton <jlayton@kernel.org>

--lPnmPEBUal380ZL+
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="fio.output"

note: both iodepth >= 1 and synchronous I/O engine are selected, queue depth will be capped at 1
{
  "fio version" : "fio-3.33",
  "timestamp" : 1718334968,
  "timestamp_ms" : 1718334968213,
  "time" : "Fri Jun 14 03:16:08 2024",
  "global options" : {
    "bs" : "4k",
    "ioengine" : "falloc",
    "iodepth" : "32",
    "size" : "137438953472",
    "direct" : "0",
    "runtime" : "300",
    "file_service_type" : "roundrobin",
    "random_distribution" : "random",
    "pre_read" : "0",
    "nrfiles" : "1",
    "filesize" : "137438953472",
    "invalidate" : "1",
    "fallocate" : "posix",
    "io_size" : "137438953472"
  },
  "jobs" : [
    {
      "jobname" : "task_0",
      "groupid" : 0,
      "error" : 0,
      "eta" : 0,
      "elapsed" : 71,
      "job options" : {
        "rw" : "write",
        "directory" : "/fs/sdb1",
        "numjobs" : "1"
      },
      "read" : {
        "io_bytes" : 0,
        "io_kbytes" : 0,
        "bw_bytes" : 0,
        "bw" : 0,
        "iops" : 0.000000,
        "runtime" : 0,
        "total_ios" : 0,
        "short_ios" : 0,
        "drop_ios" : 0,
        "slat_ns" : {
          "min" : 0,
          "max" : 0,
          "mean" : 0.000000,
          "stddev" : 0.000000,
          "N" : 0
        },
        "clat_ns" : {
          "min" : 0,
          "max" : 0,
          "mean" : 0.000000,
          "stddev" : 0.000000,
          "N" : 0
        },
        "lat_ns" : {
          "min" : 0,
          "max" : 0,
          "mean" : 0.000000,
          "stddev" : 0.000000,
          "N" : 0
        },
        "bw_min" : 0,
        "bw_max" : 0,
        "bw_agg" : 0.000000,
        "bw_mean" : 0.000000,
        "bw_dev" : 0.000000,
        "bw_samples" : 0,
        "iops_min" : 0,
        "iops_max" : 0,
        "iops_mean" : 0.000000,
        "iops_stddev" : 0.000000,
        "iops_samples" : 0
      },
      "write" : {
        "io_bytes" : 137438953472,
        "io_kbytes" : 134217728,
        "bw_bytes" : 1950180255,
        "bw" : 1904472,
        "iops" : 476118.226321,
        "runtime" : 70475,
        "total_ios" : 33554432,
        "short_ios" : 0,
        "drop_ios" : 0,
        "slat_ns" : {
          "min" : 0,
          "max" : 0,
          "mean" : 0.000000,
          "stddev" : 0.000000,
          "N" : 0
        },
        "clat_ns" : {
          "min" : 1778,
          "max" : 71068,
          "mean" : 1894.879822,
          "stddev" : 149.956185,
          "N" : 33554432,
          "percentile" : {
            "1.000000" : 1816,
            "5.000000" : 1816,
            "10.000000" : 1832,
            "20.000000" : 1832,
            "30.000000" : 1848,
            "40.000000" : 1848,
            "50.000000" : 1864,
            "60.000000" : 1864,
            "70.000000" : 1880,
            "80.000000" : 1896,
            "90.000000" : 1944,
            "95.000000" : 2192,
            "99.000000" : 2256,
            "99.500000" : 2288,
            "99.900000" : 4080,
            "99.950000" : 4512,
            "99.990000" : 5408
          }
        },
        "lat_ns" : {
          "min" : 1812,
          "max" : 71102,
          "mean" : 1929.203544,
          "stddev" : 150.831850,
          "N" : 33554432
        },
        "bw_min" : 1823696,
        "bw_max" : 1925208,
        "bw_agg" : 100.000000,
        "bw_mean" : 1904624.685714,
        "bw_dev" : 19260.493657,
        "bw_samples" : 140,
        "iops_min" : 455924,
        "iops_max" : 481302,
        "iops_mean" : 476156.171429,
        "iops_stddev" : 4815.123414,
        "iops_samples" : 140
      },
      "trim" : {
        "io_bytes" : 0,
        "io_kbytes" : 0,
        "bw_bytes" : 0,
        "bw" : 0,
        "iops" : 0.000000,
        "runtime" : 0,
        "total_ios" : 0,
        "short_ios" : 0,
        "drop_ios" : 0,
        "slat_ns" : {
          "min" : 0,
          "max" : 0,
          "mean" : 0.000000,
          "stddev" : 0.000000,
          "N" : 0
        },
        "clat_ns" : {
          "min" : 0,
          "max" : 0,
          "mean" : 0.000000,
          "stddev" : 0.000000,
          "N" : 0
        },
        "lat_ns" : {
          "min" : 0,
          "max" : 0,
          "mean" : 0.000000,
          "stddev" : 0.000000,
          "N" : 0
        },
        "bw_min" : 0,
        "bw_max" : 0,
        "bw_agg" : 0.000000,
        "bw_mean" : 0.000000,
        "bw_dev" : 0.000000,
        "bw_samples" : 0,
        "iops_min" : 0,
        "iops_max" : 0,
        "iops_mean" : 0.000000,
        "iops_stddev" : 0.000000,
        "iops_samples" : 0
      },
      "sync" : {
        "total_ios" : 0,
        "lat_ns" : {
          "min" : 0,
          "max" : 0,
          "mean" : 0.000000,
          "stddev" : 0.000000,
          "N" : 0
        }
      },
      "job_runtime" : 70474,
      "usr_cpu" : 15.249596,
      "sys_cpu" : 84.560263,
      "ctx" : 177,
      "majf" : 0,
      "minf" : 11,
      "iodepth_level" : {
        "1" : 100.000000,
        "2" : 0.000000,
        "4" : 0.000000,
        "8" : 0.000000,
        "16" : 0.000000,
        "32" : 0.000000,
        ">=64" : 0.000000
      },
      "iodepth_submit" : {
        "0" : 0.000000,
        "4" : 100.000000,
        "8" : 0.000000,
        "16" : 0.000000,
        "32" : 0.000000,
        "64" : 0.000000,
        ">=64" : 0.000000
      },
      "iodepth_complete" : {
        "0" : 0.000000,
        "4" : 100.000000,
        "8" : 0.000000,
        "16" : 0.000000,
        "32" : 0.000000,
        "64" : 0.000000,
        ">=64" : 0.000000
      },
      "latency_ns" : {
        "2" : 0.000000,
        "4" : 0.000000,
        "10" : 0.000000,
        "20" : 0.000000,
        "50" : 0.000000,
        "100" : 0.000000,
        "250" : 0.000000,
        "500" : 0.000000,
        "750" : 0.000000,
        "1000" : 0.000000
      },
      "latency_us" : {
        "2" : 91.456613,
        "4" : 8.435845,
        "10" : 0.107190,
        "20" : 0.010000,
        "50" : 0.010000,
        "100" : 0.010000,
        "250" : 0.000000,
        "500" : 0.000000,
        "750" : 0.000000,
        "1000" : 0.000000
      },
      "latency_ms" : {
        "2" : 0.000000,
        "4" : 0.000000,
        "10" : 0.000000,
        "20" : 0.000000,
        "50" : 0.000000,
        "100" : 0.000000,
        "250" : 0.000000,
        "500" : 0.000000,
        "750" : 0.000000,
        "1000" : 0.000000,
        "2000" : 0.000000,
        ">=2000" : 0.000000
      },
      "latency_depth" : 32,
      "latency_target" : 0,
      "latency_percentile" : 100.000000,
      "latency_window" : 0
    }
  ],
  "disk_util" : [
    {
      "name" : "sdb",
      "read_ios" : 0,
      "write_ios" : 18,
      "read_merges" : 0,
      "write_merges" : 6,
      "read_ticks" : 0,
      "write_ticks" : 5662,
      "in_queue" : 6085,
      "util" : 1.103687
    }
  ]
}

--lPnmPEBUal380ZL+--
