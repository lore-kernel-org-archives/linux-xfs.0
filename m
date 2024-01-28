Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DE11E508
	for <linux-xfs@vger.kernel.org>; Sun, 28 Jan 2024 16:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706460887; cv=none; b=K1zKVzkH6lKtEHeM+B/CUS7MAqwbYQCIuRQ9658LHdjWkfTiobhHjqG4sUk7BIGl9hl5rOthmEtV/ORLCyHNbH3zYpd52yHyiadcCnCmw7FNOuafMx/DvkDYtV1RacHnSQaIbZNaFlvwDWTTiPwKsmgdi6dZDuq0c+arDvtXGEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706460887; c=relaxed/simple;
	bh=W56i1iUWMn7xsZcBOGZvlGYEi/pxY5kt9yY/RSeBnQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s2LCYAtbKtVHougyTvwcMolt0FlWnyjwkg6RDb32qZ29nxpeo+yaLPy3IPxMtadQkvXbrQ0IiQUqyTTpGNgs9q9fWX+OqkldTDd/5FenzgFoekkuZ/TSa17kA1GZbWwAQDig7CcWccS+zWNcPMHM8DCk+4VAzOJ44pMeNh2IfkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4BAD168B05; Sun, 28 Jan 2024 17:54:34 +0100 (CET)
Date: Sun, 28 Jan 2024 17:54:34 +0100
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 07/21] shmem: document how to "persist" data when using
 shmem_*file_setup
Message-ID: <20240128165434.GA5605@lst.de>
References: <20240126132903.2700077-1-hch@lst.de> <20240126132903.2700077-8-hch@lst.de> <ZbPUilScedGAm8g_@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZbPUilScedGAm8g_@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jan 26, 2024 at 03:49:30PM +0000, Matthew Wilcox wrote:
> This doesn't quite make sense to me.  Do you mean:
> 
>  * If the caller modifies data in the folio, it must call folio_mark_dirty()
>  * before unlocking the folio to ensure that the folio is not reclaimed.
>  * There is no equivalent to write_begin/write_end for shmem.
> 
> (also this should go before the Return: section; the return section
> should be the last thing in the kernel-doc)

So the first sentence and moving the section makes total sense.
The second sentence I don't think is very useful.  write_begin/write_end
are relaly just a way for generic_perform_write to do the space
reservation and extending i_size and not really methods in the classic
sense.  They should go away from a_ops and certainly don't end up
being mentioned in shmem.c.

What I have now is this:

If the caller modifies data in the folio, it must call folio_mark_dirty()
before unlocking the folio to ensure that the folio is not reclaimed.
These is no need to reserve space before calling folio_mark_dirty().

but I'm open to further improvements.
