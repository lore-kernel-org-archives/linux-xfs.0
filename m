Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0739DC11D04
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 12:41:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4E0024670
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 12:41:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F5G1fVu1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbgBTMly (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 07:41:54 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50477 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726952AbgBTMly (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 07:41:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582202513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2CwqPoFYRYmeP5zlHc9AoqOfuKHIAZROXqwTw9TLbYU=;
        b=F5G1fVu1rKQSRfUxRVBl2QCGLjRush1C4nvRYfiEJSi6Kx5xTcxnqPsOS8VtNArXt595RK
        IdrGT1UvOfvmpihGVinBbkjSlrczMTwa/t3rKmnEuyEh+PJ4z73PBvTXh+NCUKouw3mlGK
        AOQTIsxwtGVDblB214NnmUgd0ciYxKc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-GNopyvREOo6TArw4mpzg5w-1; Thu, 20 Feb 2020 07:41:47 -0500
X-MC-Unique: GNopyvREOo6TArw4mpzg5w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5927818A8C80;
        Thu, 20 Feb 2020 12:41:46 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DB20D8B56B;
        Thu, 20 Feb 2020 12:41:45 +0000 (UTC)
Date:   Thu, 20 Feb 2020 07:41:44 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: fix iclog release error check race with shutdown
Message-ID: <20200220124144.GA48977@bfoster>
References: <20200218175425.20598-1-bfoster@redhat.com>
 <20200218215243.GS10776@dread.disaster.area>
 <20200219131232.GA24157@bfoster>
 <20200219215141.GP9506@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219215141.GP9506@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 01:51:41PM -0800, Darrick J. Wong wrote:
> On Wed, Feb 19, 2020 at 08:12:32AM -0500, Brian Foster wrote:
> > On Wed, Feb 19, 2020 at 08:52:43AM +1100, Dave Chinner wrote:
> > > On Tue, Feb 18, 2020 at 12:54:25PM -0500, Brian Foster wrote:
> > > > Prior to commit df732b29c8 ("xfs: call xlog_state_release_iclog with
> > > > l_icloglock held"), xlog_state_release_iclog() always performed a
> > > > locked check of the iclog error state before proceeding into the
> > > > sync state processing code. As of this commit, part of
> > > > xlog_state_release_iclog() was open-coded into
> > > > xfs_log_release_iclog() and as a result the locked error state check
> > > > was lost.
> > > > 
> > > > The lockless check still exists, but this doesn't account for the
> > > > possibility of a race with a shutdown being performed by another
> > > > task causing the iclog state to change while the original task waits
> > > > on ->l_icloglock. This has reproduced very rarely via generic/475
> > > > and manifests as an assert failure in __xlog_state_release_iclog()
> > > > due to an unexpected iclog state.
> > > > 
> > > > Restore the locked error state check in xlog_state_release_iclog()
> > > > to ensure that an iclog state update via shutdown doesn't race with
> > > > the iclog release state processing code.
> > > > 
> > > > Fixes: df732b29c807 ("xfs: call xlog_state_release_iclog with l_icloglock held")
> > > > Reported-by: Zorro Lang <zlang@redhat.com>
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > ---
> > > > 
> > > > v2:
> > > > - Include Fixes tag.
> > > > - Use common error path to include shutdown call.
> > > > v1: https://lore.kernel.org/linux-xfs/20200214181528.24046-1-bfoster@redhat.com/
> > > > 
> > > >  fs/xfs/xfs_log.c | 13 +++++++++----
> > > >  1 file changed, 9 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > > > index f6006d94a581..796ff37d5bb5 100644
> > > > --- a/fs/xfs/xfs_log.c
> > > > +++ b/fs/xfs/xfs_log.c
> > > > @@ -605,18 +605,23 @@ xfs_log_release_iclog(
> > > >  	struct xlog		*log = mp->m_log;
> > > >  	bool			sync;
> > > >  
> > > > -	if (iclog->ic_state == XLOG_STATE_IOERROR) {
> > > > -		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
> > > > -		return -EIO;
> > > > -	}
> > > 
> > > hmmmm.
> > > 
> > > xfs_force_shutdown() will does nothing if the iclog at the head of
> > > the log->iclog list is marked with XLOG_STATE_IOERROR before IO is
> > > submitted. In general, that is the case here as the head iclog is
> > > what xlog_state_get_iclog_space() returns.
> > > 
> > > i.e. XLOG_STATE_IOERROR here implies the log has already been shut
> > > down because the state is IOERROR rather than ACTIVE or WANT_SYNC as
> > > was set when the iclog was obtained from
> > > xlog_state_get_iclog_space().
> > > 
> > 
> > I'm not sure that assumption is always true. If the iclog is (was)
> > WANT_SYNC, for example, then it's already been switched out from the
> > head of that list. That might only happen if a checkpoint happens to
> > align nicely with the end of an iclog, but that's certainly possible. We
> > also need to consider that ->l_icloglock cycles here and thus somebody
> > else could switch out the head iclog..
> > 
> > > > +	if (iclog->ic_state == XLOG_STATE_IOERROR)
> > > > +		goto error;
> > > >  
> > > >  	if (atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock)) {
> > > > +		if (iclog->ic_state == XLOG_STATE_IOERROR) {
> > > > +			spin_unlock(&log->l_icloglock);
> > > > +			goto error;
> > > > +		}
> > > >  		sync = __xlog_state_release_iclog(log, iclog);
> > > >  		spin_unlock(&log->l_icloglock);
> > > >  		if (sync)
> > > >  			xlog_sync(log, iclog);
> > > >  	}
> > > >  	return 0;
> > > > +error:
> > > > +	xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
> > > > +	return -EIO;
> > > 
> > > Hence I suspect that this should be ASSERT(XLOG_FORCED_SHUTDOWN(log))
> > > just like is in xfs_log_force_umount() when this pre-existing log
> > > IO error condition is tripped over...
> > > 
> > 
> > I think this change is fundamentally correct based on the simple fact
> > that we only ever set XLOG_STATE_IOERROR in the shutdown path. That
> > said, the assert would be potentially racy against the shutdown path
> > without any ordering guarantee that the release path might see the iclog
> > state update prior to the log state update and lead to a potentially
> > false negative assert failure. I suspect this is why the shutdown call
> > might have been made from here in the first place (and partly why I
> > didn't bother with it in the restored locked state check).
> > 
> > Given the context of this patch (fixing a regression) and the practical
> > history of this code (and the annoying process of identifying and
> > tracking down the source of these kind of shutdown buglets), I'm
> > inclined to have this patch preserve the historical and relatively
> > proven behavior as much as possible and consider further cleanups
> > separately...
> 
> That sounds reasonable to me (who has at this point missed most of the
> discussion about this patch).  Is there going to be a v3 of this patch?
> Or has all of the further discussion centered around further cleanups,
> and this one is good to go?
> 

I wasn't planning on a v3. The discussion to this point has been
centered around the xfs_force_shutdown() call in the associated function
(which is orthogonal to the bug). v1 is technically correct, but
Christoph suggested to restore historical behavior wrt to the shutdown
call. v2 does that, but is a bit superfluous in that the iclog error
state with the lock held implies shutdown has already occurred. This is
harmless (unless we're worried about shutdown performance or
something..), but I think Dave indicated he preferred v1 based on that
reasoning.

Functionally I don't think it matters either way and at this point I
have no preference between v1 or v2. They fix the same problem. Do note
that v2 does have the Fixed: tag I missed with v1 (as well as a R-b)...

Brian

> --D
> 
> > Brian
> > 
> > > Cheers,
> > > 
> > > Dave.
> > > -- 
> > > Dave Chinner
> > > david@fromorbit.com
> > > 
> > 
> 

