Received: from flow-b5-smtp.messagingengine.com (flow-b5-smtp.messagingengine.com [202.12.124.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7558B493D55;
	Thu, 10 Sep 2026 13:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789047388; cv=none; b=L4rOXWEpE8TIj/R6rBdjFOALAi0m1GrpXOTbza95p86iUYrn0wqTQ+Vz1LH+31Fiyp4DtS4/cIM9DhobJs0ZlAb7zBqIBXnf3kEBNylrUGyuZWttAJOa8hCnUy65mJr/DO4NAOwYBqJ2PDyiiqPqpOhiNcY5xSudsvN82SqMyPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789047388; c=relaxed/simple;
	bh=mFzSoT/R8c1Nd73kJmUZCG6wf+klMYpnbTHGbu06jnQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PId3DnDdQYL8TRTj5wqMdN9Os3ZLb1E7c229fOxspErP8HkqQgAIE3mU5R8X9ijFQFathxxsxNNtEQteBPMORrQSxvzSU2XQq3zSLndOQgk89HAi2gPf4vFqFWrLWlT6yMMaVPjUBZb9Dk2h5EG5vAaP8Yx4zCCAw3MBTL7hR7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name; spf=pass smtp.mailfrom=shutemov.name; dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b=JiC/FNcc; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=IoUTrepy; arc=none smtp.client-ip=202.12.124.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shutemov.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b="JiC/FNcc";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="IoUTrepy"
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailflow.stl.internal (Postfix) with ESMTP id 53394130031B;
	Thu, 10 Sep 2026 09:36:24 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Thu, 10 Sep 2026 09:36:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789047384; x=
	1789054584; bh=Aix6zD+sWAhHCK96XTqdVIPFcUsbKpScTo8omJZ7kRI=; b=J
	iC/FNccl0yH8eZLx8Y1aA3k5KkWHnq/SUgCGyekPoT/VyPpPrQTTHxbCn774XPfu
	y+OtArhkvOMs8178JTM/BKjum34C28rfNShUl9uo1JeCNqmmvZUTIZLXDNM6Im8q
	sLtNlryUoZDEICm2fG/k9QuyUXqjLBLG8a2IOpctkwJfdX2OyW6GP4AlH4u4MugR
	ok5ztUySC4ICl2NqI+95e879rCmMyP3bn2AvtNIKu/QwMFgSyEeOjSZo7UtiKooM
	1UPOyj9+JXZ5Voi1xsXtLKQdq6URhZcljDW6WXHgFudXyh4aI/3QEVQ8A2fu0ycx
	e7fuDH45gUZFIcPEmVYhg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789047384; x=1789054584; bh=Aix6zD+sWAhHCK96XTqdVIPFcUsbKpScTo8
	omJZ7kRI=; b=IoUTrepyYSR/bEiVJoM6S3gFlo/l0qjcU7cPRIJFHAdTeJIL9Tz
	AxlXVqLy4UglZ0QEYVoTgXoVQPc6oK8K6+ic9X5YjPsqMIILcajf8DkK6Cg+m0Lv
	1J/UJEuwOC/cylj5dYO4IWS+eMzcU0G4uzEfv48dMAwRDbNtYsRY1Bi/UKxSCyTl
	srbKccBjrnKKKlvJUNOTRTB+ZgWjkfb0rv6y1L/X32QCq5WAlbCgp9i+PFWMvLxF
	EwEJGDWI6D3jSw/p030sYcVVEHM3bxgzY7JbpciivHKYNlvGQd8g4KZWWK9zHVQm
	Nm26BOEiho6RxJNoK19o8EAsZljaavd1rjw==
X-ME-Sender: <xms:V7KiasHiw0d7B0joUAwkdvU8Bga4XWJHRXpeEZTe_kuhdQGwp3EAbA>
    <xme:V7KianV5efMMkCR84uqLsLP9iF3dRSN08zFokNrRb_iykiESwg0mFmNCHUJ88xX1h
    xzAJzMU6lcoYmRhdIge3qr8eytQ_68Re5KYBMjMfWJB1MjJhFq7WDFx>
X-ME-Received: <xmr:V7KiaqeJ7u0PeZS6fdgBUhpQriOniVjSUV2qnx3uEXOKbKe-DSblJxw4ntg>
X-ME-Proxy-Cause: dmFkZTE/cV7Y3B5vfmq4FxwBW5zjIOR+OZ0Xq5wNE0R+9MV5eEb7Vmg3gWUSzcydLMYKsT
    k0AEiBx5vAV4G3V3qjltmxAKxV5+/EjuIP6hv39fDwwxRv8x0NwLBFQwKfQdcq+44hzyHZ
    3/uAyOhAF7+IUKa8FH5q0canFhSzlKFsCqOHb9P8uJE2LFS6hBfLubEv+qPLaOReHYiNDI
    t7k34surxCm87KQlVrWSwkDE1ybXWYCPpf0JDb1ntZexrcY4FQjImfSwEXvhyEyq9EMbag
    ZRrwqKZ/zrY7HPzA9+r3qwYLqtLJwM3F3LvVn+dQgoholjbS3YyVg7nrSnhOjJXpJWvdAB
    bsesbw6nh2xKNlCbjDZaLS+F1fclhtk/tkGvO8q3VrPNgjZRN8cAr1LvpkeXgLQlTk4eD0
    oBgAWaBpWJY6p3DxNoxJdTkhb1HcO47WICrGjLw8NjRs6Li3q3dAaah3w5GIP6MphuoJdv
    KaZWhP3av+E8Ee6yVrdqcpk5gs3GC0a9ykMnyqXjOvjFeElgQbEXDsGkZo9ImEoQ+bsWUz
    kZI1Dy7J/mPKKtvJ5mXRIkHCWlOuO5LJ0imcYavY5eiQ1kQkbc/VDgMLnSThrB/LeIJo/f
    l21N7br/2Qlm+OfDCuECU3ibjKMGb473+BUWv8mxDr+KQjqxFWJ1rLsrD9qQ
X-ME-Proxy: <xmx:V7KiamTCFHjpmBE-EEinApbKeCrS6JG3nHB4MLcdlUegeDHp7naQGg>
    <xmx:V7KiasBRTn6630SaHyJ8qQzwVrY0YsQiHDfSJ83W053CWDz3RnN5SA>
    <xmx:V7KiassB-nsQ0HGdKsvQQfAE0osTulGGqkk9TyOj2cEUzMFCNLr1Mw>
    <xmx:V7Kial4KoUrfK9nBSFF_muO3jGSz5q9aAxvFhSblQNCsz7bEbrW5Zg>
    <xmx:WLKianwh14UVD3RXq0BoVMyJjbOORFjiIgq0wIdt5yyEc40WI17Hm9lf>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Sep 2026 09:36:22 -0400 (EDT)
Date: Thu, 10 Sep 2026 14:36:21 +0100
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
Subject: Re: [RFC PATCH 1/5] mm: let folio_mkclean() report which pages had
 dirty PTEs
Message-ID: <aqKxU5iOuWjK58Al@thinkstation>
References: <20260903182943.662461-2-kirill@shutemov.name>
 <20260909101212.894871-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909101212.894871-1-usama.arif@linux.dev>

On Wed, Sep 09, 2026 at 03:12:10AM -0700, Usama Arif wrote:
> The old whole-folio behavior did not need to know which PTE became
> dirty, so this timing window was harmless. Sub-folio tracking makes the
> final dirty state correctness-critical.

Good catch, thanks. I should have known better.

Fixup below.

diff --git a/mm/rmap.c b/mm/rmap.c
index aaf45ac79fa8..9b8b9428f802 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1140,6 +1140,15 @@ static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw,
 			if (!pte_dirty(entry) && !pte_write(entry))
 				continue;
 
+			flush_cache_page(vma, address, pte_pfn(entry));
+			entry = ptep_clear_flush(vma, address, pte);
+
+			/*
+			 * Take the dirty bit from what the clear returned, not
+			 * from the value read above. The entry is writable, so
+			 * the CPU can set the bit at any point before the
+			 * clear, and the page table lock does not stop it.
+			 */
 			if (dirty_map && pte_dirty(entry)) {
 				pgoff_t idx = linear_page_index(vma, address) -
 					      pvmw->pgoff;
@@ -1149,8 +1158,6 @@ static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw,
 				__set_bit(idx, dirty_map);
 			}
 
-			flush_cache_page(vma, address, pte_pfn(entry));
-			entry = ptep_clear_flush(vma, address, pte);
 			entry = pte_wrprotect(entry);
 			entry = pte_mkclean(entry);
 			set_pte_at(vma->vm_mm, address, pte, entry);
@@ -1170,12 +1177,14 @@ static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw,
 			if (!pmd_dirty(entry) && !pmd_write(entry))
 				continue;
 
-			if (dirty_map && pmd_dirty(entry))
-				bitmap_set(dirty_map, 0, pvmw->nr_pages);
-
 			flush_cache_range(vma, address,
 					  address + HPAGE_PMD_SIZE);
 			entry = pmdp_invalidate(vma, address, pmd);
+
+			/* See the PTE case above */
+			if (dirty_map && pmd_dirty(entry))
+				bitmap_set(dirty_map, 0, pvmw->nr_pages);
+
 			entry = pmd_wrprotect(entry);
 			entry = pmd_mkclean(entry);
 			set_pmd_at(vma->vm_mm, address, pmd, entry);
-- 
  Kiryl Shutsemau / Kirill A. Shutemov
