Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DBB1E2606
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 18:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773168984; cv=none; b=AGQUiVNa2vEd6xWFxfClqLfwO7+Y7CzHleUGHl8b9FO5gAmfAGCL873XLxvz8kxvOKVk4P+OOMufs5jn6YBHZ4W3ZTj2J/wwhA1rQTrBNpBQ2mAY6+4Ht5RlcxLwfE27juViNpI8+bsfedEk3xAGA864GdFla0GYbPnnsdvS+nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773168984; c=relaxed/simple;
	bh=BYnM5b+3COAJGoGXQ5jT9MMVL7oglRAeZ+IOULD6pd4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZSTcJPQCWewSEgLfs0gma69HWfgYa9gJzroF/VPqaS4jrqUJ0JMvMkx93A35VFq6TX16WWIysgBnCcr8CwxYXjGPJ+Jc98auwo688jgQiw6N8Jpjup64/BEFdkwH6W8o1caYGZ5ZcBcRemoyMQBYofHKVsExtjiW3RyPJDXpVKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aI9zytPL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aI9zytPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77499C19423;
	Tue, 10 Mar 2026 18:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773168983;
	bh=BYnM5b+3COAJGoGXQ5jT9MMVL7oglRAeZ+IOULD6pd4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aI9zytPLJCHdFbmmN/zCjUtF/417+D2ZfGtl7uFKWdoM4lBI/u7pv4mdPaGaTJZQm
	 pinK7F321e2dUcRnRXe1m5Z4vjFao6h283MmA21T5QwcU3wX3JgWc/OcL9D153BTlw
	 Li8npr3ccyZ4QE07TbmBjrCzndvg5pvWnGo7VLgHdMP35taoULpeYNRf0i37Tran+9
	 jtWw/K9oSQ/fxreb4p1IlUV6xrURnXPQ/mhFGEs5IUQGvqaqK41mstS4RhtwAecSjL
	 +Wct1+ysbrthclzkSJu9W+rwy0jkrenV9pxs6j1OcV5NuQ51KYbU6Dc/cWvGb/o5TJ
	 5092EEGk7ROHw==
Date: Tue, 10 Mar 2026 11:56:22 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/28] xfs_healer: use statmount to find moved
 filesystems even faster
Message-ID: <20260310185622.GT1105363@frogsfrogsfrogs>
References: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
 <177311401806.1183235.3840165745930552108.stgit@frogsfrogsfrogs>
 <aa_kSzpFeT7nuJeW@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa_kSzpFeT7nuJeW@infradead.org>

On Tue, Mar 10, 2026 at 02:28:43AM -0700, Christoph Hellwig wrote:
> > 
> > However, this is really slow if there are a lot of filesystems because
> > we end up wading through a lot of irrelevant information.  However,
> > statmount() can help us here because as of Linux 7.0 we can open the
> > passed-in path at startup, call statmount() on it to retrieve the
> > mnt_id, and then call it again later with that same mnt_id to find the
> > mountpoint.  Luckily xfs_healthmon didn't get merged until 7.0 so it's
> > more or less guaranteed to be there if XFS_IOC_HEALTH_MONITOR succeeds.
> > 
> > Obviously if this doesn't work, we can fall back to the slow walk.
> 
> Can we kill the fallback and instead just have a good error message
> if someone messes up their backports?

Yes we could, though the risk with dropping the previous patch is that
someone could introduce a third-party seccomp policy that forbids
statmount() even on kernels that support it, and then xfs_healer would
just fail if the mount moves.

That would be totally stupid because the only reason you'd encounter
that is because either (a) your distro screwed up their security policy
or (b) your paranoid IT department deploys an Enterprise Security Model
written by a ven-duh who hasn't gotten around to evaluating the new
syscalls and blocks anything they've not read about.

I'd rather keep the getmntent stuff around since that's the classic way
linux programs (including xfsprogs) have handled scanning the mount
tables.  But if you feel strongly about not having getmntent it's not
hard to pull it out.

On a practical note: We have 5 weeks more to wait to be sure that
STATMOUNT_BY_FD actually makes it into a released kernel.  Seeing as
xfsprogs 7.0 won't get tagged until well after that, we don't have to
decide to strip out getmntent anytime soon.

--D
