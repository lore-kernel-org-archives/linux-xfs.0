Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9379DC433DB
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Feb 2021 16:38:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 647AB64EBA
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Feb 2021 16:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbhB1QiI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 Feb 2021 11:38:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49882 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230408AbhB1QiI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Feb 2021 11:38:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614530179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5j7g0D7Cj+PYwoKGvIw1MMt/fthCZ37llPiOHd9LGaU=;
        b=D6vUi4zxcK3Pt3hlZbxAlOoKKmQ9hSQ/Vblv5ivt6xwzkFpuImhNAj4BFyKDHrhnaIqKqS
        jW/GlqOCGRUWphFvCtYHN0+AhI2cdnzeskD5CHUzy0TcDVnoCElGgT27ZI+7oj4ES1HlbF
        hz4NenXnYRHd83TUKvU5QwvqYgHDkfU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-oAc7DNrBPy2-0CE6gqbfow-1; Sun, 28 Feb 2021 11:36:17 -0500
X-MC-Unique: oAc7DNrBPy2-0CE6gqbfow-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A4B03185A0C4;
        Sun, 28 Feb 2021 16:36:15 +0000 (UTC)
Received: from bfoster (ovpn-113-120.rdu2.redhat.com [10.10.113.120])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E1BC5D6D1;
        Sun, 28 Feb 2021 16:36:15 +0000 (UTC)
Date:   Sun, 28 Feb 2021 11:36:13 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: separate CIL commit record IO
Message-ID: <YDvGfUIcEhq9hB5t@bfoster>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-3-david@fromorbit.com>
 <20210224203429.GR7272@magnolia>
 <20210224214417.GB4662@dread.disaster.area>
 <YDdhJ0Oe6R+UXqDU@infradead.org>
 <20210226024828.GN7272@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210226024828.GN7272@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 25, 2021 at 06:48:28PM -0800, Darrick J. Wong wrote:
> On Thu, Feb 25, 2021 at 09:34:47AM +0100, Christoph Hellwig wrote:
> > On Thu, Feb 25, 2021 at 08:44:17AM +1100, Dave Chinner wrote:
> > > > Also, do you have any idea what was Christoph talking about wrt devices
> > > > with no-op flushes the last time this patch was posted?  This change
> > > > seems straightforward to me (assuming the answers to my two question are
> > > > 'yes') but I didn't grok what subtlety he was alluding to...?
> > > 
> > > He was wondering what devices benefited from this. It has no impact
> > > on highspeed devices that do not require flushes/FUA (e.g. high end
> > > intel optane SSDs) but those are not the devices this change is
> > > aimed at. There are no regressions on these high end devices,
> > > either, so they are largely irrelevant to the patch and what it
> > > targets...
> > 
> > I don't think it is that simple.  Pretty much every device aimed at
> > enterprise use does not enable a volatile write cache by default.  That
> > also includes hard drives, arrays and NAND based SSDs.
> > 
> > Especially for hard drives (or slower arrays) the actual I/O wait might
> > matter.  What is the argument against making this conditional?
> 
> I still don't understand what you're asking about here --
> 
> AFAICT the net effect of this patchset is that it reduces the number of
> preflushes and FUA log writes.  To my knowledge, on a high end device
> with no volatile write cache, flushes are a no-op (because all writes
> are persisted somewhere immediately) and a FUA write should be the exact
> same thing as a non-FUA write.  Because XFS will now issue fewer no-op
> persistence commands to the device, there should be no effect at all.
> 

Except the cost of the new iowaits used to implement iclog ordering...
which I think is what Christoph has been asking about..?

IOW, considering the storage configuration noted above where the impact
of the flush/fua optimizations is neutral, the net effect of this change
is whatever impact is introduced by intra-checkpoint iowaits and iclog
ordering. What is that impact?

Note that it's not clear enough to me to suggest whether that impact
might be significant or not. Hopefully it's neutral (?), but that seems
like best case scenario so I do think it's a reasonable question.

Brian

> In contrast, a dumb stone tablet with a write cache hooked up to SATA
> will have agonizingly slow cache flushes.  XFS will issue fewer
> persistence commands to the rock, which in turn makes things faster
> because we're calling the engravers less often.
> 
> What am I missing here?  Are you saying that the cost of a cache flush
> goes up much faster than the amount of data that has to be flushed?
> 
> --D
> 

