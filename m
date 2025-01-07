Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAFA2594A3
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jan 2025 02:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215690; cv=none; b=Km4GqrsXVUoNkRvfvTrjt5oBlwTFThkDLqgjH5GWIxaJEF8UiCH775JlYU9r98oAg27yI0X54Ac6bOfHSQc8jhWEGRWojdbvJqEhSIk1U/Cwkxt42iOXft4ilB5w/QbSLW/av2cAAmgmrXS7hpRlLYlNT/n7M0RtQbdVKDgs08U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215690; c=relaxed/simple;
	bh=WOgcyzoHLlQdi/Stc1iLvPL3IjSc8V3HHejBl0GnhOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VZD1LJ9HnNWgCIqC37Co/OYwQXq6B3PDF0XNw8efDe5J0mkU/2DkciuAQuTAs/G7kCgJ9BbQf3P3piPyktrdyrBBdtgs2OT+d63QTqY3oSaUh5rqMlCnVglrI+udgpJj6P3LFDIoBrn3E9NQpy4R7ZAt4sGUFujv6xNeRDoGK4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CUU+SCr/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CUU+SCr/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80801C4CED2;
	Tue,  7 Jan 2025 02:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736215690;
	bh=WOgcyzoHLlQdi/Stc1iLvPL3IjSc8V3HHejBl0GnhOQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CUU+SCr/lZBhMmfDi3Qc1TgmSgap657f8bnmyHLVaYmH+MjpkA1zBGSL28F1AauXC
	 dxwE1LEThm6HIaVV5DGv6g9XSB2ehuJuLavPqwPZymE+FVcXRIFnSWQqGHw1yVZgmj
	 5vCA2GcDCJlzRbur54S3aBE/Qeo+uJu1MgJpPXr1Etl7d9z8Ss//qbKx8XkfV4RlhE
	 kS5tpROuJSaEtIlDrDqpn+GWYiqUENZH3yRDeFM45jYP8D1VoAQppK5QV/tVOvVANp
	 ZBPPUAHtF6yTqboCJ1pzqficr3+QB4zXP6nUCynHKCKojH0eZgk6IOZ/RRuUnHFj8j
	 FD0ZPVk7Vlcwg==
Date: Mon, 6 Jan 2025 18:08:10 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/15] xfs: simplify xfs_buf_delwri_pushbuf
Message-ID: <20250107020810.GW6174@frogsfrogsfrogs>
References: <20250106095613.847700-1-hch@lst.de>
 <20250106095613.847700-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106095613.847700-6-hch@lst.de>

On Mon, Jan 06, 2025 at 10:54:42AM +0100, Christoph Hellwig wrote:
> xfs_buf_delwri_pushbuf synchronously writes a buffer that is on a delwri
> list already.  Instead of doing a complicated dance with the delwri
> and wait list, just leave them alone and open code the actual buffer
> write.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c | 33 ++++++++-------------------------
>  1 file changed, 8 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index a3484421a6d8..7edd7a1e9dae 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -2391,14 +2391,9 @@ xfs_buf_delwri_submit(
>   * Push a single buffer on a delwri queue.
>   *
>   * The purpose of this function is to submit a single buffer of a delwri queue
> - * and return with the buffer still on the original queue. The waiting delwri
> - * buffer submission infrastructure guarantees transfer of the delwri queue
> - * buffer reference to a temporary wait list. We reuse this infrastructure to
> - * transfer the buffer back to the original queue.
> + * and return with the buffer still on the original queue.
>   *
> - * Note the buffer transitions from the queued state, to the submitted and wait
> - * listed state and back to the queued state during this call. The buffer
> - * locking and queue management logic between _delwri_pushbuf() and
> + * The buffer locking and queue management logic between _delwri_pushbuf() and
>   * _delwri_queue() guarantee that the buffer cannot be queued to another list
>   * before returning.
>   */
> @@ -2407,33 +2402,21 @@ xfs_buf_delwri_pushbuf(
>  	struct xfs_buf		*bp,
>  	struct list_head	*buffer_list)
>  {
> -	LIST_HEAD		(submit_list);
>  	int			error;
>  
>  	ASSERT(bp->b_flags & _XBF_DELWRI_Q);
>  
>  	trace_xfs_buf_delwri_pushbuf(bp, _RET_IP_);
>  
> -	/*
> -	 * Isolate the buffer to a new local list so we can submit it for I/O
> -	 * independently from the rest of the original list.
> -	 */
>  	xfs_buf_lock(bp);
> -	list_move(&bp->b_list, &submit_list);
> -	xfs_buf_unlock(bp);
> -
> -	/*
> -	 * Delwri submission clears the DELWRI_Q buffer flag and returns with
> -	 * the buffer on the wait list with the original reference. Rather than
> -	 * bounce the buffer from a local wait list back to the original list
> -	 * after I/O completion, reuse the original list as the wait list.
> -	 */
> -	xfs_buf_delwri_submit_buffers(&submit_list, buffer_list);
> +	bp->b_flags &= ~(_XBF_DELWRI_Q | XBF_ASYNC);
> +	bp->b_flags |= XBF_WRITE;
> +	xfs_buf_submit(bp);

Why is it ok to ignore the return value here?  Is it because the only
error path in xfs_buf_submit is the xlog_is_shutdown case, in which case
the buffer ioend will have been called already and the EIO will be
returned by xfs_buf_iowait?

--D

>  
>  	/*
> -	 * The buffer is now locked, under I/O and wait listed on the original
> -	 * delwri queue. Wait for I/O completion, restore the DELWRI_Q flag and
> -	 * return with the buffer unlocked and on the original queue.
> +	 * The buffer is now locked, under I/O but still on the original delwri
> +	 * queue. Wait for I/O completion, restore the DELWRI_Q flag and
> +	 * return with the buffer unlocked and still on the original queue.
>  	 */
>  	error = xfs_buf_iowait(bp);
>  	bp->b_flags |= _XBF_DELWRI_Q;
> -- 
> 2.45.2
> 
> 
