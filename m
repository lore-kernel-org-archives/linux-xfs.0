Received: from mta0.migadu.com (out-7.mta0.migadu.com [91.218.175.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEDE47125C
	for <linux-xfs@vger.kernel.org>; Wed,  9 Sep 2026 10:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788948173; cv=none; b=ATZ30+Y2Tr2c4k8WbGq68QG9yILoFexq9tmOZ246qozIOE67xfawlvTXV8H8F77N1bj2FhK8VtwxOFLSPJST74tKRbCYIHpgQK2grT5VDZv55h/e/7tcBXx9zsR2EO3Uwl4pP17vdSOPNd2xCB57HRHm/MJ1H4J6rIMbhnXYDX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788948173; c=relaxed/simple;
	bh=m//qkx0KbTFibXUztG1vNBFPNzkzWbof/D1O8o9BQjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cipKA9+axTmTkEJKlr7mMTBNtg91V3RaXJqGl1pEPc4F+QJAoesT/Mk9u5iPKT2vEywrYWxxKVEAXK4MsMcO1lnaMh6BB/87hK+Q8olYoYRmVFYzDeAO7ERxWHuXXPOEn+W5dO+7f8MKvPwl7upNs/fF/7DU1T74b69xOhxEBpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xNyQ0Onr; arc=none smtp.client-ip=91.218.175.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xNyQ0Onr"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=m//qkx0KbTFibXUztG1vNBFPNzkzWbof/D1O8o9BQjE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788948168; v=1; x=1789552968;
 b=xNyQ0OnrVl8pSF9kW9jF1oWGPMWCYbXb53HXpU5ULX52CXjVXjkqiXOGKQntbE2I8B/JkqcQ
 fCFot3UKe75GHc0UQ/Klt/kSjNrJQ3Hi84bYkwtBYMKviuWMkbOXSIfPpuPs+MBUeoeAkd06wHC
 hcBacTEeuUpSoLUz0UNRqoys=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id c6ae4e2d42fbd256;
	Wed, 09 Sep 2026 10:02:47 +0000
X-Mizu-Trace-ID: c6ae4e2d42fbd256
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Usama Arif <usama.arif@linux.dev>,
	akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Jann Horn <jannh@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: Re: [RFC PATCH 0/5] mm: sub-folio dirty tracking for PTE-mapped mmap writes
Date: Wed,  9 Sep 2026 03:02:39 -0700
Message-ID: <20260909100240.635595-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260903182943.662461-1-kirill@shutemov.name>
References: 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu,  3 Sep 2026 19:29:38 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:

> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> A store through a shared file mapping dirties the whole folio. With large
> page cache folios that turns a 4K store into 2M of writeback: one dirty
> bit per folio, and writeback has no way to know which part changed.
> 
> XFS already knows better. iomap tracks dirty state per block and
> iomap_writeback_folio() submits only the dirty ranges, and the buffered
> write path sets just the range it copied. Only the mmap path throws that
> away, because iomap_dirty_folio() covers the whole folio.
> 
> Narrowing the dirtying at page_mkwrite() time does not work on its own:
> set_pte_range() batch-maps a whole folio writable on the first shared
> write fault, so the stores that follow never fault and never reach the
> filesystem.
> 
> So harvest the hardware instead. folio_clear_dirty_for_io() already calls
> folio_mkclean(), whose rmap walk reads pte_dirty() for every entry of the
> folio and throws it away. Those bits are the only record of which parts
> of a large folio were written through a mapping. Collect them there and
> hand the filesystem the runs that were dirty, through a new
> a_ops->dirty_folio_range().
> 
> All of this is about PTE-mapped folios. A PMD-mapped folio has a single
> dirty bit for the 2M it maps, so there is nothing finer to harvest, and
> it keeps writing back whole. Keeping shared write faults off PMDs is a
> separate patch and not part of this posting.
> 
> On a 512M file in 2M folios on XFS, storing one byte per folio and
> calling msync() wrote 512M before and writes 1M after, with identical
> minor fault counts.

Hi Kiryl,

The motivation makes sense to me. I will look into the patches.

Just wanted to check, the above xfs example, is that on an ARM host?

Thanks,
Usama

> 
> Not addressed here:
> 
>  - Dirty accounting stays folio-granular. A 4K store still counts as 2M
>    against dirty_ratio and balance_dirty_pages().
>  - iomap_page_mkwrite() still allocates blocks for the whole folio.
>  - Filesystems without per-block dirty state see no change.
> 
> Kiryl Shutsemau (Meta) (5):
>   mm: let folio_mkclean() report which pages had dirty PTEs
>   mm: add a_ops->dirty_folio_range() and use the mkclean dirty harvest
>   mm: keep the mmap dirty range down to the faulting page
>   iomap: narrow page_mkwrite() dirtying to the faulting page
>   xfs: track mmap dirty state per block
> 
>  fs/iomap/buffered-io.c | 37 +++++++++++++-----
>  fs/xfs/xfs_aops.c      |  2 +-
>  include/linux/fs.h     |  3 ++
>  include/linux/iomap.h  |  2 +
>  include/linux/mm.h     |  1 +
>  include/linux/rmap.h   |  7 ++++
>  mm/memory.c            | 58 ++++++++++++++++++++++++++--
>  mm/page-writeback.c    | 87 +++++++++++++++++++++++++++++++++++++++---
>  mm/rmap.c              | 56 +++++++++++++++++++++------
>  9 files changed, 222 insertions(+), 31 deletions(-)
> 
> 
> base-commit: 0a0d1d55dad570724bf8c7ea83409639cfb4be9b
> -- 
> 2.54.0
> 
> 
