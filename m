Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C67157F56
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 19:41:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 54525AC001
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 17:41:56 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id OVP8nbAik55zkryp (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Aug 2014 17:41:55 -0700 (PDT)
Date: Thu, 28 Aug 2014 17:41:54 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/7] xfs: xfs_file_collapse_range is delalloc challenged
Message-ID: <20140829004154.GF30463@infradead.org>
References: <1409226551-16570-1-git-send-email-david@fromorbit.com>
	<1409226551-16570-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1409226551-16570-7-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Thu, Aug 28, 2014 at 09:49:10PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If we have delalloc extents on a file before we run a collapse range
> opertaion, we sync the range that we are going to collapse to
> convert delalloc extents in that region to real extents to simplify
> the shift operation.
> 
> However, the shift operation then assumes that the extent list is
> not going to change as it iterates over the extent list moving
> things about. Unfortunately, this isn't true because we can't hold
> the ILOCK over all the operations. We can prevent new IO from
> modifying the extent list by holding the IOLOCK, but that doesn't
> prevent writeback from running....
> 
> And when writeback runs, it can convert delalloc extents is the
> range of the file prior to the region being collapsed, and this
> changes the indexes of all the extents in the file. That causes the
> collapse range operation to Go Bad.
> 
> The right fix is to rewrite the extent shift operation not to be
> dependent on the extent list not changing across the entire
> operation, but this is a fairly significant piece of work to do.
> Hence, as a short-term workaround for the problem, sync the entire
> file before starting a collapse operation to remove all delalloc
> ranges from the file and so avoid the problem of concurrent
> writeback changing the extent list.
> 
> Diagnosed-and-Reported-by: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
