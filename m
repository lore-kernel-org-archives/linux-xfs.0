Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:34276 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752869AbcKWAlO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Nov 2016 19:41:14 -0500
Received: by mail-pf0-f169.google.com with SMTP id c4so6598366pfb.1
        for <linux-xfs@vger.kernel.org>; Tue, 22 Nov 2016 16:40:33 -0800 (PST)
Subject: Re: an iomap-based direct I/O implementation V3
References: <1479064054-10474-1-git-send-email-hch@lst.de>
 <20161122225243.GN31101@dastard>
 <fe3fa405-7295-1a86-0e78-85be65d9edba@kernel.dk>
 <20161123000204.GO31101@dastard>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <d0a96b3e-9fb1-9c93-2c0e-6a1d7ec1e98d@kernel.dk>
Date: Tue, 22 Nov 2016 17:40:30 -0700
MIME-Version: 1.0
In-Reply-To: <20161123000204.GO31101@dastard>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On 11/22/2016 05:02 PM, Dave Chinner wrote:
> On Tue, Nov 22, 2016 at 04:12:56PM -0700, Jens Axboe wrote:
>> On 11/22/2016 03:52 PM, Dave Chinner wrote:
>>> On Sun, Nov 13, 2016 at 08:07:29PM +0100, Christoph Hellwig wrote:
>>>> Hi all,
>>>>
>>>> this series adds a new direct I/O implementation based on the iomap
>>>> interface, and switches XFS to use it.
>>>>
>>>> The first two patches are a resend of my earlier series to remove the
>>>> XFS iolock.  They are needed for the lockdep assert in the new iomap
>>>> code.
>>>>
>>>> The rest implements a new iomap_dio_rw direct I/O implementation and
>>>> switches XFS to use it.
>>>>
>>>> Note that this series is on top of a merge of the XFS for-next
>>>> tree with the block tree, which has a new helper needed for this
>>>> implementation.  This is the block tree it's on top of:
>>>>
>>>>    git://git.kernel.dk/linux-block for-4.10/block
>>>
>>> This tree fails compilation for me.
>>>
>>> block/blk-flush.c: In function "flush_data_end_io":
>>> block/blk-flush.c:369:20: error: "REQ_STARTED" undeclared (first use in this function)
>>>  rq->cmd_flags &= ~REQ_STARTED;
>>>                    ^~~~~~~~~~~
>>> block/blk-flush.c:369:20: note: each undeclared identifier is reported only once for each function it appears in
>>>
>>> Should be RQF_STARTED, right?
>>
>> My branch is fine, I'm guessing it's Christophs merge with master that
>> broke things.
>
> No, I merged an hour old for-4.10/block into a pristine 4.9-rc6 tree
> and got this error.

Right, then you also missed it ;-)

>> The blk-flush.c thing doesn't throw a merge conflict, but
>> you still have to resolve it...
>
> I've never seen an unreported merge problem like this before - if
> there are hunks being silently dropped on the floor during a merge,
> then I'd say we have a git bug.... Indeed, there were reported
> conflicts I resolved, but there was nothing that pointed me at the
> above being a merge issue until after I'd committed the merge and
> went to build the result...

It's because for-4.10/block was branched off before a fix that went into
4.9 later on, which added the the clearing of started:

commit 94d7dea448fae6cbb83395323c1d2fd7f19dc388
Author: Ming Lei <tom.leiming@gmail.com>
Date:   Wed Oct 26 16:57:15 2016 +0800

     block: flush: fix IO hang in case of flood fua req

So the fact that it doesn't trigger a merge conflict is fine.

>>>> To make everyones life easie I also have a git tree with the merge
>>>> plus the patches in this series available here:
>>>>
>>>>    git://git.infradead.org/users/hch/vfs.git iomap-dio.3
>>>
>>> Is there a stable topic branch with all the relevant block changes
>>> in it? I'd like to pull this into the XFS tree so I can test it, but
>>> these things need to be pulled from the block tree:
>>>
>>> 	- REQ_IDLE is undefined
>>> 	- bio_iov_iter_get_pages() is undefined
>>> 	- blk_mq_poll() is undefined
>>>
>>> Having these in a stable topic branch (or set of branches) would
>>> make this much easier for me....
>>
>> You can use my for-next, it has the block/fs changes and merged with
>> whatever should conflict with current Linus.
>
> I don't want to pull the entire block tree into the XFS tree, just
> the bare minimum needed to resolve the missing functionality this
> patchset requires. We do this regularly with filesystem trees to
> resolve cross-fs development dependencies....

That's going to be somewhat harder... The REQ_IDLE used to be
REQ_NOIDLE. bio_iov_iter_get_pages() is a single commit, so that's easy
enough. The poll bits are 3-4 patches, so not too bad either.

-- 
Jens Axboe

