Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57528 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932745AbeEaOwi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 May 2018 10:52:38 -0400
Subject: Re: [PATCH] xfs_io: fix null pointer deref when complaining about
 scrub command
References: <20180530033215.GO30110@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ef8e9136-ebf3-a208-8cef-36480bd34b6b@sandeen.net>
Date: Thu, 31 May 2018 09:52:37 -0500
MIME-Version: 1.0
In-Reply-To: <20180530033215.GO30110@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On 5/29/18 10:32 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Don't increment optind until we've validated that argv[optind] is a
> valid scrub/repair subcommand and do not need to complain about
> argv[optind].
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>


> ---
>   io/scrub.c |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/io/scrub.c b/io/scrub.c
> index 604daed9..37ffe46b 100644
> --- a/io/scrub.c
> +++ b/io/scrub.c
> @@ -166,12 +166,11 @@ parse_args(
>   			break;
>   		}
>   	}
> -	optind++;
> -
>   	if (type < 0) {
>   		printf(_("Unknown type '%s'.\n"), argv[optind]);
>   		return command_usage(cmdinfo);
>   	}
> +	optind++;
>   
>   	switch (d->type) {
>   	case ST_INODE:
