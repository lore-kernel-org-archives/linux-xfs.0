Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52054 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1765747AbcLTUY3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Dec 2016 15:24:29 -0500
Subject: Re: [PATCH] xfs_io: prefix dedupe command error messages consistently
References: <20161219195020.GA5487@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <1e4c0a50-43cc-73cf-e7d6-6ea30ec17f4a@sandeen.net>
Date: Tue, 20 Dec 2016 14:24:27 -0600
MIME-Version: 1.0
In-Reply-To: <20161219195020.GA5487@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On 12/19/16 1:50 PM, Darrick J. Wong wrote:
> Prefix the perror output of the dedupe command consistently.  All the
> other perror calls reference the ioctl name directly, so we might as
> well do that for all the dedupe cases.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

ok, after some offline discussion, *shrug* this is fine.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  io/reflink.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/io/reflink.c b/io/reflink.c
> index d4c745c..dde26b8 100644
> --- a/io/reflink.c
> +++ b/io/reflink.c
> @@ -79,12 +79,12 @@ dedupe_ioctl(
>  			goto done;
>  		}
>  		if (info->status < 0) {
> -			fprintf(stderr, "dedupe: %s\n",
> +			fprintf(stderr, "XFS_IOC_FILE_EXTENT_SAME: %s\n",
>  					_(strerror(-info->status)));
>  			goto done;
>  		}
>  		if (info->status == XFS_EXTENT_DATA_DIFFERS) {
> -			fprintf(stderr, "dedupe: %s\n",
> +			fprintf(stderr, "XFS_IOC_FILE_EXTENT_SAME: %s\n",
>  					_("Extents did not match."));
>  			goto done;
>  		}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
