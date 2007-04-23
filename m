Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Apr 2007 15:00:47 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3NM0hfB021201
	for <xfs@oss.sgi.com>; Mon, 23 Apr 2007 15:00:45 -0700
Date: Mon, 23 Apr 2007 23:00:43 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: review [1 of 3]: lazy superblock counters - fix interaction with per-cpu incore counters
Message-ID: <20070423220043.GB18325@infradead.org>
References: <20070419231859.GY48531920@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419231859.GY48531920@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Apr 20, 2007 at 09:18:59AM +1000, David Chinner wrote:
> 
> We need to reinitialise the per-cpu superblock counters after
> we have corrected them in the new recovery phase (summing hte AGF/AGI
> counters.

I think this should be merged into the first patch.  It mostly moves
code from that patch around, and the tree is in a buggy state without it.
