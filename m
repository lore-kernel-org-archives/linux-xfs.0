Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CD6281524
	for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 14:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419570; cv=none; b=ctR5pTuJD559yAI70vZX4iu4i/qpAAtJApavs6no1ikM2xAf1b9DLH2p5Qb2cEWOtoF5T+L13gK+ygnyGUxg3uxaDapD61jHVw4ThMqgnBvjUbFvxdfKaiqh4BFwP2TR3ae13RAL7SSRnbMxeuVMPWfGa0HhXrBGxTJWjFWDwT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419570; c=relaxed/simple;
	bh=QxV91BT9tThYcKRAJKtThqnl6a/kauEbOo/M0M5KC4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ubi8QG4TFa9TwLsFfy830jwc65K8UbRacqwoUfUtZSOxGLjUwfoYhyTO44EAB9TCVParAfmz+n3uHsU5ztIWBgsL0ZEejFmysVJJnLy3vWwC9RNQAGgGXdtBO6NVVeSX6oDuTmnxcjlp526FK2SI926ABc/Csd/Po5csRozZI3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZGRlR+0F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZGRlR+0F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5277C4CEE2;
	Wed, 23 Apr 2025 14:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745419569;
	bh=QxV91BT9tThYcKRAJKtThqnl6a/kauEbOo/M0M5KC4Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZGRlR+0FpOsLmKY5qJWhtZAs/Ley/Y5SwdX5j3wA0vP/x5qIqsamlr39xOJqrWQIt
	 NaUbI+7S/X7X5UVF2tEpURYMG3HZYaqYFDY67qGiGANcjceeyI2XvxKS7A3RDsmrfn
	 k59oRRozP7zG9VkfX7PQaWwokjtJfwJNbbWkFxjgMLoZih24Ri9gN0mr5ZuZ/UplyH
	 46BiiR3Pnut7TAmsbWc1tsud2Kf9zn0hEo3uokyCFEJn0j6KFft2NLzRFZzS6vKBqI
	 bwtcSEqYrc3V/0s/78WXCkj8wcwLSgtzZO+CSHl3QGPl/ZD4uVJyKUVnDs33vmwMdL
	 FDsdctqTPffUQ==
Date: Wed, 23 Apr 2025 07:46:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev
Subject: Re: [PATCH RFC 0/2] prototype: improve timestamp handling
Message-ID: <20250423144609.GX25675@frogsfrogsfrogs>
References: <20250416144400.940532-1-luca.dimaio1@gmail.com>
 <20250422031019.GM25659@frogsfrogsfrogs>
 <38CD4E31-1B83-4689-AD44-7AF9919AED6C@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38CD4E31-1B83-4689-AD44-7AF9919AED6C@gmail.com>

On Tue, Apr 22, 2025 at 08:16:17AM +0200, Luca Di Maio wrote:
> Thanks Darrick for the feedback,
> I've also sent a v3 patch for this that still uses the prototype file,
> without changing the file specification at all.
> Let me know what you think of that.

TBH I'm not enthusiastic about changing the protofile parsing at all.
The file format is creaky but stable; let's not spend engineer time on
propping up old designs...

> I'm also a bit more aligned on the "walk and copy" functionality, I'll
> try to implement that too. In the meantime if the prototype file
> implementation works, it could also be an improvement what do you
> think?

...because I like this idea a lot better.

--D

> Thanks for your review
> L.
> 
> On April 22, 2025 5:10:19 AM GMT+02:00, "Darrick J. Wong" <djwong@kernel.org> wrote:
> >Crumbs, apparently I forgot ever to send this message. :(
> >
> >On Wed, Apr 16, 2025 at 04:43:31PM +0200, Luca Di Maio wrote:
> >> Hi all,
> >> 
> >> This is an initial prototype to improve XFS's prototype file
> >> functionality in scenarios where FS reproducibility is important.
> >> 
> >> Currently, when populating a filesystem with a prototype file, all generated inodes
> >> receive timestamps set to the creation time rather than preserving timestamps from
> >> their source files.
> >> 
> >> This patchset extends the protofile handling to preserve original timestamps (atime,
> >> mtime, ctime) across all inode types. The implementation is split into two parts:
> >> 
> >> - First patch extends xfs_protofile.in to track origin path references for directories,
> >> character devices and symlinks, similar to what's already implemented for regular files.
> >> 
> >> - Second patch leverages these references to read timestamp metadata from source files
> >> and populate it into the newly created inodes during filesystem creation.
> >> 
> >> At the moment, the new `xfs_protofile` generates a file that results
> >> invalid for older `mkfs.xfs` implementations. Also this new implementation
> >> is not compatible with older prototype files.
> >> 
> >> I can imagine that new protofiles not working with older `mkfs.xfs`
> >> might not be a problem, but what about backward compatibility?
> >> I didn't find references on prototype file compatibility, is a change
> >> like this unwanted?
> >
> >I think it'd be more ergonomic for mkfs users to introduce an alternate
> >implementation that uses nftw() to copy whole directory trees (like
> >mke2fs -d does) instead of revising a 52-year old file format to support
> >copying attrs of non-regular files.  Then we can move people to a
> >mechanism that doesn't require cli options for supporting spaces in
> >filenames and whatnot.
> >
> >--D
> >
> >> If so, what do you think of a versioned support for prototype files?
> >> I was thinking something on the lines of:
> >> 
> >> - xfs_protofile
> >>   - if the new flag:
> >>     - set the first comment accordingly
> >>     - add the additional information
> >>   - else act as old one
> >> 
> >> - proto.c
> >>   - check if the doc starts with the comment `:origin-files enabled`
> >> 	(for example)
> >>   - if so, this is the new format
> >>   - else old format
> >> 
> >> Eager to know your thoughts and ideas
> >> Thanks
> >> L.
> >> 
> >> Luca Di Maio (2):
> >>   xfs_proto: add origin also for directories, chardevs and symlinks
> >>   proto: read origin also for directories, chardevs and symlinks. copy
> >>     timestamps from origin.
> >> 
> >>  mkfs/proto.c          | 49 +++++++++++++++++++++++++++++++++++++++++++
> >>  mkfs/xfs_protofile.in | 12 +++++------
> >>  2 files changed, 55 insertions(+), 6 deletions(-)
> >> 
> >> --
> >> 2.49.0
> >> 
> 
