Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f170.google.com ([209.85.219.170]:34531 "EHLO
        mail-yb1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbfBANtz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Feb 2019 08:49:55 -0500
MIME-Version: 1.0
References: <CAOQ4uxgqm-m1Zj073o_vSnwkTbGObJiQ-CdWV2ESd_P-29=jZw@mail.gmail.com>
 <20190128125044.GC27972@quack2.suse.cz> <20190128212642.GQ4205@dastard> <20190131211351.GB26359@bombadil.infradead.org>
In-Reply-To: <20190131211351.GB26359@bombadil.infradead.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 1 Feb 2019 15:49:42 +0200
Message-ID: <CAOQ4uxhf+mscvqt9VkpRDpwNJ6-gr_uQm2EMrGFGBDBZkkDbOg@mail.gmail.com>
Subject: Re: [LSF/MM TOPIC] Lazy file reflink
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, lsf-pc@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>

On Thu, Jan 31, 2019 at 11:13 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Tue, Jan 29, 2019 at 08:26:43AM +1100, Dave Chinner wrote:
> > Really, though, for this use case it's make more sense to have "per
> > file freeze" semantics. i.e. if you want a consistent backup image
> > on snapshot capable storage, the process is usually "freeze
> > filesystem, snapshot fs, unfreeze fs, do backup from snapshot,
> > remove snapshot". We can already transparently block incoming
> > writes/modifications on files via the freeze mechanism, so why not
> > just extend that to per-file granularity so writes to the "very
> > large read-mostly file" block while it's being backed up....
> >
> > Indeed, this would probably only require a simple extension to
> > FIFREEZE/FITHAW - the parameter is currently ignored, but as defined
> > by XFS it was a "freeze level". Set this to 0xffffffff and then it
> > freezes just the fd passed in, not the whole filesystem.
> > Alternatively, FI_FREEZE_FILE/FI_THAW_FILE is simple to define...
>
> This sounds like you want a lease (aka oplock), which we already have
> implemented.

Yes, its possibly true.
I think that it could make sense to skip the reflink optimization for files that
are open for write in our workloads. I'll need to check with my peers.

Thanks,
Amir.
