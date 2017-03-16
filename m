Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:10276 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751663AbdCPVcd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2017 17:32:33 -0400
Date: Fri, 17 Mar 2017 08:31:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/8] nowait aio: return on congested block device
Message-ID: <20170316213134.GV17542@dastard>
References: <20170315215107.5628-1-rgoldwyn@suse.de>
 <20170315215107.5628-6-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170315215107.5628-6-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Wed, Mar 15, 2017 at 04:51:04PM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> A new flag BIO_NOWAIT is introduced to identify bio's
> orignating from iocb with IOCB_NOWAIT. This flag indicates
> to return immediately if a request cannot be made instead
> of retrying.

So this makes a congested block device run the bio IO completion
callback with an -EAGAIN error present? Are all the filesystem
direct IO submission and completion routines OK with that? i.e. does
such a congestion case cause filesystems to temporarily expose stale
data to unprivileged users when the IO is requeued in this way?

e.g. filesystem does allocation without blocking, submits bio,
device is congested, runs IO completion with error, so nothing
written to allocated blocks, write gets queued, so other read
comes in while the write is queued, reads data from uninitialised
blocks that were allocated during the write....

Seems kinda problematic to me to have a undocumented design
constraint (i.e a landmine) where we submit the AIO only to have it
error out and then expect the filesystem to do something special and
different /without blocking/ on EAGAIN.

Why isn't the congestion check at a higher layer like we do for page
cache readahead? i.e. using the bdi*congested() API at the time we
are doing all the other filesystem blocking checks.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
