Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44956 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753021AbdHXU46 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2017 16:56:58 -0400
Date: Thu, 24 Aug 2017 13:56:47 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 7/6] xfs_bmap: fix -n documentation in manpage
Message-ID: <20170824205647.GJ4796@magnolia>
References: <1503575272-28263-1-git-send-email-nborisov@suse.com>
 <5fb3c541-ceaf-409c-3536-96bf8805076c@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5fb3c541-ceaf-409c-3536-96bf8805076c@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Nikolay Borisov <nborisov@suse.com>, linux-xfs@vger.kernel.org, sandeen@redhat.com

On Thu, Aug 24, 2017 at 03:09:32PM -0500, Eric Sandeen wrote:
> xfs_bmap's manpage mis-describes the behavior from the
> -n option.  xfs_io's fiemap command references the xfs_bmap
> manpage, and has the same problem:
> 
> -n does not change the query batch size, it limits the number
> of extents displayed.
> 
> This has been true for 15+ years, so change the documentation
> to match reality.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

For patches 6 & 7,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/man/man8/xfs_bmap.8 b/man/man8/xfs_bmap.8
> index 098cfae..c725519 100644
> --- a/man/man8/xfs_bmap.8
> +++ b/man/man8/xfs_bmap.8
> @@ -77,12 +77,11 @@ option is used.
>  .BI \-n " num_extents"
>  If this option is given,
>  .B xfs_bmap
> -obtains the extent list of the file in groups of
> +will display at most
>  .I num_extents
>  extents. In the absence of
>  .BR \-n ", " xfs_bmap
> -queries the system for the number of extents in the file and uses that
> -value to compute the group size.
> +will display all extents in the file.
>  .TP
>  .B \-p
>  If this option is used,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
