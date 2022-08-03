Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70D67C19F28
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Aug 2022 04:33:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbiHCEdL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Aug 2022 00:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiHCEdL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Aug 2022 00:33:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C3057203
        for <linux-xfs@vger.kernel.org>; Tue,  2 Aug 2022 21:33:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23513B82121
        for <linux-xfs@vger.kernel.org>; Wed,  3 Aug 2022 04:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51C2C433D6;
        Wed,  3 Aug 2022 04:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659501187;
        bh=PE0V4gRFofnaC419A2sHi2m/eTmoFNajRAeOaVIGTcM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fjVEEe6o5YpvqI44N+fjptC2I89z1h/+1Qg8bmSshO8QSPCP5ENWHJgdaZ6YuWXDe
         jyhCFkWvqupKmVRoaEfQwNGK5qP1AUL7bt56OgsRA3MpMatszO/uxX8uQ8EOcV71Ga
         1R/cIQ0lDZODmpHgI6Q+ulHZRXJNH022TEOqBn5fxXfofZO493SmsXJYbrULdomiBQ
         W2w5EYOSmVspqmxxY1QgTJaRv7FrjT4pQKBVG6qTDf3NCseav+4PJFMaCmXeUPy74j
         tsrTpdRHsKydvoN2R2O+CVi7Xc4ZX1xACDBZLgKTJK91CdpA29kRa3u+nelGVdQrO7
         DF1jBeLxTw03Q==
Date:   Tue, 2 Aug 2022 21:33:07 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: check return codes when flushing block devices
Message-ID: <Yun6gwcI1hC1ARBH@magnolia>
References: <YuasRCKeYsKlCgPM@magnolia>
 <20220801000641.GZ3600936@dread.disaster.area>
 <YugMS4G9p+JduBmq@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YugMS4G9p+JduBmq@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 01, 2022 at 10:24:27AM -0700, Christoph Hellwig wrote:
> On Mon, Aug 01, 2022 at 10:06:41AM +1000, Dave Chinner wrote:
> > > @@ -173,8 +175,11 @@ xfs_file_fsync(
> > >  	 * that happen concurrently to the fsync call, but fsync semantics
> > >  	 * only require to sync previously completed I/O.
> > >  	 */
> > > -	if (xfs_ipincount(ip))
> > > +	if (xfs_ipincount(ip)) {
> > >  		error = xfs_fsync_flush_log(ip, datasync, &log_flushed);
> > > +		if (error)
> > > +			return error;
> > > +	}
> > 
> > Shouldn't we still try to flush the data device if necessary, even
> > if the log flush failed?
> 
> xfs_fsync_flush_log ails only if the log it shut down.  Does it really
> make sense to flush the data cache for a pure overwrite of a data
> block when the fs is toast?  I can't really see any benefit in that.

/me guesses that once we hit the first error, the rest of the calls will
probably crash and burn, and if they don't, the next fs call will, so it
likely doesn't matter if we keep going or not.

> > > +		if (log->l_targ != log->l_mp->m_ddev_targp &&
> > > +		    blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev)) {
> > > +			xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
> > > +			return;
> > > +		}
> > 
> > That seems pretty drastic, though I'm not sure what else apart from
> > ignoring the data device flush error can be done here. Also, it's
> > not actually a log IO error - it's a data device IO error so it's a
> > really a metadata writeback problem. Hence the use of
> > SHUTDOWN_LOG_IO_ERROR probably needs a comment to explain why it
> > needs to be used here...
> 
> Yes, the comment would be useful.  But if a cache flush fails data
> integrity of the device must at this point be considered as fucked
> up beyond belief, so shutting down the log and thus the file system
> is the right thing to do.
> 
> So modulo a comment here the patch looks good to me.

Ok, will do.

--D
