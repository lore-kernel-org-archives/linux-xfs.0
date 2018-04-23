Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:54744 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932454AbeDWVx5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Apr 2018 17:53:57 -0400
From: Nix <nix@esperi.org.uk>
Subject: Re: bupsplit.c copyright and patching
References: <6179db6e-786d-40a2-936d-9fb4dfa2529f@googlegroups.com>
        <87k1uak2xb.fsf@trouble.defaultvalue.org>
        <CAHqTa-1eKSZq6Vph+th5YH-b43NAvF+BWCDoJqPJQGa3=Oze-w@mail.gmail.com>
        <874llde5yn.fsf@trouble.defaultvalue.org>
        <CAHqTa-1ghU6+Y0Y2pBOjbS=7CWKMytPvj-c1Z0aE3=PqpPi1OA@mail.gmail.com>
        <87k1u0ca2d.fsf@trouble.defaultvalue.org>
        <CAHqTa-0B-iZfjhX4pHMnb0d-XRhY_wCywsjOOnOgSRF1iFKN4Q@mail.gmail.com>
        <871sfsefs7.fsf@esperi.org.uk>
        <CAHqTa-25QqzDb+u9_4zXuoMGU5uF9nv_pmioLE+xJ+0pHbiYUg@mail.gmail.com>
        <87k1szdni5.fsf@esperi.org.uk>
        <CAHqTa-28D05VafHNeS0f16qHQ9A6g=Vb8u=YEODquniwfEAygA@mail.gmail.com>
        <871sf5ddi7.fsf@esperi.org.uk>
        <CAHqTa-3KHrC67r9tZs5kFNF7bSh5Dt_AYHnAEhHziqvAijD_wA@mail.gmail.com>
        <87lgddbshd.fsf@esperi.org.uk>
        <CAHqTa-1R6GDGvncE92PXmZC3ew5HZPZPqe-qWiBEREqjXygCZA@mail.gmail.com>
Date: Mon, 23 Apr 2018 22:53:51 +0100
In-Reply-To: <CAHqTa-1R6GDGvncE92PXmZC3ew5HZPZPqe-qWiBEREqjXygCZA@mail.gmail.com>
        (Avery Pennarun's message of "Mon, 23 Apr 2018 16:22:03 -0400")
Message-ID: <8736zlbndc.fsf@esperi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avery Pennarun <apenwarr@gmail.com>
Cc: Rob Browning <rlb@defaultvalue.org>, Robert Evans <evansr@google.com>, bup-list <bup-list@googlegroups.com>, linux-xfs@vger.kernel.org

On 23 Apr 2018, Avery Pennarun stated:
> On Mon, Apr 23, 2018 at 4:03 PM, Nix <nix@esperi.org.uk> wrote:
>> On 23 Apr 2018, Avery Pennarun stated:
>> Yes, though idle versus non-idle can be used by other components too: it
>> can tell bcache not to cache low-priority reads, for instance (pretty
>> crucial if you've just done an index deletion, or the next bup run would
>> destroy your entire bcache!)
>
> Hmm, I don't know about that.  It's hard to completely avoid caching
> things at all, because the usual way of things is to load stuff into
> the cache, then feed it back to userspace sometime shortly afterward.
> Not doing so can make things much worse (eg. if someone tries to
> stat() the same file twice in a row or something).  bup's way of doing
> fadvise() when it's done with a file seems to work pretty well in my
> experience, explicitly not churning the kernel cache even when doing a
> full backup from scratch.

Bear in mind that the 'cache' I mentioned above is a bcache cache, i.e.
*writing the data to SSD*. :) It'll still get read into the page cache!

>>> That's really a shame: bup does a great job (basically zero
>>> performance impact) when run at ionice 'idle" priority, especially
>>> since it uses fadvise() to tell the kernel when it's done with files,
>>> so it doesn't get other people's stuff evicted from page cache.
>>
>> Yeah. Mind you, I don't actually notice its performance impact here,
>> with the deadline scheduler, but part of that is bcache and the rest is
>> 128GiB RAM. We can't require users to have something like *that*. :P
>> (heck most of my systems are much smaller.)
>
> Inherently, doing a system backup will need to cause a huge number of
> disk seeks.

This is actually something where having a few hundred GiB of bcache
helps a great deal. A great deal of seeky metadata gets cached during
normal usage, and then bup will use it, even if it's not allowed to
populate it more.

>             If you are checking a couple of realtime streams to make
> sure they don't miss any deadlines, then you might not notice any
> impact, but you ought to notice a reduction in total available
> throughput while a big backup task is running (unless it's running
> using idle priority).

Of course it is. Why would you want to run a backup task at higher
priority than that? :)

> Incidentally, I have a tool that we used on a DVR product to ensure we
> could support multiple realtime streams under heavy load (ie.
> something like 12 readers + 12 writers on a single 7200 RPM disk).

This is also what xfs's realtime stuff was meant for, back in the day.

-- 
NULL && (void)
