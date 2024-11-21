Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0720E126F1E
	for <linux-xfs@vger.kernel.org>; Thu, 21 Nov 2024 05:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732168173; cv=none; b=YYCh919oIu4vef6Cab/MQ3QGuKMFYf4Ib4JAB+TN4eX32l+flPie1CpmpxzqiVgqqlfyeI2gAFjBqo3w8Fzxz0QNOWob+dm4A6gc8h/LNiezA2yd1bdR+KgLa0qt4L6mohMRsZIGkU7BJ0jIvQB51IejD2HapDRjxKYiWHWy4D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732168173; c=relaxed/simple;
	bh=Yy4BauqQGcmcMpJOt/RMp2ZfY9cafbieDwNirvSf754=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DJunzHFqOQcGGkfSh1GKrd07PLn1hPCuVsheY5XkVi97rBWcE5vVvO+nbp+vlEnzJbBag5B4LU83PtcQwP0oJBFQs4yVoAZylgjpsP8kXHdl6VD8hs07KlqQQM0D51wpU7K+5Kk788zPy0Ch0lvX+qLG26VnsAWf0M5FC/HhM3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HJ0rosgv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HJ0rosgv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NkR5C1HDi3hENmWtC2HFt3L7AxCu+xB16OZiNKxy99A=; b=HJ0rosgv8F6Fq2pL8XvmApmwVY
	SM2pOgPJR9FTjsqxqlec6/XMiiIesRBi6jEQXU+Zo0qkgcJC5NPAg4DKqk59QoBw5x+6iI2wKX+ga
	eerO8wIilApM9YGM9wjshlACDWvDDj8t0sAdLjV0Odfvu1Y30dcb/x29eNHIc73y+FJzTc45dPUet
	pGf2ckkIGWmEB8XFFVynKszo1w/PiVAAZ8cPKwm2/mlzrs72QYqM9IUvnwfmuwpSRlzZ/cH+koekF
	bGrzwdPl0TTdTbJ5QUUheViqIEhpfjhJbpxp7qBHkq4DVAsD4mk0b18wM3QbCsutAaloSMBC9Ibu2
	f8pDGXHA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tE04H-0000000Gsh3-2PTD;
	Thu, 21 Nov 2024 05:49:29 +0000
Date: Wed, 20 Nov 2024 21:49:29 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Long Li <leo.lilong@huawei.com>,
	brauner@kernel.org, djwong@kernel.org, cem@kernel.org,
	linux-xfs@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com,
	yangerkun@huawei.com
Subject: Re: [PATCH v2 1/2] iomap: fix zero padding data issue in concurrent
 append writes
Message-ID: <Zz7J6SwSRVQrGNMH@infradead.org>
References: <20241113091907.56937-1-leo.lilong@huawei.com>
 <ZzTQPdE5V155Soui@bfoster>
 <ZzrlO_jEz9WdBcAF@infradead.org>
 <ZztOpQwU0pRagGwU@bfoster>
 <Zz2mTCq03SEjoUZV@infradead.org>
 <Zz3pNTDwYImhuAkV@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zz3pNTDwYImhuAkV@bfoster>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Nov 20, 2024 at 08:50:45AM -0500, Brian Foster wrote:
> On Wed, Nov 20, 2024 at 01:05:16AM -0800, Christoph Hellwig wrote:
> > On Mon, Nov 18, 2024 at 09:26:45AM -0500, Brian Foster wrote:
> > > IOW following the train of thought in the other subthread, would any
> > > practical workload be affected if we just trimmed io_size when needed by
> > > i_size and left it at that?
> > 
> > Can you explain what you mean with that? 
> > 
> 
> I mean what happens if we trimmed io_size just as this patch already
> does, but left off the rounding stuff?

Ah.

> 
> The rounding is only used for adding to or attempting to merge ioends. I
> don't see when it would ever really make a difference in adding folios
> to an ioend, since we don't writeback folios beyond i_size and a size
> extending operation is unlikely to write back between the time an ioend
> is being constructed/trimmed and submitted.

True.

> After discussion, it seems there are some scenarios where the rounding
> allows i_size trimmed ioends to merge, but again I'm not seeing how that
> can occur frequently enough such that just skipping the rounding and
> letting trimmed ioends fail to merge would have any noticeable
> performance impact.

Agreed.

> But anyways, I think we've reached compromise that pulling the rounding
> helper into buffered-io.c and documenting it well preserves logic and
> addresses my concerns by making sure it doesn't proliferate for the time
> being.

I mean if we can do away without the rounding I'm fine with it.

Looking at fs/iomap/buffered-io.c I think we should be fine with
it, and in XFS everything but the size updaste itself converts to
FSBs first, so it should be fine as well.

