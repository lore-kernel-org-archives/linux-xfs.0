Return-Path: <SRS0=eqR3=AR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D74C9C433DF
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jul 2020 16:06:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1E9F20708
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jul 2020 16:06:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZNmyU06g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729386AbgGFQGX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jul 2020 12:06:23 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49903 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729293AbgGFQGX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jul 2020 12:06:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594051581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wNECbWMX1f4PqUdKbzKydt733A4SD9bMqYprlkEZbCs=;
        b=ZNmyU06gnaM5a9Ji9E0QzTPqgaarxy0JuBLVeK4x19m0Cx/4XG5a0lNdDbG8wh5oB5q6Zn
        ayoAOP3gdVmKqOR5da3KZHeCSjx4kggKpJ19AqbFE6LZkji07rJsV8NbddQXHJPJNOUI1T
        FPDgEIG3clHyyeyP13JJBQi+6gU0OJU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-5gSn49WeMcOH5tVs1glOug-1; Mon, 06 Jul 2020 12:06:20 -0400
X-MC-Unique: 5gSn49WeMcOH5tVs1glOug-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F37941005510;
        Mon,  6 Jul 2020 16:06:18 +0000 (UTC)
Received: from bfoster (ovpn-112-122.rdu2.redhat.com [10.10.112.122])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A243A10013D0;
        Mon,  6 Jul 2020 16:06:18 +0000 (UTC)
Date:   Mon, 6 Jul 2020 12:06:16 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/10] xfs: automatic log item relog mechanism
Message-ID: <20200706160616.GB21048@bfoster>
References: <20200701165116.47344-1-bfoster@redhat.com>
 <20200701165116.47344-6-bfoster@redhat.com>
 <20200703060823.GK2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200703060823.GK2005@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 03, 2020 at 04:08:23PM +1000, Dave Chinner wrote:
> On Wed, Jul 01, 2020 at 12:51:11PM -0400, Brian Foster wrote:
> > Now that relog reservation is available and relog state tracking is
> > in place, all that remains to automatically relog items is the relog
> > mechanism itself. An item with relogging enabled is basically pinned
> > from writeback until relog is disabled. Instead of being written
> > back, the item must instead be periodically committed in a new
> > transaction to move it forward in the physical log. The purpose of
> > moving the item is to avoid long term tail pinning and thus avoid
> > log deadlocks for long running operations.
> > 
> > The ideal time to relog an item is in response to tail pushing
> > pressure. This accommodates the current workload at any given time
> > as opposed to a fixed time interval or log reservation heuristic,
> > which risks performance regression. This is essentially the same
> > heuristic that drives metadata writeback. XFS already implements
> > various log tail pushing heuristics that attempt to keep the log
> > progressing on an active fileystem under various workloads.
> > 
> > The act of relogging an item simply requires to add it to a
> > transaction and commit. This pushes the already dirty item into a
> > subsequent log checkpoint and frees up its previous location in the
> > on-disk log. Joining an item to a transaction of course requires
> > locking the item first, which means we have to be aware of
> > type-specific locks and lock ordering wherever the relog takes
> > place.
> > 
> > Fundamentally, this points to xfsaild as the ideal location to
> > process relog enabled items. xfsaild already processes log resident
> > items, is driven by log tail pushing pressure, processes arbitrary
> > log item types through callbacks, and is sensitive to type-specific
> > locking rules by design. The fact that automatic relogging
> > essentially diverts items between writeback or relog also suggests
> > xfsaild as an ideal location to process items one way or the other.
> > 
> > Of course, we don't want xfsaild to process transactions as it is a
> > critical component of the log subsystem for driving metadata
> > writeback and freeing up log space. Therefore, similar to how
> > xfsaild builds up a writeback queue of dirty items and queues writes
> > asynchronously, make xfsaild responsible only for directing pending
> > relog items into an appropriate queue and create an async
> > (workqueue) context for processing the queue. The workqueue context
> > utilizes the pre-reserved log reservation to drain the queue by
> > rolling a permanent transaction.
> > 
> > Update the AIL pushing infrastructure to support a new RELOG item
> > state. If a log item push returns the relog state, queue the item
> > for relog instead of writeback. On completion of a push cycle,
> > schedule the relog task at the same point metadata buffer I/O is
> > submitted. This allows items to be relogged automatically under the
> > same locking rules and pressure heuristics that govern metadata
> > writeback.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> A note while it's still fresh in my mind: memory reclaim is going to
> force relogging of items whether they need it or not. The inode
> shrinker pushes the AIL to it's highest current LSN, which means the
> first shrinker invocation will relog the items. Sustained memory
> pressure will result in this sort of behaviour
> 
...
> 
> So it looks like when there is memory pressure we are going to
> trigger a relog every second AIL push cycle, and a synchronous log
> force every other log cycle.
> 

Indeed. I went back and forth on how to report status of already
relogged items so that bit is somewhat accidental. I could probably
remove the log force increment from the RELOG_QUEUED condition and let
the item fall back to the whatever state is most appropriate since I
didn't have an explicit reason for that other than trying to preserve
behavior from previous versions.

Ultimately even though much of this code is implemented around the AIL,
the AIL fundamentally serves as a notification mechanism to identify
when to relog items. All we really need is some indication that an item
is being pushed due to reservation pressure, whether it be a log item
state bit or a function callout, etc., and much of the rest of the
implementation could be lifted out into a separate mechanism. IOW, if
the push frequency of an item is too crude to drive relogs by itself,
that could probably be addressed by filtering the feedback mechanism to
exclude non head/tail related pressure. For example, the push code could
consider the heuristic implemented in xlog_grant_push_ail() to determine
whether to relog items at the tail, whether to force the log for already
relogged items, or just fall back to a traditional state.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

