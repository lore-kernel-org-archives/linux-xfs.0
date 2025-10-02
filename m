Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD64D16132F;
	Thu,  2 Oct 2025 08:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759392713; cv=fail; b=OfN/FuDrBdWOeg3zikicCGgstA6LHSkMG6XvDCrLtUz2DsTeJpxcZRE6BLh4ZmNH4/PMQUba+ygoWoiWOsrQirobVuhM3lhr37jtqLV/W7A0J/QwfdsOs1Ss7seuxe8gxCD5HsQscXyFLoJN2WSRbPh9JH9m2ARqccu3fX/yNzI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759392713; c=relaxed/simple;
	bh=FMQs+7v2EHPEO8jSrJY9kCPbGV27Zwgj0FQp5kDqEzs=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=hQ64HqCq5cnO9POHG6OssEe7RKq3Y9aQGGDbBc9FeAOmzOh+g3RmHdf6ko0DpjEJ89F5tRL2OGQuvE0O5ZVcNnBVjeIXJ5jX/IuUxkkrBlv9uXZSksKBTsyReVaGdRuMONVhvLtzYlGr8c4LYjQ7hfht5hevvz4EAE5BTb/ZdL4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oA/eBmoc; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oA/eBmoc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759392711; x=1790928711;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=FMQs+7v2EHPEO8jSrJY9kCPbGV27Zwgj0FQp5kDqEzs=;
  b=oA/eBmoc4Icah08xktLV0U+CLdbWoHncFnzy1x3Uut9RHKaXyOqxSAOU
   ijl7o7ag44ZqwlMisrRNqipWHr2f75qJ6zdVpsrNJQr5DNNpXxHsVYxdG
   qb8beB5INdIwqNorAJNKNktA0JB4JCFNrLuy4Ln5RBCBFmAP0Snf36MyI
   ap3KHHvSApWXGNPdpjNrExijxuc4fNzJ1Zxsvf7kvObwQHCHhG/5vVTGk
   J7ILzq0fH/9WE69BgmYw6V1hNbMhI1ZjuSFp3/Uivtba09QyVgCCQOVw0
   TpKpa0ZDpVHB3qo/XnQVs5asz6oFaGr3CxH4gt4t5tJ/GxUdV/PjbI6Ql
   w==;
X-CSE-ConnectionGUID: qvrjmjEPRxq9GGFtjEhnXA==
X-CSE-MsgGUID: pr4ZNpNvQPqXYfhzQWcstA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61588900"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61588900"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 01:11:51 -0700
X-CSE-ConnectionGUID: PNq5prXuRQWfgMtVvPzisg==
X-CSE-MsgGUID: txUCDeX+To6OkXkZAQVLLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,309,1751266800"; 
   d="scan'208";a="178598969"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 01:11:52 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 2 Oct 2025 01:11:50 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 2 Oct 2025 01:11:50 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.31) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 2 Oct 2025 01:11:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ESym4kJ9EO2eUsJnkcBjF7gRe8SKOHM9pvOZC3pK+Tib8/TjUJfTYLFupqO8Z7kO13sISjXOWeph0EaXPPO/kV6TRf0byO/GbgmES+K/HWMJKo9vKdYt3PEb2HCr1iy5sxYuC1LPexLzDnflB1w6RezDtzKYfse2KZ4DEmuCLCNICbdtYe2t/LZNlU9n+oAHnkwxZNGVTRj9iuv7q0A5z2n+w3qMiIi0EMeRknxC6MIv9jwMLXhzPhvzvYLbCWQCAvsU+XM39EeaJPO9IQPqkgcK+aJMrW7Q6CebcoSvS4zri+gSL3JzWzN8SYccrbSYZD7mLRA322oQ06hL2jE6oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x3jQx7g4N5OCx9NsUP3VXvEir9lBvzwmB/RuDG7+G2s=;
 b=iFl/KkLSnkaE7e0s1ctvnmWX3K8pYPQ5Ewl+23wBLBFd4Im8lELekGRdTtX8xy3D+w3pIegbeXQ4BiluITO35T7/DJgzX0LTdo37t7tsHMwI2dvlauTgvyMjLmCIfIXYyQztKSIR2CJEheAYIXzeu+RbWV0WXmxc8ksxVY4KhAKBG6YLWn8CtncXqCCYzBNuX7RLtQqEo6h7AXqIPZ9GJ3DvXZrpNmQRxZ0kfC/ATE4seY5IRmoi4x3bwooQFKOPldhPRuxGYftquTGspTg+6TbGv7gEiZHjNrMLHMZ8V1mSdYEk/bMpTlc0AKLIdTkqtSuxqS20b/PUG0oUQAeYNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by CH3PR11MB8708.namprd11.prod.outlook.com (2603:10b6:610:1be::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Thu, 2 Oct
 2025 08:11:38 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9160.017; Thu, 2 Oct 2025
 08:11:38 +0000
Date: Thu, 2 Oct 2025 16:11:29 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Dave Chinner <dchinner@redhat.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Jan Kara <jack@suse.cz>, Christoph Hellwig
	<hch@lst.de>, <linux-xfs@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [linus:master] [xfs]  c91d38b57f:  stress-ng.chown.ops_per_sec 70.2%
 improvement
Message-ID: <202510020917.2ead7cfe-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TPYP295CA0010.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:9::19) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|CH3PR11MB8708:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f148a91-8f73-40cc-0cb1-08de018b4f95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?nWky4pbfyBnrDdVIE0g1+dbfRrktYt4uu1rzxr4sosuYUNXFGLGGhMtnzz?=
 =?iso-8859-1?Q?zhqF36hH2c0oXak8u2E52tGZt4pxY+iXkZcGCv69bwjcCrjS8lPy/RLPt5?=
 =?iso-8859-1?Q?DwhR38D1WnMhMt/E8mam+tb5tTaemDP8HtTkmsqeCuNUUfA9ZyKp0iZG3M?=
 =?iso-8859-1?Q?R7fmh9vhG20l1Ed2Ju/7SIhq+dgPrGK5bc7Ozf+h/ExBdruCbmkKJTru1T?=
 =?iso-8859-1?Q?yZUc4bmbu6NKmPZZZRmEEX3MiYdTvWWgbzLgfuFaPl+6ZdvoAwXRRXAWIu?=
 =?iso-8859-1?Q?ki87Q4xt9+LzDzGOeSxGT4mK5EReu4LVzO+uZKqikRTTz9kz8yOCOhRcjF?=
 =?iso-8859-1?Q?OI/cLW5B4Mqmn9sU/5HGMjrGvUu0ynyQovjC2ETMa5uNFoSZ1pMYOkhqsA?=
 =?iso-8859-1?Q?fDoHW96mdJ9gBMTe2xtaFtRlByXxoyJ9XgvhcoJzKsCn7KHN3jeDXD4DMy?=
 =?iso-8859-1?Q?tDUenOFWmOuZJPV80TzG6YK3A2D5TgrLCb47Z8ZJV3Sj6m3GtCl5qo/yVu?=
 =?iso-8859-1?Q?kJLo6ldqguO94LNMjmG/5dwIKWGjp7yI4MA9WzhNIV4qZ26tYW6xtpTEtI?=
 =?iso-8859-1?Q?Q2fKX4T9gN4LhUfn/AmasFuc4+SzyU0J9gDP/N/LEBOS8xQ8sRGs1CDtHo?=
 =?iso-8859-1?Q?rTKZv7I23kcQWFx81wPIXFaUkpu6Lir42GbeJK12uU46I/pPEiuzZ8zaCY?=
 =?iso-8859-1?Q?5ybfcleDUL2YVKMFpV0CAxTAiFrviDrdvh/dMcuyxoNY86BBOsvlYFktbP?=
 =?iso-8859-1?Q?H6IsvZVxet/V81Ris4DOODfVsjJcaeqLS2J+ZNHI1vvnsYEHgEBjANNzoO?=
 =?iso-8859-1?Q?RpJnILRdRkwPZvWED7zeXxBCdcuv0D2nrs91svKbMYfQdiN0N0knuT/q3w?=
 =?iso-8859-1?Q?CJtR3l9fbIZn4mCMwaHXxC8mQqgOEM182DYma/2ovj4xV+sgss2zyk1aAc?=
 =?iso-8859-1?Q?vnLqi9oSUNemYyBWt8d5T1jqGpCMK91SPl4uporjrQ0Qru3jTl7RRLSNFA?=
 =?iso-8859-1?Q?4Ff4kmDpFZiPwHcsuBnkTCrScvAiC/WE14BRo8WkY76AnGWwIbi+dDOI+W?=
 =?iso-8859-1?Q?UJP7tqiJKVHVkUAJBQtLmOZkq1x4g8yP3qDDinKtCKgMAjVNVvti7Zack3?=
 =?iso-8859-1?Q?Tyf/pkVo0DL1VeFpAQwmlRKZrsPpbLHa3P77eSFYuRG+8cFt8Q7KTU/Yfh?=
 =?iso-8859-1?Q?9h5DdxTfnjCibxlznZtZy3ab6BtB+LcQLf1wgM9eQ00WEP2xrz2G2yJ8UW?=
 =?iso-8859-1?Q?fpnVyDs7cflzoLAn1vqQQH3uGSY2PfKriK3tpP/TyklXezBiXGDTL1U2uD?=
 =?iso-8859-1?Q?a9tyqjHaEnQFWJoND52uIOW2kOm2uKhOU0HvILGzakclZayV0tJ/OKWxk9?=
 =?iso-8859-1?Q?EAbB6Rn3GzwPpMRuUxjRdnSp7tL4RJI0AgRGfbF15lDjdsyoL39ir/fAF/?=
 =?iso-8859-1?Q?wmSQK9Y60JtOzDbjx9ow4E+JSWulMtrilQ3cmJD70ruTAojju+rUG2gBY8?=
 =?iso-8859-1?Q?I=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?FPcSqGYG1m8lG6NtgSF5xNHtVzVTgblkpHCrpfDX56+pIZcDty1H9XdrlU?=
 =?iso-8859-1?Q?bJAb+WWrJrkn05xzDMqyPCYA2bRkgL72XedFTW1Jyc5102RH20PC792Gye?=
 =?iso-8859-1?Q?R7/YxKuVbSlpvzV6s58A0wVp3pBSrBJKEI/U1pgfpOSJwBmUfHRMSgfp0X?=
 =?iso-8859-1?Q?h8o1UOQHES3z6hklMEriuQW1UoQPbe8j8vkM/D2ES13nYfWdEeUN8ggHB5?=
 =?iso-8859-1?Q?C8dlBK2I7by7rix7Q9POLpngD+Q+hWfeAtcbuwyja19Uy77HAt1EVbUU9z?=
 =?iso-8859-1?Q?GSdfUfXdERzaGcN+Zb7mS5f2P+j2hn5SqJ/yIfdptqftHZtrPouhInQoZS?=
 =?iso-8859-1?Q?N6qplg6OobjickMF64A/CaE4MnsXswILIUR5WnIKb7H2fUORnxwwEgsdkX?=
 =?iso-8859-1?Q?T8Qo82lPgZ2D7AB2gXxs5nZHdpZlCoQCv/5czp3UXJ5iYfZCUWUu7LWc4t?=
 =?iso-8859-1?Q?6VeEBP8SXynLzHZkEV9I/EoOZx0urSfNsqZ47vXfBKZutXKoK77O06g1Oy?=
 =?iso-8859-1?Q?07ZOuwAh9fwVjr7kM/GXe62Yv0NRHcDRufuqBzbhO3hV7TpMv1PlOA7/wI?=
 =?iso-8859-1?Q?w37UYdRgAFKQ3dgG9K4MMWVVHsTo1cPu71vczQal0V+Z7ujkQpLqSSK7uZ?=
 =?iso-8859-1?Q?ITuIN8a8hRRtB0Uv+Qj+F+WRTIazObh5F455qQjn5flRq/raxBCcj0UjqB?=
 =?iso-8859-1?Q?HMgjeTlzGe96O2Sk3Ev4/eC6ItlGhQLnO3IKsAjCdxxJgBKMhFQAQptMNN?=
 =?iso-8859-1?Q?Qo+r+K79w0BKLk0aMd6nrsAUwPwCyZOPWnYZ5fTpSztjFSBXlfMkhsO3Y7?=
 =?iso-8859-1?Q?c5JWoMRWU6blhfuPzDm+3sqvuVOGs6DMVoGXZp0Vd5nryS468kR7EeNGEt?=
 =?iso-8859-1?Q?W7++PkreR3se+61hmhpI5fETByo/UFZ1/qXtyTUgiBIf0XcMdLVCb1O3l7?=
 =?iso-8859-1?Q?Tc40Q8DYXDnB4UEf9NxrOj4nDFPaI+S2lh6PUxq40xTL3v9dCczCv5IdQh?=
 =?iso-8859-1?Q?0W5WfVa3O/opZkKKfVtXEiwv1IZF9OZY+k+n2m8YAMRuk8I6fOdlys3704?=
 =?iso-8859-1?Q?B7G07SS5ZqgmwRsypGH0Mvvd/Jt0p2u+hYxunTtmSnwxrcmOUJh7eG5nLF?=
 =?iso-8859-1?Q?I6G2gY0nPow9TbXuzLwk6KpzX7MH6lBXg+qcFSZTpBarfmotDNAbsdTtZ8?=
 =?iso-8859-1?Q?p32BHqu8ikiYYyjlQ4jRXHVp0ei5ORb6RjJqiDXzNQ3skzdDiNqg9S+DGm?=
 =?iso-8859-1?Q?roaTLmyvx5zA3tyVD6aQEEhkL4Wrxi+HYYudRRqWrgPSWz9S+zLTu31MY0?=
 =?iso-8859-1?Q?HS06fM+fEX5zrPFiBDiUs+FG3ba61ceNcrbEQksQ2DgnW+gR0Y9SI4Rybs?=
 =?iso-8859-1?Q?BFGHXOuPa3qg4Xg83dlAN0B0+qzp0/dn7+/4060YQvKY+yG/3FZkOlJJrz?=
 =?iso-8859-1?Q?KDSrWjgtzOw2n7oSS2gWnuIIDOahe4o1NhWgNVeGabprdFtD1+fqawefb4?=
 =?iso-8859-1?Q?D04uqATwCXAAzNIFymqUjb7ClcUAVyuNatpadE0xunP3Rmq2zMBhfZV274?=
 =?iso-8859-1?Q?rHcI6S/I1dqM/73yMpFi+fI6FIujPmR5RrJ7XvFnjXcGd45D1ESY7Fb2MU?=
 =?iso-8859-1?Q?hP/fdqc3BnbZebMhlS5aRDsCKhliSqMF1neM4Bb0QzArOtvvDM4/1Nlw?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f148a91-8f73-40cc-0cb1-08de018b4f95
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2025 08:11:38.1904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7G8DLu+nAQWd85bVS6Z7sGYOZSSLda+mJ1FuPsD+VKgd+LKveidF8cL9wyM56yn7nbpeo0BBKC8OXnFN2isukg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8708
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed a 70.2% improvement of stress-ng.chown.ops_per_sec on:


commit: c91d38b57f2c4784d885c874b2a1234a01361afd ("xfs: rework datasync tracking and execution")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master


testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 192 threads 2 sockets Intel(R) Xeon(R) Platinum 8468V  CPU @ 2.4GHz (Sapphire Rapids) with 384G memory
parameters:

	nr_threads: 100%
	disk: 1SSD
	testtime: 60s
	fs: xfs
	test: chown
	cpufreq_governor: performance



Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20251002/202510020917.2ead7cfe-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/disk/fs/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/1SSD/xfs/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/igk-spr-2sp1/chown/stress-ng/60s

commit: 
  bc7d684fea ("xfs: rearrange code in xfs_inode_item_precommit")
  c91d38b57f ("xfs: rework datasync tracking and execution")

bc7d684fea18cc48 c91d38b57f2c4784d885c874b2a 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
     21446           -15.8%      18048        uptime.idle
 1.152e+10           -29.2%  8.152e+09 ±  2%  cpuidle..time
   8263083 ±  5%     +11.3%    9194591 ±  2%  cpuidle..usage
     98.28           -26.1%      72.66 ±  2%  iostat.cpu.idle
      1.35 ±  9%   +1890.7%      26.82 ±  5%  iostat.cpu.system
     19060 ± 85%    +613.5%     135997 ± 28%  numa-meminfo.node0.Shmem
    297720 ±  7%     +43.6%     427508 ±  8%  numa-meminfo.node1.Shmem
      4765 ± 85%    +613.7%      34012 ± 28%  numa-vmstat.node0.nr_shmem
     74477 ±  7%     +43.6%     106962 ±  8%  numa-vmstat.node1.nr_shmem
   1004889           +25.4%    1260516        meminfo.Active
   1004873           +25.4%    1260499        meminfo.Active(anon)
    119627 ±  2%     +81.8%     217452 ±  2%  meminfo.Mapped
    316668 ±  4%     +77.8%     563129        meminfo.Shmem
     87.17 ± 15%    +151.4%     219.17 ±  7%  perf-c2c.DRAM.local
      1506 ±  9%    +105.9%       3102 ±  2%  perf-c2c.DRAM.remote
      1846 ±  8%     +74.6%       3225 ±  3%  perf-c2c.HITM.local
    967.83 ± 10%    +111.5%       2046 ±  3%  perf-c2c.HITM.remote
      2814 ±  3%     +87.3%       5271 ±  2%  perf-c2c.HITM.total
      6.91 ±  6%     -40.1%       4.14        perf-sched.total_wait_and_delay.average.ms
    428372 ±  5%     +71.9%     736472        perf-sched.total_wait_and_delay.count.ms
      6.90 ±  6%     -40.2%       4.13        perf-sched.total_wait_time.average.ms
      6.91 ±  6%     -40.1%       4.14        perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
    428372 ±  5%     +71.9%     736472        perf-sched.wait_and_delay.count.[unknown].[unknown].[unknown].[unknown].[unknown]
      6.90 ±  6%     -40.2%       4.13        perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
    702197 ±  6%     +70.2%    1195115        stress-ng.chown.ops
     11705 ±  6%     +70.2%      19923        stress-ng.chown.ops_per_sec
    181.50 ± 22%   +1974.8%       3765 ±  4%  stress-ng.time.involuntary_context_switches
    279.00 ±  4%   +1929.8%       5663 ±  5%  stress-ng.time.percent_of_cpu_this_job_got
    166.63 ±  4%   +1941.2%       3401 ±  5%  stress-ng.time.system_time
   5209159 ±  7%     +80.3%    9389854        stress-ng.time.voluntary_context_switches
     98.26           -26.4       71.83 ±  2%  mpstat.cpu.all.idle%
      0.13 ±  5%      +0.3        0.43 ±  5%  mpstat.cpu.all.irq%
      0.07 ± 11%      +0.0        0.11        mpstat.cpu.all.soft%
      1.15 ± 11%     +26.0       27.11 ±  6%  mpstat.cpu.all.sys%
      0.38 ±  5%      +0.1        0.53 ±  2%  mpstat.cpu.all.usr%
      1.00         +1533.3%      16.33 ± 86%  mpstat.max_utilization.seconds
      3.40 ±  6%    +950.6%      35.70 ±  6%  mpstat.max_utilization_pct
     77.00         +1065.8%     897.67 ±  4%  turbostat.Avg_MHz
      2.56 ±  3%     +28.4       30.96 ±  4%  turbostat.Busy%
      3008            -3.6%       2900        turbostat.Bzy_MHz
      0.15 ± 25%      +2.2        2.32 ±  2%  turbostat.C1%
     11.82 ±  8%      -4.1        7.67        turbostat.C1E%
     85.55           -26.4       59.13 ±  2%  turbostat.C6%
     77.00 ±  6%     -40.5%      45.80 ±  4%  turbostat.CPU%c1
     17.96 ± 28%     -88.6%       2.05 ±  8%  turbostat.CPU%c6
      0.53 ±  2%     -43.3%       0.30        turbostat.IPC
   4796749 ±  5%    +186.9%   13763385 ±  2%  turbostat.IRQ
    268338 ±  2%    +636.9%    1977304 ±  5%  turbostat.NMI
      0.27 ± 13%     -30.6%       0.18 ± 18%  turbostat.Pkg%pc6
     50.33            +8.6%      54.67        turbostat.PkgTmp
    399.48           +17.5%     469.39        turbostat.PkgWatt
      9.47            +3.3%       9.79        turbostat.RAMWatt
    251227           +25.5%     315208        proc-vmstat.nr_active_anon
    172983            +1.4%     175383        proc-vmstat.nr_anon_pages
   1003874            +6.1%    1065584        proc-vmstat.nr_file_pages
     29851           +81.4%      54161 ±  3%  proc-vmstat.nr_mapped
     79196 ±  4%     +77.9%     140909        proc-vmstat.nr_shmem
    119037            +1.8%     121217        proc-vmstat.nr_slab_unreclaimable
    251227           +25.5%     315208        proc-vmstat.nr_zone_active_anon
    878478           +13.7%     998673        proc-vmstat.numa_hit
    679877           +17.7%     800107        proc-vmstat.numa_local
     10806 ±116%    +199.2%      32333 ± 31%  proc-vmstat.numa_pages_migrated
    932088           +13.4%    1057269        proc-vmstat.pgalloc_normal
    498583 ±  2%      +6.7%     532123 ±  2%  proc-vmstat.pgfault
    797828            +3.6%     826753        proc-vmstat.pgfree
     10806 ±116%    +199.2%      32333 ± 31%  proc-vmstat.pgmigrate_success
   2667340 ±  6%     -13.3%    2311308 ±  2%  proc-vmstat.pgpgout
     27316 ±  5%     +19.9%      32752 ± 11%  proc-vmstat.pgreuse
      3.06 ± 13%     -71.8%       0.86 ±  4%  perf-stat.i.MPKI
 1.695e+09          +535.8%  1.078e+10 ±  3%  perf-stat.i.branch-instructions
      2.07 ±  3%      -1.5        0.58 ±  3%  perf-stat.i.branch-miss-rate%
  45649257 ±  2%     +32.1%   60312544        perf-stat.i.branch-misses
  20782898 ± 13%    +118.8%   45464342        perf-stat.i.cache-misses
  74939994 ±  3%    +196.9%  2.225e+08        perf-stat.i.cache-references
    211956 ±  7%     +63.6%     346733        perf-stat.i.context-switches
      2.09 ±  2%     +55.1%       3.24        perf-stat.i.cpi
 1.487e+10 ±  2%   +1070.8%  1.741e+11 ±  4%  perf-stat.i.cpu-cycles
    633.37 ± 12%    +397.0%       3147 ±  8%  perf-stat.i.cpu-migrations
    756.33 ± 16%    +409.7%       3855 ±  5%  perf-stat.i.cycles-between-cache-misses
 8.097e+09          +561.3%  5.354e+10 ±  3%  perf-stat.i.instructions
      0.53 ±  3%     -40.3%       0.31        perf-stat.i.ipc
      0.99 ± 12%     +84.4%       1.83        perf-stat.i.metric.K/sec
      6687 ±  3%      +9.2%       7305 ±  3%  perf-stat.i.minor-faults
      6687 ±  3%      +9.2%       7305 ±  3%  perf-stat.i.page-faults
      2.57 ± 14%     -66.9%       0.85 ±  4%  perf-stat.overall.MPKI
      2.68 ±  2%      -2.1        0.56 ±  3%  perf-stat.overall.branch-miss-rate%
      1.84 ±  3%     +76.9%       3.25        perf-stat.overall.cpi
    730.19 ± 14%    +425.1%       3833 ±  5%  perf-stat.overall.cycles-between-cache-misses
      0.54 ±  3%     -43.5%       0.31        perf-stat.overall.ipc
 1.668e+09          +535.6%   1.06e+10 ±  3%  perf-stat.ps.branch-instructions
  44770981 ±  2%     +31.7%   58956996        perf-stat.ps.branch-misses
  20427788 ± 13%    +118.8%   44692670        perf-stat.ps.cache-misses
  73770990 ±  3%    +196.6%  2.188e+08        perf-stat.ps.cache-references
    208371 ±  7%     +63.5%     340716        perf-stat.ps.context-switches
 1.463e+10 ±  2%   +1070.4%  1.713e+11 ±  4%  perf-stat.ps.cpu-cycles
    623.35 ± 12%    +396.3%       3093 ±  8%  perf-stat.ps.cpu-migrations
 7.964e+09          +561.1%  5.265e+10 ±  3%  perf-stat.ps.instructions
      6538 ±  3%      +8.3%       7081 ±  3%  perf-stat.ps.minor-faults
      6538 ±  3%      +8.3%       7081 ±  3%  perf-stat.ps.page-faults
 4.839e+11          +561.9%  3.203e+12 ±  4%  perf-stat.total.instructions
      5485 ± 39%   +9425.4%     522524 ±  9%  sched_debug.cfs_rq:/.avg_vruntime.avg
     70276 ± 23%   +1083.8%     831952 ±  3%  sched_debug.cfs_rq:/.avg_vruntime.max
    613.05 ± 40%  +15770.4%      97293 ± 20%  sched_debug.cfs_rq:/.avg_vruntime.min
      7853 ± 18%   +1329.3%     112241 ± 10%  sched_debug.cfs_rq:/.avg_vruntime.stddev
      0.05 ± 21%    +283.3%       0.21 ± 12%  sched_debug.cfs_rq:/.h_nr_queued.avg
      1.00           +66.7%       1.67 ± 14%  sched_debug.cfs_rq:/.h_nr_queued.max
      0.22 ± 10%     +80.1%       0.40 ±  5%  sched_debug.cfs_rq:/.h_nr_queued.stddev
      0.05 ± 21%    +250.0%       0.19 ± 12%  sched_debug.cfs_rq:/.h_nr_runnable.avg
      0.22 ± 10%     +60.3%       0.36 ±  5%  sched_debug.cfs_rq:/.h_nr_runnable.stddev
      0.00        +1.9e+12%      19199 ± 38%  sched_debug.cfs_rq:/.left_deadline.avg
      0.00          +6e+13%     598730 ± 12%  sched_debug.cfs_rq:/.left_deadline.max
      0.00        +1.9e+12%      19199 ± 38%  sched_debug.cfs_rq:/.left_vruntime.avg
      0.00          +6e+13%     598716 ± 12%  sched_debug.cfs_rq:/.left_vruntime.max
     41172 ±215%   +4030.9%    1700764 ± 36%  sched_debug.cfs_rq:/.load.avg
   7612936 ±222%    +499.5%   45642610        sched_debug.cfs_rq:/.load.max
    551304 ±220%   +1439.7%    8488365 ± 16%  sched_debug.cfs_rq:/.load.stddev
     40.23 ± 28%   +3177.8%       1318 ±  7%  sched_debug.cfs_rq:/.load_avg.avg
    847.08 ± 30%    +519.5%       5248 ±  9%  sched_debug.cfs_rq:/.load_avg.max
    140.26 ± 32%    +812.7%       1280 ±  4%  sched_debug.cfs_rq:/.load_avg.stddev
      5485 ± 39%   +9425.4%     522524 ±  9%  sched_debug.cfs_rq:/.min_vruntime.avg
     70276 ± 23%   +1083.8%     831952 ±  3%  sched_debug.cfs_rq:/.min_vruntime.max
    613.05 ± 40%  +15770.4%      97293 ± 20%  sched_debug.cfs_rq:/.min_vruntime.min
      7853 ± 18%   +1329.3%     112241 ± 10%  sched_debug.cfs_rq:/.min_vruntime.stddev
      0.05 ± 21%    +284.1%       0.21 ± 12%  sched_debug.cfs_rq:/.nr_queued.avg
      1.00           +66.7%       1.67 ± 14%  sched_debug.cfs_rq:/.nr_queued.max
      0.22 ± 10%     +80.5%       0.40 ±  4%  sched_debug.cfs_rq:/.nr_queued.stddev
      0.00        +1.9e+12%      19199 ± 38%  sched_debug.cfs_rq:/.right_vruntime.avg
      0.00          +6e+13%     598716 ± 12%  sched_debug.cfs_rq:/.right_vruntime.max
    142.69 ± 23%     +60.8%     229.41 ±  5%  sched_debug.cfs_rq:/.runnable_avg.avg
    142.61 ± 23%     +60.4%     228.74 ±  5%  sched_debug.cfs_rq:/.util_avg.avg
     12.83 ± 25%    +324.8%      54.52 ± 19%  sched_debug.cfs_rq:/.util_est.avg
     83.56 ± 17%     +46.0%     122.02 ±  8%  sched_debug.cfs_rq:/.util_est.stddev
   1202994 ± 10%     -16.1%    1009100 ±  3%  sched_debug.cpu.avg_idle.avg
      1139 ± 12%     +20.7%       1375        sched_debug.cpu.clock_task.stddev
    342.10 ± 29%    +413.8%       1757 ± 13%  sched_debug.cpu.curr->pid.avg
      8154 ± 11%     +16.4%       9490        sched_debug.cpu.curr->pid.max
      1530 ± 14%    +104.1%       3124 ±  5%  sched_debug.cpu.curr->pid.stddev
      0.05 ± 29%    +306.0%       0.20 ± 15%  sched_debug.cpu.nr_running.avg
      1.00           +66.7%       1.67 ± 14%  sched_debug.cpu.nr_running.max
      0.21 ± 14%     +86.5%       0.40 ±  6%  sched_debug.cpu.nr_running.stddev
     11939 ±125%    +364.2%      55424        sched_debug.cpu.nr_switches.avg
    296.42 ± 64%  +11974.7%      35791 ± 12%  sched_debug.cpu.nr_switches.min
     29.50 ± 12%     +66.9%      49.25 ± 11%  sched_debug.cpu.nr_uninterruptible.max
    -20.75          +385.1%    -100.67        sched_debug.cpu.nr_uninterruptible.min
      5.33 ±  8%    +102.5%      10.80 ±  9%  sched_debug.cpu.nr_uninterruptible.stddev




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

