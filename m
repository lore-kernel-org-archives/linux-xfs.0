Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E7637DE8A;
	Wed, 26 Aug 2026 07:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787730149; cv=none; b=a1yH+2uiK34dLh4VEHKU8kM7N4SSx9ABCr1Vb8gKp4wOuIof9dVfM+PeRgtQXFlLTyCtOceiFLWDCnfcGCzaj5QkX2iMBlqAveuI/1P9A4Z6YJ0vRbmTkiwNaP6dZM6VY2ghShGSxcwGFwCejMUPOWRZ0yhshZgjx4oWAwAMfNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787730149; c=relaxed/simple;
	bh=PBev44xSzJ2M1MJAmdYELWXheO/ojhCA+pH10s+URWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oPlIBgAEboftFOjjQbDS9L3HxsnaCKD58EoRufJ5NmQvPS0MdFBPIU4KFZEEG2AFxjxC+V05CmjnY1W/R6u9P6ZN2046h8oD/FetBDV+7dOH8IPsjg2IcQtpA8Cdzf+h6nN+3LQZS0oJc6Y0tKr4RQnPf9SBPYnruVDNgDZKSbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AB4F268B05; Wed, 26 Aug 2026 09:42:15 +0200 (CEST)
Date: Wed, 26 Aug 2026 09:42:15 +0200
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	Christoph Hellwig <hch@lst.de>, David Howells <dhowells@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, linux-rdma@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: Removing ->dirty_folio
Message-ID: <20260826074215.GA18668@lst.de>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org> <CAG48ez0vXVUu9j4rYUeCqgwyHKAiN_6fL--D90WvX9q7B41V-A@mail.gmail.com> <ao3y8TtEGjniZ_4f@casper.infradead.org> <20260826050733.GB15122@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826050733.GB15122@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Aug 26, 2026 at 07:07:33AM +0200, Christoph Hellwig wrote:
> The interesting case is FOLL_LONGTERM, as it can pin I/O for a much
> longer time.  And that also means IFF the user of FOLL_LONGTERM actually
> wants to be able to persist data on a shared mmap, it has to manually
> dirty folios one or more times during the FOLL_LONGTERM pin, because
> otherwise the file system would never know there is dirty data.
> The set_page_dirty call in ib_umem_odp_unmap_dma_pages is an example
> for that.

... not to forget the epic boss of this genre: vmsplice, which is also
still using get_user_pages_fast/FOLL_GET through iov_iter_get_pages2.

