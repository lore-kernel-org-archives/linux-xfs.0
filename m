Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476143B5855;
	Wed,  4 Mar 2026 19:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772653984; cv=none; b=oXFdon+ofSV6gTnqz69VXBf3UKGvqAigm3s9NDHSMYguMvaEOnE8MSpfhGNA0IaWMB7FEvaSh8M8YM5gImXa4ByeBvy2UrG3kDCThGd/lRcdw19eJQm3d/w1gXA6rGM06igGxENITFPlOiTj1t6/QjuQkKBDuPTR1L8kOoomi1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772653984; c=relaxed/simple;
	bh=fZXeDV0MQgXO6/AUIn8T7lf+eto/LLOU0dmcBROo+II=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HxB7nnKYtMQYADrdZnTJLyxJkvdIov602tz6J1ppOiZJSwTunFtWUsplYD1qUGOJ7oEs7FrFjgu2qYhzCyN1XgThnuvPDskv1BlpQPVIU2yx7AmNRgZsYH4ipgScrVa2ADmW0Q1ayRyuwQCXvCM9y93bNMq0fJexFrRN7QzpWl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dA1iMUfk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dA1iMUfk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81DBC4CEF7;
	Wed,  4 Mar 2026 19:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772653983;
	bh=fZXeDV0MQgXO6/AUIn8T7lf+eto/LLOU0dmcBROo+II=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dA1iMUfkLX2+o3fisaAizFL7Ta6XI9hfM4LZefPUhIggF6O8YBEV3HdPcLfomnBMM
	 vLtAOb/R6wwH9wc7r/VGC3W46Q82+OT+OMWUT282ELx/USrVmh+QmecRPmdRnUgiKx
	 BwPdQ79D8zMU8qf3GgEWCh6xqvOO2FheVgoKg47K9aou8reTMa2wu85Ah0pbvBJ6gf
	 SJyRNQj3vEI8Ch/eF1zLRGJful+4cT4F18o6SRx5HbWv0xxBN2o7ntZIFzwtUqkEa1
	 lYEBYKMwAZlJVWtF+DWK/vssUmHbSpOxf361OiIb9O7VuZ9kT2tvWTnTDIA/Zs2iza
	 sxFsXwGFsC3/w==
Date: Wed, 4 Mar 2026 11:53:03 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: don't clobber bi_status in xfs_zone_alloc_and_submit
Message-ID: <20260304195303.GA57948@frogsfrogsfrogs>
References: <20260304185923.291592-1-agruenba@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304185923.291592-1-agruenba@redhat.com>

On Wed, Mar 04, 2026 at 07:59:20PM +0100, Andreas Gruenbacher wrote:
> Function xfs_zone_alloc_and_submit() sets bio->bi_status and then it
> calls bio_io_error() which overwrites that value again.  Fix that by
> completing the bio separately after setting bio->bi_status.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>

Yeah, that make sense to me that we shouldn't override the value set in
out_split_error.

Cc: <stable@vger.kernel.org> # v6.15
Fixes: 4e4d5207557770 ("xfs: add the zoned space allocator")
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_zone_alloc.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index e3d19b6dc64a..c3328b9dda37 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -862,7 +862,7 @@ xfs_zone_alloc_and_submit(
>  	bool			is_seq;
>  
>  	if (xfs_is_shutdown(mp))
> -		goto out_error;
> +		goto out_io_error;
>  
>  	/*
>  	 * If we don't have a locally cached zone in this write context, see if
> @@ -875,7 +875,7 @@ xfs_zone_alloc_and_submit(
>  select_zone:
>  		*oz = xfs_select_zone(mp, write_hint, pack_tight);
>  		if (!*oz)
> -			goto out_error;
> +			goto out_io_error;
>  		xfs_set_cached_zone(ip, *oz);
>  	}
>  
> @@ -902,7 +902,10 @@ xfs_zone_alloc_and_submit(
>  
>  out_split_error:
>  	ioend->io_bio.bi_status = errno_to_blk_status(PTR_ERR(split));
> -out_error:
> +	bio_endio(&ioend->io_bio);
> +	return;
> +
> +out_io_error:
>  	bio_io_error(&ioend->io_bio);
>  }
>  
> -- 
> 2.52.0
> 
> 
