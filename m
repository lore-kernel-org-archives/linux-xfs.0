Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5J1ChZ7005019 for <xfs@oss.sgi.com>; Mon, 18 Jun 2012 20:12:43 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	gkrR9v4Wqjpxenw9 for <xfs@oss.sgi.com>;
	Mon, 18 Jun 2012 18:12:41 -0700 (PDT)
Date: Tue, 19 Jun 2012 11:11:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS status update for May 2012
Message-ID: <20120619011108.GF25389@dastard>
References: <20120618120853.GA15480@infradead.org>
	<AD997E9D-2C1E-4EE4-80D7-2A5C998B6E9E@dilger.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AD997E9D-2C1E-4EE4-80D7-2A5C998B6E9E@dilger.ca>
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
To: Andreas Dilger <adilger@dilger.ca>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org Devel" <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Jun 18, 2012 at 12:25:37PM -0600, Andreas Dilger wrote:
> On 2012-06-18, at 6:08 AM, Christoph Hellwig wrote:
> > May saw the release of Linux 3.4, including a decent sized XFS update.
> > Remarkable XFS features in Linux 3.4 include moving over all metadata
> > updates to use transactions, the addition of a work queue for the
> > low-level allocator code to avoid stack overflows due to extreme stack
> > use in the Linux VM/VFS call chain,
> 
> This is essentially a workaround for too-small stacks in the kernel,
> which we've had to do at times as well, by doing work in a separate
> thread (with a new stack) and waiting for the results?  This is a
> generic problem that any reasonably-complex filesystem will have when
> running under memory pressure on a complex storage stack (e.g. LVM +
> iSCSI), but causes unnecessary context switching.

I've seen no performance issues from the context switching.  The
overhead of them is so small to be unmeasurable most cases, because
a typical allocation already requires context switches for contended
locks and metadata IO....

> Any thoughts on a better way to handle this, or will there continue
> to be a 4kB stack limit

We were blowing 8k stacks on x86-64 with alarming ease. Even the
flusher threads were overflowing.

> and hack around this with repeated kmalloc
> on callpaths for any struct over a few tens of bytes, implementing
> memory pools all over the place, and "forking" over to other threads
> to continue the stack consumption for another 4kB to work around
> the small stack limit?

I mentioned that we needed to consider 16k stacks at last years
Kernel Summit and the response was along the lines of "you've got to
be kidding - fix your broken filesystem". That's the perception you
have to change, and i don't feel like having a 4k stacks battle
again...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
