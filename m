Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:37299 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725819AbfEVFMg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 May 2019 01:12:36 -0400
Date: Wed, 22 May 2019 07:12:14 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/17] xfs: use bios directly to read and write the log
 recovery buffers
Message-ID: <20190522051214.GA19467@lst.de>
References: <20190520161347.3044-1-hch@lst.de> <20190520161347.3044-15-hch@lst.de> <20190520233233.GF29573@dread.disaster.area> <20190521050943.GA29120@lst.de> <20190521222434.GH29573@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521222434.GH29573@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, May 22, 2019 at 08:24:34AM +1000, Dave Chinner wrote:
> Yeah, the log recovery code should probably be split in three - the
> kernel specific IO code/API, the log parsing code (the bit that
> finds head/tail and parses it into transactions for recovery) and
> then the bit that actually does the recovery. THe logprint code in
> userspace uses the parsing code, so that's the bit we need to share
> with userspace...

Actually one thing I have on my TODO list is to move the log item type
specific recovery code first into an ops vector, and then out to the
xfs_*_item.c together with the code creating those items.  That isn't
really all of the recovery code, but it seems like a useful split.

Note that the I/O code isn't really very log specific, it basically
just is trivial I/O to a vmalloc buffer code.  In fact I wonder if
I could just generalize it a little more and move it to the block layer.

> I've got a rough AIO implementation backing the xfs_buf.c code in
> userspace already. It works just fine and is massively faster than
> the existing code on SSDs, so I don't see a problem with porting IO
> code that assumes an AIO model anymore. i.e. Re-using the kernel AIO
> model for all the buffer code in userspace is one of the reasons I'm
> porting xfs-buf.c to userspace.

Given that we:

 a) do direct I/O everywhere
 b) tend to do it on either a block device, or a file where we don't
    need to allocate over holes

aio should be a win everywhere.  The only caveat is that CONFG_AIO
is kernel option and could be turned off in some low end configs.
