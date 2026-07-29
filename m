Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010623803F9;
	Wed, 29 Jul 2026 20:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785358387; cv=none; b=U95hey7EDKic7EhSxxojvI0j6HdFhaTddgDnYLNRt1bQRZxwaJidbwFFlziwNYyFhcP7VOA/K8UGAhj6bA3lXK0vbO6dNRapdbnGXIREaXe6rsds/FzRt+OvdCsnO4uvXze2BaNlVb5dckaSFxM/Tg9Mu50QwbZkp4wzKGYzqDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785358387; c=relaxed/simple;
	bh=96UoboMCUHZqTsuGDf57LAiSWdVfTiXL/gx4OmYFLNY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bKjfrwNoyr2W8xuj6heqSQMN/8WfHSgmmd13Bui/xrl5rGraUYakza3NvZJ9Y6ayZwx9lBoq7JotMC61YIx6QeP9cxlpTbVzneThOxm0WYvOlzgwjNgl14UDmjmH/yLbwbSThivJ3Mbstt/m+l4gFKdZOR43q3czYKlgreHaoBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GSwaCl8a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GSwaCl8a"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7C5231F00A3A;
	Wed, 29 Jul 2026 20:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785358385;
	bh=D1vU9pAQ04SFSDbyWPd6SqMiDXXqS0judRGECtrcaho=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GSwaCl8a733EwKZTiqodmAkNGhZbzaySKq5dpqAPqEN2pBVI+rIck+lkSOkoB+Dv9
	 9IvgH2mXYHubdTGnrR4MCjV8z/02ugnXQZFXys6AescHZ87qn8MzhDMlmBn8dr0GAq
	 kD+WGUdnA26lmurSJ6+lTJ2Y7FB3JyuwWp1BmVkOY8+Y/KO0kuciyS9vE1bOVJJbg1
	 Dcxb530UwYsJOd5NyIsRhd1G7Om3N/yXES5IqOMh7yNhC6K4LFjuDGSmIVo5wrJCzP
	 vuYjV1IFcFEdvvyh4aluilzME11gkyPXAOYGFbZ5PAaXJmmjHARuCj9JWjaGWpvAUy
	 W3fL6EQR4rIGA==
Date: Wed, 29 Jul 2026 13:53:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, hch@lst.de,
	linux-fsdevel@vger.kernel.org, changfengnan@bytedance.com,
	kbusch@kernel.org, Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>, Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>, libaokun@linux.alibaba.com,
	bfoster@redhat.com, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH v5 01/22] iomap: release the folio batch on iomap
 callback failures
Message-ID: <20260729205304.GA2901224@frogsfrogsfrogs>
References: <20260729192737.3190206-1-joannelkoong@gmail.com>
 <20260729192737.3190206-2-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729192737.3190206-2-joannelkoong@gmail.com>

On Wed, Jul 29, 2026 at 12:27:16PM -0700, Joanne Koong wrote:
> From: Brian Foster <bfoster@redhat.com>
> 
> A sashiko review of an unrelated patch points out that the folio
> batch mechanism used for iomap zero range fails to release the batch
> in a couple error scenarios. If either calls to ->iomap_end() or
> ->iomap_begin() fail, the direct return paths bypass the batch
> cleanup.
> 
> The ->iomap_end() case is not a practical issue at the moment
> because there is no user of the mechanism that returns an error from
> this path. The ->iomap_begin() case is theoretically possible
> because XFS can invoke the fill helper and error out at various
> points thereafter. This subtly complicates things because XFS does
> not transfer iomap_flags to the iomap data structure in the error
> path.
> 
> To deal with both of these issues, first make sure to invoke the
> cleanup helper in the error path for either fs callback. Second,
> update the helper to clear the flag unconditionally and release the
> batch so long as it is populated. This more clearly delineates the
> purpose of the flag to control the I/O path and not necessarily the
> status of the fbatch, so add a comment around this as well.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Assisted-by: LLM
> Fixes: 395ed1ef0012 ("iomap: optional zero range dirty folio processing")
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Seems reasonable to me,

Cc: <stable@vger.kernel.org> # v6.19
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/iomap/iter.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
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
> -- 
> 2.52.0
> 
> 
