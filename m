Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BB14C74
	for <linux-xfs@vger.kernel.org>; Tue, 24 Jun 2025 18:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750789030; cv=none; b=Cr2dBLEupA+4sfttPCnLwCMZTvlKr/mvh7gd4456zvhO7/Gsy5tp71obwEqL3Z31+wsDFOjJvegcPZHQRZnag6tOG/NKF2x8hX0mSpwO0K3wAM6b1MLM1dJzdtBiDHzN7jNKzVqwcxJ3NXx2deAqqiFSsSBPx1mP1rQpxHnyH5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750789030; c=relaxed/simple;
	bh=spg9WJ6aXikJan0BZ/dN98ueLThm9qdlV7N4M4P3bII=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q78Dq1KLzemX5eCeFvThzPsV69RJHBejUPoOjHGFi959EWi+dXH9ElGvYvGaJ+mh8BQKnd08BLiTjVO7ia5+AeVP6HkzltN2g5UipjcPbCalB9ZEHb++luu8EqrU10EP0lbTAmQKbFa0YBtgKa3qLvE4xcpSsE2sk2IcN08vpdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C4NKi/CE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C4NKi/CE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931A0C4CEE3;
	Tue, 24 Jun 2025 18:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750789029;
	bh=spg9WJ6aXikJan0BZ/dN98ueLThm9qdlV7N4M4P3bII=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C4NKi/CEoA+xz4JdMoHi5GVt4YWcDvzl5W14mA3/fo6gWozIriAHSULvu9q1qw2Y+
	 hspww5jGbRWinHQ/Wo+aNsFfY3VLYXdf46sejBKzg63oESxQrYeh8aN47OZ6xee1gm
	 rSSWFVtQmzvlXOUgF3arm64/lh0chTqDiBOxVxIm8jpMfd+Q+vyCG3ZC7NYX7M9sep
	 yO7MSKk8q06wZutkYMSvpnDqYVW9no1ftdW6wkqBaHnjd90iP6oobcNvBBBAi9qmEv
	 n9QydWGvOQ0piYTpl6v7qteJYb/UOdqb5iYQ85dthVIG4h84TIWLGwWfizZpqsm6jU
	 9XWvaz+Ss/VFA==
Date: Tue, 24 Jun 2025 20:17:05 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, 
	djwong@kernel.org
Subject: Re: [PATCH 1/2] xfs: replace iclogs circular list with a list_head
Message-ID: <b5q3uuhkn2jqcjgg6qcv6z444bftoec7dwxh4qoxbj64z2vnfv@gogvtu75o4qj>
References: <20250620070813.919516-1-cem@kernel.org>
 <20250620070813.919516-2-cem@kernel.org>
 <aFoKgNq6IuPJAJAv@dread.disaster.area>
 <39xujXwbUGTy3j2E9pH6kGvaRPmJbSuo2peOANlQ21_G69mQy2f2TQX2zhXE2fEvknjHBViVbuVkacBo3jLZ1w==@protonmail.internalid>
 <20250624135740.GA24420@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250624135740.GA24420@lst.de>

On Tue, Jun 24, 2025 at 03:57:40PM +0200, Christoph Hellwig wrote:
> On Tue, Jun 24, 2025 at 12:16:32PM +1000, Dave Chinner wrote:
> > Hence I think that the ring should remain immutable and the
> > log->l_iclog pointer retained to index the first object in the ring.
> > This means we don't need a list head in the struct xlog for the
> > iclog ring, we can have the ring simply contain just the iclogs as
> > they currently do.
> 
> Alternatively do away with the list entirely and replace it with
> an array of pointers, i.e.
> 
> 	struct xlog {
> 		...
> 		struct xlog_in_core	*l_iclog;
> 		struct xlog_in_core	*l_iclogs[XLOG_MAX_ICLOGS];
> 	};

	Thanks for the tip hch, but wouldn't this break the mount option? So far
	the user can specify how many iclogs will be in memory, by allocating
	a fixed array, we essentially lock it to 8 iclogs, no?

Cheers, and thanks again for the review.

> 
> static inline struct xlog_in_core *
> xlog_next_iclog(
> 	struct xlog_in_core	*iclog)
> {
> 	if (iclog == iclog->ic_log->l_iclogs[log->l_iclog_bufs - 1])
> 		return iclog->ic_log->l_iclogs[0];
> 	return iclog + 1;
> }
> 
> and the typical loop become something like:
> 
> 	struct xlog_in_core	*iclog = log->l_iclog;
> 
> 	do {
> 		...
> 	} while ((iclog = xlog_next_iclog(iclog)) != log->l_iclog);
> 
> 
> 
