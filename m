Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9C23C433B4
	for <linux-xfs@archiver.kernel.org>; Fri, 14 May 2021 18:22:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A84E6613C9
	for <linux-xfs@archiver.kernel.org>; Fri, 14 May 2021 18:22:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbhENSYG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 May 2021 14:24:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233446AbhENSYG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 May 2021 14:24:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 842C9613DA;
        Fri, 14 May 2021 18:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621016574;
        bh=G5Ea39FH9GhXl6VFSrYWIoqHVq8aTLP+Jvw++BPvh5g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mzq0Pq8/33gADcqnC+19KR+HuNukYIt/6Y6FUDZMBwCNTinInMLW0XhPGv0Df7T0y
         OA0tfKAcTcpAvxL1rWLAWUyKTPcfp1VGLh9iayh8Cxqk0Px4jmLcuvoidpf6jZ25G8
         fSU/zVsSOgEdpzXV6bocyqOv2WltysSPZMue+qUOSSfCmdq1NSz1vAN1ndGXPxSKHY
         4F9KEIgjbNEeAVzaol2ztl+MBHNDL4OiqmajrZzACBRd+6l54jTv6nppryELR73kC+
         oJxx9bVs5IqO5b87KN0egfck5XWVbT1MFqVoQL75HynU8nNf2Yp4nykHcbzpPsEL61
         wVEeoitoLhntw==
Date:   Fri, 14 May 2021 11:22:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: validate extsz hints against rt extent size
 when rtinherit is set
Message-ID: <20210514182253.GN9675@magnolia>
References: <162086770193.3685783.14418051698714099173.stgit@magnolia>
 <162086771885.3685783.16422648250546171771.stgit@magnolia>
 <YJ5vS+o3BydK1DrP@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJ5vS+o3BydK1DrP@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 14, 2021 at 08:38:35AM -0400, Brian Foster wrote:
> On Wed, May 12, 2021 at 06:01:58PM -0700, Darrick J. Wong wrote:
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
> > Strengthen the validation routine to avoid this situation and fix the
> > open-coded unit conversion while we're at it.  Note that this is
> > technically a breaking change to the ondisk format, but the risk should
> > be minimal because (a) most vendors disable realtime, (b) letting
> > unaligned hints propagate to new files would immediately crash the
> > filesystem, and (c) xfs_repair flags such filesystems as corrupt, so
> > anyone with such a configuration is broken already anyway.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> 
> Ok, so this looks more like a proper fix, but does this turn an existing
> directory with (rtinherit && extszinherit) and a badly aligned extsz
> hint into a read validation error?

Hmm, you're right.  This fix needs to be more targeted in its nature.
For non-rt filesystems, the rtinherit bit being set on a directory is
benign because we won't set the realtime bit on new files, so there's no
need to introduce a new verifier error that will fail existing
filesystems.

We /do/ need to trap the misconfiguration for filesystems with an rt
volume because those filesystems will fail if the propagation happens.

I think the solution here is to change the verifier check here to
prevent the spread of bad extent size hints:

	if (rt_flag || (xfs_sb_version_hasrealtime(&mp->m_sb) &&
			rtinherit_flag && inherit_flag))
		blocksize_bytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
	else
		blocksize_bytes = mp->m_sb.sb_blocksize;

...and add a check to xfs_ioctl_setattr_check_extsize to prevent
sysadmins from misconfiguring directories in the first place.

--D

> Brian
> 
> >  fs/xfs/libxfs/xfs_inode_buf.c |    7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> > index 5c9a7440d9e4..25261dd73290 100644
> > --- a/fs/xfs/libxfs/xfs_inode_buf.c
> > +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> > @@ -569,19 +569,20 @@ xfs_inode_validate_extsize(
> >  	uint16_t			mode,
> >  	uint16_t			flags)
> >  {
> > -	bool				rt_flag;
> > +	bool				rt_flag, rtinherit_flag;
> >  	bool				hint_flag;
> >  	bool				inherit_flag;
> >  	uint32_t			extsize_bytes;
> >  	uint32_t			blocksize_bytes;
> >  
> >  	rt_flag = (flags & XFS_DIFLAG_REALTIME);
> > +	rtinherit_flag = (flags & XFS_DIFLAG_RTINHERIT);
> >  	hint_flag = (flags & XFS_DIFLAG_EXTSIZE);
> >  	inherit_flag = (flags & XFS_DIFLAG_EXTSZINHERIT);
> >  	extsize_bytes = XFS_FSB_TO_B(mp, extsize);
> >  
> > -	if (rt_flag)
> > -		blocksize_bytes = mp->m_sb.sb_rextsize << mp->m_sb.sb_blocklog;
> > +	if (rt_flag || (rtinherit_flag && inherit_flag))
> > +		blocksize_bytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
> >  	else
> >  		blocksize_bytes = mp->m_sb.sb_blocksize;
> >  
> > 
> 
