Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304C43290D8
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jun 2026 06:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782454908; cv=none; b=er7sQh1nouWKLkYbbojrrZ9gc1B1xoYjTf1s2KmisnfiXl0FJUf3Vh+q8CXZKkZbaHETQQpP7ys7Va473fPZQW/llF4jrS4Mlzr047hegAXyQ1QdG7VAs2t3r9rLTwJSoutyr6QEIzl1w6rNj4W1kn+OpKMYbgi6CXEDoe5UTLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782454908; c=relaxed/simple;
	bh=idfEKvv1wddV5SqHId71X+ObwWl9zGc84+CEf5XgZOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nJyQI0KN0OuWgA3cnls2VN1Sto6tFn/3pj7F/M9TkOg7xNQoJQDOPaJCofSA+qUysJ88onL+6oG1xSxesl1MkzpxxmvJdlRDfMFpcTrFH5JWgDSu8UWpMdjQg14V+KnaLcOtz70jvSvGuR12Mfw9i+H6737tItiVDlTqnj1SAWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ek304mQQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ek304mQQ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B3B071F000E9;
	Fri, 26 Jun 2026 06:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782454906;
	bh=lTdGogKwh7SAoeCQTbpI/1NpjO+0zkRrr8czjEB4PrY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ek304mQQSED2f5JLt0owJTcnckHf4O3pemNUlkN/HTbsWbDrbUWc/AzVR5gmXdPj+
	 aVLurHhocORmwf+/o9qaT4VsUr1R4A/xSFhe5SZT+W5G8hfNC/afgu4fJOwsl4ksLj
	 PzyYuispm96ciU5nNdY+Dk7DLQv8mo1zZh0SHZrjy8bvAkkMplGYRGX6skSDiGnnqt
	 v255YJDWWio/mCCxXAuOBxV87a+ml2C4tyYJ/6WOayyNhZhUXGmbcBGRcoS7q7LzES
	 VmSKm+IATfB2pNlQ26KjRKTK8u1S67tkUp+Qf2/Yzj8OdY6prI/MpAhEVpAyFLo9fU
	 Igcq0niVso2PQ==
Date: Thu, 25 Jun 2026 23:21:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/6] xfs: also mark the buffer stale on verifier failure
 in xfs_buf_submit
Message-ID: <20260626062146.GP6078@frogsfrogsfrogs>
References: <20260625135849.2494779-1-hch@lst.de>
 <20260625135849.2494779-3-hch@lst.de>
 <20260625180002.GG6078@frogsfrogsfrogs>
 <20260626043516.GD8078@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626043516.GD8078@lst.de>

On Fri, Jun 26, 2026 at 06:35:16AM +0200, Christoph Hellwig wrote:
> On Thu, Jun 25, 2026 at 11:00:02AM -0700, Darrick J. Wong wrote:
> > > -	if (bp->b_mount->m_log && xlog_is_shutdown(bp->b_mount->m_log))
> > > +	if (bp->b_mount->m_log && xlog_is_shutdown(bp->b_mount->m_log)) {
> > > +		xfs_buf_ioerror(bp, -EIO);
> > >  		goto ioerror;
> > 
> > IDGI.  If the filesystem was already shut down, we set EIO on the
> > buffer, stale it, and complete the ioend...
> > 
> > > +	}
> > >  
> > >  	if (bp->b_flags & XBF_WRITE)
> > >  		xfs_buf_wait_unpin(bp);
> > > @@ -1397,7 +1399,7 @@ xfs_buf_submit(
> > >  
> > >  	if ((bp->b_flags & XBF_WRITE) && !xfs_buf_verify_write(bp)) {
> > >  		xfs_force_shutdown(bp->b_mount, SHUTDOWN_CORRUPT_INCORE);
> > > -		goto end_io;
> > > +		goto ioerror;
> > 
> > ...but if bp itself causes the shutdown, we now leave b_error at 0, but
> > do the same stale-and-complete thing?  Shouldn't we set EIO on the
> > buffer in both cases?
> 
> ->verify_write is expected to set b_error when it fails (and yes,
> the API in that area is awful).

Would you mind leaving a comment here, then?

	if ((bp->b_flags & XBF_WRITE) && !xfs_buf_verify_write(bp)) {
		/* ->verify_write should have set b_error already */
		xfs_force_shutdown(...);
		goto out_ioerror;
	}

--D
