Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CAA81BBBFD
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 17:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734109759; cv=none; b=NBm1UKQhluCDFYawo/oxGphVLWA/ERyro2u5XYysU9FoqbuNcZ8Bno2HfEk8OQiz2ZcP40W2o8qa089k4L3ccvleUeduPr99gRcbTzuw1Uk6dxRnk/yMDISlWYDSP6OkA6EsNFJ44s7F4fnRoN+RnnZz0VuiLuppdF5lQkEO19w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734109759; c=relaxed/simple;
	bh=ONtotZujc3csqlqrgaad9JVqI9Nro7CJsIFFhzVTnUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WFScjIwBIo8GTVb7W1qXO470mTEMPSzIHZctJEQuuJVo1pwDISeJYvkOkl4za7PnL2okIcicZHX1vCT5HDWvZ6RlcHVB1II7rbvHHk/GX+8qvXp1TOwwzZ8KJpsm7+Go8kW1wGMCSEy+xYCNbDqP+kL4KPgvJOoaWZ6ujYSRNlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fD3gK2u6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fD3gK2u6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84259C4CED0;
	Fri, 13 Dec 2024 17:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734109758;
	bh=ONtotZujc3csqlqrgaad9JVqI9Nro7CJsIFFhzVTnUc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fD3gK2u6CVLlbP9+kf9QLp1zIGE9zYG4jxDlZdH3MvaNiMIAbHQolK6ixzoZ+j9k4
	 2YaYd36EfCc7AczUWxoJJq79n/7yt8yd4xsyP8hQqg1kC+Q70KxrkBofGttgoa9Z4z
	 EtN6osaXRD/6KT5c8ua1+eA9KqGGx2GFH5T8buotGboTs7i7Xeh48x6jFeiPFKJcUv
	 IeaTZ9GMidulTlIDOl7iFDwOfYisB6d30swayVQYWTtm35LqQyf84E9XNrzfG8ia+V
	 x2oN6MoKc1ZQz4Pvl8CoZhAA6RzUSDHLI7DJN0TFmYnr6b59XhNRgznzeWqQI5L+yD
	 B9wTlId7UDJgA==
Date: Fri, 13 Dec 2024 09:09:17 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/43] xfs: define the zoned on-disk format
Message-ID: <20241213170917.GK6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-16-hch@lst.de>
 <20241212220220.GA6653@frogsfrogsfrogs>
 <20241213052210.GK5630@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241213052210.GK5630@lst.de>

On Fri, Dec 13, 2024 at 06:22:10AM +0100, Christoph Hellwig wrote:
> On Thu, Dec 12, 2024 at 02:02:20PM -0800, Darrick J. Wong wrote:
> > On Wed, Dec 11, 2024 at 09:54:40AM +0100, Christoph Hellwig wrote:
> > > Zone file systems reuse the basic RT group enabled XFS file system
> > > structure to support a mode where each RT group is always written from
> > > start to end and then reset for reuse (after moving out any remaining
> > > data).  There are few minor but important changes, which are indicated
> > > by a new incompat flag:
> > > 
> > > 1) there are no bitmap and summary inodes, and thus the sb_rbmblocks
> > >    superblock field must be cleared to zero
> > 
> > zoned rt requires rt rmap and reflink, and hence metadir.  There is no
> > such field as sb_rbmblocks anymore.
> 
> I doesn't actually require reflink - in fact it currently is incompatible
> with reflink due to GC not understanding refcounts (it does depend on
> your reflink code as it's reusing a few bits from that just to make it
> confusing).
> 
> And sb_rbmblocks is actually still set for metadir file systems.

Oops, I misread that as sb_rbmino.  Yes, sb_rbmblocks must be zero now.

> > > 4) an overlay of the cowextsizse field for the rtrmap inode so that we
> > 
> >                        cowextsize
> > 
> > >    can persistently track the total amount of bytes currently used in
> > 
> > Isn't this the total number of *fsblocks* currently used?
> 
> or rtblocks? :)  But yes, it's not byte granularity obviously, no idea
> why I wrote that.
> 
> > Heh, I guess I should go down to my lab and plug in this smr disk and
> > see how many zones it reports...
> 
> It will be capacity in bytes / 256MB unless you found a really, really
> weird beast.

I bet someone will get tempted to make bigger zones for their 120TB hard
disk.

> > > -	fa = xfs_inode_validate_cowextsize(mp, be32_to_cpu(dip->di_cowextsize),
> > > -			mode, flags, flags2);
> > > -	if (fa)
> > > -		return fa;
> > > +	if (!xfs_has_zoned(mp) ||
> > > +	    dip->di_metatype != cpu_to_be16(XFS_METAFILE_RTRMAP)) {
> > > +		/* COW extent size hint validation */
> > > +		fa = xfs_inode_validate_cowextsize(mp,
> > > +				be32_to_cpu(dip->di_cowextsize),
> > > +				mode, flags, flags2);
> > 
> > I think there's *some* validation you could do, such as checking that
> > i_cowextsize <= the number of blocks in the rtgroup.
> 
> So we do a fair amount of validation in xfs_zone_validate based on the
> hardware zone state.  I tried to add more here but it failed because
> we getting at the rtgroups wasn't easily possible.  But yes, I think
> a simple rgsize check should be possible at least.
> 
> > I almost wonder if you should add that kind of logic to
> > xfs_inode_validate_cowextsize but that might be one incoherence too
> > many.  OTOH it would probably reduce the number of changes in the fsck
> > code.
> 
> I'll take a look, but having a cowextsize helper that validated a field
> overlay with an entirely different meaning sounds a bit confusing.

Yeah, like I said, it might be one incoherence too far. :)

--D
