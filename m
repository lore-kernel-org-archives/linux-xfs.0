Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBFD54BDE
	for <linux-xfs@vger.kernel.org>; Tue,  7 May 2024 20:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715115503; cv=none; b=bcIjdkctJY/QMtoQGfw/koHfLP43EsuBY6YKy+Lp4+yu0omD4AFm0BPMqpjCE6Ko1DVyhH8f+v42iOb+QAdDg2gVpnAbaL+dhVV5V5GS5uaVT+7c10oYjbw3esLBp9I5E1nmLQVIgL9OrhhbyJlUtaoy2lWa/kxgrglho5AT1LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715115503; c=relaxed/simple;
	bh=WxhTFwI2o6Fm3LHWOkGHgAPmkvtUReKgoWwpq5q7XSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mwP1+gjj46tjHFueBvoFn3D8+22HEbGYXZ4u4ggvNmpeyd85twcp0mcVJi5GAqeyl1SGgEfDh6Hz5hK+F7qianfXt6l2N47jfN18E+ZgazhB/BO4PYoj5uQxN0E/yJau1/IFu7YODuD1Vd76KwXAES8oAv2hw9LvOcskFtEAyHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BGlbTTML; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BGlbTTML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E079FC2BBFC;
	Tue,  7 May 2024 20:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715115502;
	bh=WxhTFwI2o6Fm3LHWOkGHgAPmkvtUReKgoWwpq5q7XSA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BGlbTTMLa6Yh4WrrF0M3E+aWfE6mFZjMgWQC+cRP3bNNNjZuA9iyoUMbxvdxl/cee
	 IsFyJZzvrUNlVsRm1uKwkLBUgHFpDvw5dPvlisnXUAKnRA9K7giWxay9mPxQVSpSAV
	 G57vwM2Uu5fHJHwX4VMxpjqUThKxP3VlLDFLFsMW78ND+0v6SrovJICI8ldlVYcQ7X
	 MarBj7Gnqo/TiqsH1UobrOsrof3BQXdsS1LNzbb5j04wBy5yGQcLJqz8twt5PLQFt5
	 YWpxJBAvwDyiKPEa4tZqHrZs16kC+yF++Jq+TIr6TKMD5azr1Qgm/OkB+dFByTRjTA
	 02/XQ88qlNc9w==
Date: Tue, 7 May 2024 13:58:22 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: chandan.babu@oracle.com, dchinner@redhat.com, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC 1/2] xfs: Fix xfs_flush_unmap_range() range for RT
Message-ID: <20240507205822.GR360919@frogsfrogsfrogs>
References: <20240503140337.3426159-1-john.g.garry@oracle.com>
 <20240503140337.3426159-2-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240503140337.3426159-2-john.g.garry@oracle.com>

On Fri, May 03, 2024 at 02:03:36PM +0000, John Garry wrote:
> Currently xfs_flush_unmap_range() does a flush for full FS blocks. Extend
> this to cover full RT extents so that any range overlap with start/end of
> the modification are clean and idle. 
> 
> This code change is originally from Dave Chinner.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  fs/xfs/xfs_bmap_util.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 2e6f08198c07..da67c52d5f94 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -802,12 +802,16 @@ xfs_flush_unmap_range(
>  	xfs_off_t		offset,
>  	xfs_off_t		len)
>  {
> -	struct xfs_mount	*mp = ip->i_mount;
>  	struct inode		*inode = VFS_I(ip);
>  	xfs_off_t		rounding, start, end;
>  	int			error;
>  
> -	rounding = max_t(xfs_off_t, mp->m_sb.sb_blocksize, PAGE_SIZE);
> +	/*
> +	 * Make sure we extend the flush out to extent alignment
> +	 * boundaries so any extent range overlapping the start/end
> +	 * of the modification we are about to do is clean and idle.
> +	 */
> +	rounding = max_t(xfs_off_t, xfs_inode_alloc_unitsize(ip), PAGE_SIZE);
>  	start = round_down(offset, rounding);

round_down requires the divisor to be a power of two.

--D

>  	end = round_up(offset + len, rounding) - 1;
>  
> -- 
> 2.31.1
> 
> 
