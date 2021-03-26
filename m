Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E519C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 18:14:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 420CE61A2A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 18:14:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbhCZSNo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Mar 2021 14:13:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52170 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230043AbhCZSNg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Mar 2021 14:13:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616782415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KQ5fLJJKgGjwortuXmLaqxC/YRHCSbaqLEoU2QKEdHA=;
        b=IwdEp0ygXXeGROJOMG/phCtBgiHJdBpBQgbnd1MTg8MCYlb1BVaY+Tuz9B4HKxlwgnQar1
        e7fUjgPTcLe6qq2SGwSZNGF6tGzgEgT9EeenzlMTdTMRStbkS8QteccYJLOhoe+7orn0tn
        HDfpeHi/JB/Ez8KlGl9s0KTaWSkYirg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-XmNUlsVSO7iq6cuVr0MLSg-1; Fri, 26 Mar 2021 14:13:34 -0400
X-MC-Unique: XmNUlsVSO7iq6cuVr0MLSg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83298881D65;
        Fri, 26 Mar 2021 18:13:24 +0000 (UTC)
Received: from bfoster (ovpn-113-24.rdu2.redhat.com [10.10.113.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C17D919C71;
        Fri, 26 Mar 2021 18:13:23 +0000 (UTC)
Date:   Fri, 26 Mar 2021 14:13:21 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: xfs ioend batching log reservation deadlock
Message-ID: <YF4kQWXqwCgAh4vW@bfoster>
References: <YF4AOto30pC/0FYW@bfoster>
 <20210326173244.GY4090233@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326173244.GY4090233@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 26, 2021 at 10:32:44AM -0700, Darrick J. Wong wrote:
> On Fri, Mar 26, 2021 at 11:39:38AM -0400, Brian Foster wrote:
> > Hi all,
> > 
> > We have a report of a workload that deadlocks on log reservation via
> > iomap_ioend completion batching. To start, the fs format is somewhat
> > unique in that the log is on the smaller side (35MB) and the log stripe
> > unit is 256k, but this is actually a default mkfs for the underlying
> > storage. I don't have much more information wrt to the workload or
> > anything that contributes to the completion processing characteristics.
> > 
> > The overall scenario is that a workqueue task is executing in
> > xfs_end_io() and blocked on transaction reservation for an unwritten
> > extent conversion. Since this task began executing and pulled pending
> > items from ->i_ioend_list, the latter was repopulated with 90 ioends, 67
> > of which have append transactions. These append transactions account for
> > ~520k of log reservation each due to the log stripe unit. All together
> > this consumes nearly all of available log space, prevents allocation of
> > the aforementioned unwritten extent conversion transaction and thus
> > leaves the fs in a deadlocked state.
> > 
> > I can think of different ways we could probably optimize this problem
> > away. One example is to transfer the append transaction to the inode at
> > bio completion time such that we retain only one per pending batch of
> > ioends. The workqueue task would then pull this append transaction from
> > the inode along with the ioend list and transfer it back to the last
> > non-unwritten/shared ioend in the sorted list.
> > 
> > That said, I'm not totally convinced this addresses the fundamental
> > problem of acquiring transaction reservation from a context that
> > essentially already owns outstanding reservation vs. just making it hard
> > to reproduce. I'm wondering if/why we need the append transaction at
> > all. AFAICT it goes back to commit 281627df3eb5 ("xfs: log file size
> > updates at I/O completion time") in v3.4 which changed the completion
> > on-disk size update from being an unlogged update. If we continue to
> > send these potential append ioends to the workqueue for completion
> > processing, is there any reason we can't let the workqueue allocate the
> > transaction as it already does for unwritten conversion?
> 
> Frankly I've never understood what benefit we get from preallocating a
> transaction and letting it twist in the wind consuming log space while
> writeback pushes data to the disk.  It's perfectly fine to delay ioend
> processing while we wait for unwritten conversions and cow remapping to
> take effect, so what's the harm in a slight delay for this?
> 
> I guess it's an optimization to reduce wait times?  It's a pity that
> nobody left a comment justifying why it was done in that particular way,
> what with the freeze protection lockdep weirdness too.
> 

I thought it might have been to facilitate ioend completion in interrupt
(i.e. bio completion) context, but I'm really not sure. That's why I'm
asking. :) I'm hoping Christoph can provide some context since it
appears to be his original implementation.

> > If that is reasonable, I'm thinking of a couple patches:
> > 
> > 1. Optimize current append transaction processing with an inode field as
> > noted above.
> > 
> > 2. Replace the submission side append transaction entirely with a flag
> > or some such on the ioend that allocates the transaction at completion
> > time, but otherwise preserves batching behavior instituted in patch 1.
> 
> What happens if you replace the call to xfs_setfilesize_ioend in
> xfs_end_ioend with xfs_setfilesize, and skip the transaction
> preallocation altogether?
> 

That's pretty much what I'm referring to in step 2 above. I was just
thinking it might make sense to implement some sort of batching model
first to avoid scenarios where we have a bunch of discontiguous append
ioends in the completion list and really only need to update the file
size at the end. (Hence a flag or whatever to indicate the last ioend
must call xfs_setfilesize()).

That said, we do still have contiguous ioend merging happening already.
We could certainly just rely on that, update di_size as we process each
append ioend and worry about further optimization later. That might be
more simple and less code (and a safer first step)..

Brian

> --D
> 
> > Thoughts?
> > 
> > Brian
> > 
> 

