Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C103B6364;
	Wed,  7 Oct 2026 13:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791380830; cv=none; b=RmuJ9BEbaf5xYSY/9FtE030/1MfETnc21ylevTsTb1EYnBlWiogob9nBtOYBDFnXaFJ0UVqZYbuFd5DpKiIwKn3MLkDMWqo7cgnrWHXijnTrWB+ZnR/LTEyH1lAcayZwib+ggW8RPYz5NPjx6Kh6mLJmXmOYYwxYdt+RCITJ+UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791380830; c=relaxed/simple;
	bh=MqPVpnw8xY7tOXjDu7aM8kDKWoucXBCrQSh6s0fiBG0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e/gkL2+RFWkzNDumGUhbgQ+C5R1A7zvn73JtYlqCjocXRgkPGO36n21h6k/mkTuASEBCT0Pi7e447NUhnX0C7G/UbRc849+IV4chtWe8/X8pBoh2H+efzcGt1rJ0D+9MdRxevrcKSdTKxydUa9mwFMJrmy6y31EJmP5XggTZ14w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 11112227A8E; Wed,  7 Oct 2026 15:46:58 +0200 (CEST)
Date: Wed, 7 Oct 2026 15:46:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <dgc@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: support for RT data checksums
Message-ID: <20261007134657.GA682@lst.de>
References: <20260924100032.2733101-1-hch@lst.de> <arWpyhFyV3ouYAEx@dread> <20260925062710.GA3798@lst.de> <armf05yfzhSBUsUh@dread> <20260928052436.GA18925@lst.de> <arvHFOjF-CD5Vd3g@dread> <ary2PpSp1xTgrd3k@dread> <20261005135320.GA29829@lst.de> <asSHsVAYevL_VzdF@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asSHsVAYevL_VzdF@dread>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 06, 2026 at 04:31:29PM +1100, Dave Chinner wrote:
> I'm not sure I understand what you are refering to there. I'm not
> talking aobut the 'realloc because logged size grows', I'm talking
> aoubt 'realloc because CIL pushes steal the shadow buffer'.

So you mean alloc again, not realloc, ok.

> > with an allocation per log operation, and a memcpy both into that
> > and into the buffer, while adding a lot of new log items.
> 
> I'm not talking about an intent/done based setup - that requires an
> intent transaction, then a buffer + done transaction. That's very
> different to what I suggested (and what ICREATE implements).
> 
> I'm talking about a single one-shot transaction that logs the csums
> and that only. The buffer is ordered, so not logged. Single
> transaction, generally small in size, never gets relogged, can be
> committed asynchronously as long as it is replayed before the file
> offset relocation BMBT update in recovery.

We'd still need memory for the csum values both in the icreate
item and the ordered buffer.

> > One thing I played with for a while until I realized that the
> > simple buf item actually provides good enough performance is
> > special xfs_log_vec that is not included in the main log vec /
> > shadow allocation but points to external memory.
> 
> That's problematic. The reason delayed logging works is that it
> broke the dependency between external memory that log items pointed
> at needing to be locked and stable until the external memory was
> copied into the iclogs. The disconnection of the objects passed to
> xfs_trans_commit() vs xlog_write() whilst keeping the logged data
> stable is what allows the CIL to work

Yes, and for all the current buffers and similar items that's very
important because the data can actually change, and we must not
pick up that change.  It does however not matter much when we know
each bit of the buffer payload is only ever updated once, and thus
the is no need to double buffer or lock the backing memory.
The only important thing left with that is that the buffer as the
backing memory must not be freed.

