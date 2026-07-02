Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0535A3EB0E6;
	Thu,  2 Jul 2026 11:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782991055; cv=none; b=CsbBjc5Eto1y6gAGLSamZQUbILtTQp6dgnV1KU5XSAEC78qfd/TraQRqsm+TPBTAhnphxXqQtL2+sAmAXMQdsaLTYx2jn36QdHOaQz8uzB/wN/1GZyBdGCTewNd+CGE0n73Ai1+OebUfDeIFgQZvLBA/Iqf3JxiZvwTbQbs3cMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782991055; c=relaxed/simple;
	bh=LhOXCibg9a5drTPSzz1LQIpCrkavwlW99AeY8rvjAHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WmxXHFjTUfEZWMHfXjVe+ADR9sGN/+H0cMpWoXwWXTs22ALI7WVWSL1620DREwMNcvfJdLC62ov7+rBVV5R9mJLMIwrJElDyTvdYgUxrA6rMmQqz4rXfGXsaiCVeTCSev/ALtEUhQjEN3GQIZDLF3nN3JAXs76RbAqX5P8eM2oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jeTdrDsU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jeTdrDsU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA6DD1F000E9;
	Thu,  2 Jul 2026 11:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782991054;
	bh=B6qx0fV5Kuct++leTThUpa0sfGnYf2tKGKYlTAvI5PM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jeTdrDsUpWlyRENZ5SuOv40SOfygUjbYr5ohbvCL0H6KeKqJ5xpnjqG4A7+CC3SU/
	 SA+XzP/+GdgXLgZnBiqwBvqRB9T4Qe+xPMnpm9jM5Aqve+Bemm+XvrDTEgUFi9wtu+
	 VGTBkz/CUtT1R5jqtJbTlHKoekOuQ9yMMCpwXxxQF1ZOwxez+DSQok0RTe76DhsD8y
	 iVQ/7bp+Fxfkec2UKWa2G3w0myWjHdHKyxy9esAlwv7peMRJOFzCFt7VL2fZEweg6j
	 aIAjQqtx/AWB2hYLED67A3rpurffS/rpgHV/gHC7hVmewp1lljPws0/icVyn1SXj/T
	 /uhGO1qliYBkg==
Date: Thu, 2 Jul 2026 13:17:29 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	"Serge E. Hallyn" <serge@hallyn.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Subject: Re: [PATCH v3 1/5] xfs: fix capability check in xfs
Message-ID: <akZITB_FDP1nl2_S@nidhogg.toxiclabs.cc>
References: <20260702093324.127450-1-cem@kernel.org>
 <20260702093324.127450-3-cem@kernel.org>
 <20260702103052.GA6670@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702103052.GA6670@lst.de>

On Thu, Jul 02, 2026 at 12:30:52PM +0200, Christoph Hellwig wrote:
> On Thu, Jul 02, 2026 at 11:33:17AM +0200, cem@kernel.org wrote:
> > index 6339f4956ecb..205fe2dae732 100644
> > --- a/fs/xfs/xfs_iops.c
> > +++ b/fs/xfs/xfs_iops.c
> > @@ -835,7 +835,8 @@ xfs_setattr_nonsize(
> >  	}
> >  
> >  	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
> > -			has_capability_noaudit(current, CAP_FOWNER), &tp);
> > +					ns_capable_noaudit(&init_user_ns, CAP_FOWNER),
> 

Thanks, I tried to keep the parameters aligned, but I can bring it one
tab back. Do you mind if I fix it at commit time if -unlikely- no other
change is required?

This is what it will look like:

        error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
-                       has_capability_noaudit(current, CAP_FOWNER), &tp);
+                               ns_capable_noaudit(&init_user_ns, CAP_FOWNER),
+                               &tp);



> Extra indentation and an overly long line caused by that here.
> 
> Otherwise looks good.
> 
