Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962422E8882;
	Thu, 26 Mar 2026 05:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774503418; cv=none; b=gKqqoGP1pSKDqkIxgFBI+RTIqo8Ji6jAHu0IYqOr7qafvJOKOGnQKVG4gVoqODBmZ3EAHSD/jJiHLHgKzekMHUGvlzGXU5yyPyYNo2Ia4j5+YN/bCGbBiYKtt98xWA/RcMj7VZgz87zp9/s0FhgB/8S4sGpomq7dc1EhN6evv34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774503418; c=relaxed/simple;
	bh=s50gHSxKJAp8IVDXOo0qZIrNpXzBNBVGUOv2hFvDxT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=swZw3UvOVHfNArvgOwAch7h7YUWuEHly4mJFuy+M5rXRibthATq/LJA58fnDCcTLDj9kHoXkqsCXFT52LWK46DC6hi7YhL4IBHZaJCLjDVV7Un0u5U1Eu8/G+SbUAObG74b3J9W/nHw/LTc7+1UG+DwvoYFJ+lGxxTYmmk3GLQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BB4D568C4E; Thu, 26 Mar 2026 06:36:53 +0100 (CET)
Date: Thu, 26 Mar 2026 06:36:53 +0100
From: Christoph Hellwig <hch@lst.de>
To: Chuck Lever <cel@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Carlos Maiolino <cem@kernel.org>, linux-nfs@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/7] exportfs: don't pass struct iattr to
 ->commit_blocks
Message-ID: <20260326053653.GB23157@lst.de>
References: <20260323070746.2940140-1-hch@lst.de> <20260323070746.2940140-3-hch@lst.de> <81da6f4c-7523-496d-b8ed-8e78f4f83ea4@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81da6f4c-7523-496d-b8ed-8e78f4f83ea4@app.fastmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Mar 23, 2026 at 10:05:14AM -0400, Chuck Lever wrote:
> After this change is applied, nfsd4_block_commit_blocks continues
> to compute lcp->lc_mtime (honoring UTIME_NOW etc.) but never
> passes it to the underlying filesystem. The old code set
> 
>   iattr.ia_mtime = lcp->lc_mtime
> 
> and propagated it via setattr_copy; but now xfs_fs_commit_blocks
> unconditionally uses inode_set_ctime_current(). The mtime
> computation here is now dead code.
> 
> This change introduces a regression against RFC 8881 Section 18.42
> (LAYOUTCOMMIT's loca_time_modify is ignored).

That's not new in this patch.  For the is_mgtime() case, which applies
to XFS, setattr_copy always sets mtime to the current time when
ATTR_MTIME is passed.  We'd need to move ATTR_MTIME_SET to set a
specific time.

