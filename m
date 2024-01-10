Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838AD4A988
	for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2024 14:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FmcVRKaI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704895755; x=1736431755;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=Q6Mra+sOxIYqGc9QhQlyU9gZ1hBF4U6/7AibJdxe+l8=;
  b=FmcVRKaI1mNySeK/ELY8Jf+cNCgpBG+Ef6ztTwQCv3oBC6gJUPETMGME
   8RMvUj3aZw0ySJDLpaqc6tBHHq0216GFprDP3s1Vre97gO1F1Z0GKhwMR
   CgTrSiVj3rm+pLtAkwNPs9W2PZIbyBhSNMeG3XGo2Zta6tc1KSuKkGXSs
   UoTz8yrCM4oT1L3YPOkOCTgLurM0KjXAuRjjzXdM6a2JhxZ++FFmkFV24
   uRFUJuWhpRXHVERYPytd6m6wi2qtTr2Kl36Rpysc6o0CqVhHWseJZRJLy
   meuR6ecQJ6s6BZvISNOca1ApaHQ7az9v/nczJcCyQbwEZQG0MnUoF7B9Y
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10948"; a="398220866"
X-IronPort-AV: E=Sophos;i="6.04,184,1695711600"; 
   d="scan'208";a="398220866"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2024 06:09:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,184,1695711600"; 
   d="scan'208";a="30628556"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Jan 2024 06:09:09 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 10 Jan 2024 06:09:09 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 10 Jan 2024 06:09:09 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 10 Jan 2024 06:09:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=flm/W/Nl97IZVO/Hx7ZhIWEiUcvKlUoaveVLVcB6c3CLKzKinnWHWX9LHl4TU5OO/e/JiXkJl3H3YBB3R2kxKEBT7qxo4YAdpzpNNW1GuWjtbzs1rH0M8ntK/VnJsxUeoYTLp6FwdIaTLwck0FrizXbGxjn8cULEQ7q0I5WuO56r+yhLzJI5CgLjtOMb5XXrZKTm5itmV5kw700BoTVMX2GNVCpKAzCV3gX9ukDoEjkjYz5QV9SkkGdDOuH1Eqcfb51mFdAQVkLvKMBi5RnasjLTxS8O5l6DXBSviI8m6uTA+ysHf7InYAt5SgAnupxvW0UL9tamCFccwRIz8WQu4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9VGOaO4r3iuYC3LGnZImPsKrM/nY8skvO/EQBFhI3TE=;
 b=ES/z6V0TXyBOVhYJcfkW8EMZFjeSqb/tGfay1yn6jv0cIi2/pz5LFTNFcCDrlqyFEdsKAlOAl1pBQW4UH15DIujwhqMUPWsy6j2vbkaXxZpU6kqnt++HxeB9xgn59e5rADc02+q6CGicAhC2Ex9g4n1vdZnA0DQSOmdnIP0S/WEz5yBREqp0irRFNR3S2SNOSh9FZUTusgg8pu+GwxCtvaUcpZ/JBx98q5p2uR/RUvlNXMqMScyJl32C7ewj4WQr7CiLtjLipkldQL/KGBIqbNeGiPgSeK5dZkVQOiHMbOZMYRRvyA2dUBYyr2mo0Smi+Xv/AAOgbLKkhOCByrV7eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by MN0PR11MB6279.namprd11.prod.outlook.com (2603:10b6:208:3c1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.17; Wed, 10 Jan
 2024 14:09:06 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::1236:9a2e:5acd:a7f]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::1236:9a2e:5acd:a7f%3]) with mapi id 15.20.7159.020; Wed, 10 Jan 2024
 14:09:06 +0000
Date: Wed, 10 Jan 2024 22:08:57 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Jian Wen <wenjianhn@gmail.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Dave Chinner
	<david@fromorbit.com>, Jian Wen <wenjian1@xiaomi.com>,
	<linux-xfs@vger.kernel.org>, Jian Wen <wenjianhn@gmail.com>,
	<djwong@kernel.org>, <hch@lst.de>, <dchinner@redhat.com>,
	<oliver.sang@intel.com>
Subject: Re: [PATCH v4] xfs: improve handling of prjquot ENOSPC
Message-ID: <202401102103.1a66c72-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240104062248.3245102-1-wenjian1@xiaomi.com>
X-ClientProxiedBy: SG2PR02CA0034.apcprd02.prod.outlook.com
 (2603:1096:3:18::22) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|MN0PR11MB6279:EE_
X-MS-Office365-Filtering-Correlation-Id: 06ef8556-d233-4db2-7e2c-08dc11e5b521
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JHuWI3PwwB3eDwzKBfEsUvRA+2U+Kkp7iXh2q3pllEP1jaTa5qOyiwmvJ36Yi8g9SbAXCQe38YhDon+/yGsCkK7lkwdZE/NqsfRsQreQRtZYqT6a1m7oU1dXRC1ExWPOKlvPiPiKNIIvh7rAyxT9eUfP7J2g69W/aveEtPHhFw1zlEesj0kHhs5RdC/ZWRtr7MGJr7thwELuiw3ubLkfTe97BMzbGEc5bL5y+w9AjN8yGSkQMQjCPYFT9i/nqisQVooke8Y5bGFxSyUWTZphtWGLBQD9NWB990QKqA7YnNzFQXjdC1q6spXHq8v3Y0Q/wS3JZCRvfFWd01n3Kwf+hdPinZaTvmk5kuQDW+0PoZKjuGxQO6WIPam7+FEHZmEsEZ3I0IQXHglLjPE/LtvjXH+QzHRSqTPXQe3+qlU/2cb3DQgam/6E0bwfGeI+qos5CZr8ZNLpBNUEzoWfdSDiIF+0Keg7g2ZAT7T8pK59a5bRs52UC+hbPhrCApPAYeVZFWITgqaN8aBZoL5VaFsxt5kHiIvUJ07HUYSUUnmnCVw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(396003)(366004)(136003)(230922051799003)(1800799012)(451199024)(186009)(64100799003)(5660300002)(8676002)(8936002)(4326008)(36756003)(2906002)(4001150100001)(41300700001)(478600001)(966005)(38100700002)(83380400001)(26005)(1076003)(107886003)(2616005)(6506007)(6666004)(6512007)(316002)(66556008)(66946007)(54906003)(6916009)(66476007)(86362001)(82960400001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hXB+kGOjzZiDgzTpK78kEog9R3lXuuETzEkpDt7cZbXDS4p13ZUb6BZzKiWj?=
 =?us-ascii?Q?+sBIDHroSDQYTLcuW31/okd29AheVFprUN+ttreU2ZTiHknOPonllPK6TE7I?=
 =?us-ascii?Q?jtGY1HrECFJouqyThPd4esMOUjOHHRCFRQBnlvP765P5L/51ZUnSp5PvoS8y?=
 =?us-ascii?Q?jcJzp15uXL6M/w2Y2m5lPKmbmAicBxzN07+WUIEQapAIT3eM/Gj7qI9x3Otf?=
 =?us-ascii?Q?HQ4scY4NSOGVW7DpWU3JcBZWWKMU9ShfyKJfAM2WEU3ByoZqutHWzA/NiJ1Z?=
 =?us-ascii?Q?dmIr9JyGT65yc0xF/bSnTzl0Zfpt4NQi37GJHdEgyYAadsiYJww8qdKloHOx?=
 =?us-ascii?Q?t/EzbsB/PN0sBd5+8riD61qc5fejMkR3U/k9cenR14Dvrhij/IS9DQxilzce?=
 =?us-ascii?Q?SKWjhu27BfbPs5fy/5VtMv/17emV7yfkXoMvYrJWujkMsPsruqiyMjHw+O5F?=
 =?us-ascii?Q?SN0ZwPS2m4zicMy5HqMI7b7rbz9n3rg7fQ3dgYAwHmc4b3nZEyxJGfffwSC/?=
 =?us-ascii?Q?bxkXx1vgUK5pA1xt7R7MCovEwfuZtaz3c1WibLFmgXkLg1DlkupZHvUScfY/?=
 =?us-ascii?Q?Gq4S6fUW69Vgl7/TSNdMi35RDs/gSwF6waP+zg5wEoZi4BNOkq+MojI5Lg5W?=
 =?us-ascii?Q?xGp6dFzMEXXdcg1TdAU4azL8hyz5CunkdlcFV/FiYpLVp1dVSgkGAyMCuv5n?=
 =?us-ascii?Q?jtQ/yXFj9rddPO47ckfqgfJCTPET6/N7RjurB95ODS9LRGmNgLjwX3H8o8d8?=
 =?us-ascii?Q?yRWwMyXzGFvwOvOSYEqeyJoszjo/pdn+tAqAHXk34dqbAsfqAy4TYHxi7RoD?=
 =?us-ascii?Q?9Iu1JXk/eZAZgk4xDrimO9SMy+WkuTcAMAICJqzD9sPpMquJ0DISk9XHBtbq?=
 =?us-ascii?Q?ZFwwwSmx66AN5c30ujx8QbfIctobiXkGfS1Fsi1JS6kLHf8xNHdJdyOPdXvw?=
 =?us-ascii?Q?2gxIEOqYUHhB8onRcQImp7bl4cSAeN4Qn2Z5nW1pbjflPWrncBaZff5LcjRR?=
 =?us-ascii?Q?UkalHJSwWO7GFa7jmI12P40pMvMgFsJNnNkPQZbDnPBNdn0Bvd8yoFAkrNt0?=
 =?us-ascii?Q?0Dn75Y/J6c9SZ7odfPa6PNb20FYQcDbgiaO8aIlO3iSy6Fz8W8t1ZRU8rKQ+?=
 =?us-ascii?Q?YJtfW9ivNiLiX1aZOGoORjFiwLFgAiXQ1GV9jM34a3uywZESx6aCZ/VaDbEF?=
 =?us-ascii?Q?9gz859iKxxbqXadC83TeHqXPcbPcD79kFt/ZtmB9+tfCeoJwUXw3TXYWzVz9?=
 =?us-ascii?Q?E1jgDDUwz4aEomZ2Qg6EBhtIb6TMA672uh/ttF38XjEkenZh1sZfEzQcPVbO?=
 =?us-ascii?Q?CrOsefdm6lI8FBabVhBvPYiJE0ZWs5p22noaljx5ki+QCVjx7ttRM1XarY7H?=
 =?us-ascii?Q?l6+pz+UJrr8b+4oYZjmUpoIbvLj9Y3SNRydWlxyzCrC5zMHdRmsMXVOzcm0D?=
 =?us-ascii?Q?TEWdz+dB85bFv3oL1N8osonyBVHPUDNNEPUQflNfKUkfou7Xc9KtxDRfnEDJ?=
 =?us-ascii?Q?4JJvAh5i3Xfi1PLCTUsTFcRvIOuseS6ejPhSgzf923qJf0xQMA4dLs0UjBqf?=
 =?us-ascii?Q?AkIHRp8+s1lO5dfOLqxwz2cy9igvu7Pp5yKK69tjW43ejWPt+9rfAyeuwo0x?=
 =?us-ascii?Q?Zw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 06ef8556-d233-4db2-7e2c-08dc11e5b521
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2024 14:09:06.5227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CpN2gSF+bS2BNQeDvhQukmpZjA4q0MyYUmI8a29d4759BRTccILJJtMGRdIdFXiXIBb5U3Lyjkqhfcz7fQNGaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6279
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "xfstests.generic.603.fail" on:

commit: 7616836bd77299614d6ff314f6fd6c65b433f56a ("[PATCH v4] xfs: improve handling of prjquot ENOSPC")
url: https://github.com/intel-lab-lkp/linux/commits/Jian-Wen/xfs-improve-handling-of-prjquot-ENOSPC/20240104-142759
base: https://git.kernel.org/cgit/fs/xfs/xfs-linux.git for-next
patch link: https://lore.kernel.org/all/20240104062248.3245102-1-wenjian1@xiaomi.com/
patch subject: [PATCH v4] xfs: improve handling of prjquot ENOSPC

in testcase: xfstests
version: xfstests-x86_64-f814a0d8-1_20231225
with following parameters:

	disk: 4HDD
	fs: xfs
	test: generic-603



compiler: gcc-12
test machine: 4 threads Intel(R) Core(TM) i5-6500 CPU @ 3.20GHz (Skylake) with 32G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202401102103.1a66c72-oliver.sang@intel.com

2024-01-09 17:34:02 export TEST_DIR=/fs/sda1
2024-01-09 17:34:03 export TEST_DEV=/dev/sda1
2024-01-09 17:34:03 export FSTYP=xfs
2024-01-09 17:34:03 export SCRATCH_MNT=/fs/scratch
2024-01-09 17:34:03 mkdir /fs/scratch -p
2024-01-09 17:34:03 export SCRATCH_DEV=/dev/sda4
2024-01-09 17:34:03 export SCRATCH_LOGDEV=/dev/sda2
meta-data=/dev/sda1              isize=512    agcount=4, agsize=13107200 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1    bigtime=0
data     =                       bsize=4096   blocks=52428800, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=25600, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
2024-01-09 17:34:03 export MKFS_OPTIONS=-mreflink=1
2024-01-09 17:34:03 echo generic/603
2024-01-09 17:34:04 ./check generic/603
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 lkp-skl-d03 6.7.0-rc4-00137-g7616836bd772 #1 SMP PREEMPT_DYNAMIC Mon Jan  8 09:32:19 CST 2024
MKFS_OPTIONS  -- -f -mreflink=1 /dev/sda4
MOUNT_OPTIONS -- /dev/sda4 /fs/scratch

generic/603       - output mismatch (see /lkp/benchmarks/xfstests/results//generic/603.out.bad)
    --- tests/generic/603.out	2023-12-25 18:24:02.000000000 +0000
    +++ /lkp/benchmarks/xfstests/results//generic/603.out.bad	2024-01-09 17:37:42.162919905 +0000
    @@ -7,11 +7,11 @@
     Write 225 blocks...
     Rewrite 250 blocks plus 1 byte, over the block softlimit...
     Try to write 1 one more block after grace...
    -pwrite: Disk quota exceeded
    +pwrite: No space left on device
     --- Test inode quota ---
     Create 2 more files, over the inode softlimit...
    ...
    (Run 'diff -u /lkp/benchmarks/xfstests/tests/generic/603.out /lkp/benchmarks/xfstests/results//generic/603.out.bad'  to see the entire diff)
Ran: generic/603
Failures: generic/603
Failed 1 of 1 tests




The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240110/202401102103.1a66c72-oliver.sang@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

