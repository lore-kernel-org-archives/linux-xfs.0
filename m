Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58096 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751359AbcLPRnA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Dec 2016 12:43:00 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 340882174F
        for <linux-xfs@vger.kernel.org>; Fri, 16 Dec 2016 17:43:00 +0000 (UTC)
Date: Fri, 16 Dec 2016 12:42:58 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs_repair: don't indicate dirtiness if FSGEOMETRY fails
Message-ID: <20161216174258.GH8447@bfoster.bfoster>
References: <fceea296-989c-a71d-a6e7-23560fd6db8b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fceea296-989c-a71d-a6e7-23560fd6db8b@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Dec 16, 2016 at 09:56:19AM -0600, Eric Sandeen wrote:
> Today, pointing repair at an image hosted on a non-xfs
> filesystem will result in a XFS_IOC_FSGEOMETRY_V1 failure,
> but repair generally proceeds without further problems.
> 
> However, calling do_warn() sets fs_is_dirty to 1, so
> xfs_repair -n exits with non-zero status, indicating
> corruption.  This is incorrect.
> 
> Change the message to use do_log so that it does not
> incorrectly indicate corruption.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> --- 

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index d950a32..5c79fd9 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -696,7 +696,7 @@ main(int argc, char **argv)
>  		struct xfs_fsop_geom_v1 geom = { 0 };
>  
>  		if (ioctl(fd, XFS_IOC_FSGEOMETRY_V1, &geom) < 0) {
> -			do_warn(_("Cannot get host filesystem geometry.\n"
> +			do_log(_("Cannot get host filesystem geometry.\n"
>  		"Repair may fail if there is a sector size mismatch between\n"
>  		"the image and the host filesystem.\n"));
>  			geom.sectsize = BBSIZE;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
