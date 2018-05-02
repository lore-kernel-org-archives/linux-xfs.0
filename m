Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:39632 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750930AbeEBI5J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 May 2018 04:57:09 -0400
From: Nix <nix@esperi.org.uk>
Subject: Re: bupsplit.c copyright and patching
References: <CAHqTa-1ghU6+Y0Y2pBOjbS=7CWKMytPvj-c1Z0aE3=PqpPi1OA@mail.gmail.com>
        <87k1u0ca2d.fsf@trouble.defaultvalue.org>
        <CAHqTa-0B-iZfjhX4pHMnb0d-XRhY_wCywsjOOnOgSRF1iFKN4Q@mail.gmail.com>
        <871sfsefs7.fsf@esperi.org.uk>
        <CAHqTa-25QqzDb+u9_4zXuoMGU5uF9nv_pmioLE+xJ+0pHbiYUg@mail.gmail.com>
        <87k1szdni5.fsf@esperi.org.uk>
        <CAHqTa-28D05VafHNeS0f16qHQ9A6g=Vb8u=YEODquniwfEAygA@mail.gmail.com>
        <871sf5ddi7.fsf@esperi.org.uk>
        <CAHqTa-3KHrC67r9tZs5kFNF7bSh5Dt_AYHnAEhHziqvAijD_wA@mail.gmail.com>
        <87lgddbshd.fsf@esperi.org.uk>
        <20180424164740.2eftsje7su5usmqs@destitution>
Date: Wed, 02 May 2018 09:57:03 +0100
In-Reply-To: <20180424164740.2eftsje7su5usmqs@destitution> (Dave Chinner's
        message of "Wed, 25 Apr 2018 02:47:40 +1000")
Message-ID: <871seuxwo0.fsf@esperi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Avery Pennarun <apenwarr@gmail.com>, Rob Browning <rlb@defaultvalue.org>, Robert Evans <evansr@google.com>, bup-list <bup-list@googlegroups.com>, linux-xfs@vger.kernel.org

On 24 Apr 2018, Dave Chinner said:
> Yes, the problem still exists. CFQ just doesn't work well with
> workloads that issue concurrent, dependent IOs from multiple
> processes, nor does it work well with hardware raid arrays with
> non-volatile caches that have unpredictable IO performance. This
> sort of workload and hardware is common in the sorts of high
> performance applications we see run on XFS filesystems, and we avoid
> CFQ as much as possible....

Oh! I thought its problem was with concurrent *independent* I/Os. If
it's fine with those, and you're using md (not hardware RAID) it sounds
like the wost problems with CFQ may be avoided? (This is probably not
too surprising in hindsight, since those are the characteristics of
things like kernel compile runs, the one workload Linux will always work
well with!)
