Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30833E6385;
	Thu,  9 Jul 2026 07:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783583923; cv=none; b=URwcfb7W5yrkgEHyOqAURu5O5JkKgs0j28Cu3leZyn6igcCR6KPXw1YhPom4msqni/KPeZEwJUAKB0fn6pa4nQJnoatCy7udIk2JOYvteMSVAtYarzTCr6+eoATLjUjrXV4alWNn0v/6qs+w7iQ7ZL0qNlzZrt2JPsSbLwiUZX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783583923; c=relaxed/simple;
	bh=zQBi9PjmujlZEokl7lWhFpsdfBtRR5smJhPbDu3EhnE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rn8PJGbPLrIbpC6BsRnUCHiuyx/Twn6wgunuwhu5srH8TD757TO6GPq4hfPPQJKDtuFw3V0EkJ5Pod7s+oOgiL8ddBWfZKh+ZL+NfBX/ufQqfohhMTnmj/N3wOWa3y2LSsMIu6HeZxLxK/LPRigDCIMQvC5Nb2/3Ip/njvxZYgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YvWIoR/Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YvWIoR/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 408161F000E9;
	Thu,  9 Jul 2026 07:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783583922;
	bh=1xW3wSzALhpnylvKBiWezOHXl5YI3hvalyi3nH0EXMk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YvWIoR/Zn7VSZwhIoENJ1Ebc/mMuwdXOPO9jlS8TvnQ7Kx4T+18LDqFBdqXvTxSzr
	 hiumpKyW1/SjgqClEQA3KhQN4zRqAoaULvNKVQL32a/PoNwzBA9xaZTvChiUmwqpDy
	 DSZnbuCewG2M/ga7C+XjdsD09F+0/U1Fl/vAASWIiXGh/ifWC03GBI1LuKY4mgPmMo
	 XHcyqzUDNlSQ//o0KqfPi3OmGcZCCLalUzw08t/jpnIYyPBICHZTrhytny5YDBe4PU
	 qBNWhfv2SYy0I2u1XVtCd7SHxFRRrx3eXTjBLcVzZNme6GDsVpf3JpW0tMaH+wLe+k
	 qHm6OlBJs5Cow==
Date: Thu, 9 Jul 2026 17:58:33 +1000
From: Dave Chinner <dgc@kernel.org>
To: Ravi Singh <ravising@redhat.com>
Cc: linux-xfs@vger.kernel.org, dchinner@redhat.com, bfoster@redhat.com,
	hch@lst.de, djwong@kernel.org, cem@kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] xfs: punch COW fork delalloc on COW writeback failure
Message-ID: <ak9UqRfSB_O7vDVM@dread>
References: <20260709062622.2939412-1-ravising@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709062622.2939412-1-ravising@redhat.com>

On Thu, Jul 09, 2026 at 06:26:22AM +0000, Ravi Singh wrote:
> When a COW writeback I/O fails, xfs_end_ioend_write() cancels the COW
> fork extents and punches out any overlapping delalloc blocks.  Currently
> the delalloc punch targets XFS_DATA_FORK, but on the error path
> xfs_reflink_end_cow() is never called, so the COW fork extents have not
> been moved to the data fork yet.  Any overlapping delalloc that needs to
> be cleaned up is therefore still in the COW fork.
> 
> Punching the data fork is incorrect because it can remove delalloc
> reservations that belong to a concurrent buffered write.  In particular,
> the convert_delay path in xfs_buffered_write_iomap_begin() drops the
> ILOCK before calling xfs_bmapi_convert_delalloc(), and a concurrent COW
> writeback failure punching data fork delalloc during this window causes
> xfs_bmapi_convert_one_delalloc() to find the extent missing and trigger
> a WARN_ON_ONCE(whichfork != XFS_COW_FORK).
> 
> This is the same class of wrong-fork issue fixed by commit f6f91d290c8b
> ("xfs: punch delalloc extents from the COW fork for COW writes") for the
> xfs_buffered_write_iomap_end() path.

I know I suggested that punching the wrong fork -might- be the cause
of the bug you were trying to reproduce after noticing that commit
reference in your analysis, but I don't think my hypothesis was
correct.

I've had reason to look at xfs_reflink_cancel_cow_range() very
closely today, and I think you should, too. i.e. work out what the
COW fork should contain after it finishes running on the range the
IO spanned.

Then....

> Fix xfs_end_ioend_write() to punch delalloc from XFS_COW_FORK instead
> of XFS_DATA_FORK for IOMAP_IOEND_SHARED ioends.

... it should become clear that COW fork doesn't actually contain
any delalloc extents over the given range after the cancel operation
returns.

So even if punching the data fork is wrong or triggering some other
data fork extent manipulation race, replacing it with a cow fork
punch is not a fix for whatever the underlying issue might be.

Cheers,

Dave.
-- 
Dave Chinner
dgc@kernel.org
