Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3B052B1D2
	for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 13:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790084526; cv=none; b=O/PEG0osf2kV8XKKNPPIhnwd1CFWLSwf+k+Z7dbQWuyYpOqCZ7rVUnfCGkOFMeYTWy3FvUxapUz3j2/zC4ChzH24tUIacyl4hU5bIQTC2rKEKI1jB6rqQKIBK5OmHnvg6wnymM8hT0BznXdJX0RDGgVEdI8wljpHWqXjq7jVc68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790084526; c=relaxed/simple;
	bh=s9h3zWitYwI1SjJPwu2IczQvPXs0ylt+nfT6cRZMpY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iPF4wai1JPS6uxY6b263TnTerhfbcMSOIj/CEH7eEEWEbdoE66X/durTDmNh6Oo2KAHKmDYvZzc4ntW5Hqo/9MFgJ8NlYS6/QK0IYcCepYgnizzelRzj2ARCTKqHWUzoUGl2WSlIuBygnKEXrVTwZNXFIgZlpztlpJGDf7zlVds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FvP6bay+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FvP6bay+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B321F000FF;
	Tue, 22 Sep 2026 13:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790084524;
	bh=YnWWNi5Ga2Cn0FFz8WtUdGnUmw3rEHs1fwLfS4CJlN4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FvP6bay+iWmzsMTQDOoP4FY2pldW1oa3IfbANVKD/+G+a9rf7IeZPSpsMTA1nHzE5
	 rHTGaHrd2dlI8lUJfZ6l3YXF/joTVu5R7n5zWOgvBqiYF+9LKyFm/Tewb4nAL1CCWM
	 UV3rN5t2QLqpRZ94U6Y/abbec7k0I9YNEwUUGgLU027nRbsDR/FdQyW7agUSzD/LAw
	 G9T77Lxb+EDdWpGL8i6E97v7YtADGfjXXh6dRM2AYmysyqat+XGL/AYT28Wl0kzb9H
	 r1hxQWwa34bRwujfz7agaJmhJbC6HT+dXsenEK5hcklI5ndnlrE262zKJoFTYyAgLY
	 k0jCAM1v+Ba8A==
Date: Tue, 22 Sep 2026 15:41:59 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, Wilfred Mallawa <wilfred.opensource@gmail.com>, 
	"Darrick J . Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Alistair Francis <alistair.francis@wdc.com>, Damien Le'Moal <dlemoal@kernel.org>, linux-xfs@vger.kernel.org, 
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: Re: [PATCH 1/3] xfs: add write pointer to xfs_rtgroup_geometry
Message-ID: <arKFdAhuxSq32e-P@nidhogg.toxiclabs.cc>
References: <20260313002456.3823811-1-wilfred.opensource@gmail.com>
 <arJ5oJeAOezhOGsP@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arJ5oJeAOezhOGsP@infradead.org>

On Tue, Sep 22, 2026 at 05:50:40AM -0700, Christoph Hellwig wrote:
> It looks like patches 2 and 3 in this series never made it into
> the xfsprogs repository despite being fully reviewed.  Can we get them
> picked up?

Cc'ing Andrey here.

> 
> On Fri, Mar 13, 2026 at 10:24:54AM +1000, Wilfred Mallawa wrote:
> > From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> > 
> > Source kernel commit: c6ce65cb17aa9321687d1b8a842487f839e1a548
> > 
> > There is currently no XFS ioctl that allows userspace to retrieve the
> > write pointer for a specific realtime group block for zoned XFS. On zoned
> > block devices, userspace can obtain this information via zone reports from
> > the underlying device. However, for zoned XFS operating on regular block
> > devices, no equivalent mechanism exists.
> > 
> > Access to the realtime group write pointer is useful to userspace
> > development and analysis tools such as Zonar [1]. So extend the existing
> > struct xfs_rtgroup_geometry to add a new rg_writepointer field. This field
> > is valid if XFS_RTGROUP_GEOM_WRITEPOINTER flag is set. The rg_writepointer
> > field specifies the location of the current writepointer as a block offset
> > into the respective rtgroup.
> > 
> > [1] https://lwn.net/Articles/1059364/
> > 
> > Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Carlos Maiolino <cem@kernel.org>
> > Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> > ---
> >  libxfs/xfs_fs.h | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
> > index d165de607..185f09f32 100644
> > --- a/libxfs/xfs_fs.h
> > +++ b/libxfs/xfs_fs.h
> > @@ -995,7 +995,8 @@ struct xfs_rtgroup_geometry {
> >  	__u32 rg_sick;		/* o: sick things in ag */
> >  	__u32 rg_checked;	/* o: checked metadata in ag */
> >  	__u32 rg_flags;		/* i/o: flags for this ag */
> > -	__u32 rg_reserved[27];	/* o: zero */
> > +	__u32 rg_writepointer;  /* o: write pointer block offset for zoned */
> > +	__u32 rg_reserved[26];	/* o: zero */
> >  };
> >  #define XFS_RTGROUP_GEOM_SICK_SUPER	(1U << 0)  /* superblock */
> >  #define XFS_RTGROUP_GEOM_SICK_BITMAP	(1U << 1)  /* rtbitmap */
> > @@ -1003,6 +1004,8 @@ struct xfs_rtgroup_geometry {
> >  #define XFS_RTGROUP_GEOM_SICK_RMAPBT	(1U << 3)  /* reverse mappings */
> >  #define XFS_RTGROUP_GEOM_SICK_REFCNTBT	(1U << 4)  /* reference counts */
> >  
> > +#define XFS_RTGROUP_GEOM_WRITEPOINTER  (1U << 0)  /* write pointer */
> > +
> >  /* Health monitor event domains */
> >  
> >  /* affects the whole fs */
> > -- 
> > 2.53.0
> > 
> > 
> ---end quoted text---
> 
