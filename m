Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48444 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750885AbdCQMXc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Mar 2017 08:23:32 -0400
Subject: Re: [PATCH 5/8] nowait aio: return on congested block device
References: <20170315215107.5628-1-rgoldwyn@suse.de>
 <20170315215107.5628-6-rgoldwyn@suse.de> <20170316213134.GV17542@dastard>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <045e06ce-ac19-6293-a62b-8ac937f753ac@suse.de>
Date: Fri, 17 Mar 2017 07:23:24 -0500
MIME-Version: 1.0
In-Reply-To: <20170316213134.GV17542@dastard>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org



On 03/16/2017 04:31 PM, Dave Chinner wrote:
> On Wed, Mar 15, 2017 at 04:51:04PM -0500, Goldwyn Rodrigues wrote:
>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>
>> A new flag BIO_NOWAIT is introduced to identify bio's
>> orignating from iocb with IOCB_NOWAIT. This flag indicates
>> to return immediately if a request cannot be made instead
>> of retrying.
> 
> So this makes a congested block device run the bio IO completion
> callback with an -EAGAIN error present? Are all the filesystem
> direct IO submission and completion routines OK with that? i.e. does
> such a congestion case cause filesystems to temporarily expose stale
> data to unprivileged users when the IO is requeued in this way?
> 
> e.g. filesystem does allocation without blocking, submits bio,
> device is congested, runs IO completion with error, so nothing
> written to allocated blocks, write gets queued, so other read
> comes in while the write is queued, reads data from uninitialised
> blocks that were allocated during the write....
> 
> Seems kinda problematic to me to have a undocumented design
> constraint (i.e a landmine) where we submit the AIO only to have it
> error out and then expect the filesystem to do something special and
> different /without blocking/ on EAGAIN.


If the filesystems has to perform block allocation, we would return
-EAGAIN early enough. However, I agree there is a problem, since not all
filesystems know this. I worked on only three of them.

> 
> Why isn't the congestion check at a higher layer like we do for page
> cache readahead? i.e. using the bdi*congested() API at the time we
> are doing all the other filesystem blocking checks.
> 

Yes, that may work better. We will have to call bdi_read_congested() on
a write path. (will have to comment that part of the code). Would it
encompass all possible waits in the block layer?


-- 
Goldwyn
