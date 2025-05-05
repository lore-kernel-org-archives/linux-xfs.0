Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A8C176AC8
	for <linux-xfs@vger.kernel.org>; Mon,  5 May 2025 07:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746430952; cv=none; b=Hiel2ruD3+fFuXjdwv8fusuSKPFnVjcxgRBKnb86y8J1tPZ0WI2eVk5/iuehaiN/6ceVGNvaOQk75+kGpQ8atfyw0/nGq0h9JqbNTaEUppkiYt/N6Jkii9QfjJPP651GVNvkiOa/OR59kLCEpDd11LERCFAENxKblvqH13dT2i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746430952; c=relaxed/simple;
	bh=p9pXspJPogTf4pzG18NtN8KCLYcueBCXKP5/qCIiJWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TfizkNpMeeUa7wyF026CpYviXTlYCsftNP86bHYEjC0kymRBk0TBkSDiemusdXOS3acmNoNYlz7rEItez8cWGRgnVh0VSWojEr8A6ufCNzEn3WV+Zkgo+9Ag5pIh1FfuvWrYy0BPwkob7DnYXxXssrYLonET+k+33m3t2xGmRA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aJp4Woq9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aJp4Woq9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0EFC4CEE4;
	Mon,  5 May 2025 07:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746430952;
	bh=p9pXspJPogTf4pzG18NtN8KCLYcueBCXKP5/qCIiJWo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aJp4Woq9NSVG9bdSFXMT7ifjY8ZtD1rKz8+P5uTUVNTw3YuMyrllCRa0airJs8Yk1
	 IPRi7Y9yRlDqx+SdvD31hc0L8ivyCYvyMPlh3O9OtNwT8L5QPNQ3K3vYFIeEaWashk
	 o0a9W/E8BqMRDtDzT4RrO23dZS81t1ejZU+Js0KxY9xDO+6Mhh6lhdrJfdnvFsnj5D
	 3qGXSXg9N0oJtex9qt8ZgRL3d5bm7XEJh34I+KcXXURUbIlrjl/2x3eIJQsA5Anc29
	 rPXdTMvLRSNphQCeIltjrxAFFvOZ7pmnjUP9vp0GvuaFHC6zj9VuzEZfGXzBc3CuqS
	 9F8txqKxnmDcw==
Date: Mon, 5 May 2025 09:42:27 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't assume perags are initialised when trimming
 AGs
Message-ID: <kj2yofyfvlpgigjnu4vbfzoz647ocz66snpa2hbu4fx6z36nz4@3bug7wcicpib>
References: <20250430232724.475092-1-david@fromorbit.com>
 <20250501043735.GZ25675@frogsfrogsfrogs>
 <Y69L1xfJ_g03wVEpWQ02-B3mbMmWNs1JE4gN1e9JKNdjFsob6HDOsxLPyEAr_-XwGA76PG90Fzb97tZxev1j4w==@protonmail.internalid>
 <aBMh3PJLrHqHGY4B@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBMh3PJLrHqHGY4B@dread.disaster.area>

On Thu, May 01, 2025 at 05:25:16PM +1000, Dave Chinner wrote:
> On Wed, Apr 30, 2025 at 09:37:35PM -0700, Darrick J. Wong wrote:
> > On Thu, May 01, 2025 at 09:27:24AM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > >
> > > When running fstrim immediately after mounting a V4 filesystem,
> > > the fstrim fails to trim all the free space in the filesystem. It
> > > only trims the first extent in the by-size free space tree in each
> > > AG and then returns. If a second fstrim is then run, it runs
> > > correctly and the entire free space in the filesystem is iterated
> > > and discarded correctly.
> > >
> > > The problem lies in the setup of the trim cursor - it assumes that
> > > pag->pagf_longest is valid without either reading the AGF first or
> > > checking if xfs_perag_initialised_agf(pag) is true or not.
> > >
> > > As a result, when a filesystem is mounted without reading the AGF
> > > (e.g. a clean mount on a v4 filesystem) and the first operation is a
> > > fstrim call, pag->pagf_longest is zero and so the free extent search
> > > starts at the wrong end of the by-size btree and exits after
> > > discarding the first record in the tree.
> > >
> > > Fix this by deferring the initialisation of tcur->count to after
> > > we have locked the AGF and guaranteed that the perag is properly
> > > initialised. We trigger this on tcur->count == 0 after locking the
> > > AGF, as this will only occur on the first call to
> > > xfs_trim_gather_extents() for each AG. If we need to iterate,
> > > tcur->count will be set to the length of the record we need to
> > > restart at, so we can use this to ensure we only sample a valid
> > > pag->pagf_longest value for the iteration.
> > >
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> >
> > Makes sense to me.  Please add the following trailers on merge:
> >
> > Cc: <stable@vger.kernel.org> # v6.10
> > Fixes: b0ffe661fab4b9 ("xfs: fix performance problems when fstrimming a subset of a fragmented AG")
> 
> Those tags are incorrect. The regression was introduced by commit
> 89cfa899608f ("xfs: reduce AGF hold times during fstrim operations")
> a few releases before that change....

This sounds right, introduced in v6.6.

Darrick, I'll add a stable #v6.6 tag then.

> 
> > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> Thanks.
> 
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
> 
