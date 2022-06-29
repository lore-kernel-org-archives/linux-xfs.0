Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E27BC43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 18:16:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiF2SQI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 14:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiF2SQH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 14:16:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D467377E7
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 11:16:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7C3361F3A
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 18:16:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E963C34114;
        Wed, 29 Jun 2022 18:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656526564;
        bh=KkZvNGIWoz0e4kjz2mpJvdSJvLW2sORdDsHZsPvwzEc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nprjbrpU+kgBkCau5rDmpgLl4VEY/7f0WFay8uUMM4lEselK/lq0GRejL81Jn4p+5
         Olg3Q30XVzW9ITpjFvS1A9+/3JvARM+8rVn5A/6NWTS8WpLzJ7QD/bpDU1UcloJiXL
         quSoHnkc16K/Vin7SqVzZ3pu9N3rqNrD3u5NVRD4shRrS3Vk+GAlXyTwRthDTUfdqh
         W97cu168079iEBR0publVjYlg3d1t1HPsThshelIC8N0hqTkAyZH70PZhEF+IMi1bf
         SE+U5j4Bdy7l8Q8kVU8luQdCbcH/AHgj7jb0qPzT6AH3pdqzMzoTaWNsxnbnN4gHL7
         zrAA1Air1AKKw==
Date:   Wed, 29 Jun 2022 11:16:03 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Alli <allison.henderson@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 14/17] xfs: Add the parent pointer support to the
 superblock version 5.
Message-ID: <YryW44+cr+F1Zox6@magnolia>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
 <20220611094200.129502-15-allison.henderson@oracle.com>
 <20220616060310.GE227878@dread.disaster.area>
 <3d1cdf9bdf67954c457077a58b6520f609999b57.camel@oracle.com>
 <20220620002126.GM227878@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620002126.GM227878@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 20, 2022 at 10:21:26AM +1000, Dave Chinner wrote:
> On Fri, Jun 17, 2022 at 05:32:36PM -0700, Alli wrote:
> > On Thu, 2022-06-16 at 16:03 +1000, Dave Chinner wrote:
> > > On Sat, Jun 11, 2022 at 02:41:57AM -0700, Allison Henderson wrote:
> > > > [dchinner: forward ported and cleaned up]
> > > > [achender: rebased and added parent pointer attribute to
> > > >            compatible attributes mask]
> > > > 
> > > > Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_format.h | 14 +++++++++-----
> > > >  fs/xfs/libxfs/xfs_fs.h     |  1 +
> > > >  fs/xfs/libxfs/xfs_sb.c     |  2 ++
> > > >  fs/xfs/xfs_super.c         |  4 ++++
> > > >  4 files changed, 16 insertions(+), 5 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_format.h
> > > > b/fs/xfs/libxfs/xfs_format.h
> > > > index 96976497306c..e85d6b643622 100644
> > > > --- a/fs/xfs/libxfs/xfs_format.h
> > > > +++ b/fs/xfs/libxfs/xfs_format.h
> > > > @@ -83,6 +83,7 @@ struct xfs_ifork;
> > > >  #define	XFS_SB_VERSION2_OKBITS		\
> > > >  	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
> > > >  	 XFS_SB_VERSION2_ATTR2BIT	| \
> > > > +	 XFS_SB_VERSION2_PARENTBIT	| \
> > > >  	 XFS_SB_VERSION2_PROJID32BIT	| \
> > > >  	 XFS_SB_VERSION2_FTYPE)
> > > 
> > > No need for a v4 filesystem format feature bit - this is v4 only.
> > Ok, I ended up having to add this in the rebase or we get an "SB
> > validate failed".  I think it has to go over in
> > xfs_sb_validate_v5_features next to the manual crc bit check.  Will
> > move
> 
> Ah, I meant that parent pointers are a v5 only feature, and so we
> don't need a "v4 only" feature bit for it. As it is, we can't use
> that specific bit because SGI shipped a version of parent pointers
> on v4 filesystems on IRIX under that feature bit that was broken and
> subsequently recalled and killed. Essentially, that means
> XFS_SB_VERSION2_PARENTBIT is blacklisted and cannot ever be used by
> upstream kernels.
> 
> > > > @@ -353,11 +354,13 @@ xfs_sb_has_compat_feature(
> > > >  #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/*
> > > > reverse map btree */
> > > >  #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/*
> > > > reflinked files */
> > > >  #define XFS_SB_FEAT_RO_COMPAT_INOBTCNT (1 << 3)		/*
> > > > inobt block counts */
> > > > +#define XFS_SB_FEAT_RO_COMPAT_PARENT	(1 << 4)		/*
> > > > parent inode ptr */
> > > >  #define XFS_SB_FEAT_RO_COMPAT_ALL \
> > > > -		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
> > > > -		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
> > > > -		 XFS_SB_FEAT_RO_COMPAT_REFLINK| \
> > > > -		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
> > > > +		(XFS_SB_FEAT_RO_COMPAT_FINOBT  | \
> > > > +		 XFS_SB_FEAT_RO_COMPAT_RMAPBT  | \
> > > > +		 XFS_SB_FEAT_RO_COMPAT_REFLINK | \
> > > > +		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT| \
> > > > +		 XFS_SB_FEAT_RO_COMPAT_PARENT)
> > > 
> > > I'm not sure this is a RO Compat feature - we added an attribute
> > > namespace flag on disk, and the older kernels do not know about
> > > that (i.e. we changed XFS_ATTR_NSP_ONDISK_MASK). This may result in
> > > parent pointer attrs being exposed as user attrs rather than being
> > > hidden, or maybe parent pointer attrs being seen as corrupt because
> > > they have a flag that isn't defined set, etc.
> > > 
> > > Hence I'm not sure that this classification is correct.
> > 
> > Gosh, I'm sure there was a reason we did this, but what ever it was
> > goes all the way back in the first re-appearance of the set back in
> > 2018 and I just cant remember the discussion at the time.  It may have
> > just been done to get mkfs working and we just never got to reviewing
> > it.
> > 
> > Should we drop it and just use XFS_SB_VERSION2_PARENTBIT?
> 
> No, it needs to be a v5 feature bit - create a v5 parent pointer
> filesystem, create some files on it, and then go an mount it on a
> kernel that doesn't have PP support. If you can see the parent
> pointer attributes from userspace as "user.<binary garbage>"
> attributes, then we need to use an INCOMPAT feature bit rather than
> a RO_COMPAT bit.

Agreed, this needs to be a v5 feature bit.

If the current kernel ignores xattr leaf entries with namespaces it
doesn't know about, *then* this could be an rocompat feature.
Otherwise, it has to be incompat.

As it is, I think the attr list functions will return *every* xattr
regardless of namespace, so I think it's not safe to let old kernels
mount pptr filesystems even in readonly mode.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
