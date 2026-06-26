Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337C426ED46;
	Fri, 26 Jun 2026 05:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782452334; cv=none; b=b7TIfkn/wT5MzrtoSl9ZvyFf/QIenPem8iZx/Exe/KmzFBzP1XksyP50SQZE7+CB/1sMGF4G8B6yEay4CUMZHw+qEdC8lOyGu8vmT7inl4zqi4wgLBfvYmdq4ZLR5GZuef2bBNeujUkYCMZFSWkZbNs1L0PwkZaWevDXdjKN7lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782452334; c=relaxed/simple;
	bh=M3BEVc6kpTYWFuSxhIw16hCOS+d5IcWN0/TUy1yXdmU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rreNllE5bRN8KgNxo4UPsPTMLs5IuAmpd4wilNkL4fK85MjpUPu6cEkzRQnnKBNwBO5+awUYG3RtesaXSckW6mWTV8DqlZIGKp7Q5O22xu1exyY04Ph6NUeGcFxRKTRF6zaJsGmVds9Di02/RAn+k6HzcC4pTXRLsopeIpeFv2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8ED4B68B05; Fri, 26 Jun 2026 07:38:49 +0200 (CEST)
Date: Fri, 26 Jun 2026 07:38:49 +0200
From: Christoph Hellwig <hch@lst.de>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Christoph Hellwig <hch@lst.de>, Joanne Koong <joannelkoong@gmail.com>,
	willy@infradead.org, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/3] iomap: convert to in-iter ->iomap_next()
 model
Message-ID: <20260626053849.GA9597@lst.de>
References: <20260625024723.1611000-1-joannelkoong@gmail.com> <6446cb94-a005-4e4c-8034-d7bf2a4b402b@linux.alibaba.com> <20260625130206.GC22620@lst.de> <4da9a5ac-2a53-4fe2-9283-2e0f6181c248@linux.alibaba.com> <CAJnrk1Y_RLezfBq7sfgErGq3uT1t3czA+EWHg44zEXp9VrYF=Q@mail.gmail.com> <9bfa2c7a-1b17-41c5-9846-340e6a5b4b66@linux.alibaba.com> <20260626051004.GA8968@lst.de> <e7012eac-d10f-442d-9681-d95a791e3190@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7012eac-d10f-442d-9681-d95a791e3190@linux.alibaba.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jun 26, 2026 at 01:35:33PM +0800, Gao Xiang wrote:
> I know it's much better to "show the code" but I also think it's
> useful to comment ideas now rather than later in case that anyone
> is interested so that it could be useful for their adaption.

Sure.

> I hope I could arrange it in my formal todo list, but I've already
> had a bunch of other things (erofs fsdax dedupe support as I told
> to you since it impacts workloads, and some overlayfs improvement
> and more) in my scheduling list.
>
> Although I tend to play with this idea, it's not a blocker on
> my main interested use cases for now.  Also see if some
> complicated conversion like btrfs and f2fs can make more related
> developers interested in following this way.

Yeah.  But for now I'd like to get the relatively low hanging fruit
done.  And Joanne showed that moving from begin/end to an iter is
actually way simpler than I thought by having the iomap_process
helper that still does get callbacks, but which get inlined.  So
I'd be really happy to get this done ASAP before we get a lot more
conversions, and also to avoid having a partial transitition where
we need to keep the old ops around for too long.

After that doing the inlining as in patch 3 becomes pretty easy,
so we can do it where it matter like direct I/O.  And also once
we are down to a single callback I think we have a better baseline
for your idea.

>
> Thanks,
> Gao Xiang
---end quoted text---
