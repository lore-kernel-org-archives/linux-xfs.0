Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 07 Mar 2007 09:19:14 -0800 (PST)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l27HJ46p023039
	for <xfs@oss.sgi.com>; Wed, 7 Mar 2007 09:19:06 -0800
Date: Wed, 7 Mar 2007 18:15:47 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] xfs: stop using kmalloc in xfs_buf_get_noaddr
Message-ID: <20070307171547.GA22641@lst.de>
References: <20070307101324.GC30587@lst.de> <45EEF0B5.40905@agami.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EEF0B5.40905@agami.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Nishimoto <miken@agami.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com, ecashin@coraid.com, akpm@osdl.org, linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 09:04:53AM -0800, Michael Nishimoto wrote:
> Incore log buffers are not always a power of two of the page size.
> In particular, when xfs is running over software raid devices, the
> log buffers are allocated to match the size of a stripe.
> 
> However, they are always a multiple of PAGE_SIZE, so we are still safe.

It's not actually about beeing safe - any allocation is still safe
with this patch.  The issue is just that we waste memory because
we round up allocations to the next page size.

The power of two bit is actually wrong in this mail, it was about
another optimization I have that needs some more testing first.
