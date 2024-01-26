Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B93718626
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 14:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706278722; cv=none; b=riEh3kXOHbIAy+oEnh6xYUURRr49/Boll+2hav/ibbqXLtumTYBhU+FEZVl3M1juB1kVkBcIvRametSbJrUF37ADlMrdQ/TLMuQhXq2xlNNJ6jcITRYT5d7Y9p+N/T87l8v4YvWdgaDytSOF2WYmcsGSZFEdRC+vqHqiimPjQAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706278722; c=relaxed/simple;
	bh=vr9/PiqZYq75Gl46jRQ7Ws8nDbOftGp4ggYxSAKRxQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uRetkwBnws5oVMavaoluAMB87AJuNIiseIbgoh7/beJGtDEdrFkrr+bpjXm3WJvphyF9LAzrb1qSH2vUkE0O3bb/+VIcpTnHO0RM42Fid/wNVKRmLJWTgNtaXBPpCkwt9FEE4kjq6OPbPKHuA8rRFndliNRHNIbC28l5RZ5n8a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 13A1968C4E; Fri, 26 Jan 2024 15:18:35 +0100 (CET)
Date: Fri, 26 Jan 2024 15:18:34 +0100
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: put the xfs xfile abstraction on a diet v2
Message-ID: <20240126141834.GA4288@lst.de>
References: <20240126132903.2700077-1-hch@lst.de> <ZbO-kMfwhg1TAGn5@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZbO-kMfwhg1TAGn5@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jan 26, 2024 at 02:15:44PM +0000, Matthew Wilcox wrote:
> hwpoison is per page not per file.  That's intrinsic to, well, hardware
> poison, it affects an entire page (I'd love to support sub-page poison,
> but not enough to spend my time working on memory-poison.c).
> 
> In general, I think there's a lack of understanding of hwpoison, and
> I include myself in that.  Mostly I blame Intel for this; limiting the
> hardware support to the higher end machines means that most of us just
> don't care about it.
> 
> Why even bother checking for hwpoison in xfiles?  If you have flaky
> hardware, well, maybe there's a reason you're having to fsck, and crashing
> during a fsck might encourage the user to replace their hardware with
> stuff that works.

But the sentence is stale actually - we're using folios now after Darrick
coded up a helper check all the hwpoison cases and others.  I should
have removed it from the commit log.  Crashing is never a good idea
I think if we can easily avoid it.

Note that I still find the difference in hwpoison checking in shmem
vs filemap rather confusing.
