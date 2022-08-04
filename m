Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5796FC25B06
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 23:17:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233698AbiHDXRk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 19:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbiHDXRk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 19:17:40 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6E41A814
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 16:17:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9A0B6CE28FB
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 23:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF822C433D6;
        Thu,  4 Aug 2022 23:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659655054;
        bh=wzUCy8M1IygMiozufAEDEyXByDTyIz0WcKu41rP4+7Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u0HEonwH73qo9bQJ8pGnjF2gfDnfWkGgoFMDgg6J5UWVvavb/nHZmX9xiEqr1WhkP
         35VeABvu5RbYOs2mefQFdVqey6RUDe9RzWgCtJQEuG7H1uIMrWhCa1plW3Bptdt//J
         7u7Qad6nQ0smWyqeJmiguW7RMPA+8Fh1oVUfQRBbK751VWKN7FvcibvX+k6cWhI2aL
         7vWyZ9kuXJRS9jUkyLAcrXxnhOe+hupQj8TfMnKZm8hcZFvw5ofKy7Y+nDJXBGG/Er
         l0SoPSTYuuM2gunM2vGLbbR3YvSbOqhmOS47eED2LSCi2OQoJgVTEFreGsDOexsMZM
         9AlQ1pu9Xvmnw==
Date:   Thu, 4 Aug 2022 16:17:34 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: check return codes when flushing block devices
Message-ID: <YuxTjm9vUQ31oOMH@magnolia>
References: <165963638241.1272632.9852314965190809423.stgit@magnolia>
 <165963638822.1272632.5382210082462983546.stgit@magnolia>
 <20220804230438.GE3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220804230438.GE3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 05, 2022 at 09:04:38AM +1000, Dave Chinner wrote:
> On Thu, Aug 04, 2022 at 11:06:28AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > If a blkdev_issue_flush fails, fsync needs to report that to upper
> > levels.  Modify xfs_file_fsync to capture the errors, while trying to
> > flush as much data and log updates to disk as possible.
> > 
> > If log writes cannot flush the data device, we need to shut down the log
> > immediately because we've violated a log invariant.  Modify this code to
> > check the return value of blkdev_issue_flush as well.
> > 
> > This behavior seems to go back to about 2.6.15 or so, which makes this
> > fixes tag a bit misleading.
> > 
> > Link: https://elixir.bootlin.com/linux/v2.6.15/source/fs/xfs/xfs_vnodeops.c#L1187
> > Fixes: b5071ada510a ("xfs: remove xfs_blkdev_issue_flush")
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_file.c |   22 ++++++++++++++--------
> >  fs/xfs/xfs_log.c  |   11 +++++++++--
> >  2 files changed, 23 insertions(+), 10 deletions(-)
> 
> Looks good, couple of minor nits you can take or leave.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 5a171c0b244b..a02000be931b 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -142,7 +142,7 @@ xfs_file_fsync(
> >  {
> >  	struct xfs_inode	*ip = XFS_I(file->f_mapping->host);
> >  	struct xfs_mount	*mp = ip->i_mount;
> > -	int			error = 0;
> > +	int			error, err2;
> >  	int			log_flushed = 0;
> >  
> >  	trace_xfs_file_fsync(ip);
> > @@ -163,18 +163,21 @@ xfs_file_fsync(
> >  	 * inode size in case of an extending write.
> >  	 */
> >  	if (XFS_IS_REALTIME_INODE(ip))
> > -		blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev);
> > +		error = blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev);
> >  	else if (mp->m_logdev_targp != mp->m_ddev_targp)
> > -		blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
> > +		error = blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
> >  
> >  	/*
> >  	 * Any inode that has dirty modifications in the log is pinned.  The
> > -	 * racy check here for a pinned inode while not catch modifications
> > +	 * racy check here for a pinned inode will not catch modifications
> >  	 * that happen concurrently to the fsync call, but fsync semantics
> >  	 * only require to sync previously completed I/O.
> >  	 */
> > -	if (xfs_ipincount(ip))
> > -		error = xfs_fsync_flush_log(ip, datasync, &log_flushed);
> > +	if (xfs_ipincount(ip)) {
> > +		err2 = xfs_fsync_flush_log(ip, datasync, &log_flushed);
> > +		if (!error && err2)
> > +			error = err2;
> 
> This is better done as
> 
> 		if (err2 && !error)
> 			.....
> 
> Because we only care about the value of error if err2 is non zero.
> Hence for normal operation where there are no errors, checking err2
> first is less code to execute as error never needs to be checked...

Ok, fixed.

> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 4b1c0a9c6368..15d7cdc7a632 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -1925,9 +1925,16 @@ xlog_write_iclog(
> >  		 * device cache first to ensure all metadata writeback covered
> >  		 * by the LSN in this iclog is on stable storage. This is slow,
> >  		 * but it *must* complete before we issue the external log IO.
> > +		 *
> > +		 * If the flush fails, we cannot conclude that past metadata
> > +		 * writeback from the log succeeded, which is effectively a
> 
> 		 * writeback from the log succeeded, and repeating
> 		 * the flush from iclog IO is not possible. Hence we have to
> 		 * shut down with log IO error to avoid shutdown
> 		 * re-entering this path and erroring out here again.
> 		 */

I decided to tweak the paragraph a little:

		/*
		 * If the flush fails, we cannot conclude that past metadata
		 * writeback from the log succeeded.  Repeating the flush is
		 * not possible, hence we must shut down with log IO error to
		 * avoid shutdown re-entering this path and erroring out
		 * again.
		 */

Thanks for reviewing! :)

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
