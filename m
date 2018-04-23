Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:54430 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752086AbeDWUZD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Apr 2018 16:25:03 -0400
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
Date: Mon, 23 Apr 2018 21:03:26 +0100
In-Reply-To: <CAHqTa-3KHrC67r9tZs5kFNF7bSh5Dt_AYHnAEhHziqvAijD_wA@mail.gmail.com>
        (Avery Pennarun's message of "Mon, 23 Apr 2018 14:13:04 -0400")
Message-ID: <87lgddbshd.fsf@esperi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avery Pennarun <apenwarr@gmail.com>
Cc: Rob Browning <rlb@defaultvalue.org>, Robert Evans <evansr@google.com>, bup-list <bup-list@googlegroups.com>, linux-xfs@vger.kernel.org

[Cc:ed in the xfs list to ask a question: see the last quoted section
 below]

On 23 Apr 2018, Avery Pennarun stated:

> On Mon, Apr 23, 2018 at 1:44 PM, Nix <nix@esperi.org.uk> wrote:
>> Hm. Checking the documentation it looks like the scheduler is smarter
>> than I thought: it does try to batch the requests and service as many as
>> possible in each sweep across the disk surface, but it is indeed only
>> tunable on a systemwide basis :(
>
> Yeah, my understanding was that only cfq actually cares about ionice.

Yes, though idle versus non-idle can be used by other components too: it
can tell bcache not to cache low-priority reads, for instance (pretty
crucial if you've just done an index deletion, or the next bup run would
destroy your entire bcache!)

> That's really a shame: bup does a great job (basically zero
> performance impact) when run at ionice 'idle" priority, especially
> since it uses fadvise() to tell the kernel when it's done with files,
> so it doesn't get other people's stuff evicted from page cache.

Yeah. Mind you, I don't actually notice its performance impact here,
with the deadline scheduler, but part of that is bcache and the rest is
128GiB RAM. We can't require users to have something like *that*. :P
(heck most of my systems are much smaller.)

> On the other hand, maybe what you actually want is just cfq with your
> high-priority tasks given a higher-than-average ionice priority.  I

The XFS FAQ claims that this is, ah, not good for xfs performance, but
this may be one of those XFS canards that is wildly out of date, like
almost all the online tuning hints telling you to do something on the
mkfs.xfs line, most of which actually make performance *worse*.

xfs folks, could you confirm that the deadline scheduler really is still
necessary for XFS atop md, and that CFS is still a distinctly bad idea?

I'm trying to evaluate possible bup improvements before they're made
(involving making *lots* of I/O requests in parallel, i.e. dozens, and
relying on the I/O scheduler to sort it out, even if the number of
requests is way above the number of rotating-rust spindles), and it has
been put forward that CFS will do the right thing here and deadline is
likely to be just terrible.
<http://xfs.org/index.php/XFS_FAQ#Q:_Which_I.2FO_scheduler_for_XFS.3F>
suggests otherwise (particularly for parallel workloads such as, uh,
this one), but even on xfs.org I am somewhat concerned about stale
recommendations causing trouble...
