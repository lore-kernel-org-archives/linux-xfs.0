Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 154137F51
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 08:08:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A6C18AC003
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 06:08:15 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id rDfwQMWtyuZAUCtc (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 21 Aug 2014 06:08:13 -0700 (PDT)
Date: Thu, 21 Aug 2014 06:08:12 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] xfs: mmap write/read leaves bad state on pages
Message-ID: <20140821130812.GC1567@infradead.org>
References: <1408597754-13526-1-git-send-email-david@fromorbit.com>
	<1408597754-13526-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1408597754-13526-2-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, clm@fb.com, xfs@oss.sgi.com

On Thu, Aug 21, 2014 at 03:09:09PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> generic/263 is failing fsx at this point with a page spanning
> EOF that cannot be invalidated. The operations are:
> 
> 1190 mapwrite   0x52c00 thru    0x5e569 (0xb96a bytes)
> 1191 mapread    0x5c000 thru    0x5d636 (0x1637 bytes)
> 1192 write      0x5b600 thru    0x771ff (0x1bc00 bytes)
> 
> where 1190 extents EOF from 0x54000 to 0x5e569. When the direct IO
> write attempts to invalidate the cached page over this range, it
> fails with -EBUSY and so we fire this assert:
> 
> XFS: Assertion failed: ret < 0 || ret == count, file: fs/xfs/xfs_file.c, line: 676
> 
> because the kernel is trying to fall back to buffered IO on the
> direct IO path (which XFS does not do).
> 
> The real question is this: Why can't that page be invalidated after
> it has been written to disk an cleaned?
> 
> Well, there's data on the first two buffers in the page (1k block
> size, 4k page), but the third buffer on the page (i.e. beyond EOF)
> is failing drop_buffers because it's bh->b_state == 0x3, which is
> BH_Uptodate | BH_Dirty.  IOWs, there's dirty buffers beyond EOF. Say
> what?
> 
> OK, set_buffer_dirty() is called on all buffers from
> __set_page_buffers_dirty(), regardless of whether the buffer is
> beyond EOF or not, which means that when we get to ->writepage,
> we have buffers marked dirty beyond EOF that we need to clean.
> So, we need to implement our own .set_page_dirty method that
> doesn't dirty buffers beyond EOF.

Shouldn't this be fixed in __set_page_buffers_dirty itself?  This
doesn't seem an XFS-specific issue.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
