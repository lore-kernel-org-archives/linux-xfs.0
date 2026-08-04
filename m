Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C29C3F39FB;
	Tue,  4 Aug 2026 18:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785868159; cv=none; b=B93t9t2oVyuj6YIkVtfs3MQjV93C8hTh74lZVUUGExVPidvsWG5ryI+kIMYP4jlHIoZ/YfjPhsiTQ6IKFGhjoJggm5FVRYy4awJznzHEBSZUY0lz+HZjmLbdTUhIFj0AZVH7mfajh45GRtuu79oFfwTesxbKnz2MUD8M7LmtKUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785868159; c=relaxed/simple;
	bh=EJIyoHTNQEpk/1Xqvy0yu+8309J1h9vVehG2dheJR64=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W2Ve38efyXBESYQY49S1xlthIdRigPLepFS9xmaP9qbz7Wqb8EPKzerfAr0o/YU99FMfb22GHfuP/uYnKOrA4BLfqXY48BugVG43s/0pHlo7gV8rDfmUKk6lBaF8nEh/GIu2XJSE3MHyhz9pUG5znzzuYr6rOq0WFRFVcdyeEAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zw+/ikYl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zw+/ikYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726B61F000E9;
	Tue,  4 Aug 2026 18:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785868157;
	bh=Zp1skLnHqAyH/0d878nuE8/4QAieL1XOTvNWul4GB3A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Zw+/ikYl/m71U0AU0WIiLOLp1Rmk0UUct9jU3Cybclv3feFqErVouNiFAdQhKG5Yi
	 Eo1LXtn4+dlYvXUKbNdJlJrXpGBMvLAAavVAa7WMuYpfJsRSrYTK+1t7ldyRSac8+V
	 k0dJSuBh3+LhAcLn3GmuYKb/Jg7YAc4YiYvj36cS4zEm5vGxiNqFlR7B1TLxx03KrX
	 dSK0HHe2G4vyCU6shw8fuuNX/pmiLMvir7b1uqp3Sesdza1ztNszJNPZ8m+aYnl0cE
	 RZTwTmGT9/LMbGZKvUIoS/t2IlPtUowxCuQB4IJwM9M6oZHM3mdeqlFWlGlbJ6NP+i
	 HPD2jZU43ExCw==
Date: Tue, 4 Aug 2026 18:29:15 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v14 11/21] xfs: don't report dio_mem_align and
 dio_offset_align for fsverity files
Message-ID: <20260804182915.GB2904385@google.com>
References: <20260803200820.393203-1-aalbersh@kernel.org>
 <20260803200820.393203-12-aalbersh@kernel.org>
 <20260804174347.GC14046@lst.de>
 <20260804175058.GH3556460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804175058.GH3556460@frogsfrogsfrogs>

On Tue, Aug 04, 2026 at 10:50:58AM -0700, Darrick J. Wong wrote:
> On Tue, Aug 04, 2026 at 07:43:47PM +0200, Christoph Hellwig wrote:
> > On Mon, Aug 03, 2026 at 10:08:01PM +0200, Andrey Albershteyn wrote:
> > > Sashiko.dev reported that while fsverity files falls back to the
> > > buffered IO for Direct I/O, they should not report non-zero values in
> > > dio_mem_align and dio_offset_align, meaning it's not supported.
> > 
> > This doesn't make much sense to me.  If we didn't want to report
> > we'd also want to not set STATX_DIOALIGN | STATX_DIO_READ_ALIGN.
> > But in the end there is very little upside of this while adding
> > extra special cases.
> 
> directio is supported; the implementation merely falls back to reading
> through the page cache.  Unless you're saying that xfs shouldn't
> shouldn't set FMODE_CAN_ODIRECT for fsverity files?  But that also
> doesn't sound right.
> 
> Personally I think sashaniko is full of it and this whole patch should
> be dropped.

The statx fields are meant to report real direct I/O support, not merely
accepting the O_DIRECT flag and silently falling back to buffered I/O.

- Eric
