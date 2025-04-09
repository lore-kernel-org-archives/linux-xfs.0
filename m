Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B2D1C84CD
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 16:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744214690; cv=none; b=mZB+d0c5GQ3nlcX3C5epBtAQd40q1wFZQH8gxZZwsMJz7PCgVCyOrGP2HPeMG6sAp04gsnnjMNGTYKr4MT2FtuNXP1L6p1wltKMrzVWtZTuuIw9cwHrEjirQAwMwr4CBBU/zhLI9fPhTQPr+kyMiX0maj8CDN41lKy0utkhL1vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744214690; c=relaxed/simple;
	bh=VGZgsWVcJLcEjgk0zc5d9AqYvrSaISYf21yFdnVStX8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GIxwJJRLkBTT99JtDYozebTdLK7pY6hQUqRyK+RQYiiZJMXQ8Lern7+nxSRhorWJV5NzOwSrNYpVBmeX9SzOwd/MAKc7xRfbwd+sWrGoDYhvVtn0f7BkRX2JOsgZ8NMqQzBoMbqIug0RefdmOBsm7lt1H3oE24oFO795VpyK/OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FARJ70Ko; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FARJ70Ko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CD2C4CEE2;
	Wed,  9 Apr 2025 16:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744214689;
	bh=VGZgsWVcJLcEjgk0zc5d9AqYvrSaISYf21yFdnVStX8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FARJ70KoCACRFB0sbAwI/w1u1OcRcZR5cUSOO8bOqErDl1lgkDn5IZ7/3TgJtVFeG
	 +ubNfY9lmaROuPlRXdO18Q+7RsfixUSTIsljA3MBrY7de4Db/Uxdp7p+RcV7Y6+5u1
	 F+cryCTdvkSZpAE5ZDquG06Ina7s2iE0ujHD2e9qhWigqGJPo7pdFO8CSyZzXZEn/m
	 7O+pzDYB+cLgZndRmOvhlnoBU7fywanXCvIbH7wxGRlbAll5lAEiJh4dGR3yYXQLIZ
	 Qkze31SjfRhiZER4CKOfaCSweELAnY9wiyl/PjyzorLqb1kKM1gc9icRwA4KO5JFoC
	 7gZZIMybAFFqQ==
Date: Wed, 9 Apr 2025 09:04:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/45] FIXUP: xfs: define the zoned on-disk format
Message-ID: <20250409160448.GB6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-12-hch@lst.de>
 <20250409154715.GU6283@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409154715.GU6283@frogsfrogsfrogs>

On Wed, Apr 09, 2025 at 08:47:15AM -0700, Darrick J. Wong wrote:
> On Wed, Apr 09, 2025 at 09:55:14AM +0200, Christoph Hellwig wrote:
> 
> No SoB?
> 
> Eh whatever it's going to get folded into the previous patch anyway so
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> --D
> 
> > ---
> >  include/xfs_inode.h |  6 ++++++
> >  include/xfs_mount.h | 12 ++++++++++--
> >  2 files changed, 16 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/xfs_inode.h b/include/xfs_inode.h
> > index 5bb31eb4aa53..efef0da636d1 100644
> > --- a/include/xfs_inode.h
> > +++ b/include/xfs_inode.h
> > @@ -234,6 +234,7 @@ typedef struct xfs_inode {
> >  	xfs_extlen_t		i_extsize;	/* basic/minimum extent size */
> >  	/* cowextsize is only used for v3 inodes, flushiter for v1/2 */
> >  	union {
> > +		uint32_t	i_used_blocks;

And only now did I notice the missing comment  ^^; can this add

"i_used_blocks is used for zoned rtrmap inodes"

from the kernel?

--D

> >  		xfs_extlen_t	i_cowextsize;	/* basic cow extent size */
> >  		uint16_t	i_flushiter;	/* incremented on flush */
> >  	};
> > @@ -361,6 +362,11 @@ static inline xfs_fsize_t XFS_ISIZE(struct xfs_inode *ip)
> >  }
> >  #define XFS_IS_REALTIME_INODE(ip) ((ip)->i_diflags & XFS_DIFLAG_REALTIME)
> >  
> > +static inline bool xfs_is_zoned_inode(struct xfs_inode *ip)
> > +{
> > +	return xfs_has_zoned(ip->i_mount) && XFS_IS_REALTIME_INODE(ip);
> > +}
> > +
> >  /* inode link counts */
> >  static inline void set_nlink(struct inode *inode, uint32_t nlink)
> >  {
> > diff --git a/include/xfs_mount.h b/include/xfs_mount.h
> > index 0acf952eb9d7..7856acfb9f8e 100644
> > --- a/include/xfs_mount.h
> > +++ b/include/xfs_mount.h
> > @@ -207,6 +207,7 @@ typedef struct xfs_mount {
> >  #define XFS_FEAT_NREXT64	(1ULL << 26)	/* large extent counters */
> >  #define XFS_FEAT_EXCHANGE_RANGE	(1ULL << 27)	/* exchange range */
> >  #define XFS_FEAT_METADIR	(1ULL << 28)	/* metadata directory tree */
> > +#define XFS_FEAT_ZONED		(1ULL << 29)	/* zoned RT device */
> >  
> >  #define __XFS_HAS_FEAT(name, NAME) \
> >  static inline bool xfs_has_ ## name (const struct xfs_mount *mp) \
> > @@ -253,7 +254,7 @@ __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
> >  __XFS_HAS_FEAT(large_extent_counts, NREXT64)
> >  __XFS_HAS_FEAT(exchange_range, EXCHANGE_RANGE)
> >  __XFS_HAS_FEAT(metadir, METADIR)
> > -
> > +__XFS_HAS_FEAT(zoned, ZONED)
> >  
> >  static inline bool xfs_has_rtgroups(const struct xfs_mount *mp)
> >  {
> > @@ -264,7 +265,9 @@ static inline bool xfs_has_rtgroups(const struct xfs_mount *mp)
> >  static inline bool xfs_has_rtsb(const struct xfs_mount *mp)
> >  {
> >  	/* all rtgroups filesystems with an rt section have an rtsb */
> > -	return xfs_has_rtgroups(mp) && xfs_has_realtime(mp);
> > +	return xfs_has_rtgroups(mp) &&
> > +		xfs_has_realtime(mp) &&
> > +		!xfs_has_zoned(mp);
> >  }
> >  
> >  static inline bool xfs_has_rtrmapbt(const struct xfs_mount *mp)
> > @@ -279,6 +282,11 @@ static inline bool xfs_has_rtreflink(const struct xfs_mount *mp)
> >  	       xfs_has_reflink(mp);
> >  }
> >  
> > +static inline bool xfs_has_nonzoned(const struct xfs_mount *mp)
> > +{
> > +	return !xfs_has_zoned(mp);
> > +}
> > +
> >  /* Kernel mount features that we don't support */
> >  #define __XFS_UNSUPP_FEAT(name) \
> >  static inline bool xfs_has_ ## name (const struct xfs_mount *mp) \
> > -- 
> > 2.47.2
> > 
> > 
> 
