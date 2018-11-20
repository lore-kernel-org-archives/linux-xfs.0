Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54858 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbeKTSQa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Nov 2018 13:16:30 -0500
Date: Mon, 19 Nov 2018 23:48:32 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] iomap: FUA is wrong for DIO O_DSYNC writes into
 unwritten extents
Message-ID: <20181120074832.GA25418@infradead.org>
References: <20181119211742.8824-1-david@fromorbit.com>
 <20181119211742.8824-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181119211742.8824-2-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Nov 20, 2018 at 08:17:38AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we write into an unwritten extent via direct IO, we dirty
> metadata on IO completion to convert the unwritten extent to
> written. However, when we do the FUA optimisation checks, the inode
> may be clean and so we issue a FUA write into the unwritten extent.
> This means we then bypass the generic_write_sync() call after
> unwritten extent conversion has ben done and we don't force the
> modified metadata to stable storage.
> 
> This violates O_DSYNC semantics. The window of exposure is a single
> IO, as the next DIO write will see the inode has dirty metadata and
> hence will not use the FUA optimisation. Calling
> generic_write_sync() after completion of the second IO will also
> sync the first write and it's metadata.
> 
> Fix this by avoiding the FUA optimisation when writing to unwritten
> extents.

Ouch, yes.  We can't skip the log force when converting unwritten
extent.  If we really cared we could try to use FUA and only do
the log force vs needing a full device flush, but that would require
a fair amount of of work.

So this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
