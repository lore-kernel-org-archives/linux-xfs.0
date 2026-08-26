Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CC43B71B2;
	Wed, 26 Aug 2026 07:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787730906; cv=none; b=jjKFnhN5UlpVhqoSYbyO0CfLXM9w57bTvg7h41uW1PGZfvbQKhILN0GqTIJqv2jaNEHHYDbhiXaMFkdG+S9i3Q0TPdHkdlEb35OZ4QPYqc+Ls/2ucvFXBqiX1kxuY09pPiH2RUsBuWN7SaWBySExeqSxWDk29+d+kO0xW9EUF4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787730906; c=relaxed/simple;
	bh=t6IeEGHJVwj1rPfZMcsSZpapL6LE+E4DhLBs4hNzWK8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UIdrsMmhk4U7WAUnOrt1Is/STDJ2lOqk/IBSKMe9LnrNp/J/JjDmEPVWuAypGk569zJXevOHLYTplNzivub1UGp0Hf+UH++NIVCGfhwPXOJ5VhY5SdsGFl2CSS8atUMMjWf7pEsLrpJD5WJrQ3Dvhxxj+oBpNdqNdgvNjMBgEaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3D3D268B05; Wed, 26 Aug 2026 09:54:59 +0200 (CEST)
Date: Wed, 26 Aug 2026 09:54:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>,
	Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Message-ID: <20260826075458.GB19050@lst.de>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org> <ao1Lo6TKhPcqV42B@pedro-suse> <ao3gZRa7HOEg209P@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao3gZRa7HOEg209P@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 25, 2026 at 07:35:17PM +0100, Matthew Wilcox wrote:
> > I don't think you can do this for stable writes. It's probably ok for
> > !stable writes filesystem stacks, as long as the filesystem & writeback
> > can handle making no progress at all. But since stable writes' writeback
> > can't race with "writes", I don't think you can Just Do It as long as the
> > folio is DMA pinned.
> 
> Ah, yes, I forgot to specify that.  For mappings which need stable pages,
> we have to bounce buffer them.  I wonder if that's something we should
> do inside the VFS or if each filesystem should try to do it itself?

If you implement the writeback without clearing dirty by going through
the direct I/O path (with whatever customization is needed like not
invalidating overlapping page cache), you get to use whatever bounce
buffering the file system already implemented to deal with unstable
data for free.  Assuming it already had that, but if not there's not
point in adding it just for this corner case.

