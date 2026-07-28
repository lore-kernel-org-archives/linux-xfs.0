Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B75033F394;
	Tue, 28 Jul 2026 15:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785254110; cv=none; b=eMwQcBhnGYvyJVwrLJn0H044+wXkjwe0XnLfY11KoRp+yAa1kN9r/3Ei90kzi0qkOuqIlJebeckuBsO32hpPP+3dRjdmHvttNcnkpP6G2Aa9m1AOl4i7LyJRc5AeuXRED2fpz2PkzcllcShfNNUs+WKaDyjzRPwdl/QjH2zm7tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785254110; c=relaxed/simple;
	bh=OsZ7vR2p5IyGbHIc0NICtQJaP3mpcxbdBnFosUxmPow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QHJY07HraD0GtCF7hy485O+gjO9pHqj3iXZFPW8ks2UeH26pPPtZuyYGLQ10Vpa08yQhrNbFq999UgILAdamN7v+MGqq9y2pEe1cFhz3hXQTAfh+84U7VHwpq+m51OXzVKsEjCQO4TRF+FSpGeAEFKgDxMSsAeh9ptl+7qpyMrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NXA3b1Cj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NXA3b1Cj"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CB13C1F000E9;
	Tue, 28 Jul 2026 15:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785254108;
	bh=bpqrn3faBB0R55swf7Cx6MHmLKn63qiJCaP3NGPKoZI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NXA3b1CjN+WrwDO3fKZY6+27cki7zefXDcgqw6Lw5RaeXPY/4XZg/nqe51jlH9IcY
	 Do6ykzTQKtKcof6omTQACqZIBZdeOvogOMqeMZ01C5jwj2C3SH655vGkW6gSx0hYth
	 MWmOmZLPifOyjCY4bPWBBYMx4ORorMJEeFrwKQscTgfFWjRZij1qyVpIqVOSgzz5ZU
	 ujvu4cXACmPBHpL46qsBCyGpxALdRIMuGNUsI6HTukGOx2k04KL4ZpRBv9Tls/11io
	 xct4ChExyr+VHiY15rvu53RG1O4d3B25GUk4ed0uf5LLFXGLHBxPZNJ9OkAvBw7Lex
	 eDYrmKaS7eIUw==
Date: Tue, 28 Jul 2026 08:55:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Joanne Koong <joannelkoong@gmail.com>,
	Christian Brauner <brauner@kernel.org>, hch@lst.de,
	linux-fsdevel@vger.kernel.org, changfengnan@bytedance.com,
	kbusch@kernel.org, Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>, Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>, tytso@mit.edu,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>, libaokun@linux.alibaba.com,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 01/21] iomap: split iomap_iter() logic into
 iomap_iter_next()
Message-ID: <20260728155508.GT2901224@frogsfrogsfrogs>
References: <20260727211758.1116539-1-joannelkoong@gmail.com>
 <20260727211758.1116539-2-joannelkoong@gmail.com>
 <amizdHj6ICgP2xFv@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amizdHj6ICgP2xFv@bfoster>

On Tue, Jul 28, 2026 at 09:49:40AM -0400, Brian Foster wrote:
> On Mon, Jul 27, 2026 at 02:17:38PM -0700, Joanne Koong wrote:
> > In preparation for changing iomap to use an in-iter (->iomap_next())
> > model, move the iomap_iter() logic out into the new iomap_iter_next()
> > helper function.
> > 
> > iomap_iter_next() is added as an inlined helper so it can be called
> > directly by ->iomap_next() implementations where the begin()/end()
> > callbacks can be direct calls.
> > 
> > The DEFINE_IOMAP_ITER_NEXT() and DEFINE_IOMAP_ITER_NEXT_END() macros are
> > also provided to generate the boilerplate ->iomap_next() wrapper
> > functions that simply forward to iomap_iter_next() with the appropriate
> > begin/end callbacks. DEFINE_IOMAP_ITER_NEXT() is for the common case
> > where there is no end() callback. DEFINE_IOMAP_ITER_NEXT_END() is for
> > the case where there is an explicit end() callback.
> > 
> > No functional change intended. The only code-level difference is that on
> > the iomap_end() error path (ret < 0 && !advanced), the old code returned
> > with iter.status left as the caller's last value whereas the new code
> > zeroes it, but this is not observable in practice as there are no in-tree
> > callers that read iter.status after the iteration loop.
> > 
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Fengnan Chang <changfengnan@bytedance.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  fs/iomap/iter.c       | 123 +++++++++++++++++++++---------------------
> >  include/linux/iomap.h | 102 +++++++++++++++++++++++++++++------
> >  2 files changed, 147 insertions(+), 78 deletions(-)
> > 
> > diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
> > index e4a29829591a..66ccb87441ab 100644
> > --- a/fs/iomap/iter.c
> > +++ b/fs/iomap/iter.c
> > @@ -6,15 +6,6 @@
> >  #include <linux/iomap.h>
> >  #include "trace.h"
> >  
> > -static inline void iomap_iter_clean_fbatch(struct iomap_iter *iter)
> > -{
> > -	if (iter->iomap.flags & IOMAP_F_FOLIO_BATCH) {
> > -		folio_batch_release(iter->fbatch);
> > -		folio_batch_reinit(iter->fbatch);
> > -		iter->iomap.flags &= ~IOMAP_F_FOLIO_BATCH;
> > -	}
> > -}
> > -
> 
> So hch forwarded me a bit of Sashiko review feedback that called out a
> potential folio batch leak on error returns from iomap_begin() or
> iomap_end(). Note that I think the ->iomap_end() variant is currently
> not an issue because nothing returns error there, but it should be fixed
> regardless.
> 
> As such, I have the patch below as a fix based on current master. The
> idea here is to account for failures from either callback and also the
> fact that XFS may not necessarily transfer the iomap_flags on failure. I
> considered a couple other options here, like changing that behavior or
> using an iter flag, but I think this is the cleanest option.
> 
> However this obviously conflicts with this rework series. This isn't a
> major conflict IMO.. I'd probably just do the same thing and include the
> batch cleanup in the error/exit path of iomap_iter() (or maybe start
> passing ret into iomap_iter_done()), but I would need to reintroduce the
> helper above. Also after this series I think this could mean a duplicate
> call in the termination case where iomap_iter_continue() would have
> cleaned things up, but that is relatively harmless. Maybe there is
> something incrementally cleaner, but I'm still wrapping my head around
> the factoring here..
> 
> But anyways, the main thing I wanted to ask is how folks want to handle
> this particular bug..? This rework is invasive and looks mostly reviewed
> so I don't want to unnecessarily hold it up. I can rebase on top of this
> and leave the patch below for -stable, or avoid the helper churn and
> post the patch below on its own and rework it into this, or maybe just
> tweak this to leave the helper around and avoid some churn that way..
> thoughts?

From my 30000ft view I'd say push the folio leak fix to linus ASAP for
7.2 and work out the merge conflict resolution in for-next and send that
to broonie/linus for 7.3.  But I'm not sure if people are actually
hitting this and not realizing it; or if this is a fix for a theoretical
problem.

--D

> Brian
> 
> --- 8< ---
> 
> diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
> index e4a29829591a..63617ec48250 100644
> --- a/fs/iomap/iter.c
> +++ b/fs/iomap/iter.c
> @@ -6,12 +6,18 @@
>  #include <linux/iomap.h>
>  #include "trace.h"
>  
> +/*
> + * Release the iter folio batch. Note that the iomap flag is meant to control
> + * the I/O path for the mapping and may not be set in error situations.
> + */
>  static inline void iomap_iter_clean_fbatch(struct iomap_iter *iter)
>  {
> -	if (iter->iomap.flags & IOMAP_F_FOLIO_BATCH) {
> +	if (!iter->fbatch)
> +		return;
> +	iter->iomap.flags &= ~IOMAP_F_FOLIO_BATCH;
> +	if (folio_batch_count(iter->fbatch)) {
>  		folio_batch_release(iter->fbatch);
>  		folio_batch_reinit(iter->fbatch);
> -		iter->iomap.flags &= ~IOMAP_F_FOLIO_BATCH;
>  	}
>  }
>  
> @@ -79,7 +85,7 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
>  						  olen),
>  				advanced, iter->flags, &iter->iomap);
>  		if (ret < 0 && !advanced)
> -			return ret;
> +			goto error;
>  	}
>  
>  	/* detect old return semantics where this would advance */
> @@ -110,7 +116,11 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
>  	ret = ops->iomap_begin(iter->inode, iter->pos, iter->len, iter->flags,
>  			       &iter->iomap, &iter->srcmap);
>  	if (ret < 0)
> -		return ret;
> +		goto error;
>  	iomap_iter_done(iter);
>  	return 1;
> +
> +error:
> +	iomap_iter_clean_fbatch(iter);
> +	return ret;
>  }
> 
> 
