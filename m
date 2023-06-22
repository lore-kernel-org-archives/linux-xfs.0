Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36699EB64D8
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jun 2023 04:06:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbjFVEGZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jun 2023 00:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjFVEGF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jun 2023 00:06:05 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8572128
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jun 2023 21:04:37 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1b5018cb4dcso33411635ad.2
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jun 2023 21:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687406676; x=1689998676;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ioniQ/Hu9aB8cdNuAwkTdfNOgY7/VS82KMPqd01oL9E=;
        b=bO90JxiHlPgXo2QXFby1Y/r0VLsrhISp6sMA2s+M35Zyy2KZEivM84IK/fAxsl1Otd
         ggJbl2/UScyho+r9gHjIZSMjQZhDsrFRgeku6rKIQ6iXbejsJrGGe7G0Hf1CeE2oL/GF
         5tuGf+EJtfJ6+hjJw3FXwtEh/qNYpZFMYR+qRX4Xc71kpYgbs1losy4Q8uYdL8LbHCV5
         bp2MqIIoeUwLUduY98CU6CTyNB0xY8EC2kU37e9r3x0lHpqeTcearhnDR741hBD9Da2j
         uJc0CPHh/CrnU/NbBsJ83KegYMYXciQhFdROFdg+7/51PfucMje/KvE4KUwpqXZYUq2C
         K2kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687406676; x=1689998676;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ioniQ/Hu9aB8cdNuAwkTdfNOgY7/VS82KMPqd01oL9E=;
        b=hQ8SPmYVAKT/7NekV2vZnqVvKHDR0mBiooVEq/MSVkQE1XQjz3c/Q93njQMB+/I+HL
         CyUH1qoe9//pRX/XxZxibvhT8Gwk9/xHpwepP4/HRe4U+ISNifmHW5Cl2JgtM7xDBRP1
         jMgL7fBc0tRwKqCo5dFxXhjy5WfxpR9TOqkM90h4dnMxSLsGMDj3nexyXVkLJ1aaa6pw
         5zRrHzXiFlbTk8cIcLT8bgw9oRwGEnktb1qbQPDplts//jdeDXEOLnww4mCH83kVRJ5D
         e5+KhseM4uOqAdsJOsWAA7TYbyn41RJMHCiXX/AzKE5ZZPVcsdr1VlkjX+ByFVxJpigC
         nVGg==
X-Gm-Message-State: AC+VfDx/3egqbeYdv3OfL1nLwN4mK8+39qxX1O0LIIRCNpSgmOZ8zk+T
        b2NhnwlmDCPVQmLPsB6G6yxdiG3OMzPXTva9yX4=
X-Google-Smtp-Source: ACHHUZ4NBA3l0k3gCNnYxndXQ/0QPiZc7y14i6QHpGHzcdonWnfNn1PPslb57C+VAOl0kadu3Hhn5w==
X-Received: by 2002:a17:903:2487:b0:1b4:9dd5:b2af with SMTP id p7-20020a170903248700b001b49dd5b2afmr6122792plw.0.1687406676543;
        Wed, 21 Jun 2023 21:04:36 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id io20-20020a17090312d400b001b3be6c08adsm4217058plb.282.2023.06.21.21.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jun 2023 21:04:35 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qCBYd-00Ehqv-2u;
        Thu, 22 Jun 2023 14:04:31 +1000
Date:   Thu, 22 Jun 2023 14:04:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: rewrite xfs_icache_inode_is_allocated
Message-ID: <ZJPITz0lNOaAdIS5@dread.disaster.area>
References: <168506057909.3730229.17579286342302688368.stgit@frogsfrogsfrogs>
 <168506057960.3730229.15857132833000582560.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168506057960.3730229.15857132833000582560.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 25, 2023 at 05:51:34PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Back in the mists of time[1], I proposed this function to assist the
> inode btree scrubbers in checking the inode btree contents against the
> allocation state of the inode records.  The original version performed a
> direct lookup in the inode cache and returned the allocation status if
> the cached inode hadn't been reused and wasn't in an intermediate state.
> Brian thought it would be better to use the usual iget/irele mechanisms,
> so that was changed for the final version.
> 
> Unfortunately, this hasn't aged well -- the IGET_INCORE flag only has
> one user and clutters up the regular iget path, which makes it hard to
> reason about how it actually works.  Worse yet, the inode inactivation
> series silently broke it because iget won't return inodes that are
> anywhere in the inactivation machinery, even though the caller is
> already required to prevent inode allocation and freeing.  Inodes in the
> inactivation machinery are still allocated, but the current code's
> interactions with the iget code prevent us from being able to say that.
> 
> Now that I understand the inode lifecycle better than I did in early
> 2017, I now realize that as long as the cached inode hasn't been reused
> and isn't actively being reclaimed, it's safe to access the i_mode field
> (with the AGI, rcu, and i_flags locks held), and we don't need to worry
> about the inode being freed out from under us.
> 
> Therefore, port the original version to modern code structure, which
> fixes the brokennes w.r.t. inactivation.  In the next patch we'll remove
> IGET_INCORE since it's no longer necessary.
> 
> [1] https://lore.kernel.org/linux-xfs/149643868294.23065.8094890990886436794.stgit@birch.djwong.org/
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_icache.c |  127 +++++++++++++++++++++++++++++++++++++++++++--------
>  fs/xfs/xfs_trace.h  |   22 +++++++++
>  2 files changed, 129 insertions(+), 20 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 0f60e301eb1f..0048a8b290bc 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -782,23 +782,23 @@ xfs_iget(
>  }
>  
>  /*
> - * "Is this a cached inode that's also allocated?"
> + * Decide if this is this a cached inode that's also allocated.  The caller
> + * must hold the AGI buffer lock to prevent inodes from being allocated or
> + * freed.
>   *
> - * Look up an inode by number in the given file system.  If the inode is
> - * in cache and isn't in purgatory, return 1 if the inode is allocated
> - * and 0 if it is not.  For all other cases (not in cache, being torn
> - * down, etc.), return a negative error code.
> + * Look up an inode by number in the given file system.  If the inode number
> + * is invalid, return -EINVAL.  If the inode is not in cache, return -ENODATA.
> + * If the inode is in an intermediate state (new, being reclaimed, reused) then
> + * return -EAGAIN.
>   *
> - * The caller has to prevent inode allocation and freeing activity,
> - * presumably by locking the AGI buffer.   This is to ensure that an
> - * inode cannot transition from allocated to freed until the caller is
> - * ready to allow that.  If the inode is in an intermediate state (new,
> - * reclaimable, or being reclaimed), -EAGAIN will be returned; if the
> - * inode is not in the cache, -ENOENT will be returned.  The caller must
> - * deal with these scenarios appropriately.
> + * Otherwise, the incore inode is the one we want, and it is either live,
> + * somewhere in the inactivation machinery, or reclaimable.  The inode is
> + * allocated if i_mode is nonzero.  In all three cases, the cached inode will
> + * be more up to date than the ondisk inode buffer, so we must use the incore
> + * i_mode.
>   *
> - * This is a specialized use case for the online scrubber; if you're
> - * reading this, you probably want xfs_iget.
> + * This is a specialized use case for the online fsck; if you're reading this,
> + * you probably want xfs_iget.
>   */
>  int
>  xfs_icache_inode_is_allocated(
> @@ -808,15 +808,102 @@ xfs_icache_inode_is_allocated(
>  	bool			*inuse)
>  {
>  	struct xfs_inode	*ip;
> +	struct xfs_perag	*pag;
> +	xfs_agino_t		agino;
>  	int			error;
>  
> -	error = xfs_iget(mp, tp, ino, XFS_IGET_INCORE, 0, &ip);
> -	if (error)
> -		return error;
> +	/* reject inode numbers outside existing AGs */
> +	if (!ino || XFS_INO_TO_AGNO(mp, ino) >= mp->m_sb.sb_agcount)
> +		return -EINVAL;

xfs_verify_ino(mp, ino)

>  
> -	*inuse = !!(VFS_I(ip)->i_mode);
> -	xfs_irele(ip);
> -	return 0;
> +	/* get the perag structure and ensure that it's inode capable */
> +	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ino));
> +	if (!pag) {
> +		/* No perag means this inode can't possibly be allocated */
> +		return -EINVAL;
> +	}

Probably should be xfs_perag_grab/rele in this function.

> +	agino = XFS_INO_TO_AGINO(mp, ino);
> +
> +	rcu_read_lock();
> +	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
> +	if (!ip) {
> +		/* cache miss */
> +		error = -ENODATA;
> +		goto out_pag;
> +	}
> +
> +	/*
> +	 * If the inode number doesn't match, the incore inode got reused
> +	 * during an RCU grace period and the radix tree hasn't been updated.
> +	 * This isn't the inode we want.
> +	 */
> +	error = -ENODATA;

move this up to before the rcu_read_lock(), and it can be removed
from the !ip branch above, too.

> +	spin_lock(&ip->i_flags_lock);
> +	if (ip->i_ino != ino)
> +		goto out_skip;
> +
> +	trace_xfs_icache_inode_is_allocated(ip);
> +
> +	/*
> +	 * We have an incore inode that matches the inode we want, and the
> +	 * caller holds the AGI buffer.
> +	 *
> +	 * If the incore inode is INEW, there are several possibilities:
> +	 *
> +	 * For a file that is being created, note that we allocate the ondisk
> +	 * inode before allocating, initializing, and adding the incore inode
> +	 * to the radix tree.
> +	 *
> +	 * If the incore inode is being recycled, the inode has to be allocated
> +	 * because we don't allow freed inodes to be recycled.
> +	 *
> +	 * If the inode is queued for inactivation, it should still be
> +	 * allocated.
> +	 *
> +	 * If the incore inode is undergoing inactivation, either it is before
> +	 * the point where it would get freed ondisk (in which case i_mode is
> +	 * still nonzero), or it has already been freed, in which case i_mode
> +	 * is zero.  We don't take the ILOCK here, but difree and dialloc
> +	 * require the AGI, which we do hold.
> +	 *
> +	 * If the inode is anywhere in the reclaim mechanism, we know that it's
> +	 * still ok to query i_mode because we don't allow uncached inode
> +	 * updates.

Is it? We explicitly consider XFS_IRECLAIM inodes as in the process
of being freed, so there is no guarantee that anything in them is
valid anymore. Indeed, there's a transient state in recycling an
inode where we set XFS_IRECLAIM, then re-initialise the inode (which
trashes i_mode) and then restore i_mode to it's correct value before
clearing XFS_IRECLAIM.

Hence I think that if XFS_IRECLAIM is set, we can't make any safe
judgement of the state of i_mode here with just a rcu_read_lock()
being held.

> +	 *
> +	 * If the incore inode is live (i.e. referenced from the dcache), the
> +	 * ondisk inode had better be allocated.  This is the most trivial
> +	 * case.
> +	 */
> +#ifdef DEBUG
> +	if (ip->i_flags & XFS_INEW) {
> +		/* created on disk already or recycling */
> +		ASSERT(VFS_I(ip)->i_mode != 0);
> +	}

I don't think this is correct. In xfs_iget_cache_miss() when
allocating a new inode, we set XFS_INEW and we don't set i_mode
until we call xfs_init_new_inode() after xfs_iget() on the newly
allocated inode returns.  Hence there is a long period where
XFS_INEW can be set and i_mode is zero and the i_flags_lock is not
held.

Remember, if this is a generic function (which by placing it in
fs/xfs/xfs_icache.c is essentially asserting that it is) then the
inode state is only being serialised by RCU. Hence the debug code
here cannot assume that it has been called with the AGI locked to
serialise it against create/free operations, nor that there aren't
other operations being performed on the inode as the lookup is done.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
