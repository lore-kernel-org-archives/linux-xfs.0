Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFA17C34047
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 13:12:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 806F024656
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 13:12:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gFSDvlVl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgBSNMn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 08:12:43 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52016 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726617AbgBSNMm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 08:12:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582117961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5HSiHEbNTelTXGVtn3Y1T8r/bDKgvsxV5OOkdOLIRHA=;
        b=gFSDvlVl5F1Kb7/vnP+m6gh37E9iXDpnqitBMCYLnwWIwqW6fokT9ADDQOa//EJx9KL3iq
        VwsONQ1QsjYGyp/xydjSox+NcPAxfxOilQblovSNLu67TWf4vFfGavV+EN7kRcoAHqgCYX
        XqoDXbNJexDMEx8o+g+wy8Du34lZYrc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-x1dpGIEGMV60-autv0jp4g-1; Wed, 19 Feb 2020 08:12:35 -0500
X-MC-Unique: x1dpGIEGMV60-autv0jp4g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD9511937FC0;
        Wed, 19 Feb 2020 13:12:34 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D97B5D9E2;
        Wed, 19 Feb 2020 13:12:34 +0000 (UTC)
Date:   Wed, 19 Feb 2020 08:12:32 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: fix iclog release error check race with shutdown
Message-ID: <20200219131232.GA24157@bfoster>
References: <20200218175425.20598-1-bfoster@redhat.com>
 <20200218215243.GS10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218215243.GS10776@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 08:52:43AM +1100, Dave Chinner wrote:
> On Tue, Feb 18, 2020 at 12:54:25PM -0500, Brian Foster wrote:
> > Prior to commit df732b29c8 ("xfs: call xlog_state_release_iclog with
> > l_icloglock held"), xlog_state_release_iclog() always performed a
> > locked check of the iclog error state before proceeding into the
> > sync state processing code. As of this commit, part of
> > xlog_state_release_iclog() was open-coded into
> > xfs_log_release_iclog() and as a result the locked error state check
> > was lost.
> > 
> > The lockless check still exists, but this doesn't account for the
> > possibility of a race with a shutdown being performed by another
> > task causing the iclog state to change while the original task waits
> > on ->l_icloglock. This has reproduced very rarely via generic/475
> > and manifests as an assert failure in __xlog_state_release_iclog()
> > due to an unexpected iclog state.
> > 
> > Restore the locked error state check in xlog_state_release_iclog()
> > to ensure that an iclog state update via shutdown doesn't race with
> > the iclog release state processing code.
> > 
> > Fixes: df732b29c807 ("xfs: call xlog_state_release_iclog with l_icloglock held")
> > Reported-by: Zorro Lang <zlang@redhat.com>
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > v2:
> > - Include Fixes tag.
> > - Use common error path to include shutdown call.
> > v1: https://lore.kernel.org/linux-xfs/20200214181528.24046-1-bfoster@redhat.com/
> > 
> >  fs/xfs/xfs_log.c | 13 +++++++++----
> >  1 file changed, 9 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index f6006d94a581..796ff37d5bb5 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -605,18 +605,23 @@ xfs_log_release_iclog(
> >  	struct xlog		*log = mp->m_log;
> >  	bool			sync;
> >  
> > -	if (iclog->ic_state == XLOG_STATE_IOERROR) {
> > -		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
> > -		return -EIO;
> > -	}
> 
> hmmmm.
> 
> xfs_force_shutdown() will does nothing if the iclog at the head of
> the log->iclog list is marked with XLOG_STATE_IOERROR before IO is
> submitted. In general, that is the case here as the head iclog is
> what xlog_state_get_iclog_space() returns.
> 
> i.e. XLOG_STATE_IOERROR here implies the log has already been shut
> down because the state is IOERROR rather than ACTIVE or WANT_SYNC as
> was set when the iclog was obtained from
> xlog_state_get_iclog_space().
> 

I'm not sure that assumption is always true. If the iclog is (was)
WANT_SYNC, for example, then it's already been switched out from the
head of that list. That might only happen if a checkpoint happens to
align nicely with the end of an iclog, but that's certainly possible. We
also need to consider that ->l_icloglock cycles here and thus somebody
else could switch out the head iclog..

> > +	if (iclog->ic_state == XLOG_STATE_IOERROR)
> > +		goto error;
> >  
> >  	if (atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock)) {
> > +		if (iclog->ic_state == XLOG_STATE_IOERROR) {
> > +			spin_unlock(&log->l_icloglock);
> > +			goto error;
> > +		}
> >  		sync = __xlog_state_release_iclog(log, iclog);
> >  		spin_unlock(&log->l_icloglock);
> >  		if (sync)
> >  			xlog_sync(log, iclog);
> >  	}
> >  	return 0;
> > +error:
> > +	xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
> > +	return -EIO;
> 
> Hence I suspect that this should be ASSERT(XLOG_FORCED_SHUTDOWN(log))
> just like is in xfs_log_force_umount() when this pre-existing log
> IO error condition is tripped over...
> 

I think this change is fundamentally correct based on the simple fact
that we only ever set XLOG_STATE_IOERROR in the shutdown path. That
said, the assert would be potentially racy against the shutdown path
without any ordering guarantee that the release path might see the iclog
state update prior to the log state update and lead to a potentially
false negative assert failure. I suspect this is why the shutdown call
might have been made from here in the first place (and partly why I
didn't bother with it in the restored locked state check).

Given the context of this patch (fixing a regression) and the practical
history of this code (and the annoying process of identifying and
tracking down the source of these kind of shutdown buglets), I'm
inclined to have this patch preserve the historical and relatively
proven behavior as much as possible and consider further cleanups
separately...

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

