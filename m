Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 05 Sep 2007 01:14:33 -0700 (PDT)
Received: from bay0-omc1-s17.bay0.hotmail.com (bay0-omc1-s17.bay0.hotmail.com [65.54.246.89])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l858EQ4p015973
	for <xfs@oss.sgi.com>; Wed, 5 Sep 2007 01:14:29 -0700
Message-ID: <BAY103-DAV12D93B7C4F6214C867EE70B2CB0@phx.gbl>
From: "Marco Berizzi" <pupilla@hotmail.com>
References: <BAY103-DAV11CCE8C757E221217A0176B2EA0@phx.gbl> <Pine.LNX.4.64.0708030937280.17307@schroedinger.engr.sgi.com> <BAY103-DAV602D6B6D39BC875BBCB69B2CA0@phx.gbl> <Pine.LNX.4.64.0709040952570.5768@schroedinger.engr.sgi.com>
Subject: Re: kernel BUG at mm/slab.c:2980 (was Re: [<c019c63f>] xfs_bmap_search_multi_extents+0x6f/0xe0)
Date: Wed, 5 Sep 2007 10:12:56 +0200
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, mel@skynet.ie, Marco Berizzi <pupilla@hotmail.com>

"Christoph Lameter" wrote:


> On Tue, 4 Sep 2007, Marco Berizzi wrote:
>
> > After a week uptime I got this error. I hope it
> > will be useful for you.
>
> Yes indeed but this is a different type of failure. Looks like a
higher
> allocation failure in the networking code. Someone created objects
that
> required an order 2 allocations that failed.
>
> > SLUB: Genslabs=22, HWalign=32, Order=0-1, MinObjects=4, CPUs=1,
Nodes=1
>
> Slub is restricted to order 0 and 1 allocs.
>
> >   PREFETCH window: e5c00000-e7cfffff
> > NET: Registered protocol family 2
> > IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
> > TCP established hash table entries: 8192 (order: 4, 65536 bytes)
> > TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
>
> Hmmmm.
>
> > eth2:  setting full-duplex.
> > swapper: page allocation failure. order:2, mode:0x4020
> >  [<c013b21d>] __alloc_pages+0x1ed/0x2e0
> >  [<c014ee3b>] allocate_slab+0x4b/0x90
> >  [<c014eef2>] new_slab+0x32/0x150
> >  [<c014f47b>] __slab_alloc+0xcb/0x120
> >  [<c014f429>] __slab_alloc+0x79/0x120
> >  [<c02b0183>] tcp_collapse+0x113/0x3b0
>
> tcp_collapse? This is due to a network configuration that required an
> order 2 kmalloc block. Jumbo frames?

I don't use jumbo frames. Hardware is
very old (celeron with 3com 3c905).
