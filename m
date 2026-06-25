Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB18925B099
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 18:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782410665; cv=none; b=FjVj+KRyhNKlRR62Kf0yC9dsozt1lpwmDbRuDjq0/i/neEhPTYqAzFY/Hn9cGDB9GsC4mt02F/ohR2yZR0L2/1WmWhrnc2AsC8iMcZAmtwmXR04GnO60Aa+GzElu3aOlN/pLSWTZa084gVZ/Y5eLorRd++8p4epZSOaJUdkZg6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782410665; c=relaxed/simple;
	bh=7D2kLqphyDHl3IG/rtXIiUkcjwTFWXXFGSt2/z7HsJM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UKEaEX2V5n8GAke27w8M7Qdiaqopjn2ZT6v+2Z6GKKZcjFuU818E1yXC9LzhITJq+fURwGQB42uUeDaL6IbJHdD4U68D4xyS06IfrGijnltiNAVtbYN+ZAc3DQOsSFILQi4VlZDdCy2yg6wuo+Ujglv5kIP9Zyvwk2LUjB9Iifw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lQ6huOXP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lQ6huOXP"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 479B11F000E9;
	Thu, 25 Jun 2026 18:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782410664;
	bh=siSEgZHZQu9UK0UAC0qsEDu99dQPyo3dpuX8xEbHl54=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lQ6huOXPS7Tpq6zoISThl0PU8fuwYMH+UAGuXQb+SJnlZKiGc5XxoUE01TjOyUuyx
	 ch1xu3oGXNlYuxUeE0Ryxg0hRezwitiJ6Fp9xBeDkkRb2N4ZwnxaSKoEHT1Ybk4ax2
	 AFUtxr1Hka4OygJCZbR5MTBLyJe+RyRZzUSJ+gm/Jiiu25UUsqIZRoo7Z+5RQajyJf
	 2cBBjQFMl7/9MOHA7SmcHRA1Y7CTZyQRXmlnH1QtHw7YEJ86cLjNdwczj5aAuEoNDq
	 lF6oX+plUOqV2ihOLwt0DQWel0TDcYLdpRLGzT76vLiP+RNajHtbiQUseR5BjdVcrQ
	 ghFdiTNHrQ+XQ==
Date: Thu, 25 Jun 2026 11:04:23 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 3/6] xfs: improve the xfs_buf_ioend_fail calling
 convention
Message-ID: <20260625180423.GH6078@frogsfrogsfrogs>
References: <20260625135849.2494779-1-hch@lst.de>
 <20260625135849.2494779-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625135849.2494779-4-hch@lst.de>

On Thu, Jun 25, 2026 at 03:58:33PM +0200, Christoph Hellwig wrote:
> Move setting the ASYNC flag into xfs_buf_ioend_fail, assert that the
> buffer is locked as expected, and drop the confusing _ioend in the
> name.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks straightforward to me...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c      | 13 +++++++------
>  fs/xfs/xfs_buf.h      |  2 +-
>  fs/xfs/xfs_buf_item.c |  3 +--
>  fs/xfs/xfs_inode.c    |  3 +--
>  4 files changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 5ce48d8062fa..83c74b5b7e8e 100644
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
> index b3cd1c7029f1..79cc9c3f0254 100644
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
> index 317eb57f989f..15279d22a894 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2646,8 +2646,7 @@ xfs_iflush_cluster(
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
> 
