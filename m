Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 03 Aug 2007 10:24:07 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l73HO1bm027356
	for <xfs@oss.sgi.com>; Fri, 3 Aug 2007 10:24:04 -0700
Received: from schroedinger.engr.sgi.com (schroedinger.engr.sgi.com [150.166.1.51])
	by netops-testserver-3.corp.sgi.com (Postfix) with ESMTP id 7BBF1908A2
	for <xfs@oss.sgi.com>; Fri,  3 Aug 2007 10:08:01 -0700 (PDT)
Date: Fri, 3 Aug 2007 09:37:46 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
Subject: Re: kernel BUG at mm/slab.c:2980 (was Re: [<c019c63f>]
 xfs_bmap_search_multi_extents+0x6f/0xe0)
In-Reply-To: <BAY103-DAV11CCE8C757E221217A0176B2EA0@phx.gbl>
Message-ID: <Pine.LNX.4.64.0708030937280.17307@schroedinger.engr.sgi.com>
References: <BAY103-DAV11CCE8C757E221217A0176B2EA0@phx.gbl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Marco Berizzi <pupilla@hotmail.com>
Cc: linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

Could you try this with the SLUB allocator and then boot with 
"slub_debug"?
