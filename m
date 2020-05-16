Return-Path: <SRS0=gkwD=66=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50A48C433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 17:43:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25C86206D8
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 17:43:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XacLzsR7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgEPRnW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 May 2020 13:43:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45328 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbgEPRnW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 May 2020 13:43:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04GHgwQn022007;
        Sat, 16 May 2020 17:43:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=QKnK9mFBeysYSrxfo0in97/6x9Gz41tLhc+pIPiVr8k=;
 b=XacLzsR73VFx7yYYUcNzkq3Mx7zXlrA4NzF2BNv8boRe3HAFt9n00fglRxUeGry4IZLh
 DVGSzwAIeea45o3cMqYELTKRA198c/Jhwjx3QoAxEUIB2Vn24XmqOlnzqZU6mKqrd/Xm
 BBYAGG5LUECbdtzmw+VJS0PKepns0+uUveU+1nTaQcviDP9sIMwi0bXIf84He/m+Ji5R
 bJf9tu4PAGLxsPqpLEW/qUwOsuCoxEqX9s9TGNUsB7QHPhMI+LSz3ETK5grO7OFmESMX
 Reemht2yb5YlD0lHHiOZZOdyONcB51LPr0mkn4yoebx5s3237yHLx5nw9aPogMrgGo2a +g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3127kqsf23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 16 May 2020 17:43:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04GHceJN159664;
        Sat, 16 May 2020 17:43:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 312679d4w3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 May 2020 17:43:15 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04GHhEii006463;
        Sat, 16 May 2020 17:43:14 GMT
Received: from localhost (/10.159.131.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 16 May 2020 10:43:14 -0700
Date:   Sat, 16 May 2020 10:43:13 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 07/12] xfs: remove xfs_iread
Message-ID: <20200516174313.GW6714@magnolia>
References: <20200508063423.482370-1-hch@lst.de>
 <20200508063423.482370-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508063423.482370-8-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9623 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=1 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005160158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9623 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=1 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005160159
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 08, 2020 at 08:34:18AM +0200, Christoph Hellwig wrote:
> There is not much point in the xfs_iread function, as it has a single
> caller and not a whole lot of code.  Move it into the only caller,
> and trim down the overdocumentation to just documenting the important
> "why" instead of a lot of redundant "what".
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks reasonable,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 73 -----------------------------------
>  fs/xfs/libxfs/xfs_inode_buf.h |  2 -
>  fs/xfs/xfs_icache.c           | 33 +++++++++++++++-
>  3 files changed, 32 insertions(+), 76 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 329534eebbdcc..05f939adea944 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -614,79 +614,6 @@ xfs_dinode_calc_crc(
>  	dip->di_crc = xfs_end_cksum(crc);
>  }
>  
> -/*
> - * Read the disk inode attributes into the in-core inode structure.
> - *
> - * For version 5 superblocks, if we are initialising a new inode and we are not
> - * utilising the XFS_MOUNT_IKEEP inode cluster mode, we can simple build the new
> - * inode core with a random generation number. If we are keeping inodes around,
> - * we need to read the inode cluster to get the existing generation number off
> - * disk. Further, if we are using version 4 superblocks (i.e. v1/v2 inode
> - * format) then log recovery is dependent on the di_flushiter field being
> - * initialised from the current on-disk value and hence we must also read the
> - * inode off disk.
> - */
> -int
> -xfs_iread(
> -	xfs_mount_t	*mp,
> -	xfs_trans_t	*tp,
> -	xfs_inode_t	*ip,
> -	uint		iget_flags)
> -{
> -	xfs_buf_t	*bp;
> -	xfs_dinode_t	*dip;
> -	int		error;
> -
> -	/*
> -	 * Fill in the location information in the in-core inode.
> -	 */
> -	error = xfs_imap(mp, tp, ip->i_ino, &ip->i_imap, iget_flags);
> -	if (error)
> -		return error;
> -
> -	/* shortcut IO on inode allocation if possible */
> -	if ((iget_flags & XFS_IGET_CREATE) &&
> -	    xfs_sb_version_has_v3inode(&mp->m_sb) &&
> -	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
> -		VFS_I(ip)->i_generation = prandom_u32();
> -		return 0;
> -	}
> -
> -	/*
> -	 * Get pointers to the on-disk inode and the buffer containing it.
> -	 */
> -	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &bp, 0);
> -	if (error)
> -		return error;
> -
> -	error = xfs_inode_from_disk(ip, dip);
> -	if (error)
> -		goto out_brelse;
> -
> -	/*
> -	 * Mark the buffer containing the inode as something to keep
> -	 * around for a while.  This helps to keep recently accessed
> -	 * meta-data in-core longer.
> -	 */
> -	xfs_buf_set_ref(bp, XFS_INO_REF);
> -
> -	/*
> -	 * Use xfs_trans_brelse() to release the buffer containing the on-disk
> -	 * inode, because it was acquired with xfs_trans_read_buf() in
> -	 * xfs_imap_to_bp() above.  If tp is NULL, this is just a normal
> -	 * brelse().  If we're within a transaction, then xfs_trans_brelse()
> -	 * will only release the buffer if it is not dirty within the
> -	 * transaction.  It will be OK to release the buffer in this case,
> -	 * because inodes on disk are never destroyed and we will be locking the
> -	 * new in-core inode before putting it in the cache where other
> -	 * processes can find it.  Thus we don't have to worry about the inode
> -	 * being changed just because we released the buffer.
> -	 */
> - out_brelse:
> -	xfs_trans_brelse(tp, bp);
> -	return error;
> -}
> -
>  /*
>   * Validate di_extsize hint.
>   *
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 0fbb99224ec73..e4cbcaf62a32b 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -49,8 +49,6 @@ struct xfs_imap {
>  int	xfs_imap_to_bp(struct xfs_mount *, struct xfs_trans *,
>  		       struct xfs_imap *, struct xfs_dinode **,
>  		       struct xfs_buf **, uint);
> -int	xfs_iread(struct xfs_mount *, struct xfs_trans *,
> -		  struct xfs_inode *, uint);
>  void	xfs_dinode_calc_crc(struct xfs_mount *, struct xfs_dinode *);
>  void	xfs_inode_to_disk(struct xfs_inode *ip, struct xfs_dinode *to,
>  			  xfs_lsn_t lsn);
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 922a29032e374..af5748f5d9271 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -22,6 +22,7 @@
>  #include "xfs_dquot_item.h"
>  #include "xfs_dquot.h"
>  #include "xfs_reflink.h"
> +#include "xfs_ialloc.h"
>  
>  #include <linux/iversion.h>
>  
> @@ -508,10 +509,40 @@ xfs_iget_cache_miss(
>  	if (!ip)
>  		return -ENOMEM;
>  
> -	error = xfs_iread(mp, tp, ip, flags);
> +	error = xfs_imap(mp, tp, ip->i_ino, &ip->i_imap, flags);
>  	if (error)
>  		goto out_destroy;
>  
> +	/*
> +	 * For version 5 superblocks, if we are initialising a new inode and we
> +	 * are not utilising the XFS_MOUNT_IKEEP inode cluster mode, we can
> +	 * simply build the new inode core with a random generation number.
> +	 *
> +	 * For version 4 (and older) superblocks, log recovery is dependent on
> +	 * the di_flushiter field being initialised from the current on-disk
> +	 * value and hence we must also read the inode off disk even when
> +	 * initializing new inodes.
> +	 */
> +	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
> +	    (flags & XFS_IGET_CREATE) && !(mp->m_flags & XFS_MOUNT_IKEEP)) {
> +		VFS_I(ip)->i_generation = prandom_u32();
> +	} else {
> +		struct xfs_dinode	*dip;
> +		struct xfs_buf		*bp;
> +
> +		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &bp, 0);
> +		if (error)
> +			goto out_destroy;
> +
> +		error = xfs_inode_from_disk(ip, dip);
> +		if (!error)
> +			xfs_buf_set_ref(bp, XFS_INO_REF);
> +		xfs_trans_brelse(tp, bp);
> +
> +		if (error)
> +			goto out_destroy;
> +	}
> +
>  	if (!xfs_inode_verify_forks(ip)) {
>  		error = -EFSCORRUPTED;
>  		goto out_destroy;
> -- 
> 2.26.2
> 
