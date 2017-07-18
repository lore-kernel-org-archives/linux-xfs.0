Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48422 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751513AbdGRV0z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Jul 2017 17:26:55 -0400
Date: Tue, 18 Jul 2017 16:26:51 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH V2] xfs_db: properly set inode type
Message-ID: <20170718212651.GA24515@redhat.com>
References: <e6c83eea-af29-c01b-752e-e049e8fdc69f@redhat.com>
 <c17ce413-430e-acce-e63d-51fd1b684f62@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c17ce413-430e-acce-e63d-51fd1b684f62@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Jul 17, 2017 at 08:51:13PM -0500, Eric Sandeen wrote:
> When we set the type to "inode" the verifier may validate multiple
> inodes in the current fs block, so setting the buffer size to
> that of just one inode is not sufficient and it'll emit spurious
> verifier errors for all but the first, as we read off the end:
> 
> xfs_db> daddr 99
> xfs_db> type inode
> Metadata corruption detected at xfs_inode block 0x63/0x200
> Metadata corruption detected at xfs_inode block 0x63/0x200
> Metadata corruption detected at xfs_inode block 0x63/0x200
> Metadata corruption detected at xfs_inode block 0x63/0x200
> Metadata corruption detected at xfs_inode block 0x63/0x200
> Metadata corruption detected at xfs_inode block 0x63/0x200
> Metadata corruption detected at xfs_inode block 0x63/0x200
> 
> Use the special set_cur_inode() function for this purpose
> as is done in inode_f().
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

I ran the new, proposed test xfs/424 to test this patch and
it runs fine. Thanks!

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> 
> V2: Warn if the daddr given was reset to an inode-aligned
> address
> 
> diff --git a/db/io.c b/db/io.c
> index b046c8d..4153da0 100644
> --- a/db/io.c
> +++ b/db/io.c
> @@ -616,6 +616,22 @@ set_iocur_type(
>  {
>  	struct xfs_buf	*bp = iocur_top->bp;
>  
> +	/* Inodes are special; verifier checks all inodes in the buffer */
> +	if (type->typnm == TYP_INODE) {
> +		xfs_daddr_t	b = iocur_top->bb;
> +		xfs_ino_t	ino;
> +
> +		ino = XFS_AGINO_TO_INO(mp, xfs_daddr_to_agno(mp, b),
> +			((b << BBSHIFT) >> mp->m_sb.sb_inodelog) %
> +			(mp->m_sb.sb_agblocks << mp->m_sb.sb_inopblog));
> +		set_cur_inode(ino);
> +		if (iocur_top->bb != b)
> +			dbprintf(
> +_("cursor set to nearest inode %llu at daddr %lld\n"),
> +				 ino, iocur_top->bb);
> +		return;
> +	}
> +
>  	/* adjust buffer size for types with fields & hence fsize() */
>  	if (type->fields) {
>  		int bb_count;	/* type's size in basic blocks */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
