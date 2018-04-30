Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:35432
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751304AbeD3VbX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Apr 2018 17:31:23 -0400
Date: Tue, 1 May 2018 07:31:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: add 'discard_sync' mount flag
Message-ID: <20180430213120.GD13766@dastard>
References: <1525102372-8430-1-git-send-email-axboe@kernel.dk>
 <1525102372-8430-3-git-send-email-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1525102372-8430-3-git-send-email-axboe@kernel.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-xfs@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de

On Mon, Apr 30, 2018 at 09:32:52AM -0600, Jens Axboe wrote:
> XFS recently added support for async discards. While this can be
> a win for some workloads and devices, there are also cases where
> async bursty discard will severly harm the latencies of reads
> and writes.

FWIW, convention is it document the performance regression in the
commit message, not leave the reader to guess at what it was....

Did anyone analyse the pattern of discards being issued to work out
what pattern was worse for async vs sync discard? is it lots of
little discards, large extents being discarded, perhaps a problem
with the request request queue starving other IOs because we queue
so many async discards in such a short time (which is the difference
in behaviour vs the old code), or something else?

> Add a 'discard_sync' mount flag to revert to using sync discard,
> issuing them one at the time and waiting for each one. This fixes
> a big performance regression we had moving to kernels that include
> the XFS async discard support.

I'm not a fan of adding a mount option to work around bad,
unpredictable performance due to a mount option we recommend you
don't use because it results in bad, unpredictable performance.

Without any details of the discard pattern that results in problems
I don't think we should be changing anything - adding an opaque,
user-unfriendly mount option does nothing to address the underlying
problem - it's just a hack to work around the symptoms being seen...

More details of the regression and the root cause analysis is
needed, please.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
