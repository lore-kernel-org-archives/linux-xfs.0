Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3291FBEB0
	for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 12:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758629561; cv=none; b=nmvs4JWNVBbh7/LTPrcs+MU5r3X9b6JfJQkds8XcjREDd2Q9poX6lxRhL9Q7XHT/Xysrt7f54GED59k+Mue/GqNcZ2+k/msXrZATyMsqSEswRZUePe4OV/ucAdvCHtF7/2+ecxJ9LPnXa5znWWlSjIyCSgfMWCYkVLyspYDSvSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758629561; c=relaxed/simple;
	bh=xVwqy7tzdppyYudKwWwY8CbMnrW6Kz9Ww1j+69zz3fo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VIdgeYskWc6sgIt5g2pLUqcUb1ss1aK+4wyP5cLlr6ogR8KCVOtv4KxMU+9tZo1X0MKtqVv7Qj93R6rWSHxjfaAz6NzCGHVhyUYO5aueK4guTlEIr61dWFMJnUICiZ5DhgjfRXEpe8GkYb+wUVtIF+Zsuuk7v7MwGk/i3En6jE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nhTjd+Kn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nhTjd+Kn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D4BC4CEF5;
	Tue, 23 Sep 2025 12:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758629560;
	bh=xVwqy7tzdppyYudKwWwY8CbMnrW6Kz9Ww1j+69zz3fo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nhTjd+KnfY1agCuAU6zXT4OEmnMiSbZCFNk9j/je+cs072P7W5lzbJjLErgp/YdWm
	 oeOw5k5U1dEsoy48v7CRHbeRPQYJ0VYELIFLXHW/h87JAzCnEyWq6mMr+8QBGhR6G0
	 phJgrMxUqMwoyJ6/Ywka8GM+GPNQavWAd7C4o5Btdrkn9GWdDGXdrErIrEvQ4yo9FD
	 69vLMtzYBUlyeuEQ0z4haGOE0PmGXrg/208lTRw/csEli/XGuEW/Mn7Z+UL2FmHRJF
	 LS3ly2QHSW1raJ2Q6kEjMkg37ITONo2D+FtGVuK8qnPdDz3QrFtckU9lwN7+0pa1Gl
	 wRDSL6T+VQNpg==
Date: Tue, 23 Sep 2025 14:12:36 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, 
	jack@suse.cz, lherbolt@redhat.com
Subject: Re: [PATCH 2/2] xfs: rework datasync tracking and execution
Message-ID: <bt2p5jg3nhacmubtqkasfpofsqb36mqk4zujalkalhgwd63zlx@nb2secnp22ga>
References: <20250917222446.1329304-1-david@fromorbit.com>
 <20250917222446.1329304-3-david@fromorbit.com>
 <k1en9q0LLyltfADnuFHJpWNk9VvoVUpBZmyU-ijV5IUIaTBe7nEcss6BudsNtQERfGkCeigdpjcUVU8uQr7Dww==@protonmail.internalid>
 <aM13H6P-lMYjR-9k@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aM13H6P-lMYjR-9k@infradead.org>

On Fri, Sep 19, 2025 at 08:30:39AM -0700, Christoph Hellwig wrote:
> On Thu, Sep 18, 2025 at 08:12:54AM +1000, Dave Chinner wrote:
> > Jan demostrated that reducing the ifdatasync lock hold time can
> 
> s/demostrated/demonstrated/
> 
> > came to the conclusion that seperately tracking datasync flush
> 
> s/seperately/separately/
> 
> > seqeunces was the best approach to solving the problem.
> 
> s/seqeunces/sequences/g
> 
> > operations are allo done under ILOCK_EXCL context:
> 
> s/allo/all/

I'll update those at commit time.


> 
> >  xfs_fsync_flush_log(
> >  	struct xfs_inode	*ip,
> >  	bool			datasync,
> >  	int			*log_flushed)
> >  {
> > +	struct xfs_inode_log_item *iip = ip->i_itemp;
> > +	xfs_csn_t		seq = 0;
> >
> > +	spin_lock(&iip->ili_lock);
> > +	if (datasync)
> > +		seq = iip->ili_datasync_seq;
> > +	else
> > +		seq = iip->ili_commit_seq;
> > +	spin_unlock(&iip->ili_lock);
> 
> If we care about the additional speedup of the READ_ONCE done
> in Jan's patch we could make that configurable on CONFIG_64BIT
> here.  There's precedence for that in i_size_read for that in the
> VFS.  If we have a helper like:
> 
> static inline bool
> xfs_inode_sync_csn(
> 	struct xfs_inode	*ip,
>  	bool			datasync,
> 	xfs_csn_t		*seq)
>  {
> 	struct xfs_inode_log_item *iip = ip->i_itemp;
> 
> 	if (!iip)
> 		return false;
> 
> 	spin_lock(&iip->ili_lock);
> 	if (datasync)
> 		*seq = iip->ili_datasync_seq;
> 	else
> 		*seq = iip->ili_commit_seq;
> 	spin_unlock(&iip->ili_lock);
> 	return true;
> }
> 
> we could isolate that to one single place as well.
> 

Yeah, an isolated patch with that would be better.

> But even without that, the patch looks fine:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
