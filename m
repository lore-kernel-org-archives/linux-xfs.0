Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC428233944;
	Fri, 19 Jun 2026 01:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781834258; cv=fail; b=TPdp/2XgMuL51bTVm5xnq1S10IB+LCOhX3Mh8mpxpqU9SbPj9GmO+zHf597fKIkaCL6y9KiU8DCmVsTSUmcMhF7TyKV+mNHjGv7ynDdk9mZ0Y5XKgU2ogWYvuyQCOGtEx+fegEUxNyNR96KSTBT8aTOzgr2TNQNkavHLHwpW1Ys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781834258; c=relaxed/simple;
	bh=2kp+FLcz5uIkb43GnKKz0HplD3MtINrOXbpaB/cDrAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=d/36/Y9Rx/Ipe1mwZfQxX5jFG2mL3i/aZhW/JP6V0q+vJcPvdeDON9VOe3uWNEW802adSjGkmDIAsQme5/6EpL8OlyVbzVkNW+YYBZr1lCqN2mN3yw9B5hV9b2j2AI+zXxp7wHjOsODjnEqiY/IQ3zUFRejjCAAaS4ul/dISJD4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=GEehOzer; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=B0hKI4Nz; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="GEehOzer";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="B0hKI4Nz"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781834257; x=1813370257;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=2kp+FLcz5uIkb43GnKKz0HplD3MtINrOXbpaB/cDrAo=;
  b=GEehOzerzmOy2/nAds1B6MRQFK8GJ9hUwD+9aCti/ODewdxBy151dhDb
   470CiHpfyMVNImkm0h+0eJkGCnfJqRU+tGrCa7EgXQPAhCb7xifTQyaiv
   FlW7i/8L5S6gdEDbepDAQPJLorrkce7blkLICDomE6Ca7XaG7XNNxja5I
   20+fnXBA5X/kM80HzVKgxqDB/DgTl7XEQzfzfomBfnUXsKH1ALaae8uIf
   +6XHgM54wy2oPutCkjKEce6bGIq3ktQO1/Ve+D+YYDNbjsjSUm1fh389R
   FpG2ZPrxefFuUbNsTwusomBrfKbw4gae+PdYr3I4IyMBoLJ9Fnqrnn5Pb
   Q==;
X-CSE-ConnectionGUID: uQzSkWrORaCeLtS0fxxwNQ==
X-CSE-MsgGUID: Fb/fcP/0Tv6FqoJvgnF7cg==
X-IronPort-AV: E=Sophos;i="6.24,212,1774281600"; 
   d="scan'208";a="145305530"
Received: from mail-westus3azon11010059.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.59])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jun 2026 09:57:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GWcMi8xOVC62ZDvXB46zoWGq7FVIg+zlQYZu30O/EYaKRNbHKSr/63CtFBzbjbBOBIS77IL22EiWp4+qUsC/k8K8RfwWFm2dd6LgcOa5n0UXohCh38oHljwueKkXwydf3f478cXmcFoKADyBSgjypX9moYVTWeFVrYZROocBD+IDizzY82/SieJ74SPD5jEZW0jQwz66UU5IwRwHUFVwhSQSMmYoUPJ/bX1F0xZElxtp25fxi8EhMKDeXz18hIjyI1uerAV6wGP84Eq8MenfPDtHW8jYx6xCpabgw2JPfYJKsREA6okdZCGfciMOpIAv8WMNwGSSMJVZvZQKZqZHqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kxdRBoFEG44sdWxBXIWwXJUdU2p6gG9vbeSHJALMUog=;
 b=igl0wpIB7Eylbe5fB2v+zaL5irgT69RRVSRT+JGOntWk9KmZ//wZOOwjOb9myONgeZc+nZ757vZ/AvySdIKekfzeq91DmBPdXeWKhyLNAYPWka0HkAb9RX+XeT4UpIk6XJk1oPKaAjxO6/tHNDPupGj/3aSuv5yf0ald7TVs7guXdyPzlD12/8K6gKMGdgF4vuUOca78j7jGqLN5S7Euw81Meb6UzW7pP9vsE1KlrKlcomQnI3MPFAAe6rg24V9P0ozScUYBa5uxD85R+U16QYQ+iLaeRMISREN7CuThh6Kig9Fxlj8+qFXT3khbr7H+oG7Yj0YU6RsytMVu9iEKdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kxdRBoFEG44sdWxBXIWwXJUdU2p6gG9vbeSHJALMUog=;
 b=B0hKI4Nzli3jJMZ6LWJKvN3K68tWupXdHYL4qMe/fLM4zVnCSc7WuW/xNlvGa+DZpfg+MRVgm7mVSY6XE98Edp15XkIlV4Ug+bp5KbtqQj9PbDa4ZKra91k4mpWBluTq5fw03t2YybDusCy0DULZaLMaVH91MJNFCwgPmS78tmM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14) by SA0PR04MB7465.namprd04.prod.outlook.com
 (2603:10b6:806:da::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Fri, 19 Jun
 2026 01:57:34 +0000
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85]) by SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85%6]) with mapi id 15.21.0139.009; Fri, 19 Jun 2026
 01:57:34 +0000
Date: Fri, 19 Jun 2026 10:57:28 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	Lukas Herbolt <lukas@herbolt.com>, Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org, 
	fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs/216: disable all concurrency scaling
Message-ID: <ajSh4IK_C7FRW8zO@shinmob>
References: <20260618134834.237647-1-hch@lst.de>
 <20260618134834.237647-3-hch@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618134834.237647-3-hch@lst.de>
X-ClientProxiedBy: TYWP286CA0016.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:178::21) To SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR04MB10065:EE_|SA0PR04MB7465:EE_
X-MS-Office365-Filtering-Correlation-Id: 91658e16-dc5a-4201-b8ee-08decda621b6
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|19092799006|1800799024|376014|23010399003|11063799006|56012099006|4143699003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	7XRrFQvcQjHZH5OLr+BLxrkNOIpwsEj4YIxKsWITk+AxixjR3WVQSISbsxeqVGKdioq8kHsjD+TecAHvoOTte2Vfnq5US9uXuZldPJViikwiRwm1bd3uCtvgwMeimXHx6WtfFsyr5X6HaGksTRmUK8m3ZNSzpww2k9gCUPTc7JSABGQq89iKFiv4QDPp/QYUR94+2XWmGydSkvgvYngA8uu4G2RaZ6fw7NoqtXYSUNqm5hlBS31TTi/w/tCH0zPUArHvWiZoKvrVA9s5ETFmSNjvp7YBK0eQxUSjDSgbx+li5/UeTUk4kt7u9uhE4A9BjV2d/R6OY1NRZ8oh+YzIeZ6KPtC2nFYhHTu8XP+W14NMs5T8vx78nTXGbzmuCFsNv0jMMiWxiR1tVffQKTH5HDGkHXQ55mqbsc3iY5jImaO2sgnEgoVhLmSnmBYSSSh+svWagOnWBUZMmUyx2iKv0m7Q0R8k6gXhpqKlPr2KoUqOuZi+Q0P3JhflrSm2zqG5FH3Y4Mtbuw4jrDE6rJuM/+k1ndfynR63yCRZYXkq9x8cFDHC/E1EhFGUeHvHu1gSg/vlYgVpRShNITZ70BLV+82YDG+1Lu2cDV3zJ0vuGunak7AN/Fg8/mJdWA6u0qomdpoXv4RcFs8PRfZ1t2fsBRgWMtZIgFGBxiLsBY5qAnQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB10065.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(1800799024)(376014)(23010399003)(11063799006)(56012099006)(4143699003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?139CkdlT1qMV49ws2ApF1aR2RdZ3HIaq4VmbZ3VW1I3UE2ommNGhjzKge0Dg?=
 =?us-ascii?Q?aWggoRmYjeaT5DsXwHLgNRwf0arrDXoGo0NS2yeMV0qDt4PoKCL2JkdJKXFm?=
 =?us-ascii?Q?4hzRiqWZDfyXQWclD+6WV8/3oTuZoFNRwgXEwh+7q7PSdnwx5yNH8532t4Jn?=
 =?us-ascii?Q?vahRcSMTnJ5uKvUJ1Xm8i4AFsGhzruxmd2GAB6GlQZWprdtFJzJIb6afJ2l9?=
 =?us-ascii?Q?UtkFBBrw2Xv4qzhGBbj1+K6TZcZVAiqotwGi0xvUVbSEEKTqvBju7OPn2B4n?=
 =?us-ascii?Q?d0eprRlfEqs93QH1n+5HbveX1HHPVNwkQjcwiXvqz0LcBxKjdza6SoCdZN/C?=
 =?us-ascii?Q?fmDzGlIDQaNq74tPHFTEpnM8ZgGy+NLxThv+XfryBD0OPmn7Am5zdLyLSHhR?=
 =?us-ascii?Q?w3nWDEBvj+e1ixsrd5kjh5wwTZtqnr5TBI2Zq3UfWroxaKbZMMxE1vAavB/o?=
 =?us-ascii?Q?vV6Svx0llLWuZI+or0GjnwMwicjiZLXoesjLC/PJtJuDDXQQNgAI7KdLLZWi?=
 =?us-ascii?Q?q/UE92nosjdnX4/soEEspH7Ijt8V6b11/JB0Vye/RGLyNbQZbhbWGYSucte2?=
 =?us-ascii?Q?FVPAFuB8inrwGwzKnb3t95guQLM+KF95rnpXhqvaxxHNeTGhK0exPR+aWYFF?=
 =?us-ascii?Q?nIbdMfsPOnw650I4AjEbpwkyYwR7HI6DejRP/aZr3mNIjW5Nii2qRdZsatlk?=
 =?us-ascii?Q?OmFZmc2eqgwPOj2JO0d2rtk+WnmkTvR6HFiKJCfHoTf+AoKLFXI1BRWy4dV5?=
 =?us-ascii?Q?k4lZBWgTSFxQA8OKzN0fxbi8uGAO5XH/IFzA3oY7jJ7ru+0Kx7DvtXJBvavn?=
 =?us-ascii?Q?ZtDQ3k1dIkkyRduOLKqsfTrAiQJ5OVGKzVFpwYpuJI+CXfbvdbow10kQHhd/?=
 =?us-ascii?Q?SyMCAXNAjQlR3XpHjpbjhBqOUmL9oZ1cAn/0BN8rtiZLKoCU5bFzJ0WKCAO+?=
 =?us-ascii?Q?02jcYHDZgkWPO1YAVw9tYcrOi1h/k7odj7yhD5ZAiHH1Smi6pnD156a+I/if?=
 =?us-ascii?Q?amHure+5dltuw2vMU+EqVradcxbUY8tTmTUnUK/2KOS1/YqTqeCnzdrMkZsg?=
 =?us-ascii?Q?wp43DXiQpc9uOJ13wIsOKX2GNAdF59cuw10Y1U//A3RTSjejKpleLdsRTVL9?=
 =?us-ascii?Q?c7jikSHR07RPJRUS4QguPl8Fuc/cOMvtXltBX8RSW++zT9rhcwmCSEpLAGX0?=
 =?us-ascii?Q?o4GgSEvMWOgTbSwAJ67DrCZ7OBA8+qLyJHfZI8KkR2x23MmYkBHmGFAyeqvK?=
 =?us-ascii?Q?6uCM1ePTJZnM225UJGpw0ixJwwna3vLMJfmrzQ0on7hgE2q+g6Hee3Qc3hEr?=
 =?us-ascii?Q?8TNz5OV7YewTMAq+T4j4Ms6x/eiraEasYrDfl+scBzApyuD4RDb4XJMgym4L?=
 =?us-ascii?Q?w8noG6lDqk+r4EBIQjmf+3hWcbLQvQUuiZ1w3Kwh/IfiWBqbLlb3ngIU4+7P?=
 =?us-ascii?Q?8OceP66bJG2tBTGOHEJGUzTkUDcDskOIFfojX4ry9QWYVYPlZRo5RSVHiqyd?=
 =?us-ascii?Q?o8VHpba0i9GIaioHlxzCxYxQ6gpdpnHMFKMv4BQndYGoepozKJ+Mx20ZLySH?=
 =?us-ascii?Q?Kt7svGbkeeKgg/SpN8NGWCyarhjCr2Xy/1PQloU68jU5zj7p6eIAgBeKbWhW?=
 =?us-ascii?Q?Qo6W/1rUJUhXBPSY0vG14OIzEPcCQOZJAoAxl6lvDAW21VXQeObVsCk9NjNz?=
 =?us-ascii?Q?B3hNk9Yu+IA8rl/l+7WZLBJZrkzRjhwRxPa0gJE4pn38BPtuQjVu/np4KOcJ?=
 =?us-ascii?Q?POu+pTTXGnLWiJIW5leGQYoR0vgvo+M=3D?=
X-Exchange-RoutingPolicyChecked:
	FasJSHqnv4a4drizvn2Fs3Ka/68Q6Y/z5nKoDAUxiJ3ghsEMzcwwN2RZ/qW5hoXHYOpXG4zETppEPIK/1Yi/56aozxQ0N+Lj1KHFR05jIgolHFEYVhnEbnMBlfl7fCKqmxVwntdPZrW3JLH8y2Oqph3BplLhq3acpTti4P1Ak2P3GVd1Bp6Koda156HdVvu/3UPV7h3vW8/kaLGsOpaVWTMounnPcTfQlZZP0ya0lvvB+bcnV3Yhq0NHk4ifcDEVqBp+PjWAs7qqhUuElL/ceNCnV0xuHFjCqPhnIJoZFSWEToMrQf2+Xgx9q/JumyLMrPzXYC+mT4GbzM4gGvYQmw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tnwyYo4FOsw2Ab6+Qd02QPKHYnfEuKRuyMGXkLPKd5zL/9C4U4vW3v8hVe9a+NlO4lmG+5qwLxgjjwhy0WO1N/NoNeDQURXlfKBBqluR6qXZWhliFkuvijYfwzZql9Q86wa+LxEvKwFK3xBHOKW2l5Wu2xgUr9oNd6r5C0+SWSlnOGWSyy/koTQptexhbgNH3QYfejhTHCOKvmGxGhl/T2v4QKhZ+6MS/ZlBzapsgGY8jT0WSBhPanvWx81OmX59lI7w+hph8rkWtzH/7cY8ROh33hO3HDI4Yd9h+clHM5xGFjGe+ZIkwXXk9bnyMez0ja8laKIQaYPRG96asQdIUtVzpz8PPK+tXAvAlXfSun7zMKHolIXhtYOVo6d7hRaOIf5HQQfpGRboaRv7DtvJUgNaxsr4MR3m1rt6/sUXvr3V6/0RW7QLb2me+HvCGdFN32/Kq7uWyX4qO7p9YRCaqqYSy6/JT6WGWml/JdVm26NrwCvrqCWY6dpAVB6qUQEgHF1K1kO8Igm1rZIEf/WN48Me1NyYjKCnvx/vzpeqqnMMu26h41pkqZkc8GAOYUln4LYJUcPOivJKfM1aAIKPD++yk0HB9DrbD2cMOxOfIzJE0/ppeMgT8yusoM+Vj+8c
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91658e16-dc5a-4201-b8ee-08decda621b6
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB10065.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2026 01:57:34.7664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wY74+rdVB6m63QLDjPceugRg5QItNUQWMpNAH+eJfQvXjFB99GOThaSwzQN4wAxyU0uvospxEzRyM5iWafkcgfaH6T16ibpxaejQYH/D3ds=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7465

On Jun 18, 2026 / 15:48, Christoph Hellwig wrote:
> This test currently disables log concurrency scaling, but even the
> data device concurrency scaling can create mismatching output on
> systems with a large CPU count.
> 
> Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks, I confirmed this patch avoid the failure that I reported.

Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
