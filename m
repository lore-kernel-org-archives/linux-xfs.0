Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942F13BBF6
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 01:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728954873; cv=none; b=UCWRI+30LW4XOKnq5nL3HLIa6i5DgZu1zby2V6Rxk05WDJ3pXNc2stZX/j7Hl5oKVQQBqwrOeTt7/VY+1AD/H1GH+bt1NOHCzH34plhw7dqHpF5MDAJ3PDqEAw45zhE6pfSaRb+X8z1aI78vXjYLR+lMk3HQoIYHOgejw82TXLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728954873; c=relaxed/simple;
	bh=qz98XDru2Cj8wP4JOV5u/TddLrSIrQ9QGDHyR+Mq900=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IbiwFmzeIvCYHDQ9feuuhD8yO7Hmvkcog5j7koyK2mkOObBLOmB6113Lte85bzg7q8J6+mf839SY/i4SspeoV2IHG9WUCDAVOlKyS+ZeA5eFDQK6d2sjY5Duhn+cFQl6yu7myS4BF/tlaRomCdVdtmPw1jCdYjZ810fECD5ad2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nLkyO82f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nLkyO82f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB42C4CEC3;
	Tue, 15 Oct 2024 01:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728954873;
	bh=qz98XDru2Cj8wP4JOV5u/TddLrSIrQ9QGDHyR+Mq900=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nLkyO82f4kiKTGIMPKG6GFJu1plaNvuT8w0+md4URixQ2ExIUCoyHa/LhXE4GITqn
	 nueSlyupiUIw3I1qSun74iMnzABQiju+3warNsQygt1UxdRcf64/UsXK3Ar1RY+rKG
	 /XdmQMvY86QmXumWrmdY3JGw0tFtsT19mJHf8/DJHTXdjtD+brPKqcC4peVXaSZhqR
	 6Z2WbjAw+XF8HGjtDsddqheoXNuvl2SUuVvTiUqR0aDqyzIbxLTClU3NZiUdtX2eFR
	 bita/7QJNOYVeaJ9VRaS0dM0Wvch779UITKBdS8D16R71kM/76HyROxwoLG5P7MMAH
	 du6dCV2H2jY6A==
Date: Mon, 14 Oct 2024 18:14:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: "hch@infradead.org" <hch@infradead.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 10/36] xfs: export the geometry of realtime groups to
 userspace
Message-ID: <20241015011432.GQ21853@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
 <172860644412.4178701.5633521217539140453.stgit@frogsfrogsfrogs>
 <ZwzXRdcbnpOh9VEe@infradead.org>
 <8ecae4c5-aeaa-4889-8a3a-e4ba17f3bf7c@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8ecae4c5-aeaa-4889-8a3a-e4ba17f3bf7c@wdc.com>

On Mon, Oct 14, 2024 at 01:27:57PM +0000, Hans Holmberg wrote:
> On 14/10/2024 10:33, Christoph Hellwig wrote:
> > On Thu, Oct 10, 2024 at 06:04:17PM -0700, Darrick J. Wong wrote:
> >> From: Darrick J. Wong <djwong@kernel.org>
> >> +	__u32 rg_number;	/* i/o: rtgroup number */
> >> +	__u32 rg_length;	/* o: length in blocks */
> >> +	__u32 rg_capacity;	/* o: usable capacity in blocks */
> > 
> > So the separate length vs capacity reporting was needed for my previous
> > implementation of zoned devices with LBA gaps.  Now that RT groups
> > always use segmented addressing we shouldn't need it any more.
> > 
> > That being said Hans was looking into using the capacity field to
> > optimize data placement in power users like RockѕDB, and one thing
> > that might be useful for that is to exclude known fixed metadata from
> > the capacity field, which really is just the rtsb on rtgroup 0.
> > 
> 
> Yeah, it would be very useful for apps to know the available user capacity
> so that file sizes could be set up to align with that.
> 
> When files are mapped to disjoint sets of realtime groups we can avoid garbage
> collection all together. Even if the apps can't align file sizes perfectly to
> the number of user writable blocks, write amplification can be minimized
> by aiming for it.

Hmmm so if I'm understanding you correctly: you want to define
"capacity" to mean "maximum number of blocks available to userspace"?

Does that available block count depend on privilege level (ala ext4
which always hides 5% of the blocks for root)?  I think the answer to
that is 'no' because you're really just reporting the number of LBAs in
that zone that are available to /any/ application program, and there's a
direct mapping from 'available LBAs in a zone' to 'rgblocks available in
a rtgroup'.

But yeah, I agree that it might be nice to know total blocks available
in a particular rtgroup.  Is it useful to track and report the number of
unwritten blocks remaining in that group?

For example, if the rtgroup size is 1024 fsblocks, the zns zone actually
only has 8000 lba == 1000 fsblocks, and you've already written to 200
fsblocks of it, then we'd report:

rg_length: 1024
rg_capacity: 1000
rg_avail: 800

Here the program knows that every 1000*4k bytes it writes will result in
a jump to a new rtgroup; and that the next time this will happen is
after it writes 800*4k bytes more?  (Assume the usual frictionless
system with no other writers :P)

--D
