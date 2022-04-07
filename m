Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F92FC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 01:47:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbiDGBtu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 21:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239555AbiDGBtR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 21:49:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58972335CE
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 18:47:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AE161CE2684
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 01:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAD0C385A1;
        Thu,  7 Apr 2022 01:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649296019;
        bh=vu4scvkUZ9QQ6jc2BCg3FONxbWn9xzQuSoxLOq3sQQo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l//uNoSWY3dIiHBlnGoeqeLiVJ/+hFMwFU6G39RdovxseFfxhc/DngOg+4aMDzL/j
         gZDgPrSvnYtL3TAZ1MVBA6T1qdsk6ngoB95djYcWu56mLkvFf3qLMN84E9duYIhmDI
         Tg63w3pfUbCI68M0saPHG7FbX58wUmH/Tj+ggQ0VN5GoM0a9lxjX0EF45yyW5gPmsY
         3NbMTND5LMNBELvTjgrLnrEaGSpaBX1fYwA1ruph0BGTexqE9jzFCaZdtTCGmqd0zj
         6iKxoqLzx+AfvFXg+eCv5jTJ9p2kinl7SNyES416ej38k+Vb+SATh+YrX5YI8mqBy+
         +gI2b4HRuXkLw==
Date:   Wed, 6 Apr 2022 18:46:58 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V9 16/19] xfs: Conditionally upgrade existing inodes to
 use large extent counters
Message-ID: <20220407014658.GW27690@magnolia>
References: <20220406061904.595597-1-chandan.babu@oracle.com>
 <20220406061904.595597-17-chandan.babu@oracle.com>
 <20220407012225.GF1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407012225.GF1544202@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 07, 2022 at 11:22:25AM +1000, Dave Chinner wrote:
> On Wed, Apr 06, 2022 at 11:49:00AM +0530, Chandan Babu R wrote:
> > This commit enables upgrading existing inodes to use large extent counters
> > provided that underlying filesystem's superblock has large extent counter
> > feature enabled.
> > 
> > Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c       | 10 ++++++++++
> >  fs/xfs/libxfs/xfs_bmap.c       |  6 ++++--
> >  fs/xfs/libxfs/xfs_format.h     |  8 ++++++++
> >  fs/xfs/libxfs/xfs_inode_fork.c | 19 +++++++++++++++++++
> >  fs/xfs/libxfs/xfs_inode_fork.h |  2 ++
> >  fs/xfs/xfs_bmap_item.c         |  2 ++
> >  fs/xfs/xfs_bmap_util.c         | 13 +++++++++++++
> >  fs/xfs/xfs_dquot.c             |  3 +++
> >  fs/xfs/xfs_iomap.c             |  5 +++++
> >  fs/xfs/xfs_reflink.c           |  5 +++++
> >  fs/xfs/xfs_rtalloc.c           |  3 +++
> >  11 files changed, 74 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index 23523b802539..66c4fc55c9d7 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -776,8 +776,18 @@ xfs_attr_set(
> >  	if (args->value || xfs_inode_hasattr(dp)) {
> >  		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
> >  				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
> > +		if (error == -EFBIG)
> > +			error = xfs_iext_count_upgrade(args->trans, dp,
> > +					XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
> >  		if (error)
> >  			goto out_trans_cancel;
> > +
> > +		if (error == -EFBIG) {
> > +			error = xfs_iext_count_upgrade(args->trans, dp,
> > +					XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
> > +			if (error)
> > +				goto out_trans_cancel;
> > +		}
> >  	}
> 
> Did you forgot to remove the original xfs_iext_count_upgrade() call?
> 
> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > index 43de892d0305..bb327ea43ca1 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -934,6 +934,14 @@ enum xfs_dinode_fmt {
> >  #define XFS_MAX_EXTCNT_DATA_FORK_SMALL	((xfs_extnum_t)((1ULL << 31) - 1))
> >  #define XFS_MAX_EXTCNT_ATTR_FORK_SMALL	((xfs_extnum_t)((1ULL << 15) - 1))
> >  
> > +/*
> > + * This macro represents the maximum value by which a filesystem operation can
> > + * increase the value of an inode's data/attr fork extent count.
> > + */
> > +#define XFS_MAX_EXTCNT_UPGRADE_NR	\
> > +	min(XFS_MAX_EXTCNT_ATTR_FORK_LARGE - XFS_MAX_EXTCNT_ATTR_FORK_SMALL,	\
> > +	    XFS_MAX_EXTCNT_DATA_FORK_LARGE - XFS_MAX_EXTCNT_DATA_FORK_SMALL)
> 
> You don't need to write "This macro represents" in a comment above
> the macro that that the comment is describing. If you need to refer
> to the actual macro, use it's name directly.
> 
> As it is, the comment could be improved:
> 
> /*
>  * When we upgrade an inode to the large extent counts, the maximum
>  * value by which the extent count can increase is bound by the
>  * change in size of the on-disk field. No upgrade operation should
>  * ever be adding more than a few tens of, so if we get a really

Nit: missing object?

"...more than a few tens of extents, so if we get..."

--D

>  * large value it is a sign of a code bug or corruption.
>  */
> #define XFS_MAX_EXTCNT_UPGRADE_NR	\
> 	min(XFS_MAX_EXTCNT_ATTR_FORK_LARGE - XFS_MAX_EXTCNT_ATTR_FORK_SMALL,	\
> 	    XFS_MAX_EXTCNT_DATA_FORK_LARGE - XFS_MAX_EXTCNT_DATA_FORK_SMALL)
> 
> Otherwise it looks OK.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
