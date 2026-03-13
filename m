Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6B03A7F74;
	Fri, 13 Mar 2026 14:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773413752; cv=none; b=LDzjf+LfqH1gOChC7ZrqeoX8ddldpj/u7gy2TmqKlZjOsSWIN1JftEDq7lH3CS8kcWXR6pA9wc+g2niXVoZKpTjyf49MywgtC7qUYo65SLVNNdImk18X+V5Gxd2E4pmll/hZh96LZ+9d9FXQZ/PvHcsQBOrzHAfkd6rd5esMm1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773413752; c=relaxed/simple;
	bh=1SJdVb46rEOXp0TNCRzNQH20hOu3F1a8jHEpr/61pdg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O7wF6pWkjx8hO36/j38Beivm2HccAJRhszXIHRi7Bb7NK/SIEWToK+tYveWFeyZWdkWFqCyIWH6Umwo+8ZeI69jX6YxyeuNZ1raj+wK2I3bItLAyg91JGRuGe3tWJth5S9iibByenRNbyEnzanDWfOrGwz4iIzwCbQplnEtfRL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=STCiPlE7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="STCiPlE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E4FC19421;
	Fri, 13 Mar 2026 14:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773413752;
	bh=1SJdVb46rEOXp0TNCRzNQH20hOu3F1a8jHEpr/61pdg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=STCiPlE7YCJ6EP08/0/rI3sm0hiVo8h5O7hPvhYrwE3F9gUgh6x4qYOG+oseUMFcp
	 0fco+B87d09Raz+TTKdqXsLyYzKcXAdDlu7u6dynGTXapE5MiKaRnCLZNtHfy4iPVf
	 YrFUa2ViLJHx3lj6THIzfxNRTHyc59xkPpq2G4OYaS7/FpXFsareyepu+TXhtqXV1t
	 +IWXOamdz1kto1W1vQdKKch43W+DgpLtRQt/JCOlpjqXu2nAG9q2e5bg95X1VbUZkm
	 zFHSXzhBhfLcoSN9hVcPH55Kp/YFTYgSIxZnb4g0wcPn5Iu25E8YXr01CGvzb/Z3K7
	 vTjplDCeoUGQQ==
Date: Fri, 13 Mar 2026 07:55:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org, hch@lst.de, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 19/25] xfs: remove unwritten extents after
 preallocations in fsverity metadata
Message-ID: <20260313145551.GN1770774@frogsfrogsfrogs>
References: <20260309192355.176980-1-aalbersh@kernel.org>
 <20260309192355.176980-20-aalbersh@kernel.org>
 <20260310012914.GG1105363@frogsfrogsfrogs>
 <ymisdrze3ohdnxa4inqfwp4riaz4qk5nmtil33adn5ukhngq7v@f3tcv3hbzobz>
 <20260312145250.GE6069@frogsfrogsfrogs>
 <dz3va7indkh4to2pingopyndck737qvyxvlfomkqqothzj4pdk@wu26ba5stnf6>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dz3va7indkh4to2pingopyndck737qvyxvlfomkqqothzj4pdk@wu26ba5stnf6>

On Fri, Mar 13, 2026 at 12:17:15PM +0100, Andrey Albershteyn wrote:
> On 2026-03-12 07:52:50, Darrick J. Wong wrote:
> > On Thu, Mar 12, 2026 at 02:50:57PM +0100, Andrey Albershteyn wrote:
> > > On 2026-03-09 18:29:14, Darrick J. Wong wrote:
> > > > > XFS preallocates spaces during writes. In normal I/O this space, if
> > > > > unused, is removed by truncate. For files with fsverity, XFS does not
> > > > > use truncate as fsverity metadata is stored past EOF.
> > > > > 
> > > > > After we're done with writing fsverity metadata iterate over extents in
> > > > > that region and remove any unwritten ones. These would be preallocation
> > > > > leftovers in the merkle tree holes and past fsverity descriptor.
> > > > > 
> > > > > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > > > > ---
> > > 
> > > > There's an upper limit on the number of blocks you can unmap/free in a
> > > > single transaction.  Maybe move the xfs_trans_{alloc,commit} into the
> > > > loop body?
> > > > 
> > > > Oh wait, you skip the written extents.  Ok, so maybe just roll it after
> > > > you've done a bunmapi.
> > > 
> > > I see, I will add a rolling transaction. Btw, why skipping the
> > > written extents let's us use rolling here?
> > 
> > Hrmm.  At first I thought: why can't xfs_fsverity_cancel_unwritten
> > allocate (and commit) the transaction inside the loop body?  Then I
> > thought "well, it's only conditionally unmapping things, and it's sort
> > of a pain to allocate a transaction only then to find out if you
> > actually want to run one".
> > 
> > OTOH there could be billions of extents in the data fork, so holding the
> > ILOCK for that many transactions isn't a good thing because tr_write
> > only preallocates space for a certain number of transaction rolls.
> > fsverity already holds IOLOCK_EXCL so there can't be any other programs
> > using the file.
> > 
> > So now I arrive back at "The transaction allocation and commit/cancel
> > should be inside the loop body, since crashing midway through wouldn't
> > result in user-visible changes to the file data".
> > 
> > > > Do you need to purge the cow fork too?
> > > 
> > > hmm, what case are you thinking about here? The fsverity is written
> > > in past EOF region, I don't see how COW extent could be left there.
> > > Can they somehow be left mapped for blocks past i_size?
> > 
> > I was talking about speculative cow fork preallocations below i_size.
> > They'll eventually get purged by blockgc, but you could give the space
> > back once you've committed enabling the fsverity file flag.
> 
> hmm, if they're purged by blockgc, then why to do it here? I'm

Since you've made the file read-only by turning on fsverity, I think
it's appropriate to return the COW fork preallocations to the free space
pool.  Granted, you're correct that blockgc will eventually call
xfs_reflink_cancel_cow_range for you either due to timeout or because
something hit ENOSPC and kicked blockgc.  So I guess its not a
requirement to land this series; I was just surprised not to see
xfs_reflink_cancel_cow_range done explicitly here.

> iterating and removing unwritten extents here only because
> xfs_inode_free_eofblocks() will skip fsverity inodes, the check in
> xfs_can_free_eofblocks():
> 
> 	if (IS_VERITY(VFS_I(ip)))
> 		return false;
> 
> The skipping is done to not remove all the fsverity metadata
> extents. With preallocations enabled there could be unwritten
> extents left in the metadata.

<nod> Cleaning out the unwritten extents from the data fork when
enabling fsverity makes sense to me and is totally fine.

> Am I missing something?

Nah, but we might be talking past each other a bit at this point. :/

--D
