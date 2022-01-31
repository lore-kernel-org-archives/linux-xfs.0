Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AC6BC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Jan 2022 23:31:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiAaXbZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Jan 2022 18:31:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49332 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiAaXbY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Jan 2022 18:31:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8332B60B87
        for <linux-xfs@vger.kernel.org>; Mon, 31 Jan 2022 23:31:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D99C340E8;
        Mon, 31 Jan 2022 23:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643671883;
        bh=dLtkXvRPsWHz5XX6KcTEpgLSC4qPIOAafAV/fqJMQJw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H4KfVadP5AxkL3khQw9uJ77d5SvugfYzROGXnVj/cMhIOXY7nOeNBpgGvoC4Jt/JC
         8zAaAlavYhJzxD8aPzJjGPgKT87dxNqrAvNAHUWwXDNiftmXf2hm7gbxkmgoyQmHp5
         chau4vdO099oT7n8FLPYT2tbmPIRH8E3TDUz56zIyLq7jJ29hyH/Ra+mQ4X/fvyNnh
         72yyFLS9YtrOx3ctDi8V+Do6jnACKQ0i0ItT/+HUa0InYydDimC/kUZHbNHEYX/Vvf
         k/+mkmds/xBUH4hsA5hKclbWMe7uxCqRd5RBgeuz4xNQVbHFFi+xbs0ecwgILeOZOY
         MJeEvDeNd1IvQ==
Date:   Mon, 31 Jan 2022 15:31:22 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/45] xfs: convert mount flags to features
Message-ID: <20220131233122.GF8313@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
 <164263798606.860211.15937351978841057288.stgit@magnolia>
 <44cb7849-a54d-b7b2-0ca0-c963947ae765@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44cb7849-a54d-b7b2-0ca0-c963947ae765@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 31, 2022 at 04:59:49PM -0600, Eric Sandeen wrote:
> On 1/19/22 6:19 PM, Darrick J. Wong wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Source kernel commit: 0560f31a09e523090d1ab2bfe21c69d028c2bdf2
> > 
> > Replace m_flags feature checks with xfs_has_<feature>() calls and
> > rework the setup code to set flags in m_features.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  include/xfs_mount.h    |   11 +++++++++++
> >  libxfs/xfs_attr.c      |    4 ++--
> >  libxfs/xfs_attr_leaf.c |   41 +++++++++++++++++++++++------------------
> >  libxfs/xfs_bmap.c      |    4 ++--
> >  libxfs/xfs_ialloc.c    |   10 ++++------
> >  5 files changed, 42 insertions(+), 28 deletions(-)
> > 
> > 
> > diff --git a/include/xfs_mount.h b/include/xfs_mount.h
> > index a995140d..d4b4ccdc 100644
> > --- a/include/xfs_mount.h
> > +++ b/include/xfs_mount.h
> > @@ -197,6 +197,17 @@ __XFS_HAS_FEAT(inobtcounts, INOBTCNT)
> >  __XFS_HAS_FEAT(bigtime, BIGTIME)
> >  __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
> >  
> > +/* Kernel mount features that we don't support */
> > +#define __XFS_UNSUPP_FEAT(name) \
> > +static inline bool xfs_has_ ## name (struct xfs_mount *mp) \
> > +{ \
> > +	return false; \
> > +}
> > +__XFS_UNSUPP_FEAT(wsync)
> > +__XFS_UNSUPP_FEAT(noattr2)
> > +__XFS_UNSUPP_FEAT(ikeep)
> > +__XFS_UNSUPP_FEAT(swalloc)
> 
> So I'd like to add small_inums to the above list:
> 
> +__XFS_UNSUPP_FEAT(small_inums)
> 
> and use that in xfs_set_inode_alloc() here as was done in kernelspace, i.e.:
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 7d94b721..364c3578 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -540,7 +540,7 @@ xfs_set_inode_alloc(
>  	 * sufficiently large, set XFS_MOUNT_32BITINODES if we must alter
>  	 * the allocator to accommodate the request.
>  	 */
> -	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) && ino > XFS_MAXINUMBER_32)
> +	if (xfs_has_small_inums(mp) && ino > XFS_MAXINUMBER_32)
>  		mp->m_flags |= XFS_MOUNT_32BITINODES;
>  	else
>  		mp->m_flags &= ~XFS_MOUNT_32BITINODES;
> 
> 
> That will let us keep this "backport libxfs" series more or less the
> same as kernelspace, without needing to gut xfs_set_inode_alloc() as
> got proposed in
> 
> [PATCH v1.1 39/45] libxfs: remove pointless *XFS_MOUNT* flags
> 
> and followups to preserve userspace inode allocation behavior.
> 
> If we want to remove dead code from the userspace-specific version of
> xfs_set_inode_alloc() I think we can/should do that separately.

Ok, that sounds good to me.

--D

> Thanks,
> -Eric
> 
