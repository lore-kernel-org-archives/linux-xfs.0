Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B9327464E
	for <linux-xfs@vger.kernel.org>; Tue, 20 May 2025 10:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747737491; cv=none; b=f97siYde5t0/jYgzS1+yuTHoSK0nXiL4l5clZWj64H/xEi8zU0yK+pd9oJ6OggvsdbmBUgoVwsR90Sqlr0s3WQ56bT7BLPqyeJ5cN4sMyh/4gRlA9tD7ai8w/R8zkA4kXR3h4eGUqI1csiGDLt9OUHrzq83MIkopceSlRqQizK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747737491; c=relaxed/simple;
	bh=mRU0VykrlxKIBkrDBdya8U7Kow21ZCRP9bV6krzADpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EfIVoR3Sr6e99Wcp6cY3rqiA5SHigmoDh9DFiejoHtBKlbYbeTq43rT+kIIjFnCb2BFPa72ojjQWfU7tU8Rctn3IzZNPLXr5rlN6QtEeomtYtLgdn2EAZK2KUdJgSk2J6Jz8zIqZU1nxUf3R07q1MVwJUEyLxJAyvnz/VIA1FOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rTk9SgLc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rTk9SgLc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D101C4CEEB;
	Tue, 20 May 2025 10:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747737489;
	bh=mRU0VykrlxKIBkrDBdya8U7Kow21ZCRP9bV6krzADpY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rTk9SgLc8gLP0mOOIZ79xPMmWL5FFgBhZ6XgI0bn9FVxHEF69cYJd4Z/uACLzfbcQ
	 xICZ73FtM0nehh1rm4wIwZhomuhW1XNpY2lcK0w8tcXrcA+gIpGpplDhbIrGZqSGmJ
	 WEl8e7qngn0zeiHMRwft9OuoSY46/7Kfp3uuMYWmWvSsp5ne/oLLd0qEfRexOqj3fc
	 uZiajQvYMdInkXxXG5Yf10wANjo5T+A4gsSwD0oLRUt+vAfhMC50xVGEnl3uFgKt0D
	 h23EzGMyLDHugXL7yWuHsQpqmujgVUGS9gwAWcIXqtkIQoaM1Xrr7mBi5v2RMRMYO+
	 tNpdHHrdEsdwA==
Date: Tue, 20 May 2025 12:38:04 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zizhi Wo <wozizhi@huawei.com>, dchinner@redhat.com, osandov@fb.com, 
	john.g.garry@oracle.com, linux-xfs@vger.kernel.org, yangerkun@huawei.com, 
	leo.lilong@huawei.com
Subject: Re: [PATCH] xfs: Remove unnecessary checks in functions related to
 xfs_fsmap
Message-ID: <kzgijlgzweykmeni664npughps5jkgf34l7ndyj3zzwgq2wrbi@zbwrkf6xcmzh>
References: <20250517074341.3841468-1-wozizhi@huawei.com>
 <9_MWuMXnaWk3qXgpyYhQa-60ELGmTr8hBsB3E4comBf1_9Mx-ZtDqy3cQKCTkNa9aVG4zLeTHVvnaepX2jweEA==@protonmail.internalid>
 <20250519150854.GB9705@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250519150854.GB9705@frogsfrogsfrogs>

On Mon, May 19, 2025 at 08:08:54AM -0700, Darrick J. Wong wrote:
> On Sat, May 17, 2025 at 03:43:41PM +0800, Zizhi Wo wrote:
> > From: Zizhi Wo <wozizhi@huaweicloud.com>
> >
> > In __xfs_getfsmap_datadev(), if "pag_agno(pag) == end_ag", we don't need
> > to check the result of query_fn(), because there won't be another iteration
> > of the loop anyway. Also, both before and after the change, info->group
> > will eventually be set to NULL and the reference count of xfs_group will
> > also be decremented before exiting the iteration.
> >
> > The same logic applies to other similar functions as well, so related
> > cleanup operations are performed together.
> >
> > Signed-off-by: Zizhi Wo <wozizhi@huaweicloud.com>
> > Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
> > ---
> >  fs/xfs/xfs_fsmap.c | 6 ------
> >  1 file changed, 6 deletions(-)
> >
> > diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> > index 414b27a86458..792282aa8a29 100644
> > --- a/fs/xfs/xfs_fsmap.c
> > +++ b/fs/xfs/xfs_fsmap.c
> > @@ -579,8 +579,6 @@ __xfs_getfsmap_datadev(
> >  		if (pag_agno(pag) == end_ag) {
> >  			info->last = true;
> >  			error = query_fn(tp, info, &bt_cur, priv);
> > -			if (error)
> > -				break;
> 
> Removing these statements make the error path harder to follow.  Before,
> it was explicit that an error breaks out of the loop body.  Now you have
> to look upwards to the while loop conditional and reason about what
> xfs_perag_next_range does when pag-> agno == end_ag to determine that
> the loop terminates.
> 
> This also leaves a tripping point for anyone who wants to add another
> statement into this here if body because now they have to recognize that
> they need to re-add the "if (error) break;" statements that you're now
> taking out.
> 
> You also don't claim any reduction in generated machine code size or
> execution speed, which means all the programmers end up having to
> perform extra reasoning when reading this code for ... what?  Zero gain?
> 
> Please stop sending overly narrowly focused "optimizations" that make
> life harder for all of us.

I do agree with Darrick. What's the point of this patch other than making code
harder to understand? This gets rid of less than 10 machine instructions at the
final module, and such cod is not even a hot path. making these extra instructions
virtually negligible IMO (looking at x86 architecture). The checks are unneeded
logically, but make the code easier to read, which is also important.
Did you actually see any improvement on anything by applying this patch? Or was
it crafted merely as a result of code inspection? Where are the results that make
this change worth the extra complexity while reading it?

Cheers,
Carlos

> 
> NAK.
> 
> --D
> 
> >  		}
> >  		info->group = NULL;
> >  	}
> > @@ -813,8 +811,6 @@ xfs_getfsmap_rtdev_rtbitmap(
> >  			info->last = true;
> >  			error = xfs_getfsmap_rtdev_rtbitmap_helper(rtg, tp,
> >  					&ahigh, info);
> > -			if (error)
> > -				break;
> >  		}
> >
> >  		xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_BITMAP_SHARED);
> > @@ -1018,8 +1014,6 @@ xfs_getfsmap_rtdev_rmapbt(
> >  			info->last = true;
> >  			error = xfs_getfsmap_rtdev_rmapbt_helper(bt_cur,
> >  					&info->high, info);
> > -			if (error)
> > -				break;
> >  		}
> >  		info->group = NULL;
> >  	}
> > --
> > 2.39.2
> >
> >
> 
