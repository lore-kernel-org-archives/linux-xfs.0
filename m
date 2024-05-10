Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CA715E7F8
	for <linux-xfs@vger.kernel.org>; Fri, 10 May 2024 06:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715322582; cv=fail; b=CmnnaoxSqJ3yweZsZFjw7S5HvsYOD5AuhBNN6PArcoe0HB0mgQJXzt+70L9QQXTZzkkQLvEHgktWFufxXosDeMDtmjVSE9AWjRiW+CRGNW1itBxyNcnNiolRCf27avSI5JvPIk/l/wWMsOkEhXrhxh803zwmyMT6bjtLZSu4AXw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715322582; c=relaxed/simple;
	bh=hl7VwpicMQgWBjoC/xnFnV5EvOlcMEiZyWiVVG91jfU=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XH/56aI3zjolralud9Eu6s7ef1dIUTSix2+PoYopwE95aAw82exCcW+pTxDQnCrG7zN2GiOuEQeuKI8/AVDPKfcFmepNxDtrVMY6Qusnn+0yn2H5+5WPXqJQVXCuFzHKSybELz56xRCUwvwE0+65Dsd1Ia5+zuX/1SLpuMAtvLQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dWfBzwc+; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dWfBzwc+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715322581; x=1746858581;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=hl7VwpicMQgWBjoC/xnFnV5EvOlcMEiZyWiVVG91jfU=;
  b=dWfBzwc+r6860dhp2lhcDIMtyl7ODnMUP00G3fDqwvHMtxi3Ty9mw5hF
   FvWM/aryUQOdK5GTzUq9dFTDkRPCiqCyzRLx+VOd/3cYDXAsagG03Hgf7
   xYGXOw00a7pxyt5a2VIwaOrP3mGYmjUgetsaOd8FC23dzuTieQjApLEQt
   STcT8tO2slutRYldtH9cIlwGplpFa74Y2mWWquo5hRmpoIXpwmNRwPtB7
   Jt2tGqm3/fTunuC3ObiwIX7ZGo2yzr5ChlMigpUQN+FrXyF8Wxd2X2+/B
   DRJy+H0/snmH5cGCtSFjtdk4FzOHauf+jl53e4SNvRBf70chrxImIXQ2G
   Q==;
X-CSE-ConnectionGUID: LiKDa14iRE+kcTMFS2admA==
X-CSE-MsgGUID: WyFo4tt3S2upoqH5XtbGkQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11068"; a="21861218"
X-IronPort-AV: E=Sophos;i="6.08,150,1712646000"; 
   d="scan'208";a="21861218"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2024 23:29:40 -0700
X-CSE-ConnectionGUID: Ou5rBGjXR++PpuyOPHzDpA==
X-CSE-MsgGUID: 6Ed1P+JxTpuFFRs6uiYrbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,150,1712646000"; 
   d="scan'208";a="33942335"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 May 2024 23:29:40 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 9 May 2024 23:29:38 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 9 May 2024 23:29:38 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 9 May 2024 23:29:38 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 9 May 2024 23:29:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YX2vrzG/uVeWoohKnj0mWj/oTXmNbJ05MGvn73tzIOkw0Q/BTe75t+lSOMBmMkZ+D8HgjSY0Dp44wUyCYlSBa+HgGOpC+3SsgV2UYnRo7O457eOOfrGWdOLBwkzi7EmcC1udZSdFn/7dUmnv0RGHpEo8EcqU/cpBGHDYiXLl/xprXABhMoWbLQRnTgOE5NNm6EPEQo8ibfRvoAE5o7nM2k2pq6Ouf7R3nkdFEwdKPr88sJz3eagb6IfxJg1YLtLh1afrrDiH+hGogYasG+9TXcJlW25arusfpUwYGriAJwrFUYU4J+TiBSXwYZh35rLC/Y1BE1c7Sw/2HYYLwpLpag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4WKYIpZV/vPUupzQocxkF0bQaut/DNcHCjhH5Yv5Ot4=;
 b=CBo9d90Q9dO/N/DI6oyXIm9+dD6DDj8QTnUl76SIuA22dW7PpgT0vRbZgla9cNOL8anLSw+p3OK8qnObIb5YaG30Um9tPj2LFRzkoQYD/qkCgrLNTAthBLmsbYMZ2ffGnuBhdgb1hiODJ6eETSvjUqEnDbpCRjxm5XnohOdXtzdxeDFHfq1aqWvbZSwN16O6Ql4OvQQlNT6GHUNaMpq1jS01trhr/q8ErBvn59PZVFg2+7e7U9QNyk/4MgqpFD222VKtACJP3IKJZhkRAEHGCD8fcfqQxn/H59FeAA7OtePgY+HLu/4/0P/ZKcHpggQk7mjVpLjNwJe0mMZARv8lWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8393.namprd11.prod.outlook.com (2603:10b6:806:373::21)
 by DM4PR11MB6263.namprd11.prod.outlook.com (2603:10b6:8:a6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.41; Fri, 10 May
 2024 06:29:36 +0000
Received: from SA1PR11MB8393.namprd11.prod.outlook.com
 ([fe80::1835:328e:6bb5:3a45]) by SA1PR11MB8393.namprd11.prod.outlook.com
 ([fe80::1835:328e:6bb5:3a45%4]) with mapi id 15.20.7544.047; Fri, 10 May 2024
 06:29:36 +0000
Date: Fri, 10 May 2024 14:29:33 +0800
From: kernel test robot <yujie.liu@intel.com>
To: Christoph Hellwig <hch@lst.de>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-xfs@vger.kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>, "Darrick J. Wong"
	<djwong@kernel.org>
Subject: Re: [PATCH 16/16] xfs: make the hard case in xfs_dir2_sf_addname
 less hard
Message-ID: <202405101352.bcf759f-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240430124926.1775355-17-hch@lst.de>
X-ClientProxiedBy: SI2PR01CA0017.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::19) To SA1PR11MB8393.namprd11.prod.outlook.com
 (2603:10b6:806:373::21)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8393:EE_|DM4PR11MB6263:EE_
X-MS-Office365-Filtering-Correlation-Id: 3340cc6b-29c1-4978-9bc6-08dc70ba8fbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?/zl2Ui7LDYY0WvCRoLyHo2IxU5ZvSGg1wuULT6DYaSJ2MCpNe4DdukYo1Tah?=
 =?us-ascii?Q?3w2ubQFYsb+J6MbClR47is8EQl0PFJMqE2cP1awusQYkCtKvVE85E0IaJsTd?=
 =?us-ascii?Q?HwKy++K/VC2TcTx5y6ZJ4yvRnFDWX/YFFhJ7UPbydSzE9F33rSKCQBPRoP+h?=
 =?us-ascii?Q?2n7yAow6x3bwnG3pKqWvrgeszlJieNpZbSXoh3PS8yx1+YW75c6HNq1FUfi4?=
 =?us-ascii?Q?z9WwiJkgqqooebJfBs549RjuWHpChSRdiLbFGaF3jC6CdywoiuW0i0AjvA5g?=
 =?us-ascii?Q?6DPnup8K2V/Ysw3l4IhxeL6wB3qUGlm054+Q2vC545Y7obbPg0VNZR0fcshy?=
 =?us-ascii?Q?w+lQy/Ta6tIn6k0xNfSPR1199KLP1yU3tnU1LzPl0eeyGgY9gBxK7Wg4q9Cl?=
 =?us-ascii?Q?ucyYtVcrtxxpmkquySGPxm+VYyq8c+oJV5YqYJ75xh/sSqwIt00OsN+TQGIL?=
 =?us-ascii?Q?BZ4P9BjoKHBAkFmYp+0EY7ryNcjRAi0/abRamydaEWM/cQ/GEg4hchLT7NN5?=
 =?us-ascii?Q?13Hv9xN7pDAaNy9VF+J0BmI8KPKaFbloOKFsipCuYNknofgrK4wPc8/nviSl?=
 =?us-ascii?Q?xlytkJQUDjcCy1LEK4rbsatgiBWlKgf3OSKEDtwZp3ZddUn5sbU7L5NzovNq?=
 =?us-ascii?Q?ybcdWKT36aUKD8T2IS5R10ih3GroRmO+O/Tv7vqAioJKiOYOwFq3DaVRFlu7?=
 =?us-ascii?Q?L6nnBehBHXW29Tudg8djHvGevg3My+QBUmKOWaTxIZiHQ3VMGgSoaafmmAMk?=
 =?us-ascii?Q?3Jh8Ljsxci2wPG/73xX2FqszBTXd2GhJ0GIbkMr3vuD4mq4QQSqcbMlo2KMM?=
 =?us-ascii?Q?tozoe5J9tNb/po5t9N5+fvIevIArAFiLHkNXb4PRe9QhzFjha5/jvBiHfxpF?=
 =?us-ascii?Q?JT2ReCzEY9jlHRx+ogVg/IWaCOsCi44YSt2Abvgx05SnEHjIgO215RDimnCV?=
 =?us-ascii?Q?u5fwFmaxzTKtUiFaZ9novZZVG3plHhuT4TeLoqgbHlbDcWvb3WsWgcX/RBDH?=
 =?us-ascii?Q?nnUwaen9pSKq7wpiiPYAgN+nsR+NQGU+0ei+6wylehgeIdJZ5UesfET7rs/W?=
 =?us-ascii?Q?f1TPCM0VQ4cDzh8SnHoxIGT/xeNBYoqSRh4+ec2/tUWWvXJ7Okga8cRvRjJ8?=
 =?us-ascii?Q?MrE21JBJCZNnX+118JQGdrwwiU7TzCfyiw6PAKzayr1fB+vz0p+AgxRtqPUl?=
 =?us-ascii?Q?gh3s6mRa9d2ZB6+PJBfooYtzNmd/vPEe9Ei9flLyygVaOxxkMrHpiE3//QA?=
 =?us-ascii?Q?=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8393.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ymxYHeIl7nfYqGczEKNIsldyJ6ev6aiPuXvAdYZL3vC//Cb1BlDz/PT2gquf?=
 =?us-ascii?Q?DOvgpix8xVgUpzF7J/L2V5WrFLcrMtEVhHJYZj+RiZwg7EU3QBdbO2xbFzPK?=
 =?us-ascii?Q?g3mfCuZa4yzZCsqIFEI1WaU7bCCcsuyadcfCPtzv2IVjyKY3U9lpNm9nq7C/?=
 =?us-ascii?Q?jnVUn+ZwhV14XxMAnMCxolSWv/KsCMCaBSX/0oduwQRJ+FYVEsEhov7IhNrO?=
 =?us-ascii?Q?ktY9bGtxHU/OwBSPAvhu7RGEKD9/7cdg+LKOM0xAKgcHF59IbcJC39HGfYYD?=
 =?us-ascii?Q?MbIha/INLfeyjrSI6Wr2BQcc0rFX/ogFFhfkcFEQuZ7tSgyP/eTkOvdP1Fzi?=
 =?us-ascii?Q?gqVaME9BM+TuXijz5IN1+exFA5FZt4qtiHhHd2ZSQEw4rZivR9OGaSRN1b/9?=
 =?us-ascii?Q?Qc7X1/0Ry3DcILoXpMK32gDQxfF9RgD4m+Tl97TEtHDZYGpS61fA7dhgQJq+?=
 =?us-ascii?Q?9x2wQeC5gUyhz6uslvQCDGjNk6zRuGVz+SahLOKeMUiekcw7GpqPP734b15g?=
 =?us-ascii?Q?/rFPRPkcrRZNvXNSf86l6kRR/JQvhzyDIIlSA7OnULiCl38S1dwu0xwoq5ce?=
 =?us-ascii?Q?d0aRuyyedIhg8VcTdJFa1DeicXrVChtxNCO8+/+mrB1TfC6d01skK2bJoq+V?=
 =?us-ascii?Q?/r9PEt/fPXyRWkDjIpLRV3uHRTvBUcSc15azW3ng2Ggi3DRE8dUmkKbwQ0r2?=
 =?us-ascii?Q?576JjxPsN8xTxvYpFPtu2SHOoma5bjwE1OAhn8dGO3oxAOJXhKmU/8ztPl4R?=
 =?us-ascii?Q?8JQcMdJmnaqgGDZjM3G9SdhQEF7uVybo6w/C1+TwKgAKPMMlxvjVAkqfPvzm?=
 =?us-ascii?Q?+TM1s8IDQ1g0JbE5Jg3NbhGkvYxwnHkY53CG4mkJnkCUpD/eJGacqUX3HQhb?=
 =?us-ascii?Q?rjvFoR8k1EcwFIe3iScMvGDqNKs/LsMMhqa1uXoHAhDqNHb2vk2iPYHy2dUZ?=
 =?us-ascii?Q?CSAKjv6o0hSjl8UQSniGZV5zafVzW+QXw0OOc6EdRekQTP7XsaWsL1JpkFxW?=
 =?us-ascii?Q?iNXWuCeAuL4V6VWgWFQBHRi+lxScrdfGFPtAkhMVh+jy9PYJJ1VrIOfX+Y1G?=
 =?us-ascii?Q?3Yh1AkPYnBlCAIeVK6F1/h2TN2vC0exo4T/ReBAtu705ZLiFzuK63khe+zES?=
 =?us-ascii?Q?1e3o/SIGsvBWHyIE3R9MkXFBBC9ykVjoL7xVQ2IebhSdQ83KaNHHkGrDmriU?=
 =?us-ascii?Q?aZ/NrWk/XJBgDMXPYqRyMHftQSSAcsJqa10DiT1uPNnN1vFKbp9a/+lgp8H5?=
 =?us-ascii?Q?vHMdpW8Cq3USALMBy0ov90FxFn/ipcdh+EKD9aPYfJwHnm6u03x6biMVY5Xs?=
 =?us-ascii?Q?TkdHgMII0OJDn+r8ojrB8x15z+t8ERcDKNyo73innSCwxQpWM1hbt+Ufa/L7?=
 =?us-ascii?Q?HPRZFyVkTn1NMSDbXhH9W2059AWOzmQqGqjT11eCL5nV1p9f2xnoAh+/hBZH?=
 =?us-ascii?Q?MJZVOQqruvYCvTk3CSR+3K/LUaizJ1GNq030BaPVHP7j5eFRadsMRDI90XmJ?=
 =?us-ascii?Q?+9sIDtV6Vt31kgP9zGhukpU5RSbm+4V4Z0DZNQSKkMT0AbCs7zaae8yR4iI5?=
 =?us-ascii?Q?xIzGZfd4Fggg7Lyg7tA4DgaxhZcXc/TJJAp7OyKi?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3340cc6b-29c1-4978-9bc6-08dc70ba8fbc
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8393.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 06:29:36.3280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2P66qEUBlkLNkwEW93amW61etF4l2CJ9NOeLSig2Mi7F90mdy0yRqxJdZ96otvydYM1TDhdB9hIFFUrQXlukLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6263
X-OriginatorOrg: intel.com

Hello,

kernel test robot noticed "dmesg.WARNING:at_fs/xfs/xfs_message.c:#asswarn[xfs]" on:

commit: cbc81dd4e3e501eb8888bf412f7d4fdd8c416927 ("[PATCH 16/16] xfs: make the hard case in xfs_dir2_sf_addname less hard")
url: https://github.com/intel-lab-lkp/linux/commits/Christoph-Hellwig/xfs-remove-an-extra-buffer-allocation-in-xfs_attr_shortform_to_leaf/20240430-214950
base: https://git.kernel.org/cgit/fs/xfs/xfs-linux.git for-next
patch link: https://lore.kernel.org/all/20240430124926.1775355-17-hch@lst.de/
patch subject: [PATCH 16/16] xfs: make the hard case in xfs_dir2_sf_addname less hard

in testcase: filebench
version: filebench-x86_64-22620e6-1_20240224
with following parameters:

	disk: 1HDD
	fs: xfs
	test: fileserver.f
	cpufreq_governor: performance

compiler: gcc-13
test machine: 128 threads 2 sockets Intel(R) Xeon(R) Platinum 8358 CPU @ 2.60GHz (Ice Lake) with 128G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <yujie.liu@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202405101352.bcf759f-lkp@intel.com


[   41.583616][ T4699] XFS: Assertion failed: xfs_dir2_sf_lookup(args) == -ENOENT, file: fs/xfs/libxfs/xfs_dir2_sf.c, line: 456
[   41.595114][ T4699] ------------[ cut here ]------------
[ 41.600675][ T4699] WARNING: CPU: 66 PID: 4699 at fs/xfs/xfs_message.c:89 asswarn (fs/xfs/xfs_message.c:89 (discriminator 1)) xfs
[   41.609938][ T4699] Modules linked in: xfs device_dax(+) nd_pmem nd_btt dax_pmem intel_rapl_msr intel_rapl_common btrfs x86_pkg_temp_thermal intel_powerclamp blake2b_generic xor coretemp raid6_pq libcrc32c sd_mod t10_pi crc64_rocksoft_generic crc64_rocksoft crc64 kvm_intel sg kvm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel sha512_ssse3 rapl ahci ipmi_ssif ast libahci intel_cstate binfmt_misc acpi_ipmi drm_shmem_helper mei_me ipmi_si i2c_i801 ioatdma dax_hmem intel_uncore libata drm_kms_helper mei i2c_smbus ipmi_devintf intel_pch_thermal nfit wmi dca ipmi_msghandler libnvdimm acpi_pad acpi_power_meter joydev drm loop fuse dm_mod ip_tables
[   41.669439][ T4699] CPU: 66 PID: 4699 Comm: filebench Not tainted 6.9.0-rc4-00238-gcbc81dd4e3e5 #1
[ 41.678673][ T4699] RIP: 0010:asswarn (fs/xfs/xfs_message.c:89 (discriminator 1)) xfs
[ 41.684114][ T4699] Code: 90 90 66 0f 1f 00 0f 1f 44 00 00 49 89 d0 41 89 c9 48 c7 c2 18 cd 45 c1 48 89 f1 48 89 fe 48 c7 c7 c8 e6 44 c1 e8 18 fd ff ff <0f> 0b c3 cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
All code
========
   0:   90                      nop
   1:   90                      nop
   2:   66 0f 1f 00             nopw   (%rax)
   6:   0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
   b:   49 89 d0                mov    %rdx,%r8
   e:   41 89 c9                mov    %ecx,%r9d
  11:   48 c7 c2 18 cd 45 c1    mov    $0xffffffffc145cd18,%rdx
  18:   48 89 f1                mov    %rsi,%rcx
  1b:   48 89 fe                mov    %rdi,%rsi
  1e:   48 c7 c7 c8 e6 44 c1    mov    $0xffffffffc144e6c8,%rdi
  25:   e8 18 fd ff ff          call   0xfffffffffffffd42
  2a:*  0f 0b                   ud2             <-- trapping instruction
  2c:   c3                      ret
  2d:   cc                      int3
  2e:   cc                      int3
  2f:   cc                      int3
  30:   cc                      int3
  31:   90                      nop
  32:   90                      nop
  33:   90                      nop
  34:   90                      nop
  35:   90                      nop
  36:   90                      nop
  37:   90                      nop
  38:   90                      nop
  39:   90                      nop
  3a:   90                      nop
  3b:   90                      nop
  3c:   90                      nop
  3d:   90                      nop
  3e:   90                      nop
  3f:   90                      nop

Code starting with the faulting instruction
===========================================
   0:   0f 0b                   ud2
   2:   c3                      ret
   3:   cc                      int3
   4:   cc                      int3
   5:   cc                      int3
   6:   cc                      int3
   7:   90                      nop
   8:   90                      nop
   9:   90                      nop
   a:   90                      nop
   b:   90                      nop
   c:   90                      nop
   d:   90                      nop
   e:   90                      nop
   f:   90                      nop
  10:   90                      nop
  11:   90                      nop
  12:   90                      nop
  13:   90                      nop
  14:   90                      nop
  15:   90                      nop
[   41.704055][ T4699] RSP: 0018:ffa0000020c4faa0 EFLAGS: 00010246
[   41.710227][ T4699] RAX: 0000000000000000 RBX: ff11000105112300 RCX: 000000007fffffff
[   41.718304][ T4699] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffc144e6c8
[   41.726378][ T4699] RBP: ff1100010067c000 R08: 0000000000000000 R09: 000000000000000a
[   41.734449][ T4699] R10: 000000000000000a R11: 0fffffffffffffff R12: ffa0000020c4fc28
[   41.742526][ T4699] R13: ff1100013d163200 R14: ff11000107e5f000 R15: 0000000000000023
[   41.750622][ T4699] FS:  00007fffd14006c0(0000) GS:ff1100103fa80000(0000) knlGS:0000000000000000
[   41.759686][ T4699] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   41.766378][ T4699] CR2: 00007ffff7d50000 CR3: 0000000159594005 CR4: 0000000000771ef0
[   41.774460][ T4699] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   41.782532][ T4699] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   41.790619][ T4699] PKRU: 55555554
[   41.794261][ T4699] Call Trace:
[   41.797669][ T4699]  <TASK>
[ 41.800737][ T4699] ? __warn (kernel/panic.c:694)
[ 41.804898][ T4699] ? asswarn (fs/xfs/xfs_message.c:89 (discriminator 1)) xfs
[ 41.809761][ T4699] ? report_bug (lib/bug.c:180 lib/bug.c:219)
[ 41.814357][ T4699] ? handle_bug (arch/x86/kernel/traps.c:239)
[ 41.818819][ T4699] ? exc_invalid_op (arch/x86/kernel/traps.c:260 (discriminator 1))
[ 41.823593][ T4699] ? asm_exc_invalid_op (arch/x86/include/asm/idtentry.h:621)
[ 41.828743][ T4699] ? asswarn (fs/xfs/xfs_message.c:89 (discriminator 1)) xfs
[ 41.833541][ T4699] xfs_dir2_sf_addname (fs/xfs/libxfs/xfs_dir2_sf.c:457 (discriminator 1)) xfs
[ 41.839390][ T4699] xfs_dir_createname (fs/xfs/libxfs/xfs_dir2.c:357) xfs
[ 41.845125][ T4699] xfs_create (fs/xfs/xfs_inode.c:1116) xfs
[ 41.850168][ T4699] ? generic_permission (fs/namei.c:346 (discriminator 1) fs/namei.c:407 (discriminator 1))
[ 41.855344][ T4699] xfs_generic_create (fs/xfs/xfs_iops.c:202 (discriminator 1)) xfs
[ 41.861071][ T4699] ? generic_permission (fs/namei.c:346 (discriminator 1) fs/namei.c:407 (discriminator 1))
[ 41.866237][ T4699] lookup_open+0x4c8/0x570
[ 41.871311][ T4699] open_last_lookups (fs/namei.c:3567 (discriminator 1))
[ 41.876301][ T4699] path_openat (fs/namei.c:3796)
[ 41.880726][ T4699] do_filp_open (fs/namei.c:3826)
[ 41.885194][ T4699] do_sys_openat2 (fs/open.c:1406)
[ 41.889761][ T4699] __x64_sys_openat (fs/open.c:1432)
[ 41.894487][ T4699] do_syscall_64 (arch/x86/entry/common.c:52 (discriminator 1) arch/x86/entry/common.c:83 (discriminator 1))
[ 41.899034][ T4699] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
[   41.904966][ T4699] RIP: 0033:0x7ffff7df0f80
[ 41.909418][ T4699] Code: 48 89 44 24 20 75 93 44 89 54 24 0c e8 39 d8 f8 ff 44 8b 54 24 0c 89 da 48 89 ee 41 89 c0 bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00 f0 ff ff 77 38 44 89 c7 89 44 24 0c e8 8c d8 f8 ff 8b 44
All code
========
   0:   48 89 44 24 20          mov    %rax,0x20(%rsp)
   5:   75 93                   jne    0xffffffffffffff9a
   7:   44 89 54 24 0c          mov    %r10d,0xc(%rsp)
   c:   e8 39 d8 f8 ff          call   0xfffffffffff8d84a
  11:   44 8b 54 24 0c          mov    0xc(%rsp),%r10d
  16:   89 da                   mov    %ebx,%edx
  18:   48 89 ee                mov    %rbp,%rsi
  1b:   41 89 c0                mov    %eax,%r8d
  1e:   bf 9c ff ff ff          mov    $0xffffff9c,%edi
  23:   b8 01 01 00 00          mov    $0x101,%eax
  28:   0f 05                   syscall
  2a:*  48 3d 00 f0 ff ff       cmp    $0xfffffffffffff000,%rax         <-- trapping instruction
  30:   77 38                   ja     0x6a
  32:   44 89 c7                mov    %r8d,%edi
  35:   89 44 24 0c             mov    %eax,0xc(%rsp)
  39:   e8 8c d8 f8 ff          call   0xfffffffffff8d8ca
  3e:   8b                      .byte 0x8b
  3f:   44                      rex.R

Code starting with the faulting instruction
===========================================
   0:   48 3d 00 f0 ff ff       cmp    $0xfffffffffffff000,%rax
   6:   77 38                   ja     0x40
   8:   44 89 c7                mov    %r8d,%edi
   b:   89 44 24 0c             mov    %eax,0xc(%rsp)
   f:   e8 8c d8 f8 ff          call   0xfffffffffff8d8a0
  14:   8b                      .byte 0x8b
  15:   44                      rex.R
[   41.929230][ T4699] RSP: 002b:00007fffd13fdcd0 EFLAGS: 00000293 ORIG_RAX: 0000000000000101
[   41.937705][ T4699] RAX: ffffffffffffffda RBX: 0000000000000042 RCX: 00007ffff7df0f80
[   41.945760][ T4699] RDX: 0000000000000042 RSI: 00007fffd13fde00 RDI: 00000000ffffff9c
[   41.953766][ T4699] RBP: 00007fffd13fde00 R08: 0000000000000000 R09: 00007ffeb4000b70
[   41.961774][ T4699] R10: 00000000000001b6 R11: 0000000000000293 R12: 0000000000000000
[   41.969773][ T4699] R13: 00007fffef5b6148 R14: 00007fffd13fee00 R15: 0000000000000040
[   41.977770][ T4699]  </TASK>
[   41.980813][ T4699] ---[ end trace 0000000000000000 ]---
[   42.196053][ T4696] XFS: Assertion failed: error != -ENOENT, file: fs/xfs/xfs_inode.c, line: 2827
[   42.205189][ T4696] ------------[ cut here ]------------
[ 42.210734][ T4696] WARNING: CPU: 28 PID: 4696 at fs/xfs/xfs_message.c:89 asswarn (fs/xfs/xfs_message.c:89 (discriminator 1)) xfs
[   42.219964][ T4696] Modules linked in: xfs device_dax(+) nd_pmem nd_btt dax_pmem intel_rapl_msr intel_rapl_common btrfs x86_pkg_temp_thermal intel_powerclamp blake2b_generic xor coretemp raid6_pq libcrc32c sd_mod t10_pi crc64_rocksoft_generic crc64_rocksoft crc64 kvm_intel sg kvm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel sha512_ssse3 rapl ahci ipmi_ssif ast libahci intel_cstate binfmt_misc acpi_ipmi drm_shmem_helper mei_me ipmi_si i2c_i801 ioatdma dax_hmem intel_uncore libata drm_kms_helper mei i2c_smbus ipmi_devintf intel_pch_thermal nfit wmi dca ipmi_msghandler libnvdimm acpi_pad acpi_power_meter joydev drm loop fuse dm_mod ip_tables
[   42.279151][ T4696] CPU: 28 PID: 4696 Comm: filebench Tainted: G        W          6.9.0-rc4-00238-gcbc81dd4e3e5 #1
[ 42.289767][ T4696] RIP: 0010:asswarn (fs/xfs/xfs_message.c:89 (discriminator 1)) xfs
[ 42.295150][ T4696] Code: 90 90 66 0f 1f 00 0f 1f 44 00 00 49 89 d0 41 89 c9 48 c7 c2 18 cd 45 c1 48 89 f1 48 89 fe 48 c7 c7 c8 e6 44 c1 e8 18 fd ff ff <0f> 0b c3 cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
All code
========
   0:   90                      nop
   1:   90                      nop
   2:   66 0f 1f 00             nopw   (%rax)
   6:   0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
   b:   49 89 d0                mov    %rdx,%r8
   e:   41 89 c9                mov    %ecx,%r9d
  11:   48 c7 c2 18 cd 45 c1    mov    $0xffffffffc145cd18,%rdx
  18:   48 89 f1                mov    %rsi,%rcx
  1b:   48 89 fe                mov    %rdi,%rsi
  1e:   48 c7 c7 c8 e6 44 c1    mov    $0xffffffffc144e6c8,%rdi
  25:   e8 18 fd ff ff          call   0xfffffffffffffd42
  2a:*  0f 0b                   ud2             <-- trapping instruction
  2c:   c3                      ret
  2d:   cc                      int3
  2e:   cc                      int3
  2f:   cc                      int3
  30:   cc                      int3
  31:   90                      nop
  32:   90                      nop
  33:   90                      nop
  34:   90                      nop
  35:   90                      nop
  36:   90                      nop
  37:   90                      nop
  38:   90                      nop
  39:   90                      nop
  3a:   90                      nop
  3b:   90                      nop
  3c:   90                      nop
  3d:   90                      nop
  3e:   90                      nop
  3f:   90                      nop

Code starting with the faulting instruction
===========================================
   0:   0f 0b                   ud2
   2:   c3                      ret
   3:   cc                      int3
   4:   cc                      int3
   5:   cc                      int3
   6:   cc                      int3
   7:   90                      nop
   8:   90                      nop
   9:   90                      nop
   a:   90                      nop
   b:   90                      nop
   c:   90                      nop
   d:   90                      nop
   e:   90                      nop
   f:   90                      nop
  10:   90                      nop
  11:   90                      nop
  12:   90                      nop
  13:   90                      nop
  14:   90                      nop
  15:   90                      nop
[   42.314977][ T4696] RSP: 0018:ffa0000020c37db8 EFLAGS: 00010246
[   42.321096][ T4696] RAX: 0000000000000000 RBX: ff1100017eccc400 RCX: 000000007fffffff
[   42.329126][ T4696] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffc144e6c8
[   42.337154][ T4696] RBP: ffa0000020c37e40 R08: 0000000000000000 R09: 000000000000000a
[   42.345178][ T4696] R10: 000000000000000a R11: 0fffffffffffffff R12: ff11000107e5f000
[   42.353204][ T4696] R13: 0000000000008000 R14: 0000000000000000 R15: ff1100010067c000
[   42.361240][ T4696] FS:  00007fffd32006c0(0000) GS:ff1100103f900000(0000) knlGS:0000000000000000
[   42.370230][ T4696] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   42.376878][ T4696] CR2: 0000555555579cf0 CR3: 0000000159594005 CR4: 0000000000771ef0
[   42.384913][ T4696] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   42.392951][ T4696] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   42.400990][ T4696] PKRU: 55555554
[   42.404617][ T4696] Call Trace:
[   42.407980][ T4696]  <TASK>
[ 42.410992][ T4696] ? __warn (kernel/panic.c:694)
[ 42.415133][ T4696] ? asswarn (fs/xfs/xfs_message.c:89 (discriminator 1)) xfs
[ 42.419927][ T4696] ? report_bug (lib/bug.c:180 lib/bug.c:219)
[ 42.424498][ T4696] ? handle_bug (arch/x86/kernel/traps.c:239)
[ 42.428892][ T4696] ? exc_invalid_op (arch/x86/kernel/traps.c:260 (discriminator 1))
[ 42.433649][ T4696] ? asm_exc_invalid_op (arch/x86/include/asm/idtentry.h:621)
[ 42.438775][ T4696] ? asswarn (fs/xfs/xfs_message.c:89 (discriminator 1)) xfs
[ 42.443560][ T4696] ? asswarn (fs/xfs/xfs_message.c:89 (discriminator 1)) xfs
[ 42.448341][ T4696] xfs_remove (fs/xfs/xfs_inode.c:2827 (discriminator 1)) xfs
[ 42.453379][ T4696] xfs_vn_unlink (fs/xfs/xfs_iops.c:404) xfs
[ 42.458499][ T4696] vfs_unlink (fs/namei.c:4335)
[ 42.462895][ T4696] do_unlinkat (fs/namei.c:4399 (discriminator 1))
[ 42.467367][ T4696] __x64_sys_unlink (fs/namei.c:4445)
[ 42.472097][ T4696] do_syscall_64 (arch/x86/entry/common.c:52 (discriminator 1) arch/x86/entry/common.c:83 (discriminator 1))
[ 42.476661][ T4696] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
[   42.482607][ T4696] RIP: 0033:0x7ffff7df2a07
[ 42.487068][ T4696] Code: f0 ff ff 73 01 c3 48 8b 0d f6 83 0d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 b8 57 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c9 83 0d 00 f7 d8 64 89 01 48
All code
========
   0:   f0 ff                   lock (bad)
   2:   ff 73 01                push   0x1(%rbx)
   5:   c3                      ret
   6:   48 8b 0d f6 83 0d 00    mov    0xd83f6(%rip),%rcx        # 0xd8403
   d:   f7 d8                   neg    %eax
   f:   64 89 01                mov    %eax,%fs:(%rcx)
  12:   48 83 c8 ff             or     $0xffffffffffffffff,%rax
  16:   c3                      ret
  17:   66 2e 0f 1f 84 00 00    cs nopw 0x0(%rax,%rax,1)
  1e:   00 00 00
  21:   66 90                   xchg   %ax,%ax
  23:   b8 57 00 00 00          mov    $0x57,%eax
  28:   0f 05                   syscall
  2a:*  48 3d 01 f0 ff ff       cmp    $0xfffffffffffff001,%rax         <-- trapping instruction
  30:   73 01                   jae    0x33
  32:   c3                      ret
  33:   48 8b 0d c9 83 0d 00    mov    0xd83c9(%rip),%rcx        # 0xd8403
  3a:   f7 d8                   neg    %eax
  3c:   64 89 01                mov    %eax,%fs:(%rcx)
  3f:   48                      rex.W

Code starting with the faulting instruction
===========================================
   0:   48 3d 01 f0 ff ff       cmp    $0xfffffffffffff001,%rax
   6:   73 01                   jae    0x9
   8:   c3                      ret
   9:   48 8b 0d c9 83 0d 00    mov    0xd83c9(%rip),%rcx        # 0xd83d9
  10:   f7 d8                   neg    %eax
  12:   64 89 01                mov    %eax,%fs:(%rcx)
  15:   48                      rex.W
[   42.506970][ T4696] RSP: 002b:00007fffd31fee38 EFLAGS: 00000206 ORIG_RAX: 0000000000000057
[   42.515426][ T4696] RAX: ffffffffffffffda RBX: 00007fffef5b5c08 RCX: 00007ffff7df2a07
[   42.523454][ T4696] RDX: 0000000000000000 RSI: 000000006638299e RDI: 00007fffd31fee60
[   42.531478][ T4696] RBP: 00007fffd31fee60 R08: 0000000000000007 R09: 00007ffed4000b70
[   42.539501][ T4696] R10: 00007fffd31fee00 R11: 0000000000000206 R12: 00007ffed4000b70
[   42.547525][ T4696] R13: 00007ffff55e3ae0 R14: 00007ffff5940c08 R15: 00007fffd2a00000
[   42.555540][ T4696]  </TASK>
[   42.558619][ T4696] ---[ end trace 0000000000000000 ]---
[ 42.564118][ T4696] XFS (sdd1): Internal error xfs_trans_cancel at line 1112 of file fs/xfs/xfs_trans.c. Caller xfs_remove (fs/xfs/xfs_inode.c:2865) xfs
[   42.577304][ T4696] CPU: 28 PID: 4696 Comm: filebench Tainted: G        W          6.9.0-rc4-00238-gcbc81dd4e3e5 #1
[   42.587946][ T4696] Call Trace:
[   42.591293][ T4696]  <TASK>
[ 42.594294][ T4696] dump_stack_lvl (lib/dump_stack.c:117)
[ 42.598846][ T4696] xfs_trans_cancel (fs/xfs/xfs_trans.c:1113) xfs
[ 42.604396][ T4696] xfs_remove (fs/xfs/xfs_inode.c:2865) xfs
[ 42.609419][ T4696] xfs_vn_unlink (fs/xfs/xfs_iops.c:404) xfs
[ 42.614520][ T4696] vfs_unlink (fs/namei.c:4335)
[ 42.618888][ T4696] do_unlinkat (fs/namei.c:4399 (discriminator 1))
[ 42.623340][ T4696] __x64_sys_unlink (fs/namei.c:4445)
[ 42.628051][ T4696] do_syscall_64 (arch/x86/entry/common.c:52 (discriminator 1) arch/x86/entry/common.c:83 (discriminator 1))
[ 42.632585][ T4696] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
[   42.638504][ T4696] RIP: 0033:0x7ffff7df2a07
[ 42.642945][ T4696] Code: f0 ff ff 73 01 c3 48 8b 0d f6 83 0d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 b8 57 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c9 83 0d 00 f7 d8 64 89 01 48
All code
========
   0:   f0 ff                   lock (bad)
   2:   ff 73 01                push   0x1(%rbx)
   5:   c3                      ret
   6:   48 8b 0d f6 83 0d 00    mov    0xd83f6(%rip),%rcx        # 0xd8403
   d:   f7 d8                   neg    %eax
   f:   64 89 01                mov    %eax,%fs:(%rcx)
  12:   48 83 c8 ff             or     $0xffffffffffffffff,%rax
  16:   c3                      ret
  17:   66 2e 0f 1f 84 00 00    cs nopw 0x0(%rax,%rax,1)
  1e:   00 00 00
  21:   66 90                   xchg   %ax,%ax
  23:   b8 57 00 00 00          mov    $0x57,%eax
  28:   0f 05                   syscall
  2a:*  48 3d 01 f0 ff ff       cmp    $0xfffffffffffff001,%rax         <-- trapping instruction
  30:   73 01                   jae    0x33
  32:   c3                      ret
  33:   48 8b 0d c9 83 0d 00    mov    0xd83c9(%rip),%rcx        # 0xd8403
  3a:   f7 d8                   neg    %eax
  3c:   64 89 01                mov    %eax,%fs:(%rcx)
  3f:   48                      rex.W

Code starting with the faulting instruction
===========================================
   0:   48 3d 01 f0 ff ff       cmp    $0xfffffffffffff001,%rax
   6:   73 01                   jae    0x9
   8:   c3                      ret
   9:   48 8b 0d c9 83 0d 00    mov    0xd83c9(%rip),%rcx        # 0xd83d9
  10:   f7 d8                   neg    %eax
  12:   64 89 01                mov    %eax,%fs:(%rcx)
  15:   48                      rex.W
[   42.662759][ T4696] RSP: 002b:00007fffd31fee38 EFLAGS: 00000206 ORIG_RAX: 0000000000000057
[   42.671206][ T4696] RAX: ffffffffffffffda RBX: 00007fffef5b5c08 RCX: 00007ffff7df2a07
[   42.679223][ T4696] RDX: 0000000000000000 RSI: 000000006638299e RDI: 00007fffd31fee60
[   42.687242][ T4696] RBP: 00007fffd31fee60 R08: 0000000000000007 R09: 00007ffed4000b70
[   42.695260][ T4696] R10: 00007fffd31fee00 R11: 0000000000000206 R12: 00007ffed4000b70
[   42.703276][ T4696] R13: 00007ffff55e3ae0 R14: 00007ffff5940c08 R15: 00007fffd2a00000
[   42.711295][ T4696]  </TASK>


The kernel config is available at:
https://download.01.org/0day-ci/archive/20240510/202405101352.bcf759f-lkp@intel.com


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
