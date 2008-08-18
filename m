Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 17 Aug 2008 17:18:20 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7I0IIIj006138
	for <xfs@oss.sgi.com>; Sun, 17 Aug 2008 17:18:18 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 332CA19F41B7
	for <xfs@oss.sgi.com>; Sun, 17 Aug 2008 17:19:37 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id PgxMy6dpWYeaHkXZ for <xfs@oss.sgi.com>; Sun, 17 Aug 2008 17:19:37 -0700 (PDT)
Date: Mon, 18 Aug 2008 10:19:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/7] XFS: Never call mark_inode_dirty_sync() directly
Message-ID: <20080818001935.GF19760@disturbed>
References: <1218698083-11226-1-git-send-email-david@fromorbit.com> <1218698083-11226-5-git-send-email-david@fromorbit.com> <20080814194702.GB12237@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814194702.GB12237@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Aug 14, 2008 at 03:47:02PM -0400, Christoph Hellwig wrote:
> On Thu, Aug 14, 2008 at 05:14:40PM +1000, Dave Chinner wrote:
> > Once the Linux inode and the XFS inode are combined, we cannot rely
> > on just check if the linux inode exists as a method of determining
> > if it is valid or not. Hence we should always call
> > xfs_mark_inode_dirty_sync() instead as it does the correct checks to
> > determine if the liinux inode is in a valid state or not.
> 
> Makes sense, and another candidate to put at the beginning of the series
> or rather just put in now.

Ok. I'll reorder it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
