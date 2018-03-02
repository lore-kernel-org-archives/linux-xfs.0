Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38513 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932477AbeCBXVr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Mar 2018 18:21:47 -0500
Date: Sat, 3 Mar 2018 00:21:46 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] [RFC] iomap: Use FUA for pure data O_DSYNC DIO writes
Message-ID: <20180302232146.GA31754@lst.de>
References: <20180301014144.28892-1-david@fromorbit.com> <20180302222031.GA30818@lst.de> <20180302225319.GW30854@dastard> <20180302230042.GA31370@lst.de> <20180302231517.GY30854@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180302231517.GY30854@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Sat, Mar 03, 2018 at 10:15:17AM +1100, Dave Chinner wrote:
> On Sat, Mar 03, 2018 at 12:00:42AM +0100, Christoph Hellwig wrote:
> > Oh, and another thing:  I think you want to make this new code dependent
> > on the block devie actually supporting REQ_FUA natively.  Otherwise
> > you'll cause a flush for every emulated FUA write, which is only going
> > make things worse, especially for ATA where FLUSH is not queued.  And
> > last time I check libata still disabled FUA by default.
> 
> Yup, but the issue we have right now is that for pure RWF_DSYNC data
> overwrites we are already doing a post-flush on every IO. It's being
> issued as a separate zero-length IO, which is why REQ_FUA is faster
> and results in lower overall IOPS.  The flush comes from this path:

That is only the case if your device actually supports FUA.  If the
device does notit is emulated by the block/flk-flush.c code by issuing a
FLUSH once the write has returned.

So for e.g. a direct I/O write() call with O_DSYNC that turns into
e.g. four write calls on the wire you currently have:

   WRITE
   WRITE
   WRITE
   WRITE
   FLUSH

with your patch and a device that supports FUA you get

   WRITE (FUA)
   WRITE (FUA)
   WRITE (FUA)
   WRITE (FUA)

but with a device that does not support FUA you get

   WRITE
   FLUSH
   WRITE
   FLUSH
   WRITE
   FLUSH
   WRITE
   FLUSH

with the additional pain point that on ATA FLUSH is not a queueable
command, so it will have to wait for the completion of every other
non-related command first, and no other command can be started.

So we should absolutely use your new approach IFF the device actually
supports FUA (aka QUEUE_FLAG_FUA is set), but it will not help much
or even be harmful if the device does not actually support the FUA bit.
