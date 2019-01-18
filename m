Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39380 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbfARFbB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Jan 2019 00:31:01 -0500
Subject: Re: [PATCH v2 2/5] xfs: update fork seq counter on data fork changes
References: <20190117192004.49346-1-bfoster@redhat.com>
 <20190117192004.49346-3-bfoster@redhat.com>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <ad09398f-c3cc-c2ba-1c71-2e063d069058@oracle.com>
Date: Thu, 17 Jan 2019 22:30:56 -0700
MIME-Version: 1.0
In-Reply-To: <20190117192004.49346-3-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org


On 1/17/19 12:20 PM, Brian Foster wrote:
> The sequence counter in the xfs_ifork structure is only updated on
> COW forks. This is because the counter is currently only used to
> optimize out repetitive COW fork checks at writeback time.
> 
> Tweak the extent code to update the seq counter regardless of the
> fork type in preparation for using this counter on data forks as
> well.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>   fs/xfs/libxfs/xfs_iext_tree.c  | 13 ++++++-------
>   fs/xfs/libxfs/xfs_inode_fork.h |  2 +-
>   2 files changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
> index 771dd072015d..bc690f2409fa 100644
> --- a/fs/xfs/libxfs/xfs_iext_tree.c
> +++ b/fs/xfs/libxfs/xfs_iext_tree.c
> @@ -614,16 +614,15 @@ xfs_iext_realloc_root(
>   }
>   
>   /*
> - * Increment the sequence counter if we are on a COW fork.  This allows
> - * the writeback code to skip looking for a COW extent if the COW fork
> - * hasn't changed.  We use WRITE_ONCE here to ensure the update to the
> - * sequence counter is seen before the modifications to the extent
> - * tree itself take effect.
> + * Increment the sequence counter on extent tree changes. If we are on a COW
> + * fork, this allows the writeback code to skip looking for a COW extent if the
> + * COW fork hasn't changed. We use WRITE_ONCE here to ensure the update to the
> + * sequence counter is seen before the modifications to the extent tree itself
> + * take effect.
>    */
>   static inline void xfs_iext_inc_seq(struct xfs_ifork *ifp, int state)
>   {
> -	if (state & BMAP_COWFORK)
> -		WRITE_ONCE(ifp->if_seq, READ_ONCE(ifp->if_seq) + 1);
> +	WRITE_ONCE(ifp->if_seq, READ_ONCE(ifp->if_seq) + 1);
>   }
>   
>   void
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 60361d2d74a1..00c62ce170d0 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -14,7 +14,7 @@ struct xfs_dinode;
>    */
>   struct xfs_ifork {
>   	int			if_bytes;	/* bytes in if_u1 */
> -	unsigned int		if_seq;		/* cow fork mod counter */
> +	unsigned int		if_seq;		/* fork mod counter */
>   	struct xfs_btree_block	*if_broot;	/* file's incore btree root */
>   	short			if_broot_bytes;	/* bytes allocated for root */
>   	unsigned char		if_flags;	/* per-fork flags */
> 

This one looks fine too:

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
