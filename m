Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:58810 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbfCOAbq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 20:31:46 -0400
Date: Thu, 14 Mar 2019 17:31:41 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 09.5/36] xfs_io: document fzero_f -k option in manpage
Message-ID: <20190315003141.GA4929@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259748531.31886.6568534900832262149.stgit@magnolia>
 <9784a4eb-f90c-c57a-34af-0039e24e9e78@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9784a4eb-f90c-c57a-34af-0039e24e9e78@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Mar 14, 2019 at 07:25:28PM -0500, Eric Sandeen wrote:
> Perhaps the reason -k was broken is that nobody knew it existed?
> 
> Fixes: 938904c4 ("xfs_io: add fzero command for zeroing range via fallocate")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index fbf50df..980dcfd 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -516,10 +516,13 @@ Call fallocate with FALLOC_FL_UNSHARE_RANGE flag as described in the
>  .BR fallocate (2)
>  manual page to unshare all shared blocks within the range.
>  .TP
> -.BI fzero " offset length"
> +.BI "fzero [ \-k ]" " offset length"
>  Call fallocate with FALLOC_FL_ZERO_RANGE flag as described in the
>  .BR fallocate (2)
>  manual page to allocate and zero blocks within the range.
> +With the
> +.B -k
> +option, use the FALLOC_FL_KEEP_SIZE flag as well.
>  .TP
>  .BI zero " offset length"
>  Call xfsctl with
> 
