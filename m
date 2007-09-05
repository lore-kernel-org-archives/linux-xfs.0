Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 05 Sep 2007 04:08:08 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l85B834p008955
	for <xfs@oss.sgi.com>; Wed, 5 Sep 2007 04:08:04 -0700
Received: from schroedinger.engr.sgi.com (schroedinger.engr.sgi.com [150.166.1.51])
	by netops-testserver-3.corp.sgi.com (Postfix) with ESMTP id D3F9F90893
	for <xfs@oss.sgi.com>; Wed,  5 Sep 2007 04:08:01 -0700 (PDT)
Date: Wed, 5 Sep 2007 03:32:30 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
Subject: Re: kernel BUG at mm/slab.c:2980 (was Re: [<c019c63f>]
 xfs_bmap_search_multi_extents+0x6f/0xe0)
In-Reply-To: <BAY103-DAV12D93B7C4F6214C867EE70B2CB0@phx.gbl>
Message-ID: <Pine.LNX.4.64.0709050331340.8127@schroedinger.engr.sgi.com>
References: <BAY103-DAV11CCE8C757E221217A0176B2EA0@phx.gbl>
 <Pine.LNX.4.64.0708030937280.17307@schroedinger.engr.sgi.com>
 <BAY103-DAV602D6B6D39BC875BBCB69B2CA0@phx.gbl>
 <Pine.LNX.4.64.0709040952570.5768@schroedinger.engr.sgi.com>
 <BAY103-DAV12D93B7C4F6214C867EE70B2CB0@phx.gbl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Marco Berizzi <pupilla@hotmail.com>
Cc: linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, mel@skynet.ie

On Wed, 5 Sep 2007, Marco Berizzi wrote:

> > tcp_collapse? This is due to a network configuration that required an
> > order 2 kmalloc block. Jumbo frames?
> 
> I don't use jumbo frames. Hardware is
> very old (celeron with 3com 3c905).

Something must be doing allocations that requires between 8k and 16k that
SLUB cannot satisfy from order 0 or order 1 allocations.
