Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C261DE4EC
	for <linux-xfs@vger.kernel.org>; Thu,  6 Mar 2025 18:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741286389; cv=none; b=O9+QRoGMrIrC851BxK+ZVf2feFU2WQj9HY3Qgw42eqE1H9fvOJQsB819iYHEkGQLGDy6MYQjkv0YH/XEA1n19dKelyElvbD4x5tpud43M8vrZK+dOLS68fdXnPpynZnXTkAIJqy9NAjPu9kSjtxn9ko9ZzROPK6LS/mFGdHXFzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741286389; c=relaxed/simple;
	bh=XWD6Dry+ZCvyL7V8nsGpG36yC3g39ymOK2iMSwoZgEk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P4yKrAUPiz6Srnxe4qffx1gyFFjKo9IOJubJDBjEUPaV1n+wAI+0lyklv0eZPS68pYfGBgxs3dcRmipB3Bz3GOmPRJe+Ur4V0UQsQbmyJ3DR8p1rAPwRq6nyih1YBB95UFeyERuh5vlENCwlriIaLqn+ScVzYpCPD7NIPk93AAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aI9VkKyd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aI9VkKyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917ABC4CEE0;
	Thu,  6 Mar 2025 18:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741286388;
	bh=XWD6Dry+ZCvyL7V8nsGpG36yC3g39ymOK2iMSwoZgEk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aI9VkKyd6gB+5QvAlrTX1gHLtMJCDj0cMgOy680IOPvyr3f8Qr4v4a6YrNCK4Df/m
	 Rtn0NH9u4GiEgZExkK+IOdbbLMe87OKpz/sxi+xlkR4DXOTKwNqEhzoe0O0Iln7NkC
	 +c4fmsaNAuIJitJBShb9kZZPxRHgVVjpmmwi5NTSy6cG6oaB/dWhHa6IWnoNgcmIf0
	 Vo8naGH/DDQD7MsHbFxPH91KhnHc0VsG3haXFiNFWz+GSbp+w8/mfS30FrLNDfrPvf
	 wzIcFVzzMpHP4aNZqDItzYFrVWTuLl35oNRG1XY6isc2tK1o6lSF+coPe+l0FhgkdO
	 8YP2r76fJIsGA==
Date: Thu, 6 Mar 2025 10:39:48 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Kjetil Torgrim Homme <kjetilho@ifi.uio.no>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: nouuid hint in kernel message?
Message-ID: <20250306183948.GQ2803749@frogsfrogsfrogs>
References: <Nro5gceoG1ar5vFFGSWGNwo-KlGPVYooeufy2thIqL3A5VKjZKQ0yp0kKyAxSVRiAvTm1CkpW4ITHawDjpez0A==@protonmail.internalid>
 <cbf4f4c23efba09467ca7c08e516fe8561a1f130.camel@ifi.uio.no>
 <pgirewjvggop2v2s6qrovyqr72kxfajuk2sbqlqll3facikiuu@sriorffcy3x4>
 <521200e9de4a3b789af1e2890f8a50f9612ed9c9.camel@ifi.uio.no>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <521200e9de4a3b789af1e2890f8a50f9612ed9c9.camel@ifi.uio.no>

On Thu, Mar 06, 2025 at 12:36:34PM +0100, Kjetil Torgrim Homme wrote:
> to. den 06. 03. 2025 klokka 11.00 (+0100) skreiv Carlos Maiolino:
> > On Thu, Mar 06, 2025 at 12:46:23AM +0100, Kjetil Torgrim Homme wrote:
> > > hey people, thank you for XFS!
> > > 
> > > tl;dr: consider changing the kernel message "Filesystem has duplicate
> > > UUID - can't mount" to include a hint about the existence of the nouuid
> > > mount option.  perhaps append " (use -o nouuid?)" to message?
> > 
> > This looks good at first, but adding a message like this has a big down
> > side IMHO. This leads users to simply attempt to do that even in cases when they
> > shouldn't.
> > 
> > As an example, in a common multipath environment with dm-multipath, an user
> > might accidentally attempt to mount both individual paths to the same device,
> > and this uuid duplicate check protects against such cases, which might end in
> > disaster.
> 
> makes sense.
> 
> 
> > On a mid term here, I think we could improve xfs(5) to include a bit more
> > information about duplicated uuids.
> > 
> 
> current text:
> 
>    Each XFS filesystem is labeled with a Universal Unique Identifier
>    (UUID).  The UUID is stored in every allocation group header and is used
>    to help distinguish one XFS filesystem from another, therefore you
>    should avoid using dd(1) or other block-by-block copying programs to
>    copy  XFS  filesystems.   If two XFS filesystems on the same machine
>    have the same UUID, xfsdump(8) may become confused when doing
>    incremental and resumed dumps.  xfsdump(8) and xfsrestore(8) are
>    recommended for making copies of XFS filesystems.
> 
> perhaps add a sentence at the end of that, "To mount a snapshot of an
> already mounted filesystem, use mount option \fBnouuid\fR."
> 
> possibly also something about this in xfs_admin(8)?
> 
> current text:
> 
>        -U uuid
>               Set  the  UUID  of the filesystem to uuid.  A sample UUID
>               looks like this: "c1b9d5a2-f162-11cf-9ece-0020afc76f16".
>               The uuid may also be nil, which will set the filesystem
>               UUID to the null UUID.  The uuid may also be generate,
>               which will generate a new UUID for the filesystem.  Note
>               that on CRC-enabled  filesystems,  this will set an
>               incompatible flag such that older kernels will not be
>               able to mount the filesystem.  To remove this
>               incompatible flag,  use restore, which will restore the
>               original UUID and remove the incompatible feature flag
>               as needed.
> 
> suggested addition: "A transient snapshot which conflicts with a mounted
> filesystem can alternatively be mounted with the option \bBnouuid\fR."
> 
> what do you think?

I think we ought to fix the informational messages in xfs_db:

"ERROR: The filesystem has valuable metadata changes in a log which
needs to be replayed.  Mount the filesystem to replay the log, and
unmount it before re-running xfs_admin.  If the filesystem is a snapshot
of a mounted filesystem, you may need to give mount the nouuid option.
If you are unable to mount the filesystem, then use the xfs_repair -L
option to destroy the log and attempt a repair.  Note that destroying
the log may cause corruption -- please attempt a mount of the filesystem
before doing this.

and xfs_repair:

"ERROR: The filesystem has valuable metadata changes in a log which
needs to be replayed.  Mount the filesystem to replay the log, and
unmount it before re-running xfs_repair.  If the filesystem is a
snapshot of a mounted filesystem, you may need to give mount the nouuid
option.  If you are unable to mount the filesystem, then use the -L
option to destroy the log and attempt a repair.  Note that destroying
the log may cause corruption -- please attempt a mount of the filesystem
before doing this."

Thanks for reporting this on the list so we can have a discussion, btw.

--D


> 
> -- 
> venleg helsing,
> Kjetil T.
> 
