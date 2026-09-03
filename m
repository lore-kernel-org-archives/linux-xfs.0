Received: from flow-a1-smtp.messagingengine.com (flow-a1-smtp.messagingengine.com [103.168.172.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF314A8FCB;
	Thu,  3 Sep 2026 21:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788470348; cv=none; b=efLLjsfqKCEVRFuOwpB6ydd8Ckgo0PSu30CaHk1mnGy5A41whogI0gROecWTYU1ut9Ww3tj5pAJsS9Al5CDbcaRORRtwZgL4eHJ8uI+XGFlvo/85Z7lJMKKGiw//pvn2siuLUWcmR5mlZQli8gJJ2MsK3d9b3gui8VYeP/1NRXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788470348; c=relaxed/simple;
	bh=n7bXea1Nwi+OAhiePbpS6n0L92KkeM24e644t8Q6uV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iE/03dhMlwXvwVtTKSUDsOfbSOCxJ8aLOFukSC/EOnj3yQOYlvF5lmuRQBkniNJe+LutZlyiNS0Xu4ovtxms6uLVWpdAcFwV9vT8jGI4uGOYvSmWohg+CFkR1tKGdRd7/pDRPu4X8UBGyKZ8APNCzqioskvlhKud/hxqg0ESKVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name; spf=pass smtp.mailfrom=shutemov.name; dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b=KkyGpbv/; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=kTkuY8LX; arc=none smtp.client-ip=103.168.172.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shutemov.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b="KkyGpbv/";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="kTkuY8LX"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.phl.internal (Postfix) with ESMTP id 9FA10138011F;
	Thu,  3 Sep 2026 17:19:00 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 03 Sep 2026 17:19:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788470340; x=
	1788477540; bh=7ionguWI8woKzL1NBqHJS3q3P7mndBbcfqKVWzugITQ=; b=K
	kyGpbv/xk3XEBsFODyNNbPNhtISyQzZok3DSPya01CwZV+kwt5ABBw0IE2wyouvP
	IHqmtFW6WGlUtkcORzDbB31AnWdw7VpELOtvXH2xJl1x3D2tPK5IjwZ3Zm1QMpB+
	5V+QiTCpRK7ZO7BxXlINFjTDLTBQJlX4DtHit15mzjLvROVaY/TPHIcC5yM7UnEt
	gmtbLL/EgP+ZZiworifrxEbnvRUlfmfRLY2gbhElz0s8ls/nYBu3luVMWgHI8fbs
	IYELbwLj0Jbm7+LP2Km54IFowHViDWew8ElLhftzeL1WMn15wx1a2hbyyEH8UpfX
	xylcSUduqHOHr9Qt+yweg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1788470340; x=1788477540; bh=7ionguWI8woKzL1NBqHJS3q3P7mndBbcfqK
	VWzugITQ=; b=kTkuY8LXa1IqB74/9oSwScifj+93XwAdFCiALWWa64sFKERxIHL
	NS8dFJd8hGAkJkd5nKNBjL3TLUHl4GZmvq8kG52Z+zH0JhFT3ZF1oFuLXz6bqRFD
	pFhF/qSUizLtgBPD2cvIBS5Hyu87drtjmzAKEKuSJjTH2NDLmUXKqZzbvwndpC6z
	N2ZrIQ+/gB61cN/oQjp5MTDSr642N6d5gGuaWwNr21222k2LgrUPiTbkpFj7eNeP
	DHvRKj/rb1a/GQDRYD2a7sHSHOI9DD/NvbqSweR9DITPUOTW9tvb7F1tebDE2Xsz
	fcT3p+vu78oN1b2Coq0EwAqvKk53sZZ2lRQ==
X-ME-Sender: <xms:ROSZagYsobD3c2h-Wdl89NMeq7pW8NXhglXCCKifbju_BNPJNW2pdQ>
    <xme:ROSZap0zJh7rmWadvXuee5SbWOJ26ZG-pEfGHhTLKo453_ri4jc1oicKGEe4FwsxC
    6_jK6bZKRpNmSGb6SAw8p-4ONFLDkUfwyfGunihJ7mT4DKbX2V9UKdErg>
X-ME-Received: <xmr:ROSZaiGPy-Kk1Tc6ZejicntQeSEiBWSA4zgSf2QV719CnwdtrLGGKO3cCdA>
X-ME-Proxy-Cause: dmFkZTGWigpzmqyNitv9uTrA95IFMdWwGGI+6KZ2VVuNnzRvIZsn+TK1jFAGEicXuZi9Fp
    gbjJlgSD454klJuCw6LuID91eg85v+tMqoS8HqcgIHD/POYyHZkp/Y81BY4mgMKHSq/nEq
    lMZnm/7plL33kQ5/zwiPoew57IMfLMJoPmyCqQWBSu50XV/W58V7YZyrOgDt79AOJKoVk2
    yE0kH2F5YlLH8hGjt/74wtuQ+f1HG0IddTaxUqkd70lEiCOQXcpq+K1xwhLoNiL6Q04fj1
    iNh/8ip0Jr6ZQOXZ26pNHPEf7dA5CPzflnKYQmRIEICzXQu2QLGGYRpKnxizXY8ZopdMqV
    OT4AaxPctccLpPdNEEl1CfqNQm7lV6SBK3S1wvLNMA0TVJUCFXKvIW7Wg/erHe59VbwS1v
    AigM7FUGg0r1denPnQ7Fz5xeh4Wqbw39jffn3NHwbZb38VMoNh2P73RFfWGZ+bx9FPN3Cd
    FhHM/ogmP4MEoclyGTk8qrXmqSXTSN6jX8x2Rnw4GDY5Z9BkdqyuyDkF7HvYwocy4vdv8T
    +S+9EYlb86i8i1d9fn1jvyWziYDd40P6i/2p1SNBYpkp9Y4MYfjQ/9VaH3KXXZNp4jjjr4
    YU7h36T1KQGZBhwDW/T+IQKpz/dO8AUaLvqs9jLlMP2BxYYGl7P1PVFTy1wA
X-ME-Proxy: <xmx:ROSZauNL6rWsY1CL01y1Y_GyPAB3C8IU4O5tv8CkIYwSSz0iJ0T_iw>
    <xmx:ROSZavBdGOal3ndBo3Lgm3UHgKp5dBe1J72GuoDcpvQK58uYXceFfA>
    <xmx:ROSZalxUp2DruySNPqnVYhT9Apl2KORHoSkSNQD3N6d6kxRY4kuzBg>
    <xmx:ROSZajdGCISGV2C1wF07tjd3fqeqDBoW1d90RuwE5PkmaMCSbpprUA>
    <xmx:ROSZaqjqMWUhDWeQ7ym4WLZ4TUWodn2ThDaEnrubTS-psg-s4iunu5Mw>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Sep 2026 17:18:59 -0400 (EDT)
Date: Thu, 3 Sep 2026 22:18:58 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Pedro Falcato <pfalcato@suse.de>
Cc: akpm@linux-foundation.org, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	Carlos Maiolino <cem@kernel.org>, Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [RFC PATCH 0/5] mm: sub-folio dirty tracking for PTE-mapped mmap
 writes
Message-ID: <apngWgs4OAVFij_7@thinkstation>
References: <20260903182943.662461-1-kirill@shutemov.name>
 <apnO6MyHhCilamqJ@pedro-suse.lan>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apnO6MyHhCilamqJ@pedro-suse.lan>

On Thu, Sep 03, 2026 at 08:55:36PM +0100, Pedro Falcato wrote:
> On Thu, Sep 03, 2026 at 07:29:38PM +0100, Kiryl Shutsemau wrote:
> > Narrowing the dirtying at page_mkwrite() time does not work on its own:
> > set_pte_range() batch-maps a whole folio writable on the first shared
> > write fault, so the stores that follow never fault and never reach the
> > filesystem.
> 
> Help me out here: in which case does this happen? page fault handling is a
> mess... I think page_mkwrite is always called, no? in do_shared_fault().

It is always called, but once per folio, not once per page. It is the
filesystem's chance to preallocate whatever it needs to track dirty
state for the *folio*.

Later finish_fault() maps the folio. It tries to map it fully when it
can, so a write fault creates up to 512 writable PTEs on x86. And we
really do need to map the folio fully whenever we can. Otherwise we
significantly undercount mlocked memory. See commit 19773df031bc
("mm/fault: try to map the entire file folio in finish_fault()").

And once the whole folio is mapped with writable PTEs we cannot narrow
the dirtying to a subset of pages. Any of them can turn dirty at any
time, with nothing to record it.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
