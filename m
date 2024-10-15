Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D7A1F9ED1
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 18:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729016792; cv=none; b=D8x4r/AjePhOBgMc8pCnghdamMfhCcf8CUtVhel2PoShmmX2zaEPDCKrCt+785KEYsZY0uEBBrOQUIVstfTqMj7i7r793UDBSIkzQVokZ7RKSMnpxwAnNyrC4y0w6r3WbvEVdjk3LAohuQ/5kXpiz7QeX8uyW/gbxacfv08Hzdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729016792; c=relaxed/simple;
	bh=fb/c0aDWT4LLrzTktgDL56UWaMhMcEIOiiiGbowrpYw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KMB45I3woHsm/q2XP96xdfXDqImYP7djxj7+lxpVnXopDi2fsScfGjcH7s/r2kHUCwi9E2upljrarKORQflrnlU4eRLEGcsOXj2y68Jcm0XaA7D4zUHow5nX1Xp51eTbR/G0/TCqgZ11ye01i0Low6NaaWkJqjtOPCf15C/hiDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JV4SIM9S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JV4SIM9S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F06EC4CEC6;
	Tue, 15 Oct 2024 18:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729016791;
	bh=fb/c0aDWT4LLrzTktgDL56UWaMhMcEIOiiiGbowrpYw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JV4SIM9SypybgIu84Zewzk58dze54Dq5j7lQx2aIvk27rvPcQ39+e43mBrzTVyTQH
	 /ZOi1J7gQ9jMsOjDszBqwg56TADqxRkc3cJz3cznSzklAORvlytV1HEPXYEyaE3YtP
	 f3NqgyKpI1K7mi0XkaoVgQg9xjj7c3O7iuYzSgQ9MxIG8/DHfGqO56Qgog+kq5l99I
	 +/ZlubSx/NirUhoD5CG+YrZUXjfK+uE5H6SsfO5OBTGogyRUZcrb73I6e0eKUxbDkP
	 As4YXSFxGcBykT0wLD87BOKm2YrhtKeQBcpBP4VUPGjsHXEpsP9gc/zhHavMKM9sLc
	 Qpyb1NoAblUXw==
Date: Tue, 15 Oct 2024 11:26:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/28] xfs: define the on-disk format for the metadir
 feature
Message-ID: <20241015182630.GF21853@frogsfrogsfrogs>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
 <172860642064.4176876.13567674130190367379.stgit@frogsfrogsfrogs>
 <Zw3rjkSklol5xOzE@dread.disaster.area>
 <20241015052123.GA18499@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015052123.GA18499@lst.de>

On Tue, Oct 15, 2024 at 07:21:23AM +0200, Christoph Hellwig wrote:
> On Tue, Oct 15, 2024 at 03:11:58PM +1100, Dave Chinner wrote:
> > > +enum xfs_metafile_type {
> > > +	XFS_METAFILE_UNKNOWN,		/* unknown */
> > > +	XFS_METAFILE_DIR,		/* metadir directory */
> > > +	XFS_METAFILE_USRQUOTA,		/* user quota */
> > > +	XFS_METAFILE_GRPQUOTA,		/* group quota */
> > > +	XFS_METAFILE_PRJQUOTA,		/* project quota */
> > > +	XFS_METAFILE_RTBITMAP,		/* rt bitmap */
> > > +	XFS_METAFILE_RTSUMMARY,		/* rt summary */
> > > +
> > > +	XFS_METAFILE_MAX
> > > +} __packed;
> > 
> > Ok, so that's all the initial things that we want to support. How do
> > we handle expanding this list of types in future? i.e. does it
> > require incompat or rocompat feature bit protection, new inode
> > flags, and/or something else?
> 
> New incompat flag.
> 
> > 
> > 
> > > @@ -812,7 +844,10 @@ struct xfs_dinode {
> > >  	__be16		di_mode;	/* mode and type of file */
> > >  	__u8		di_version;	/* inode version */
> > >  	__u8		di_format;	/* format of di_c data */
> > > -	__be16		di_onlink;	/* old number of links to file */
> > > +	union {
> > > +		__be16	di_onlink;	/* old number of links to file */
> > > +		__be16	di_metatype;	/* XFS_METAFILE_* */
> > > +	} __packed; /* explicit packing because arm gcc bloats this up */
> > 
> > That's a nasty landmine. Does anything bad happen to the log dinode
> > with the same compilers?
> 
> The log_dinode just has di_metatype because we never log di_onlink.
> 
> TBH I wonder if just changing the field to be just di_metatype
> and adding a comment that for v1 inodes it is used for the nlink
> field might be a cleaner.

I think so.  packed unions are gross.

--D
