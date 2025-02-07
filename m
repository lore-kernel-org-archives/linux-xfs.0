Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EFA19992C
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 17:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738947604; cv=none; b=UYYy8cE/libnTXhCMhCfXipCxFOL/UX9SNOySkKJ/iXyt/eHg+p1ifmLp2NzeEdUeSMmuPmkjFf0Fvs9jHe9IIhfQQxwk6T0j083EKS8O6ilD4cRYJ8Mm4wwfQvLWx4Uf1g0C0ZD1v23ZTqSnuzcqJRoUp4KAi8UVLr4L6jFWe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738947604; c=relaxed/simple;
	bh=A7YlVwLXCuaj0tcUcTJ7Oqdx5qFgYPpajrrPikRRqso=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ql1woJ3XGbVVflvIBOGcAcXR+Jq/V3TfCJ0U52gCWB8CuUM/YL09UGNUQu43Oj5Dc4bgWiGH1GQtgeTuYS85Iq7oBt0iuiE73RLPeal3aqWPo3pBXKC5ZDPaHoyTgXxzlQjtz9jtyAeu8wNMsnVvyJTjpVZ95Il0X+i/ZLhtFxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b8vXWXVa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b8vXWXVa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 635C0C4CED1;
	Fri,  7 Feb 2025 17:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738947603;
	bh=A7YlVwLXCuaj0tcUcTJ7Oqdx5qFgYPpajrrPikRRqso=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b8vXWXVaL61hgI/B4pA3g8lZJfa2u8LNL+A0fA3rWRqIbdvCVZktJ6igY4fWcLjtw
	 pOIuAUG5VZ53fkeEvs6gw43hKh748SH3svlWrO3uPbLyJSd6idZDpZu4AxxaOE2PEu
	 uhId3qr7Q9Xmjd5tTJ4REXA9zq4EIj39di3JgyAvD2ei241TnDqGvtGf6yC0LnfOTX
	 9gYYcER4EXMSMr8W/zaHJhLaQ4fwoJUWFvjxl5/YbahpxIR9wLqf7o5xNksamZEdbT
	 2SfrGFYZEyobFgbi0QPx0PXrdz9mS6qKlb7pTcW2lAyvKGxqzCtnqn+yLHmJtNzaDB
	 M5AJPq3DsLzKg==
Date: Fri, 7 Feb 2025 09:00:02 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/17] libfrog: wrap handle construction code
Message-ID: <20250207170002.GW21808@frogsfrogsfrogs>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
 <173888086121.2738568.17449625667584946105.stgit@frogsfrogsfrogs>
 <Z6WNXCVEyAIyBCrd@infradead.org>
 <20250207044922.GR21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250207044922.GR21808@frogsfrogsfrogs>

On Thu, Feb 06, 2025 at 08:49:22PM -0800, Darrick J. Wong wrote:
> On Thu, Feb 06, 2025 at 08:34:36PM -0800, Christoph Hellwig wrote:
> > On Thu, Feb 06, 2025 at 02:31:41PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Clean up all the open-coded logic to construct a file handle from a
> > > fshandle and some bulkstat/parent pointer information.  The new
> > > functions are stashed in a private header file to avoid leaking the
> > > details of xfs_handle construction in the public libhandle headers.
> > 
> > So creating a handle from bulkstat is a totally normal thing to do
> > for xfs-aware applications.  I'd much rathe see this in libhandle
> > than hiding it away.
> 
> I was going to protest that even xfsdump doesn't construct its own weird
> handle, but Debian codesearch says that Ganesha does it, so I'll move it
> to actual libhandle.

I tried moving the code to libhandle, but I don't entirely like the
result.  The libhandle functions pass around handles as arbitrary binary
blobs that come from and are sent to the kernel, meaning that the
interface is full of (void *, size_t) tuples.  Putting these new
functions in libhandle breaks that abstraction because now clients know
that they can deal with a struct xfs_handle.

We could fix that leak by changing it to a (void *, size_t) tuple, but
then we'd have to validate the size_t or returns -1 having set errno,
which then means that all the client code now has to have error handling
for a case that we're fairly sure can't be true.  This is overkill for
xfsprogs code that knows better, because we can trust ourselves to know
the exact layout of a handle.

So this nice compact code:

	memcpy(&handle.ha_fsid, file->fshandle, file->fshandle_len);
	handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
			sizeof(handle.ha_fid.fid_len);

becomes:

	ret = handle_from_fshandle(&handle, file->fshandle,
			file->fshandle_len);
	if (ret) {
		perror("what?");
		return -1;
	}

Which is much more verbose code, and right now it exists to handle an
exceptional condition that is not possible.  If someone outside of
xfsprogs would like this sort of functionality in libhandle I'm all for
adding it, but with zero demand from external users, I prefer to keep
things simple.

For now I'm leaving the declarations as taking a pointer to mutable
struct xfs_handle.  This change also causes the libhandle version number
to jump from 1.0.3 to 1.1.0.

--D

> > > +		handle_from_fshandle(&handle, file->fshandle, file->fshandle_len);
> > 
> > Nit: overly long line.
> 
> Will fix.
> 
> --D
> 
