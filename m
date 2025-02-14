Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB47A14D28C
	for <linux-xfs@vger.kernel.org>; Fri, 14 Feb 2025 18:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739557794; cv=none; b=boFA+qQi7zMS1oiqK42+FcscbCWHi+VCGLTYcG3ZAIwr3cymlv80AYOGRFiQ46tlfEBxV/1uyxcHuhOGgSiNsbGI3/YE6dJcqfwSaCGM3XFReB4bB0VNWx2VZV+/qXs33z/qxlRIg9icQmVm2VO6fe+Z1iVyquZs0lnhFzegnY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739557794; c=relaxed/simple;
	bh=jb4xt+UKRzFVrBQHoQKfH7KxkMnlbIuQ6w4fJiQtcHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qXGc2JF28HiM5KXk57LRvNKcLHeo6LxgAH1CApJgxsZVlqCHESMr+oIPXlYFzqNG+hcsMrDhLo9fsuZOw3uYaxVS/PPpCsZPGykx2apdMqBaA8bb1DNpk722C9MswyTha2laVAmeRYYkkxndX8tH8vmnEMZmKEJnsyXSaXypLeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KqIntJqw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KqIntJqw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24352C4CED1;
	Fri, 14 Feb 2025 18:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739557794;
	bh=jb4xt+UKRzFVrBQHoQKfH7KxkMnlbIuQ6w4fJiQtcHk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KqIntJqwipFBzUSvfa/vq/SAV9sYIO1/5JZitYSZID9U6y4DMNQUDRqcshbZEF4l1
	 kxKnsOYY6WX8QhKmutl08928WTVJk92+0XUZXGQS28q3vR/9n4usUwsWiLWWb7Q5Es
	 Ox73PSkujvxbyHGhVS7mmnXiq3eRZUu5fTciY9mnGmBcubAkvdM+8Mh15u72vPicsQ
	 pSqzlsDGO6c/RSYZ6Sk2ld2wjgT40YUaqieOTw6Jj4WjTh+mldYS9N0g2JbAgRc8hs
	 kKZpIBGwhgbiVmQ2Mtn7/fVzE8qAuCasYWP3iOxKhDWhHseQZL41vpVWpjVcQkbhNA
	 wB80rQdJJecHQ==
Date: Fri, 14 Feb 2025 10:29:53 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/43] xfs: implement buffered writes to zoned RT devices
Message-ID: <20250214182953.GA21808@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-26-hch@lst.de>
 <20250212005405.GH21808@frogsfrogsfrogs>
 <20250213053943.GA18867@lst.de>
 <20250213230558.GX21808@frogsfrogsfrogs>
 <20250214062252.GB25903@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250214062252.GB25903@lst.de>

On Fri, Feb 14, 2025 at 07:22:52AM +0100, Christoph Hellwig wrote:
> On Thu, Feb 13, 2025 at 03:05:58PM -0800, Darrick J. Wong wrote:
> > > we'll need a space allocation for every write in an out of tree write
> > > file system.  But -ENOSPC (or SIGBUS for the lovers of shared mmap
> > > based I/O :)) on writes is very much expected.  On truncate a lot less
> > > so.  In fact not dipping into the reserved pool here for example breaks
> > > rocksdb workloads.
> > 
> > It occurs to me that regular truncate-down on a shared block can also
> > return ENOSPC if the filesystem is completely out of space.  Though I
> > guess in that case, at least df will say that nearly zero space is
> > available, whereas for zoned storage we might have plenty of free space
> > that simply isn't available right now... right?
> 
> That's part of it, yes as we can't kick GC.  That reason will go away
> if/when the VFS locking for truncates is fixed.  But I also doubt people
> run nasty workloads on reflinked files all that much.

<nod> The nasty reflink workloads are mostly disk images, and those
aren't getting small truncations.

--D
