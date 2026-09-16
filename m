Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C008D306746;
	Wed, 16 Sep 2026 17:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789578584; cv=none; b=ik/F5OPAML3enr/J8nh/BdpYsDfYeBhfAc8bWABRZ6GPgLuHDy//4SSFBEDr7ayrbFaKs693LD5lM1RmYQoQPlq3LWdCX3Gl7vxZ+azWgPUbkRiCYqDQ1Nkcuoa4Jd6CtAFcnrkQ4KY3b8bI1UCLDHO4TbfNEkrkUa4S6kWCQsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789578584; c=relaxed/simple;
	bh=wzoOAZtHWO1VK42/OD6jmwXxNw2aPfhujFb1VZifudM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AeDCb9w4KY6XT9VsEDilwv9bSZPNj1lAfarxzqsIGlaFedRHjJsOCuKc9ilz4FWDlOKk4QvgBxCSBYVWTfZ+YZBtcWyie5rPpWTP26WQnWHc2gP7vNFCyL3wWgQlYzbiGGFdNTa+bXFSGmFiVmRYHyNrSIIeYl06nmyYDE4eg2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LWqerj0a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LWqerj0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4B01F000FF;
	Wed, 16 Sep 2026 17:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789578567;
	bh=EYIPtNMDNyQ/6WY1hk2JBEVGtLHLfjG619n8HAgX2tw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LWqerj0asUBl5mtWNWo7n/nykCqCU502c2DJydmt2eMm7kzsEvMm9nPaKCKnYxFle
	 PtJ4nQtsfIWJrDtrDFpS4Ro3cO7+E5Fo7fC8y+ZE08Li+lRcdurVqgRlxM41vlWpvH
	 cPFaiYckAIS3XUTkkwbCtKT5yzSJ0NY15pBcj2+2sZVOK4jJmWZqJQwXpWUKBouDjU
	 VborlYuABqOtgaJHC4/qx6LFR/W6ZJAk+SXmbugszPA5iXmBsKbQslwn32WDORnPt0
	 q9Fhq5vhndQDxsJfruuRYAWGkZu+moIPwHBUWk5lffpo36mq4f0+8Ghe3NzOOOCcYJ
	 cFCxxhMTRfWWA==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.ams.internal (Postfix) with ESMTP id 37F4F198003A;
	Wed, 16 Sep 2026 13:09:20 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 16 Sep 2026 13:09:24 -0400
X-ME-Sender: <xms:P82qaiwtHNsjl1hytDOaqAe2_6EnrUrcXt0YfqaFCHBsC1kn_e4gAw>
    <xme:P82qavHnQFv0mIWxMbXrNw6e8CuhjHis_cEvFycaQtXEPGUBUZOZG0Nowg2VtLybu
    XKviAE09c-CjE4SKlyODnQZNoS8yGD-pLu1VLsUt1Cbqhw279yV4rZc>
X-ME-Received: <xmr:P82qai6IeaGYtne0hJP-GQQZwYeGGBBW7KK-J8g6wGh258to265jQr29PBk>
X-ME-Proxy-Cause: dmFkZTFV2UCcZr2GlXxYscRnpO5twby6pXhiHVdxeWgqRFx4KTYs3c1z/LJtw2pl3bmLGT
    SjKcaugx9MWXu+xOcXXwd3VtNepswxZmDVEUvi4lQHUKvURxNnarwj9loY6NXKq6Cmax9y
    wvcU8EkW3DVn16heKoIFJ9UsUjMtAoXK96bkebfHJeZRVjxqjgNOj5/kPQYwVdE6TQ023p
    CCMxllIHDMNupE3Ac77/LjqyVd4CZI78dRY4ZeB+OTMw0dQ5oQfzfZU3NzQDR3P7wW0c4C
    MR6zFt8bbwxRh8gyLQ4m2aFbkZWXqUilZTaeerE8U5TZFrY9Tu74f8LWMkHwlcVPKSEYI2
    ELt8rO+LmPoGRacMpaFK8VJNEhSga/OemsP/etzQg1NA43uDvwJZ0Q2iamr6+cOrrJOhhZ
    Ob/D4EoB7s9eGmNKK9Wz6Ql53fVTRhZz9hsfNDrz/iRxFYhzq1Oet95QNfTfSTAx8qRS12
    XoveBvdLrXUqsJgzaNLg5Xp6q9CDIweabgLMlRM8sT2kuNZr1P11u9NUfzslS40hwlG4mM
    BBJQCOEnxSthIZ6iy2lRp+l50IFyD/wYYuipel/bc7f2gdEIMGPIcUiJ0nRIi3ODY3yYAB
    l0dUjaHDx59hhDtjphJgpyQSHZMQNDMPfPiHlFmeY+TovoCEGh26+KFTIK+g
X-ME-Proxy: <xmx:P82qauV7CdE5fVc-RlAU-sFYarVXpHS9ezru3zj4s_TpDtcO4BmE0w>
    <xmx:P82qavJfqmCsNrsZp8GNVrYoFUI_uoM5FdBIHd_xHZAV57bSfl6d6Q>
    <xmx:P82qauQ2vQD3aUgol4h2WHHUmis3y1dwQGiZabPW3M1vGPioub3tXQ>
    <xmx:P82qaiBnhXmiTuoavJ0sd348dWGmzObwLtYoGHBva5EB2kMbIk800w>
    <xmx:P82qak-gvAifzihzhevXQjss8iKtVSzDLmJGWJhmOTU4yAarpr4l6OnL>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Sep 2026 13:09:18 -0400 (EDT)
Date: Wed, 16 Sep 2026 18:09:17 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, David Hildenbrand <david@kernel.org>, 
	Boris Burkov <boris@bur.io>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, Jann Horn <jannh@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [RFC PATCH 0/5] mm: sub-folio dirty tracking for PTE-mapped mmap
 writes
Message-ID: <aqrJAX6nMTIo6Vnn@thinkstation>
References: <20260903182943.662461-1-kirill@shutemov.name>
 <ap6LFvuOuWf_BkGi@thinkstation>
 <aqrDfoFFr8o0Mf0G@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqrDfoFFr8o0Mf0G@casper.infradead.org>

On Wed, Sep 16, 2026 at 05:27:42PM +0100, Matthew Wilcox wrote:
> On Mon, Sep 07, 2026 at 11:15:15AM +0100, Kiryl Shutsemau wrote:
> > Boris pointed me to Matthew's proposal to remove ->dirty_folio:
> > 
> > https://lore.kernel.org/all/aoyWln-Gt-yvZQkE@casper.infradead.org
> 
> Thanks, Boris ;-)
> 
> > I agree that the current ->dirty_folio() makes little sense and that
> > dirtying the folio can be bundled into ->page_mkwrite(), as they are
> > matched 1-to-1.
> > 
> > My proposal makes the distinction between making the folio writable and
> > making it dirty meaningful. ->page_mkwrite() allocates whatever is needed
> > on the filesystem side to track dirty state and drive writeback for the
> > *folio*, while ->dirty_folio_range() marks part of the folio dirty.
> 
> Why do you think that's a meaningful distinction?  We create a writable
> PTE because we've taken a page fault for write.  There's probably a few
> naoseconds where the PTE is writable+clean before it becomes
> writable+dirty, but even then sometimes we do both pte_mkwrite() and
> pte_mkdirty() as an optimisation in the write fault path.

This is true for the PTE that the fault was for. But we don't necessarily
want to dirty the other 511 pages at the same time.

The basic idea is to make the whole folio writable at fault and shift
dirtying to be per-PTE on write to it.

> > We can still drop ->dirty_folio(). A filesystem can provide
> > ->dirty_folio_range() if it wants fine-grained (sub-folio) dirty
> > tracking.
> > 
> > A separate question is whether we want to avoid installing a writable PMD
> > entry for filesystems that want fine-grained dirty tracking. I have a
> > patch for this, but it deserves a separate discussion once we agree that we
> > want this for PTE-mapped folios first.
> > 
> > Any feedback?
> 
> It's very odd to be optimising for shared-writable-mmap.  This is a
> horrid model for I/O.  https://cs.brown.edu/people/acrotty/pubs/p13-crotty.pdf

Sure.

But not everybody got the memo[1] :P

I think it worth considering if we want to make large folio adoption
smoother.

[1] https://www.reddit.com/r/bcachefs/comments/1vepk4a/comment/p1sn4v1/

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
