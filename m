Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:12945 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751249AbdEEJm1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 May 2017 05:42:27 -0400
Message-ID: <1493977343.30052.23.camel@linux.intel.com>
Subject: Re: [PATCH 2/3] xfs: use uuid_be to implement the uuid_t type
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Fri, 05 May 2017 12:42:23 +0300
In-Reply-To: <20170505084813.GA4805@lst.de>
References: <20170505075725.19597-1-hch@lst.de>
         <20170505075725.19597-3-hch@lst.de>
         <CAOQ4uxg=wLW9d195W_Ro71iNZEt8jVFyVwXysd-WnuDx7ELKDw@mail.gmail.com>
         <20170505084813.GA4805@lst.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, Amir Goldstein <amir73il@gmail.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>

On Fri, 2017-05-05 at 10:48 +0200, Christoph Hellwig wrote:
> On Fri, May 05, 2017 at 11:44:16AM +0300, Amir Goldstein wrote:
> > How about moving this typedef to linux/uuid.h.
> 
> Yes, I think eventually we want that, but for now I tried to keep
> it local to XFS.  uuid.h already is a mess with uuid_be/uuid_le and
> struct uuid_v1.
> 
> I think I'll need to do a series on that first, but this might
> run into conflicts with the work that Andy is doing at the moment.

Christoph, I can wait a bit and re-do my patch if we settle down data
types and function name space.

I would really get rid of the mess with UUIDs/GUIDs we have in kernel
(but I'm not FS expert, so, I didn't touch that area at all).

> > It's weird to have a non xfs_ prefixed typedef as it was
> > and placing it here is even more weird.
> 
> We do have a few typedefs like that, but maybe we should eventually
> clean them up.
> 
> > Yes, only xfs uses uuid_t right now, but this could mark the
> > intentions
> > in a central place, so other code can follow suit (i.e. libnvdimm)
> > and
> > start using uuid_t as well.
> 
> I think libnvdimm would be guid_t.

Yes.

EFI, ACPI, this one are the users of uuid_le.
AFAIR EFI defines type as efi_guid_t.

> 
> > If this is acceptable by Andy, I can re-post my series based on top
> > of this one to hoist uuid_t and the rest of the xfs helpers to
> > linux/uuid.h.
> 
> Sure.  There actually are very few users of uuid_be at the moment,
> so it might be a good opportunity to just kill if off ASAP.

Agreed.

> uuid_le might take a little more time if it's really worth it.

We may leave the type and helpers, introduce better ones and encourage
new code to use them instead.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
