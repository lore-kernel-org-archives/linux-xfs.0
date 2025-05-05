Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027751917D0
	for <linux-xfs@vger.kernel.org>; Mon,  5 May 2025 15:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746457669; cv=none; b=XOIYvB6JxkRmLN7xaJ60wf6WbdHnkPEK547Voepn+b8Gdx33gB8tOk1wJCigdTTHr3tk62WihH3StvYJTVzuXXgSgFgDn16gQNnlJWRPpcgAlZJ2i8oOGle7Icub58A5JDKC3c5KNAWtH3tiHSO2fR/DYigjerWm39pUnNJ7DLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746457669; c=relaxed/simple;
	bh=4MA16sBWkSXUuIAbaeYdMlVLRGU8iFmjxeiYZ5xUVh8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NKXCR6L5FBc4tlMEnyxLZd0F8R5mU4o4b0TI/6VkmLFmFqt32y2SufFC31kNEeg76xL/nDDAU+adyERIPa1sePSg09kSxEj2nQKbjaCAq0+Sy/1p6xtmUloykBL0KT2FM5FHZZTxQ2C5Zr3CbSvS0kp2NhKF1CTCNrH78LtwGa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ag531Ihh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ag531Ihh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72EE5C4CEE4;
	Mon,  5 May 2025 15:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746457668;
	bh=4MA16sBWkSXUuIAbaeYdMlVLRGU8iFmjxeiYZ5xUVh8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ag531IhhrRoDKnrljV71iUG+juROsUDBzwODYBqX50XOogwtjTt8VGXdZAgyQ+Slp
	 I6ERNq6cKgQk+c1C3qgA88vtsdvcLdR3QfNQLcFxBUUvfDhqMIv+ntbGYKgkuQMh0H
	 PuAl/56y0fte7rwmu2Y91wFyV2D5pPMlEDsQgPE+xCj9ydn5pTap2jpKFOQ1rl5bSV
	 s5FoizG7pHVmBE4uU0JcB7m+0Lhty7h/vD5oA/G+bAshgjjHLGYwdMQJZ0ywBWIhZe
	 iA3P1yAmLTL1jRRvYXls9EjFJlKGgCn9GUjuGlIULnRZVejRtDWCCfpaJ8jaM0Rz/1
	 ZMt/ZOhdsxXMQ==
Date: Mon, 5 May 2025 08:07:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't assume perags are initialised when trimming
 AGs
Message-ID: <20250505150746.GA25675@frogsfrogsfrogs>
References: <20250430232724.475092-1-david@fromorbit.com>
 <20250501043735.GZ25675@frogsfrogsfrogs>
 <Y69L1xfJ_g03wVEpWQ02-B3mbMmWNs1JE4gN1e9JKNdjFsob6HDOsxLPyEAr_-XwGA76PG90Fzb97tZxev1j4w==@protonmail.internalid>
 <aBMh3PJLrHqHGY4B@dread.disaster.area>
 <kj2yofyfvlpgigjnu4vbfzoz647ocz66snpa2hbu4fx6z36nz4@3bug7wcicpib>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <kj2yofyfvlpgigjnu4vbfzoz647ocz66snpa2hbu4fx6z36nz4@3bug7wcicpib>

On Mon, May 05, 2025 at 09:42:27AM +0200, Carlos Maiolino wrote:
> On Thu, May 01, 2025 at 05:25:16PM +1000, Dave Chinner wrote:
> > On Wed, Apr 30, 2025 at 09:37:35PM -0700, Darrick J. Wong wrote:
> > > On Thu, May 01, 2025 at 09:27:24AM +1000, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > >
> > > > When running fstrim immediately after mounting a V4 filesystem,
> > > > the fstrim fails to trim all the free space in the filesystem. It
> > > > only trims the first extent in the by-size free space tree in each
> > > > AG and then returns. If a second fstrim is then run, it runs
> > > > correctly and the entire free space in the filesystem is iterated
> > > > and discarded correctly.
> > > >
> > > > The problem lies in the setup of the trim cursor - it assumes that
> > > > pag->pagf_longest is valid without either reading the AGF first or
> > > > checking if xfs_perag_initialised_agf(pag) is true or not.
> > > >
> > > > As a result, when a filesystem is mounted without reading the AGF
> > > > (e.g. a clean mount on a v4 filesystem) and the first operation is a
> > > > fstrim call, pag->pagf_longest is zero and so the free extent search
> > > > starts at the wrong end of the by-size btree and exits after
> > > > discarding the first record in the tree.
> > > >
> > > > Fix this by deferring the initialisation of tcur->count to after
> > > > we have locked the AGF and guaranteed that the perag is properly
> > > > initialised. We trigger this on tcur->count == 0 after locking the
> > > > AGF, as this will only occur on the first call to
> > > > xfs_trim_gather_extents() for each AG. If we need to iterate,
> > > > tcur->count will be set to the length of the record we need to
> > > > restart at, so we can use this to ensure we only sample a valid
> > > > pag->pagf_longest value for the iteration.
> > > >
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > >
> > > Makes sense to me.  Please add the following trailers on merge:
> > >
> > > Cc: <stable@vger.kernel.org> # v6.10
> > > Fixes: b0ffe661fab4b9 ("xfs: fix performance problems when fstrimming a subset of a fragmented AG")
> > 
> > Those tags are incorrect. The regression was introduced by commit
> > 89cfa899608f ("xfs: reduce AGF hold times during fstrim operations")
> > a few releases before that change....
> 
> This sounds right, introduced in v6.6.
> 
> Darrick, I'll add a stable #v6.6 tag then.

Ok thanks.

--D

> > 
> > > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> > 
> > Thanks.
> > 
> > -Dave.
> > --
> > Dave Chinner
> > david@fromorbit.com
> > 
> 
