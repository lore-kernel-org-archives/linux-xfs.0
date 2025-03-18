Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2BB1E8344
	for <linux-xfs@vger.kernel.org>; Tue, 18 Mar 2025 08:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742285454; cv=none; b=rCxUGJxsvRXzaQRp32DGPhERojd1L1zoAJtjmgCtt7ubU8ndQMXHZ+XrSS3rlRJw8aobqOSWN8zqjgZgmJ7BIMAS+ukDmAh4N2mntPZsLuE0Ibi3iOBQCtmS6moxkl0IM8rRyJ0tLOkikWnvmfFKVvsGUceeCc1RN3N+3u/dPxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742285454; c=relaxed/simple;
	bh=LwlN5dJoohUYV7ufXdVhugDyOX4JBoJwlWriFSOYPQo=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ITVpN8lTK25t/6JmJ8dq6WK6Ozz05ma++vwVbQjrCaf8eVnHE9UzI3RF7vHFY2wXDL/xels1hfk0UUJk8hp1xbU2JpRmdC7Bcc9o9dgYERtyl/Sk4Rn5OgKBqoDzNRUpd0j2vlk8HETt/v8UeybXTZM0tYktkDHDomL+0X1+4Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=atL0RVYx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="atL0RVYx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=algdgAA63BJsvssN1ruPOT0Sr53Dn5gmGgPbMWxoYiI=; b=atL0RVYxTgdkILGdQq2+0kaQ0w
	8Tj20O7+Be723qWFc9piEE8rYCLRxBy4JKzoMuCovLOrg7jvQb/iCw/Bl7MEWKDNnVy8HAaX870r0
	22B8MW5teUwYoBZFnhJY9eq3p5/GDcJEflzM54Qk/74E1mxWYCD672I17gfekiFGfRaooUDFK2Vl+
	AIOnxDqUc32S4Uc1o/H5hBiTwbAkNR56g+tXzMDegVWB8FMjLTUJAVLjBcm6wnpxnQmyNano1rWS3
	R7pucEbVSFLqtsApYau4CwuMKU2VUHOwm7qk2iWfJEOHsuTtTjE2Krao+o9E1LgnAEwguO+bNgNtL
	pdZ155Aw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tuS2H-000000056wb-0nL7;
	Tue, 18 Mar 2025 08:10:53 +0000
Date: Tue, 18 Mar 2025 01:10:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	Zorro Lang <zlang@redhat.com>
Subject: Re: [report] Unixbench shell1 performance regression
Message-ID: <Z9kqjdXM8i-7bS9o@infradead.org>
References: <0849fc77-1a6e-46f8-a18d-15699f99158e@linux.alibaba.com>
 <Z9dB4nT2a2k0d5vH@dread.disaster.area>
 <fddda0be-3679-46ae-836c-26580a8d55f4@linux.alibaba.com>
 <Z9iJgWf_RL0vlolN@dread.disaster.area>
 <b9871ab8-19c1-4708-99f7-3f91f629aeda@linux.alibaba.com>
 <Z9jFTdELyfwsfeKz@dread.disaster.area>
 <Z9jUXkfmDYc0Vlni@debian>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9jUXkfmDYc0Vlni@debian>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 18, 2025 at 10:03:10AM +0800, Gao Xiang wrote:
> Anyway, I've got the community view of Unixbench.  I will arrange my
> own TODO list.

FYI, while I agree with all of Dave's observation on Unixbench I don't
entirely agree with the conclusion.  Yes, we should not bend over
backwards to optimize for this workload.  But if we can find an easy
enough way to improve it I'm all in favour.  While everyone should
know not to do subsector writes there's actually still plenty of
workloads that do.  And while those are not the heavily optimized ones
that really matter it would still be nice to get good numbers for them.

So if you can find a way to optimize it without much negative impact
I'd love to see that.
