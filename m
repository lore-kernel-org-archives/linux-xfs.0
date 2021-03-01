Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01261C433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Mar 2021 15:36:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5BD064DDE
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Mar 2021 15:36:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237309AbhCAPfd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Mar 2021 10:35:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35169 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237286AbhCAPfV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Mar 2021 10:35:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614612833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uXyxT95pCdk5p5iEgHYIPuTgEDNHspTtuc6ptf+g/l8=;
        b=IDskZYPsB6skWA3eJoERoMfZtF3Ss8UgGasmTe+VVuxJ1PEkU4CP2tv46B8gs4PY+hDCJO
        uyMtVmBtVvyYd8R+5wTlevmUt20VQ+UJtzFx0iBFXHL1+C26CuWJA4ByRqE+WchFSGYrE/
        fvitHaJ9mXHttVKDtkX8CULHKjC2pCY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-BU92hvLcNE2DmEygVZfjPg-1; Mon, 01 Mar 2021 10:33:50 -0500
X-MC-Unique: BU92hvLcNE2DmEygVZfjPg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2397C10CE786;
        Mon,  1 Mar 2021 15:33:49 +0000 (UTC)
Received: from bfoster (ovpn-113-120.rdu2.redhat.com [10.10.113.120])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 92FB460DA1;
        Mon,  1 Mar 2021 15:33:48 +0000 (UTC)
Date:   Mon, 1 Mar 2021 10:33:46 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: separate CIL commit record IO
Message-ID: <YD0JWjMHCOajyLd6@bfoster>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-3-david@fromorbit.com>
 <20210224203429.GR7272@magnolia>
 <20210224214417.GB4662@dread.disaster.area>
 <YDdhJ0Oe6R+UXqDU@infradead.org>
 <20210226024828.GN7272@magnolia>
 <YDvGfUIcEhq9hB5t@bfoster>
 <20210228234642.GC4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210228234642.GC4662@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 01, 2021 at 10:46:42AM +1100, Dave Chinner wrote:
> On Sun, Feb 28, 2021 at 11:36:13AM -0500, Brian Foster wrote:
> > On Thu, Feb 25, 2021 at 06:48:28PM -0800, Darrick J. Wong wrote:
> > > On Thu, Feb 25, 2021 at 09:34:47AM +0100, Christoph Hellwig wrote:
> > > > On Thu, Feb 25, 2021 at 08:44:17AM +1100, Dave Chinner wrote:
> > > > > > Also, do you have any idea what was Christoph talking about wrt devices
> > > > > > with no-op flushes the last time this patch was posted?  This change
> > > > > > seems straightforward to me (assuming the answers to my two question are
> > > > > > 'yes') but I didn't grok what subtlety he was alluding to...?
> > > > > 
> > > > > He was wondering what devices benefited from this. It has no impact
> > > > > on highspeed devices that do not require flushes/FUA (e.g. high end
> > > > > intel optane SSDs) but those are not the devices this change is
> > > > > aimed at. There are no regressions on these high end devices,
> > > > > either, so they are largely irrelevant to the patch and what it
> > > > > targets...
> > > > 
> > > > I don't think it is that simple.  Pretty much every device aimed at
> > > > enterprise use does not enable a volatile write cache by default.  That
> > > > also includes hard drives, arrays and NAND based SSDs.
> > > > 
> > > > Especially for hard drives (or slower arrays) the actual I/O wait might
> > > > matter.  What is the argument against making this conditional?
> > > 
> > > I still don't understand what you're asking about here --
> > > 
> > > AFAICT the net effect of this patchset is that it reduces the number of
> > > preflushes and FUA log writes.  To my knowledge, on a high end device
> > > with no volatile write cache, flushes are a no-op (because all writes
> > > are persisted somewhere immediately) and a FUA write should be the exact
> > > same thing as a non-FUA write.  Because XFS will now issue fewer no-op
> > > persistence commands to the device, there should be no effect at all.
> > > 
> > 
> > Except the cost of the new iowaits used to implement iclog ordering...
> > which I think is what Christoph has been asking about..?
> 
> And I've already answered - it is largely just noise.
> 
> > IOW, considering the storage configuration noted above where the impact
> > of the flush/fua optimizations is neutral, the net effect of this change
> > is whatever impact is introduced by intra-checkpoint iowaits and iclog
> > ordering. What is that impact?
> 
> All I've really noticed is that long tail latencies on operations go
> down a bit. That seems to correlate with spending less time waiting
> for log space when the log is full, but it's a marginal improvement
> at best.
> 
> Otherwise I cannot measure any significant difference in performance
> or behaviour across any of the metrics I monitor during performance
> testing.
> 

Ok.

> > Note that it's not clear enough to me to suggest whether that impact
> > might be significant or not. Hopefully it's neutral (?), but that seems
> > like best case scenario so I do think it's a reasonable question.
> 
> Yes, It's a reasonable question, but I answered it entirely and in
> great detail the first time.  Repeating the same question multiple
> times just with slightly different phrasing does not change the
> answer, nor explain to me what the undocumented concern might be...
> 

Darrick noted he wasn't clear on the question being asked. I rephrased
it to hopefully add some clarity, not change the answer (?).

(FWIW, the response in the previous version of this series didn't
clearly answer the question from my perspective either, so perhaps that
is why you're seeing it repeated by multiple reviewers. Regardless,
Christoph already replied with more detail so I'll just follow along in
that sub-thread..)

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

