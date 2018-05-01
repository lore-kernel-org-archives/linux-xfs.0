Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:38390 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751071AbeEAQN4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 May 2018 12:13:56 -0400
Date: Tue, 1 May 2018 09:13:37 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/6] xfs: validate UUID and type in xfs_dquot_verify
Message-ID: <20180501161337.GF4127@magnolia>
References: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
 <59cde702-21d5-3465-12b0-29dad978186d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59cde702-21d5-3465-12b0-29dad978186d@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Apr 04, 2018 at 02:00:22PM -0500, Eric Sandeen wrote:
> Today the xfs_dqblk UUID is only checked in
> xfs_dquot_buf_verify_crc, which is a bit odd in itself; normally
> a CRC is checked on its own, separate from other metadata.
> 
> And by not checking the UUID in xfs_dquot_verify, this means
> that future read/write verifiers will continue to choke on
> mismatched UUID errors which are never seen or repaired when
> quotacheck calls xfs_dquot_verify to validate a disk dquot.
> 
> Move the uuid check from xfs_dquot_buf_verify_crc to
> xfs_dquot_verify so that this piece of metadata is more consistently
> checked.  If we have a type sent in as well, validate that too -
> it was unused until now.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_dquot_buf.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> index f94e8c2..9f8b2c5 100644
> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> @@ -66,11 +66,20 @@
>  	 * This is all fine; things are still consistent, and we haven't lost
>  	 * any quota information. Just don't complain about bad dquot blks.
>  	 */
> +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +		struct xfs_dqblk *dqb = (struct xfs_dqblk *)ddq;
> +
> +		if (!uuid_equal(&dqb->dd_uuid, &mp->m_sb.sb_meta_uuid))
> +			return __this_address;
> +	}
> +
>  	if (ddq->d_magic != cpu_to_be16(XFS_DQUOT_MAGIC))
>  		return __this_address;
>  	if (ddq->d_version != XFS_DQUOT_VERSION)
>  		return __this_address;
>  
> +	if (type && ddq->d_flags != type)
> +		return __this_address;
>  	if (ddq->d_flags != XFS_DQ_USER &&
>  	    ddq->d_flags != XFS_DQ_PROJ &&
>  	    ddq->d_flags != XFS_DQ_GROUP)
> @@ -156,8 +165,6 @@
>  		if (!xfs_verify_cksum((char *)d, sizeof(struct xfs_dqblk),
>  				 XFS_DQUOT_CRC_OFF))
>  			return false;
> -		if (!uuid_equal(&d->dd_uuid, &mp->m_sb.sb_meta_uuid))
> -			return false;
>  	}
>  	return true;
>  }
> -- 
> 1.8.3.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
