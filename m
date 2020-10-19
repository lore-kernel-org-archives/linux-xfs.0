Return-Path: <SRS0=Yj0O=D2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D97DBC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 22:21:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89B382237B
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 22:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbgJSWVg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Oct 2020 18:21:36 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:51981 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728291AbgJSWVg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Oct 2020 18:21:36 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id DBD103AAA6E;
        Tue, 20 Oct 2020 09:21:32 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kUdX1-002I12-Pg; Tue, 20 Oct 2020 09:21:31 +1100
Date:   Tue, 20 Oct 2020 09:21:31 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/27] libxfs: add kernel-compatible completion API
Message-ID: <20201019222131.GM7391@dread.disaster.area>
References: <20201015072155.1631135-1-david@fromorbit.com>
 <20201015072155.1631135-11-david@fromorbit.com>
 <20201015170917.GU9832@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015170917.GU9832@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=u0TvasgRxHUb8qEZ4t0A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 15, 2020 at 10:09:17AM -0700, Darrick J. Wong wrote:
> On Thu, Oct 15, 2020 at 06:21:38PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > This is needed for the kernel buffer cache conversion to be able
> > to wait on IO synchrnously. It is implemented with pthread mutexes
> > and conditional variables.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  include/Makefile     |  1 +
> >  include/completion.h | 61 ++++++++++++++++++++++++++++++++++++++++++++
> >  include/libxfs.h     |  1 +
> >  libxfs/libxfs_priv.h |  1 +
> >  4 files changed, 64 insertions(+)
> >  create mode 100644 include/completion.h
> > 
> > diff --git a/include/Makefile b/include/Makefile
> > index f7c40a5ce1a1..98031e70fa0d 100644
> > --- a/include/Makefile
> > +++ b/include/Makefile
> > @@ -12,6 +12,7 @@ LIBHFILES = libxfs.h \
> >  	atomic.h \
> >  	bitops.h \
> >  	cache.h \
> > +	completion.h \
> >  	hlist.h \
> >  	kmem.h \
> >  	list.h \
> > diff --git a/include/completion.h b/include/completion.h
> > new file mode 100644
> > index 000000000000..92194c3f1484
> > --- /dev/null
> > +++ b/include/completion.h
> > @@ -0,0 +1,61 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (c) 2019 RedHat, Inc.
> > + * All Rights Reserved.
> > + */
> > +#ifndef __LIBXFS_COMPLETION_H__
> > +#define __LIBXFS_COMPLETION_H__
> > +
> > +/*
> > + * This implements kernel compatible completion semantics. This is slightly
> > + * different to the way pthread conditional variables work in that completions
> > + * can be signalled before the waiter tries to wait on the variable. In the
> > + * pthread case, the completion is ignored and the waiter goes to sleep, whilst
> > + * the kernel will see that the completion has already been completed and so
> > + * will not block. This is handled through the addition of the the @signalled
> > + * flag in the struct completion.
> 
> Hmm... do any of the existing pthread_cond_t users need these semantics?

No idea. I haven't done an audit, and that's outside the scope of
what I'm doing here...

> I suspect the ones in scrub/vfs.c might actually be vulnerable to the
> signal-before-wait race that this completion structure solves.
> 
> In any case, seeing as this primitive isn't inherent to the xfs disk
> format, maybe these new concurrency management things belong in libfrog?

I've just mirrored all the other kernel wrapper headers by placing
them in include/. I don't see much point in moving these to libfrog,
because they have no actual built object code that needs to be
linked. i.e. they are included globally for everything via
libxfs/libxfs_priv.h and include/libxfs.h, and that's all that is
needed to use these APIs. If they get more complex and require
actual object files to be built, then it's time to reconsider...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
