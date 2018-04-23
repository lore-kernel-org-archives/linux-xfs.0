Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:42548 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752086AbeDWUWZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Apr 2018 16:22:25 -0400
Received: by mail-lf0-f45.google.com with SMTP id u21-v6so15300634lfu.9
        for <linux-xfs@vger.kernel.org>; Mon, 23 Apr 2018 13:22:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87lgddbshd.fsf@esperi.org.uk>
References: <6179db6e-786d-40a2-936d-9fb4dfa2529f@googlegroups.com>
 <87k1uak2xb.fsf@trouble.defaultvalue.org> <CAHqTa-1eKSZq6Vph+th5YH-b43NAvF+BWCDoJqPJQGa3=Oze-w@mail.gmail.com>
 <874llde5yn.fsf@trouble.defaultvalue.org> <CAHqTa-1ghU6+Y0Y2pBOjbS=7CWKMytPvj-c1Z0aE3=PqpPi1OA@mail.gmail.com>
 <87k1u0ca2d.fsf@trouble.defaultvalue.org> <CAHqTa-0B-iZfjhX4pHMnb0d-XRhY_wCywsjOOnOgSRF1iFKN4Q@mail.gmail.com>
 <871sfsefs7.fsf@esperi.org.uk> <CAHqTa-25QqzDb+u9_4zXuoMGU5uF9nv_pmioLE+xJ+0pHbiYUg@mail.gmail.com>
 <87k1szdni5.fsf@esperi.org.uk> <CAHqTa-28D05VafHNeS0f16qHQ9A6g=Vb8u=YEODquniwfEAygA@mail.gmail.com>
 <871sf5ddi7.fsf@esperi.org.uk> <CAHqTa-3KHrC67r9tZs5kFNF7bSh5Dt_AYHnAEhHziqvAijD_wA@mail.gmail.com>
 <87lgddbshd.fsf@esperi.org.uk>
From: Avery Pennarun <apenwarr@gmail.com>
Date: Mon, 23 Apr 2018 16:22:03 -0400
Message-ID: <CAHqTa-1R6GDGvncE92PXmZC3ew5HZPZPqe-qWiBEREqjXygCZA@mail.gmail.com>
Subject: Re: bupsplit.c copyright and patching
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nix <nix@esperi.org.uk>
Cc: Rob Browning <rlb@defaultvalue.org>, Robert Evans <evansr@google.com>, bup-list <bup-list@googlegroups.com>, linux-xfs@vger.kernel.org

On Mon, Apr 23, 2018 at 4:03 PM, Nix <nix@esperi.org.uk> wrote:
> [Cc:ed in the xfs list to ask a question: see the last quoted section
>  below]
>
> On 23 Apr 2018, Avery Pennarun stated:
>
>> On Mon, Apr 23, 2018 at 1:44 PM, Nix <nix@esperi.org.uk> wrote:
>>> Hm. Checking the documentation it looks like the scheduler is smarter
>>> than I thought: it does try to batch the requests and service as many as
>>> possible in each sweep across the disk surface, but it is indeed only
>>> tunable on a systemwide basis :(
>>
>> Yeah, my understanding was that only cfq actually cares about ionice.
>
> Yes, though idle versus non-idle can be used by other components too: it
> can tell bcache not to cache low-priority reads, for instance (pretty
> crucial if you've just done an index deletion, or the next bup run would
> destroy your entire bcache!)

Hmm, I don't know about that.  It's hard to completely avoid caching
things at all, because the usual way of things is to load stuff into
the cache, then feed it back to userspace sometime shortly afterward.
Not doing so can make things much worse (eg. if someone tries to
stat() the same file twice in a row or something).  bup's way of doing
fadvise() when it's done with a file seems to work pretty well in my
experience, explicitly not churning the kernel cache even when doing a
full backup from scratch.

>> That's really a shame: bup does a great job (basically zero
>> performance impact) when run at ionice 'idle" priority, especially
>> since it uses fadvise() to tell the kernel when it's done with files,
>> so it doesn't get other people's stuff evicted from page cache.
>
> Yeah. Mind you, I don't actually notice its performance impact here,
> with the deadline scheduler, but part of that is bcache and the rest is
> 128GiB RAM. We can't require users to have something like *that*. :P
> (heck most of my systems are much smaller.)

Inherently, doing a system backup will need to cause a huge number of
disk seeks.  If you are checking a couple of realtime streams to make
sure they don't miss any deadlines, then you might not notice any
impact, but you ought to notice a reduction in total available
throughput while a big backup task is running (unless it's running
using idle priority).  This would presumably be even worse if the
backup task is running many file reads/stats in parallel.

Incidentally, I have a tool that we used on a DVR product to ensure we
could support multiple realtime streams under heavy load (ie.
something like 12 readers + 12 writers on a single 7200 RPM disk).
For that use case, it was easy to see that deadline was better for
keeping deadlines (imagine!) than cfq.  But cfq got more total
throughput.  This was on ext4 with preallocation though, not xfs.  The
tool I wrote is diskbench, available here:
https://gfiber.googlesource.com/vendor/google/platform/+/master/cmds/diskbench.c

> <http://xfs.org/index.php/XFS_FAQ#Q:_Which_I.2FO_scheduler_for_XFS.3F>
> suggests otherwise (particularly for parallel workloads such as, uh,
> this one), but even on xfs.org I am somewhat concerned about stale
> recommendations causing trouble...

That section seems... not so well supported.  If your deadlines are
incredibly short, there might be something to it, but the whole point
of cfq and this sort of time slicing is to minimize seeks.  It might
cause the disk to linger longer in a particular section without
seeking, but if (eg.) one of the tasks decides it wants to read from
all over the disk, it wouldn't make sense to just let that task do
whatever it wants, then switch to another task that does whatever it
wants, and so on.  That would seem to *maximize* seeks as well as
latency, which is just bad for everyone.  Empirically cfq is quite
good :)

Have fun,

Avery
