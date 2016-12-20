Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49512 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751583AbcLTAGP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Dec 2016 19:06:15 -0500
Subject: Re: [PATCH] xfs_io: prefix dedupe command error messages consistently
References: <20161219195020.GA5487@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ff9d53a6-fdb9-1343-eef0-4c44075cfef2@sandeen.net>
Date: Mon, 19 Dec 2016 18:06:13 -0600
MIME-Version: 1.0
In-Reply-To: <20161219195020.GA5487@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On 12/19/16 1:50 PM, Darrick J. Wong wrote:
> Prefix the perror output of the dedupe command consistently.  All the
> other perror calls reference the ioctl name directly, so we might as
> well do that for all the dedupe cases.

I guess it's fine - technically, these aren't perrors.  :)

and there are plenty of places like this too, though:

       } else if (xfsctl(name, file->fd, FS_IOC_FSGETXATTR, &attr) < 0) {
                fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
                        progname, name, strerror(errno));

as well.  I'd probably argue for an actual ioctl error to include
the ioctl name, but the "eh, can't dedupe" message to be a bit more
friendly (i.e. "dedupe: ...") - but I may be bikeshedding too much?

-Eric


> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
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
