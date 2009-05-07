Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n472tvsB166897 for <xfs@oss.sgi.com>; Wed, 6 May 2009 21:55:58 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 37A0F1D15884
	for <xfs@oss.sgi.com>; Wed,  6 May 2009 19:56:00 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id HD6rDRykr3J9jaVf for
	<xfs@oss.sgi.com>; Wed, 06 May 2009 19:56:00 -0700 (PDT)
Message-ID: <4A024DBF.40209@sandeen.net>
Date: Wed, 06 May 2009 21:55:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_repair: open filesystem device exclusively
References: <49B48B8E.3030602@houseofnate.net>
	<49B491EA.4090003@houseofnate.net>
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

Nathaniel W. Turner wrote:
> I forgot to mention that this is against xfsprogs 3.0.0.  Also, the
> indentation was a bit messed up on that last post, so here's the patch
> again (all 2 lines of it):
> 
> ----
> 
> I'm sure there is a better way to fix this, but without this patch, two
> xfs_repair processes will happily operate on the same filesystem device
> at the same time.  It is also possible to mount a filesystem that is in
> the process of being repaired.
> 
> This seems like it's probably not ideal, so this patch just modifies
> xfs_repair to open the filesystem device with O_EXCL unless it was
> invoked in "no modify" or "dangerous" mode.

...

> Signed-off-by: Nathaniel W. Turner <nate@houseofnate.net>

Christoph already looked I guess, but I'll give this my thumbs-up too :)

-Eric

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
>  
>      if (!libxfs_init(args))
>          do_error(_("couldn't initialize XFS library\n"));
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
