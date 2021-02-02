Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E1E7C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 22:24:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 586AB64F69
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 22:24:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234451AbhBBWXx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Feb 2021 17:23:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:36978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233907AbhBBWWp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Feb 2021 17:22:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39FA264EDA;
        Tue,  2 Feb 2021 22:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612304525;
        bh=EljfkljFETnM0/N8stOE4K1wX9VD9+fst57QZFM9lMY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uyCBNIT6sTRXgGI3sKc6KAegGROVMx6CoVPUZDD4H8tgDKwSzS7/sTcRcfQB6tLaE
         m3giCXHr50uEF1tMA/6FedVEj10gJcJyxw3PPpfIoFsiLSyevbx1nunZuJb0tNGijc
         dG+Lz83R6N/L7iCGiNoEgK+B58hSZGI0fu6Oud/nfsImoQNS4zf2WwNdl4cceYn9q5
         hu/0kji/Ld3pHS4rLx+9rPGcnZ348JkF6nqEYdj+CyV6UX7vei3KJ74PYFFm5Tejf/
         +DmZw2d5aluWwsc2jV8o9KhbpzF2MP021FNeDMGT0qfQcby2hnhVPJNp2GLZJmPk/I
         +h1bKs5azcQAw==
Date:   Tue, 2 Feb 2021 14:22:04 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2.1 2/2] xfs_repair: clear the needsrepair flag
Message-ID: <20210202222204.GW7193@magnolia>
References: <161076028124.3386490.8050189989277321393.stgit@magnolia>
 <161076029319.3386490.2011901341184065451.stgit@magnolia>
 <20210120043128.GX3134581@magnolia>
 <20210120173820.GA1722880@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120173820.GA1722880@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 20, 2021 at 12:38:20PM -0500, Brian Foster wrote:
> On Tue, Jan 19, 2021 at 08:31:28PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Clear the needsrepair flag, since it's used to prevent mounting of an
> > inconsistent filesystem.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> > v2.1: only remove needsrepair at the end of the xfs_repair run
> > ---
> >  include/xfs_mount.h |    1 +
> >  libxfs/init.c       |    2 +-
> >  repair/agheader.c   |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  repair/agheader.h   |    2 ++
> >  repair/xfs_repair.c |    4 +++-
> >  5 files changed, 62 insertions(+), 2 deletions(-)
> > 
> ...
> > diff --git a/repair/agheader.c b/repair/agheader.c
> > index 8bb99489..56a7f45c 100644
> > --- a/repair/agheader.c
> > +++ b/repair/agheader.c
> > @@ -220,6 +220,40 @@ compare_sb(xfs_mount_t *mp, xfs_sb_t *sb)
> >  	return(XR_OK);
> >  }
> >  
> > +/* Clear needsrepair after a successful repair run. */
> > +int
> > +clear_needsrepair(
> > +	struct xfs_mount	*mp)
> > +{
> > +	struct xfs_buf		*bp;
> > +	int			error;
> > +
> > +	if (!xfs_sb_version_needsrepair(&mp->m_sb) || no_modify)
> > +		return 0;
> > +
> > +	/* We must succeed at flushing all dirty buffers to disk. */
> > +	error = -libxfs_flush_mount(mp);
> > +	if (error)
> > +		return error;
> > +
> 
> Do we really need a new helper and buf get/relse cycle just to
> incorporate the above flush? ISTM we could either lift the

Yes.  If quotacheck thinks the dquots are bad, we always want to try to
clear the CHKD flags in the primary superblock, even if other disk
writes fail due to IO errors or write verifiers failing, etc.  Note that
libxfs_bcache_flush only pwrite()s the dirty buffers to disk, it doesn't
force the disks to persist to stable media.

However, if NEEDSREPAIR was set and /any/ part of persisting the dirty
buffers fails (write verifier trips, media errors, etc.) then we don't
even want to try to clear NEEDSREPAIR.

Because of that requirement, the two writes have to be separate steps,
separated by a big flush.

--D

> libxfs_bcache_flush() call above the superblock update in the caller,
> insert the libxfs_flush_mount() right after that, and just do:
> 
> 	dsb->sb_features_incompat &= ~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> 
> ... in the hunk that also updates the quota flags.
> 
> Though perhaps cleaner would be to keep the helper, but genericize it a
> bit to something like final_sb_update() and fold in the qflags update
> and whatever flush/ordering is required for the feature bit.
> 
> > +	/* Clear needsrepair from the superblock. */
> > +	bp = libxfs_getsb(mp);
> > +	if (!bp)
> > +		return ENOMEM;
> > +	if (bp->b_error) {
> > +		error = bp->b_error;
> > +		libxfs_buf_relse(bp);
> > +		return -error;
> > +	}
> > +
> > +	mp->m_sb.sb_features_incompat &= ~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> > +
> > +	libxfs_sb_to_disk(bp->b_addr, &mp->m_sb);
> > +	libxfs_buf_mark_dirty(bp);
> > +	libxfs_buf_relse(bp);
> > +	return 0;
> > +}
> > +
> >  /*
> >   * Possible fields that may have been set at mkfs time,
> >   * sb_inoalignmt, sb_unit, sb_width and sb_dirblklog.
> > @@ -452,6 +486,27 @@ secondary_sb_whack(
> >  			rval |= XR_AG_SB_SEC;
> >  	}
> >  
> > +	if (xfs_sb_version_needsrepair(sb)) {
> > +		if (!no_modify)
> > +			sb->sb_features_incompat &=
> > +					~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> 
> I suspect this should be folded into the check below so we don't modify
> the primary sb by accident (should some other check dirty it).

Yup.  Fixed.

--D

> 
> Brian
> 
> > +		if (i == 0) {
> > +			if (!no_modify)
> > +				do_warn(
> > +	_("clearing needsrepair flag and regenerating metadata\n"));
> > +			else
> > +				do_warn(
> > +	_("would clear needsrepair flag and regenerate metadata\n"));
> > +		} else {
> > +			/*
> > +			 * Quietly clear needsrepair on the secondary supers as
> > +			 * part of ensuring them.  If needsrepair is set on the
> > +			 * primary, it will be done at the very end of repair.
> > +			 */
> > +			rval |= XR_AG_SB_SEC;
> > +		}
> > +	}
> > +
> >  	return(rval);
> >  }
> >  
> > diff --git a/repair/agheader.h b/repair/agheader.h
> > index a63827c8..552c1f70 100644
> > --- a/repair/agheader.h
> > +++ b/repair/agheader.h
> > @@ -82,3 +82,5 @@ typedef struct fs_geo_list  {
> >  #define XR_AG_AGF	0x2
> >  #define XR_AG_AGI	0x4
> >  #define XR_AG_SB_SEC	0x8
> > +
> > +int clear_needsrepair(struct xfs_mount *mp);
> > diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> > index 9409f0d8..d36c5a21 100644
> > --- a/repair/xfs_repair.c
> > +++ b/repair/xfs_repair.c
> > @@ -1133,7 +1133,9 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
> >  	format_log_max_lsn(mp);
> >  
> >  	/* Report failure if anything failed to get written to our fs. */
> > -	error = -libxfs_umount(mp);
> > +	error = clear_needsrepair(mp);
> > +	if (!error)
> > +		error = -libxfs_umount(mp);
> >  	if (error)
> >  		do_error(
> >  	_("File system metadata writeout failed, err=%d.  Re-run xfs_repair.\n"),
> > 
> 
