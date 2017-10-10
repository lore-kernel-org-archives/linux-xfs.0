Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43663 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932075AbdJJQzx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Oct 2017 12:55:53 -0400
Date: Tue, 10 Oct 2017 09:55:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] xfs: assert that xattr inactivation never reaches a
 hole
Message-ID: <20171010165546.GZ7122@magnolia>
References: <20171010164756.28390-1-bfoster@redhat.com>
 <20171010164756.28390-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171010164756.28390-2-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 10, 2017 at 12:47:55PM -0400, Brian Foster wrote:
> The child buffer read in xfs_attr3_node_inactive() should never
> reach a hole in the attr fork. If this occurs, it is likely due to a
> bug. Prior to commit cd87d867 ("xfs: don't crash on unexpected holes
> in dir/attr btrees"), this would result in a crash. Now that the
> crash has been fixed, this is a silent failure.
> 
> Add an assert in this codepath to detect this particular condition.
> Note that the right fix here may be to pass -1 to
> xfs_da3_node_read() such that a hole returns an error. This is a
> cautious first step in that direction.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_attr_inactive.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> index ebd66b1..6b4f5c6 100644
> --- a/fs/xfs/xfs_attr_inactive.c
> +++ b/fs/xfs/xfs_attr_inactive.c
> @@ -255,6 +255,7 @@ xfs_attr3_node_inactive(
>  						XFS_ATTR_FORK);
>  		if (error)
>  			return error;
> +		ASSERT(child_bp);

xfs_dabuf_map will log an error message and return -EFSCORRUPTED if
mappedbno == -1, so (afaict) you might as well do that instead of adding
the ASSERT.  We'll still see the dmesg report.

--D

>  		if (child_bp) {
>  						/* save for re-read later */
>  			child_blkno = XFS_BUF_ADDR(child_bp);
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
