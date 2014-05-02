Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C41537F6F
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 18:23:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B42268F804B
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 16:23:59 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	VpIwkMQuDTFDkgI2 for <xfs@oss.sgi.com>;
	Fri, 02 May 2014 16:23:54 -0700 (PDT)
Date: Sat, 3 May 2014 09:23:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfs: truncate_setsize should be outside transactions
Message-ID: <20140502232339.GD26353@dastard>
References: <1398983979-23696-1-git-send-email-david@fromorbit.com>
	<20140502045443.GA8867@infradead.org>
	<20140502050053.GA17578@infradead.org>
	<20140502064700.GB26353@dastard> <20140502070054.GC26353@dastard>
	<20140502100802.GB14028@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140502100802.GB14028@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, May 02, 2014 at 03:08:02AM -0700, Christoph Hellwig wrote:
> On Fri, May 02, 2014 at 05:00:54PM +1000, Dave Chinner wrote:
> > The reason truncate_setsize() was located where in this place was
> > that we can't change the file size until after we are in the
> > transaction context and the operation will either succeed or shut
> > down the filesystem on failure. Hence we have to split
> > truncate_setsize() back into a pagecache operation that occurs
> > before the transaction context, and a i_size_write() call that
> > happens within the transaction context.
> 
> Further updating myself earlier on the comment next to
> truncate_pagecache claims that the file size must have been updated
> before, but I can't see a reason for that.

Oh, I can, and that reminds me of why - racing with mmap page
faults, which aren't serialised against truncate except by an
indirect combination of the page locks and i_size updates. hence if
we remove the pages before updating the inode size, then a page
fault can re-instantiate a page after the truncation beyond the new
EOF when, in fact, it should SEGV.

So, no, we can't split truncate_setsize() like this.

As it is, we've already made a user visible data change in the truncate process
before we get to the transaction that can fail:
block_truncate_page() zeroes the tail of the page cache page. Hence
if the transaction reservation fails, we've already trashed the file
data - we may as well finish off the job and at least make it look
like the truncate succeeded from a user point of view. They then get
a ENOMEM error (only non-fatal error that can come from
xfs_trans_reserve) and try the truncate again....

So I now think the first version of the patch is better than this
one..

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
