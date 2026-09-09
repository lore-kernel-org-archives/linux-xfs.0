Received: from flow-a4-smtp.messagingengine.com (flow-a4-smtp.messagingengine.com [103.168.172.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE0344C50E;
	Wed,  9 Sep 2026 10:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788948956; cv=none; b=mIow40hpu27pBGEM0YXZJx/CzawqVRdFO9kp6dwk/TFebInnh6cj+eJa6PP2HdV/VYQug5r+tqRcOeVtSYLCTpvLtnBN78NP+pFkbd0VyzXJWXJrXBAUdKQdeazTwSXtlDaEuQ9ns3hHxZkmJAkqvrjIQhmKLx9vwV6BTEOxbH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788948956; c=relaxed/simple;
	bh=Fp54oNfUOiD3p8nGl6fbPqRL41XnZHFGGQ8I0mtwnUo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZVPZigFQRhQpeBnZIFX8m6pG/z2AKBCkviafEhOqWERWWIw/rju4xU4qTJhGFtUOuVFPVgH1HsXPxas/0sXVygakuKkCEDw0K8+KFK/mhYK82xZZHvUtnoXpWoFspv5+qezgVpdUvX3awM4DKHDzN+hSh1Tm0o/F7SxmZuiAfdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name; spf=pass smtp.mailfrom=shutemov.name; dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b=EMk86vK/; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=xdqi4c4T; arc=none smtp.client-ip=103.168.172.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shutemov.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b="EMk86vK/";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="xdqi4c4T"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.phl.internal (Postfix) with ESMTP id C315C138023A;
	Wed,  9 Sep 2026 06:15:35 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 09 Sep 2026 06:15:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788948935; x=
	1788956135; bh=l0bA2UOwepFFOmS/bv5Uzc5Fj7QM31mNBWzJWBJpT/A=; b=E
	Mk86vK/XwrtS9J37WZuFfmJ5SVpJDHDZ6hEJ8/IXG30fs2WD+B0ufH5VZFUTp292
	jMOuh/xKSUtcqZ8hiBLpOyvteE1BuGHOG9HvywMlI0hwEgaDKys2a9XzQ+sEkqHO
	M/+cZ7LVwJlZceL0cUnyGzzcwnYBvfy5fJ/D8GTLBmRcLfG3+Ke4EVFZcSZs0JXk
	/8ANZYCWLjLkbXkfZrFoXWcY1Bakady40rjSUvlJjLPsnPDnTF6F+XewmrE9LrHK
	YY6yyOgfO5sIcvhdh7BMc4wPd65vHXtSLOG3WGiV6Gzobzei7naXe2nLiNybLrgW
	O+G0HaVbH/9HzzShnYDtA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1788948935; x=1788956135; bh=l0bA2UOwepFFOmS/bv5Uzc5Fj7QM31mNBWz
	JWBJpT/A=; b=xdqi4c4TC2EKOMc6mxGpNWM+fvaddmCXeGS11XeaRuRt7M2BDEW
	BuJchR8oIjLZm3fGlpVcP9diLG3tV9CGFpJUFy35p/wAFFZiQ5YyDfSM+7FzSsbD
	VjYTsKfRLJJC54Tgip8/mqeGmVdqEy1bCKlIDw6FcxcTx3q83FF17sWqbWu1EB7H
	JtrtZ00WLoSx9PFCyg35BDGSfOBmNm36KL8mrMnZ0Y7PhhxmkCQBQPLzW0DZc1IA
	TIF6kHMha7NNegTal9MhKFzn0xYe2yfjC/q3Hb70tKT9TKu3EvL1QPZvdFV5x0EM
	tsb6RDHlagupN5u+hXBiXeP6HVmNNaD8d9g==
X-ME-Sender: <xms:xzGhatUAaFDvmvipLNsi9G-JyJiuqY3hJG3-0yKVcQbeJrZNbNeNFQ>
    <xme:xzGhavk_0CYEIW7IMPC9Dy57zl-oCd9JwmD5wyz6D8b95RYoVoa9Se2ks43X-sgAw
    AkOCsABGQCHUeD8YSuKjkolVLIps1hhCe4m2tkpToPzIk6xcbc-9MM9Fg>
X-ME-Received: <xmr:xzGhatun6zlTZCxkwaSgC4dgy4Obno20MG8dP9UM38mxvYOpl5WVmqvP3Q0>
X-ME-Proxy-Cause: dmFkZTEUqK0n663bU8dHG/gXAim5or8IDZuAMT9spUIRS7o1wQxh4f32BZUUt41uBSxvbY
    DWEH4wBzf4fX/tU6Fe9b/UvDQQ0roIkvnNsTesZI9aPxwEDI8S2XaBrAFOz/JVvzPWk4GF
    0W/CnzpEgT1GukTwvX2x5EynFNHqZa91yCXtlA6py88ymBFZ0qGpBPmnBWEroBPrxOoZ6J
    PqxtX3nPwiTYzSUIvS++f61uroxeRxzzZwFRBYthF8hRDAgYghR75AEnzTZbKrjRQCYzoK
    UupKJGVHx02xDqQX/sBTbIoAS8d0ijH6w/AR1PW2zkt8ss3DkUpKKE6dfOB3tro1rsAmBf
    uHeBeKkb7LoD3Po4skHeQe3Uspt+l3Gq1VlrJ5a6fnnbHxbUcjlKfrCAKqxE9l418CYF5J
    HQs0518a8Aoh8vHgCOZY7J6rYFMHe6HIBNE5Dl4MUNHCPW473nmVgiIW8SyUqM2YYkMiOf
    mLjR+f4JylidrCUHOGtjuAgJAPK+CsuC/1dSGLw9TfW2GGosMYDNHuzQw7SIsjb/70JD/5
    EJqKYT+G60OzjQ2RhQsUxYnlrJQrsIT2h2yFJvKMD18gPCH5dM9Mtc6XusEacbzsurMclR
    rq2n8fJ2FFEHXk9Zhzcu1t9gDC2A0BWbL6yHfCHptYj/aZGmSLMR8s6FE7nA
X-ME-Proxy: <xmx:xzGhaohW7Svp05zxtpu383xfOj-Pvk0PxIihb73lf-TLnh53Z-dxsA>
    <xmx:xzGhahS9zW_QrY6EM3-A7DeAA5QdQkwfNHnGvMKkU5VmfsTMFFKGkw>
    <xmx:xzGhao8sGJPohqw-JMDg1l0cmRId1NX0HquDq7G5V6woFP4IOUBRPA>
    <xmx:xzGhatJXlaFAqYw5pHoqdjpnQwXwaSHjo69R-pUidKf5nnXBAvar9w>
    <xmx:xzGhaoByYJea67cl2E40ENZtIHPA_Y36Cmd5EhNgYpInH2bg06n7cfBf>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 9 Sep 2026 06:15:34 -0400 (EDT)
Date: Wed, 9 Sep 2026 11:15:33 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Usama Arif <usama.arif@linux.dev>
Cc: akpm@linux-foundation.org, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	Carlos Maiolino <cem@kernel.org>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [RFC PATCH 0/5] mm: sub-folio dirty tracking for PTE-mapped mmap
 writes
Message-ID: <aqEwlUNIYYUEfdje@thinkstation>
References: <20260903182943.662461-1-kirill@shutemov.name>
 <20260909100240.635595-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909100240.635595-1-usama.arif@linux.dev>

On Wed, Sep 09, 2026 at 03:02:39AM -0700, Usama Arif wrote:
> On Thu,  3 Sep 2026 19:29:38 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:
> 
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > 
> > A store through a shared file mapping dirties the whole folio. With large
> > page cache folios that turns a 4K store into 2M of writeback: one dirty
> > bit per folio, and writeback has no way to know which part changed.
> > 
> > XFS already knows better. iomap tracks dirty state per block and
> > iomap_writeback_folio() submits only the dirty ranges, and the buffered
> > write path sets just the range it copied. Only the mmap path throws that
> > away, because iomap_dirty_folio() covers the whole folio.
> > 
> > Narrowing the dirtying at page_mkwrite() time does not work on its own:
> > set_pte_range() batch-maps a whole folio writable on the first shared
> > write fault, so the stores that follow never fault and never reach the
> > filesystem.
> > 
> > So harvest the hardware instead. folio_clear_dirty_for_io() already calls
> > folio_mkclean(), whose rmap walk reads pte_dirty() for every entry of the
> > folio and throws it away. Those bits are the only record of which parts
> > of a large folio were written through a mapping. Collect them there and
> > hand the filesystem the runs that were dirty, through a new
> > a_ops->dirty_folio_range().
> > 
> > All of this is about PTE-mapped folios. A PMD-mapped folio has a single
> > dirty bit for the 2M it maps, so there is nothing finer to harvest, and
> > it keeps writing back whole. Keeping shared write faults off PMDs is a
> > separate patch and not part of this posting.
> > 
> > On a 512M file in 2M folios on XFS, storing one byte per folio and
> > calling msync() wrote 512M before and writes 1M after, with identical
> > minor fault counts.
> 
> Hi Kiryl,
> 
> The motivation makes sense to me. I will look into the patches.
> 
> Just wanted to check, the above xfs example, is that on an ARM host?

No, that was x86. But the math is the same on any arch with 2M THP/mTHP
in page cache and 4k PAGE_SIZE.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
