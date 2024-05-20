Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D18A12E40
	for <linux-xfs@vger.kernel.org>; Mon, 20 May 2024 04:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716181132; cv=fail; b=ducxklHtVrnB3OiQCq4GmwfF+HWBE5JjI7/ySptxwhy1UL8r66vmMAsUzKKn/GhYiLysJwc/mwkGHnYYBUQC4LRwtqN8EZ0aONVpo2MXCUG6h7CMcbV4I06lC8CbM8Nw5ilat4SC5bAhcjHv+5q+9kqYooJX8itaJM2z80QfACg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716181132; c=relaxed/simple;
	bh=IR3766SROFq6NFhNBugnhGxE2MviVzPexmIVDIus3R4=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=H2GXK648xJ9b/ETmGyTO2rieswIf6kfpZtdbLz/TFZBaitBkcxkWWpqpQ6w28sHt/egxOJv2W08JbpHDwPJeIW7RbnUrO3uA2DM02PfwjR7AMFYa4kcUL/CEH409ylGNJn4e50fUzZbjwCB4yndZw1JNRzj0KFkkDd3tpWZOfjY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R/umcZQD; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R/umcZQD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716181131; x=1747717131;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=IR3766SROFq6NFhNBugnhGxE2MviVzPexmIVDIus3R4=;
  b=R/umcZQDC7L5leggpmrylq/qjtNKld5VulAxw/C+Pc0ohNExcDYY3XXh
   AIR/L3hGMSF3GfjAXKipZ3SeLEQfxcSyJ1EL778laGGbG9popgFaj+thJ
   eaaJqjXOQ2qwyNFMJEREvsHwWIY4WS/CwttXQ2LuoJuVe2Ec+ZICkUAtM
   G0bp6/7EzUdMRG7Rl4oYbXrRBqiUTYMNXirsmvUgjfISRJDExNBTZ1xC3
   KKfPgueZwvcAth0HhxG4kwG1jQhNsxW0j0sBQKlLNjuXdPVsOtbjR1Zgm
   oCOy3daZ8jSxtktqKrEExZo51PnwAqqCutncOpNp8klc/J+KF1ubBaXDg
   Q==;
X-CSE-ConnectionGUID: 5ZdHa6lkTYa8CVPy+Lr/0Q==
X-CSE-MsgGUID: r9oqifiDQo2cs7jmR+/AAA==
X-IronPort-AV: E=McAfee;i="6600,9927,11077"; a="12412934"
X-IronPort-AV: E=Sophos;i="6.08,174,1712646000"; 
   d="scan'208";a="12412934"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2024 21:58:50 -0700
X-CSE-ConnectionGUID: gORcMWKhQfSs9mfgtv5hTQ==
X-CSE-MsgGUID: TlrH1K2mQ2yDMp554ygzgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,174,1712646000"; 
   d="scan'208";a="63232846"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 May 2024 21:58:50 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 19 May 2024 21:58:49 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 19 May 2024 21:58:49 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 19 May 2024 21:58:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V78o2jbQboiW9aIW+ak6STbxQIPPLtAT+AxbktMgePHxWhONd6cDqV4lp4UPni36GkmNKQWHH0bKipgJLNRAuCBKVESzR/ckdmH8/sz4+mOrfimSn7P12me3nFHVzTw6zzbI88O0iorQSWMfeQ4iCHWx+HzK4/dJ1xvgKEOBP+GxCGL+2gwbr3sPTjR8Xqmo1DYDkItnmNMjyZPmPSQi7vdYH53DEvEkJqt+sd0+1yG729gj5f43PtrcHw15xxnzbM796PvQo/BFd2K+o0cZC8+8CFECg9hETmCD8BHVmNAPCPWe6y+hXQOm3ubsuz5uwp8QC4KoWFJ8U4mOQvFkpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=51Jv0CNRovMemPVdUk4zPUytIg/XGhHNrxOqFNj2v5Q=;
 b=Br3Hzl0URvPkJa5vB+4v5g/XCMteUsXMfsIGNicCIzeXqGCCfWEO//IZhT6EDfT05TzdKJ+kf5GKCmNAf65rtZl3QTer9li03naXwtBQbttYxu8O99sOJv1G66NLyUlytclJDelEk6tzKgNL6cjLOOSd1svWH8q7pyW+wOp5ZW6l12DFfjvsOjBRaxgbf3iblUcb07kquydAEImULPVjozOtyehlOqi18aiu9BVJDZc/GBFtoaHBIFs5XKrnVcV1JtcdDFBc3iHLKyDaErSwVMb5HekxlaymXj5FigFwP8BfmOA2iprxIeLvpnTXguses1TY/m/+H3T6wgpdJ650Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by DM4PR11MB5312.namprd11.prod.outlook.com (2603:10b6:5:393::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Mon, 20 May
 2024 04:58:47 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%2]) with mapi id 15.20.7587.030; Mon, 20 May 2024
 04:58:47 +0000
Date: Mon, 20 May 2024 12:58:39 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Wengang Wang <wen.gang.wang@oracle.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-xfs@vger.kernel.org>,
	<david@fromorbit.com>, <wen.gang.wang@oracle.com>, <oliver.sang@intel.com>
Subject: Re: [PATCH] xfs: allow changing extsize on file
Message-ID: <202405201028.ca3b53bf-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240508170343.2774-1-wen.gang.wang@oracle.com>
X-ClientProxiedBy: SG2PR01CA0198.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::7) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|DM4PR11MB5312:EE_
X-MS-Office365-Filtering-Correlation-Id: aa3bfa4c-f19e-48c7-a7b8-08dc78898835
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?0YVIJZMbsBqTR4DYeonp8C3tDUM1gNhdrpwaDlBldeW10Ak5m1QSHeY4t1Z5?=
 =?us-ascii?Q?7t7E9hTNSx6NcpYYihZ5MKzlQ3sWmr1OPoIaMqgg9WtVNCQ+dsA1jBcBka6E?=
 =?us-ascii?Q?HFYoAHgg2SZ1Vpn2D+mLfwWBOcDdzrx3KVoggMQFLy5zP0d64zDLGsZfPAFw?=
 =?us-ascii?Q?EcFya40ayr9mPgxg0gMp3279GEhVTwp1B/aYoXy4vtuwPMuWefUyLwRk2Mq/?=
 =?us-ascii?Q?V9i32ra+M7okQ99+DLmZfH7DDUi5gr4i2HRQN17tOaF5Z4J5IF4E8+Qf/Rz5?=
 =?us-ascii?Q?E6dwZtY2mIMH9pF6SdtaJkIqJWTfaeJbRLwasZ5WS75OEuptRMk+yXbW3JMT?=
 =?us-ascii?Q?APFL3wDHMcw5LfWxsCuT+MU/10Suklv6v+isQHEbspHsTGFLKu49FbrQokAq?=
 =?us-ascii?Q?guVnvlIgftp4ioYuPDXvAA0WaZy7Xf8Ngx9WsuonK6dmSziHyen7cQxEf1oz?=
 =?us-ascii?Q?SL7rljmayj6SFes2j4Z9/yw2ipnYj93Wf/4x1eSNSyFbg64ptsla9O5LkFYz?=
 =?us-ascii?Q?He6zed50TPMbrqCwAkyjXGibGN1d+/iyCddko3viie0g5mNCqaADer/6JjA2?=
 =?us-ascii?Q?C0WEiPXmaVafwBSf+vE60lSXVzk+XCfTbYyiqgor/gaqaFN0ltReISPm43E+?=
 =?us-ascii?Q?PdllapRZv8LNvfsGm9Owi1Ink+P6ZmL8I8WbHcseIbzloWFPCa5CEzxb4ch2?=
 =?us-ascii?Q?4aJYDtaNdp9AO3LmVpk3yAKMsNjCxfXII+i/1sSWjHdR375ozSBVJ55k4RYM?=
 =?us-ascii?Q?DNnhQBArg+7y6yDcqvg8s8Yey7vdl6dKPi8itUmempAm0ehwShG0BuzLkR4z?=
 =?us-ascii?Q?zkwDGrtWySFfNWWBparM/uTKlMcejr+9Q9DnlTtx/WSc9cJfFvSisn8j1TGz?=
 =?us-ascii?Q?ZmXQQ2U73zHuaJxn8+nxawhS+XKnjO/oKWDSZyF2YXohU6OTz9F3LgBDUbFx?=
 =?us-ascii?Q?0XB+0oyE9yUghWQ/ujOmWTl5uVZc0mC50dwwQQkQEmFtq2OgM45Y7I9qfcvL?=
 =?us-ascii?Q?Yhpy4F3TPhMztu8yRBu9N4uraO+1nFdUD/x0tgm6bACcCoNFh3Dq3eRiLn2L?=
 =?us-ascii?Q?pplZ14CTd+99rqRSQZkvmKG1UITn5EVaJ9DwFv/6hURnYSyQ0lmvV5yu8klM?=
 =?us-ascii?Q?/aGuNurFK4DLwC2vAQ21F8mOu6IswCnO00B20ar2ZNLXyFmgjSvs/RE8zF93?=
 =?us-ascii?Q?HQ1Cp9uSiU8xIe/Hh4F1BMeywnS8oq3qz/wrkafo6/5qAiKwqZNvaoFkvYc?=
 =?us-ascii?Q?=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4t6MKJFQAr5p0smokuFi16STNgE5V6iGKmZUkI5pUJTwcFzJnB2F4ToaiG2p?=
 =?us-ascii?Q?k6wQ6Q7HKqvbnuhD2eM0xLEQkhUxYQ9aRtyTSY2mjBuBn64tO1U3jtjwpTY2?=
 =?us-ascii?Q?arYCV+bjrPqaS0npa++4AR1UV1h/nIdnUpDVMzNlkXcqOhFK14SmFAaMiLC8?=
 =?us-ascii?Q?Qo02PblofB0kDiMCunSR6nkBKcAlZSDdDmBMBPGUVjhUjwV9x+qwUlvlcXM9?=
 =?us-ascii?Q?m87m5TKZMUlJhgSbo/QReZMB6PYxGgaAgYxnDZ6LThlKaWe+Mz4qUB8Iauwv?=
 =?us-ascii?Q?w6igd39KPoxbtpYLZTwUfqbizmyXkBX2slRIUSmKvTZvCxqXMO3x80fX466K?=
 =?us-ascii?Q?N7L1yFOwmDgQdoghPORehyQUgRVszoqmCUNzTkBImd3R7UVwdMzeq6ABrjSN?=
 =?us-ascii?Q?mjiF53Hh8UuVFRXXv325aQxq0UlPt8e4IesOlmRYUbyaP8HMO5r8GCIfwcu5?=
 =?us-ascii?Q?ihWJGwpIXDnzzkjPeoGcciUfB01j24L9NMOb7W6GRCcfRkJ9TNIy/5K+oEsW?=
 =?us-ascii?Q?lfKzVGKBkW6eFpngOVEmva9U1Gyi+w+jmiytULrf642D35q3+v9Jm562w7JB?=
 =?us-ascii?Q?9jWcs+qeVmlQTBz7kEFUov2bY/XvvNpCgpKPrrjxk0stzmHIJZrTtCLQN1FV?=
 =?us-ascii?Q?YwHzajnOi+3M17SfGT0gFjC52nH3KKRB1m23r5vPkw2JbqfDac64gzUPjVbF?=
 =?us-ascii?Q?d4dZIrdP+0R0fYsvSgu6txD0/yfRXGHX0HvKUUjfFijqqYI3C/cZPVmmCtzm?=
 =?us-ascii?Q?yZZffkAeIecXafbYTn9sVKUedzNI7cmSIBvwr8uoavHrPt3c/pdWzxvlRNgE?=
 =?us-ascii?Q?AR7e2nhsPRA+xr2CARMfSlq/XpuuY/ZDLuZcLP7A3J95WS9LiLvpJuuZtMQn?=
 =?us-ascii?Q?nt8a5wIyozvjJmzKVXnOTHbGBjhaHqoqifOfjPyqjmdpWVM8rFR9a786TIrz?=
 =?us-ascii?Q?e1sILlhM/mtEN0yqFVlsVKZuYc5DOirN8A4UCz0ObETHOVnD824D3YRKAepb?=
 =?us-ascii?Q?HqUh2ao+ASfCuEd5L4wf0xjycJVIEmJh7agOj21mHI+yKT1tTYovbHyu+Yrd?=
 =?us-ascii?Q?12KRGxsW4Ua+ha7hZTFaNHoHkw3tEVNBTejwuYzVFPcPuHVkSmlazskqCdlI?=
 =?us-ascii?Q?r69//OInKEqqFdK0SCiHk24ytcp24wqUFll43Bpa5Yr4Dg2Yn/MusxYja3/a?=
 =?us-ascii?Q?gNA6aMTctBgzXWIfUxOSkASPnCEfLNkNOAHhv5olqPdgQhESHridcHgQVyi/?=
 =?us-ascii?Q?W2WxXGPTIBEhLJzmQ5Id59b+xCxz4wwnul4wzowR+SMIhyo7LyDYUgBwQyTl?=
 =?us-ascii?Q?zAV87Z518ipo38XAUfcTetQ8luVgkP0UolHK91ZGmfH5Hvu72sU3kOlyy9tx?=
 =?us-ascii?Q?AYXb0BoGHcCgoDIvHqH+l0Cb5GSYqyxL5ZLeekyPlb5WGm1fWLohY7YApr5Y?=
 =?us-ascii?Q?7Kfi+h1moSYRH2gzVQxux5oUVgBs+xKidW17xF+QHjynyHH5cw3UkbubLYeO?=
 =?us-ascii?Q?n9ty27+Ror/eb0X7kqkQSyiK8MAQD05Ulcqpol+YTDEhuVFF3Nfndgw4ZFUS?=
 =?us-ascii?Q?cntFs4Q8ZO0u6ARwsSkQ+V4g7gHQR49q4kd7UZXrJE9z4QP+kzmnwmZQaZ7D?=
 =?us-ascii?Q?Rw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aa3bfa4c-f19e-48c7-a7b8-08dc78898835
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2024 04:58:47.1822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eBzLIOhNChUR0sV1wk3CDoIOyjZ9Zg06xLgTuwqP/jWzqoC2Ep2KYC4FnklkTu0VscnbmsIBLlMyHvq2JYbQ6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5312
X-OriginatorOrg: intel.com


hi, Wengang Wang,

we noticed "this is more a question than a patch."
but not sure if below report could supply any useful information to you, so
still send FYI what we observed in our tests.


Hello,

kernel test robot noticed "xfstests.xfs.207.fail" on:

commit: ab25dcd364e632586fe0bd3a2cdb194e03f5b484 ("[PATCH] xfs: allow changing extsize on file")
url: https://github.com/intel-lab-lkp/linux/commits/Wengang-Wang/xfs-allow-changing-extsize-on-file/20240509-010818
base: https://git.kernel.org/cgit/fs/xfs/xfs-linux.git for-next
patch link: https://lore.kernel.org/all/20240508170343.2774-1-wen.gang.wang@oracle.com/
patch subject: [PATCH] xfs: allow changing extsize on file

in testcase: xfstests
version: xfstests-x86_64-b26d68da-1_20240517
with following parameters:

	disk: 4HDD
	fs: xfs
	test: xfs-207



compiler: gcc-13
test machine: 4 threads Intel(R) Xeon(R) CPU E3-1225 v5 @ 3.30GHz (Skylake) with 16G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202405201028.ca3b53bf-oliver.sang@intel.com

2024-05-17 16:19:24 export TEST_DIR=/fs/sda1
2024-05-17 16:19:24 export TEST_DEV=/dev/sda1
2024-05-17 16:19:24 export FSTYP=xfs
2024-05-17 16:19:24 export SCRATCH_MNT=/fs/scratch
2024-05-17 16:19:24 mkdir /fs/scratch -p
2024-05-17 16:19:24 export SCRATCH_DEV=/dev/sda4
2024-05-17 16:19:24 export SCRATCH_LOGDEV=/dev/sda2
2024-05-17 16:19:24 export SCRATCH_XFS_LIST_METADATA_FIELDS=u3.sfdir3.hdr.parent.i4
2024-05-17 16:19:24 export SCRATCH_XFS_LIST_FUZZ_VERBS=random
2024-05-17 16:19:24 export MKFS_OPTIONS=-mreflink=1
2024-05-17 16:19:24 echo xfs/207
2024-05-17 16:19:24 ./check xfs/207
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 lkp-skl-d06 6.9.0-rc4-00248-gab25dcd364e6 #1 SMP PREEMPT_DYNAMIC Fri May 17 14:27:24 CST 2024
MKFS_OPTIONS  -- -f -mreflink=1 /dev/sda4
MOUNT_OPTIONS -- /dev/sda4 /fs/scratch

xfs/207       - output mismatch (see /lkp/benchmarks/xfstests/results//xfs/207.out.bad)
    --- tests/xfs/207.out	2024-05-17 14:38:40.000000000 +0000
    +++ /lkp/benchmarks/xfstests/results//xfs/207.out.bad	2024-05-17 16:20:09.902112701 +0000
    @@ -3,12 +3,11 @@
     Create the original files
     Set extsz and cowextsz on zero byte file
     Set extsz and cowextsz on 1Mbyte file
    -xfs_io: FS_IOC_FSSETXATTR SCRATCH_MNT/test-207/file2: Invalid argument
     Check extsz and cowextsz settings on zero byte file
     [1048576] SCRATCH_MNT/test-207/file1
     [1048576] SCRATCH_MNT/test-207/file1
    ...
    (Run 'diff -u /lkp/benchmarks/xfstests/tests/xfs/207.out /lkp/benchmarks/xfstests/results//xfs/207.out.bad'  to see the entire diff)
Ran: xfs/207
Failures: xfs/207
Failed 1 of 1 tests




The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240520/202405201028.ca3b53bf-oliver.sang@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

