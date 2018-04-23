Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:44441 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932416AbeDWWGZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Apr 2018 18:06:25 -0400
Received: by mail-lf0-f53.google.com with SMTP id g203-v6so17239371lfg.11
        for <linux-xfs@vger.kernel.org>; Mon, 23 Apr 2018 15:06:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8736zlbndc.fsf@esperi.org.uk>
References: <6179db6e-786d-40a2-936d-9fb4dfa2529f@googlegroups.com>
 <87k1uak2xb.fsf@trouble.defaultvalue.org> <CAHqTa-1eKSZq6Vph+th5YH-b43NAvF+BWCDoJqPJQGa3=Oze-w@mail.gmail.com>
 <874llde5yn.fsf@trouble.defaultvalue.org> <CAHqTa-1ghU6+Y0Y2pBOjbS=7CWKMytPvj-c1Z0aE3=PqpPi1OA@mail.gmail.com>
 <87k1u0ca2d.fsf@trouble.defaultvalue.org> <CAHqTa-0B-iZfjhX4pHMnb0d-XRhY_wCywsjOOnOgSRF1iFKN4Q@mail.gmail.com>
 <871sfsefs7.fsf@esperi.org.uk> <CAHqTa-25QqzDb+u9_4zXuoMGU5uF9nv_pmioLE+xJ+0pHbiYUg@mail.gmail.com>
 <87k1szdni5.fsf@esperi.org.uk> <CAHqTa-28D05VafHNeS0f16qHQ9A6g=Vb8u=YEODquniwfEAygA@mail.gmail.com>
 <871sf5ddi7.fsf@esperi.org.uk> <CAHqTa-3KHrC67r9tZs5kFNF7bSh5Dt_AYHnAEhHziqvAijD_wA@mail.gmail.com>
 <87lgddbshd.fsf@esperi.org.uk> <CAHqTa-1R6GDGvncE92PXmZC3ew5HZPZPqe-qWiBEREqjXygCZA@mail.gmail.com>
 <8736zlbndc.fsf@esperi.org.uk>
From: Avery Pennarun <apenwarr@gmail.com>
Date: Mon, 23 Apr 2018 18:06:03 -0400
Message-ID: <CAHqTa-1zY9jpuBNjyxWzH+Nk3xH5K+gEz9EnODEhWPPdY_kp-Q@mail.gmail.com>
Subject: Re: bupsplit.c copyright and patching
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nix <nix@esperi.org.uk>
Cc: Rob Browning <rlb@defaultvalue.org>, Robert Evans <evansr@google.com>, bup-list <bup-list@googlegroups.com>, linux-xfs@vger.kernel.org

On Mon, Apr 23, 2018 at 5:53 PM, Nix <nix@esperi.org.uk> wrote:
> On 23 Apr 2018, Avery Pennarun stated:
>>             If you are checking a couple of realtime streams to make
>> sure they don't miss any deadlines, then you might not notice any
>> impact, but you ought to notice a reduction in total available
>> throughput while a big backup task is running (unless it's running
>> using idle priority).
>
> Of course it is. Why would you want to run a backup task at higher
> priority than that? :)

Well, assuming your block scheduler supports it :)  Anyway, the idea
is that this is relatively easy to benchmark empirically, as long as
you know what to look for.

>> Incidentally, I have a tool that we used on a DVR product to ensure we
>> could support multiple realtime streams under heavy load (ie.
>> something like 12 readers + 12 writers on a single 7200 RPM disk).
>
> This is also what xfs's realtime stuff was meant for, back in the day.

Oops, I wasn't clear.  diskbench is a tool for checking whether your
cpu + disk + filesystem + scheduler can handle the load.  It doesn't
actually do the work.  That way you can do things like compare ext4,
ext4 + large prealloc, xfs, different disk schedulers, etc.  For our
dvr it was clear that the deadline scheduler did better, but only
because we had virtually no non-dvr disk accesses.  It would have been
really nice to be able to deprioritize all the non-realtime disk
accesses.
