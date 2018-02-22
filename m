Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:45818 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751345AbeBVX6A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Feb 2018 18:58:00 -0500
Date: Fri, 23 Feb 2018 10:57:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] misc: enable retpolines across all xfsprogs utilities
Message-ID: <20180222235758.GI7000@dastard>
References: <20180222021625.GA9827@magnolia>
 <20180222150922.GA26282@infradead.org>
 <4d78832f-4148-d0d9-e2f2-ee8e02a44e97@redhat.com>
 <20180222171529.GC9827@magnolia>
 <20180222211024.GA26034@citd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180222211024.GA26034@citd.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthias Schniedermeyer <ms@citd.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>

On Thu, Feb 22, 2018 at 10:10:24PM +0100, Matthias Schniedermeyer wrote:
> On 22.02.2018 09:15, Darrick J. Wong wrote:
> > They're a smaller target than the kernel, for sure, but the scary part
> > about spectre is that unprivileged programs running on the same core as
> > a privileged xfs_repair can then use branch predictor poisoning to cause
> > problems with the xfs_repair.
> 
> Spectre & Meltdown are information disclosure vulnerabilities IOW "Read 
> Only".
> The other process CAN NOT interfere with xfs_repair.

Yup, that's enough to leak private information. e.g. encryption keys
stored in extended attributes...

> I would speculate that the most it can get, is information about parts 
> of the filesystem that are inaccsessible to an unprivileged process by 
> spying on xfs_repair.
> I don't know how xfs_repair works, especially how xfs_repair handles 
> storing data in memory. But for xfs_repair to be a good target, it 
> would have to store relevant data in a deterministic fashion and for 
> some length of time. At least enough to justify writing an extraction 
> program for it.

Oh, yeah, we've got this whopping great big buffer cache that can
cache all the metadata it reads from disk in memory while repair
does it's validation work. It's a pretty big target from that
perspective. That's made even worse if you consider a large
filesystem that takes days for xfs_repair to completely check....

> I would say the 'good old' xfs_repair case isn't really a good target, 
> but the online-scrubbing-case sure sounds to be a different beast.

Scrubbing is done in the kernel, with metadata cached in kernel
memory, so it's already protected by whatever kernel mitigations are
in place.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
