Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15CF152DFE
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 16:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706544269; cv=none; b=a36AVWxQLqMwrXvrs6+JyhVxTaID7qMQwJLat9fllSXPMcFuvMh+IhhCwz65YED64HB0zQg4mpmbM9jolIiH8s8AvrVzjYdrNwH8TSzk8fjcxYIQI/p+dkbMsaeNtiqQmOifrBvmacTdjF/6ITu31/wHxSCshAs//vjSogfkKmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706544269; c=relaxed/simple;
	bh=PRHDUsL8Tqo/ebf24p87gv26R0s2BUOxVjeHcgb4x7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M+j09hN0h8mXiwwkYlpg2lNJA5E/FMHeQw0D5a+QjkI0ycaLhBYEyLYTjwPaP1NrE5Sho9JCMLkrcp1W8vB9BSlF+zLaK8ysHtCCv1jhH9TOTHQGAIDpLRfh113gjTRClhGXRkytUjfOz/BFA0dGHxv1hURX23VOKucqWhVu3sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4E4CC227A8E; Mon, 29 Jan 2024 17:04:22 +0100 (CET)
Date: Mon, 29 Jan 2024 17:04:21 +0100
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
Message-ID: <20240129160421.GA3082@lst.de>
References: <20240126132903.2700077-1-hch@lst.de> <20240126132903.2700077-8-hch@lst.de> <ZbPUilScedGAm8g_@casper.infradead.org> <20240128165434.GA5605@lst.de> <ZbfKykFtm64CjjL6@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZbfKykFtm64CjjL6@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 29, 2024 at 03:56:58PM +0000, Matthew Wilcox wrote:
> Could I trouble you to elaborate on what you'd like to see a filesystem
> like ubifs do to replace write_begin/write_end?  After my recent patches,
> those are the only places in ubifs that have a struct page reference.
> I've been holding off on converting those and writepage because we have
> plans to eliminate them, but I'm not sure how much longer we can hold off.

I think the abstraction is okay for anyone using generic_perform_write.
The problem with them is that they are not generic operations called
by higher level code, but callbacks that depend on caller context.
So in perfect world they would be passed directly to
generic_perform_write and the few other users and not go through aops.
