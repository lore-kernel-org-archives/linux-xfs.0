Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42524 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751196AbdGYLBW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jul 2017 07:01:22 -0400
Date: Tue, 25 Jul 2017 07:01:21 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: check that dir block entries don't off the end of
 the buffer
Message-ID: <20170725110121.GC16188@bfoster.bfoster>
References: <20170721220122.GW4224@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170721220122.GW4224@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Fri, Jul 21, 2017 at 03:01:22PM -0700, Darrick J. Wong wrote:
> When we're checking the entries in a directory buffer, make sure that
> the entry length doesn't push us off the end of the buffer.  Found via
> xfs/388 writing ones to the freetag length field and xfs_repair crashing.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_dir2_data.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index d478065..8727a43 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -136,6 +136,8 @@ __xfs_dir3_data_check(
>  		 */
>  		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
>  			XFS_WANT_CORRUPTED_RETURN(mp, lastfree == 0);
> +			XFS_WANT_CORRUPTED_RETURN(mp, endp >=
> +					p + be16_to_cpu(dup->length));

FWIW, the rest of the code seems to use the dup/dep pointers for
verification and explicitly casts to char * where necessary. I don't see
that it really matters, so:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  			XFS_WANT_CORRUPTED_RETURN(mp,
>  				be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)) ==
>  					       (char *)dup - (char *)hdr);
> @@ -164,6 +166,8 @@ __xfs_dir3_data_check(
>  		XFS_WANT_CORRUPTED_RETURN(mp, dep->namelen != 0);
>  		XFS_WANT_CORRUPTED_RETURN(mp,
>  			!xfs_dir_ino_validate(mp, be64_to_cpu(dep->inumber)));
> +		XFS_WANT_CORRUPTED_RETURN(mp, endp >=
> +				p + ops->data_entsize(dep->namelen));
>  		XFS_WANT_CORRUPTED_RETURN(mp,
>  			be16_to_cpu(*ops->data_entry_tag_p(dep)) ==
>  					       (char *)dep - (char *)hdr);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
