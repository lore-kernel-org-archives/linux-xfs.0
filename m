Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D320BC2B9F8
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 17:21:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8DE461401
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 17:21:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbhEYRWc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 13:22:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233731AbhEYRW2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 May 2021 13:22:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 465BF613F4;
        Tue, 25 May 2021 17:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621963258;
        bh=Jh9ivWcjF2mLIAhAb2XC0G+mMEnSLVqafsB9DxzeAYU=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=QQ0PMl4GrGtWKzDx1N2NsKkHF/4OtH2gbnLsQpO5irzBKSNFzSPUR4E41+0ljTXo4
         itfTLs/baR3FpEkMKG1Q1KgnNep8YYnsaDLGn9bFwIRW04jW3tcfxio06ts50RIJ+x
         O1u2T3/7ghM8ASveHvibs7+bD20H3+cOD0QYIa6JbLQX8unR0vtHOFR0V6oAO7mQQM
         X6dDpXi8zzFzN3kCCjZguTnaFFWpJwIeDCy79ZS2hzGFQczC9TxkFJTcIL1VPx14dW
         iSqA3QvmpQA2UGieQOFBSuac1hgw9FrfhjciBAl+EsmzUnPn/+Ou6jrBudN/f3qh8r
         z8fY5q6AytxSQ==
Date:   Tue, 25 May 2021 10:20:57 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, bfoster@redhat.com, hch@infradead.org
Subject: Re: [PATCH v3] xfs: validate extsz hints against rt extent size when
 rtinherit is set
Message-ID: <20210525172057.GG202121@locust>
References: <20210525061531.GF202121@locust>
 <20210525104902.sjch56wbtvav5wcr@omega.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210525104902.sjch56wbtvav5wcr@omega.lan>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 25, 2021 at 12:49:02PM +0200, Carlos Maiolino wrote:
> Hi Darrick.
> 
> On Mon, May 24, 2021 at 11:15:31PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The RTINHERIT bit can be set on a directory so that newly created
> > regular files will have the REALTIME bit set to store their data on the
> > realtime volume.  If an extent size hint (and EXTSZINHERIT) are set on
> > the directory, the hint will also be copied into the new file.
> > 
> > As pointed out in previous patches, for realtime files we require the
> > extent size hint be an integer multiple of the realtime extent, but we
> > don't perform the same validation on a directory with both RTINHERIT and
> > EXTSZINHERIT set, even though the only use-case of that combination is
> > to propagate extent size hints into new realtime files.  This leads to
> > inode corruption errors when the bad values are propagated.
> > 
> > Because there may be existing filesystems with such a configuration, we
> > cannot simply amend the inode verifier to trip on these directories and
> > call it a day because that will cause previously "working" filesystems
> > to start throwing errors abruptly.  Note that it's valid to have
> > directories with rtinherit set even if there is no realtime volume, in
> > which case the problem does not manifest because rtinherit is ignored if
> > there's no realtime device; and it's possible that someone set the flag,
> > crashed, repaired the filesystem (which clears the hint on the realtime
> > file) and continued.
> > 
> > Therefore, mitigate this issue in several ways: First, if we try to
> > write out an inode with both rtinherit/extszinherit set and an unaligned
> > extent size hint, turn off the hint to correct the error.  Second, if
> > someone tries to misconfigure a directory via the fssetxattr ioctl, fail
> > the ioctl.  Third, reverify both extent size hint values when we
> > propagate heritable inode attributes from parent to child, to prevent
> > misconfigurations from spreading.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> > v2: disable incorrect hints at runtime instead of whacking filesystems
> >     with verifier errors
> > v3: revise the comment in the verifier to describe the source of the
> >     problem, the observable symptoms, and how the solution fits the
> >     historical context
> 
> IMHO the patch is fine, I have just one comment I'd like to address though:
> 
> > +	/*
> > +	 * Inode verifiers on older kernels don't check that the extent size
> > +	 * hint is an integer multiple of the rt extent size on a directory
> > +	 * with both rtinherit and extszinherit flags set.  If we're logging a
> > +	 * directory that is misconfigured in this way, clear the hint.
> > +	 */
> > +	if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
> > +	    (ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) &&
> > +	    (ip->i_extsize % ip->i_mount->m_sb.sb_rextsize) > 0) {
> > +		ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE |
> > +				   XFS_DIFLAG_EXTSZINHERIT);
> > +		ip->i_extsize = 0;
> > +		flags |= XFS_ILOG_CORE;
> > +	}
> > +
> ...
> > +	 * that we don't let broken hints propagate.
> > +	 */
> > +	failaddr = xfs_inode_validate_extsize(ip->i_mount, ip->i_extsize,
> > +			VFS_I(ip)->i_mode, ip->i_diflags);
> > +	if (failaddr) {
> > +		ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE |
> > +				   XFS_DIFLAG_EXTSZINHERIT);
> > +		ip->i_extsize = 0;
> > +	}
> >  }
> 
> ...
> > +	/* Don't let invalid cowextsize hints propagate. */
> > +	failaddr = xfs_inode_validate_cowextsize(ip->i_mount, ip->i_cowextsize,
> > +			VFS_I(ip)->i_mode, ip->i_diflags, ip->i_diflags2);
> > +	if (failaddr) {
> > +		ip->i_diflags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
> > +		ip->i_cowextsize = 0;
> > +	}
> >  }
> 
> In all cases above, wouldn't be interesting to at least log the fact we are
> resetting the extent size? At least in debug mode? This may let users clueless
> on why the extent size has been reset, or at least give us some debug data when
> required?

Ok, I'll add an xfs_info message to log the fact that we are changing
inode attributes.  Thanks for the review!

--D

> 
> 
> The patch itself looks fine, with or without logging the extsize reset, you can
> add:
> 
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> Cheers
> 
> >  
> >  /*
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 6407921aca96..1fe4c1fc0aea 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -1291,6 +1291,21 @@ xfs_ioctl_setattr_check_extsize(
> >  
> >  	new_diflags = xfs_flags2diflags(ip, fa->fsx_xflags);
> >  
> > +	/*
> > +	 * Inode verifiers on older kernels don't check that the extent size
> > +	 * hint is an integer multiple of the rt extent size on a directory
> > +	 * with both rtinherit and extszinherit flags set.  Don't let sysadmins
> > +	 * misconfigure directories.
> > +	 */
> > +	if ((new_diflags & XFS_DIFLAG_RTINHERIT) &&
> > +	    (new_diflags & XFS_DIFLAG_EXTSZINHERIT)) {
> > +		unsigned int	rtextsize_bytes;
> > +
> > +		rtextsize_bytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
> > +		if (fa->fsx_extsize % rtextsize_bytes)
> > +			return -EINVAL;
> > +	}
> > +
> >  	failaddr = xfs_inode_validate_extsize(ip->i_mount,
> >  			XFS_B_TO_FSB(mp, fa->fsx_extsize),
> >  			VFS_I(ip)->i_mode, new_diflags);
> > 
> 
> -- 
> Carlos
> 
