Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955DA204C29
	for <linux-xfs@vger.kernel.org>; Thu,  9 Jan 2025 07:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736408349; cv=none; b=HnNhaAdkVLV9mFJP0F5M/iO3+44yhqKztrIhPzyFBt6hoHKRcj78/scU1bZ2J6lOQFKx9omHhlPSeC1QSsqONwFGY2BA1V8k/y9oCyb0ahFtQv8xHXadf2ZHI9u80xg3u64BtqhSeZ9GTsFkTF41b3HU8jFaVL13mccu3mxvEoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736408349; c=relaxed/simple;
	bh=ZgBRRbUly5zZEEsRkGRz9vILfsScpBX8GjvrjhnbMbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J6L/HNmT8E418GryJ/rovpi8AfTUkIjgQ9F61NytJ+fLe0yeq4vKo/WxD6H3YUGRkfnAFMRB/p4bRsaRWWcwukHquuFZh5vn/Srl9gMXxxxCXKvTwtVaY9mxxEufe+oBl/f46KAcI1FShNAwUwzobCdlS8J72odZDfrzevjcsXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HFBXYn9B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HFBXYn9B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC41DC4CED2;
	Thu,  9 Jan 2025 07:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736408349;
	bh=ZgBRRbUly5zZEEsRkGRz9vILfsScpBX8GjvrjhnbMbQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HFBXYn9Bcy9uv0FTTKyn9f2nPDJZ4T9GrYQIyj727RdpVW+nYMriuuZou0547DbxK
	 +rtFWxXlKMuo3dOxCNSu4uUOmZvtSXjd6GPm52jBmpMmj6zSr8g+Z/lg55i0asq3Dx
	 wOi4H8ArTPgBCbOyTkUpZNPyN5fIxI57YPzEhol92cuZkoQ77VwQoF5Uam7t+43Adi
	 /7FnjbXBXt17DFJbGZLO/j4d83UyaS4iEhx2WaxqwCEbT9ZrVsQycdG13d+YmzkJKH
	 S4euI4g11OXGJVTEm8wrbVOcbvbvS2aqCN9gV3SoCQUWucGnfCrGXzJn4uxU97zLhO
	 wJULvhakT19DQ==
Date: Wed, 8 Jan 2025 23:39:08 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
	david@fromorbit.com, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [RFC] Directly mapped xattr data & fs-verity
Message-ID: <20250109073908.GL1387004@frogsfrogsfrogs>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20250106154212.GA27933@lst.de>
 <prijdbxigrvzr5xsjviohbkb3gjzrans6yqzygncqrwdacfhcu@lhc3vtgd6ecw>
 <20250107165057.GA371@lst.de>
 <j7barlm3iix22ytjuu5y5mptfqzjme5pfdxk2a3vgb43ukoqxg@uhbobs5fs2uz>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <j7barlm3iix22ytjuu5y5mptfqzjme5pfdxk2a3vgb43ukoqxg@uhbobs5fs2uz>

On Wed, Jan 08, 2025 at 10:20:59AM +0100, Andrey Albershteyn wrote:
> On 2025-01-07 17:50:57, Christoph Hellwig wrote:
> > On Mon, Jan 06, 2025 at 09:56:51PM +0100, Andrey Albershteyn wrote:
> > > On 2025-01-06 16:42:12, Christoph Hellwig wrote:
> > > > I've not looked in details through the entire series, but I still find
> > > > all the churn for trying to force fsverity into xattrs very counter
> > > > productive, or in fact wrong.
> > > 
> > > Have you checked
> > > 	[PATCH] xfs: direct mapped xattrs design documentation [1]?
> > > It has more detailed argumentation of this approach.
> > 
> > It assumes verity must be stored in the attr fork and then justifies
> > complexity by that.
> > 
> > > > xattrs are for relatively small variable sized items where each item
> > > > has it's own name.
> > > 
> > > Probably, but now I'm not sure that this is what I see, xattrs have
> > > the whole dabtree to address all the attributes and there's
> > > infrastructure to have quite a lot of pretty huge attributes.
> > 
> > fsverity has a linear mapping.  The only thing you need to map it
> > is the bmap btree.  Using the dabtree helps nothing with the task
> > at hand, quite to the contrary it makes the task really complex.
> > As seen both by the design document and the code.
> > 
> > > Taking 1T file we will have about 1908 4k merkle tree blocks ~8Mb,
> > > in comparison to file size, I see it as a pretty small set of
> > > metadata.
> > 
> > And you could easily map them using a single extent in the bmap
> > btree with no overhead at all.  Or a few more if there isn't enough
> > contiguous freespace.
> > 
> > > 
> > > > fsverity has been designed to be stored beyond
> > > > i_size inside the file.
> > > 
> > > I think the only requirement coming from fs-verity in this regard is
> > > that Merkle blocks are stored in Pages. This allows for PG_Checked
> > > optimization. Otherwise, I think it doesn't really care where the
> > > data comes from or where it is.
> > 
> > I'm not say it's a requirement.  I'm saying it's been designed with
> > that in mind.  In other words it is a very natural fit.  Mapping it
> > to some kind of xattrs is not.
> > 
> > > Yes, that's one of the arguments in the design doc, we can possibly
> > > use it for mutable files in future. Not sure how feasible it is with
> > > post-EOF approach.
> > 
> > Maybe we can used it for $HANDWAVE is not a good idea. 
> 
> > Hash based verification works poorly for mutable files, so we'd
> > rather have a really good argument for that.
> 
> hmm, why? Not sure I have an understanding of this

Me neither.  I can see how you might design file data block checksumming
to be basically an array of u32 crc[nblocks][2].  Then if you turned on
stable folios for writeback, the folio contents can't change so you can
compute the checksum of the new data, run a transaction to set
crc[nblock][0] to the old checksum; crc[nblock][1] to the new checksum;
and only then issue the writeback bio.

But I don't think that works if you crash.  At least one of the
checksums might be right if the device doesn't tear the write, but that
gets us tangled up in the untorn block writes patches.  If the device
does not guarantee untorn writes, then you probably have to do it the
way the other checksumming fses do it -- write to a new location, then
run a transaction to store the checksum and update the file mapping.

In any case, that's still just a linear array stored in some blocks
beyond EOF, and (presumably) growing in the top of the file.  Maybe you
can even have a merkle(ish) tree to checksum the checksum leaves.  But I
don't see why the xattr stuff is needed at all in that case, but what
I'm really looking for here is this -- do you folks have some future
design involving these double-checksummed headerless remote xattr
blocks?  Or a more clever data block checksumming design than the stupid
one I just came with?

<shrug>

> > > I don't really see the advantage or much difference of storing
> > > fs-verity post-i_size. Dedicating post-i_size space to fs-verity
> > > dosn't seem to be much different from changing xattr format to align
> > > with fs blocks, to me.
> > 
> > It is much simpler, and more storage efficient by doing away with the
> > need for the dabtree entries and your new remote-remote header.

I agree... at least in the absence of any other knowledge.

--D

> 
> I see.
> 
> -- 
> - Andrey
> 
