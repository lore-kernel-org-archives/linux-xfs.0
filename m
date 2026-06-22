Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219F7399D08
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 12:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782133150; cv=none; b=ZsXglX4fSmv0gwlArDvT7iwtMCNUd8gB2MUxhfnqVBEloYubyUMmmvIzE3p/z7w1MWyT84g9tHubBT7PEwmb4iZjxCGfx5X3Odf5ayPEwpWXBXKbX5PruZsyaci6dS3VyJ+h5L77vju1/e5di2N6w+KIWvri7jJV1MZ1hn3Fqkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782133150; c=relaxed/simple;
	bh=8UHw2W1zKoo+MQud/s5mKutDPVmikCNLhMYr+P1L+yM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tZ2hmFPS888sxdxmMRNlN5/WdapzdCmNuRutbLyOMDeLlDn4d7gIvStHtUj2xUAJYfs4IZw+Hn0j4yTUOaZD3179CORJxniAd7/TVhxbQQSMYwwm7YwiM6luKCFCDE8rIQj+SRTFtC5iKs8DPdU687NhCR3pGD2D6U8V74rvwQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YOS8ZDBC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YOS8ZDBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC6C1F000E9;
	Mon, 22 Jun 2026 12:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782133148;
	bh=hMnvFxa/fECcQf/2Iexe2LSRrXUchNoAEYiODnCac3w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YOS8ZDBCxzoMPBygg/mW0liBarXU4RMW4pcTNG8rIr7n4JGIUnXhNpeofjt83r9hc
	 tND8HG2yUmGqa07zknTKg50Q1wRk3btVOMB8EJ842K5h2Snz2g3S+hERGba/ywtoMi
	 B5Scw3NhNBJZLEv1fAJQcotIqzEPm4y7MgH9PFKUuoOBzpUqewsuJ1BaAxdl3oaaqP
	 4h4LBfnbvbeCHdycd5sJpwPeFH8HZoxEBSPCSMPXTvnIsMyYPEkuJh2wE/csvvK8vQ
	 uxxDUG+2MMYSwiSL6FZzEoVy0OIF/11IOSci1s4uLGfMEHspm9jkWrSj6nkQnZtxI7
	 6G9TZNFPZYrzA==
Date: Mon, 22 Jun 2026 14:59:05 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: improve the xfs_buf_ioend_fail calling
 convention
Message-ID: <ajkxAU-VxjRrHVS0@nidhogg.toxiclabs.cc>
References: <20260622073035.1370904-1-hch@lst.de>
 <20260622073035.1370904-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622073035.1370904-4-hch@lst.de>

On Mon, Jun 22, 2026 at 09:30:02AM +0200, Christoph Hellwig wrote:
> Move setting the ASYNC flag into xfs_buf_ioend_fail_async, assert that
				  Is this a typo? I can't find this
				  definition anywhere and the code also
				  moves this into xfs_buf_ioend_fail(),
				  not into a _async variation.


> the buffer is locked as expected, and drop the confusing _ioend in the
> name.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c      | 13 +++++++------
>  fs/xfs/xfs_buf.h      |  2 +-
>  fs/xfs/xfs_buf_item.c |  3 +--
>  fs/xfs/xfs_inode.c    |  3 +--
>  4 files changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 60ef53acebd2..ef2ea15a97bb 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1192,17 +1192,18 @@ xfs_buf_ioerror_alert(
>  }
>  
>  /*
> - * To simulate an I/O failure, the buffer must be locked and held with at least
> - * two references.
> + * Fail a locked and referenced buffer outside the I/O path.
>   *
> - * The buf item reference is dropped via ioend processing. The second reference
> - * is owned by the caller and is dropped on I/O completion if the buffer is
> - * XBF_ASYNC.
> + * The caller transfers a reference which will be released after processing the
> + * error.
>   */
>  void
> -xfs_buf_ioend_fail(
> +xfs_buf_fail(
>  	struct xfs_buf	*bp)
>  {
> +	ASSERT(xfs_buf_islocked(bp));
> +
> +	bp->b_flags |= XBF_ASYNC;
>  	bp->b_flags &= ~XBF_DONE;
>  	xfs_buf_stale(bp);
>  	xfs_buf_ioerror(bp, -EIO);
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index bf39d89f0f6d..690002d3dd2b 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -290,7 +290,7 @@ extern void __xfs_buf_ioerror(struct xfs_buf *bp, int error,
>  		xfs_failaddr_t failaddr);
>  #define xfs_buf_ioerror(bp, err) __xfs_buf_ioerror((bp), (err), __this_address)
>  extern void xfs_buf_ioerror_alert(struct xfs_buf *bp, xfs_failaddr_t fa);
> -void xfs_buf_ioend_fail(struct xfs_buf *);
> +void xfs_buf_fail(struct xfs_buf *bp);
>  void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
>  #define xfs_buf_mark_corrupt(bp) __xfs_buf_mark_corrupt((bp), __this_address)
>  
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 8487635579e5..1f055cd6732e 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -549,8 +549,7 @@ xfs_buf_item_unpin(
>  		 * wait for the lock and then run the IO failure completion.
>  		 */
>  		xfs_buf_lock(bp);
> -		bp->b_flags |= XBF_ASYNC;
> -		xfs_buf_ioend_fail(bp);
> +		xfs_buf_fail(bp);
>  		return;
>  	}
>  
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 9978ac1422fc..15facb0631d1 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2634,8 +2634,7 @@ xfs_iflush_cluster(
>  		 * inode cluster buffers.
>  		 */
>  		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> -		bp->b_flags |= XBF_ASYNC;
> -		xfs_buf_ioend_fail(bp);
> +		xfs_buf_fail(bp);
>  		return error;
>  	}
>  
> -- 
> 2.53.0
> 
