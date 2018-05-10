Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53704 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751096AbeEJNx1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 10 May 2018 09:53:27 -0400
Date: Thu, 10 May 2018 09:53:26 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 02/12] xfs: add missing rmap error return
Message-ID: <20180510135325.GB69384@bfoster.bfoster>
References: <152537075334.16676.10600900179473864298.stgit@magnolia>
 <152537076596.16676.8860720933298336661.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152537076596.16676.8860720933298336661.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, May 03, 2018 at 11:06:06AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> xfs_rmap_lookup_le_range can return errors, so we need to check for
> them and bail out.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_rmap.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index fba8d2718017..f7769edf5b68 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -1374,6 +1374,8 @@ xfs_rmap_convert_shared(
>  	 */
>  	error = xfs_rmap_lookup_le_range(cur, bno, owner, offset, flags,
>  			&PREV, &i);
> +	if (error)
> +		goto done;
>  	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
>  
>  	ASSERT(PREV.rm_offset <= offset);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
