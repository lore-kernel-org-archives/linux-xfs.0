Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75E8199E9A
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 22:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724796982; cv=none; b=l3eEY4UutDS34Cub1fDyx9T5vmeHAwX9inUZIpMonlYCYvbnVKVeDVQHvZmrZ0DEoPzq5R3X9Ym/OQbunoef4dRtS95gCnPCtLa4Ch2cMj0Ndw8vPgLKWr9X5r6quC8b1VJuZOedS6ry0v2dFHYFGVd7ZRA8N0OUp0Dj5Op6GVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724796982; c=relaxed/simple;
	bh=SfX1tHs9gKNTAUS5zkETPyeEV/wSRiVBskVK9mqzuXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vFnLPRyvzPO+qgXIpXrX2fOcWGcAS6HoJd4CKrNebpvosOG4AqrinW5b6E2T4VeM7d4zRiA0Qqvh+eqboul2NJw7AD2Ga65mKgbRW9U7b6FYoD3oM8wy+0xHv2NhV6+8Qu1UzuL14L98S5C7q9JoP1uUmo78qped9qtZIJ/JB5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=WCSCQCTW; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="WCSCQCTW"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-715cdc7a153so13192b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 15:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724796980; x=1725401780; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KD4STHuugc9R+D1ZsmEF8y6GHrYFcOh7XfwKRaBYaHg=;
        b=WCSCQCTWskFV5yuU+IguylF72cDQhkQ5jMHzVoXPv5MvcxiKH2xvmpxqxvj2K5GX8A
         hUAFJTCEk/DR0xICUGtqW5R06syvgME2M3vIkK0cgdFePgfUM/NOIxl0X/LZilUeVTyy
         lm+Cf0o+XalaDkuUhN8UqCxXRbGCDpnpMa4JEOu5Ibw2/l9lrqP0HSbB4NJscociuzVo
         1ae8BbrDieQh1AKqRWVFoEbmdiOscx5l6UOTkkOpB9OrASr0WqEui6sBFsNuv4k4qirm
         8QH4dP45+k2IifxNqZY6a0cW89zMKWJjgdWCCSkQDZZ0jOeUGf2ZswaS06Qs5OXMZ7RL
         AZjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724796980; x=1725401780;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KD4STHuugc9R+D1ZsmEF8y6GHrYFcOh7XfwKRaBYaHg=;
        b=xRhzc2WJ95qyi19eNn6a1/Qqel0DJ10nqkUxOtWlukUsBSZYDV7FAUDTiWSPEI9Uyy
         wJUKrdYzO0WxjUT4eT+GrP4tXQjB+mhMiiKE6dKel9bZdLDAli/Q1yytbr/bHZLWnjS8
         DA6rCujaHTu9A4EtiWw9v34jY0H5RaBmPtWkG4YUj9RnRk3IgvPYfcqBtNSUngGzKYFF
         qn31odLITcYbzg5crHURRcXBnCZ6tcxz/fQOEum1WXERH60jvkBPQmGLo0qtN2CxV2OG
         m+tuV+UYwMqQb5w+Pd0ccIey7aWJ/T+DGyq0uxhksZfIhFzR0MYwa1YV3U09Ju/GCuUw
         skHQ==
X-Forwarded-Encrypted: i=1; AJvYcCWrOj46mWgYfJWasHx/Qp0Ypnpv913/J4I4CreYd5xCovms0nTQvvjy7B8rkFFmtjkrHpAhvsYU6u8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1UxGOzQQ7J5WKOJx8UMEWXl+LsfvbsJe0DdELH4/lyiXbytYZ
	DyzafGteeArKn0cipjH/YV8uMO1nQz/+xx2Rx+mltGFQIQ6FKI+KGXMZG79iTmTyVQAJUPB1Q17
	C
X-Google-Smtp-Source: AGHT+IFyMAnCXFF7mKKDaua2lx+U982ri/l81iG0QwILQhmzYxo2HmYO7fQGo7XQKuqDQfQB0Ya+lQ==
X-Received: by 2002:a05:6a00:2e85:b0:70e:cee8:264a with SMTP id d2e1a72fcca58-715d108b08bmr351737b3a.1.1724796979860;
        Tue, 27 Aug 2024 15:16:19 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-65.pa.nsw.optusnet.com.au. [49.179.0.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-714342e0a61sm9026394b3a.134.2024.08.27.15.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 15:16:19 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sj4U4-00F1s2-1m;
	Wed, 28 Aug 2024 08:16:16 +1000
Date: Wed, 28 Aug 2024 08:16:16 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/24] xfs: factor out a xfs_growfs_check_rtgeom helper
Message-ID: <Zs5QMMfv2JQfjhCl@dread.disaster.area>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087611.59588.7898768503459548119.stgit@frogsfrogsfrogs>
 <ZsvjQiGQS6WD/rwB@dread.disaster.area>
 <20240826182734.GA865349@frogsfrogsfrogs>
 <Zs0sBGeYgiiKxk4o@dread.disaster.area>
 <20240827042724.GI865349@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240827042724.GI865349@frogsfrogsfrogs>

On Mon, Aug 26, 2024 at 09:27:24PM -0700, Darrick J. Wong wrote:
> On Tue, Aug 27, 2024 at 11:29:40AM +1000, Dave Chinner wrote:
> > On Mon, Aug 26, 2024 at 11:27:34AM -0700, Darrick J. Wong wrote:
> > > On Mon, Aug 26, 2024 at 12:06:58PM +1000, Dave Chinner wrote:
> > > > On Thu, Aug 22, 2024 at 05:20:07PM -0700, Darrick J. Wong wrote:
> > > > > From: Christoph Hellwig <hch@lst.de>
> > > > > 
> > > > > Split the check that the rtsummary fits into the log into a separate
> > > > > helper, and use xfs_growfs_rt_alloc_fake_mount to calculate the new RT
> > > > > geometry.
> > > > > 
> > > > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > > > [djwong: avoid division for the 0-rtx growfs check]
> > > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > > ---
> > > > >  fs/xfs/xfs_rtalloc.c |   43 +++++++++++++++++++++++++++++--------------
> > > > >  1 file changed, 29 insertions(+), 14 deletions(-)
> > > > > 
> > > > > 
> > > > > diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> > > > > index 61231b1dc4b79..78a3879ad6193 100644
> > > > > --- a/fs/xfs/xfs_rtalloc.c
> > > > > +++ b/fs/xfs/xfs_rtalloc.c
> > > > > @@ -1023,6 +1023,31 @@ xfs_growfs_rtg(
> > > > >  	return error;
> > > > >  }
> > > > >  
> > > > > +static int
> > > > > +xfs_growfs_check_rtgeom(
> > > > > +	const struct xfs_mount	*mp,
> > > > > +	xfs_rfsblock_t		rblocks,
> > > > > +	xfs_extlen_t		rextsize)
> > > > > +{
> > > > > +	struct xfs_mount	*nmp;
> > > > > +	int			error = 0;
> > > > > +
> > > > > +	nmp = xfs_growfs_rt_alloc_fake_mount(mp, rblocks, rextsize);
> > > > > +	if (!nmp)
> > > > > +		return -ENOMEM;
> > > > > +
> > > > > +	/*
> > > > > +	 * New summary size can't be more than half the size of the log.  This
> > > > > +	 * prevents us from getting a log overflow, since we'll log basically
> > > > > +	 * the whole summary file at once.
> > > > > +	 */
> > > > > +	if (nmp->m_rsumblocks > (mp->m_sb.sb_logblocks >> 1))
> > > > > +		error = -EINVAL;
> > > > 
> > > > FWIW, the new size needs to be smaller than that, because the "half
> > > > the log size" must to include all the log metadata needed to
> > > > encapsulate that object. The grwofs transaction also logs inodes and
> > > > the superblock, so that also takes away from the maximum size of
> > > > the summary file....
> > > 
> > > <shrug> It's the same logic as what's there now, and there haven't been
> > > any bug reports, have there? 
> > 
> > No, none that I know of - it was just an observation that the code
> > doesn't actually guarantee what the comment says it should do.
> > 
> > > Though I suppose that's just a reduction
> > > of what?  One block for the rtbitmap, and (conservatively) two inodes
> > > and a superblock?
> > 
> > The rtbitmap update might touch a lot more than one block. The newly
> > allocated space in the rtbitmap inode is initialised to zeros, and
> > so the xfs_rtfree_range() call from the growfs code to mark the new
> > space free has to write all 1s to that range of the rtbitmap. This
> > is all done in a single transaction, so we might actually be logging
> > a *lot* of rtbitmap buffers here.
> > 
> > IIRC, there is a bit per rtextent, so in a 4kB buffer we can mark
> > 32768 rtextents free. If they are 4kB each, then that's 128MB of
> > space tracked per rtbitmap block. This adds up to roughly 3.5MB of
> > log space for the rtbitmap updates per TB of grown rtdev space....
> > 
> > So, yeah, I think that calculation and comment is inaccurate, but we
> > don't have to fix this right now.
> 
> The kernel only "frees" the new space one rbmblock at a time, so I think
> that's why this calculation has never misfired.

not quite. It iterates all the rbmblocks in the given range (i.e.
the entire extent being freed) in xfs_rtmodify_range() in
a single transaction, but...

> I /think/ that means
> that each transaction only ends up logging two rtsummary blocks at a
> time?  One to decrement a counter, and again to increment one another
> level up?

... we only do one update of the summary blocks per extent being
freed (i.e. in xfs_rtfree_range() after the call to
xfs_rtmodify_range()). So, yes, we should only end up logging two
rtsummary blocks per extent being freed, but the number of rbmblocks
logged in that same transaction is O(extent length).

-Dave.
-- 
Dave Chinner
david@fromorbit.com
