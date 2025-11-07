Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9B6298CDC;
	Fri,  7 Nov 2025 07:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762500137; cv=fail; b=FVOaTYDxnY7op4b+fyIP8cpGMn1vQR2W7LdUTGC8glHRD+52QhHKoEbrtyR/TdErE+3VmxrIk5K5WBR9TKkF1kspCZwd0WkuVYfGr5CgdIfIvImCd/0JZo+7yCedADd8ZJtzufn0WqcuT6myF6Ak+WIhn7rLo8BBpv93+n0OydA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762500137; c=relaxed/simple;
	bh=DKMZKHs9ysA23poO7frb7A8vcUEyhdq3Su5CP9D+/aY=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=AWD0r8ExXBOIqNdVOXfo/PRNETKb1VWDknkhO+NwdKKZUT/zIOz+B9QnQcdLD6KKDaddkmfQN8Sbf1JWr8pGIQ+wsmJX+NPsaAKjsykVejQfWs3+GboThX4pSquka+D2rR1WHN2gFWlTJNwu1bhX/s3lUDnfuOm400kpaSJ15Vk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fcZ5Bi8N; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fcZ5Bi8N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762500135; x=1794036135;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=DKMZKHs9ysA23poO7frb7A8vcUEyhdq3Su5CP9D+/aY=;
  b=fcZ5Bi8NLdha/jotyiHpAZzNHgzKY9MGJcsUcLp2hI52eplonFgeyZv2
   awzrHaZukNbM+O5a191QXRtel4753zV/fQ/i8GkuM3cycBu+Pv+hmPKrb
   uUBfHmXZhZzCVVp2mHIjO1MOUCzNMF4gLYr7CVPZvjtW8PBChsKwUvhKP
   s9YtTReACjC+HmtZgOz3QhHhWTJUTCA3+JsVFvlue+7Vp2d9TgwQbkr+I
   qF0v+niX4wCuWm7t+T5CSxSFhFjtM1z1TMx0tU3Q4zcTvmg/SWC5HP8PO
   zZ0kCxxLyWLWLEJu+3UEx5utNpvUqad65KPPQhNjMNL6rx+Y97iPgi8en
   g==;
X-CSE-ConnectionGUID: KMfA+yXFQWyshoKivrA8ew==
X-CSE-MsgGUID: ihRjClISRnO1kyXTgcKlvA==
X-IronPort-AV: E=McAfee;i="6800,10657,11605"; a="64346261"
X-IronPort-AV: E=Sophos;i="6.19,286,1754982000"; 
   d="scan'208";a="64346261"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 23:22:15 -0800
X-CSE-ConnectionGUID: yHaLPfsXR++O5cmjuSSzog==
X-CSE-MsgGUID: 7cPzfz+rTCqkZaN6xgKVqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,286,1754982000"; 
   d="scan'208";a="187275501"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 23:22:15 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 6 Nov 2025 23:22:14 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 6 Nov 2025 23:22:14 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.54)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 6 Nov 2025 23:22:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cnUHODqytnBZPzPfmk8hAYn995my6GtIW3l7xUnr9qeyTdNKBFZX4ShdYH171HW+cV/Z75nRwRTpoIJNF1q+MCBApejWByYSbVzoskmQK01WtMphNLQYSkqXGVtZXJ1Nv5tQlsDL7ZFxgCJ47mTbwxI2JQzD1n1Mqn1DSaleRrkOdZisY2BwtqZQWstFOUCK6jAY69e9GFuPjNurASRLiowUxRLUpxJPCVskUT3tZmXldRrgyTPgGQTgVXM5u1cuuN6D7ksZou/R8dtUS36uuwXSTWt9KBEdC8s7fTOAU4mm0KiCT1kSUOfMrMoJ7YiOiyWIguuQYJBS0k64CM8Flw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SGNuprkLcZsrs836o1KK0buL6ZukGmhMdeCytZbNDCA=;
 b=mguTHrpiB3qNBWYzIHpnIXZo0AZfcZ//UaC8rb8WXVA83pKfNIBzoQvNaYI8FfdchXU8rjS9klMuYZpITcnRf4nde3YkG7lFoTRDPOfkkZLAaGiazo1ns5+7SSHXExOvfaB9bM19i1sTzHkbKtx9kFq6fVkYpPVNHhgy1mBF3OXWlceUdq2NWhvqD4GGr1oZVgpbJsR67XkGOb9JuSvhvoTXY4UXZdpznB1Wm7sAHEbReBpI61nB1UbFsp6D839mpwUKfPm6OBODtZje1kdQCAqCjNtK7f/Z930tcAk/1qnwlYqrebzTsucd62Y1CJ1CaXFmByDa+C7Yl9xmvD8OfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8587.namprd11.prod.outlook.com (2603:10b6:a03:568::21)
 by MN2PR11MB4568.namprd11.prod.outlook.com (2603:10b6:208:266::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Fri, 7 Nov
 2025 07:22:06 +0000
Received: from SJ2PR11MB8587.namprd11.prod.outlook.com
 ([fe80::4050:8bc7:b7c9:c125]) by SJ2PR11MB8587.namprd11.prod.outlook.com
 ([fe80::4050:8bc7:b7c9:c125%7]) with mapi id 15.20.9298.010; Fri, 7 Nov 2025
 07:22:05 +0000
Date: Fri, 7 Nov 2025 15:21:54 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Dave Chinner <dchinner@redhat.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Jan Kara <jack@suse.cz>, Christoph Hellwig
	<hch@lst.de>, <linux-xfs@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [linus:master] [xfs]  c91d38b57f:  stress-ng.chmod.ops_per_sec
 3807.5% improvement
Message-ID: <202511071447.b5bd3ddf-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR04CA0197.apcprd04.prod.outlook.com
 (2603:1096:4:14::35) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8587:EE_|MN2PR11MB4568:EE_
X-MS-Office365-Filtering-Correlation-Id: e88433b6-1a89-42a2-82c2-08de1dce5997
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?jIqZfpYDDbBYARjLQdvZy1nCblHM2fGDENnMJ0I68chQYGl6UVr22ZQP4e?=
 =?iso-8859-1?Q?W3WRRBbwUP4jHAZ1H96dPH/vlZq4ZFns4tTXtH0g37j3zkAaKCxibg9VyP?=
 =?iso-8859-1?Q?PAOoHqemQsIMJo51Jvbi5XtsyhW6d7lFzDupzLCJMczIgp7CaG7JAjQm4I?=
 =?iso-8859-1?Q?RqHM5G7PptRKjCXe6Sk94T3RmLl5u6Wluu08pXQ3uqLuMZPrFnNE7Hm3/x?=
 =?iso-8859-1?Q?6d5NgSy8mvQsQeymZ3F0zLeDdg65tecjxbWYFoMpnKtAK2ykfwdKcMYY1t?=
 =?iso-8859-1?Q?aBU1yRe2tUkckDdsEqWJx8XqlqMu+5ZAmSuCuTO7Y/3m30QauDkPuDxZCt?=
 =?iso-8859-1?Q?4f3bUK5vpErFNp/2tYPjeN3tcx27ze7h8nmFZz/9pBqRAcc3bTZ9VbNkEE?=
 =?iso-8859-1?Q?7zV+UZ2bXFfjClVwjAgoHdyszKXrYWeRhRenn5Hahj7DIeBc41ZvhAD2kS?=
 =?iso-8859-1?Q?+iAfvfjb7AdaYQLcZdptIQZxjeXJL63E7IyKGJ+6aFM9PT1SIT7oKcgSKs?=
 =?iso-8859-1?Q?r18jpmFs1hjfpCJuQVfh0Jq/KAJRfz7812yJmzPKzsfIkA3d+jE0grJdBf?=
 =?iso-8859-1?Q?1nkY/utWEFxWhHhAg+shcLwuRvzUSh3a297yeYHdsuyzad/7ecbIWvwSFi?=
 =?iso-8859-1?Q?icibIvJ0AwcYKj5ie7TW04QCLU0UnKb7aw9lIFcVWIlsNhitPcFGRgYs/f?=
 =?iso-8859-1?Q?/kkHqgsPDTG6mlTUmY5Mvwf2TtCl3U3bx5U+Yrue+dNiTbwU2NEkCfS9C5?=
 =?iso-8859-1?Q?V0Qc5EvCKG0R1aXAP9y8ihFn7Pq/eftWixuzMJFoAeCMnTzsLlcJcq4aG9?=
 =?iso-8859-1?Q?+G+Ws4eaSxO79WZUVSkyyo6T/LieI0FKa5DO0VrbCnm2Y1YapNBjNxAVzr?=
 =?iso-8859-1?Q?JCxPkkXJ8fGxNevUh6MiQ1nw/Rkq4YPdJlfmS4EXiDv+7Fh0e7cF/LzTk9?=
 =?iso-8859-1?Q?VCWGKLkNXhu4Y/BXFBolikjui2MJaSQCSoEF+WU9xtfSQvWAn+0sv151jZ?=
 =?iso-8859-1?Q?GAijEDl8mu8wjetA1bq4z4NrDdczGvXfgImgq5f/vQuj5eWahfZreqwmSp?=
 =?iso-8859-1?Q?CGj1rhWcgrRzLSYBh3wXMIoWtcfookWUboGCM7EvvZHl8megSqUWYGY2Gx?=
 =?iso-8859-1?Q?t9jFkLJPA/9mi9EZPWqCBNSkzbZkcOwQWMVQhKHqZQ1UnhymFcj4tspp/e?=
 =?iso-8859-1?Q?R9WkpbWEVXgHlAsGJoLF0rKtduPezs2kJp+IMiKPWOt54XERiJGZQw13uZ?=
 =?iso-8859-1?Q?jr/ycF0rKaxjNN2RDEHqk5FgUarv1zvrZgr9TIoHtbQVcdFmsJOqKv6Is6?=
 =?iso-8859-1?Q?OJaUN7anCS7Zesem7T8OeAukwvQHsnXlmzz+pzQoMjytieXU8Hh2/XGMGv?=
 =?iso-8859-1?Q?1M4Gu+urMEzhC97MRPvdcIfJ4LcH1seX0y8eKra17lDHMhbxmyLwMFVhH0?=
 =?iso-8859-1?Q?8D+1wgiLkXzkL+84My99jCBrIsUG4gNYhrs3+Sb207mkSPuDn0UcolTMS3?=
 =?iso-8859-1?Q?LKtDiLE3D77MeU7dmu6ZEP/DNfzMc4QtVcsxN57tJ5JA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8587.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?TxN+AWg/aP8P+W0LSBr45icxHMl1JEevwh82gCsx56vbqm5tIzQnEONsVf?=
 =?iso-8859-1?Q?IxqXaNC2uoPVLktuGtTxQbkCpHYJPu2yj1floQQsjvxCE1ey/Qxv404KNR?=
 =?iso-8859-1?Q?iu1fX3PM1eQ+69ftuqfRbg8It3PrqeTI04GP6uTei8sB56nzkQmr2C01Wf?=
 =?iso-8859-1?Q?wG1jH6I4jGq8TMqCaKScUY0soZd9J1gLgET0m3hpqeRTkcY8lXU6B6zX62?=
 =?iso-8859-1?Q?oKI7IMUnp3EzQDwhPFq4HQ4xv1DJfEsa6kfm4LY0F5zTmmEyXSkieIZWN0?=
 =?iso-8859-1?Q?aCPjCjgKXOOoDJoSeZiHthV+Ox4V81Fz7NndF+39py2F+1iQcJ0gTREClu?=
 =?iso-8859-1?Q?MkAqxLbeUSIOZASRCMK7c81FN4OaV6veB1SRnugmj5i+NnmM6anxcU9yLM?=
 =?iso-8859-1?Q?kKT2zXh34W4wyC+db+cbqB1Yj+ALwDLVVVU28WaDyJK1GSpsNYvr5BKiIF?=
 =?iso-8859-1?Q?zySQP/GpLo3LN7cBqvJ4NT01LoVXnq4dDcFc8rNYj2vGkoui4XhnARjKLz?=
 =?iso-8859-1?Q?e43/o7YStS/UL/Bjf3BT69U83JHz/gCOM+RDhguWhRBfaEKZHJO2fDzY5i?=
 =?iso-8859-1?Q?kcY7pLi6jcPXuSKo3k9ypB1OYf5O/RxZM8pYO7Yw7+bNCsC12URc74/reS?=
 =?iso-8859-1?Q?w6gpQhc/FyY6MjfXykp83SCUhNdVWmeZX+x5LBT5hp2CJgHj2Jb8BHwWaE?=
 =?iso-8859-1?Q?ekXJ9gJiy8BF+IpwJK5m9DJChFcHYQjs6CpVQjCsbo0savkhFWSBtoOOm0?=
 =?iso-8859-1?Q?Bb21ou2w+tv0esnDb82KpSERgKb/voye6Qe0gD+t5z8whi8HIY4vMJZp1x?=
 =?iso-8859-1?Q?Q9URR4fSS6w+JDwvkIB8Iyn/weUx8vJdQgEr5T561Jvd1ZAvC7zSt3y+Zz?=
 =?iso-8859-1?Q?7CnE8ch4DevfhNzLD5+THBBKuTfs8RUcdyyYztGftpX6h4NneHfD50mSFK?=
 =?iso-8859-1?Q?bpnbZNYQpxxvV8rALrenVuAsC27IsFH2FhkkUF4XJX3IcbpCoSGNadXDm4?=
 =?iso-8859-1?Q?gzy1Ck25166APWYsDq7EQ2E33VTiHbOfC0dsGUGeezEmCq72/mfN2p/KvI?=
 =?iso-8859-1?Q?BfhX1OZ0NhoBeQU8TSMPL9k84ceyrE8O+nRaAg8yJAKat8d/eY4jX4068y?=
 =?iso-8859-1?Q?BG3zOpAH2x+R0mOBorVfAmC5p7UaDEnjB6iqu7u2VELxs7UJrm6Jwh5Wer?=
 =?iso-8859-1?Q?99qo5LH0kt81y9E1UHyEiqUGEKzWZrUbut9lbguB4RvvWcyQS4l/LW+URT?=
 =?iso-8859-1?Q?eciAtCnBinXY6K7ffCFneCwhuDCoRkv0LDKfQTLYXheiGxkLax48KrhqSq?=
 =?iso-8859-1?Q?0YaqyDtIqJuxMXOmFcJNKwC5IQkBu8VROL0NmQ9nB5Hwv2FY7gSJRH/3xO?=
 =?iso-8859-1?Q?rGrn7wtDH4Y43J+6g8v6g4tRCzRaO+DSD9SoPq4l+rmOB2mDSaSflj//+c?=
 =?iso-8859-1?Q?mJueM25b/Fxnve6XTKf+6Loc9JjeKLYQFATCuY6NZ6oyQS+gZ7LieUUAYy?=
 =?iso-8859-1?Q?aWpQalWqaHaV6QvECE9ek5afWyGHOzbkRfT+0XfnmfhhA392Vin3el2G6a?=
 =?iso-8859-1?Q?bFUIKUdnPYm4ae9Pt+jfDoL6ZRcAM2193ZZ069rW8Vu1ednoZgCBcZfKez?=
 =?iso-8859-1?Q?y8L1R2MJFmK1YCVFRCkAHuSdD2t2ucsekcrdoVJ1EqwIM1FrhYSAq3Pg?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e88433b6-1a89-42a2-82c2-08de1dce5997
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 07:22:05.3577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YWFAUHMf6qwiu8XJwoEhx1/lLR7NrDHnLQGvpabebcaEUb6vDeyHI7yt7jWrgLhtlmo+vpg6VdylfbOacmutxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4568
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed a 3807.5% improvement of stress-ng.chmod.ops_per_sec on:


commit: c91d38b57f2c4784d885c874b2a1234a01361afd ("xfs: rework datasync tracking and execution")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master


testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory
parameters:

	nr_threads: 100%
	disk: 1HDD
	testtime: 60s
	fs: xfs
	test: chmod
	cpufreq_governor: performance


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20251107/202511071447.b5bd3ddf-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/disk/fs/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/1HDD/xfs/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-icl-2sp8/chmod/stress-ng/60s

commit: 
  bc7d684fea ("xfs: rearrange code in xfs_inode_item_precommit")
  c91d38b57f ("xfs: rework datasync tracking and execution")

bc7d684fea18cc48 c91d38b57f2c4784d885c874b2a 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      6943 ±  2%     -31.3%       4767        uptime.idle
 3.968e+09           -19.6%  3.191e+09        cpuidle..time
    267038 ±  6%    +228.0%     875840 ±  6%  cpuidle..usage
    202471 ± 87%    +110.4%     425943 ± 53%  numa-meminfo.node1.Active
    202464 ± 87%    +110.4%     425935 ± 53%  numa-meminfo.node1.Active(anon)
     11019 ± 11%    +614.5%      78736 ± 19%  numa-meminfo.node1.Shmem
     50689 ± 87%    +110.2%     106536 ± 53%  numa-vmstat.node1.nr_active_anon
      2736 ± 11%    +620.7%      19718 ± 19%  numa-vmstat.node1.nr_shmem
     50689 ± 87%    +110.2%     106536 ± 53%  numa-vmstat.node1.nr_zone_active_anon
     98.29           -47.8%      51.30 ±  2%  iostat.cpu.idle
      0.01 ± 34%  +4.4e+05%      29.80        iostat.cpu.iowait
      0.86 ±  8%   +1983.4%      17.82 ±  6%  iostat.cpu.system
      0.84 ± 13%     +27.9%       1.08 ±  2%  iostat.cpu.user
    678151           +10.8%     751607        meminfo.Active
    678134           +10.8%     751591        meminfo.Active(anon)
     74229 ±  4%     -10.1%      66725 ±  3%  meminfo.AnonHugePages
     16590 ±  5%    +432.3%      88307 ± 14%  meminfo.Shmem
     15.83 ± 23%   +1103.2%     190.50 ±  8%  perf-c2c.DRAM.local
    358.00 ± 30%   +3312.1%      12215 ±  7%  perf-c2c.DRAM.remote
    321.17 ± 32%   +2900.4%       9636 ±  7%  perf-c2c.HITM.local
    241.00 ± 30%   +3726.9%       9222 ±  7%  perf-c2c.HITM.remote
    562.17 ± 31%   +3254.7%      18859 ±  7%  perf-c2c.HITM.total
      1225 ± 14%   +3762.4%      47314 ±  4%  stress-ng.chmod.ops
     20.17 ± 15%   +3807.5%     788.15 ±  4%  stress-ng.chmod.ops_per_sec
    146.50 ± 11%    +752.3%       1248 ±  4%  stress-ng.time.involuntary_context_switches
     11984           +20.8%      14481        stress-ng.time.minor_page_faults
     34.17 ± 16%   +3293.2%       1159 ±  6%  stress-ng.time.percent_of_cpu_this_job_got
     21.27 ± 15%   +3173.1%     696.14 ±  6%  stress-ng.time.system_time
     62731 ± 16%   +1072.8%     735741 ±  9%  stress-ng.time.voluntary_context_switches
     98.30           -48.5       49.84 ±  2%  mpstat.cpu.all.idle%
      0.00 ±105%     +30.7       30.72        mpstat.cpu.all.iowait%
      0.02 ±  8%      +0.1        0.09 ±  6%  mpstat.cpu.all.irq%
      0.01 ± 18%      +0.0        0.02 ±  5%  mpstat.cpu.all.soft%
      0.83 ±  9%     +17.4       18.24 ±  6%  mpstat.cpu.all.sys%
      0.85 ± 14%      +0.2        1.09 ±  2%  mpstat.cpu.all.usr%
      1.00         +4033.3%      41.33 ± 33%  mpstat.max_utilization.seconds
      6.13 ±  6%    +333.0%      26.54 ±  4%  mpstat.max_utilization_pct
     65.17 ± 11%    +969.1%     696.67 ±  6%  turbostat.Avg_MHz
      1.81 ± 11%     +17.6       19.39 ±  6%  turbostat.Busy%
     98.22           -17.5       80.69        turbostat.C1%
     96.82           -25.6%      72.07        turbostat.CPU%c1
      0.72 ±  4%     -55.4%       0.32 ±  2%  turbostat.IPC
    372011 ±  8%    +706.5%    3000169 ±  5%  turbostat.IRQ
     23024 ± 30%   +2629.0%     628341 ±  6%  turbostat.NMI
    243.27            +9.4%     266.04        turbostat.PkgWatt
     15.14            +2.9%      15.57        turbostat.RAMWatt
    225.26 ± 17%     -92.7%      16.48 ±  9%  perf-sched.total_wait_and_delay.average.ms
      4552 ± 19%   +1482.3%      72026 ± 10%  perf-sched.total_wait_and_delay.count.ms
      4996           -22.0%       3898 ± 10%  perf-sched.total_wait_and_delay.max.ms
    225.25 ± 17%     -92.7%      16.46 ±  9%  perf-sched.total_wait_time.average.ms
      4996           -22.0%       3898 ± 10%  perf-sched.total_wait_time.max.ms
    225.26 ± 17%     -92.7%      16.48 ±  9%  perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      4552 ± 19%   +1482.3%      72026 ± 10%  perf-sched.wait_and_delay.count.[unknown].[unknown].[unknown].[unknown].[unknown]
      4996           -22.0%       3898 ± 10%  perf-sched.wait_and_delay.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
    225.25 ± 17%     -92.7%      16.46 ±  9%  perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      4996           -22.0%       3898 ± 10%  perf-sched.wait_time.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
    169578           +10.8%     187927        proc-vmstat.nr_active_anon
    935816            +1.9%     953408        proc-vmstat.nr_file_pages
     20878            +4.0%      21711        proc-vmstat.nr_mapped
      4142 ±  5%    +433.8%      22109 ± 14%  proc-vmstat.nr_shmem
     41118            +1.0%      41531        proc-vmstat.nr_slab_unreclaimable
    169578           +10.8%     187927        proc-vmstat.nr_zone_active_anon
    615.17 ±218%    +464.4%       3472 ± 14%  proc-vmstat.numa_hint_faults_local
    345828 ±  4%     +10.1%     380782 ±  2%  proc-vmstat.numa_hit
    279652 ±  5%     +12.5%     314600 ±  3%  proc-vmstat.numa_local
     60782 ± 60%     +78.2%     108287 ± 14%  proc-vmstat.numa_pte_updates
    382421 ±  4%      +9.6%     419096 ±  2%  proc-vmstat.pgalloc_normal
      5338 ± 20%    +193.0%      15639 ±  6%  proc-vmstat.pgpgout
      7731 ±  7%   +1078.0%      91080 ± 10%  sched_debug.cfs_rq:/.avg_vruntime.avg
     61046 ± 13%    +183.6%     173149 ± 14%  sched_debug.cfs_rq:/.avg_vruntime.max
    747.60 ± 23%   +3826.2%      29352 ± 13%  sched_debug.cfs_rq:/.avg_vruntime.min
     10401 ±  7%     +72.6%      17954 ±  9%  sched_debug.cfs_rq:/.avg_vruntime.stddev
    564880 ± 44%     -71.2%     162663 ±113%  sched_debug.cfs_rq:/.load.max
     79058 ± 37%     -64.4%      28177 ± 90%  sched_debug.cfs_rq:/.load.stddev
      7731 ±  7%   +1078.0%      91080 ± 10%  sched_debug.cfs_rq:/.min_vruntime.avg
     61046 ± 13%    +183.6%     173149 ± 14%  sched_debug.cfs_rq:/.min_vruntime.max
    747.60 ± 23%   +3826.2%      29352 ± 13%  sched_debug.cfs_rq:/.min_vruntime.min
     10401 ±  7%     +72.6%      17954 ±  9%  sched_debug.cfs_rq:/.min_vruntime.stddev
    254.61 ±  6%     +23.3%     313.88 ±  6%  sched_debug.cfs_rq:/.runnable_avg.avg
    254.13 ±  6%     +23.4%     313.61 ±  6%  sched_debug.cfs_rq:/.util_avg.avg
   1388025 ±  3%      -8.9%    1264183 ±  4%  sched_debug.cpu.avg_idle.avg
      4207 ±  7%    +257.6%      15044 ±  6%  sched_debug.cpu.nr_switches.avg
     13511 ± 20%    +276.6%      50888 ± 62%  sched_debug.cpu.nr_switches.max
      1440 ±  9%    +592.5%       9975 ±  4%  sched_debug.cpu.nr_switches.min
      2591 ± 14%    +129.9%       5958 ± 61%  sched_debug.cpu.nr_switches.stddev
     19.42 ± 31%    +137.8%      46.17 ± 17%  sched_debug.cpu.nr_uninterruptible.max
    -14.67          +891.5%    -145.42        sched_debug.cpu.nr_uninterruptible.min
      4.79 ± 10%    +353.6%      21.71 ± 15%  sched_debug.cpu.nr_uninterruptible.stddev
      0.94 ±  5%     -30.7%       0.65 ±  2%  perf-stat.i.MPKI
 6.179e+08 ± 12%    +373.6%  2.927e+09 ±  4%  perf-stat.i.branch-instructions
      3.29 ± 11%      -1.8        1.47 ±  8%  perf-stat.i.branch-miss-rate%
  43227294 ± 15%     +20.8%   52203685 ±  3%  perf-stat.i.branch-misses
     17.76 ±  6%     +19.1       36.85        perf-stat.i.cache-miss-rate%
   1306832 ± 11%    +601.7%    9169533 ±  4%  perf-stat.i.cache-misses
   8673239 ± 10%    +206.9%   26621069 ±  3%  perf-stat.i.cache-references
      3772 ± 10%    +618.3%      27098 ±  8%  perf-stat.i.context-switches
      2.43 ±  4%     +32.5%       3.23        perf-stat.i.cpi
 4.243e+09 ± 11%    +964.2%  4.515e+10 ±  6%  perf-stat.i.cpu-cycles
    116.32 ±  2%    +203.4%     352.94 ±  3%  perf-stat.i.cpu-migrations
      3133 ±  3%     +59.5%       4996 ±  2%  perf-stat.i.cycles-between-cache-misses
 3.037e+09 ± 12%    +376.7%  1.448e+10 ±  4%  perf-stat.i.instructions
      0.55 ±  4%     -40.3%       0.33 ±  2%  perf-stat.i.ipc
      0.43 ±  4%     +46.9%       0.63 ±  2%  perf-stat.overall.MPKI
      6.97 ±  3%      -5.2        1.79 ±  7%  perf-stat.overall.branch-miss-rate%
     15.06 ±  4%     +19.3       34.39        perf-stat.overall.cache-miss-rate%
      1.40 ±  3%    +122.3%       3.12        perf-stat.overall.cpi
      3252 ±  2%     +51.3%       4921 ±  3%  perf-stat.overall.cycles-between-cache-misses
      0.71 ±  3%     -55.1%       0.32        perf-stat.overall.ipc
 6.093e+08 ± 12%    +372.7%   2.88e+09 ±  4%  perf-stat.ps.branch-instructions
  42634564 ± 15%     +20.7%   51439404 ±  3%  perf-stat.ps.branch-misses
   1287683 ± 11%    +600.7%    9022871 ±  4%  perf-stat.ps.cache-misses
   8556164 ± 10%    +206.5%   26227629 ±  3%  perf-stat.ps.cache-references
      3710 ± 10%    +618.7%      26664 ±  8%  perf-stat.ps.context-switches
 4.185e+09 ± 11%    +961.5%  4.442e+10 ±  6%  perf-stat.ps.cpu-cycles
    114.49 ±  2%    +203.8%     347.78 ±  3%  perf-stat.ps.cpu-migrations
 2.995e+09 ± 12%    +375.7%  1.425e+10 ±  4%  perf-stat.ps.instructions
 1.865e+11 ± 12%    +369.7%  8.759e+11 ±  4%  perf-stat.total.instructions




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

