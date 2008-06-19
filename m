Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jun 2008 01:34:49 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5J8YlgL008399
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 01:34:47 -0700
Date: Thu, 19 Jun 2008 04:35:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] Always reset btree cursor after an insert
Message-ID: <20080619083544.GA19606@infradead.org>
References: <4859F9EB.5050505@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4859F9EB.5050505@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Jun 19, 2008 at 04:17:15PM +1000, Lachlan McIlroy wrote:
> After a btree insert operation a cursor can be invalid due to block
> splits and a maybe a new root block.  We reset the cursor in
> xfs_bmbt_insert() in the cases where we think we need to but it
> isn't enough as we still see assertions.  Just do what we do elsewhere
> and reset the cursor unconditionally.  Version 2 adds
> XFS_WANT_CORRUPTED_GOTO checks throughout xfs_bmap.c and removes the
> fix to revalidate the original cursor in xfs_bmbt_insert().

Can you commit the XFS_WANT_CORRUPTED_GOTO checks as a separate patch
before the cursor reset?  ACK from me for those hunks.
