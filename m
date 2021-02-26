Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D689C433E9
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Feb 2021 02:49:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37F4964F13
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Feb 2021 02:49:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhBZCtL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 21:49:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:43520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229491AbhBZCtK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Feb 2021 21:49:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FA1D64E60;
        Fri, 26 Feb 2021 02:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614307709;
        bh=NCMAiAOhZGyyyUmhbWEx/1L1b/cxIJ5QxH/BC0rGYWY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kNk3qGbFlp3YOg7jC43Ze0pB2NnCpzYpHDxIIbzioYPFrOLCV51ZJE5oT9knzvgqL
         JfsVFg+S7UnbOaCw/fKM6ye3UXWH6OOpJfb6wTvgg55L/vW40ZVtCS6R+Aeje2JybT
         0Mn8HsAt/6crNFZrgUgu1ts4aGEnFs5WWANupJKSBpakRpdVkRCx3clMecK41og3fX
         IR7ZRCRIcBgP6NxcCKVExD8KTYJrjVDtHVDnI7Nqm4ATDmUscxStz4mkO8KTC76EgX
         UqVkvYrlSqyRT+nAvFY3rZvOKJsUH30zbL0JecbR1gJoTffQlHIcf/WsjF+sffrCJM
         22r3ZrAKecdog==
Date:   Thu, 25 Feb 2021 18:48:28 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: separate CIL commit record IO
Message-ID: <20210226024828.GN7272@magnolia>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-3-david@fromorbit.com>
 <20210224203429.GR7272@magnolia>
 <20210224214417.GB4662@dread.disaster.area>
 <YDdhJ0Oe6R+UXqDU@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDdhJ0Oe6R+UXqDU@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 25, 2021 at 09:34:47AM +0100, Christoph Hellwig wrote:
> On Thu, Feb 25, 2021 at 08:44:17AM +1100, Dave Chinner wrote:
> > > Also, do you have any idea what was Christoph talking about wrt devices
> > > with no-op flushes the last time this patch was posted?  This change
> > > seems straightforward to me (assuming the answers to my two question are
> > > 'yes') but I didn't grok what subtlety he was alluding to...?
> > 
> > He was wondering what devices benefited from this. It has no impact
> > on highspeed devices that do not require flushes/FUA (e.g. high end
> > intel optane SSDs) but those are not the devices this change is
> > aimed at. There are no regressions on these high end devices,
> > either, so they are largely irrelevant to the patch and what it
> > targets...
> 
> I don't think it is that simple.  Pretty much every device aimed at
> enterprise use does not enable a volatile write cache by default.  That
> also includes hard drives, arrays and NAND based SSDs.
> 
> Especially for hard drives (or slower arrays) the actual I/O wait might
> matter.  What is the argument against making this conditional?

I still don't understand what you're asking about here --

AFAICT the net effect of this patchset is that it reduces the number of
preflushes and FUA log writes.  To my knowledge, on a high end device
with no volatile write cache, flushes are a no-op (because all writes
are persisted somewhere immediately) and a FUA write should be the exact
same thing as a non-FUA write.  Because XFS will now issue fewer no-op
persistence commands to the device, there should be no effect at all.

In contrast, a dumb stone tablet with a write cache hooked up to SATA
will have agonizingly slow cache flushes.  XFS will issue fewer
persistence commands to the rock, which in turn makes things faster
because we're calling the engravers less often.

What am I missing here?  Are you saying that the cost of a cache flush
goes up much faster than the amount of data that has to be flushed?

--D
