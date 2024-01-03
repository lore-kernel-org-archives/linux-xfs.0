Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651855C9A
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 02:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hTG7ZHxZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51BBC433C9;
	Wed,  3 Jan 2024 02:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704248966;
	bh=/oFXVglLyimogX4C6qGZk7EF2JqB+2LWAx2ccXL7pKY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hTG7ZHxZTbPt/tyfzUgY1ahzuGezkvfD0AyARHzrveia7M4kLWV/vr5S6NqG2cNWv
	 TOsJH37Uyqf4oXxtoWnqNMPLDQ78G8llucZHGBk8GzNnoO7gvDBb1xTtfk5VvYv3XE
	 TSjax6u/drAWbXRtisczfwyrvNZTQPs7WkL9lo/a+S5ZH4BMy6fZAnOZiYXwFUEwi4
	 zYrt6t/LP7zxuMCyO8r/MeZUCP2E8XCIxI6w/FV6EBYbSnIWDQ23JPlpsuxuM9bUY5
	 nJ5TTN26zpU7+B8IS4zsNXeFxt8LiQ4LPudjTYnTFZavNqaU6fMuRut70zyd3PnvUX
	 QbCoTg9dP+DRw==
Date: Tue, 2 Jan 2024 18:29:26 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: define an in-memory btree for storing refcount
 bag info during repairs
Message-ID: <20240103022926.GK361584@frogsfrogsfrogs>
References: <170404830995.1749557.6135790697605021363.stgit@frogsfrogsfrogs>
 <170404831037.1749557.13971406924347839328.stgit@frogsfrogsfrogs>
 <ZZPoZAb4jd9tvaOi@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZPoZAb4jd9tvaOi@infradead.org>

On Tue, Jan 02, 2024 at 02:41:40AM -0800, Christoph Hellwig wrote:
> On Sun, Dec 31, 2023 at 12:19:49PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Create a new in-memory btree type so that we can store refcount bag info
> > in a much more memory-efficient format.
> 
> Can you add a cursory explanation of what 'bag info' is?  It took me
> quite a while to figure this out by looking at the refcount_repair.c
> file, and future readers or the commit log might be a lot less savy
> in finding that information.  The source file could also really use a
> comment explaining the bag term and what is actually stored in it.

In the original refcount recordset regenerator in xfs_repair, refcount
records are generated from rmap records.  Let's say that the rmap
records are:

{agbno: 10, length: 40...}
{agbno: 11, length: 3...}
{agbno: 12, length: 20...}
{agbno: 15, length: 1...}

It would be convenient to have a data structure that could quickly tell
us the refcount for an arbitrary agbno without wasting memory.  An array
or a list could do that pretty easily.  List suck because of the pointer
overhead.  xfarrays are a lot more compact, but we want to minimize
sparse holes in the xfarray to constrain memory usage.  Maintaining
order isn't critical for correctness, so I created the "rcbag", which is
shorthand for an unordered list of (excerpted) reverse mappings.

So we add the first rmap to the rcbag, and it looks like:

0: {agbno: 10, length: 40}

The refcount for agbno 10 is 1.  Then we move on to block 11, so we add
the second rmap:

0: {agbno: 10, length: 40}
1: {agbno: 11, length: 3}

The refcount for agbno 11 is 2.  We move on to block 12, so we add the
third:

0: {agbno: 10, length: 40}
1: {agbno: 11, length: 3}
2: {agbno: 12, length: 20}

The refcount for agbno 12 and 13 is 3.  We move on to block 14, and
remove the second rmap:

0: {agbno: 10, length: 40}
1: NULL
2: {agbno: 12, length: 20}

The refcount for agbno 14 is 2.  We move on to block 15, and add the
last rmap.  But we don't care where it is and we don't want to expand
the array so we put it in slot 1:

0: {agbno: 10, length: 40}
1: {agbno: 15, length: 1}
2: {agbno: 12, length: 20}

The refcount for block 15 is 3.  Notice how order doesn't matter in this
list?  That's why repair uses an unordered list, or "bag".

That said, adding and removing specific items is now an O(n) operation
because we have no idea where that item might be in the list.  Overall,
the runtime is O(n^2) which is bad.

I realized that I could easily refactor the btree code and reimplement
the refcount bag with an xfbtree.  Adding and removing is now O(log2 n),
so the runtime is at least O(n log2 n), which is much faster.  In the
end, the rcbag becomes a sorted list, but that's merely a detail of the
implementation.  The repair code doesn't care.

(Note: That horrible xfs_db bmap_inflate command can be used to exercise
this sort of rcbag insanity by cranking up refcounts quickly.)

--D
