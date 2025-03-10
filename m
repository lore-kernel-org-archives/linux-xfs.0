Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3362C2253EC
	for <linux-xfs@vger.kernel.org>; Mon, 10 Mar 2025 09:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741599583; cv=fail; b=DOgsgYdprz518ESgcwKVXGadQPz2dABs+KtnY4CIlewu0FY5wxOs6RDz6Daspvk9ZR4bTD2Hqx1grOuL92sWZI8W5adpzADJ4fFLwdxeW2aWRjzjmQ1m1lP6L+VB1gix08j/ZqTNS1BUXNB5/75fY2flV4fn1WSXlinSfcJZcaI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741599583; c=relaxed/simple;
	bh=C3qOnFUka4DSmFb3CaCqgcwJMSqohV6gMM7EUYaG9uA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TRgCQ2EDPwsQKD19S+j4BAGGg9bLfgHlv/LP1noG+dVWLLaDvk/PI1xxQpe0d0DEKefSY6Ze4JSn8oJU0vDx+qWR9RlZJ5B3Ibp4E+IYDWs3qXN2+5xESeHN3CdlJauZuv2jGEEZ6rHBniQ4wITB0UnE2f0nWg3lf3jQ/3y2ixM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VTTdlbUp; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VTTdlbUp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741599581; x=1773135581;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=C3qOnFUka4DSmFb3CaCqgcwJMSqohV6gMM7EUYaG9uA=;
  b=VTTdlbUpFx/gWVBxU7mmYouHVAJscKCunE1dAJiBbf5fOvyVrySvRsbp
   vvSOHdmDjwH+0mG5oP+WcCZHAQzynn9qg3agE6aFevHl18zL1wApqYcUO
   kSf7LZYRsnO6rzGo9/sV/hu2+7y0NQwKeMGiaIDUR59jyuSDWrqoRTfzq
   5a3AlnkPtBjoGn6fIYpwTHLflFwjr1fC7jnzxsm/fgo6ljwq5H4QbGorW
   pl/IQV+0ucVQayoC9KJcbx+mpq3NaqQmSO1hxdd6KfYVv0P7xm7dCo1RN
   yZVbFXPifeJ1SK93bs1poW+q2+XHpiBUBRzg/5f6i1sZv/tbLZMtlznPa
   w==;
X-CSE-ConnectionGUID: sXAWGo/0SuaidJXOwF+Ndg==
X-CSE-MsgGUID: S8HzEtWvQCObPSxRh78zFg==
X-IronPort-AV: E=McAfee;i="6700,10204,11368"; a="42624628"
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="42624628"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 02:39:40 -0700
X-CSE-ConnectionGUID: 9XMWc9w3QrSUxacTB+AJOQ==
X-CSE-MsgGUID: ZxKbFUrkTWeqxeol0Ban9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="150888676"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 02:39:34 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Mon, 10 Mar 2025 02:39:34 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 10 Mar 2025 02:39:34 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 10 Mar 2025 02:39:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c7j4fmF56OB6t64PZhyYjQEcJ0PVvwvJupMUsPAx1E+0OkUqpfdCZHSG67eKdJeJNhMV3FjmSaOPHvZs8UE2tiKK46eWVw0qEHPeK2U2UQK6CRAPwhRZiEIH8Sdc493Ic2yxJChHmXbTNA6fkUJc53ftjFpDc9jJ45HlJX5bAdiY6gdfr8oaffnq1pxpK89birud9rpn2fBOgotCZXKAlIU/62qZHl9Ggfsgb+x59iERCYS4DjHUbIcO7wDZGLvId57h7zuEHJxdzikobLl2I1fveX/J010EOnin2LXKM4eNVdilD3EJ06fxFkCnVfJ1zNVKl5KkZeYeAkH1BZMWlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3B60BgMTwqhmIQeVxDrKPGxW+MJqGHpmS0PcnMjzJg8=;
 b=j//6wABInEuTpqm/KS8rX7KH9oTsew0E6WaUub0R5YQIg1jwdmlZqF+CjA2ffCMDEoJ2ihRnuWZcnJI4SxqlGmzzJfk6W+xVOww03gVerfDaP4/vu6VxKM3ehkOJfTA9HqbYICU07dbFuMprFPwmTwzdqDDjvpSnA9cH9kppRvWEF+sFJGWzDE7xOt939lIHiF6LJ+wrPubIbbSXl/sOf1v9YhRbdJhF/sYmLlApG7aB3Ho5YIUuyw8kKaN1IJEVWt+BEf/5XxJBmW1/rjaMu7U6JJ3e3tmowL8rBHasafPImk2hVwIDoxJ/NE4N7+yPGggsbYVJc1xU8IZt7kdCCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5423.namprd11.prod.outlook.com (2603:10b6:5:39b::20)
 by SJ2PR11MB8514.namprd11.prod.outlook.com (2603:10b6:a03:56b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.26; Mon, 10 Mar
 2025 09:39:31 +0000
Received: from DM4PR11MB5423.namprd11.prod.outlook.com
 ([fe80::dffa:e0c8:dbf1:c82e]) by DM4PR11MB5423.namprd11.prod.outlook.com
 ([fe80::dffa:e0c8:dbf1:c82e%6]) with mapi id 15.20.8511.026; Mon, 10 Mar 2025
 09:39:31 +0000
Date: Mon, 10 Mar 2025 17:39:23 +0800
From: Philip Li <philip.li@intel.com>
To: Carlos Maiolino <cem@kernel.org>
CC: kernel test robot <lkp@intel.com>, <llvm@lists.linux.dev>,
	<oe-kbuild-all@lists.linux.dev>, <linux-xfs@vger.kernel.org>
Subject: Re: [xfs-linux:test-merge 13/13] fs/xfs/xfs_file.c:746:49: error:
 too few arguments to function call, expected 4, have 3
Message-ID: <Z86zS/kT3yr4Tz5o@rli9-mobl>
References: <PSt0U3K_mmDGWaUOdQei1VdlAVGOrC5kd15x-0yg_rquOtDV_Mh9rhn6hh7E2UkGEaAkraNnR5S41kzJkAmjMg==@protonmail.internalid>
 <202503090149.Wu0ag7zs-lkp@intel.com>
 <jclah7ezuc723hjwdr3x5u57rypxafy6olq7ig43b2kawcraid@3ghad6tv23ci>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <jclah7ezuc723hjwdr3x5u57rypxafy6olq7ig43b2kawcraid@3ghad6tv23ci>
X-ClientProxiedBy: SG2PR04CA0158.apcprd04.prod.outlook.com (2603:1096:4::20)
 To DM4PR11MB5423.namprd11.prod.outlook.com (2603:10b6:5:39b::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5423:EE_|SJ2PR11MB8514:EE_
X-MS-Office365-Filtering-Correlation-Id: 038d8f40-e3f5-4dc2-799a-08dd5fb775aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?mC6RgFb5YiGuOpcHSt3EOBz2zlXvT+EigST4vfX/sKlO91ulYDonbs3aDfx+?=
 =?us-ascii?Q?OGYD4ieOvPPzYbEDuYVxL5I3ir+eR0WdH5Uw10BhjRvUBR0BIOVpt4cQE15h?=
 =?us-ascii?Q?kGVBHR7ipFq/YJKoA3ZlGOD2qsU9Lplu4YlMOxAZ0Mu/DWopPZYBvatVs1rk?=
 =?us-ascii?Q?rPqoyddRrXpEq1YYdYUPgotjEehkf2N8cVt3rf2a5p773Ie8YX7NtDo6+8st?=
 =?us-ascii?Q?J73uNMiiZnVU42YzZe6JOKOGiF4NJumXqv1dAiBHYXpX/wGbD+RsCRNPkFRM?=
 =?us-ascii?Q?c13bJoUqaFkxDC6GOqxd3MthbitTujEWYDSqqo7MqSTMhoKaBZEps6YV5pbd?=
 =?us-ascii?Q?MVMBproc8Z6zIxJWaanpxxi3QLLyJe4FjMrg0CONcwqHQdcDFYkEPJQbdGXZ?=
 =?us-ascii?Q?X9yf3iIyGTZcWssUdFhY2lzIl+Os3bEwu0nKljK9QRQUFHgOZ3bG0bhSrzRo?=
 =?us-ascii?Q?/bYzS6ddoCbWzVnV94PZqscILrZrPiyNd+d28SyxP8QH4b+hK8xe7PQoCigV?=
 =?us-ascii?Q?h3iILbC+31fTTy8C9dyhco7wEuhFBBPKZGldihDIW7Z0ZK6B63CIEYmRIhU9?=
 =?us-ascii?Q?XLcRS7BTn1ove1gLKdYeV45fKqGHzH32e25is+gXtDsRZQvrc5EKUUBuRa/0?=
 =?us-ascii?Q?GjCkokjEfmMYai+c+klN8hdKQ5+W9JGAPcI7bs7SvO8uUBjfZFyO4p/TUKCx?=
 =?us-ascii?Q?X8ovYNDTK+lz0N9zsO0bk3pe7VTgHrb6O5Z6x/ebYR4JWnofF1Yy4szhttnp?=
 =?us-ascii?Q?DC/1bVSqConSGMMZzMnDrsGFX+Y+RTF0SYx5JNDMY5ppX38CKeL05o4AwiSS?=
 =?us-ascii?Q?tKZlmqbsAWo5ojf574ishJ3dhWkeA7IbR8URLEsI/ZiAxUm4J4nTFcPQZwQN?=
 =?us-ascii?Q?UP1pJwZeybirFX5h/dlXMbDM4Gmj6OsKvFJOa04z7iXTEwIpfC4ZVrSI/Bld?=
 =?us-ascii?Q?YO6BJ/l2GSXuu5kGuaBtIdrgJ4OzmfpyJvm2G9tOiqtR61VbNZkmH4YfdMs8?=
 =?us-ascii?Q?c5MRkhF0IY0lw6qiQgOIBLg93VHBFscwlnNR6jzGhW0fwouPjmK6dBUzpJv3?=
 =?us-ascii?Q?WfNmGIWOjL1ETge2VlrAX/Ow0BHMetXBQKKIwCIP4B2mYdKY61a+bzkEWGHb?=
 =?us-ascii?Q?1YrWz0itcdtxd8WH3xvZaKIehGwwagkyEUVqZpSqBTCXggzhBjJiXFEevhRL?=
 =?us-ascii?Q?HvcvKWsYpBSFC1fhymc+sqPel94WtXN4oipSmvGGQR4ed93zEDI89LYSK0Dd?=
 =?us-ascii?Q?00lxCpxEVX2AEP/mw8NctoE0xebaXDMJY+pIWuUfE4tmcv3UUQ+7TBFZ4y7J?=
 =?us-ascii?Q?AODgQjrYE5K7KxXjhxQ3lQfzX7f/1XD/lP+SUPtAisSt0A=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5423.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0xk48BwLABScWCZ3/TMVfXDyZXKGzIfGePwMlpUGKxdT1G1C840379lPxKDI?=
 =?us-ascii?Q?mTSn1dFkT0vk4uaujNLhtTx/YTOTbtQMSgM8jKO7vFJC9/94ugkuc3xkB+Ys?=
 =?us-ascii?Q?1BPbJGhHAthLAYUR9WSyyAKS5h1VmvU6O2shAhq6+fh62aySoWrPEaYAePpc?=
 =?us-ascii?Q?W2MJnyoU3hAc0Ljn6gogb3PAe+oMcaNvr7bWM6TOJANgS3RQsjw3IBpiKrCz?=
 =?us-ascii?Q?UjT0VxON00+TJpgoc2bjS8eF/OGRLcIK2Jefz8oASaTGyry/umn3xaS3FDj9?=
 =?us-ascii?Q?e642ft7XuqWA+shrlVsAj43+7YakW3PtfwfoV1SHicAqoGSAqC2XzhKvxm3Z?=
 =?us-ascii?Q?O2ksFUy3SQ3hZx22FfUJMTQjmA5XIdCvfboH3P7T76MGeZoYcWS2OArGaZfY?=
 =?us-ascii?Q?lpPeKhppAb55murcYGOK4eJD5hA51LjVHnifdJna2Bt43/CROvYdCwmapZhP?=
 =?us-ascii?Q?7srurou5QVlyU60UvYc6pdszrTfiCjVN02TKUaSvT7ibeQ2iQfUYEjXdscRs?=
 =?us-ascii?Q?irMLl31AIOjk2XStNpVxrn7b9MfrQXRxDgDoTjw/+bMy48CRB+TQ7zovsWfa?=
 =?us-ascii?Q?zjtS7MoKvCmOiPiNDloIa4urbobwCH/5dqRotdtun1M3q1mLh5Gnk1V4YvGT?=
 =?us-ascii?Q?kGX8mMz4ckZz/J2BnS3ALVRbED1fzDrlqo5vtSHsjB4ZhxTWX4hcTM4Dg1XH?=
 =?us-ascii?Q?+do9utf1klSvinfS8AxRFLjDTf23ZaWUh3njPObl5JnRXI5GboG/Jd3kTOOF?=
 =?us-ascii?Q?tdHSV3qOUXr9cvQ/zVUxl5sW9ASI+kgMczbZQPHMU8VNjBF22n7dh0ifKt2m?=
 =?us-ascii?Q?5ABizypmEPoTbnww0gG1J4mJCUA/yh+35PousIWfwCgEX2kji1mQZAbvT+Y7?=
 =?us-ascii?Q?0/zDu9i5kXhLKM5Xh91akt59KZae+s9fFkzV35gQpN6nTyO8/jY9lvR5XbWg?=
 =?us-ascii?Q?Q/am4jmS9sy1hIcM39baHSfA5AUWAfwmmv77lMHt/kr11Frmq7HCINq5QCMr?=
 =?us-ascii?Q?+llDWHy8epWDcUP8aEn5Ar52NQgTpvCRX/YHZccFb6G4SZ0XLJQ4umQWAN0P?=
 =?us-ascii?Q?mpcJtvV6Pib6FM/hddxkW+K20xszjJW9Xm89ibA9g0ItKQxa0pWYmNVcq6eZ?=
 =?us-ascii?Q?Adj8utm6EL4fNg8bRyBi5ETH/+vHiCecGjqejnzJ8MEkQCo1jkhkebV6rbsf?=
 =?us-ascii?Q?pWZFPo0KFMGtb2+1mMv21mzP50D8SH5WDao4E8GPjEamlZUp9eWu+NCv/9nY?=
 =?us-ascii?Q?S2eAQpnCTGTTHzxotvTatxMVlZYo+gWqzCgzu8zHJ6z+FhB9+L6Q3vlz7MTU?=
 =?us-ascii?Q?q+LH5CR+gUW32F10vLOkNz4xdLEXkimAkrvVU4hShfK/f5Qx7mWQTJiViL4p?=
 =?us-ascii?Q?0nXiXMSSvoi0PZbRnSS0i8xEfYd7FzC8XxMrmlIlgR+PDYc5RREUOG3kPwJY?=
 =?us-ascii?Q?g7eT4prlvlVhz6DKV8T8BCl1MyNbuO7KrPGslzI6qFW2RmuhMUKeZmdOLfZc?=
 =?us-ascii?Q?KG7jNKBVstSKfdBit2raFkZDwKeYDbt/kqCh/4MSMYDb/+ajSf1nehatALeg?=
 =?us-ascii?Q?8A69zOXSQCeTrQq/uv4AtQE5Dg4qgEy/LerSBCcW?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 038d8f40-e3f5-4dc2-799a-08dd5fb775aa
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5423.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2025 09:39:31.7466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Xux/R035SsPvnmmD2NuXIYINwfKr7/7IJTMycsNgP/B9ZIPnMm8+Ra8yuDh1IfWOrxFcCIs2SdlL6JrVIgAtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8514
X-OriginatorOrg: intel.com

On Mon, Mar 10, 2025 at 10:21:04AM +0100, Carlos Maiolino wrote:
> On Sun, Mar 09, 2025 at 01:06:40AM +0800, kernel test robot wrote:
> > tree:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git test-merge
> > head:   fac04210bb99888fd453db09239bed27436fd619
> > commit: fac04210bb99888fd453db09239bed27436fd619 [13/13] Merge branch 'xfs-6.15-atomicwrites' into for-next
> > config: i386-buildonly-randconfig-003-20250308 (https://download.01.org/0day-ci/archive/20250309/202503090149.Wu0ag7zs-lkp@intel.com/config)
> > compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250309/202503090149.Wu0ag7zs-lkp@intel.com/reproduce)
> 
> Huh? All xfs branches are monitored? This was by no means to be tested.

thanks for the info, we will ignore this test-merge branch to avoid sending
meaningless report.

> 
> Carlos
> 
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202503090149.Wu0ag7zs-lkp@intel.com/
> > 
> > All errors (new ones prefixed by >>):
> > 
> > >> fs/xfs/xfs_file.c:746:49: error: too few arguments to function call, expected 4, have 3
> >      746 |         ret = xfs_file_write_checks(iocb, from, &iolock);
> >          |               ~~~~~~~~~~~~~~~~~~~~~                    ^
> >    fs/xfs/xfs_file.c:434:1: note: 'xfs_file_write_checks' declared here
> >      434 | xfs_file_write_checks(
> >          | ^
> >      435 |         struct kiocb            *iocb,
> >          |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >      436 |         struct iov_iter         *from,
> >          |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >      437 |         unsigned int            *iolock,
> >          |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >      438 |         struct xfs_zone_alloc_ctx *ac)
> >          |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    1 error generated.
> > 
> > 
> > vim +746 fs/xfs/xfs_file.c
> > 
> > 2e2383405824b9 Christoph Hellwig 2025-01-27  730
> > 307185b178ac26 John Garry        2025-03-03  731  static noinline ssize_t
> > 307185b178ac26 John Garry        2025-03-03  732  xfs_file_dio_write_atomic(
> > 307185b178ac26 John Garry        2025-03-03  733  	struct xfs_inode	*ip,
> > 307185b178ac26 John Garry        2025-03-03  734  	struct kiocb		*iocb,
> > 307185b178ac26 John Garry        2025-03-03  735  	struct iov_iter		*from)
> > 307185b178ac26 John Garry        2025-03-03  736  {
> > 307185b178ac26 John Garry        2025-03-03  737  	unsigned int		iolock = XFS_IOLOCK_SHARED;
> > 307185b178ac26 John Garry        2025-03-03  738  	unsigned int		dio_flags = 0;
> > 307185b178ac26 John Garry        2025-03-03  739  	ssize_t			ret;
> > 307185b178ac26 John Garry        2025-03-03  740
> > 307185b178ac26 John Garry        2025-03-03  741  retry:
> > 307185b178ac26 John Garry        2025-03-03  742  	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
> > 307185b178ac26 John Garry        2025-03-03  743  	if (ret)
> > 307185b178ac26 John Garry        2025-03-03  744  		return ret;
> > 307185b178ac26 John Garry        2025-03-03  745
> > 307185b178ac26 John Garry        2025-03-03 @746  	ret = xfs_file_write_checks(iocb, from, &iolock);
> > 307185b178ac26 John Garry        2025-03-03  747  	if (ret)
> > 307185b178ac26 John Garry        2025-03-03  748  		goto out_unlock;
> > 307185b178ac26 John Garry        2025-03-03  749
> > 307185b178ac26 John Garry        2025-03-03  750  	if (dio_flags & IOMAP_DIO_FORCE_WAIT)
> > 307185b178ac26 John Garry        2025-03-03  751  		inode_dio_wait(VFS_I(ip));
> > 307185b178ac26 John Garry        2025-03-03  752
> > 307185b178ac26 John Garry        2025-03-03  753  	trace_xfs_file_direct_write(iocb, from);
> > 307185b178ac26 John Garry        2025-03-03  754  	ret = iomap_dio_rw(iocb, from, &xfs_atomic_write_iomap_ops,
> > 307185b178ac26 John Garry        2025-03-03  755  			&xfs_dio_write_ops, dio_flags, NULL, 0);
> > 307185b178ac26 John Garry        2025-03-03  756
> > 307185b178ac26 John Garry        2025-03-03  757  	if (ret == -EAGAIN && !(iocb->ki_flags & IOCB_NOWAIT) &&
> > 307185b178ac26 John Garry        2025-03-03  758  	    !(dio_flags & IOMAP_DIO_ATOMIC_SW)) {
> > 307185b178ac26 John Garry        2025-03-03  759  		xfs_iunlock(ip, iolock);
> > 307185b178ac26 John Garry        2025-03-03  760  		dio_flags = IOMAP_DIO_ATOMIC_SW | IOMAP_DIO_FORCE_WAIT;
> > 307185b178ac26 John Garry        2025-03-03  761  		iolock = XFS_IOLOCK_EXCL;
> > 307185b178ac26 John Garry        2025-03-03  762  		goto retry;
> > 307185b178ac26 John Garry        2025-03-03  763  	}
> > 307185b178ac26 John Garry        2025-03-03  764
> > 307185b178ac26 John Garry        2025-03-03  765  out_unlock:
> > 307185b178ac26 John Garry        2025-03-03  766  	if (iolock)
> > 307185b178ac26 John Garry        2025-03-03  767  		xfs_iunlock(ip, iolock);
> > 307185b178ac26 John Garry        2025-03-03  768  	return ret;
> > 307185b178ac26 John Garry        2025-03-03  769  }
> > 307185b178ac26 John Garry        2025-03-03  770
> > 
> > :::::: The code at line 746 was first introduced by commit
> > :::::: 307185b178ac2695cbd964e9b0a5a9b7513bba93 xfs: Add xfs_file_dio_write_atomic()
> > 
> > :::::: TO: John Garry <john.g.garry@oracle.com>
> > :::::: CC: Carlos Maiolino <cem@kernel.org>
> > 
> > --
> > 0-DAY CI Kernel Test Service
> > https://github.com/intel/lkp-tests/wiki
> > 
> 
