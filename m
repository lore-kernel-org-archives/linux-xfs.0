Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38025 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751129AbdICHYe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 03:24:34 -0400
Date: Sun, 3 Sep 2017 00:24:33 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] misc: fix more stupid compiler warnings
Message-ID: <20170903072432.GA32095@infradead.org>
References: <20170901222157.GL3775@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170901222157.GL3775@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

Can you splits this up a bit to be more self explanatory, e.g.
one patch per warning class or logical change?

>  	if (be32_to_cpu(free->hdr.nvalid) > maxent ||
> -				be32_to_cpu(free->hdr.nvalid) < 0 ||
>  				be32_to_cpu(free->hdr.nused) > maxent ||
> -				be32_to_cpu(free->hdr.nused) < 0 ||
>  				be32_to_cpu(free->hdr.nused) >
>  					be32_to_cpu(free->hdr.nvalid)) {

be32_to_cpu returns uint, so this makese sense.

> -	(void)getcwd(curdir,MAXPATHLEN);
> +	if (!getcwd(curdir, MAXPATHLEN)) {
> +		perror("getcwd");
> +		strcpy(curdir, ".");
> +	}

All this chdir magic will need a lot more explanation.  To me it
seems like most of this is a left over from IRIX days where we
could have device names relative to a volume.  The proper fix
probably is to just remove that whole thing - if we'd ever
need to bring it back we should use openat relative to a dirfd
instead.

> +#define xfs_inode_set_cowblocks_tag(ip)	do { } while (0)
> +#define xfs_inode_set_eofblocks_tag(ip)	do { } while (0)

This part looks fine.

>  #else
>  #define xfs_bmap_check_leaf_extents(cur, ip, whichfork)		do { } while (0)
> -#define	xfs_bmap_validate_ret(bno,len,flags,mval,onmap,nmap)
> +#define	xfs_bmap_validate_ret(bno,len,flags,mval,onmap,nmap)	do { } while (0)
>  #endif /* DEBUG */

This as well.

> diff --git a/repair/phase6.c b/repair/phase6.c
> index b051a44..f360aed 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -3092,11 +3092,11 @@ mark_standalone_inodes(xfs_mount_t *mp)
>  	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rsumino),
>  			XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rsumino));
>  
> +	ASSERT(irec != NULL);
> +
>  	offset = XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rsumino) -
>  			irec->ino_startnum;
>  
> -	ASSERT(irec != NULL);
> -

What's the point in even having this assert?   Either we turn this
into something like

	if (!irec)
		abort();

or just let the code dereference it.

> -		imap.br_state = (rm_rec->rm_flags & XFS_RMAP_UNWRITTEN ?
> +		imap.br_state = ((rm_rec->rm_flags & XFS_RMAP_UNWRITTEN) ?
>  				XFS_EXT_UNWRITTEN : XFS_EXT_NORM);

Looks fine.
