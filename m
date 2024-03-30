Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260938BE7
	for <linux-xfs@vger.kernel.org>; Sat, 30 Mar 2024 06:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711778414; cv=none; b=mdj/ZJcW3nNOxuSYm4EHZbMhiUlyGb7doSVWVjjbUO79+3DFDwOuQSuUbJMoGPRjG+8gw9/GMMJeFzyFdHABS97J/ScsWqaE/H6HyXJ0e1b0UNc/IvNjptDb/DTJ/G3S5g/Due9lKOO29wH4qC05d4j8uzVUrIjdScapwIK8Tw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711778414; c=relaxed/simple;
	bh=9R/d56SH+jfO2W4bKmdLwHwteKH8/m9qR6u8kxHITyI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V+GEMG2FVtxloKYFByWNzT2janlNZZRk32ZbgeZlmsFgcti6NovSqZcKgAi25EZFUuC44Au/qqv9ihD+TN69GEwVKvpZsvO8dY29NVittMYBPhMavQOz/1YIRZgNildfav/mmtZpUlJSPxOdgCa17/xd0Eozdb3A89qiPWJjDeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0E6C868B05; Sat, 30 Mar 2024 07:00:10 +0100 (CET)
Date: Sat, 30 Mar 2024 07:00:09 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: optimize extent remapping in
 xfs_reflink_end_cow_extent
Message-ID: <20240330060009.GD24680@lst.de>
References: <20240328070256.2918605-1-hch@lst.de> <20240328070256.2918605-6-hch@lst.de> <20240329162936.GI6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240329162936.GI6390@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Mar 29, 2024 at 09:29:36AM -0700, Darrick J. Wong wrote:
> On Thu, Mar 28, 2024 at 08:02:55AM +0100, Christoph Hellwig wrote:
> > xfs_reflink_end_cow_extent currently caps the range it works on to
> > fit both the existing extent (or hole) in the data fork and the
> > new COW range.  For overwrites of fragmented regions that is highly
> > inefficient, as we need to split the new region at every boundary,
> > just for it to be merge back in the next pass.
> > 
> > Switch to unmapping the old data using a chain of deferred bmap
> > and extent free ops ops first, and then handle remapping the new
> > data in one single transaction instead.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_reflink.c | 98 +++++++++++++++++++++++++-------------------
> >  1 file changed, 56 insertions(+), 42 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index 3c35cd3b2dec5d..a7ee868d79bf02 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -701,6 +701,52 @@ xfs_reflink_cancel_cow_range(
> >  	return error;
> >  }
> >  
> > +/*
> > + * Unmap any old data covering the COW target.
> > + */
> > +static void
> > +xfs_reflink_unmap_old_data(
> > +	struct xfs_trans	*tp,
> > +	struct xfs_inode	*ip,
> > +	xfs_fileoff_t		offset_fsb,
> > +	xfs_fileoff_t		end_fsb)
> > +{
> > +	struct xfs_ifork	*ifp = &ip->i_df;
> > +	struct xfs_bmbt_irec	got, del;
> > +	struct xfs_iext_cursor	icur;
> > +
> > +	ASSERT(!xfs_need_iread_extents(ifp));
> > +
> > +	if (!xfs_iext_lookup_extent_before(ip, ifp, &end_fsb, &icur, &got))
> > +		return;
> > +
> > +	while (got.br_startoff + got.br_blockcount > offset_fsb) {
> 
> How many bmap and refcount log intent items can we attach to a single
> transaction?  It's roughly t_log_res / (32 + 32) though iirc in repair
> I simply picked an upper limit of 128 extent mappings before I'd go back
> for a fresh transaction.

Ah, I didn't even think of a limit, but the log reservation obiously
caps it.  I'll look into simply reusing and documenting the repair
limit.

