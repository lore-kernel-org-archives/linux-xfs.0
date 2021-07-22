Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D8BCC432BE
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 23:10:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C01860EBC
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 23:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbhGVW3q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 18:29:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:33354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232024AbhGVW3q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Jul 2021 18:29:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1330760EB2;
        Thu, 22 Jul 2021 23:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626995420;
        bh=xw+Gvn6JWGiARtZYWYqgpFhkGUW+YGdLxTP433Yo/FI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kXToU4L1qZl1h2zdXAyAsNQ4dlZ/3A56paWJzmu5srpRuLGSZB4jhv5xtlPaPbSn9
         248g1hvFIIOKuLS4IZ/V330trH6Unr/WfQ3tA/OKFmyguclIAQ1oYQxH6V72019VLw
         LXikrScm8IRsfgkzhciAwh4TA02n4l4MR0baNj6x76waqvSNuZTbHVFKVuXh1kcAM2
         1594ByHO9+It3xRB3mIhU3WPziB5Huf4NGQypJAp/TLIw5jHm0jIRXOudzzcaVKSSq
         mrPjWBZ/KrgUwqccMuTAGd+HdQNIhLzXzPmA1qHOd8cW5ZjUP9jDrvG+wgglhStz/j
         DeQJ3RhJ/tDvg==
Date:   Thu, 22 Jul 2021 16:10:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: external logs need to flush data device
Message-ID: <20210722231019.GO559212@magnolia>
References: <20210722015335.3063274-1-david@fromorbit.com>
 <20210722015335.3063274-3-david@fromorbit.com>
 <20210722181445.GA559212@magnolia>
 <20210722214539.GP664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722214539.GP664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 23, 2021 at 07:45:39AM +1000, Dave Chinner wrote:
> On Thu, Jul 22, 2021 at 11:14:45AM -0700, Darrick J. Wong wrote:
> > On Thu, Jul 22, 2021 at 11:53:32AM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > The recent journal flush/FUA changes replaced the flushing of the
> > > data device on every iclog write with an up-front async data device
> > > cache flush. Unfortunately, the assumption of which this was based
> > > on has been proven incorrect by the flush vs log tail update
> > > ordering issue. As the fix for that issue uses the
> > > XLOG_ICL_NEED_FLUSH flag to indicate that data device needs a cache
> > > flush, we now need to (once again) ensure that an iclog write to
> > > external logs that need a cache flush to be issued actually issue a
> > > cache flush to the data device as well as the log device.
> > > 
> > > Fixes: eef983ffeae7 ("xfs: journal IO cache flush reductions")
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/xfs_log.c | 19 +++++++++++--------
> > >  1 file changed, 11 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > > index 96434cc4df6e..a3c4d48195d9 100644
> > > --- a/fs/xfs/xfs_log.c
> > > +++ b/fs/xfs/xfs_log.c
> > > @@ -827,13 +827,6 @@ xlog_write_unmount_record(
> > >  	/* account for space used by record data */
> > >  	ticket->t_curr_res -= sizeof(ulf);
> > >  
> > > -	/*
> > > -	 * For external log devices, we need to flush the data device cache
> > > -	 * first to ensure all metadata writeback is on stable storage before we
> > > -	 * stamp the tail LSN into the unmount record.
> > > -	 */
> > > -	if (log->l_targ != log->l_mp->m_ddev_targp)
> > > -		blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev);
> > >  	return xlog_write(log, &vec, ticket, NULL, NULL, XLOG_UNMOUNT_TRANS);
> > >  }
> > >  
> > > @@ -1796,10 +1789,20 @@ xlog_write_iclog(
> > >  	 * metadata writeback and causing priority inversions.
> > >  	 */
> > >  	iclog->ic_bio.bi_opf = REQ_OP_WRITE | REQ_META | REQ_SYNC | REQ_IDLE;
> > > -	if (iclog->ic_flags & XLOG_ICL_NEED_FLUSH)
> > > +	if (iclog->ic_flags & XLOG_ICL_NEED_FLUSH) {
> > >  		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
> > > +		/*
> > > +		 * For external log devices, we also need to flush the data
> > > +		 * device cache first to ensure all metadata writeback covered
> > > +		 * by the LSN in this iclog is on stable storage. This is slow,
> > > +		 * but it *must* complete before we issue the external log IO.
> > 
> > I'm a little confused about what's going on here.  We're about to write
> > a log record to disk, with h_tail_lsn reflecting the tail of the log and
> > h_lsn reflecting the current head of the log (i.e. this record).
> > 
> > If the log tail has moved forward since the last log record was written
> > and this fs has an external log, we need to flush the data device
> > because the AIL could have written logged items back into the filesystem
> > and we need to ensure those items have been persisted before we write to
> > the log the fact that the tail moved forward.  The AIL itself doesn't
> > issue cache flushes (nor does it need to), so that's why we do that
> > here.
> > 
> > Why don't we need a flush like this if only FUA is set?  Is it not
> > possible to write a checkpoint that fits within a single iclog after the
> > log tail has moved forward?
> 
> Yes, it is, and that is the race condition is exactly what the next
> patch in the series addresses. If the log tail moves after the data
> device cache flush was issued before we started writing the
> checkpoint to the iclogs, then we detect that when releasing the
> commit iclog and set the XLOG_ICL_NEED_FLUSH flag on it. That will
> then trigger this code to issue a data device cache flush....

Aha, yeah, I noticed that after scanning the next few patches.

> IOWs, for external logs, the XLOG_ICL_NEED_FLUSH flag indicates that
> both the data device and the log device need a cache flush, rather
> than just the log device. I think it could be split into two flags,
> but then my head explodes thinking about log forces and trying to
> determine what type of flush is implied (and what flags we'd need to
> set) when we return log_flushed = true....

Maybe later when we're not focussed on recovery failures.

In the meantime, I'm satisfied enough to
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
