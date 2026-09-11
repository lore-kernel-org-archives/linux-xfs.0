Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CEC443C2C;
	Fri, 11 Sep 2026 15:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789142362; cv=none; b=PkqasZnQOPvMGom23hu3qLyWa3ar/o55eHjM9Q9PoyGQA4BW7WtqHW4llwqdC1uUqYJj6ITME723WjBdEF5S1+eOPpM8QVNrDrtCS3/TvrS/1EBqVFCBWD+ypAQVMM+Oqwo3zGHQZswXGc/LtqwTwSZVddwEq21qM8VeM9YRHEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789142362; c=relaxed/simple;
	bh=C/G2uI72WNwm5TC9AHc8P7INWFfWcZ4pJLzIndX5vhY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ih7URHrxf//rwsQ4IRlv7bbLBqFWi/NL6Tah/mRrp3Mi/K1d6TB707gepFAUkNrGK6/tC7V9rQemv8Aeup6Vn1BGpnqd7PBpp5B2RcjPv0rUgqiBhFx9uQfvYE70ayv5OCPzotR2CBC/we8IjwW+kTXbwzgZpsNhs6s3O7EP1rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a1Oy5LVw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a1Oy5LVw"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4F2951F000FF;
	Fri, 11 Sep 2026 15:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789142360;
	bh=L2mrpVdDTXfEhhV8bnW1vyrGecaO1PaMSA92DkR1Vcc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a1Oy5LVw15zANN69LQzDLoOj320/r5zfZYivUOu6Qf+8wILNu1OUtAfYX9xhIuc+U
	 bHpFnjv8oqrm0T5rr0h+hd5YC6mNS9EQ/enCel9ZTGSI9LDsROZEO7eG8krA2cqNrD
	 vlx/A1CkIwnO/Gd1wm8CEjG97q68yOeKfykF6z6lKC+9ziQBHQaOZrCK4b31+bGWyZ
	 HY75b6B3nVHXZj8tcMb7kEB0YqWO2uovztfC9Sx73B4kj8fYqrZWy8fpYe+gnykR4S
	 qDGS5zpCyY5nqP0UsQLxvRnx1T7XGO/wTE7B4n0RdzWklfd70nm3W8s9fNg8A45u89
	 DxF2gjycL0QNg==
Date: Fri, 11 Sep 2026 08:59:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: check di_forkoff correctly in scrub
Message-ID: <20260911155919.GG6265@frogsfrogsfrogs>
References: <178910161988.174887.8958318922224347752.stgit@frogsfrogsfrogs>
 <178910162147.174887.15828411239184280666.stgit@frogsfrogsfrogs>
 <20260911150745.GA26822@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911150745.GA26822@lst.de>

On Fri, Sep 11, 2026 at 05:07:45PM +0200, Christoph Hellwig wrote:
> On Thu, Sep 10, 2026 at 10:54:58PM -0700, Darrick J. Wong wrote:
> > The di_forkoff check in xchk_dinode is incorrect, according to LOLLM.
> > XFS_DFORK_BOFF returns a byte count relative to the start of the literal
> > area, not the start of the inode.  Therefore, this check won't flag
> > di_forkoff values that are larger than the literal area but not the
> > inode size itself.  Fix this check; sadly the old APTR code was correct.
> 
> The fi looks good, but I really which we could encapsulate this
> magic >> 3 a bit better (here and elsewhere).

I /did/ think about adding a cleanup to do:

#define XFS_B_TO_FORKOFF(b)	((b) >> 3)
#define XFS_FORKOFF_TO_B(f)	((f) << 3)

and then code like this:

fs/xfs/libxfs/xfs_attr_leaf.c:782:      minforkoff = max_t(int64_t, dsize, xfs_bmdr_space_calc(MINDBTPTRS));
fs/xfs/libxfs/xfs_attr_leaf.c:783:      minforkoff = roundup(minforkoff, 8) >> 3;
fs/xfs/libxfs/xfs_attr_leaf.c:786:      maxforkoff = XFS_LITINO(mp) - xfs_bmdr_space_calc(MINABTPTRS);
fs/xfs/libxfs/xfs_attr_leaf.c:787:      maxforkoff = maxforkoff >> 3;   /* rounded down */

becomes:

	minforkoff = XFS_B_TO_FORKOFF(max_t(int64_t, dsize,
				xfs_bmdr_space_calc(MINDBTPTRS)));
	maxforkoff = XFS_B_TO_FORKOFF(XFS_LITINO(mp) -
				xfs_bmdr_space_calc(MINABTPTRS));

There aren't as many users of FORKOFF_TO_B though:

static inline unsigned int xfs_inode_fork_boff(struct xfs_inode *ip)
{
	return XFS_FORKOFF_TO_B(ip->i_forkoff);
}

> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
