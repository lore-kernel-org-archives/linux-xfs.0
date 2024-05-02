Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1A2153563
	for <linux-xfs@vger.kernel.org>; Thu,  2 May 2024 14:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714660985; cv=none; b=R5KiFjv7HYaqxk9CMdSBONWC1o56LuypJIv26DrukDDaRhLCYrkB0hAlG/ASxLDbwtZdH67IHtQ/v6zcO2a7Ehr8IdI31a04mJYiSe48R/cEyXSXTDw86KJJZE73OOy63tOwH6pbSHdrXdgDuhnDytJjE4qY5prr1kAYQO+y5OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714660985; c=relaxed/simple;
	bh=Hp5O+lpGSIssA/g+2dsxOmEPKwjoZ7qV1mN2bv7fcis=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UA/jHBHkUuSjQFH08eVqWZJzmDRjBe4XwqPX1zIWDCVaeQ5WvW/a0XqNqqkLqDN8zYATkmigTXtd6o6x7OFZz7bbtv5UuF9P4Am0/kf3hAcurRORS9DRTUDAOPN2+HsNjssBwJeXuZLhZwA5YSW5xFcLApvDTiR0+eHChb1oo10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Op3fH5I3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Op3fH5I3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87934C113CC;
	Thu,  2 May 2024 14:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714660985;
	bh=Hp5O+lpGSIssA/g+2dsxOmEPKwjoZ7qV1mN2bv7fcis=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Op3fH5I3h/IcIkyHhIL739FSJ1LfJ9UlZByJ/xIcBdx2rlVLFAsZ2iFTQYni2/Wv6
	 fvit+rR+CCKwvi5ACBPFLaRvNKedmrtaGE2gaTHudjgfLmaD1Jb4ucEvXJQQoTFdHd
	 oueqk1ZaqWEH/5isoUQxqwVn9oCOXXVhEApZZhZ7b1IVnVbxZtGp6AGTEhYdRs75Dh
	 B1ZvMpXSg+2BPKtu/meluzcKYTjlV96GPRWuuFkizKEPJhcOzxpaT1ViqRSRFoQq+T
	 A1iSjXFlqEYNGpbf7N4OE6dZcxRT7Kqh2+OGCcc0Ube48yDydiDR3HMty278UD0GV6
	 J4jxBEEI/sLOQ==
Date: Thu, 2 May 2024 07:43:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/16] xfs: optimize adding the first 8-byte inode to a
 shortform directory
Message-ID: <20240502144304.GQ360919@frogsfrogsfrogs>
References: <20240430124926.1775355-1-hch@lst.de>
 <20240430124926.1775355-15-hch@lst.de>
 <20240501215056.GD360919@frogsfrogsfrogs>
 <20240502042509.GD26601@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240502042509.GD26601@lst.de>

On Thu, May 02, 2024 at 06:25:09AM +0200, Christoph Hellwig wrote:
> On Wed, May 01, 2024 at 02:50:56PM -0700, Darrick J. Wong wrote:
> > I noticed a few places where we pass offset == 0 here.  That's ok as a
> > null value because the start of a shortform directory is always the
> > header, correct?
> 
> The start of the "physical" layout has the header, but offset is the
> "logic" d_offset offset.  The start of it it reserved for (but not
> actually used by) the "." and ".." entries that will occupy the space
> when converted out of the short form.  Probably also needs a comment.
> 
> > Ok, so this isn't needed anymore because the ino8 conversion now adds
> > the new dirent?
> 
> Yes.
> 
> > > -		xfs_dir2_sf_toino8(args);
> > > +		xfs_dir2_sf_toino8(args, 0);
> > 
> > This is a replace, so we pass 0 here effectively as a null value?
> 
> Exactly.

ok good.

> > > @@ -1250,6 +1275,17 @@ xfs_dir2_sf_toino8(
> > >  				xfs_dir2_sf_get_ino(mp, oldsfp, oldsfep));
> > >  		xfs_dir2_sf_put_ftype(mp, sfep,
> > >  				xfs_dir2_sf_get_ftype(mp, oldsfep));
> > > +
> > > +		/*
> > > +		 * If there is a new entry to add it once we reach the specified
> > > +		 * offset.
> > 
> > It took me a minute of staring at the if test logic to figure out what
> > we're doing here.  If, after, reformatting a directory entry, the next
> > entry is the offset where _pick wants us to place the new dirent, we
> > should jump sfep to the next entry, and then add the new entry.
> > 
> > Is that right?  And we can't simplify the logic to:
> > 
> > 	if (new_offset && new_offset = xfs_dir2_sf_get_offset(sfep))
> 
> == ?

Yes, double-equals, not single-equals.

> > Because _pick might want us to add the entry at the end of the directory
> > but we haven't incremented sfp->count yet, so the loop body will not be
> > executed in that case.
> > 
> > Is it ever the case that the entry get added in the middle of a
> > shortform directory?
> 
> Yes, that is the hard case.  There is no good reason to add it in
> the middle, but we've encoded that the "logical" offset for a
> shortform directly needs to fit into the physical size of a single
> directory block when converted to block format in asserts and verifiers
> and are stuck with it.  Otherwise we could have just always added it
> at the end..

<nod> I think the mechanics of this patch look ok, but this:

		xfs_dir2_sf_toino8(args, 0);

worries me because the reader has to know that zero is never a valid
offset for adding a dirent, vs:

#define XFS_DIR2_DATA_AOFF_NULL	((xfs_dir2_data_aoff_t)0)

		xfs_dir2_sf_toino8(args, XFS_DIR2_DATA_AOFF_NULL);

shouts that we're not trying to add anything.

--D

