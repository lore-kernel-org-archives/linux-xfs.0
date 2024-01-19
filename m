Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B3EEC7
	for <linux-xfs@vger.kernel.org>; Fri, 19 Jan 2024 01:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705626336; cv=none; b=GXDzPKyrzKjJzqhsRIoDplOQTJ4OlKSZk6mO9TJURRxbddkbp8LONoPa469OBKcnUp70j5HOgrNOgdwYbGdbUl4u4nKtYBYNx8UcenGmiO3KHrBkuZRwNa8C+/UbvvWhW5Psg7xXou+mETSOfuQaKiM+GqmGIPIv3PKxGjn60J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705626336; c=relaxed/simple;
	bh=JJIMTdptpjRLqghyqHcwxmA/ycuk6CNv+5IIAWSkqaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f1Cjos2+8H0s2ZOq6lJwlC7d4uHT8ykkl2rSF0m76+iHBS4/nYWg5rrcJAC9ONwwWeW9p21mvbmpkKDs+GZx4jkFbjts3MWv0MKjcHqL2EHEUL1nK+xCJpdudTYmCqQA4XK8pXmVvF+UoH4rL/wyUQBAHZnh/RWfBoU8iRdlZ1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uUuTYMCj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uUuTYMCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA86C433C7;
	Fri, 19 Jan 2024 01:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705626335;
	bh=JJIMTdptpjRLqghyqHcwxmA/ycuk6CNv+5IIAWSkqaw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uUuTYMCjI9pzDy1xuacxfo6X2TPAD/5Z5Ef/2PS/FWlsz0yjlcz8i047TNXIsW9yw
	 hHN4RQW7N4FxyDFnSDRwzNUabUVbDfwrEVnS73areg3028gX9deRBXEiXt8UdXDE6E
	 TEgcpvuGE6eUE7bd1OB0zgvDJaCAmg/jfxa1ncP0oWBo5hLadrcjneo10S22qh53mb
	 Io4dmvJcZU38ufkMqpV6lloCsQLr0y4xBCXYFpCk/lWfRy/rXPY4N4MqeRArTlpsJI
	 8Y9S7MJvT+SuccCEVxba7PpnuAnrWZ9+JPtcJUU4s6LRrbtj0QUnsrvKH9LQ5lS8t6
	 DTViiyOWZYxvg==
Date: Thu, 18 Jan 2024 17:05:35 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org
Subject: Re: [RFC] [PATCH 0/3] xfs: use large folios for buffers
Message-ID: <20240119010535.GP674499@frogsfrogsfrogs>
References: <20240118222216.4131379-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240118222216.4131379-1-david@fromorbit.com>

On Fri, Jan 19, 2024 at 09:19:38AM +1100, Dave Chinner wrote:
> The XFS buffer cache supports metadata buffers up to 64kB, and it does so by
> aggregating multiple pages into a single contiguous memory region using
> vmapping. This is expensive (both the setup and the runtime TLB mapping cost),
> and would be unnecessary if we could allocate large contiguous memory regions
> for the buffers in the first place.
> 
> Enter multi-page folios.

LOL, hch and I just wrapped up making the xfbtree buffer cache work with
large folios coming from tmpfs.  Though the use case there is simpler
because we require blocksize==PAGE_SIZE, forbid the use of highmem, and
don't need discontig buffers.  Hence we sidestep vm_map_ram. :)

> This patchset converts the buffer cache to use the folio API, then enhances it
> to optimisitically use large folios where possible. It retains the old "vmap an
> array of single page folios" functionality as a fallback when large folio
> allocation fails. This means that, like page cache support for large folios, we
> aren't dependent on large folio allocation succeeding all the time.
> 
> This relegates the single page array allocation mechanism to the "slow path"
> that we don't have to care so much about performance of this path anymore. This
> might allow us to simplify it a bit in future.
> 
> One of the issues with the folio conversion is that we use a couple of APIs that
> take struct page ** (i.e. pointers to page pointer arrays) and there aren't
> folio counterparts. These are the bulk page allocator and vm_map_ram(). In the
> cases where they are used, we cast &bp->b_folios[] to (struct page **) knowing
> that this array will only contain single page folios and that single page folios
> and struct page are the same structure and so have the same address. This is a
> bit of a hack (hence the RFC) but I'm not sure that it's worth adding folio
> versions of these interfaces right now. We don't need to use the bulk page
> allocator so much any more, because that's now a slow path and we could probably
> just call folio_alloc() in a loop like we used to. What to do about vm_map_ram()
> is a little less clear....

Yeah, that's what I suspected.

> The other issue I tripped over in doing this conversion is that the
> discontiguous buffer straddling code in the buf log item dirty region tracking
> is broken. We don't actually exercise that code on existing configurations, and
> I tripped over it when tracking down a bug in the folio conversion. I fixed it
> and short-circuted the check for contiguous buffers, but that didn't fix the
> failure I was seeing (which was not handling bp->b_offset and large folios
> properly when building bios).

Yikes.

> Apart from those issues, the conversion and enhancement is relatively straight
> forward.  It passes fstests on both 512 and 4096 byte sector size storage (512
> byte sectors exercise the XBF_KMEM path which has non-zero bp->b_offset values)
> and doesn't appear to cause any problems with large directory buffers, though I
> haven't done any real testing on those yet. Large folio allocations are
> definitely being exercised, though, as all the inode cluster buffers are 16kB on
> a 512 byte inode V5 filesystem.
> 
> Thoughts, comments, etc?

Not yet.

> Note: this patchset is on top of the NOFS removal patchset I sent a
> few days ago. That can be pulled from this git branch:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git xfs-kmem-cleanup

Oooh a branch link, thank you.  It's so much easier if I can pull a
branch while picking through commits over gitweb.

--D

> 
> 
