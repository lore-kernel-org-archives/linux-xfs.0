Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644524C83
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 01:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724722186; cv=none; b=h7WVMB9+67cCke6/IyrcfMHh799yA3RHfUf9JW60CQHt7Jk2AnjnQTdYlMkwK8HdyWC2oS6ur7yjbq4Aqu1SGakK7hYePuUshrbn1iifMRPqM8ugBm+KuduNyEl8zOWXrIt+lfn7FXvz0vLX6XWfAtFz8jGWzzfyjzi7CMAbnfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724722186; c=relaxed/simple;
	bh=DcinMszPgcPb1z6ijB3ytomN8iLG0XRfNzHlF9tNJAA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FkZTq+eb+JqqyFzmsYo3fIPj+N3bRcHHiMUbYLCFa4hJDinarQ9xVt3h2DPd6F8VDjA5bn/b+AKgLdXmzDiAxBVJGkc2Wigtca0OI6NR2aakYH1HZkpGRK2bVPBXG8C6UGmcrTs8tOrJeg7bu9A9bmzOw1ODO7qVg5mMsRxKYAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=zJQrzT8g; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="zJQrzT8g"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1fec34f94abso48895635ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 18:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724722184; x=1725326984; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=052qOUC3MWV4p9zp/MFFbExy4ZnQnJ2gv9XkJob2jlc=;
        b=zJQrzT8gHMx4m9qutXqqwU72ERZT4WK41CBVobBs7rUx8bgpL7qBStmY06CavNsl41
         sVNb0xN6R3oRS5SYaplOembfPwDByhsYZ0vNGumMQV+RrJoGSFS26ImO5cTgO2zQgOUQ
         gAzebgcLDH3hmXf4H38jxzBYGbzStZH561eRna7JTOKiIGqyo9VRJpBkR15PiQwuUBuU
         sUTovL9qz7It0j9VhsI2hC1oaOL6/ij7/bL8LsHU5AhmfsqpJ10jUoNnhcA4Tt7yFc9a
         y5N4NpD7v3PmnvFvTt8h4pmXOJ5UkT4fbM3PLR6VI0VdiqVYyVmq8LvSZU9ONAO+bZo/
         qZMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724722184; x=1725326984;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=052qOUC3MWV4p9zp/MFFbExy4ZnQnJ2gv9XkJob2jlc=;
        b=hecLzhW8KYZOtabAUUN4oL8AtHPEWYbGJiFQYcpzEKwz0PQGSf218uMcs8wZ2ss/z7
         2wCHcZ/t2Cj4muo1sURYRXI5PWrJkrnStpH87pcTK/0kJMOxD2LhECwU/maJ9VwlDAqF
         rLK8h+63Nck6vc8E+bb7FWO2Wsg28mnO8Xp2G0eqWEkxCoZTAfZ8fiG7XLVN3qInFufr
         haLkSWZb7w8sB7Lqf6ttFDPTm0wWsXq2zgMlDBJG0abjJISyWs5TprZeEDb31fCt5PFf
         ijPux6fi20fquVr42WMFZJyovBiTT89+UCa83cHitLPEwp5H3SOaO9uT0HVL6lgRFqFM
         6Qdw==
X-Forwarded-Encrypted: i=1; AJvYcCXzpT8oCxzHWvQKny/9KIsOVDU5fceq2/fcM2WAAX7AmbXGVvfWi706Uaplv10t6tOVZcdcONIncWg=@vger.kernel.org
X-Gm-Message-State: AOJu0YykOMuSefINtFGQpxLx4CIsO57R00Hz3DeXgrtICSqrgHW8myzb
	0UN8RkwoEh+eeUuXwDRXQxRflPDPt3GsiDH1IW+lLV6ss/ao4lw1jjUtrz3Ddc8=
X-Google-Smtp-Source: AGHT+IHm2qveADu2QdS943NR8XkK6bGhXm3v0/Wg9n98geaOI0178Esdv7Ku5uHiej8nxuOT9LlpQg==
X-Received: by 2002:a17:902:ecca:b0:1fa:7e0:d69a with SMTP id d9443c01a7336-2039e4ef0d7mr109814175ad.46.1724722183568;
        Mon, 26 Aug 2024 18:29:43 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20385564dd9sm72795795ad.51.2024.08.26.18.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 18:29:43 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sil1g-00E0Cb-1O;
	Tue, 27 Aug 2024 11:29:40 +1000
Date: Tue, 27 Aug 2024 11:29:40 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/24] xfs: factor out a xfs_growfs_check_rtgeom helper
Message-ID: <Zs0sBGeYgiiKxk4o@dread.disaster.area>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087611.59588.7898768503459548119.stgit@frogsfrogsfrogs>
 <ZsvjQiGQS6WD/rwB@dread.disaster.area>
 <20240826182734.GA865349@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240826182734.GA865349@frogsfrogsfrogs>

On Mon, Aug 26, 2024 at 11:27:34AM -0700, Darrick J. Wong wrote:
> On Mon, Aug 26, 2024 at 12:06:58PM +1000, Dave Chinner wrote:
> > On Thu, Aug 22, 2024 at 05:20:07PM -0700, Darrick J. Wong wrote:
> > > From: Christoph Hellwig <hch@lst.de>
> > > 
> > > Split the check that the rtsummary fits into the log into a separate
> > > helper, and use xfs_growfs_rt_alloc_fake_mount to calculate the new RT
> > > geometry.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > [djwong: avoid division for the 0-rtx growfs check]
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  fs/xfs/xfs_rtalloc.c |   43 +++++++++++++++++++++++++++++--------------
> > >  1 file changed, 29 insertions(+), 14 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> > > index 61231b1dc4b79..78a3879ad6193 100644
> > > --- a/fs/xfs/xfs_rtalloc.c
> > > +++ b/fs/xfs/xfs_rtalloc.c
> > > @@ -1023,6 +1023,31 @@ xfs_growfs_rtg(
> > >  	return error;
> > >  }
> > >  
> > > +static int
> > > +xfs_growfs_check_rtgeom(
> > > +	const struct xfs_mount	*mp,
> > > +	xfs_rfsblock_t		rblocks,
> > > +	xfs_extlen_t		rextsize)
> > > +{
> > > +	struct xfs_mount	*nmp;
> > > +	int			error = 0;
> > > +
> > > +	nmp = xfs_growfs_rt_alloc_fake_mount(mp, rblocks, rextsize);
> > > +	if (!nmp)
> > > +		return -ENOMEM;
> > > +
> > > +	/*
> > > +	 * New summary size can't be more than half the size of the log.  This
> > > +	 * prevents us from getting a log overflow, since we'll log basically
> > > +	 * the whole summary file at once.
> > > +	 */
> > > +	if (nmp->m_rsumblocks > (mp->m_sb.sb_logblocks >> 1))
> > > +		error = -EINVAL;
> > 
> > FWIW, the new size needs to be smaller than that, because the "half
> > the log size" must to include all the log metadata needed to
> > encapsulate that object. The grwofs transaction also logs inodes and
> > the superblock, so that also takes away from the maximum size of
> > the summary file....
> 
> <shrug> It's the same logic as what's there now, and there haven't been
> any bug reports, have there? 

No, none that I know of - it was just an observation that the code
doesn't actually guarantee what the comment says it should do.

> Though I suppose that's just a reduction
> of what?  One block for the rtbitmap, and (conservatively) two inodes
> and a superblock?

The rtbitmap update might touch a lot more than one block. The newly
allocated space in the rtbitmap inode is initialised to zeros, and
so the xfs_rtfree_range() call from the growfs code to mark the new
space free has to write all 1s to that range of the rtbitmap. This
is all done in a single transaction, so we might actually be logging
a *lot* of rtbitmap buffers here.

IIRC, there is a bit per rtextent, so in a 4kB buffer we can mark
32768 rtextents free. If they are 4kB each, then that's 128MB of
space tracked per rtbitmap block. This adds up to roughly 3.5MB of
log space for the rtbitmap updates per TB of grown rtdev space....

So, yeah, I think that calculation and comment is inaccurate, but we
don't have to fix this right now.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
