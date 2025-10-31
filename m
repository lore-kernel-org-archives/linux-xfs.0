Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDAF28E0F;
	Fri, 31 Oct 2025 04:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761885025; cv=none; b=oLkzSfRwfZGp8BeHxb5oT3p1GQKqgfKbqByIGJd91N6Dv68zQ+VxmZSNCzx1Wvd7CSu6ms3QamAh5m/xOLpXq7A6kdKvFkNEqjJ0h3tnCK31mtppd0t3L0qwAUe50Z+IfEiwQnccEpOpqmMVkoyPRCTrw+bIJN+a5G/4ss9cpwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761885025; c=relaxed/simple;
	bh=uH+o4PP+Irz7hBKcXqBMnLybHmEHpHI6cXBxMZ+Wwvk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O3qSti72DR+Q9s2ysqn0nmGs409tJRexNgqZZT/Vpur3v9mo5uTeE4TXR2OozI/X3OoZ9wXEgyCg/tbpLVnlos6qHr9vMsiO3F+TTyHjbdbVIK6EAXCVwUqY4cTM+zR7yyMzrZVi1TLFb2ZT37cGpgfVHYFIJF331bgYpTlVbTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZWLmlBVY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZWLmlBVY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2307C4CEE7;
	Fri, 31 Oct 2025 04:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761885024;
	bh=uH+o4PP+Irz7hBKcXqBMnLybHmEHpHI6cXBxMZ+Wwvk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZWLmlBVYnUG/agTvHmIcH/2T8fgaRUwpJTArEalu4tmJWoMlx86tQeIOKkcSIBEDa
	 foPS93OfS6cc3nq/cpKH/lmARp6ItneXyjxVcSQsAha2mpYDa3VR6sJNyUgtm0IbLU
	 5iErGCcrjFp0XhMXeKEi1NOy8WdzKBDy/0KAn4LMDT0bGa+e8Xu/uK7YpGn6jYkwAL
	 QnLIcBAY2m5WRAC09SyurKfGD30DMZ3X1hd0vi+XVb4duuQQKKc4JJJO5grx2e3RdA
	 y+/c/CdE0tOid6kVHQfZ7RJGPLK6z4HLHj8r3BJGMDG6ZWAez4K8XgiT/+Nun8Zrf2
	 5/IYkKRUL81mw==
Date: Thu, 30 Oct 2025 21:30:24 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: Carlos Maiolino <cem@kernel.org>, Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org,
	Ritesh Harjani <ritesh.list@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix write failures in software-provided atomic
 writes
Message-ID: <20251031043024.GP3356773@frogsfrogsfrogs>
References: <cover.1758264169.git.ojaswin@linux.ibm.com>
 <c3a040b249485b02b569b9269b649d02d721d995.1758264169.git.ojaswin@linux.ibm.com>
 <20251029181132.GH3356773@frogsfrogsfrogs>
 <02af7e21-1a0f-4035-b2d1-b96c9db2f5c7@oracle.com>
 <20251030150138.GW4015566@frogsfrogsfrogs>
 <c3cdd46f-7169-48c9-ae7a-9c315713e31f@oracle.com>
 <0c25aaf1-e813-475f-ac7e-a05e33af91f1@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c25aaf1-e813-475f-ac7e-a05e33af91f1@oracle.com>

On Thu, Oct 30, 2025 at 07:38:43PM +0000, John Garry wrote:
> On 30/10/2025 16:35, John Garry wrote:
> > > > 
> > > That's a good breadcrumb for me to follow;
> > 
> > I hope that it is ...
> > 
> > > I will turn on the rmap
> > > tracepoints to see if they give me a better idea of what's going on.
> > > I mentioned earlier that I think the problem could be that iomap treats
> > > srcmap::type == IOMAP_HOLE as if the srcmap isn't there, and so it'll
> > > read from the cow fork blocks even though that's not right.
> > 
> > Something else I notice for my failing test is that we do the regular
> > write, it ends in a sub-fs block write on a hole. But that fs block
> > (which was part of a hole) ends up being filled with all the same data
> > pattern (when I would expect the unwritten region to be 0s when read
> > back) - and this is what the compare fails on.
> 
> This makes the problem go away for me:
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index e1da06b157cf..e04af830d196 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1113,6 +1113,7 @@ xfs_atomic_write_cow_iomap_begin(
>  	unsigned int		dblocks = 0, rblocks = 0;
>  	int			error;
>  	u64			seq;
> +	xfs_filblks_t		count_fsb_orig = count_fsb;
> 
>  	ASSERT(flags & IOMAP_WRITE);
>  	ASSERT(flags & IOMAP_DIRECT);
> @@ -1202,7 +1203,7 @@ xfs_atomic_write_cow_iomap_begin(
>  found:
>  	if (cmap.br_state != XFS_EXT_NORM) {
>  		error = xfs_reflink_convert_cow_locked(ip, offset_fsb,
> -				count_fsb);
> +				count_fsb_orig);
>  		if (error)
>  			goto out_unlock;
>  		cmap.br_state = XFS_EXT_NORM;
> @@ -1215,6 +1216,7 @@ xfs_atomic_write_cow_iomap_begin(
>  	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, IOMAP_F_SHARED, seq);
> 
> I think that the problem may be that we were converting an inappropriate
> number of blocks from unwritten to real allocations (but never writing to
> the excess blocks). Does it look ok?

That looks like a good correction to me; I'll run that on my test fleet
overnight and we'll see what happens.  Thanks for putting this together!

--D


> thanks
> 
