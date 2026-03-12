Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C01363C4D;
	Thu, 12 Mar 2026 14:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773327171; cv=none; b=oN5q3KP7gqroKJcJkWrl/Fqnw8HmhMAdswf5yualhnBKQqLMqJEiGbNOK2ufC0s2jNrM01qnzIB2c0MVsmQ+Ay9rem8S432q9kLcKSkq+BwDfrJi3ifZFvZTYj37Urfpqegju4KW42Hpkis9hbAeHJO/jp7HETyYFEvWcpAPIEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773327171; c=relaxed/simple;
	bh=XXRoLW5PPkxCND8B4ImdToPWiFZE9WfidZSxqoOee0k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b1UowPtBAyEBo6fmCSzvbmff5kJgg0iZ1QgjNRG6/F+tDSd7lW3vwQnr32Dkn19VZa8gqoe3fHuJuDR78A1fovAHRS8/sB9dHvQfJWoxfaaiGeevbB8uDCtXBtDluQTRUx2YSlu5hN68bXDfuwo8rsm3o5lKGkrBvhbsgZ5lGDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tGWdX1gG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tGWdX1gG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DFF9C4CEF7;
	Thu, 12 Mar 2026 14:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773327171;
	bh=XXRoLW5PPkxCND8B4ImdToPWiFZE9WfidZSxqoOee0k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tGWdX1gGMIAsB7zM1mPWjtb1RZFPGD3vDnjI+sBmpir8tSsen2/ic68Ma9EBUNSw5
	 P+Vdq92Iaf48by8SLyoH3yj/bwZySOXGsJcDkGbOUFDgCYWdtzozCJViroaLJW0M8n
	 Y3easI+nkr/V2Zqk/TEWbbJ+fscjhQWlnm8i0KCgUGCHqe0cn35/Yl9C82vpHfx003
	 yvq7h7bYqJdedFbW0c/Jul45OK8xK6KGZzXb+ZUkObYdrIZf085O5CBSrZCbrhVbJG
	 NayUE0HtiaTpJrxbqIPjKJdvKLSyuJ8Dl6tMoWYpkh5g9WNlQ/pr3Bcdml9Oz/0JEh
	 XlI/nhSbvPdiQ==
Date: Thu, 12 Mar 2026 07:52:50 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org, hch@lst.de, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 19/25] xfs: remove unwritten extents after
 preallocations in fsverity metadata
Message-ID: <20260312145250.GE6069@frogsfrogsfrogs>
References: <20260309192355.176980-1-aalbersh@kernel.org>
 <20260309192355.176980-20-aalbersh@kernel.org>
 <20260310012914.GG1105363@frogsfrogsfrogs>
 <ymisdrze3ohdnxa4inqfwp4riaz4qk5nmtil33adn5ukhngq7v@f3tcv3hbzobz>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ymisdrze3ohdnxa4inqfwp4riaz4qk5nmtil33adn5ukhngq7v@f3tcv3hbzobz>

On Thu, Mar 12, 2026 at 02:50:57PM +0100, Andrey Albershteyn wrote:
> On 2026-03-09 18:29:14, Darrick J. Wong wrote:
> > > XFS preallocates spaces during writes. In normal I/O this space, if
> > > unused, is removed by truncate. For files with fsverity, XFS does not
> > > use truncate as fsverity metadata is stored past EOF.
> > > 
> > > After we're done with writing fsverity metadata iterate over extents in
> > > that region and remove any unwritten ones. These would be preallocation
> > > leftovers in the merkle tree holes and past fsverity descriptor.
> > > 
> > > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > > ---
> 
> > There's an upper limit on the number of blocks you can unmap/free in a
> > single transaction.  Maybe move the xfs_trans_{alloc,commit} into the
> > loop body?
> > 
> > Oh wait, you skip the written extents.  Ok, so maybe just roll it after
> > you've done a bunmapi.
> 
> I see, I will add a rolling transaction. Btw, why skipping the
> written extents let's us use rolling here?

Hrmm.  At first I thought: why can't xfs_fsverity_cancel_unwritten
allocate (and commit) the transaction inside the loop body?  Then I
thought "well, it's only conditionally unmapping things, and it's sort
of a pain to allocate a transaction only then to find out if you
actually want to run one".

OTOH there could be billions of extents in the data fork, so holding the
ILOCK for that many transactions isn't a good thing because tr_write
only preallocates space for a certain number of transaction rolls.
fsverity already holds IOLOCK_EXCL so there can't be any other programs
using the file.

So now I arrive back at "The transaction allocation and commit/cancel
should be inside the loop body, since crashing midway through wouldn't
result in user-visible changes to the file data".

> > Do you need to purge the cow fork too?
> 
> hmm, what case are you thinking about here? The fsverity is written
> in past EOF region, I don't see how COW extent could be left there.
> Can they somehow be left mapped for blocks past i_size?

I was talking about speculative cow fork preallocations below i_size.
They'll eventually get purged by blockgc, but you could give the space
back once you've committed enabling the fsverity file flag.

--D
