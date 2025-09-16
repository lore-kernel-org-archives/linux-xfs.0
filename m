Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0AF2E7BA0
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 08:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758009621; cv=fail; b=ZsHw3nT+mbilL3VkRLqx0H6cto1bul0vTTjTE0v1mJSpRGBucI1JwLvgmwdZG0mkuPinvJGsnOaBIt6h6By+ox25GWXZXJCLbh0Nb16KmUKAvOfQAyB/AgUSerJREI+zhTMDVcfW9l/uH0hjdDCCSg5WZ0fhrkXB5Yx+ANi9CIw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758009621; c=relaxed/simple;
	bh=9r8cAHPKs03OKaeyfpGIgdXq18K6VXYZmUi+o1hz0A0=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=aFThQL0crm98uoX1ceaZR25XNy10DKuUfa8qV8QmL8Nq76B4B/+8/J3CU7GcrRGcmxOazpJFUjM281TDGFRLOLZNQin+7WOVFSZoWErcNeYYFWxX3Foeld3lxq+kfljE16mTkW0Bnhjnq1VlCxDZ0TygznP4ZyCWaytkTKZ0lRc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BI3Sh+yM; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BI3Sh+yM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758009620; x=1789545620;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=9r8cAHPKs03OKaeyfpGIgdXq18K6VXYZmUi+o1hz0A0=;
  b=BI3Sh+yMgVfui4dkipeEYc7J5yGOPHR1K8YgXBcnIYao2iE6yaV7zZzx
   zqsK+1Xvp2Dur7B+gM4U4E6bZsUaZ2uOeR+jdgHe4dxM8lW6MPQmlt49F
   uj07neOqSVm6SYfJncm6P0N6H0r8ljGMkMO1WjpaKxrJ0GOCw4l8QQsRt
   A90ZMzJYVYRkAZcCeOOnAvQegAS8rai7zhCsjTN5iXT6Rf9BypTAZoAhT
   d9Ft6TqKv0GGRiXa9ZLAnC2SxNQCfCtRqiTTQWQCvA1o/KyT65msGcCjq
   SiVlVHN1E2CIdSAey/bRERth4pXjAxmqotj7mVBRIDdoNVc2nvsFi2iIU
   Q==;
X-CSE-ConnectionGUID: o41h9hFEQw2hqQkRc65l6w==
X-CSE-MsgGUID: L4fiGJk1RV+blSdrj1RnsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11554"; a="60353067"
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="60353067"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 01:00:18 -0700
X-CSE-ConnectionGUID: SnjK82tTSguJFRfDzx5BXg==
X-CSE-MsgGUID: JzXjBBkKT8mBft1XZn1uQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="173988971"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 01:00:17 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 16 Sep 2025 01:00:17 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 16 Sep 2025 01:00:17 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.15) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 16 Sep 2025 01:00:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s1WpEWSQk8Yop7f3Cq3zUP6CJyzOPt9ubMVX4IWeASArYZC2jcezSMmYLAocOMmm/ibwNA9roF8F4jUh5CsG8twwEZAdLn+nqtc9bEr0N7wxmVE3NC1uCGdSOydSMqqqBGAc+nS7BN66D9BB/Udn93Cro9JFl17GQKlefXUwvu5X/wKxtKb+4RXd8gDwZZ29xhUu7i7zbUC/NcNWKfR79gP8Uq2bNUgZq2FtsSZOtiUSiO/8AjOrSVUGOu5SBdjjKUeaLlrN91eUEJdAtwSciLWPc3ClutjDvR6JNp9idMUGZ/Nz2W+kmwMNcTQmjLtniJD3JNXRvR1gZPj8P+1RHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i+AaAGw6YwI6R7QxvOoDPkZ+X/NYV4dRAv1QVwZIjvA=;
 b=oQwej02hp1sp2rH9FG2LbJlD4YIJlJeJD4xzWz71HwT9h7wBzsl0wQLNIN3+wYcC56mpF0oX64aFZ315OP0OwlD2xPI0FqBGUUkGziKmTOoeiS4VkLH52UdvjUsDWHsTbyeYtuBT7wwKfWNuzlSyRmrybSEGS8NtAoV3994vLg7OQAqhgcealX72IvH51qjZTUAbH8IYP4txfdxbGgx6gOee/S0J4k1U9/dEnJmzLT1WjmONT1bI9gZpGEGodlsIBT5ykN679Se45AeIcs+9qfICwDLKLK6VrwDIiEK0tamm5SJKTO5lYjdLuz5yWxt9aBpDIe4/XnUEgAf4+J7ecA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by LV8PR11MB8487.namprd11.prod.outlook.com (2603:10b6:408:1ed::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 08:00:08 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9115.020; Tue, 16 Sep 2025
 08:00:08 +0000
Date: Tue, 16 Sep 2025 15:59:59 +0800
From: kernel test robot <oliver.sang@intel.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Carlos Maiolino
	<cmaiolino@redhat.com>, <linux-xfs@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [xfs]  b9a176e541: xfstests.xfs.613.fail
Message-ID: <202509161536.f4d93fbf-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SI2PR02CA0048.apcprd02.prod.outlook.com
 (2603:1096:4:196::23) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|LV8PR11MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: 164c5fe4-7b64-47d2-3e09-08ddf4f70d9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?7TL1tG3afmOpHa6y/QLY7yMhiLR/RnaeZYtMibSg0YPGyjXIwFhg4D0TPQSL?=
 =?us-ascii?Q?VQyzHIwJHrcyW0sE5IBMfUqILyYHnrgktBuuRe60W/63TCgV0oaqMN0QfIOG?=
 =?us-ascii?Q?OT2G7+fUEyf7+AT1Fhi946nfg7+UJnILAKPtgVM5zE+DQQQnILo7Jx6M0oXx?=
 =?us-ascii?Q?CvabC7QzNJNRC9RSLgOvWk2Usrz+Gh2OCyh9bVf03VsdkvNRyx1JmL4cgYCS?=
 =?us-ascii?Q?FJXylWjexJWs65mWTsgvZpEXX3YErX4imQ+N0wFTwpYadRDsDZLoIRxeNRFg?=
 =?us-ascii?Q?yQykNm0xtxDmZoeP5/oVLOTxrES3soGrdbtE8Vhl/xExA+4faLjmtTQ/9hKH?=
 =?us-ascii?Q?x/uwRJGh6slTL8FFOwZMIbmUALjmeCH+PWK+i7zIE+LKrV2CS1WBBCYvH75t?=
 =?us-ascii?Q?rR2Rzp3+p9UavN+cEe4g1uTVBYJLL66r8VkSwNy3Npj7AcdDDTWAWYcOmQbQ?=
 =?us-ascii?Q?mURJyOPL7+X2BrEBVv4qFwqpokLKgCbfQd089IsclyTn7HYoUbrQrSBzaCuK?=
 =?us-ascii?Q?5eazRrMxi1jauvWBc1I30Yj/N717OH408zG5Si282uUZYqyXQXPK7cbQIifk?=
 =?us-ascii?Q?XlS+cS4/dye7rBzO1FroPMUSk8lPi6ozskRVx3dqqdZA75ndoBrX/px4d8dn?=
 =?us-ascii?Q?afp3UIurGT2iFCe/LJ//wGDm4gacPBwk0WTS/VxJJUrDlClFhOxA4Cb3zIEv?=
 =?us-ascii?Q?npQO56JBY5neHVo9RK+/NItpqpdkKcO4eiyUMtMHgOf+Z7DiIingrAWuHPe6?=
 =?us-ascii?Q?tlg8wQYxejRhnk2th9253Dkd6UIILobV2HpNoqJx1lUbUaOu+unnFXXbijIi?=
 =?us-ascii?Q?IZYbe6+aZoZd6cZbRwDapPSBIrP/aZoiuQgB8qpdd83AQWxczezarvVqu1c0?=
 =?us-ascii?Q?5Mm145er4C3Y+WtLWlWoEPJ/8DewnghO/M5ysYJWOTF/ViyGBTt0+HIKhgMg?=
 =?us-ascii?Q?iitvrWcEX45dIbGF24A6B+3BgNfiIu6IPbnv8J8gvmCgVsNCkksB+WcHj6Ya?=
 =?us-ascii?Q?QEbeWfAHx/nqM67EmKJIMMTARgr1jLIKiXnehx15Dge3OHO7qXapPbLwi8Eg?=
 =?us-ascii?Q?Rt06bgymu/lhq2AKbcVDOoC8JfFRe4V5/IKZZY3BOBr4lu3Jr3c68axRIqi8?=
 =?us-ascii?Q?KJQwOjPhSv+E52/CqdPHLvWZSGVkUdXNYIWc2kdiHRH/MsSJz9+AzO4hXhN6?=
 =?us-ascii?Q?hUpw203r6ZrDSbQJu+F2t18m1spixh04Wm17t6Bwhcs6eTEb6zm59eEMb9il?=
 =?us-ascii?Q?6aCKNeBXc3vfkg2qn+cAJjgWym7PJLwtimDx7/tAZVTJFtQVHt2m20uZEk8d?=
 =?us-ascii?Q?Xmvp28v4K3+EfTmJSPyQnew9QmxR9usX0UItQ+7GWjmrLbMH1bmkOpiAPH0L?=
 =?us-ascii?Q?bEML+KqHK9X4yr4nrWeze5Hkg08u?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jW18h/vHuXR0UnYoI2X862/DjMIqUQQYkk0M3avcGTr/NFOSM006BL0Kt8Vz?=
 =?us-ascii?Q?zNt7r6g37r+WbxfjM/Eut33H2uDvRbPh0XkS2qDSPbDDoENmVJcVhnhfGUp8?=
 =?us-ascii?Q?+bT9zuzbUsUyVbFhVZMY74jUFOsL3jm+H1Gqrs6ZduqkZEisoYTqRtQV2Mxl?=
 =?us-ascii?Q?cXuODakGNzGmnRGTo+myf5EV6FI1k3LPpgTFePTzhQ8GroQckezmpI+Ptyic?=
 =?us-ascii?Q?dkPxLCy9Qn0n/NvZeat/cp45M/Vh52s+A41/ZX79AEDUHDIV/sVVk8SUjHo9?=
 =?us-ascii?Q?w91b/0J9tFhc8CdPAN/WJJx/X1l6HlO2qi7TnOwkp9dOxMY8qr6wRr2V6U9A?=
 =?us-ascii?Q?mRyCsmnwk/kXino426Dp6ZKoJl30RJHkUG89T+zt0jCbqV9Nu2WLDdDP5otD?=
 =?us-ascii?Q?2pMJprn19zBByy/gUf7sdd252BomZ11fRbBKD5hX20gafsCj7dIL2Rlwth+K?=
 =?us-ascii?Q?WSZrXhg+SZnKGKMe/Vc7PXgt+7nncNHSmz7VIDScExXPIsVZgzFnUsqP7x/o?=
 =?us-ascii?Q?mANQENbdVzBn1cKkAOLrM7QngYbKa8nwes8orbtasuffgurxjqvjvF1Yw8T+?=
 =?us-ascii?Q?Mv9+/j08wWAozGG7TAKFQVZmTvPBrXdOhNg8EI5MnrpRSVCCs/6Qyg1dn2sT?=
 =?us-ascii?Q?iFhyqgID/O705hkL8gsh62To/cV836Pl+LzaUbjCijvxUpUFm66u6CG4eZfS?=
 =?us-ascii?Q?Tv9SPNufVcUmI/ahPRZftN3wmO9PbF/KEeTx6/QJuH6FhUBNm25TX3qVCWfJ?=
 =?us-ascii?Q?qE1BwEdge5cUD1Is5m2LRxA1Mj7zSqflSEzB/VQXqpf3VVCzbKqS7pvOaZR/?=
 =?us-ascii?Q?JyeN+RtPSDmIe8J+MvRH7SpDPg+Fl+5NrPcQRYA0eXiuMsQBLHEZwF1IdoT6?=
 =?us-ascii?Q?BsetTn2VbRYw9DkC359yYMgHpvIQfH20QKzLXNHzbGyYaqIp3SoYcR5wWb/t?=
 =?us-ascii?Q?CKLiqA1MTc4ybu2zXOHF/auEJpq9ROSKgx4BeD2vE4Uqc2UpRucihooeMNqM?=
 =?us-ascii?Q?57ftDSckzY711CA239xdlQnl1BZVnoLKWTovVRvJnHdPkJjocFXnbNRxd+zp?=
 =?us-ascii?Q?40o6LOJvrAA1HnkFktanJJBJW/jVAppwR+ZpnKJX6x28DES03+2lHT66Q76W?=
 =?us-ascii?Q?H5y28zuinwp0yyrCDacatWdZWoOENqGy+XIF+nXy44nFnq/HVAh/+hgB4po4?=
 =?us-ascii?Q?nUIYQK9nT4eZm8HYpZSPi5SdVguL6ANkaDW/XwIWoxMJ5PSs7pK8NfD9AcRo?=
 =?us-ascii?Q?avRB9GqUeiKiTpYFHceEIRerbxf8uudveOj5kbN1uaz3jiuX//ousWqwtG39?=
 =?us-ascii?Q?hdchR9jzi55fX5hHF+rE5Dnkf9gOjrpbu7ogWvbBIzWHzdmauSVj3pz7GRQ4?=
 =?us-ascii?Q?t0MS/MxcIZmGnNhSvqvcG7MMzWryEVKin4zpch/gsOE5j6JRo+md/37XGgJG?=
 =?us-ascii?Q?am59IY00tdfLciPnKpSzeh9hphFO2v9MT71jtmjNSl7TGFs/cqPQr77C5i9p?=
 =?us-ascii?Q?RNI5TMlU2/rce4axD0if8irBjGTMfUwN0L/bYYUyKrW30XxmpMbVpfMzaFF6?=
 =?us-ascii?Q?2coC/BeBfSFLjZpWIN4NDv8sKkrmGYNGplp+vhUymO9IbQz+jRi6wfGSEMjr?=
 =?us-ascii?Q?dA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 164c5fe4-7b64-47d2-3e09-08ddf4f70d9f
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 08:00:08.0369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p3ix9v+AmZKPxLS8pO/6ifFUllXFVpssyxlx9O251xsqWyowiPvu+zZZS01btl9G0QMPOlMNFlFo398b9Q4Ovg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8487
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "xfstests.xfs.613.fail" on:

commit: b9a176e54162f890aaf50ac8a467d725ed2f00df ("xfs: remove deprecated mount options")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[test failed on linux-next/master 8f21d9da46702c4d6951ba60ca8a05f42870fe8f]

in testcase: xfstests
version: xfstests-x86_64-e1e4a0ea-1_20250714
with following parameters:

	disk: 4HDD
	fs: xfs
	test: xfs-group-61



config: x86_64-rhel-9.4-func
compiler: gcc-14
test machine: 4 threads Intel(R) Xeon(R) CPU E3-1225 v5 @ 3.30GHz (Skylake) with 16G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202509161536.f4d93fbf-lkp@intel.com

2025-09-11 14:07:13 cd /lkp/benchmarks/xfstests
2025-09-11 14:07:14 export TEST_DIR=/fs/sdb1
2025-09-11 14:07:14 export TEST_DEV=/dev/sdb1
2025-09-11 14:07:14 export FSTYP=xfs
2025-09-11 14:07:14 export SCRATCH_MNT=/fs/scratch
2025-09-11 14:07:14 mkdir /fs/scratch -p
2025-09-11 14:07:14 export SCRATCH_DEV=/dev/sdb4
2025-09-11 14:07:14 export SCRATCH_LOGDEV=/dev/sdb2
2025-09-11 14:07:14 export SCRATCH_XFS_LIST_METADATA_FIELDS=u3.sfdir3.hdr.parent.i4
2025-09-11 14:07:14 export SCRATCH_XFS_LIST_FUZZ_VERBS=random
2025-09-11 14:07:14 sed "s:^:xfs/:" //lkp/benchmarks/xfstests/tests/xfs-group-61
2025-09-11 14:07:14 ./check xfs/612 xfs/613 xfs/614 xfs/616 xfs/618 xfs/619
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 lkp-skl-d06 6.17.0-rc4-00011-gb9a176e54162 #1 SMP PREEMPT_DYNAMIC Thu Sep 11 21:52:04 CST 2025
MKFS_OPTIONS  -- -f /dev/sdb4
MOUNT_OPTIONS -- /dev/sdb4 /fs/scratch

xfs/612        5s
xfs/613       - output mismatch (see /lkp/benchmarks/xfstests/results//xfs/613.out.bad)
    --- tests/xfs/613.out	2025-07-14 17:48:52.000000000 +0000
    +++ /lkp/benchmarks/xfstests/results//xfs/613.out.bad	2025-09-11 14:07:27.472610189 +0000
    @@ -4,8 +4,14 @@
     ** start xfs mount testing ...
     FORMAT: -m crc=0
     TEST: "" "pass" "attr2" "true"
    +[FAILED]: mount /dev/loop0 /fs/sdb1/613.mnt 
    +ERROR: did not expect to find "attr2" in "rw,relatime,inode64,logbufs=8,logbsize=32k,noquota"
     TEST: "-o attr2" "pass" "attr2" "true"
    +[FAILED]: mount /dev/loop0 /fs/sdb1/613.mnt -o attr2
    ...
    (Run 'diff -u /lkp/benchmarks/xfstests/tests/xfs/613.out /lkp/benchmarks/xfstests/results//xfs/613.out.bad'  to see the entire diff)





The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250916/202509161536.f4d93fbf-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

