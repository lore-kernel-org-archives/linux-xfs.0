Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:36671 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754435AbcKDU44 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 16:56:56 -0400
Received: by mail-pf0-f172.google.com with SMTP id 189so57520701pfz.3
        for <linux-xfs@vger.kernel.org>; Fri, 04 Nov 2016 13:56:56 -0700 (PDT)
Date: Fri, 4 Nov 2016 14:56:54 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 4/5] iomap: implement direct I/O
Message-ID: <20161104205654.GB11764@kernel.dk>
References: <1478276479-10749-1-git-send-email-hch@lst.de>
 <1478276479-10749-5-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1478276479-10749-5-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, kent.overstreet@gmail.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org

On Fri, Nov 04 2016, Christoph Hellwig wrote:
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

This looks pretty good, I'll give it a whirl on my fast(er) devices.

One question, since it isn't commented and isn't immediately obvious to
me - what's the purpose of using the cmpxchg() on dio->error?

-- 
Jens Axboe

