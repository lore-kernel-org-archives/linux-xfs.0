Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E2AEC7F4E
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 05:37:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7BF21AC002
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 03:37:59 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	aR8AwMbbzp8VelAr for <xfs@oss.sgi.com>;
	Thu, 24 Oct 2013 03:37:57 -0700 (PDT)
Date: Thu, 24 Oct 2013 21:37:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: prevent stack overflows from page cache allocation
Message-ID: <20131024103751.GS2797@dastard>
References: <1382585110-1796-1-git-send-email-david@fromorbit.com>
	<20131024084803.GA28144@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131024084803.GA28144@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Oct 24, 2013 at 01:48:03AM -0700, Christoph Hellwig wrote:
> On Thu, Oct 24, 2013 at 02:25:10PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Page cache allocation doesn't always go through ->begin_write and
> > hence we don't always get the opportunity to set the allocation
> > context to GFP_NOFS. Failing to do this means we open up the direct
> > relcaim stack to recurse into the filesystem and consume a
> > significant amount of stack.
> > 
> > On RHEL6.4 kernels we are seeing ra_submit() and
> > generic_file_splice_read() from an nfsd context recursing into the
> > filesystem via the inode cache shrinker and evicting inodes. This is
> > causing truncation to be run (e.g EOF block freeing) and causing
> > bmap btree block merges and free space btree block splits to occur.
> > These btree manipulations are occurring with the call chain already
> > 30 functions deep and hence there is not enough stack space to
> > complete such operations.
> 
> It seems like we really should fix this in the VFS as it could affect
> all non-trivial filesystems.

Sure, if you want to. But doing that shouldn't prevent this fix from
being committed in the mean time, especially as other filesystems
already use this method for avoiding these problems.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
