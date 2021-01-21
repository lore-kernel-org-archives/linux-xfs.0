Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80FABC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 16:51:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 313C723A3C
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 16:51:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387822AbhAUQuU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Jan 2021 11:50:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:36316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387939AbhAUQuP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Jan 2021 11:50:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7516C23A33;
        Thu, 21 Jan 2021 16:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611247774;
        bh=X4nROZ75f30MW+uojAR3g+0n4YsXa28ligOVBC33oeI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sWBilSRSW0yv4fZaGViAyQvrKgDKGkjPaUcyVntMhtxko79wOPOho4RfOCQ/UHd6a
         UAO3OHdCgLzGm6qnvLGtDGSqQYRXGS9VkEyFsR0wogxtnm59GJb2R9bHEd0fqh6Qiv
         PT8YM3HF3wYtdLnAgIzTcGIeievCiUraPIHdZGCzFLnQlggig42+VA+Xx89FFUMcXc
         V4DyR/xF9rIg8vGlfWst4ytmGGCiGx/uetMNe8EW3llau4tm4P8uxGX7CLp1UYVAZF
         g1hCiZ7oLLqcGjyw9dYuAi7HOsUN+361UaDqGXNNK4oEdyd+aPJFnhbzLXc3IKlz5k
         es7eKNnnw9b4Q==
Date:   Thu, 21 Jan 2021 08:49:33 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Bill O'Donnell <billodo@redhat.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs: sync lazy sb accounting on quiesce of read-only
 mounts
Message-ID: <20210121164933.GA1282159@magnolia>
References: <20210106174127.805660-1-bfoster@redhat.com>
 <20210106174127.805660-2-bfoster@redhat.com>
 <20210121150827.GA1118971@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121150827.GA1118971@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 21, 2021 at 09:08:27AM -0600, Bill O'Donnell wrote:
> On Wed, Jan 06, 2021 at 12:41:19PM -0500, Brian Foster wrote:
> > xfs_log_sbcount() syncs the superblock specifically to accumulate
> > the in-core percpu superblock counters and commit them to disk. This
> > is required to maintain filesystem consistency across quiesce
> > (freeze, read-only mount/remount) or unmount when lazy superblock
> > accounting is enabled because individual transactions do not update
> > the superblock directly.
> > 
> > This mechanism works as expected for writable mounts, but
> > xfs_log_sbcount() skips the update for read-only mounts. Read-only
> > mounts otherwise still allow log recovery and write out an unmount
> > record during log quiesce. If a read-only mount performs log
> > recovery, it can modify the in-core superblock counters and write an
> > unmount record when the filesystem unmounts without ever syncing the
> > in-core counters. This leaves the filesystem with a clean log but in
> > an inconsistent state with regard to lazy sb counters.
> > 
> > Update xfs_log_sbcount() to use the same logic
> > xfs_log_unmount_write() uses to determine when to write an unmount
> > record. We can drop the freeze state check because the update is
> > already allowed during the freezing process and no context calls
> > this function on an already frozen fs. This ensures that lazy
> > accounting is always synced before the log is cleaned. Refactor this
> > logic into a new helper to distinguish between a writable filesystem
> > and a writable log. Specifically, the log is writable unless the
> > filesystem is mounted with the norecovery mount option, the
> > underlying log device is read-only, or the filesystem is shutdown.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > Reviewed-by: Gao Xiang <hsiangkao@redhat.com>
> 
> works for me.
> Reviewed-by: Bill O'Donnell <billodo@redhat.com>

Does this also apply to the v3 series that Brian just sent?

--D

> 
> > ---
> >  fs/xfs/xfs_log.c   | 28 ++++++++++++++++++++--------
> >  fs/xfs/xfs_log.h   |  1 +
> >  fs/xfs/xfs_mount.c |  3 +--
> >  3 files changed, 22 insertions(+), 10 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index fa2d05e65ff1..b445e63cbc3c 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -347,6 +347,25 @@ xlog_tic_add_region(xlog_ticket_t *tic, uint len, uint type)
> >  	tic->t_res_num++;
> >  }
> >  
> > +bool
> > +xfs_log_writable(
> > +	struct xfs_mount	*mp)
> > +{
> > +	/*
> > +	 * Never write to the log on norecovery mounts, if the block device is
> > +	 * read-only, or if the filesystem is shutdown. Read-only mounts still
> > +	 * allow internal writes for log recovery and unmount purposes, so don't
> > +	 * restrict that case here.
> > +	 */
> > +	if (mp->m_flags & XFS_MOUNT_NORECOVERY)
> > +		return false;
> > +	if (xfs_readonly_buftarg(mp->m_log->l_targ))
> > +		return false;
> > +	if (XFS_FORCED_SHUTDOWN(mp))
> > +		return false;
> > +	return true;
> > +}
> > +
> >  /*
> >   * Replenish the byte reservation required by moving the grant write head.
> >   */
> > @@ -886,15 +905,8 @@ xfs_log_unmount_write(
> >  {
> >  	struct xlog		*log = mp->m_log;
> >  
> > -	/*
> > -	 * Don't write out unmount record on norecovery mounts or ro devices.
> > -	 * Or, if we are doing a forced umount (typically because of IO errors).
> > -	 */
> > -	if (mp->m_flags & XFS_MOUNT_NORECOVERY ||
> > -	    xfs_readonly_buftarg(log->l_targ)) {
> > -		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
> > +	if (!xfs_log_writable(mp))
> >  		return;
> > -	}
> >  
> >  	xfs_log_force(mp, XFS_LOG_SYNC);
> >  
> > diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> > index 58c3fcbec94a..98c913da7587 100644
> > --- a/fs/xfs/xfs_log.h
> > +++ b/fs/xfs/xfs_log.h
> > @@ -127,6 +127,7 @@ int	  xfs_log_reserve(struct xfs_mount *mp,
> >  int	  xfs_log_regrant(struct xfs_mount *mp, struct xlog_ticket *tic);
> >  void      xfs_log_unmount(struct xfs_mount *mp);
> >  int	  xfs_log_force_umount(struct xfs_mount *mp, int logerror);
> > +bool	xfs_log_writable(struct xfs_mount *mp);
> >  
> >  struct xlog_ticket *xfs_log_ticket_get(struct xlog_ticket *ticket);
> >  void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index 7110507a2b6b..a62b8a574409 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -1176,8 +1176,7 @@ xfs_fs_writable(
> >  int
> >  xfs_log_sbcount(xfs_mount_t *mp)
> >  {
> > -	/* allow this to proceed during the freeze sequence... */
> > -	if (!xfs_fs_writable(mp, SB_FREEZE_COMPLETE))
> > +	if (!xfs_log_writable(mp))
> >  		return 0;
> >  
> >  	/*
> > -- 
> > 2.26.2
> > 
> 
