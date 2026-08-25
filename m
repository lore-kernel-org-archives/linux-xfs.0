Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152842B2D7;
	Tue, 25 Aug 2026 19:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787685375; cv=none; b=o8EQfgI7yeFdAjksQ1niD6zjZ6INVCTqocKA36b22N3TI7PI3BEPQoojvBdvIyf+I5nDqUoPpuMcSiq4KCCW+d4IqDevu+CdJZcit26XQtzkK8hr3UCJOVnc8+a/3Xb8hgaj5o5thKzzrnteciAF7MmZyHBM7zJP6mHV6vVkJjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787685375; c=relaxed/simple;
	bh=rXtS4lqKXv5+XHu4i78YlqMyRuGgxSA34Z6hgz1wqN8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ew3HsLqM3b3TOB1jTOrTna6HaZvdopL49glo3aJE/XQGWiAIX22cRCu0t9qcevR3USuBD9NlXDOY+bDQilxttqv7T4bvOtHLdTqd56jVewmddTh2LBaKJpgKVXVC/JaOQZZZ2LnUpochOZ07zz0QsoP4GxxAdmnpdTOCdLBIiMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=G09TgWUe; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="G09TgWUe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ycXANbtGC0cUw84iuY50XDEeCaFMT6BdiIVSuYymPl8=; b=G09TgWUeIwSs4vxXpNMyxpfWFu
	2vfuSKgft3JGN5DgcxEAP8qFTNiz5/q1nWpCVeG+nk/0vQFq7MTEXSrAhrlMKp5xnLlcGWBXm3ASp
	J/MD/QHCyS3Zql66PM6J0c1v65m5lQWwOI6xmq/vs1ECTRmGMpaGVBuetOkRG5gEAUpc1HDSp5n1Q
	fHu1OIqCVnFidu6LDjAM48gUzdzOXVY65VQWr4zQ250pcAgKsVdkC2hExrCPKcSKtQSOqKx4FqP86
	FCTZr1gq6bfKLYRlJgkgMA/t61T4tlKRoFa71LU3P6aue9NcBTQbSGDGNcpVlw0bo1gUCQ5XHqc09
	TCV+qAZg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wywcw-00000009aXy-02wf;
	Tue, 25 Aug 2026 19:16:06 +0000
Date: Tue, 25 Aug 2026 20:16:05 +0100
From: Matthew Wilcox <willy@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>,
	Jann Horn <jannh@google.com>, John Hubbard <jhubbard@nvidia.com>,
	Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>,
	Qu Wenruo <wqu@suse.com>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Message-ID: <ao3p9StpLtZloDcT@casper.infradead.org>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
 <798622.1787640486@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <798622.1787640486@warthog.procyon.org.uk>

On Tue, Aug 25, 2026 at 07:48:06AM +0100, David Howells wrote:
> Matthew Wilcox <willy@infradead.org> wrote:
> 
> > I'm probably missing some stuff here.  Let me know.
> 
> mmap()?  That usually tosses a spanner in somewhere.

Well, you have to have mmap()ed a file for GUP to be able to happen.
And it has to be shared writable for us to care about writeback.
The nice thing about GUP is that it goes through the normal fault
handler path.  The nasty thing about GUP is that we don't have a way to
revoke a GUP access to that page like we do through page tables.
> 
