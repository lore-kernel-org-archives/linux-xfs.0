Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECE1340DA4
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 13:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214995; cv=none; b=H0aaRI/HPO35lYoR+xgUyLFSbX7uBC8PLOOZHGL2oiDpb6KG0qnse/aaMFSdjkCvLTFoC/n4ZfA8v+xF0zfhUGwJ5bMuP1lY6d8zNMdcTRlfou4rdrC6Pwfejo7jYfXHHJa9OwaT38O7koO5UGj+YORCcJZZ+PqJ+XEGsfa/3To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214995; c=relaxed/simple;
	bh=LXVk3cLsEzeFBGO1Fk6D6oFqDHqOQ5Kb7oKLIXDBgDk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Olsdy3mEx9cdZTRqexDadB33IHPsF9Z7Cet9psgNm+KBa9tPGIBfDEaSxnhz4WgKm9q3n8YQXM42OQ/lj85sM+rXF3liAkW4LQi762fzlrImilZ7ppiyTJ+M6FEjHdDh5RFGYZD9SPALMqou1b5vAv3eVzqLm7rq3tY6P8CACiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 93FCE67373; Tue, 26 Aug 2025 15:29:49 +0200 (CEST)
Date: Tue, 26 Aug 2025 15:29:48 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: track the number of blocks in each buftarg
Message-ID: <20250826132948.GB1946@lst.de>
References: <20250825111944.460955-1-hch@lst.de> <20250825111944.460955-2-hch@lst.de> <aK1JWBw72zzC1uvN@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aK1JWBw72zzC1uvN@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 26, 2025 at 03:42:48PM +1000, Dave Chinner wrote:
> > +	/*
> > +	 * Grow can change the device size.  Mirror that into the buftarg.
> > +	 */
> > +	mp->m_ddev_targp->bt_nr_blocks = mp->m_sb.sb_dblocks;
> > +	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp)
> > +		mp->m_rtdev_targp->bt_nr_blocks = mp->m_sb.sb_dblocks;
>                                                               ^
> That's not right.

Indeed.  It reverts us to the current state without this patch if
someone does a growfs :)

> Perhaps we need some growfs crash/recovery tests to exercise this
> code....

This code is exercises by the RT/zoned growfs tests.  However as the
only RT metadata buffer is at block 0 nothing will notice a wrong
value here (which is also the reason why the current state of this
that hardcodes the sb_dblocks check actually works).

