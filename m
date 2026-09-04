Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013067.outbound.protection.outlook.com [40.93.201.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF5B37648F;
	Fri,  4 Sep 2026 15:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788534524; cv=fail; b=JckhKTPVIO8TvabmXWVAjVhTPWyYM/vpStM1Elg6HdLeXYCyDOhjnIvbPyKE+Dga00vJeA/hwS/riNbsZ/GIanqEfFSQj6YiqRcS5SzQxJOcmPjKBvx1NBvjLjwVhQB93v0PAkjHmraFVGLOqrl3SDQIViNP0UuMbx0HUCeEmCM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788534524; c=relaxed/simple;
	bh=Kfc86p6yxKUL/ubFI1Qvl/Fbf8QweI4jJ5vxi+iBe8A=;
	h=Content-Type:Date:Message-Id:Subject:Cc:To:From:References:
	 In-Reply-To:MIME-Version; b=Er0Nh3HyEWfLyqUv+c2zux8sIiWnhSgGaI7cpiokaeVgaoALm3+nRPny9Cr760gKP0btZMTA+EWrcSjJslKANBM1lsIClCVS0kP2RymAwXptpV7ZNYzQ9J+WuFMC4q0eo4HSpMTbGQdu+QG8OW/GStPYFfMSQzB8dmfNH/L71ew=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tSVEmD/d; arc=fail smtp.client-ip=40.93.201.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tSVEmD/d"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hT8FusuxNES62XU8/gBSONdzPjzy84Pf6e5Lk4+CFEhjaWvIdiUCbM+/LdMEB9W5EquoUcYUHW1fclIaTdLIo2jOkzKhErzKn72lW34OL+07mtfItn/jVR0+5UmOfAyyj2k50vo+Lqh/Xcdtf2G8n46OLgEIL7F8MQ96bDHHorfHZcg3uMQGaqLTwrTbgRB4sce/TQlPD4F+9c9x0ouTATqTSawaPw+kxlu7VM35OVI+sDmEVHyj3rnxqy5xisz3Zn8NMsZlY88fZwRbmmPIscctJfox2MR9NI321htU2uLb964QwfioNdW6JPpGJsVFC0fR0K12wsxobMQo3oBTzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GN6mBwLT/6rTFhRsPUjslE3h4JBShe6KdsyAhTt8At8=;
 b=w5gCk5VH9sUYqceHFRz5a1ghW2lDOfxW0hp72Jbh62alqoHaobJRdUpnXbssVHr0qDHWbXLbyncNYGOodKdnQUpd7pztwkA8ZvXITXDScONZcCqZpV9ck/j3qBfTqmtzjRaW5R7sIhzP+QpMD5DVqtHAw7UWIGGmV4g6sajGuNhm2e638VjxNUfW8YOW6b7rR5EPFcazEh/15dv6CdvQjxYaiATFaitFH7TlVAAVafbXxPylIrWcjIfhDMEI6cGYnKvYuooTGXI/7R+YXVAd3YMjBqE8f9uhkQPJDftlkpMQ374VuKKrU6qq3l6QGqa1uik0DWkmRVsaIKOotRdk0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GN6mBwLT/6rTFhRsPUjslE3h4JBShe6KdsyAhTt8At8=;
 b=tSVEmD/d7QCqlNWY11RwfHexE6NLaAjb7ErQSA9gTfHac+2Nda4298Ydd9tWM1/O7XxCRRlTgT9q6vOKFBmV9MkZN55tuOlKuSHb/cLHl3Xdk91cg3NS7J6/UPMzXayZCqVSEJUh+Ccrl5LGL6s1ibNeQ88GFWx6SwGcroGhEcS/EHLpXIuzHU7zSU+hUWGdvv6e0QviLmBHGeHCpAP+jvRAE0cGWF5n67B74gr1c3HVGw7CGIgLCIDWDxVENYWEowqeDsq+JgJQx2VSTXgGAur4Vpzky5LBDpP/z/V7p0hng71J4JGhMZeDfyqlbAFfS5fOjdqQ2f/mAsu8qtoklw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM6PR12MB4330.namprd12.prod.outlook.com (2603:10b6:5:21d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Fri, 4 Sep
 2026 15:08:36 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Fri, 4 Sep 2026
 15:08:35 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 04 Sep 2026 11:08:33 -0400
Message-Id: <DL6MKKOOL5DX.1R3Q77UTXBFYT@nvidia.com>
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Cc: <abuehaze@amazon.com>, <akpm@linux-foundation.org>,
 <alisaidi@amazon.com>, <blakgeof@amazon.com>, <brauner@kernel.org>,
 <dgc@kernel.org>, <dipietro.salvatore@gmail.com>, <djwong@kernel.org>,
 <hannes@cmpxchg.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>, <mhocko@suse.com>,
 <ritesh.list@gmail.com>, <rvvandan@amazon.com>, <stable@vger.kernel.org>,
 <surenb@google.com>, <willy@infradead.org>, "David Hildenbrand"
 <david@redhat.com>, "Christoph Hellwig" <hch@lst.de>, "Brendan Jackman"
 <brendan.jackman@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, "Salvatore Dipietro"
 <dipiets@amazon.it>, <linux-kernel@vger.kernel.org>, <hch@infradead.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260904115629.3993331-1-dipiets@amazon.it>
 <8cc503d9-04a1-4d90-874c-ada6c0ac5147@kernel.org>
In-Reply-To: <8cc503d9-04a1-4d90-874c-ada6c0ac5147@kernel.org>
X-ClientProxiedBy: BN0PR04CA0125.namprd04.prod.outlook.com
 (2603:10b6:408:ed::10) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM6PR12MB4330:EE_
X-MS-Office365-Filtering-Correlation-Id: e07f8e47-2398-4ce3-9a3b-08df0a966445
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|13003099007|4143699003|56012099006|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	GIk7PhfTXZTuF1Et1NKSfQ+PwRp6GhuMqzKn0bcAUDTxcaQIMIH6UJdvbmoZXrcPi7tVgtZoWCiStCv13jTnd16ESBvomJPpNh8PTnsWvENdcqNY7iDTP9dFdxqUXKc6NqgtM+c1od7eC5L+4Hx9gHCjQncF/XO7RNIpD+K+hBmA32mrd7ahojFJuEL9atriRil4OPlv4bzhzMosW+9FlLTenLGVBkL715zbQRepwFQYOg/188Eoq6esMi6St9A5niiyJG3oXbyxd4lInnATzCFE4tuEXZJkKQ8/Ew1chhUiVdG4J/e0/zZ6Cv9a+uSzXrBr/fLmkvG9islCIFWDOm9q2b1fYw7kHK68Lcu/pfADobXinwebrl5dMYEp5CVup3kUdgIgRNMKsVrFiMsdF4Am1QEzqrK+ybUOCMbfW+++UugsFJ3w9fGKuJDB+JxQgz0rLslUnQmLvRVdw+RP+9l9H1amrtqmY0R0g8uN1LtNEyndlwKxU6/yacJGBT03AitTnJUYAbXGJNbeNwiaGuPG9iPpmqccmVKefQZaT6Qg+TkoaPCR69SQnlky6cLGG6aiSUUhQ/ffyVE4i19zIytU7C9TUw03NLSdkd6Pf7V9ZVHwxbtwwqbHNaWlpgzzejDGFi2wYo/d84U1dB+tK4qSFUnm2KGkMKGYGY8/2Dw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(13003099007)(4143699003)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d1JpcmJ6anY0aFpSSGg2TmtublRkemJGUzNGdTlOc25jZHNIekJhQ1VlbldT?=
 =?utf-8?B?eGs3UFR6WHpvdmlZY1AxTTl0SkVTWnFYWHB4cjZ1M1haVUVsRVB5cWZGVkVl?=
 =?utf-8?B?YURad0gxeEx6VXZodXZnVmljbFNCYTVQMktXREdsZjRFblhGQUVDN1hFMFNW?=
 =?utf-8?B?SHBQVTlYSmdGRWcxdXFJZjFVY2VNVU8zWmxEVy8yZEpNdGVoVEU2MWdaWlE0?=
 =?utf-8?B?eXBiK1JjQUMxdVF5NWMrQVhYSHhDc3owTU9lMjNyMUF3blpuMzAwTkplTUJ6?=
 =?utf-8?B?cWJsTHZQaFdTc2YvUGlrVVpDOFU2NmgwbldZdGQyaEoyVXJWZFdQdXptZE9W?=
 =?utf-8?B?MGV2NjlHSXBIc0VkSmhlYWVKMWRnejJ4dVhoV0U0THJHd3R6WHRBWm4wRjJ3?=
 =?utf-8?B?ZDRIdEVYU3puSHZXbmZVVFJiVHNybXc4VDJEUzV4UlQycmJQTGVjT09tQU9r?=
 =?utf-8?B?REpCR2xqenJCRGlzT05oMDdPV3JTVkd4cEZNb1ZsT0JQTUpHdHBId2w5bHRo?=
 =?utf-8?B?UlI5cmcxUXRiN2VQdXBUbk00R0lmYk44M2d6S29PT0RTelh0N2RZSVE5Z25P?=
 =?utf-8?B?TmhvLytMMWRnUkRHS1M1alJoLzdQRzFudUtEbUtZbkorSi9sMUUyT3NYaC9t?=
 =?utf-8?B?NVlHN1NzNjcyb085dGR2T2xxcGNBbEpuN3huOFZQYUJXU2R1YW5VWXBTUzNu?=
 =?utf-8?B?S1l1YVhpdlgvZzBEYW9PS2hPcTFUTGVidTY5dVVBWjRNK0owdldzYnFVK21T?=
 =?utf-8?B?dnl4MVpQM1BvMzhyTTNMYXlRaEorYUtMTkw2bnNaMFBiTFhNVUl1aURUOG1u?=
 =?utf-8?B?SGFxOERSbEplK3dxUXM5TmJ1S3RwbXlmY1Y2OWNINEROUExCOWhxOEdsOW1E?=
 =?utf-8?B?SVp1U04yK25zd3B4cEg0bUl5cmtYdmo2cGRCYUtLVERzU05CMDA5WG15RENF?=
 =?utf-8?B?R3NFUHFPWjVBZlZIbHVvNDNzTjFDL2pCMzRxQlRBU2ZhM1IzZzJ1RHU5VHNI?=
 =?utf-8?B?cHBLTXNVcHhXK0xpZ2RKOEdxNWdYdEdhUU1rbTBlSVY1cXh5ZGRzQU9jNit0?=
 =?utf-8?B?RFBsQStpY09iWlZoMTZEMzVzSEdXRHJEZ0s2V29tWjFHaGZ4NnhSRHZYR1cy?=
 =?utf-8?B?T0VWeHlPaUNWRUZsT3N2UmI0elB1Wk41NVBwU1JDWW9OeUZKNjhyQlZiWHo4?=
 =?utf-8?B?TVlHaGkyaklYUzJySm4rNGhzQ2RBN0hNQjUrZklZVityakU1a1pRWmtNamJM?=
 =?utf-8?B?ZXNuYVFNeW5rYXFUa3pmdndtOCtJM0ZSMXZMUTBwSVE5QkhNT2dGWUhaa3Zv?=
 =?utf-8?B?aC9xUXFGWmdVVVA0dnNrT0V4MzZtKzlHTU9BZkc3TkJpOERYMXVNckVuQkto?=
 =?utf-8?B?a1ViSWlWeHkreHRnUnExcjF1aDMvNEtLMEhTaVN6Q2F2ZEhaeUlVMkMwUDdE?=
 =?utf-8?B?SUxEUW1RbStXOXk3WjhWZWR3TFFsYm9MWVRXWmJSeEQxc1BQQjl6WDV5dnJZ?=
 =?utf-8?B?WUJTWkVzUlJ5SHRnRkVwQmJpcGxhM2hRQ1pTQ0g2dzMvVVJIa3RpV1pHUmdE?=
 =?utf-8?B?d2RHNS9uL2VHTHZkMFZyYjUwSmJTaHV0Qit4a2FNZFEvSEFPVEFUNmxHK3dR?=
 =?utf-8?B?NTFETURuczhqcDZnQWhXenVqb3Z6em5TMTFNZGthRW9xOURGSkJiamVrQnVj?=
 =?utf-8?B?UTdmeXZXNkFySzljSWxhRU1XT3lyM3BNbGUra0NjRHBOWHB6VmR2TlJSSzNV?=
 =?utf-8?B?YWtYMXFlU0tsTC9uS3B0emVqT0l0eHhLcVY0TU1BbERzSW9aZ25OV0xKcCtM?=
 =?utf-8?B?TkM0Q0Z1cklrZmdkcGhLTGdDMnFiQ1Z4SWlJR1BXd1RLUmZ3eXkwU0dqVFRw?=
 =?utf-8?B?T2RxSmhYS1FhS1VHa2Z0UmR1ZkVKTWcyTnBTZjRmd3pVS2JoVDBiSjNKNXZW?=
 =?utf-8?B?cExvb1lXbDg4b3ZIUklHQ3dXQ3I1YlpWNTJRRjg1RmpXNGJ3YXkwbWVFcXhv?=
 =?utf-8?B?RzZlQmJwWnFreDNGVXBYUEdVZWVpQkhTTTJiQnNCRzFKVDFEdjZFcUoySm5P?=
 =?utf-8?B?Y09PaEdxeWc2Y0xVZ3pkeUQ3d0pDdHJadlgvWGxXVUJzcXcyK1orcFZyWlpy?=
 =?utf-8?B?SEJlZy9yaENZOGw4bW9sR3k3RTVMSUIrMzZVUW1OQ3pudzdVYm02RzlhZjNt?=
 =?utf-8?B?dWtDZlZtZnAwelJLaEdZL1NMbUlkQXJSck8vZUIrV2VYSGl5QmprVkxyRXI5?=
 =?utf-8?B?S0U4V1NsaUszQTBldm1VaWh2UWxGMkdjMTY4K2d2cTFPNW5JL0c3RHVJVnNl?=
 =?utf-8?Q?0zmOazxrGu9JXAOXYj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e07f8e47-2398-4ce3-9a3b-08df0a966445
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 15:08:35.4844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5+Uqk5ckVm7H1CcR/fcOKkfvF9grmJ46CvQr0o0erv5bHvlPQvKOPhlVvs2tqaR4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4330

On Fri Sep 4, 2026 at 10:11 AM EDT, Vlastimil Babka (SUSE) wrote:
> On 9/4/26 13:56, Salvatore Dipietro wrote:
>> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
>> introduced high-order folio allocations in the iomap buffered write
>> path.  When memory is fragmented, each failed costly-order allocation
>> enters __alloc_pages_slowpath() which runs direct compaction and
>> drain_all_pages(), causing a 0.38x throughput drop on PostgreSQL
>> pgbench (simple-update) with 1024 clients on a 96-vCPU arm64 system.
>>=20
>> The root issue is that direct compaction is too expensive for hot
>> allocation paths that have fallbacks to smaller allocations.
>> __filemap_get_folio_mpol() already marks higher-order allocations with
>> __GFP_NORETRY | __GFP_NOWARN, signalling that the caller can handle
>> failure.  However, the page allocator still attempts full direct
>> compaction for costly orders with __GFP_NORETRY, which is unnecessarily
>> aggressive when the caller will simply retry at a lower order.
>>=20
>> For costly-order allocations with __GFP_NORETRY, clear
>> __GFP_DIRECT_RECLAIM at the very start of the slowpath, before
>> can_direct_reclaim, can_compact and the nofail checks are evaluated.
>> This makes the entire slowpath treat the request as non-blocking: no
>> direct reclaim, no direct compaction and no drain_all_pages() IPI
>> across every CPU. kswapd (and in turn kcompactd) is still woken further
>> down for background defragmentation, so compaction keeps working for
>> long-term system health while being removed from the latency-critical
>> direct allocation path.
>>=20
>> Allocations that also request __GFP_THISNODE are exempted.  That flag
>> pairing identifies the local-node-first THP attempt issued by
>> alloc_pages_mpol() (mempolicy.c), which relies on direct compaction to
>> form transparent huge pages.
>>=20
>> Test environment:
>>   Hardware:  AWS EC2 m8g.24xlarge (96 vCPU, arm64)
>>              12x 1TB IO2 32000 IOPS RAID0 XFS
>>   OS:        AL2023
>>   Kernel:    v7.3-rc1
>>   Database:  PostgreSQL 18.4
>>   Workload:  pgbench simple-update, 1024 clients, 96 threads, 1200s
>>=20
>> Results (average of 3 runs, TPS):
>>=20
>>   Config                   Avg TPS      % vs Baseline
>>   baseline (no patch)       59,408       -
>>   With this patch          155,409      +161.6%
>>=20
>> Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.i=
t/T/#t [v1]
>> Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amaz=
on.it/T/#u [v2]
>> Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon.=
it/T/#u [v3]
>> Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
>> Cc: stable@vger.kernel.org
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Michal Hocko <mhocko@suse.com>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Matthew Wilcox <willy@infradead.org>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Dave Chinner <dgc@kernel.org>
>> Cc: Ritesh Harjani <ritesh.list@gmail.com>
>> Cc: linux-mm@kvack.org
>> Cc: linux-fsdevel@vger.kernel.org
>> Cc: linux-xfs@vger.kernel.org
>> Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
>
> I guess this will have to do until unlikely(we figure out a better API)..=
.

We could add a "new_gfp =3D gfp_policy(gfp)" to adjust input gfp based on
various policies we currently have. Even better if callers can do that
instead.

>
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>
>> ---
>> v4: Clear __GFP_DIRECT_RECLAIM early in the slowpath and exempt
>>     __GFP_THISNODE so THP attempt keeps using direct compaction
>> v3: Move to mm/page_alloc.c, wake kcompactd instead of avoiding it
>> v2: Move from fs/iomap/buffered-io.c to mm/filemap.c
>> v1: Avoid compaction in iomap folio allocation
>>=20
>>  mm/page_alloc.c | 18 +++++++++++++++---
>>  1 file changed, 15 insertions(+), 3 deletions(-)
>>=20
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 12fac9084c48..542c2ec31061 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -4784,10 +4784,10 @@ static inline struct page *
>>  __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>>  						struct alloc_context *ac)
>>  {
>> -	bool can_direct_reclaim =3D gfp_mask & __GFP_DIRECT_RECLAIM;
>> -	bool can_compact =3D can_direct_reclaim && gfp_compaction_allowed(gfp_=
mask);
>> -	bool nofail =3D gfp_mask & __GFP_NOFAIL;
>>  	const bool costly_order =3D order > PAGE_ALLOC_COSTLY_ORDER;
>> +	bool can_direct_reclaim;
>> +	bool can_compact;
>> +	bool nofail;
>>  	struct page *page =3D NULL;
>>  	unsigned int alloc_flags;
>>  	unsigned long did_some_progress;
>> @@ -4802,6 +4802,18 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned i=
nt order,
>>  	bool can_retry_reserves =3D true;
>>  	unsigned long alloc_start_time =3D jiffies;
>> =20
>> +	/*
>> +	 * Costly __GFP_NORETRY callers have a cheap fallback, so don't stall
>> +	 * them in reclaim or compaction. __GFP_THISNODE callers are exempt.
>> +	 */

Should this also be documented in gfp_types.h? It currently only says,

"__GFP_NORETRY: The VM implementation will try only very lightweight
memory direct reclaim to get some memory under memory pressure (thus it
can sleep)."

Otherwise,

Acked-by: Zi Yan <ziy@nvidia.com>

>> +	if (costly_order && (gfp_mask & __GFP_NORETRY) &&
>> +	    !(gfp_mask & __GFP_THISNODE))
>> +		gfp_mask &=3D ~__GFP_DIRECT_RECLAIM;
>> +
>> +	can_direct_reclaim =3D gfp_mask & __GFP_DIRECT_RECLAIM;
>> +	can_compact =3D can_direct_reclaim && gfp_compaction_allowed(gfp_mask)=
;
>> +	nofail =3D gfp_mask & __GFP_NOFAIL;
>> +
>>  	if (unlikely(nofail)) {
>>  		/*
>>  		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,




--=20
Best Regards,
Yan, Zi

