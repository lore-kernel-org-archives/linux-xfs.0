Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03293423EA2
	for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2026 06:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789626662; cv=fail; b=M/so70hLEdpXA49OlU+dZc+W7F0FADg/Moz2hYoW/nbWZrzNMFASRhb8cI5L/YAXVLqCPCKhzFeE2hk/0YYCD/0vF0M2DYt53iGdb20J53oPmGmJrmFvY/Z3fWjx8dIVBvrhjpcOQnw/Ur+IccL8xfD6+WqX+fsmpoauC2/hek8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789626662; c=relaxed/simple;
	bh=pKoSh593SsR1ZZdRIj8zcgIohFR7RljVigcBS0pQ9QA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rhCp8NYmQVtKrei/UFLCae7Fs4wZCv2zH6sQQFmnnKYSmUkbmvJ+DKP2lo1+jUNgtLC9JhGsm0ppcFMv50+Nj+tspwGdPZDvMh5zSAr/i9x8gD8U89jr3ODtVFmXmchoIXuLz/hCkNeQXZtIfTX5bKCD/+pSWLFJKwO0EVTrnXw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=nB9rLrH1; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=cqKhP5vh; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="nB9rLrH1";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="cqKhP5vh"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1789626659; x=1821162659;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=pKoSh593SsR1ZZdRIj8zcgIohFR7RljVigcBS0pQ9QA=;
  b=nB9rLrH1AsW1LVZcmF9gyyJrETe4J3mihwnC3dZ3u9OWnienuD2zUmfg
   f3R6Mhk7UFlpOdWvdISSF3oNOvnbXMw1Pxp+3TCYpufCBXwkCkuMxdiTs
   mLVtOhMsNDYDXyFTZNa4tJCGsiVsOvFQSPSuYJT0l7qs7gxnoBD6/2TBF
   YKIrYsVxhX1KJ01iJrU91w7sAfUQXyWks66RXzHOgp9IQ8soh0UgFVLTh
   sCGLiovyzAPWGlQL+pmV/hZbtjTbkf+S0gNDxU5idWNBZZ4ty5w5OrSIP
   eJUklxhCCXoHxh5ql+FXot16cHUu14OLOhuYxzukNjoEqYlDwFaZlclU6
   g==;
X-CSE-ConnectionGUID: +UoZhDzWSVerAfCi+3CZSg==
X-CSE-MsgGUID: QYD6JncEQYO5so5rIJX9YQ==
X-IronPort-AV: E=Sophos;i="6.27,103,1786982400"; 
   d="scan'208";a="156808703"
Received: from mail-southcentralusazon11012011.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.195.11])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Sep 2026 14:30:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EZqmCDt3TDkOxliq9gwWsDqdnEaSASmJvyiEMA6x138RU4NtALR5L4rt0Ix4d8stDm0BxIrMc9QOhPC3/t8eVlyKkgSGyiiuTHvFA33p3k8/BIxQBqGfLbarqJmWcqzofmWI41YWXn/eYx4l8PpMZ3DTj/bo4uNMMhPFcLRM0t6RHKy1HAJbJNqfD+gqnjFsJH4vy4H0tS42Cbd3ldLu2/FVBqFIlgYLvTZQHhFwvplZBLKQC6G5SNd5YQUdyfzFPd9mK9hfuAgxxabCLxoLQzMXrzZT7bNgQUKRUk+snJNQY3TYuN+TszlBaLPqIBW5/vcal/MMFGn7GapNfvVfAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P6rihmJyPyUJbohR5IY9HoGzvizBqoKBU/FLxGC8+JI=;
 b=h5ZOZ9R69zculbLH1uL9zbvwgHum1rtRVUzJU6zSJZZSjBVmqfbsYbPaPRKwldAVvbfsi/R4lKs8d089Ajz3QACtNbZLLjZTYMZDAAvBM9EBgBPQG7P6xZBfBSw47fl4kGa1T6lmG+FefFemTpVBOmgXv0ckAdTDpxh9GipJ1S7sl0+97vP8Hnu/uyaJ6Ti13p9ioVgg63nmojwGdb5ks8iRMrLvUWk2sOphi/SbNGJt2gcU9Fzj12K7qJ82PzJD9EPqKsseKodHRFahKSw/fPjayQsoAJGFSTNAn3l3RqICB9LIIGXs6Rc+kuzT4SjhrCOKHA68ikli2CNIPLx5HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P6rihmJyPyUJbohR5IY9HoGzvizBqoKBU/FLxGC8+JI=;
 b=cqKhP5vh+QQlv5c9OIP6RhMTZDlbxgwKDJacV1b8bl8TbyaEf/2KFHiz66zcmo/NramBnnomlta2vGcJJTyS7cxPhOcZKwZEUpb82jPxVDRzlfdaz34hHuZyg3dz/n5Uz5mn35x5QBaioc9Ix199gUAfuaC/DRJD3bkTVDhhIYY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from DS3PR04MB10053.namprd04.prod.outlook.com (2603:10b6:8:38f::5)
 by CH0PR04MB8049.namprd04.prod.outlook.com (2603:10b6:610:f5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.12; Thu, 17 Sep
 2026 06:30:51 +0000
Received: from DS3PR04MB10053.namprd04.prod.outlook.com
 ([fe80::faeb:7524:f842:9f3a]) by DS3PR04MB10053.namprd04.prod.outlook.com
 ([fe80::faeb:7524:f842:9f3a%4]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 06:30:51 +0000
Date: Thu, 17 Sep 2026 15:30:35 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: John Garry <john.g.garry@oracle.com>
Cc: John Garry <john.garry@linux.dev>, 
	"Darrick J. Wong" <djwong@kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [bug report] fstests generic/774 hang again
Message-ID: <aquIXRz0tq7K4xPQ@shinmob>
References: <aqkP9CTUvlC2YCIb@shinmob>
 <98190f62-ccc3-49df-934d-f168e293c485@linux.dev>
 <aqkv-2opTlWD6bzU@shinmob>
 <ed224f94-f605-4be0-8a0a-0b3d481e46ae@linux.dev>
 <20260915145046.GC2705364@frogsfrogsfrogs>
 <db4ab609-af16-4c5d-aa98-c0655625a2df@linux.dev>
 <9bf23063-e6e5-4595-8ff9-27383c99e5a6@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9bf23063-e6e5-4595-8ff9-27383c99e5a6@oracle.com>
X-ClientProxiedBy: TYCP286CA0318.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3b7::6) To DS3PR04MB10053.namprd04.prod.outlook.com
 (2603:10b6:8:38f::5)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR04MB10053:EE_|CH0PR04MB8049:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a329d68-af80-4d6e-4e05-08df148537f7
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|19092799006|23010399003|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	0vrJRTSPq4jD3e8I6FbMQfQz0tbQu31B5SLuFqTcy7NnGW6SWq6bN4V7iCFdoU6quqHH3yNSYKUg8kHIQXS7qe/DO/VS2FV6qAiNLTPMiirJP3t6Atv88aGgd2N41+CK9e7oObXqEP8rrOXS0JXGlmVHzpdxvXAxZvR7W1fPac7uFmsvwhHdvLzan5MO9be8nycxRU4ee1n4B/kc+f0DBGnEeZmhdwLkqY6i1/6eDmKZ1Yvs5VW1L3tSBZ3cYDltlbtWotGkkseaRV8byPXNINfcqyz/kyV02xjHTXpFZlfQ8aREX79lAq6XVxlm3dMsZeeczmURN1ic9nRCKlDOyJhO1IEAySuksE/kMZ02y1LyQ3VpnUIYVvzpdYO+6RsH3UrSSyIx+rxBn4BHlLAcbrIN97fpf4cU7YzQn1ZomGTjGX06ePDtN+q5UCaqgkXHxCte6yEsgNkyDsoPM1G7YFK4ozOQ/4/taNsmQuKh8FhPpgm/uum4zq8QjVbYYjWBKP6BMnQCF6NBZopwxNKlJ+ZGft73ZF1T6IqCXnxQsqQCSH+c7suNBnZCQL2f7flk+I6Cs9KsMeIEwHBAV/BII9RB7WugfvMMzdmzBIOxZTzh8zKBup/5irdyANRDBmt1jCjcxlKeXszyQoHLooaHAFvc2KKtXno05Xbfj/wIsUg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR04MB10053.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(19092799006)(23010399003)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yuuo5hwVAeZQpjSGpb1G+Nl4uzUArnW+36GJ7Bql8Jt4g4YjNQoCq4OK4xE/?=
 =?us-ascii?Q?77EN1Hp7pgzcN+XArfoq6CCJOrRyaNS4aBdJJ10tdU3ia4BcP43hXaSc8OwM?=
 =?us-ascii?Q?DCocF1Km9y1DZ0ZV4aBlr8MN++D4CK1htIv6r/GER9UUIU+TDItnIhS+mjoS?=
 =?us-ascii?Q?vN9cTcR74FBAXLNCM3NSNEqNirYAOXr3ZiwnlMmbTdqUKFEtthOrpUvcC0Qm?=
 =?us-ascii?Q?RaLVLbLFxnWukujBcIhYPo+3W7QaVxyu4uiFhfJwxil7k603lgfiGmruEDAh?=
 =?us-ascii?Q?FGSu9N5Qao250qgd4br30RF+c7J3/kHRQ43AvwG479HDZGmSbmag2gjB17Hs?=
 =?us-ascii?Q?Im8MYweoM9HNwIwbkfiAxEGaG2bFBnl9fz0CmJpQAboV2RzBCjS+F7D2hCQy?=
 =?us-ascii?Q?74JLktH/wyRgJu2xg//P8/o/ldvDSEWibv4bTd+c7/+GLtJe/swqq8ekh0Cc?=
 =?us-ascii?Q?0vj3SbDQf1lryL/AH246YcO4yDeaJA9jjw+WQfyNDSrJMp/rrpcPA6fUdGA5?=
 =?us-ascii?Q?aev5VIa0P7ruvwhu/uhww/Tsi6fkWtVTCYyLcWkGpgsGMC9ym9e1Bn0XGCYE?=
 =?us-ascii?Q?lSzrkWwgzKUPSnXDUr4O0s96DFfTvw+R0MIaex3Shz7+CCyZZZF/GkZJwaPy?=
 =?us-ascii?Q?R8rURqBW5+BGzcexLh0t4H074N6YnIq2GGN3NY0zlKOanV4/OBsJvm22KOdN?=
 =?us-ascii?Q?0CTOsrBBNq8fYwXhK0eQzoN52J4vo6PdbDfKe+KS10GEqGg09lpYgaSue5b8?=
 =?us-ascii?Q?2zMQwnRfK1ss3BojW2jXyIEg2pG+peQWg9902ztaCped3hMvLweoEoeSVfpe?=
 =?us-ascii?Q?N6B0TYu22p68CN9Qb+ZWvYdZCJvryGzhKdLme5fvADzuWqPOE2lZRYuGVw1F?=
 =?us-ascii?Q?3vNdcCzJpDOSOgw1kFQNzerqgpa//OxnGe5ReNKat16E47JbBzJnex9CyBBb?=
 =?us-ascii?Q?1//qtgLyUix6rIzTsyojzJea9/a7Yt2Bk60ciqNpING2ofPf6nu/pJkH7hl/?=
 =?us-ascii?Q?4mZk+PGTc8RrMtyYwQza00LMr7PiqRz80/+DxzqQZrgi1OtXLIs6zZAtmfrj?=
 =?us-ascii?Q?0AGvdcxqKk3WyXz6blr4vJc3vNFWgabn7kg7W47tR4gC5dwC35zjgzjxZXJI?=
 =?us-ascii?Q?OzxXZkRRGOSfG2NDACNSFdCpW/lrOsgLtxGfwLyyzIS9Unp3S9iLK0o4ADrr?=
 =?us-ascii?Q?We/cpto9B9GgO6RidwanTi76+eTIByo8VsNkwUpTKnvwe3K4I5fXKrI7q6dM?=
 =?us-ascii?Q?JRfcJugpVg82yZZEmyENGhnKYIBVNjDGTd3dInU4A9An8BMACydFWm2rDRRX?=
 =?us-ascii?Q?dRs68OmJuRvn2dKGiiemWE1eXuQyzdEs6QKcCoAkIfmNNVfIk9dUF+yX45Cj?=
 =?us-ascii?Q?mh5nff/LGHEWWLjVZkYVJ2e5fCRKxQzw6M+AYpuaDun/HeI3IEMCDNe9aehL?=
 =?us-ascii?Q?H5l+WXka9xjiytQCFxhnTGb8vhEy1Enfblo4LVM2cb+Nm/Ccbze6rwrc3WUj?=
 =?us-ascii?Q?0wLpIfznH48f0WrRvt1z4Qm9+69jRMF1EbUFfJ0pZvyyj+rRbfFXRAFHiKd+?=
 =?us-ascii?Q?dhzdSCzbU2oJ0qwTBDRrNBhjJqJ96sTKVUCjvvs0hSAabIpEP8jNg3c9vHD1?=
 =?us-ascii?Q?0AHtDGEtdnlKMu2+b8/Ldgp0H+GJRyNU3rvIScsf6UPrUeOLtYSQUeDWNYMp?=
 =?us-ascii?Q?rciDc7xrSlBRWnwzc6aTke+nuTxldJFK6vRlBea8xpvUQeO5kNgLO7mKXDWB?=
 =?us-ascii?Q?o9qqG8Hko8tdAKmkUuL+7bBM3Aq/WNw=3D?=
X-Exchange-RoutingPolicyChecked:
	QA0CTmGO2uqs8iPMNaeQ0zLjpsgDxSz0XRhkuTglr6j5Gedn9agYDwlQppdJnzfYPxp7ugmd3hr7EXz9aIJHOPVXd1dgOEIwXz20PkDZHRvbEguNPuSCKeNp5Cl6DSA/FqKpynaIlCzdJLyURNesJhVsskN3//2CAR1yLJxwzYk1Q5AKuR166Ic+mnQrMfIs1h8dsKwgwFYAMSPI1/jXJNT9G9ehnjTvLB5ehTAhFD0o26lV6o1TBUGiAUBhLLxk/4Yh0HfzyF1I4b1tCcDqKmqOn6OE71xv3aws7n+cNqJQl7fDtHcDBzkFqPzFUsyJ0YC1yWZvM0Ol7eY/mgWR+A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	N8f/nFy/71vigOj/q7LuQLrm8yvcfz65+Rxm94t+vXa5AzG8Xcy2+HwSH32F4AHz092rOcexBiLyRS5ANZ65RNjr3IO9gr9tgBnRchaTd54inJI5DRm88QsKXzw6H7VnU9exstjWywWhj06AFsZobeYafqPGvJ2BYt2n3xLcXowuNsLxmMjgRCPRMTsjMTVS6UKmgkpudY1yeu191UMG7LosVVWuyUzIYFT1GKEI5HyiCyAwmjq76xi0OuTgBZuIZIxZFEggVxZSgsHWG80mEIb2TBoeSQCJe0bnDB0inrGm0+Ir+SCpD+aWcpMAzk7vn5rWjIdIz4z8id8NY3fa7Y81g9FpQk1fvFT3A9awnRt7xoHWg5yd226SG6GmQNvRnGCBRKOAK20GT1TtF5tuXBu0RgdUYKfKvvCVdbSIG7VdnaVT7ABitno5aas61k/VNQ+CAcDuvai2QRHZBL5dIfDjU9HsLpihMVEqPDaK9BWV2Q7Ob9UDruTmoKMj7inet7MnFYvu6I9nNLXJy8uLPtEuuw8t5rkHDjU5CCJKuaWC4FHPo2yfJM3f39v/HSP+yvfhy10cLQ+fJLuY4jzG73M79GAGfKDFLy2WfPlZgnq6sMf3c2FN/801z7WKHeyh
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a329d68-af80-4d6e-4e05-08df148537f7
X-MS-Exchange-CrossTenant-AuthSource: DS3PR04MB10053.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 06:30:51.3436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mixEx+wGza1MxgMhaZp5WdZtUv7K2aussFPrXDlPLNwtRABMcZP2kvctdOxaCYlJQxBeaenJ6ofUGRHVeYB9wnulu5dPlaARZWS5gNqmkpI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB8049

On Sep 16, 2026 / 11:23, John Garry wrote:
[...]
> We could try something like this:
> 
> ----8<------
> 
> [PATCH] xfs: serialize CoW-based atomic writes
> 
> We have had reports of system hangs when testing Cow-based atomic writes
> for large block sizes.
> 
> Analysis has shown large contention on the the per-inode ilock,
> superficially in creating the mapping in
> xfs_atomic_write_cow_iomap_begin().
> 
> Serialize atomic writes to reduce this contention. In some cases this may
> reduce performance, but high performance has not been a requirement so far
> for CoW-based atomic writes.
> 
> Signed-off-by: John Garry <john.garry@linux.dev>
[...]
> ---->8------
> 
> This is far from ideal, but I think that it should stops the hangs - having
> the kernel hang is intolerable.

Thanks. I applied the patch on top of xfs/for-next branch commit 0ca15a1a1151,
then repeated the test case 100 times on top of the kernel. I did not observe
the hang. This patch looks avoiding the hang.

