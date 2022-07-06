Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FD0BC43334
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Jul 2022 01:10:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiGFBKB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jul 2022 21:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiGFBKB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jul 2022 21:10:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4579A6474
        for <linux-xfs@vger.kernel.org>; Tue,  5 Jul 2022 18:09:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5862D608C1
        for <linux-xfs@vger.kernel.org>; Wed,  6 Jul 2022 01:09:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A253EC341C7;
        Wed,  6 Jul 2022 01:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657069798;
        bh=b1R+abr7PDgW3F9iCwbijZ3SNSxLP9EnbfenHThHAf0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OcdLl+aiEaSu69Tr6XJSTiDPXoR5ZW23xxo8T+ACqGDr8jiZUqoimFmgi9dbw8Gi3
         LU5fHel+zh4afOkAgdX1wWMM7Wm2OqCQszsw/wp6+ItxjvJ/mCwoVriFR5FKzQNIb1
         7zGEpHvCLc8r+FuDQCBXh5Unvz8Aks52D4VVWhNVUU/mjM2/LzOdw0ob2fFvw3ZZCa
         ubeuvXXeVLyt6xLQClpSD5kAexktjSIzYcvSG0au/42ku4oEK8F88QNpuM6v7HLD/G
         HNe40TTenSMpwfnUa9KxeAQiyuZ6Jg5/69NscdRWi2CIsDYesQCV+95MU3RHKIGlTY
         Od9sk35OOnGmw==
Date:   Tue, 5 Jul 2022 18:09:58 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 5/3] xfs: replace inode fork size macros with functions
Message-ID: <YsTg5hdmJtdHZTfO@magnolia>
References: <165705897408.2826746.14673631830829415034.stgit@magnolia>
 <YsTG/Juy45im6Wzv@magnolia>
 <20220706002555.GI227878@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220706002555.GI227878@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 06, 2022 at 10:25:55AM +1000, Dave Chinner wrote:
> On Tue, Jul 05, 2022 at 04:19:24PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Replace the shouty macros here with typechecked helper functions.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> looks good.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> .....
> > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > index 2badbf9bb80d..7ff828504b3c 100644
> > --- a/fs/xfs/xfs_inode.h
> > +++ b/fs/xfs/xfs_inode.h
> > @@ -102,6 +102,41 @@ xfs_ifork_ptr(
> >  	}
> >  }
> >  
> > +static inline unsigned int xfs_inode_fork_boff(struct xfs_inode *ip)
> > +{
> > +	return ip->i_forkoff << 3;
> > +}
> > +
> > +static inline unsigned int xfs_inode_data_fork_size(struct xfs_inode *ip)
> > +{
> > +	if (xfs_inode_has_attr_fork(ip))
> > +		return xfs_inode_fork_boff(ip);
> > +
> > +	return XFS_LITINO(ip->i_mount);
> > +}
> > +
> > +static inline unsigned int xfs_inode_attr_fork_size(struct xfs_inode *ip)
> > +{
> > +	if (xfs_inode_has_attr_fork(ip))
> > +		return XFS_LITINO(ip->i_mount) - xfs_inode_fork_boff(ip);
> > +	return 0;
> > +}
> > +
> > +static inline unsigned int
> > +xfs_inode_fork_size(
> > +	struct xfs_inode	*ip,
> > +	int			whichfork)
> > +{
> > +	switch (whichfork) {
> > +	case XFS_DATA_FORK:
> > +		return xfs_inode_data_fork_size(ip);
> > +	case XFS_ATTR_FORK:
> > +		return xfs_inode_attr_fork_size(ip);
> > +	default:
> > +		return 0;
> > +	}
> > +}
> 
> As an aside, one of the things I noticed when doing the 5.19 libxfs
> sync was that there's some generic xfs_inode stuff in
> fs/xfs/xfs_inode.h that is duplicated in include/xfs_inode.h in
> userspace. I suspect all this new stuff here will end up being
> duplicated, too.
> 
> Hence I'm wondering if these new functions should end up in
> libxfs/xfs_inode_fork.h rather than xfs_inode.h?

They should, but there are a surprising number of files that don't
include xfs_inode.h before xfs_inode_fork.h, which causes a ton of
compilation errors.  I'll respin this series with a gigantic pile
of #include changes, but I wanted to get reviews of the main changes
in this series (patches #2 and #3) before spending time on that.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
