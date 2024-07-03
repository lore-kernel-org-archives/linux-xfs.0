Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7565804
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 02:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719973755; cv=none; b=oW5nwe0RyHJR+i103ayqPO+22helpMP6ke9acFK0QpplnFIosZFRwQGl7Fa+vpt5PEXgjqt0BEEMWnnavxmA0tVjTlZ5sePTCZ0eXBRKuQ4ZT3/TQind/PbAiyG1ZXEQjWBE2409Lo816MQO0esVEaCrNyZVEJDuJfFRoyFvoAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719973755; c=relaxed/simple;
	bh=MJijvm3ITVrGolxVcyY+KOj0/84mqUZSer1zYg+p8z0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bTUu42S261Joi8Td2vFFriWR63XaZtpitUimBe2643FxSkh0ZUqL8uZq9dxLjH097r1Jxupa3bo6saRZW8bmyZjhV4aib/xLPXxwsWfS5EwPkB4v/Hy34+QbLIJKFRPJFVsytIYedJCzwfa7/cziX1HoAtGmzzpY5C6cQNTO7QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cQID0QVh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cQID0QVh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E0FDC116B1;
	Wed,  3 Jul 2024 02:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719973755;
	bh=MJijvm3ITVrGolxVcyY+KOj0/84mqUZSer1zYg+p8z0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cQID0QVhDK6JvMyIcJz2dFrRO3ydYr7Zrvqn/BOGpOTUQchVgnNBOjJOaQ2kGSd9J
	 vPf03AMc5FkCtv08N3JDmuTOcZSt4AuGdKMKPw1tTOu+6DbyJBlXkb8n9iVMWgBM7r
	 pjvizi6RQ8EshZWTO7XTkKlRiCzABzPcOMrbwf8hqPK3TRgcEwtDCFq456RslkCWqt
	 8YjbRnp28pO3kUtDY+RRYXus6ikqtWeYYrpkfsDSY72ov2cZ7/jWxTF3VzZUOJ7cq7
	 OnBNhN6QvAvcup7iUhlPY3DSfCPj45RXu7bFltzSgPDbghw3KrnJpxxdyB5eYwH3mj
	 N6/nop/fpASjg==
Date: Tue, 2 Jul 2024 19:29:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs_scrub: tune fstrim minlen parameter based on
 free space histograms
Message-ID: <20240703022914.GT612460@frogsfrogsfrogs>
References: <171988118569.2007921.18066484659815583228.stgit@frogsfrogsfrogs>
 <171988118687.2007921.1260012940783338117.stgit@frogsfrogsfrogs>
 <20240702053627.GN22804@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240702053627.GN22804@lst.de>

On Tue, Jul 02, 2024 at 07:36:27AM +0200, Christoph Hellwig wrote:
> On Mon, Jul 01, 2024 at 06:04:41PM -0700, Darrick J. Wong wrote:
> > Add a new -o fstrim_pct= option to xfs_scrub just in case there are
> > users out there who want a different percentage.  For example, accepting
> > a 95% trim would net us a speed increase of nearly two orders of
> > magnitude, ignoring system call overhead.  Setting it to 100% will trim
> > everything, just like fstrim(8).
> 
> It might also make sense to default the parameter to the
> discard_granularity reported in sysfs.  While a lot of devices don't
> report a useful value there, it avoids pointless work for those that
> do.

Oooh, that's a good idea.  Let me fiddle with that & tack it on the end?

Hmm.  How do we query the discard granularity from a userspace program?
I can try to guess the /sys/block/XXX root from the devices passed in,
or maybe libblkid will tell me?  And then I'd have to go open
queue/discard_granularity underneath that to read that.

That's going to take a day or so, I suspect. :/

> Otherwise this looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
