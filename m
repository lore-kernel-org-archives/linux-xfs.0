Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21350E567;
	Thu,  1 May 2025 14:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746108770; cv=none; b=BvRtmRhz5jsvZ0+5owT/gJNl9u5p2ao8CsOE5Hk2ZOAbbnTMaQQMKDGfj24/UbcKeYtdFLx3QkVUH2lhijAPn+kAyfRmHRscZSdTYxS0TogsADa9DHMmcQbHHK2U3Tt/2AqBWZWhqJTdGe174HK1o0LmsDRASvnO67j5JHLzE3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746108770; c=relaxed/simple;
	bh=DEPcQcNUqqfyXHzvoouqtlLOOHaet4oIue0IxVF3xow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=frNLrZx2bQ4ll76AcYQq/WXGTVaQvh5is4fQ31CATXiHwO/PPRBgyn4HaQBZuc3pQJj5AM4IA7mrMYzHSRWp+g2HuPQrKpPlltSDu1QnLxA9gtQNK1KWSK6pt4d3+34tPNyYOEShUj4rg7sL+mXSI3P9Fw8x5YpLru44ZHMv3Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fxdndoi6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fxdndoi6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1EA9C4CEE3;
	Thu,  1 May 2025 14:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746108769;
	bh=DEPcQcNUqqfyXHzvoouqtlLOOHaet4oIue0IxVF3xow=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fxdndoi6v3fBeOpXL8s1FwksY10j+nobeBSZ1z1mZL0Kvx3brEL//+GC4Y6ju3W1B
	 grTGJ1q2j2Bv/08NvFOuIQKbnuSoifBcpu+a2Fxr2vAet3vX9nguYJhjT3vwaohacY
	 4zk05FxgOJ3gWNYmYUJTiXVaBJhm4LhIl6sEJFsbtr7pVNiQqYj2NSqePXJiDkgL6a
	 1CeP9MzESz+LLiT5+sMCpXgedUZRuhWBKAA5UOrnt7mYhLr1xcbO+1p9s6YnsbvtBP
	 1Vwch/A366jTpFSCpqdySHYfTFnN9v6zF69MUARbkYDMEJIuiLbb65PQGpvcamQz5r
	 WJ4hOxzLzAShw==
Date: Thu, 1 May 2025 07:12:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Charalampos Mitrodimas <charmitro@posteo.net>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Verify DA node btree hash order
Message-ID: <20250501141249.GA25675@frogsfrogsfrogs>
References: <6Fo_nCBU7RijxC1Kg6qD573hCAQBTcddQlb7i0E9C7tbpPIycSQ8Vt3BeW-1DqdayPO9EzyJLyNgxpH6rfts4g==@protonmail.internalid>
 <20250412-xfs-hash-check-v1-1-fec1fef5d006@posteo.net>
 <dyo3cdnqg3zocge2ygspovdlrjjo2dbwefbvq6w5mcbjgs3bdj@diwkyidcrpjg>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dyo3cdnqg3zocge2ygspovdlrjjo2dbwefbvq6w5mcbjgs3bdj@diwkyidcrpjg>

On Wed, Apr 30, 2025 at 11:23:57AM +0200, Carlos Maiolino wrote:
> On Sat, Apr 12, 2025 at 08:03:57PM +0000, Charalampos Mitrodimas wrote:
> > The xfs_da3_node_verify() function checks the integrity of directory
> > and attribute B-tree node blocks. However, it was missing a check to
> > ensure that the hash values of the btree entries within the node are
> > strictly increasing, as required by the B-tree structure.
> > 
> > Add a loop to iterate through the btree entries and verify that each
> > entry's hash value is greater than the previous one. If an
> > out-of-order hash value is detected, return failure to indicate
> > corruption.
> > 
> > This addresses the "XXX: hash order check?" comment and improves
> > corruption detection for DA node blocks.
> > 
> > Signed-off-by: Charalampos Mitrodimas <charmitro@posteo.net>
> > ---
> >  fs/xfs/libxfs/xfs_da_btree.c | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> > index 17d9e6154f1978ce5a5cb82176eea4d6b9cd768d..6c748911e54619c3ceae9b81f55cf61da6735f01 100644
> > --- a/fs/xfs/libxfs/xfs_da_btree.c
> > +++ b/fs/xfs/libxfs/xfs_da_btree.c
> > @@ -247,7 +247,16 @@ xfs_da3_node_verify(
> >  	    ichdr.count > mp->m_attr_geo->node_ents)
> >  		return __this_address;
> > 
> > -	/* XXX: hash order check? */
> > +	/* Check hash order */
> > +	uint32_t prev_hash = be32_to_cpu(ichdr.btree[0].hashval);
> > +
> > +	for (int i = 1; i < ichdr.count; i++) {
> > +		uint32_t curr_hash = be32_to_cpu(ichdr.btree[i].hashval);
> > +
> > +		if (curr_hash <= prev_hash)
> > +			return __this_address;
> > +		prev_hash = curr_hash;
> > +	}
> 
> Hmmm. Do you have any numbers related to the performance impact of this patch?
> 
> IIRC for very populated directories we can end up having many entries here. It's
> not uncommon to have filesystems with millions of entries in a single directory.
> Now we'll be looping over all those entries here during verification, which could
> scale to many interactions on this loop.
> I'm not sure if I'm right here, but this seems to add a big performance penalty
> for directory writes, so I'm curious about the performance implications of this
> patch.

It's only a single dabtree block, which will likely be warm in cache
due to the crc32c validation.

But if memory serves, one can create a large enough dir (or xattr)
structure such that a dabtree node gets written out with a bunch of
entries with the same hashval.  That was the subject of the correction
made in commit b7b81f336ac02f ("xfs_repair: fix incorrect dabtree
hashval comparison") so I've been wondering if this passes the xfs/599
test?  Or am I just being dumb?

--D

> > 
> >  	return NULL;
> >  }
> > 
> > ---
> > base-commit: ecd5d67ad602c2c12e8709762717112ef0958767
> > change-id: 20250412-xfs-hash-check-be7397881a2c
> > 
> > Best regards,
> > --
> > Charalampos Mitrodimas <charmitro@posteo.net>
> > 
> 
