Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A70204F74
	for <linux-xfs@vger.kernel.org>; Wed, 16 Oct 2024 08:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729069127; cv=fail; b=n+hTY/oSIFL//NSg+5y5WIYGKY9Z2yWcWTxeikl0JXafN/9mERDC7v7KT9DjYWYzGMFjt+kyHjyHpjlBz6HCle9IOySyRpDGo+qd7RFMTbXFwRtjJS1d/2PcU4SY9ATv0C6wbjL7PfKUBbsk7AoCZIJ9KZEsHAzfFsi2/ndYbg8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729069127; c=relaxed/simple;
	bh=DNG4uh8KobmaGXt0auD6Flj9zCMx3QV3SIM3BYNgSng=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jTwWKBerqb2YGa+8VdJXis0If7KnzYXdpbNDIyzAmdCjXxkdVV37xeGnK00IuHqpDNv0I1Zyj5EIX75g45OJYx+oBe6VFa5XWmggxURGWiPkuQGT3XiexJxNJxUsNBUpgK+d7ZjNJLo2ZxZWRYroafvxpj2yiWMD1k0M3oJMSGw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VaZd0E/W; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VaZd0E/W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729069124; x=1760605124;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=DNG4uh8KobmaGXt0auD6Flj9zCMx3QV3SIM3BYNgSng=;
  b=VaZd0E/W90vJTyAyAb2Eex0AjCwY3kUCeFZ4ypgY+ZqzPh7UjCaqnDlM
   R1L3MIOZtdQJA1gkDhsvK9mzvPxZgIAsnDpjFXwi+Jq1r94/8Hs5jOUxX
   q7Igmwre+508DxCPBNzQHF8PQ80lbx/fwSCdYW+g/2lxwOUeFUStpP30n
   tV0rrcDSEPbVji6F8T7aIPV5juZgoVvcbomIykRZcHQUe3fInpdhzOjSn
   U4TZNPZ14912ZhfoHSnY6ghIjvXj8mTGdyPkMEhqOYBTXL8tt/jx/1Mil
   EjMG+Dd1uZdaKOkdUUfl8VdL/4kJv9JQnCjCXc7AoVmfrvQKC6EASs1OU
   Q==;
X-CSE-ConnectionGUID: /nqYDagcQnaFmqgGQYH5Ug==
X-CSE-MsgGUID: D5IM3+GMQAGiUjH3BVyP6A==
X-IronPort-AV: E=McAfee;i="6700,10204,11225"; a="39081049"
X-IronPort-AV: E=Sophos;i="6.11,207,1725346800"; 
   d="scan'208";a="39081049"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2024 01:58:43 -0700
X-CSE-ConnectionGUID: QfXhZ7KBTX+akmpGb/Myww==
X-CSE-MsgGUID: 1x12QWGWTWKMBPyQu5AeBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,207,1725346800"; 
   d="scan'208";a="77839719"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Oct 2024 01:58:43 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 16 Oct 2024 01:58:42 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 16 Oct 2024 01:58:42 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 16 Oct 2024 01:58:42 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 16 Oct 2024 01:58:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UOR6E6hDHs4fJ1CF99jeGWZhWGZF7iUjj6s7JZiuciZobb0Y+e1nQSJ/4wSRMQ8CKZhjV2vNaMkctrcDqIAj5rjFhXdqIYeO6bSkjA1rL+tXtuK4Zxk0554hIh7pZ2qNdU2A+yUwdkEfuEXGVk7ViYTgQT4eVuUCyoNwXf1aEBfQgCjoygeGWeT6XVr9vqaLYgSaSWjljZf/KkkZRINvmE0RVHVWU6zzPVB+1U43fHVeP/XTZZ8JeItHSrq61eAcnKXtaGMaxvBMp6zVjrseC7hiIuaIne/koQfjBKmgP6uvLsYLdQOfNFe4opgD6/AVewR38TsCjHU2u6YLVNs1ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IlXJqzo6X1wXRix3PFOgj/ZFyFUG2GnK4h0BxPRh5R8=;
 b=LLP36pT2h5MJEH39KF21MHihkUo4RykQqTMYFWBblnk4i6j/o66II86RnVNgDlAlusKnGbCdreWI5Uo24lFa0vSoAR33aqXDJqd/LjCSx6adCeN9iu1xi+iPKJWpwPyaxEhTNs6sfp3GxK1S4b9DPdLBROSvszaNnNBJ6GQYJBTaekmR0pzr9r3GoVFD9gapR09Pg8QzOy/8XSOY34E4dw+ElwmFlj1ypeOJ9hzA1X6uNn3Hqtokb6aMdgS4+qqjqHMUu/u6pM+mtddC0DikJVsKVlzi4SAeiWpCidVw3v3kgf5VhTeylzt4VPahpFttBnl3spwr3RtSdHi4wb5TpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5423.namprd11.prod.outlook.com (2603:10b6:5:39b::20)
 by SN7PR11MB7995.namprd11.prod.outlook.com (2603:10b6:806:2e2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.21; Wed, 16 Oct
 2024 08:58:39 +0000
Received: from DM4PR11MB5423.namprd11.prod.outlook.com
 ([fe80::dffa:e0c8:dbf1:c82e]) by DM4PR11MB5423.namprd11.prod.outlook.com
 ([fe80::dffa:e0c8:dbf1:c82e%3]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 08:58:39 +0000
Date: Wed, 16 Oct 2024 16:58:30 +0800
From: kernel test robot <lkp@intel.com>
To: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>
CC: <oe-kbuild-all@lists.linux.dev>, xfs <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: port xfs/122 to the kernel
Message-ID: <Zw+ANpfFdGD5fqtv@rli9-mobl>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241011182407.GC21853@frogsfrogsfrogs>
X-ClientProxiedBy: SG2PR04CA0158.apcprd04.prod.outlook.com (2603:1096:4::20)
 To DM4PR11MB5423.namprd11.prod.outlook.com (2603:10b6:5:39b::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5423:EE_|SN7PR11MB7995:EE_
X-MS-Office365-Filtering-Correlation-Id: c7923bbe-674d-47b8-b90c-08dcedc0b9dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?2CmWXtL+mv6ZhQZ73suIK31VZNtnSoVhq7dOG/ct8BGRv7qZbPkB2HRoWeIB?=
 =?us-ascii?Q?qPX+LQuMhSMX9i9oXDjwVaSMiEhmN3ozARn2TaYW/DXDQ+iWr5v06+tROkjp?=
 =?us-ascii?Q?iLWJZV1mHAegt4BHZJVPfZdwM0Q4IbI9R1wxI9Hg+lZdYQZzJNNdi2UGw4Hv?=
 =?us-ascii?Q?cYNminAQHw9gnlOtZgl8tutsKxrJVA1P40/YOToYeXyZCGeY3FCWn79j+THk?=
 =?us-ascii?Q?sZKDazwcZfQGDyaXBCwdnaOn7lZlxt5+wWBdve3sj0XQXdc4gI39dyeXBX4d?=
 =?us-ascii?Q?n8iTVRHuz3DvicFOMi1/aBEP+/1trjW0bZk57DUwy7pEy+WG/GUSJCTpLTNe?=
 =?us-ascii?Q?4WODrwBojgLVn0KEfxwQt2l4VahL7cW3XuRXi/NLd1ynt5XpqOTFKbzFCUT5?=
 =?us-ascii?Q?1cEQhK/QKsUrtfZFzwEM118P/VLa5GrfGQ+SZwUIjxAQtpDO8hoj+j9vwVro?=
 =?us-ascii?Q?rU1i5/GPsjvqVLD8S07EJp1ljJ3zEPpP8O+PCWR3ezt+iKodcQlY82tlnJIQ?=
 =?us-ascii?Q?8QaXQI6fMfcXOPULBvIMCR9xGY0Y/ZIh59wo/iYul97+yYlKciVTdb1o2sGa?=
 =?us-ascii?Q?63QwD0R/UUjeOfbBur4hwxMgGQhwaKYxTGJMwyeUKy0+QQ43ElH0jH1CiSCQ?=
 =?us-ascii?Q?skdTUm75bYVERY7bMSHvJTqK980XQ4kZG4Z9Jz7cOxHG7pUCDsGdRMQqZ/cr?=
 =?us-ascii?Q?galWhyeQGjO5vM53Jc+nw625rcu7uNDbczN6rvNNNr0UZU4+bWKBA/jzHWCQ?=
 =?us-ascii?Q?yrkdGhUobke8PuTVwVACFEWDQ8lOm8o5pTLPpkrkfMgIl9UGBPUeOT2IHuML?=
 =?us-ascii?Q?k9yC/vQzoD+oaGtGDWugPtpTxR6d57LyshqTRB5RRGcOO6qqDvAr4vZ5WLlH?=
 =?us-ascii?Q?XkG3BNwvKrWng4BMTHl7e3ymQrZYvSgr0zW715+hFNso2kzu/ZSaYr++ND2v?=
 =?us-ascii?Q?IAWTLDKvYdzUkqi6mzfpYLU+nJW2iPDbrPWCecbBHe6i/vbkvl0jyWl+UsJ6?=
 =?us-ascii?Q?VhMoMafRIV0uabKt4qYsR8tF+p3Km8MZiEbmaaAyPM4OQy6q/GCjwAKx6YLH?=
 =?us-ascii?Q?2otZyiBUQr/cumxGMEu4tLiklqCFU4r+Ay3lnXnlu/AqLcO9naWjFH6rQXKp?=
 =?us-ascii?Q?jW2t8q3SzZOMOZciJbPTaH5u2DVRpodw0ppFuxKKQzjeksTMJoMauSfm0uMp?=
 =?us-ascii?Q?FixlHpOCKz6YMMumocBAoa6CTm/ogg09LWwv8zAbw+18n95LahtaYytO4YU?=
 =?us-ascii?Q?=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5423.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RGM+JFIIGWAlD9JEl26iPRNo2qGSH+aKNMXosmmzZty2e7MEwCqAIAUbKKYF?=
 =?us-ascii?Q?wjgvVyWqRU78RUgcvr/PioWOXEbYG+a1bdEFTdghoLpmq2obrhBOA5PCK9bN?=
 =?us-ascii?Q?9o3cUlvOWueOcG2iTUMhgOXSdJ5PQ7/ZbccVnH9l45R5Xez6NKGvGi0D2MoB?=
 =?us-ascii?Q?IGt4NvektjHxi1hPI2UVPFX1bszIYF0HYApDU+pSYedXuP0IkiSayJQO+H8w?=
 =?us-ascii?Q?7NWs0fQ2hPJ4q3BQkn8c10XI5rqi6O5+roTILHbNnIR7hkQJ3aVibvYLeuFM?=
 =?us-ascii?Q?ypwtr+a56TKFO4/qpS0IGPgcYwoPDq97jdS8DDB1fSaq2yc0Y0aGm819Gw00?=
 =?us-ascii?Q?9DYFubXkYn5Ylt2QO2rXk/ASjLSN3tA6sh4tBoBgsK0a82yNWEsxb+xyeWNl?=
 =?us-ascii?Q?QL/PJEzFZk6Oz7zUtElaasYSUlRZNE3d+JojcKkfOFlg1il4EWT4PlKwXlLb?=
 =?us-ascii?Q?4q+Q/iGMnq1IkOK2AvdDWH3BbEujSoVATZd9YhgCjqWTWE9qqRCMpwmR0w36?=
 =?us-ascii?Q?BqNrW3Act1gXHSRqXch8yu9cwJGR58sccLcTKXGGmkyrXzhg/hoKcKug952s?=
 =?us-ascii?Q?lOy97FsBYFxMLM4azttCreZ5cl9XLMAdgryLNe6JTCyQK0VbkzZYeVyRR43h?=
 =?us-ascii?Q?tGX2Gmqi3axFmekCfSF0np1va5FlZYlNebOlLHol2p4InL24C4jP2iKGlAoW?=
 =?us-ascii?Q?zo5CiUB3v1S7SomI3mfwxmWMf8mXds2I9WATt6ONZ/+AQtZOyT0Csk5mrxxT?=
 =?us-ascii?Q?J3bJXi2B+41jVcRhpWo23FipBQCdjBDfXafQk9BsjIqu3OzKRnZWXJeD727q?=
 =?us-ascii?Q?bA0KlKIYWq34kwfmDnt3vN+nZurFQRhWJSdg+m2vgN29mzLhPP5SCoyIU5vP?=
 =?us-ascii?Q?itUaKpx6URFjSJpqDJxHSKBb1+ULWkL9B3r5x17DW/fGOAq+AOOly+NE8v/L?=
 =?us-ascii?Q?+oLwUt+Q6S7VM0jcRReylzSkcoz3254tXaq7t32LktSaJimk9eghIa/Vc2Fj?=
 =?us-ascii?Q?E8Fe4fno6u3iUz62rMKPQMLUmi8zrKe5szShmfLWGE7pBmb4fzUSpKzVxXLb?=
 =?us-ascii?Q?tYgwt8tKmtIvMLK9pZZ6sHnFQH93TIAH5WiwpzVkED9EEGhydB2Vmf0pdlfD?=
 =?us-ascii?Q?hxxF1tSU8g+cXuSG1eNomH8qLjl2YMtf+4ifYelbtdxxn8K3CC0ceMnhom5K?=
 =?us-ascii?Q?OpNd5xjtLcvtI3JolJ7ydORsBzBI220Y3mKD9/xElFWQsdUQWiRFBA1rAP/X?=
 =?us-ascii?Q?fj3kO3wvigNDqyAh23b6eVKqV3oQMQzR54zCmf9lLQk6VhWSXLH9s6gyUxav?=
 =?us-ascii?Q?Cy3Hh3aGarXa4cm1mtQbjylFG4ppqwYdAp6xVfSXazBhnrYIueF4z2CxQRjF?=
 =?us-ascii?Q?5gYJOFfUFI/v4kRTBkB+jykdPlPT0ZObPjYvyFhASD+xHa26e9MuiCPyMlVI?=
 =?us-ascii?Q?M+OtmKSACmwgtmirpbDitA7gkhCCEy6qaHLC0cPjQO2Eh6e0iE7AUf3opOkR?=
 =?us-ascii?Q?ZHRvs7D/fateqefSMv7tYmg41RdJXSGRE3dXlZTYaYFqwwxXNCYih7f80DVx?=
 =?us-ascii?Q?35vhv4wMHvZsbYBbCneA9c5gc3QvnKrNqQbBHJ9E?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c7923bbe-674d-47b8-b90c-08dcedc0b9dc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5423.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 08:58:39.1722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 23JROaSgtesH9pGP9yiT3d6uaz3b03AqEe4CFnLD3hBo4x99dla+lYOkdej+Dk0R5mrZ75W5LNooT7IpH5LqIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7995
X-OriginatorOrg: intel.com

Hi Darrick,

kernel test robot noticed the following build warnings:

[auto build test WARNING on xfs-linux/for-next]
[also build test WARNING on linus/master v6.12-rc3 next-20241014]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Darrick-J-Wong/xfs-port-xfs-122-to-the-kernel/20241012-022552
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
patch link:    https://lore.kernel.org/r/20241011182407.GC21853%40frogsfrogsfrogs
patch subject: [PATCH] xfs: port xfs/122 to the kernel
:::::: branch date: 4 days ago
:::::: commit date: 4 days ago
config: arm-randconfig-r132-20241015 (https://download.01.org/0day-ci/archive/20241015/202410151539.xVeElBsB-lkp@intel.com/config)
compiler: clang version 20.0.0git (https://github.com/llvm/llvm-project 70e0a7e7e6a8541bcc46908c592eed561850e416)
reproduce: (https://download.01.org/0day-ci/archive/20241015/202410151539.xVeElBsB-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/r/202410151539.xVeElBsB-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   fs/xfs/xfs_super.c: note: in included file:
>> fs/xfs/libxfs/xfs_ondisk.h:302:9: sparse: sparse: static assertion failed: "XFS: sizeof(struct xfs_fsop_geom_v1) is wrong, expected 112"

vim +302 fs/xfs/libxfs/xfs_ondisk.h

30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09    8  
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09    9  #define XFS_CHECK_STRUCT_SIZE(structname, size) \
c12c50393c1f6f fs/xfs/xfs_ondisk.h        Christoph Hellwig 2023-12-04   10  	static_assert(sizeof(structname) == (size), \
c12c50393c1f6f fs/xfs/xfs_ondisk.h        Christoph Hellwig 2023-12-04   11  		"XFS: sizeof(" #structname ") is wrong, expected " #size)
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   12  
3f94c441e2c3de fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-06-21   13  #define XFS_CHECK_OFFSET(structname, member, off) \
c12c50393c1f6f fs/xfs/xfs_ondisk.h        Christoph Hellwig 2023-12-04   14  	static_assert(offsetof(structname, member) == (off), \
3f94c441e2c3de fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-06-21   15  		"XFS: offsetof(" #structname ", " #member ") is wrong, " \
3f94c441e2c3de fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-06-21   16  		"expected " #off)
3f94c441e2c3de fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-06-21   17  
f93e5436f0ee5a fs/xfs/xfs_ondisk.h        Darrick J. Wong   2020-08-17   18  #define XFS_CHECK_VALUE(value, expected) \
c12c50393c1f6f fs/xfs/xfs_ondisk.h        Christoph Hellwig 2023-12-04   19  	static_assert((value) == (expected), \
f93e5436f0ee5a fs/xfs/xfs_ondisk.h        Darrick J. Wong   2020-08-17   20  		"XFS: value of " #value " is wrong, expected " #expected)
f93e5436f0ee5a fs/xfs/xfs_ondisk.h        Darrick J. Wong   2020-08-17   21  
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11   22  #define XFS_CHECK_SB_OFFSET(field, offset) \
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11   23  	XFS_CHECK_OFFSET(struct xfs_dsb, field, offset); \
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11   24  	XFS_CHECK_OFFSET(struct xfs_sb, field, offset);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11   25  
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   26  static inline void __init
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   27  xfs_check_ondisk_structs(void)
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   28  {
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   29  	/* ag/file structures */
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   30  	XFS_CHECK_STRUCT_SIZE(struct xfs_acl,			4);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   31  	XFS_CHECK_STRUCT_SIZE(struct xfs_acl_entry,		12);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   32  	XFS_CHECK_STRUCT_SIZE(struct xfs_agf,			224);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   33  	XFS_CHECK_STRUCT_SIZE(struct xfs_agfl,			36);
2a39946c984464 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2020-08-17   34  	XFS_CHECK_STRUCT_SIZE(struct xfs_agi,			344);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   35  	XFS_CHECK_STRUCT_SIZE(struct xfs_bmbt_key,		8);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   36  	XFS_CHECK_STRUCT_SIZE(struct xfs_bmbt_rec,		16);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   37  	XFS_CHECK_STRUCT_SIZE(struct xfs_bmdr_block,		4);
ad70328a503fae fs/xfs/xfs_ondisk.h        Hou Tao           2016-07-20   38  	XFS_CHECK_STRUCT_SIZE(struct xfs_btree_block_shdr,	48);
ad70328a503fae fs/xfs/xfs_ondisk.h        Hou Tao           2016-07-20   39  	XFS_CHECK_STRUCT_SIZE(struct xfs_btree_block_lhdr,	64);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   40  	XFS_CHECK_STRUCT_SIZE(struct xfs_btree_block,		72);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   41  	XFS_CHECK_STRUCT_SIZE(struct xfs_dinode,		176);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   42  	XFS_CHECK_STRUCT_SIZE(struct xfs_disk_dquot,		104);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   43  	XFS_CHECK_STRUCT_SIZE(struct xfs_dqblk,			136);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   44  	XFS_CHECK_STRUCT_SIZE(struct xfs_dsb,			264);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   45  	XFS_CHECK_STRUCT_SIZE(struct xfs_dsymlink_hdr,		56);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   46  	XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_key,		4);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   47  	XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_rec,		16);
1946b91cee4fc8 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-10-03   48  	XFS_CHECK_STRUCT_SIZE(struct xfs_refcount_key,		4);
1946b91cee4fc8 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-10-03   49  	XFS_CHECK_STRUCT_SIZE(struct xfs_refcount_rec,		12);
035e00acb5c719 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-08-03   50  	XFS_CHECK_STRUCT_SIZE(struct xfs_rmap_key,		20);
035e00acb5c719 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-08-03   51  	XFS_CHECK_STRUCT_SIZE(struct xfs_rmap_rec,		24);
5a0bb066f60fa0 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2020-08-24   52  	XFS_CHECK_STRUCT_SIZE(xfs_timestamp_t,			8);
5a0bb066f60fa0 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2020-08-24   53  	XFS_CHECK_STRUCT_SIZE(struct xfs_legacy_timestamp,	8);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   54  	XFS_CHECK_STRUCT_SIZE(xfs_alloc_key_t,			8);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   55  	XFS_CHECK_STRUCT_SIZE(xfs_alloc_ptr_t,			4);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   56  	XFS_CHECK_STRUCT_SIZE(xfs_alloc_rec_t,			8);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   57  	XFS_CHECK_STRUCT_SIZE(xfs_inobt_ptr_t,			4);
1946b91cee4fc8 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-10-03   58  	XFS_CHECK_STRUCT_SIZE(xfs_refcount_ptr_t,		4);
035e00acb5c719 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-08-03   59  	XFS_CHECK_STRUCT_SIZE(xfs_rmap_ptr_t,			4);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   60  
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   61  	/* dir/attr trees */
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   62  	XFS_CHECK_STRUCT_SIZE(struct xfs_attr3_leaf_hdr,	80);
a49bbce58ea90b fs/xfs/xfs_ondisk.h        Darrick J. Wong   2023-07-10   63  	XFS_CHECK_STRUCT_SIZE(struct xfs_attr3_leafblock,	80);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   64  	XFS_CHECK_STRUCT_SIZE(struct xfs_attr3_rmt_hdr,		56);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   65  	XFS_CHECK_STRUCT_SIZE(struct xfs_da3_blkinfo,		56);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   66  	XFS_CHECK_STRUCT_SIZE(struct xfs_da3_intnode,		64);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   67  	XFS_CHECK_STRUCT_SIZE(struct xfs_da3_node_hdr,		64);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   68  	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_blk_hdr,		48);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   69  	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_data_hdr,		64);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   70  	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_free,		64);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   71  	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_free_hdr,		64);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   72  	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_leaf,		64);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   73  	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_leaf_hdr,		64);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   74  	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_entry_t,		8);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   75  	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_hdr_t,		32);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   76  	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_map_t,		4);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   77  	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_name_local_t,	4);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   78  
97e993830a1cdd fs/xfs/xfs_ondisk.h        Darrick J. Wong   2023-10-16   79  	/* realtime structures */
97e993830a1cdd fs/xfs/xfs_ondisk.h        Darrick J. Wong   2023-10-16   80  	XFS_CHECK_STRUCT_SIZE(union xfs_rtword_raw,		4);
663b8db7b0256b fs/xfs/xfs_ondisk.h        Darrick J. Wong   2023-10-16   81  	XFS_CHECK_STRUCT_SIZE(union xfs_suminfo_raw,		4);
97e993830a1cdd fs/xfs/xfs_ondisk.h        Darrick J. Wong   2023-10-16   82  
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   83  	/*
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   84  	 * m68k has problems with xfs_attr_leaf_name_remote_t, but we pad it to
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   85  	 * 4 bytes anyway so it's not obviously a problem.  Hence for the moment
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   86  	 * we don't check this structure. This can be re-instated when the attr
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   87  	 * definitions are updated to use c99 VLA definitions.
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   88  	 *
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   89  	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_name_remote_t,	12);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   90  	 */
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09   91  
3f94c441e2c3de fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-06-21   92  	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, valuelen,	0);
3f94c441e2c3de fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-06-21   93  	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, namelen,	2);
3f94c441e2c3de fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-06-21   94  	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, nameval,	3);
3f94c441e2c3de fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-06-21   95  	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, valueblk,	0);
3f94c441e2c3de fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-06-21   96  	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, valuelen,	4);
3f94c441e2c3de fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-06-21   97  	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, namelen,	8);
3f94c441e2c3de fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-06-21   98  	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, name,	9);
a49bbce58ea90b fs/xfs/xfs_ondisk.h        Darrick J. Wong   2023-07-10   99  	XFS_CHECK_STRUCT_SIZE(xfs_attr_leafblock_t,		32);
414147225400a0 fs/xfs/libxfs/xfs_ondisk.h Christoph Hellwig 2023-12-20  100  	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_sf_hdr,		4);
414147225400a0 fs/xfs/libxfs/xfs_ondisk.h Christoph Hellwig 2023-12-20  101  	XFS_CHECK_OFFSET(struct xfs_attr_sf_hdr, totsize,	0);
414147225400a0 fs/xfs/libxfs/xfs_ondisk.h Christoph Hellwig 2023-12-20  102  	XFS_CHECK_OFFSET(struct xfs_attr_sf_hdr, count,		2);
414147225400a0 fs/xfs/libxfs/xfs_ondisk.h Christoph Hellwig 2023-12-20  103  	XFS_CHECK_OFFSET(struct xfs_attr_sf_entry, namelen,	0);
414147225400a0 fs/xfs/libxfs/xfs_ondisk.h Christoph Hellwig 2023-12-20  104  	XFS_CHECK_OFFSET(struct xfs_attr_sf_entry, valuelen,	1);
414147225400a0 fs/xfs/libxfs/xfs_ondisk.h Christoph Hellwig 2023-12-20  105  	XFS_CHECK_OFFSET(struct xfs_attr_sf_entry, flags,	2);
414147225400a0 fs/xfs/libxfs/xfs_ondisk.h Christoph Hellwig 2023-12-20  106  	XFS_CHECK_OFFSET(struct xfs_attr_sf_entry, nameval,	3);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09  107  	XFS_CHECK_STRUCT_SIZE(xfs_da_blkinfo_t,			12);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09  108  	XFS_CHECK_STRUCT_SIZE(xfs_da_intnode_t,			16);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09  109  	XFS_CHECK_STRUCT_SIZE(xfs_da_node_entry_t,		8);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09  110  	XFS_CHECK_STRUCT_SIZE(xfs_da_node_hdr_t,		16);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09  111  	XFS_CHECK_STRUCT_SIZE(xfs_dir2_data_free_t,		4);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09  112  	XFS_CHECK_STRUCT_SIZE(xfs_dir2_data_hdr_t,		16);
3f94c441e2c3de fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-06-21  113  	XFS_CHECK_OFFSET(xfs_dir2_data_unused_t, freetag,	0);
3f94c441e2c3de fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-06-21  114  	XFS_CHECK_OFFSET(xfs_dir2_data_unused_t, length,	2);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09  115  	XFS_CHECK_STRUCT_SIZE(xfs_dir2_free_hdr_t,		16);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09  116  	XFS_CHECK_STRUCT_SIZE(xfs_dir2_free_t,			16);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09  117  	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_entry_t,		8);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09  118  	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_hdr_t,		16);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09  119  	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_t,			16);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09  120  	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_tail_t,		4);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09  121  	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_entry_t,		3);
3f94c441e2c3de fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-06-21  122  	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, namelen,		0);
3f94c441e2c3de fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-06-21  123  	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, offset,		1);
3f94c441e2c3de fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-06-21  124  	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, name,		3);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09  125  	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_hdr_t,		10);
8337d58ab2868f fs/xfs/libxfs/xfs_ondisk.h Allison Henderson 2024-04-22  126  	XFS_CHECK_STRUCT_SIZE(struct xfs_parent_rec,		12);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09  127  
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09  128  	/* log structures */
b7df5e92055c69 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2020-01-07  129  	XFS_CHECK_STRUCT_SIZE(struct xfs_buf_log_format,	88);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09  130  	XFS_CHECK_STRUCT_SIZE(struct xfs_dq_logformat,		24);
03a7485cd701e1 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2022-10-20  131  	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_32,	16);
03a7485cd701e1 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2022-10-20  132  	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_64,	16);
03a7485cd701e1 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2022-10-20  133  	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_32,	16);
03a7485cd701e1 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2022-10-20  134  	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_64,	16);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09  135  	XFS_CHECK_STRUCT_SIZE(struct xfs_extent_32,		12);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09  136  	XFS_CHECK_STRUCT_SIZE(struct xfs_extent_64,		16);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09  137  	XFS_CHECK_STRUCT_SIZE(struct xfs_log_dinode,		176);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09  138  	XFS_CHECK_STRUCT_SIZE(struct xfs_icreate_log,		28);
6fc277c7c935c7 fs/xfs/xfs_ondisk.h        Christoph Hellwig 2021-04-21  139  	XFS_CHECK_STRUCT_SIZE(xfs_log_timestamp_t,		8);
732de7dbdbd30d fs/xfs/xfs_ondisk.h        Christoph Hellwig 2021-04-21  140  	XFS_CHECK_STRUCT_SIZE(struct xfs_log_legacy_timestamp,	8);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09  141  	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format_32,	52);
20413e37d71bef fs/xfs/xfs_ondisk.h        Dave Chinner      2017-10-09  142  	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,	56);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09  143  	XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,	20);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09  144  	XFS_CHECK_STRUCT_SIZE(struct xfs_trans_header,		16);
fd920008784ead fs/xfs/xfs_ondisk.h        Allison Henderson 2022-05-04  145  	XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,	40);
fd920008784ead fs/xfs/xfs_ondisk.h        Allison Henderson 2022-05-04  146  	XFS_CHECK_STRUCT_SIZE(struct xfs_attrd_log_format,	16);
a38ebce1da271f fs/xfs/xfs_ondisk.h        Darrick J. Wong   2022-10-20  147  	XFS_CHECK_STRUCT_SIZE(struct xfs_bui_log_format,	16);
a38ebce1da271f fs/xfs/xfs_ondisk.h        Darrick J. Wong   2022-10-20  148  	XFS_CHECK_STRUCT_SIZE(struct xfs_bud_log_format,	16);
a38935c03c7914 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2022-10-20  149  	XFS_CHECK_STRUCT_SIZE(struct xfs_cui_log_format,	16);
a38935c03c7914 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2022-10-20  150  	XFS_CHECK_STRUCT_SIZE(struct xfs_cud_log_format,	16);
b45ca961e94673 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2022-10-20  151  	XFS_CHECK_STRUCT_SIZE(struct xfs_rui_log_format,	16);
b45ca961e94673 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2022-10-20  152  	XFS_CHECK_STRUCT_SIZE(struct xfs_rud_log_format,	16);
a38ebce1da271f fs/xfs/xfs_ondisk.h        Darrick J. Wong   2022-10-20  153  	XFS_CHECK_STRUCT_SIZE(struct xfs_map_extent,		32);
a38935c03c7914 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2022-10-20  154  	XFS_CHECK_STRUCT_SIZE(struct xfs_phys_extent,		16);
a38ebce1da271f fs/xfs/xfs_ondisk.h        Darrick J. Wong   2022-10-20  155  
a38ebce1da271f fs/xfs/xfs_ondisk.h        Darrick J. Wong   2022-10-20  156  	XFS_CHECK_OFFSET(struct xfs_bui_log_format, bui_extents,	16);
a38935c03c7914 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2022-10-20  157  	XFS_CHECK_OFFSET(struct xfs_cui_log_format, cui_extents,	16);
b45ca961e94673 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2022-10-20  158  	XFS_CHECK_OFFSET(struct xfs_rui_log_format, rui_extents,	16);
03a7485cd701e1 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2022-10-20  159  	XFS_CHECK_OFFSET(struct xfs_efi_log_format, efi_extents,	16);
03a7485cd701e1 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2022-10-20  160  	XFS_CHECK_OFFSET(struct xfs_efi_log_format_32, efi_extents,	16);
03a7485cd701e1 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2022-10-20  161  	XFS_CHECK_OFFSET(struct xfs_efi_log_format_64, efi_extents,	16);
670105de15cd98 fs/xfs/xfs_ondisk.h        Brian Foster      2019-02-08  162  
233f4e12bbb2c5 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-04-22  163  	/* parent pointer ioctls */
233f4e12bbb2c5 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-04-22  164  	XFS_CHECK_STRUCT_SIZE(struct xfs_getparents_rec,	32);
233f4e12bbb2c5 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-04-22  165  	XFS_CHECK_STRUCT_SIZE(struct xfs_getparents,		40);
233f4e12bbb2c5 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-04-22  166  	XFS_CHECK_STRUCT_SIZE(struct xfs_getparents_by_handle,	64);
233f4e12bbb2c5 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-04-22  167  
670105de15cd98 fs/xfs/xfs_ondisk.h        Brian Foster      2019-02-08  168  	/*
670105de15cd98 fs/xfs/xfs_ondisk.h        Brian Foster      2019-02-08  169  	 * The v5 superblock format extended several v4 header structures with
670105de15cd98 fs/xfs/xfs_ondisk.h        Brian Foster      2019-02-08  170  	 * additional data. While new fields are only accessible on v5
670105de15cd98 fs/xfs/xfs_ondisk.h        Brian Foster      2019-02-08  171  	 * superblocks, it's important that the v5 structures place original v4
670105de15cd98 fs/xfs/xfs_ondisk.h        Brian Foster      2019-02-08  172  	 * fields/headers in the correct location on-disk. For example, we must
670105de15cd98 fs/xfs/xfs_ondisk.h        Brian Foster      2019-02-08  173  	 * be able to find magic values at the same location in certain blocks
670105de15cd98 fs/xfs/xfs_ondisk.h        Brian Foster      2019-02-08  174  	 * regardless of superblock version.
670105de15cd98 fs/xfs/xfs_ondisk.h        Brian Foster      2019-02-08  175  	 *
670105de15cd98 fs/xfs/xfs_ondisk.h        Brian Foster      2019-02-08  176  	 * The following checks ensure that various v5 data structures place the
670105de15cd98 fs/xfs/xfs_ondisk.h        Brian Foster      2019-02-08  177  	 * subset of v4 metadata associated with the same type of block at the
670105de15cd98 fs/xfs/xfs_ondisk.h        Brian Foster      2019-02-08  178  	 * start of the on-disk block. If there is no data structure definition
670105de15cd98 fs/xfs/xfs_ondisk.h        Brian Foster      2019-02-08  179  	 * for certain types of v4 blocks, traverse down to the first field of
670105de15cd98 fs/xfs/xfs_ondisk.h        Brian Foster      2019-02-08  180  	 * common metadata (e.g., magic value) and make sure it is at offset
670105de15cd98 fs/xfs/xfs_ondisk.h        Brian Foster      2019-02-08  181  	 * zero.
670105de15cd98 fs/xfs/xfs_ondisk.h        Brian Foster      2019-02-08  182  	 */
670105de15cd98 fs/xfs/xfs_ondisk.h        Brian Foster      2019-02-08  183  	XFS_CHECK_OFFSET(struct xfs_dir3_leaf, hdr.info.hdr,	0);
670105de15cd98 fs/xfs/xfs_ondisk.h        Brian Foster      2019-02-08  184  	XFS_CHECK_OFFSET(struct xfs_da3_intnode, hdr.info.hdr,	0);
670105de15cd98 fs/xfs/xfs_ondisk.h        Brian Foster      2019-02-08  185  	XFS_CHECK_OFFSET(struct xfs_dir3_data_hdr, hdr.magic,	0);
670105de15cd98 fs/xfs/xfs_ondisk.h        Brian Foster      2019-02-08  186  	XFS_CHECK_OFFSET(struct xfs_dir3_free, hdr.hdr.magic,	0);
670105de15cd98 fs/xfs/xfs_ondisk.h        Brian Foster      2019-02-08  187  	XFS_CHECK_OFFSET(struct xfs_attr3_leafblock, hdr.info.hdr, 0);
7035f9724f8497 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2019-07-03  188  
7035f9724f8497 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2019-07-03  189  	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat,		192);
5f19c7fc687335 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2019-07-03  190  	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers,		24);
0448b6f488fa66 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2019-07-03  191  	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat_req,		64);
fba9760a433634 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2019-07-03  192  	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers_req,		64);
f93e5436f0ee5a fs/xfs/xfs_ondisk.h        Darrick J. Wong   2020-08-17  193  
f93e5436f0ee5a fs/xfs/xfs_ondisk.h        Darrick J. Wong   2020-08-17  194  	/*
f93e5436f0ee5a fs/xfs/xfs_ondisk.h        Darrick J. Wong   2020-08-17  195  	 * Make sure the incore inode timestamp range corresponds to hand
f93e5436f0ee5a fs/xfs/xfs_ondisk.h        Darrick J. Wong   2020-08-17  196  	 * converted values based on the ondisk format specification.
f93e5436f0ee5a fs/xfs/xfs_ondisk.h        Darrick J. Wong   2020-08-17  197  	 */
f93e5436f0ee5a fs/xfs/xfs_ondisk.h        Darrick J. Wong   2020-08-17  198  	XFS_CHECK_VALUE(XFS_BIGTIME_TIME_MIN - XFS_BIGTIME_EPOCH_OFFSET,
f93e5436f0ee5a fs/xfs/xfs_ondisk.h        Darrick J. Wong   2020-08-17  199  			XFS_LEGACY_TIME_MIN);
f93e5436f0ee5a fs/xfs/xfs_ondisk.h        Darrick J. Wong   2020-08-17  200  	XFS_CHECK_VALUE(XFS_BIGTIME_TIME_MAX - XFS_BIGTIME_EPOCH_OFFSET,
f93e5436f0ee5a fs/xfs/xfs_ondisk.h        Darrick J. Wong   2020-08-17  201  			16299260424LL);
4ea1ff3b49681a fs/xfs/xfs_ondisk.h        Darrick J. Wong   2020-08-17  202  
4ea1ff3b49681a fs/xfs/xfs_ondisk.h        Darrick J. Wong   2020-08-17  203  	/* Do the same with the incore quota expiration range. */
4ea1ff3b49681a fs/xfs/xfs_ondisk.h        Darrick J. Wong   2020-08-17  204  	XFS_CHECK_VALUE(XFS_DQ_BIGTIME_EXPIRY_MIN << XFS_DQ_BIGTIME_SHIFT, 4);
4ea1ff3b49681a fs/xfs/xfs_ondisk.h        Darrick J. Wong   2020-08-17  205  	XFS_CHECK_VALUE(XFS_DQ_BIGTIME_EXPIRY_MAX << XFS_DQ_BIGTIME_SHIFT,
4ea1ff3b49681a fs/xfs/xfs_ondisk.h        Darrick J. Wong   2020-08-17  206  			16299260424LL);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  207  
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  208  	/* stuff we got from xfs/122 */
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  209  	XFS_CHECK_SB_OFFSET(sb_agblklog,		124);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  210  	XFS_CHECK_SB_OFFSET(sb_agblocks,		84);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  211  	XFS_CHECK_SB_OFFSET(sb_agcount,			88);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  212  	XFS_CHECK_SB_OFFSET(sb_bad_features2,		204);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  213  	XFS_CHECK_SB_OFFSET(sb_blocklog,		120);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  214  	XFS_CHECK_SB_OFFSET(sb_blocksize,		4);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  215  	XFS_CHECK_SB_OFFSET(sb_crc,			224);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  216  	XFS_CHECK_SB_OFFSET(sb_dblocks,			8);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  217  	XFS_CHECK_SB_OFFSET(sb_dirblklog,		192);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  218  	XFS_CHECK_SB_OFFSET(sb_fdblocks,		144);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  219  	XFS_CHECK_SB_OFFSET(sb_features2,		200);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  220  	XFS_CHECK_SB_OFFSET(sb_features_compat,		208);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  221  	XFS_CHECK_SB_OFFSET(sb_features_incompat,	216);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  222  	XFS_CHECK_SB_OFFSET(sb_features_log_incompat,	220);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  223  	XFS_CHECK_SB_OFFSET(sb_features_ro_compat,	212);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  224  	XFS_CHECK_SB_OFFSET(sb_flags,			178);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  225  	XFS_CHECK_SB_OFFSET(sb_fname[12],		120);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  226  	XFS_CHECK_SB_OFFSET(sb_frextents,		152);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  227  	XFS_CHECK_SB_OFFSET(sb_gquotino,		168);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  228  	XFS_CHECK_SB_OFFSET(sb_icount,			128);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  229  	XFS_CHECK_SB_OFFSET(sb_ifree,			136);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  230  	XFS_CHECK_SB_OFFSET(sb_imax_pct,		127);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  231  	XFS_CHECK_SB_OFFSET(sb_inoalignmt,		180);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  232  	XFS_CHECK_SB_OFFSET(sb_inodelog,		122);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  233  	XFS_CHECK_SB_OFFSET(sb_inodesize,		104);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  234  	XFS_CHECK_SB_OFFSET(sb_inopblock,		106);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  235  	XFS_CHECK_SB_OFFSET(sb_inopblog,		123);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  236  	XFS_CHECK_SB_OFFSET(sb_inprogress,		126);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  237  	XFS_CHECK_SB_OFFSET(sb_logblocks,		96);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  238  	XFS_CHECK_SB_OFFSET(sb_logsectlog,		193);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  239  	XFS_CHECK_SB_OFFSET(sb_logsectsize,		194);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  240  	XFS_CHECK_SB_OFFSET(sb_logstart,		48);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  241  	XFS_CHECK_SB_OFFSET(sb_logsunit,		196);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  242  	XFS_CHECK_SB_OFFSET(sb_lsn,			240);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  243  	XFS_CHECK_SB_OFFSET(sb_magicnum,		0);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  244  	XFS_CHECK_SB_OFFSET(sb_meta_uuid,		248);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  245  	XFS_CHECK_SB_OFFSET(sb_pquotino,		232);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  246  	XFS_CHECK_SB_OFFSET(sb_qflags,			176);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  247  	XFS_CHECK_SB_OFFSET(sb_rblocks,			16);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  248  	XFS_CHECK_SB_OFFSET(sb_rbmblocks,		92);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  249  	XFS_CHECK_SB_OFFSET(sb_rbmino,			64);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  250  	XFS_CHECK_SB_OFFSET(sb_rextents,		24);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  251  	XFS_CHECK_SB_OFFSET(sb_rextsize,		80);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  252  	XFS_CHECK_SB_OFFSET(sb_rextslog,		125);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  253  	XFS_CHECK_SB_OFFSET(sb_rootino,			56);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  254  	XFS_CHECK_SB_OFFSET(sb_rsumino,			72);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  255  	XFS_CHECK_SB_OFFSET(sb_sectlog,			121);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  256  	XFS_CHECK_SB_OFFSET(sb_sectsize,		102);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  257  	XFS_CHECK_SB_OFFSET(sb_shared_vn,		179);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  258  	XFS_CHECK_SB_OFFSET(sb_spino_align,		228);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  259  	XFS_CHECK_SB_OFFSET(sb_unit,			184);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  260  	XFS_CHECK_SB_OFFSET(sb_uquotino,		160);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  261  	XFS_CHECK_SB_OFFSET(sb_uuid,			32);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  262  	XFS_CHECK_SB_OFFSET(sb_versionnum,		100);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  263  	XFS_CHECK_SB_OFFSET(sb_width,			188);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  264  
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  265  	XFS_CHECK_STRUCT_SIZE(struct xfs_ag_geometry,			128);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  266  	XFS_CHECK_STRUCT_SIZE(struct xfs_alloc_rec,			8);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  267  	XFS_CHECK_STRUCT_SIZE(struct xfs_alloc_rec_incore,		8);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  268  	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_entry,		8);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  269  	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_hdr,			32);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  270  	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_map,			4);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  271  	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_name_local,		4);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  272  	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_name_remote,		12);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  273  	XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist_cursor,		16);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  274  	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_sf_entry,			3);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  275  	XFS_CHECK_STRUCT_SIZE(xfs_bmdr_key_t,				8);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  276  	XFS_CHECK_STRUCT_SIZE(struct xfs_bulk_ireq,			64);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  277  	XFS_CHECK_STRUCT_SIZE(struct xfs_commit_range,			88);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  278  	XFS_CHECK_STRUCT_SIZE(struct xfs_da_blkinfo,			12);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  279  	XFS_CHECK_STRUCT_SIZE(struct xfs_da_intnode,			16);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  280  	XFS_CHECK_STRUCT_SIZE(struct xfs_da_node_entry,			8);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  281  	XFS_CHECK_STRUCT_SIZE(struct xfs_da_node_hdr,			16);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  282  	XFS_CHECK_STRUCT_SIZE(enum xfs_dinode_fmt,			4);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  283  	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_free,		4);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  284  	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_hdr,			16);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  285  	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_unused,		6);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  286  	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_free,			16);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  287  	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_free_hdr,			16);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  288  	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf,			16);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  289  	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf_entry,		8);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  290  	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf_hdr,			16);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  291  	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf_tail,		4);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  292  	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_sf_entry,			3);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  293  	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_sf_hdr,			10);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  294  	XFS_CHECK_STRUCT_SIZE(struct xfs_error_injection,		8);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  295  	XFS_CHECK_STRUCT_SIZE(struct xfs_exchange_range,		40);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  296  	XFS_CHECK_STRUCT_SIZE(xfs_exntst_t,				4);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  297  	XFS_CHECK_STRUCT_SIZE(struct xfs_fid,				16);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  298  	XFS_CHECK_STRUCT_SIZE(struct xfs_fs_eofblocks,			128);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  299  	XFS_CHECK_STRUCT_SIZE(struct xfs_fsid,				8);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  300  	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_counts,			32);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  301  	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom,			256);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11 @302  	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom_v1,			112);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  303  	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom_v4,			112);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  304  	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_resblks,			16);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  305  	XFS_CHECK_STRUCT_SIZE(struct xfs_growfs_log,			8);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  306  	XFS_CHECK_STRUCT_SIZE(struct xfs_handle,			24);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  307  	XFS_CHECK_STRUCT_SIZE(struct xfs_scrub_metadata,		64);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  308  	XFS_CHECK_STRUCT_SIZE(struct xfs_scrub_vec,			16);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  309  	XFS_CHECK_STRUCT_SIZE(struct xfs_scrub_vec_head,		40);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  310  	XFS_CHECK_STRUCT_SIZE(struct xfs_unmount_log_format,		8);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  311  	XFS_CHECK_STRUCT_SIZE(struct xfs_xmd_log_format,		16);
19fb443bb75f03 fs/xfs/libxfs/xfs_ondisk.h Darrick J. Wong   2024-10-11  312  	XFS_CHECK_STRUCT_SIZE(struct xfs_xmi_log_format,		88);
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09  313  }
30cbc591c34e68 fs/xfs/xfs_ondisk.h        Darrick J. Wong   2016-03-09  314  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

