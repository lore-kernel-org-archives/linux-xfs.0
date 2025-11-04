Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC542DF71
	for <linux-xfs@vger.kernel.org>; Tue,  4 Nov 2025 23:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762300389; cv=none; b=PHhqlcoxCbL6rMLiAOUnzJsa9lz6V/y/gGt0JskUMgZ/KCJu63DH42qcfnEXXY90A61i5Zi/PaOvq36tGa11H3LrnyiUH3q7VB/0GYqD/p4g+/XouW8FXeZBj7qZgIy0ypyWcnHRC5hHL1ZjVxSqkhiFhi7Wlt/8VOe2+alHK8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762300389; c=relaxed/simple;
	bh=gjICkyEWaYAcfbpfFqfESEWNqlmzUsk7mj8+MFE0ktg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UQbQLiUOEF22tKiWFRYY3yCAtMLpYpEvUuDa2Yp8A+DptYF6aiU5SyeSw0IP3u7Lj9D/WgDcjhFaU2le7Du/J5XOstk0d3z4Cu57nbi1ZxXPqJG9iFhfZGJpztdb20STWdHq+HmQuM8VqiQyG/vDO4z21jboRlcYmYWVrgvm22g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cPFPkbEh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cPFPkbEh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C43C4CEF7;
	Tue,  4 Nov 2025 23:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762300389;
	bh=gjICkyEWaYAcfbpfFqfESEWNqlmzUsk7mj8+MFE0ktg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cPFPkbEhVQ8UzIxOUK1upwDjlfPp7uF3uY4+GoHneyVeFctsRbbXLSIbrDI5Whl+l
	 KakVmBdS+7XF9rLkV44t17phZGJ/FMjbVYZ9YSehMOfERvx7Kexysc2rltfLDGJKKi
	 PYEfKieSFVcNE16rh7mpW5qPUJGzZDrSLLCWOmkcql6L0KbehdYmiVA6u+LbMyCO7m
	 IlMt3r32hFmkavzCyqpJKzjl7DgTqhzXZQnX3D5tpnjCq0y4mWPyG0bvAt83xloGkt
	 oKH40a/iTFf0bFA3bgxW/gh9n9llgqiJ5K68HakaExbjrYg65chLkAfHxe0uR+Umc9
	 f9wQhqv75AKrg==
Date: Tue, 4 Nov 2025 15:53:09 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/10] xfs: regularize iclog space accounting in
 xlog_write_partial
Message-ID: <20251104235309.GT196370@frogsfrogsfrogs>
References: <20251030144946.1372887-1-hch@lst.de>
 <20251030144946.1372887-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251030144946.1372887-7-hch@lst.de>

On Thu, Oct 30, 2025 at 03:49:16PM +0100, Christoph Hellwig wrote:
> When xlog_write_partial splits a log region over multiple iclogs, it
> has to include the continuation ophder in the length requested for the
> new iclog.  Currently is simply adds that to the request, which makes
> the accounting of the used space below look slightly different from the
> other users of iclog space that decrement it.  To prepare for more code
> sharing, adding the ophdr size to the len variable before the call to
> xlog_write_get_more_iclog_space and then decrement it later.
> 
> This changes the contents of len when xlog_write_get_more_iclog_space
> returns an error, but as nothing looks at len in that case the
> difference doesn't matter.

Ooops, sorry I missed this patch. :(

It makes sense to me that we have to account for the continuation when
asking for a fresh iclog, but now I have a question.  In "xfs: improve
the calling convention for the xlog_write helpers", the len pointer
becomes xlog_write_data::bytes_left.  In the context of this patch, I
guess that means "len" is the amount of log data that we still have to
write to the log, correct?

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 93e99d1cc037..539b22dff2d1 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2048,10 +2048,10 @@ xlog_write_partial(
>  			 * consumes hasn't been accounted to the lv we are
>  			 * writing.
>  			 */
> +			*len += sizeof(struct xlog_op_header);
>  			error = xlog_write_get_more_iclog_space(ticket,
> -					&iclog, log_offset,
> -					*len + sizeof(struct xlog_op_header),
> -					record_cnt, data_cnt);
> +					&iclog, log_offset, *len, record_cnt,
> +					data_cnt);
>  			if (error)
>  				return error;
>  
> @@ -2064,6 +2064,7 @@ xlog_write_partial(
>  			ticket->t_curr_res -= sizeof(struct xlog_op_header);
>  			*log_offset += sizeof(struct xlog_op_header);
>  			*data_cnt += sizeof(struct xlog_op_header);
> +			*len -= sizeof(struct xlog_op_header);
>  
>  			/*
>  			 * If rlen fits in the iclog, then end the region
> -- 
> 2.47.3
> 
> 
