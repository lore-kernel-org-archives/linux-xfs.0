Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:34332 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751599AbeCOFqb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Mar 2018 01:46:31 -0400
Received: by mail-ot0-f194.google.com with SMTP id v4-v6so2556887otj.1
        for <linux-xfs@vger.kernel.org>; Wed, 14 Mar 2018 22:46:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180313102056.GJ4043@hirez.programming.kicks-ass.net>
References: <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152066493247.40260.10849841915366086021.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180311112725.GC4043@hirez.programming.kicks-ass.net> <CAPcyv4jr53dqVTzdEQ6Ln1Qg7nWVMQSVTkf6uc+Lg6Y-xruhuw@mail.gmail.com>
 <20180313102056.GJ4043@hirez.programming.kicks-ass.net>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 14 Mar 2018 22:46:30 -0700
Message-ID: <CAPcyv4jR4_juttgKJj_RQBfX8VfFpB5buh_-f1XJvOaVJ6aiog@mail.gmail.com>
Subject: Re: [RFC][PATCH] sched/wait_bit: Introduce wait_var_event()/wake_up_var()
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Ingo Molnar <mingo@redhat.com>, Christoph Hellwig <hch@lst.de>, david <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, Ross Zwisler <ross.zwisler@linux.intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Ralf Baechle <ralf@linux-mips.org>

On Tue, Mar 13, 2018 at 3:20 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sun, Mar 11, 2018 at 10:15:55AM -0700, Dan Williams wrote:
>> On Sun, Mar 11, 2018 at 4:27 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Fri, Mar 09, 2018 at 10:55:32PM -0800, Dan Williams wrote:
>> >> Add a generic facility for awaiting an atomic_t to reach a value of 1.
>> >>
>> >> Page reference counts typically need to reach 0 to be considered a
>> >> free / inactive page. However, ZONE_DEVICE pages allocated via
>> >> devm_memremap_pages() are never 'onlined', i.e. the put_page() typically
>> >> done at init time to assign pages to the page allocator is skipped.
>> >>
>> >> These pages will have their reference count elevated > 1 by
>> >> get_user_pages() when they are under DMA. In order to coordinate DMA to
>> >> these pages vs filesytem operations like hole-punch and truncate the
>> >> filesystem-dax implementation needs to capture the DMA-idle event i.e.
>> >> the 2 to 1 count transition).
>> >>
>> >> For now, this implementation does not have functional behavior change,
>> >> follow-on patches will add waiters for these page-idle events.
>> >
>> > Argh, no no no.. That whole wait_for_atomic_t thing is a giant
>> > trainwreck already and now you're making it worse still.
>> >
>> > Please have a look here:
>> >
>> >   https://lkml.kernel.org/r/20171101190644.chwhfpoz3ywxx2m7@hirez.programming.kicks-ass.net
>>
>> That thread seems to be worried about the object disappearing the
>> moment it's reference count reaches a target. That isn't the case with
>> the memmap / struct page objects for ZONE_DEVICE pages. I understand
>> wait_for_atomic_one() is broken in the general case, but as far as I
>> can see it works fine specifically for ZONE_DEVICE page busy tracking,
>> just not generic object lifetime.
>
> How's this, compile tested (x86_64-allmodconfig) only.
>
> This allows you to write:
>
>         wait_var_event(&your_atomic, atomic_read(&your_atomic) == 1);

This works for me, you can add

Tested-by: Dan Williams <dan.j.williams@intel.com>

...to the upstream version.

Can we add this new api in an immutable commit tip/sched/core tree, so
I can base my fix on it? The wait_for_atomic_t removal can then come
in follow-on patches.
