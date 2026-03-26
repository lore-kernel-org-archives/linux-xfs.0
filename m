Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB0037CD41
	for <linux-xfs@vger.kernel.org>; Thu, 26 Mar 2026 14:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774536889; cv=none; b=PL2uC5MWNI2iPxN4AL7C9V9tKNC9ndScXDvkUquTaPV/gu7dsAJQz82sEquvaCPkzg9G8vQSMaW6kKuc/zvtHvBmvGut8Tk7TQZoeqy4UANhxvmbtvE6nQ/Ck0nROB2DzLZztpP2hnkpjzEQ8KxWNPAWLpnm7MZlidfK9NkbD2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774536889; c=relaxed/simple;
	bh=3oHK4Rps5wYqlYXw9EBCHac7j4detccsgjGnbv4TL7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nCM119HUdbyifJr7caPddoRZuAEZ3bVmfPbS3OXvldxm1gWblELtldTsynSQpRTHh77K0FWu9QLFI/egQRUMzksktjYJa0iQ5zbY6+0VrnWXkKjaqGTwbyEyXI/wnqsn9LyJkCIZK54rR+LX9vkVkAxeEt1YlWjKqjCm1fBgiEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aXWzuV3X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aXWzuV3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5000BC116C6;
	Thu, 26 Mar 2026 14:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774536889;
	bh=3oHK4Rps5wYqlYXw9EBCHac7j4detccsgjGnbv4TL7k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aXWzuV3XyAcNWPyUQspyA+n3Nyb4f1xvKSNKP9tktHi76wncIX8XS+D5Fh0BJz5TM
	 kqPruRpZmDcRD5E0Vv6oTmonBSS+K0GxctXJW1sqckWSTUPI02rvFp0LsJBKFl/5G7
	 OgV4X4LUMUKeKDfAHPqODJgYe6pRRoce1uJRSaMrH2Se2DpVrXQxMZEHogwfAkqU7r
	 STV1b6JHAPTW8Hy4A+yTrovhg3QBwFylMZEpaMQgM6rb9jxFKu/a8VvdAIQshGD58l
	 YrMeEMVjqOhReFtOy0Kd+vLVNKW2kHoJozw8jtWPMQnaa2MjOhVIpp8VJZ1cZUY35N
	 NahPJZX79Mv0Q==
Date: Thu, 26 Mar 2026 07:54:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Long Li <leo.lilong@huawei.com>, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/3] xfs: don't expose stale pointers to callers of
 xlog_recover_iget
Message-ID: <20260326145448.GA6223@frogsfrogsfrogs>
References: <20260323210157.GM6223@frogsfrogsfrogs>
 <20260323210351.GN6223@frogsfrogsfrogs>
 <acUrniYmDuw6k71m@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acUrniYmDuw6k71m@nidhogg.toxiclabs.cc>

On Thu, Mar 26, 2026 at 02:04:19PM +0100, Carlos Maiolino wrote:
> On Mon, Mar 23, 2026 at 02:03:51PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Fix this function to avoid exposing a stale pointer to the caller when
> > returning an error code after dqattach fails.
> > 
> > Cc: <stable@vger.kernel.org> # v5.15
> > Fixes: 4bc619833f738f ("xfs: refactor xfs_iget calls from log intent recovery")
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Long Li <leo.lilong@huawei.com>
> > ---
> 
> Hi.
> 
> 
> >  fs/xfs/xfs_log_recover.c |   12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 09e6678ca4878e..0e91a62348eb79 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -1745,21 +1745,23 @@ xlog_recover_iget(
> >  	xfs_ino_t		ino,
> >  	struct xfs_inode	**ipp)
> >  {
> > +	struct xfs_inode	*ip;
> >  	int			error;
> >  
> > -	error = xfs_iget(mp, NULL, ino, 0, 0, ipp);
> > +	error = xfs_iget(mp, NULL, ino, 0, 0, &ip);
> >  	if (error)
> >  		return error;
> >  
> > -	error = xfs_qm_dqattach(*ipp);
> > +	error = xfs_qm_dqattach(ip);
> >  	if (error) {
> > -		xfs_irele(*ipp);
> > +		xfs_irele(ip);
> >  		return error;
> >  	}
> >  
> > -	if (VFS_I(*ipp)->i_nlink == 0)
> > -		xfs_iflags_set(*ipp, XFS_IRECOVERY);
> > +	if (VFS_I(ip)->i_nlink == 0)
> > +		xfs_iflags_set(ip, XFS_IRECOVERY);
> >  
> > +	*ipp = ip;
> >  	return 0;
> 
> Honestly I tend to agree with Christoph here. I don't really understand
> what bug, real or theoretical, this is trying to fix, other than
> somebody not aborting whatever operation is being done if an error
> is returned.
> 
> I don't see any issue with an extra inode pointer being passed on the
> stack here, but I don't see any benefit for this either.
> 
> Did you fall into this somehow? Have you seen this into the wild? I'll
> pull the other patches meanwhile, but I think this one deserves more
> discussion.

Yeah, look who wrote the function and the bad error handling.  You could
say that the *author* didn't understand his own function's outparam
conventions and wants to prevent himself or anyone else from making
further mistakes.  ;)

--D
