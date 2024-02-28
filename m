Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E52F1E4A8
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 16:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709139148; cv=none; b=JG4dGgtkddtoFuDNmC4cyObai/6UWnSzah0R2iBkicZQDZeAnQD2WfVI90GLrAM3uRjxaFZ1mjvatJ2C7GqmCf17M1Y90J6E5NqQYvjvROC4P0MxuRYBMPgmAOwsAlybLE7i7N8vHW7UaXVMGJhfMt1nCyeU0sboG5dDAOfareU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709139148; c=relaxed/simple;
	bh=aum1jmUrDMyK4Wq9shgxJqNqnJ/8y0PLvqH2hl94Gmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=droQQ8u93xJJhaW4WQb+EH+m+dOw+4eLmM20pcSHhJGn64j0aQfNMaQTHus8VN72TRIXmKdZg8Q+akWTajOnZl5xZEz05Afh2Dfm56Z3+N+3YVNuafwrlx+ErQ8q5FrkOkr2BZ7BZsLv4FGxUtDGBrAlxVAFS1kk67367X5hFr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eyVpJtqH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eyVpJtqH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDD9C433F1;
	Wed, 28 Feb 2024 16:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709139147;
	bh=aum1jmUrDMyK4Wq9shgxJqNqnJ/8y0PLvqH2hl94Gmw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eyVpJtqHepuOy7GEW9LmKgAdTf7vUHYTvu7eCKKusKtPmL6zcyVDhIJowihus3q0m
	 erVC/O8cg+GngEtF5yvX0PNk3Xj6UY8o3n7Tr1YVFwEVmDBuG6aEYAoZj8OHBmB1GF
	 EgHUMblHgN3M3cw0i46bsk12yLy0c9c3o8PlLfxdx5MzLGgpK76iENxjCi+kok/kOB
	 +4NDg7HNALHl/XJEKobUT+pgjIqae/pKDS0VL8JCpW9sqYbnfpeQr+NSJepzG9pZwf
	 j52nhbBhelNuAshIG4Mcf81YiTfPvlqPwTPIaMcnQfLP2gc2h/i7oPD1Wqq1ltepU8
	 4XHWeTUwx5KGQ==
Date: Wed, 28 Feb 2024 08:52:27 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: hide private inodes from bulkstat and handle
 functions
Message-ID: <20240228165227.GH1927156@frogsfrogsfrogs>
References: <170900012206.938660.3603038404932438747.stgit@frogsfrogsfrogs>
 <170900012232.938660.16382530364290848736.stgit@frogsfrogsfrogs>
 <Zd4mxB5alRUsAS7o@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zd4mxB5alRUsAS7o@infradead.org>

On Tue, Feb 27, 2024 at 10:15:32AM -0800, Christoph Hellwig wrote:
> On Mon, Feb 26, 2024 at 06:24:46PM -0800, Darrick J. Wong wrote:
> > Callers are not allowed to link these
> > files into the directory tree, which should suffice to make these
> > private inodes actually private.
> 
> I'm a bit confused about this commit log.  The only files with
> i_nlink == 0 that can be linked into the namespace or O_TMPFILE
> files that have I_LINKABLE.
> 
> The only think that cares about S_PRIVATE are the security modules
> (and reiserfs for it's own xattr inodes).
> 
> So I think setting the flag is a good thing and gets us out of nasty
> interaction with LSMs, but the commit log could use a little update.

How about:

"We're about to start adding functionality that uses internal inodes
that are private to XFS.  What this means is that userspace should never
be able to access any information about these files, and should not be
able to open these files by handle.

"Callers must not be allowed to link these files into the directory
tree, which should suffice to keep these private inodes actually
private.  I_LINKABLE is therefore left unset.

"To prevent mis-interactions with LSMs, and the rest of the security
apparatus, set S_PRIVATE."

--D
