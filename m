Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827461D7E2F;
	Fri, 21 Feb 2025 20:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740170298; cv=none; b=qEPrgUd+KyTM6MIMcp0JUMbervEErZPNEOH1ak21hWryrGcdBC/KlZU4B3NAW9FK+Di2BJ+togLv0KkP1l6xg2Nw/uTh2ENDFEgbAXqsEmDzFvVzdVAhg5Tyn6+HDEDWfjCBt6GX84yhZX13wzVDXUtkuX7vtB0BE1byGv0CYbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740170298; c=relaxed/simple;
	bh=ghbPgVthWd4oK9iygGhBjUwBaMjNiQM7DAwYcx9mSSk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aDdkDNsu5X0JRYdgq+omxWVeaxpunYInYU6CD6fnNhj+mcMQVaQXQL6R4bgZVXlqWVpaF089P8G4kKIIvUO7cUIvtTUk54GLTGhebRdoF+CWSTKkvaWp7nxL7idjh9Ns00FnmTOQYKsuBB/Jdp/c4TVfo2W6s1DnIrGIGQ9b+DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gQqKRZ3S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gQqKRZ3S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9229DC4CED6;
	Fri, 21 Feb 2025 20:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740170298;
	bh=ghbPgVthWd4oK9iygGhBjUwBaMjNiQM7DAwYcx9mSSk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gQqKRZ3SNc8/8Mj6yqwM9TY4dwiPYD6s+D6wZ3FjcQQqTE0jE621N+S9SSTr57vSq
	 QJZddPqd2xTrtfTrrEVT2qnVjAkH2E814QQMnlOhrVtYD1c0diMlQ6ZdLNKFMZqqbj
	 954rL9v1PGifG0E7fQnzf76/HyFBUBbBuhDxDTOJe0OMjq/tKNZcIs2waCtNgrKn6h
	 +LZpnsoXfaH/vOr7vQykaTY/LHkggnQwqgesV8vIeaUzPTYGheRcV9ll4pXhhWU8bt
	 Emj5pRbtiqu4MalHZq5GZ9IGvcyAo/DKTxP+silAootvfBT2zxCGrB3A0xwUafjPwO
	 4afBBY69GWKyw==
Date: Fri, 21 Feb 2025 12:38:15 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>, dave@stgolabs.net, david@fromorbit.com,
	djwong@kernel.org, kbusch@kernel.org, john.g.garry@oracle.com,
	hch@lst.de, ritesh.list@gmail.com, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	p.raghav@samsung.com, da.gomez@samsung.com, kernel@pankajraghav.com
Subject: Re: [PATCH v2 4/8] fs/mpage: use blocks_per_folio instead of
 blocks_per_page
Message-ID: <Z7jkN-C7GQln2F7i@bombadil.infradead.org>
References: <20250204231209.429356-1-mcgrof@kernel.org>
 <20250204231209.429356-5-mcgrof@kernel.org>
 <Z7Ow_ib2GDobCXdP@casper.infradead.org>
 <a4ba2d82-1f42-4d70-bf66-56ef9c037cca@suse.de>
 <Z7jM8p5boAOOxz_j@bombadil.infradead.org>
 <Z7jhJ9_AipEbpKmV@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7jhJ9_AipEbpKmV@casper.infradead.org>

On Fri, Feb 21, 2025 at 08:25:11PM +0000, Matthew Wilcox wrote:
> On Fri, Feb 21, 2025 at 10:58:58AM -0800, Luis Chamberlain wrote:
> > @@ -385,7 +388,7 @@ int mpage_read_folio(struct folio *folio, get_block_t get_block)
> >  {
> >  	struct mpage_readpage_args args = {
> >  		.folio = folio,
> > -		.nr_pages = 1,
> > +		.nr_pages = mapping_min_folio_nrpages(folio->mapping),
> 
> 		.nr_pages = folio_nr_pages(folio);
> 
> since the folio is not necessarily the minimum size.

Will roll this in for tests before a new v3.

 Luis
