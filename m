Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A832AE69
	for <linux-xfs@vger.kernel.org>; Sun, 29 Sep 2024 14:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727620633; cv=fail; b=CfU4xTf4RzzSAI28e4TKw7v3+RQjCIfdh+6OdlDD/rx9bpBKEmHVw1rldnPTmTOpa5WK2+mzKELDZy+rwsMIk5azUVPmO0Du9FyI2Dl3YzA39nnO/1vAJ5zXjCPfin8LyX3dxXI+ylUMn/dyPLYT+hUksxB4QSn5O1FeGCPq3Zo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727620633; c=relaxed/simple;
	bh=DoYXRjj68ihbCvsqcGbzAEXwTOTwr6teff0pLnL/DGw=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=Ncog/hf7MEmT+0MgzUspXS80NXyypOhOSHLM7nrM4ftN9mJOKkjeCGUI7ZAf87XGqvfZeRE2ujjG/gHXN2W2hpTfl+iHQsZstfXdbeYJbaJj/G6Pve8Gb4EgRu2Wvs8KvnjUz/GZmL+sM0fQhLywaOhe18+o6NNjY1nktp2AYwk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H4BTU3AS; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H4BTU3AS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727620631; x=1759156631;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=DoYXRjj68ihbCvsqcGbzAEXwTOTwr6teff0pLnL/DGw=;
  b=H4BTU3ASOkzUgd2IMXZ2XByxJQ5PELnoSbwMbXcn/doDjFQGcpbITU08
   wkUBjHP8VWc/eE/Ad3utKVBb0ouhTQ0DIx3tM9MSqIkMlr6XqOvTt1GRT
   4afH+GQ6IjV4noIyDdqTgcWQ51TtGwYKQHbrSTIfxWVWHH90owRlEKwmD
   2d+0QirfbUrNGDwAjQWyMOnXRhL45juS4ZArWm2UP5+T4DP5WjEpZpEJV
   jk8JW7d9G0m2oSA6MK7w69aOYY4ajznQI+C4Vw67PQkqJxcqQFu8f0Izx
   KCGHJ9z81Fm8QQgdcTPY0XWJ1lFplp58nCcoGDj4DiEw67nB9QjzbznVY
   g==;
X-CSE-ConnectionGUID: os0WvZSOS8iq2zSJnLYlKQ==
X-CSE-MsgGUID: hRQXyaSZTnSo8ylujYf8Fw==
X-IronPort-AV: E=McAfee;i="6700,10204,11209"; a="26586619"
X-IronPort-AV: E=Sophos;i="6.11,163,1725346800"; 
   d="scan'208";a="26586619"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2024 07:37:11 -0700
X-CSE-ConnectionGUID: KxkvHUqPRGqnE2caVA41iw==
X-CSE-MsgGUID: /zYBoHlDQA+6oLJkgMsTzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,163,1725346800"; 
   d="scan'208";a="73829747"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Sep 2024 07:37:11 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 29 Sep 2024 07:37:10 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 29 Sep 2024 07:37:10 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 29 Sep 2024 07:37:10 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 29 Sep 2024 07:37:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bHIScIodkyjAyfVnEre/pWmVWQWejCBoWcLGtUrKcQCOvOsNY9P4gp2BwisUATmS4DSmNDUwSZH5L4deloJp/Y4LX6tCgai6c3rzza+YzT8Nt50qch3NgGPNfopJb7Z/eaTReXChQop4gnp2QQn7exLcnC0KcqIrlzFxrJI4kebF8PkZgICiDCdqfG4A2MTqUo7J9lTozvFsda/2/Qd/xJx4W8q25iDhQS7k4Vv0D++BgFdQ+mIpTAU9v0W7kNV6ceSyu+9HZ75ZoY+hPgkHvE9iqj29ISFTOM6YnWIDsMR6Nq8M5edN/qy4phmyPYvETe+092ZXPx8Di3rgEYOUTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2dzuAK3AlBSai9Gcl7cfNVfzzQIWTb8zee/sdy4ASZc=;
 b=anXoUZTubb2R5iFazROnfqK4/07eJwBQzDImzVzapU941C0L6E/JWvDsLgqrlIQMHZ1hXqXwXFpYnoPHg942mG7moHxegMJsFQO/wnKw4QRJxjhqnSsBZ7Kuh1l2DETET0pdPhv1UmQIMoT1BPtxbUnPPbRxDw2o3CRnMN1QPaYvTRs1y/aYS4n1JpQhHsXLiBjEjWceH5YmP9wrk+wG+JcpTklsODecpxKEIf9Rsn5Wdq9o84d5mNRolzZtoIB9FhwZr4+FCjaZL2kgiTb1LlYj41ZQG7F22/WXZ9a6Ng99p4H8Y04RylnYHmadrXKOZRfFdh40bEEZT8igC2o2jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by MN6PR11MB8101.namprd11.prod.outlook.com (2603:10b6:208:46e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.26; Sun, 29 Sep
 2024 14:37:07 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.8005.024; Sun, 29 Sep 2024
 14:37:06 +0000
Date: Sun, 29 Sep 2024 22:36:56 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Jeff Layton <jlayton@kernel.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Linux Memory Management List
	<linux-mm@kvack.org>, Christian Brauner <brauner@kernel.org>, Josef Bacik
	<josef@toxicpanda.com>, "Darrick J. Wong" <djwong@kernel.org>,
	<linux-xfs@vger.kernel.org>, <ying.huang@intel.com>, <feng.tang@intel.com>,
	<fengwei.yin@intel.com>, <oliver.sang@intel.com>
Subject: [linux-next:master] [xfs]  3062a738d7:  filebench.sum_operations/s
 -85.0% regression
Message-ID: <202409292200.d8132f52-oliver.sang@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0034.apcprd02.prod.outlook.com
 (2603:1096:4:195::9) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|MN6PR11MB8101:EE_
X-MS-Office365-Filtering-Correlation-Id: 52804b85-b95f-428a-8bc4-08dce0943156
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?/EsB68e/UYdfA27mUQDnNBWnwaqauGO7HKRVbEqNPT7+enDzwsrWEMzMug?=
 =?iso-8859-1?Q?7tSdMkQNgkm5evww2Jo7WIIJBghJN6yoY5GpCHnani7wCQWM860QeB5zkP?=
 =?iso-8859-1?Q?NsGF/XuU23Q6wilQtU+cjyGKCYtn4qzAw/0voZLFf1f7bGkT9uh2tBUZvM?=
 =?iso-8859-1?Q?YS3EQ8MVkSrFaCnp/eliy143hYf32YyMunJp/F/eTBN+MhtwZVuMIciIG6?=
 =?iso-8859-1?Q?L51w4AgcmZaztKlfCSxAoYXvJDI90Z+5c6zpiwt2b78S4LOdiJafHLdwO3?=
 =?iso-8859-1?Q?+tLReyr2hgMNK50kxM32ekjiM3c8T+2IKDu8px2pJDUuaY54LS0Bc1TuLm?=
 =?iso-8859-1?Q?JAPXB0D2He0tV8ZKZJE1jr/2uN7mscMhF/VMS9TendbE9hkB88vOCzSNje?=
 =?iso-8859-1?Q?/F6ImT+6SOt/B6rsWgBhU/OVJAVrQFHkkun5BPpWNV/pZ0rNR4M33+UoHD?=
 =?iso-8859-1?Q?+oeOj9a5uRFaBZyvZCaqdu9NjuNc1txX3ZTtZBdapmRxylVB5dT55f5Viu?=
 =?iso-8859-1?Q?tHPTlxWz0XHcfsiVz7N5QWj/L4ilR8vyIE+A94yX6cHvNp6qJrczuW11er?=
 =?iso-8859-1?Q?w777lMpmP47AfloFJD9KxWvB59p5Y/1MtW5+ra/bxcLpaypvAkxybi/YeN?=
 =?iso-8859-1?Q?gyaHNa4h5Hc5IopbKZnicYzdgZrzeu+1bdXSlRacEJ4SbET6KXxPf7O/Wl?=
 =?iso-8859-1?Q?RdpzXT+q2LtJTyEOdH/z4GgsQiK6m1/4NRfkrbz/mFy/EzvS/u+npisBVj?=
 =?iso-8859-1?Q?4jSCxoxK3QQNfTW9Mrvqb+klvwETjlRkMF72R5+VW2bfyIjS1q/Kms0MtU?=
 =?iso-8859-1?Q?4Pmos3qauaHZwimyFQ3V6b4kcrj8BPA0KL71rnObdC8fGK+Ie6hFI9ZwQ6?=
 =?iso-8859-1?Q?nDZhZYfZMLtZmMHu6PtXQNEh2ciMsNihW4AdGzgSmCIXaafHeWQWzeWXO1?=
 =?iso-8859-1?Q?q+L2TyyJwDMYlbdQzoVU7aJL+S42LHoJvqMA18HTe0oDaSi9elujXgst+H?=
 =?iso-8859-1?Q?7ZCv/gtMWxi/5N8xiJYGtIRVcOD+JUWZ1yXGx5kGYo86W86cR8y9tzG3Cl?=
 =?iso-8859-1?Q?TosunkmRb7mlmTpqMexea0Zl8bHd+a/zj/0g88V5bf80YjmMpHeFTTMK/K?=
 =?iso-8859-1?Q?PnK7Al8kr1tmdsSKJlMXPDMIkZNBf1U1JG+yNcCL2tJJ+4LOWGF50nHU2A?=
 =?iso-8859-1?Q?aOpv4n8NJYqY8RB0Tikkk0X8W5WjBR3ysM0jdBnOpz2gitNlduKSSqTMBG?=
 =?iso-8859-1?Q?ETepchDTk9dvQ0upX37PKBPLEA1X9joEfdoqb1o66mD3+cB9DeuJYmSxAY?=
 =?iso-8859-1?Q?nyvhUGSSemEVGwpUK6sAM5tB2tza25O/mQJgSghjwNikDWw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?zYxGKap6aMXllj4P7UNQzZhilQUSrSzP4chfiTP/d2uVcbP+FMlTvJiZ7J?=
 =?iso-8859-1?Q?GAwJMPtELDbZj0IM2HMdG71KnlDVQ9X5ER8Ypn8qyMmvxpzoPbkiw0pMzJ?=
 =?iso-8859-1?Q?sDn4kkHR1OUV04NMBEBoQmKdI4VYIIKE8rEPhrDFz4pFroUrYdx7fTpkQn?=
 =?iso-8859-1?Q?9onXpDadzm4LF7UlhnvNlBDq9D72ZND1m3Y90KupVviN2s4vmx55Eokm4k?=
 =?iso-8859-1?Q?VW2EYppXVt/UVz9tyQeKWjghhMMba/tZZR11f+Uzt0akKVQtZa/HtIiZH5?=
 =?iso-8859-1?Q?BSRTCq5tPFthsH+2D/sHkOetNE0dZHXeJlU2aoqHd9Ijj3X0LxrZ7cvC6H?=
 =?iso-8859-1?Q?OlUdZeVh0Vql7xPoqOU5A+J8cFqFe/3bblp+qFlE3WU6rzErT8yL7Ggypj?=
 =?iso-8859-1?Q?umdsYBClhIZ78/7cQCaHva3LaUe+s3zRDmUMvqXlibiSHAO5h4Lr7kn66C?=
 =?iso-8859-1?Q?gVwIvzJUTmSNsb1DRYPg1/k2YIdV0BCXuBe92nnFu995ccmAvn2OLVFkLA?=
 =?iso-8859-1?Q?p29QvdnSCdQzoNf43zA5qt3Xtm/jf/9WUm2gfeANpKuiNc0OH16mhzTOFD?=
 =?iso-8859-1?Q?nyPBznZ5r81LD7pskaNgt0yfaEdoTi8BILUTvht39XgD8WJe9q6WjVdBuL?=
 =?iso-8859-1?Q?Z73OYQVLY925MOKSKLQSReSfI0fOsMSry2DPOpO93oi/Jxl8CNbGJ94N5x?=
 =?iso-8859-1?Q?+2sK4U5btweiSSGxomgAYYdeEnkMTUnBiFgT9PcrVhqLO+p1ff0FpqGKUZ?=
 =?iso-8859-1?Q?3leX+bP2FunrZkaL39In6pgQeEevfqpyIlt3aKoBJp68WHAcmnilbCEZuw?=
 =?iso-8859-1?Q?cwrzM2bs564jeKxF89IfrH7gLiRR0IvcDLI97Pe+PHSl+mdswicz3V1i0z?=
 =?iso-8859-1?Q?Br9I35Nuwh9nSX67PQe8NZXywZJwyo3TgHnM0bXIsLDfRn9d1SDQrkbr3V?=
 =?iso-8859-1?Q?PnhpgSH/KiwCbGwA5PVbYWY8rY41YcYENYhwRIe/g3xcIqBvEP9NXVHowi?=
 =?iso-8859-1?Q?KQze7D3qhVln/uNRZD9X1guGUddSEcZunYhlSlwIlmWKqETbtPrIrEHJfN?=
 =?iso-8859-1?Q?RL8PaxlLPKA7rNsJow8mlczut19qF15Fho9I+Am+xoeQJPvE5md7JmMefo?=
 =?iso-8859-1?Q?NNq0f6UFHL6XpXroqzqicJGDgKru2fgUK0snVTeQg5eugVXXlwKsu14ZJW?=
 =?iso-8859-1?Q?ktn8QvFFTp5SfjO5Eux3Ypp/E1qjhzNfM+DlxOAcgmm3DkH1saUW8Wcwew?=
 =?iso-8859-1?Q?oQGxH11jDCTYTVzbydAx+N3H3TCfit1unZEW/VCxSX5lZYhL6lCk3S010T?=
 =?iso-8859-1?Q?sdOk+ipFI/JgMb7mfu1awZfQf1WQy2MwiYagsT8CiXRWvyZeGTwOUP11Er?=
 =?iso-8859-1?Q?BG6NpNldpSYCrb4w5WwwsTIdIfHvx74CO+e3IItcNqyZFqDLMsDLPOzC5V?=
 =?iso-8859-1?Q?ElzvHM7OIJwA76blM06Cm4wKMp6g/b0sjuXpYaR6wtLobzOn5nrD51rVuq?=
 =?iso-8859-1?Q?KgcvIuIuvvc1NL/BZPieg0dIYWiPbFeTpR8yN9esAgAVjGRh+5czB+an2e?=
 =?iso-8859-1?Q?p9Z/zabSX1Hl/0CwP835bvGbNsFGmnKFJoCS3pA/1J9/Go3PndNe718gh/?=
 =?iso-8859-1?Q?Lnv4YL0iBNGqI4SLCP5uGrMmedWgzE//lKHlSPFs8fkWTwOD6Wk2ljvg?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 52804b85-b95f-428a-8bc4-08dce0943156
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2024 14:37:06.8712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cm24f2AFBdZJ+MhNxTUawciRbLnm7+ryNPT/fB2FelVyDkJCwo+C8KUJEjG/5ofVEFepWwMdspUaqJagfJW67Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8101
X-OriginatorOrg: intel.com


hi, Jeff Layton,

we reported
"[jlayton:mgtime] [xfs]  4edee232ed:  fio.write_iops -34.9% regression"
in
https://lore.kernel.org/all/202406141453.7a44f956-oliver.sang@intel.com/

you asked us to supply further information at that time.

now we noticed this commit is in linux-next/master, and we observed the
regression for a different test - filebench. FYI.



Hello,

kernel test robot noticed a -85.0% regression of filebench.sum_operations/s on:


commit: 3062a738d73c866bf50df13bc47a2223b7b47d87 ("xfs: switch to multigrain timestamps")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

testcase: filebench
test machine: 96 threads 2 sockets Intel(R) Xeon(R) Platinum 8260L CPU @ 2.40GHz (Cascade Lake) with 128G memory
parameters:

	disk: 1HDD
	fs: xfs
	fs2: nfsv4
	test: filemicro_rwritefsync.f
	cpufreq_governor: performance




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202409292200.d8132f52-oliver.sang@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240929/202409292200.d8132f52-oliver.sang@intel.com

=========================================================================================
compiler/cpufreq_governor/disk/fs2/fs/kconfig/rootfs/tbox_group/test/testcase:
  gcc-12/performance/1HDD/nfsv4/xfs/x86_64-rhel-8.3/debian-12-x86_64-20240206.cgz/lkp-csl-2sp3/filemicro_rwritefsync.f/filebench

commit: 
  42ba4ae657 ("Documentation: add a new file documenting multigrain timestamps")
  3062a738d7 ("xfs: switch to multigrain timestamps")

42ba4ae65752b8cb 3062a738d73c866bf50df13bc47 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      1.48           -13.5%       1.28 ±  5%  iostat.cpu.iowait
 4.302e+10 ±  2%     -21.9%  3.361e+10 ±  2%  cpuidle..time
   2316977           -10.5%    2072537        cpuidle..usage
    763659 ± 17%     -33.4%     508644 ± 15%  numa-numastat.node1.local_node
    817625 ± 14%     -30.4%     568838 ± 11%  numa-numastat.node1.numa_hit
      0.32 ± 12%      -0.0        0.27 ±  6%  perf-profile.children.cycles-pp.idle_cpu
      0.31 ± 12%      -0.0        0.26 ±  6%  perf-profile.self.cycles-pp.idle_cpu
      0.03 ± 88%    +128.5%       0.08 ±  6%  perf-sched.sch_delay.avg.ms.schedule_timeout.transaction_kthread.kthread.ret_from_fork
      0.03 ± 88%    +128.5%       0.08 ±  6%  perf-sched.sch_delay.max.ms.schedule_timeout.transaction_kthread.kthread.ret_from_fork
    523.13           -18.9%     424.32 ±  2%  uptime.boot
     48962           -18.9%      39691 ±  2%  uptime.idle
    208.10 ±  7%     -67.4%      67.75 ± 52%  numa-vmstat.node0.nr_mlock
    816180 ± 14%     -30.4%     567697 ± 11%  numa-vmstat.node1.numa_hit
    762194 ± 17%     -33.4%     507502 ± 15%  numa-vmstat.node1.numa_local
   4823448           +10.8%    5344826        meminfo.Cached
    244108 ±  6%     -41.9%     141806 ± 29%  meminfo.Dirty
   2242446           +23.2%    2763206        meminfo.Inactive
   1552268           +34.0%    2080318        meminfo.Inactive(file)
      1.49            -0.2        1.29 ±  5%  mpstat.cpu.all.iowait%
      0.10 ±  2%      +0.0        0.12 ±  4%  mpstat.cpu.all.irq%
      0.01 ±  4%      +0.0        0.02 ±  2%  mpstat.cpu.all.soft%
      0.03 ±  2%      +0.0        0.04 ±  2%  mpstat.cpu.all.usr%
      2603 ±  2%     +16.6%       3036 ±  2%  vmstat.io.bo
      1.43           -13.6%       1.23 ±  7%  vmstat.procs.b
      2058           -14.7%       1756        vmstat.system.cs
      5528           +21.9%       6738 ±  2%  vmstat.system.in
      2.10           -84.9%       0.32 ± 21%  filebench.sum_bytes_mb/s
     16385           -85.0%       2456 ± 13%  filebench.sum_operations
    273.04           -85.0%      40.94 ± 13%  filebench.sum_operations/s
      0.00 ± 14%  +7.2e+05%      24.14 ± 13%  filebench.sum_time_ms/op
    273.00           -85.0%      41.00 ± 13%  filebench.sum_writes/s
    447.44 ±  2%     -21.9%     349.26 ±  2%  filebench.time.elapsed_time
    447.44 ±  2%     -21.9%     349.26 ±  2%  filebench.time.elapsed_time.max
   2343344          +207.9%    7214762 ±  9%  filebench.time.file_system_outputs
      8762 ±  2%     -80.1%       1747 ±  6%  filebench.time.voluntary_context_switches
    269483 ±  6%     -17.0%     223745 ±  8%  sched_debug.cpu.clock.avg
    269496 ±  6%     -17.0%     223755 ±  8%  sched_debug.cpu.clock.max
    269474 ±  6%     -17.0%     223735 ±  8%  sched_debug.cpu.clock.min
    268974 ±  6%     -17.0%     223268 ±  8%  sched_debug.cpu.clock_task.avg
    269263 ±  6%     -17.0%     223549 ±  8%  sched_debug.cpu.clock_task.max
    261595 ±  6%     -17.5%     215932 ±  8%  sched_debug.cpu.clock_task.min
      8873 ±  4%     -12.9%       7731 ±  5%  sched_debug.cpu.curr->pid.max
      1033 ±  3%      -9.4%     936.02 ±  5%  sched_debug.cpu.curr->pid.stddev
      6038 ±  5%     -27.7%       4366 ±  7%  sched_debug.cpu.nr_switches.avg
    977.53 ±  7%     -17.2%     809.02 ±  8%  sched_debug.cpu.nr_switches.min
    269486 ±  6%     -17.0%     223746 ±  8%  sched_debug.cpu_clk
    268914 ±  6%     -17.0%     223174 ±  8%  sched_debug.ktime
    270076 ±  6%     -16.9%     224334 ±  8%  sched_debug.sched_clk
     15708            -6.1%      14746 ±  2%  proc-vmstat.nr_active_anon
    817011          +120.3%    1799485 ±  9%  proc-vmstat.nr_dirtied
     61152 ±  6%     -42.0%      35491 ± 30%  proc-vmstat.nr_dirty
   1206117           +10.8%    1335949        proc-vmstat.nr_file_pages
    388315           +33.9%     519818        proc-vmstat.nr_inactive_file
     18531            +1.0%      18721        proc-vmstat.nr_kernel_stack
     16540            -3.8%      15909        proc-vmstat.nr_mapped
    213.82 ±  4%     -53.7%      99.00 ± 14%  proc-vmstat.nr_mlock
     25295            -6.6%      23625        proc-vmstat.nr_shmem
     24447            -1.6%      24066        proc-vmstat.nr_slab_reclaimable
    817011          +120.3%    1799485 ±  9%  proc-vmstat.nr_written
     15708            -6.1%      14746 ±  2%  proc-vmstat.nr_zone_active_anon
    388315           +33.9%     519818        proc-vmstat.nr_zone_inactive_file
    139175           -19.7%     111713 ±  7%  proc-vmstat.nr_zone_write_pending
   1299984           -13.1%    1129235        proc-vmstat.numa_hit
   1200290           -14.2%    1029746        proc-vmstat.numa_local
   2273118 ±  2%     -10.2%    2042156        proc-vmstat.pgalloc_normal
   1203036           -18.6%     979402 ±  2%  proc-vmstat.pgfault
   1743917 ±  2%     -13.4%    1509546        proc-vmstat.pgfree
   1171848            -8.8%    1069087        proc-vmstat.pgpgout
     56737           -18.4%      46304 ±  2%  proc-vmstat.pgreuse
      2.40 ±  2%      +7.8%       2.59 ±  3%  perf-stat.i.MPKI
  49439015           +14.9%   56804851 ±  2%  perf-stat.i.branch-instructions
      4.34            +0.1        4.47        perf-stat.i.branch-miss-rate%
   2634429           +20.4%    3171479 ±  2%  perf-stat.i.branch-misses
      5.07 ±  2%      +0.4        5.46 ±  3%  perf-stat.i.cache-miss-rate%
    545304 ±  4%     +22.0%     665397 ±  5%  perf-stat.i.cache-misses
   7567339           +11.9%    8468261        perf-stat.i.cache-references
      2021           -15.8%       1702        perf-stat.i.context-switches
      2.24            +3.8%       2.33        perf-stat.i.cpi
 4.391e+08           +14.4%  5.022e+08 ±  2%  perf-stat.i.cpu-cycles
    102.06            +1.4%     103.52        perf-stat.i.cpu-migrations
 2.401e+08           +15.0%  2.761e+08 ±  2%  perf-stat.i.instructions
      0.01 ±  6%    -100.0%       0.00        perf-stat.i.metric.K/sec
      5.33            +0.3        5.58        perf-stat.overall.branch-miss-rate%
      7.21 ±  4%      +0.7        7.86 ±  5%  perf-stat.overall.cache-miss-rate%
  49259568           +14.8%   56567448 ±  2%  perf-stat.ps.branch-instructions
   2625073           +20.3%    3158787 ±  2%  perf-stat.ps.branch-misses
    543464 ±  4%     +22.0%     662949 ±  5%  perf-stat.ps.cache-misses
   7540908           +11.8%    8433223        perf-stat.ps.cache-references
      2017           -15.8%       1697        perf-stat.ps.context-switches
 4.373e+08           +14.3%  4.999e+08 ±  2%  perf-stat.ps.cpu-cycles
    101.82            +1.4%     103.21        perf-stat.ps.cpu-migrations
 2.392e+08           +14.9%   2.75e+08 ±  2%  perf-stat.ps.instructions
 1.072e+11           -10.2%  9.632e+10        perf-stat.total.instructions




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

