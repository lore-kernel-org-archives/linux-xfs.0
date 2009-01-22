Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0M43fqS037703 for <xfs@oss.sgi.com>; Wed, 21 Jan 2009 22:03:42 -0600
In-Reply-To: <20090122012520.GS10158@disturbed>
References: <20090121042217.GL10158@disturbed>
	<20090121112648.GA9002@infradead.org>
	<20090121230221.GP10158@disturbed>
	<20090122012520.GS10158@disturbed>
Mime-Version: 1.0 (Apple Message framework v753.1)
Message-Id: <CAF7069E-851B-4840-B8E9-3E5701F3579F@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
Subject: Re: [PATCH] Long btree pointers are still 64 bit on disk
Date: Wed, 21 Jan 2009 22:02:26 -0600
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com


On Jan 21, 2009, at 7:25 PM, Dave Chinner wrote:

> On Wed, Jan 21, 2009 at 06:26:48AM -0500, Christoph Hellwig wrote:
>> Looks good and passes xfsqs for me.
>
> Thanks Christoph.
>
> SGI, patch with updated metadata is below.

I've added those tags myself as well, hope it's ok if
tags order is different. It's already in ready to push
state.

> Please include and push
> to Linus ASAP.

The account breakage on oss hold my push. Seems Russell
resolved it, will push right away.

Felix

>
> Cheers,
>
> Dave.
>
> -----
>
> [XFS] Long btree pointers are still 64 bit on disk
>
> On 32 bit machines with CONFIG_LBD=n, XFS reduces the
> in memory size of xfs_fsblock_t to 32 bits so that it
> will fit within 32 bit addressing. However, the disk format
> for long btree pointers are still 64 bits in size.
>
> The recent btree rewrite failed to take this into account
> when initialising new btree blocks, setting sibling pointers
> to NULL and checking if they are NULL. Hence checking whether
> a 64 bit NULL was the same as a 32 bit NULL was failingi
> resulting in NULL sibling pointers failing to be detected
> correctly. This showed up as WANT_CORRUPTED_GOTO shutdowns
> in xfs_btree_delrec.
>
> Fix this by making all the comparisons and setting of long
> pointer btree NULL blocks to the disk format, not the
> in memory format. i.e. use NULLDFSBNO.
>
> Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
> Reported-by: Jacek Luczak <difrost.kernel@gmail.com>
> Reported-by: Danny ter Haar <dth@dth.net>
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> Tested-by: Jacek Luczak <difrost.kernel@gmail.com>
> Reviewed-by: Christoph Hellwig <hch@infradead.org>
>
> ---
>  fs/xfs/xfs_btree.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
> index 2c3ef20..6bc2136 100644
> --- a/fs/xfs/xfs_btree.c
> +++ b/fs/xfs/xfs_btree.c
> @@ -843,7 +843,7 @@ xfs_btree_ptr_is_null(
>  	union xfs_btree_ptr	*ptr)
>  {
>  	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
> -		return be64_to_cpu(ptr->l) == NULLFSBLOCK;
> +		return be64_to_cpu(ptr->l) == NULLDFSBNO;
>  	else
>  		return be32_to_cpu(ptr->s) == NULLAGBLOCK;
>  }
> @@ -854,7 +854,7 @@ xfs_btree_set_ptr_null(
>  	union xfs_btree_ptr	*ptr)
>  {
>  	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
> -		ptr->l = cpu_to_be64(NULLFSBLOCK);
> +		ptr->l = cpu_to_be64(NULLDFSBNO);
>  	else
>  		ptr->s = cpu_to_be32(NULLAGBLOCK);
>  }
> @@ -918,8 +918,8 @@ xfs_btree_init_block(
>  	new->bb_numrecs = cpu_to_be16(numrecs);
>
>  	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
> -		new->bb_u.l.bb_leftsib = cpu_to_be64(NULLFSBLOCK);
> -		new->bb_u.l.bb_rightsib = cpu_to_be64(NULLFSBLOCK);
> +		new->bb_u.l.bb_leftsib = cpu_to_be64(NULLDFSBNO);
> +		new->bb_u.l.bb_rightsib = cpu_to_be64(NULLDFSBNO);
>  	} else {
>  		new->bb_u.s.bb_leftsib = cpu_to_be32(NULLAGBLOCK);
>  		new->bb_u.s.bb_rightsib = cpu_to_be32(NULLAGBLOCK);
> @@ -971,7 +971,7 @@ xfs_btree_ptr_to_daddr(
>  	union xfs_btree_ptr	*ptr)
>  {
>  	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
> -		ASSERT(be64_to_cpu(ptr->l) != NULLFSBLOCK);
> +		ASSERT(be64_to_cpu(ptr->l) != NULLDFSBNO);
>
>  		return XFS_FSB_TO_DADDR(cur->bc_mp, be64_to_cpu(ptr->l));
>  	} else {
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
