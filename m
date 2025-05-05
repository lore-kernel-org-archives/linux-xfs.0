Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B1418FDD5;
	Mon,  5 May 2025 15:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746457640; cv=none; b=FfCu8+Pbj/6mAGbsyvTnGiysEDYou4L38zeuQQw+nMDWeVsAT0JyM22tj+qnTYkYNaYQHE7z0VcuamwAg067gPiOdOLRt/8jSvdYDXsnF0Ap+MXe7Qqhv9FCHpu2V8gyyS2DuJzBZCfJtMdTuoIcSmmZrObLrL3NxS5mf6J7Org=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746457640; c=relaxed/simple;
	bh=y9FCfOiO6QLi981nCwCrqUJyWBizGqlQGrZqWfBXvRQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OXBxHh0K9tzQL6uYb3XYMgq08YCSy7absVAkYOGsuFhGqw7+LYptmxK+1KI1RzuAGoQixLh9dNZ03qQlVy/yfzkJnNwjG+TA2LYWnfcwb4qai0alJNKgjxzPxksWzM1shpAzkn3VF14KRfk7X4w3uQOP9Ee5h8AHEBU4gA6HDVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fhbgUloE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fhbgUloE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D485CC4CEE4;
	Mon,  5 May 2025 15:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746457639;
	bh=y9FCfOiO6QLi981nCwCrqUJyWBizGqlQGrZqWfBXvRQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fhbgUloE6MXGWnpPfjATb5fUD2rZ7xEquT8n+c9UsVxQWKFJRv0pEWonGvv6q1yLS
	 b2UHF350eNcQ956uUCmVk2NQF0twhZNtI6VSwzuBIIwF3dCdJW8hv/3VID/DmOAppO
	 j+vMLk67nobNXHr2TX5tthbNX90hgST4sr/Tvs/TkZYc9cojU/7nNpvKowBUWhH0HM
	 3Vbr/8TWprqvutwbJn7xUO+xuALAX2HMlvCRD2DqC4ILQe5XUwARUi1N9VSPPToSKq
	 EhMu9UrexY+w9ZvoiL16VGiloDRtWEZsqBNszcJgFWZjvcv0nRY9Jd8oc3Qt1ROt7v
	 r3H5T47m/UH6g==
Date: Mon, 5 May 2025 08:07:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch <hch@lst.de>
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] xfs: free the item in xfs_mru_cache_insert on
 failure
Message-ID: <20250505150719.GZ25675@frogsfrogsfrogs>
References: <20250430084117.9850-1-hans.holmberg@wdc.com>
 <20250430084117.9850-2-hans.holmberg@wdc.com>
 <20250502200646.GT25675@frogsfrogsfrogs>
 <20250505054549.GA21045@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250505054549.GA21045@lst.de>

On Mon, May 05, 2025 at 07:45:49AM +0200, hch wrote:
> On Fri, May 02, 2025 at 01:06:46PM -0700, Darrick J. Wong wrote:
> > >  	atomic_inc(&pag_group(args->pag)->xg_active_ref);
> > >  	item->pag = args->pag;
> > > -	error = xfs_mru_cache_insert(mp->m_filestream, pino, &item->mru);
> > > -	if (error)
> > > -		goto out_free_item;
> > > +	xfs_mru_cache_insert(mp->m_filestream, pino, &item->mru);
> > 
> > Hmm, don't you still need to check for -ENOMEM returns?  Or if truly
> > none of the callers care anymore, then can we get rid of the return
> > value for xfs_mru_cache_insert?
> 
> Both for file streams and the zone association in the next patch the
> mru cache is just a hint, so we ignore all errors (see the return 0
> in the error handling boilerplate in the existing code).  But hardcoding
> that assumption into the core mru cache helpers seems a bit weird.

Ok then.  The comment change in this patch is a reasonable explanation
for why the return value is/has always been ignored, so

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D
