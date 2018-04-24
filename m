Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:31279 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751323AbeDXQrd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Apr 2018 12:47:33 -0400
Date: Wed, 25 Apr 2018 02:47:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: bupsplit.c copyright and patching
Message-ID: <20180424164740.2eftsje7su5usmqs@destitution>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lgddbshd.fsf@esperi.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nix <nix@esperi.org.uk>
Cc: Avery Pennarun <apenwarr@gmail.com>, Rob Browning <rlb@defaultvalue.org>, Robert Evans <evansr@google.com>, bup-list <bup-list@googlegroups.com>, linux-xfs@vger.kernel.org

On Mon, Apr 23, 2018 at 09:03:26PM +0100, Nix wrote:
> The XFS FAQ claims that this is, ah, not good for xfs performance, but
> this may be one of those XFS canards that is wildly out of date, like
> almost all the online tuning hints telling you to do something on the
> mkfs.xfs line, most of which actually make performance *worse*.
> 
> xfs folks, could you confirm that the deadline scheduler really is still
> necessary for XFS atop md, and that CFS is still a distinctly bad idea?

Yes, the problem still exists. CFQ just doesn't work well with
workloads that issue concurrent, dependent IOs from multiple
processes, nor does it work well with hardware raid arrays with
non-volatile caches that have unpredictable IO performance. This
sort of workload and hardware is common in the sorts of high
performance applications we see run on XFS filesystems, and we avoid
CFQ as much as possible....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
