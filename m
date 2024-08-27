Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF2419EEA2
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 14:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769377; cv=none; b=mMVDZJw9ZyC+Mv2vEdf6X1wez5l7aQCjBZMhoFmqCT1cyzrB2p2CH9oMne23bwh5W5Mh5fzo/O8ZurMyb7W/ZLoTPMJmVgi+WmB8tXV2/+xHHazPu0KPz+nCCwc/AmDoZU1BesCOR9i9QWo626+MW/qKh1bT+11kssrha3vOkAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769377; c=relaxed/simple;
	bh=gBadKD2GFCjdl+yjfUWpSBaXPOXUAEGqjtOkuVZlB3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LVhiCRAagoupagaMyqZo9S6YUEQ3V9N1rNEJ/CHNfLji1H1Rg7hWnpx4kXyWchjdDmMyHINQmpf1633SGnuz8vzEeB0z3ogTNSBIby6bOnDKDF6BfeiB88ZjVypOqYQLkLZR/bSBK1UhXPI/jjTUx/Ao3Da9GhBk9VeIx0s6jlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y3cvlGg0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y3cvlGg0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7FAC4DE02;
	Tue, 27 Aug 2024 14:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724769376;
	bh=gBadKD2GFCjdl+yjfUWpSBaXPOXUAEGqjtOkuVZlB3c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y3cvlGg0yxNesIeaSJx0PLHZs/0vvPutQhHHneBQPexCmwHv42DNfTDdtNAK0nXbJ
	 mn26vT5hW2EyATC+217E+iSM3/Ubi/0D8OpZE/y2dYl+5ruqMITZBTY1kn5MmESuBt
	 hjUFgfUEWvQCwey7Qb/+xCCo9XvdaVk2YeEyEUfEfnaUdjyHuuZ91+uwwHFnN+zJ9j
	 cZ0iymhm4or5pzIFaytPiLIrcRD1KXDw0uOc7XZRwPdh4r4qqHVjtVpJz/iaqdMRUv
	 r3XkrfbTNUUYQqMtnc+Q0H//pOFrnOyaDlwh3b7xM4h7YCa+wd4fwpEWCt9fQMtgNX
	 MTWJN0IpVFipQ==
Date: Tue, 27 Aug 2024 07:36:15 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 3/3] scrub: Remove libattr dependency
Message-ID: <20240827143615.GM865349@frogsfrogsfrogs>
References: <20240827115032.406321-1-cem@kernel.org>
 <20240827115032.406321-4-cem@kernel.org>
 <Zs3Dr2wwcaAFhMMO@infradead.org>
 <7vjkhxi2jv6mg4k6xle62lhve27myjgxml2batfwmshwkvfekk@jstiohihwa2d>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7vjkhxi2jv6mg4k6xle62lhve27myjgxml2batfwmshwkvfekk@jstiohihwa2d>

On Tue, Aug 27, 2024 at 02:27:07PM +0200, Carlos Maiolino wrote:
> On Tue, Aug 27, 2024 at 05:16:47AM GMT, Christoph Hellwig wrote:
> > >   */
> > > +
> > >  #define ATTR_ENTRY(buffer, index)		\
> > 
> > Spurious whitespace change.
> > 
> > >  	((struct xfs_attrlist_ent *)		\
> > >  	 &((char *)buffer)[ ((struct xfs_attrlist *)(buffer))->al_offset[index] ])
> > >  
> > > +/* Attr flags used within xfsprogs, must match the definitions from libattr */
> > > +#define ATTR_ROOT	0x0002	/* use root namespace attributes in op */
> > > +#define ATTR_SECURE	0x0008	/* use security namespaces attributes in op */
> > 
> > Why do we need these vs just using XFS_ATTR_ROOT/XFS_ATTR_SECURE from
> > xfs_da_format.h?
> 
> Because I didn't see XFS_ATTR_ROOT and XFS_ATTR_SECURE exists :)

Well if we're reusing symbols from xfs_fs.h then change these to
XFS_IOC_ATTR_ROOT and XFS_IOC_ATTR_SECURE.

> I'll take a look on it, and if we don't really need to define ATTR_ROOT/SECURE,
> I'll just keep ATTR_ENTRY locally to fsprops.h, we don't need a header file for
> just a single definition IMO.

<shrug> I'd have turned them into namespaced libfrog functions in
libfrog/attr.h, and demacro'd ATTR_ENTRY too:

static inline struct xfs_attrlist_ent *
libfrog_attr_entry(
	struct xfs_attrlist	*list,
	unsigned int		index)
{
	char			*buffer = (char *)list;

	return (struct xfs_attrlist_ent *)&buffer[list->al_offset[index]];
}

static inline int
libfrog_attr_list_by_handle(
	void				*hanp,
	size_t				hlen,
	void				*buf,
	size_t				bufsize,
	int				flags,
	struct xfs_attrlist_cursor	*cursor)
{
	return attr_list_by_handle(hanp, hlen, buf, bufsize, flags,
			(struct attrlist_cursor *)cursor);
}

--D

> 
> > 
> > > +	struct xfs_attrlist		*attrlist = (struct xfs_attrlist *)attrbuf;
> > 
> > Overly long line.
> 
> Ok, Thanks!
> 
> Carlos
> 
