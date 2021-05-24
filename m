Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B68AC2B9F8
	for <linux-xfs@archiver.kernel.org>; Mon, 24 May 2021 17:23:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB3AB61260
	for <linux-xfs@archiver.kernel.org>; Mon, 24 May 2021 17:23:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbhEXRY5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 May 2021 13:24:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232543AbhEXRY4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 May 2021 13:24:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C83E613EC;
        Mon, 24 May 2021 17:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621877008;
        bh=bAGbi0QrSHmDUiViNkYPYgNcvUvtGhiquSEM1ZpR5h0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sDtaX5GiypYM9YR+RWpWCTs3XKEA5bc1Mqt1RQnoQHo/4no8iaWPB4PS3O2MfGU/i
         KajwYViUb/dHsJdDDrbwVI4FHOMlWBTFxRMfogjrQmts62fzDkWrJqAokR7gUTauDk
         /JyhC9avn4Q7FVDFnUl1mJCVTptpLT1JcX+sj4SUUUPRvacSpWyZJtNL2IisE1Z35N
         Fgz1A3L/5R3FtnjdacdjuxD1c+lt99zSR61AgPtSf7wOuctMs5WmHmyhwP1GYG+ARF
         WV9fmd5GO5FPgDg4YPuuJb9iyo8dg7JsNkY02v8OwaA3pX2Iz5xzt3gtG2rzntGGsd
         8CBw2W8vchoMw==
Date:   Mon, 24 May 2021 10:23:28 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 2/2] xfs: validate extsz hints against rt extent size
 when rtinherit is set
Message-ID: <20210524172328.GA202121@locust>
References: <162181807472.202929.18194381144862527586.stgit@locust>
 <162181808584.202929.10474310046605173335.stgit@locust>
 <YKuDFNdxIqLKfIbg@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKuDFNdxIqLKfIbg@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 24, 2021 at 06:42:28AM -0400, Brian Foster wrote:
> On Sun, May 23, 2021 at 06:01:25PM -0700, Darrick J. Wong wrote:
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
> > extent size hint, we'll simply turn off the hint to correct the error.
> > Second, if someone tries to misconfigure a file via the fssetxattr
> > ioctl, we'll fail the ioctl.  Third, we reverify both extent size hint
> > values when we propagate heritable inode attributes from parent to
> > child, so that we prevent misconfigurations from spreading.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_inode_buf.c   |   13 +++++++++++++
> >  fs/xfs/libxfs/xfs_trans_inode.c |   15 +++++++++++++++
> >  fs/xfs/xfs_inode.c              |   29 +++++++++++++++++++++++++++++
> >  fs/xfs/xfs_ioctl.c              |   15 +++++++++++++++
> >  4 files changed, 72 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> > index 045118c7bf78..23c19e632c2d 100644
> > --- a/fs/xfs/libxfs/xfs_inode_buf.c
> > +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> > @@ -589,6 +589,19 @@ xfs_inode_validate_extsize(
> >  	inherit_flag = (flags & XFS_DIFLAG_EXTSZINHERIT);
> >  	extsize_bytes = XFS_FSB_TO_B(mp, extsize);
> >  
> > +	/*
> > +	 * This comment describes a historic gap in this verifier function.
> > +	 * On older kernels, XFS doesnt't check that the extent size hint is
> > +	 * an integer multiple of the rt extent size on a directory with both
> > +	 * RTINHERIT and EXTSZINHERIT flags set.  This results in corruption
> > +	 * shutdowns when the misaligned hint propagates into new realtime
> > +	 * files, since they do check the rextsize alignment of the hint for
> > +	 * files with the REALTIME flag set.  There could be filesystems with
> > +	 * misconfigured directories in the wild, so we cannot add it to the
> > +	 * verifier now because that would cause new corruption shutdowns on
> > +	 * the directories.
> > +	 */
> > +
> 
> One of the things that confused me about the previous version is whether
> the verifier changes would have triggered corruption on read of a
> misconfigured inode.

Yes, it would have, so I switched strategies...

> If so, that seems to conflict with propagation
> mitigation if we can't read such a pre-existing inode in the first
> place. Is that not still a factor here too?

...completely away from making any code changes to the verifier.
So to answer your question, it should not be a factor any more.

> >  	if (rt_flag)
> >  		blocksize_bytes = mp->m_sb.sb_rextsize << mp->m_sb.sb_blocklog;
> >  	else
> > diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> > index 78324e043e25..325f2dceec13 100644
> > --- a/fs/xfs/libxfs/xfs_trans_inode.c
> > +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> > @@ -142,6 +142,21 @@ xfs_trans_log_inode(
> >  		flags |= XFS_ILOG_CORE;
> >  	}
> >  
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
> 
> Hmm.. if we're going to also clear the state from preexisting
> directories (vs. just mitigate propagation), it kind of makes me wonder
> why we wouldn't just clear the bad settings from in-core inodes on read.

Making corrections at iget time is complicated -- of the callers that
pass in a transaction, I'd would have to check every call site carefully
to ensure that we don't cancel what would otherwise be a clean
transaction, since that would lead to a shutdown.  The non-transaction
iget callsites would each have to grow a call to get a transaction,
update the inode, and commit it.  We'd have to be careful to make sure
that all new iget callsites do this properly, forever.  We could make
the change nontransactionally and wait for someone to log the icore to
persist the changes, but that's always frowned upon.

That's why I decided to go with making updates in xfs_trans_log_inode,
since (a) it's not going to burn a bunch of human time, (b) it's where
we perform other silent inode upgrades, and (c) it doesn't generate any
new log traffic.

However, I just had a thought--

This patch doesn't do anything to fix the case of existing realtime
regular files with an invalid hint.  The only time the invalid hint
actually bites us is in xfs_bmap_rtalloc.  To fix that case, all I need
to do is amend xfs_trans_log_inode to fix realtime files too, and then
update xfs_bmap_rtalloc:

	align = xfs_get_extsz_hint(ap->ip);

to check for bad hints:

	align = xfs_get_extsz_hint(ap->ip);
	if (align > mp->m_sb.sb_rextsize &&
	    align % mp->m_sb.sb_rextsize)
		align = mp->m_sb.sb_rextsize;

If the allocation succeeds, then the rt file's inode (which is already
ijoined) gets logged, at which point we'll correct the inode.

> Wouldn't that also prevent the state from propagating and/or clear it
> from directories on next modification?

Yes, but with the reviewer costs mentioned above.

--D

> 
> Brian
> 
> >  	/*
> >  	 * Record the specific change for fdatasync optimisation. This allows
> >  	 * fdatasync to skip log forces for inodes that are only timestamp
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 0369eb22c1bb..e4c2da4566f1 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -690,6 +690,7 @@ xfs_inode_inherit_flags(
> >  	const struct xfs_inode	*pip)
> >  {
> >  	unsigned int		di_flags = 0;
> > +	xfs_failaddr_t		failaddr;
> >  	umode_t			mode = VFS_I(ip)->i_mode;
> >  
> >  	if (S_ISDIR(mode)) {
> > @@ -729,6 +730,24 @@ xfs_inode_inherit_flags(
> >  		di_flags |= XFS_DIFLAG_FILESTREAM;
> >  
> >  	ip->i_diflags |= di_flags;
> > +
> > +	/*
> > +	 * Inode verifiers on older kernels only check that the extent size
> > +	 * hint is an integer multiple of the rt extent size on realtime files.
> > +	 * They did not check the hint alignment on a directory with both
> > +	 * rtinherit and extszinherit flags set.  If the misaligned hint is
> > +	 * propagated from a directory into a new realtime file, new file
> > +	 * allocations will fail due to math errors in the rt allocator and/or
> > +	 * trip the verifiers.  Validate the hint settings in the new file so
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
> >  
> >  /* Propagate di_flags2 from a parent inode to a child inode. */
> > @@ -737,12 +756,22 @@ xfs_inode_inherit_flags2(
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
> > +	/* Don't let invalid cowextsize hints propagate. */
> > +	failaddr = xfs_inode_validate_cowextsize(ip->i_mount, ip->i_cowextsize,
> > +			VFS_I(ip)->i_mode, ip->i_diflags, ip->i_diflags2);
> > +	if (failaddr) {
> > +		ip->i_diflags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
> > +		ip->i_cowextsize = 0;
> > +	}
> >  }
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
