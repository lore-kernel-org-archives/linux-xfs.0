Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53701 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752475AbdEEIsP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 May 2017 04:48:15 -0400
Date: Fri, 5 May 2017 10:48:13 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] xfs: use uuid_be to implement the uuid_t type
Message-ID: <20170505084813.GA4805@lst.de>
References: <20170505075725.19597-1-hch@lst.de> <20170505075725.19597-3-hch@lst.de> <CAOQ4uxg=wLW9d195W_Ro71iNZEt8jVFyVwXysd-WnuDx7ELKDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxg=wLW9d195W_Ro71iNZEt8jVFyVwXysd-WnuDx7ELKDw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>

On Fri, May 05, 2017 at 11:44:16AM +0300, Amir Goldstein wrote:
> How about moving this typedef to linux/uuid.h.

Yes, I think eventually we want that, but for now I tried to keep
it local to XFS.  uuid.h already is a mess with uuid_be/uuid_le and
struct uuid_v1.

I think I'll need to do a series on that first, but this might
run into conflicts with the work that Andy is doing at the moment.

> It's weird to have a non xfs_ prefixed typedef as it was
> and placing it here is even more weird.

We do have a few typedefs like that, but maybe we should eventually
clean them up.

> Yes, only xfs uses uuid_t right now, but this could mark the intentions
> in a central place, so other code can follow suit (i.e. libnvdimm) and
> start using uuid_t as well.

I think libnvdimm would be guid_t.

> If this is acceptable by Andy, I can re-post my series based on top
> of this one to hoist uuid_t and the rest of the xfs helpers to linux/uuid.h.

Sure.  There actually are very few users of uuid_be at the moment,
so it might be a good opportunity to just kill if off ASAP.

uuid_le might take a little more time if it's really worth it.
