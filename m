Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45049 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751693AbdF1Am6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jun 2017 20:42:58 -0400
Date: Tue, 27 Jun 2017 17:42:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_db: properly set inode type
Message-ID: <20170628004252.GB4492@birch.djwong.org>
References: <e6c83eea-af29-c01b-752e-e049e8fdc69f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6c83eea-af29-c01b-752e-e049e8fdc69f@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Jun 27, 2017 at 07:16:39PM -0500, Eric Sandeen wrote:
> When we set the type to "inode" the verifier validates multiple
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

Do you need a similar thing for dquots?  I sort of worry that we're
going down the rabbit hole of special casing all over xfs_db, but...
I'll defer to you. :)

> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/db/io.c b/db/io.c
> index b97b710..655a978 100644
> --- a/db/io.c
> +++ b/db/io.c
> @@ -618,6 +618,18 @@ set_iocur_type(
>  	struct xfs_buf	*bp = iocur_top->bp;
>  	int bb_count;
>  
> +	/* Inodes are special; verifier checks all inodes in the buffer */
> +	if (t->typnm == TYP_INODE) {
> +		xfs_daddr_t	b = iocur_top->bb;
> +		xfs_ino_t	ino;
> +
> +		ino = XFS_AGINO_TO_INO(mp, xfs_daddr_to_agno(mp, b),
> +			((b << BBSHIFT) >> mp->m_sb.sb_inodelog) %
> +			(mp->m_sb.sb_agblocks << mp->m_sb.sb_inopblog));

XFS_OFFBNO_TO_AGINO(mp, xfs_daddr_to_agbno(mp, b), 0) instead of that
long third argument?

--D

> +		set_cur_inode(ino);
> +		return;
> +	}
> +
>  	/* adjust cursor for types that contain fields */
>  	if (t->fields) {
>  		bb_count = BTOBB(byteize(fsize(t->fields, iocur_top->data, 0, 0)));
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
