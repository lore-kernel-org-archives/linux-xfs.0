Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78ADB2E7F3A;
	Sun,  6 Sep 2026 00:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788655362; cv=none; b=OxVto4pkyF/KdcclYyn+KoKAMNJoo6BJoVzI4VqdHHq6hcFpYq1s71djLM5HdNA/z1z804IAg8decGJGFyP2F4lLNKKPzG08iVCk0VfTgva/sYeqQUFLmwAQ9f8GD+PApjl4ctwC6Qhp8w6P8ICF2N4pVokVKK8OBoXw0gAS9xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788655362; c=relaxed/simple;
	bh=arFJLmH5jl9WeLftwszFDOgOlstbl9Zjhdw61LUG4kg=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=gK/cmuijgDes78nRFci2Ssu/rkE5d1Er/iein1B8VTJeXumUbo/6/jeItbtaXh47lQSiK7i9l07taUdvvrkGqDH+JXVBw41o08My1St5X236O/xNkLZdatpZfIsvNeJFvYywimmwgvrZz6F4mYRwx9eGDXlrmI4smEi09VPLwVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DH+YNIWa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DH+YNIWa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6881F00A3A;
	Sun,  6 Sep 2026 00:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788655360;
	bh=GM2SyBAgRCQZD95qhR+WEi9oXrPFIDHlTqyVd3dGmVE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=DH+YNIWar6wt1hdxQ72+7q6esIgjvBDieMtYb75WVM9L5FOTr3Ca3mSeY5LpHYALu
	 SrooTcOzf/OGvsFOC7HuJGILmvO8Epx7K459+4ZeWUlKIdeHNcjeY8SafIc1lx/13r
	 R/+GTdeReqy0Af0lnKAmyMndnjwjcW8qNm/zpDZQ=
Date: Sat, 5 Sep 2026 17:42:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: <linux-kernel@vger.kernel.org>, <hch@infradead.org>,
 <abuehaze@amazon.com>, <alisaidi@amazon.com>, <blakgeof@amazon.com>,
 <brauner@kernel.org>, <dgc@kernel.org>, <dipietro.salvatore@gmail.com>,
 <djwong@kernel.org>, <hannes@cmpxchg.org>, <jackmanb@google.com>,
 <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-xfs@vger.kernel.org>, <mhocko@suse.com>, <ritesh.list@gmail.com>,
 <rvvandan@amazon.com>, <stable@vger.kernel.org>, <surenb@google.com>,
 <vbabka@kernel.org>, <willy@infradead.org>, <ziy@nvidia.com>, Vlastimil
 Babka <vbabka@suse.cz>, David Hildenbrand <david@redhat.com>, Christoph
 Hellwig <hch@lst.de>, Brendan Jackman <brendan.jackman@linux.dev>
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Message-Id: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
In-Reply-To: <20260904115629.3993331-1-dipiets@amazon.it>
References: <20260904115629.3993331-1-dipiets@amazon.it>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 4 Sep 2026 11:56:28 +0000 Salvatore Dipietro <dipiets@amazon.it> wrote:

> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> introduced high-order folio allocations in the iomap buffered write
> path.  When memory is fragmented, each failed costly-order allocation
> enters __alloc_pages_slowpath() which runs direct compaction and
> drain_all_pages(), causing a 0.38x throughput drop on PostgreSQL
> pgbench (simple-update) with 1024 clients on a 96-vCPU arm64 system.

Is there anything particularly unusual about this test case?

> Results (average of 3 runs, TPS):
> 
>   Config                   Avg TPS      % vs Baseline
>   baseline (no patch)       59,408       -
>   With this patch          155,409      +161.6%

Is this back to pre-5d8edfb900d5 performance?

> Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/T/#t [v1]
> Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u [v2]
> Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon.it/T/#u [v3]
> Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")

That's three years old.  v6.10.  

This is not good.  Can you think of an exceptional reason why this took
so long to surface, or is it simply that our testing isn't good?

And thanks for fixing it.

AI review asked a few serious-looking questions:
	https://sashiko.dev/#/patchset/20260904115629.3993331-1-dipiets@amazon.it
