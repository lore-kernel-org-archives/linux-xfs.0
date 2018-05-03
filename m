Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43846 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750822AbeECU57 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 May 2018 16:57:59 -0400
Subject: Re: [PATCH 5/9] xfs_spaceman: print a nicer message when the file
 path isn't on an xfs
References: <152401952391.13048.15040850425873030425.stgit@magnolia>
 <152401956294.13048.1815463748899965760.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ff9df1e2-7bbd-c5a8-3c7b-1bb29a5eff2f@sandeen.net>
Date: Thu, 3 May 2018 15:57:57 -0500
MIME-Version: 1.0
In-Reply-To: <152401956294.13048.1815463748899965760.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 4/17/18 9:46 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If the file path passed in is not something on an xfs filesystem, print
> a nice message about that instead of yelling about ioctls.

Assumes that -ENOTTY is the only possible error though...

Maybe:

if (errno == ENOTTY)
	printf("nice thing")
else
	perror("XFS_IOC_FSGEOMETRY");

?

Not a lot else that should go wrong today (EFAULT?) but assuming only
one thing could go wrong seems wrong.

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  spaceman/file.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/spaceman/file.c b/spaceman/file.c
> index 4c13b4a..4f9f66c 100644
> --- a/spaceman/file.c
> +++ b/spaceman/file.c
> @@ -69,7 +69,8 @@ openfile(
>  	}
>  
>  	if (ioctl(fd, XFS_IOC_FSGEOMETRY, geom) < 0) {
> -		perror("XFS_IOC_FSGEOMETRY");
> +		fprintf(stderr, _("%s: Not on a mounted XFS filesystem.\n"),
> +				path);
>  		close(fd);
>  		return -1;
>  	}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
