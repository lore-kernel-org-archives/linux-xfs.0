Return-Path: <SRS0=JvtZ=5L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	TVD_PH_BODY_ACCOUNTS_PRE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C29C0C43331
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Mar 2020 11:08:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97B322073E
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Mar 2020 11:08:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E6MlLpde"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbgCZLIf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Mar 2020 07:08:35 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:29408 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727688AbgCZLIf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Mar 2020 07:08:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585220913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fTd3YBMRRnw7oz01SSnHPbSgxTYevgD/q7LKT3puFA8=;
        b=E6MlLpdelGLwJM6ITRWotSeM4hziy3RJ1O5V21OYTWyyDMfUI6OC3f26AcIXTYMo/27iyr
        QEi6vhxI7lDYbiv8VTrdwNIo7Lfr3TNOEVRlI2tH9Ta38waJ0v/EFtSyQkHy00rqe3Ir6P
        EQ9lhmy322LNS8pT/sUMYGlgRftk2Qw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-80-PBFmpLuzOgeqgkO866YCCA-1; Thu, 26 Mar 2020 07:08:31 -0400
X-MC-Unique: PBFmpLuzOgeqgkO866YCCA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F2D61926DA1;
        Thu, 26 Mar 2020 11:08:30 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 140E59CA3;
        Thu, 26 Mar 2020 11:08:30 +0000 (UTC)
Date:   Thu, 26 Mar 2020 07:08:28 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 1/8] xfs: don't try to write a start record into every
 iclog
Message-ID: <20200326110828.GA19262@bfoster>
References: <20200324174459.770999-1-hch@lst.de>
 <20200324174459.770999-2-hch@lst.de>
 <20200325123314.GC10922@bfoster>
 <20200325232500.GK10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325232500.GK10776@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 26, 2020 at 10:25:00AM +1100, Dave Chinner wrote:
> On Wed, Mar 25, 2020 at 08:33:14AM -0400, Brian Foster wrote:
> > On Tue, Mar 24, 2020 at 06:44:52PM +0100, Christoph Hellwig wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > The xlog_write() function iterates over iclogs until it completes
> > > writing all the log vectors passed in. The ticket tracks whether
> > > a start record has been written or not, so only the first iclog gets
> > > a start record. We only ever pass single use tickets to
> > > xlog_write() so we only ever need to write a start record once per
> > > xlog_write() call.
> > > 
> > > Hence we don't need to store whether we should write a start record
> > > in the ticket as the callers provide all the information we need to
> > > determine if a start record should be written. For the moment, we
> > > have to ensure that we clear the XLOG_TIC_INITED appropriately so
> > > the code in xfs_log_done() still works correctly for committing
> > > transactions.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > [hch: use an need_start_rec bool]
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >  fs/xfs/xfs_log.c | 63 ++++++++++++++++++++++++------------------------
> > >  1 file changed, 32 insertions(+), 31 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > > index 2a90a483c2d6..bf071552094a 100644
> > > --- a/fs/xfs/xfs_log.c
> > > +++ b/fs/xfs/xfs_log.c
> > ...
> > > @@ -2372,25 +2359,29 @@ xlog_write(
> > >  	int			record_cnt = 0;
> > >  	int			data_cnt = 0;
> > >  	int			error = 0;
> > > +	bool			need_start_rec = true;
> > >  
> > >  	*start_lsn = 0;
> > >  
> > > -	len = xlog_write_calc_vec_length(ticket, log_vector);
> > >  
> > >  	/*
> > >  	 * Region headers and bytes are already accounted for.
> > >  	 * We only need to take into account start records and
> > >  	 * split regions in this function.
> > >  	 */
> > > -	if (ticket->t_flags & XLOG_TIC_INITED)
> > > -		ticket->t_curr_res -= sizeof(xlog_op_header_t);
> > > +	if (ticket->t_flags & XLOG_TIC_INITED) {
> > > +		ticket->t_curr_res -= sizeof(struct xlog_op_header);
> > > +		ticket->t_flags &= ~XLOG_TIC_INITED;
> > > +	}
> > >  
> > >  	/*
> > >  	 * Commit record headers need to be accounted for. These
> > >  	 * come in as separate writes so are easy to detect.
> > >  	 */
> > > -	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS))
> > > -		ticket->t_curr_res -= sizeof(xlog_op_header_t);
> > > +	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS)) {
> > > +		ticket->t_curr_res -= sizeof(struct xlog_op_header);
> > > +		need_start_rec = false;
> > > +	}
> > 
> > Hmm.. I was asking for a comment update in v1 for this logic change.
> > Looking through it again, what happens here if
> > xfs_log_write_unmount_record() clears the UNMOUNT_TRANS flag for that
> > summary counter check? That looks like a potential behavior change wrt
> > to the start record..
> 
> xfs_log_write_unmount_record() clears the XLOG_TIC_INITED
> flag before calling xlog_write(), so the current code never writes
> out a start record for the unmount record. i.e. the unmount
> record is a single region with the unmount log item in it, and
> AFAICT this code does not change the behaviour of the unmount record
> write at all.
> 

I'm referring to the UNMOUNT_TRANS flag, not t_flags. With this patch,
we actually would write a start record in some cases because
need_start_rec is toggled based on the flags parameter and the summary
counter check zeroes it.

> FWIW, that error injection code looks dodgy - it turns the unmount
> record into an XFS_LOG transaction type with an invalid log item
> type (0). That probably should be flagged as corruption, not be
> silently ignored by recovery. IOWs, I think the error injection code
> was wrong to begin with - if we want to ensure the log is dirty at
> unmount, we should just skip writing the unmount record altogether.
> 

That may be true... TBH I wasn't totally clear on what that logic was
for (it isn't purely error injection). From the commit (f467cad95f5e3)
log, the intent appears to be to "skip writing the unmount record," but
that doesn't quite describe the behavior. Darrick might want to
comment..? If we do revisit this, I'm mainly curious on whether there's
a change in recovery behavior between having this specially crafted
record vs. just writing nothing. For example, does recovery still set
the head/tail based on this record even though we don't mark the log
clean? If so, do we care..?

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

