Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9161B7F4
	for <linux-xfs@vger.kernel.org>; Mon,  2 Feb 2026 18:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770058215; cv=none; b=feVsDLtNMEgPPSDdwlcDqkaTQug4b0kbz5R6va57PXAOQqRMvsVxJmW4pp1ka4PUouHz1e7SM23nGiKEIWEHti6LoxqNMbi4ygijB8NAW+3X7r1PKoEN7xfr/cjrBVhF6q3P8A2NpqTSlD63i22QTm/aP2YpC066WyfEP1O/PbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770058215; c=relaxed/simple;
	bh=kQtGlIMoyp76biNn64XI0FgY6iQ0BexMZuVU3Gk6cKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o2hYWK5UFbU4zGszEoxFWf3SqftfU06DWU1M4ZRR//jppt43Cp7mFx9+NpASXxvGwTYFgKsJEcj2fx9Oaax00p+vYdUftVAln8T2XIbZrf7JqI/8LZuhe34DEilOSnr5APQJmXUkxAM6ha8y74xl7YcwNw7yCMZEPiHbd7wTkuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gp/UYLdZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gp/UYLdZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82619C116C6;
	Mon,  2 Feb 2026 18:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770058214;
	bh=kQtGlIMoyp76biNn64XI0FgY6iQ0BexMZuVU3Gk6cKg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gp/UYLdZHofgtjtrzGP/IzLAoMrYCqQGAs9nV+gNZ2euh/hbISnWYLZy0DwHJ+rds
	 UETZFR7b562QZiCziW7jN4oIsvwIndK+BkkSZtPvRsVeFXqm/pPlwzuSqy8QgfSq5X
	 GyEjL5SnDO7nv8prgbrW5vsK2l1RZZVSfHHAe4XdcNsc32mk/4yP1PWoTD7SSAgHTu
	 qbJQMwkZC1u46NCa7AtXRInqh1MjnAxLQjRNYin3vMLLvzoI/fmu7ilcvmVLzPRmrT
	 nR/pvPy7oOS1RqD8mBsnPqR0Y/LSN3StiSIMeGEAKwHSdZzZyCF3S/XO03t2dfqGSr
	 wOoPm9y6hbCEw==
Date: Mon, 2 Feb 2026 10:50:13 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	cem@kernel.org
Subject: Re: [PATCH] xfs: Use xarray to track SB UUIDs instead of plain array.
Message-ID: <20260202185013.GH7712@frogsfrogsfrogs>
References: <20260130154206.1368034-2-lukas@herbolt.com>
 <20260130154206.1368034-4-lukas@herbolt.com>
 <20260130165534.GG7712@frogsfrogsfrogs>
 <aYBSzg3IhFffphuI@infradead.org>
 <698e4433ee0b01978deed124792c7e57@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <698e4433ee0b01978deed124792c7e57@herbolt.com>

On Mon, Feb 02, 2026 at 10:37:23AM +0100, Lukas Herbolt wrote:
> On 2026-02-02 08:31, Christoph Hellwig wrote:
> > On Fri, Jan 30, 2026 at 08:55:34AM -0800, Darrick J. Wong wrote:
> > > > +		xa_erase(&xfs_uuid_table, index);
> > > > +	}
> > > 
> > > Why not store the xarray index in the xfs_mount so you can delete the
> > > entry directly without having to walk the entire array?
> > 
> > Yeah, that makes a lot of sense.
> > 
> I did not want to touch the xfs_mount but if there is no objection against,
> I will add the index there.
> 
> > > And while I'm on about it ... if you're going to change data
> > > structures,
> > > why not use rhashtable or something that can do a direct lookup?
> > 
> > rhashtables require quite a bit of boilerplate.  Probably not worth
> > if for a single lookup in a relatively small colletion once per
> > mount.  But yeah, if only we had a data structure that allows
> > directly lookups without all that boilerplate..
> 
> I do not have strong preference here.

<shrug> Since the original message said "krealloc prints out warning if
allocation is bigger than 2x PAGE_SIZE", I figured that meant you were
trying to mount more than (2 * 4096) / 16 == 512 different xfs
filesystems on the same host.

I don't have a particular problem with the array search and large memory
allocation since I never mount that many filesystems, but you would
appear to be the first user to complain about a scaling limit there...

:)

--D

> -- 
> -lhe
> 
