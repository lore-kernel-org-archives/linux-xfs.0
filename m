Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79482A1D8
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738903763; cv=none; b=O3/JPVcJtanTCy2HIA4w83AKcLIWm0+qQAGn7fcTU8d0chR4D77vyDC67u/7tM+SrOsf95xoeiaw8H8VS/99F+TD8oLNR/tKE1izcLk9FsNEtU1yngeAapsOIZGXV+pFOqv+ODonqcXkMnUW7Y78NLAWjDbFLwc37qXwOoxVk7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738903763; c=relaxed/simple;
	bh=J9lY0cVDPTx7wqFqCon9qIOpRAvJRkhu+JAmfKDcXTw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tIhJe/vWvpentH4CqB4BcxT8Zmz4d8HLNRuX45pTd7+cCfgUerR3gJ7JgM2H9Q/D1+gY65mSrek0IM0X1bIbyG1KMUSKWKm+y1+NL6gno+WbODSFZe78SoTWUNqRv7IqzjPl8UUGcMH1r8surGAfe8YiqA/+XynzxA4z3+8kkRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tg3m+S+B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tg3m+S+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F62C4CED1;
	Fri,  7 Feb 2025 04:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738903762;
	bh=J9lY0cVDPTx7wqFqCon9qIOpRAvJRkhu+JAmfKDcXTw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Tg3m+S+B0Qp5/XmZRKaIHN03lyNTElFqu3rzzP9Cd6tGU8NuSygJVREzhD544e+zS
	 6/yVYI0tYrutwRb8Qs+rVtYgsZGDafF3cmMUg6g6NxHEZYh2MPj0gd64sjWJd17J2J
	 UMfbaKaNHS5fGvSxx3vXGK8rt2XqrYYkSWM+UyoIzHUAYkY4Sq7y9Sk6ivzY5pGLdW
	 d+Ri6RupAiHI/eqnIz0FmG/mN1kNMDYAkl/9kOpoeDlXXR1sKZiSiiQTreOn/j04gX
	 YgBtC6QF5PdV+BbuX4WPF+Pac2YccN6Ieauti8CaWT3c0DyiQbVpQzwEpgtU9X2HEv
	 ZAo+fGam0guCg==
Date: Thu, 6 Feb 2025 20:49:22 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/17] libfrog: wrap handle construction code
Message-ID: <20250207044922.GR21808@frogsfrogsfrogs>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
 <173888086121.2738568.17449625667584946105.stgit@frogsfrogsfrogs>
 <Z6WNXCVEyAIyBCrd@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6WNXCVEyAIyBCrd@infradead.org>

On Thu, Feb 06, 2025 at 08:34:36PM -0800, Christoph Hellwig wrote:
> On Thu, Feb 06, 2025 at 02:31:41PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Clean up all the open-coded logic to construct a file handle from a
> > fshandle and some bulkstat/parent pointer information.  The new
> > functions are stashed in a private header file to avoid leaking the
> > details of xfs_handle construction in the public libhandle headers.
> 
> So creating a handle from bulkstat is a totally normal thing to do
> for xfs-aware applications.  I'd much rathe see this in libhandle
> than hiding it away.

I was going to protest that even xfsdump doesn't construct its own weird
handle, but Debian codesearch says that Ganesha does it, so I'll move it
to actual libhandle.

> > +		handle_from_fshandle(&handle, file->fshandle, file->fshandle_len);
> 
> Nit: overly long line.

Will fix.

--D
