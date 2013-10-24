Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 85A2B7F37
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 03:48:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 584F58F8054
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 01:48:06 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id OhlBzeN8Nv7vFciX (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Oct 2013 01:48:04 -0700 (PDT)
Date: Thu, 24 Oct 2013 01:48:03 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: prevent stack overflows from page cache allocation
Message-ID: <20131024084803.GA28144@infradead.org>
References: <1382585110-1796-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1382585110-1796-1-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Oct 24, 2013 at 02:25:10PM +1100, Dave Chinner wrote:
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

It seems like we really should fix this in the VFS as it could affect
all non-trivial filesystems.

> To avoid these specific overruns, we need to prevent the page cache
> allocation from recursing via direct reclaim. We can do that because
> the allocation functions take the allocation context from that which
> is stored in the mapping for the inode. We don't set that right now,
> so the default is GFP_HIGHUSER_MOVABLE, which is effectively a
> GFP_KERNEL context. We need it to be the equivalent of GFP_NOFS, so
> when we initialise an inode, set the mapping gfp mask appropriately.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_iops.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index c4cd6d4..27e0e54 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1168,6 +1168,7 @@ xfs_setup_inode(
>  	struct xfs_inode	*ip)
>  {
>  	struct inode		*inode = &ip->i_vnode;
> +	gfp_t			gfp_mask;
>  
>  	inode->i_ino = ip->i_ino;
>  	inode->i_state = I_NEW;
> @@ -1230,6 +1231,14 @@ xfs_setup_inode(
>  	}
>  
>  	/*
> +	 * Ensure all page cache allocations are done from GFP_NOFS context to
> +	 * prevent direct reclaim recursion back into the filesystem and blowing
> +	 * stacks or deadlocking.
> +	 */
> +	gfp_mask = mapping_gfp_mask(inode->i_mapping);
> +	mapping_set_gfp_mask(inode->i_mapping, (gfp_mask & ~(__GFP_FS)));
> +
> +	/*
>  	 * If there is no attribute fork no ACL can exist on this inode,
>  	 * and it can't have any file capabilities attached to it either.
>  	 */
> -- 
> 1.8.4.rc3
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
