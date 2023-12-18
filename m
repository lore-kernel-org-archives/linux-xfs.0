Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355E6111B5
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 09:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oH1r541P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77A0C433C7;
	Mon, 18 Dec 2023 09:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702891121;
	bh=tkHCV9865yOcpWK5bCZfMp9v+1H/QF+mfgh+ZPp59FY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oH1r541P0nTLpSi0SgHnGoblRa58GDgv7yv+0d6k7dIzpZRd+yYgEuIhzfU+k1ImP
	 cMUS8R+dvqGxwwCJKyRO4JBBR5XxUUvmNTcMpPQSUXg9ug2MXExajRLADqQEapwgTf
	 6HkDMPOeLJwJfZfsQBqwWdOft5XSk+hVqifbnDVsbU4pGcrNiKR4EnyMxXvnVUJz2z
	 MbNu/JFwkMkaCHgy2YIfHq7dOESF6j3ZKqqOSdNAQjC5zWOM0/oXNKMACkmnbTUShk
	 rboDP/poQt3cHMjedwGmu5HtzKRP/dQBIEdARX2eg1Ho30noFBOd3aDPV/e8dTQ+4J
	 28n42ldQ7PsEg==
Date: Mon, 18 Dec 2023 10:18:37 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/23] libxlog: remove the global libxfs_xinit x structure
Message-ID: <2srnqtntkdf7zo4xotxvmo3xdtwjzsrhpt7kbppzrvznjocyne@v2gbjbsb3vw7>
References: <20231211163742.837427-1-hch@lst.de>
 <FYBraPwYxNmUIuiwRxQbgnShs7VHcBDB4TXpijeGLE7-TYfThSOZatjxAZff5cEy1-1mHP-hTHo9ZRy3M7krsg==@protonmail.internalid>
 <20231211163742.837427-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211163742.837427-10-hch@lst.de>

On Mon, Dec 11, 2023 at 05:37:28PM +0100, Christoph Hellwig wrote:
> There is no need to export a libxfs_xinit with the somewhat unsuitable
> name x from libxlog.  Move it into the tools linking against libxlog
> that actually need it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  db/init.c           | 1 +
>  include/libxlog.h   | 3 ---
>  libxlog/util.c      | 1 -
>  logprint/logprint.c | 1 +
>  repair/globals.h    | 2 ++
>  repair/init.c       | 2 ++
>  6 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/db/init.c b/db/init.c
> index 18d9dfdd9..eceaf576c 100644
> --- a/db/init.c
> +++ b/db/init.c
> @@ -27,6 +27,7 @@ static struct xfs_mount	xmount;
>  struct xfs_mount	*mp;
>  static struct xlog	xlog;
>  xfs_agnumber_t		cur_agno = NULLAGNUMBER;
> +libxfs_init_t		x;
> 
>  static void
>  usage(void)
> diff --git a/include/libxlog.h b/include/libxlog.h
> index 57f39e4e8..3948c0b8d 100644
> --- a/include/libxlog.h
> +++ b/include/libxlog.h
> @@ -68,9 +68,6 @@ extern int	print_exit;
>  extern int	print_skip_uuid;
>  extern int	print_record_header;
> 
> -/* libxfs parameters */
> -extern libxfs_init_t	x;
> -
>  void xlog_init(struct xfs_mount *mp, struct xlog *log);
>  int xlog_is_dirty(struct xfs_mount *mp, struct xlog *log);
> 
> diff --git a/libxlog/util.c b/libxlog/util.c
> index d1377c2e2..6e21f1a89 100644
> --- a/libxlog/util.c
> +++ b/libxlog/util.c
> @@ -10,7 +10,6 @@
>  int print_exit;
>  int print_skip_uuid;
>  int print_record_header;
> -libxfs_init_t x;
> 
>  void
>  xlog_init(
> diff --git a/logprint/logprint.c b/logprint/logprint.c
> index bcdb6b359..1a096fa79 100644
> --- a/logprint/logprint.c
> +++ b/logprint/logprint.c
> @@ -25,6 +25,7 @@ int	print_overwrite;
>  int     print_no_data;
>  int     print_no_print;
>  static int	print_operation = OP_PRINT;
> +static struct libxfs_xinit x;
> 
>  static void
>  usage(void)
> diff --git a/repair/globals.h b/repair/globals.h
> index b65e4a2d0..f2952d8b4 100644
> --- a/repair/globals.h
> +++ b/repair/globals.h
> @@ -169,4 +169,6 @@ extern int		thread_count;
>  /* If nonzero, simulate failure after this phase. */
>  extern int		fail_after_phase;
> 
> +extern libxfs_init_t	x;
> +
>  #endif /* _XFS_REPAIR_GLOBAL_H */
> diff --git a/repair/init.c b/repair/init.c
> index 6d019b393..6e3548b32 100644
> --- a/repair/init.c
> +++ b/repair/init.c
> @@ -18,6 +18,8 @@
>  #include "libfrog/dahashselftest.h"
>  #include <sys/resource.h>
> 
> +struct libxfs_xinit	x;
> +
>  static void
>  ts_create(void)
>  {
> --
> 2.39.2
> 
