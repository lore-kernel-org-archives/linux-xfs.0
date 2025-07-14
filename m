Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C378C13B;
	Mon, 14 Jul 2025 05:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752472430; cv=none; b=lhKrjHSNiQ+xg722l0fZf6sudMZhVJGk707IQLhM8wXhJ8TKfzXCpdzd5luWf5k3ddfk+hgY/EWKlKYpZ1RqdqVx743Mc+Sh49IEQejvIFNDq1nGL/wbCo9Qzrfs8NrBGucfBfsy8QIZRtscGo+NmOO68H6SwfU9lLQ9dF6sgrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752472430; c=relaxed/simple;
	bh=nzVIWQotXzvOVvdbcH+aGWC4scCIOpcd6RbOnD+5JXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u5N7Y2kv46il9vQfpAa6PRnNBPeAmAfYTj/dXQjhwkptOL3N0EJ82AYn7jd7XDtadqKn3U/r+IrBcrHrE5WmQmQ9HpogxAuIhovlmRf8uds3eqpdPK7pDN7kU/wItsv2nQVrk8wikfm3yUN8H+qdVx+DZ7TQKF2pI6HxNMJuTM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DF74067373; Mon, 14 Jul 2025 07:53:38 +0200 (CEST)
Date: Mon, 14 Jul 2025 07:53:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
	yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com,
	axboe@kernel.dk, cem@kernel.org, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-block@vger.kernel.org, ojaswin@linux.ibm.com,
	martin.petersen@oracle.com, akpm@linux-foundation.org,
	linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v6 0/6] block/md/dm: set chunk_sectors from stacked dev
 stripe size
Message-ID: <20250714055338.GA13470@lst.de>
References: <20250711080929.3091196-1-john.g.garry@oracle.com> <f80713ec-fef1-4a33-b7bf-820ca69cb6ce@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f80713ec-fef1-4a33-b7bf-820ca69cb6ce@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 11, 2025 at 05:44:26PM +0900, Damien Le Moal wrote:
> On 7/11/25 5:09 PM, John Garry wrote:
> > This value in io_min is used to configure any atomic write limit for the
> > stacked device. The idea is that the atomic write unit max is a
> > power-of-2 factor of the stripe size, and the stripe size is available
> > in io_min.
> > 
> > Using io_min causes issues, as:
> > a. it may be mutated
> > b. the check for io_min being set for determining if we are dealing with
> > a striped device is hard to get right, as reported in [0].
> > 
> > This series now sets chunk_sectors limit to share stripe size.
> 
> Hmm... chunk_sectors for a zoned device is the zone size. So is this all safe
> if we are dealing with a zoned block device that also supports atomic writes ?

Btw, I wonder if it's time to decouple the zone size from the chunk
size eventually.  It seems like a nice little hack, but with things
like parity raid for zoned devices now showing up at least in academia,
and nvme devices reporting chunk sizes the overload might not be that
good any more.

> Not that I know of any such device, but better be safe, so maybe for now
> do not enable atomic write support on zoned devices ?

How would atomic writes make sense for zone devices?  Because all writes
up to the reported write pointer must be valid, there usual checks for
partial updates a lacking, so the only use would be to figure out if a
write got truncated.  At least for file systems we detects this using the
fs metadata that must be written on I/O completion anyway, so the only
user would be an application with some sort of speculative writes that
can't detect partial writes. Which sounds rather fringe and dangerous.

Now we should be able to implement the software atomic writes pretty
easily for zoned XFS, and funnily they might actually be slightly faster
than normal writes due to the transaction batching.  Now that we're
getting reasonable test coverage we should be able to give it a spin, but
I have a few too many things on my plate at the moment.
