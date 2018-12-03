Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:44712 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbeLCQUq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 11:20:46 -0500
Date: Mon, 3 Dec 2018 08:20:30 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] io: open pipes in non-blocking mode
Message-ID: <20181203162030.GT8125@magnolia>
References: <20181202205343.7104-1-david@fromorbit.com>
 <20181202205343.7104-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181202205343.7104-2-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 03, 2018 at 07:53:42AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> So that O_RDONLY open commands (such as from copy_range) do not
> block forever waiting on a non-existent writer.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  io/open.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/io/open.c b/io/open.c
> index 6ea3e9a2019f..b1d9a0fa317c 100644
> --- a/io/open.c
> +++ b/io/open.c
> @@ -56,6 +56,7 @@ openfile(
>  	struct fs_path	*fs_path)
>  {
>  	struct fs_path	*fsp;
> +	struct stat	st;
>  	int		fd;
>  	int		oflags;
>  
> @@ -79,6 +80,18 @@ openfile(
>  	if (flags & IO_NOFOLLOW)
>  		oflags |= O_NOFOLLOW;
>  
> +	/*
> +	 * if we've been passed a pipe to open, don't block waiting for a
> +	 * reader or writer to appear. We want to either succeed or error out
> +	 * immediately.
> +	 */
> +	if (stat(path, &st) < 0 && errno != ENOENT) {
> +		perror("stat");
> +		return -1;
> +	}
> +	if (S_ISFIFO(st.st_mode))

Hmm... does stat() set st.st_mode even if it returns ENOENT?  Or are we
possibly branching on an uninitialized st here?

struct stat	st = { 0 }; ?

The rest seems fine to me.

--D

> +		oflags |= O_NONBLOCK;
> +
>  	fd = open(path, oflags, mode);
>  	if (fd < 0) {
>  		if (errno == EISDIR &&
> -- 
> 2.19.1
> 
