Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38C73BA237;
	Fri, 20 Mar 2026 14:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774016849; cv=none; b=JYva9nOUF/30K8H40BmNnljy+t2kKeRJASizgQ5N26A60BRMv1DAytmdnQeFn7V2qwILPtV0c+wDMp6mR4MTNRAMkK5exqctYdX4pvbxX5hqV18i1nc/aHY16z0layukum6OZILyZzzdyZYzpWOqoI/+A3lNLDgg5Twxkk3c50o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774016849; c=relaxed/simple;
	bh=6q1yxC0tfBQVrkOe+6H0/zTRH/O4MP+M0GPDMCS9zEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oSyrpqxEKFzVFTk4eXzhNp9tj/gkCVm9/aEV+Z/FYTwETtz4DE7qC4zhVmuqZKIZGQx9lDAXn3TcHy8NDT9q4A2MrmZuFCxU9x9uBYnLCWHAGu+tyayND9cKkOn0KS9Iy0eVhVrEJ6fG2lWgui6hbjHCyR5OtfXSKz1ujUXTwIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uOBIGk+1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uOBIGk+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5052AC4CEF7;
	Fri, 20 Mar 2026 14:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774016849;
	bh=6q1yxC0tfBQVrkOe+6H0/zTRH/O4MP+M0GPDMCS9zEY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uOBIGk+120PUKUzaWVw4jHIoLxUElcGJihU4rYS42udgQD3N5sZay2Mqik87OP+C2
	 9mWY/Jk05qv+DxjY45H4yR5XdKm02YcwRkfX+uDbBKMYJxwJ74Mt3nzwKWv+55aL5K
	 25/UNYi5JznxdpfhkwnlL31nDp+6ZIlaNgoiZTNR6YoGXzXdxrFsVS4cg4KSnZPdeQ
	 01l4jlA8GlrMsPDIDEtDFyWUr2fTolAN5+GDeLr3Jio9oqBwQSXEDLJ6v3AqSrlTdQ
	 YR7UIvXms2Z1XaTB33KCGANwPmwnPqigzh5ZSBRNYhNUgIoV4rsyqoe5/7CtNSQhnm
	 ljQGvzCjExRog==
Date: Fri, 20 Mar 2026 07:27:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
	brauner@kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [Bug][xfstests xfs/556] inconsistent {HARDIRQ-ON-W} ->
 {IN-HARDIRQ-W} usage
Message-ID: <20260320142728.GA6254@frogsfrogsfrogs>
References: <20260319194303.efw4wcu7c4idhthz@doltdoltdolt>
 <abz2C1a-KIGMZCGe@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abz2C1a-KIGMZCGe@infradead.org>

On Fri, Mar 20, 2026 at 12:23:55AM -0700, Christoph Hellwig wrote:
> On Fri, Mar 20, 2026 at 03:43:03AM +0800, Zorro Lang wrote:
> > Hi,
> > 
> > While running fstests xfs/556 on kernel 7.0.0-rc4+ (HEAD=04a9f1766954), a
> > lockdep warning was triggered indicating an inconsistent lock state for
> > sb->s_type->i_lock_key.
> > 
> > The deadlock might occur because iomap_read_end_io (called from a hardware
> > interrupt completion path) invokes fserror_report, which then calls igrab.
> > igrab attempts to acquire the i_lock spinlock. However, the i_lock is frequently
> > acquired in process context with interrupts enabled. If an interrupt occurs while
> > a process holds the i_lock, and that interrupt handler calls fserror_report, the
> > system deadlocks.
> > 
> > I hit this warning several times by running xfs/556 (mostly) or generic/648
> > on xfs. More details refer to below console log.
> 
> I've seen the same.  AFAIK this is because the patch Darrick did to
> offload all bio errors to a workque hasn't been merged upstream.
> Unfortunately I don't remember the subject for that anymore.

That was only for writeback ioends[1], which went upstream a couple of
weeks ago.  This report is for read(ahead) completions, but there isn't
a quick fix because (AFAIK) the readahead ctx is gone by the time we get
to the bio endio handler.  I think we'd have to allocate a new struct
{bio, list_head} in iomap_read_end_io and bump the
iomap_finish_folio_read calls to process context via queue_work().

--D

[1] https://lore.kernel.org/linux-fsdevel/177148129564.716249.3069780698231701540.stgit@frogsfrogsfrogs/
