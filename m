Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C084B23E23C
	for <linux-xfs@vger.kernel.org>; Fri,  7 Mar 2025 17:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741370043; cv=none; b=TaYnuC3H/+0+bTGFcYixdFeb9Mo+JCUieWL7r3FVWG93BWmin3xwEYQDmcC7NoNie59c+IyHWc/7stW5snKJNuU/2A5YVxDZTmX2mvWFxB18E6Z8cG2Ir+aNryyJoT8B+1/hINm3kUY0E1squCMKvFNJZDaqQ+x8l2Tjv31SzfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741370043; c=relaxed/simple;
	bh=ofMhJgfVUymRj9is2e6YM0EYdf+QSwtJ3rkDTV1oXFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X7k3FRCQPRNm02drhpoEswzxK48iwG+L+5GbqSKeslu85ypwdTuCpW/QUR2iCj4kwhDnhgr6GAzyeHq3WWSTrRco6T6MdpiWABxRSS9AERlWqLod3kydK2KpFzqpsveAYYE9HfHd9wunoG2VQKgw0UQhF2icTnw8dgFiLsKiEcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eZfW2o3J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eZfW2o3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E4DC4CED1;
	Fri,  7 Mar 2025 17:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741370043;
	bh=ofMhJgfVUymRj9is2e6YM0EYdf+QSwtJ3rkDTV1oXFM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eZfW2o3J/H1xkrI7fRzWXcG6UUtk0CK8tOSidtjogH2VVhIy5YU5DfumhIh6aZ5zr
	 sCSr1cpiUmivzkwQhQIu/tlf9NUuaHQ6zWKm4Uv0hgIVm0et9eFRuDdg6e/bCZlgGD
	 UqT2K6aRPruRulX78CA+8LPnoPjSy5YAPIWteK5555WW3z24rmmpRdSf6RF20Q9772
	 TcCLDImVwAJwNujxQisSX3XmxgexY3MHSctgEp2YEaVzYRpYwncM9f1sNgZZGzRbi1
	 TNLkW0jlFMRY39C76CkRppAH/j/NtDX5PyESkOajC2ZofBJsfzXjMSMkEBB+xRGZ4F
	 4pyGiItRhGjig==
Date: Fri, 7 Mar 2025 09:54:02 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Kjetil Torgrim Homme <kjetilho@ifi.uio.no>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: nouuid hint in kernel message?
Message-ID: <20250307175402.GH2803771@frogsfrogsfrogs>
References: <Nro5gceoG1ar5vFFGSWGNwo-KlGPVYooeufy2thIqL3A5VKjZKQ0yp0kKyAxSVRiAvTm1CkpW4ITHawDjpez0A==@protonmail.internalid>
 <cbf4f4c23efba09467ca7c08e516fe8561a1f130.camel@ifi.uio.no>
 <pgirewjvggop2v2s6qrovyqr72kxfajuk2sbqlqll3facikiuu@sriorffcy3x4>
 <521200e9de4a3b789af1e2890f8a50f9612ed9c9.camel@ifi.uio.no>
 <20250306183948.GQ2803749@frogsfrogsfrogs>
 <359a0fe9a2aaa308016ca236b145feb038f07687.camel@ifi.uio.no>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <359a0fe9a2aaa308016ca236b145feb038f07687.camel@ifi.uio.no>

On Fri, Mar 07, 2025 at 08:47:08AM +0100, Kjetil Torgrim Homme wrote:
> to. den 06. 03. 2025 klokka 10.39 (-0800) skreiv Darrick J. Wong:
> > On Thu, Mar 06, 2025 at 12:36:34PM +0100, Kjetil Torgrim Homme wrote:
> > > to. den 06. 03. 2025 klokka 11.00 (+0100) skreiv Carlos Maiolino:
> > > 
> > > > On a mid term here, I think we could improve xfs(5) to include a bit more
> > > > information about duplicated uuids.
> > > > 
> > > 
> > > current text:
> > > 
> > >    Each XFS filesystem is labeled with a Universal Unique Identifier
> > >    (UUID).  The UUID is stored in every allocation group header and is used
> > >    to help distinguish one XFS filesystem from another, therefore you
> > >    should avoid using dd(1) or other block-by-block copying programs to
> > >    copy  XFS  filesystems.   If two XFS filesystems on the same machine
> > >    have the same UUID, xfsdump(8) may become confused when doing
> > >    incremental and resumed dumps.  xfsdump(8) and xfsrestore(8) are
> > >    recommended for making copies of XFS filesystems.
> > > 
> > > perhaps add a sentence at the end of that, "To mount a snapshot of an
> > > already mounted filesystem, use mount option \fBnouuid\fR."
> > > 
> > > possibly also something about this in xfs_admin(8)?
> > > 
> > > current text:
> > > 
> > >        -U uuid
> > >               Set  the  UUID  of the filesystem to uuid.  A sample UUID
> > >               looks like this: "c1b9d5a2-f162-11cf-9ece-0020afc76f16".
> > >               The uuid may also be nil, which will set the filesystem
> > >               UUID to the null UUID.  The uuid may also be generate,
> > >               which will generate a new UUID for the filesystem.  Note
> > >               that on CRC-enabled  filesystems,  this will set an
> > >               incompatible flag such that older kernels will not be
> > >               able to mount the filesystem.  To remove this
> > >               incompatible flag,  use restore, which will restore the
> > >               original UUID and remove the incompatible feature flag
> > >               as needed.
> > > 
> > > suggested addition: "A transient snapshot which conflicts with a mounted
> > > filesystem can alternatively be mounted with the option \bBnouuid\fR."
> > > 
> > > what do you think?

I think a change to xfs(5) is appropriate, because sysadmins don't
necessarily

I don't think it's necessary for the xfs_admin manpage because then we'd
have to explain that it can fail if the log is dirty (e.g. due to
snapshotting), that it's necessary to mount to replay the log, and that
there's a corner case where mount fails due to snapshots having the same
uuid... which is already going into the advisory text below.

> > 
> > I think we ought to fix the informational messages in xfs_db:
> > 
> > "ERROR: The filesystem has valuable metadata changes in a log which
> > needs to be replayed.  Mount the filesystem to replay the log, and
> > unmount it before re-running xfs_admin.  If the filesystem is a snapshot
> > of a mounted filesystem, you may need to give mount the nouuid option.
> > If you are unable to mount the filesystem, then use the xfs_repair -L
> > option to destroy the log and attempt a repair.  Note that destroying
> > the log may cause corruption -- please attempt a mount of the filesystem
> > before doing this.
> > 
> > and xfs_repair:
> > 
> > "ERROR: The filesystem has valuable metadata changes in a log which
> > needs to be replayed.  Mount the filesystem to replay the log, and
> > unmount it before re-running xfs_repair.  If the filesystem is a
> > snapshot of a mounted filesystem, you may need to give mount the nouuid
> > option.  If you are unable to mount the filesystem, then use the -L
> > option to destroy the log and attempt a repair.  Note that destroying
> > the log may cause corruption -- please attempt a mount of the filesystem
> > before doing this."
> 
> I like these texts, simple and plain spoken.  I think my extra text for
> xfs(5) is appropriate in addition to your change, the xfs_admin(8)
> addition is less obvious.

<nod> patch soon.

--D

> 
> -- 
> venleg helsing,
> Kjetil T.
