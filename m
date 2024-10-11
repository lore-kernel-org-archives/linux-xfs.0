Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1C85381E;
	Fri, 11 Oct 2024 16:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728662906; cv=none; b=kLKUqla9wXRMGdAmRHez9RgwpjMRW1mMqpNFuRQO0KLKzct9W6DoowJcAtjp1bTdQ0RYq3evOtcuhi6yG4T23Z8dGPSMJoRlQYrvxzfeYnZNCz0f8vpuPiFW1D0s4Bi21mY+RJ5ekEBfZ8Cejx6XdjxUzr/zOM+HI2JXj0a3IlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728662906; c=relaxed/simple;
	bh=DaA+kF/qkoahcN36NNm0XC+rEL+tEz7AaVnGruu9pDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JIiVo+O8rnnKAh5uXczEbmgJaqYRfEovDVEgXrF4D+qj8U9OJ7luP/4c64iwnESuMygtC3/44RC6KX6qDS7SCUZg+dQyv5+fbcxnRrspq+UFwXWrA/eTx7rreM5vcqpVmfnYNCXFsKmGujqDAlqo2066boSDJFa4YrJvEzkC0YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U8X9rL1M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U8X9rL1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EFF9C4CEC3;
	Fri, 11 Oct 2024 16:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728662906;
	bh=DaA+kF/qkoahcN36NNm0XC+rEL+tEz7AaVnGruu9pDA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U8X9rL1M8azo8mA3HQadBvyrojMFOm5epVJI2sBBVVkhniKG7rhR77P8bAsNoJ/Al
	 +w4A5A/n5YVGBORyudq2GJjx/BEsKAu/aG+84zNbflhUENpImDvCVLJbIM+vsKlVKL
	 0djzJHbdxmgp5Kvskjn28f/dPWfX8gi71KU1OA9LgZoYFoI8j4n0qnRksBUCVhuBXE
	 HZU2ALWY5WvAhwlclsoX9g31iDpK3vqsrJOSvF8lbWMo2bhKh8U8dv2J2CfatrwJFD
	 Ms3OvwoyeDNA8m9XBGV4hKqE+flOXrQpQAE2/vNNP1RScO0iGizZYTzqHm9EsANQ3E
	 7hpgdzrfz6dfw==
Date: Fri, 11 Oct 2024 09:08:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] fsstress: add support for FALLOC_FL_UNSHARE_RANGE
Message-ID: <20241011160825.GN21840@frogsfrogsfrogs>
References: <172780126017.3586479.18209378224774919872.stgit@frogsfrogsfrogs>
 <20241003213714.GH21840@frogsfrogsfrogs>
 <20241011051356.mjaoarskwedmjs75@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241011052133.vrq3nzic5fpjkzvr@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241011052133.vrq3nzic5fpjkzvr@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Fri, Oct 11, 2024 at 01:21:33PM +0800, Zorro Lang wrote:
> On Fri, Oct 11, 2024 at 01:13:56PM +0800, Zorro Lang wrote:
> > On Thu, Oct 03, 2024 at 02:37:14PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Teach fsstress to try to unshare file blocks on filesystems, seeing how
> > > the recent addition to fsx has uncovered a lot of bugs.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > 
> > Thanks for this new test coverage on fsstress. Although it's conflict with
> > current for-next branch, I've merged it manually, don't need one more
> > version :)
> > 
> > Reviewed-by: Zorro Lang <zlang@redhat.com>
> 
> And...
> 
> I'm not sure why this patch is contained in this patchset:
> [PATCHSET v31.1 2/2] fstests: atomic file content commits

I hit reply-all to get the same to/cc list and forgot to strip out the
in-reply-to header. :(

> As that patchset still need change, I'll merge this patch singly this week.

Thanks. :)

--D

> Thanks,
> Zorro
> 
> > 
> > >  ltp/fsstress.c |   14 ++++++++++++++
> > >  1 file changed, 14 insertions(+)
> > > 
> > > diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> > > index b8d025d3a0..8cd45c7a85 100644
> > > --- a/ltp/fsstress.c
> > > +++ b/ltp/fsstress.c
> > > @@ -139,6 +139,7 @@ typedef enum {
> > >  	OP_TRUNCATE,
> > >  	OP_UNLINK,
> > >  	OP_UNRESVSP,
> > > +	OP_UNSHARE,
> > >  	OP_URING_READ,
> > >  	OP_URING_WRITE,
> > >  	OP_WRITE,
> > > @@ -246,6 +247,7 @@ void	punch_f(opnum_t, long);
> > >  void	zero_f(opnum_t, long);
> > >  void	collapse_f(opnum_t, long);
> > >  void	insert_f(opnum_t, long);
> > > +void	unshare_f(opnum_t, long);
> > >  void	read_f(opnum_t, long);
> > >  void	readlink_f(opnum_t, long);
> > >  void	readv_f(opnum_t, long);
> > > @@ -339,6 +341,7 @@ struct opdesc	ops[OP_LAST]	= {
> > >  	[OP_TRUNCATE]	   = {"truncate",      truncate_f,	2, 1 },
> > >  	[OP_UNLINK]	   = {"unlink",	       unlink_f,	1, 1 },
> > >  	[OP_UNRESVSP]	   = {"unresvsp",      unresvsp_f,	1, 1 },
> > > +	[OP_UNSHARE]	   = {"unshare",       unshare_f,	1, 1 },
> > >  	[OP_URING_READ]	   = {"uring_read",    uring_read_f,	-1, 0 },
> > >  	[OP_URING_WRITE]   = {"uring_write",   uring_write_f,	-1, 1 },
> > >  	[OP_WRITE]	   = {"write",	       write_f,		4, 1 },
> > > @@ -3767,6 +3770,7 @@ struct print_flags falloc_flags [] = {
> > >  	{ FALLOC_FL_COLLAPSE_RANGE, "COLLAPSE_RANGE"},
> > >  	{ FALLOC_FL_ZERO_RANGE, "ZERO_RANGE"},
> > >  	{ FALLOC_FL_INSERT_RANGE, "INSERT_RANGE"},
> > > +	{ FALLOC_FL_UNSHARE_RANGE, "UNSHARE_RANGE"},
> > >  	{ -1, NULL}
> > >  };
> > >  
> > > @@ -4469,6 +4473,16 @@ insert_f(opnum_t opno, long r)
> > >  #endif
> > >  }
> > >  
> > > +void
> > > +unshare_f(opnum_t opno, long r)
> > > +{
> > > +#ifdef HAVE_LINUX_FALLOC_H
> > > +# ifdef FALLOC_FL_UNSHARE_RANGE
> > > +	do_fallocate(opno, r, FALLOC_FL_UNSHARE_RANGE);
> > > +# endif
> > > +#endif
> > > +}
> > > +
> > >  void
> > >  read_f(opnum_t opno, long r)
> > >  {
> > > 
> 
> 
