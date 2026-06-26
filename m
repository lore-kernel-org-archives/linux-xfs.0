Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B7E23BD1B;
	Fri, 26 Jun 2026 05:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782450609; cv=none; b=K97jE8NGiGis+KxsUKqzXVRPvi5JB5DmjYEhHieF1X+CBv6RP1fnuUq97kjkUrf/W2L3/0cj8iHhIvBQXMuH3lVxwspZRrevXNnvWQ5FxdHQbkIxt7rvSq/0gmp56xLQ704+qTJwXQC41kWQ2r0v636XuLblVXNRRNawUqTkW6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782450609; c=relaxed/simple;
	bh=/4Z9K8L5dBdaMqtb68qN5FdaLB0mItREaS683Gr6ai8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QtlfSbkXGYWcr8TvPqw2xyeYSESoYMboWHboWryTJv3iB+wWaqHAx/qdg3iSWJMHM+v18/+PUMH/RuPRHH0GAYcnfU30Xhn15PUTzlLKBR5nNAzwjZyXgZmhAl9o1QxjB1YcUBYHsauWWBfgfaTrfz4Z8Waw8XM5A73kFtU2csg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E5D8D68B05; Fri, 26 Jun 2026 07:10:04 +0200 (CEST)
Date: Fri, 26 Jun 2026 07:10:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Joanne Koong <joannelkoong@gmail.com>, Christoph Hellwig <hch@lst.de>,
	willy@infradead.org, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/3] iomap: convert to in-iter ->iomap_next()
 model
Message-ID: <20260626051004.GA8968@lst.de>
References: <20260625024723.1611000-1-joannelkoong@gmail.com> <6446cb94-a005-4e4c-8034-d7bf2a4b402b@linux.alibaba.com> <20260625130206.GC22620@lst.de> <4da9a5ac-2a53-4fe2-9283-2e0f6181c248@linux.alibaba.com> <CAJnrk1Y_RLezfBq7sfgErGq3uT1t3czA+EWHg44zEXp9VrYF=Q@mail.gmail.com> <9bfa2c7a-1b17-41c5-9846-340e6a5b4b66@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9bfa2c7a-1b17-41c5-9846-340e6a5b4b66@linux.alibaba.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jun 26, 2026 at 10:22:17AM +0800, Gao Xiang wrote:
> It's just my rough thought, as I said in the previous year, I
> still don't have a strong tendency but it's my suggestion over
> these years.
>
> Anyway since you're actively working/changing on iomap, so
> it's fine to just respect your ideas/efforts if you don't
> think it's worth, but as a record of my thoughts here again.

This does sound like a lot of work, and I'm not a 100% sold on
the benefits, although getting rid of callbacks would be nice.

I'd be tempted to say that as a first step we should move the the
single callback, as a second stop (after converting everyone to
the single callback) to inline for performance critical path, and
then see if we can massage it into a pure iterator without much
downside instead of trying to do everything at once.

As you seem to have the strongest opinion here, I'd love to see
a proof of concept from you to get everyone excited.

