Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B8020409F
	for <linux-xfs@vger.kernel.org>; Thu, 10 Apr 2025 06:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744268233; cv=none; b=X9YJNI4wcrhcUv1ZjVIlyp0QsrsoZ4lzYyQXK8aNyQDLq/DNvEytg5fJtNfUjRamvZNlAh3Z2w+oUOuQ0niYEQL0/r1EYDsref6qdNVQmfUHzoc8e7uneRdN40vCAwTarce1JmeVao914hxFSGoYULPybuOaA34P2Zgwf5nGZ9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744268233; c=relaxed/simple;
	bh=ap+gP8TnFwhn32z+l/vPBRPHtlhDE81MTKMOreMS+to=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aBZMbpsXPYndBfQTzBOeI1XCpGdbpP2qvvmjtGvk+R7lYHsDEeEusTr1Zh3lGJO49INuWB4R/Yi0m35orTNqgNtdQslmUULzL8UU8PV20i649QZF30261ho18t+LikgjzLiZv69RmB/G4/wmGnhkc1gGFkgj8LQ08bMQUsEkGgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 07A7B68BFE; Thu, 10 Apr 2025 08:57:08 +0200 (CEST)
Date: Thu, 10 Apr 2025 08:57:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 42/45] xfs_scrub: support internal RT sections
Message-ID: <20250410065707.GB31858@lst.de>
References: <20250409075557.3535745-1-hch@lst.de> <20250409075557.3535745-43-hch@lst.de> <20250409193049.GN6283@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409193049.GN6283@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 09, 2025 at 12:30:49PM -0700, Darrick J. Wong wrote:
> On Wed, Apr 09, 2025 at 09:55:45AM +0200, Christoph Hellwig wrote:
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  scrub/phase1.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/scrub/phase1.c b/scrub/phase1.c
> > index d03a9099a217..e71cab7b7d90 100644
> > --- a/scrub/phase1.c
> > +++ b/scrub/phase1.c
> > @@ -341,7 +341,8 @@ _("Kernel metadata repair facility is not available.  Use -n to scrub."));
> >  _("Unable to find log device path."));
> >  		return ECANCELED;
> >  	}
> > -	if (ctx->mnt.fsgeom.rtblocks && ctx->fsinfo.fs_rt == NULL) {
> > +	if (ctx->mnt.fsgeom.rtblocks && ctx->fsinfo.fs_rt == NULL &&
> > +	    !(ctx->mnt.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_ZONED)) {
> 
> Shouldn't this be gated on ctx->mnt.fsgeom.rtstart == 0 instead of
> !ZONED?  I think we still want to be able to do media scans of zoned
> external rt devices.

It checks for ctx->fsinfo.fs_rt above, which is non-NULL for
external devices.  But looking at rtstart might still be better, I'll
look into it.

