Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38762 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755440AbdKJBoA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Nov 2017 20:44:00 -0500
Subject: Re: [PATCH] xfs_io: fix gcc-7 related printf warnings
References: <20171110013926.15289-1-david@fromorbit.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ac210659-80a1-1eec-3704-a79d650ada40@sandeen.net>
Date: Thu, 9 Nov 2017 19:43:59 -0600
MIME-Version: 1.0
In-Reply-To: <20171110013926.15289-1-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On 11/9/17 7:39 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> New compiler, new checks, new warnings.
> 
> Fix the new [-Wformat-truncation=] warnings that io/fsmap.c is
> throwing w/ gcc-7.2 because "%lld..%lld" requires a buffer 40
> characters long, not 32.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>

2^63 is 19 chars, yup.

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> ---
>  io/fsmap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/io/fsmap.c b/io/fsmap.c
> index 448fb5356466..e46fdbaa148c 100644
> --- a/io/fsmap.c
> +++ b/io/fsmap.c
> @@ -184,8 +184,8 @@ dump_map_verbose(
>  	off64_t			agoff, bperag;
>  	int			foff_w, boff_w, aoff_w, tot_w, agno_w, own_w;
>  	int			nr_w, dev_w;
> -	char			rbuf[32], bbuf[32], abuf[32], obuf[32];
> -	char			nbuf[32], dbuf[32], gbuf[32];
> +	char			rbuf[40], bbuf[40], abuf[40], obuf[40];
> +	char			nbuf[40], dbuf[40], gbuf[40];
>  	char			owner[OWNER_BUF_SZ];
>  	int			sunit, swidth;
>  	int			flg = 0;
> 
