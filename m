Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36D53F44EC
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jun 2026 14:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782485272; cv=none; b=SJI7+xc9WsQftGQPNBSTBrBdbQHgv+SbKGzXj+1LMHDiJ932SY1Fb+iGGXOueMx3Nv6k0PIR+SuAYC3fqod492oafRHo0VbuBymndZhawYVNjC72mvijD+apMTk0ABV4QZzJn8W0DSMT4IdOnzNc76El6TE+RMnB7tX/qUBBoVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782485272; c=relaxed/simple;
	bh=oSarp3fEDincYll/GPBcH+aiMkw8U+c8C6ceAi10Ulc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pAyc6JbBEoLCZBrrADLyqeQW7gpX3RaXfdiVZ48MBiUamzfDSnxQ3cF99xKRPJufhzpfHzc90BWmMutrnzk22cTF3lnPBZy8u6FAzIRITncMoJ12PK9oOhL9oOFmnaq2fqP6+68QtF3OOPVKbKMRnzaZp+86fIIb17B6bCGIZoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b32ggrCC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b32ggrCC"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8050E1F000E9;
	Fri, 26 Jun 2026 14:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782485270;
	bh=FKltKYjen0eS/hZooEUy00oach4+Lq08ClJCLUN4arU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b32ggrCCVRfpaLqImEmzPEAqQVnxKB54J9Z62yXWpvIFQJpgw7pXbGjdgNbYw7Oze
	 Cv2GWAhbLKfRQYDNhgjmO3Y1om5drgkfyUjWaiZGSLXxqvVVUeKhYKeGiykb7GjMMN
	 6zENbzI0OTzKwCxhhEHSAi9Ck68cdAu8EoScUxZp7zHZIOyR9wMYEC09pLWiJZQsf+
	 6lTkyU3+YdOvPIDUI3OfilX0uYbSGpgsvzAEdE8a5du1AkNyTrsVzRr7N3rfslBC2E
	 q8ROpWTHUaA1cA2NhnHReV2PLnMB6ZzCuaH6ox5xm3bicqg+2wPFtz5wMb/dCy7KHY
	 3hrxcO7VWKjTw==
Date: Fri, 26 Jun 2026 07:47:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/6] xfs: also mark the buffer stale on verifier failure
 in xfs_buf_submit
Message-ID: <20260626144749.GQ6078@frogsfrogsfrogs>
References: <20260625135849.2494779-1-hch@lst.de>
 <20260625135849.2494779-3-hch@lst.de>
 <20260625180002.GG6078@frogsfrogsfrogs>
 <20260626043516.GD8078@lst.de>
 <20260626062146.GP6078@frogsfrogsfrogs>
 <20260626062326.GA10546@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626062326.GA10546@lst.de>

On Fri, Jun 26, 2026 at 08:23:26AM +0200, Christoph Hellwig wrote:
> On Thu, Jun 25, 2026 at 11:21:46PM -0700, Darrick J. Wong wrote:
> > > ->verify_write is expected to set b_error when it fails (and yes,
> > > the API in that area is awful).
> > 
> > Would you mind leaving a comment here, then?
> > 
> > 	if ((bp->b_flags & XBF_WRITE) && !xfs_buf_verify_write(bp)) {
> > 		/* ->verify_write should have set b_error already */
> > 		xfs_force_shutdown(...);
> > 		goto out_ioerror;
> > 	}
> 
> Sure.

With the comment added,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D
