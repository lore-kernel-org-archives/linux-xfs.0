Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC5B420883;
	Tue,  7 Jul 2026 09:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783416380; cv=none; b=CZwoZrFzKu/KphC4drisDBliQFaH084fjmQxeHNs+6OkkC3PB5RmmdEsvZwOntyn2QWQt63/A9SJn0CwG8g9iFW/CDfuYukZ77FCJ8nDoo286XYk4Q8ZTS6MX0ByNryI6COFJ88ljrt21N0NP++iIKt99F/npnzvkeHz8/e3AVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783416380; c=relaxed/simple;
	bh=8reDIogVVWi2ZVnm3om1KLSkVBPsmba6RSht5PYm0hg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JvxWbIaMR9LDswwdqJfLjxA8ZwoFcKlgiyGwzitW4Nps8fZIKg22E9QZZh2DhICJF8fZxX2PakoBJhTVrqJqO0Hzp5lyttVnr9PZwLwitsqFKySvjYVDJ9ZaNvospcF6fi6GiOveLTXqO3RgR7M9bRiW02tJeEwgqFurSslViHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XfYUNtHW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XfYUNtHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4B7E1F000E9;
	Tue,  7 Jul 2026 09:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783416379;
	bh=Yg1oXe/zfY/l8Ubuj1pFgyd7SjYhWd1Kyb8nkhYD5VQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XfYUNtHWznoDIGkzHk4iKn11rU9dVRaE8k4cwpgLP8ZPr3G2BvaTna+JeJsVH5nTa
	 bdesD5Pi5Nga+0AxX6DVZXamAf7nnhobkxZOh1kN8r1hmuB3XS+Mqq9FZtmbIejfGr
	 aX6ptCS5C9eRQXx9tZAOn7mP9vL6BJzfo4k5N7SiRcyAA/YXS68263ZO/D2maP3Xps
	 nI2iSh9nvPfy5bYSVQoeV4AUun/JYDPhdMLcjyVEX+VCTtgIJ1glF/y7Gsr41j1NBt
	 NLVEYZ3h0w4R5C8eSmTYeqajpHgXDpJusqZ8+vUBS2rlm/PsfiuG4Ea6di+jx7jFhG
	 79CQkBmJcQBBg==
Date: Tue, 7 Jul 2026 11:26:14 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Dave Chinner <david@fromorbit.com>, 
	Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/5] xfs: replace ns_capable_noaudit
Message-ID: <akzGE4bi-f3O7JmS@nidhogg.toxiclabs.cc>
References: <20260702093324.127450-1-cem@kernel.org>
 <20260702093324.127450-9-cem@kernel.org>
 <20260702155856.GF9392@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702155856.GF9392@frogsfrogsfrogs>

On Thu, Jul 02, 2026 at 08:58:56AM -0700, Darrick J. Wong wrote:
> On Thu, Jul 02, 2026 at 11:33:23AM +0200, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> > 
> > Now that capable_noaudit() is available, we don't need to keep
> > using ns_capable_noaudit() and specifying the usernaspace every single
> > time.
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Serge E. Hallyn <serge@hallyn.com>
> > Cc: Darrick J. Wong <djwong@kernel.org>
> > Cc: Dave Chinner <david@fromorbit.com>
> > Cc: Eric Sandeen <sandeen@redhat.com>
> > Cc: Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
> > Cc: linux-xfs@vger.kernel.org
> > Cc: linux-fsdevel@vger.kernel.org
> > Cc: linux-security-module@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  fs/xfs/xfs_fsmap.c | 3 +--
> >  fs/xfs/xfs_ioctl.c | 2 +-
> >  fs/xfs/xfs_iops.c  | 2 +-
> >  3 files changed, 3 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> > index 7c79fbe0a74c..041bb2105ec6 100644
> > --- a/fs/xfs/xfs_fsmap.c
> > +++ b/fs/xfs/xfs_fsmap.c
> > @@ -1174,8 +1174,7 @@ xfs_getfsmap(
> >  	if (!xfs_getfsmap_check_keys(&head->fmh_keys[0], &head->fmh_keys[1]))
> >  		return -EINVAL;
> >  
> > -	use_rmap = xfs_has_rmapbt(mp) &&
> > -		   ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN);
> > +	use_rmap = xfs_has_rmapbt(mp) && capable_noaudit(CAP_SYS_ADMIN);
> >  	head->fmh_entries = 0;
> >  
> >  	/* Set up our device handlers. */
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 1a8af827dde1..374b488f0416 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -647,7 +647,7 @@ xfs_ioctl_setattr_get_trans(
> >  		goto out_error;
> >  
> >  	error = xfs_trans_alloc_ichange(ip, NULL, NULL, pdqp,
> > -			ns_capable_noaudit(&init_user_ns, CAP_FOWNER), &tp);
> > +					capable_noaudit(CAP_FOWNER), &tp);
> 
> Not sure why the indentation changed, otherwise the patch looks fine to
> me.

Purely my screw up. I fixed it already to send to the next version. Was
just waiting for more comments

> 
> --D
> 
> >  	if (error)
> >  		goto out_error;
> >  
> > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > index 205fe2dae732..ce9f8b8468fc 100644
> > --- a/fs/xfs/xfs_iops.c
> > +++ b/fs/xfs/xfs_iops.c
> > @@ -835,7 +835,7 @@ xfs_setattr_nonsize(
> >  	}
> >  
> >  	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
> > -					ns_capable_noaudit(&init_user_ns, CAP_FOWNER),
> > +					capable_noaudit(CAP_FOWNER),
> >  					&tp);
> >  	if (error)
> >  		goto out_dqrele;
> > -- 
> > 2.54.0
> > 
> > 
> 
