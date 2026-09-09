Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010046.outbound.protection.outlook.com [52.101.193.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28AE32B113;
	Wed,  9 Sep 2026 02:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788921244; cv=fail; b=gCbl46g7GzR/LKHXjiQFB+R7Bi0XzmE7+G8An/IAFPZpxH/wZMWyEOsV8YetwJxMzLbdTCIm6WcbWr12nz25JgC8J954jwSOutbdACGDHnEgkczuEnz7WK3C3jpvv5VWFZ3ukh/PXfHllorgB/8KcWfPaTt4OtZ12phE97yy+0M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788921244; c=relaxed/simple;
	bh=C6ULIZy9nH6P9gP/AuY8Ggj7f+AqEeAWREpqYG3Fxa8=;
	h=Content-Type:Date:Message-Id:Cc:To:From:Subject:References:
	 In-Reply-To:MIME-Version; b=TQTUMkU/xyH8zT92TQ0Jz+e1L2diJbtUEHeH9q3uBKA9HO/+wFAtA/V7zzadDmX7grvXIbGcSPF27GaSGIiUEWBuYXpi/L1OfVGle39A8y5OzvOovJ8L/FdraDBa3ep2Kv2GcMp7qyVfhFOn776rki+5RsLMUBThHpiDe1xIWno=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JgVfoaO5; arc=fail smtp.client-ip=52.101.193.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JgVfoaO5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rqwHi7RhaZBIgTrLZZ27nbwLRTOtGxRG2UulfRUBQJE2WlbFkvXXBwFFtgoq/spTfi7//Va4JGKBLa+NjosTO7mKNg0F4BNbYXIICX7G+3lGvKK7Vpv5UdPxNQeKCbqVv9AweI7a5QrDDGUdbk5J/Rs3PQqVDJc9oNJaedWZBpI6puFpSd3sZuErMTuGjYczZYc8vNWusoC05oh0+KQOG8l6/ma5GPGDLuycaoqlKn6m4TiiRTh1jCTgcMjM3u712eGMaLhR/frOHaoAM65FwJnh/nUzkNpiTOdVZRdm4nw47LDZFmznk1+o1PkmltD7mNxfg3TTD9FdHM5bKFAU8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g1lUQ8omS5Rwob/hWT5Q7RbZyhCNU+9dYjbYv86dm8k=;
 b=kyTDefdoUc8vAyf48pIWZGi9sQ4q+zEwH/tb60pvPE9yv7i/Yp/moS3Uoi3A9Ly69lgaUA5S70UxYK3x44q0E/5xwHQl65ckoRS51BF73/IV8eekAs9OAKaivPC0rU3gobNBYLiSI/NFHEnMiioYXlRj9aRdwKfmtnpl1tayxXYMMcDm1mY2diCtFSld5Ja3jHj3doCQfv4QOtzWaGU0f8WL7356xaj8ayr0cR66MbjS9mRvXEZQKcGEhCB24G6LPkOs2gXemW/xyLVTqfwEO0l78M4Qt2W6+OCnZSM5f1sAS97kBDMxGxdJ0T2BCYltaU0dJXKCuGaF+t+vNnkPGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g1lUQ8omS5Rwob/hWT5Q7RbZyhCNU+9dYjbYv86dm8k=;
 b=JgVfoaO5Ob6GIlcwQz9UOebUfYT0TDsqp8G5TSIT1k6vNCa9TAsb9h7Qp1dEmKqsgwxbv54NrQmQzePNmZIgj5qepWfCMqjV+6Onb9VfrnjOzIAp9oit41eqD9QuBXphNjs9xc6ownC0TP2ocl9DlIr9sxUwngYR5+tx988ar0Dj8BXT/8FryhtLBR7iQqLEPMbpVRNuNUu6h/qURENN1i0H99ixV97ihYf8tJoV6/HWXhnaZA/WF5zZpyvPmhVvconmpeI/X0K1DzuadA4rpSdgqI0hvUG2VUEV2DW5dHyI9b2+Ggs0BHx4uhHXkvjdrd7uZJBa34RcP82/txdApw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS7PR12MB5742.namprd12.prod.outlook.com (2603:10b6:8:71::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Wed, 9 Sep 2026
 02:33:52 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.005; Wed, 9 Sep 2026
 02:33:46 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 08 Sep 2026 22:33:44 -0400
Message-Id: <DLAFND3OZSN5.2QM9WPRWMQSZ0@nvidia.com>
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
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
X-Mailer: aerc 0.22.0
References: <20260904115629.3993331-1-dipiets@amazon.it>
 <8cc503d9-04a1-4d90-874c-ada6c0ac5147@kernel.org>
 <DL6MKKOOL5DX.1R3Q77UTXBFYT@nvidia.com>
 <be13228a-f35e-4868-9b56-6452c34abc60@kernel.org>
In-Reply-To: <be13228a-f35e-4868-9b56-6452c34abc60@kernel.org>
X-ClientProxiedBy: BLAPR03CA0128.namprd03.prod.outlook.com
 (2603:10b6:208:32e::13) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS7PR12MB5742:EE_
X-MS-Office365-Filtering-Correlation-Id: 33131d6e-c42f-495f-2ff2-08df0e1ac5ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|6133799003|22082099003|18002099003|56012099006|13003099007|10067099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	UFhhlm5UvYoogbOsnSkq+9mVGfafZbsJEZhvaLkGdWJoVw3C6ZLJCnD/IPjaURPJSptCiHsB0QjhP9ZC4Qu5Wl/L10b062J4GyIS9WswCwnyG1GTMkM8CRRe0d9wwqK31lgyPHQxexBoCukn58mseOwQQziGZqvFoN2feYgaq6AhSxNg3LgSVHPStFXEzK/XttwJCUzF6whXPtt3YnS9xreD3RF+8wgrFmLmQWZeTuJQftdgVxXFoHNZuD9qMVIS8TRgCAG1R2lzeOjGy0IqRuSSdo+IetKrfpmDWFz+PKii66vaEz6IN4ApWb5qpPw5m6VOWeOwYc1W6xwdajT0nOn9ZNcRlD+fSgazWWOKAGge5iY9qMRdTrfAsj7d/uNjpLQEMuKKHcCf6nj8NQOZaorUlK48vfdom9v2us8AM1FCtIQmw47BdyUod6vqU3kM6tgzaK9v6dFhiyOfPF0si2CyD+OWiCjOdQ9tfeoXBIADEobz2AvEOMqnmf3QyZts3l2R1Imr9Ht6UPa2hPoNo/v08zybdMuvLaY9pnHDQD34AdhrTzop4lZomAAXW+pdG4RkL9jE6mEd/s2u1GwPsdmtG4OX/bIIuIPs0mSkCOxMnfdpt+kX2xmPzHuhmh3KhXG11hVE0A/fww+mvglrPcft+0PZ60lCBoNEr18xx7s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(6133799003)(22082099003)(18002099003)(56012099006)(13003099007)(10067099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SG1lQk5XeE5hc1NPTE5VU3l0dmtlN0cxSE5iOEpTMFRvZFZJVEtiZW8yeVZF?=
 =?utf-8?B?V0g1RTNicURvOHJGMmdmMFRySnZIaVo1cm84bFh2V3c2QjhtZzJ3TWE5Mksz?=
 =?utf-8?B?cTczdFBSUkx3amlCejUrbzk4ZXFiNjRRcmUya2crclEvWG9QQTRZcWlZUTc2?=
 =?utf-8?B?NEN5K0VlazZhWUdkVG5va1QxV0Z4bXpyUFJQNUZzenF3alFRUUEyN0NtMnRs?=
 =?utf-8?B?bmJtNFMrMTdMT01RR3RESVlSbWdvclJlc2x6b3phdkZGNk9NSDl2NnQrU25n?=
 =?utf-8?B?OThRYWRIWXdTeUVabWErUmxqaExpZmtkemE1bGJkRW9YdW8zbjJRQzBGcmlv?=
 =?utf-8?B?QkVGT29uci9pMWV0TDczYmJiNWFGVUZMQXQwWlZBZGRlbjY0Yk0vMXBWSDVr?=
 =?utf-8?B?T29wVTJHTUlOMmZQeHo4ajJQaENKa2ZXdHFxUXdsV1RDVTFmTjJVSnNXWDJj?=
 =?utf-8?B?ZFl1Y1lHL2grZU9UczNIdEQ5ajRuZjF4WENXV2pFMDk2Vmc5QlRiRWU2Wm0r?=
 =?utf-8?B?Rk9vMitpblJ6MEtCS2l6RmdtdERoNHE5VmhNN0JtbVdhN0J1WCtwbmlTZUF2?=
 =?utf-8?B?UnNmRVgxM3BBUGcvbko4YlhrUXJ1VkZJeFVzdVBOeXNmMlRkTTlIVkdnNlVi?=
 =?utf-8?B?eW1hVFZ0UmtXak52MWVSblpsb1hpNDY2WWVhTThtTVh5UjAwOE9hbGVpVjN2?=
 =?utf-8?B?cWczZlRIUE0xTXB6ZldBOHdKRGtnMGtwNEtXK3dpSlErZGkyWHROVDcvUjll?=
 =?utf-8?B?cFd1bGhBaC82MHByVGJWWUFhWFdXUWthVG9kZ0gxa0JSaWJHa1JzcXk0dkRQ?=
 =?utf-8?B?OE0vdnNuKzVJRDg1NmNVZVJ5aENPMjl3UGgwckpOVmMveFRhZXh5MHpPKzlJ?=
 =?utf-8?B?SnhtbEhwcVhPRDhpUlR3VnYzaWIwcVpPU1NNVUF5ZFF5SU92Y2xKaHdYa1RH?=
 =?utf-8?B?TUJLdlcxM1ZodlJoM1N1aWt0enR2c2tyR1pxQXM2bkRmVE5sQUJNaThTaXY0?=
 =?utf-8?B?MGlTOSthRlkxVmpDQXdDemx0ZU5oc0l0dk9tWTdxc2YwUEZvSVExaXY1Smpx?=
 =?utf-8?B?MnkrN3ljNVlMNUR1bHV0VzRPaWdRMXR6V0xnbzZtem9kd3BvYnIvekZaOFNs?=
 =?utf-8?B?ZDlVOW1lL3lRajNnSFhoOVByZXg3OUpDeU9QYnpJYnAwKzVtV0ZOWVA1WWlm?=
 =?utf-8?B?ZHd6MXQ1YmdvQlRSRVRGT05CL0tSZTFEeWwveUNqdGtONXZFS1hKTEpFcFNG?=
 =?utf-8?B?azRaem91UDFqRUZCWGtwZFFTS0ZUVDI3VU90amVvSzNBS2tuYmlOQVhYVURR?=
 =?utf-8?B?Zmovc21zZVJTYm9mL0VDZVBxTmFINXU3MWpieHJUSEVPdjFCSDRYL0dSak5y?=
 =?utf-8?B?SlZzYWNqWVFtNGVtVmJJcnJJQkJSM1h0enhvQWpzRVJJMENEWkhOajJtVXBE?=
 =?utf-8?B?bWMwZEo5dlJZWjhhRjcrTmR5cUtHcC9yRzhCNEVLSWFkTkJXZEVmTEMva1B1?=
 =?utf-8?B?ZDZHSEd2UmFoZVp0cHpFNHUvUjNEMFhWQzNwT0ZFVStidjVnVGJqQnhJeHA5?=
 =?utf-8?B?anY3YzkrYW5qeUVxKzF0N1ZGZ0hwcjVsRDN5eDF3cWl3TGlpYTBEamZMNXRx?=
 =?utf-8?B?UEp2SVpIa3JsVnp2bllxbndJbDN5OWxSdk9pbVluRGQ3MFJqVXN5SzdFdklx?=
 =?utf-8?B?SldVT2JhdC9MMnFTR2JQaGxlMTY4KzlqYWZTMk95bUxwQi9vV1AydllRamtK?=
 =?utf-8?B?SzVEWERRUG1rN3RzYnR0T1IwemVRWEt4L2V1azZ4SDNzQ24yUU5sT0t3dVFB?=
 =?utf-8?B?bm1FYjBTT2szeDFWMEppMVVJWGVNOHpDZWxtVC95YXo2aWJFVzRRMjNRTldr?=
 =?utf-8?B?U2hZMk4yeFBCbWhTY3hWWC9IdkFTeDhxcVVVOWVoeHFRNUdmZkh5eUNmeko4?=
 =?utf-8?B?bWdJZXYzcVFaVzlkZWhwQUxsaEk5R3p0Mk5EUEtrazRYMFZjN1pMTEhUcWZs?=
 =?utf-8?B?L1Fha2ZzM0ViVXJZQ1JLdDJXSjhnTHhuUnhBa0dPS2lIb1RrTFdLRVdzenp6?=
 =?utf-8?B?Y1F1TmNGVlFiOFBaNGhjc3NMc3NDNW5QWGROTHZYMWxuV0NsN0ZPWm9tVmhT?=
 =?utf-8?B?TlFRM1BuajRuMlNlU0J3YmRwTElvRVFsZzU1UjRRS3NrNlVWS2ZPZnFnNXpP?=
 =?utf-8?B?Q2dzVndrY0gyVThhZmZVTTBlL25yZmUrTG56TXZZcHhOb2pBQ3NNV3ZIUGQ0?=
 =?utf-8?B?VnVxMWlNV0ZzNk1EWGpZVHU1ekdRdlMyTk1TSHg3bnFQZ04zbzZVUk9DRytl?=
 =?utf-8?Q?n7IPgbTBYcJXeweivc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33131d6e-c42f-495f-2ff2-08df0e1ac5ac
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2026 02:33:45.9544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CGRaJd3+pax3trl9T9liCC8qaa18xOPWWWZJdhfGmKuuU9PaHvmZMbz5knDnL+H7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5742

On Mon Sep 7, 2026 at 3:30 AM EDT, Vlastimil Babka (SUSE) wrote:
> On 9/4/26 17:08, Zi Yan wrote:
>> On Fri Sep 4, 2026 at 10:11 AM EDT, Vlastimil Babka (SUSE) wrote:
>>> On 9/4/26 13:56, Salvatore Dipietro wrote:
>>>> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
>>>> introduced high-order folio allocations in the iomap buffered write
>>>> path.  When memory is fragmented, each failed costly-order allocation
>>>> enters __alloc_pages_slowpath() which runs direct compaction and
>>>> drain_all_pages(), causing a 0.38x throughput drop on PostgreSQL
>>>> pgbench (simple-update) with 1024 clients on a 96-vCPU arm64 system.
>>>>=20
>>>> The root issue is that direct compaction is too expensive for hot
>>>> allocation paths that have fallbacks to smaller allocations.
>>>> __filemap_get_folio_mpol() already marks higher-order allocations with
>>>> __GFP_NORETRY | __GFP_NOWARN, signalling that the caller can handle
>>>> failure.  However, the page allocator still attempts full direct
>>>> compaction for costly orders with __GFP_NORETRY, which is unnecessaril=
y
>>>> aggressive when the caller will simply retry at a lower order.
>>>>=20
>>>> For costly-order allocations with __GFP_NORETRY, clear
>>>> __GFP_DIRECT_RECLAIM at the very start of the slowpath, before
>>>> can_direct_reclaim, can_compact and the nofail checks are evaluated.
>>>> This makes the entire slowpath treat the request as non-blocking: no
>>>> direct reclaim, no direct compaction and no drain_all_pages() IPI
>>>> across every CPU. kswapd (and in turn kcompactd) is still woken furthe=
r
>>>> down for background defragmentation, so compaction keeps working for
>>>> long-term system health while being removed from the latency-critical
>>>> direct allocation path.
>>>>=20
>>>> Allocations that also request __GFP_THISNODE are exempted.  That flag
>>>> pairing identifies the local-node-first THP attempt issued by
>>>> alloc_pages_mpol() (mempolicy.c), which relies on direct compaction to
>>>> form transparent huge pages.
>>>>=20
>>>> Test environment:
>>>>   Hardware:  AWS EC2 m8g.24xlarge (96 vCPU, arm64)
>>>>              12x 1TB IO2 32000 IOPS RAID0 XFS
>>>>   OS:        AL2023
>>>>   Kernel:    v7.3-rc1
>>>>   Database:  PostgreSQL 18.4
>>>>   Workload:  pgbench simple-update, 1024 clients, 96 threads, 1200s
>>>>=20
>>>> Results (average of 3 runs, TPS):
>>>>=20
>>>>   Config                   Avg TPS      % vs Baseline
>>>>   baseline (no patch)       59,408       -
>>>>   With this patch          155,409      +161.6%
>>>>=20
>>>> Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon=
.it/T/#t [v1]
>>>> Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@am=
azon.it/T/#u [v2]
>>>> Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazo=
n.it/T/#u [v3]
>>>> Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
>>>> Cc: stable@vger.kernel.org
>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>> Cc: Vlastimil Babka <vbabka@suse.cz>
>>>> Cc: David Hildenbrand <david@redhat.com>
>>>> Cc: Michal Hocko <mhocko@suse.com>
>>>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>>>> Cc: Matthew Wilcox <willy@infradead.org>
>>>> Cc: Christoph Hellwig <hch@lst.de>
>>>> Cc: Dave Chinner <dgc@kernel.org>
>>>> Cc: Ritesh Harjani <ritesh.list@gmail.com>
>>>> Cc: linux-mm@kvack.org
>>>> Cc: linux-fsdevel@vger.kernel.org
>>>> Cc: linux-xfs@vger.kernel.org
>>>> Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
>>>
>>> I guess this will have to do until unlikely(we figure out a better API)=
...
>>=20
>> We could add a "new_gfp =3D gfp_policy(gfp)" to adjust input gfp based o=
n
>> various policies we currently have.
>
> Maybe with the help of alloc_flags to avoid the limitated count of gfp fl=
ags.

But alloc_flags are not exposed outside of MM, so alloc_page*() users
are still limited by the existing GFP_* flags. Are you suggesting
alloc_flags could be an addtional input for alloc_page*()?

>
>> Even better if callers can do that
>> instead.
>
> Not sure about burdening the callers (e.g. "every filesystem should do X"
> etc), unless they are some intermediate wrappers within mm itself.

Not all callers. I assume gfp_policy() will only be used by advance
users who want specific page allocation behavior without knowing the
details of the page allocator or changing how the page allocator behave.

> For example, THP (but only anonymous?) is now handled in such a special w=
ay,
> it could be a candidate. But I also have a vague feeling this was already
> done in the past. Worth investigating perhaps.
>

The number of wrappers can grow if different users have different needs.
Some might not want direct reclaim, some might not want direct
compaction, some might not want kswapd, and so on. I am not sure we want
to add wrappers for each.

For this patch, the caller can use gfp_policy() to strip out
__GFP_DIRECT_RECLAIM based on the conditions and pass the adjusted gfp
to the page allocator.


--=20
Best Regards,
Yan, Zi

