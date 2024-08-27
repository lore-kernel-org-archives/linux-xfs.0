Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E195C4C83
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 03:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724727655; cv=none; b=eO8qG19lv7Mliu3oEhl+cP8ymrNE1oTX6LfVdibBJTxambMoMLKe8tQXJ+R/9LHs83QpV3/en7Ag7Ih7DRUjdmzIIoiXRXmnbEFCPInpVyrwNiZ+Hsxf9GK2nGRFHi2evksAmzJ6M91VDWZwAoq4fVhoMJ7fSFC4ZHBfqbi8U08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724727655; c=relaxed/simple;
	bh=srD7kfxwLbp1gGJ71WmMsdnCo3VwGQ8SXwC5OlWbvxc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K8PH51rUD/zHo0a+UCoY+jxLVQkZhkiZNFq6xeTVPhz4GrWeRv8wX2YWXGr+VivTQb9xr35YBCXlzrZm1osC3TARNS0SqsPGf5YAFV7l48TWqkHiJ1aQ3c80pp0UvVAH54QGqLrL4oRhZbeXbwy2sZbvnlW9pGhQ9Z6oobLkWRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=T6XX5ZVE; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="T6XX5ZVE"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2d5f5d8cc01so3429512a91.0
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 20:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724727653; x=1725332453; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3SihR2HEVes4mW2D41LMvRCDb8X62DzsgYe+Pxg0Dz8=;
        b=T6XX5ZVEsS/10YheqtdX/0cN657KUYdBFC3PHkIxc2jIUnpCSHmG1tdZDdWYFyzYgl
         mvi86yY5/KMOfFOAnLA4UEvpZhQTBNNuHzXSoSc7PIPYgK3kiSZLgue+EE5RsK176z1g
         OnGdu49qoGkMlTNcd9U02hidRpE9UpuQKJZmnmx3ramIsqKoioHnQI8wQFfyUH3tV3hU
         FJwoytZADRIqWCQvqEsqOYqnyRCv5yv0E4DyL9g3Eq221azOrjBGMruntBzLFM3SVISz
         yKGxXaHlc4dPGBA+DWECJCp1dLjlUbOYCYUnM/bDL8SmsZZvWsh/VMjf9mYWAJ6+VsLv
         yj5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724727653; x=1725332453;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3SihR2HEVes4mW2D41LMvRCDb8X62DzsgYe+Pxg0Dz8=;
        b=KahecwkK9Ci+R7iaiw4+ctuc9zPMSEcDZ8z9C9JmYtdLGPU5CNI5zlRyeInw2lVTDa
         4KD3pZk4BBpa914glccdLRw/ulg7iNbP8y/ry3JFp4U9U8QOsTzz9Cc+JmAo56oqrERK
         G7ZLlMrArQkAv/Il3aI8AUr/qy73Qv+JN956ENXGGVpbge7VFpnDGbnGHMSUItIY3W6Q
         O2pnhJG3CeNr0MFktlVAru4B6v4bgb1RM2TSJJ5QOypaV7LHDw0emW/urFImpsZan+ta
         S3Xal444/iP9BNpqgKvy9pgSnZrxwGfZLaV8m4q263Ob94OYp8U5W/q2k5PC6e2GnNuX
         CLVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWEPWEzMR3u5C3wAfykUgrpTO6vg7grC4UJnCXUbUVFbhA3Wn+XUnaok0l/ykcnNu7VHhR2a1eItbs=@vger.kernel.org
X-Gm-Message-State: AOJu0YziZU28Vo6uBU82IxOYrwRKS4RWy8m6TcqL7j4krNGlAasNY1N8
	+Z6L/HAf23eGK8Q0azbh8S+LPDwuP8Xb2oikeLBtOk31DjYnNyYKQIHg88niL+M=
X-Google-Smtp-Source: AGHT+IGlABfd8s5do8aWWQIIM6ytdfok+IUN+yKQq2vzdgq9ZitkYLP4oSWPzGNHiMhQiQT7C7dZ3g==
X-Received: by 2002:a17:90b:1217:b0:2c9:63fb:d3ab with SMTP id 98e67ed59e1d1-2d824d11f20mr2372068a91.22.1724727653052;
        Mon, 26 Aug 2024 20:00:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d613a420cdsm10684104a91.28.2024.08.26.20.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 20:00:52 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1simRt-00E4pz-0F;
	Tue, 27 Aug 2024 13:00:49 +1000
Date: Tue, 27 Aug 2024 13:00:49 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/24] xfs: add a lockdep class key for rtgroup inodes
Message-ID: <Zs1BYb4Q5m2paCSl@dread.disaster.area>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087470.59588.4171434021531099837.stgit@frogsfrogsfrogs>
 <ZsvFDesdVVdUhI8T@dread.disaster.area>
 <20240826213827.GG865349@frogsfrogsfrogs>
 <Zs0k0y1euPWgWMie@dread.disaster.area>
 <20240827015658.GE6082@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240827015658.GE6082@frogsfrogsfrogs>

On Mon, Aug 26, 2024 at 06:56:58PM -0700, Darrick J. Wong wrote:
> On Tue, Aug 27, 2024 at 10:58:59AM +1000, Dave Chinner wrote:
> > On Mon, Aug 26, 2024 at 02:38:27PM -0700, Darrick J. Wong wrote:
> > > On Mon, Aug 26, 2024 at 09:58:05AM +1000, Dave Chinner wrote:
> > > > On Thu, Aug 22, 2024 at 05:18:02PM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > 
> > > > > Add a dynamic lockdep class key for rtgroup inodes.  This will enable
> > > > > lockdep to deduce inconsistencies in the rtgroup metadata ILOCK locking
> > > > > order.  Each class can have 8 subclasses, and for now we will only have
> > > > > 2 inodes per group.  This enables rtgroup order and inode order checks
> > > > > when nesting ILOCKs.
> > > > > 
> > > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > > ---
> > > > >  fs/xfs/libxfs/xfs_rtgroup.c |   52 +++++++++++++++++++++++++++++++++++++++++++
> > > > >  1 file changed, 52 insertions(+)
> > > > > 
> > > > > 
> > > > > diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
> > > > > index 51f04cad5227c..ae6d67c673b1a 100644
> > > > > --- a/fs/xfs/libxfs/xfs_rtgroup.c
> > > > > +++ b/fs/xfs/libxfs/xfs_rtgroup.c
> > > > > @@ -243,3 +243,55 @@ xfs_rtgroup_trans_join(
> > > > >  	if (rtglock_flags & XFS_RTGLOCK_BITMAP)
> > > > >  		xfs_rtbitmap_trans_join(tp);
> > > > >  }
> > > > > +
> > > > > +#ifdef CONFIG_PROVE_LOCKING
> > > > > +static struct lock_class_key xfs_rtginode_lock_class;
> > > > > +
> > > > > +static int
> > > > > +xfs_rtginode_ilock_cmp_fn(
> > > > > +	const struct lockdep_map	*m1,
> > > > > +	const struct lockdep_map	*m2)
> > > > > +{
> > > > > +	const struct xfs_inode *ip1 =
> > > > > +		container_of(m1, struct xfs_inode, i_lock.dep_map);
> > > > > +	const struct xfs_inode *ip2 =
> > > > > +		container_of(m2, struct xfs_inode, i_lock.dep_map);
> > > > > +
> > > > > +	if (ip1->i_projid < ip2->i_projid)
> > > > > +		return -1;
> > > > > +	if (ip1->i_projid > ip2->i_projid)
> > > > > +		return 1;
> > > > > +	return 0;
> > > > > +}
> > > > 
> > > > What's the project ID of the inode got to do with realtime groups?
> > > 
> > > Each rtgroup metadata file stores its group number in i_projid so that
> > > mount can detect if there's a corruption in /rtgroup and we just opened
> > > the bitmap from the wrong group.
> > > 
> > > We can also use lockdep to detect code that locks rtgroup metadata in
> > > the wrong order.  Potentially we could use this _cmp_fn to enforce that
> > > we always ILOCK in the order bitmap -> summary -> rmap -> refcount based
> > > on i_metatype.
> > 
> > Ok, can we union the i_projid field (both in memory and in the
> > on-disk structure) so that dual use of the field is well documented
> > by the code?
> 
> Sounds good to me.  Does
> 
> union {
> 	xfs_prid_t	i_projid;
> 	uint32_t	i_metagroup;
> };
> 
> sound ok?

Yup.

-- 
Dave Chinner
david@fromorbit.com
