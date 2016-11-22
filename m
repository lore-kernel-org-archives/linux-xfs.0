Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:33160 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751968AbcKVXNn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Nov 2016 18:13:43 -0500
Received: by mail-io0-f172.google.com with SMTP id j65so87550807iof.0
        for <linux-xfs@vger.kernel.org>; Tue, 22 Nov 2016 15:12:58 -0800 (PST)
Subject: Re: an iomap-based direct I/O implementation V3
References: <1479064054-10474-1-git-send-email-hch@lst.de>
 <20161122225243.GN31101@dastard>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <fe3fa405-7295-1a86-0e78-85be65d9edba@kernel.dk>
Date: Tue, 22 Nov 2016 16:12:56 -0700
MIME-Version: 1.0
In-Reply-To: <20161122225243.GN31101@dastard>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On 11/22/2016 03:52 PM, Dave Chinner wrote:
> On Sun, Nov 13, 2016 at 08:07:29PM +0100, Christoph Hellwig wrote:
>> Hi all,
>>
>> this series adds a new direct I/O implementation based on the iomap
>> interface, and switches XFS to use it.
>>
>> The first two patches are a resend of my earlier series to remove the
>> XFS iolock.  They are needed for the lockdep assert in the new iomap
>> code.
>>
>> The rest implements a new iomap_dio_rw direct I/O implementation and
>> switches XFS to use it.
>>
>> Note that this series is on top of a merge of the XFS for-next
>> tree with the block tree, which has a new helper needed for this
>> implementation.  This is the block tree it's on top of:
>>
>>     git://git.kernel.dk/linux-block for-4.10/block
>
> This tree fails compilation for me.
>
> block/blk-flush.c: In function "flush_data_end_io":
> block/blk-flush.c:369:20: error: "REQ_STARTED" undeclared (first use in this function)
>   rq->cmd_flags &= ~REQ_STARTED;
>                     ^~~~~~~~~~~
> block/blk-flush.c:369:20: note: each undeclared identifier is reported only once for each function it appears in
>
> Should be RQF_STARTED, right?

My branch is fine, I'm guessing it's Christophs merge with master that
broke things. The blk-flush.c thing doesn't throw a merge conflict, but
you still have to resolve it...

>> To make everyones life easie I also have a git tree with the merge
>> plus the patches in this series available here:
>>
>>     git://git.infradead.org/users/hch/vfs.git iomap-dio.3
>
> Is there a stable topic branch with all the relevant block changes
> in it? I'd like to pull this into the XFS tree so I can test it, but
> these things need to be pulled from the block tree:
>
> 	- REQ_IDLE is undefined
> 	- bio_iov_iter_get_pages() is undefined
> 	- blk_mq_poll() is undefined
>
> Having these in a stable topic branch (or set of branches) would
> make this much easier for me....

You can use my for-next, it has the block/fs changes and merged with
whatever should conflict with current Linus.

-- 
Jens Axboe

