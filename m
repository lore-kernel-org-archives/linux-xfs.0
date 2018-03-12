Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:38247 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751300AbeCLTci (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Mar 2018 15:32:38 -0400
Received: by mail-ot0-f196.google.com with SMTP id 95so16490022ote.5
        for <linux-xfs@vger.kernel.org>; Mon, 12 Mar 2018 12:32:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jr53dqVTzdEQ6Ln1Qg7nWVMQSVTkf6uc+Lg6Y-xruhuw@mail.gmail.com>
References: <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152066493247.40260.10849841915366086021.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180311112725.GC4043@hirez.programming.kicks-ass.net> <CAPcyv4jr53dqVTzdEQ6Ln1Qg7nWVMQSVTkf6uc+Lg6Y-xruhuw@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 12 Mar 2018 12:32:37 -0700
Message-ID: <CAPcyv4gsLTViqtz=v6U8i5C25bAPL01bzH2=X595t0AR2-qL9g@mail.gmail.com>
Subject: Re: [PATCH v5 08/11] wait_bit: introduce {wait_on,wake_up}_atomic_one
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Ingo Molnar <mingo@redhat.com>, Christoph Hellwig <hch@lst.de>, david <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, Ross Zwisler <ross.zwisler@linux.intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Sun, Mar 11, 2018 at 10:15 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Sun, Mar 11, 2018 at 4:27 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Fri, Mar 09, 2018 at 10:55:32PM -0800, Dan Williams wrote:
>>> Add a generic facility for awaiting an atomic_t to reach a value of 1.
>>>
>>> Page reference counts typically need to reach 0 to be considered a
>>> free / inactive page. However, ZONE_DEVICE pages allocated via
>>> devm_memremap_pages() are never 'onlined', i.e. the put_page() typically
>>> done at init time to assign pages to the page allocator is skipped.
>>>
>>> These pages will have their reference count elevated > 1 by
>>> get_user_pages() when they are under DMA. In order to coordinate DMA to
>>> these pages vs filesytem operations like hole-punch and truncate the
>>> filesystem-dax implementation needs to capture the DMA-idle event i.e.
>>> the 2 to 1 count transition).
>>>
>>> For now, this implementation does not have functional behavior change,
>>> follow-on patches will add waiters for these page-idle events.
>>
>> Argh, no no no.. That whole wait_for_atomic_t thing is a giant
>> trainwreck already and now you're making it worse still.
>>
>> Please have a look here:
>>
>>   https://lkml.kernel.org/r/20171101190644.chwhfpoz3ywxx2m7@hirez.programming.kicks-ass.net
>
> That thread seems to be worried about the object disappearing the
> moment it's reference count reaches a target. That isn't the case with
> the memmap / struct page objects for ZONE_DEVICE pages. I understand
> wait_for_atomic_one() is broken in the general case, but as far as I
> can see it works fine specifically for ZONE_DEVICE page busy tracking,
> just not generic object lifetime.

Ok, that thread is also concerned with cleaning up the
wait_for_atomic_* pattern to also do something more idiomatic with
wait_event(). I agree that would be better, but I'm running short of
time to go refactor this aou for 4.17 inclusion, especially as I
expect another couple rounds of review on this more urgent data
corruption fix series that depends on this new api. I think the
addition of wait_for_atomic_one() makes it clear that we need a way to
pass a conditional expression rather than create a variant api for
each different condition. Can you help me out with an attempt of your
own, or at least point in a direction that you would accept for
solving the "Except the current wait_event() doesn't do the whole key
part that makes the hash-table 'work'."  problem that you highlighted?
