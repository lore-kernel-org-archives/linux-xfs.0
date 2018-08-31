Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:47004 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727268AbeHaQoC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 31 Aug 2018 12:44:02 -0400
Date: Fri, 31 Aug 2018 08:36:40 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH, RFC] xfs: re-enable FIBMAP on reflink; disable for swap
Message-ID: <20180831123639.GA39825@bfoster>
References: <2eb759e5-2faa-67fd-5c16-c1d8edc42d02@redhat.com>
 <20180830162545.GA26816@lst.de>
 <dbe27763-2e69-6e3a-f769-2528eda54940@redhat.com>
 <20180830163614.GA27069@lst.de>
 <65e818f2-885d-50a4-0d4a-7700c703c2af@sandeen.net>
 <20180830180204.GC2853@bfoster>
 <20180830182849.GA4359@magnolia>
 <20180831062813.GA7280@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180831062813.GA7280@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@sandeen.net>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Aug 31, 2018 at 08:28:13AM +0200, Christoph Hellwig wrote:
> On Thu, Aug 30, 2018 at 11:28:49AM -0700, Darrick J. Wong wrote:
> > I prefer to have FIBMAP return errors to *cough* encourage people to use
> > FIEMAP.  If code are going to abuse the FI[BE]MAP interface they could
> > at least abuse the one that gives it enough context to avoid fs
> > corruption.  (A proper fs driver would be preferable, though very
> > difficult).
> 
> I think Carlos was looking into implementing the FIBMAP ioctl
> using ->fiemap.  In that case we could return sensible errors,
> and centralize policy in a single place..
> 

So basically ioctl_fibmap() either prioritizes ->fiemap() or looks for
some special combination of (fiemap && !bmap) to translate the call..

> > Granted, grub's blocklist code doesn't seem to check for shared blocks
> > when it writes grubenv.... yuck, though TBH I don't have the eye budget
> > to spend on digging through grub2.  Frankly I think FIBMAP comes verrry
> > close to "this API is unfixably stupid and shouldn't be enabled for new
> > use cases and should go away some day".
> 
> .. and that policy should be: always return an error for the slightest
> unusual file layout (shared, encrypted, inline, etc).

... and then return some error if the associate extent is in some state
that cannot be described by fibmap..? That sounds like a nice option to
me. Carlos..?

Maybe it's too late for this, but I think even dropping ->bmap
completely for the time being on XFS reflink=1 filesystems is preferable
to the current behavior where we return a perfectly valid result and
pretend that somehow represents an error to userspace.

The arguments for the current behavior essentially apply the "known
fibmap usecase of direct block writes" as justification for implementing
this policy in the kernel. In practice, the current behavior just trades
off one problem (data corruption) for another where the end result is
probably the same for that particular use case: the system doesn't boot.
If we dropped bmap, then at least there's an obvious error and the user
can decide whether to update to fiemap or disable reflink (as opposed to
us having to continue to chase down these odd bootloader issues).

Brian
