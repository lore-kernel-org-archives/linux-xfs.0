Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0205351C17
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 17:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772557586; cv=none; b=kPLRQO4aim5x+NuCX0RGHY4TqROSDP5jnQAj5GG9hJxZ0c8WpEprl3yAjNdk1yUMWeof60SEW2WPmaPAHpDcF0JYbBFp34N1iymY7vCMnC/F7E0vtTXceksMbwGv5qXyqcAZ4z+ouXoFUOPLqNfuE3+zdo8zbI/nRmoX/ZBXrv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772557586; c=relaxed/simple;
	bh=vyAoLeihvZ8MY6MWA90CuB9wsHyY25nB6K4h6XsbEE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cwjWzbs/cIHI8cBbW6lHTt18vncjvT/LPMuWPIj4k1cXil/BLhxtlOT/XwkRgvpk2PBBWLy9hrNDdR0eL51y+uAljN0l3Ayn+0FfShjI80wqrQ6GLg9qoUFpDc8WfZgQoZ+eo93M6oEM4+HAplXgNHHNDHDGpx+E5RHFdyF8UWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OLHuUCQP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OLHuUCQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC7EC116C6;
	Tue,  3 Mar 2026 17:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772557586;
	bh=vyAoLeihvZ8MY6MWA90CuB9wsHyY25nB6K4h6XsbEE0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OLHuUCQPIl15a+GLlVQgcqY60eRn+XaGcixEkI1wLuXAJUDZqauukx1NImAvSUQ1B
	 HgZluszs/nulIeKFoPAplOW5kvsSYuDOsoqpCTzzUjbJ8be3S23P0g1KPpG7ElrwQ7
	 cjNzdCVT4nPwLJnQfGSF0s46/F00+lJYGA1fMb5IxooOi+/60GmEDfRSeRMwtV/+r1
	 d0VVEzcrpu5Tsf7sXN1rXPsL+cA/EbxJyjQeKbXgreR2z39TfdsXVnDl3gFa5qz39t
	 3md4cVme1Vi0Ckm6bmtt72W/O7eivTGH9nw5a1H0UGa3wFiGBU+n7pqHDVEW1By6C9
	 Rv4FfbylN/C4Q==
Date: Tue, 3 Mar 2026 09:06:26 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/26] xfs_healer: create a service to start the
 per-mount healer service
Message-ID: <20260303170626.GM57948@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783527.482027.17759904859193601740.stgit@frogsfrogsfrogs>
 <aacDDXudwf9ygIkQ@infradead.org>
 <20260303165221.GK57948@frogsfrogsfrogs>
 <aacSNL9qWjo8NIo-@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aacSNL9qWjo8NIo-@infradead.org>

On Tue, Mar 03, 2026 at 08:54:12AM -0800, Christoph Hellwig wrote:
> On Tue, Mar 03, 2026 at 08:52:21AM -0800, Darrick J. Wong wrote:
> > > > +	while ((ret = syscall(SYS_listmount, &req, &mnt_ids, 32, 0)) > 0) {
> > > 
> > > Should this use a wrapper so we can switch to the type safe libc
> > > version once it becomes available?
> > 
> > What kind of wrapper?
> 
> For calling the listmount system call.
> 
> > or did you have something else in mind?  The manual page for listmount
> > says that glibc provides no wrapper[1].
> 
> Ånd there are no plans to provide one? :(  Even if so having a libfrog
> wrapper would be nice rather than open coding syscall() in at least
> two places in this series.

Oh, I see.  Yes, I could create a libfrog helper to wrap the listmount
callsites.

I can't tell what sorts of discussions glibc may or may not have had
because sourceware is barely reachable due to AIDDOS attacks or whatever
the reason du jour is, and given that the archives are pipermail they're
probably not searchable anyway. :(

Google, FWIW, shows a discussion from November 2023 that seems to have
dried up, and the glibc gitweb doesn't produce any hits for listmount or
statmount.

So my guess is that we can just make our own libfrog wrapper and if libc
support ever shows up we can always port.

--D
