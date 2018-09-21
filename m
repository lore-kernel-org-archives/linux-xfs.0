Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it1-f182.google.com ([209.85.166.182]:50551 "EHLO
        mail-it1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390111AbeIUUtQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Sep 2018 16:49:16 -0400
Received: by mail-it1-f182.google.com with SMTP id j81-v6so2279778ite.0
        for <linux-xfs@vger.kernel.org>; Fri, 21 Sep 2018 08:00:00 -0700 (PDT)
Subject: Re: block: DMA alignment of IO buffer allocated from slab
References: <CACVXFVOBq3L_EjSTCoiqUL1PH=HMR5EuNNQV0hNndFpGxmUK6g@mail.gmail.com>
 <20180921015608.GA31060@dastard> <20180921070805.GC14529@lst.de>
 <20180921072511.GA8188@ming.t460p>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <65999732-fc76-bb86-65ed-01aace49b9c7@kernel.dk>
Date: Fri, 21 Sep 2018 08:59:57 -0600
MIME-Version: 1.0
In-Reply-To: <20180921072511.GA8188@ming.t460p>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>, Ming Lei <tom.leiming@gmail.com>, linux-block <linux-block@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On 9/21/18 1:25 AM, Ming Lei wrote:
> On Fri, Sep 21, 2018 at 09:08:05AM +0200, Christoph Hellwig wrote:
>> On Fri, Sep 21, 2018 at 11:56:08AM +1000, Dave Chinner wrote:
>>>> 3) If slab can't guarantee to return 512-aligned buffer, how to fix
>>>> this data corruption issue?
>>>
>>> I think that the block layer needs to check the alignment of memory
>>> buffers passed to it and take appropriate action rather than
>>> corrupting random memory and returning a sucess status to the bad
>>> bio.
>>
>> Or just reject the I/O.  But yes, we already have the
>> queue_dma_alignment helper in the block layer, we just don't do it
>> in the fast path.  I think generic_make_request_checks needs to
>> check it, and print an error and return a warning if the alignment
>> requirement isn't met.
> 
> That can be done in generic_make_request_checks(), but some cost may be
> introduced, because each bvec needs to be checked in the fast path.

I think this is all crazy talk. We've never done this, we've always
assumed that an address of length N, will be N aligned as well. If
a driver sets queue dma alignment > than its sector size, then we're
in real trouble and would need to bounce IOs. That's silly enough
that it doesn't warrant being done in the core code imho, if you're
hw is that crappy, then do it in your queue_rq(). Could be done with
a core helper for sure, but I'm really not that interested in
having a full bvec loop for each bio just to check something that
(to my knowledge) hasn't been an issue in decades.

-- 
Jens Axboe
