Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35470 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934912AbcJYPcB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 11:32:01 -0400
Date: Tue, 25 Oct 2016 07:31:56 -0800
From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH 5/6] iomap: implement direct I/O
Message-ID: <20161025153156.cjhcvvoxd3c6pqf7@kmo-pixel>
References: <1477408098-10153-1-git-send-email-hch@lst.de>
 <1477408098-10153-6-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1477408098-10153-6-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, axboe@fb.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org

On Tue, Oct 25, 2016 at 05:08:17PM +0200, Christoph Hellwig wrote:
> This adds a full fledget direct I/O implementation using the iomap
> interface. Full fledged in this case means all features are supported:
> AIO, vectored I/O, any iov_iter type including kernel pointers, bvecs
> and pipes, support for hole filling and async apending writes.  It does
> not mean supporting all the warts of the old generic code.  We expect
> i_rwsem to be held over the duration of the call, and we expect to
> maintain i_dio_count ourselves, and we pass on any kinds of mapping
> to the file system for now.
> 
> The algorithm used is very simple: We use iomap_apply to iterate over
> the range of the I/O, and then we use the new bio_iov_iter_get_pages
> helper to lock down the user range for the size of the extent.
> bio_iov_iter_get_pages can currently lock down twice as many pages as
> the old direct I/O code did, which means that we will have a better
> batch factor for everything but overwrites of badly fragmented files.

It's definitely simpler :)

So you're still walking the mappings, then for each mapping allocating a bio and
pinning pages - opposite of my approach, I started out by allocating a bio and
pinning pages and then walk the mapping, splitting the bio as needed.

I still like my approach better, I think it ought to perform better when doing
fragmented IOs and it feels cleaner to me - you're not going back and forth
between calling into the gup() code, and your filesystem's btree code, both of
which are going to require taking their own set of locks and such. That said, I
doubt it's much of a difference and your code is so much simpler than
direct-IO.c that who cares :)

Do you have your code up in a git repo somewhere? I'm going to compare it to
bcachefs's dio code and see if I can remember all edge cases I hit when I was
working on that.

bcachefs's dio code, for reference:
https://evilpiepirate.org/git/linux-bcache.git/tree/drivers/md/bcache/fs-io.c?h=bcache-dev#n1268
