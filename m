Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014CC30E852
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 11:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769599123; cv=none; b=Wy4LYVwmuLq6a58XUt/GvHgMuYhuAgrb6P1pRw6qx9t+7gvLc9jDv7ls9YaiWJWZqwEpA+Cnv6F8pvL1ZEjpoEDjcIKFxvuG0QhERZNF/XZh566VoxF4QP7KyEzjBZBHm8I9go/S0jJ79zWi+SQe9IqFr/NeePosOsA1us2B5JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769599123; c=relaxed/simple;
	bh=TyHDhdLQBNEFPPk/WYGxJtFH0phybSTLpfHJrfQ6l4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nb+VArBweg5wZSTTIj/ercwKWAIwEG4uTSAm6JqW3FCUeXcKPQBodoQJIOOKPtWR3cWi/iEw+DKPGEeeEn3+IlC1xOsacQJG1dDn6qGZXXJO5X0wf/e7T8YcEnz9eni3d5dZqZrzceTWYpR7jPzjrJ+H9y90M73T9yPIXwTL388=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rjA+K5Bs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rjA+K5Bs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AEA0C19421;
	Wed, 28 Jan 2026 11:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769599122;
	bh=TyHDhdLQBNEFPPk/WYGxJtFH0phybSTLpfHJrfQ6l4A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rjA+K5BscQnvapzCQVkh/tcbgZy2cogH99DVvluv/dUqAkrZhfnsTp/L15qfqTxlR
	 DhjNB2G74p3UZfl0seDYUpmnvKMGh8Fd1gUhWQblVU0wtGT/Dmr7lWlt68s/mYOr6L
	 ycX/04lUErACAaw6hiecnnkByq9hfFvLdNAowGvXbxIk6KZlcfnSbNijVVws2nJ+E2
	 YCTch82s355Mzc2+yikYMIP3x3mVTRmTVYbSr0u3I2S7Q9OloU0DdsiLGKYZMVHbhZ
	 7WWthGz7oqbEGgTpqs50z1q1C3dNXq0NH6HZuBQGI72CpM8yh9I85VUt6bRD1SJgJB
	 Bw+JylhFaZQeg==
Date: Wed, 28 Jan 2026 12:18:38 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Hans Holmberg <hans.holmberg@wdc.com>, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] xfs: move the guts of XFS_ERRORTAG_DELAY out of
 line
Message-ID: <aXnv3tWiFlHwOheE@nidhogg.toxiclabs.cc>
References: <20260127160619.330250-1-hch@lst.de>
 <20260127160619.330250-5-hch@lst.de>
 <20260128013525.GD5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128013525.GD5945@frogsfrogsfrogs>

On Tue, Jan 27, 2026 at 05:35:25PM -0800, Darrick J. Wong wrote:
> On Tue, Jan 27, 2026 at 05:05:44PM +0100, Christoph Hellwig wrote:
> > Mirror what is done for the more common XFS_ERRORTAG_TEST version,
> > and also only look at the error tag value once now that we can
> > easily have a local variable.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_error.c | 21 +++++++++++++++++++++
> >  fs/xfs/xfs_error.h | 15 +++------------
> >  2 files changed, 24 insertions(+), 12 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> > index 52a1d51126e3..a6f160a4d0e9 100644
> > --- a/fs/xfs/xfs_error.c
> > +++ b/fs/xfs/xfs_error.c
> > @@ -144,6 +144,27 @@ xfs_errortag_test(
> >  	return true;
> >  }
> >  
> > +void
> > +xfs_errortag_delay(
> > +	struct xfs_mount	*mp,
> > +	const char		*file,
> > +	int			line,
> > +	unsigned int		error_tag)
> > +{
> > +	unsigned int		delay = mp->m_errortag[error_tag];
> > +
> > +	might_sleep();
> > +
> > +	if (!delay)
> > +		return;
> > +
> > +	xfs_warn_ratelimited(mp,
> > +"Injecting %ums delay at file %s, line %d, on filesystem \"%s\"",
> > +		delay, file, line,
> > +		mp->m_super->s_id);
> 
> Hrm.  This changes the logging ratelimiting from per-injection-site to
> global for the whole kernel.  I'm mostly ok with that since I rarely
> read dmesg, but does anyone else care?

It's a valid concern IMHO, but the default rates are high enough for
this purpose, so I don't see an issue with it.

I'm curious though if is there any reason why those are ratelimited?
It's not like users would be running with error injection enabled or,
they would be flooding the message ring buffer with it.

> 
> If not, then
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> --D
> 
> > +	mdelay(delay);
> > +}
> > +
> >  int
> >  xfs_errortag_add(
> >  	struct xfs_mount	*mp,
> > diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> > index ec22546a8ca8..b40e7c671d2a 100644
> > --- a/fs/xfs/xfs_error.h
> > +++ b/fs/xfs/xfs_error.h
> > @@ -40,19 +40,10 @@ bool xfs_errortag_test(struct xfs_mount *mp, const char *file, int line,
> >  		unsigned int error_tag);
> >  #define XFS_TEST_ERROR(mp, tag)		\
> >  	xfs_errortag_test((mp), __FILE__, __LINE__, (tag))
> > -bool xfs_errortag_enabled(struct xfs_mount *mp, unsigned int tag);
> > +void xfs_errortag_delay(struct xfs_mount *mp, const char *file, int line,
> > +		unsigned int error_tag);
> >  #define XFS_ERRORTAG_DELAY(mp, tag)		\
> > -	do { \
> > -		might_sleep(); \
> > -		if (!mp->m_errortag[tag]) \
> > -			break; \
> > -		xfs_warn_ratelimited((mp), \
> > -"Injecting %ums delay at file %s, line %d, on filesystem \"%s\"", \
> > -				(mp)->m_errortag[(tag)], __FILE__, __LINE__, \
> > -				(mp)->m_super->s_id); \
> > -		mdelay((mp)->m_errortag[(tag)]); \
> > -	} while (0)
> > -
> > +	xfs_errortag_delay((mp), __FILE__, __LINE__, (tag))
> >  int xfs_errortag_add(struct xfs_mount *mp, unsigned int error_tag);
> >  int xfs_errortag_clearall(struct xfs_mount *mp);
> >  #else
> > -- 
> > 2.47.3
> > 
> > 
> 
