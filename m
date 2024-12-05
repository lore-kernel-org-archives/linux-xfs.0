Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABC212CDA5;
	Thu,  5 Dec 2024 05:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733378092; cv=none; b=mYTuMatGRNMz7Xr8tjv67Se4uhRt/ErJholgMT2NodhAH4N70kTLGkBmwURh1X671Iaxym+xm27CYrnZ3y+O1JT1l95Ek9tm7FaGDuFFF0QwrmyOuiqnaNi+spaBurNDLvS4LNEPP4KHsoCwqwIIeA/1PxPhb4Vf1ODkmlcBXkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733378092; c=relaxed/simple;
	bh=awsrD5lZrOpBiId8y0sw8lb/MY4D6bVSNEpUNmXOi7A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ExaAQSO0xyTY/gFi2B0wA97JCi8tGDZp2nSVtCJZ4wA4jV8aigYnZIsEhsxie6E7IPzB4+ZlvPCWCGhbhk5O/bhs5RrSvaWwBI9+/K1IQOufvjuzxsh0Ik86vTWSb1QBSgTlw8zgz+J4wKm2F+vdwxDXQXDTLOLIpUzx2xt/YZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uKfWco+D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uKfWco+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82E9C4CED1;
	Thu,  5 Dec 2024 05:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733378092;
	bh=awsrD5lZrOpBiId8y0sw8lb/MY4D6bVSNEpUNmXOi7A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uKfWco+DEggnjMJ21yilTE4jDyMowdwyHJUEL+535e28eUC4OsYkjtINeAYyFb7Xd
	 9v66xG6tjrGqWAJfXKwjWn5PO/ERMIQ1ErE+peTSagxB9oxq1lKGj64NgNsmFcTt3r
	 fSes8ilfpBAZi5ejqfHRNw5MxfMkd6IdUqfEo4NKaZaBuHI/veUGzcGG1fGeyLxfzB
	 dh/hInU+wvioRCmVPIpnokb54csbfwlRx4M+yen2HrU4XnLJi5tbI/2t9TGm0fnrd3
	 XXNovUlKSw/kpp8eVS33nkILRoUQji3a88OsYx0FqutIl6/p0n5uHDWG706UUkDNMm
	 wMA6EgKvYzNeA==
Date: Wed, 4 Dec 2024 21:54:51 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 4/6] xfs: fix zero byte checking in the superblock
 scrubber
Message-ID: <20241205055451.GB7837@frogsfrogsfrogs>
References: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
 <173328106652.1145623.7325198732846866757.stgit@frogsfrogsfrogs>
 <Z1ASehwdTewFiwZE@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1ASehwdTewFiwZE@infradead.org>

On Wed, Dec 04, 2024 at 12:27:38AM -0800, Christoph Hellwig wrote:
> On Tue, Dec 03, 2024 at 07:03:16PM -0800, Darrick J. Wong wrote:
> > +/* Calculate the ondisk superblock size in bytes */
> > +STATIC size_t
> > +xchk_superblock_ondisk_size(
> > +	struct xfs_mount	*mp)
> > +{
> > +	if (xfs_has_metadir(mp))
> > +		return offsetofend(struct xfs_dsb, sb_pad);
> > +	if (xfs_has_metauuid(mp))
> > +		return offsetofend(struct xfs_dsb, sb_meta_uuid);
> > +	if (xfs_has_crc(mp))
> > +		return offsetofend(struct xfs_dsb, sb_lsn);
> > +	if (xfs_sb_version_hasmorebits(&mp->m_sb))
> > +		return offsetofend(struct xfs_dsb, sb_bad_features2);
> > +	if (xfs_has_logv2(mp))
> > +		return offsetofend(struct xfs_dsb, sb_logsunit);
> > +	if (xfs_has_sector(mp))
> > +		return offsetofend(struct xfs_dsb, sb_logsectsize);
> > +	/* only support dirv2 or more recent */
> > +	return offsetofend(struct xfs_dsb, sb_dirblklog);
> 
> This really should be libxfs so tht it can be shared with
> secondary_sb_whack in xfsrepair.  The comment at the end of
> the xfs_dsb definition should also be changed to point to this
> libxfs version.

The xfs_repair version of this is subtlely different -- given a
secondary ondisk superblock, it figures out the size of the ondisk
superblock given the features set *in that alleged superblock*.  From
there it validates the secondary superblock.  The featureset in the
alleged superblock doesn't even have to match the primary super, but
it'll go zero things all the same before copying the incore super back
to disk:

	if (xfs_sb_version_hasmetadir(sb))
		size = offsetofend(struct xfs_dsb, sb_pad);
	else if (xfs_sb_version_hasmetauuid(sb))
		size = offsetofend(struct xfs_dsb, sb_meta_uuid);

This version in online computes the size of the secondary ondisk
superblock object given the features set in the *primary* superblock
that we used to mount the filesystem.

Also if I did that we'd have to recopy the xfs_sb_version_hasXXXX
functions back into libxfs after ripping most of them out.  Or we'd have
to encode the logic manually.  But even then, the xfs_repair and
xfs_scrub functions are /not quite/ switching on the same thing.

> > +}
> >  	/* Everything else must be zero. */
> > -	if (memchr_inv(sb + 1, 0,
> > -			BBTOB(bp->b_length) - sizeof(struct xfs_dsb)))
> > +	sblen = xchk_superblock_ondisk_size(mp);
> > +	if (memchr_inv((char *)sb + sblen, 0, BBTOB(bp->b_length) - sblen))
> 
> This could be simplified to
> 
> 	if (memchr_inv(bp->b_addr + sblen, 0, BBTOB(bp->b_length) - sblen))

<nod>

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
