Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527B11B950
	for <linux-xfs@vger.kernel.org>; Mon, 24 Jun 2024 18:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719254685; cv=none; b=SVo5RkLoUtCqHXEvodkSxVSr+/mpBPb3oarXzrlvicI74MPxumQ2mGocxieMI9aAcyJsN+qrw9TmWNG8YjXb+f9rExtjKbKW6bhhiNYlq0x9sKuSo2JfcNFvjt+z2dfA/6C0leArvPolE+pR7KA+m25xmWHNS6mKh07x73wyCcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719254685; c=relaxed/simple;
	bh=eNO83OtSo2TieqkZ3DcNKpW+hOO3plcfTuTIhW/yqXA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=esb1HFb2L7v8NuxvT/SRwrgqSeBMZubFoAcmrQ+uaVKzuRDKHot6Ru+b/NrVfF3C6n9OckcoaYdbR41xyNMJbxz/glGnMNM3slP+VEStIvFA6xsWjyPXjSKwSQWL8Uz+/1l5kNeKUKkqCTV5qnIelIEzypUBg8ZLs/WgNgLXETg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tuLPWTri; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tuLPWTri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB31AC2BBFC;
	Mon, 24 Jun 2024 18:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719254684;
	bh=eNO83OtSo2TieqkZ3DcNKpW+hOO3plcfTuTIhW/yqXA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tuLPWTriennzkV3ao7ywjq8h73V9MP1fK3F/d7bQEqMWdSv9BnyVhpokD4QrfDXs5
	 YkAoJYb0AuRdxx/6Yq/x1iOtSba23x9Oo2/Lvv/Um8Cm4MtTjRyRHq7SnSJO+DxL1K
	 I0KbGIbs2/RZ4oFgjbBVuBWqdRMoCZlGGBAyLcVmStYmAbeEL0pkKH1kWMch9S48WV
	 83U8vo/x6z7odQ1z72TkkHm3ZZPUSyzV6xhs7v4WTA4zyxgPRzLSzstEAD67FkGCMP
	 q1MkSE42lOnF/1eY0eJOLiHsS50I1Tu5Rmoo1ZxLZXaTzuJmC+O9lZNl+t1ADlWvjt
	 Bbe1Jm8weZOWg==
Date: Mon, 24 Jun 2024 11:44:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/10] xfs: reclaim speculative preallocations for append
 only files
Message-ID: <20240624184444.GA612460@frogsfrogsfrogs>
References: <20240623053532.857496-1-hch@lst.de>
 <20240623053532.857496-11-hch@lst.de>
 <20240624155443.GN3058325@frogsfrogsfrogs>
 <20240624160735.GA15941@lst.de>
 <20240624170618.GN103057@frogsfrogsfrogs>
 <20240624172253.GA22044@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240624172253.GA22044@lst.de>

On Mon, Jun 24, 2024 at 07:22:53PM +0200, Christoph Hellwig wrote:
> On Mon, Jun 24, 2024 at 10:06:18AM -0700, Darrick J. Wong wrote:
> > On Mon, Jun 24, 2024 at 06:07:35PM +0200, Christoph Hellwig wrote:
> > > On Mon, Jun 24, 2024 at 08:54:43AM -0700, Darrick J. Wong wrote:
> > > > >  
> > > > >  		if (xfs_get_extsz_hint(ip) ||
> > > > > -		    (ip->i_diflags &
> > > > > -		     (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)))
> > > > > +		    (ip->i_diflags & XFS_DIFLAG_PREALLOC))
> > > > 
> > > > The last time you tried to remove XFS_DIFLAG_APPEND from this test, I
> > > > noticed that there's some fstest that "fails" because the bmap output
> > > > for an append-only file now stops at isize instead of maxbytes.  Do you
> > > > see this same regression?
> > > 
> > > No.   What test did you see it with?  Any special mkfs or mount options?
> > 
> > IIRC /think/ it was xfs/009.  No particularly special mkfs/mount
> > options, though my memory of 10 days ago is a bit hazy now. :(
> 
> 009 was the case when I also removed the XFS_DIFLAG_PREALLOC check
> accidentally in the very first version.

Aha!  /me sneezes for the 10,000th time today and says

With the typos fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D
