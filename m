Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48511 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751707AbdDARVX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Apr 2017 13:21:23 -0400
Date: Sat, 1 Apr 2017 19:21:08 +0200
From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 12/26] xfs: reject all unaligned direct writes to
 reflinked files
Message-ID: <20170401172108.GA10203@kroah.com>
References: <20170401063512.25313-1-hch@lst.de>
 <20170401063512.25313-13-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170401063512.25313-13-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>

On Sat, Apr 01, 2017 at 08:34:58AM +0200, Christoph Hellwig wrote:
> commit 54a4ef8af4e0dc5c983d17fcb9cf5fd25666d94e upstream.
> 
> We currently fall back from direct to buffered writes if we detect a
> remaining shared extent in the iomap_begin callback.  But by the time
> iomap_begin is called for the potentially unaligned end block we might
> have already written most of the data to disk, which we'd now write
> again using buffered I/O.  To avoid this reject all writes to reflinked
> files before starting I/O so that we are guaranteed to only write the
> data once.
> 
> The alternative would be to unshare the unaligned start and/or end block
> before doing the I/O. I think that's doable, and will actually be
> required to support reflinks on DAX file system.  But it will take a
> little more time and I'd rather get rid of the double write ASAP.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Any specific reason you don't want this one in 4.9 as well?

Just curious,

greg k-h
