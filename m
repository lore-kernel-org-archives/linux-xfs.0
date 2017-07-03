Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37622 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750835AbdGCMLN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Jul 2017 08:11:13 -0400
Date: Mon, 3 Jul 2017 08:11:11 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/4] xfs: fix recovery failure when log record header
 wraps log end
Message-ID: <20170703121108.GA26149@bfoster.bfoster>
References: <1498574436-57561-1-git-send-email-bfoster@redhat.com>
 <1498574436-57561-2-git-send-email-bfoster@redhat.com>
 <20170701043803.GT5874@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170701043803.GT5874@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jun 30, 2017 at 09:38:03PM -0700, Darrick J. Wong wrote:
> On Tue, Jun 27, 2017 at 10:40:33AM -0400, Brian Foster wrote:
> > The high-level log recovery algorithm consists of two loops that
> > walk the physical log and process log records from the tail to the
> > head. The first loop handles the case where the tail is beyond the
> > head and processes records up to the end of the physical log. The
> > subsequent loop processes records from the beginning of the physical
> > log to the head.
> > 
> > Because log records can wrap around the end of the physical log, the
> > first loop mentioned above must handle this case appropriately.
> > Records are processed from in-core buffers, which means that this
> > algorithm must split the reads of such records into two partial
> > I/Os: 1.) from the beginning of the record to the end of the log and
> > 2.) from the beginning of the log to the end of the record. This is
> > further complicated by the fact that the log record header and log
> > record data are read into independent buffers.
> > 
> > The current handling of each buffer correctly splits the reads when
> > either the header or data starts before the end of the log and wraps
> > around the end. The data read does not correctly handle the case
> > where the prior header read wrapped or ends on the physical log end
> > boundary. blk_no is incremented to or beyond the log end after the
> > header read to point to the record data, but the split data read
> > logic triggers, attempts to read from an invalid log block and
> > ultimately causes log recovery to fail. This can be reproduced
> > fairly reliably via xfstests tests generic/047 and generic/388 with
> > large iclog sizes (256k) and small (10M) logs.
> > 
> > If the record header read has pushed beyond the end of the physical
> > log, the subsequent data read is actually contiguous. Update the
> > data read logic to detect the case where blk_no has wrapped, mod it
> > against the log size to read from the correct address and issue one
> > contiguous read for the log data buffer. The log record is processed
> > as normal from the buffer(s), the loop exits after the current
> > iteration and the subsequent loop picks up with the first new record
> > after the start of the log.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_log_recover.c | 18 ++++++++++++++----
> >  1 file changed, 14 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index b6a40bd..9efcd12 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -5371,10 +5371,20 @@ xlog_do_recovery_pass(
> >  			bblks = (int)BTOBB(be32_to_cpu(rhead->h_len));
> >  			blk_no += hblks;
> >  
> > -			/* Read in data for log record */
> > -			if (blk_no + bblks <= log->l_logBBsize) {
> > -				error = xlog_bread(log, blk_no, bblks, dbp,
> > -						   &offset);
> > +			/*
> > +			 * Read the log record data in multiple reads if it
> > +			 * wraps around the end of the log. Note that if the
> > +			 * header already wrapped, blk_no could point past the
> > +			 * end of the log. The record data is contiguous in
> > +			 * that case.
> > +			 */
> > +			if (blk_no + bblks <= log->l_logBBsize ||
> > +			    blk_no >= log->l_logBBsize) {
> > +				/* mod blk_no in case the header wrapped and
> > +				 * pushed it beyond the end of the log */
> > +				error = xlog_bread(log,
> > +						   blk_no % log->l_logBBsize,
> 
> I /think/ this is ok, though isn't this 64-bit division?  ^
> 

Yep, looks like it. Will fix.. thanks for catching that..

Brian

> --D
> 
> > +						   bblks, dbp, &offset);
> >  				if (error)
> >  					goto bread_err2;
> >  			} else {
> > -- 
> > 2.7.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
