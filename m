Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37304 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753133AbeB0OVa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Feb 2018 09:21:30 -0500
Subject: Re: [PATCH] xfs_repair: Ensure just xfs_repair without -n can return
 a status code of 2
References: <1519710632-16129-1-git-send-email-yangx.jy@cn.fujitsu.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b311ddb9-e996-9e4b-f7f1-d0d45b8f782a@sandeen.net>
Date: Tue, 27 Feb 2018 08:21:29 -0600
MIME-Version: 1.0
In-Reply-To: <1519710632-16129-1-git-send-email-yangx.jy@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc: darrick.wong@oracle.com, linux-xfs@vger.kernel.org

On 2/26/18 11:50 PM, Xiao Yang wrote:
> Since commit b04647edea32, xfs_repair -L could't succeed to clear a dirty log
> and returned a status of 2.  Besides, xfs_repair -n returned a status of 2
> instead of 1 if a dirty log was detected.  I think just xfs_repair without -n
> should return a status code of 2 when getting a dirty log, so fix it.  We can
> expose this issue by xfstests case xfs/098.
> 
> Fixes:'commit b04647edea32 ("xfs_repair: exit with status 2 if log dirtiness is unknown")'
> 
> Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>

Whoops, yes this was a silly mistake, my fault, and definitely a bug -
and your fix is obviously correct.

However, your description isn't accurate; the bug exists only when
xlog_find_tail() fails to find the head or the tail, which
is why this went undiscovered for so long.  xfs_repair -L certainly
can clear a dirty log today, it only fails if xlog_find_tail fails.

The core bug here is missing braces; the result is that an unparseable
log always exits with exit(2), even if we've asked for -n or -L which
should proceed.

Can you resend this patch with a proper summary and a description
which more closely matches the actual bug?

Thanks,
-Eric

> ---
>  repair/phase2.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/repair/phase2.c b/repair/phase2.c
> index 992e997..c124882 100644
> --- a/repair/phase2.c
> +++ b/repair/phase2.c
> @@ -78,12 +78,13 @@ zero_log(
>  		do_warn(
>  		_("zero_log: cannot find log head/tail (xlog_find_tail=%d)\n"),
>  			error);
> -		if (!no_modify && !zap_log)
> +		if (!no_modify && !zap_log) {
>  			do_warn(_(
>  "ERROR: The log head and/or tail cannot be discovered. Attempt to mount the\n"
>  "filesystem to replay the log or use the -L option to destroy the log and\n"
>  "attempt a repair.\n"));
>  			exit(2);
> +		}
>  	} else {
>  		if (verbose) {
>  			do_log(
> 
