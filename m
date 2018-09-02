Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:51895 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbeIBSZC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Sep 2018 14:25:02 -0400
Received: by mail-wm0-f65.google.com with SMTP id y2-v6so9127437wma.1
        for <linux-xfs@vger.kernel.org>; Sun, 02 Sep 2018 07:09:01 -0700 (PDT)
Date: Sun, 2 Sep 2018 16:08:58 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH, RFC] xfs: re-enable FIBMAP on reflink; disable for swap
Message-ID: <20180902140858.ssl7dxtnbl7sw2ig@odin.usersys.redhat.com>
References: <2eb759e5-2faa-67fd-5c16-c1d8edc42d02@redhat.com>
 <20180830162545.GA26816@lst.de>
 <dbe27763-2e69-6e3a-f769-2528eda54940@redhat.com>
 <20180830163614.GA27069@lst.de>
 <65e818f2-885d-50a4-0d4a-7700c703c2af@sandeen.net>
 <20180830180204.GC2853@bfoster>
 <20180830182849.GA4359@magnolia>
 <20180831062813.GA7280@lst.de>
 <20180831123639.GA39825@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180831123639.GA39825@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@sandeen.net>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Hi Folks,

On Fri, Aug 31, 2018 at 08:36:40AM -0400, Brian Foster wrote:
> On Fri, Aug 31, 2018 at 08:28:13AM +0200, Christoph Hellwig wrote:
> > On Thu, Aug 30, 2018 at 11:28:49AM -0700, Darrick J. Wong wrote:
> > > I prefer to have FIBMAP return errors to *cough* encourage people to use
> > > FIEMAP.  If code are going to abuse the FI[BE]MAP interface they could
> > > at least abuse the one that gives it enough context to avoid fs
> > > corruption.  (A proper fs driver would be preferable, though very
> > > difficult).
> > 
> > I think Carlos was looking into implementing the FIBMAP ioctl
> > using ->fiemap.  In that case we could return sensible errors,
> > and centralize policy in a single place..
> > 
> 
> So basically ioctl_fibmap() either prioritizes ->fiemap() or looks for
> some special combination of (fiemap && !bmap) to translate the call..
> 
> > > Granted, grub's blocklist code doesn't seem to check for shared blocks
> > > when it writes grubenv.... yuck, though TBH I don't have the eye budget
> > > to spend on digging through grub2.  Frankly I think FIBMAP comes verrry
> > > close to "this API is unfixably stupid and shouldn't be enabled for new
> > > use cases and should go away some day".
> > 
> > .. and that policy should be: always return an error for the slightest
> > unusual file layout (shared, encrypted, inline, etc).
> 
> ... and then return some error if the associate extent is in some state
> that cannot be described by fibmap..? That sounds like a nice option to
> me. Carlos..?
> 

Yes, I've been working on using FIEMAP interface to handle FIBMAP, it was mostly
working, although it needed some extra tweaks due the fact different
filesystems return different blocks inside an extent, when a single block query
is made on FIEMAP.

I mean, if you query for a single block which is in the middle of an extent,
ext4 returns the address of the specific block inside the extent, while xfs
(using iomap fiemap infra), returns the address of the first block in the
extent.
Or something like that, I needed to context switch to some other tasks, but I'll
come back to this during this week, and let you guys know.

Cheers

> Maybe it's too late for this, but I think even dropping ->bmap
> completely for the time being on XFS reflink=1 filesystems is preferable
> to the current behavior where we return a perfectly valid result and
> pretend that somehow represents an error to userspace.
> 
> The arguments for the current behavior essentially apply the "known
> fibmap usecase of direct block writes" as justification for implementing
> this policy in the kernel. In practice, the current behavior just trades
> off one problem (data corruption) for another where the end result is
> probably the same for that particular use case: the system doesn't boot.
> If we dropped bmap, then at least there's an obvious error and the user
> can decide whether to update to fiemap or disable reflink (as opposed to
> us having to continue to chase down these odd bootloader issues).
> 
> Brian

-- 
Carlos
