Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEEB11714
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 08:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rWbTRKq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15441C433C8;
	Mon, 18 Dec 2023 08:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702889787;
	bh=+3xF/KmAV0P9ZpkUKB+bLzp3qeEKP2kdMqPB0VjWIDI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rWbTRKq4P6GYg5VUc5d30Rv+R31noRxtxYz646nauBgeAivF/a+pmCuhbSkcxmeRa
	 3/d2YwzHjAQLVFhrnEHEYJ6tLI/A2rw93XbomTb2hBUeZwQeQX5l6y33YSDzLeJJY7
	 gv4AYaojUkNXPylM8pgxl43GR3kQlxGjY6ZhiH+MJyUpIxQX7/3CRjtRXo+ScIh0PA
	 2UYPkZFMnPzQoeARC98fMr1209MHH92yMZXN4z/5aDL16uCNyA9glT5cwDgfVDbf/p
	 Sd35YRRNhRxR5FTb1tl6huJDb7tIl866gI8V8Hk1pRkU/K6CjsDsWEj+rI8VXTG7FS
	 sGo+wRaxG0Mpw==
Date: Mon, 18 Dec 2023 09:56:24 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/23] libxlog: remove the verbose argument to
 xlog_is_dirty
Message-ID: <e3kaq4hpe54o7zhry5sqyy7nfkcj52wcgodegm6qbaqvqijvky@hnnwyydew74a>
References: <20231211163742.837427-1-hch@lst.de>
 <JgbFcwkeeGas24CkiuLzZF4CUCoEhxuZFvjESwDidN9fxD0jMX7TENvV9tZdjUUmoW6bcg4ReVZyukvlDiD6lQ==@protonmail.internalid>
 <20231211163742.837427-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211163742.837427-7-hch@lst.de>

On Mon, Dec 11, 2023 at 05:37:25PM +0100, Christoph Hellwig wrote:
> No caller passes a non-zero verbose argument to xlog_is_dirty.
> Remove the argument the code keyed off by it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  copy/xfs_copy.c   | 2 +-
>  db/metadump.c     | 4 ++--
>  db/sb.c           | 2 +-
>  include/libxlog.h | 3 +--
>  libxlog/util.c    | 8 +-------
>  5 files changed, 6 insertions(+), 13 deletions(-)
> 
> diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
> index 66728f199..4bd473a04 100644
> --- a/copy/xfs_copy.c
> +++ b/copy/xfs_copy.c
> @@ -784,7 +784,7 @@ main(int argc, char **argv)
>  	 */
>  	memset(&xlog, 0, sizeof(struct xlog));
>  	mp->m_log = &xlog;
> -	c = xlog_is_dirty(mp, mp->m_log, &xargs, 0);
> +	c = xlog_is_dirty(mp, mp->m_log, &xargs);
>  	if (!duplicate) {
>  		if (c == 1) {
>  			do_log(_(
> diff --git a/db/metadump.c b/db/metadump.c
> index f9c82148e..e57b024cd 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -2615,7 +2615,7 @@ copy_log(void)
>  	if (!metadump.obfuscate && !metadump.zero_stale_data)
>  		goto done;
> 
> -	dirty = xlog_is_dirty(mp, &log, &x, 0);
> +	dirty = xlog_is_dirty(mp, &log, &x);
> 
>  	switch (dirty) {
>  	case 0:
> @@ -2945,7 +2945,7 @@ metadump_f(
>  		if (iocur_top->data) {	/* best effort */
>  			struct xlog	log;
> 
> -			if (xlog_is_dirty(mp, &log, &x, 0))
> +			if (xlog_is_dirty(mp, &log, &x))
>  				metadump.dirty_log = true;
>  		}
>  		pop_cur();
> diff --git a/db/sb.c b/db/sb.c
> index 2d508c26a..a3a4a758f 100644
> --- a/db/sb.c
> +++ b/db/sb.c
> @@ -235,7 +235,7 @@ sb_logcheck(void)
> 
>  	libxfs_buftarg_init(mp, x.ddev, x.logdev, x.rtdev);
> 
> -	dirty = xlog_is_dirty(mp, mp->m_log, &x, 0);
> +	dirty = xlog_is_dirty(mp, mp->m_log, &x);
>  	if (dirty == -1) {
>  		dbprintf(_("ERROR: cannot find log head/tail, run xfs_repair\n"));
>  		return 0;
> diff --git a/include/libxlog.h b/include/libxlog.h
> index 3ade7ffaf..a598a7b3c 100644
> --- a/include/libxlog.h
> +++ b/include/libxlog.h
> @@ -71,9 +71,8 @@ extern int	print_record_header;
>  /* libxfs parameters */
>  extern libxfs_init_t	x;
> 
> +int xlog_is_dirty(struct xfs_mount *mp, struct xlog *log, libxfs_init_t *x);
> 
> -extern int xlog_is_dirty(struct xfs_mount *, struct xlog *, libxfs_init_t *,
> -			 int);
>  extern struct xfs_buf *xlog_get_bp(struct xlog *, int);
>  extern int	xlog_bread(struct xlog *log, xfs_daddr_t blk_no, int nbblks,
>  				struct xfs_buf *bp, char **offset);
> diff --git a/libxlog/util.c b/libxlog/util.c
> index ad60036f8..1022e3378 100644
> --- a/libxlog/util.c
> +++ b/libxlog/util.c
> @@ -19,8 +19,7 @@ int
>  xlog_is_dirty(
>  	struct xfs_mount	*mp,
>  	struct xlog		*log,
> -	libxfs_init_t		*x,
> -	int			verbose)
> +	libxfs_init_t		*x)
>  {
>  	int			error;
>  	xfs_daddr_t		head_blk, tail_blk;
> @@ -58,11 +57,6 @@ xlog_is_dirty(
>  		return -1;
>  	}
> 
> -	if (verbose)
> -		xlog_warn(
> -	_("%s: head block %" PRId64 " tail block %" PRId64 "\n"),
> -			__func__, head_blk, tail_blk);
> -
>  	if (head_blk != tail_blk)
>  		return 1;
> 
> --
> 2.39.2
> 
