Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B282E10A1F
	for <linux-xfs@vger.kernel.org>; Tue, 22 Apr 2025 03:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745291420; cv=none; b=Kf/jbGXRmhL0/Lq5g6D74RyT5WYFt28V8YrxnUIfZvZMMSk10xj8kXs/bvkyunkbS95tYxtpdGjhvuDwUA3vN96wIGs7hZa3Ru3f2rzY8JujoUjPAfp8v2pdfWUs5IE4SjOGrcUNu7LE1h1DITWE8vjazczvejMxQysubSQukwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745291420; c=relaxed/simple;
	bh=t6fEzwJ5m43L6AmFrRZevZiLc5NbOD7snsbJJJYYPkI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gp3qkxSFmM1erN63ZE1uMHBRjU7SdUYQL3f+B7b+9ror0ucRxd7hoEmfIwb0RIV8v2PMitcb84Dz/2OZTLerwwI/xx93EAAPf8rSe/u+/BKPEOsGBv7dDpu7gvr/ZukJIHd7tPqA0q5iUYRH9ZC9PXweuODbhjFYlVoIhz7r9/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uPjCJfL6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uPjCJfL6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF52C4CEE4;
	Tue, 22 Apr 2025 03:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745291420;
	bh=t6fEzwJ5m43L6AmFrRZevZiLc5NbOD7snsbJJJYYPkI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uPjCJfL62qnQMHJECI5ViQrMHWxF7eXo7jUhYjEKz6iuNgPc44D1gyXo2bZfgA9DE
	 oH6b2NTC5kLTlXGvVR2H3eKF+N31hR1qLuY0v4roCXGUo++cfGLTAdto9Q6MDIS1qp
	 ndAM7QyxfWv+Xus52SguTBqzsfEtG4+mKZEL1nANzuIyf8SKt8gGLtj5OaXl6vWKNW
	 qk+aGv5FjSHp97umqbmqp2cRzB9X6XTZF2FD/Yngzc8cXkSpj2zOSmjPx2ZFRzfwcD
	 EiacyKk/6vC0Z5/6iEaR8BDmuREJk2IT0HYpyU4vEupQsqVAugPxtuvncIUkg2xxKv
	 Msn4l0p7aSi0Q==
Date: Mon, 21 Apr 2025 20:10:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev
Subject: Re: [PATCH RFC 0/2] prototype: improve timestamp handling
Message-ID: <20250422031019.GM25659@frogsfrogsfrogs>
References: <20250416144400.940532-1-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250416144400.940532-1-luca.dimaio1@gmail.com>

Crumbs, apparently I forgot ever to send this message. :(

On Wed, Apr 16, 2025 at 04:43:31PM +0200, Luca Di Maio wrote:
> Hi all,
> 
> This is an initial prototype to improve XFS's prototype file
> functionality in scenarios where FS reproducibility is important.
> 
> Currently, when populating a filesystem with a prototype file, all generated inodes
> receive timestamps set to the creation time rather than preserving timestamps from
> their source files.
> 
> This patchset extends the protofile handling to preserve original timestamps (atime,
> mtime, ctime) across all inode types. The implementation is split into two parts:
> 
> - First patch extends xfs_protofile.in to track origin path references for directories,
> character devices and symlinks, similar to what's already implemented for regular files.
> 
> - Second patch leverages these references to read timestamp metadata from source files
> and populate it into the newly created inodes during filesystem creation.
> 
> At the moment, the new `xfs_protofile` generates a file that results
> invalid for older `mkfs.xfs` implementations. Also this new implementation
> is not compatible with older prototype files.
> 
> I can imagine that new protofiles not working with older `mkfs.xfs`
> might not be a problem, but what about backward compatibility?
> I didn't find references on prototype file compatibility, is a change
> like this unwanted?

I think it'd be more ergonomic for mkfs users to introduce an alternate
implementation that uses nftw() to copy whole directory trees (like
mke2fs -d does) instead of revising a 52-year old file format to support
copying attrs of non-regular files.  Then we can move people to a
mechanism that doesn't require cli options for supporting spaces in
filenames and whatnot.

--D

> If so, what do you think of a versioned support for prototype files?
> I was thinking something on the lines of:
> 
> - xfs_protofile
>   - if the new flag:
>     - set the first comment accordingly
>     - add the additional information
>   - else act as old one
> 
> - proto.c
>   - check if the doc starts with the comment `:origin-files enabled`
> 	(for example)
>   - if so, this is the new format
>   - else old format
> 
> Eager to know your thoughts and ideas
> Thanks
> L.
> 
> Luca Di Maio (2):
>   xfs_proto: add origin also for directories, chardevs and symlinks
>   proto: read origin also for directories, chardevs and symlinks. copy
>     timestamps from origin.
> 
>  mkfs/proto.c          | 49 +++++++++++++++++++++++++++++++++++++++++++
>  mkfs/xfs_protofile.in | 12 +++++------
>  2 files changed, 55 insertions(+), 6 deletions(-)
> 
> --
> 2.49.0
> 
