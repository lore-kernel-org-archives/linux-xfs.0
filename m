Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689CE3DD50E;
	Fri, 22 May 2026 11:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779449192; cv=fail; b=pT5qjzWP3fvguZVLi3pwLkyDDj3oSfVoRPqIH9qnKZlzs4SiJu2jVWUzCcbAduvhY9peQvlv4VAQX4obPS8JAmV1621cvobbt7x8d2uuKHspU7D/MBhVcEzUQRvDnb6I7/XSkaJ+XwFouSMsl0RChktUSm8RF4wFUTMikvH0nL0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779449192; c=relaxed/simple;
	bh=0afhkcuh/yI20Gbm7fzDwGL1n6GBbsd9Rd6QHkI44ZU=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=SUYk9kzI2xyBnBOQ/K7YQT2PfdogjkqxpQhNUWEIcO3e4Mbpj7EN4TTvZKI3QY+C9uTbS+LUYtsTFUtbSygt3lyl7SaLjnjL8/BIn8rgn8p/AB2sz3pLx9wGQfXEvoV/EzWSpTh+s8mKjHPGvkfAHcSoim+h1LziXp7c414xmjA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=V2Y+EjJ8; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=RIwo0QQW; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="V2Y+EjJ8";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="RIwo0QQW"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779449190; x=1810985190;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=0afhkcuh/yI20Gbm7fzDwGL1n6GBbsd9Rd6QHkI44ZU=;
  b=V2Y+EjJ8WPFJU8fAznMx+R3sJYe20DclcOHhpfZgKY/s02VZS88rD7i1
   2mz7q7P7AM/40Rt7OmTyaCfCYTIa01/0HSQdrpO7zW3kilx9xf4LLjEXx
   GnXu0TNhuXvHDlTTF1QBP3Gh3coXRRDvYdOMZ2sNDaO7jF4TkEERWovyZ
   SkfZhSF+DSrBYSdKP8Rc6ifvsu6iRF315pyAgUH6vrX6/Hf8gOGB9P+OJ
   Ml8GICjH7ElrCfYf9LUVC3MQ1SX01YmJskNxdhLKIdlVMaXIcHJGtbwQl
   GVlnF+nH+C6AKs7HQpgIvlGLwtlwoS9KER94F90VWeqIuYmWweAx/Z8vr
   w==;
X-CSE-ConnectionGUID: 1/WcwgsuR42oxs9AhrNJbw==
X-CSE-MsgGUID: zlYug864QSOgRlcM6z72UA==
X-IronPort-AV: E=Sophos;i="6.24,162,1774281600"; 
   d="bad'?full'?scan'208";a="143353832"
Received: from mail-northcentralusazon11013029.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.29])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 May 2026 19:26:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CKhbTV3Zf0qbAr7TLkEa2RNC3C+NBLJy1jn4zKhAIkaWoWI05tdFcvvBMxMQw1ABBWm9rMk5bhOOCnHnVXrWg93KdKgWBrjmTpteKqqItBXET6s7oqqypzVbjYr398mI2UQVfYLVnlsi6qJAj96QphzmAbaubx6wvjKwCrWTjG0tuLFXlljoXCJA7PR5Ks9MQDPTgs8Xw38NG+Nw2bAYBb58DCz/Sq1B+oHj676Q/L3JMQhASkCcQU6/AY8jLRk9Or8nJfrBJmfr5TcFa2PFfZM12fJcXkIFs5F3VcxiWB5Z/YYXiT2LD7OXKX/AO1bcIT447zbNPOXZuxeOh5T6+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fTaIorkf+qrLX7ch0f34Jw30rQvqWY0odBnLegQajh8=;
 b=jdeUoCbWPkW5l0PpVDDLQeoeb7yPW46/MOj1lfh5HmKY5FI+baPfvimZrlXmZhcAQx28aNCbInGICb9B8Cwr/lD+Pw2mQfDGzKaPJNnkZ5NLWy1/Lr4cXPS0scfjXLDOVVPI/+TCBr+x8uKN3sH7LlBQgVclpB4ICSmgioyIo3K+4TnzFdDPIUKA3Y3nzsQwsCcmYi+C46FBaLmy4LbJ9t3gsBMiHKIe3RGVHWarO0qMYxMxepHBEynKiDH0XE+9JTV79lM3Wv8qeV3tALn9wURgnJEbFOo88Mgq2TRI1wt0rHjA+NTVFfM8rUz6T0lEWA3Hngfwj+44dvWHAx5xUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fTaIorkf+qrLX7ch0f34Jw30rQvqWY0odBnLegQajh8=;
 b=RIwo0QQWrFW35KWuira+vp73/xqfcE6KT6+B/FZgzEQ424iSyQJIHvPa2ivKPUgB/6iCqm2lijGfGrwc5DYkCiQUtRduFFZt1xmLkmWqqlGLmXGjv5J+NQY7eDxareoj2eTpgyKThINEtQaclbdx1RCx3GYiL05ZVsm3AjrcACo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14) by PH8PR04MB8660.namprd04.prod.outlook.com
 (2603:10b6:510:23b::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Fri, 22 May
 2026 11:26:19 +0000
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85]) by SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85%6]) with mapi id 15.21.0048.016; Fri, 22 May 2026
 11:26:19 +0000
Date: Fri, 22 May 2026 20:26:13 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, djwong@kernel.org
Cc: hch@lst.de
Subject: [bug report] xfs/078 failure
Message-ID: <ahA8uwU8G83YVYU8@shinmob>
Content-Type: multipart/mixed; boundary="mqsotgwkaasgl7yf"
Content-Disposition: inline
X-ClientProxiedBy: TYCP286CA0187.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:382::11) To SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR04MB10065:EE_|PH8PR04MB8660:EE_
X-MS-Office365-Filtering-Correlation-Id: 75ec4432-f132-4bce-14bb-08deb7f4f1be
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|376014|366016|6049299003|1800799024|3023799007|18002099003|56012099003|11063799006|5023799004|4053099003;
X-Microsoft-Antispam-Message-Info:
	2GQKNZ3ahN0THcqymsiby3Qr77LDFF23FYd6gc3diYsn8IvMeOb9akpMnhsn8DSnm8oeb+eJW6pM2kEWoquxz48+WQ64HCSgSaCvZck0hQNAUrB+V0fErF/+XayfQOuDmDr4qy71sozyhYU+ZyMZ+9WQzNjIoBHIbZSgnlfyoTwT4F70eNA1wQFkgNnOn6u/InX7oSwPeGyZwdj6zzANCVMxVp0KiiksY80ctZNV+H2XkJTs59b4Dq4cIGotCbm9T00FDyUozPe09UXmSwhVEKS8uvaGSQeAfnE9w7a2uCuoG850RG/nij/6R0Jemp5XYx6bOgq4Lb460X0hAyxISnZZEZBFwPhIJjDnLemy6y96cCRY1zZvzAByf7LgPNCCqZeEt6JSSPcR/rflvPT0vndBsBlwAYrYZcbFijQhPrWw1E7qLLuskjN5j00maNslxPHHDWaploIHKKAb1y/LowHMFz22YbhcHVHlxAdV50g9RQBXw9VsCefqY0f+pGzLhGmKz2IrMGhr4uZsfV+mSQgm6LskZEJZbLbcWD/I4yKb2lt7hEZJgn+Yn9x7CJYJeYFyoIFDXlDUdgNY8wkemn66wB8K1fy7uOYP9jtNezKoDO3WA2tqczAMuk3ehhqqREGRjk7VRxC6loeRjeA+/tAggdIA55yabzpdg/WvJUvsKPmRKrpEN+4TXAofgzjZ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB10065.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(366016)(6049299003)(1800799024)(3023799007)(18002099003)(56012099003)(11063799006)(5023799004)(4053099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5kVb+vU/7+d3gNQF7lUuNdCvm0o5bfWH+XhfMRiDgmiDaXe4UPZAbi+GGdyn?=
 =?us-ascii?Q?KumtSxPvTO4iAbhzuva+3YBBnaJsCdueR8QwbucC90S2B3nFpphfyc3Y+QQ1?=
 =?us-ascii?Q?C8SfxD16EaucS2j/AL9nk8uBnD5qdfINYp9jGdnIOqFPhNs616xn/+RKhjNQ?=
 =?us-ascii?Q?FqHCh/TubTNAqtXRWLdsi1Wdn4OCsI+SOl60j7dlNVG2HXjJ9upr4Wznn5WH?=
 =?us-ascii?Q?tf+hOiy4toviEH7Lsu0LFSnf5EVYznKaJ9FzPvFQUCPeyyjcrLd5/ZBbh/FO?=
 =?us-ascii?Q?NaNzTzcVN0c6/qEG3rKLchqT/7D2IsZ6wpuFCvN/2Ozwce4skcPKuTYjaCBI?=
 =?us-ascii?Q?1Yc7NKWYy8UYqZcazY5QS85TJqNpZNzz8C4yVi6IDZ0yuN4Q8R5q9lcXympK?=
 =?us-ascii?Q?1mnWk3FgdXMQMcPYv0QYOTXPssboSLFx69hKqSjYTy2iouAEk+QB97Mb2NRo?=
 =?us-ascii?Q?fEM0hicdXwnEzEYDhj/SOFhq25Lo40cfFNC9ZRJB3X69RhNOHlMLRAxrpa7f?=
 =?us-ascii?Q?78uRESiY5gZYR2guP0gVpexdq1DLXr0DNK3KTweoOQFSuqNwN5wZ5PZnzPs1?=
 =?us-ascii?Q?JxBGcbpMRTRTryAG3hJUvZ+POPYC3AJ56dRvdLf+SR415SwPVJtKxPuWyOYT?=
 =?us-ascii?Q?7vhZpM7IfBuYOQMSbkU3jCGW8HTpFdP0OA9mRyU2k0xjkTOWDAqxvqfzwNuc?=
 =?us-ascii?Q?YRAbGN94XxnScPMxWFBQG8TKS/8o2rl/1E6JHQ69HLEnxlB7Fd6klKchG35t?=
 =?us-ascii?Q?Mf8uxmZ0Pj6kj+ckVpYanD2FrKPmjywVMX2xHYRHzm3F98QmX5JwOH+5P7ph?=
 =?us-ascii?Q?AnSpqYOUU5vgx+tL7WYtGIgfCTgmxEDaRSVrwPfX2aUactVtjzfPJuxvJusw?=
 =?us-ascii?Q?t4YJtqRd/j8kStkPL9CFTMKebLGkZ5kWnge4Jwt1eeOtChQcpsChD87a4Kle?=
 =?us-ascii?Q?a7cTH+qBg+ljUgl6jipu3hSWsr3+xwtXjMCi/J0A3R6kNhsIwGMpfbmrW7jl?=
 =?us-ascii?Q?GScUgyZVGhjIbKJ58WF1WnEEjZqMIELhMMVJomZE/x8Ylyxr5E2nMX8/mHHr?=
 =?us-ascii?Q?0BsdKOYN6D6T2d8Tgh2plEwsVkWbYL3WaynwLjVxuJ+yU4X4alSLSRIxOj1d?=
 =?us-ascii?Q?hkUNTN54wIjSECytB6kRAfU04WwwbwDqIx/gl5FBmtU3HLOJmJqAlFuM3Mws?=
 =?us-ascii?Q?UIyjgyxFQePlgVmlQVF4MOfMNC4Lbme7oLgtgluCR3y8NzacZqQ97H2Q4pdM?=
 =?us-ascii?Q?gV2kJ0qlOx6dpgV7famEBlhehsGN/UAqdniBEDgUe/CmsEcq4k/6t+Ao7bFW?=
 =?us-ascii?Q?KeHOCRnKmXLfDA/Q9S8lxne3Kt8NKnqm/B0HKfPMkIVBJuDxPVhhYYfqqxOO?=
 =?us-ascii?Q?TUcg7uI+DvgxfUlM3ALloy8PA190kIHuC4dDbMjRhR61TyfGtNE7xcXEOKG2?=
 =?us-ascii?Q?/1hT9pPytodZDhtUPjXzucCs6/Npd8sdqQVQtMIUHq5PWaU2R6ClFoifopCV?=
 =?us-ascii?Q?cMDZtW8WVWjsszVums469hQM7KcTrnYU8EVCUhH0VgqFAE9ZlJAWz2/HcRZN?=
 =?us-ascii?Q?KvrAwcfj75N+YLTqkzmcP6JZsqnJZ3PD9yebv0ML/QFWQkIB8Q9YY4Qpo05C?=
 =?us-ascii?Q?9EpYRgk20XCLkHfibucbZXiehbX3TLD2Bpj37HaKXYgmoBd31WOYIZGLKrmR?=
 =?us-ascii?Q?8R/Wr6q8T1rOwbzGF+KI3qk0Fxlwvg3hLQvklD090C3Ru1x+ZW2NUttBw+gX?=
 =?us-ascii?Q?Ogm6vxNnZQKcQC6m1+iXo6bC3dxHyE8=3D?=
X-Exchange-RoutingPolicyChecked:
	L33PUOzVBA3tRa1lKrRkGi8QgOyr4mwZQyIHKfl7Tt6LzrUtLZGwPHhBjgyCdXbiK0Z7n8Vu/EOGbHyzVtLl4ITXKQyQQEM5rNQBNC0caNdJ+wYAfU9Ehe2fLvOqaT8bFOrV5QzqTCmeccQicB3WA3TSNi34gdlSeV44Fn/bnRdbFHF7lGj76+qnPnbboBLek09awU8qSMjBf7eXxZSLnQ+wP3EvCOmNycNZZKknJbFnND79d2QWcxKyIY3Mm4sjgV08Z4tNtgs4SDfOMu72RsFgRjl42I25DMeYBx/95ut24RzU4ufDJQ54AL9wLTQTlJPprJjv6jS+c5synKkbCA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zbT6DQ3pcotX4rmUflbTUDNZNxDgkPcKqTlqWJ9+cC0lZv4tM9Esmm6ErHZbI9+PcVZ2fXUXj+pTmX94Y66xxHwkdcbnAAgoMK0gJKnk+5CmHotuSLuoEvHg7PBgQkAHsQqHT//ILlKEQZe6UqTFAfsvsaYcbyo0Pm/8/3Q9dVI02Opc8Z6RASAE38H5C4G6hR7ZnL9T1dEDtxE5BmVHB9Q4IzH+eY4IeyANJbSKvHoW5ZciuV9VywDIsnGntkpvDOAHU+PA6pSL2ShsE/KNf/uE7pzwYerESC8jIchMvCramUVwjuYEpIWZ7sLhXiJa4zIWejUEOknpcpQKdtiZ5xvk3lzicWC6uqaNFSzRbQYEaoVJkvHFGtus9TBZuiivnxf/aICEkhxY54IRjqNqr6SBZw9/XL8gJg8uqp2oiSH3l3FOl/X8ubYTui8lQlCsqnZ8xVStK8y4KXnuw8io54eeaLyYmuVLiZfeAeMeRd+FwDqH+bjjaQpA4iqKmySFAJ3gsk5xWIYEdgVFpGqfF4D2kx/qL1c3ENO5LbjgG6k96I0n82v6x7aaSKcMtGUb6r9Xht2g7LPjd/N42OyuOQsIvU5B/I8jlIhLPzcu4V+XIaJkANdE/x8IecDCaQUh
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75ec4432-f132-4bce-14bb-08deb7f4f1be
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB10065.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2026 11:26:18.9697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1XejZeO3Q+M4MY311uJaKxOKAJ4GVeMoRfwaWJDpAyFM24BMyhpXzw5g1pcEu8KvXodv7puq1mvYLj03PfDsIbG4IV12/QV2DUcoexhv7zc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR04MB8660

--mqsotgwkaasgl7yf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

I found xfs/078 failure with null_blk devices [1]. When I saw the failure for
the first time, it was observed with regular null_blk with 8GB size with 512
bytes sector size. Later on, I was able to recreate with,

 - both zoned and non-zoned
 - both 512 byte sector and 4KB sector
 - device size from 1GB to 8GB

The failure was recreated on QEMU VM test nodes. When I reduce the number of
CPUs assigned to the VM, the test case succeeded. With larger number of CPUs,
the test case failed.

  nproc   |  16  |   8  |   2  |   1
 ---------+------+------+------+------
  xfs/078 | fail | fail | pass | pass

I attach 078.dmesg, 078.full and 078.out.bad for your reference. Actions for fix
will be appreciated. If I can do anything on my testnodes, please let me know.

[1] local.config, command line and outputs

$ cat ./local.config
export TEST_DIR=/var/kts/test
export TEST_DEV="/dev/nullb0"
export KEEP_DMESG=yes
export FSTYP=xfs
export MKFS_OPTIONS=""
export SCRATCH_MNT=/var/kts/scratch
export SCRATCH_DEV="/dev/nullb1"
export FSX_AVOID=-a
$ sudo mkfs.xfs /dev/nullb0
meta-data=/dev/nullb0            isize=512    agcount=4, agsize=524288 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=1   metadir=0
data     =                       bsize=4096   blocks=2097152, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
         =                       rgcount=0    rgsize=0 extents
         =                       zoned=0      start=0 reserved=0
$ sudo ./check xfs/078
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 redsun71q 7.1.0-rc1-kts-xfs-g509fdeb3326+ #1 SMP PREEMPT_DYNAMIC Fri May 15 20:16:28 JST 2026
MKFS_OPTIONS  -- -f /dev/nullb1
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/nullb1 /var/kts/scratch

xfs/078            - output mismatch (see /home/shin/kts/kernel-test-suite/src/xfstests/results//xfs/078.out.bad)
    --- tests/xfs/078.out       2026-05-18 14:56:44.108307737 +0900
    +++ /home/shin/kts/kernel-test-suite/src/xfstests/results//xfs/078.out.bad  2026-05-22 20:16:11.735184759 +0900
    @@ -188,6 +188,6 @@
     *** mount loop filesystem
     *** grow loop filesystem
     xfs_growfs --BlockSize=4096 --Blocks=268435456
    -data blocks changed from 268435456 to 4194304001
    +data blocks changed from 268435456 to 4194304000
     *** unmount
     *** all done
    ...
    (Run 'diff -u /home/shin/kts/kernel-test-suite/src/xfstests/tests/xfs/078.out /home/shin/kts/kernel-test-suite/src/xfstests/results//xfs/078.out.bad'  to see the entire diff)
Ran: xfs/078
Failures: xfs/078
Failed 1 of 1 tests

--mqsotgwkaasgl7yf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="078.dmesg"

[346638.550194] [  T32208] run fstests xfs/078 at 2026-05-22 20:15:44
[346642.710896] [  T33162] loop0: detected capacity change from 0 to 1344192
[346643.022555] [    T877] I/O error, dev loop0, sector 0 op 0x1:(WRITE) flags 0x800 phys_seg 0 prio class 2
[346643.055173] [  T33175] loop0: detected capacity change from 0 to 2688392
[346643.144484] [  T33177] XFS (loop0): Mounting V5 Filesystem 746f0e35-30af-4136-b531-73e95ad87a3c
[346643.203081] [  T33177] XFS (loop0): Ending clean mount
[346643.338548] [  T33191] XFS (loop0): Unmounting Filesystem 746f0e35-30af-4136-b531-73e95ad87a3c
[346644.011082] [  T33454] loop0: detected capacity change from 0 to 672096
[346644.368598] [  T33466] loop0: detected capacity change from 0 to 2688388
[346644.470308] [  T33468] XFS (loop0): Mounting V5 Filesystem cc06080b-270c-4433-8dad-a753fdbddec6
[346644.525640] [  T33468] XFS (loop0): Ending clean mount
[346644.734001] [  T33482] XFS (loop0): Unmounting Filesystem cc06080b-270c-4433-8dad-a753fdbddec6
[346645.477586] [  T33825] loop0: detected capacity change from 0 to 336048
[346645.739019] [    T325] I/O error, dev loop0, sector 0 op 0x1:(WRITE) flags 0x800 phys_seg 0 prio class 2
[346645.790943] [  T33837] loop0: detected capacity change from 0 to 1344202
[346645.891977] [  T33838] XFS (loop0): Mounting V5 Filesystem b54ad8c9-18b8-42c2-ad83-9be584f2c84a
[346645.931163] [  T33838] XFS (loop0): Ending clean mount
[346646.162087] [  T33852] XFS (loop0): Unmounting Filesystem b54ad8c9-18b8-42c2-ad83-9be584f2c84a
[346646.827080] [  T34195] loop0: detected capacity change from 0 to 2147483648
[346647.612577] [  T34208] loop1: detected capacity change from 0 to 5242880008
[346647.623323] [    T586] I/O error, dev loop0, sector 0 op 0x1:(WRITE) flags 0x800 phys_seg 0 prio class 2
[346647.721646] [  T34210] XFS (loop1): Mounting V5 Filesystem 86a92b03-765d-4e48-8329-4c4e03faf40c
[346647.770548] [  T34210] XFS (loop1): Ending clean mount
[346648.067951] [  T34225] XFS (loop1): Unmounting Filesystem 86a92b03-765d-4e48-8329-4c4e03faf40c
[346648.150529] [      C0] clocksource: Watchdog remote CPU 10 read timed out
[346648.295566] [  T34233] loop0: detected capacity change from 0 to 2147483648
[346649.178443] [  T34246] loop0: detected capacity change from 0 to 7340032008
[346649.272214] [  T34247] XFS (loop0): Mounting V5 Filesystem 386bf672-1e2e-45c2-918d-2bd8e2710011
[346649.341180] [  T34247] XFS (loop0): Ending clean mount
[346649.714697] [  T34261] XFS (loop0): Unmounting Filesystem 386bf672-1e2e-45c2-918d-2bd8e2710011
[346649.949635] [  T34269] loop0: detected capacity change from 0 to 2147483648
[346650.819597] [  T34282] loop1: detected capacity change from 0 to 9437184008
[346650.834446] [   T1008] I/O error, dev loop0, sector 0 op 0x1:(WRITE) flags 0x800 phys_seg 0 prio class 2
[346650.929310] [  T34284] XFS (loop1): Mounting V5 Filesystem ad2552a4-4051-48b3-86af-0b9edfe28bb0
[346650.989257] [  T34284] XFS (loop1): Ending clean mount
[346651.486306] [  T34297] XFS (loop1): Unmounting Filesystem ad2552a4-4051-48b3-86af-0b9edfe28bb0
[346651.647242] [    T586] I/O error, dev loop1, sector 0 op 0x1:(WRITE) flags 0x800 phys_seg 0 prio class 2
[346651.709163] [  T34305] loop0: detected capacity change from 0 to 2147483648
[346652.577727] [  T34318] loop0: detected capacity change from 0 to 11534336008
[346652.677599] [  T34319] XFS (loop0): Mounting V5 Filesystem 766eb1b8-e80f-4ad6-ac35-c98cc6fd4195
[346652.734701] [  T34319] XFS (loop0): Ending clean mount
[346653.283152] [  T34333] XFS (loop0): Unmounting Filesystem 766eb1b8-e80f-4ad6-ac35-c98cc6fd4195
[346653.507118] [  T34341] loop0: detected capacity change from 0 to 2147483648
[346654.329581] [  T34354] loop1: detected capacity change from 0 to 17825792008
[346654.343237] [    T769] I/O error, dev loop0, sector 0 op 0x1:(WRITE) flags 0x800 phys_seg 0 prio class 2
[346654.426162] [  T34356] XFS (loop1): Mounting V5 Filesystem d60fa45a-6533-474d-baad-72b19ae6f2d3
[346654.480317] [  T34356] XFS (loop1): Ending clean mount
[346655.388320] [  T34370] XFS (loop1): Unmounting Filesystem d60fa45a-6533-474d-baad-72b19ae6f2d3
[346655.601878] [  T34378] loop0: detected capacity change from 0 to 2147483648
[346656.427245] [  T34392] loop1: detected capacity change from 0 to 19922944008
[346656.521749] [  T34394] XFS (loop1): Mounting V5 Filesystem c4780098-6c34-4553-ae2c-837f4b6d2c8d
[346656.567558] [  T34394] XFS (loop1): Ending clean mount
[346657.505756] [  T34408] XFS (loop1): Unmounting Filesystem c4780098-6c34-4553-ae2c-837f4b6d2c8d
[346657.727715] [  T34416] loop0: detected capacity change from 0 to 2147483648
[346658.433332] [  T34429] loop1: detected capacity change from 0 to 32505856008
[346658.450508] [    T768] I/O error, dev loop0, sector 0 op 0x1:(WRITE) flags 0x800 phys_seg 0 prio class 2
[346658.530546] [  T34431] XFS (loop1): Mounting V5 Filesystem ebfe392b-8c01-4080-9174-fd1ff3ba0a72
[346658.597583] [  T34431] XFS (loop1): Ending clean mount
[346660.061005] [  T34444] XFS (loop1): Unmounting Filesystem ebfe392b-8c01-4080-9174-fd1ff3ba0a72
[346660.305255] [  T34452] loop0: detected capacity change from 0 to 2147483648
[346661.064456] [  T34465] loop1: detected capacity change from 0 to 33554432008
[346661.077366] [    T325] I/O error, dev loop0, sector 0 op 0x1:(WRITE) flags 0x800 phys_seg 0 prio class 2
[346661.168596] [  T34467] XFS (loop1): Mounting V5 Filesystem ee62fee9-3c2e-4f9f-9f7d-81d108f36128
[346661.222539] [  T34467] XFS (loop1): Ending clean mount
[346662.772152] [  T34482] XFS (loop1): Unmounting Filesystem ee62fee9-3c2e-4f9f-9f7d-81d108f36128
[346665.103767] [  T34652] XFS (nullb0): Unmounting Filesystem 9d6146a4-9265-4658-a98c-d11b0cf45328
[346665.500646] [  T34860] XFS (nullb0): Mounting V5 Filesystem 9d6146a4-9265-4658-a98c-d11b0cf45328
[346665.527151] [  T34860] XFS (nullb0): Ending clean mount

--mqsotgwkaasgl7yf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="078.full"

umount: /var/kts/test/078.mnt: not mounted.
umount: /dev/nullb1: not mounted.

--mqsotgwkaasgl7yf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="078.out.bad"

QA output created by 078
*** create loop mount point

=== GROWFS (from 688226304 to 1376452608, 4096 blocksize)

*** mkfs loop file (size=688226304)
meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
data     = bsize=XXX blocks=XXX, imaxpct=PCT
         = sunit=XXX swidth=XXX, unwritten=X
naming   =VERN bsize=XXX
log      =LDEV bsize=XXX blocks=XXX
realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
*** extend loop file
wrote 4096/4096 bytes at offset 1376452608
*** mount loop filesystem
*** grow loop filesystem
xfs_growfs --BlockSize=4096 --Blocks=168024
data blocks changed from 168024 to 336048
*** unmount
*** check

=== GROWFS (from 344113152 to 1376452608, 2048 blocksize)

*** mkfs loop file (size=344113152)
meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
data     = bsize=XXX blocks=XXX, imaxpct=PCT
         = sunit=XXX swidth=XXX, unwritten=X
naming   =VERN bsize=XXX
log      =LDEV bsize=XXX blocks=XXX
realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
*** extend loop file
wrote 2048/2048 bytes at offset 1376452608
*** mount loop filesystem
*** grow loop filesystem
xfs_growfs --BlockSize=2048 --Blocks=168024
data blocks changed from 168024 to 672096
*** unmount
*** check

=== GROWFS (from 172056576 to 688230400, 1024 blocksize)

*** mkfs loop file (size=172056576)
meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
data     = bsize=XXX blocks=XXX, imaxpct=PCT
         = sunit=XXX swidth=XXX, unwritten=X
naming   =VERN bsize=XXX
log      =LDEV bsize=XXX blocks=XXX
realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
*** extend loop file
wrote 1024/1024 bytes at offset 688230400
*** mount loop filesystem
*** grow loop filesystem
xfs_growfs --BlockSize=1024 --Blocks=168024
data blocks changed from 168024 to 672096
*** unmount
*** check

=== GROWFS (from 1t to 2500g, 4096 blocksize)

*** mkfs loop file (size=1t)
meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
data     = bsize=XXX blocks=XXX, imaxpct=PCT
         = sunit=XXX swidth=XXX, unwritten=X
naming   =VERN bsize=XXX
log      =LDEV bsize=XXX blocks=XXX
realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
*** extend loop file
wrote 4096/4096 bytes at offset 2684354560000
*** mount loop filesystem
*** grow loop filesystem
xfs_growfs --BlockSize=4096 --Blocks=268435456
data blocks changed from 268435456 to 655360001
*** unmount

=== GROWFS (from 1t to 3500g, 4096 blocksize)

*** mkfs loop file (size=1t)
meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
data     = bsize=XXX blocks=XXX, imaxpct=PCT
         = sunit=XXX swidth=XXX, unwritten=X
naming   =VERN bsize=XXX
log      =LDEV bsize=XXX blocks=XXX
realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
*** extend loop file
wrote 4096/4096 bytes at offset 3758096384000
*** mount loop filesystem
*** grow loop filesystem
xfs_growfs --BlockSize=4096 --Blocks=268435456
data blocks changed from 268435456 to 917504001
*** unmount

=== GROWFS (from 1t to 4500g, 4096 blocksize)

*** mkfs loop file (size=1t)
meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
data     = bsize=XXX blocks=XXX, imaxpct=PCT
         = sunit=XXX swidth=XXX, unwritten=X
naming   =VERN bsize=XXX
log      =LDEV bsize=XXX blocks=XXX
realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
*** extend loop file
wrote 4096/4096 bytes at offset 4831838208000
*** mount loop filesystem
*** grow loop filesystem
xfs_growfs --BlockSize=4096 --Blocks=268435456
data blocks changed from 268435456 to 1179648001
*** unmount

=== GROWFS (from 1t to 5500g, 4096 blocksize)

*** mkfs loop file (size=1t)
meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
data     = bsize=XXX blocks=XXX, imaxpct=PCT
         = sunit=XXX swidth=XXX, unwritten=X
naming   =VERN bsize=XXX
log      =LDEV bsize=XXX blocks=XXX
realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
*** extend loop file
wrote 4096/4096 bytes at offset 5905580032000
*** mount loop filesystem
*** grow loop filesystem
xfs_growfs --BlockSize=4096 --Blocks=268435456
data blocks changed from 268435456 to 1441792001
*** unmount

=== GROWFS (from 1t to 8500g, 4096 blocksize)

*** mkfs loop file (size=1t)
meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
data     = bsize=XXX blocks=XXX, imaxpct=PCT
         = sunit=XXX swidth=XXX, unwritten=X
naming   =VERN bsize=XXX
log      =LDEV bsize=XXX blocks=XXX
realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
*** extend loop file
wrote 4096/4096 bytes at offset 9126805504000
*** mount loop filesystem
*** grow loop filesystem
xfs_growfs --BlockSize=4096 --Blocks=268435456
data blocks changed from 268435456 to 2228224001
*** unmount

=== GROWFS (from 1t to 9500g, 4096 blocksize)

*** mkfs loop file (size=1t)
meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
data     = bsize=XXX blocks=XXX, imaxpct=PCT
         = sunit=XXX swidth=XXX, unwritten=X
naming   =VERN bsize=XXX
log      =LDEV bsize=XXX blocks=XXX
realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
*** extend loop file
wrote 4096/4096 bytes at offset 10200547328000
*** mount loop filesystem
*** grow loop filesystem
xfs_growfs --BlockSize=4096 --Blocks=268435456
data blocks changed from 268435456 to 2490368001
*** unmount

=== GROWFS (from 1t to 15500g, 4096 blocksize)

*** mkfs loop file (size=1t)
meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
data     = bsize=XXX blocks=XXX, imaxpct=PCT
         = sunit=XXX swidth=XXX, unwritten=X
naming   =VERN bsize=XXX
log      =LDEV bsize=XXX blocks=XXX
realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
*** extend loop file
wrote 4096/4096 bytes at offset 16642998272000
*** mount loop filesystem
*** grow loop filesystem
xfs_growfs --BlockSize=4096 --Blocks=268435456
data blocks changed from 268435456 to 4063232001
*** unmount

=== GROWFS (from 1t to 16000g, 4096 blocksize)

*** mkfs loop file (size=1t)
meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
data     = bsize=XXX blocks=XXX, imaxpct=PCT
         = sunit=XXX swidth=XXX, unwritten=X
naming   =VERN bsize=XXX
log      =LDEV bsize=XXX blocks=XXX
realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
*** extend loop file
wrote 4096/4096 bytes at offset 17179869184000
*** mount loop filesystem
*** grow loop filesystem
xfs_growfs --BlockSize=4096 --Blocks=268435456
data blocks changed from 268435456 to 4194304000
*** unmount
*** all done

--mqsotgwkaasgl7yf--
