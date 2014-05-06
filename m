Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 28D0D7FBD
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 02:52:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E658E304032
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 00:52:09 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id VwemKzVDynHEqByS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 00:52:07 -0700 (PDT)
Date: Tue, 6 May 2014 00:52:06 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V3] xfs: truncate_setsize should be outside transactions
Message-ID: <20140506075206.GD21910@infradead.org>
References: <1398983979-23696-1-git-send-email-david@fromorbit.com>
	<20140502045443.GA8867@infradead.org>
	<20140502050053.GA17578@infradead.org>
	<20140502064700.GB26353@dastard> <20140502070054.GC26353@dastard>
	<20140502100802.GB14028@infradead.org>
	<20140502232339.GD26353@dastard>
	<20140503151601.GB28608@infradead.org>
	<20140504000618.GK26353@dastard> <20140505051941.GU26353@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140505051941.GU26353@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, May 05, 2014 at 03:19:42PM +1000, Dave Chinner wrote:
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> truncate_setsize() removes pages from the page cache, and hence
> requires page locks to be held. It is not valid to lock a page cache
> page inside a transaction context as we can hold page locks when we
> we reserve space for a transaction. If we do, then we expose an ABBA
> deadlock between log space reservation and page locks.
> 
> That is, both the write path and writeback lock a page, then start a
> transaction for block allocation, which means they can block waiting
> for a log reservation with the page lock held. If we hold a log
> reservation and then do something that locks a page (e.g.
> truncate_setsize in xfs_setattr_size) then that page lock can block
> on the page locked and waiting for a log reservation. If the
> transaction that is waiting for the page lock is the only active
> transaction in the system that can free log space via a commit,
> then writeback will never make progress and so log space will never
> free up.
> 
> This issue with xfs_setattr_size() was introduced back in 2010 by
> commit fa9b227 ("xfs: new truncate sequence") which moved the page
> cache truncate from outside the transaction context (what was
> xfs_itruncate_data()) to inside the transaction context as a call to
> truncate_setsize().
> 
> The reason truncate_setsize() was located where in this place was
> that we can't shouldn't change the file size until after we are in
> the transaction context and the operation will either succeed or
> shut down the filesystem on failure. However, block_truncate_page()
> already modifies the file contents before we enter the transaction
> context, so we can't really fulfill this guarantee in any way. Hence
> we may as well ensure that on success or failure, the in-memory
> inode and data is truncated away and that the application cleans up
> the mess appropriately.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
