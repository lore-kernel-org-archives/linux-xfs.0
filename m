Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E01E215F75
	for <linux-xfs@vger.kernel.org>; Thu,  7 Nov 2024 15:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730995090; cv=none; b=OSxRUd8XPiBvbUPNHQtsRHfb3v3gVI6tzvn5HO7HihSOWkflyIb8PurF63PZ6SHj42W+oRkVud6eH2PD8B77lYrvkc4jZT1u7sRwtBQm6VuZLCfO7Uc9I7jqV3rF7dkppaKOAmOiBPcVpG1bvgMzN0GlHn0NiX+w2EyeeEiCVgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730995090; c=relaxed/simple;
	bh=EekOlCfgm8BbseUj+OXO0KG3VFdVVgJQU/0USHY+ygE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KNb/0v8B1OSD21gMXX7CL5gDegzPIIs89+SuYR2qLQUXjqVDFIGxao+cDWklSWUX9mo6yA3WLYZiwg2pKOtOVnQql3rd1sqB92DDkisHj/bzUkjS0HXHFH/JkvADJ0mJfuKMeabJhDNwPESOg8cK2H3UXEOOVJmBRmXFMXUIl/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I1A+NOaB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I1A+NOaB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01922C4CECD;
	Thu,  7 Nov 2024 15:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730995090;
	bh=EekOlCfgm8BbseUj+OXO0KG3VFdVVgJQU/0USHY+ygE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I1A+NOaBb/DStpH/j33h1siZyP8Ar7Jx1TusJlrUtDem2IdrtUSOQEWJURuvleevZ
	 SgXfMYAa6CqEQHmZQw8+s5SmGLjjzccy5jJxva1mzHg1sw8VG+9+7jDt2D6IpTxxD+
	 pmhbUvuyTJaYM6Tyx07K/90CXZCCm7V/MarwZxjWjC0JFZ9zMvwa6ksQZ7fUy2Dcah
	 JuDEw6FD8m8D2r0vTK9tA3bUlzsWWViuPsvFatVWTHtJG8b1GCygfRMJvn29Ro9nBi
	 kopIe8vClfNku9X2Zvfov+LEJVIUeot3mgfwZINU4VmWP6yM19S8QVlFM4oyffdybA
	 8ptyLG32/49mA==
Date: Thu, 7 Nov 2024 07:58:09 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] design: document realtime groups
Message-ID: <20241107155809.GQ2386201@frogsfrogsfrogs>
References: <173092059696.2883258.7093773656482973762.stgit@frogsfrogsfrogs>
 <173092059729.2883258.3327326591290447581.stgit@frogsfrogsfrogs>
 <20241107073318.GF4408@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241107073318.GF4408@lst.de>

On Thu, Nov 07, 2024 at 08:33:18AM +0100, Christoph Hellwig wrote:
> > --- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
> > +++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
> > @@ -106,6 +106,10 @@ struct xfs_sb
> >  	xfs_lsn_t		sb_lsn;
> >  	uuid_t			sb_meta_uuid;
> >  	xfs_ino_t		sb_metadirino;
> > +	xfs_rgnumber_t		sb_rgcount;
> > +	xfs_rgblock_t		sb_rgextents;
> > +	uint8_t			sb_rgblklog;
> > +	uint8_t			sb_pad[7];
> 
> And following on with my ranting about existing bits theme from the
> previous review:  why are we documenting the in-memory xfs_sb here
> and not the on-disk xfs_dsb?

<nod> will clean that one up too.

> > +| +XFS_SB_FEAT_RO_COMPAT_RTSB+ |
> > +Realtime superblock.  The first rt extent in rt group zero contains a superblock
> > +header that can be used to identify the realtime device.  See the section about
> > +the xref:Realtime_Group_Superblocks[realtime group superblocks] for more
> > +information.
> 
> This is actually gone now.

Oops, will remove that one.

> > +*sb_rgcount*::
> > +Count of realtime groups in the filesystem, if the
> > ++XFS_SB_FEAT_INCOMPAT_RTGROUPS+ feature is enabled.
> 
> ... will be zero if XFS_SB_FEAT_INCOMPAT_RTGROUPS is set, but no
> realtime subvolume exists
> 
> ?

Yeah, that's a good thing to note.  I'll also s/RTGROUPS/METADIR/ since
the rtgroups feature bit is also gone yet I seem to have missed this
one. :(

--D
