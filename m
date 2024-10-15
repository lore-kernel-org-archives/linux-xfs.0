Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626B9158D9C
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 05:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728969691; cv=none; b=Z2QtM/zsnestPMMlRE1VIaUeMt838X8Ucfd/jBGM9l3YsYeiEd33iy/wIALa/LMbM1IXACxnsxJWQ33IxciNn3j3r1wXi+EzpLrEKRID07IFylAsusgUBhluzOygQq2QDF9mRYUWL93n3eP01NzWkDZ8RsuIaixOt2ow6AfosAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728969691; c=relaxed/simple;
	bh=3onZ8PfgTUi2mV6slbDVpftS9nVwZudaxSL9mt3F1qk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fG7rnXEFUKpLfJtqYpaq2TzlRanNeS4DdMwbJ5P8k2KosiwGKp9GJKE3nPw/YKAZHcAxxaLIkhOn4NXE/e/JCREePa/fkcG1O1X27G6HlZ37K5nGFVEPB+B/j28MLKr2kMrWri+R86n1ZfOJoe/IeN8pdQtD6CWK0iUf1K0XJxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A8FDA227AA8; Tue, 15 Oct 2024 07:21:23 +0200 (CEST)
Date: Tue, 15 Oct 2024 07:21:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 03/28] xfs: define the on-disk format for the metadir
 feature
Message-ID: <20241015052123.GA18499@lst.de>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs> <172860642064.4176876.13567674130190367379.stgit@frogsfrogsfrogs> <Zw3rjkSklol5xOzE@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zw3rjkSklol5xOzE@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 15, 2024 at 03:11:58PM +1100, Dave Chinner wrote:
> > +enum xfs_metafile_type {
> > +	XFS_METAFILE_UNKNOWN,		/* unknown */
> > +	XFS_METAFILE_DIR,		/* metadir directory */
> > +	XFS_METAFILE_USRQUOTA,		/* user quota */
> > +	XFS_METAFILE_GRPQUOTA,		/* group quota */
> > +	XFS_METAFILE_PRJQUOTA,		/* project quota */
> > +	XFS_METAFILE_RTBITMAP,		/* rt bitmap */
> > +	XFS_METAFILE_RTSUMMARY,		/* rt summary */
> > +
> > +	XFS_METAFILE_MAX
> > +} __packed;
> 
> Ok, so that's all the initial things that we want to support. How do
> we handle expanding this list of types in future? i.e. does it
> require incompat or rocompat feature bit protection, new inode
> flags, and/or something else?

New incompat flag.

> 
> 
> > @@ -812,7 +844,10 @@ struct xfs_dinode {
> >  	__be16		di_mode;	/* mode and type of file */
> >  	__u8		di_version;	/* inode version */
> >  	__u8		di_format;	/* format of di_c data */
> > -	__be16		di_onlink;	/* old number of links to file */
> > +	union {
> > +		__be16	di_onlink;	/* old number of links to file */
> > +		__be16	di_metatype;	/* XFS_METAFILE_* */
> > +	} __packed; /* explicit packing because arm gcc bloats this up */
> 
> That's a nasty landmine. Does anything bad happen to the log dinode
> with the same compilers?

The log_dinode just has di_metatype because we never log di_onlink.

TBH I wonder if just changing the field to be just di_metatype
and adding a comment that for v1 inodes it is used for the nlink
field might be a cleaner.

