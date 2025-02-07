Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7F9232392
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738902524; cv=none; b=KunHlVuQ54Cn5EF84UbdpLr1CQGYExATRSTWMzX5qWSNZVQg39aV7gXAEt4l4V6qhRyJNKboqeSWHo1PIXOH0TacJOnUnBf9+uGYZwBihz5JbZG1/j9qBFX1b/1/WHJ5Qw96wnUJHhWqjgCjDPDNWaE2Itl5mE/t/U7mRvvwVP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738902524; c=relaxed/simple;
	bh=zPycE+jh2bBcj6BuOrxxqoZ05YwBOq8EiNaH2HikBCY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pRbpp6CgFC/FYHVmCa11K3nxJE+IBam6kDYpxWB4RIbphrrx5rdAVX8dHcGPK21mdWd8KqNTf+k/Pc9gGvMvvAmhcqlcstPcsFaa9YX+dGyUp06TsuPH44ybMfUkuLTj8gqRBfsFUnzAZuUMF/P0DEx/bJyD1jQzE2EamRrBfjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QIkEaM3l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QIkEaM3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7DDC4CED1;
	Fri,  7 Feb 2025 04:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738902520;
	bh=zPycE+jh2bBcj6BuOrxxqoZ05YwBOq8EiNaH2HikBCY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QIkEaM3lqxs5xjhAQ2PSd2O3Wy5soqzGVXIGN5QEhLRoTcvutHSbIKpMAygiFDaOH
	 h0dF45DkmsSRWKECGYpj00lqPc+IXQyC5USthcPdgxJlfw+8rVvotZxDO0iHfi561Q
	 qo4e4lbHAK8vys7G93izWWFbKtTVWNgNTBO0i5IwiRqmjKbndPbhReQTj1xFLITyIo
	 doQV+I3qlBKHy+5lyTg9s9Ni+zRgoPs5m5lB276NSroIEWycl6lzlQFMoKIiuBEvg5
	 kduI7gvanhD4+YKqq/1lA5wEVXj7BJQOA8uiN9M0ZSTWsxg+GXl4QKhF9uczPPqvN1
	 ko5+EI/OQ7tgg==
Date: Thu, 6 Feb 2025 20:28:40 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/43] xfs: generalize the freespace and reserved blocks
 handling
Message-ID: <20250207042840.GK21808@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-7-hch@lst.de>
 <20250206212942.GT21808@frogsfrogsfrogs>
 <20250207042155.GF5467@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250207042155.GF5467@lst.de>

On Fri, Feb 07, 2025 at 05:21:55AM +0100, Christoph Hellwig wrote:
> On Thu, Feb 06, 2025 at 01:29:42PM -0800, Darrick J. Wong wrote:
> > > Use helpers to access the freespace counters everywhere intead of
> > > poking through the abstraction by using the percpu_count helpers
> > > directly.  This also switches the flooring of the frextents counter
> > > to 0 in statfs for the rthinherit case to a manual min_t call to match
> > > the handling of the fdblocks counter for normal file systems.
> > 
> > It might've been nice to split the m_resblk and the freecounter wrapping
> > into two smaller patches, but I can also see that it makes sense to do
> > both together.
> 
> So you want separate patches for the percpu counters and reservations?
> I could look into that, but I'm not sure it really helps understanding
> the logic.

Yeah, it would more help the part of my brain that reviews mechanical
changes by storing up to about 4 X -> Y transitions and making sure
that's the only thing I see in the patch.  Once I go above 4 my brain
fills up and I have to start paging like Windows 95.

> But thinking about it we should probably have one array
> of structures with the percpu counters and reservations anyway, so
> if I redo this anyway I might be able to split it up a little more.

Might be useful, particularly if it gets the two counters away from each
other on a busy filesystem.

--D
