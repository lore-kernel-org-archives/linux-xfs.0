Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CF425C80E
	for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 05:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771393349; cv=none; b=YjxfxcCF16x9r5vl+2pEzfxUuT6Z9pSsPZGZjWumpXfSUEI1wY517GL3nKEHqADmQSzr+Sm0u3JXErRDrbJMeUrt5bJmAgVAhvjpqhm7aHjachfm4nNJYVSO5FJWeC5G7HMRDrNHb+ply8Af2sOlBnoJ5LURHEHsVJvzSCA6wTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771393349; c=relaxed/simple;
	bh=zNl+GyMr3dpNYB7T4AdhpCv41P4JjBi4OVJUq2MtHqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qiXZUqpfp9dT8MKDau5Fn1OLgPfIvWQecTGfY9KytsMmox8e4QpW4V/wxtFvhh+eZAJFB6154xTF4CdMq1bUrpAyA4BM/q3kpBXLAdDCCGuHO+atPLBjyrCvMnH1eCAEVXAT9ipU8iSPbl9vWiJMGmbFMoVTdwAluY2T1nNMD7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=d/IocdZo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="d/IocdZo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=f1GTXHbJGIkYijt0tNY4p46Eb2akpk8rY64MKZoR5AQ=; b=d/IocdZoc9r24QjXPxT1qkfdd9
	fFwTSI8DmHXhbO7ATVATv4a71wH+o4DxFd+bc8VxsrROM5ja10X5AiKVa/PBDK0No+XNvc09sa3fO
	GDOstBl4bfDTMxOiRqrrpBQxaTaJ2YEfazGYCWL7hN5RBa39aEOn4v0VVqXJoBSx4XjcNHcxIVVpR
	/aN4wtuy4d++sO9fZn7bqz9zcU7wMusuDmBdEoiXPxlMb6/CFR7mbXhrbVmNALsKD4YKSe0L2xqcK
	JzSZpumhbAPaRLsmXd+5Zn0zBgopmO3FNvjOUAoMksgEpchIJDygbzJLE/NXPhrhZCsmgqxlolDxg
	x4HFHVcQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsaKR-00000009KXF-0yzP;
	Wed, 18 Feb 2026 05:42:27 +0000
Date: Tue, 17 Feb 2026 21:42:27 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Lukas Herbolt <lukas@herbolt.com>, djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v8 REBASE] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code
 base
Message-ID: <aZVRQ9ahHI-cL_iz@infradead.org>
References: <20260212131302.132709-3-lukas@herbolt.com>
 <aZRjL9KElwju605a@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZRjL9KElwju605a@nidhogg.toxiclabs.cc>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 17, 2026 at 02:19:16PM +0100, Carlos Maiolino wrote:
> On Thu, Feb 12, 2026 at 02:13:04PM +0100, Lukas Herbolt wrote:
> > Add support for FALLOC_FL_WRITE_ZEROES if the underlying device enable
> > the unmap write zeroes operation.
> > 
> > Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> > ---
> > v8 changes:
> > 	rebase to v6.19
> > 	add early check for not supported cases
> > 
> >  fs/xfs/xfs_bmap_util.c | 10 ++++++++--
> >  fs/xfs/xfs_bmap_util.h |  2 +-
> >  fs/xfs/xfs_file.c      | 39 ++++++++++++++++++++++++++-------------
> >  3 files changed, 35 insertions(+), 16 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index 2208a720ec3f..942d35743b82 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -642,11 +642,17 @@ xfs_free_eofblocks(
> >  	return error;
> >  }
> >  
> > +/*
> > + * Callers can specify bmapi_flags, if XFS_BMAPI_ZERO is used there are no
> 
> "Callers can specify bmapi_flags" is unneeded here IMHO, the function
> definition already states that.

They in fact have to specify the value :)

> 
> > + * further checks whether the hard ware supports and it can fallback to
> > + * software zeroing.
> 
> This sounds weird to me, but I'm not native English speaker. Also, I
> don't think this comment belongs here, xfs_alloc_file_space() ignores
> bmapi_flags, it just pass it along...

Yeah.  I think we can just drop it.

> > +	if (mode & FALLOC_FL_WRITE_ZEROES) {
> 
> 	... The comment probably belongs here and it can be short like
> 	(based on the same comment from Ext4):
> 
> 	  /*
> 	   * Do not allow writing zeroes if the hardware does not
> 	   * support it
> 	   */
> 
> The rest of the patch looks fine to me, although Christoph likely will
> also need to take a look on it because xfs_falloc_force_zero() behavior.

I'll reply directly if I find anything.

