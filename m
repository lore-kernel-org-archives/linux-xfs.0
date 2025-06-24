Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA71139E
	for <linux-xfs@vger.kernel.org>; Tue, 24 Jun 2025 13:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750773467; cv=none; b=gbsNgMxvXKxtUGJhrTS5I8hS+W2+YYqeIxrSl+wmj27SqvQm1iQENdvDmGQ6JFiKFfUY94PYEABtKXbE1wOlfoXVO4lsDn9ZUKU4XEeBrSFzJh/fhZzOh4D0Qm3/kbhEs9JO2LKAJL6U3ntO9T+EdLmqv0MT9cAZ2TNAUs95bQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750773467; c=relaxed/simple;
	bh=cqKikMJxTIk2Uh1msuUvGEsOYKMHhuaNeygml9Ys0TU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hfMKjKw1rR40xEklKVmAAQGfR7NJTjkpWvIkJmjr1sAB2gbmqTE89BKeHfULwrmPTjDGp/Eyx4eJ0KWyUILpwsE9r7N+trS4vaqeqBpvKf3xswG8BormSslzijl5MuJ4fTD6zI5UAxw96WRWXGhX6rLUaKpdeZgCTnQIPWwyvSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2C05368AFE; Tue, 24 Jun 2025 15:57:41 +0200 (CEST)
Date: Tue, 24 Jun 2025 15:57:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
	djwong@kernel.org
Subject: Re: [PATCH 1/2] xfs: replace iclogs circular list with a list_head
Message-ID: <20250624135740.GA24420@lst.de>
References: <20250620070813.919516-1-cem@kernel.org> <20250620070813.919516-2-cem@kernel.org> <aFoKgNq6IuPJAJAv@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFoKgNq6IuPJAJAv@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 24, 2025 at 12:16:32PM +1000, Dave Chinner wrote:
> Hence I think that the ring should remain immutable and the
> log->l_iclog pointer retained to index the first object in the ring.
> This means we don't need a list head in the struct xlog for the
> iclog ring, we can have the ring simply contain just the iclogs as
> they currently do.

Alternatively do away with the list entirely and replace it with
an array of pointers, i.e.

	struct xlog {
		...
		struct xlog_in_core	*l_iclog;
		struct xlog_in_core	*l_iclogs[XLOG_MAX_ICLOGS];
	};

static inline struct xlog_in_core *
xlog_next_iclog(
	struct xlog_in_core	*iclog)
{
	if (iclog == iclog->ic_log->l_iclogs[log->l_iclog_bufs - 1])
		return iclog->ic_log->l_iclogs[0];
	return iclog + 1;
}

and the typical loop become something like:

	struct xlog_in_core	*iclog = log->l_iclog;

	do {
		...
	} while ((iclog = xlog_next_iclog(iclog)) != log->l_iclog);


