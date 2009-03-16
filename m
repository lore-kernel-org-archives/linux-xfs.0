Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2GLNrZt115180 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 16:24:14 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 063FB19F60E
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 14:23:32 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id FYLioMtlQ0zrUo9H for
	<xfs@oss.sgi.com>; Mon, 16 Mar 2009 14:23:32 -0700 (PDT)
Date: Mon, 16 Mar 2009 17:23:32 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_repair: open filesystem device exclusively
Message-ID: <20090316212332.GA8496@infradead.org>
References: <49B48B8E.3030602@houseofnate.net>
	<49B491EA.4090003@houseofnate.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49B491EA.4090003@houseofnate.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "Nathaniel W. Turner" <nate@houseofnate.net>
Cc: xfs@oss.sgi.com

On Sun, Mar 08, 2009 at 11:50:02PM -0400, Nathaniel W. Turner wrote:
> (Error messages could probably be improved to be more user-friendly in
> this new failure case, and it probably wouldn't hurt to add a BLKROGET
> ioctl to check for read-only block devices with read-write permissions,
> but this does the job for me.)
> 
> Signed-off-by: Nathaniel W. Turner <nate@houseofnate.net>
> ---
>  repair/init.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/repair/init.c b/repair/init.c
> index 8e508c4..7e5052c 100644
> --- a/repair/init.c
> +++ b/repair/init.c
> @@ -142,6 +142,8 @@ xfs_init(libxfs_init_t *args)
>          args->isreadonly = (LIBXFS_ISREADONLY | LIBXFS_ISINACTIVE);
>      else if (dangerously)
>          args->isreadonly = (LIBXFS_ISINACTIVE | LIBXFS_DANGEROUSLY);
> +    else
> +        args->isreadonly = LIBXFS_EXCLUSIVELY;

Given that we skip it for -d and -n this is fine with me.

I think we might want to delay this change in the way xfs_repair
operates until after we get a 3.0.1 release out with all the build
system fixes (hopefully really soon)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
