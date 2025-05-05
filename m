Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB192E62C;
	Mon,  5 May 2025 07:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746429044; cv=none; b=ah1ZV9crsUTi57vRncicoItKmtof9u60DgCYKiu19ubUw4xUXQCwnXD0r2oe8CIsl44RgN0boy/GRbfBTorwBGVhu1dNxDm1/LlT3zaABOZWjayPcEXy7io/Ee5GRGoRDSYO5bDeZQP743Y6wT20lf+Fv4pdRglYyq8BvtiJR5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746429044; c=relaxed/simple;
	bh=xBd+W3ZoyuxN5L3bU9S3LAlbhway874q22Inxj9LXn8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NuI9bUv069y0z6rE7geeN5Al6/u32WzgICyELPEpfNamxYQ0RMDxuaJ4icuNNOQ2mG4g17TXaCiTtoaegBvZ+HOZXuTQcRZOfD0wePkDls9A5/13worApBAT0aEqhCRQ4Ft1m34OklaSRdmTA0G05Ms1IHFyXqcIjYvOa6XBuRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TgtrVWA2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TgtrVWA2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE61BC4CEE4;
	Mon,  5 May 2025 07:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746429043;
	bh=xBd+W3ZoyuxN5L3bU9S3LAlbhway874q22Inxj9LXn8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TgtrVWA2Ac/YcSXOLl1HDzO2Cb+zrUUkOZKCkD5w69+NPjMcrPfo/wwOFTLPG4/Iv
	 8odhs+/z0+i0+tcFkwc0TmYdUzTaxX3Dbu7JgugjXyryREHgUjqrFo82DgGAOP/8p3
	 Zy3vWvP4ddQ1L2ZxqFU7MTnfPw0XOu9k8LYZZLUUO02Yc5aeHUJtmH6/6HyIk261i9
	 sOuYg1Ew0RQkOwk2+JNHQ6XuzI56x0Koi+hQsNFXgVdYQKWGdytpsAolhQ/vxPWsVI
	 deyIddsjQZZVWaQ4hgGQCW3XkFnfo1iD6KwMCS4HkfES/7TG6a2MV+eYuicyudcLDC
	 zXrcnsTRjLWSQ==
Date: Mon, 5 May 2025 09:10:38 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Charalampos Mitrodimas <charmitro@posteo.net>, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Verify DA node btree hash order
Message-ID: <wk2tqzdfersvwespapxgjwujb5nc2nvmvntdsj7uunxhcvxznb@sjli3e3i6rhp>
References: <6Fo_nCBU7RijxC1Kg6qD573hCAQBTcddQlb7i0E9C7tbpPIycSQ8Vt3BeW-1DqdayPO9EzyJLyNgxpH6rfts4g==@protonmail.internalid>
 <20250412-xfs-hash-check-v1-1-fec1fef5d006@posteo.net>
 <dyo3cdnqg3zocge2ygspovdlrjjo2dbwefbvq6w5mcbjgs3bdj@diwkyidcrpjg>
 <lbaob9s1_tUxYvjGHQenkwdnv3WRsD4qjMur4VE5ELE_Ph4Q388PDEmb8bOGuSRnRpbC0mAW-du5eG2UpwmpGg==@protonmail.internalid>
 <20250501141249.GA25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250501141249.GA25675@frogsfrogsfrogs>

On Thu, May 01, 2025 at 07:12:49AM -0700, Darrick J. Wong wrote:
> On Wed, Apr 30, 2025 at 11:23:57AM +0200, Carlos Maiolino wrote:
> > On Sat, Apr 12, 2025 at 08:03:57PM +0000, Charalampos Mitrodimas wrote:
> > > The xfs_da3_node_verify() function checks the integrity of directory
> > > and attribute B-tree node blocks. However, it was missing a check to
> > > ensure that the hash values of the btree entries within the node are
> > > strictly increasing, as required by the B-tree structure.
> > >
> > > Add a loop to iterate through the btree entries and verify that each
> > > entry's hash value is greater than the previous one. If an
> > > out-of-order hash value is detected, return failure to indicate
> > > corruption.
> > >
> > > This addresses the "XXX: hash order check?" comment and improves
> > > corruption detection for DA node blocks.
> > >
> > > Signed-off-by: Charalampos Mitrodimas <charmitro@posteo.net>
> > > ---
> > >  fs/xfs/libxfs/xfs_da_btree.c | 11 ++++++++++-
> > >  1 file changed, 10 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> > > index 17d9e6154f1978ce5a5cb82176eea4d6b9cd768d..6c748911e54619c3ceae9b81f55cf61da6735f01 100644
> > > --- a/fs/xfs/libxfs/xfs_da_btree.c
> > > +++ b/fs/xfs/libxfs/xfs_da_btree.c
> > > @@ -247,7 +247,16 @@ xfs_da3_node_verify(
> > >  	    ichdr.count > mp->m_attr_geo->node_ents)
> > >  		return __this_address;
> > >
> > > -	/* XXX: hash order check? */
> > > +	/* Check hash order */
> > > +	uint32_t prev_hash = be32_to_cpu(ichdr.btree[0].hashval);
> > > +
> > > +	for (int i = 1; i < ichdr.count; i++) {
> > > +		uint32_t curr_hash = be32_to_cpu(ichdr.btree[i].hashval);
> > > +
> > > +		if (curr_hash <= prev_hash)
> > > +			return __this_address;
> > > +		prev_hash = curr_hash;
> > > +	}
> >
> > Hmmm. Do you have any numbers related to the performance impact of this patch?
> >
> > IIRC for very populated directories we can end up having many entries here. It's
> > not uncommon to have filesystems with millions of entries in a single directory.
> > Now we'll be looping over all those entries here during verification, which could
> > scale to many interactions on this loop.
> > I'm not sure if I'm right here, but this seems to add a big performance penalty
> > for directory writes, so I'm curious about the performance implications of this
> > patch.
> 
> It's only a single dabtree block, which will likely be warm in cache
> due to the crc32c validation.

I assumed this could be called to verify a leaf block, a look at the code
seems that's not the case, so, this is perhaps harmless related to performance.

> 
> But if memory serves, one can create a large enough dir (or xattr)
> structure such that a dabtree node gets written out with a bunch of
> entries with the same hashval.  That was the subject of the correction
> made in commit b7b81f336ac02f ("xfs_repair: fix incorrect dabtree
> hashval comparison") so I've been wondering if this passes the xfs/599
> test?  Or am I just being dumb?
> 
> --D
> 
> > >
> > >  	return NULL;
> > >  }
> > >
> > > ---
> > > base-commit: ecd5d67ad602c2c12e8709762717112ef0958767
> > > change-id: 20250412-xfs-hash-check-be7397881a2c
> > >
> > > Best regards,
> > > --
> > > Charalampos Mitrodimas <charmitro@posteo.net>
> > >
> >
