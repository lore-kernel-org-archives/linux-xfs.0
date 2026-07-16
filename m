Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7841E42379D;
	Thu, 16 Jul 2026 13:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784207676; cv=fail; b=AyCH9TXwLF0R5fe2YtGWVA1Vxs9N6EMaoHUw4vs640mEAbsSsHREoio5+ixolmqUx7TPqB9hhqK9pK3ZpYdj1fCarilAdGtXfTcXOOUOO9cmYVei9UZloXSzOUNZZnKgdhTxQsfQJNAaFWJFh6tEg8S0mgINajNeNUhhbB+imvs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784207676; c=relaxed/simple;
	bh=KuoKB+kaW/Ryt4bpG5YPrX219ZRFrDu3+WXVUVtaIdE=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=t4NgLEpDxcLGOHcCxP683FVNFNNgkfSRb+u/wbm0/IzOT/6nH61guuDR4n3GiJJFutZwOogj1J2HIWYTeIfqrLdXICoWNW45H96hgrytgGD8xKn94vt+FxMIO6Ap3PNVQnjjZR/+XcfvRKJZzps5nu8nrG4aMOjfHYu7jwKfkWQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OEZQZMt2; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OEZQZMt2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784207672; x=1815743672;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=KuoKB+kaW/Ryt4bpG5YPrX219ZRFrDu3+WXVUVtaIdE=;
  b=OEZQZMt2dHpzA0YxfZaPO2yr0IAxRUkbNwErHuj4LLJ1kSL3SmGretjv
   HmLbV1SEUil6cwv8TiZEPZmnaqH6RmouZimw1Tv09XXz0988CwWwxX2EO
   ByesLZv1CYue6f7fCxc246qTixE5w+xzSlK/uET8qIKlbhbiFHFwaPnP5
   soxVNDf49iCXujin9T9gllDbPXWfPW3laS9etcAslSJagNnr0lRKLNHtu
   0o1JMK1+eietWSRV21YBaDGoVGwmRepJ0R8Zj1611Gvqizaq5WQhhIsPh
   UMMaZ6TKICcoKEbMz0wYKUOYyWoiY3sdu3vgULbFinE6v5LbAe3QJOkhM
   g==;
X-CSE-ConnectionGUID: p9AKpdPpRUKxrIFdtRCkIA==
X-CSE-MsgGUID: bNpo/AP+RAeMviMvWggiYQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="84979278"
X-IronPort-AV: E=Sophos;i="6.25,167,1779174000"; 
   d="scan'208";a="84979278"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2026 06:13:33 -0700
X-CSE-ConnectionGUID: GbOVuZ9eRuG6avjYjSfE9w==
X-CSE-MsgGUID: dGSxJ7X8S3aks5wul7dx0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,167,1779174000"; 
   d="scan'208";a="258474881"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2026 06:13:33 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 16 Jul 2026 06:13:33 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Thu, 16 Jul 2026 06:13:33 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.14) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 16 Jul 2026 06:13:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PeQKHK/NlLWK/DFXwXwxoCjdTw8DOxrfbNXtB+2101cJg7QRfQatxk6gzFrT9UzlHQYYnUuN5HItgU5trImzUeAlMvqE1Pz/gTtIMPsODe7+Nlgef6vS9+fZX+Mj12zWCkqDu42tSI92sk3APY7x0m1Jiy8tzOHT31PPikGKJvjz9gSJ1BjGZ3BK17QMwr5G43GrpPpxR310HBpaZFGiaeq9RekWDw0LygXSQzFTpte51LT+lOdvfzX0SBbe9AgDbWbsCvhAKAa1RtAvbJSZdR7+3G9vYGMkbrG2V18kjE4Nmqmy/M7k0BxumXyVOePH2PYaP7pzn0DPrp7RGDyWlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o0Q1oMdO8gnA/06bXzX0zK/k4hLfD7DzYAhZf0pTzvY=;
 b=pyffcsUVo264/X3pfx9XD9E6AWxATAAamBlupX3NcPt9QQvsBrAg4N3rnGcgLDIbnS0SrZtv+NYuou2QHDqEPvBx7vwhuQr80IAJIVOGn3eQY2iZYQveaDTacqJ3Al5RXYjR+X567NNKpYjOOUhuz8fkcbFa6oX/9E960BnjQjDAzlU5xkzDFHoVb36RXxs+elijxML4hNxjhmzZ14WTEiHK2YWUpFr+LYmBHW4rX2eRvIjJNf4SWBJP2PucgEz7LP4nnUoM2tuosjOJ57fVh9ApmnIhgINQCR7XXXWiLebKhUs37HeTR4+hcKD31OGPivOmP6fIRQYDzCRycOPUXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by PH8PR11MB9606.namprd11.prod.outlook.com (2603:10b6:510:3a0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Thu, 16 Jul
 2026 13:13:29 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%5]) with mapi id 15.21.0223.011; Thu, 16 Jul 2026
 13:13:28 +0000
Date: Thu, 16 Jul 2026 21:13:19 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Christoph Hellwig <hch@lst.de>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Carlos Maiolino <cmaiolino@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>, <linux-xfs@vger.kernel.org>,
	<oliver.sang@intel.com>
Subject: [linus:master] [xfs]  9b64ca202f:
 fxmark.ssd_xfs_DRBH_4_bufferedio.works/sec 24.1% regression
Message-ID: <202607161601.867c143e-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: KUZPR01CA0017.apcprd01.prod.exchangelabs.com
 (2603:1096:d10:26::17) To SJ0PR11MB5815.namprd11.prod.outlook.com
 (2603:10b6:a03:426::9)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|PH8PR11MB9606:EE_
X-MS-Office365-Filtering-Correlation-Id: 7427bb05-e4be-4232-f85c-08dee33c0642
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|3023799007|11063799006|56012099006|6133799003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info: QPXOWZEtt8JCENR6uznejAxuLwjBiC0IZai+6eWpu0HGXHcBCqC234PMKY6fzHwbipWirgHolwhvyAOiUhjEVs1QSlZU+bPvYWfjnZWHvRt3B9mubgfqE+TT/Qsuwrq48jR3Kmh98o4op5YkNK3U3qjTOOoRqjF2NUrp1CPDyhsGLPUD7vDyNHZYuRT1iArzwQ8XrJPTPwJVMhMbFPSNvHp+hINq5LoClUpGzT0nSOSQSPz7tnNq5KszBA3l5erSV7eTRQDZOsibYCg4pryCBMj9FsQGjZSwDJtsPCbA1U8YM97l2JQOLorReiEiPI6DloallnKGAfEgWx18UAwlBJICKMFwqHhqM1m/zr9Ae8foykQdjVQCe/DRKG2vc1lnDv7Yw4uvQDrobOhRj25ORF0o41gHKHuBG8Si89PmkjBxhAD5ehZ+gyD3b1kn81C61A913kidL8s+jdrIqlrRD3/51kDItRCnzVridQSsNZFj6bB4ZkC59HoaTdvrxvt7CLi3QVcrripAw9RHtRJrB3Yttz7t12GB3F2VQmvzfrRe7NGvCWJG+pKTxBIYNxQFfuveq7e5MReL9N+3nZhOPrwSZn6K0sKUaFDnBxr7Dml5TI8AhPRyXB7KoE7v9/y5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(3023799007)(11063799006)(56012099006)(6133799003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?Vfqfftti5vyw7fQ1jbdygobInyJMkTeeWsyPvabS5Yxlb4uwle351nLpWM?=
 =?iso-8859-1?Q?Sf7Lw8eF1dSNzCyLv2Duq3tmHLD8eyKs964yIrTbg4Us5Mp52mZGrPYmDD?=
 =?iso-8859-1?Q?EHZR9nIHk/H2r9Ak5DbXNiMwGIQnEv0DCjSWkUo7b8Lv+sJipUGO6ZNjO6?=
 =?iso-8859-1?Q?N616KKrtiOgUztyxLa8wRJeouDntwi39RHA+IOzJd1OjQXUOw7hNntSX0Y?=
 =?iso-8859-1?Q?wkcUfphCaaXq6Fmm6v6c31oKw55A/Zrcoipq+9rBSnfCz2RZBJrr/NSz0X?=
 =?iso-8859-1?Q?h9u2/YIqtq/+6dJLRCm7eUFCcCTpufZXojgXxj9I4/7MFpjJSqDuUeGOLf?=
 =?iso-8859-1?Q?yTsd33pCULtMt+hqKMBb+PTcIZBRlHod/1o1le973Twn2qjuMI36nPQA8u?=
 =?iso-8859-1?Q?8S5/xXp5mD4T9+qWNhs8Ma1E4APW2RaqODoGIuipoYH0j9x6HB5xSaW81Q?=
 =?iso-8859-1?Q?G6zpfMA3nwD9F9FOPABWOSUwXKUwmjlnrXdyRlT1q2/FQDcgusjJ5oCQCb?=
 =?iso-8859-1?Q?8vLNkVnK+qjDWeeamSthm+rTrBYvOMPOaEP0bX4JfGWF3xr1Rn563b8a4L?=
 =?iso-8859-1?Q?aUpqs/RLE6hYzjH/q1C89e3tzcFLnLcEPKIRbEo3VSzcAgTKX9R/JHCqAw?=
 =?iso-8859-1?Q?P8T8x1plpV+3Z/kvxTNNHu2R6D1IOM0Xtqv82bqxIJAGiVmpYCfFqPbOff?=
 =?iso-8859-1?Q?8VKnkzpIcnUxZbSF0U7fPYT0oLItxiNlKnmxgFVK+3QTngORKEEVlFkGRW?=
 =?iso-8859-1?Q?pYY1suY0k2Qeu8clcDNE+gA5XDU3Yg0hk7fqPpGjycavDKlLCT7hXaYB46?=
 =?iso-8859-1?Q?DOtyoak+25zOtR75Qmeigr9l8+bOjnwZUHrE4bCX59U9h3SRKVLzQD/IfX?=
 =?iso-8859-1?Q?uTIEcO9dTQO51qcjmxbed+CtYtAcSGC4EQwtSbCeMeu7pKNJbRgtZnUcs1?=
 =?iso-8859-1?Q?t1mqzUP1A/fNDHgYwq7VETANvezSO4xAS5vX8YIudghAmbHjDvlhTjjh+K?=
 =?iso-8859-1?Q?CvhoNG3g/6fj1LOFEWbpBwDYsNJtb6veqhpfaI0fiFsZYnUzE/MKmorJfK?=
 =?iso-8859-1?Q?g1qLyw9YWlXthhVNKjsmwc95a3z9hNsKcZjpdE7a1VYR4g49melCxROMeH?=
 =?iso-8859-1?Q?XhWSOciQHHXOQPqPkj3rCaeOa220VdyTu3cLeLuFS5ZomugcRhxNGTP+zp?=
 =?iso-8859-1?Q?IaF930v0h3lsVrMKADyhxxxjREnD/+Jd6hpOQg6UtNvbukH/BhN27mDqNK?=
 =?iso-8859-1?Q?Kl/Aps0qXQ4t+1klhvSFjp6DOjsuf5qT3A5awn4C5x1vjwKx0LgGNGLNWM?=
 =?iso-8859-1?Q?8SVTSSc5Kd1BQCUMCjREeodT3pMrlYzrpAfoP/wiMiARWaeawSC8SO7Ukj?=
 =?iso-8859-1?Q?meGO/TDgLmjKTw1LuH0PoSv3G5OvTExkcXA3uw4+/rRiG+eid1NaG95gnq?=
 =?iso-8859-1?Q?zC3m83AXywr9YwTaQkde29ypjwW7TFOzxBpcT0QIMZueImTwHPH7XuWl9U?=
 =?iso-8859-1?Q?bUoWd5Zx3Q/YNnYQCkEE83Kk3Ut3lHR7us+7J0vX93koZ+Ix1mSgQ/exEV?=
 =?iso-8859-1?Q?vn/RTGHbiY7KlBN/ub/As8/BTicsQMDEaw47YT8zno0l0Pg6OQEltL5dcH?=
 =?iso-8859-1?Q?b3TaiH6J1d65qMxSpHRqpKEL3AHSBsLFTbFT3rZb2XC97KtMVWJGgo3MtB?=
 =?iso-8859-1?Q?QrhiSqn+TX1eSAeCV2/iKp697IRuCQXkE4seHulOgWMn6Lo6zTGtmVuGQn?=
 =?iso-8859-1?Q?4lG59x3GgHlE+JD0Og8deEPAlCDT6ynGKFlbWYHS/YCdoXAmqkzfvEkbm+?=
 =?iso-8859-1?Q?OluwY3dy3Q=3D=3D?=
X-Exchange-RoutingPolicyChecked: ZWztinyZGClzjf1K202JaxnuRVBBxB1UgZxr/SY+GeV2RSPNO+gxdCob9bNUMDEAw018nIjSYVK4JJRdtcMLb2mrlOe/tWAoTkTX4fxTq1GC6kqb1nz3iym/rHhmyR4uvcUKg48BXy93yG2BfKVYXwtNyGlZrre9wN8wCQH7u+UXfvpZ59IifbeCXdcC3YGr5VStwnztQFHfOYVEgFDwkudLLZ2PsWxiThzVZbMO3lOuYAPEgP7dXRSwM2nWwgXC+5FfpTVOeHwv/gEhoObEY0aF2LXDCnYRWoM/KC70evRZpA/Nar9fsFe/eo85eD+mQiG2MQnBvQr6UD+DP/2NoA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 7427bb05-e4be-4232-f85c-08dee33c0642
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5815.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 13:13:28.7065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8pQgjeB/6TuDppbK4IBQ3dPmLDscttRktToJGbTKqYpeHRdQcoqPuWgKBE7bncb10z1SIo4nqVH3kpD1SnWegw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB9606
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed a 24.1% regression of fxmark.ssd_xfs_DRBH_4_bufferedio.works/sec on:


commit: 9b64ca202f364a6bf8e19bdd20953bc2d776c67f ("xfs: store an agbno in struct xfs_imap")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[still regression on linus/master      a635d6748234582ea287c5ffeae28b9b23f91c7e]
[still regression on linux-next/master bee763d5f341b99cf472afeb508d4988f62a6ca1]

testcase: fxmark
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory
parameters:

	disk: 1SSD
	media: ssd
	test: DRBH
	fstype: xfs
	directio: bufferedio
	thread_nr: 4
	cpufreq_governor: performance




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202607161601.867c143e-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260716/202607161601.867c143e-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/directio/disk/fstype/kconfig/media/rootfs/tbox_group/test/testcase/thread_nr:
  gcc-14/performance/bufferedio/1SSD/xfs/x86_64-rhel-9.4/ssd/debian-13-x86_64-20250902.cgz/lkp-icl-2sp8/DRBH/fxmark/4

commit: 
  caffb4252c ("xfs: massage xfs_imap_to_bp into xfs_read_icluster")
  9b64ca202f ("xfs: store an agbno in struct xfs_imap")

caffb4252cf15c5c 9b64ca202f364a6bf8e19bdd209 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
     23.90 ±  3%     -12.6%      20.88 ±  3%  fxmark.ssd_xfs_DRBH_4_bufferedio.user_sec
     12.24 ±  3%     -12.9%      10.67 ±  4%  fxmark.ssd_xfs_DRBH_4_bufferedio.user_util
 3.662e+08 ±  4%     -24.1%   2.78e+08 ±  4%  fxmark.ssd_xfs_DRBH_4_bufferedio.works
   7324905 ±  4%     -24.1%    5559335 ±  4%  fxmark.ssd_xfs_DRBH_4_bufferedio.works/sec
     76773 ±  5%     +13.3%      87019 ± 10%  cpuidle..usage
     10.88 ±  3%     -12.1%       9.56 ±  6%  iostat.cpu.user
     11.27 ±  3%      -1.3        9.96 ±  6%  mpstat.cpu.all.usr%
      2332 ±  2%      +6.5%       2483 ±  6%  vmstat.system.cs
      1.34 ± 49%    +112.1%       2.85 ± 31%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.current_time
      1.89 ± 46%    +763.1%      16.29 ± 43%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.current_time
     66.33 ± 17%     +69.8%     112.67 ± 28%  perf-sched.wait_and_delay.count.perf_trace_sched_switch.preempt_schedule_thunk.filemap_get_read_batch.filemap_get_pages.filemap_read
      1.34 ± 49%    +112.1%       2.85 ± 31%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.current_time
      1.89 ± 46%    +763.1%      16.29 ± 43%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.current_time
      5.58 ±104%      -4.4        1.19 ±223%  perf-profile.calltrace.cycles-pp.pv_native_safe_halt.acpi_safe_halt.acpi_idle_do_entry.acpi_idle_enter.cpuidle_enter_state
      4.45 ±117%      -3.3        1.11 ±223%  perf-profile.calltrace.cycles-pp.lru_gen_del_folio.__page_cache_release.folios_put_refs.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages
      3.26 ±101%      -3.3        0.00        perf-profile.calltrace.cycles-pp.__page_cache_release.folios_put_refs.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_flush_mmu
      4.30 ± 72%      -2.8        1.52 ±223%  perf-profile.calltrace.cycles-pp.mutex_unlock.sw_perf_event_destroy.__free_event.perf_event_release_kernel.perf_release
      4.15 ± 74%      -2.3        1.87 ±145%  perf-profile.calltrace.cycles-pp.tear_down_vmas.exit_mmap.__mmput.exit_mm.do_exit
      4.14 ±103%      -1.6        2.58 ±160%  perf-profile.calltrace.cycles-pp.__dentry_kill.finish_dput.__fput.task_work_run.do_exit
      4.14 ±103%      -1.6        2.58 ±160%  perf-profile.calltrace.cycles-pp.finish_dput.__fput.task_work_run.do_exit.do_group_exit
      3.11 ±101%      -1.1        2.04 ±148%  perf-profile.calltrace.cycles-pp.free_unref_folios.folios_put_refs.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_finish_mmu
      3.26 ±101%      -0.7        2.58 ±160%  perf-profile.calltrace.cycles-pp.kmem_cache_free.__dentry_kill.finish_dput.__fput.task_work_run
      4.45 ±117%      -3.3        1.11 ±223%  perf-profile.children.cycles-pp.lru_gen_del_folio
      4.45 ±117%      -2.6        1.84 ±146%  perf-profile.children.cycles-pp.__page_cache_release
      4.15 ± 74%      -2.3        1.87 ±145%  perf-profile.children.cycles-pp.tear_down_vmas
      4.30 ± 72%      -1.5        2.80 ±142%  perf-profile.children.cycles-pp.mutex_unlock
      4.30 ± 72%      -1.5        2.80 ±142%  perf-profile.self.cycles-pp.mutex_unlock




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

