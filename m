Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB2744DB68
	for <linux-xfs@vger.kernel.org>; Tue, 20 Jan 2026 15:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768924207; cv=none; b=E/LdssXhD8N5N9d2z8X6YQ72pqEXuMBcSLR1ERaiA4UI7p8kHGm9Ph1T4ZCclvNd0WNv3MAVAj+SUYjGuOdn7PZfVBcoNM5RuImQK3CYLScCsc4gqbtBm5ByTHmxPmi6BshJJEidSOCg8Ui4sluWJXn915upymlo8XeeF7VyBts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768924207; c=relaxed/simple;
	bh=KzLGa1WQ3HnXDJ6coOzb06dG/KACBoOe1HceUwJqNEg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=epKdvjIPmuWqzcv4oV1YlejqRnSCJB/vNrabJbyoxEheAxRbE+vxws1eOrFTxgtsG95VT4V93QuECOt2h0pkJhFmA6FTnfck6ROZ1CWGZTg01v6pSiDWRd+mLlyucnZ7n+i+kZ/GEGDL+DZ2X65N3nxtfcaOUdJythp6eXGI550=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h7LNmE6v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h7LNmE6v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2AE3C16AAE;
	Tue, 20 Jan 2026 15:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768924205;
	bh=KzLGa1WQ3HnXDJ6coOzb06dG/KACBoOe1HceUwJqNEg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h7LNmE6vOg+gl/b5Yp2NioiJppp0jKcE4IBEvQ6nXf3Gd//PFtFQaXLq+ngIK1Wo5
	 zdgd4aOYXqPZgflJF6m+MY7tjZ0CVONkUr5Wd8bo4O5lJ6TAmSh0AcpntlmWzeLIsI
	 V1O8AtIbRYYYfQ8IbtCnQ45BiJSU9I9S8V3tt2AF9bmkeukmH4TY7/hZkucW5ZoDXt
	 7yzJmtvKlabk2HUKyFs9CfL0KtsFaVrncLG/HvZcnvnYYrWG/9t5HUDNxocd8SgB3L
	 QhDOAz+EC0xoaplQHYD3JR04jtGe33QGC0BwhOFf9E+piZ0tzE/SKni9Ow28eCLK74
	 x9FYx5p74wjBw==
Date: Tue, 20 Jan 2026 07:50:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org,
	syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com
Subject: Re: [PATCH 3/3] xfs: switch (back) to a per-buftarg buffer hash
Message-ID: <20260120155004.GK15551@frogsfrogsfrogs>
References: <20260119153156.4088290-1-hch@lst.de>
 <20260119153156.4088290-4-hch@lst.de>
 <20260120023918.GG15551@frogsfrogsfrogs>
 <20260120070615.GB3954@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120070615.GB3954@lst.de>

On Tue, Jan 20, 2026 at 08:06:15AM +0100, Christoph Hellwig wrote:
> On Mon, Jan 19, 2026 at 06:39:18PM -0800, Darrick J. Wong wrote:
> > On Mon, Jan 19, 2026 at 04:31:37PM +0100, Christoph Hellwig wrote:
> > > The per-AG buffer hashes were added when all buffer lookups took a
> > > per-hash look.  Since then we've made lookups entirely lockless and
> > > removed the need for a hash-wide lock for inserts and removals as
> > > well.  With this there is no need to sharding the hash, so reduce the
> > > used resources by using a per-buftarg hash for all buftargs.
> > 
> > Hey, not having all the per-ag buffer cache sounds neat!
> > 
> > > Long after writing this initially, syzbot found a problem in the
> > > buffer cache teardown order, which this happens to fix as well.
> > 
> > What did we get wrong, specifically?
> 
> Dave has a really good analysis here:
> 
> https://lore.kernel.org/linux-xfs/aLeUdemAZ5wmtZel@dread.disaster.area/

Can you Link: to that in this patch?  If I'm reading linus' most recent
exposition correctly, links to other threads are still allowed.

> > Also: Is there a simpler fix for this bug that we can stuff into old lts
> > kernels?
> 
> I can't really think of anything much simpler, just different.  It would
> require some careful reordering of the unmount path, which is always
> hairy.
> 
> > Or is this fix independent of the b_hold and lockref changes
> > in the previous patches?
> 
> In theory it is, except that the old tricks with the refcount would
> make it very difficult.  I tried to reorder this twice and failed
> both times.

<nod> I figured that might be the case seeing as you cleaned up the
confusing b_hold rules.

--D
