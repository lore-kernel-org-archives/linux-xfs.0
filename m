Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012068.outbound.protection.outlook.com [52.101.48.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C745B439F75;
	Fri, 11 Sep 2026 15:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789141037; cv=fail; b=kYa1ivZxQN+akffrnXmdLoRe4W/bVb9RkHFLWyMIybSvOnV8rCdoniEIMfgfv5yMWiGUKnNJ3i8xPkWQ5xzmFGdhzJG1YPbdX2Sh8p7Dzi7iLOe9AkvzV5lyvUfwpGRTfUPV4HfBtLy+EgFoIxlCiGhkzezlXSEd1+dKNbfMMYc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789141037; c=relaxed/simple;
	bh=UFGDT/WOM0kXD1NbJnhdR9go1j88O0Rp2jcw8g/p9qU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Mefc8EbRrsSkAkpDqtf7OV8MexCoH/ZnGO2do258s6q96bg7HDgSFQJEiOFspYQs6kFeRA86vmin308xdu4Zhl+dVdoCVvMQXq5WiTWDH5Iq0W7AjTDq+0yolRvpN0+PbMrgjTW6mVYEH1sOBRQyDdE7xnw4iyF4TkbT6rw+VsA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IA82WWvJ; arc=fail smtp.client-ip=52.101.48.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IA82WWvJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L4L5j20T4YFY0ngGBjF4zlvjWvx/W0quX7Z/FFaVY7nYyCvdRnrGT6w2d5P0msEqDwpobtV8KkaSgY536/uMW6ReL78bJjy/mZLl4/X3k4/yupVm1Bm2ABASaqfVWmkETKtsMU99y2lxVOc86TMxEo6I4JIJl3MbHeaLYaJKflUmW11/d8tNJ6Il05Z2DcEzDREPcQePKzZryAGFp/ocI5Tr3IIJ7e2mMAZYjgZ7SOlev+XPxwzXgrSoH1iXYP+sL88W7mHX2bejBzTtbdlibtkZzUXQtDO9Cd7GdqM/ws/k+b1HrG52vo7Lztv9fccxGKhJtWALgPxXp8f4Og8z/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2vBxu9QTqT9xwiBzCnIFr88Ct+PZYbRk3JxdVkP6qfY=;
 b=s9ai24mPeTWVAwIrm7w/D2kyvIMOYPnj/NYgWh5zWmsHfNIoLu0cLIgO+CNjScLY4aS0sxx9MJYcr5mYsjvEihuPdzi39Rf2kHhHWD8yDi1RarS1FbqIA0D+BTAbM97i5dNaDeRhBeQF3FPFmOZA3yUUeW+EqBkQFTV9OuWuzSaqCtL4RyW/4Z5T+zZUSvZWZWuUeb8DMaAdei+Q0F6Huu2MQqaO2Y8PUaX3c9r2hX31qhXWOxNYYxDKQjYet3igoGf/c6FIbzZEKE/Cwv00tTD+n4NDOKLXYqo1Ww7FyPOG3mypId/V5+yrHEtgKGc6Ov7h9uLKND0kHvsUpIvz5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2vBxu9QTqT9xwiBzCnIFr88Ct+PZYbRk3JxdVkP6qfY=;
 b=IA82WWvJy0vncmsOvW/zQBIroYR9kKjFjnaT5maVRT4ONmZ9IK02P/WkA/vTxKiXpKVLr01uzWejxsd1V/jUBVGaSxUh+jE4BXZ/hF3m9SYmcfmn2KItbm3zQlgy3YleG68D7H9NLw67EPQP6eboji4BR2k0nWl+ztTT6xAKhSsivTKL8rPgsSSQ4AjDOrDtJfhxD5ywivGKmMYGeE4TwVD5PsPq8e+rRAE2avWMykmpOgCqS/taEAzcnVqiKU69TIhd2sIedqONq+Pct9KUiIrSzqyF6gwqiVlnGoX2NUQnxeD0CV2/NeMxNx9PpGjiYcspkIAwUtxBxADIX9lylg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH2PR12MB4040.namprd12.prod.outlook.com (2603:10b6:610:ac::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.10; Fri, 11 Sep
 2026 15:37:05 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Fri, 11 Sep 2026
 15:37:04 +0000
From: Zi Yan <ziy@nvidia.com>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, abuehaze@amazon.com,
 akpm@linux-foundation.org, alisaidi@amazon.com, blakgeof@amazon.com,
 brauner@kernel.org, dgc@kernel.org, dipietro.salvatore@gmail.com,
 djwong@kernel.org, hannes@cmpxchg.org, jackmanb@google.com,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
 mhocko@suse.com, ritesh.list@gmail.com, rvvandan@amazon.com,
 stable@vger.kernel.org, surenb@google.com, vbabka@kernel.org,
 willy@infradead.org, Vlastimil Babka <vbabka@suse.cz>,
 David Hildenbrand <david@redhat.com>, Christoph Hellwig <hch@lst.de>,
 Brendan Jackman <brendan.jackman@linux.dev>
Subject: Re: [PATCH v5] mm/page_alloc: avoid direct compaction for costly
  __GFP_NORETRY allocations
Date: Fri, 11 Sep 2026 11:37:06 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <ED9E1F18-6BBE-4E61-89EE-2D513EFFC12F@nvidia.com>
In-Reply-To: <20260911142102.2294202-1-dipiets@amazon.it>
References: <20260911142102.2294202-1-dipiets@amazon.it>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9P222CA0014.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:408:10c::19) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH2PR12MB4040:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e35f232-18da-4c3d-2db6-08df101a8771
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|10067099003|11063799006|56012099006|18002099003|22082099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	Jp7U5bCXWaPjFlDWxAZMResXz/fRQqkZOX/Q2axn/u/9XFGoBGkfV7Twh0y6lc7pVbUnW20azPuUKLQQ41jzMXkRVAatB2WcfAfjztQsqoZg21Sbd7a3QLFeO7WWc7TgKPfCf1dnhlsEbCbbBzugO54Woy32pRxACWLJZvIDymujd37Bz/QR8sbRRrLbHnsysBv5Jb9a9bDtT0I5vJ3lhbav5cXgHl0hqnWuHiWcNQZEA6J37h7crwNVQXCPLmv8SNknCKXBvDJhQBHVHZ51Kkb3DV/34nCuIQZzkZtADpRhTTYIqPtpGUa6NtAs6bTwGwOwiXzX6g6inAVoaD4z1hrMQkvHWXv8EPbfxwmJBnAU986SOf0Dibt9Pc0lVZ3W9nByLZvCcPjzl2X9i2GjCFf5QctDAtEsIhfd7O7XSWWo5YrG8JEyOAANxjQcAbhZnC3qxQs5haBSCwiVldzKoDLzaSmtK+B2ZcVqs/l+CP/ATffMCGQA3U4JB0igaizZg348qBnFe1ctWAXipSQ7xms84A34U6Qk/r58HDseEoZEpOjIKAF5FicL7n0iKTu1+Tna5mj8LPWF1/7T2Gn97IBAIK23TjZGfp3X5SthFKAF+6De3xaptStYHYV/VNZpMP8tnz/cHM7lDEteBSsPPJYCVokTTfCQEfCVZK1bnSs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RPWACbVI09PQtTEIAwcYnFLCnf30Dr0XRTSxFXOA0fVIUKxc137EJkXBKAE8?=
 =?us-ascii?Q?UUXHXyGpP3EmfufDU778jRfuS8Xxlm01ZWaOW2TriOaZyrI+oAeSaHt8XfWs?=
 =?us-ascii?Q?e7YuNH2vQhoEpAQZAjkaxkLB6LzLfgjLq9CjeFn13x6rRWR29mKRZ7C5zZxA?=
 =?us-ascii?Q?5TTv1VpMJe1lPVOoyH+jy3Awb/mNc6m428jKGBlFkmyc8TZd3yrZZhxMhTSU?=
 =?us-ascii?Q?wQnZDp+4yAvr6Wxyxn3DVr/6RuQ3xu40h6N6VwF3XYPaw63bu7IdFM4HuFpX?=
 =?us-ascii?Q?oDdV66SfY+VPcjkwhb/6r43zgRS4Bf1Sn+RspQri1njTfknU877MYgWYTe5N?=
 =?us-ascii?Q?dhGdd/0bQwce2VB6j72xX7NNUueJEyyp3AtKWl+errgsRyj0QQLU/zm6JGLg?=
 =?us-ascii?Q?1urL5f2Ca5Lm5jHZIDe9LFbX/1r0iR9W7Ipng0M+48DlKDBW0YaENkBDnoWM?=
 =?us-ascii?Q?7NGKP+Vltx1+I58ZJjpem0I0ORUgBOlEzXrz7zmjP7S7A2+uK+b+1aEosMxw?=
 =?us-ascii?Q?jmuQ89sBFir2rYBgVYjiPQn2400uVZgvdXAOvSP9kFXwXVvNsfaAwvsrJg5n?=
 =?us-ascii?Q?4fshBd5y1wpRrc8SrIb2tcY4B55r+XpC39kMoSq6YhCeERDUbihFBqUgG74v?=
 =?us-ascii?Q?O+ZUpsOCb91zvpA1eNjcB/vEjqhOAqTPVxaIk2lDI0ZKAbP8obeZ3/UtRndY?=
 =?us-ascii?Q?fB6NrYCsm5UVt8hAHF7RT5GutZ3TlhZ1PqUCJ0RxOA6jgCccozk/iMHWenA4?=
 =?us-ascii?Q?HYkNn8+nCq0y9Td7TorrwBVUCdPPrLoioY/3mWZUQhKI1DyGnrZVRiXwcVZL?=
 =?us-ascii?Q?Xx2sktu2kyKCLlZ0DmIXi2RNPzDCWBunqDxQr/1LY9Wfejeg+XReCppztSGk?=
 =?us-ascii?Q?Y4iBDhUsQLkKCMDalAEbsSS9eiyLYhxXHEENwNNjal9mqD8D0Lppx7yJ36u5?=
 =?us-ascii?Q?TgodNxqbhpndRFCHPoYAD65KCsBp57ofuXe/CKolvoAr/5w+sHwGrcKw/oHd?=
 =?us-ascii?Q?KBKFtqNS8rYXcRWprMKAP9RZKw4/V0SvTW6/IcVPZ6o2t+UiJDTBGr3KB4Sw?=
 =?us-ascii?Q?pOThU7SvhuPUbmJjxSAIVcoKFMxXhQUw3Lpmygyhn2zJfMGRdMLAnXQA+b0z?=
 =?us-ascii?Q?+vdYykabFYv01MgsLvDRx+Jv7prhlQ5zs4xoR63WiWO84SBpR3TvsEe0QZCC?=
 =?us-ascii?Q?aHSkhhkqjZRlXRDU6WLlh0gHE5Uhc8WDBDBUzAdMR2Eh0nYTd+S4XO/d+VDl?=
 =?us-ascii?Q?OjThukn1cAHf2DsIdHoHmgoVplzRJycwn7YPdBcm6gZEJurEUtzSCRKu3o1x?=
 =?us-ascii?Q?/qTmplrynRxiJq+SlDWMAAGNfaJ/p+/E7ZFFiUSjaKPrfvKVePMGpcv89rql?=
 =?us-ascii?Q?yO/LKmYjnWsPlsF9Slcvu8Tv4NDM4IfswrCv45LqtHdXM/GFuBEBgLGLN/hM?=
 =?us-ascii?Q?O3wxSAeXCGj68CFRFuoBgoiDEiZydqizOBeho7I7WY8YLaBOPS7fK68K33xW?=
 =?us-ascii?Q?JDRoKcxe1sw7GVqixh6sw56XX0ITw9k71lrgrqPQxCn7jI/vxHRPE5X7Y+1a?=
 =?us-ascii?Q?toQopqvmSHCULdPJOVqNsGHdTfzoB8VpoYhOrhHxhTsc+WP0NvGU86W0R8cV?=
 =?us-ascii?Q?ONGd92sGaU19Oyh7tcbhgRw1Dz8MQXxJQ+H1XRz5fcD9jgM9G5QH71VuR5TV?=
 =?us-ascii?Q?E6/g38zfK17UuWPbZuJorD7ai9mwZmqotMg8xfyKlMoYcbMr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e35f232-18da-4c3d-2db6-08df101a8771
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 15:37:03.9296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gRwPIJmDLfUvZfqsCunUrqu9Bz3anX2cb2qox1xUgTBYNNQAMNEoLHf4qlvh8Dfx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4040

On 11 Sep 2026, at 10:21, Salvatore Dipietro wrote:

> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> introduced high-order folio allocations in the iomap buffered write
> path.  When memory is fragmented, each failed costly-order allocation
> enters __alloc_pages_slowpath() which runs direct compaction and
> drain_all_pages(), causing a 0.38x throughput drop on PostgreSQL
> pgbench (simple-update) with 1024 clients on a 96-vCPU arm64 system.
>
> The root issue is that direct compaction is too expensive for hot
> allocation paths that have fallbacks to smaller allocations.
> __filemap_get_folio_mpol() already marks higher-order allocations with
> __GFP_NORETRY | __GFP_NOWARN, signalling that the caller can handle
> failure.  However, the page allocator still attempts full direct
> compaction for costly orders with __GFP_NORETRY, which is unnecessarily=

> aggressive when the caller will simply retry at a lower order.
>
> For costly-order allocations with __GFP_NORETRY, suppress direct reclai=
m
> for the whole slowpath by computing can_direct_reclaim (and hence
> can_compact) as false.  The !can_direct_reclaim check near the top of
> the slowpath then short-circuits to nopage: no direct reclaim, no direc=
t
> compaction and no drain_all_pages() IPI across every CPU.  kswapd (and
> in turn kcompactd) is still woken further down for background
> defragmentation, so compaction keeps working for long-term system healt=
h
> while being removed from the latency-critical direct allocation path.
>
> Allocations that also request __GFP_THISNODE are exempted.  That flag
> pairing identifies the local-node-first THP attempt issued by
> alloc_pages_mpol() (mempolicy.c), which relies on direct compaction to
> form transparent huge pages.  __GFP_NOFAIL is exempted as well, so a
> must-not-fail allocation is never made to fail.
>
> Test environment:
>   Hardware:  AWS EC2 m8g.24xlarge (96 vCPU, arm64)
>              12x 1TB IO2 32000 IOPS RAID0 XFS
>   OS:        AL2023
>   Kernel:    v7.3-rc1
>   Database:  PostgreSQL 18.4
>   Workload:  pgbench simple-update, 1024 clients, 96 threads, 1200s
>
> Results (average of 3 runs, TPS):
>   Config                                       Avg TPS   % vs baseline
>   AL2023 stock 6.1 kernel (pre-5d8edfb900d5)   136,942           n/a
>   v7.3-rc1 baseline (no patch)                  59,408             -
>   v7.3-rc1 + this patch                        161,994       +172.7%
>
> The patch fully recovers the pre-5d8edfb900d5 performance, bringing
> throughput back above the pre-regression level and well clear of the
> ~59k baseline.  The AL2023 6.1 row runs a kernel that predates commit
> 5d8edfb900d5 ("iomap: Copy larger chunks from userspace"), so it is not=

> directly comparable, but it shows the pre-regression level and confirms=

> that the ~59k baseline is the anomaly and not the norm.
>
>
> Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.=
it/T/#t [v1]
> Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@ama=
zon.it/T/#u [v2]
> Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon=
=2Eit/T/#u [v3]
> Link: https://lore.kernel.org/all/20260904115629.3993331-1-dipiets@amaz=
on.it/T/#u [v4]
> Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> Cc: stable@vger.kernel.org
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Dave Chinner <dgc@kernel.org>
> Cc: Ritesh Harjani <ritesh.list@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: linux-mm@kvack.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-xfs@vger.kernel.org
> Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
> ---
> v5: Derive the decision into a local flag instead of mutating gfp_mask
> v4: Clear __GFP_DIRECT_RECLAIM early in the slowpath and exempt
>     __GFP_THISNODE so THP attempt keeps using direct compaction
> v3: Move to mm/page_alloc.c, wake kcompactd instead of avoiding it
> v2: Move from fs/iomap/buffered-io.c to mm/filemap.c
> v1: Avoid compaction in iomap folio allocation
>
LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi
