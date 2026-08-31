Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB1E3A6EEE
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 07:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788159966; cv=none; b=pYHotURLY8ebKHgiSwv8t7adXsn2NCK4yV/xibIW0vZ67bqtQ0+Q2aF1PSAs5fJJGKHWrqrovKilIetxXnj1clESlzgexo88STyovhs/Db0XWhD+gtejmuk2GbGGZoCsn1EarxGeeOP9eyS3czSWnoNdOxj/54Mn3q45grOIRio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788159966; c=relaxed/simple;
	bh=J8NB1+/mrek7rrIjlU6pLNGqAKCysnUUKo9qnJWyaJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y4qHBkkAoNkT12a2u2dVzFLjVDMPzrNK3J46Yi+lSKKbpzGkR8y8OSrvDpOl9PusDJcl/k0USbAUkN5PsfRxPNQWFhQXpcHRIVY0DGJ0GJMJCZa+dFDOUNothsrrmiOmbj6AxTRyGrpKhx3jDS1yc2PargEjEciPiVXKQiEKa40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D25DD68BFE; Mon, 31 Aug 2026 09:05:59 +0200 (CEST)
Date: Mon, 31 Aug 2026 09:05:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: Hans Holmberg <hans.holmberg@wdc.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
	djwong@kernel.org, dlemoal@kernel.org, shinichiro.kawasaki@wdc.com,
	sashiko-bot@kernel.org
Subject: Re: [PATCH] xfs: prevent race in zoned space reservations
Message-ID: <20260831070559.GA24988@lst.de>
References: <20260826123219.73978-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826123219.73978-1-hans.holmberg@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Aug 26, 2026 at 02:32:19PM +0200, Hans Holmberg wrote:
> xfs_zoned_add_available() checks whether the reservation list is empty
> before adding blocks to the available-space counter.  This check is not
> serialized against a task adding itself to the reservation list however.
> 
> This allows the space provider to observe an empty list, after which a
> reserver can enqueue itself and retry the counter before the new space is
> added.  The provider then adds the space and returns without waking the
> now-eligible reserver, leaving it asleep until GC or another event
> provides a wakeup, potentially adding seconds to max write latency.
> 
> Take the reservation lock before updating the counter and checking the
> list.  Use list_empty() because the list is now inspected under its lock.
> 
> Taking a per-mount lock when handing back space is far from ideal, but
> benchmarking with null_blk showed no measurable performance regression.
> 

I kinda hate taking a global lock for each block free, but at least
the critical section is very small..

Reviewed-by: Christoph Hellwig <hch@lst.de>

