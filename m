Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4CE36B047;
	Wed, 25 Mar 2026 20:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774470897; cv=none; b=PrEwFMkRj+mxOK5/nj1/CxSbxBBD3GUDdqWa+lh9dwZvlcSxVlYbnsU3Bi1tBKaVTje/1mcId4T4JtTqWkJnVf11gz9jL+AXZXYNtkEjYUUkhSCQSBCwL+/4zzT/DOB5UXU+J2mjsrI+pz2OqzNT0cpqIVgnBQZZttUcirUsWrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774470897; c=relaxed/simple;
	bh=hY080uvPl+LEJJt54gSEYsldkDiD0CJld2/4td8A6aI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GTDCCPt1XnREmTiYoWLcMsi3GPVLUzJVYgLFUQ+30kEmb21bqugoNTf6b6lR43tI8HgohqdWcK4b3fFAbWUi/uD55P+7hwN13Dti9ySLON2sN8TGNMxzy/kqRBCOh1CspFOjIM1YuOTQVJn0cl8CXuMuC/g4QexVrdzNdO5DGiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bbYBhCbS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bbYBhCbS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9764DC4CEF7;
	Wed, 25 Mar 2026 20:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774470897;
	bh=hY080uvPl+LEJJt54gSEYsldkDiD0CJld2/4td8A6aI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bbYBhCbSSQyOTk2rJFqHAHyFkKsd73IqUwcFy1AxQRkoLCwLLPF6umiKPs2LeSj7H
	 Hb2Y1u24jgh3bjfi6QzV4qDUu44EkKemZiprOOLgNgmHHUayATDX8gnaSXKhoYUck0
	 oaxE1niv2eRDUu2vHcH/hKX7Tbh4hCPoz0Y/MIbst2XgsBzoS8Ttync+PNpOfwa3bH
	 5IVdXJnMAQ6hoLZ/Amx7/4E0zDBlAaMvXFa03NeGgd1xTLyLS8gVLGk4rAzXdR/mU+
	 6xueRiigw4BkQhn+wkJqXsBN1gQeiEN02uf1TnMkhR3uvyRnMWgxgs0oifdlPY5Cca
	 fgS5DepuxPWMA==
Date: Thu, 26 Mar 2026 07:34:45 +1100
From: Dave Chinner <dgc@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC v4 2/3] iomap: use BIO_COMPLETE_IN_TASK for
 dropbehind writeback
Message-ID: <acRG5f9QjdEKg2JB@dread>
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-2-c4b56db43f64@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325-blk-dontcache-v4-2-c4b56db43f64@columbia.edu>

On Wed, Mar 25, 2026 at 02:43:01PM -0400, Tal Zussman wrote:
> Set BIO_COMPLETE_IN_TASK on iomap writeback bios when
> IOMAP_IOEND_DONTCACHE is set. This ensures that bi_end_io runs in task
> context, where folio_end_dropbehind() can safely invalidate folios.
> 
> With the bio layer now handling task-context deferral generically, XFS
> no longer needs to route DONTCACHE ioends through its completion
> workqueue for page cache invalidation. Remove the DONTCACHE check from
> xfs_ioend_needs_wq_completion().
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  fs/iomap/ioend.c  | 2 ++
>  fs/xfs/xfs_aops.c | 4 ----
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
> index e4d57cb969f1..6b8375d11cc0 100644
> --- a/fs/iomap/ioend.c
> +++ b/fs/iomap/ioend.c
> @@ -113,6 +113,8 @@ static struct iomap_ioend *iomap_alloc_ioend(struct iomap_writepage_ctx *wpc,
>  			       GFP_NOFS, &iomap_ioend_bioset);
>  	bio->bi_iter.bi_sector = iomap_sector(&wpc->iomap, pos);
>  	bio->bi_write_hint = wpc->inode->i_write_hint;
> +	if (ioend_flags & IOMAP_IOEND_DONTCACHE)
> +		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
>  	wbc_init_bio(wpc->wbc, bio);
>  	wpc->nr_folios = 0;
>  	return iomap_init_ioend(wpc->inode, bio, pos, ioend_flags);
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 76678814f46f..0d469b91377d 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -510,10 +510,6 @@ xfs_ioend_needs_wq_completion(
>  	if (ioend->io_flags & (IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_SHARED))
>  		return true;
>  
> -	/* Page cache invalidation cannot be done in irq context. */
> -	if (ioend->io_flags & IOMAP_IOEND_DONTCACHE)
> -		return true;
> -
>  	return false;
>  }

Ok, so higher layers can set it.

At this point, I'd suggest that we should not be making random
one-off changes to the iomap and filesystem layers like this just
for one operation that needs deferred IO completion work. This needs
to considered from the overall perspective of how we defer
completion work -  there are lots of different paths through
filesystems and/or iomap that require/use task deferal for IO
completion. We want them all to use the same mechanism - splitting
deferal between multiple layers depending on IO type is not a
particularly nice thing to be doing...

-Dave.
-- 
Dave Chinner
dgc@kernel.org
