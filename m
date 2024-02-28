Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C522B13D2E8
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 23:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709163991; cv=none; b=WYiCkMM3VdiiKNsubWhAarTC2/YzQ1PPa3J1f5ewjXf2l/W9Nhna2kalUiMDx15Ng678UKsm57xL+GcCixFnGkEuhDyOTAbLs/hARtigYR11g2//xj+hKl+hdpi0AjefLUIdm8GL8wBJm3LHdBB4GzWzCW3Tee+o21J6OKooSgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709163991; c=relaxed/simple;
	bh=G5WLoLM0t2VAEQ971UN1015iYJdotWHn54XUfnau1J0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z8eePj6n+jU8webGGGAoR4UDDOqq91pdk6/7KDVbF3x2l9I/EE6ysmbWaj9CSXeZldJFz/EYcfne4z8mJbYo0/+BnChTgFHoEKqpsa5cCcm9stEubKuPYp6mJ/ncWKYO3qCZBE/aYBzanLVaPNZg5vnN2eynZTbhvtSnYP9msbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZJz8WDbu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZJz8WDbu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F10C433F1;
	Wed, 28 Feb 2024 23:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709163991;
	bh=G5WLoLM0t2VAEQ971UN1015iYJdotWHn54XUfnau1J0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZJz8WDbujpkKCYq+K0DXN1aNL3h7glWY9Jcs6niSU7PDkl4oHH/itC76QlolyMZIr
	 3Ut1fEZ/12WAMhoRlhinKcfL4LmJyu3ETewOEhGilvD3CpFEBpXUl3gWCEAVEGdWem
	 8v66Kb7Y073avUhYbML+PY+Z2GhXi099xY2SzyU1Uf1oLnCv7ma3xkOZDlWKMV0OWs
	 5Wff3bTQjC5qZFGz5V0c4rSJQFWqbv0EPLRCpqLtHF43ErODm8nf2/LQnegRJP9gRF
	 6IBpDFuEN9h3/XFnMbxmOFB+LNFCuunnAi1xGe2TsKODsQMTAWuly3t4Aa+A1ZveH+
	 Ob19ATGfHcT0g==
Date: Wed, 28 Feb 2024 15:46:30 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: online repair of symbolic links
Message-ID: <20240228234630.GV1927156@frogsfrogsfrogs>
References: <170900015254.939796.8033314539322473598.stgit@frogsfrogsfrogs>
 <170900015273.939796.12650929826491519393.stgit@frogsfrogsfrogs>
 <Zd9sqALoZMOvHm8P@infradead.org>
 <20240228183740.GO1927156@frogsfrogsfrogs>
 <Zd-BHo96SoY4Camr@infradead.org>
 <20240228205213.GS1927156@frogsfrogsfrogs>
 <Zd-vaC5xjJ_YgeD6@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zd-vaC5xjJ_YgeD6@infradead.org>

On Wed, Feb 28, 2024 at 02:10:48PM -0800, Christoph Hellwig wrote:
> On Wed, Feb 28, 2024 at 12:52:13PM -0800, Darrick J. Wong wrote:
> > I overlooked something this morning -- if the caller passes in
> > XFS_SCRUB_IFLAG_FORCE_REBUILD, that might be the free space defragmenter
> > trying to get us to move the remote target block somewhere else.  For
> > that usecase, if the symlink scrub doesn't find any problems and we read
> > in exactly i_size bytes, I think we want to write that back to the
> > symlink, and not the DUMMY_TARGET.
> 
> Yes, I think we really want that :) 

I'm glad we agree.

> > Something like:
> > 
> > 	if (FORCE_REBUILD && !CORRUPT) {
> 
> Maybe I need to read the code a little more, but shouldn't this
> simply be !corrupt?  Or an assert that if it is not corrupt it is
> a force rebuild?  Or am I missing a use case for !corrupt &&
> !force_rebuild?

Hmmmm.  You're right, I think that should merely be !corrupt.

I was trying to be cautious by checking FORCE_REBUILD, but there are
other ways to end up in repair -- if something sets PREEN, for example.
That won't happen for symbolic links (at least not today) but I could
also not leave such a logic bomb. :)

> > 	/*
> > 	 * Change an empty target into a dummy target and clear the symlink
> > 	 * target zapped flag.
> > 	 */
> > 	if (target_buf[0] == 0) {
> > 		sc->sick_mask |= XFS_SICK_INO_SYMLINK_ZAPPED;
> > 		sprintf(target_buf, DUMMY_TARGET);
> > 	}
> > 
> > Can we allow that without risking truncation making the symlink point to
> > some unintended place?
> 
> I can't think of anything that would truncated it, what do you have in
> mind?

I think the answer to my question is "No".

If scrub (or the regular verifiers) hit anything, then we end up in
symlink_repair.c with CORRUPT set.  In this case we set the target to
DUMMY_TARGET.

If the salvage functions recover fewer bytes than i_disk_size, then
we'll set the target to DUMMY_TARGET because that could lead to things
like:

0. touch autoexec autoexec@bat
1. ln -s 'autoexec@bat' victimlink
2. corrupt victimlink by s/@/\0/g' on the target
3. repair salvages the target and ends up with 'autoexec'

Alternately:

0. touch autoexec autoexec@bat
1. ln -s 'autoexec@bat' victimlink
2. corrupt victimlink by incrementing di_size (it's now 13)
3. repair salvages the target and ends up with "autoexec@bat\0"

In both of those cases, something's inconsistent between the buffer
contents and di_size.  There aren't supposed to be nulls in the target,
but whatever might have been in that byte originally is long gone.  The
only thing to do here is replace it with DUMMY_TARGET.

If salvage recovers more bytes than i_disk_size then we have no idea if
di_size was broken or not because the target isn't null-terminated.
In theory the kernel will never do this (because it zeroes the xfs_buf
contents in xfs_trans_buf_get) but fuzzers could do that.

So yeah, I think the salvage code should be:

	buflen = 0;

	if (!(sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)) {
		if (sc->ip->i_df.if_format == XFS_DINODE_FMT_LOCAL)
			buflen = xrep_symlink_salvage_inline(sc);
		else
			buflen = xrep_symlink_salvage_remote(sc);
		if (buflen < 0)
			return buflen;

		/*
		 * NULL-terminate the buffer because the ondisk target does not
		 * do that for us.  If salvage didn't find the exact amount of
		 * data that we expected to find, don't salvage anything.
		 */
		target_buf[buflen] = 0;
		if (strlen(target_buf) != sc->ip->i_disk_size)
			buflen = 0;
	}

	/*
	 * Change an empty target into a dummy target and clear the symlink
	 * target zapped flag.
	 */
	if (buflen == 0) {
		sc->sick_mask |= XFS_SICK_INO_SYMLINK_ZAPPED;
		sprintf(target_buf, DUMMY_TARGET);
	}

--D
