Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99B5EC0032E
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Oct 2023 14:39:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235035AbjJYOjr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Oct 2023 10:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235048AbjJYOjp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2023 10:39:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E34E13D;
        Wed, 25 Oct 2023 07:39:44 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7FF1C433C8;
        Wed, 25 Oct 2023 14:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698244783;
        bh=GE2SFdyv9cPI+wHMUMYdDQNMKbpwQ523nL6lEiQznvg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tJPfWDt5LZA47V0pmiuWNNY47E4t0Gnh2UML/j2/DIfaOGcHADX2EI5MFca7JN8ED
         NlIuKBDP1WGLPhmCChLc6qeSCTxTfqHqTg5JnmyoitNXt6Gja3fZctIK4/dqwWnXOG
         IOsFoT9KyJeWCH0bU8LInPxBSllbbVtMIe8lL8Kdk502z1ru73+joKMxZ3APnbKtcF
         cynXwXatUIU262lfXGHF4dqV68yZoxQ2/T8I+vXyz27PaYligoUnuERoOoJlGvan4x
         UR6qIEARwgK7IPd88MfZbCknCU63QF652j2+CP0cTfb9466ocde8Pup7buLV3k24N+
         PAuE/Z7LNUK0g==
Date:   Wed, 25 Oct 2023 07:39:43 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@infradead.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] xfs: clean up FS_XFLAG_REALTIME handling in
 xfs_ioctl_setattr_xflags
Message-ID: <20231025143943.GC3195650@frogsfrogsfrogs>
References: <20231025141020.192413-1-hch@lst.de>
 <20231025141020.192413-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231025141020.192413-4-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 25, 2023 at 04:10:19PM +0200, Christoph Hellwig wrote:
> Introduce a local boolean variable if FS_XFLAG_REALTIME to make the
> checks for it more obvious, and de-densify a few of the conditionals
> using it to make them more readable while at it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_ioctl.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 55bb01173cde8c..be69e7be713e5c 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1120,23 +1120,25 @@ xfs_ioctl_setattr_xflags(
>  	struct fileattr		*fa)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> +	bool			rtflag = (fa->fsx_xflags & FS_XFLAG_REALTIME);
>  	uint64_t		i_flags2;
>  
> -	/* Can't change realtime flag if any extents are allocated. */
> -	if ((ip->i_df.if_nextents || ip->i_delayed_blks) &&
> -	    XFS_IS_REALTIME_INODE(ip) != (fa->fsx_xflags & FS_XFLAG_REALTIME))
> -		return -EINVAL;
> +	if (rtflag != XFS_IS_REALTIME_INODE(ip)) {
> +		/* Can't change realtime flag if any extents are allocated. */
> +		if (ip->i_df.if_nextents || ip->i_delayed_blks)
> +			return -EINVAL;
> +	}
>  
> -	/* If realtime flag is set then must have realtime device */
> -	if (fa->fsx_xflags & FS_XFLAG_REALTIME) {
> +	if (rtflag) {
> +		/* If realtime flag is set then must have realtime device */
>  		if (mp->m_sb.sb_rblocks == 0 || mp->m_sb.sb_rextsize == 0 ||
>  		    (ip->i_extsize % mp->m_sb.sb_rextsize))
>  			return -EINVAL;
> -	}
>  
> -	/* Clear reflink if we are actually able to set the rt flag. */
> -	if ((fa->fsx_xflags & FS_XFLAG_REALTIME) && xfs_is_reflink_inode(ip))
> -		ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
> +		/* Clear reflink if we are actually able to set the rt flag. */
> +		if (xfs_is_reflink_inode(ip))
> +			ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
> +	}
>  
>  	/* diflags2 only valid for v3 inodes. */
>  	i_flags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);
> -- 
> 2.39.2
> 
