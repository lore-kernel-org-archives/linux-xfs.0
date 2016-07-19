Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A673C7CB5
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 02:53:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 181FEAC002
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 00:53:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ML2iEnHY6EjGbtCO (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 19 Jul 2016 00:53:00 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id E5AC64480B
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 07:52:59 +0000 (UTC)
Date: Tue, 19 Jul 2016 09:52:55 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: fix xfs_error_get_cfg for negative errnos
Message-ID: <20160719075255.GB8134@redhat.com>
References: <9810c6bf-9fd7-bf41-13ab-a96bec861457@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <9810c6bf-9fd7-bf41-13ab-a96bec861457@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Jul 08, 2016 at 02:32:17PM -0500, Eric Sandeen wrote:
> xfs_error_get_cfg() is called with bp->b_error as an arg,
> which is negative, so the switch statement won't ever find
> any matches.
> 
> This results in only the default error handler having
> any effect, as EIO/ENOSPC/ENODEV get ignored due to the
> wrong sign.
> 
> It seems simplest to always flip the error sign to positive,
> so that we can handle either negative errors in bp->b_error,
> or possibly a positive errno via something like
> xfs_error_get_cfg(EIO) - this future-proofs the function.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

This looks the right thing to do for me too.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
> 
> I'm still chasing down some odd behaviors in the error handling
> patches but this seems worth sending now :)
> 
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index 4c2c550..79cfd3f 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -634,6 +634,9 @@ xfs_error_get_cfg(
>  {
>  	struct xfs_error_cfg	*cfg;
>  
> +	if (error < 0)
> +		error = -error;
> +
>  	switch (error) {
>  	case EIO:
>  		cfg = &mp->m_error_cfg[error_class][XFS_ERR_EIO];
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
