Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:42116 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752069AbeD3VmO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Apr 2018 17:42:14 -0400
Received: by mail-pg0-f51.google.com with SMTP id p9-v6so4245093pgc.9
        for <linux-xfs@vger.kernel.org>; Mon, 30 Apr 2018 14:42:14 -0700 (PDT)
Subject: Re: [PATCH 2/2] xfs: add 'discard_sync' mount flag
References: <1525102372-8430-1-git-send-email-axboe@kernel.dk>
 <1525102372-8430-3-git-send-email-axboe@kernel.dk>
 <20180430213120.GD13766@dastard>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <c6e9db38-51d3-ae13-58cb-2b815ddd5891@kernel.dk>
Date: Mon, 30 Apr 2018 15:42:11 -0600
MIME-Version: 1.0
In-Reply-To: <20180430213120.GD13766@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de

On 4/30/18 3:31 PM, Dave Chinner wrote:
> On Mon, Apr 30, 2018 at 09:32:52AM -0600, Jens Axboe wrote:
>> XFS recently added support for async discards. While this can be
>> a win for some workloads and devices, there are also cases where
>> async bursty discard will severly harm the latencies of reads
>> and writes.
> 
> FWIW, convention is it document the performance regression in the
> commit message, not leave the reader to guess at what it was....

Yeah I'll give you that, I can improve the commit message for sure.

> Did anyone analyse the pattern of discards being issued to work out
> what pattern was worse for async vs sync discard? is it lots of
> little discards, large extents being discarded, perhaps a problem
> with the request request queue starving other IOs because we queue
> so many async discards in such a short time (which is the difference
> in behaviour vs the old code), or something else?

What was observed was a big discard which would previously have
gone down as smaller discards now going down as either one or many
discards. Looking at the blktrace data, it's the difference between

discard 1 queue
discard 1 complete
discatd 2 queue
discard 2 complete
[...]
discard n queue
discard n complete

which is now

discard 1 queue
discard 2 queue
[...]
discard n queue
[...]
discard 1 complete
discard 2 complete
[...]
discard n complete

Note that we set a max discard size of 64MB for most devices,
since it's been shown to have less impact on latencies for
the IO that jobs actually care about.

>> Add a 'discard_sync' mount flag to revert to using sync discard,
>> issuing them one at the time and waiting for each one. This fixes
>> a big performance regression we had moving to kernels that include
>> the XFS async discard support.
> 
> I'm not a fan of adding a mount option to work around bad,
> unpredictable performance due to a mount option we recommend you
> don't use because it results in bad, unpredictable performance.

Oh I hear you, as I wrote in other replies, I don't generally
recommend discard except for cases where it's been proven to be
useful in terms of write amplification improvements. If we can
avoid using it, we do. It's a tradeoff, and for some situations,
the right decision is to use discards.

> Without any details of the discard pattern that results in problems
> I don't think we should be changing anything - adding an opaque,
> user-unfriendly mount option does nothing to address the underlying
> problem - it's just a hack to work around the symptoms being seen...
> 
> More details of the regression and the root cause analysis is
> needed, please.

It brings back the same behavior as we had before, which performs
better for us. It's preventing users of XFS+discard from upgrading,
which is sad.

-- 
Jens Axboe

