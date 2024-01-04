Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D566910793
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 01:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J7OYuQ2c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53670C433C8;
	Thu,  4 Jan 2024 01:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704332037;
	bh=t9AVbI7r0jaDsVvDI+zsjeqJFUSDOkqOhVbzf0xyjj4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J7OYuQ2ckF/frP1/tPOnNHrNqe+t4t62apxZ8OnTrilSqwwjUNl5DhT0SxVgD8cT6
	 HIPyHc8kDu415KFF48N2mgPE4v696NlMN5caKuBVXZXYnCgTh1TKVWf98piGLosFDB
	 e7fD5TiYo8yL+wpJDH0FKSUc1vztRWbmuEm7T8W0LnASrJ72I7XpyxwsBTpMILZVcz
	 +OsF1pl2FjuGow9HAO58PqKEwUldbjVRyYhphB8H0RdgUP0LNgGPZxu7XhouzT6rEl
	 eoS/+VIPD4RctJEOoxWNXGiij7Dviw6FHuiLEbrJaFz9QqL723CXHrZFRKCkJlt1kN
	 tseoWeVlbKWoA==
Date: Wed, 3 Jan 2024 17:33:56 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfile: implement write caching
Message-ID: <20240104013356.GP361584@frogsfrogsfrogs>
References: <170404837590.1754104.3601847870577015044.stgit@frogsfrogsfrogs>
 <170404837645.1754104.3271871045806193458.stgit@frogsfrogsfrogs>
 <ZZUfVVJSkvDRHZsp@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZUfVVJSkvDRHZsp@infradead.org>

On Wed, Jan 03, 2024 at 12:48:21AM -0800, Christoph Hellwig wrote:
> On Sun, Dec 31, 2023 at 12:40:40PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Mapping a page into the kernel's address space is expensive.
> 
> What do you mean with mapping into the kernel's address space?
> 
> Mormally that owuld point to the kmap* family of helpers, but those
> are complete no-ops on the typical xfs setups without highmem.  But
> even with highmem at least kmap_local_page isn't too expensive.
> 
> My xfile diet patches actually change the xfile mapping to never
> allocate highmem, which simplifies things a bit (and fixes a bug
> in the xfs_buf use that just uses page_address instead of a kmap).
> 
> So I suspect this is something else and more about looking up pages?

Sort of both.  For xfbtrees (or anything mapping a xfs_buftarg atop an
xfile) we can't use the cheap(er) kmap_local_page and have to use kmap,
which ... is expensive, isn't it?

Granted, forbidding highmem like you posted today makes all of this
/much/ simpler so I think it's probably worth the increased chances of
ENOMEM on i386.

That said, why not avoid a trip through shmem_get_folio_gfp aka
filemap_get_entry if we can?  Even if we can use page_address directly
now?

--D
