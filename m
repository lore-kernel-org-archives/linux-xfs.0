Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A699C433B4
	for <linux-xfs@archiver.kernel.org>; Fri, 14 May 2021 15:55:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 370C861444
	for <linux-xfs@archiver.kernel.org>; Fri, 14 May 2021 15:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233914AbhENP4r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 May 2021 11:56:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231519AbhENP4p (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 May 2021 11:56:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42051613B9;
        Fri, 14 May 2021 15:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621007734;
        bh=v5DRmDZo2IWJ/5xYwox1340RW7KLECmn5cf4wrNd0XI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ajB2CvQ0FIacPV/sgyjBiZKix8ET6CDCAMPCt+wWMMbLK5RoERG9ZrPSHHJEjAK9A
         9uYno5hFGM9QWr6ZVJis8k+9F63wdQmDwkvN8hkvCtB/o+KqWRBGdnat21x7IX2JU0
         bCbW/S+REPiXN6sNw6V5pOljRMzL27F8/kriPnTjma2Q4jyToQqKuSMyKmjZf/tMN7
         spFqNzcQHtq97k2GjjViIOrmVM9ECOS3bu/ZyszKRjy7Q/ybsaFe/xdHOztkFgayBd
         5b1kxsdqEWPkBTPrUIq0FD4oIOlR7gL3DT3uw7YD9w+8EgFzvdtb4QqxozWqupEL9s
         uAU+kBfPtoaSw==
Date:   Fri, 14 May 2021 08:55:33 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: don't propagate invalid extent size hints to
 new files
Message-ID: <20210514155533.GJ9675@magnolia>
References: <162086770193.3685783.14418051698714099173.stgit@magnolia>
 <162086771324.3685783.12562187598352097487.stgit@magnolia>
 <YJ5vQ2GHFw2EilJO@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJ5vQ2GHFw2EilJO@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 14, 2021 at 08:38:27AM -0400, Brian Foster wrote:
> On Wed, May 12, 2021 at 06:01:53PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Under the current inode extent size hint validation rules, it's possible
> > to set extent size hints on directories along with an 'inherit' flag so
> > that the values will be propagated to newly created regular files.  (The
> > directories themselves do not care about the hint values.)
> > 
> > For these directories, the alignment of the hint is checked against the
> > data device even if the directory also has the rtinherit hint set, which
> > means that one can set a directory's hint value to something that isn't
> > an integer multiple of the realtime extent size.  This isn't a problem
> > for the directory itself, but the validation routines require rt extent
> > alignment for realtime files.
> > 
> > If the unaligned hint value and the realtime bit are both propagated
> > into a newly created regular realtime file, we end up writing out an
> > incorrect hint that trips the verifiers the next time we try to read the
> > inode buffer, and the fs shuts down.  Fix this by cancelling the hint
> > propagation if it would cause problems.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> 
> Hmm.. this seems a bit unfortunate. Is the purpose of this flag
> cancellation behavior basically to accommodate existing filesystems that
> might have this incompatible combination in place?

Yes.  The incompatible combination when set on a directory is benign,
but setting it on regular files gets us into real trouble, so the goal
here is to end the propagation of the incompatible values.

--D

> Brian
> 
> >  fs/xfs/xfs_inode.c |   19 +++++++++++++++++++
> >  1 file changed, 19 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 0369eb22c1bb..db81e8c22708 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -689,6 +689,7 @@ xfs_inode_inherit_flags(
> >  	struct xfs_inode	*ip,
> >  	const struct xfs_inode	*pip)
> >  {
> > +	xfs_failaddr_t		failaddr;
> >  	unsigned int		di_flags = 0;
> >  	umode_t			mode = VFS_I(ip)->i_mode;
> >  
> > @@ -728,6 +729,14 @@ xfs_inode_inherit_flags(
> >  	if (pip->i_diflags & XFS_DIFLAG_FILESTREAM)
> >  		di_flags |= XFS_DIFLAG_FILESTREAM;
> >  
> > +	/* Make sure the extsize actually validates properly. */
> > +	failaddr = xfs_inode_validate_extsize(ip->i_mount, ip->i_extsize,
> > +			VFS_I(ip)->i_mode, ip->i_diflags);
> > +	if (failaddr) {
> > +		di_flags &= ~(XFS_DIFLAG_EXTSIZE | XFS_DIFLAG_EXTSZINHERIT);
> > +		ip->i_extsize = 0;
> > +	}
> > +
> >  	ip->i_diflags |= di_flags;
> >  }
> >  
> > @@ -737,12 +746,22 @@ xfs_inode_inherit_flags2(
> >  	struct xfs_inode	*ip,
> >  	const struct xfs_inode	*pip)
> >  {
> > +	xfs_failaddr_t		failaddr;
> > +
> >  	if (pip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) {
> >  		ip->i_diflags2 |= XFS_DIFLAG2_COWEXTSIZE;
> >  		ip->i_cowextsize = pip->i_cowextsize;
> >  	}
> >  	if (pip->i_diflags2 & XFS_DIFLAG2_DAX)
> >  		ip->i_diflags2 |= XFS_DIFLAG2_DAX;
> > +
> > +	/* Make sure the cowextsize actually validates properly. */
> > +	failaddr = xfs_inode_validate_cowextsize(ip->i_mount, ip->i_cowextsize,
> > +			VFS_I(ip)->i_mode, ip->i_diflags, ip->i_diflags2);
> > +	if (failaddr) {
> > +		ip->i_diflags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
> > +		ip->i_cowextsize = 0;
> > +	}
> >  }
> >  
> >  /*
> > 
> 
