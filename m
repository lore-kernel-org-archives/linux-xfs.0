Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:56646 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725973AbeIAMjM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 1 Sep 2018 08:39:12 -0400
Date: Sat, 1 Sep 2018 10:31:02 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC] xfs: re-enable FIBMAP on reflink; disable for swap
Message-ID: <20180901083102.GC670@lst.de>
References: <2eb759e5-2faa-67fd-5c16-c1d8edc42d02@redhat.com> <20180830162545.GA26816@lst.de> <dbe27763-2e69-6e3a-f769-2528eda54940@redhat.com> <20180830163614.GA27069@lst.de> <65e818f2-885d-50a4-0d4a-7700c703c2af@sandeen.net> <20180830180204.GC2853@bfoster> <20180830182849.GA4359@magnolia> <20180831062813.GA7280@lst.de> <20180831123639.GA39825@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180831123639.GA39825@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@sandeen.net>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Carlos Maiolino <cmaiolino@redhat.com>

[adding Carlos who was looking into this if I remember correctly]

On Fri, Aug 31, 2018 at 08:36:40AM -0400, Brian Foster wrote:
> So basically ioctl_fibmap() either prioritizes ->fiemap() or looks for
> some special combination of (fiemap && !bmap) to translate the call..

I'd always use fiemap if present, but if there is any good reason
to prefer ->bmap if present that should be ok.  Hopefully we can just
kill of pure ->bmap implementations in the long run..

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

Yes.

> Maybe it's too late for this, but I think even dropping ->bmap
> completely for the time being on XFS reflink=1 filesystems is preferable
> to the current behavior where we return a perfectly valid result and
> pretend that somehow represents an error to userspace.

Note that a 0 return on ->bmap has traditionally been treated as an
error, including in userspace as block 0 is usually not a valid block
for user data.   (this isn't intended as support for this interface,
just stating history)
