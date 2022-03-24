Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ACB0C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Mar 2022 21:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351432AbiCXVmH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Mar 2022 17:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355212AbiCXVmG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Mar 2022 17:42:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5967EB0A5E
        for <linux-xfs@vger.kernel.org>; Thu, 24 Mar 2022 14:40:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00B78B82649
        for <linux-xfs@vger.kernel.org>; Thu, 24 Mar 2022 21:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 981BAC340EC;
        Thu, 24 Mar 2022 21:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648158030;
        bh=gknODSm8fTc7X7JxkYxCkxSsFh/UcaejaANsdH5QMQc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HGb0dZaIbzLhUkIHzy4oQR8MCAnmR64TFuGV8sZQIT6hF9hNlqGzx0SztHqpRb6U3
         qJVKwy5sUaemLER5H77k8wqkJi4Gbo54Mu6MVvzoFD+Ks+uv40yNhNBQ8WarSlL6Sx
         rQooY7RQUikAFTf3iyJ8AZcQGHlvtJoEuZg+FniFRwieEevGLVnXF/Swamh4XGUliP
         dL5VVhXDmuaotj1JQEGnlEXfkrgZ9kwdrOoLEfd2BFg1ArqNZNuLKfyl7XzczRpwsT
         3uAu6AaAuUBjMJ2NVOt0E8seY/Fi0jE88fOnycCCQc+4oflNIlKWONZmzGBL2nUv4J
         HjB2fHWgaLB3g==
Date:   Thu, 24 Mar 2022 14:40:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V8 08/19] xfs: Introduce XFS_SB_FEAT_INCOMPAT_NREXT64 and
 associated per-fs feature bit
Message-ID: <20220324214030.GT8224@magnolia>
References: <20220321051750.400056-1-chandan.babu@oracle.com>
 <20220321051750.400056-9-chandan.babu@oracle.com>
 <20220324213719.GG1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324213719.GG1544202@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 25, 2022 at 08:37:19AM +1100, Dave Chinner wrote:
> On Mon, Mar 21, 2022 at 10:47:39AM +0530, Chandan Babu R wrote:
> > XFS_SB_FEAT_INCOMPAT_NREXT64 incompat feature bit will be set on filesystems
> > which support large per-inode extent counters. This commit defines the new
> > incompat feature bit and the corresponding per-fs feature bit (along with
> > inline functions to work on it).
> > 
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_format.h | 1 +
> >  fs/xfs/libxfs/xfs_sb.c     | 3 +++
> >  fs/xfs/xfs_mount.h         | 2 ++
> >  3 files changed, 6 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > index b5e9256d6d32..64ff0c310696 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -372,6 +372,7 @@ xfs_sb_has_ro_compat_feature(
> >  #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
> >  #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
> >  #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
> > +#define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)	/* large extent counters */
> >  #define XFS_SB_FEAT_INCOMPAT_ALL \
> >  		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
> >  		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
> > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > index f4e84aa1d50a..bd632389ae92 100644
> > --- a/fs/xfs/libxfs/xfs_sb.c
> > +++ b/fs/xfs/libxfs/xfs_sb.c
> > @@ -124,6 +124,9 @@ xfs_sb_version_to_features(
> >  		features |= XFS_FEAT_BIGTIME;
> >  	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR)
> >  		features |= XFS_FEAT_NEEDSREPAIR;
> > +	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NREXT64)
> > +		features |= XFS_FEAT_NREXT64;
> > +
> 
> Shouldn't enabling the feature be the last patch in the series, once
> all the infrastructure to support the feature is in place? i.e. if
> someone does a bisect on a XFS_FEAT_NREXT64 enabled filesystem, they
> can land in the middle of this series where the fs tries to use
> XFS_FEAT_NREXT64 but the functionality is not complete.

The last patch of the series does exactly that, by adding NREXT64 to
XFS_SB_FEAT_INCOMPAT_ALL.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
