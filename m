Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829AD2EBDFA
	for <linux-xfs@vger.kernel.org>; Sun,  3 May 2026 10:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777805851; cv=none; b=r6QXBqeXfPAsARn7grkzlmIuI0HLZJ4yIVtU7nw9czY4k5oiP7/mgvM+3vcQxEJE23HgNCru3ku6D82bGdnFer3NiVr8S1dSK6rym1rVTLovTqhm33jNK8BOa9BfLBC58pm6T6pVTBxA53/Zw2+tDjWqL8nD9jj71QKr/fnoLbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777805851; c=relaxed/simple;
	bh=UAdUkLzv1/CBpCZoLwjYXVHI+6UxPlvjo62v/bFnd2M=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References:
	 MIME-version:Content-type; b=sV72k6nRyWavRfWG67Uq/zXIum3yJZ1Y/+5S5CqColeVcHY7k8AfuSTOjMnE4wdJTgBWgolcYfKShgsI1IC4CfjPbjUmuH9iEZrYLdcZwa5N51fXczSwBTqiKSQyIlMee+rgqbLCtgm1SVjIRLb1/kroUGmEhqDVNiYGqUKaYQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VQo9T0Jl; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VQo9T0Jl"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2b9e9a6802aso5303815ad.3
        for <linux-xfs@vger.kernel.org>; Sun, 03 May 2026 03:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777805850; x=1778410650; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ys4F9jLZCUagMJPlUlEDYoYDPgQdni61LpfAhjLSMOE=;
        b=VQo9T0Jl7hCFn82WjAz4QI/gl6AtPBIUEVb5iYYL04drteXcdofPecvc5hDoWI8W6a
         oQIPf8cFvOePpYzZfT/vtFn0XNLZZOAAx+Tlh0tdquo78Qor/MlEuUWvLhnPxpRDKlrT
         3N8QwsH/iK7y4ZVN1ws2KOTIuQd9HhodDqCRtV1lDYvX2sUthg0YJxEd/+6A9jPNNBfy
         N8dMTHlMo4+CE/OCU8tgBSw8omJe9XJ0Gc5udmz7a9aQHuAr24BtGYTmFivPl7aGGeqS
         v9LKuxu23/1uwRCM7ZH61OwxTaNqkBmuUqL2yi/R+POHA1iZDvJgXDEcjRz+tCjZkY/f
         7rRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777805850; x=1778410650;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ys4F9jLZCUagMJPlUlEDYoYDPgQdni61LpfAhjLSMOE=;
        b=TF/Qy/dxNfeWGJg0JI5sOYdmx6qfwCxK6e5R72Y46rZZOZEbn8QEL7HdVvDEL+dESD
         ejkQB1FM9U6/LiDYr/CJ55Wlt/SyUD+hlG0/TyKFeh7y9CVQ05ojU5c8ifDPmDqriXBu
         3c/8n7jMMQhHu5XRu1MGCrAJGIJT0yP/JSANIE3DUI6wU9pM7xznV3g6cg6WO35jteVq
         A3Xq+qs8HkgfH+Cwi56UobikczmibLSal+hqam5IiyvQ8E7a8UQtVqR372cJMiOcoWSl
         zwcRcjEGhn7p9+wdSvk5gNqB4KqcgsogIUGX7hp+5JycK+ZWFDfghIOJscVUnjOFr7if
         6CHw==
X-Forwarded-Encrypted: i=1; AFNElJ/YxT+OhIQZrKKXHvAvBTFm2mRKqdtLJfPi9Kvcb5U+kyl4e+Lemg7MPdeDy9XO3rrtxD03KJl6j3E=@vger.kernel.org
X-Gm-Message-State: AOJu0YxekRf4bVhjq8JhBJPGzwpqiXjfQgZ+TyD5UjvkhQp/3T4ltJwf
	hY7cIKIdeo/rV1e0o6UqS52rj3nuIz8E+fV6ARpuWEhPAUy/X0ymEHcaUohJXCk3
X-Gm-Gg: AeBDievSsDfz9PMkN+0JKOIspdC6IHyWOhymTqE18jvg2O+9V8fWBW6WMalNmZ6LInY
	1smqV5ykst9khsguo7XSNx7KepQkhFVTV413jOX85+dt7PkIHKB/28bKknC1JhReJVBzjD7Ea4y
	iRK0yBDPBWNe/XnAKW/MNuiB+ftSxvBvFakIh2uDof0Bbg6ivGRmhNmjF7rknL/VaXKNQxWu72o
	A/6PhRV16DovjahXyOi+N4og9fsfyIlNnhSO2ekw15ZRqJSnR+O+7ERi480SsPg1Dn/AKzLhN7F
	MSg52ah0EZGIu+rtou9thTISUx7bWFi9lyRx473PeOeGvkuY6P/TX58dBBkbVoJS22IK1Tq4f7G
	b9i+PnQg7QVxppXL+Z1cbatV4My34Itx3ZnVrP5BzkDmhjfNyf8D0nWfemOUHFaNfspL6TxW7lW
	MKP+RZoW1++25f6Veiq6WNEchWNDreJG6x
X-Received: by 2002:a17:902:708c:b0:2b2:b117:1d5d with SMTP id d9443c01a7336-2b9f282befdmr38615915ad.33.1777805849735;
        Sun, 03 May 2026 03:57:29 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9cae4a127sm94009995ad.67.2026.05.03.03.57.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2026 03:57:28 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Salvatore Dipietro <dipiets@amazon.it>, Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.com>
Cc: abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com, brauner@kernel.org, dipietro.salvatore@gmail.com, dipiets@amazon.it, djwong@kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, stable@vger.kernel.org, willy@infradead.org
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order allocation
In-Reply-To: <20260428150240.3009-1-dipiets@amazon.it>
Date: Sun, 03 May 2026 11:22:10 +0530
Message-ID: <a4uhrqet.ritesh.list@gmail.com>
References: <cxztt8nw.ritesh.list@gmail.com> <20260428150240.3009-1-dipiets@amazon.it>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit


Sorry about the delayed response, got caught up in some other work.

Salvatore Dipietro <dipiets@amazon.it> writes:

> On 4/21/26 00:43, Ritesh Harjani wrote:
>> Also, given the Maintainers (willy, Christoph, Dave) shown their
>> dis-interest in taking the patch in it's current form, the right way is
>> to get back with performance data with both the approaches (which we
>> were discussing) and first get the consensus from everyone, before
>> proposing this as a patch :).
>
> Thank you for the follow-up and the additional context, Ritesh.
> I might have misunderstood the previous request and will make sure to 
> link back to previous patch versions in the future.
> Here are the performance results that we have collected on our end with
> the proposed patches:
>
>
> | Patch                |    Run 1   |    Run 2   |    Run 3   |   Average   | % vs Baseline |
> |----------------------|-----------:|-----------:|-----------:|------------:|:-------------:|
> | Baseline             | 107,064.61 |  97,043.86 | 101,830.78 | 101,979.75  |       —       |

> | PG huge_pages + pre-alloc mem | THP     |   Run 1 |   Run 2 |   Run 3 | Average |
> |-------------------------------|---------|--------:|--------:|--------:|--------:|
> | on                            | never   | 189,418 | 187,764 | 188,207 | 188,463 |
>

First of all thanks for sharing the detailed performance numbers.

Ok, so here is what I understood from the data you shared.
This performance problem is mostly seen with PostgreSQL huge_pages=off
[1][2] i.e.

baseline-no-patches                 ~104K
v/s
baseline-no-patches+huge_pages=on   ~188K

Also the observation with huge_pages=off is - we have 40% of memory as page
table memory (as you pointed below)

> We do not use any tool to fragment the memory in advance. Collecting 
> memory metric of this system, we noticed that ~40% of memory is used by
> PageTables since PostgreSQL spawns a new process for each client limiting
> significantly the available caching and free memory.
>

So there must be 2 things going on with huge_pages=on option here:

1. Huge pages use PMD-size mapping, which eliminates the need of PTE
tables entirely. This then reduces the amount of memory consumed by page
tables. W/O huges pages, the page table overhead become significant
(~40% of DRAM), because on fork, each child process gets it's own copy
of the PTE tables (even though the underlying shared memory pages
remains the same)

2. The second savings might come from the fact that Linux supports
CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING with hugetlb. With this, the
PMD table pages themselves are shared among proceses.

[1]:
https://www.postgresql.org/docs/current/runtime-config-resource.html
[2]:
https://www.postgresql.org/docs/current/kernel-resources.html#LINUX-HUGE-PAGES

So the above explain the 40% of memory used up in Page tables.


Now this is what I believe could be the reason for memory fragmentation
with this workload - 
In Linux, each PTE page table uses 4KB size (assuming you are using 4KB
system PAGE_SIZE). When your workload forks a
child process for each new connection, child gets its own copy of the
page tables which maps the shared buffer.
Since each PTE table is a single 4KB page, hundreds of connections
spawning means hundreds of thousands of single-page allocations for page
tables. So it looks like, the major source of your memory fragmentation
problem must be these several order-0 allocations for PTE page table
pages.

Also as per the documentation [1], huge_pages=try option is the default
setting. So I am assuming in production we at least won't suffer from
this memory fragmentation, correct?

[1]: https://www.postgresql.org/docs/current/runtime-config-resource.html

> PostgreSQL write pattern consists mostly of 8/16 KB data but during 
> the database checkpoints, by default every 5 minutes, it flushes write-ahead
> logs to disk, which uses large folios. At this point, the system attempts to
> satisfy the folio allocation request, triggering the regression and falling
> into the slow path, as shown by the Linux perf profile below:
>
>   `-0.26%-__arm64_sys_pwrite64
>     `-0.26%-vfs_write
>       `-0.26%-xfs_file_write_iter
>         `-0.26%-xfs_file_buffered_write
>           `-0.26%-iomap_file_buffered_write
>             `-0.26%-iomap_write_iter
>               `-0.22%-iomap_write_begin
>                 `-0.22%-iomap_get_folio
>                   `-0.22%-__filemap_get_folio
>                     `-0.21%-filemap_alloc_folio->alloc_pages
>                       `-0.20%-__alloc_pages_slowpath
>                         |-0.12%-__alloc_pages_direct_compact
>                         | `-0.12%-try_to_compact_pages
>                         |   `-0.11%-compact_zone
>                         |     `-0.11%-isolate_migratepages
>                         `-0.07%-__drain_all_pages
>                           `-0.07%-drain_pages_zone
>                             `-0.07%-free_pcppages_bulk
>

However, I agree that it still make sense look into possible solution to
address this performance gap which you pointed out when the system has
memory fragmentation (with huge_pages=off).


> | Patch                |    Run 1   |    Run 2   |    Run 3   |   Average   | % vs Baseline |
> |----------------------|-----------:|-----------:|-----------:|------------:|:-------------:|
> | Baseline             | 107,064.61 |  97,043.86 | 101,830.78 | 101,979.75  |       —       |
> | Proposed patch       | 146,012.23 | 136,392.36 | 141,178.00 | 141,194.20  |    +38.45%    |
> | Ritesh's suggestion  | 147,481.50 | 133,069.03 | 137,051.30 | 139,200.61  |    +36.50%    |
> | Matthew's suggestion | 145,653.91 | 144,169.24 | 141,768.31 | 143,863.82  |    +41.07%    |


The main reason, why I proposed the below patch was because, this only
affects costly order allocation (i.e for order > PAGE_ALLOC_COSTLY_ORDER)
by skipping direct reclaim for those orders, while still keeping the
behaviour same for others.

So, for smaller orders (order > min_order and <=
PAGE_ALLOC_COSTLY_ORDER), the allocator will still attempt for direct
reclaim and compaction (which I guess is required to avoid oom too?) And
also, this looks like a change which could be easily backportable :)

diff --git a/mm/filemap.c b/mm/filemap.c
index 4e636647100c..f2343c26dd63 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2007,8 +2007,13 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 			gfp_t alloc_gfp = gfp;
 
 			err = -ENOMEM;
-			if (order > min_order)
-				alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
+			if (order > min_order) {
+				alloc_gfp |= __GFP_NOWARN;
+				if (order > PAGE_ALLOC_COSTLY_ORDER)
+					alloc_gfp &= ~__GFP_DIRECT_RECLAIM;
+				else
+					alloc_gfp |= __GFP_NORETRY;
+			}


But of course let's hear from others on their suggestions / thoughts.
Maybe the filemap is not the right place to fix this as Matthew, Andrew
and others were pointing. Any other suggestions on how to approach this,
please?

-ritesh
