Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF34B1BF50
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 16:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711471658; cv=none; b=ogq7XN+PwPhLFDJG8WRJXNQNmLg2VvPKx13EaREdic+6BnkQlj6wAmP9DREQDzskckMTH14nWU+V1aVTDTDo1GU3yT040guP9vuNuYsJFSkXs5N+marjx98vOGnTi7/RBrBOjBNDEoYzva1JEvx5+DQxxX9HwvkU7CYs+QOBsxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711471658; c=relaxed/simple;
	bh=QAscICIyutDemtiIJw01unClUaqwzCOjDMF8jVjTn8k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aIpWY/Fo3KmywEDddIFP0PaO3PUK9cg/b4bpqBSiO8NpphOeYeaV4NrwAYrQrlnwQkqvLm5Cx8yC+IveDxVrB2ROlZnMYJz9WZAMgynRPon9zE2r/wuPLkYasJORC3WKqgk8kFyxoQ3N3bi3F+f7c1ai7px2DzrrJaVbfeKKPrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n4byzcRT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n4byzcRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CAD8C433F1;
	Tue, 26 Mar 2024 16:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711471657;
	bh=QAscICIyutDemtiIJw01unClUaqwzCOjDMF8jVjTn8k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n4byzcRTjMNTU44OYd7Yz4osaRRHj3e3y362y+5PQTelw8webdEKJrLGNS8QOpN4Q
	 ebMn9KJEyrhGmEHPRttsMxBDA5jt6lAmqyb+0POOUZBlAdVtkIqQ9wHk+zTRE4A+QN
	 SMSye2YfoAOwPvljwR8NhBDmLH3jj2yF3qgCHm0/bafbu0EziHb+J6Te8jLJ71PNGh
	 vkcplZBu/PZFRXcs2bNiuRKRrljb8WKq4fyjUv600CdneY3ljUDnIUY8OaopvUgW/O
	 4wmlZGf44rocXfSI1WEnADGTu1ELkDMffsu9jjWQxBwVpOegmMq9ssI0mKQeOTXA1x
	 T8MgD1lwvueuw==
Date: Tue, 26 Mar 2024 09:47:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 089/110] libxfs: add xfile support
Message-ID: <20240326164736.GK6390@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
 <171142132661.2215168.16277962138780069112.stgit@frogsfrogsfrogs>
 <ZgJdSnLbTlY4ZW8s@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgJdSnLbTlY4ZW8s@infradead.org>

On Mon, Mar 25, 2024 at 10:29:46PM -0700, Christoph Hellwig wrote:
> > +#ifdef HAVE_MEMFD_CLOEXEC
> > +# ifdef HAVE_MEMFD_NOEXEC_SEAL
> > +	fd = memfd_create(description, MFD_CLOEXEC | MFD_NOEXEC_SEAL);
> > +# endif /* HAVE_MEMFD_NOEXEC_SEAL */
> > +	/* memfd_create exists in kernel 3.17 (2014) and glibc 2.27 (2018). */
> > +	fd = memfd_create(description, MFD_CLOEXEC);
> > +#endif /* HAVE_MEMFD_CLOEXEC */
> > +
> > +#ifdef HAVE_O_TMPFILE
> > +	fd = open("/dev/shm", O_TMPFILE | O_CLOEXEC | O_RDWR, 0600);
> > +	fd = open("/tmp", O_TMPFILE | O_CLOEXEC | O_RDWR, 0600);
> > +#endif
> > +
> > +#ifdef HAVE_MKOSTEMP_CLOEXEC
> > +	fd = mkostemp("libxfsXXXXXX", O_CLOEXEC);
> > +	if (fd >= 0)
> > +		goto got_fd;
> > +#endif
> 
> Is there any point in supporting pre-3.17 kernels here and not
> just use memfd_create unconditionally?  And then just ifdef on
> MFD_NOEXEC_SEAL instead of adding a configure check?

There's not much reason.  Now that memfd_create has existed for a decade
and the other flags for even longer, I'll drop all these configure
checks.

--D
