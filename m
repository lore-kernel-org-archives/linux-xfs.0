Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCE42253A1;
	Thu, 25 Jun 2026 13:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392531; cv=none; b=uCSFoW4Xp57aHmXlITbVerwI+jzLEydd29j/LSTyYKyt4EeihZQ3bxIHkn7DwHJdK7h2OZo88ZB37mPFXZB3xZQjrgirctIpjHixz30WXU436z+mFE6Q9tt/5sKiaXM9unixVPbFn0n3YCWcD4/Oq0oQy4M57fZjONf4ifgD/e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392531; c=relaxed/simple;
	bh=YCQ8N3qDlsCBXdm62lyVQ7U1NnSDDXP1xMKAjpcoSSw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p7GzmZ4sLP2TBSGA+6rwvA0VpqN8t0fXJSFdPRIOdFX72Axc5N7YKOBuEh7DhTwuFCTI3wND4EFy3+3H1sjJLmxJtChQwu57BtM00p42ukr3AfSSLXF9fsdArCjeQZ/qInXkpLaQl9jVKzUnH+HaHw2orZPY30oJ9XjXVMtmJ1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 70F8768B05; Thu, 25 Jun 2026 15:02:07 +0200 (CEST)
Date: Thu, 25 Jun 2026 15:02:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Joanne Koong <joannelkoong@gmail.com>, hch@lst.de, willy@infradead.org,
	djwong@kernel.org, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/3] iomap: convert to in-iter ->iomap_next()
 model
Message-ID: <20260625130206.GC22620@lst.de>
References: <20260625024723.1611000-1-joannelkoong@gmail.com> <6446cb94-a005-4e4c-8034-d7bf2a4b402b@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6446cb94-a005-4e4c-8034-d7bf2a4b402b@linux.alibaba.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 25, 2026 at 11:25:54AM +0800, Gao Xiang wrote:
> As I mentioned a year ago, I really hope this way can be proceed
> to avoid iomap iter-callback models:
>
> https://lore.kernel.org/r/20250905152118.GE1587915@frogsfrogsfrogs

Oh, I guess this is where passing the iomap and srcmap separately
from the iter come from.  But for this to make sense we'd have to
be able to pass a const iter.

