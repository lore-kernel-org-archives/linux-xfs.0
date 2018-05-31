Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:53162 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753862AbeEaOzi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 May 2018 10:55:38 -0400
Date: Thu, 31 May 2018 09:55:34 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH] xfs_io: fix null pointer deref when complaining about
 scrub command
Message-ID: <20180531145534.GA1268@redhat.com>
References: <20180530033215.GO30110@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180530033215.GO30110@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Tue, May 29, 2018 at 08:32:15PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Don't increment optind until we've validated that argv[optind] is a
> valid scrub/repair subcommand and do not need to complain about
> argv[optind].
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  io/scrub.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/io/scrub.c b/io/scrub.c
> index 604daed9..37ffe46b 100644
> --- a/io/scrub.c
> +++ b/io/scrub.c
> @@ -166,12 +166,11 @@ parse_args(
>  			break;
>  		}
>  	}
> -	optind++;
> -
>  	if (type < 0) {
>  		printf(_("Unknown type '%s'.\n"), argv[optind]);
>  		return command_usage(cmdinfo);
>  	}
> +	optind++;
>  
>  	switch (d->type) {
>  	case ST_INODE:
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
