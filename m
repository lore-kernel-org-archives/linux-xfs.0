Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:37178 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753895AbeARA3n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jan 2018 19:29:43 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0I0NGV4046870
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2018 00:29:43 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2fjetj0fn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2018 00:29:42 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0I0TgXv008707
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2018 00:29:42 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0I0TgRA014569
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2018 00:29:42 GMT
Date: Wed, 17 Jan 2018 16:29:40 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/5] xfs: introduce 'fixed agfl' feature
Message-ID: <20180118002940.GF25805@magnolia>
References: <151623403113.4727.2418454911805718650.stgit@magnolia>
 <151623404388.4727.13556729503051957189.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151623404388.4727.13556729503051957189.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Wed, Jan 17, 2018 at 04:07:23PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Introduce a new rocompat flag "FIXED_AGFL" to indicate that we've
> scanned and verified that the AGFL does not hit the troublesome last
> element of the AGFL array, and update xfs_agfl_size to its new
> definition based on this feature.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_format.h |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index bb42a11..3befc92f 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -464,6 +464,7 @@ xfs_sb_has_compat_feature(
>  #define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
>  #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
>  #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
> +#define XFS_SB_FEAT_RO_COMPAT_FIXED_AGFL (1 << 3)	/* fixed agfl */

(echoing comments made on irc by myself & Dave)

It suddenly occurred to me that we could do without this rocompat
feature if we simply don't allow wrapped AGFLs anymore.  As soon as
fllast points to that last agfl_bno slot, we simply move the whole list
back to the start of the agfl block (i.e. flfirst = 0) and relog the
whole agfl.  We still have problems if the admin mounts with an
unpatched kernel, gets the agfl to wrap, and then then moves to another
unpatched kernel, but at least the up-to-date kernels can just fix the
problem and move on.

I guess the nice thing about the rocompat feature is that the unpatched
kernels won't mount, instead of blowing up randomly some time in the
future and the user's antiquarian xfsprogs also refuses to touch it.

We could also only set the rocompat flag if we actually had to fix
something (vs. now where we always set it) though I wonder if that just
makes the "I reverted kernels and now it blew up wtf?!" even more
sporadic?  Hm.  Maybe we want that, since either is a rude awakening &
making the rude wakeup less frequent isn't a bad thing.

Ugh.  Maybe bikeshed now? :)

--D

>  #define XFS_SB_FEAT_RO_COMPAT_ALL \
>  		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
>  		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
> @@ -566,6 +567,12 @@ static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
>  		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK);
>  }
>  
> +static inline bool xfs_sb_version_hasfixedagfl(struct xfs_sb *sbp)
> +{
> +	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> +		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_FIXED_AGFL);
> +}
> +
>  /*
>   * end of superblock version macros
>   */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
