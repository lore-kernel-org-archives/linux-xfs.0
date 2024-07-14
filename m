Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD672132120
	for <linux-xfs@vger.kernel.org>; Sun, 14 Jul 2024 13:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720964938; cv=fail; b=OlopoLAc9z3+Gym1wPjDtFmB85KyplDZmcx11xQYMguS6mFKqGAYAwr/8yl5jccLpmqvcghly1JXyHe+RU6hv0cuB5Y7D5MAEHT96eYEZ5pUv5QOzAIXtOy0Qju0OACczIQhEbPP74EFhvhJ13NWpHwzMBY4y5XpPRnsmYRKrB4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720964938; c=relaxed/simple;
	bh=S8hkDz4sNbmcRQpssXZTme4b9SeLYeg7z3RtqpUpWRc=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=Gk5ox9k3yOzFohLLkiHQl72IzUI7xezQS9tgb9Kve8Z8J82o/NBsfv9kr9hf7Db39h83cln9JlbnBzC/ahzz7SLGjYTslXtgaKyeO3dQ79eSuX3AsV6Chw5cQS1i7CJt8hT7TYsFCQYAlvIKpHxGX9lOkb7O+XUt5olPwMvbfqk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H3SrR563; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H3SrR563"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720964937; x=1752500937;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=S8hkDz4sNbmcRQpssXZTme4b9SeLYeg7z3RtqpUpWRc=;
  b=H3SrR563J8GvZ1Z/4g5vLXoR43aw3otX0QACvdTgz0zRQ+Nfz7eUZ+E6
   v4+yM0/kCjf83u3/v3/xM9JVRC2HhCgt+3xU0FUzjGQS/Sz+mIkDMc6/t
   P+WO+J/81+Ls7pIUIiiiy2LILHffavWrThKmkdn23p50UnwewjuQY9/Uq
   OwB1wDtoMdONzWKMnaq8iltcsEHEBypG7nBWimeqRuudzPlAT1S+U+0/K
   msCH07B7jIuu5ugaPfZcSLEN35ToRPXx1eM2huUyK0HVEuBtbLuJ1yIRV
   0+tlNr04VjAwFH5r/YJm92o/+932s2RiESMuKmf2N/nPf6/RzovLo+40F
   g==;
X-CSE-ConnectionGUID: U7ckWfaJRrKqDzTXo+FXHg==
X-CSE-MsgGUID: 4dGi7HUESvWhdRUCs+DPTw==
X-IronPort-AV: E=McAfee;i="6700,10204,11133"; a="43760631"
X-IronPort-AV: E=Sophos;i="6.09,208,1716274800"; 
   d="scan'208";a="43760631"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2024 06:48:56 -0700
X-CSE-ConnectionGUID: vz36/byQRdu1wOPoJhhCwg==
X-CSE-MsgGUID: YNG4l/rCTNicQqwzy/Im7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,208,1716274800"; 
   d="scan'208";a="50001834"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Jul 2024 06:48:56 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 14 Jul 2024 06:48:54 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 14 Jul 2024 06:48:54 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 14 Jul 2024 06:48:54 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 14 Jul 2024 06:48:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FiHRbXUpNIDj8fKJFdJmsLacommQDgz3gIVpokAcK9fnSHdSGnZ9MyoGUwmyeY3mUT1bN5i9aFJRNzBvKKrJuZX3Ivv3U/CJ2tpFG/GI6TNKhzoS5OChoI4NNhI4t7r/OdcjEY3uG9lkQua7EfxvJpB4mKq8Kc2L4XNcIpbTSYolDN+qjirrF3xO+cCu+WcpiWdkNMoXAgjqLHeqTwGNvHz81FMaOJSCKwniohDrSj1ZF85H5SiXW3d9u8YCPskP3t0p71bVowZ4bYPbSImnx+aGsqEsNc0ntNAkgbXjeb3kQ6c2baQuG3BCdBCzvfobtHe9QpmILNWxiDi10uUr8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=72cu3FLUrIOMzZr/pJ28bozP9OitIyZoj9/gEn9q3Qo=;
 b=RXzgJD7+rDyoXL/wAMYP2By5CP1SbzzVWWSpeJYkCzuWc3qnIAJKh49lLRBtBM8xtOjEi/bJH8d0eVoS9v4AhjlA5WPYhWNyjSTjJLYwIShT8JChrbMefYm7jezaRqFMCqbFEtZ7aqBA90vBbniBwgHrtty3GVrs3XkOyTL1EqdAW1ARLnavJ2Rqw93DqkMozEV5w0sY+SfY/mrkCg9WQnVhvO0K6wJng5nCnFaL0PTBW2qm51ZE9Z7bHDv+f3FkpkoPTdvuN4Pujgy25DCb5K0x07bM1JHjM311HX/wraxNzdgWL02kFEkq+eGagHyxK3DOTDnvAN/sQ0nakHbinA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by BL3PR11MB6338.namprd11.prod.outlook.com (2603:10b6:208:3b2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.23; Sun, 14 Jul
 2024 13:48:52 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.7762.027; Sun, 14 Jul 2024
 13:48:52 +0000
Date: Sun, 14 Jul 2024 21:48:41 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Dave Chinner <dchinner@redhat.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Linux Memory Management List
	<linux-mm@kvack.org>, Chandan Babu R <chandanbabu@kernel.org>, "Darrick J.
 Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
	<linux-xfs@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [xfs]  c1220522ef: xfstests.xfs.011.fail
Message-ID: <202407142151.a0d44fbb-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SI2PR01CA0015.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::15) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|BL3PR11MB6338:EE_
X-MS-Office365-Filtering-Correlation-Id: 814f9663-940e-44ff-faca-08dca40bb237
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?01qdKCkhoSb5fJ++ih75wJJ3I2EdfdEvCzjUERdJcFQ9WoSQHm85KzNwKYUk?=
 =?us-ascii?Q?viXlcuUwVWNZVYRB4WmpQBcVlJyTE2CfX3BPYbZYeHf8ezRadioyK5tAf+88?=
 =?us-ascii?Q?p7UCI25OlJFffY2n4ek0GVM8ZIy3DVZlgFXcZYzxuGhBNORxXusgxdRcUJbv?=
 =?us-ascii?Q?LawVKcEW0fbYlR07OKM6lpYhylAYoG7BgTO1kNCMK7K/L40v9/iMdgbCvZT+?=
 =?us-ascii?Q?08JFKiBmXd3MjjMMLM/2qJDDxbmJCZLVqU18EKSAm+phnBhiiPWvT8+oVw9f?=
 =?us-ascii?Q?mNgM3C9cSaBiTlL215z73mN35pkiueafVvZ7NMu4vAO+WOjJqRcEAZnQBR5Z?=
 =?us-ascii?Q?miXFsmP866NPNv+tUsL61VFTPFz+OEb+i1hgp8yAWoVaF+D8P9fQaE1IHPQ+?=
 =?us-ascii?Q?8tNhkShyIS4C+oCiEJFPRNrLx4Y/pvFuMVmAda+6ydyMnzBW60DQuS7nhpO7?=
 =?us-ascii?Q?zGI14g8bOyFSO890dNW3v/ozs198MN5X3b+v9gPRIYptZ+pqiLajeDEuQqPq?=
 =?us-ascii?Q?xJkgPCrWhpAWPJWEjfFozw/tGczfWQTLvmr39QLOXmdfRhML84ZYroTxHRnu?=
 =?us-ascii?Q?bUI44wO5Bls6s81FEEeA0rA3Xcg255oHEdQMFbiQXAqyAONN41nZREhxkH0I?=
 =?us-ascii?Q?3tVPREvN+mV+qMcdvADi5UIVUA4LGdIzm7VPX2Hw8EAP+rvom2+wZ9TpcPUm?=
 =?us-ascii?Q?dMQLwMCq/t3FazOVvq/hQvBAh6J32/4O7uGY8CLegMxAwtsOYzydx7fPB+jK?=
 =?us-ascii?Q?1yigN1I45fUBxsxr5DwJ1+QMu6ZNwnKwDKl9RKzK8agn+MzeXCPM5iARUqkv?=
 =?us-ascii?Q?ZYdvXBKzPGWz4wS9P8s++fKVpX0KNvXV+fBxOdYdHQz3HBU0vT0VM5skE0Gg?=
 =?us-ascii?Q?Tj778piDUzMDUD3RcaxSvGijKAjtqqYHQ0f8It1PCCE8SSOD13r0NUzPLOvs?=
 =?us-ascii?Q?Y70/dnboArZ5j/hscZmKmyMZFgI9gDqYhu0NU5D9Lq/diu9pn1GKq15+6Mfj?=
 =?us-ascii?Q?gnYByELVmJSCxNqHszOgQmbUGL2IIOSZbWym9QqP/5sg1Bl7tX8vybXh2xFp?=
 =?us-ascii?Q?PaDW4vdvCOAYYJBsSZvyBm5ncqIBR3L/YZi0k6e63HCieNlz0SjuzZVAwOxr?=
 =?us-ascii?Q?TM5QhxU3iXTwUUuZrrxTJZ/Y/VN6iGV0luIpDPjibKJPNTjlPGbPzvIMheLz?=
 =?us-ascii?Q?4oJ5LxxQ0NckiWgSC0gxVayefxj7cz0/naqpV8slhSdMbXlCuVT0bXIyzmc0?=
 =?us-ascii?Q?i/vZpt89TCONZbgDyIB2Snm3Iw/uLRFO8DYDIh5XA+cVNloo04vjrHSz2KNi?=
 =?us-ascii?Q?oC8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HTqJ3P3C5sYnO8n6bKuiXo1XoG2J+RbVNArzsjuXfs/jPftAIuVODYNPNrbd?=
 =?us-ascii?Q?gYFRpY4xeqixJl7uDEVa+/8MxkcVbnZOC+LeBzUp9EFdF5D34MjKubrthslA?=
 =?us-ascii?Q?OGcr5V0qssh5Yti5KfMQkDd71OGrSEd6ZbkkY9BAgqO9V80kZtj9sZNALW63?=
 =?us-ascii?Q?3oemmhln9tXMcX1m4tbta7PGD0p8GngtiQ0M5i8mwcd3FisAUHTbdAmb7u5E?=
 =?us-ascii?Q?JvhWNG2xT4iyLntGWlXTsx3+o8XP03HjrL11xn2850WjFNRNuNG7iL3qn6QJ?=
 =?us-ascii?Q?qnl1Cb0QF2uZ2haVmncBaKF6ZKl516XIoywZ6nb8VlzXJKsqrq+HQbQdjrU8?=
 =?us-ascii?Q?1Xjf2uf/RiI+zQbd9STJ2q4JUXVzIYpcfkLyv+AQKIQy/RLA4XRxgd9mhLje?=
 =?us-ascii?Q?7QdvOEKKZpLVndZpjUnEc5iLpc8tLtV+Hi0QICNOrCZcRdNb9C5jLnwPhaV2?=
 =?us-ascii?Q?NLWKgKqBkQ0sYYS4sB2PG0GtxLp2A+dlcDVBxUJpmO/IfhAZX8gpPagjXNpS?=
 =?us-ascii?Q?SAaJMNFqycXv2xmIOLKuQKrn077B5tNu3VV805cSaZ7tBPa9PoQLpqZS3Dym?=
 =?us-ascii?Q?cGm8oMda4MKQSVRym3+nOz8pxzl5kTkUkIqVqP4TrC/WbaifEgfj5m9I+Xx0?=
 =?us-ascii?Q?bUen5r83aioOdMI6WIKYODurC4xyvORFjAIRXIOhf7SW/AnFmluT4fQ3cHbs?=
 =?us-ascii?Q?LmXwXkWRCfdlbXTIgNF2VRhssF8anu7tMCH+ZcoGYKW8gU3+NXQ5jR6jr2Zl?=
 =?us-ascii?Q?+MteDnXEKft3DmBj/zX9OtAImvdAFiZumfjCPMzzTKDz0pme831r/4vLAQVZ?=
 =?us-ascii?Q?JKSPJxmjUBSP2fG6nyJ3TVNTBEXnnr9w+WruvlDrFGGHAFWmfO1ehwpp+QZO?=
 =?us-ascii?Q?V8w/UG7ox1WrPfCHgvWpRnXkSBd32WlaP+FpGjIj2RxOivtP/eqBPh61K9T1?=
 =?us-ascii?Q?rXNbi7fdz4s7TRf5XMvJ//sgXpFZJnwbfOnjcymz9Pzv8bJdHfG21HbCCogp?=
 =?us-ascii?Q?jUhQGeR1r00tzBSwp8oOv1quzvzyY0DD4tL9lKpSIhAdOWC0lB4BgnMOsFKH?=
 =?us-ascii?Q?e47wYcA86PnDYk/4EKmF9XtXwxYn1PEbl01Bkde4vCk4Yd0dvD1pLVCmWV+u?=
 =?us-ascii?Q?Jd7sIotDeLLmsMRt3sEYyHGlVjG8FfeDYyMWJ5yR15wX6t/ht0o4qIvvd590?=
 =?us-ascii?Q?51icG8SEzrZbffdAb+jNlP8tSNhkQOaaaTCfpygVAzuaKfAuQ+3c8sjwAhRI?=
 =?us-ascii?Q?xfWFct5VBmFZzqGNXlrYLZEE86BYbMl4A/GbDfNX4fUTXnaZP5do1poBUq7y?=
 =?us-ascii?Q?G4ORHjDlMcIRUvu6hvWej5FQ1o9WgYsaM8rWBauhHiqoYELqT0KNyP6RyjPC?=
 =?us-ascii?Q?ysmixLna42c3m/Nfyfq1T3oCQx2rugkYULoTdmeaHwS6XbPpcQH1zC8IxuTv?=
 =?us-ascii?Q?UQ/BgLwhp5EysHjz4EN7ia3Wo/CE+Owv/DU3itdw0ivdIBIcOy4lTt2BZ1R4?=
 =?us-ascii?Q?oi5WHSH6u7SDF2FI7Y2NammQHoKZ7TFwvXV4PZ0xL8dLa33MQIqJxLTnaWkh?=
 =?us-ascii?Q?6N89O3lBPGa0bXiibg1jbB/TLEB5F7HH2OVepym3FnbgmLB7NCYXhnPeg+Mv?=
 =?us-ascii?Q?pQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 814f9663-940e-44ff-faca-08dca40bb237
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2024 13:48:52.2163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZxqsUK7pYlQ+PetzUYG1L0G9JvPUe+OmGCz12e/iCD32VsVxnG7My8XYPvUK4TpXLlaJWndSa9ZOJqy6a6hEig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6338
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "xfstests.xfs.011.fail" on:

commit: c1220522ef405a9ebf19447330c9e9de5dfc649c ("xfs: grant heads track byte counts, not LSNs")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[test failed on linux-next/master 3fe121b622825ff8cc995a1e6b026181c48188db]

in testcase: xfstests
version: xfstests-x86_64-83598d2f-1_20240701
with following parameters:

	disk: 4HDD
	fs: xfs
	test: xfs-011



compiler: gcc-13
test machine: 4 threads Intel(R) Xeon(R) CPU E3-1225 v5 @ 3.30GHz (Skylake) with 16G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202407142151.a0d44fbb-oliver.sang@intel.com

2024-07-13 12:55:29 export TEST_DIR=/fs/sda1
2024-07-13 12:55:29 export TEST_DEV=/dev/sda1
2024-07-13 12:55:29 export FSTYP=xfs
2024-07-13 12:55:29 export SCRATCH_MNT=/fs/scratch
2024-07-13 12:55:29 mkdir /fs/scratch -p
2024-07-13 12:55:29 export SCRATCH_DEV=/dev/sda4
2024-07-13 12:55:29 export SCRATCH_LOGDEV=/dev/sda2
2024-07-13 12:55:29 export SCRATCH_XFS_LIST_METADATA_FIELDS=u3.sfdir3.hdr.parent.i4
2024-07-13 12:55:29 export SCRATCH_XFS_LIST_FUZZ_VERBS=random
2024-07-13 12:55:29 echo xfs/011
2024-07-13 12:55:29 ./check xfs/011
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 lkp-skl-d06 6.10.0-rc6-00081-gc1220522ef40 #1 SMP PREEMPT_DYNAMIC Sat Jul 13 18:40:03 CST 2024
MKFS_OPTIONS  -- -f /dev/sda4
MOUNT_OPTIONS -- /dev/sda4 /fs/scratch

xfs/011       - output mismatch (see /lkp/benchmarks/xfstests/results//xfs/011.out.bad)
    --- tests/xfs/011.out	2024-07-01 17:00:26.000000000 +0000
    +++ /lkp/benchmarks/xfstests/results//xfs/011.out.bad	2024-07-13 12:56:05.015411786 +0000
    @@ -1,2 +1,50 @@
     QA output created by 011
     Silence is golden.
    +cat: /sys/fs/xfs/sda4/log/reserve_grant_head: No such file or directory
    +cat: /sys/fs/xfs/sda4/log/reserve_grant_head: No such file or directory
    +/lkp/benchmarks/xfstests/tests/xfs/011: line 49: [: !=: unary operator expected
    +/lkp/benchmarks/xfstests/tests/xfs/011: line 50: [: !=: unary operator expected
    +cat: /sys/fs/xfs/sda4/log/write_grant_head: No such file or directory
    ...
    (Run 'diff -u /lkp/benchmarks/xfstests/tests/xfs/011.out /lkp/benchmarks/xfstests/results//xfs/011.out.bad'  to see the entire diff)
Ran: xfs/011
Failures: xfs/011
Failed 1 of 1 tests




The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240714/202407142151.a0d44fbb-oliver.sang@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

