Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B67CC12002
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:38:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F046613CF
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:38:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234691AbhGNXld (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 19:41:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229535AbhGNXld (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 19:41:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D6AD613CC;
        Wed, 14 Jul 2021 23:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626305921;
        bh=VG6iCWzi5bLxzqYtHEsEFZisgxE5Z8V6rDX0jMtayW0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oCLQmuzc0Ci3qiCbIdxw8C9Vc/TEKjeSbBI1SxtNrnnOSAWmbJWekwAYXbuSgdjXL
         Rpc7vPXlhhIWy0EXe46x/8g8+cCF1oVjx0Tu1KId1FS20/mBWDp4+On4DwECcmLH0i
         hGk5pqar5My9L7aFGpiHYKjmMqPTrW4IW4IuexbA3/DHyxjo8cJkWtiG0RqjjcEDCw
         uKS+kIXh6grozI3jNGWev7DR9sgCEx0DH6/dg+5lIG4dIB5xSL+YkClrPLggAabVcN
         KKuPUDJPW5AxCl1cPNe9WgrI7DSZItP6DWcbAB9fmehL3BxDQKOWfYvjkvGaqSLQEl
         YRG3kYBXh0yPA==
Date:   Wed, 14 Jul 2021 16:38:41 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/16] xfs: convert xfs_fs_geometry to use mount feature
 checks
Message-ID: <20210714233841.GS22402@magnolia>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-11-david@fromorbit.com>
 <20210714231549.GD22402@magnolia>
 <20210714233554.GC664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714233554.GC664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 15, 2021 at 09:35:54AM +1000, Dave Chinner wrote:
> On Wed, Jul 14, 2021 at 04:15:49PM -0700, Darrick J. Wong wrote:
> > On Wed, Jul 14, 2021 at 02:19:06PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Reporting filesystem features to userspace is currently superblock
> > > based. Now we have a general mount-based feature infrastructure,
> > > switch to using the xfs_mount rather than the superblock directly.
> > > 
> > > This reduces the size of the function by over 300 bytes.
> > > 
> > > $ size -t fs/xfs/built-in.a
> > > 	text    data     bss     dec     hex filename
> > > before	1127855  311352     484 1439691  15f7cb (TOTALS)
> > > after	1127535  311352     484 1439371  15f68b (TOTALS)
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_sb.c | 46 ++++++++++++++++++++++--------------------
> > >  fs/xfs/libxfs/xfs_sb.h |  2 +-
> > >  fs/xfs/xfs_ioctl.c     |  2 +-
> > >  fs/xfs/xfs_ioctl32.c   |  2 +-
> > >  4 files changed, 27 insertions(+), 25 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > > index baaec7e6a975..5eaf14b6fe3c 100644
> > > --- a/fs/xfs/libxfs/xfs_sb.c
> > > +++ b/fs/xfs/libxfs/xfs_sb.c
> > > @@ -1016,10 +1016,12 @@ xfs_sync_sb_buf(
> > >  
> > >  void
> > >  xfs_fs_geometry(
> > > -	struct xfs_sb		*sbp,
> > > +	struct xfs_mount	*mp,
> > 
> > Hmm.  I /think/ this won't cause problems in userspace, because db
> > passes in &mp->m_sb, and mkfs passes in sbp, which points to &mp->m_sb,
> > and mp itself points to &mbuf...
> 
> Yes, AFAICT that is correct. mkfs.xfs has the same setup so it
> should work there, too.
> 
> > >  	struct xfs_fsop_geom	*geo,
> > >  	int			struct_version)
> > >  {
> > > +	struct xfs_sb		*sbp = &mp->m_sb;
> > > +
> > >  	memset(geo, 0, sizeof(struct xfs_fsop_geom));
> > >  
> > >  	geo->blocksize = sbp->sb_blocksize;
> > > @@ -1050,51 +1052,51 @@ xfs_fs_geometry(
> > >  	geo->flags = XFS_FSOP_GEOM_FLAGS_NLINK |
> > >  		     XFS_FSOP_GEOM_FLAGS_DIRV2 |
> > >  		     XFS_FSOP_GEOM_FLAGS_EXTFLG;
> > > -	if (xfs_sb_version_hasattr(sbp))
> > > +	if (xfs_has_attr(mp))
> > 
> > ...provided those utilities set m_features before we get to this point,
> > right?  And provided that libxfs_init will take care of that, I think
> > only mkfs would need special consideration, right?
> 
> Yup, that's how I read the usrespace situation - the superblock we
> pass to xfs_fs_geometry() is always attached to a mount structure,
> and we'll set up the features field in the mount when we first read
> in the superblock in libxfs_init(). mkfs might require a specific
> call to set up the m_features field after the superblock is
> finalised (i.e in initialise_mount()), but other than that I
> think it all just works...

Ok.  I'm glad you thought about userspace too!

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
