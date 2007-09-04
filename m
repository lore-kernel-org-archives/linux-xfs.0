Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 04 Sep 2007 10:23:08 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l84HN34p009016
	for <xfs@oss.sgi.com>; Tue, 4 Sep 2007 10:23:03 -0700
Received: from schroedinger.engr.sgi.com (schroedinger.engr.sgi.com [150.166.1.51])
	by netops-testserver-3.corp.sgi.com (Postfix) with ESMTP id 8D5D59088B
	for <xfs@oss.sgi.com>; Tue,  4 Sep 2007 10:23:01 -0700 (PDT)
Date: Tue, 4 Sep 2007 09:58:34 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
Subject: Re: kernel BUG at mm/slab.c:2980 (was Re: [<c019c63f>]
 xfs_bmap_search_multi_extents+0x6f/0xe0)
In-Reply-To: <BAY103-DAV602D6B6D39BC875BBCB69B2CA0@phx.gbl>
Message-ID: <Pine.LNX.4.64.0709040952570.5768@schroedinger.engr.sgi.com>
References: <BAY103-DAV11CCE8C757E221217A0176B2EA0@phx.gbl>
 <Pine.LNX.4.64.0708030937280.17307@schroedinger.engr.sgi.com>
 <BAY103-DAV602D6B6D39BC875BBCB69B2CA0@phx.gbl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Marco Berizzi <pupilla@hotmail.com>
Cc: linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, mel@skynet.ie

On Tue, 4 Sep 2007, Marco Berizzi wrote:

> After a week uptime I got this error. I hope it
> will be useful for you.

Yes indeed but this is a different type of failure. Looks like a higher 
allocation failure in the networking code. Someone created objects that
required an order 2 allocations that failed.

> SLUB: Genslabs=22, HWalign=32, Order=0-1, MinObjects=4, CPUs=1, Nodes=1

Slub is restricted to order 0 and 1 allocs.

>   PREFETCH window: e5c00000-e7cfffff
> NET: Registered protocol family 2
> IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
> TCP established hash table entries: 8192 (order: 4, 65536 bytes)
> TCP bind hash table entries: 8192 (order: 3, 32768 bytes)

Hmmmm.

> eth2:  setting full-duplex.
> swapper: page allocation failure. order:2, mode:0x4020
>  [<c013b21d>] __alloc_pages+0x1ed/0x2e0
>  [<c014ee3b>] allocate_slab+0x4b/0x90
>  [<c014eef2>] new_slab+0x32/0x150
>  [<c014f47b>] __slab_alloc+0xcb/0x120
>  [<c014f429>] __slab_alloc+0x79/0x120
>  [<c02b0183>] tcp_collapse+0x113/0x3b0

tcp_collapse? This is due to a network configuration that required an
order 2 kmalloc block. Jumbo frames?
