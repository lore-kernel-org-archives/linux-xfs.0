Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:60638 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725797AbfEUWYj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 May 2019 18:24:39 -0400
Date: Wed, 22 May 2019 08:24:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 14/17] xfs: use bios directly to read and write the log
 recovery buffers
Message-ID: <20190521222434.GH29573@dread.disaster.area>
References: <20190520161347.3044-1-hch@lst.de>
 <20190520161347.3044-15-hch@lst.de>
 <20190520233233.GF29573@dread.disaster.area>
 <20190521050943.GA29120@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521050943.GA29120@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, May 21, 2019 at 07:09:43AM +0200, Christoph Hellwig wrote:
> On Tue, May 21, 2019 at 09:32:33AM +1000, Dave Chinner wrote:
> > So while it's easy to drop the uncached buffer API from the kernel
> > side, it leaves me with the question of what API do we use in
> > userspace to provide this same functionality? I suspect that we
> > probably need to separate all this log-to-bio code out into a
> > separate file (e.g. xfs_log_io.[ch]) to leave a set of API stubs
> > that we can reimplement in userspace to pread/pwrite directly to
> > the log buftarg device fd as I've done already for the buffer
> > code...
> 
> For one we still keep the uncached buffers in xfs_buf.c as we have users
> of that outside of the log code, but I guess that is not what you mean.
> 
> I can split the log recovery code into a separate file, as you said
> it should just be malloc + pread/pwrite in userspace, so implementing
> it should be trivial.

Yeah, the log recovery code should probably be split in three - the
kernel specific IO code/API, the log parsing code (the bit that
finds head/tail and parses it into transactions for recovery) and
then the bit that actually does the recovery. THe logprint code in
userspace uses the parsing code, so that's the bit we need to share
with userspace...

> The xlog_sync case is pretty different in the
> kernel as it isn't synchonous, and it also doesn't currently exist in
> userspace.  I'd rather keep that as-is unless you have plans to port
> the logging code to userspace?

That's fine, I have no plans to pull the full logging code into
userspace right now.

> Even in that case we'll probably want
> a different abstraction that maps to aio.

I've got a rough AIO implementation backing the xfs_buf.c code in
userspace already. It works just fine and is massively faster than
the existing code on SSDs, so I don't see a problem with porting IO
code that assumes an AIO model anymore. i.e. Re-using the kernel AIO
model for all the buffer code in userspace is one of the reasons I'm
porting xfs-buf.c to userspace.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
