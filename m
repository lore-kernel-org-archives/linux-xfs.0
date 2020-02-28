Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 670E3C3F2CD
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 13:47:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C68124699
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 13:47:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YqGu6Paz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgB1NrA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 08:47:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32049 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726151AbgB1NrA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 08:47:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582897618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BwEqQAA3Lx65L/ux/vp1leT+T9lygVIoC1MveuHm2pQ=;
        b=YqGu6Pazu5p5cTR39ZWS1IMH5B4ajk0d7buYmZBfoYpxJt+lONYbhCaShjaQchwbRTnYAZ
        pjOfbb0WF0kmHyJG2Mp506MAfo9pWwoQGxy6F5Y0okvmWxGCh2M7qQgEgUunQ2078y2gX9
        4QwZftDEnV17sDFoFgmfCs30XoLNsF4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-E9HGLyUPOQqdeM2JCxhKAw-1; Fri, 28 Feb 2020 08:46:57 -0500
X-MC-Unique: E9HGLyUPOQqdeM2JCxhKAw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3D09800D5C;
        Fri, 28 Feb 2020 13:46:55 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 79A2587B08;
        Fri, 28 Feb 2020 13:46:55 +0000 (UTC)
Date:   Fri, 28 Feb 2020 08:46:53 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [RFC v5 PATCH 1/9] xfs: set t_task at wait time instead of alloc
 time
Message-ID: <20200228134653.GA2751@bfoster>
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-2-bfoster@redhat.com>
 <20200227232853.GP8045@magnolia>
 <20200228001000.GC10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228001000.GC10776@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 28, 2020 at 11:10:00AM +1100, Dave Chinner wrote:
> On Thu, Feb 27, 2020 at 03:28:53PM -0800, Darrick J. Wong wrote:
> > On Thu, Feb 27, 2020 at 08:43:13AM -0500, Brian Foster wrote:
> > > The xlog_ticket structure contains a task reference to support
> > > blocking for available log reservation. This reference is assigned
> > > at ticket allocation time, which assumes that the transaction
> > > allocator will acquire reservation in the same context. This is
> > > normally true, but will not always be the case with automatic
> > > relogging.
> > > 
> > > There is otherwise no fundamental reason log space cannot be
> > > reserved for a ticket from a context different from the allocating
> > > context. Move the task assignment to the log reservation blocking
> > > code where it is used.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/xfs_log.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > > index f6006d94a581..df60942a9804 100644
> > > --- a/fs/xfs/xfs_log.c
> > > +++ b/fs/xfs/xfs_log.c
> > > @@ -262,6 +262,7 @@ xlog_grant_head_wait(
> > >  	int			need_bytes) __releases(&head->lock)
> > >  					    __acquires(&head->lock)
> > >  {
> > > +	tic->t_task = current;
> > >  	list_add_tail(&tic->t_queue, &head->waiters);
> > >  
> > >  	do {
> > > @@ -3601,7 +3602,6 @@ xlog_ticket_alloc(
> > >  	unit_res = xfs_log_calc_unit_res(log->l_mp, unit_bytes);
> > >  
> > >  	atomic_set(&tic->t_ref, 1);
> > > -	tic->t_task		= current;
> > 
> > Hm.  So this leaves t_task set to NULL in the ticket constructor in
> > favor of setting it in xlog_grant_head_wait.  I guess this implies that
> > some future piece will be able to transfer a ticket to another process
> > as part of a regrant or something?
> > 

Pretty much.. it's mostly just breaking the assumption that the task
that allocates a log ticket is necessarily the one that acquires log
reservation (or regrants it). The purpose of this change is so that any
particular task could allocate (and reserve) a relog ticket and donate
it to the relog mechanism (a separate task) for use (i.e. to roll it).

> > I've been wondering lately if you could transfer a dirty permanent
> > transaction to a different task so that the front end could return to
> > userspace as soon as the first transaction (with the intent items)
> > commits, and then you could reduce the latency of front-end system
> > calls.  That's probably a huge fantasy since you'd also have to transfer
> > a whole ton of state to that worker and whatever you locked to do the
> > operation remains locked...
> 
> Yup, that's basically the idea I've raised in the past for "async
> XFS" where the front end is completely detached from the back end
> that does the internal work. i.e deferred ops are the basis for
> turning XFS into a huge async processing machine.
> 

I think we've discussed this in the past, though I'm not clear on
whether it rely on this sort of change. Either way, there's a big
difference in scope between the tweak made by this patch and the design
of a generic async XFS front-end. :)

Brian

> This isn't a new idea - tux3 was based around this "async back end"
> concept, too.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

