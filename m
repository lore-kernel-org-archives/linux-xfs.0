Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2B33B960B
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 16:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782921823; cv=none; b=Vu07iAiiLZ3g1jdp8p9cU9JpEMLFlqzuH035+OVEN8vhk6qWZstbaHdBNZFRP/LeVmw34DTmTBubj2+3UVBOfQQ/4glPI3MXzRrWW0qTYUagXBxQoacd2H8oBH8Kj9kG/JkrCT0GmqaG2/Xe2P+en0b2rxDu/dMKs0DJiLKtK9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782921823; c=relaxed/simple;
	bh=6lwBYNMjIL1LFXbL03/NkmKnF/07K0LhBoPyzsDyXKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R6qlU8alnxddZ2qtDlzmr0fwGVP/ZnonR/+bRDGi2+iQYYLp9mNWFI1S4E4yP3AH5GymsvxcXwWFX67gl7kiRJZ3QUXN/lYB3CQ6VbpbgS62hzVzfp0PqPqDGc2iJEET46n6ufU4MUyxnEvWxk4BtND+3hqZa52pQje7JPvls0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I4bUVPIf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I4bUVPIf"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 194051F000E9;
	Wed,  1 Jul 2026 16:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782921822;
	bh=mqSNDbKgCjZKnlEYX8cMAiP9Ji949u3mE+4w4+qNN0U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I4bUVPIft+bkiw78CVxUDWzRkmt2aTJ7HV3iW5y+YDMOgX8OZb+HMuR0fd4tMH5lL
	 ZlIuLsreO/N848j3ovqdDZuLwAZL6rHPj81oJWHhSGeRWOHivf49TExWvTnbzE/Ndg
	 HL4v2XV7K0AK9soLto4ukyDziPtWofVXmY0OQP2XOdGHkLbOJwEQYQtoucnL9hsD7j
	 wOcjCuZ8jp9rCvEm5x56VBwHnHijrJDmyUrbW5uj6do7kyDbTuNQ852raBUnLsobsu
	 PaMfbEXTVDIXeVKxMdPTFVBT9dQBhRxIleQfk/B9XaMI7zphnDLH2afNUSMLYVx5or
	 YZXDdQbXXURxA==
Date: Wed, 1 Jul 2026 09:03:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: lift setting __GFP_NOFAIL from
 xfs_buf_alloc_kmem to the caller
Message-ID: <20260701160341.GC6544@frogsfrogsfrogs>
References: <20260617055814.3842058-1-hch@lst.de>
 <20260617055814.3842058-3-hch@lst.de>
 <20260630005254.GH6078@frogsfrogsfrogs>
 <akTeZYyMbJNNDSxF@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akTeZYyMbJNNDSxF@nidhogg.toxiclabs.cc>

On Wed, Jul 01, 2026 at 11:31:27AM +0200, Carlos Maiolino wrote:
> On Mon, Jun 29, 2026 at 05:52:54PM -0700, Darrick J. Wong wrote:
> > On Wed, Jun 17, 2026 at 07:58:03AM +0200, Christoph Hellwig wrote:
> > > The current __GFP_NOFAIL setting is wrong in some cases.  Prepare
> > > for fixing that by giving control to the caller.
> > 
> > Simple enough...
> 
> /me interprets it as a RwB

Yeah.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> 
> > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >  fs/xfs/xfs_buf.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > index d3d44e3ff001..dce398337ad0 100644
> > > --- a/fs/xfs/xfs_buf.c
> > > +++ b/fs/xfs/xfs_buf.c
> > > @@ -145,7 +145,7 @@ xfs_buf_alloc_kmem(
> > >  	ASSERT(is_power_of_2(size));
> > >  	ASSERT(size < PAGE_SIZE);
> > >  
> > > -	bp->b_addr = kmalloc(size, gfp_mask | __GFP_NOFAIL);
> > > +	bp->b_addr = kmalloc(size, gfp_mask);
> > >  	if (!bp->b_addr)
> > >  		return -ENOMEM;
> > >  
> > > @@ -230,7 +230,7 @@ xfs_buf_alloc_backing_mem(
> > >  	 * smaller than PAGE_SIZE buffers used by XFS.
> > >  	 */
> > >  	if (size < PAGE_SIZE && is_power_of_2(size))
> > > -		return xfs_buf_alloc_kmem(bp, size, gfp_mask);
> > > +		return xfs_buf_alloc_kmem(bp, size, gfp_mask | __GFP_NOFAIL);
> > >  
> > >  	/*
> > >  	 * Don't bother with the retry loop for single PAGE allocations: vmalloc
> > > -- 
> > > 2.53.0
> > > 
> > > 
> > 
