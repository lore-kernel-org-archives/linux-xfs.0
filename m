Return-Path: <SRS0=GxFA=6H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E0E4C54FD0
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 14:30:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6140A20857
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 14:30:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HrMEMwtp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgDWOaI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 10:30:08 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57714 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726060AbgDWOaI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 10:30:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587652206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AFJbZHMaO0HdNcdb2/20MJ+Ggj6w130maqmqJeEgJbg=;
        b=HrMEMwtpGLkBddcVyQSXxsS89YVq4ezYGgM+THomWNbACLY1HEAJteztnTWfDlUVN0Ydvn
        Td8N0OE18ipMtFcNXuYe2Ybis0PBszaOEiMh0PiQQgy0VVZ5L150mVSC5gJdfIKjvqanXJ
        Koo6we0WGVM/KHGIgxxO6BteE6+c0FQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-6Xlg21tnMPa9OGnL-VgB_g-1; Thu, 23 Apr 2020 10:30:01 -0400
X-MC-Unique: 6Xlg21tnMPa9OGnL-VgB_g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5714A800FC7;
        Thu, 23 Apr 2020 14:30:00 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F030B5C1BD;
        Thu, 23 Apr 2020 14:29:59 +0000 (UTC)
Date:   Thu, 23 Apr 2020 10:29:58 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 05/13] xfs: ratelimit unmount time per-buffer I/O
 error message
Message-ID: <20200423142958.GB43557@bfoster>
References: <20200422175429.38957-1-bfoster@redhat.com>
 <20200422175429.38957-6-bfoster@redhat.com>
 <20200423044604.GI27860@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423044604.GI27860@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 23, 2020 at 02:46:04PM +1000, Dave Chinner wrote:
> On Wed, Apr 22, 2020 at 01:54:21PM -0400, Brian Foster wrote:
> > At unmount time, XFS emits a warning for every in-core buffer that
> > might have undergone a write error. In practice this behavior is
> > probably reasonable given that the filesystem is likely short lived
> > once I/O errors begin to occur consistently. Under certain test or
> > otherwise expected error conditions, this can spam the logs and slow
> > down the unmount.
> > 
> > We already have a ratelimit state defined for buffers failing
> > writeback. Fold this state into the buftarg and reuse it for the
> > unmount time errors.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> Looks fine, but I suspect we both missed something here:
> xfs_buf_ioerror_alert() was made a ratelimited printk in the last
> cycle:
> 
> void
> xfs_buf_ioerror_alert(
>         struct xfs_buf          *bp,
>         xfs_failaddr_t          func)
> {
>         xfs_alert_ratelimited(bp->b_mount,
> "metadata I/O error in \"%pS\" at daddr 0x%llx len %d error %d",
>                         func, (uint64_t)XFS_BUF_ADDR(bp), bp->b_length,
>                         -bp->b_error);
> }
> 

Yeah, I hadn't noticed that.

> Hence I think all these buffer error alerts can be brought under the
> same rate limiting variable. Something like this in xfs_message.c:
> 

One thing to note is that xfs_alert_ratelimited() ultimately uses
the DEFAULT_RATELIMIT_INTERVAL of 5s. The ratelimit we're generalizing
here uses 30s (both use a burst of 10). That seems reasonable enough to
me for I/O errors so I'm good with the changes below.

FWIW, that also means we could just call xfs_buf_alert_ratelimited()
from xfs_buf_item_push() if we're also Ok with using an "alert" instead
of a "warn." I'm not immediately aware of a reason to use one over the
other (xfs_wait_buftarg() already uses alert) so I'll try that unless I
hear an objection. The xfs_wait_buftarg() ratelimit presumably remains
open coded because it's two separate calls and we probably don't want
them to individually count against the limit.

Brian

> void
> xfs_buf_alert_ratelimited(
>         struct xfs_buf          *bp,
> 	const char		*rlmsg,
> 	const char		*fmt,
> 	...)
> {
> 	struct va_format        vaf;
> 	va_list                 args;
> 
> 	if (!___ratelimit(&bp->b_target->bt_ioerror_rl, rlmsg)
> 		return;
> 
> 	va_start(args, fmt);
> 	vaf.fmt = fmt;
> 	vaf.args = &args;
> 	__xfs_printk(KERN_ALERT, bp->b_mount, &vaf);
> 	va_end(args);
> }
> 
> and:
> 
> void
> xfs_buf_ioerror_alert(
>         struct xfs_buf          *bp,
>         xfs_failaddr_t          func)
> {
> 	xfs_buf_alert_ratelimited(bp, "XFS: metadata IO error",
> 		"metadata I/O error in \"%pS\" at daddr 0x%llx len %d error %d",
> 		func, (uint64_t)XFS_BUF_ADDR(bp), bp->b_length, -bp->b_error);
> }
> 
> 
> > ---
> >  fs/xfs/xfs_buf.c      | 13 +++++++++++--
> >  fs/xfs/xfs_buf.h      |  1 +
> >  fs/xfs/xfs_buf_item.c | 10 +---------
> >  3 files changed, 13 insertions(+), 11 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 7a6bc617f0a9..c28a93d2fd8c 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -1684,10 +1684,12 @@ xfs_wait_buftarg(
> >  			struct xfs_buf *bp;
> >  			bp = list_first_entry(&dispose, struct xfs_buf, b_lru);
> >  			list_del_init(&bp->b_lru);
> > -			if (bp->b_flags & XBF_WRITE_FAIL) {
> > +			if (bp->b_flags & XBF_WRITE_FAIL &&
> > +			    ___ratelimit(&bp->b_target->bt_ioerror_rl,
> > +					 "XFS: Corruption Alert")) {
> >  				xfs_alert(btp->bt_mount,
> >  "Corruption Alert: Buffer at daddr 0x%llx had permanent write failures!",
> > -					(long long)bp->b_bn);
> > +					  (long long)bp->b_bn);
> >  				xfs_alert(btp->bt_mount,
> >  "Please run xfs_repair to determine the extent of the problem.");
> >  			}
> 
> I think if we are tossing away metadata here, we should probably
> shut down the filesystem once the loop has completed. That way we
> get all the normal warnings about running xfs_repair and don't have
> to open code it here...
> 
> > -
> >  STATIC uint
> >  xfs_buf_item_push(
> >  	struct xfs_log_item	*lip,
> > @@ -518,7 +510,7 @@ xfs_buf_item_push(
> >  
> >  	/* has a previous flush failed due to IO errors? */
> >  	if ((bp->b_flags & XBF_WRITE_FAIL) &&
> > -	    ___ratelimit(&xfs_buf_write_fail_rl_state, "XFS: Failing async write")) {
> > +	    ___ratelimit(&bp->b_target->bt_ioerror_rl, "XFS: Failing async write")) {
> >  		xfs_warn(bp->b_mount,
> >  "Failing async write on buffer block 0x%llx. Retrying async write.",
> >  			 (long long)bp->b_bn);
> 
> This gets simplified to:
> 
> 	if (bp->b_flags & XBF_WRITE_FAIL) {
> 		xfs_buf_alert_ratelimited(bp, "XFS: Failing async write",
> "Failing async write on buffer block 0x%llx. Retrying async write.",
> 					(long long)bp->b_bn);
> 	}
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

