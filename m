Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 Nov 2007 13:42:14 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lALLg5lb016305
	for <xfs@oss.sgi.com>; Wed, 21 Nov 2007 13:42:09 -0800
Date: Thu, 22 Nov 2007 08:42:08 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH,RFC] Factor some btree code....
Message-ID: <20071121214208.GE114266761@sgi.com>
References: <20071106091836.GV995458@sgi.com> <20071121152006.GD8454@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071121152006.GD8454@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Nov 21, 2007 at 03:20:06PM +0000, Christoph Hellwig wrote:
> 
> I like this.  But I think a single set of xfs_btree_ops would be a lot
> more readable.  Also I'm not sure we actually need all these ops, e.g.
> instead of .buf_to_block we could always just call XFS_BUF_PTR directly.

I've already converted it to a single ops structure and cut out quite
a few ops that could be generic (sibling ops, checking ops, numrecs
ops, etc). I opted for moving them all over initially and now I'm culling
the common stuff. .buf_to_block is another one that can go, .buf_to_ptr
can be done generically, too....

I'm still flshing bugs out, so i haven't posted an update. When I get
it to pass xfsqa I'll send out an updated patchset.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
