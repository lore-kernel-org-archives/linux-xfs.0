Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58728 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbeLFU0X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Dec 2018 15:26:23 -0500
Date: Thu, 6 Dec 2018 12:26:14 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: use a dedicated SLAB cache for sector sized
 buffer data
Message-ID: <20181206202614.GQ24487@magnolia>
References: <20181205225147.12626-1-hch@lst.de>
 <20181206181139.GP24487@magnolia>
 <20181206201105.GB31797@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181206201105.GB31797@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, tom.leiming@gmail.com, vkuznets@redhat.com

On Thu, Dec 06, 2018 at 09:11:06PM +0100, Christoph Hellwig wrote:
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

Hmmm.  I guess we could declare three slabs then -- sector size, fsb size,
and dir fsb size?  This is getting kinda spidery now though.  Is three
too weird?

--D
