Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011064.outbound.protection.outlook.com [52.101.57.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFD634D4CE;
	Mon, 24 Aug 2026 19:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787599552; cv=fail; b=tdK2RpUIAu+j63jReSo8xVAvt8PPRt1fpLoLauKvsyENeyuYjRUfzgkcXCEobx0dn78VhmRKLAPTZCkmWEjOms6d7JZInck5ZDi6OHxRtdqqqst0eXOwJpxlb9ESEt197ML/UW9rx0tRO5+W8fJxcB0v4y4QA/KXNT+DJaxA+K0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787599552; c=relaxed/simple;
	bh=fBHh1+7if6hBN392A1LJiMMQ89S5+s2D9yH6aUdIuJ8=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BzYE0QtUBZqLcLQcfujEUZAXwrDuo+YbfTfHUWfmT4zyvJg4s9chQsctPuP1rFFWanz/aJaQW3ttFqPnsgkDxvthh+1K/tP3hoahci1EXnsVc7ijKJmhgwsIgWB8tEATvR5M67fqNI94DwH+0ePX7abHn11xthkEvUuNROPlze0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kWWX0xYm; arc=fail smtp.client-ip=52.101.57.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kWWX0xYm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qt18V1qAyvbgZDJnYogMa57Ybvl9DAqRCkC+99o3tnj+riB9MfbWppIUmVh82Hexwy9tPz0mII8c8yX2mKfC6VncjgXye5hM8wz2nonB5IjuwXOjDH/pj8gH/ZITF/tmCIkhFiasUCluNbxnyuVmxWSlNZF4qYmm9TdkSiEOyHEnyrfwVbO/OvVXPMu1fwjks6LZyRPixhCw3SiY8fxP6Za/jQnwvahJL+aRw6aSgTNu8ime8c6rn45bUbtdpavZIo7r4XYQkfMEBViIhfKmlQKwpAL6zCafJ5/MI/VLw4/yTOXGt/n2EKF7tROaZRevvEVnDEkQyv3ILmJZ5dLehw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jay5eZFjg4CWyyDc0JKQ8rfXRBb0O6lhKaeWP3PMIXM=;
 b=tAfwQADHPUOd0va++whM9Fy0pwl2CvaXwH3zvR+HdV05qGXZzGRzC6bPDWpY6RhLf3kkFHm6VOQN8WUhbm//pRWF+xn1mSAsNUhBAhjLA9SalLBqZW5VZpNPwngFpyqBRcuUiSi455RsZRPYbDvz9OQ7TDNSVqr9ObHeOXNuyQKypCpqYtt7COc/xsnwzmG50qLWCONDRrZvtX6atinNmEj6gyCFt3Oef776jsbaPHK36h4JH6iQQENherQZUTBc7NV02LCKzPkcXLfLfeunD6ndrRELisLYhzEL31KOc8rt0fvlQo3COsBUhcjFkP0CKZdEUNMeC/jWVDgH97uSEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jay5eZFjg4CWyyDc0JKQ8rfXRBb0O6lhKaeWP3PMIXM=;
 b=kWWX0xYmigzZkojQvjWQz7BtlVs3s5u7d5+FRG7dJI7e1Hq1nNann4khAe4agglfIeqSMJaviKy/KB0lts7K5OJ9ltBeNZZm2PtcMGLhYyPHV/PYXgp/N3nvcqE5YK9ZhfpGPY5oIwwnAqMxh8uY/C+FgObIY09GQmRSLi2/0novSJWZsz9jq3UMw0LhUqTtGQP2lb80v3kAy0Ue+vLTRak8/e2NEfhG923VsbTVnoC/0mcKR8wSj7uvwdknmTjvhCdoMLF9Cs84Xi3j1OECrUHdTRT3ZXYjfNzjk9cwxg+u9yjWqFa9Lc59/Fu61Se70WeNyRerrcFD+nM0ZOLQLw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 CH1PPF4C9628624.namprd12.prod.outlook.com (2603:10b6:61f:fc00::60d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Mon, 24 Aug
 2026 19:25:44 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%4]) with mapi id 15.21.0339.012; Mon, 24 Aug 2026
 19:25:44 +0000
Message-ID: <5f4ed03c-e91f-4641-8964-cca0391971ba@nvidia.com>
Date: Mon, 24 Aug 2026 12:25:42 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: Removing ->dirty_folio
To: Matthew Wilcox <willy@infradead.org>, Pedro Falcato <pfalcato@suse.de>,
 Christoph Hellwig <hch@lst.de>, Jann Horn <jannh@google.com>,
 David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>,
 Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>,
 "Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <aoyWln-Gt-yvZQkE@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0023.namprd10.prod.outlook.com
 (2603:10b6:a03:255::28) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|CH1PPF4C9628624:EE_
X-MS-Office365-Filtering-Correlation-Id: e3e72e29-f1b3-4edb-a62e-08df02157e1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|921020|11063799006|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	LSboEcZixpk29s7Q2+HgjWkukV+M75bRusihV8k4EDo6YFaM+4GMFIB/wtJpPgiVKB+nTlGhPGCWMmD7LyZF9XYgkGZQ8cPnP0mm2bz0l+Trt/yFpDIQ/k06FfeHjKCTW0g91ITPuVTbRrFcC2XmSRPT5OMvGVhBPtgoM/pmcFdrU+Hh8UM1hCJso5EBmt3iciZB5B+vV+ZLH95TGRmcaVDTqktiUNN1CX6LRQucAR8qRt9u36nH114lnvH9D7bP7J4id0MXt6kRVqaJVBgBqtqrqBq6RPsdGzRFdTmqYs7aprNUpuZbl2Yv2eh7PGxiag5pHpUyPMZUs+C2GTWSr7J0iC8kC8hAPf0PdaTF9/oAuS/kWFSXLkdI701g5VGNxofdyadkOvh5bf8361l3+On0dZdYoH89ifBphka1trE4CQIsyLstnxjEZ/DTr8p+K0ySU+d2ZzW7LSFSwOogdsacSL/JXC0GJl/fuQFfu6LxkD9KJjz0SGkjiQ3R7XH49lzVfHBwmrpiVcoBjOTAPzE7IdX1GV8lKsKwu+SrDqn47bzheH/E68CvlntzqFf1qwdovKKdD95lGq5A3JfoKHTxs59vIv/2LXajXI8qE8frouB9FD27IdFnmiwup9qaO2HoJvbJmYP0B+ccoVbhUq9emfgnU0EyyZov0xG12dxTo1rgi8kY134fzQCbspRzZ5KtQ3pYAYZ++2Bz64Qt4A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(921020)(11063799006)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WjgwZEtKQmdweHQ3VEF2b3ZzdkpmMVp2OHZxVFpMZXFKWDI3TThjdXN5cGd5?=
 =?utf-8?B?SXlmQXQ5OHhIampWWmVnVDI5WkdTRGQvdVNidUhlMWdBS2VNeUVPZWVYM3Z2?=
 =?utf-8?B?ZFFVSFA2UXMvN2dvUGxCRStIakdINkdQN3RjdUp3SFl6R21SS2REeFJFanFv?=
 =?utf-8?B?K2hUZGtzSWY0RmF2SVJsU0hIbVo1SDkzcU0relJEU3JSZHBQcE9TakxMS3ho?=
 =?utf-8?B?M0RrMVdKZW8rek40YmNkUExQMngwZTIxT3EwTHp4ZW9wcmtXMHdQek5ZZ1Mv?=
 =?utf-8?B?ZHdCWkF5cTJKTWIzWXZNcEloRFRVc3Y2SEN1L2lZUTdMUjFFdytHWnN6ZE8x?=
 =?utf-8?B?bVJlRUFOcTNjWFVOUm8zRFB1aS9oNnVacGx0VTRUK2k0Ni9BMUk0WTk5TlNr?=
 =?utf-8?B?QlZFc2VhZUJWUmVnWmxmR2J1YmVrd2VUUHZadDVVYlJCRUdpTEFqWUc2bU5G?=
 =?utf-8?B?dGJoSW1Ja0lRZnpQSlEyazJ5V2JITWFkS2I0c1JuRGRIUlNkS2xTTmlpRk4z?=
 =?utf-8?B?cTcrWlhrMVd3em5URDJxV0pjUEdnaWtBeEdxWTByWVRWc1RQeDNXZ3ZlcklU?=
 =?utf-8?B?YjZDZFpEbnF2S0NJbkxPODlQUWFCR3VXeFVTV1ZZTkxFTnpvVTNxdDIxT1py?=
 =?utf-8?B?eUZmUDBPMHNrRlBSZCtHb251UkhMUG1UQTRlSjUwVWZTejNGcGNpbS9PM0Fi?=
 =?utf-8?B?bU94RXlBelVDYjlWNm5FSzUwNDZiNmNQdHpxZDNvano0cDNaSGRXUWZXN2RX?=
 =?utf-8?B?Q3ZkdEI4cFM5ZElqVVRkM2NVa21CbmhLelJ4WHErMmZ0eUFKcVcwaDc0aEVZ?=
 =?utf-8?B?dlloL01XeHo4eWpHK0s2dnJmeGdLeXhyZkxCdnhqYnFnUkhHUTg0UDN6cElT?=
 =?utf-8?B?UXVKcnIySkNiMWFNZGZib1VIRVFJcjBJbmlMR0hJeXRvQldyYXR3Ym1RQmhy?=
 =?utf-8?B?cXRIQitHOCs3WTE0TUVUWUdqZEFsejlnS05RWm5vcGZGL0RpKzhkMWw2TVlX?=
 =?utf-8?B?eWtQZU1DVmM3NWRjbkc3YUNKRmVpbWZOQUFaZzhxVWw3c0lqcUpXdWhHNzZw?=
 =?utf-8?B?TGd2bURkTFEwM3g1Y1JEUHZLd2poR3E0VmcyODJuWGhPMkxSVGhVK0pQVFRl?=
 =?utf-8?B?TVZVSWg2bHNWbXRqQmJwNmpHNUdxTWJtSXNsYWZwNkhTcngvRzhzdDRHQk5B?=
 =?utf-8?B?N1NzQXNUL2lGWGFCY3hUcjdRd3d1V3RESTNWU05QU3JrK2t3T21ucnNEb0gy?=
 =?utf-8?B?TlhlTkE1bUd4QnRrNEwza2VoNWVTM1AvRk0yNW5aZ082bnNQOXBzVUVNNmZm?=
 =?utf-8?B?REE5TUdIaDd1eVQrSjRubGN4MDBIVGNMY201UUtzZlRRV0c0eU9zUnJNdFZO?=
 =?utf-8?B?enZTTDBYeVgwTkJ0bUFjNmNZdEFtUlViSlNXdk5FT0N1S1cyTzI5U20zT3U2?=
 =?utf-8?B?SGtuRXdoRnNucFhnOHE5YXFielVLN2dMbWh5ZHk3d1hRK0FyU3YrbGZuSWhQ?=
 =?utf-8?B?YzgwaFZmNVZpeG8raFgwdWtOUE1CbVlhbElFYVhab0lCY09DWjdybnh1Z2ZS?=
 =?utf-8?B?cUt0dzRQbkIva3ZxZEhjT2JzdEx2dHRpSml5ZGFkWS9vd2ZhK0RDUVB4UWdy?=
 =?utf-8?B?NjFhZDd4TldZbVR0YUtmY0RoU2FINE5HVUxPdnBLdHNZNmdYUm1ReFBoM09N?=
 =?utf-8?B?V0pPajl3cGdKR1hXSTRKcnltaHRNOWs3alMzTVpOcXNRQXN4R3lZS0VjdXk2?=
 =?utf-8?B?NkxxYnpkS3lrckFEckxmQmFkQis2VGozSzFlV0EwbDJtTU5UMmorQ2ZTOEor?=
 =?utf-8?B?MndrU1B3Z2FQNDR5U2dOdnhiRzVVcUdGeHVkRmFITjZCK2ZqckwvcFVROXVk?=
 =?utf-8?B?NFNJN1FxajZ6UnRYVkY3K1c0MTV1NTV3UVBkSWcyTHhTTzFFaHNwb3hLNndG?=
 =?utf-8?B?MysrRzZxNW1TYWwxWVMwR3hJM1k5eG1rbEZpV0QrTkc1U3J2VjlCQ1FyVEZq?=
 =?utf-8?B?RzgwQWJiVmtSc2s4bVkxZDZQdVY1ZzkzdXovL1hnaCtvREpYTWVSMzBDM3F0?=
 =?utf-8?B?SnJuM09BdVV0ODVUSGFLTlZoSnNNSWNuNUhNRGRKUUZpNU5SV3ZUaHhPKzV0?=
 =?utf-8?B?NzVvVGkwQytyaE4ybm5EUEJhWWJoUHdLSzRZSXVDZFlVaDVLeHZYVGVjRCtD?=
 =?utf-8?B?Si9CZWhnbk9sWHFFK2Z2RTh3TzFTQ3YwbG5saVQ1RE5seE53UEp4U0xlaTFM?=
 =?utf-8?B?U24rbGlFUFdvdXJoRjFZYTc0S2tma0M2emFhd04wcTA1eE1EQWdTVzZZNWl3?=
 =?utf-8?B?MWswTWc4R3h0eG5LRGFsMTVJNHc5TXhTeEJJblpHOFZ5TytHeDFmZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3e72e29-f1b3-4edb-a62e-08df02157e1a
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2026 19:25:44.5763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rKH2LORzYQsAx8PKy37tUK12lnfE9EVcfzm0smuCrsm6qJX0utE7tucgkKN7/cHHD4QqU7ZpaIGQMp6COt3YSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF4C9628624

On 8/24/26 12:08 PM, Matthew Wilcox wrote:
> I think it's time to remove folio_mark_dirty(), ->dirty_folio() and so on.
> 
> This is not how filesystems want to be informed of folio dirtying.
> It was fine for ext2, but anything that's journalled or COW has work
> to do before the folio is made dirty, and it's hard to do that work
> under the page table spinlock (not all callers hold that lock, but the
> filesystem has to be able to handle the cases where it is.
> 
> Filesystems want the page_mkwrite() entry point to be how they find out
> about a folio being dirtied -- and that works great!  Except that we
> can writeback the folio for a number of reasons.  If it's been dirtied
> due to a shared writable mmap, that's fine; we map the folio read-only
> and any subsequent writes will re-enter the page_mkwrite path.
> 
> The problem is GUP.  We have no way to force the GUP caller to go
> through page_mkwrite again.  So instead we make the GUP caller call
> folio_mark_dirty_lock() which many just don't, and generally we get away
> with it.  But it's a bug, and a bad interface.
> 
> There's also the problem that GUP users bypass the folio_wait_stable()
> mechanism.  If a page is written to while somebody is creating a
> checksum over that page, the checksum will be corrupted.  If we want
> to fix this, we have to bounce-buffer the page.  There's no way to
> prevent or delay a GUP user from writing to the page.  Enjoy your RAID.
> 
> My proposal is this:
> 
>  - Fileystems take note of folio_maybe_dma_pinned() during writeback.
>    If it's true, do the writeback, but retain/recreate whatever data
>    structures you need in order to write the folio again; behave as if
>    ->page_mkdirty() had been called again for each page in the folio is
>    marked as dirty.

Yes, that would work nicely.

>  - The MM behaves similarly; we do not clear the writeback flag for
>    folio_maybe_dma_pinned().
> 
> This will have the effect of writing pinned folios back every time the
> inode is scheduled for writeback.  But since we have no idea whether
> the folio is actually dirty (because the GUP user won't tell us),
> this is the correct behaviour.
> 
> I'm probably missing some stuff here.  Let me know.

OK, so working through the end of the pinning, I think it still is
correct: device finishes writing to pinned memory, device driver
unpins the memory but the page has been left marked dirty the whole
time and still is, so the next writeback still does the writeback,
but this time sees no pins and so it marks the page clean.



thanks,
-- 
John Hubbard

