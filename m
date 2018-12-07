Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:32890 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbeLGKOS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Dec 2018 05:14:18 -0500
Received: by mail-wm1-f67.google.com with SMTP id r24so979131wmh.0
        for <linux-xfs@vger.kernel.org>; Fri, 07 Dec 2018 02:14:18 -0800 (PST)
MIME-Version: 1.0
References: <20181205225147.12626-1-hch@lst.de> <20181206181139.GP24487@magnolia>
 <20181206201105.GB31797@lst.de>
In-Reply-To: <20181206201105.GB31797@lst.de>
From: Ming Lei <tom.leiming@gmail.com>
Date: Fri, 7 Dec 2018 18:14:04 +0800
Message-ID: <CACVXFVNGhK8tbayej4+aC8WcVFzweb2PsOm2m9BWpoYTxS6U_g@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: use a dedicated SLAB cache for sector sized
 buffer data
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: darrick.wong@oracle.com, "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>, Vitaly Kuznetsov <vkuznets@redhat.com>

On Fri, Dec 7, 2018 at 4:11 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Thu, Dec 06, 2018 at 10:11:39AM -0800, Darrick J. Wong wrote:
> > I think this has the same problem that Dave complained about back in
> > October -- if I have a hard disk with 512b sectors, a xfs with 4k
> > blocks, and mount it on a machine with 64k pages, then single-sector
> > buffers will get a small slab allocation, but single-fsb buffers will
> > now fall back to grabbing a 64k page to hold 4k worth of data.
> >
> > Even if we add a second slab for single-fsb blocks, we'll run into the
> > same problem if the filesystem contains multi-block directory blocks, so
> > then we'd potentially need a third slab, and... is there a way to ask a
> > slab allocator for multiple contiguous objects totalling less than
> > PAGE_SIZE bytes?
>
> No, unfortunately there is not.  And the sad part is that generally it
> will give you aligned ones, just with slub debugging turned on it won't.

page_frag_alloc() can support that, could we fix it for this use case?

thanks,
Ming Lei
