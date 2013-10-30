Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0CDAA7F52
	for <xfs@oss.sgi.com>; Wed, 30 Oct 2013 16:40:23 -0500 (CDT)
Date: Wed, 30 Oct 2013 16:40:18 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 14/15] xfs: prevent stack overflows from page cache
	allocation
Message-ID: <20131030214018.GL1935@sgi.com>
References: <1383045118-31107-1-git-send-email-david@fromorbit.com>
	<1383045118-31107-15-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1383045118-31107-15-git-send-email-david@fromorbit.com>
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

On Tue, Oct 29, 2013 at 10:11:57PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Page cache allocation doesn't always go through ->begin_write and
> hence we don't always get the opportunity to set the allocation
> context to GFP_NOFS. Failing to do this means we open up the direct
> relcaim stack to recurse into the filesystem and consume a
> significant amount of stack.
> 
> On RHEL6.4 kernels we are seeing ra_submit() and
> generic_file_splice_read() from an nfsd context recursing into the
> filesystem via the inode cache shrinker and evicting inodes. This is
> causing truncation to be run (e.g EOF block freeing) and causing
> bmap btree block merges and free space btree block splits to occur.
> These btree manipulations are occurring with the call chain already
> 30 functions deep and hence there is not enough stack space to
> complete such operations.
> 
> To avoid these specific overruns, we need to prevent the page cache
> allocation from recursing via direct reclaim. We can do that because
> the allocation functions take the allocation context from that which
> is stored in the mapping for the inode. We don't set that right now,
> so the default is GFP_HIGHUSER_MOVABLE, which is effectively a
> GFP_KERNEL context. We need it to be the equivalent of GFP_NOFS, so
> when we initialise an inode, set the mapping gfp mask appropriately.
> 
> This makes the use of AOP_FLAG_NOFS redundant from other parts of
> the XFS IO path, so get rid of it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Applied this.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
