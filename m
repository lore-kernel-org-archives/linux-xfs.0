Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593A63E5A16
	for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 08:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784278796; cv=none; b=oloKB4bUFM/6Hg7KlM113GSLu48Xvwt9Y9Ba/ZZ0MGBS9NCrfjHpOygLXQdmZK7ViSyYtystZx2/Sh1T5W51d1X6XX+xOusAhb5486AOu36cSEgMz2iDEFe5ziiS8bd10vd1AyZ5gnlDmo1ysqeRDUWFt+slwiC5Zpm712hL2Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784278796; c=relaxed/simple;
	bh=Zj24LnthODBIF38FGB7cl6JXa7pFuR5/AEzobEXtFbE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iR60levhwjI9RbNt/AbE5/cAuFQyrg6fSvaP6N+cO0uVl0n/whlJ6vF46wsN9ngfQXJuFaZpuFUdWcKjBkNDCwlIO9xieWAnQ2lSH2U9Ywe3Dswn/R6yjV3yVQ0wPt7rernq0kRW0wJr3mw+qpj8vVhXuoRA6C/vzTq9lKPWjJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E1CED68BFE; Fri, 17 Jul 2026 10:59:50 +0200 (CEST)
Date: Fri, 17 Jul 2026 10:59:50 +0200
From: Christoph Hellwig <hch@lst.de>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] xfs: consolidate buffer locking in
 xfs_buf_get_map
Message-ID: <20260717085950.GA32056@lst.de>
References: <20260715145147.95654-1-hch@lst.de> <20260715145147.95654-3-hch@lst.de> <aljY0uI6jY8y2b3Z@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aljY0uI6jY8y2b3Z@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jul 16, 2026 at 09:12:50AM -0400, Brian Foster wrote:
> > -	/*
> > -	 * A new buffer is held and locked by the owner.  This ensures that the
> > -	 * buffer is owned by the caller and racing RCU lookups right after
> > -	 * inserting into the hash table are safe (and will have to wait for
> > -	 * the unlock to do anything non-trivial).
> > -	 */
> >  	lockref_init(&bp->b_lockref);
> > -	sema_init(&bp->b_sema, 0); /* held, no waiters */
> > +	sema_init(&bp->b_sema, 1); /* unlocked */
> 
> Maybe I'm missing something, but I thought the point of the locked init
> was to ensure that the allocator owns the buffer and can't end up
> blocking on the lock with a racing lookup. I.e., the buffer is locked
> before it becomes available for external lookup. Do we plan to do that
> another way, or are we just dropping that assumption?

The comment has been stale for a while.  b_sema is not involved in
lookup synchronization in any way.  Only the lockref is needed to actually
get a stable buffer reference.  Once we have a stable buffer reference,
b_sema is used to protect again multiple readers trying to actually
read the data (for xfs_buf_read*), but we don't care if that is done
by the thread that allocated the buffer or not.

