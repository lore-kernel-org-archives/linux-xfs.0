Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4F6vQed164128 for <xfs@oss.sgi.com>; Tue, 15 May 2012 01:57:26 -0500
Date: Tue, 15 May 2012 02:57:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: hole-punch use truncate_pagecache_range
Message-ID: <20120515065718.GA7373@infradead.org>
References: <alpine.LSU.2.00.1205131347120.1547@eggly.anvils>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1205131347120.1547@eggly.anvils>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Hugh Dickins <hughd@google.com>
Cc: xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Ben Myers <bpm@sgi.com>, linux-fsdevel@vger.kernel.org

On Sun, May 13, 2012 at 01:50:06PM -0700, Hugh Dickins wrote:
> When truncating a file, we unmap pages from userspace first, as that's
> usually more efficient than relying, page by page, on the fallback in
> truncate_inode_page() - particularly if the file is mapped many times.
> 
> Do the same when punching a hole: 3.4 added truncate_pagecache_range()
> to do the unmap and trunc, so use it in xfs_flushinval_pages(), instead
> of calling truncate_inode_pages_range() directly.

This change looks fine.

> Should xfs_tosspages() be using it too?  I don't know: left unchanged.

I'll look at it.  I've been planning to simplify and/or kill the
xfs_fs_subr.c wrappers which tend to confuse the code for a while now,
and deciding what exactly to do should be a fallout from that.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
