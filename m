Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A3FFC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 27 May 2022 00:23:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiE0AXY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 May 2022 20:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiE0AXX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 20:23:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C971644E1
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 17:23:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DBB9B82275
        for <linux-xfs@vger.kernel.org>; Fri, 27 May 2022 00:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F60CC385A9;
        Fri, 27 May 2022 00:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653610999;
        bh=peIZXoQYBeozn1lZCsulDDqLjwR1hjY8if+qyg/f7n4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bTS8yoBm6CIUfWcySRtpGjJ2ZXMOnxqoMGwQJ0sN3+efO2DnJUYxqlqA3lDwz6lXe
         XPw4roQ97D8ftuQjSCwrZnruReWQecslJyyNYsLycSNYWIGoJV1ve9io28M3A5je1w
         S0XV4/bMPwCeecztT0UQMOPrlq5DWHoXnUTT14fStzfY4W5QxdQ5jBZdcsb5n/22rW
         ZYvByXxCb0/msVlD8nqhC1uvsteiK20FicOBjuWv3kKYcTt/f0CZx+KB+cUSQC+ON1
         52SNi2Y5U9mTbfD34LCKlE1h8I6B8k3BL7QzZBnczuJ1+kfUbG+Pm5Q4G13YoaMguR
         FGAjPBjc2g0LA==
Date:   Thu, 26 May 2022 17:23:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_repair: don't flag log_incompat inconsistencies as
 corruptions
Message-ID: <YpAZ9vAg6XFeXYB1@magnolia>
References: <Yo02nmlajIuFqVez@magnolia>
 <337aa926-ba8c-3383-c200-e54fde4182f1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <337aa926-ba8c-3383-c200-e54fde4182f1@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 26, 2022 at 04:53:30PM -0500, Eric Sandeen wrote:
> On 5/24/22 2:48 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > While testing xfs/233 and xfs/127 with LARP mode enabled, I noticed
> > errors such as the following:
> > 
> > xfs_growfs --BlockSize=4096 --Blocks=8192
> > data blocks changed from 8192 to 2579968
> > meta-data=/dev/sdf               isize=512    agcount=630, agsize=4096 blks
> >          =                       sectsz=512   attr=2, projid32bit=1
> >          =                       crc=1        finobt=1, sparse=1, rmapbt=1
> >          =                       reflink=1    bigtime=1 inobtcount=1
> > data     =                       bsize=4096   blocks=2579968, imaxpct=25
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> > log      =internal log           bsize=4096   blocks=3075, version=2
> >          =                       sectsz=512   sunit=0 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > _check_xfs_filesystem: filesystem on /dev/sdf is inconsistent (r)
> > *** xfs_repair -n output ***
> > Phase 1 - find and verify superblock...
> >         - reporting progress in intervals of 15 minutes
> > Phase 2 - using internal log
> >         - zero log...
> >         - 23:03:47: zeroing log - 3075 of 3075 blocks done
> >         - scan filesystem freespace and inode maps...
> > would fix log incompat feature mismatch in AG 30 super, 0x0 != 0x1
> > would fix log incompat feature mismatch in AG 8 super, 0x0 != 0x1
> > would fix log incompat feature mismatch in AG 12 super, 0x0 != 0x1
> > would fix log incompat feature mismatch in AG 24 super, 0x0 != 0x1
> > would fix log incompat feature mismatch in AG 18 super, 0x0 != 0x1
> > <snip>
> > 
> > 0x1 corresponds to XFS_SB_FEAT_INCOMPAT_LOG_XATTRS, which is the feature
> > bit used to indicate that the log contains extended attribute log intent
> > items.  This is a mechanism to prevent older kernels from trying to
> > recover log items that they won't know how to recover.
> > 
> > I thought about this a little bit more, and realized that log_incompat
> > features bits are set on the primary sb prior to writing certain types
> > of log records, and cleared once the log has written the committed
> > changes back to the filesystem.  If the secondary superblocks are
> > updated at any point during that interval (due to things like growfs or
> > setting labels), the log_incompat field will now be set on the secondary
> > supers.
> > 
> > Due to the ephemeral nature of the current log_incompat feature bits,
> > a discrepancy between the primary and secondary supers is not a
> > corruption.  If we're in dry run mode, we should log the discrepancy,
> > but that's not a reason to end with EXIT_FAILURE.
> 
> Interesting. This makes me wonder a few things.
> 
> This approach differs from the just-added handling of 
> XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR, where we /always/ ignore it. For now I think
> that's a little different, because that flag only gets set from userspace, but
> that could change in the future, maybe?

Yes, though I don't have any plans to change that.

> So I wonder why we have this feature getting noted and cleared, but the other
> one always ignored.

NEEDSREPAIR is different from log_incompat -- if it's set on the primary
sb, then mount will reject the filesystem.  I don't think any code ever
makes any decisions based on NEEDSREPAIR bit in the secondary supers.

If xfs_repair recovers the primary sb from a secondary, it will always
clear needsrepair on the primary sb when it's done.  Adding a feature
via xfs_repair causes it to sync the secondary supers, but we're careful
to mask off the NEEDSREPAIR bit first.

I guess right now check_v5_feature_mismatch can accidentally propagate
needsrepair from a primary to a secondary sb.

> I also notice that scrub tries to avoid setting it in the first place:
> 
>          * Don't write out a secondary super with NEEDSREPAIR or log incompat
>          * features set, since both are ignored when set on a secondary.
> 
> ... should growfs avoid it as well?
> 
> It feels like we're spreading this special handling around, copying (or not)
> and ignoring (or not) at various points.  I kinda want to step back and think
> about this a little.
> 
> It seems like the most consistent approach would be to always keep all supers
> in sync, though I suppose that has costs. The 2nd most consistent approach would
> be to never copy these ephemeral features to the secondary.
> 
> Whatever the consistent future looks like, I guess we do have to deal with
> inconsistent stuff in the wild, already.

There aren't any filesystems in the wild with log_incompat bits set, so
we still have time to sort this one out.

I think it might actually be an error that online repair zeroes the
log_incompat bits when resetting the primary superblock, and that we
don't update the secondaries when we set or clear a bit on the primary.

If the system goes down and the primary sb somehow gets wiped, the fs
will be unmountable.  xfs_repair will try to find a secondary, and if it
does, it writes that onto the primary sb.  If the primary had a
log_incompat bit set but the secondary didn't, we've effectively cleared
that bit in the primary super.  If repair then finds that the log is
dirty, it will tell the user to try to mount the fs to recover the log.
If the kernel is too old to handle the log contents (say you're booting
from a Knoppix CD) and those log items would have been protected by that
log_incompat bit in the primary sb, then recovery starts up and will
fail at some point midway through.

Soooo ... I've changed my mind. :P  Now I've convinced myself that the
code that clears and sets the LARP log-incompat bit needs to update the
secondaries and online fsck needs to make log-incompat discrepancies a
real error (and a real fix).  xfs_repair was actually DTRT and this
patch should be ignored.

More thoughts? :D

--D

> 
> Thoughts?
> 
> -Eric
> 
> 
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  repair/agheader.c |   15 ++++++++++++---
> >  1 file changed, 12 insertions(+), 3 deletions(-)
> > 
> > diff --git a/repair/agheader.c b/repair/agheader.c
> > index 2c2a26d1..478ed7e5 100644
> > --- a/repair/agheader.c
> > +++ b/repair/agheader.c
> > @@ -286,15 +286,24 @@ check_v5_feature_mismatch(
> >  		}
> >  	}
> >  
> > +	/*
> > +	 * Log incompat feature bits are set and cleared from the primary super
> > +	 * as needed to protect against log replay on old kernels finding log
> > +	 * records that they cannot handle.  Secondary sb resyncs performed as
> > +	 * part of a geometry update to the primary sb (e.g. growfs, label/uuid
> > +	 * changes) will copy the log incompat feature bits, but it's not a
> > +	 * corruption for a secondary to have a bit set that is clear in the
> > +	 * primary super.
> > +	 */
> >  	if (mp->m_sb.sb_features_log_incompat != sb->sb_features_log_incompat) {
> >  		if (no_modify) {
> > -			do_warn(
> > -	_("would fix log incompat feature mismatch in AG %u super, 0x%x != 0x%x\n"),
> > +			do_log(
> > +	_("would sync log incompat feature in AG %u super, 0x%x != 0x%x\n"),
> >  					agno, mp->m_sb.sb_features_log_incompat,
> >  					sb->sb_features_log_incompat);
> >  		} else {
> >  			do_warn(
> > -	_("will fix log incompat feature mismatch in AG %u super, 0x%x != 0x%x\n"),
> > +	_("will sync log incompat feature in AG %u super, 0x%x != 0x%x\n"),
> >  					agno, mp->m_sb.sb_features_log_incompat,
> >  					sb->sb_features_log_incompat);
> >  			dirty = true;
> > 
> 
