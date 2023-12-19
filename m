Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680CDC12F
	for <linux-xfs@vger.kernel.org>; Tue, 19 Dec 2023 04:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oE65+OqQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA19EC433C8;
	Tue, 19 Dec 2023 04:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702961530;
	bh=SHUzwQZagOSNTctzvCb6PRBxdeMcDRljM9WWAla29ys=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oE65+OqQFPqglHi0oZXUQsymITbPF9+fCFi27Fg5tzOgjEagaX8BLgEKE5gFvoqGn
	 h3IDwH9kzKAvy9D1KOW0a46R/+WWq77ycyZS5KOAqZEs+AUl/3BaLaAzRZDF7i5R6a
	 JvVjiuPn48tCeY+TETiupe9jAtEBUkFXvZ/A5MzJPBh7z8SL7C6HA73HHaV9WwQ4VG
	 P4rbEGdLymC1Z1nJKcNKtJjfFdMQFqHgLwROOQseUmG28dT5F1nUODFAAKvZa7Id1E
	 g/2yz5+UO+29mJ1ZdyF66lZFbh22crK0QnDF88Fw32CDlJRrclDfXFtW9gu2DGiTEr
	 JgspApa6dhggg==
Date: Mon, 18 Dec 2023 20:52:10 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: move the xfs_attr_sf_lookup tracepoint
Message-ID: <20231219045210.GH361584@frogsfrogsfrogs>
References: <20231217170350.605812-1-hch@lst.de>
 <20231217170350.605812-4-hch@lst.de>
 <20231218223902.GC361584@frogsfrogsfrogs>
 <20231219042139.GB30534@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231219042139.GB30534@lst.de>

On Tue, Dec 19, 2023 at 05:21:39AM +0100, Christoph Hellwig wrote:
> On Mon, Dec 18, 2023 at 02:39:02PM -0800, Darrick J. Wong wrote:
> > > -	trace_xfs_attr_sf_lookup(args);
> > > -
> > >  	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
> > >  	sfe = &sf->list[0];
> > >  	for (i = 0; i < sf->hdr.count;
> > > @@ -905,6 +903,9 @@ xfs_attr_shortform_getvalue(
> > >  	int				i;
> > >  
> > >  	ASSERT(args->dp->i_af.if_format == XFS_DINODE_FMT_LOCAL);
> > > +
> > > +	trace_xfs_attr_sf_lookup(args);
> > 
> > Shouldn't this get renamed to trace_xfs_attr_shortform_getvalue to match
> > the function?  Especially since xfs_attr_shortform_lookup disappears
> > later, AFAICT.
> 
> If we value accurate naming over being able to use a historical
> trace point: yes.  Although in that case I'd probably structure it
> as a patch adding the new xfs_attr_shortform_getvalue tracepoint only,
> and removing the xfs_attr_sf_lookup one with the function.

Eh, tracepoint names are greppable enough.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

