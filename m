Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE09221FCD
	for <linux-xfs@vger.kernel.org>; Thu, 20 Nov 2025 23:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763682404; cv=none; b=hUe1i8Dy+sbchpR+535MMWCSErfJ01eTpUH0/KzIGG/5HXLPfR2+X/L8VmPvlP44ZLAl835jUhq5NtTXnU/xfXSyInRo1s9f496DFmU2E3t0UBcqd8IhBAPiVbhcnXa/YbZKCaJVjbdeTbM6b9izxsEX5O8QHbXsZ3ATGlJO6Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763682404; c=relaxed/simple;
	bh=cTZsjp3Q12+6j4up0pvr+qj17cO36L7L0HsWTK0G4Gc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZrfWEt/W+ec34EahHfmhvdZx9gkL7wdKtSehsJ3XrtFeDpCS0G5s8uRoIuHGIj+eSng6XYu3vASTfhBo4sW5TIO3I7b4sf8DgpLhb37O6nzE5ymOZ+0tC12V4VNKqE8Nt9FjIubwFykCgxFyIvCJNXLLl0YVj1YdQSfeuUhepfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qprGbRrB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qprGbRrB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EEBAC4CEF1;
	Thu, 20 Nov 2025 23:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763682403;
	bh=cTZsjp3Q12+6j4up0pvr+qj17cO36L7L0HsWTK0G4Gc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qprGbRrB2jWbzp+DthpcVuMIEr58QWKn0Jdp7xBea6YtJvAo8+nN3xhOUxM+kr1Tr
	 hxQfdbae0F15EfcKASy9BhsG2tOl4Xyoe+bMTgoABLMaFJM9JhKGQp3wXQ/YRYjN4W
	 lfOwvc3ZKc5WQmiN6kgdkvI3w1mpgHAJ7dEew2pXNTbcBvWWS+jlOybP4+uGdz3K54
	 kMl1I1KDc8C0LHxJvir3Knr8dMiYT/7/m+MAkzh25CqRZBtp+3QBG01Yye0rdiwDnG
	 hBSTaphwWceS8A+JT56WbLuG4wJ1TkTSJ6sqejn6xx+YwkTgKdmXrUaQOswTqbEZUI
	 5nIQLeXB3gcng==
Date: Thu, 20 Nov 2025 15:46:43 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Alexander Monakov <amonakov@ispras.ru>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_db rdump: remove sole_path logic
Message-ID: <20251120234643.GM196370@frogsfrogsfrogs>
References: <20251112151932.12141-1-amonakov@ispras.ru>
 <20251112151932.12141-2-amonakov@ispras.ru>
 <20251112185308.GB196370@frogsfrogsfrogs>
 <7e7a4185-040d-b438-1821-bdb8b602f257@ispras.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e7a4185-040d-b438-1821-bdb8b602f257@ispras.ru>

On Wed, Nov 12, 2025 at 10:45:37PM +0300, Alexander Monakov wrote:
> 
> On Wed, 12 Nov 2025, Darrick J. Wong wrote:
> 
> > On Wed, Nov 12, 2025 at 06:19:31PM +0300, Alexander Monakov wrote:
> > > Eliminate special handling of the case where rdump'ing one directory
> > > does not create the corresponding directory in the destination, but
> > > instead modifies the destination's attributes and creates children
> > > alongside the pre-existing children.
> > 
> > It sounds like what happened is that you ran rdump with a non-empty
> > destdir, only to have rdump mutate the existing children in that
> > directory.  Is that correct?
> 
> Not really (what you describe would have been even worse).
> 
> In my case, I was rdump'ing into a directory that had rtinherit set, and
> rdump undid that (generally speaking, all attributes of the destdir were
> overwritten, not just rtinherit).
> 
> > If so, then I think what you really wanted was for rdump to check for
> > that and error out, unless explicit --overwrite permission had been
> > granted.  Because...
> 
> (I would still hit the above issue with attributes)
> 
> > > This can be a trap for the unwary (the effect on attributes can be
> > > particularly surprising and non-trivial to undo), and, in general, fewer
> > > special cases in such a low-level tool should be desirable.
> > 
> > ...I use this "special case" and don't understand why you decided that
> > removing functionality was the solution here.  This is a filesystem
> > debugger, there are weird functions and sharp edges everywhere.
> 
> Shouldn't we strive to have fewer surprises? For instance, if there was
> an explicit flag for that, there wouldn't be an issue.
> 
> Out of curiosity, what is your use-case for this?

Copying build artifacts out of a directory on an xfs filesystem into
some other directory, e.g.

# xfs_db -c 'rdump /rootfs /srv/containers/whatever' /dev/sda1

Without then having to do:

# mv /srv/containers/whatever/rootfs/* /srv/containers/whatever/
# rmdir /srv/containers/whatever/rootfs

I'd be willing to accept more rsync-like behavior where a trailing slash
means "copy children directly into the target dir" and no trailing slash
means "create new child subdir in target dir and copy stuff into that".

IOWs,

xfs_db> rdump /rootfs /srv/containers/whatever

Would always create /srv/containers/whatever/rootfs and copy the
children of /rootfs into that path, but

xfs_db> rdump /rootfs/ /srv/containers/whatever/boot

Would copy the children of /rootfs directly into
/srv/containers/whatever/boot.

--D


> Thank you.
> Alexander
> 
