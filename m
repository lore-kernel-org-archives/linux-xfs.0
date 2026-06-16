Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F4D43E490
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 17:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629441; cv=none; b=G1EALa9ehfFSGwxXM2D1ggOWksXu6teOBdumYNiafYxoSBycmfgBLMoGfGGexc+c9A7Yec9l403HSf9DjwcHURuRUjxUN6u1y8lxOHZkxNbwlxXAQf5jewGOF4V8biYFAzk7Ka3IGy/D3YN/19ptvb9p+yW0kQO+i52OYZz7fWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629441; c=relaxed/simple;
	bh=KcfJKSX5qwOoayTBBHpB1/1R+ZVn/4FH1WHtvgNNut0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a2iPs0sRo4B4FgFifiKdgm3dRS6t4kesMyw7vsS6e6pFUN7ZpdY6LoNMiU++o7WE/KjrVvE0q/MUI8Ta2ApS/HydwUOHMAIpy5B93hwqCCnOG/gJyWHjeyS82wYgQSFheaghOuJ3XONj6qmgY4CciWThx0gtqrE31cgZtzeLwLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PSMid8C5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PSMid8C5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781629439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wpRck+/vYX+Rj55sg1OaxMWZnrBR7i62r9W58hH+LLE=;
	b=PSMid8C5t4YDWwzEzjJpLMLYbNwgMD5xitTivU53V1lFjAn4N6USZsGRsqIJYA9+9qCM6o
	F3lC+YZeKDd1LjQAP2ePQdMa1eZ4h6CqUhuJBmaRs2RHzSqpNIIn/b+FX4DKDY/EvJ7xCl
	QelMjmnRgg4IRu22wUuyXyOm6dOtbtQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-586-nabaUg1DP9aMmJ9Ilu36GA-1; Tue,
 16 Jun 2026 13:03:56 -0400
X-MC-Unique: nabaUg1DP9aMmJ9Ilu36GA-1
X-Mimecast-MFC-AGG-ID: nabaUg1DP9aMmJ9Ilu36GA_1781629434
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 074A91955F54;
	Tue, 16 Jun 2026 17:03:54 +0000 (UTC)
Received: from bfoster (unknown [10.22.89.36])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2815830001A1;
	Tue, 16 Jun 2026 17:03:53 +0000 (UTC)
Date: Tue, 16 Jun 2026 13:03:50 -0400
From: Brian Foster <bfoster@redhat.com>
To: Kyle Zeng <kylebot@openai.com>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	outbounddisclosures@openai.com
Subject: Re: [PATCH] xfs: validate recovered buffer item dirty bitmaps
Message-ID: <ajGB9o5Ys6itU3Rh@bfoster>
References: <20260611212314.4610-1-kylebot@openai.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611212314.4610-1-kylebot@openai.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Thu, Jun 11, 2026 at 02:23:14PM -0700, Kyle Zeng wrote:
> XFS buffer log recovery trusts the dirty bitmap in recovered buffer log
> items when replaying logged regions into the buffer.  The replay path only
> has debug assertions to check that each bitmap extent fits within the
> buffer described by blf_len.
> 
> A corrupted log can therefore set a dirty bit beyond the end of the
> recovered buffer.  In non-debug builds, xlog_recover_do_reg_buffer() will
> copy the corresponding logged region to that out-of-range buffer offset.
> 
> Validate the recovered dirty bitmap and the associated logged data regions
> before replay.  Reject buffer items whose dirty extents extend beyond
> blf_len, whose region count does not match the bitmap, or whose data iovecs
> are malformed.
> 
> Assisted-by: Codex:gpt-5.5
> Signed-off-by: Kyle Zeng <kylebot@openai.com>
> ---

This looks reasonable to me at first look, but a few questions..

Do you have a test or reproducer to trigger this issue that we could
incorportate into fstests? That said, I am wondering if that might be
difficult if say checksumming gets in the way, but it can't hurt to
think about at least.

>  fs/xfs/xfs_buf_item_recover.c | 63 +++++++++++++++++++++++++++++++++++
>  1 file changed, 63 insertions(+)
> 
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index 02b95b89d1b5..576d6245e922 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -206,6 +206,63 @@ xlog_recover_buf_commit_pass1(
>  	return 0;
>  }
>  
> +/*
> + * Make sure the recovered dirty bitmap only describes ranges inside the
> + * recovered buffer and that each logged region is backed by one data iovec.
> + */
> +STATIC int xlog_recover_validate_buf_data_map(struct xfs_mount *mp,
> +					      struct xlog_recover_item *item,
> +					      struct xfs_buf_log_format *buf_f)
> +{
> +	u64				buf_bytes = BBTOB(buf_f->blf_len);
> +	int				i = 1;
> +	int				bit = 0;
> +
> +	while (1) {
> +		u64			reg_bytes;
> +		u64			reg_end;
> +		int			nbits;
> +
> +		bit = xfs_next_bit(buf_f->blf_data_map, buf_f->blf_map_size,
> +				   bit);
> +		if (bit == -1)
> +			break;
> +
> +		nbits = xfs_contig_bits(buf_f->blf_data_map,
> +					buf_f->blf_map_size, bit);
> +		if (XFS_IS_CORRUPT(mp, nbits <= 0))
> +			return -EFSCORRUPTED;
> +
> +		reg_bytes = (u64)nbits << XFS_BLF_SHIFT;
> +		reg_end = ((u64)bit << XFS_BLF_SHIFT) + reg_bytes;
> +		if (XFS_IS_CORRUPT(mp, reg_end > buf_bytes))
> +			return -EFSCORRUPTED;
> +
> +		if (XFS_IS_CORRUPT(mp, i >= item->ri_total))
> +			return -EFSCORRUPTED;
> +		if (XFS_IS_CORRUPT(mp, !item->ri_buf[i].iov_base))
> +			return -EFSCORRUPTED;
> +		if (XFS_IS_CORRUPT(mp, item->ri_buf[i].iov_len == 0 ||
> +				   item->ri_buf[i].iov_len % XFS_BLF_CHUNK))
> +			return -EFSCORRUPTED;
> +		if (XFS_IS_CORRUPT(mp, item->ri_buf[i].iov_len > reg_bytes))
> +			return -EFSCORRUPTED;
> +

It looks like these checks are mostly promoted from asserts in
_do_reg_buffer(), right? If so that is worth pointing out in the commit
log. I'm also curious why we'd keep the asserts around at all, at least
the ones that are purely duplicated by the runtime checks, since it
seems we can no longer hit them.

> +		/*
> +		 * A single contiguous dirty range can be split into multiple
> +		 * log vectors.  Advance by the amount covered by this iovec.
> +		 */
> +		nbits = item->ri_buf[i].iov_len >> XFS_BLF_SHIFT;
> +		i++;
> +		bit += nbits;

Hmm along the same lines, I see something like this being duplicated and
wonder.. why not promote the asserts to runtime checks within the
do_reg_buffer() function where we already walk the vectors (and modify
so it can return error)?

Do we miss any protection by doing that that I'm not seeing? If not,
then at least we're not spinning through the list multiple times or
duplicating logic quirks like the above. Hm?

Brian

> +	}
> +
> +	if (XFS_IS_CORRUPT(mp, i != item->ri_total))
> +		return -EFSCORRUPTED;
> +
> +	return 0;
> +}
> +
>  /*
>   * Validate the recovered buffer is of the correct type and attach the
>   * appropriate buffer operations to them for writeback. Magic numbers are in a
> @@ -1033,6 +1090,12 @@ xlog_recover_buf_commit_pass2(
>  			goto cancelled;
>  	}
>  
> +	error = xlog_recover_validate_buf_data_map(mp, item, buf_f);
> +	if (error) {
> +		ASSERT(error == -EFSCORRUPTED);
> +		return error;
> +	}
> +
>  	trace_xfs_log_recover_buf_recover(log, buf_f);
>  	error = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno, buf_f->blf_len,
>  			  0, &bp, NULL);
> -- 
> 2.43.0
> 

