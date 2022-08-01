Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C878BC00144
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Aug 2022 03:46:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238973AbiHADqW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 Jul 2022 23:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbiHADqV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 31 Jul 2022 23:46:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE53B492
        for <linux-xfs@vger.kernel.org>; Sun, 31 Jul 2022 20:46:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E64CB80E88
        for <linux-xfs@vger.kernel.org>; Mon,  1 Aug 2022 03:46:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5234C433D6;
        Mon,  1 Aug 2022 03:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659325577;
        bh=bUokPls7FLkoHdTxqpeQ+aF+Ps+ImVT+9yYSZUo97ac=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ol85mhyps++MByx/nHlf4oHpDM7k7ClzV0DqkC0uKNqMas8P9KU10c8/ezLH05NuQ
         HLZd7HMutSaxF7MiNGT4i7hKu745FRGFPMWn5ogM06FWzJCVDWE0nriVafKy5Ax7Xy
         xZutYbZ54vDBskir3CJlP2Wsr4lhZVb7q6nVf6chHMxIeFCdc07mQYgex+3/m7+uja
         jPG9VtFGPeiefNCok12ePpb15UNsp/3QGePykFjolD1U1g8a1/14FIholoEE1LbK6l
         hm3ccO3uPBlIxlHB5n8b2gEhgkWAQhnsSjYnysU03wLNBc3fOR+qxklNlvWqdMbFNx
         yfbQyMZWH73LA==
Date:   Sun, 31 Jul 2022 20:46:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: check return codes when flushing block devices
Message-ID: <YudMiFAtap6EVRga@magnolia>
References: <YuasRCKeYsKlCgPM@magnolia>
 <20220801000641.GZ3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801000641.GZ3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 01, 2022 at 10:06:41AM +1000, Dave Chinner wrote:
> On Sun, Jul 31, 2022 at 09:22:28AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > If a block device cache flush fails, fsync needs to report that to upper
> > levels.  If the log can't flush the data device, we should shut it down
> > immediately because we've just violated an invariant.  Hence, check the
> > return value of blkdev_issue_flush.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_file.c |   15 ++++++++++-----
> >  fs/xfs/xfs_log.c  |    7 +++++--
> >  2 files changed, 15 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 5a171c0b244b..88450c33ab01 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -163,9 +163,11 @@ xfs_file_fsync(
> >  	 * inode size in case of an extending write.
> >  	 */
> >  	if (XFS_IS_REALTIME_INODE(ip))
> > -		blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev);
> > +		error = blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev);
> >  	else if (mp->m_logdev_targp != mp->m_ddev_targp)
> > -		blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
> > +		error = blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
> > +	if (error)
> > +		return error;
> >  
> >  	/*
> >  	 * Any inode that has dirty modifications in the log is pinned.  The
> > @@ -173,8 +175,11 @@ xfs_file_fsync(
> >  	 * that happen concurrently to the fsync call, but fsync semantics
> >  	 * only require to sync previously completed I/O.
> >  	 */
> > -	if (xfs_ipincount(ip))
> > +	if (xfs_ipincount(ip)) {
> >  		error = xfs_fsync_flush_log(ip, datasync, &log_flushed);
> > +		if (error)
> > +			return error;
> > +	}
> 
> Shouldn't we still try to flush the data device if necessary, even
> if the log flush failed?

Hm.  I can see two points of view here -- if the system is falling down
around us, just stop before we make anything worse.  The other POV is
that we should push as much as we can towards the storage in the hope
a reboot and recovery will fix everything.  And hope that the log flush
doesn't do anything out of order.

So, should xfs_file_fsync return the first error but try all the calls?

> >  	/*
> >  	 * If we only have a single device, and the log force about was
> > @@ -185,9 +190,9 @@ xfs_file_fsync(
> >  	 */
> >  	if (!log_flushed && !XFS_IS_REALTIME_INODE(ip) &&
> >  	    mp->m_logdev_targp == mp->m_ddev_targp)
> > -		blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
> > +		return blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
> >  
> > -	return error;
> > +	return 0;
> >  }
> >  
> >  static int
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 4b1c0a9c6368..8a767f4145f0 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -1926,8 +1926,11 @@ xlog_write_iclog(
> >  		 * by the LSN in this iclog is on stable storage. This is slow,
> >  		 * but it *must* complete before we issue the external log IO.
> >  		 */
> > -		if (log->l_targ != log->l_mp->m_ddev_targp)
> > -			blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev);
> > +		if (log->l_targ != log->l_mp->m_ddev_targp &&
> > +		    blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev)) {
> > +			xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
> > +			return;
> > +		}
> 
> That seems pretty drastic, though I'm not sure what else apart from
> ignoring the data device flush error can be done here. Also, it's
> not actually a log IO error - it's a data device IO error so it's a
> really a metadata writeback problem. Hence the use of
> SHUTDOWN_LOG_IO_ERROR probably needs a comment to explain why it
> needs to be used here...

My first thought was to do that, but my second thought is -- can we do
whatever the AIL does when writes back to the filesystem fail?  I
/think/ it retries writes, correct?  I suppose this could retry the
flush until it succeeds or we hit an impatience threshold.

(Alternately, define a new SHUTDOWN_LOG_* code that will print a
slightly different message, on the grounds that few people have external
log devices anyway.)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
