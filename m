Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:43960 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754003AbeDTDAM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Apr 2018 23:00:12 -0400
Received: by mail-oi0-f68.google.com with SMTP id p62-v6so6763356oie.10
        for <linux-xfs@vger.kernel.org>; Thu, 19 Apr 2018 20:00:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180419104432.7lzk7nbjmwav6ojl@quack2.suse.cz>
References: <152246892890.36038.18436540150980653229.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152246901060.36038.4487158506830998280.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180404094656.dssixqvvdcp5jff2@quack2.suse.cz> <CAPcyv4joRA=BrurYZ1kzXpMG=jnXik9+LdLqH9961jM5VnmU7w@mail.gmail.com>
 <20180409164944.6u7i4wgbp6yihvin@quack2.suse.cz> <CAPcyv4gzJ4gcWgwOOmER1z7zsWR+X2zao-tMh8TjN9tx2kg_0g@mail.gmail.com>
 <CAPcyv4h3RPdohsPyiB=GxE8iQCjRRen=knDd=Em5BMy1MYpRvA@mail.gmail.com> <20180419104432.7lzk7nbjmwav6ojl@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 19 Apr 2018 20:00:09 -0700
Message-ID: <CAPcyv4ievTQtaMRBe8Pdz=f-rvpcv82tLDTFbJ6v5WSixU91pg@mail.gmail.com>
Subject: Re: [PATCH v8 15/18] mm, fs, dax: handle layout changes to pinned dax mappings
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Jeff Moyer <jmoyer@redhat.com>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <mawilcox@microsoft.com>, Alexander Viro <viro@zeniv.linux.org.uk>, "Darrick J. Wong" <darrick.wong@oracle.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh.triplett@intel.com>

On Thu, Apr 19, 2018 at 3:44 AM, Jan Kara <jack@suse.cz> wrote:
> On Fri 13-04-18 15:03:51, Dan Williams wrote:
>> On Mon, Apr 9, 2018 at 9:51 AM, Dan Williams <dan.j.williams@intel.com> wrote:
>> > On Mon, Apr 9, 2018 at 9:49 AM, Jan Kara <jack@suse.cz> wrote:
>> >> On Sat 07-04-18 12:38:24, Dan Williams wrote:
>> > [..]
>> >>> I wonder if this can be trivially solved by using srcu. I.e. we don't
>> >>> need to wait for a global quiescent state, just a
>> >>> get_user_pages_fast() quiescent state. ...or is that an abuse of the
>> >>> srcu api?
>> >>
>> >> Well, I'd rather use the percpu rwsemaphore (linux/percpu-rwsem.h) than
>> >> SRCU. It is a more-or-less standard locking mechanism rather than relying
>> >> on implementation properties of SRCU which is a data structure protection
>> >> method. And the overhead of percpu rwsemaphore for your use case should be
>> >> about the same as that of SRCU.
>> >
>> > I was just about to ask that. Yes, it seems they would share similar
>> > properties and it would be better to use the explicit implementation
>> > rather than a side effect of srcu.
>>
>> ...unfortunately:
>>
>>  BUG: sleeping function called from invalid context at
>> ./include/linux/percpu-rwsem.h:34
>>  [..]
>>  Call Trace:
>>   dump_stack+0x85/0xcb
>>   ___might_sleep+0x15b/0x240
>>   dax_layout_lock+0x18/0x80
>>   get_user_pages_fast+0xf8/0x140
>>
>> ...and thinking about it more srcu is a better fit. We don't need the
>> 100% exclusion provided by an rwsem we only need the guarantee that
>> all cpus that might have been running get_user_pages_fast() have
>> finished it at least once.
>>
>> In my tests synchronize_srcu is a bit slower than unpatched for the
>> trivial 100 truncate test, but certainly not the 200x latency you were
>> seeing with syncrhonize_rcu.
>>
>> Elapsed time:
>> 0.006149178 unpatched
>> 0.009426360 srcu
>
> Hum, right. Yesterday I was looking into KSM for a different reason and
> I've noticed it also does writeprotect pages and deals with races with GUP.
> And what KSM relies on is:
>
> write_protect_page()
>   ...
>   entry = ptep_clear_flush(vma, pvmw.address, pvmw.pte);
>   /*
>    * Check that no O_DIRECT or similar I/O is in progress on the
>    * page
>    */
>   if (page_mapcount(page) + 1 + swapped != page_count(page)) {
>     page used -> bail

Slick.

>   }
>
> And this really works because gup_pte_range() does:
>
>   page = pte_page(pte);
>   head = compound_head(page);
>
>   if (!page_cache_get_speculative(head))
>     goto pte_unmap;
>
>   if (unlikely(pte_val(pte) != pte_val(*ptep))) {
>     bail

Need to add a similar check to __gup_device_huge_pmd.

>   }
>
> So either write_protect_page() page sees the elevated reference or
> gup_pte_range() bails because it will see the pte changed.
>
> In the truncate path things are a bit different but in principle the same
> should work - once truncate blocks page faults and unmaps pages from page
> tables, we can be sure GUP will not grab the page anymore or we'll see
> elevated page count. So IMO there's no need for any additional locking
> against the GUP path (but a comment explaining this is highly desirable I
> guess).

Yes, those "pte_val(pte) != pte_val(*ptep)" checks should be
documented for the same reason we require comments on rmb/wmb pairs.
I'll take a look, thanks Jan.
