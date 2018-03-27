Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48350 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752060AbeC0WT6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Mar 2018 18:19:58 -0400
Date: Tue, 27 Mar 2018 15:19:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] libfrog: enforce dir XOR blkdev in
 __fs_table_lookup_mount
Message-ID: <20180327221953.GE4818@magnolia>
References: <f7ab3da2-618c-dc1c-6d95-3890cdac2b43@redhat.com>
 <391d9faf-093f-24b7-9261-95feab18df51@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <391d9faf-093f-24b7-9261-95feab18df51@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Mar 27, 2018 at 05:14:51PM -0500, Eric Sandeen wrote:
> It's not valid to call fs_table_lookup_mount with both
> dir and blkdev set, but one of them must be supplied.
> Doing otherwise is a programming error, so catch it
> with an ASSERT.
> 
> Fixes-coverity-id: 1433615
> Fixes-coverity-id: 1433616
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Hmmm.... what /is/ the intended behavior if some jerk does
fs_table_lookup_mount(NULL) and both arguments are NULL?  AFAICT the
non-static wrappers will prevent the case where both parameters are
specified.

How about:

if (!dir && !blkdev) {
	ASSERT(0);
	return NULL;
}

just after the variable declarations?

--D

> ---
> 
> diff --git a/libfrog/paths.c b/libfrog/paths.c
> index 318b48f..55cb284 100644
> --- a/libfrog/paths.c
> +++ b/libfrog/paths.c
> @@ -98,6 +98,10 @@ __fs_table_lookup_mount(
>  	char		rpath[PATH_MAX];
>  	char		dpath[PATH_MAX];
>  
> +	/* There can be only one! */
> +	ASSERT(dir || blkdev);
> +	ASSERT(!(dir && blkdev));
> +
>  	if (dir && !realpath(dir, dpath))
>  		return NULL;
>  	if (blkdev && !realpath(blkdev, dpath))
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
