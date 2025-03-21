Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98251514F6
	for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 20:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742589555; cv=none; b=Z8PcnGsDnOhMO7U7J7EYag3PQDvMfAZVPNJx9DUgSslGR+AsOSWOWaSNytJQYKtNK9/HwFXc5jAlOKIqQB40hNmI31bh39MeZdChcBRaIhL5RbTu2bwXhuAFQyx1NGllp451PLMED1bYacPeTRoya57hF7+dE3q6GYIKdhClquQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742589555; c=relaxed/simple;
	bh=h2BS+oKUo5xyuuAY4i4TQtV8AltNutjex9oN4hNbxpA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HLmP4KR5gfFaZ+SLXcoIJU4qthrEfOd52miZDwX51zQxQe/eiXAmvfQkJaBWCHQFLmPONAm/lY4o4q5+dH1g8cGwJMh8ARf9QgYdtg+PK6u5r1mXTgefK35RaflfqiRGsvmv49D8r0qRqgWY6tfEXeSGzdqOKDGyonnYZpwm3o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=coQ15H/I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="coQ15H/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED1EC4CEE3;
	Fri, 21 Mar 2025 20:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742589555;
	bh=h2BS+oKUo5xyuuAY4i4TQtV8AltNutjex9oN4hNbxpA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=coQ15H/I9qgezGrZqqBtaP2x0gt+rycfbsRTjIFGDuh69rrU61nFuHQj2vne3T7P8
	 VSh02gw3G5r7IaF/FNnO00pXhcydjxDkOj6ivzXS/Yig6xq8Wm/rQNlz6zJQPPzlfF
	 7eT9yLhtXHczywAevHoVJny/b0YXXT9serSNPu+4j7NEHIyZvIw25+KH+iy05hzGdT
	 sTBME2YAx72viCuGfG3MEYzNSEBU7eF2RYfWblHXHnCzjNwGke6iE8yqx9hQSimDfD
	 IWdfyPQlBLScbkvv0HG5KM3uzm8xHfas1mHoNBdKG7DE1FdZY7PQl/FHuZ0UcBAXcR
	 y6QOPZs62AR4Q==
Date: Fri, 21 Mar 2025 13:39:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Bill O'Donnell <bodonnel@redhat.com>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net, hch@infradead.org
Subject: Re: [PATCH v2] xfs_repair: handling a block with bad crc, bad uuid,
 and bad magic number needs fixing
Message-ID: <20250321203914.GA89034@frogsfrogsfrogs>
References: <20250321142848.676719-2-bodonnel@redhat.com>
 <20250321152725.GL2803749@frogsfrogsfrogs>
 <Z93N12zwQeg6Fuot@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z93N12zwQeg6Fuot@redhat.com>

On Fri, Mar 21, 2025 at 03:36:39PM -0500, Bill O'Donnell wrote:
> On Fri, Mar 21, 2025 at 08:27:25AM -0700, Darrick J. Wong wrote:
> > On Fri, Mar 21, 2025 at 09:28:49AM -0500, bodonnel@redhat.com wrote:
> > > From: Bill O'Donnell <bodonnel@redhat.com>
> > > 
> > > In certain cases, if a block is so messed up that crc, uuid and magic
> > > number are all bad, we need to not only detect in phase3 but fix it
> > > properly in phase6. In the current code, the mechanism doesn't work
> > > in that it only pays attention to one of the parameters.
> > > 
> > > Note: in this case, the nlink inode link count drops to 1, but
> > > re-running xfs_repair fixes it back to 2. This is a side effect that
> > > should probably be handled in update_inode_nlinks() with separate patch.
> > > Regardless, running xfs_repair twice fixes the issue. Also, this patch
> > > fixes the issue with v5, but not v4 xfs.
> > > 
> > > Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
> > 
> > That makes sense.
> > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> > 
> > Bonus question: does longform_dir2_check_leaf need a similar correction
> > for:
> > 
> > 	if (leafhdr.magic == XFS_DIR3_LEAF1_MAGIC) {
> > 		error = check_da3_header(mp, bp, ip->i_ino);
> > 		if (error) {
> > 			libxfs_buf_relse(bp);
> > 			return error;
> > 		}
> > 	}
> > --D
> > 
> 
> I believe so, yes. Basing the v4/v5 decisions on an assumed correct
> magic number is not so good. I'll fix it in a new version or separate
> patch if preferred.

It's up to you, but since this fix has already earned its review, how
about a separate patch? :)

--D

> Thanks-
> Bill
> 
> 
> > > 
> > > v2: remove superfluous wantmagic logic
> > > 
> > > ---
> > >  repair/phase6.c | 5 +----
> > >  1 file changed, 1 insertion(+), 4 deletions(-)
> > > 
> > > diff --git a/repair/phase6.c b/repair/phase6.c
> > > index 4064a84b2450..9cffbb1f4510 100644
> > > --- a/repair/phase6.c
> > > +++ b/repair/phase6.c
> > > @@ -2364,7 +2364,6 @@ longform_dir2_entry_check(
> > >  	     da_bno = (xfs_dablk_t)next_da_bno) {
> > >  		const struct xfs_buf_ops *ops;
> > >  		int			 error;
> > > -		struct xfs_dir2_data_hdr *d;
> > >  
> > >  		next_da_bno = da_bno + mp->m_dir_geo->fsbcount - 1;
> > >  		if (bmap_next_offset(ip, &next_da_bno)) {
> > > @@ -2404,9 +2403,7 @@ longform_dir2_entry_check(
> > >  		}
> > >  
> > >  		/* check v5 metadata */
> > > -		d = bp->b_addr;
> > > -		if (be32_to_cpu(d->magic) == XFS_DIR3_BLOCK_MAGIC ||
> > > -		    be32_to_cpu(d->magic) == XFS_DIR3_DATA_MAGIC) {
> > > +		if (xfs_has_crc(mp)) {
> > >  			error = check_dir3_header(mp, bp, ino);
> > >  			if (error) {
> > >  				fixit++;
> > > -- 
> > > 2.48.1
> > > 
> > > 
> > 
> 
