Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5NLUGPX048081 for <xfs@oss.sgi.com>; Tue, 23 Jun 2009 16:30:18 -0500
Date: Tue, 23 Jun 2009 17:30:43 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: implement ->dirty_inode callout
Message-ID: <20090623213043.GA13921@infradead.org>
References: <EBC1B5EB-A971-4769-8E2A-9C15BB069E11@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <EBC1B5EB-A971-4769-8E2A-9C15BB069E11@sgi.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Tue, Jun 23, 2009 at 10:38:43AM -0500, Felix Blyakher wrote:
> I'd like to (re)propose Dave's patch from the last October to
> address the problem of atime never making to the disk. Many
> people complained about it.
> I may have slightly adjusted the patch to fit the latest
> code, and verified it addresses the issue.
>
> The reference to the discussion on this matter on xfs mailing
> list is here:
>
> http://oss.sgi.com/archives/xfs/2008-10/msg02102.html


Can you run some benchmarks to see what impact it has with the
new relatime default?

The only places where we actual look at i_update_core are fsync and
the decision wether to flush out the inode fully in reclaim and
I we should sync out the inode there.

The VFS ends up calling into ->dirty_inode from the following places:

 - set_page_dirty
 - mark_buffer_dirty
 - touch_atime
 - file_update_time
 - generic_file_direct_write

And it doesn't distinguish between setting I_DIRTY_SYNC and
I_DIRTY_DATASYNC which means we'll also get it for the first two
events which only affect the data and not the inode core.

I'd be much more comfortable if we'd pass down those flags to
->dirty_inode and optimize based on that.


On the bright side this patch will also allow us to hack around the VFS
layering violation which currently causes missed c/mtime updates on
mmaped writes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
