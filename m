Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43854 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727158AbfHEKim (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Aug 2019 06:38:42 -0400
Received: by mail-wr1-f68.google.com with SMTP id p13so9317291wru.10
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 03:38:40 -0700 (PDT)
Date: Mon, 5 Aug 2019 12:38:37 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 8/9] Use FIEMAP for FIBMAP calls
Message-ID: <20190805103835.mcketlhcxyrtko5c@pegasus.maiolino.io>
References: <20190731141245.7230-1-cmaiolino@redhat.com>
 <20190731141245.7230-9-cmaiolino@redhat.com>
 <20190731232254.GW1561054@magnolia>
 <20190802134816.usmauocewduggrjt@pegasus.maiolino.io>
 <20190802152902.GI7138@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802152902.GI7138@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, hch@lst.de, adilger@dilger.ca, jaegeuk@kernel.org, miklos@szeredi.hu, rpeterso@redhat.com, linux-xfs@vger.kernel.org

> > > 
> > > Why doesn't this function just call fiemap_fill_kernel_extent to fill
> > > out the onstack @extent structure?  We've now implemented "fill out out
> > > a struct fiemap_extent" twice.
> > 
> > fiemap_fill_{user, kernel}_extent() have different purposes, and the big
> > difference is one handles a userspace pointer memory and the other don't. IIRC
> > the original proposal was some sort of sharing a single function, but then
> > Christoph suggested a new design, using different functions as callbacks.
> 
> It's harder for me to tell when I don't have a branch containing the
> final product to look at,

Good, I though I was the only one having issues with it :)

You can see the work here:

https://github.com/cmaiolino/linux/commits/FIEMAP_V5

^ This already includes changes addressing your concerns as we discussed int
this thread btw.

> but I'd have thought that _fill_kernel fills
> out an in-kernel fiemap extent; and then _fill_user would declare one on
> the stack, call _fill_kernel to set the fields, and then copy_to_user?

None of those functions will declare a fiemap_extent, the fiemap extent will be
declared before (in ioctl_fiemap() or bmap_fiemap()) calling either function and
then passed to the proper callback via fieinfo.fi_cb_data. This will be a user
or a kernel memory address, and the callbacks will handle the memory accordingly.

Cheers

-- 
Carlos
